Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26EE316C36E
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 15:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbgBYOIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 09:08:32 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46641 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730240AbgBYOIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 09:08:31 -0500
Received: by mail-wr1-f66.google.com with SMTP id j7so2363757wrp.13;
        Tue, 25 Feb 2020 06:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E9/8+yaqRvrAtgc15Q6xGgpo7ZqTiVPb7l/6H6m7t5Q=;
        b=ipTJOk/01c3Cv19kwq5xngz+7Q8JLD9W9SwP30kqoDvGgs9mzmSuyVdOp/0x2Z3JBX
         SouECnpnvqbZiyAORAku+W/U/oRbWRkpCMkrmsn8Xl89YrZge3A/xv42OGXaXRe85vr9
         vTJsbKq4CygkV1enEslMKQQAzYJvqW3zZywCr495lv9nYZjlIyDLhhmMutccJIDL3E+D
         UjcWbnalYMJWIJc1ouJOTNUt8xrvH7VkdxIyKwl0kRhepl8251mAItVW4EnwGN5lCEOU
         trh3JytS55gxaECU44jYgdM7QwaTh8CoQ0V0QkYq/wyOz2RQYHpyMrLr1mpaw7/QNu2g
         A+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E9/8+yaqRvrAtgc15Q6xGgpo7ZqTiVPb7l/6H6m7t5Q=;
        b=CI1/BbZxkbVcrdTVwl7COxp1msnv0nYYIXR6m23lgnsoEvDN6jlsr9b4AG6xH7WO3Y
         H++ZjMfW8t+3nwaWZidaIIJE61XhTrkKuL/U/NOzfM8iuDcvQitP2OA9KoiFE64mPXIP
         iW8uKVLqFA28RlmwXwl1xw7qNjRp8x5XmtTXab3hRv4Pn9xBITac6D1NVQsBO2aoOOJg
         1paeZyyJEAw5M2BhetphKgh84Bz9Vo5VRTndjM/M8HPgfLumOKsYpUjn4RynoLn2Sv72
         Da3+QLB6t8nJ1zhL2t7kRvnecYzfu7ZRMYqp+TJBHN/wrWsmdo91s8u6ZwT1r+NGXUKc
         sURg==
X-Gm-Message-State: APjAAAXaLNLa1qtKc4w1GpcQim+cnx1R7qrCPefyR3lj/zEeIrFOO7cO
        ScaomgeDRiFQSuW82rks+MU=
X-Google-Smtp-Source: APXvYqx+DZruNmT8sN2rhRo+8HDVho5gJrgSt8caSfXEUGu9sq6Ub/o8MAgrKTltKV/iaWI8Kpn9HA==
X-Received: by 2002:a5d:5183:: with SMTP id k3mr72340713wrv.414.1582639709386;
        Tue, 25 Feb 2020 06:08:29 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:30a8:e117:ed7d:d145? (p200300EA8F29600030A8E117ED7DD145.dip0.t-ipconnect.de. [2003:ea:8f29:6000:30a8:e117:ed7d:d145])
        by smtp.googlemail.com with ESMTPSA id z19sm4286325wmi.35.2020.02.25.06.08.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 06:08:28 -0800 (PST)
Subject: [PATCH v3 1/8] PCI: add constant PCI_STATUS_ERROR_BITS
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org
References: <20ca7c1f-7530-2d89-40a6-d97a65aa25ef@gmail.com>
Message-ID: <73dd692e-bbce-35f5-88e9-417fb0f7229e@gmail.com>
Date:   Tue, 25 Feb 2020 15:03:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20ca7c1f-7530-2d89-40a6-d97a65aa25ef@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This constant is used (with different names) in more than one driver,
so move it to the PCI core.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/marvell/skge.h | 6 ------
 drivers/net/ethernet/marvell/sky2.h | 6 ------
 include/uapi/linux/pci_regs.h       | 7 +++++++
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/marvell/skge.h b/drivers/net/ethernet/marvell/skge.h
index 6fa7b6a34..e149bdfe1 100644
--- a/drivers/net/ethernet/marvell/skge.h
+++ b/drivers/net/ethernet/marvell/skge.h
@@ -15,12 +15,6 @@
 #define  PCI_VPD_ROM_SZ	7L<<14	/* VPD ROM size 0=256, 1=512, ... */
 #define  PCI_REV_DESC	1<<2	/* Reverse Descriptor bytes */
 
-#define PCI_STATUS_ERROR_BITS (PCI_STATUS_DETECTED_PARITY | \
-			       PCI_STATUS_SIG_SYSTEM_ERROR | \
-			       PCI_STATUS_REC_MASTER_ABORT | \
-			       PCI_STATUS_REC_TARGET_ABORT | \
-			       PCI_STATUS_PARITY)
-
 enum csr_regs {
 	B0_RAP	= 0x0000,
 	B0_CTST	= 0x0004,
diff --git a/drivers/net/ethernet/marvell/sky2.h b/drivers/net/ethernet/marvell/sky2.h
index b02b65230..851d8ed34 100644
--- a/drivers/net/ethernet/marvell/sky2.h
+++ b/drivers/net/ethernet/marvell/sky2.h
@@ -252,12 +252,6 @@ enum {
 };
 
 
-#define PCI_STATUS_ERROR_BITS (PCI_STATUS_DETECTED_PARITY | \
-			       PCI_STATUS_SIG_SYSTEM_ERROR | \
-			       PCI_STATUS_REC_MASTER_ABORT | \
-			       PCI_STATUS_REC_TARGET_ABORT | \
-			       PCI_STATUS_PARITY)
-
 enum csr_regs {
 	B0_RAP		= 0x0000,
 	B0_CTST		= 0x0004,
diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index 543769048..9b84a1278 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -68,6 +68,13 @@
 #define  PCI_STATUS_SIG_SYSTEM_ERROR	0x4000 /* Set when we drive SERR */
 #define  PCI_STATUS_DETECTED_PARITY	0x8000 /* Set on parity error */
 
+#define PCI_STATUS_ERROR_BITS (PCI_STATUS_DETECTED_PARITY  | \
+			       PCI_STATUS_SIG_SYSTEM_ERROR | \
+			       PCI_STATUS_REC_MASTER_ABORT | \
+			       PCI_STATUS_REC_TARGET_ABORT | \
+			       PCI_STATUS_SIG_TARGET_ABORT | \
+			       PCI_STATUS_PARITY)
+
 #define PCI_CLASS_REVISION	0x08	/* High 24 bits are class, low 8 revision */
 #define PCI_REVISION_ID		0x08	/* Revision ID */
 #define PCI_CLASS_PROG		0x09	/* Reg. Level Programming Interface */
-- 
2.25.1




