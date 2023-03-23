Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B97B6C6E50
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 18:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjCWRCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 13:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbjCWRCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 13:02:48 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97F2C5;
        Thu, 23 Mar 2023 10:02:47 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id o32so7669462wms.1;
        Thu, 23 Mar 2023 10:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679590966;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=78162z2b+7J2782qQmRV4fn9t8VnH20Ib+aduU/6V3k=;
        b=J13+tDu5xI1wTUKdJDVWtGTV3JdgcSXGLW8wCXRqnorkhmz+HTQSBqIFvBkx2vMW59
         9urUNz8+IknJoNd+zp+J+OCqR69eXWqEJufvXoHCSq+vB/hIpb06dhSJAaEdBG8wQJFG
         hdq9eORqtNTPbnNhZn/xmH0RhvGEJB1NvbfFKsYkNhHC2sDbr9UzPk05SPOzLLnWFoZS
         mRgMVQlFuRDtOd8fcqil5q/gf6uVw8MSzB7vsBg04Sz7K6o9zxWIaUjZcHHbuhP/G5e8
         VO2Asj0wRjg/NDmgxH5Qlg2eVFM4Vjv28i9rULYDq87spUfMEulcntr39+Vcxd7KLtzD
         GJGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679590966;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=78162z2b+7J2782qQmRV4fn9t8VnH20Ib+aduU/6V3k=;
        b=dpAKuHQM78dDGsayqNETVNjuy9n+NnwjWVOeLiXLGf2P20qRXQ2IgQ3vqUZMW2Pa0e
         MsY2T5a74eiBJDyQBfly5pBw4lN4s9/yZkqXiNL2L7xA0JWe3T28G5CP/+ghKKLW8Pbm
         XfyJCRxcCKGyyyC3bSW2IOjEEk0zVuiM2TAsmL+bWMv5hXjbfuAcVFjueHrRJGn0ZxF6
         93XNGwWR/5OZrMzrtoFDI6mCTZPfqilgTccLPsc0JF+V6+LfFD/SotyacWSC9Jh07sQ7
         9KeYfb1BM0AWoAEsu5HVrbj3FyTeYdQYGpOlYbfLQeUiWxbZQ79HlQXvbK7B8aHM+iuC
         /VRA==
X-Gm-Message-State: AO0yUKX11CtQJg2dVW8ke79LQrOMLffsjiYleFYDAuxd155/Dh+SHOm7
        J0ftGR5hXrHosIF8mUqdH4P2Rmd1+0OlozGB
X-Google-Smtp-Source: AK7set+rOcEVq79fdpx5VsUlkztT9/kZy/0Npsm8TsyH9Aby3fmJsFpsL2//WHPqMA7F0SkY43Eajw==
X-Received: by 2002:a1c:f606:0:b0:3ee:8e3d:4b7a with SMTP id w6-20020a1cf606000000b003ee8e3d4b7amr199324wmc.39.1679590965943;
        Thu, 23 Mar 2023 10:02:45 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id a2-20020a05600c224200b003ee63fe5203sm2395778wmm.36.2023.03.23.10.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 10:02:45 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     f.fainelli@gmail.com, jonas.gorski@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH 0/1] net: dsa: b53: mmap: add dsa switch ops
Date:   Thu, 23 Mar 2023 18:02:37 +0100
Message-Id: <20230323170238.210687-1-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

B53 MMAP switches have a MDIO Mux bus controller which should be used instead
of the default phy_read/phy_write ops used in the rest of the B53 controllers.
Therefore, in order to use the proper MDIO Mux bus controller we need to
replicate the default B53 DSA switch ops removing the phy_read/phy_write
entries.
Without this, when external switches are configured together with B53 MMAP
internal switches the device will hang on phy_read/phy_write ops.

This is an alternative to:
- https://patchwork.kernel.org/project/netdevbpf/cover/20230317113427.302162-1-noltari@gmail.com/
- https://patchwork.kernel.org/project/netdevbpf/patch/20230317113427.302162-2-noltari@gmail.com/
- https://patchwork.kernel.org/project/netdevbpf/patch/20230317113427.302162-3-noltari@gmail.com/
- https://patchwork.kernel.org/project/netdevbpf/patch/20230317113427.302162-4-noltari@gmail.com/
As discussed, it was an ABI break and not the correct way of fixing the issue.

And also to:
- https://patchwork.kernel.org/project/netdevbpf/patch/20230320182813.963508-1-noltari@gmail.com/

Álvaro Fernández Rojas (1):
  net: dsa: b53: mmap: add dsa switch ops

 drivers/net/dsa/b53/b53_common.c | 22 +++++++++---------
 drivers/net/dsa/b53/b53_mmap.c   | 40 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/b53/b53_priv.h   | 11 +++++++++
 3 files changed, 62 insertions(+), 11 deletions(-)

-- 
2.30.2

