Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8F6710A3A8
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 18:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbfKZR4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 12:56:03 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38019 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfKZR4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 12:56:02 -0500
Received: by mail-pg1-f194.google.com with SMTP id t3so8925225pgl.5;
        Tue, 26 Nov 2019 09:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/r+BkUfLmBH3CeGijVoAyUPn7ui6aiDwXGoFCaRj4zU=;
        b=mQvsTYyccYh79x0L8dgi0htAPzlYiCAtixC4wckft7r/7mfyb4LLox8Ws9HIuO8bHJ
         C+Jdai1uct571FnAEJZDweiuZ385wZmjbnKiqsqTR7Os8lH6reBb0QNkX59mFcJxWZKW
         uIQL4nCO4BzJmB2FxCodrdQ1stsRZ72hRyqtgUANcSdp2HJi4ceLn+4/Da9fjg/c1L1j
         W5CC9sapTB5Xdvhnw2YGyVYgvj3IwjRmh1QmE3cpEEPgnNafQDVPLjbDXAd9YdGtHjB5
         aiNkRBZ95isGeSte1MUDyqGw8tyvOl577mzJ0UCU6rdMFXH88hkv/bUQ37IkcPSHif90
         exzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/r+BkUfLmBH3CeGijVoAyUPn7ui6aiDwXGoFCaRj4zU=;
        b=U1I/HRQh8q0I688CrrwpJcfxUkqcwxqzhDd/SFgi+YAztHVROLRvqUEn/WsLum7BHA
         ASJnIi1NYr+XqFJA1RMgpKLsR0QEqR13tZN6AlR7z2eHsNs7ULFskMnb188uRVgKusIj
         6U83rOlpGIV1S0XeTRqK24AKohnWJsFdX3tZzAR5QJgnTLWZQmbdBto75FU3cyHfDJur
         jiWYmHifxzPrmYG6h0b43s1tGbo7WEymOclJ+UzZOLufLi0zREhJ7XP/jSRgH48OBKu2
         9nauzF62Sbt2/aqJbiysMEx3YsFkd5T0IEdXCRNVtu82d4OUBgZkDlO/LFYcBFJv9LL1
         tW7w==
X-Gm-Message-State: APjAAAVn0PPdiOL86XtbSG4lLjprWIRgtNkwSdRK8hiWjUW+uRO/yZef
        NtHV2UP+KVE6OHIc9MnJ4Hk=
X-Google-Smtp-Source: APXvYqyr+epTJI3nUteZnOZOJSkivY/g1OL7A3Wf23RyTqON+IyQmqBvJH1mUruiq+wi0WnH247ZxA==
X-Received: by 2002:a63:1b4e:: with SMTP id b14mr41447886pgm.280.1574790961263;
        Tue, 26 Nov 2019 09:56:01 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:2f79:ce3b:4b9:a68f:959f])
        by smtp.gmail.com with ESMTPSA id q6sm781577pfl.140.2019.11.26.09.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 09:56:00 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     Larry.Finger@lwfinger.net, jakub.kicinski@netronome.com,
        kvalo@codeaurora.org
Cc:     tranmanphong@gmail.com, Wright.Feng@cypress.com,
        arend.vanspriel@broadcom.com, davem@davemloft.net,
        emmanuel.grumbach@intel.com, franky.lin@broadcom.com,
        johannes.berg@intel.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        luciano.coelho@intel.com, netdev@vger.kernel.org,
        p.figiel@camlintechnologies.com,
        pieter-paul.giesberts@broadcom.com, pkshih@realtek.com,
        rafal@milecki.pl, sara.sharon@intel.com,
        shahar.s.matityahu@intel.com, yhchuang@realtek.com,
        yuehaibing@huawei.com
Subject: [Patch v2 2/4] ipw2x00: Fix -Wcast-function-type
Date:   Wed, 27 Nov 2019 00:55:27 +0700
Message-Id: <20191126175529.10909-3-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191126175529.10909-1-tranmanphong@gmail.com>
References: <20191125150215.29263-1-tranmanphong@gmail.com>
 <20191126175529.10909-1-tranmanphong@gmail.com>
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
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 7 ++++---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 5 +++--
 2 files changed, 7 insertions(+), 5 deletions(-)

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
-- 
2.20.1

