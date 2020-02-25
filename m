Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E54316C35D
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 15:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbgBYOIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 09:08:39 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44621 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730636AbgBYOIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 09:08:37 -0500
Received: by mail-wr1-f67.google.com with SMTP id m16so14856169wrx.11;
        Tue, 25 Feb 2020 06:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JL4Q1l1W07XAcq8S0r/D3xLT9kgasro6XokOt1NtSiI=;
        b=MZWJuGhSP85kFq7spVW+O11aVWt7Xewr+oYPq73Zn+JD71eMwAVPXm96SD2gdNAGJZ
         1uqEuPNRjme7Ac18Ghbp/9K0bvBLXE0S0l/2/dO3VQQZxs4aCuxhDhSCFKQq8k55DZeR
         x5r58FBU/txaSh/cZGJ0KnOFihaNVpZD98mNtEZcnF6SzGEMkaK3nK8b9C4PGsaN1goo
         PwJ90DzR/4H3SckQI2tetCNgH+GWBb+qhxjV+MGMeFIZPByu6ko6cpkAt7ebZ2f7A7SH
         D2XvgJ0+uFfilXnxRp7REUQ3T1Gp8mEHOxk83fay7bep2rjiklcBwzO0fO0s2lkspwgS
         aj5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JL4Q1l1W07XAcq8S0r/D3xLT9kgasro6XokOt1NtSiI=;
        b=SzZ6c3A4vHY369iaphSRRejz4UoK4d5jtg/taJmRTn9ZCYYPVnVbABXzsnF5nGiLRK
         MrpgTRnfDx+eHl6roUm40eknZIsaTaeHU7YaHXT5fvHzFj/XEJx2kRhztThN/tTAld4b
         pIzwM7tuiQETNoUDibhr2JWrrZe4nhXk+aZlLHjdPoWRPzAjeORfJNKKvlFw5IOqcM0B
         9faXhGr/WHGeLzm/TeSVo3h0cmRsoPL/w5YU8AIyfPXEby739JvU1rAtCbiu0B7vDpP+
         N5UzVq0Q91j1egLSaVJyDumdW3Cd4ZRyPbQyQGbzVbim0zvXjOGEsKd+grpEiW2EMC/L
         Gqtw==
X-Gm-Message-State: APjAAAVQT5RpoLlsO41Sl46S0bj4DIPgTB98QY5mHTmUTcH9C7/TdXi6
        ZqZlOUNKSfzXfbP/Y9g8eHM=
X-Google-Smtp-Source: APXvYqxaeJdsQZUPEGWE+H0VhtPrOGAnLR724qjByg+055q0tc1L6tghO3BMF3ID4Tp9+RTEOOTWBg==
X-Received: by 2002:a05:6000:188:: with SMTP id p8mr72225419wrx.336.1582639715749;
        Tue, 25 Feb 2020 06:08:35 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:30a8:e117:ed7d:d145? (p200300EA8F29600030A8E117ED7DD145.dip0.t-ipconnect.de. [2003:ea:8f29:6000:30a8:e117:ed7d:d145])
        by smtp.googlemail.com with ESMTPSA id m21sm4155888wmi.27.2020.02.25.06.08.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 06:08:35 -0800 (PST)
Subject: [PATCH v3 6/8] net: skfp: use PCI_STATUS_ERROR_BITS
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
Message-ID: <a012a7cf-d960-0bf8-29d2-403b75589c64@gmail.com>
Date:   Tue, 25 Feb 2020 15:06:17 +0100
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

Use new constant PCI_STATUS_ERROR_BITS to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/fddi/skfp/drvfbi.c  | 2 +-
 drivers/net/fddi/skfp/h/skfbi.h | 5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/fddi/skfp/drvfbi.c b/drivers/net/fddi/skfp/drvfbi.c
index 9c8aa3a95..d5937aff5 100644
--- a/drivers/net/fddi/skfp/drvfbi.c
+++ b/drivers/net/fddi/skfp/drvfbi.c
@@ -112,7 +112,7 @@ static void card_start(struct s_smc *smc)
 	 */
 	outp(ADDR(B0_TST_CTRL), TST_CFG_WRITE_ON) ;	/* enable for writes */
 	word = inpw(PCI_C(PCI_STATUS)) ;
-	outpw(PCI_C(PCI_STATUS), word | PCI_ERRBITS) ;
+	outpw(PCI_C(PCI_STATUS), word | PCI_STATUS_ERROR_BITS) ;
 	outp(ADDR(B0_TST_CTRL), TST_CFG_WRITE_OFF) ;	/* disable writes */
 
 	/*
diff --git a/drivers/net/fddi/skfp/h/skfbi.h b/drivers/net/fddi/skfp/h/skfbi.h
index 480795681..ccee00b71 100644
--- a/drivers/net/fddi/skfp/h/skfbi.h
+++ b/drivers/net/fddi/skfp/h/skfbi.h
@@ -33,11 +33,6 @@
  */
 #define I2C_ADDR_VPD	0xA0	/* I2C address for the VPD EEPROM */ 
 
-
-#define PCI_ERRBITS	(PCI_STATUS_DETECTED_PARITY | PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_REC_MASTER_ABORT | PCI_STATUS_SIG_TARGET_ABORT | PCI_STATUS_PARITY)
-
-
-
 /*
  *	Control Register File:
  *	Bank 0
-- 
2.25.1




