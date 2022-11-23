Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9A1635073
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 07:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbiKWGZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 01:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234151AbiKWGZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 01:25:28 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4E5E8712
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 22:25:26 -0800 (PST)
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id EC89D3F10B
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1669184723;
        bh=PDl3MXmZUkgPXUvqF2eBNhOB/cXRKHs/BmNMouA44GY=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=FfpRQ2qFU++mgdxzLuhGPCGgayhX3mS+IBLRsmJhinJG7VICEaOjmiY4+8ZY3rxSd
         0gB8IkMU7+4Dqnpkc9P8fdXdakn+9VF3O9vU6j7jGXPcH0IiAI+guu7hlb7bL+rkH1
         Pg5R6W9Z7NEiYhqd3fA8pQDBuuuBY347Hyx2gcgznZ4VZsrl1ZCKTYbekA/gX5NrUQ
         bmTlh665EaEjuigy9V8cN9F21q1x0LSoiQKJImOsxGO62wyDJ8pu/tgVMPgfG6Ww4h
         ObDRa5/AQeSCALMMqOGx6KYGfCact+p30Rhyhm3onwxxAQax4JtiYBxHdHMORUNNXi
         KtdLMsdR/8daA==
Received: by mail-pf1-f197.google.com with SMTP id v16-20020a62a510000000b005745a58c197so401619pfm.23
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 22:25:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PDl3MXmZUkgPXUvqF2eBNhOB/cXRKHs/BmNMouA44GY=;
        b=ttDsFo9olHvPoEA8NJAozG0S7xMLXR6Gh5Lpcg71nryGjYVRKdypGH8FAljLICUb3o
         xdPjedt7gdH68iSCD6riuxJajoB46F3IvVPFFQIZV1+zYB76d9WkEfoNEEepTrN9VAhg
         qn9IZM/fsep68l9Nlcw3Q6mdSxhGo2MdmAc79IvBAiTQCzhcpU9lx5llZlr/+nj+lq0h
         Nu3o3K7ghRP1HzbtzZG85zmbmXMSIW6Yye2MsIjd2lbWXsTJYl+vLf3D30Va1NNC8d+1
         h7YwNAnPTLt+i9nvvEq4dH4/+ICCwnEQ2ZcR/Mse/HFZtp1IiwbRKLZfvGIBYdM51faj
         xBbA==
X-Gm-Message-State: ANoB5pkXjrFnqorKeyrV8iNH4eSWHXsERJJAt/qGUQ5N8Tgliro23mw7
        6zNAsTzYqlI8Zoq8eF1IuMnf3trl4vnt0x95Zs/lI8+x+gOr3sKoV/AemomN7v/98mVvou+Mt7+
        F3C/9UsLVS4QTJSTxvfTs9cLj1c4TEJKj5w==
X-Received: by 2002:a63:2361:0:b0:45f:f8df:108e with SMTP id u33-20020a632361000000b0045ff8df108emr6317140pgm.127.1669184722358;
        Tue, 22 Nov 2022 22:25:22 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7nd/MQDtV/srPXjw6ht/7Z47hpE4PbOHAoikeMRgxMR4MkJlpnWr4CFP0wQNYOoMYc5vu+6w==
X-Received: by 2002:a63:2361:0:b0:45f:f8df:108e with SMTP id u33-20020a632361000000b0045ff8df108emr6317122pgm.127.1669184722060;
        Tue, 22 Nov 2022 22:25:22 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id t3-20020a625f03000000b0056c3d3f5a8dsm11736698pfb.56.2022.11.22.22.25.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Nov 2022 22:25:21 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 601845FF10; Tue, 22 Nov 2022 22:25:20 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 58168A02BA;
        Tue, 22 Nov 2022 22:25:20 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
cc:     "netdev @ vger . kernel . org" <netdev@vger.kernel.org>,
        pabeni@redhat.com, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] bonding: fix link recovery in mode 2 when updelay is nonzero
In-reply-to: <f5a7893d8a83c6fb8233bb3127d301e12f45e9b3.1669147951.git.jtoppins@redhat.com>
References: <cover.1669147951.git.jtoppins@redhat.com> <f5a7893d8a83c6fb8233bb3127d301e12f45e9b3.1669147951.git.jtoppins@redhat.com>
Comments: In-reply-to Jonathan Toppins <jtoppins@redhat.com>
   message dated "Tue, 22 Nov 2022 16:24:29 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15929.1669184720.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 22 Nov 2022 22:25:20 -0800
Message-ID: <15930.1669184720@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Toppins <jtoppins@redhat.com> wrote:

>Before this change when a bond in mode 2 lost link, all of its slaves
>lost link, the bonding device would never recover even after the
>expiration of updelay. This change removes the updelay when the bond
>currently has no usable links. Conforming to bonding.txt section 13.1
>paragraph 4.
>
>Fixes: 41f891004063 ("bonding: ignore updelay param when there is no acti=
ve slave")
>Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>

	This looks correct, although I suspect it would affect more than
just balance-xor ("mode 2"); if memory serves, balance-rr mode operates
similarly.

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	-J

>---
>
>Notes:
>    v2:
>     * added fixes tag and reposted to net tree
>
> drivers/net/bonding/bond_main.c | 11 ++++++++++-
> 1 file changed, 10 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index f298b9b3eb77..f747bd60d399 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -2536,7 +2536,16 @@ static int bond_miimon_inspect(struct bonding *bon=
d)
> 	struct slave *slave;
> 	bool ignore_updelay;
> =

>-	ignore_updelay =3D !rcu_dereference(bond->curr_active_slave);
>+	if (BOND_MODE(bond) =3D=3D BOND_MODE_ACTIVEBACKUP) {
>+		ignore_updelay =3D !rcu_dereference(bond->curr_active_slave);
>+	} else {
>+		struct bond_up_slave *usable_slaves;
>+
>+		usable_slaves =3D rcu_dereference(bond->usable_slaves);
>+
>+		if (usable_slaves && usable_slaves->count =3D=3D 0)
>+			ignore_updelay =3D true;
>+	}
> =

> 	bond_for_each_slave_rcu(bond, slave, iter) {
> 		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
>-- =

>2.31.1
>
