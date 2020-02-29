Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A479A1749B0
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 23:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbgB2W3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 17:29:30 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44491 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727445AbgB2W3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 17:29:30 -0500
Received: by mail-wr1-f68.google.com with SMTP id m16so7743606wrx.11;
        Sat, 29 Feb 2020 14:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s/TnxZL+H4AudblQ9nBvceLmeag+LoDGvX5KJd89j6g=;
        b=k8NM2x0TbAhJg4p2iYPVeOybSPB6GjF4/79OXHkfiHttd1HJkHa9umOol/v73niymq
         2+KLTO6vSaCnlohZ9n1YjRtxlXyEbfZYCeR+bKUR8Y43ICVbX8zeo0XIyw6SNOFfr5NN
         f9pmdMvKL4ANZfGLXhxgX1nSkNSNCVvQcakC/QsJWuSPIQ0gJJJzfjVmKan9RQgTh5PS
         PcJm+k9dmt9FcuUBNYmRFCzfe9iI/xTPaOOECHDGHwIgNIrH3KZQ9kw0HG4U6Tp8tgXM
         crIdibA3AuFjVU0nV6+0YBVZUVdbe9K1iIZuHNh9N38YlFCj7KBbJbcsxr8C0MD89kKR
         Ev7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s/TnxZL+H4AudblQ9nBvceLmeag+LoDGvX5KJd89j6g=;
        b=P01FZ2yevJ1Uszo6dYWX1jdxHRBrgdvJobO6YGWj2T1s/Qm7zNQlSOrCCP7fnMzuD1
         ypdVJ379+o/bdDEIQWITKnWHWh8gAac1TLT+YH8FVnSljw/V2cJ2J7nVy0a9AuWfMvjI
         Y+qpEJ9skYGzdcqDg0LMXX6dX5B2ALtXE8ZtoFtAEuqQYg7NLqEHOUR+2Tv6zW5nyCa3
         r+SH/xfpqIwr5JNzCUXr5AHm6CujlnNnVtUZzAXgc4pfaxy9JW0r1GciDHTwIojXf2Jj
         j92ZK7zNLTbUFhbThmdZndTDg0ABfAx8O+akEYNN9ES2sbfmb8yM9Rkst7+r/8wYOxM7
         dDqg==
X-Gm-Message-State: APjAAAXLf8hVCZtz7QvxuSMr8/lTMiVE2wvyht55iBRiff6dF4aFYoe1
        ZZBAXiznQeNf3TycqKbdcyT0/cah
X-Google-Smtp-Source: APXvYqxr9ZXt4u/hyNp4CNYuC+q8dPJp4l70xIpHcpRak5opw1aujsXw3FxhTXp3lssPaIJ8cUxSiQ==
X-Received: by 2002:adf:fd11:: with SMTP id e17mr6306515wrr.195.1583015367829;
        Sat, 29 Feb 2020 14:29:27 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:7150:76fe:91ca:7ab5? (p200300EA8F296000715076FE91CA7AB5.dip0.t-ipconnect.de. [2003:ea:8f29:6000:7150:76fe:91ca:7ab5])
        by smtp.googlemail.com with ESMTPSA id e1sm4129549wrx.90.2020.02.29.14.29.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 14:29:27 -0800 (PST)
Subject: [PATCH v4 04/10] PCI: Add constant PCI_STATUS_ERROR_BITS
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
References: <adeb9e6e-9be6-317f-3fc0-a4e6e6af5f81@gmail.com>
Message-ID: <175dca23-c3b1-e297-ef35-4100f1c96879@gmail.com>
Date:   Sat, 29 Feb 2020 23:23:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <adeb9e6e-9be6-317f-3fc0-a4e6e6af5f81@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This collection of PCI error bits is used in more than one driver,
so move it to the PCI core.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
v4:
- move new constant to include/linux/pci.h
- improve commit description
---
 drivers/net/ethernet/marvell/skge.h | 7 -------
 drivers/net/ethernet/marvell/sky2.h | 7 -------
 include/linux/pci.h                 | 7 +++++++
 3 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/marvell/skge.h b/drivers/net/ethernet/marvell/skge.h
index e76c03c87..e149bdfe1 100644
--- a/drivers/net/ethernet/marvell/skge.h
+++ b/drivers/net/ethernet/marvell/skge.h
@@ -15,13 +15,6 @@
 #define  PCI_VPD_ROM_SZ	7L<<14	/* VPD ROM size 0=256, 1=512, ... */
 #define  PCI_REV_DESC	1<<2	/* Reverse Descriptor bytes */
 
-#define PCI_STATUS_ERROR_BITS (PCI_STATUS_DETECTED_PARITY | \
-			       PCI_STATUS_SIG_SYSTEM_ERROR | \
-			       PCI_STATUS_REC_MASTER_ABORT | \
-			       PCI_STATUS_REC_TARGET_ABORT | \
-			       PCI_STATUS_SIG_TARGET_ABORT | \
-			       PCI_STATUS_PARITY)
-
 enum csr_regs {
 	B0_RAP	= 0x0000,
 	B0_CTST	= 0x0004,
diff --git a/drivers/net/ethernet/marvell/sky2.h b/drivers/net/ethernet/marvell/sky2.h
index aee87f838..851d8ed34 100644
--- a/drivers/net/ethernet/marvell/sky2.h
+++ b/drivers/net/ethernet/marvell/sky2.h
@@ -252,13 +252,6 @@ enum {
 };
 
 
-#define PCI_STATUS_ERROR_BITS (PCI_STATUS_DETECTED_PARITY | \
-			       PCI_STATUS_SIG_SYSTEM_ERROR | \
-			       PCI_STATUS_REC_MASTER_ABORT | \
-			       PCI_STATUS_REC_TARGET_ABORT | \
-			       PCI_STATUS_SIG_TARGET_ABORT | \
-			       PCI_STATUS_PARITY)
-
 enum csr_regs {
 	B0_RAP		= 0x0000,
 	B0_CTST		= 0x0004,
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 3840a541a..101d71e0a 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -42,6 +42,13 @@
 
 #include <linux/pci_ids.h>
 
+#define PCI_STATUS_ERROR_BITS (PCI_STATUS_DETECTED_PARITY  | \
+			       PCI_STATUS_SIG_SYSTEM_ERROR | \
+			       PCI_STATUS_REC_MASTER_ABORT | \
+			       PCI_STATUS_REC_TARGET_ABORT | \
+			       PCI_STATUS_SIG_TARGET_ABORT | \
+			       PCI_STATUS_PARITY)
+
 /*
  * The PCI interface treats multi-function devices as independent
  * devices.  The slot/function address of each device is encoded
-- 
2.25.1


