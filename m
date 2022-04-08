Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9614FA04B
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 01:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236649AbiDHX41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 19:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiDHX40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 19:56:26 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178FDE21;
        Fri,  8 Apr 2022 16:54:19 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id p189so6473245wmp.3;
        Fri, 08 Apr 2022 16:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=n5UPNQEDai1gUFUdN9sucmKpzqqEUym2Bv+35OpgTmc=;
        b=pG1F0MrmF0MxsheTCnU5KlnL7Fq3an1SzIoDIJWlvZTcNPwAejlsTxkr/aITjxttuN
         4t9qOz+HWVuW9mjRCjV1vM02Lp8cdd8MquH/W9I+QdExZFr0zL5FS2Nb0kvl0UlWCFVK
         NgbMRkfNJM8aq4eRSV2Ai4D/koQFTxUsZyeBDHnWTq2iI4ygMQjDD0DiM26d3Eg9r9fy
         whdlpXipwUciya55rwa+AMb/cR0AFXTNn9znvHshZnrvO2q7Hhgb3ypRlYjgYvC2QDHR
         tvaZ+Czt68GGIRMZ42zUl+nz0t57NIJTSXJjhID/BEsFgMymPAqNrdXgUaadY0zKbhfr
         5DQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=n5UPNQEDai1gUFUdN9sucmKpzqqEUym2Bv+35OpgTmc=;
        b=wqZVqkg+tRgqcKqW6VxL7qebjlw7bN7VSILHHzoDAWT6JOSyWCmG1Pfqrue6F84e9d
         Wf930uH4I2jPtvkZQJUblyLYEqCw+Xri8PNmcUkH6UFwdrYGQgFxechZyo1H0lWb9MZJ
         cObdGTL8Cwh7JvWxUv8hSI5cvXv8/N3aGEXim+i1NTpyQbVzOOmPTs8Qe0bn7ILXVrEW
         sPXh34yb5lyYa7IjTxnEAINAIOg1KcQ3xZXX0LgAvXjwGjAJ6PNapOs6b7uwXmpxk0oh
         PuVW7N8W/azJooFUKzhPcpg1nMcpYVu3BitjzQUBX6cipi4/3aZgwwoOxTW2UlYlG8Mh
         WIhw==
X-Gm-Message-State: AOAM532b3NbAxxexktrI8/feHraKLsEeKv6NfixZdYb1KirBdoHORkiy
        kB3AC05Mor4I6F0l8ACvTtU=
X-Google-Smtp-Source: ABdhPJzYPe2XZp3HIcQrurMuTy8KVeKXLKzzK2Euy2m/YilBtUjHiW3sSWpaiPkVrXseuI50+m05lg==
X-Received: by 2002:a05:600c:190e:b0:38c:b1ea:f4ac with SMTP id j14-20020a05600c190e00b0038cb1eaf4acmr18783624wmq.70.1649462057538;
        Fri, 08 Apr 2022 16:54:17 -0700 (PDT)
Received: from smtpclient.apple ([185.238.38.242])
        by smtp.gmail.com with ESMTPSA id p16-20020a5d6390000000b00203ffebddf3sm26542577wru.99.2022.04.08.16.54.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Apr 2022 16:54:16 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH net-next 02/15] net: dsa: sja1105: Remove usage of
 iterator for list_add() after loop
From:   Jakob Koschel <jakobkoschel@gmail.com>
In-Reply-To: <20220408114120.tvf2lxvhfqbnrlml@skbuf>
Date:   Sat, 9 Apr 2022 01:54:13 +0200
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Colin Ian King <colin.king@intel.com>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Di Zhu <zhudi21@huawei.com>, Xu Wang <vulab@iscas.ac.cn>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FA317E17-3B09-411B-9DF6-05BDD320D988@gmail.com>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
 <20220407102900.3086255-3-jakobkoschel@gmail.com>
 <20220408114120.tvf2lxvhfqbnrlml@skbuf>
To:     Vladimir Oltean <olteanv@gmail.com>
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

Hello Vladimir,

> On 8. Apr 2022, at 13:41, Vladimir Oltean <olteanv@gmail.com> wrote:
>=20
> Hello Jakob,
>=20
> On Thu, Apr 07, 2022 at 12:28:47PM +0200, Jakob Koschel wrote:
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
>> 						   "Gate conflict");
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
>> --=20
>> 2.25.1
>>=20
>=20
> I apologize in advance if I've misinterpreted the end goal of your =
patch.
> I do have a vague suspicion I understand what you're trying to =
achieve,
> and in that case, would you mind using this patch instead of yours?

I think you are very much spot on!

> I think it still preserves the intention of the code in a clean =
manner.
>=20
> -----------------------------[ cut here ]-----------------------------
> =46rom 7aed740750d1bc3bff6e85fd33298f5905bb4e01 Mon Sep 17 00:00:00 =
2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Fri, 8 Apr 2022 13:55:14 +0300
> Subject: [PATCH] net: dsa: sja1105: avoid use of type-confused pointer =
in
> sja1105_insert_gate_entry()
>=20
> It appears that list_for_each_entry() leaks a type-confused pointer =
when
> the iteration loop ends with no early break, since "*p" will no longer
> point to a "struct sja1105_gate_entry", but rather to some memory in
> front of "gating_cfg->entries".
>=20
> This isn't actually a problem here, because if the element we insert =
has
> the highest interval, therefore we never exit the loop early, =
"p->list"
> (which is all that we use outside the loop) will in fact point to
> "gating_cfg->entries" even though "p" itself is invalid.
>=20
> Nonetheless, there are preparations to increase the safety of
> list_for_each_entry() by making it impossible to use the encapsulating
> structure of the iterator element outside the loop. So something needs
> to change here before those preparations go in, even though this
> constitutes legitimate use.
>=20
> Make it clear that we are not dereferencing members of the =
encapsulating
> "struct sja1105_gate_entry" outside the loop, by using the regular
> list_for_each() iterator, and dereferencing the struct =
sja1105_gate_entry
> only within the loop.
>=20
> With list_for_each(), the iterator element at the end of the loop does
> have a sane value in all cases, and we can just use that as the "head"
> argument of list_add().
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> drivers/net/dsa/sja1105/sja1105_vl.c | 12 +++++++++---
> 1 file changed, 9 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c =
b/drivers/net/dsa/sja1105/sja1105_vl.c
> index c0e45b393fde..fe93c80fe5ef 100644
> --- a/drivers/net/dsa/sja1105/sja1105_vl.c
> +++ b/drivers/net/dsa/sja1105/sja1105_vl.c
> @@ -27,9 +27,15 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
> 	if (list_empty(&gating_cfg->entries)) {
> 		list_add(&e->list, &gating_cfg->entries);
> 	} else {
> -		struct sja1105_gate_entry *p;
> +		struct list_head *pos;
> +
> +		/* We cannot safely use list_for_each_entry()
> +		 * because we dereference "pos" after the loop
> +		 */
> +		list_for_each(pos, &gating_cfg->entries) {
> +			struct sja1105_gate_entry *p;
>=20
> -		list_for_each_entry(p, &gating_cfg->entries, list) {
> +			p =3D list_entry(pos, struct sja1105_gate_entry, =
list);
> 			if (p->interval =3D=3D e->interval) {
> 				NL_SET_ERR_MSG_MOD(extack,
> 						   "Gate conflict");
> @@ -40,7 +46,7 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
> 			if (e->interval < p->interval)
> 				break;
> 		}
> -		list_add(&e->list, p->list.prev);
> +		list_add(&e->list, pos->prev);

I was actually considering doing it this way before but wasn't sure if =
this would be preferred.
I've done something like this in [1] and it does turn out quite well.

I'll integrate this in the v2 series.

Thanks for the suggestion.

> 	}
>=20
> 	gating_cfg->num_entries++;
> -----------------------------[ cut here ]-----------------------------

[1] =
https://lore.kernel.org/linux-kernel/20220407102900.3086255-12-jakobkosche=
l@gmail.com/

	Jakob=
