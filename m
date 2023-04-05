Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2D46D746A
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 08:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237072AbjDEGdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 02:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237073AbjDEGdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 02:33:42 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026264693
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 23:33:40 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id n1so17589467ili.10
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 23:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680676419;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FHkayuJtl6xCLTlAQSI4IXA3UYe1TqqY69yR4IhqOlg=;
        b=OAIolssD6kfxsXLgf2OZT3oF2SDY+Gji+GdA4NG+0WiLXxk8RozSj038zYZuqRjkdv
         GSjoeVYKSfQnf4DG3s7PMu7T8m9AVJdDtmEs5o+v16rW+IrGZGZ42WD1skv+/kJtTvNa
         MtLrVFykZPW3/HUl79w0iE5c/tMe9OHaMWMPVznQN1xmbqIkg//xIPSWS3BL3iYJ/rN9
         bSYYm5D1Cmwv45WLAh/CuNYznTjVkLOZ+Ae+yw2QKSEyxVHRKU2Im2kFugcZewz4vEvP
         JG90+KQM2ZmhxtaDvoQhONN4SITGZswB9gli1fFST0QvHrOME8u2rbslHVjiW77Von+0
         8VSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680676419;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FHkayuJtl6xCLTlAQSI4IXA3UYe1TqqY69yR4IhqOlg=;
        b=X2fpyYTvcSTxZR04TSl2hhqWHoaS3IPezkynLDnMMSwBBP+cTXqnnnOJh0RrNEQSJH
         RSgQuojagw3/ul8fM5e52qS7v4guRcHdGD5O2i57LFMgmi9bV3c3wv4cQ2bNsLnLYhFw
         K/1VCwgXvq8Fep32urAw5xhJfPbeo+wgGo+7z4zNASTfxmRk7LkbDh2Omt9903ycvdwe
         NnD8pPa5t6DFsBjd/JmLN7XR+51aY6VxdL0mZIpcuOYYQuPOtK1SlSX9+emeCRY+3CQf
         Ym77xJCqsoqL06sB5i+j84I7xFVAFt0xoDxMzW15X7YihDPR21yyTzHMowC44BkwruVg
         Z1Eg==
X-Gm-Message-State: AAQBX9dpCHHWHHaG8yUw7Cgufb8YMyYvKDiHO0DeFt9+/g5d3d+8hnXU
        jB6EG9821ZKj8SBkpYpSnUI=
X-Google-Smtp-Source: AKy350YvKpDjFidq7hEvPTey/RL01wr5LT91YGn20eqdVaPV0WaVCvvf2GCMmyIJUB0KbExiQ3aM3w==
X-Received: by 2002:a92:6912:0:b0:310:c6f7:c1e9 with SMTP id e18-20020a926912000000b00310c6f7c1e9mr3740697ilc.5.1680676419230;
        Tue, 04 Apr 2023 23:33:39 -0700 (PDT)
Received: from fedora.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id d62-20020a0285c4000000b004089e0b68fbsm3877107jai.12.2023.04.04.23.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 23:33:39 -0700 (PDT)
From:   Maxim Georgiev <glipus@gmail.com>
To:     kory.maincent@bootlin.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: [RFC PATCH v3 5/5] Convert Intel e1000e NIC driver to use ndo_hwtstamp_get/set callbacks
Date:   Wed,  5 Apr 2023 00:33:38 -0600
Message-Id: <20230405063338.36305-1-glipus@gmail.com>
X-Mailer: git-send-email 2.39.2
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

This patch converts Intel·e1000e·NIC·driver·to·use
the newly introduced ndo_hwtstamp_get/set functions to handle
HW timestamp set and query requests instead of implementing
SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs handling logic.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Maxim Georgiev <glipus@gmail.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 29 +++++++++++-----------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 6f5c16aebcbf..207e439b949c 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6161,7 +6161,8 @@ static int e1000_mii_ioctl(struct net_device *netdev, struct ifreq *ifr,
 /**
  * e1000e_hwtstamp_set - control hardware time stamping
  * @netdev: network interface device structure
- * @ifr: interface request
+ * @kernel_config: kernel version of config parameter structure
+ * @extack: netlink request parameters
  *
  * Outgoing time stamping can be enabled and disabled. Play nice and
  * disable it when requested, although it shouldn't cause any overhead
@@ -6174,15 +6175,15 @@ static int e1000_mii_ioctl(struct net_device *netdev, struct ifreq *ifr,
  * specified. Matching the kind of event packet is not supported, with the
  * exception of "all V2 events regardless of level 2 or 4".
  **/
-static int e1000e_hwtstamp_set(struct net_device *netdev, struct ifreq *ifr)
+static int e1000e_hwtstamp_set(struct net_device *netdev,
+			       struct kernel_hwtstamp_config *kernel_config,
+			       struct netlink_ext_ack *extack)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct hwtstamp_config config;
 	int ret_val;
 
-	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
-		return -EFAULT;
-
+	hwtstamp_kernel_to_config(&config, kernel_config);
 	ret_val = e1000e_config_hwtstamp(adapter, &config);
 	if (ret_val)
 		return ret_val;
@@ -6205,16 +6206,18 @@ static int e1000e_hwtstamp_set(struct net_device *netdev, struct ifreq *ifr)
 		break;
 	}
 
-	return copy_to_user(ifr->ifr_data, &config,
-			    sizeof(config)) ? -EFAULT : 0;
+	hwtstamp_config_to_kernel(kernel_config, &config);
+	return 0;
 }
 
-static int e1000e_hwtstamp_get(struct net_device *netdev, struct ifreq *ifr)
+static int e1000e_hwtstamp_get(struct net_device *netdev,
+			       struct kernel_hwtstamp_config *kernel_config,
+			       struct netlink_ext_ack *extack)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
-	return copy_to_user(ifr->ifr_data, &adapter->hwtstamp_config,
-			    sizeof(adapter->hwtstamp_config)) ? -EFAULT : 0;
+	hwtstamp_config_to_kernel(kernel_config, &adapter->hwtstamp_config);
+	return 0;
 }
 
 static int e1000_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
@@ -6224,10 +6227,6 @@ static int e1000_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 	case SIOCGMIIREG:
 	case SIOCSMIIREG:
 		return e1000_mii_ioctl(netdev, ifr, cmd);
-	case SIOCSHWTSTAMP:
-		return e1000e_hwtstamp_set(netdev, ifr);
-	case SIOCGHWTSTAMP:
-		return e1000e_hwtstamp_get(netdev, ifr);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -7365,6 +7364,8 @@ static const struct net_device_ops e1000e_netdev_ops = {
 	.ndo_set_features = e1000_set_features,
 	.ndo_fix_features = e1000_fix_features,
 	.ndo_features_check	= passthru_features_check,
+	.ndo_hwtstamp_get	= e1000e_hwtstamp_get,
+	.ndo_hwtstamp_set	= e1000e_hwtstamp_set,
 };
 
 /**
-- 
2.39.2

