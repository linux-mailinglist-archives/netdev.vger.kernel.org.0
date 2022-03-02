Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDBB4CAA5C
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242506AbiCBQfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239689AbiCBQft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:35:49 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1F94B1E5
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:35:05 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id u1so3642612wrg.11
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 08:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=+KEne0a6IJLE6Osg+JtxCNTixxOaL7fmqtVO7EUGwdM=;
        b=eriiTgh3LKCyoVVVPO6fzaMx7unAv5KWFymHLCvAXaAtlU3baqkWijEISxNLBAqkAQ
         uaxhLjzPS0aZ+EiAhwTFNGSY1zDUsl04hf8Sp1HUTvFHOMvheIn+gE4JjDlAHpdzxjdx
         YCM9TvZ/q4LkbMtqrD6ejDnNXC7xVj3gizuQgnb3U9GOR2bTx76rM5l5fHuYGeA4asa0
         7ivj4h3lqER1A/eP2BwwOHk6zR0clcrIfWad0+QanCR0bgKAgXHcNjAt1dlp7fESagx4
         RCvtVyTJYLBRythecvOrGVfdzPZmYtVpQZynCY4Atb7XQ0lwIjdAk5rApwT/4VaFlXbd
         kB9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=+KEne0a6IJLE6Osg+JtxCNTixxOaL7fmqtVO7EUGwdM=;
        b=n9FQi6Zl2tPIUhh+16x06XWP0lVdEh50ATOTTyd8Qox+TE1Y76lUwm1nsUdrjPBEO9
         J01uEsRrl2C+VFvjcV0XQ1hB6Yc/LnH/soZ0syuAzJFO0NbOHdd5pjhDwRVHXouwNzVC
         ex7YlTeY7rlIfeo6Nj0oWEL0LgQOXrDn/BZ93e9dn/n1owTwXY99KCTZu/R75VMOvZLw
         iRxoAW1Fi24ckpLuR7AiM8XO3BfX+aTatLu1djxdkpMcTf9YrDDxtcig32E1+F8vpFz7
         OSDOLEHNUzRn7JqxtYQocsyGF3nhLMZdUDqu6qp6/lLlVfwwlnkHxCyDVJtDUbPYCygO
         9ZGQ==
X-Gm-Message-State: AOAM5317jhzKtPo1zi/PLKK9PnymXdz4zZw+fc4bosm1kGWuXJVuv4bx
        VnyAcqWpmvAHF/xHuCZX+G4=
X-Google-Smtp-Source: ABdhPJxun3EH+nXUunB7e4Mu5u0c6eahD3gMTpXb5Ff6KYLT9eAJgez2N+mUNLfGroTKnUZupS47Ug==
X-Received: by 2002:a05:6000:1b8a:b0:1e4:b3a3:4c1f with SMTP id r10-20020a0560001b8a00b001e4b3a34c1fmr24081428wru.202.1646238903719;
        Wed, 02 Mar 2022 08:35:03 -0800 (PST)
Received: from ?IPV6:2a01:c22:7331:8a00:f01c:7f48:1898:5008? (dynamic-2a01-0c22-7331-8a00-f01c-7f48-1898-5008.c22.pool.telefonica.de. [2a01:c22:7331:8a00:f01c:7f48:1898:5008])
        by smtp.googlemail.com with ESMTPSA id i20-20020a05600c355400b0038164ef5418sm6761846wmq.32.2022.03.02.08.35.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 08:35:03 -0800 (PST)
Message-ID: <a4d3fef1-d410-c029-cdff-4d90f578e2da@gmail.com>
Date:   Wed, 2 Mar 2022 17:34:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Content-Language: en-US
To:     Jerome Brunet <jbrunet@baylibre.com>,
        Erico Nunes <nunes.erico@gmail.com>,
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
 <1e828df4-7c5d-01af-cc49-3ef9de2cf6de@gmail.com>
 <1j8rts76te.fsf@starbuckisacylon.baylibre.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: net: stmmac: dwmac-meson8b: interface sometimes does not come up
 at boot
In-Reply-To: <1j8rts76te.fsf@starbuckisacylon.baylibre.com>
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

On 02.03.2022 14:39, Jerome Brunet wrote:
> 
> On Wed 02 Mar 2022 at 12:01, Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>> On 02.03.2022 11:33, Erico Nunes wrote:
>>> On Sat, Feb 26, 2022 at 2:53 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>> Just to rule out that the PHY may be involved:
>>>> - Does the issue occur with internal and/or external PHY?
>>>
>>> My target boards have the internal phy only. It is not possible for me
>>> at the moment to test it with an external phy.
>>>
>>>> - Issue still occurs in PHY polling mode? (disable PHY interrupt in dts)
>>>
>>> Thanks for suggesting this. I did tests with this and it seems to be a
>>> workaround.
>>> With phy interrupt on recent kernels (around v5.17-rc3) I'm able to
>>> reproduce the issue relatively easily over a batch of a hundred jobs.
>>> With my tests with the phy in polling mode, I have not been able to
>>> reproduce so far, even with several hundred jobs.
>>>
>> It's my understanding that in the problem case the "aneg complete"
>> interrupt fires, but no data flows.
>> This might indicate a timing issue. According to the meson PHY driver
>> (I don't have the datasheet) the PHY doesn't have a "link up" interrupt
>> source, just the mentioned "aneg complete".
>>
>> Below I send an experimental patch that delays the link up processing
>> a little and eliminates not needed interrupt sources.
>> Could you please test it with PHY interrupts enabled?
>>
>>
>> By the way, to all:
>> I found that interrupt mode is broken in fixed (aneg disabled) mode,
>> because link-up isn't signaled. Experiments showed that irq source
>> bit 7 can be used to fix this, but this bit isn't documented in the
>> driver.
>>
>>> For completeness I also tested 46f69ded988d (from my initial analysis)
>>> and setting the phy to polling mode there does not make a difference,
>>> issue still reproduces. So it may have been a different bug. Though I
>>> guess at this point we can disregard that and focus on the current
>>> kernel.
>>>
>>> I tried adding a few debugs and delays to the interrupt code path in
>>> drivers/net/phy/meson-gxl.c but nothing gave me useful info so far.
>>>
>>> Do you have more advice on how to proceed from here?
>>>
>>> Thanks
>>>
>>> Erico
>>
>> Heiner
> 
> Hi,
> 
> I also did some tests on my side as well. Mostly with v5.10.93 ATM
> It is true that I can recall seeing this issue only on boards using the
> internal PHY (g12 and gxl board for me - I don't have meson8b boards)
> 
> I tried on the u200 (g12 based). Being the ref design it has both
> the internal and external interfaces and I can choose.
> 
> To my surprise, I could not reproduce the issue on it with the internal
> PHY ... until I noticed that eMMC was initialising more or less at the
> same time as the network.
> 
> I disabled the eMMC, out of curiosity, and the issue was back.
> Like Heiner, I suspect a timing issue - at this stage, I can't tell if it
> is PHY related though.
> 
> I also tried with the external phy, could not reproduce. Unfortunately,
> as we can see from the first test on the u200, not reproducing is not
> really a proof and it difficult to conclude.
> 
> Like Erico, I tried bisecting but I ended up on a BT merge ... Clearly
> inconclusive :(
> 
> Disabling the IRQ is an interesting test but, on my side, I have mixed
> results (on the libretech-cc this time):
> 
> * I first tried quickly while bisecting, on commit
>   5.6.0-rc3-01434-g8d4ccd7770e7:
>   - With IRQ => NOK
>   - POLL => NOK
> 
> Seeing Erico's report, I thought maybe I mixed things up so I tried again,
> doubled checked IRQ were disabled ... still broken. There was another
> commit I reproduce it without IRQ but I lost it.
> 
> * I also tried on v5.10.93:
>   - With IRQ => NOK
>   - POLL => OK ... (well, I got bored before the issue showed up)
> 
> It seems that switching to polling, in some case, changes the timings
> just enough to hide the issue ... but not always. Unless I forgot to
> consider something else ?? Ideas ?
> 
When using polling the time difference between aneg complete and
PHY state machine run is random in the interval 0 .. 1s.
Hence there's a certain chance that the difference is too small
to avoid the issue.

> If I understand the proposed patch correctly, it is mostly about the phy
> IRQ. Since I reproduce without the IRQ, I suppose it is not the
> problem we where looking for (might still be a problem worth fixing -
> the phy is not "rock-solid" when it comes to aneg - I already tried
> stabilising it a few years ago)

Below is a slightly improved version of the test patch. It doesn't sleep
in the (threaded) interrupt handler and lets the workqueue do it.

Maybe Amlogic is aware of a potentially related silicon issue?

> 
> TBH, It bothers me that I reproduced w/o the IRQ. The idea makes
> sense :/
> 
>>
[...]
> 


diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index 7e7904fee..a3318ae01 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -209,12 +209,7 @@ static int meson_gxl_config_intr(struct phy_device *phydev)
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
@@ -240,7 +235,10 @@ static irqreturn_t meson_gxl_handle_interrupt(struct phy_device *phydev)
 	if (irq_status == 0)
 		return IRQ_NONE;
 
-	phy_trigger_machine(phydev);
+	if (irq_status & INTSRC_ANEG_COMPLETE)
+		phy_queue_state_machine(phydev, msecs_to_jiffies(100));
+	else
+		phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;
 }
-- 
2.35.1


