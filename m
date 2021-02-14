Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC3C31B374
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 00:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhBNXoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 18:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhBNXoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 18:44:09 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D3DC061574;
        Sun, 14 Feb 2021 15:43:29 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id m144so5012228qke.10;
        Sun, 14 Feb 2021 15:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g51sb7f8Ru24KB1O9CC1p/nfwLPwMBUXtIRefVZqVLY=;
        b=LgAdkOGtUJrMwau46ostm3EyetfaF61qoYheeArqNx/mafRfRGKnlMAdKFbzKHjn5J
         quqUdYKWP1VBUeVYr9eAfq6jWi5CFGdXiNGSQuvB6l7kQe2sv81X9zj70t3QgSug95hK
         0/qToaCXk/OMoPXgdctHG8d/O8GTniTSNads7xzNnTBRulAnLsiZutswqz/NbkOXAPqZ
         nWhamtJzQSF6e2uEI220aSl7KssuUTUiCFQ+6jt91joPo3Tpj9naWgA9kac23+BQqX6s
         MihWBU7iw+XlF/c96+FgaNDq0IYz8Ikap9leBZz7CX1m2EnhPKvilQVpl54uSfHLLR5R
         iJLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g51sb7f8Ru24KB1O9CC1p/nfwLPwMBUXtIRefVZqVLY=;
        b=uNpOl2WOdy6bxkDUPHvS8CgiHlSOFRDEUO71KStAh/iKswV8dbqTWVK4FErzEmFa+I
         ZShQf6OOkDEpIHZe+aVtOjeGjobFrFt0J295fWScfJg1vtWfMHyexvyXtWKOyQyX9M8O
         jpGA9ot8UD/JFbzyJ5+CyHMcKhNEGFIXjPJ9F8I5fDIJs/GnAV30LRg4KZnbfzJ4VXHx
         9xe+x3rT5mV1F8UWTbLP5e+ApgVCienJhAwh6grfPawkmUJNZ5opUwa2/p7/nDTgv03Q
         2ZeQdxOhIbRIAtB8r+PvOKRovnMEf+kti7AyIkspeU+xum+GokaHlc+TB9QWuduy7/pW
         fSkQ==
X-Gm-Message-State: AOAM530Vq2oeVHq/qNmwo7aU7wXaBjwPbIKUmrCs0Br5zL88OptY1hnk
        EeTGj8jEVecK2/kWRQcQsYQ=
X-Google-Smtp-Source: ABdhPJw2kHWXJ8q+VkyKpttfMAnzuk6ht5f6OEJcmLul2LckaVJixYjCyKiD1gIaH6g2MJ4+qt1zpQ==
X-Received: by 2002:a37:4589:: with SMTP id s131mr12773257qka.269.1613346207969;
        Sun, 14 Feb 2021 15:43:27 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:48a6:eef1:8ac9:fd76])
        by smtp.googlemail.com with ESMTPSA id x4sm10669469qkx.136.2021.02.14.15.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 15:43:27 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ztong0001@gmail.com
Subject: [PATCH v1] atm: idt77252: fix build broken on amd64
Date:   Sun, 14 Feb 2021 18:43:08 -0500
Message-Id: <20210214234308.1524014-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  idt77252 is broken and wont load on amd64 systems
  modprobe idt77252 shows the following

    idt77252_init: skb->cb is too small (48 < 56)

  Add packed attribute to struct idt77252_skb_prv and struct atm_skb_data
  so that the total size can be <= sizeof(skb->cb)
  Also convert runtime size check to buildtime size check in
  idt77252_init()

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/atm/idt77252.c | 11 +----------
 drivers/atm/idt77252.h |  2 +-
 include/linux/atmdev.h |  2 +-
 3 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 5f0472c18bcb..0c13cac903de 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -3743,16 +3743,7 @@ static int __init idt77252_init(void)
 	struct sk_buff *skb;
 
 	printk("%s: at %p\n", __func__, idt77252_init);
-
-	if (sizeof(skb->cb) < sizeof(struct atm_skb_data) +
-			      sizeof(struct idt77252_skb_prv)) {
-		printk(KERN_ERR "%s: skb->cb is too small (%lu < %lu)\n",
-		       __func__, (unsigned long) sizeof(skb->cb),
-		       (unsigned long) sizeof(struct atm_skb_data) +
-				       sizeof(struct idt77252_skb_prv));
-		return -EIO;
-	}
-
+	BUILD_BUG_ON(sizeof(skb->cb) < sizeof(struct idt77252_skb_prv) + sizeof(struct atm_skb_data));
 	return pci_register_driver(&idt77252_driver);
 }
 
diff --git a/drivers/atm/idt77252.h b/drivers/atm/idt77252.h
index 9339197d701c..b059d31364dd 100644
--- a/drivers/atm/idt77252.h
+++ b/drivers/atm/idt77252.h
@@ -789,7 +789,7 @@ struct idt77252_skb_prv {
 	struct scqe	tbd;	/* Transmit Buffer Descriptor */
 	dma_addr_t	paddr;	/* DMA handle */
 	u32		pool;	/* sb_pool handle */
-};
+} __packed;
 
 #define IDT77252_PRV_TBD(skb)	\
 	(((struct idt77252_skb_prv *)(ATM_SKB(skb)+1))->tbd)
diff --git a/include/linux/atmdev.h b/include/linux/atmdev.h
index d7493016cd46..60cd25c0461b 100644
--- a/include/linux/atmdev.h
+++ b/include/linux/atmdev.h
@@ -207,7 +207,7 @@ struct atm_skb_data {
 	struct atm_vcc	*vcc;		/* ATM VCC */
 	unsigned long	atm_options;	/* ATM layer options */
 	unsigned int	acct_truesize;  /* truesize accounted to vcc */
-};
+} __packed;
 
 #define VCC_HTABLE_SIZE 32
 
-- 
2.25.1

