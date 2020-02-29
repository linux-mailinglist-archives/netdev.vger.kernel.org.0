Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7711749A7
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 23:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgB2W3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 17:29:53 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45204 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727637AbgB2W3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 17:29:36 -0500
Received: by mail-wr1-f65.google.com with SMTP id v2so7723233wrp.12;
        Sat, 29 Feb 2020 14:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HnjyZ2rP4r4R9QdkadbJqDIvo+cFcKMufZXST9ow+bc=;
        b=OgxTpXc/q+X92Qj3X1cZMo0lx5igTtCtGdTurqDnTiaf1QFOKRRZOXyFXe2KFVyKhZ
         2bR4To+kT3lsL3jev58Bj2lD2AJ3aAlFyNLELlArikgum1jVu5GomwH3es4sc/PA1NBi
         /M40QJo7vPEGCs+9qjDxlnC1KVs6eNZ21+m3dx4zrebZOTa6/ORltkwWk4qVhxZsSw0T
         1m7kFTQxzZUG6woTqAUMWue2voMASzwfGc4N3Je3yXAkMBorKSbVHFhwBPhnVD5laBYN
         GiRSuXZC0i7pq9Oi0a+Wt6tmfOGcMvFNJ2WvxVjN7pyLucmUUHmX7tqklShFcK3UeKiq
         6tHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HnjyZ2rP4r4R9QdkadbJqDIvo+cFcKMufZXST9ow+bc=;
        b=YbM3w8D47X12/Q4tSPYDShqqcK6JXbdLtIwXrhE+XoRoGFBOQqfNFS/Iq+zXCCOW1C
         /ozyv5j8ajx8ocCY5177IWZyxMAh2fOuZ2BI9gGhRNW6iewDYgro10D9CsumoP6zLxHg
         2YVyRHzXsliibYE7tem406b4UWss+i6Ov1qAGmpWAu3QfpzMdqeAKhyqt45fCNo93/w6
         UFqZjaqq4HZ+J4OJonVVgAV5tk/28mjM39jFCkX5OrPHPrG8bHPiIYAwrcHtRSUUXU7B
         OkEtiPfQsn90G01lQuEuN5bJotU3L2x/uGYYp8TyS/0GLe/wQPDmSJj/ii3FelJPa4jk
         5b6w==
X-Gm-Message-State: ANhLgQ3mrHBdxN3WqOunMzzqig4+b1SKgK52plwhL0PVOjV6mB1J44Ds
        JMXuaQQJ4bP3h5Q7CYS2nZk=
X-Google-Smtp-Source: ADFU+vvnu0rLKBCTigw0gSq5LRERDVrun/+wOc0XCFZmlFglPZdGaovMBe8s6lwAq8kH1D8kB4DHFA==
X-Received: by 2002:a5d:4d10:: with SMTP id z16mr2936727wrt.271.1583015374193;
        Sat, 29 Feb 2020 14:29:34 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:7150:76fe:91ca:7ab5? (p200300EA8F296000715076FE91CA7AB5.dip0.t-ipconnect.de. [2003:ea:8f29:6000:7150:76fe:91ca:7ab5])
        by smtp.googlemail.com with ESMTPSA id j4sm7354174wrr.0.2020.02.29.14.29.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 14:29:33 -0800 (PST)
Subject: [PATCH v4 09/10] PCI: pci-bridge-emul: Use new constant
 PCI_STATUS_ERROR_BITS
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
Message-ID: <04851614-b906-2b1b-f937-189c3c210880@gmail.com>
Date:   Sat, 29 Feb 2020 23:28:18 +0100
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

Use new constant PCI_STATUS_ERROR_BITS to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/pci/pci-bridge-emul.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/pci-bridge-emul.c b/drivers/pci/pci-bridge-emul.c
index fffa77093..4f4f54bc7 100644
--- a/drivers/pci/pci-bridge-emul.c
+++ b/drivers/pci/pci-bridge-emul.c
@@ -50,12 +50,7 @@ static const struct pci_bridge_reg_behavior pci_regs_behavior[] = {
 		       (PCI_STATUS_CAP_LIST | PCI_STATUS_66MHZ |
 			PCI_STATUS_FAST_BACK | PCI_STATUS_DEVSEL_MASK) << 16),
 		.rsvd = GENMASK(15, 10) | ((BIT(6) | GENMASK(3, 0)) << 16),
-		.w1c = (PCI_STATUS_PARITY |
-			PCI_STATUS_SIG_TARGET_ABORT |
-			PCI_STATUS_REC_TARGET_ABORT |
-			PCI_STATUS_REC_MASTER_ABORT |
-			PCI_STATUS_SIG_SYSTEM_ERROR |
-			PCI_STATUS_DETECTED_PARITY) << 16,
+		.w1c = PCI_STATUS_ERROR_BITS << 16,
 	},
 	[PCI_CLASS_REVISION / 4] = { .ro = ~0 },
 
@@ -100,12 +95,7 @@ static const struct pci_bridge_reg_behavior pci_regs_behavior[] = {
 			 PCI_STATUS_DEVSEL_MASK) << 16) |
 		       GENMASK(11, 8) | GENMASK(3, 0)),
 
-		.w1c = (PCI_STATUS_PARITY |
-			PCI_STATUS_SIG_TARGET_ABORT |
-			PCI_STATUS_REC_TARGET_ABORT |
-			PCI_STATUS_REC_MASTER_ABORT |
-			PCI_STATUS_SIG_SYSTEM_ERROR |
-			PCI_STATUS_DETECTED_PARITY) << 16,
+		.w1c = PCI_STATUS_ERROR_BITS << 16,
 
 		.rsvd = ((BIT(6) | GENMASK(4, 0)) << 16),
 	},
-- 
2.25.1


