Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A69769C11B
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 16:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjBSPEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 10:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjBSPEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 10:04:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3806EC69
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 07:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676819012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=l5O7cDrniZeFvFtupLPAJc4Ul8TEw28vVrb3ohN5kOQ=;
        b=bHAZAIdYq1GOPMxCemT+s3hTBHiNp5I1QH0H6Eyxa6Ftwm0iKxzzG4mV1KqDlJwtwG18oU
        M3FYXIvDWYFB77rb9dKS1vaMMct5boruWV3X7dFfTZt9AaGWTnWenwHi4KS8zH5XKpgqt/
        yFxK89uBZpEdnVEYC/V1colratZXPoU=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-281-KWddo9MHPnCtfDODtMGzxw-1; Sun, 19 Feb 2023 10:03:30 -0500
X-MC-Unique: KWddo9MHPnCtfDODtMGzxw-1
Received: by mail-qt1-f199.google.com with SMTP id f17-20020ac86ed1000000b003ba0dc5d798so127172qtv.22
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 07:03:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l5O7cDrniZeFvFtupLPAJc4Ul8TEw28vVrb3ohN5kOQ=;
        b=fLN9FgFLYT9Txp7b6+yOu45Z8+h1BLLz/Q5bNQIxhLHNyMBu411xfcoWjxzHbHeG2k
         CNFUqgytNkFeEDcTzd9RI3u9827r/CGBSD9HZXSmySOQz0gdNSQZq5AFft/0CYg+vv6T
         PDLcnvPWPwL2MtBv4+LVcaW5CpJW6JDLFJK4Xjc/4Vbirq1+14dWH+TfAJchY5aMVgTd
         Ya3G7Aht6kZWzo/OV60VTgke6bP+IG/E51hV9I778GKNwUDQymlVpobqg1j3ZQCPvD2P
         mFdhy0bW9DUEz0U9MwH1z7bD76myV5C0RfcRf3ywWFcc6YeqVAY7RA/g+xHx29Y2LRtY
         d/fA==
X-Gm-Message-State: AO0yUKWZcaWRaXEfzyRzAKXO0GM/bW4dUmh7iAEyieHUudL6PIBjlme9
        R6lK3PkuJId/hKx88wVhMZBXLo0+MJNvmfYWKld+8FlEZzJeJ8fQ6Bc2v9J9QqTgrzvJoNQWA4q
        ckRlcM1g3j55lF1/7
X-Received: by 2002:a05:622a:144d:b0:3b9:b6e8:8670 with SMTP id v13-20020a05622a144d00b003b9b6e88670mr12947077qtx.51.1676819010075;
        Sun, 19 Feb 2023 07:03:30 -0800 (PST)
X-Google-Smtp-Source: AK7set8U9Iw+Lndvx14dBnuen6iJOmQqqb2ayZt99BzZlUBhJzaOxvzFOxW7u10HqbK+TCNp7bEUDg==
X-Received: by 2002:a05:622a:144d:b0:3b9:b6e8:8670 with SMTP id v13-20020a05622a144d00b003b9b6e88670mr12947042qtx.51.1676819009857;
        Sun, 19 Feb 2023 07:03:29 -0800 (PST)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id a4-20020ac84344000000b003b2957fb45bsm7230258qtn.8.2023.02.19.07.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Feb 2023 07:03:29 -0800 (PST)
From:   Tom Rix <trix@redhat.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steen.hegelund@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] net: lan743x: LAN743X selects FIXED_PHY to resolve a link error
Date:   Sun, 19 Feb 2023 10:03:21 -0500
Message-Id: <20230219150321.2683358-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A rand config causes this link error
drivers/net/ethernet/microchip/lan743x_main.o: In function `lan743x_netdev_open':
drivers/net/ethernet/microchip/lan743x_main.c:1512: undefined reference to `fixed_phy_register'

lan743x_netdev_open is controlled by LAN743X
fixed_phy_register is controlled by FIXED_PHY

So LAN743X should also select FIXED_PHY

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/microchip/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microchip/Kconfig b/drivers/net/ethernet/microchip/Kconfig
index 24c994baad13..43ba71e82260 100644
--- a/drivers/net/ethernet/microchip/Kconfig
+++ b/drivers/net/ethernet/microchip/Kconfig
@@ -47,6 +47,7 @@ config LAN743X
 	depends on PCI
 	depends on PTP_1588_CLOCK_OPTIONAL
 	select PHYLIB
+	select FIXED_PHY
 	select CRC16
 	select CRC32
 	help
-- 
2.27.0

