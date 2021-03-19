Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2F034119D
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 01:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbhCSAt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 20:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbhCSAsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 20:48:53 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725DCC06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 17:48:53 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id v2so2552302pgk.11
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 17:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DjbQqNDuT2ROMaS4/zyuviHOW40z0MnWjplzC78XgvA=;
        b=NZp03VOsce0LNT7U+VhPE5/94kf4mjWmPl7GhjgK/JCGJzIZfH9/cyiSrIDhgOSrSh
         UFic+edlrKjRHbQhU22n30XL/KhfcWJAGZXQMCZcyoBlm0Ns4xc/kOzBQMKXVg5LLFbT
         buFF0icbWF3sW80KZ2NJGqrVocDA6P52UmPArx8dFp2wUqyDkVAVHE5FjjF46CWpHtmL
         pjP3QHj13K+MwavucCfnUQZ6AqohfYLgZhpmxiBp1WDbqd34B9NLt9oXCUr5CWi8kAzN
         y6SBAYT7hcOizP/PLolDwvvZspWw2xJ7UcGXHqusagyLjWDZzqIFzZgiK3FswH4DelyF
         SrdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DjbQqNDuT2ROMaS4/zyuviHOW40z0MnWjplzC78XgvA=;
        b=YtHv4bs3AAHzxO3uB6gbubNvf/stxHf8rYYWCADpJDZYALnldprj8SIihstw6LNFS5
         oT0jpXkLDr/m5CBhDalIWfo4R3q/GIEY5Ccyc2XA8dY93k8rcl1CLwvz1gTwWm55KKgv
         TdGv5D8b6aG255NYsimKU4mJNOqQQ7m48kCStZThKX8p9S3AHKcqNEBHrQCQNi4MJcq1
         YzB9t1ZsaWZCTSuOZ+1niWTBVOplppuZdIVGzDdKwkGynPg5sokuwk9X8F0dtbEcH6dt
         s6LjkfpH71Twf/MT+mkt9qGddEWvvwZHIrWlHtMjJ2ar5DiaTymg171jLgkj2YEAP9/v
         3hWw==
X-Gm-Message-State: AOAM533H3TsQmqHd8lSuQBtCA1YtNViCdXx6vPG2oOiU9FLLI/d77DGJ
        /9TUav2dDzDKrUTr8xZZfk249avE6lRzaw==
X-Google-Smtp-Source: ABdhPJwwu8VNBx2LgvkMOpoyMAeIx5z4ch80G/tmQseZP+342cVHKH+/GU3ibqQRE+mc+XCMa7K7rw==
X-Received: by 2002:a63:520e:: with SMTP id g14mr9091089pgb.350.1616114932743;
        Thu, 18 Mar 2021 17:48:52 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id i7sm3592949pfq.184.2021.03.18.17.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 17:48:52 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/7] ionic: update ethtool support bits for BASET
Date:   Thu, 18 Mar 2021 17:48:07 -0700
Message-Id: <20210319004810.4825-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210319004810.4825-1-snelson@pensando.io>
References: <20210319004810.4825-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support in get_link_ksettings for a couple of
new BASET connections.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 8 ++++++++
 drivers/net/ethernet/pensando/ionic/ionic_if.h      | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 9df4b9df7a82..b1e78b452fad 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -207,6 +207,14 @@ static int ionic_get_link_ksettings(struct net_device *netdev,
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     10000baseER_Full);
 		break;
+	case IONIC_XCVR_PID_SFP_10GBASE_T:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     10000baseT_Full);
+		break;
+	case IONIC_XCVR_PID_SFP_1000BASE_T:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     1000baseT_Full);
+		break;
 	case IONIC_XCVR_PID_UNKNOWN:
 		/* This means there's no module plugged in */
 		break;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index 40bd72bb5148..88210142395d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -1111,6 +1111,8 @@ enum ionic_xcvr_pid {
 	IONIC_XCVR_PID_QSFP_100G_CWDM4  = 69,
 	IONIC_XCVR_PID_QSFP_100G_PSM4   = 70,
 	IONIC_XCVR_PID_SFP_25GBASE_ACC  = 71,
+	IONIC_XCVR_PID_SFP_10GBASE_T    = 72,
+	IONIC_XCVR_PID_SFP_1000BASE_T   = 73,
 };
 
 /**
-- 
2.17.1

