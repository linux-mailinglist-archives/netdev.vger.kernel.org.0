Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A45304FAF93
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 20:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239869AbiDJS0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 14:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbiDJS0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 14:26:53 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CC04FC6C;
        Sun, 10 Apr 2022 11:24:41 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id v15so5698364edb.12;
        Sun, 10 Apr 2022 11:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=6cdVUS6XiscYrUgxUxtAL2ssNdCpR5fNQ/PXRqx8HXE=;
        b=E3oamHlVUO9sG+tUlCb7w/lxckY+1bMJ8Oj/JMRsdthREWTAo/EU1ssZbsEddX/CMW
         XF+LLnOvzqbQ09/kqpDMUFnXICqi/jhgYhhv5gxrC5MMdDeloz3+bT7nNdHFZfSEL2q0
         XjhyXlJ2wmJ+nWvvMT0izK3719NdGolLrqWsrZQa3UBq1r9OQ40xF0MyV4NqmK82mhIJ
         Z5+8pR6KZwFLv6NnK3nKzBo3rK6QovFRSGe9xxfzi7Cygm/LyX76sqMrbY0iZzA1pxUb
         HTenU1x8AjD/thUEi/iR5ReeV/7u+ZMAdb3HHejyOJt71iosXVU5vKr6vibgesiixUDv
         Ojhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=6cdVUS6XiscYrUgxUxtAL2ssNdCpR5fNQ/PXRqx8HXE=;
        b=oZ70vUMHT1f2R7ZkKTsK/pRe0ZP070Wo3lnf7IMacIGvDui3Qg3WI5w4LLDA+PKw0J
         ZJE93qQ3ip7ELF5x62uTV3wWumnlfqyheUbFBYxWUrx0CY6TdAeCTalcoYkhW7wkbj1z
         W96Cq67u7QaASq/Y/QdXMaF9pocve+5HZe4Eyt4ggZxS4A1uM8U54Il2o7QovM58kmBt
         BR0SvG0myREqnMKveFBHXkWzjdWyryab9GNGMQiWbLOivDhGCV32OEMtuMZJriHm8EmG
         aRByH5CqKO7WOF5fUpoc+qp5TGsqsMymbNlAoNhzy3ulnEWDQFvOq+nMzNv1e6TEw3Yf
         W3Ww==
X-Gm-Message-State: AOAM531uTlVcXMsZd8j8xnQLHzLUc9QHOhUqBcPguwNO+l05xJbpKq5e
        RIQd87DoQ7h7iZeL7Rb04EXqU0lcMxcNtVTC
X-Google-Smtp-Source: ABdhPJzHtBkIeS+/EEn5hhsp2OBGrQi0n93cEQMWNioFwMIDx3qPQINg9OZCTpvVlSgC58g1HvsjRQ==
X-Received: by 2002:aa7:db94:0:b0:410:f0e8:c39e with SMTP id u20-20020aa7db94000000b00410f0e8c39emr29340972edt.14.1649615079652;
        Sun, 10 Apr 2022 11:24:39 -0700 (PDT)
Received: from smtpclient.apple (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.gmail.com with ESMTPSA id s4-20020a170906bc4400b006e893908c4csm356693ejv.60.2022.04.10.11.24.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 Apr 2022 11:24:39 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH net-next 02/15] net: dsa: sja1105: Remove usage of
 iterator for list_add() after loop
From:   Jakob Koschel <jakobkoschel@gmail.com>
In-Reply-To: <935062D0-C657-4C79-A0BE-70141D052EC0@gmail.com>
Date:   Sun, 10 Apr 2022 20:24:37 +0200
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
Message-Id: <C88FE232-417C-4029-A79E-9A7E807D2FE7@gmail.com>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
 <20220407102900.3086255-3-jakobkoschel@gmail.com>
 <20220408114120.tvf2lxvhfqbnrlml@skbuf>
 <FA317E17-3B09-411B-9DF6-05BDD320D988@gmail.com>
 <C9081CE3-B008-48DA-A97C-76F51D4F189F@gmail.com>
 <20220410110508.em3r7z62ufqcbrfm@skbuf>
 <935062D0-C657-4C79-A0BE-70141D052EC0@gmail.com>
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



> On 10. Apr 2022, at 14:39, Jakob Koschel <jakobkoschel@gmail.com> =
wrote:
>=20
>=20
>=20
>> On 10. Apr 2022, at 13:05, Vladimir Oltean <olteanv@gmail.com> wrote:
>>=20
>> On Sun, Apr 10, 2022 at 12:51:56PM +0200, Jakob Koschel wrote:
>>> I've just looked at this again in a bit more detail while =
integrating it into the patch series.
>>>=20
>>> I realized that this just shifts the 'problem' to using the 'pos' =
iterator variable after the loop.
>>> If the scope of the list iterator would be lowered to the list =
traversal loop it would also make sense
>>> to also do it for list_for_each().
>>=20
>> Yes, but list_for_each() was never formulated as being problematic in
>> the same way as list_for_each_entry(), was it? I guess I'm starting =
to
>> not understand what is the true purpose of the changes.
>=20
> Sorry for having caused the confusion. Let me elaborate a bit to give =
more context.
>=20
> There are two main benefits of this entire effort.
>=20
> 1) fix the architectural bugs and avoid any missuse of the list =
iterator after the loop
> by construction. This only concerns the list_for_each_entry_*() macros =
and your change
> will allow lowering the scope for all of those. It might be debatable =
that it would be
> more consistent to lower the scope for list_for_each() as well, but it =
wouldn't be
> strictly necessary.
>=20
> 2) fix *possible* speculative bugs. In our project, Kasper [1], we =
were able to show
> that this can be an issue for the list traversal macros (and this is =
how the entire
> effort started).
> The reason is that the processor might run an additional loop =
iteration in speculative
> execution with the iterator variable computed based on the head =
element. This can
> (and we have verified this) happen if the CPU incorrectly=20
> assumes !list_entry_is_head(pos, head, member).
>=20
> If this happens, all memory accesses based on the iterator variable =
*potentially* open
> the chance for spectre [2] gadgets. The proposed mitigation was =
setting the iterator variable
> to NULL when the terminating condition is reached (in speculative safe =
way). Then,
> the additional speculative list iteration would still execute but =
won't access any
> potential secret data.
>=20
> And this would also be required for list_for_each() since combined =
with the list_entry()
> within the loop it basically is semantically identical to =
list_for_each_entry()
> for the additional speculative iteration.
>=20
> Now, I have no strong opinion on going all the way and since 2) is not =
the main motivation
> for this I'm also fine with sticking to your proposed solution, but it =
would mean that implementing
> a "speculative safe" list_for_each() will be more difficult in the =
future since it is using
> the iterator of list_for_each() past the loop.
>=20
> I hope this explains the background a bit better.
>=20
>>=20
>>> What do you think about doing it this way:
>>>=20
>>> diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c =
b/drivers/net/dsa/sja1105/sja1105_vl.c
>>> index b7e95d60a6e4..f5b0502c1098 100644
>>> --- a/drivers/net/dsa/sja1105/sja1105_vl.c
>>> +++ b/drivers/net/dsa/sja1105/sja1105_vl.c
>>> @@ -28,6 +28,7 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
>>> list_add(&e->list, &gating_cfg->entries);
>>> } else {
>>> struct sja1105_gate_entry *p;
>>> + struct list_head *pos =3D NULL;
>>>=20
>>> list_for_each_entry(p, &gating_cfg->entries, list) {
>>> if (p->interval =3D=3D e->interval) {
>>> @@ -37,10 +38,14 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
>>> goto err;
>>> }
>>>=20
>>> - if (e->interval < p->interval)
>>> + if (e->interval < p->interval) {
>>> + pos =3D &p->list;
>>> break;
>>> + }
>>> }
>>> - list_add(&e->list, p->list.prev);
>>> + if (!pos)
>>> + pos =3D &gating_cfg->entries;
>>> + list_add(&e->list, pos->prev);
>>> }
>>>=20
>>> gating_cfg->num_entries++;
>>> --
>>>=20
>>>>=20
>>>> Thanks for the suggestion.
>>>>=20
>>>>> 	}
>>>>>=20
>>>>> 	gating_cfg->num_entries++;
>>>>> -----------------------------[ cut here =
]-----------------------------
>>>>=20
>>>> [1] =
https://lore.kernel.org/linux-kernel/20220407102900.3086255-12-jakobkosche=
l@gmail.com/
>>>>=20
>>>> 	Jakob
>>>=20
>>> Thanks,
>>> Jakob
>=20
> Thanks,
> Jakob
>=20
> [1] https://www.vusec.net/projects/kasper/
> [2] https://spectreattack.com/spectre.pdf


Btw, I just realized that the if (!pos) is not necessary. This should =
simply do it:

diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c =
b/drivers/net/dsa/sja1105/sja1105_vl.c
index b7e95d60a6e4..2d59e75a9e3d 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -28,6 +28,7 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
 		list_add(&e->list, &gating_cfg->entries);
 	} else {
+		struct list_head *pos =3D &gating_cfg->entries;
 		struct sja1105_gate_entry *p;
=20
 		list_for_each_entry(p, &gating_cfg->entries, list) {
 			if (p->interval =3D=3D e->interval) {
@@ -37,10 +38,12 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
 				goto err;
 			}
=20
-			if (e->interval < p->interval)
+			if (e->interval < p->interval) {
+				pos =3D &p->list;
 				break;
+			}
 		}
-		list_add(&e->list, p->list.prev);
+		list_add(&e->list, pos->prev);
 	}
=20
 	gating_cfg->num_entries++;
--=20
2.25.1

Thanks,
Jakob

