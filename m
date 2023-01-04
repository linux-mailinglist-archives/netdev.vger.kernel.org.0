Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A4B65CD22
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 07:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbjADGfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 01:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbjADGfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 01:35:15 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA8714017;
        Tue,  3 Jan 2023 22:35:14 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id c9so17276002pfj.5;
        Tue, 03 Jan 2023 22:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5i2PAsadZxre+fZA40ApSOO4k6rDBMhHG9OHUSd1jK0=;
        b=gAU5b++TyEBAGOOaOjV+IHnXy9gGfUTiYm9Ah5+13Veoa4PyVgvxtlUrJbzk1V5sa8
         AcmbmoM63BK7EcMazLZ+5+ksoUUBV4oKeYdzfMi/cjQJlqjA+Ozr1k/UUT0bugDyccfv
         Ws5ridHBCE+02PZxSg8qgC+RdpMVR7YW8LaNn4UAUqkUlTRVO426XC2NlSmJ0QoDZWbG
         UbtWr4etQF+jokXd1g4um6O/bTDPKAK2WoE1WcQ7lxR2KB1+gyC3PkD5y7vkWifaubjb
         jtvlU7Uq0JfA4iU1+NqoukvI0jAXDKOszVV7xPRs4BDXNHp6N9caWLIzFyo86ylzz7dn
         P9JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5i2PAsadZxre+fZA40ApSOO4k6rDBMhHG9OHUSd1jK0=;
        b=w1lqCgewXT7EUqUNCW1bHjtvArWbrdRxQP696NhRtUHIhS7dAjjgm/93BvW58qKXls
         WO5l2dsuYfi6Hz87Zvwi1uTumgDdtr8JV3QbeC1BVNy2ta1/4p4Y0Qhsa/H7oaGn4uiI
         vS/cuG22SclnHQdx400jS2pAIfC67WijgPvmoRwsAe5WdLC/fu3JZmLFt3CbzKntoJSF
         jgTj1HeUdVwU5RdV30SOqUwCfexcU2KfX2d7Z1ohg3GIh7+arAWU5vsaBowjFpcIDOX3
         s5alXgg7ywNnh25jr5bSYUjVfsDRps7QsFxzHT0fZX/9Wqk8F+Zy24OvrUJvltXRR0Ll
         /7/A==
X-Gm-Message-State: AFqh2kqTp/GDGhKotQqrdAMioV0LD/lmZ4WJRfCB0y9mnE1DrCJQxsAM
        kq+STjhhfyiOIRPGORJAaKnS2nVIdHAYirpU
X-Google-Smtp-Source: AMrXdXvi6Dj8Q8jPRtltXyZIDqYzpi3IkyqsCHG995ldQ2iwyBQ2irb4AHPBwcV/AwV9CgE0Jc2w3A==
X-Received: by 2002:a05:6a00:21ce:b0:581:26c2:aa0a with SMTP id t14-20020a056a0021ce00b0058126c2aa0amr43392435pfj.30.1672814112856;
        Tue, 03 Jan 2023 22:35:12 -0800 (PST)
Received: from guoguo-thinkbook.lan ([240e:379:964:5365:9621:efdc:4c9e:b465])
        by smtp.gmail.com with ESMTPSA id 67-20020a621446000000b0056d98e359a5sm20378439pfu.165.2023.01.03.22.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 22:35:11 -0800 (PST)
From:   Chuanhong Guo <gch981213@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Chuanhong Guo <gch981213@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Deren Wu <deren.wu@mediatek.com>,
        YN Chen <YN.Chen@mediatek.com>,
        Ben Greear <greearb@candelatech.com>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] wifi: mt76: mt7921u: add support for Comfast CF-952AX
Date:   Wed,  4 Jan 2023 14:33:38 +0800
Message-Id: <20230104063341.18863-1-gch981213@gmail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Comfast CF-952AX is a MT7921 based USB WiFi dongle with custom
VID/PID. Add an entry for it.

Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
index 5321d20dcdcb..a0778ecdb995 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
@@ -15,6 +15,9 @@
 static const struct usb_device_id mt7921u_device_table[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0e8d, 0x7961, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)MT7921_FIRMWARE_WM },
+	/* Comfast CF-952AX */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x3574, 0x6211, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t)MT7921_FIRMWARE_WM },
 	{ },
 };
 
-- 
2.39.0

