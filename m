Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74A0B16B26E
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgBXV3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:29:46 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40607 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728257AbgBXV3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:29:44 -0500
Received: by mail-wm1-f67.google.com with SMTP id t14so891771wmi.5;
        Mon, 24 Feb 2020 13:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E9/8+yaqRvrAtgc15Q6xGgpo7ZqTiVPb7l/6H6m7t5Q=;
        b=NKaXURfZ1NqkGkQxTkR2n9fqQBrq9+jibXeSJpxwl573MInYBFnVXqncS4vCeGwfJb
         CEL+dWVBeljqEiJQiQCHw2PAK5YFI989FTKqVYOG37zNldMa9Z5Ka2fNfB87YKIDusKe
         1ZUSR7DIIEbQEjn37yQHSZm+7OOCFB45tbekmmy3j2Fds/Kq/1htSxXBzsEc+70O/Iv6
         SqleS/u/K7t1VW08LzIvNVT0h1hwY7XZw/RDiNFoUul2asLJphUNp5VknyCGdvKXtHr3
         rtHqjm7F7jGPmi6uhbuKE6mKt7vTagMbsL0RB5AEpxy/wu0XgQ8jTprhjUuS614eKB6+
         LtdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E9/8+yaqRvrAtgc15Q6xGgpo7ZqTiVPb7l/6H6m7t5Q=;
        b=spoiul36vtl6smEjodHHnja7FNFgCz1sJmW5U8nc8obyLrOoZ/2DFRjQCroo3Q8ew1
         lS2bLOHPN2SVlVCz8oxSSK/ckrbRwgwlH6BQSI8Q4jzdpU+MEHP+h2QfL/csbCT4tgv1
         vTxKXKEZSu0yVkL2s2j/E+qxq/z86qzkmX+kFE56ECzciudBs9BfGOaV882OzUDXIOZQ
         AMg446SgMbEayQq6LHUi3xz6I3pZGLb8gySNn6pkPsICuLRKkiY13nGRkDblsrbJ7R/D
         GN2j+9lkCPpq29uBet3bocQIKlBWQyBmNvyC8NnR5/+RFmPZTzD00/dssXQlovwJRjC3
         ezfA==
X-Gm-Message-State: APjAAAXWrVGoJCaoNzPWJdvsrtNOpzhDhGKhmBRJdOkIV4xuKuznFXlQ
        ZSdMe0aOmbrneFLL1XMYriPhRUlk
X-Google-Smtp-Source: APXvYqxruEH1sHYvFUjylGwTeW642aO6q6BjVx/Msh+bTzEzlkZWlryBOCDvfSOwyOr70XLRs3JCoQ==
X-Received: by 2002:a7b:ce0b:: with SMTP id m11mr1020524wmc.4.1582579782522;
        Mon, 24 Feb 2020 13:29:42 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:3d90:eff:31bc:c6a9? (p200300EA8F2960003D900EFF31BCC6A9.dip0.t-ipconnect.de. [2003:ea:8f29:6000:3d90:eff:31bc:c6a9])
        by smtp.googlemail.com with ESMTPSA id e8sm13925652wrr.69.2020.02.24.13.29.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 13:29:42 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 1/8] PCI: add constant PCI_STATUS_ERROR_BITS
To:     Bjorn Helgaas <bhelgaas@google.com>,
        David Miller <davem@davemloft.net>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <5939f711-92aa-e7ed-2a26-4f1e4169f786@gmail.com>
Message-ID: <d61cddab-785b-7a57-4b2d-2fbdd34766d7@gmail.com>
Date:   Mon, 24 Feb 2020 22:22:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <5939f711-92aa-e7ed-2a26-4f1e4169f786@gmail.com>
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


