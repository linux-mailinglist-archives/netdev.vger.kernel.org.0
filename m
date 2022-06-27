Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749B555CDF9
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbiF0RaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 13:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbiF0RaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 13:30:18 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187EC6153
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 10:30:17 -0700 (PDT)
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 7C85F3FC14
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 17:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1656351015;
        bh=SBPhl6XtVXu0MB4Y1vAZhGppyqlKyJ2UmLSWwup7iek=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=ILN6ACZs0iGkGkSfSbIZB786RJZk5PTV/WcGRPJykKAMLKlgv1vPGkexM4BKgrxH/
         sa3g0E0MBf9a47BEkaXZ/pktl/ubFGreu+ei9lWs9hsK+1BY7yq+Xlte/3FBUbVX6r
         fcB0ZRvsDJUg3uUurps+RAs7A2uySCs+RGRk8MUM2d9xsMrtKKQeGrlkko8Aqwt6aq
         HfBnTngg01j06p73Asli8RwmBwz4vG+72DbxKwI9xA1DgR4rBTvSJCY1/5Oy0I15nc
         6jXyawooshjhuzrgXZRD3X0Rw92yInCQgLgbIeJkCStqobE4BToDT5SVV3zdKB1Mnk
         olY6Nh9KHF7Tw==
Received: by mail-pf1-f198.google.com with SMTP id o192-20020a62cdc9000000b00527a9108efaso897127pfg.7
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 10:30:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=SBPhl6XtVXu0MB4Y1vAZhGppyqlKyJ2UmLSWwup7iek=;
        b=MvJt8vVCTdioFWTlIiLoKva4zr3+r3C0N9TfSE1YR914R+GDNCDjg6p5/Z3jf3Iz+U
         LDpkHy1Kf7RKI/ctwf8IueIzFe/5EJSPXbo2/Nv0xLOjbyvzY1OiniLZ1GDmn8J8b5SK
         W07RiBOYYoiCVsmUtkM325X1pq8wJ3YeC4zsvMC+95DhzQ+BdT4AJFAvNzaQWMWJRdcP
         aVtg7mUer5xdc2tJTZHxWgWMM+GZXINtihp6awczgd+353OjU0k4rbiQ96LWY5I4O3hu
         4LVlF3CMy6/I2XnBsXKNqsNLc2JZ4j/6PNFDARVbbN6UfQ1QMWOyu7CMMQ+h9kykwqYs
         mSnQ==
X-Gm-Message-State: AJIora8xFUF1ne0zuHzenFQ6imt9p70GdjDbXmzrZWdmR74D5mvXeoWE
        VX7Bw3qzgBSyOrRrhX96aJ7LlUB1JAhLtcdHtpQjIaMsFZYcV0d/E7/flBcrLRdc8bX/otheCSt
        ifVEomTx5YRQOyFTrOMA0WfeHCL/9fqv2cA==
X-Received: by 2002:a63:ba07:0:b0:40d:77fd:9429 with SMTP id k7-20020a63ba07000000b0040d77fd9429mr14063446pgf.110.1656351013632;
        Mon, 27 Jun 2022 10:30:13 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tzxBo2MJ9idMaXoTeKuJ+jaMAQngG5PO0NLX+jyk0GPfyDDyhN12wFyCkajgN98bcM8vhkdg==
X-Received: by 2002:a63:ba07:0:b0:40d:77fd:9429 with SMTP id k7-20020a63ba07000000b0040d77fd9429mr14063420pgf.110.1656351013329;
        Mon, 27 Jun 2022 10:30:13 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id b16-20020a17090a101000b001eeeb40092fsm1748575pja.21.2022.06.27.10.30.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jun 2022 10:30:12 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 77B0C62730; Mon, 27 Jun 2022 10:30:11 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 70859A1777;
        Mon, 27 Jun 2022 10:30:11 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Eric Dumazet <edumazet@google.com>
cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net] net: bonding: fix possible NULL deref in rlb code
In-reply-to: <20220627102813.126264-1-edumazet@google.com>
References: <20220627102813.126264-1-edumazet@google.com>
Comments: In-reply-to Eric Dumazet <edumazet@google.com>
   message dated "Mon, 27 Jun 2022 10:28:13 -0000."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19682.1656351011.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 27 Jun 2022 10:30:11 -0700
Message-ID: <19683.1656351011@famine>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> wrote:

>syzbot has two reports involving the same root cause.
>
>bond_alb_initialize() must not set bond->alb_info.rlb_enabled
>if a memory allocation error is detected.
>
[...]
>
>Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>Reported-by: syzbot <syzkaller@googlegroups.com>
>Signed-off-by: Eric Dumazet <edumazet@google.com>
>Cc: Jay Vosburgh <j.vosburgh@gmail.com>
>Cc: Veaceslav Falico <vfalico@gmail.com>
>Cc: Andy Gospodarek <andy@greyhouse.net>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>


>---
> drivers/net/bonding/bond_alb.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_al=
b.c
>index 303c8d32d451e24345222ec105a1986d53a94eb4..007d43e46dcb0cb1cee1f2362=
3bd161a6c32a45c 100644
>--- a/drivers/net/bonding/bond_alb.c
>+++ b/drivers/net/bonding/bond_alb.c
>@@ -1302,12 +1302,12 @@ int bond_alb_initialize(struct bonding *bond, int=
 rlb_enabled)
> 		return res;
> =

> 	if (rlb_enabled) {
>-		bond->alb_info.rlb_enabled =3D 1;
> 		res =3D rlb_initialize(bond);
> 		if (res) {
> 			tlb_deinitialize(bond);
> 			return res;
> 		}
>+		bond->alb_info.rlb_enabled =3D 1;
> 	} else {
> 		bond->alb_info.rlb_enabled =3D 0;
> 	}
>-- =

>2.37.0.rc0.161.g10f37bed90-goog
>
