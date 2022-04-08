Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7B14FA041
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 01:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240082AbiDHXvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 19:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbiDHXvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 19:51:21 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E509C3A1BE;
        Fri,  8 Apr 2022 16:49:15 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id m30so15070238wrb.1;
        Fri, 08 Apr 2022 16:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=jJJz58zv7KMZ+uRF9TJ9vVznBCdQcIV2nZTcm+DabQ4=;
        b=LeZBXq596L+RUC07MpUfK8sijkiOV/vjQN9FZpAqEwrZKQgAaBP8Xi+J4cOun+Ubzh
         VMuGOVeglyE1HfmvNlx3z9ylLBBnAv6sGLSBrNQVXA5gZzKeWM97/qpJrqGSIe/u3m/D
         /2E0GQ0SqViJw7LkoqXSEoCVFVTv4cG+J/1BWapGfMJjKj6WMbS+2IqQQSbUFYrCuxns
         Y1nBae1kNQncq/nTxRWsXNSfCm/BAe6MoAd/kWJ6NyopBkFDqwglTv8hHvT01tNGJh0S
         ku2qo8WIkBTQkoRh/EOdGMeU5dHrSa8P0pXDFG3zOfqFFuqYerPdMs3rng/UgFf4sEyP
         O2Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=jJJz58zv7KMZ+uRF9TJ9vVznBCdQcIV2nZTcm+DabQ4=;
        b=AVNgeuppLA63FSHwnF98mWC22klEbcdqbG13uw/1qPidk79CkDUAlqipknJAtpBJm2
         bF5X7k8l4R5AYqUVvS2S07FDKo+/XtY26E1RHjQ5QArtJLObTX/P5zbPAT+SPScvhKJi
         amHOcKqii1MeeFnYUxKunPUmziuRoDh2VtCJAsnnyhy2d+KBhBsKpIc2Ul8TTrN49qVH
         /QQ+209IQ5LSO11rLF6Dt2RsDFwn/BS6GSCr8PLymHa8dm9bJ6C1GXmSdeaqNX0jOvGv
         ezjOLnGEQ6WXIQCTXgzootfX7WnL6j1Gr7+ZdGkVlXw5kH45cHgmNz4Ys43/KI2jcDnK
         mBJw==
X-Gm-Message-State: AOAM530C99Y/P3rOFGFdEef3hmD2ScoD3qkpJHTqqjigjffWxpfsIOie
        +SqXImKxsXO97N+tFg60Ob4=
X-Google-Smtp-Source: ABdhPJziLwcsZqKYo3LDpwK2CM3T5m9xeYqROL4FNm0o8b9RWL3l+AB20WPLz1nFs+aacFs/QPi/nA==
X-Received: by 2002:a05:6000:18ae:b0:204:62a:20f4 with SMTP id b14-20020a05600018ae00b00204062a20f4mr17229958wri.640.1649461754381;
        Fri, 08 Apr 2022 16:49:14 -0700 (PDT)
Received: from smtpclient.apple ([185.238.38.242])
        by smtp.gmail.com with ESMTPSA id l3-20020a05600002a300b00207902922cesm3588316wry.15.2022.04.08.16.49.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Apr 2022 16:49:13 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH net-next 02/15] net: dsa: sja1105: Remove usage of
 iterator for list_add() after loop
From:   Jakob Koschel <jakobkoschel@gmail.com>
In-Reply-To: <cd02715e-890d-bf67-697a-8f9b06160536@csgroup.eu>
Date:   Sat, 9 Apr 2022 01:49:10 +0200
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        Eric Dumazet <edumazet@google.com>,
        Paul Mackerras <paulus@samba.org>,
        Ariel Elior <aelior@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Jiri Pirko <jiri@resnulli.us>, Arnd Bergmann <arnd@arndb.de>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>, Di Zhu <zhudi21@huawei.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Colin Ian King <colin.king@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Michael Walle <michael@walle.cc>, Xu Wang <vulab@iscas.ac.cn>,
        Vladimir Oltean <olteanv@gmail.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Mike Rapoport <rppt@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5F571243-683A-42F0-8E9B-4A8C9853A9D6@gmail.com>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
 <20220407102900.3086255-3-jakobkoschel@gmail.com>
 <cd02715e-890d-bf67-697a-8f9b06160536@csgroup.eu>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Christophe,

> On 8. Apr 2022, at 09:47, Christophe Leroy =
<christophe.leroy@csgroup.eu> wrote:
>=20
>=20
>=20
> Le 07/04/2022 =C3=A0 12:28, Jakob Koschel a =C3=A9crit :
>> In preparation to limit the scope of a list iterator to the list
>> traversal loop, use a dedicated pointer to point to the found element =
[1].
>>=20
>> Before, the code implicitly used the head when no element was found
>> when using &pos->list. Since the new variable is only set if an
>> element was found, the list_add() is performed within the loop
>> and only done after the loop if it is done on the list head directly.
>>=20
>> Link: =
https://lore.kernel.org/all/CAHk-=3DwgRr_D8CB-D9Kg-c=3DEHreAsk5SqXPwr9Y7k9=
sA6cWXJ6w@mail.gmail.com/ [1]
>> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
>> ---
>> drivers/net/dsa/sja1105/sja1105_vl.c | 14 +++++++++-----
>> 1 file changed, 9 insertions(+), 5 deletions(-)
>>=20
>> diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c =
b/drivers/net/dsa/sja1105/sja1105_vl.c
>> index b7e95d60a6e4..cfcae4d19eef 100644
>> --- a/drivers/net/dsa/sja1105/sja1105_vl.c
>> +++ b/drivers/net/dsa/sja1105/sja1105_vl.c
>> @@ -27,20 +27,24 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
>> 	if (list_empty(&gating_cfg->entries)) {
>> 		list_add(&e->list, &gating_cfg->entries);
>> 	} else {
>> -		struct sja1105_gate_entry *p;
>> +		struct sja1105_gate_entry *p =3D NULL, *iter;
>>=20
>> -		list_for_each_entry(p, &gating_cfg->entries, list) {
>> -			if (p->interval =3D=3D e->interval) {
>> +		list_for_each_entry(iter, &gating_cfg->entries, list) {
>> +			if (iter->interval =3D=3D e->interval) {
>> 				NL_SET_ERR_MSG_MOD(extack,
>> 						 "Gate conflict");
>> 				rc =3D -EBUSY;
>> 				goto err;
>> 			}
>>=20
>> -			if (e->interval < p->interval)
>> +			if (e->interval < iter->interval) {
>> +				p =3D iter;
>> +				list_add(&e->list, iter->list.prev);
>> 				break;
>> +			}
>> 		}
>> -		list_add(&e->list, p->list.prev);
>> +		if (!p)
>> +			list_add(&e->list, gating_cfg->entries.prev);
>> 	}
>>=20
>> 	gating_cfg->num_entries++;
>=20
> This change looks ugly, why duplicating the list_add() to do the same =
?=20
> At the end of the loop the pointer contains gating_cfg->entries, so it=20=

> was cleaner before.
>=20
> If you don't want to use the loop index outside the loop, fair enough,=20=

> all you have to do is:
>=20
> 		struct sja1105_gate_entry *p, *iter;
>=20
> 		list_for_each_entry(iter, &gating_cfg->entries, list) {
> 			if (iter->interval =3D=3D e->interval) {
> 				NL_SET_ERR_MSG_MOD(extack,
> 						 "Gate conflict");
> 				rc =3D -EBUSY;
> 				goto err;
> 			}
> 			p =3D iter;
>=20
> 			if (e->interval < iter->interval)
> 				break;
> 		}
> 		list_add(&e->list, p->list.prev);

Thanks for the review and input.

The code you are showing here would have an uninitialized access to 'p'
if the list is empty.

Also 'p->list.prev' will be the second last entry if the list iterator
ran through completely, whereas the original code was pointing to the =
last
entry of the list.

IMO Vladimir Oltean posted a nice alternative way to solve it, see [1].
That way it keeps the semantics of the code the same and doesn't =
duplicate
the list_add.

>=20
>=20
>=20
> Christophe

[1] =
https://lore.kernel.org/linux-kernel/20220408114120.tvf2lxvhfqbnrlml@skbuf=
/

Thanks,
Jakob

