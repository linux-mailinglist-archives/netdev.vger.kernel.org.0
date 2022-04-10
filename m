Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06C54FAD7E
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 12:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237788AbiDJKyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 06:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237695AbiDJKyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 06:54:47 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A5B53732;
        Sun, 10 Apr 2022 03:52:36 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id o20-20020a05600c511400b0038ebbbb2ad8so31384wms.0;
        Sun, 10 Apr 2022 03:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=kn52YjxRP3HqWkZew8Ipsml5lgWqK7Cz8BCyoXhoZV0=;
        b=nRLdihQfsUp6sOWD/nbTtvNLMahUa3M3qne1N4xH/AydXioUpWdhPubJA7eKSeUhUx
         w7d3384iWpbwTVWDQ5IUJJCPhtwaReM2CJXXTO/XSehw11KmHBhBWieY7Zk6xsXzv21m
         skJn3JmdAjUG2epzSVL6LxvoZn5f6484C94OUEWBatIBJThlje5Vl24BLML0OAbKFBf4
         JoK4FeewUjOWymiDKBcTdUeW+b5K4PdGOsmBQRzYKwD95fu4KTLRsOp4CBB7zCKvAzVp
         fFBRADeBE0V+wggy8Z+EAOwfk/e0dCyodl8fN0fVs8HTJpf264mgZaTeMPaYciEiD0kr
         o3Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=kn52YjxRP3HqWkZew8Ipsml5lgWqK7Cz8BCyoXhoZV0=;
        b=MNqCXIXuRKnTaGaKFEju3uUs61AnCsgZPE7ewXqmDFbZGzMgFzX5cy7W5glf174OAY
         Z7OTEI2TN2U2l1fAi+xaKdrDEBjQLPQJOmXBQiF5uaC177wcfUOyVDVsIBvaP3lWtFyk
         WZl82HagHylM5VRdYWC9lA4fnvb4bM4zwNbOECdd3j9UsKsyJvNGhCtYo3sblVOvaUzC
         QNJNyU4lp+qki6DOIe3+FaPx9BZF4IgG/3I2yqPotghkCdMesqOckX203wz72td1fsaZ
         BDL03HKUQ5tB+yjhh7J+0JHRLmgm24y8kaHVXp1pPrqfYLwmtp9ctiXhaRq4/zqf6znQ
         qLig==
X-Gm-Message-State: AOAM532EiUlqB1dVv6oisf20C+mOCVm454tDItYsY9OxpN0ofvtrt0XY
        Z7zrplCRgkHSplflZuEbjhM=
X-Google-Smtp-Source: ABdhPJyNmzP4UmoC2TmYAqta8L+av7eM7X4bCLxc7XByKnN0jEFRhqTNWjgEoTqRG4ZsBe0V8cQU8g==
X-Received: by 2002:a05:600c:5111:b0:38e:3535:b258 with SMTP id o17-20020a05600c511100b0038e3535b258mr24017702wms.169.1649587954790;
        Sun, 10 Apr 2022 03:52:34 -0700 (PDT)
Received: from smtpclient.apple ([109.190.253.11])
        by smtp.gmail.com with ESMTPSA id h9-20020a05600c350900b0038cbcbcf994sm15712375wmq.36.2022.04.10.03.52.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 Apr 2022 03:52:34 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH net-next 02/15] net: dsa: sja1105: Remove usage of
 iterator for list_add() after loop
From:   Jakob Koschel <jakobkoschel@gmail.com>
In-Reply-To: <FA317E17-3B09-411B-9DF6-05BDD320D988@gmail.com>
Date:   Sun, 10 Apr 2022 12:51:56 +0200
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
Message-Id: <C9081CE3-B008-48DA-A97C-76F51D4F189F@gmail.com>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
 <20220407102900.3086255-3-jakobkoschel@gmail.com>
 <20220408114120.tvf2lxvhfqbnrlml@skbuf>
 <FA317E17-3B09-411B-9DF6-05BDD320D988@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Vladimir,

> On 9. Apr 2022, at 01:54, Jakob Koschel <jakobkoschel@gmail.com> =
wrote:
>=20
> Hello Vladimir,
>=20
>> On 8. Apr 2022, at 13:41, Vladimir Oltean <olteanv@gmail.com> wrote:
>>=20
>> Hello Jakob,
>>=20
>> On Thu, Apr 07, 2022 at 12:28:47PM +0200, Jakob Koschel wrote:
>>> In preparation to limit the scope of a list iterator to the list
>>> traversal loop, use a dedicated pointer to point to the found =
element [1].
>>>=20
>>> Before, the code implicitly used the head when no element was found
>>> when using &pos->list. Since the new variable is only set if an
>>> element was found, the list_add() is performed within the loop
>>> and only done after the loop if it is done on the list head =
directly.
>>>=20
>>> Link: =
https://lore.kernel.org/all/CAHk-=3DwgRr_D8CB-D9Kg-c=3DEHreAsk5SqXPwr9Y7k9=
sA6cWXJ6w@mail.gmail.com/ [1]
>>> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
>>> ---
>>> drivers/net/dsa/sja1105/sja1105_vl.c | 14 +++++++++-----
>>> 1 file changed, 9 insertions(+), 5 deletions(-)
>>>=20
>>> diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c =
b/drivers/net/dsa/sja1105/sja1105_vl.c
>>> index b7e95d60a6e4..cfcae4d19eef 100644
>>> --- a/drivers/net/dsa/sja1105/sja1105_vl.c
>>> +++ b/drivers/net/dsa/sja1105/sja1105_vl.c
>>> @@ -27,20 +27,24 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
>>> 	if (list_empty(&gating_cfg->entries)) {
>>> 		list_add(&e->list, &gating_cfg->entries);
>>> 	} else {
>>> -		struct sja1105_gate_entry *p;
>>> +		struct sja1105_gate_entry *p =3D NULL, *iter;
>>>=20
>>> -		list_for_each_entry(p, &gating_cfg->entries, list) {
>>> -			if (p->interval =3D=3D e->interval) {
>>> +		list_for_each_entry(iter, &gating_cfg->entries, list) {
>>> +			if (iter->interval =3D=3D e->interval) {
>>> 				NL_SET_ERR_MSG_MOD(extack,
>>> 						 "Gate conflict");
>>> 				rc =3D -EBUSY;
>>> 				goto err;
>>> 			}
>>>=20
>>> -			if (e->interval < p->interval)
>>> +			if (e->interval < iter->interval) {
>>> +				p =3D iter;
>>> +				list_add(&e->list, iter->list.prev);
>>> 				break;
>>> +			}
>>> 		}
>>> -		list_add(&e->list, p->list.prev);
>>> +		if (!p)
>>> +			list_add(&e->list, gating_cfg->entries.prev);
>>> 	}
>>>=20
>>> 	gating_cfg->num_entries++;
>>> --=20
>>> 2.25.1
>>>=20
>>=20
>> I apologize in advance if I've misinterpreted the end goal of your =
patch.
>> I do have a vague suspicion I understand what you're trying to =
achieve,
>> and in that case, would you mind using this patch instead of yours?
>=20
> I think you are very much spot on!
>=20
>> I think it still preserves the intention of the code in a clean =
manner.
>>=20
>> -----------------------------[ cut here =
]-----------------------------
>> =46rom 7aed740750d1bc3bff6e85fd33298f5905bb4e01 Mon Sep 17 00:00:00 =
2001
>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>> Date: Fri, 8 Apr 2022 13:55:14 +0300
>> Subject: [PATCH] net: dsa: sja1105: avoid use of type-confused =
pointer in
>> sja1105_insert_gate_entry()
>>=20
>> It appears that list_for_each_entry() leaks a type-confused pointer =
when
>> the iteration loop ends with no early break, since "*p" will no =
longer
>> point to a "struct sja1105_gate_entry", but rather to some memory in
>> front of "gating_cfg->entries".
>>=20
>> This isn't actually a problem here, because if the element we insert =
has
>> the highest interval, therefore we never exit the loop early, =
"p->list"
>> (which is all that we use outside the loop) will in fact point to
>> "gating_cfg->entries" even though "p" itself is invalid.
>>=20
>> Nonetheless, there are preparations to increase the safety of
>> list_for_each_entry() by making it impossible to use the =
encapsulating
>> structure of the iterator element outside the loop. So something =
needs
>> to change here before those preparations go in, even though this
>> constitutes legitimate use.
>>=20
>> Make it clear that we are not dereferencing members of the =
encapsulating
>> "struct sja1105_gate_entry" outside the loop, by using the regular
>> list_for_each() iterator, and dereferencing the struct =
sja1105_gate_entry
>> only within the loop.
>>=20
>> With list_for_each(), the iterator element at the end of the loop =
does
>> have a sane value in all cases, and we can just use that as the =
"head"
>> argument of list_add().
>>=20
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> ---
>> drivers/net/dsa/sja1105/sja1105_vl.c | 12 +++++++++---
>> 1 file changed, 9 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c =
b/drivers/net/dsa/sja1105/sja1105_vl.c
>> index c0e45b393fde..fe93c80fe5ef 100644
>> --- a/drivers/net/dsa/sja1105/sja1105_vl.c
>> +++ b/drivers/net/dsa/sja1105/sja1105_vl.c
>> @@ -27,9 +27,15 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
>> 	if (list_empty(&gating_cfg->entries)) {
>> 		list_add(&e->list, &gating_cfg->entries);
>> 	} else {
>> -		struct sja1105_gate_entry *p;
>> +		struct list_head *pos;
>> +
>> +		/* We cannot safely use list_for_each_entry()
>> +		 * because we dereference "pos" after the loop
>> +		 */
>> +		list_for_each(pos, &gating_cfg->entries) {
>> +			struct sja1105_gate_entry *p;
>>=20
>> -		list_for_each_entry(p, &gating_cfg->entries, list) {
>> +			p =3D list_entry(pos, struct sja1105_gate_entry, =
list);
>> 			if (p->interval =3D=3D e->interval) {
>> 				NL_SET_ERR_MSG_MOD(extack,
>> 						 "Gate conflict");
>> @@ -40,7 +46,7 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
>> 			if (e->interval < p->interval)
>> 				break;
>> 		}
>> -		list_add(&e->list, p->list.prev);
>> +		list_add(&e->list, pos->prev);
>=20
> I was actually considering doing it this way before but wasn't sure if =
this would be preferred.
> I've done something like this in [1] and it does turn out quite well.
>=20
> I'll integrate this in the v2 series.

I've just looked at this again in a bit more detail while integrating it =
into the patch series.

I realized that this just shifts the 'problem' to using the 'pos' =
iterator variable after the loop.
If the scope of the list iterator would be lowered to the list traversal =
loop it would also make sense
to also do it for list_for_each().

What do you think about doing it this way:

diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c =
b/drivers/net/dsa/sja1105/sja1105_vl.c
index b7e95d60a6e4..f5b0502c1098 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -28,6 +28,7 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
                list_add(&e->list, &gating_cfg->entries);
        } else {
                struct sja1105_gate_entry *p;
+               struct list_head *pos =3D NULL;

                list_for_each_entry(p, &gating_cfg->entries, list) {
                        if (p->interval =3D=3D e->interval) {
@@ -37,10 +38,14 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
                                goto err;
                        }

-                       if (e->interval < p->interval)
+                       if (e->interval < p->interval) {
+                               pos =3D &p->list;
                                break;
+                       }
                }
-               list_add(&e->list, p->list.prev);
+               if (!pos)
+                       pos =3D &gating_cfg->entries;
+               list_add(&e->list, pos->prev);
        }

        gating_cfg->num_entries++;
--

>=20
> Thanks for the suggestion.
>=20
>> 	}
>>=20
>> 	gating_cfg->num_entries++;
>> -----------------------------[ cut here =
]-----------------------------
>=20
> [1] =
https://lore.kernel.org/linux-kernel/20220407102900.3086255-12-jakobkosche=
l@gmail.com/
>=20
> 	Jakob

Thanks,
Jakob=
