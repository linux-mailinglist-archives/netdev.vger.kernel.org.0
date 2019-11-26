Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B5510A3AB
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 18:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfKZR4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 12:56:09 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45301 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfKZR4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 12:56:07 -0500
Received: by mail-pf1-f193.google.com with SMTP id z4so9532582pfn.12;
        Tue, 26 Nov 2019 09:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cimGLUIkJsl8gm8ukuHoHlW7vil473DnKZ8zwyUQQ6Q=;
        b=DhuCaLSMIWKcX4cbFcFQmm6eNFdgLBBsljbtTfiWCF9CBejP6B4fhMVm8XHThZ62oR
         IEErrh05KoflnPN8ZtJAPp7+SJ8Kn9h+A2HbggKeHlh7mcqjtu79f5CYZDlXN50RTHFl
         No8I04EaIVJNiny2yEyVuOmj+AxmbA8tM8TncGWvvOqgUVpH1ELuatijZJMKDDnUNbuW
         wO4xc7zrYF9Lz/QY9G/Xko1zvUulSioEVxol8WC7+++yErKSNM5Ncjw0u643gdxb0W85
         uVtBE9y9kHeNMofQhQr0lGqyMrC30KpSjOkk9Pp+Y/ec4SZn3Yj3Pk/xqGfKMHE9zLFf
         cPig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cimGLUIkJsl8gm8ukuHoHlW7vil473DnKZ8zwyUQQ6Q=;
        b=XLK51c84ffqd92dZs311jPqZkHKT/ugbP5fOerRohI1Bc2ma7jb6khPefMrY+L7uiQ
         h4y2tNm0mncHDL+PxTjyQEkXIsZQ9o2g+B5dWyjsgGNWZpO71I1k1e8RJd9juJmp2aQ9
         FgBRRLBN+BQsjehUHzRfmfg1VzybEj1QjCn0lav5TVG0V8jDD+f8d4ni5/sb1MpfFsSO
         YoMysRsuyeibeAuJM1/AL/ovrKeSgzADU4vbOyyFBecMXH4KJwi65UBH57WwHtbCpKwu
         RIjCNhVtUM59lBVSx6ImEMwKIsB8HpisyVRFLwM3J9G8K3awRe/6NVlDTWJjSQFnvdZL
         LZuQ==
X-Gm-Message-State: APjAAAX71beiub5ztccfGw47QLVauyzJcM/cvgU+3faOBmmHxblOvfPn
        QgtDcN0J4x1szx0Z/WSZwRw=
X-Google-Smtp-Source: APXvYqzUU4WN7h8GDDrp+6bdxlfUTzw51p9KKIWu0zHzB0vdWwmNblZgHUoVXIwnSZFfvUoSjfyUIw==
X-Received: by 2002:a63:c01:: with SMTP id b1mr25248919pgl.342.1574790967015;
        Tue, 26 Nov 2019 09:56:07 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:2f79:ce3b:4b9:a68f:959f])
        by smtp.gmail.com with ESMTPSA id q6sm781577pfl.140.2019.11.26.09.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 09:56:06 -0800 (PST)
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
Subject: [Patch v2 3/4] iwlegacy: Fix -Wcast-function-type
Date:   Wed, 27 Nov 2019 00:55:28 +0700
Message-Id: <20191126175529.10909-4-tranmanphong@gmail.com>
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
 drivers/net/wireless/intel/iwlegacy/3945-mac.c | 5 +++--
 drivers/net/wireless/intel/iwlegacy/4965-mac.c | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

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

