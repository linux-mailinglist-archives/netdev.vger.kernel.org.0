Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8DA01749A0
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 23:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgB2W3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 17:29:35 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39612 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727445AbgB2W3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 17:29:34 -0500
Received: by mail-wr1-f68.google.com with SMTP id y17so7803871wrn.6;
        Sat, 29 Feb 2020 14:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3oxaHy7GUp3VvIUdefqSTFgeBUI+Ntzm5rsd6wjLj2E=;
        b=XeT3zQv8D4p9/s7KFaC2XLvJIa0Y4bgNxvat+uiOPGGcra6jfHBmxfPbJeQOwtxl/T
         VBoYIZUDJsR/XrnZcFYYGbKNo76X8n8p3yUsPpyF8MEfvLeL6eUWRHiaSL/HsDv5EZDo
         ZXWTAq4le1YCxxzPz0mbC6JUB/Y/W8mELLXy672tU/vI7ASLGohQeHxbCKGv/kErMkzo
         5O6ELKUlcs15++amA5vkc2bCkUftYfRJa/iWc42t5WN66u8OiYMpiR3Q0lApQ/a36eAj
         HcJVUsBFomdYIGEqQzMr/v8iRP2D63UBloX+zJMQjGRbQyTYDSJGl0QcF7se85Fw+pcW
         VEEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3oxaHy7GUp3VvIUdefqSTFgeBUI+Ntzm5rsd6wjLj2E=;
        b=dq7oyKwE2IbcMLozP4XOm7kP5nii9eTstNEhZqlihMFCz0nky7sJLMGDAeTUW6Dgh3
         8mNIY0UmOTODcSxddkDK8KldRdIuhI67j/HxllPfr+cbSIEoBZQ3NTtFEzvcPK7D2/tZ
         JoNTrmNMAM6S1Y8mGRw6HqbQo9iKoHsVmVCe8uLdU16mhx4gnn3ctOgkmVCmsd/ckchy
         Lejhz4wDgZrJRog3ad5VV1nx7x3bvOzr8lhj1KqvBszjtfXuvFDPuGOTneVr45pn0YHB
         QN17ziIqOSsOmT1OqwV1kZf7mzdoNLOKHv9aiggpkABi8w5gFKDbA4kSwA2LnDnE2fMD
         mzJA==
X-Gm-Message-State: APjAAAVKSYZxECil6O2/jgrbQ3gjPO5PBXR6pQRisuR0wXLcBQJUeaob
        5PPeYqPOMTyOKGEwaVbvP2U=
X-Google-Smtp-Source: APXvYqzk7VrcL96l5dY+NPmzgSag4xUmdFPBQ59DKdg5xfhQIEdG89bjaM6n1y0fvBLJqx46WzfhCw==
X-Received: by 2002:adf:edd0:: with SMTP id v16mr12853225wro.357.1583015372768;
        Sat, 29 Feb 2020 14:29:32 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:7150:76fe:91ca:7ab5? (p200300EA8F296000715076FE91CA7AB5.dip0.t-ipconnect.de. [2003:ea:8f29:6000:7150:76fe:91ca:7ab5])
        by smtp.googlemail.com with ESMTPSA id c11sm18770976wrp.51.2020.02.29.14.29.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 14:29:32 -0800 (PST)
Subject: [PATCH v4 08/10] net: skfp: use new constant PCI_STATUS_ERROR_BITS
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
Message-ID: <bd47367e-45f2-96e3-a5b6-b63471c946b7@gmail.com>
Date:   Sat, 29 Feb 2020 23:27:34 +0100
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

Use new PCI core constant PCI_STATUS_ERROR_BITS to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/fddi/skfp/drvfbi.c  | 4 ++--
 drivers/net/fddi/skfp/h/skfbi.h | 5 -----
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/fddi/skfp/drvfbi.c b/drivers/net/fddi/skfp/drvfbi.c
index 9c8aa3a95..cc9ac5724 100644
--- a/drivers/net/fddi/skfp/drvfbi.c
+++ b/drivers/net/fddi/skfp/drvfbi.c
@@ -20,7 +20,7 @@
 #include "h/supern_2.h"
 #include "h/skfbiinc.h"
 #include <linux/bitrev.h>
-#include <linux/pci_regs.h>
+#include <linux/pci.h>
 
 #ifndef	lint
 static const char ID_sccs[] = "@(#)drvfbi.c	1.63 99/02/11 (C) SK " ;
@@ -112,7 +112,7 @@ static void card_start(struct s_smc *smc)
 	 */
 	outp(ADDR(B0_TST_CTRL), TST_CFG_WRITE_ON) ;	/* enable for writes */
 	word = inpw(PCI_C(PCI_STATUS)) ;
-	outpw(PCI_C(PCI_STATUS), word | PCI_ERRBITS) ;
+	outpw(PCI_C(PCI_STATUS), word | PCI_STATUS_ERROR_BITS);
 	outp(ADDR(B0_TST_CTRL), TST_CFG_WRITE_OFF) ;	/* disable writes */
 
 	/*
diff --git a/drivers/net/fddi/skfp/h/skfbi.h b/drivers/net/fddi/skfp/h/skfbi.h
index 36e20a514..ccee00b71 100644
--- a/drivers/net/fddi/skfp/h/skfbi.h
+++ b/drivers/net/fddi/skfp/h/skfbi.h
@@ -33,11 +33,6 @@
  */
 #define I2C_ADDR_VPD	0xA0	/* I2C address for the VPD EEPROM */ 
 
-
-#define PCI_ERRBITS	(PCI_STATUS_DETECTED_PARITY | PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_REC_MASTER_ABORT | PCI_STATUS_REC_TARGET_ABORT | PCI_STATUS_SIG_TARGET_ABORT | PCI_STATUS_PARITY)
-
-
-
 /*
  *	Control Register File:
  *	Bank 0
-- 
2.25.1


