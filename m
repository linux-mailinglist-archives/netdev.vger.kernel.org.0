Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADB4016BA62
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 08:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbgBYHP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 02:15:28 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33032 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgBYHP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 02:15:28 -0500
Received: by mail-wr1-f67.google.com with SMTP id u6so13385178wrt.0;
        Mon, 24 Feb 2020 23:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E9/8+yaqRvrAtgc15Q6xGgpo7ZqTiVPb7l/6H6m7t5Q=;
        b=gAWg8nEUgOdWMLB+diQmTE5GCqD/pZb7L3UOJCYLP7Vey8g8AehMFuEWE++Fk2UqS7
         Xl/MbbrA1kNs2Wle6Stbm69gVDLeDIGyxnMw+hCH2mG/r7Q4KbO9RreP87rEYgQ8xg+h
         caOg65x7OT477nOJxWoCKg3QUSDoFvlBkADIqjiLWnG7+Vc3AadRLJCGOto6r4XTCNCc
         bX4c25YtDRnKbIWDBU0U6ohSAsPDHK33UjdxT415BI/qv0Jg/DPb601LDErsNSPgCXIe
         TgomgirmW4+gf1axl7pdU+MT7delM6FB/7x7CP24wyAD/6XcVR0c1Alenf/SEQNamhDm
         k3qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E9/8+yaqRvrAtgc15Q6xGgpo7ZqTiVPb7l/6H6m7t5Q=;
        b=mpQVUMIbPtIzaCEih2Go+6CkecMHBQ1B/Q+opYuNePD3oH7vDp/eIRaTkQng/H3/YA
         NqWoBbtEGhCJWfooKiyUVagZL/JitSoL3EqDOcEYO79H16XX9kb+sLf6H1MmVurRfGlh
         7GB9UaV7BIIRI5guTD/eaClE+bYCQU5umi9hpNNwXG6IQNKXwfLzrSFafKTLtL4SuJSP
         CQf62h8034bsE3jTD8HjI4PcznXtlBbEsfFHZpoGOgXx7QIBXsXKnJhp+Vmkru1Cg2cT
         OuyMOh0tXxfDBZwE9wjrbzXa9xSuGZlNMKBQYriueqRCsTX4hLsDw5HvOKGFXFEEBKM/
         2t4A==
X-Gm-Message-State: APjAAAVAo9JLXbciGruPoNjaseho5ez8Dnq9iyYV9W5p6+wH4pPTuGvt
        DRXwqagiC++XluLyf9bCMSo=
X-Google-Smtp-Source: APXvYqzMoigKDqr8+BVCh5FG6g9TOQqytMq+/hxO1sqgNtEubEWlXD7Uu0lxsUhjzf/h7JhWaMZD+A==
X-Received: by 2002:adf:e686:: with SMTP id r6mr72229406wrm.177.1582614925973;
        Mon, 24 Feb 2020 23:15:25 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:6c81:a415:de47:1314? (p200300EA8F2960006C81A415DE471314.dip0.t-ipconnect.de. [2003:ea:8f29:6000:6c81:a415:de47:1314])
        by smtp.googlemail.com with ESMTPSA id x6sm2872736wmi.44.2020.02.24.23.15.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 23:15:25 -0800 (PST)
Subject: [PATCH v2 1/8] PCI: add constant PCI_STATUS_ERROR_BITS
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
References: <c1a84adc-a864-4f46-c8de-7ea533a7fdc3@gmail.com>
Message-ID: <e60d5457-b70d-99ef-d488-397cf1d541e8@gmail.com>
Date:   Tue, 25 Feb 2020 08:08:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <c1a84adc-a864-4f46-c8de-7ea533a7fdc3@gmail.com>
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



