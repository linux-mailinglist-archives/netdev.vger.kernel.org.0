Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753B25B558C
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 09:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiILHvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 03:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiILHvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 03:51:19 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E3F220D8
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 00:51:17 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so7387442pjl.0
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 00:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=pY3PEbiyJD1wlLqK+op8vAenQPbd+RIV3Kd0VGnjuCU=;
        b=P3SockaQDi64Vng61svYIhOVwbqsGNw0v2dFWX5si6/Rc0RWVgU7cKnVSQ/Cic81bQ
         T2yKuFHiBUZGS/oSXUxuUETPycexOF2KWgxv5jaWo1ekQc1Bx8YKFpXZODsScupBTG2b
         WOIKh4ZIjElPltVHiiaF63GF2mOiAyteU5ub1I7QDa/mYwqKZeg2pAeB7cA5wean6ENx
         7ciGm64QK/T5sx/NjRaxIqGLY+jKXaV5SI2LjoH21ASH/Z/0I3H4UN+WpjQmUSiwZk9F
         Kpv55TeYePMpQhD1GCAL+A5Lo6s273DqV+7UpN+8eJyQOMYjDQI9+rkNtHiFfTQL+Pwd
         5ptw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=pY3PEbiyJD1wlLqK+op8vAenQPbd+RIV3Kd0VGnjuCU=;
        b=xwLxSA8lhkAlzX0R58p8WpQOHf9+m22yvv3oPpxT9cbGYjCsMZMw/KWGG34gK3XmqC
         WhxrO8C/amAJut8LuXxD3S3iEWN4cclGRZdLQJ8pEQXdD4ZzmWsMgBAnb5cSZb7c56+D
         Kx7GfFBHXZpY7AWL0MJZ1Ha3pF61QLBpa6UZ3ElgzyBADnnT5cKZJGXVQUTYSiqeQrmE
         GFnKjUzJrE3D6ZFX4yo6Rf//nWsOP/wVAcZkHuJkOWCpxdnWacoV7CUfH82XYqcuAUNQ
         dRVDiNcExsEYP2q8FDrrOZAH8mVpZV/uv4doQDe2jHKJT7PkXgjNETDr57+fl+5JgJeI
         oyUQ==
X-Gm-Message-State: ACgBeo3IzyWT2m4OEyTnCCKaJrZI5hShhAK2qO8CdgKsC8xkWIzEQ4Lz
        Ibnlm7mgzykyCRLjt5P2XPw=
X-Google-Smtp-Source: AA6agR5pJevmpwZir1fjf75gK5sv4hfNv++rHloCUn15o27E5cmL9TkQ608//55KlW2ldye9nN2LUA==
X-Received: by 2002:a17:90b:4acd:b0:202:e381:e650 with SMTP id mh13-20020a17090b4acd00b00202e381e650mr707543pjb.204.1662969076568;
        Mon, 12 Sep 2022 00:51:16 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id y12-20020aa78f2c000000b0053e78769470sm4648277pfr.88.2022.09.12.00.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 00:51:13 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.panda@zte.com.cn
To:     woojung.huh@microchip.com
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, netdev@vger.kernel.org,
        Xu Panda <xu.panda@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] net: dsa: microchip: remove the unneeded result variable -------------------------------------------------------------------------
Date:   Mon, 12 Sep 2022 07:50:46 +0000
Message-Id: <20220912075045.17060-1-xu.panda@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Panda <xu.panda@zte.com.cn>

Return the value ksz_get_xmii() directly instead of storing it in
another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
---
 drivers/net/dsa/microchip/ksz9477.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 42d7e4c12459..ab7245b24493 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -884,7 +884,6 @@ void ksz9477_port_mirror_del(struct ksz_device *dev, int port,

 static phy_interface_t ksz9477_get_interface(struct ksz_device *dev, int port)
 {
-       phy_interface_t interface;
        bool gbit;

        if (dev->info->internal_phy[port])
@@ -892,9 +891,7 @@ static phy_interface_t ksz9477_get_interface(struct ksz_device *dev, int port)

        gbit = ksz_get_gbit(dev, port);

-       interface = ksz_get_xmii(dev, port, gbit);
-
-       return interface;
+       return ksz_get_xmii(dev, port, gbit);
 }

 static void ksz9477_port_mmd_write(struct ksz_device *dev, int port,
-- 
2.15.2

