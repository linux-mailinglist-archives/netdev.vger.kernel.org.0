Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12A05609DF
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 20:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiF2S66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 14:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiF2S65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 14:58:57 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73CF193D0
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 11:58:56 -0700 (PDT)
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E3441402C2
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 18:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1656529134;
        bh=6iYWf/YeOTRqNm7ox36J45/MeTPZORHOToEf2PQ9E2U=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=Zj8MdDqyNBoAdzpQ/WOmv5qf6IRfFzl8o45kyOxg/5FwW2+vYs0tQyLnbzTWtgxJY
         pwHuxaVkch1EGhxKlggDykhALLxrxC5Js4gDmCN4oSv/eusu/BrPWkTsYyTWY38+KX
         ldMmXz0+gY6RrNkSMWj9VS8ycIFD0IoIEYKTYx8pFq4QjumI+paCaIJNIZ+Bz3txZN
         Ow+vYyLSScMsE62/IzwJwDrSXu4QglzS6IwYjFhQ790ZZXLLnevtNbujkyQNaQlMcp
         S2TuTSvBvrKDVkbTCqlPpyXomop7VfLLJaGCebELTdXHFz+BqTns+03vwdiA4bIAog
         lsIBuRzOMP4ag==
Received: by mail-pl1-f197.google.com with SMTP id c16-20020a170902b69000b0016a71a49c0cso8076768pls.23
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 11:58:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=6iYWf/YeOTRqNm7ox36J45/MeTPZORHOToEf2PQ9E2U=;
        b=fL499TwogZfFGmeph47TdzGguO6ThJfRBHpLLiAlsRpG+saGVmykr//AywJMNvcmAv
         jWtJhOMh74krxWsKKwas/ZpSfa4LVKkO6jEhSBxdDRWIsuPch2V03BTqGeJQdaDoJcZD
         vu2FfMvKXH/SWtCgmzK0Btv0WeHOzjuZSuHlrLPm24JQ+P9UJJBb7ELgxhwwJ0y37iV2
         cT4hfY4peTxJr91XClSd4GszX/idVWxcB1GlcAJuEhIrtuPhjkLTelTv5XT3SUHAO4S9
         uiM/Xc1Wy9bFOCmhSy+tWjREYgUKM6GraCqHh2jCXkdG2TCvIR0WgKWU1q+GAjn5HMa2
         KHjg==
X-Gm-Message-State: AJIora8QGqdDYd1uUJ0FEKsnK+XFuUN6EQNECtY/mkX7yIb8bcv270Hi
        k+sUM+tvcsZHWgn41a2KwPCr6ic16UXVvkF1RrazOOPjeB8QLkhtVL1SR7RnNA1VUgQyauPoMJt
        GjhvHvMO/QnSADOl6eH1lfZghR62+jsapow==
X-Received: by 2002:a63:b444:0:b0:40c:f936:a21a with SMTP id n4-20020a63b444000000b0040cf936a21amr4253165pgu.37.1656529133589;
        Wed, 29 Jun 2022 11:58:53 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tLJjDVD1ffdKoE/azFr6/Om005ry1/h8AruJFOA0Km4PLUHHmf5L3eOWe6UOaAws8/1LvWRQ==
X-Received: by 2002:a63:b444:0:b0:40c:f936:a21a with SMTP id n4-20020a63b444000000b0040cf936a21amr4253141pgu.37.1656529133314;
        Wed, 29 Jun 2022 11:58:53 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id c20-20020a17090aa61400b001ec84049064sm2514341pjq.41.2022.06.29.11.58.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jun 2022 11:58:52 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 3BCB062730; Wed, 29 Jun 2022 11:58:52 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 34767A1777;
        Wed, 29 Jun 2022 11:58:52 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
cc:     netdev@vger.kernel.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: bonding: fix use-after-free after 802.3ad slave unbind
In-reply-to: <20220629012914.361-1-yevhen.orlov@plvision.eu>
References: <20220629012914.361-1-yevhen.orlov@plvision.eu>
Comments: In-reply-to Yevhen Orlov <yevhen.orlov@plvision.eu>
   message dated "Wed, 29 Jun 2022 04:29:14 +0300."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <30285.1656529132.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 29 Jun 2022 11:58:52 -0700
Message-ID: <30286.1656529132@famine>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yevhen Orlov <yevhen.orlov@plvision.eu> wrote:

>commit 0622cab0341c ("bonding: fix 802.3ad aggregator reselection"),
>resolve case, when there is several aggregation groups in the same bond.
>bond_3ad_unbind_slave will invalidate (clear) aggregator when
>__agg_active_ports return zero. So, ad_clear_agg can be executed even, wh=
en
>num_of_ports!=3D0. Than bond_3ad_unbind_slave can be executed again for,
>previously cleared aggregator. NOTE: at this time bond_3ad_unbind_slave
>will not update slave ports list, because lag_ports=3D=3DNULL. So, here w=
e
>got slave ports, pointing to freed aggregator memory.
>
>Fix with checking actual number of ports in group (as was before
>commit 0622cab0341c ("bonding: fix 802.3ad aggregator reselection") ),
>before ad_clear_agg().

	To be clear, what it looks like is going on is that, after
0622cab0341c, we're getting to this point with an aggregator that
contains the port being removed and a non-zero number of inactive ports.
The extant logic is for the "old way" (no inactive ports in an agg), and
presumes that if __agg_active_ports() =3D=3D 0 then the agg is empty, whic=
h
isn't a safe assumption in the current code.

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	-J

>The KASAN logs are as follows:
>
>[  767.617392] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>[  767.630776] BUG: KASAN: use-after-free in bond_3ad_state_machine_handl=
er+0x13dc/0x1470
>[  767.638764] Read of size 2 at addr ffff00011ba9d430 by task kworker/u8=
:7/767
>[  767.647361] CPU: 3 PID: 767 Comm: kworker/u8:7 Tainted: G           O =
5.15.11 #15
>[  767.655329] Hardware name: DNI AmazonGo1 A7040 board (DT)
>[  767.660760] Workqueue: lacp_1 bond_3ad_state_machine_handler
>[  767.666468] Call trace:
>[  767.668930]  dump_backtrace+0x0/0x2d0
>[  767.672625]  show_stack+0x24/0x30
>[  767.675965]  dump_stack_lvl+0x68/0x84
>[  767.679659]  print_address_description.constprop.0+0x74/0x2b8
>[  767.685451]  kasan_report+0x1f0/0x260
>[  767.689148]  __asan_load2+0x94/0xd0
>[  767.692667]  bond_3ad_state_machine_handler+0x13dc/0x1470
>
>Fixes: 0622cab0341c ("bonding: fix 802.3ad aggregator reselection")
>Co-developed-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
>Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
>Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
>---
> drivers/net/bonding/bond_3ad.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3a=
d.c
>index a86b1f71762e..d7fb33c078e8 100644
>--- a/drivers/net/bonding/bond_3ad.c
>+++ b/drivers/net/bonding/bond_3ad.c
>@@ -2228,7 +2228,8 @@ void bond_3ad_unbind_slave(struct slave *slave)
> 				temp_aggregator->num_of_ports--;
> 				if (__agg_active_ports(temp_aggregator) =3D=3D 0) {
> 					select_new_active_agg =3D temp_aggregator->is_active;
>-					ad_clear_agg(temp_aggregator);
>+					if (temp_aggregator->num_of_ports =3D=3D 0)
>+						ad_clear_agg(temp_aggregator);
> 					if (select_new_active_agg) {
> 						slave_info(bond->dev, slave->dev, "Removing an active aggregator\n=
");
> 						/* select new active aggregator */
>-- =

>2.17.1
>
