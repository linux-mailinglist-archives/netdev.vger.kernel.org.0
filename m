Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5293C176DE4
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 05:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgCCEQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 23:16:09 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42622 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727312AbgCCEQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 23:16:07 -0500
Received: by mail-pl1-f196.google.com with SMTP id u3so702852plr.9
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 20:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=61gZ4SQN/1tdeU8RQk3DcrIUxl3TSrJNCIjlf4zlDM0=;
        b=zhWC6hXvgVFhJox8jDMudwzy1sy3dbQZv05ipC1JoLkK9k8i3Gxca9qAIxnvEkotcf
         3ve/9ggTh8T+0gc9Fxnn9NoWO/Ddoy1Tnn1LNHy0QnZBMRd9W99cRpiQm+IxsZENtmqe
         dTgC6n5oO94jCRzUlnZsRvyyzZ16aoy8yidWNYoEaBLtEcCnHmScrYrgOAkYa6KT0Ga9
         zfzpt3W1HARN3kCAZ5xh2OQgukbCvAlAc+ncqGnXqa4apInVilwC69kEYnMqSLpf4/LA
         KhX/AmGYoGl75GgQxyrANaKCua1RPqP5M0dgZXVVbmLBd/mKcSHw61Ef4OfowFOL5CeR
         cI1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=61gZ4SQN/1tdeU8RQk3DcrIUxl3TSrJNCIjlf4zlDM0=;
        b=LCGFwDOOia/ssFIIKwkUgJXYbF/Zq17tg5MbkLq7oBPEXR42+qNCOh5YUBcpBgOY/g
         bdJ66BMCr6mCN6g8PmB1+rnryNWNaD8NjRisSC9IdkD3AiSfnTMVGREgs+WakGyiNxUC
         ievKViulyZQCmRi30UxaLrLXyCghiTa0PSK/tAADtjycn8bUnF0sV9Lo4cLNHWwSx8ll
         2qAf2oALy9hS6VwLAut6PGFe60vnOenS5dilgLKfG/I0HjXCFv4GdARnVECRzjzRw871
         38wk9suHK54Mzoz6G6//FOagVHZdLqD3pqDL6CAOeCgXhzSRmWFdFiXnLyc+Okjkv15l
         aIiw==
X-Gm-Message-State: ANhLgQ0dE/GTxvjOmVi8JrqX9PjmUWVu/HwdUagt/aoV0KeHs/1K7V/O
        +OdyDfyv5bZdUTVxRphCJInnQQ==
X-Google-Smtp-Source: ADFU+vs/HdSszhqT2AKn4rsIvceaqJ5/Sg4+OvdWfHV1ljabfzOlEJPP5QUe6glYGyQxNDmb4XGDgQ==
X-Received: by 2002:a17:90a:348a:: with SMTP id p10mr2080285pjb.120.1583208966244;
        Mon, 02 Mar 2020 20:16:06 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t7sm396682pjy.1.2020.03.02.20.16.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2020 20:16:05 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 7/8] ionic: add support for device id 0x1004
Date:   Mon,  2 Mar 2020 20:15:44 -0800
Message-Id: <20200303041545.1611-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200303041545.1611-1-snelson@pensando.io>
References: <20200303041545.1611-1-snelson@pensando.io>
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

