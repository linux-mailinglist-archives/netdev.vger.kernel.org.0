Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B81D34CA2B1
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 12:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241175AbiCBLCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 06:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240583AbiCBLCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 06:02:50 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620656D85C
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 03:02:07 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id a5-20020a05600c224500b003832be89f25so1005025wmm.2
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 03:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=GK7LbsrLfu8NDtuAdj7VpigfGpU3e9sLo3rD9+yMAKg=;
        b=k+AVIXRPpET3eqsYjZTwW5Hwi8ly90xiacCytwW/sdH99Q1pv3OatYQSywJH8WbFOj
         rFFjCbaOE2/hJqKlseNMYm1JulAXxF6MYvEwodYD5qHvtYnNMpY05PprP8W60o+aBEN9
         8AO3xJzHmmRmibt2BqeLaWZuzbvIf3HmCn0FgBezOgYX5prJqN5DSl9on4YoLMldlva0
         eaSdsnt+MeY72NL12QwB9wprx2uMMSloXb7bUvKEOZVw+MG4Vl8Td8rBIdJ1HHHihoF4
         gmxZhzx3yfqvC0GTHNJ30ptgpANFKm33mN6AofqaU2EXXMKwGIcb81+urCz5PfKMLvqM
         giBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=GK7LbsrLfu8NDtuAdj7VpigfGpU3e9sLo3rD9+yMAKg=;
        b=jrqXZxarUotyr5AXIQrKQrtpXQ8ha4nAqBGXH2V+E5G88vXg71RZ2sB/gh2A2jSEa1
         cZoPl3PV0Rhg7OyJiHRiPhCXv5RxC28ULUVZujqc5iGA6d/oW1h8oo1hiYKdxpuKpNzW
         Ue8AVLgydqpTWWl8xZSch5f769Cd+eXEWtPFbFpqo2xkTdjFdFsS8W7nY6PWpPx2zomR
         ET+T1Roe64GV1WqWzNgVBFLLowO/pAWsqfXsv175t41Szctgqo5U1VfIv+1HrVCdmaBx
         CIOUUROxJQD2LiMGjkEbCOTZR/ffMHoRbkXiiSxOYMVgz0qcZaY78P5UqcAqU/56ReS/
         eqKg==
X-Gm-Message-State: AOAM530NfcbgjrgGmYzZREzZRHCato4h2fIc2kWbSk+pacE3jcjS/LEo
        zoB0dczQPRzogtvx8KsOnLo=
X-Google-Smtp-Source: ABdhPJysMuAwmk3s78nTsltDe2Isbs1ISpf2VRTVkR3jz46c8siZbMwco13uuyKzYlxiEe3ux7gl+g==
X-Received: by 2002:a05:600c:3c8b:b0:37f:1546:40c9 with SMTP id bg11-20020a05600c3c8b00b0037f154640c9mr20703326wmb.161.1646218925888;
        Wed, 02 Mar 2022 03:02:05 -0800 (PST)
Received: from ?IPV6:2a01:c22:7331:8a00:3d70:3e0f:83b8:3269? (dynamic-2a01-0c22-7331-8a00-3d70-3e0f-83b8-3269.c22.pool.telefonica.de. [2a01:c22:7331:8a00:3d70:3e0f:83b8:3269])
        by smtp.googlemail.com with ESMTPSA id g17-20020a5d4891000000b001e74e998bf9sm16392585wrq.33.2022.03.02.03.02.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 03:02:05 -0800 (PST)
Message-ID: <1e828df4-7c5d-01af-cc49-3ef9de2cf6de@gmail.com>
Date:   Wed, 2 Mar 2022 12:01:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Content-Language: en-US
To:     Erico Nunes <nunes.erico@gmail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-sunxi@lists.linux.dev
References: <CAK4VdL3-BEBzgVXTMejrAmDjOorvoGDBZ14UFrDrKxVEMD2Zjg@mail.gmail.com>
 <1jczjzt05k.fsf@starbuckisacylon.baylibre.com>
 <CAK4VdL2=1ibpzMRJ97m02AiGD7_sN++F3SCKn6MyKRZX_nhm=g@mail.gmail.com>
 <6b04d864-7642-3f0a-aac0-a3db84e541af@gmail.com>
 <CAK4VdL0gpz_55aYo6pt+8h14FHxaBmo5kNookzua9+0w+E4JcA@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: net: stmmac: dwmac-meson8b: interface sometimes does not come up
 at boot
In-Reply-To: <CAK4VdL0gpz_55aYo6pt+8h14FHxaBmo5kNookzua9+0w+E4JcA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.03.2022 11:33, Erico Nunes wrote:
> On Sat, Feb 26, 2022 at 2:53 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>> Just to rule out that the PHY may be involved:
>> - Does the issue occur with internal and/or external PHY?
> 
> My target boards have the internal phy only. It is not possible for me
> at the moment to test it with an external phy.
> 
>> - Issue still occurs in PHY polling mode? (disable PHY interrupt in dts)
> 
> Thanks for suggesting this. I did tests with this and it seems to be a
> workaround.
> With phy interrupt on recent kernels (around v5.17-rc3) I'm able to
> reproduce the issue relatively easily over a batch of a hundred jobs.
> With my tests with the phy in polling mode, I have not been able to
> reproduce so far, even with several hundred jobs.
> 
It's my understanding that in the problem case the "aneg complete"
interrupt fires, but no data flows.
This might indicate a timing issue. According to the meson PHY driver
(I don't have the datasheet) the PHY doesn't have a "link up" interrupt
source, just the mentioned "aneg complete".

Below I send an experimental patch that delays the link up processing
a little and eliminates not needed interrupt sources.
Could you please test it with PHY interrupts enabled?


By the way, to all:
I found that interrupt mode is broken in fixed (aneg disabled) mode,
because link-up isn't signaled. Experiments showed that irq source
bit 7 can be used to fix this, but this bit isn't documented in the
driver.

> For completeness I also tested 46f69ded988d (from my initial analysis)
> and setting the phy to polling mode there does not make a difference,
> issue still reproduces. So it may have been a different bug. Though I
> guess at this point we can disregard that and focus on the current
> kernel.
> 
> I tried adding a few debugs and delays to the interrupt code path in
> drivers/net/phy/meson-gxl.c but nothing gave me useful info so far.
> 
> Do you have more advice on how to proceed from here?
> 
> Thanks
> 
> Erico

Heiner


diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index 7e7904fee..0acb3a99a 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -7,6 +7,7 @@
  * Author: Neil Armstrong <narmstrong@baylibre.com>
  */
 #include <linux/kernel.h>
+#include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/mii.h>
 #include <linux/ethtool.h>
@@ -209,12 +210,7 @@ static int meson_gxl_config_intr(struct phy_device *phydev)
 		if (ret)
 			return ret;
 
-		val = INTSRC_ANEG_PR
-			| INTSRC_PARALLEL_FAULT
-			| INTSRC_ANEG_LP_ACK
-			| INTSRC_LINK_DOWN
-			| INTSRC_REMOTE_FAULT
-			| INTSRC_ANEG_COMPLETE;
+		val = INTSRC_LINK_DOWN | INTSRC_ANEG_COMPLETE;
 		ret = phy_write(phydev, INTSRC_MASK, val);
 	} else {
 		val = 0;
@@ -240,6 +236,9 @@ static irqreturn_t meson_gxl_handle_interrupt(struct phy_device *phydev)
 	if (irq_status == 0)
 		return IRQ_NONE;
 
+	if (irq_status & INTSRC_ANEG_COMPLETE)
+		msleep(100);
+
 	phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;
-- 
2.35.1

