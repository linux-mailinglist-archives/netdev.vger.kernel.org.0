Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4747D21D6E7
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 15:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbgGMNYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 09:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729969AbgGMNXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 09:23:06 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3B2C061755;
        Mon, 13 Jul 2020 06:23:05 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id rk21so17149493ejb.2;
        Mon, 13 Jul 2020 06:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f8H9ERlOx/bwQCAi3oIgaIga9LfQUpIbkoayEldb0HM=;
        b=nP4tM4OoaJfI0jEtW6xEBzg5apoi+sWZOdNUHQnZql6+5zpfUsCjSE4u5R6pLHW7oz
         jwCKuzbcq2TY5Dj55XYH232OmurQzeBHVhYptBrE9zfGCZRU4opTaCJbHAMpr0Io+O6H
         7CkiLXYzvyqDjoBjHNoxd6DKPV8nlkPB4GjV5Gm5694PrvQuHLga/wb1ZW/qqoYB7fX/
         23WjP7f45Ar86+KfC2ZgCUkjdOH+neDGunZLfG1c3Unv9zr1u/U/MpAClk0P9WhMhftQ
         ZOPqXc9lBwP4VFQwgbEqziTeD1X6/NYWmcovo0m8tlTlLm04kKUGwewdHeh4toIGMfu7
         3x/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=f8H9ERlOx/bwQCAi3oIgaIga9LfQUpIbkoayEldb0HM=;
        b=pztxPtpxGG8sJaOluoP5/lUUn/noVfyMUp9WcKFCd0XM7Za7SZILzyV43ZPUsm2mx5
         qBGx5E78zDzY/4MYHJNhwMlusOPYjyE5QOZuoSg8S5Qc+EWLZouqiSGGes77tAtGwEux
         ZNdj7Y6m9G2P+/685aBqIiab6rzDahgiVDiVoTqDzORQWw4TZPHkqVXRnckZM4CTpmhd
         XFAAGAvurnVpihwCejR1h5tU6O0RnvbGZkZMKdTovfTmowbExTG1gQ4LMcvW27MRID6l
         5S+/Cbr79M1vCk8jh0oSkEUJB+ylpJSbiBYc9rSlV/WgVo49tbaL3lyVrPrzHjUI1cWq
         fTAg==
X-Gm-Message-State: AOAM532esOD2WD25d9yB9rABIX7jfNrg48TO2o/T4xK1+DpMV+/gnHTb
        tDuGcXZC7KB9ez+1rX5J8hI=
X-Google-Smtp-Source: ABdhPJzx0zQFxJKNIsf6530AIRMCz6zA8fnk43QLenk2ugiiyTQ45TDgcyc6ZIixfZou+TbMT0rN7g==
X-Received: by 2002:a17:906:ca56:: with SMTP id jx22mr72549054ejb.494.1594646584531;
        Mon, 13 Jul 2020 06:23:04 -0700 (PDT)
Received: from net.saheed (54007186.dsl.pool.telekom.hu. [84.0.113.134])
        by smtp.gmail.com with ESMTPSA id n9sm11806540edr.46.2020.07.13.06.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 06:23:04 -0700 (PDT)
From:   "Saheed O. Bolarinwa" <refactormyself@gmail.com>
To:     helgaas@kernel.org, Chas Williams <3chas3@gmail.com>
Cc:     "Saheed O. Bolarinwa" <refactormyself@gmail.com>,
        bjorn@helgaas.com, skhan@linuxfoundation.org,
        linux-pci@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [RFC PATCH 20/35] atm: Tidy Success/Failure checks
Date:   Mon, 13 Jul 2020 14:22:32 +0200
Message-Id: <20200713122247.10985-21-refactormyself@gmail.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200713122247.10985-1-refactormyself@gmail.com>
References: <20200713122247.10985-1-refactormyself@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unnecessary check for 0.

Signed-off-by: "Saheed O. Bolarinwa" <refactormyself@gmail.com>
---
This patch depends on PATCH 19/35

 drivers/atm/iphase.c | 10 ++++------
 drivers/atm/lanai.c  |  6 +++---
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index b01cc491540d..2c75b82b4e7f 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -2295,14 +2295,12 @@ static int reset_sar(struct atm_dev *dev)
 	  
 	iadev = INPH_IA_DEV(dev);  
 	for(i=0; i<64; i++)  
-	  if ((error = pci_read_config_dword(iadev->pci,  
-				i*4, &pci[i])) != 0)
-  	      return error;  
+		if ((error = pci_read_config_dword(iadev->pci, i*4, &pci[i])))
+			return error;
 	writel(0, iadev->reg+IPHASE5575_EXT_RESET);  
 	for(i=0; i<64; i++)  
-	  if ((error = pci_write_config_dword(iadev->pci,  
-					i*4, pci[i])) != 0)
-	    return error;  
+		if ((error = pci_write_config_dword(iadev->pci, i*4, pci[i])))
+			return error;
 	udelay(5);  
 	return 0;  
 }  
diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index 2b82ae30dd74..5852b8cc0cc4 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -1098,7 +1098,7 @@ static void pcistatus_check(struct lanai_dev *lanai, int clearonly)
 	u16 s;
 	int result;
 	result = pci_read_config_word(lanai->pci, PCI_STATUS, &s);
-	if (result != 0) {
+	if (result) {
 		printk(KERN_ERR DEV_LABEL "(itf %d): can't read PCI_STATUS: "
 		    "%d\n", lanai->number, result);
 		return;
@@ -1109,7 +1109,7 @@ static void pcistatus_check(struct lanai_dev *lanai, int clearonly)
 	if (s == 0)
 		return;
 	result = pci_write_config_word(lanai->pci, PCI_STATUS, s);
-	if (result != 0)
+	if (result)
 		printk(KERN_ERR DEV_LABEL "(itf %d): can't write PCI_STATUS: "
 		    "%d\n", lanai->number, result);
 	if (clearonly)
@@ -1945,7 +1945,7 @@ static int lanai_pci_start(struct lanai_dev *lanai)
 		return -EBUSY;
 	}
 	result = check_board_id_and_rev("PCI", pci->subsystem_device, NULL);
-	if (result != 0)
+	if (result)
 		return result;
 	/* Set latency timer to zero as per lanai docs */
 	result = pci_write_config_byte(pci, PCI_LATENCY_TIMER, 0);
-- 
2.18.2

