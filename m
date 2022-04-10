Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCBE94FADE1
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 14:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238558AbiDJMmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 08:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiDJMmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 08:42:17 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545DB3F324;
        Sun, 10 Apr 2022 05:40:06 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id i27so25698871ejd.9;
        Sun, 10 Apr 2022 05:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=WJ3zx5hxbrhQdoh4df/mkYbAfZTieLScs1fGc8yvAKE=;
        b=genybavvxQfO3oMBZjo2CjIk1O/oGwGjSShnuF7VRUqPU857l7tmI7mOpqspRCdNa8
         PP0OIXI2vNtXcK+auG9ZXMTFfhBJFd0oUTv8b4pdD3v7PeUC32Ge/N4RYYU9PNXTmgJE
         zl+60cT3783cP9JX4TQBR8pW957rVNarSQlgjCj2xNVl4mqDV72XT3VCx+sVT9VZ1DHg
         zQaUavreMRULymshsvHLE8NMNW7w3nEqeO1w59qryQUYbxeUYgeVZGqKcEuDOH+/Mstm
         /dypm4G0EB4d+XBiyN7xyFepVohVcq2zwf8oZ9d6urnWhkNoNMDQ1bECwpDFSUHNF7wj
         Nq1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=WJ3zx5hxbrhQdoh4df/mkYbAfZTieLScs1fGc8yvAKE=;
        b=xP5YrVRotHcKLMcZPWxKYt1CQYLy2UaClaobFuj91EO4nuNikzAAhPO0DzabZnxDiB
         VVR3RDuEkRDfphhb3v5UgeuT18Q6G0Fw73bcUCXgT7Yos1TT/xPuA+ePyyrJcLZjMt4j
         K/ce9ldgo5nIARoMqSsIBfJ579i4hTLNN151Q8Xlfl/negVDsaPiy1CgQKhLaSFNF4rv
         esZ6MrvB3FCRpr1gqTKFnz+nnpbvFFX20bqCFuB2w4cIrVbXJhwvj+QfdcRh68xYA/k+
         W88FBhZqz9cSFffV2y1+f8ogeyT6p4lACrS+QUxH3sMN9F4pvTTkbZMfj1lDaJCnqeYT
         /JCw==
X-Gm-Message-State: AOAM531NPCMFRQcnQGtwVLDuwwk4neSof4DjDEyyIhGk+dkmjBb7L/5/
        mnQhdF9Nm/wbCbi+40rH05Q=
X-Google-Smtp-Source: ABdhPJyyaBS7UlkYvO3wuO5S0f8bGGkJ6uVCS0ltBvj9Hg44UfZ+IoAoo+jvga3Jvjur3dumJsVFrg==
X-Received: by 2002:a17:906:7943:b0:6df:e5b3:6553 with SMTP id l3-20020a170906794300b006dfe5b36553mr25955888ejo.398.1649594404580;
        Sun, 10 Apr 2022 05:40:04 -0700 (PDT)
Received: from smtpclient.apple (ip-185-104-137-32.ptr.icomera.net. [185.104.137.32])
        by smtp.gmail.com with ESMTPSA id tj13-20020a170907c24d00b006e853804a70sm2598630ejc.0.2022.04.10.05.39.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 Apr 2022 05:40:04 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH net-next 02/15] net: dsa: sja1105: Remove usage of
 iterator for list_add() after loop
From:   Jakob Koschel <jakobkoschel@gmail.com>
In-Reply-To: <20220410110508.em3r7z62ufqcbrfm@skbuf>
Date:   Sun, 10 Apr 2022 14:39:48 +0200
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
Message-Id: <935062D0-C657-4C79-A0BE-70141D052EC0@gmail.com>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
 <20220407102900.3086255-3-jakobkoschel@gmail.com>
 <20220408114120.tvf2lxvhfqbnrlml@skbuf>
 <FA317E17-3B09-411B-9DF6-05BDD320D988@gmail.com>
 <C9081CE3-B008-48DA-A97C-76F51D4F189F@gmail.com>
 <20220410110508.em3r7z62ufqcbrfm@skbuf>
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



> On 10. Apr 2022, at 13:05, Vladimir Oltean <olteanv@gmail.com> wrote:
>=20
> On Sun, Apr 10, 2022 at 12:51:56PM +0200, Jakob Koschel wrote:
>> I've just looked at this again in a bit more detail while integrating =
it into the patch series.
>>=20
>> I realized that this just shifts the 'problem' to using the 'pos' =
iterator variable after the loop.
>> If the scope of the list iterator would be lowered to the list =
traversal loop it would also make sense
>> to also do it for list_for_each().
>=20
> Yes, but list_for_each() was never formulated as being problematic in
> the same way as list_for_each_entry(), was it? I guess I'm starting to
> not understand what is the true purpose of the changes.

Sorry for having caused the confusion. Let me elaborate a bit to give =
more context.

There are two main benefits of this entire effort.

1) fix the architectural bugs and avoid any missuse of the list iterator =
after the loop
by construction. This only concerns the list_for_each_entry_*() macros =
and your change
will allow lowering the scope for all of those. It might be debatable =
that it would be
more consistent to lower the scope for list_for_each() as well, but it =
wouldn't be
strictly necessary.

2) fix *possible* speculative bugs. In our project, Kasper [1], we were =
able to show
that this can be an issue for the list traversal macros (and this is how =
the entire
effort started).
The reason is that the processor might run an additional loop iteration =
in speculative
execution with the iterator variable computed based on the head element. =
This can
(and we have verified this) happen if the CPU incorrectly=20
assumes !list_entry_is_head(pos, head, member).

If this happens, all memory accesses based on the iterator variable =
*potentially* open
the chance for spectre [2] gadgets. The proposed mitigation was setting =
the iterator variable
to NULL when the terminating condition is reached (in speculative safe =
way). Then,
the additional speculative list iteration would still execute but won't =
access any
potential secret data.

And this would also be required for list_for_each() since combined with =
the list_entry()
within the loop it basically is semantically identical to =
list_for_each_entry()
for the additional speculative iteration.

Now, I have no strong opinion on going all the way and since 2) is not =
the main motivation
for this I'm also fine with sticking to your proposed solution, but it =
would mean that implementing
a "speculative safe" list_for_each() will be more difficult in the =
future since it is using
the iterator of list_for_each() past the loop.

I hope this explains the background a bit better.

>=20
>> What do you think about doing it this way:
>>=20
>> diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c =
b/drivers/net/dsa/sja1105/sja1105_vl.c
>> index b7e95d60a6e4..f5b0502c1098 100644
>> --- a/drivers/net/dsa/sja1105/sja1105_vl.c
>> +++ b/drivers/net/dsa/sja1105/sja1105_vl.c
>> @@ -28,6 +28,7 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
>>                list_add(&e->list, &gating_cfg->entries);
>>        } else {
>>                struct sja1105_gate_entry *p;
>> +               struct list_head *pos =3D NULL;
>>=20
>>                list_for_each_entry(p, &gating_cfg->entries, list) {
>>                        if (p->interval =3D=3D e->interval) {
>> @@ -37,10 +38,14 @@ static int sja1105_insert_gate_entry(struct =
sja1105_gating_config *gating_cfg,
>>                                goto err;
>>                        }
>>=20
>> -                       if (e->interval < p->interval)
>> +                       if (e->interval < p->interval) {
>> +                               pos =3D &p->list;
>>                                break;
>> +                       }
>>                }
>> -               list_add(&e->list, p->list.prev);
>> +               if (!pos)
>> +                       pos =3D &gating_cfg->entries;
>> +               list_add(&e->list, pos->prev);
>>        }
>>=20
>>        gating_cfg->num_entries++;
>> --
>>=20
>>>=20
>>> Thanks for the suggestion.
>>>=20
>>>> 	}
>>>>=20
>>>> 	gating_cfg->num_entries++;
>>>> -----------------------------[ cut here =
]-----------------------------
>>>=20
>>> [1] =
https://lore.kernel.org/linux-kernel/20220407102900.3086255-12-jakobkosche=
l@gmail.com/
>>>=20
>>> 	Jakob
>>=20
>> Thanks,
>> Jakob

Thanks,
Jakob

[1] https://www.vusec.net/projects/kasper/
[2] https://spectreattack.com/spectre.pdf

