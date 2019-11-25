Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1282210909C
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 16:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbfKYPCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 10:02:38 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36980 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbfKYPCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 10:02:38 -0500
Received: by mail-pl1-f195.google.com with SMTP id bb5so6626461plb.4;
        Mon, 25 Nov 2019 07:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fv51DMlGqD9FZ0x4Yb8tL4M0VywmGrWikcN80HTtJdA=;
        b=WuaDVCRbHsNBI7cbjw0qGEdEbLgVwhHuCIPdGqz6CU04Dn2ka7qrLYsCctyqT2dn4i
         4sxIUGhOh4Z7yDAYbdDNOXEBr1Sdh7rn/rG0MVUMIvoSBsR90XAB550tN708jrwvPK9S
         Rc22k6WXaMYA4SCbhmDHLiPHPRHEccjxJj1vU4E914qTFhrtOKaoZvDcsDDylC2S8u3x
         509HHdf+/3t9yQpxiuLng0HpVRK+XJNe+2EKKiVxSCVNmesHPrgyJ0JoGvlgcGemEiBY
         vFKisLTthZe2e5H4P9YMAkZZrRhBZ6fM8F2zykYGhvq6DDfkKflql7avU6sCFcQScub2
         N0lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fv51DMlGqD9FZ0x4Yb8tL4M0VywmGrWikcN80HTtJdA=;
        b=mQz/+hdpB6OnfoUnaSg/PjLH1VgoTma8dXm1bP/ozZMAlMF4Lk0bKgkJvY07rwLZ68
         vUCVRc8FCf0TPlZEMscFnWDd8ENSmIoMbrdutDNuhmcgBZ7VDhmyWQzmlgWSFyBjo+fL
         7KPBNj1y/HXjVejt2Ozh8D4KaYRZDbZwRHW8sMrdOIAW0h11VspN9psOtKv2A4/zk+6y
         f7r7qI3m00cqRmNFgKToYT8e1Ju7q+a9cbMndpQKta+jRbtM1CIeUmz08s9oNU4LBTcf
         FW5GmzzMfDJEl4oSUtMo84axt7p90s6DfV49h4GT8J5P7Pe3pfyiXkwyDvlGj8xIDAiI
         PE4w==
X-Gm-Message-State: APjAAAVoZivQpHU82ELkvD1HWAWcKjYOBkpxYVtxppdYKYyQQsCkBW4G
        UIhKMMJZS5kNe6c5O48VFKw=
X-Google-Smtp-Source: APXvYqwGrICoGWUIz7PHdsxCgovxW2MXZv5ELAIKNNKuchBK2hfT8s7qiX89Ps3vDLHF6ZTqw/JCpg==
X-Received: by 2002:a17:902:fe12:: with SMTP id g18mr18547888plj.20.1574694155434;
        Mon, 25 Nov 2019 07:02:35 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:550c:6dad:1b5f:afc6:7758])
        by smtp.gmail.com with ESMTPSA id x2sm8703129pfn.167.2019.11.25.07.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 07:02:34 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     jakub.kicinski@netronome.com, kvalo@codeaurora.org,
        davem@davemloft.net, luciano.coelho@intel.com,
        shahar.s.matityahu@intel.com, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, sara.sharon@intel.com,
        Larry.Finger@lwfinger.net, yhchuang@realtek.com,
        yuehaibing@huawei.com, pkshih@realtek.com,
        arend.vanspriel@broadcom.com, rafal@milecki.pl,
        franky.lin@broadcom.com, pieter-paul.giesberts@broadcom.com,
        p.figiel@camlintechnologies.com, Wright.Feng@cypress.com,
        keescook@chromium.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH 2/3] drivers: net: intel: Fix -Wcast-function-type
Date:   Mon, 25 Nov 2019 22:02:14 +0700
Message-Id: <20191125150215.29263-2-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191125150215.29263-1-tranmanphong@gmail.com>
References: <20191125150215.29263-1-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

correct usage prototype of callback in tasklet_init().
Report by https://github.com/KSPP/linux/issues/20

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c   | 7 ++++---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c   | 5 +++--
 drivers/net/wireless/intel/iwlegacy/3945-mac.c | 5 +++--
 drivers/net/wireless/intel/iwlegacy/4965-mac.c | 5 +++--
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 8dfbaff2d1fe..a162146a43a7 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -3206,8 +3206,9 @@ static void ipw2100_tx_send_data(struct ipw2100_priv *priv)
 	}
 }
 
-static void ipw2100_irq_tasklet(struct ipw2100_priv *priv)
+static void ipw2100_irq_tasklet(unsigned long data)
 {
+	struct ipw2100_priv *priv = (struct ipw2100_priv *)data;
 	struct net_device *dev = priv->net_dev;
 	unsigned long flags;
 	u32 inta, tmp;
@@ -6007,7 +6008,7 @@ static void ipw2100_rf_kill(struct work_struct *work)
 	spin_unlock_irqrestore(&priv->low_lock, flags);
 }
 
-static void ipw2100_irq_tasklet(struct ipw2100_priv *priv);
+static void ipw2100_irq_tasklet(unsigned long data);
 
 static const struct net_device_ops ipw2100_netdev_ops = {
 	.ndo_open		= ipw2100_open,
@@ -6137,7 +6138,7 @@ static struct net_device *ipw2100_alloc_device(struct pci_dev *pci_dev,
 	INIT_DELAYED_WORK(&priv->rf_kill, ipw2100_rf_kill);
 	INIT_DELAYED_WORK(&priv->scan_event, ipw2100_scan_event);
 
-	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
+	tasklet_init(&priv->irq_tasklet,
 		     ipw2100_irq_tasklet, (unsigned long)priv);
 
 	/* NOTE:  We do not start the deferred work for status checks yet */
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index ed0f06532d5e..ac5f797fb1ad 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -1945,8 +1945,9 @@ static void notify_wx_assoc_event(struct ipw_priv *priv)
 	wireless_send_event(priv->net_dev, SIOCGIWAP, &wrqu, NULL);
 }
 
-static void ipw_irq_tasklet(struct ipw_priv *priv)
+static void ipw_irq_tasklet(unsigned long data)
 {
+	struct ipw_priv *priv = (struct ipw_priv *)data;
 	u32 inta, inta_mask, handled = 0;
 	unsigned long flags;
 	int rc = 0;
@@ -10680,7 +10681,7 @@ static int ipw_setup_deferred_work(struct ipw_priv *priv)
 	INIT_WORK(&priv->qos_activate, ipw_bg_qos_activate);
 #endif				/* CONFIG_IPW2200_QOS */
 
-	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
+	tasklet_init(&priv->irq_tasklet,
 		     ipw_irq_tasklet, (unsigned long)priv);
 
 	return ret;
diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index 4fbcc7fba3cc..e2e9c3e8fff5 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -1376,8 +1376,9 @@ il3945_dump_nic_error_log(struct il_priv *il)
 }
 
 static void
-il3945_irq_tasklet(struct il_priv *il)
+il3945_irq_tasklet(unsigned long data)
 {
+	struct il_priv *il = (struct il_priv *)data;
 	u32 inta, handled = 0;
 	u32 inta_fh;
 	unsigned long flags;
@@ -3403,7 +3404,7 @@ il3945_setup_deferred_work(struct il_priv *il)
 	timer_setup(&il->watchdog, il_bg_watchdog, 0);
 
 	tasklet_init(&il->irq_tasklet,
-		     (void (*)(unsigned long))il3945_irq_tasklet,
+		     il3945_irq_tasklet,
 		     (unsigned long)il);
 }
 
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index ffb705b18fb1..5fe17039a337 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -4344,8 +4344,9 @@ il4965_synchronize_irq(struct il_priv *il)
 }
 
 static void
-il4965_irq_tasklet(struct il_priv *il)
+il4965_irq_tasklet(unsigned long data)
 {
+	struct il_priv *il = (struct il_priv *)data;
 	u32 inta, handled = 0;
 	u32 inta_fh;
 	unsigned long flags;
@@ -6238,7 +6239,7 @@ il4965_setup_deferred_work(struct il_priv *il)
 	timer_setup(&il->watchdog, il_bg_watchdog, 0);
 
 	tasklet_init(&il->irq_tasklet,
-		     (void (*)(unsigned long))il4965_irq_tasklet,
+		     il4965_irq_tasklet,
 		     (unsigned long)il);
 }
 
-- 
2.20.1

