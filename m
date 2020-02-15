Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE2D416006B
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 21:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgBOUOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 15:14:49 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44493 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgBOUOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 15:14:48 -0500
Received: by mail-lf1-f65.google.com with SMTP id v201so9064281lfa.11
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 12:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:organization:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RZU6b7gfrdt8OMDzxwYR5gKBxMlnTMfF9BrDkIci5yM=;
        b=RVaKWp+LU+qpcfltSEhHsKI9/eTvCt5UCyHqOiXnbSZQpuMAJsMQ3U3FVqbrClTzJr
         FKo1qPtMJ1EMXK8iR6nBHPRc/Vo1QbciKZv4M45N0CwJxDNPZOIYZl02p+CTBE4L58Fl
         ugARdLQe2en+IJTaVrXgHD+82Jgai8GraEYzbxm28Mg6Fr/JVg3/jVJ9A3iFAapIEBBq
         I9fOL9Dp8h54UfPa+7LYaWEWKLmC0ud6+pz8WStDIJ8X9wKFPewl6asfbaHk6Nt74cgH
         5x+Be+LFLGUGxdjMs14aNWxF1/obnk7gzSpy749pZRxt3n6hK5DUa4nn1P6CVHXkBzR1
         j15A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=RZU6b7gfrdt8OMDzxwYR5gKBxMlnTMfF9BrDkIci5yM=;
        b=iVtC5muJ/3uh+iElXFAWS1uefhk+QYNsCUXJWDq8cCXKUcNeU1qkuZUT+H4+6refQX
         LrdwG267RCqRW5pvMcMLmhSgdlGhI1MugpO4FnHXYuRyYCnq1ja0cEe/s+kuDB6NXoDL
         xOwwYXzK9ApkTkpAMkHIi2nxVD/odsPfevjdWwWOxnUn77Sa10kFj5+/Il0hH8+XMy3K
         6i6Z7DYZcccAfvWulnWO3be5oK+DE/EUzj/LArNo0vt0snVPNSvLTKJLkZAkFAR5I/NO
         AEya9YQhNEx+f6VN/EORfOPIBjSBl8zg7V5PubvqTR/ltp27hWr+14Bf7G700qFCgjMG
         7K/g==
X-Gm-Message-State: APjAAAXXBilpeWVpOHxqRiZGrez3Y6qCOdMs2ZNaGDem/wvg0tW/Wl+w
        xsDTW1XBtAj0bBa8CKIWoABLoryt/w4=
X-Google-Smtp-Source: APXvYqxKz7uDP1jZVW+aCMfYLd2lSMKQIlGEYiJGn9p9fPPyvo1OY2AcrBCF5LXLAybcS6hDMrGfyQ==
X-Received: by 2002:a19:5212:: with SMTP id m18mr4643662lfb.7.1581797686556;
        Sat, 15 Feb 2020 12:14:46 -0800 (PST)
Received: from wasted.cogentembedded.com ([2a00:1fa0:49d:f851:9745:99c9:a1aa:2f9c])
        by smtp.gmail.com with ESMTPSA id r26sm4748818lfm.82.2020.02.15.12.14.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Feb 2020 12:14:46 -0800 (PST)
Subject: [PATCH net-next v2 5/5] sh_eth: use Gigabit register map for R7S72100
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To:     "David S. Miller" <davem@davemloft.net>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
References: <effa9dea-638b-aa29-2ec3-942974de12a0@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <f11c0c8b-0837-2640-19ce-4d49022303eb@cogentembedded.com>
Date:   Sat, 15 Feb 2020 23:14:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <effa9dea-638b-aa29-2ec3-942974de12a0@cogentembedded.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The register maps for the Gigabit controllers and the Ether one used on
RZ/A1  (AKA R7S72100) are identical except for GECMR which is only present
on the true GEther controllers.  We no longer use the register map arrays
to determine if a given register exists,  and have added the GECMR flag to
the 'struct sh_eth_cpu_data' in the previous patch, so we're ready to drop
the R7S72100 specific register map -- this saves 216 bytes of object code
(ARM gcc 4.8.5).

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Tested-by: Chris Brandt <chris.brandt@renesas.com>

---
Changes in version 2:
- fixed the arch name in the description;
- added Chris' tag.

 drivers/net/ethernet/renesas/sh_eth.c |   68 ----------------------------------
 drivers/net/ethernet/renesas/sh_eth.h |    1 
 2 files changed, 1 insertion(+), 68 deletions(-)

Index: net-next/drivers/net/ethernet/renesas/sh_eth.c
===================================================================
--- net-next.orig/drivers/net/ethernet/renesas/sh_eth.c
+++ net-next/drivers/net/ethernet/renesas/sh_eth.c
@@ -142,69 +142,6 @@ static const u16 sh_eth_offset_gigabit[S
 	[FWALCR1]	= 0x00b4,
 };
 
-static const u16 sh_eth_offset_fast_rz[SH_ETH_MAX_REGISTER_OFFSET] = {
-	SH_ETH_OFFSET_DEFAULTS,
-
-	[EDSR]		= 0x0000,
-	[EDMR]		= 0x0400,
-	[EDTRR]		= 0x0408,
-	[EDRRR]		= 0x0410,
-	[EESR]		= 0x0428,
-	[EESIPR]	= 0x0430,
-	[TDLAR]		= 0x0010,
-	[TDFAR]		= 0x0014,
-	[TDFXR]		= 0x0018,
-	[TDFFR]		= 0x001c,
-	[RDLAR]		= 0x0030,
-	[RDFAR]		= 0x0034,
-	[RDFXR]		= 0x0038,
-	[RDFFR]		= 0x003c,
-	[TRSCER]	= 0x0438,
-	[RMFCR]		= 0x0440,
-	[TFTR]		= 0x0448,
-	[FDR]		= 0x0450,
-	[RMCR]		= 0x0458,
-	[RPADIR]	= 0x0460,
-	[FCFTR]		= 0x0468,
-	[CSMR]		= 0x04E4,
-
-	[ECMR]		= 0x0500,
-	[RFLR]		= 0x0508,
-	[ECSR]		= 0x0510,
-	[ECSIPR]	= 0x0518,
-	[PIR]		= 0x0520,
-	[APR]		= 0x0554,
-	[MPR]		= 0x0558,
-	[PFTCR]		= 0x055c,
-	[PFRCR]		= 0x0560,
-	[TPAUSER]	= 0x0564,
-	[MAHR]		= 0x05c0,
-	[MALR]		= 0x05c8,
-	[CEFCR]		= 0x0740,
-	[FRECR]		= 0x0748,
-	[TSFRCR]	= 0x0750,
-	[TLFRCR]	= 0x0758,
-	[RFCR]		= 0x0760,
-	[MAFCR]		= 0x0778,
-
-	[ARSTR]		= 0x0000,
-	[TSU_CTRST]	= 0x0004,
-	[TSU_FWSLC]	= 0x0038,
-	[TSU_VTAG0]	= 0x0058,
-	[TSU_ADSBSY]	= 0x0060,
-	[TSU_TEN]	= 0x0064,
-	[TSU_POST1]	= 0x0070,
-	[TSU_POST2]	= 0x0074,
-	[TSU_POST3]	= 0x0078,
-	[TSU_POST4]	= 0x007c,
-	[TSU_ADRH0]	= 0x0100,
-
-	[TXNLCR0]	= 0x0080,
-	[TXALCR0]	= 0x0084,
-	[RXNLCR0]	= 0x0088,
-	[RXALCR0]	= 0x008C,
-};
-
 static const u16 sh_eth_offset_fast_rcar[SH_ETH_MAX_REGISTER_OFFSET] = {
 	SH_ETH_OFFSET_DEFAULTS,
 
@@ -593,7 +530,7 @@ static struct sh_eth_cpu_data r7s72100_d
 	.chip_reset	= sh_eth_chip_reset,
 	.set_duplex	= sh_eth_set_duplex,
 
-	.register_type	= SH_ETH_REG_FAST_RZ,
+	.register_type	= SH_ETH_REG_GIGABIT,
 
 	.edtrr_trns	= EDTRR_TRNS_GETHER,
 	.ecsr_value	= ECSR_ICD,
@@ -3139,9 +3076,6 @@ static const u16 *sh_eth_get_register_of
 	case SH_ETH_REG_GIGABIT:
 		reg_offset = sh_eth_offset_gigabit;
 		break;
-	case SH_ETH_REG_FAST_RZ:
-		reg_offset = sh_eth_offset_fast_rz;
-		break;
 	case SH_ETH_REG_FAST_RCAR:
 		reg_offset = sh_eth_offset_fast_rcar;
 		break;
Index: net-next/drivers/net/ethernet/renesas/sh_eth.h
===================================================================
--- net-next.orig/drivers/net/ethernet/renesas/sh_eth.h
+++ net-next/drivers/net/ethernet/renesas/sh_eth.h
@@ -145,7 +145,6 @@ enum {
 
 enum {
 	SH_ETH_REG_GIGABIT,
-	SH_ETH_REG_FAST_RZ,
 	SH_ETH_REG_FAST_RCAR,
 	SH_ETH_REG_FAST_SH4,
 	SH_ETH_REG_FAST_SH3_SH2
