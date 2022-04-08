Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CA64FA054
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 01:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236671AbiDIAAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 20:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiDIAAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 20:00:38 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0B413CEA;
        Fri,  8 Apr 2022 16:58:32 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id h16so6507266wmd.0;
        Fri, 08 Apr 2022 16:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qd3xc3Ra5RdXly3fLoBNbPp+Yte3DEybTK7LULZsV3k=;
        b=UTGVqcy3UNBHn4SjP055yjMHx25cx36ejPBp1IwM+TK42xPMJWggb62u36PjAn6CNs
         erjoHyHU8VCNFk6fyYMl9z5v01Gp4wFgd/YNtvHzVZoUNO1l1su4dzjYvBw8kUi9XQGT
         Dqx4LfV7Q3W3Q2ELUZ+IriwQLR2xNOatUWwcD4gCTCxw1L69vExXISL5tvGEhODxE6Rx
         NyTL6VCNOxreRWn96Q5S2m2f20ESHMigOHCRieFZbYkKlad5VdovjvaPkuSuw/BSGDvW
         pPhBauUCmlFtTa8H2+PKUY86AjdMN4Ej5kEfWhaBYJ/9ht3pshbQ+wwXawCFIYrMD9Xn
         BSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qd3xc3Ra5RdXly3fLoBNbPp+Yte3DEybTK7LULZsV3k=;
        b=6oRi3thfDtbwwtR2I3gPr4GK4ehkqhYhMDKTCmZqtpkKIOEv4zqhaKDP86wBmtj8Ab
         8n3lpv74wzCmRCLPy/WBeyQeWKkQ065VoiRED5VmOjMYgoAzh5rNrP2udW/xmdri4CUB
         41E6W9fXS67ipT9aqZIURPeygc8cXRS8BRGLDFb60/rUAvmdD+H5rWdMHddNM65eFcg9
         NLbqPzmZTWQ2F6w4+kRf2aXmm8uHmQD+D2IkAtRnwODM9xIAseK580dvTfSN4pwugyqb
         gkBZ0CAc6isN4XyTJTiNJAs/64Lqgep+Dk4kY8P9OEHtbKrvFe4OTjFwa18lbNUvswIN
         iVDg==
X-Gm-Message-State: AOAM533KxwKt62gUXK2SRYst5YDdN9AISA/7Rw/L3TfUAETRBLJVXJlm
        RhDrBEIWbLyMM+Cl9DLH/ug=
X-Google-Smtp-Source: ABdhPJwvJD+Cmd/2tHHonwkEVj4aZLwFznxjwZ531F0NRT9DZUNezEkyG1rHEVZvGmv1umZ1GStMeg==
X-Received: by 2002:a7b:c844:0:b0:38e:7c92:a9e3 with SMTP id c4-20020a7bc844000000b0038e7c92a9e3mr18808150wml.140.1649462311057;
        Fri, 08 Apr 2022 16:58:31 -0700 (PDT)
Received: from smtpclient.apple ([185.238.38.242])
        by smtp.gmail.com with ESMTPSA id o17-20020a05600c4fd100b0038cd5074c83sm12043743wmq.34.2022.04.08.16.58.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Apr 2022 16:58:30 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH net-next 02/15] net: dsa: sja1105: Remove usage of
 iterator for list_add() after loop
From:   Jakob Koschel <jakobkoschel@gmail.com>
In-Reply-To: <20220407205426.6a31e4b2@kernel.org>
Date:   Sat, 9 Apr 2022 01:58:29 +0200
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
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
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AAB64C72-5B45-4BA1-BB48-106F08BDFF1B@gmail.com>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
 <20220407102900.3086255-3-jakobkoschel@gmail.com>
 <20220407205426.6a31e4b2@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
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

Hello Jakub,

> On 8. Apr 2022, at 05:54, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Thu,  7 Apr 2022 12:28:47 +0200 Jakob Koschel wrote:
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
>=20
> This turns a pretty slick piece of code into something ugly :(
> I'd rather you open coded the iteration here than make it more=20
> complex to satisfy "safe coding guidelines".

I'm not entirely sure I understand what you mean with=20
"open coded the iteration". But maybe the solution proposed by Vladimir =
[1]
works for you? I'm planning to rewrite the cases in that way for the =
relevant
ones.

>=20
> Also the list_add() could be converted to list_add_tail().

Good point, I wasn't sure if that's considered as something that should =
be
done as a separate change. I'm happy to include it in v2.

Thanks for the input.

	Jakob

[1] =
https://lore.kernel.org/linux-kernel/20220408114120.tvf2lxvhfqbnrlml@skbuf=
/

