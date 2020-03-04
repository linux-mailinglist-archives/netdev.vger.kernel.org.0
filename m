Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9C7A17897A
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 05:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgCDEUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 23:20:30 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44342 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727725AbgCDEU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 23:20:29 -0500
Received: by mail-pf1-f196.google.com with SMTP id y26so264829pfn.11
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 20:20:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=61gZ4SQN/1tdeU8RQk3DcrIUxl3TSrJNCIjlf4zlDM0=;
        b=DHb23UfRr/fiJv5qGnRFaJ1wMjsOPnKEsetj6f1VRGxCNAnpsgA1EpLN+MXw55P3zp
         YTrmcvuvpn2kf/cYszileF8CW3fk7nKR27kIvkPSb7NBajnBbC5tT1ZZgjG5CyreL/HZ
         DY/g8ie+r6w7/Tc1H5FuY3QjKANbno8LHNGz2RxkajY7kj/Dgr2CLJvLodjMIs7V0wG9
         Xlh1MVgY9ecz2gqothladDC0ME6+mKm31UbI5uJv7O0EHr/Gty0ejVbSw1QHZ6hFM9OS
         qc+h1qoDUEeQNUWRV5JJacnWvRhC0hrEM+eD0FSpHqHbDDfdS2vkaln0igs5EkubzOfE
         +zNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=61gZ4SQN/1tdeU8RQk3DcrIUxl3TSrJNCIjlf4zlDM0=;
        b=sAe/Ddt1yS9iecgsldcSTGlOXeoBoUV+KgPsGPtd/lbqFad7nGh+6PAWcPycs1gAun
         jlQ74bRiR7jZwQgW9BtHsVRiJSSvxbVUXYyUpVYldJPE2ROszEV4C2hvt8jEXz38PHN/
         Rsz+1RWMbXJqAilqo2m6bZv2WjYRjE0fMGmCVxPAUxd4eJw7xe3fgohVWsAZox5sWRZD
         MZ+wqXdGY17uOKX6YUOHpNW47PuPfRvBXpqZIckvrNPllGqRsE5yZwfb09Qdq2l0g7WS
         kMBeeTxu4KJfDJE6c6flTrHLMmLGTN0Io+AldnPpqCv+j4Y+k2WanEPoJ4NVKXEgaqE7
         MdPw==
X-Gm-Message-State: ANhLgQ1Tib+sOZfBFazxm+HeyXkET5aU+HSK7kCrVenqm3KqgR+iMWn6
        kxf9r/KlVeiVcXgkf2E9onlxWST2c8Y=
X-Google-Smtp-Source: ADFU+vv51Alsd1d1sy9IgYfRMUobkFuv32eyTCUIVo2/zN6C6D2m6NhRDtOXkFEr3/N8XLuoyIihHg==
X-Received: by 2002:a62:e10b:: with SMTP id q11mr1247791pfh.48.1583295628156;
        Tue, 03 Mar 2020 20:20:28 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c2sm671702pjo.28.2020.03.03.20.20.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Mar 2020 20:20:27 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 7/8] ionic: add support for device id 0x1004
Date:   Tue,  3 Mar 2020 20:20:12 -0800
Message-Id: <20200304042013.51970-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200304042013.51970-1-snelson@pensando.io>
References: <20200304042013.51970-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for an additional device id.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h         | 1 +
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index bb106a32f416..c8ff33da243a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -18,6 +18,7 @@ struct ionic_lif;
 
 #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF	0x1002
 #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF	0x1003
+#define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT	0x1004
 
 #define DEVCMD_TIMEOUT  10
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 59b0091146e6..3dc985cae391 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -15,6 +15,7 @@
 static const struct pci_device_id ionic_id_table[] = {
 	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF) },
 	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF) },
+	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT) },
 	{ 0, }	/* end of table */
 };
 MODULE_DEVICE_TABLE(pci, ionic_id_table);
-- 
2.17.1

