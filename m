Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E4B4CA85E
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 15:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243185AbiCBOpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 09:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241207AbiCBOpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 09:45:00 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7122B60CE3
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 06:44:16 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id r10so3172603wrp.3
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 06:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=FhWPuxj/YTUyK847np3IX93yxzJZHcz7qh4GO+7rXKE=;
        b=msaaAUtYJ4UsgZwG4sJuMhyxBIBNud3N4C+lLFW9viMe+uajCi99kjRwYykX652Lgw
         2eSEg9m/6Thl27dD6VUUYSkPVLH54de9va8DFzmM9uKdE+jGdik4V2AxcDjPRt35rRUb
         7J3Ip4w45tgm3bkTpAY7608rIwWUzCfwOUDbvo8OP6HrGh/eBXxu/g3NlRXUgyWTxnQ7
         SXtOpCdZrCfmkFdQpTOTWYHxPU8VHAyLZCM2k/SlgAbVKODxOX79JXrG3AnR/uhBKHpc
         vvGCPOC4bPdxA++OUaECwgdBTpG96LjSfeI9NY5M7AswjyV9Ccp8e5lshz5zSEGZ/P7J
         oAEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=FhWPuxj/YTUyK847np3IX93yxzJZHcz7qh4GO+7rXKE=;
        b=dGROjtdYImndcn9keryhonhmpHbCc6SD/wM2d00UXT5rmT5+h1pcgMjL6ngRlQP9JY
         dwTvNZ4TBqdKD7filztdHO+8+QSvQ/EehQhHPKS/xOUrIh5QI5yxnYi27gOXMUXlpz+P
         qYlY1PwSn00s4KcjBJ2y6OvpWk2OHsy326G6ZZPizjc7uuCnwW3TZsNx7uolUgROuYzZ
         SpmOyPQpx46T+BvSW+jPll0cbNHEeW0i1fLzgGYAQXQ68eMrD2edFJbDmcNWuQ5IqJRF
         uJDIF5UYm140t7dhmCFyUjpyC7xwpBKRjTwbWxJ4nkvHVauVC649iByQlq+h6RNLIt5R
         uRQQ==
X-Gm-Message-State: AOAM531RDwY5I2EFC5+MD8v8j66jg4ZGoKJD1b9Gv953oTLOS86Ws2jw
        UjRe4GS3HWTdaCZctTIZph6a5w==
X-Google-Smtp-Source: ABdhPJzpL4aEUuKagqpQ7KI1a1VSvKWc65xZONt1iWiFcNA6nLEK1U7HWta5oDI+FEGGzZdYSfZ2hw==
X-Received: by 2002:a5d:5889:0:b0:1ef:d7e1:c6c with SMTP id n9-20020a5d5889000000b001efd7e10c6cmr10337751wrf.569.1646232254953;
        Wed, 02 Mar 2022 06:44:14 -0800 (PST)
Received: from localhost (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id t9-20020a05600c198900b0037c0342cb62sm7842262wmq.4.2022.03.02.06.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 06:44:14 -0800 (PST)
References: <CAK4VdL3-BEBzgVXTMejrAmDjOorvoGDBZ14UFrDrKxVEMD2Zjg@mail.gmail.com>
 <1jczjzt05k.fsf@starbuckisacylon.baylibre.com>
 <CAK4VdL2=1ibpzMRJ97m02AiGD7_sN++F3SCKn6MyKRZX_nhm=g@mail.gmail.com>
 <6b04d864-7642-3f0a-aac0-a3db84e541af@gmail.com>
 <CAK4VdL0gpz_55aYo6pt+8h14FHxaBmo5kNookzua9+0w+E4JcA@mail.gmail.com>
 <1e828df4-7c5d-01af-cc49-3ef9de2cf6de@gmail.com>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
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
Subject: Re: net: stmmac: dwmac-meson8b: interface sometimes does not come
 up at boot
Date:   Wed, 02 Mar 2022 14:39:47 +0100
In-reply-to: <1e828df4-7c5d-01af-cc49-3ef9de2cf6de@gmail.com>
Message-ID: <1j8rts76te.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed 02 Mar 2022 at 12:01, Heiner Kallweit <hkallweit1@gmail.com> wrote:

> On 02.03.2022 11:33, Erico Nunes wrote:
>> On Sat, Feb 26, 2022 at 2:53 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>> Just to rule out that the PHY may be involved:
>>> - Does the issue occur with internal and/or external PHY?
>> 
>> My target boards have the internal phy only. It is not possible for me
>> at the moment to test it with an external phy.
>> 
>>> - Issue still occurs in PHY polling mode? (disable PHY interrupt in dts)
>> 
>> Thanks for suggesting this. I did tests with this and it seems to be a
>> workaround.
>> With phy interrupt on recent kernels (around v5.17-rc3) I'm able to
>> reproduce the issue relatively easily over a batch of a hundred jobs.
>> With my tests with the phy in polling mode, I have not been able to
>> reproduce so far, even with several hundred jobs.
>> 
> It's my understanding that in the problem case the "aneg complete"
> interrupt fires, but no data flows.
> This might indicate a timing issue. According to the meson PHY driver
> (I don't have the datasheet) the PHY doesn't have a "link up" interrupt
> source, just the mentioned "aneg complete".
>
> Below I send an experimental patch that delays the link up processing
> a little and eliminates not needed interrupt sources.
> Could you please test it with PHY interrupts enabled?
>
>
> By the way, to all:
> I found that interrupt mode is broken in fixed (aneg disabled) mode,
> because link-up isn't signaled. Experiments showed that irq source
> bit 7 can be used to fix this, but this bit isn't documented in the
> driver.
>
>> For completeness I also tested 46f69ded988d (from my initial analysis)
>> and setting the phy to polling mode there does not make a difference,
>> issue still reproduces. So it may have been a different bug. Though I
>> guess at this point we can disregard that and focus on the current
>> kernel.
>> 
>> I tried adding a few debugs and delays to the interrupt code path in
>> drivers/net/phy/meson-gxl.c but nothing gave me useful info so far.
>> 
>> Do you have more advice on how to proceed from here?
>> 
>> Thanks
>> 
>> Erico
>
> Heiner

Hi,

I also did some tests on my side as well. Mostly with v5.10.93 ATM
It is true that I can recall seeing this issue only on boards using the
internal PHY (g12 and gxl board for me - I don't have meson8b boards)

I tried on the u200 (g12 based). Being the ref design it has both
the internal and external interfaces and I can choose.

To my surprise, I could not reproduce the issue on it with the internal
PHY ... until I noticed that eMMC was initialising more or less at the
same time as the network.

I disabled the eMMC, out of curiosity, and the issue was back.
Like Heiner, I suspect a timing issue - at this stage, I can't tell if it
is PHY related though.

I also tried with the external phy, could not reproduce. Unfortunately,
as we can see from the first test on the u200, not reproducing is not
really a proof and it difficult to conclude.

Like Erico, I tried bisecting but I ended up on a BT merge ... Clearly
inconclusive :(

Disabling the IRQ is an interesting test but, on my side, I have mixed
results (on the libretech-cc this time):

* I first tried quickly while bisecting, on commit
  5.6.0-rc3-01434-g8d4ccd7770e7:
  - With IRQ => NOK
  - POLL => NOK

Seeing Erico's report, I thought maybe I mixed things up so I tried again,
doubled checked IRQ were disabled ... still broken. There was another
commit I reproduce it without IRQ but I lost it.

* I also tried on v5.10.93:
  - With IRQ => NOK
  - POLL => OK ... (well, I got bored before the issue showed up)

It seems that switching to polling, in some case, changes the timings
just enough to hide the issue ... but not always. Unless I forgot to
consider something else ?? Ideas ?

If I understand the proposed patch correctly, it is mostly about the phy
IRQ. Since I reproduce without the IRQ, I suppose it is not the
problem we where looking for (might still be a problem worth fixing -
the phy is not "rock-solid" when it comes to aneg - I already tried
stabilising it a few years ago)

TBH, It bothers me that I reproduced w/o the IRQ. The idea makes
sense :/

>
>
> diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
> index 7e7904fee..0acb3a99a 100644
> --- a/drivers/net/phy/meson-gxl.c
> +++ b/drivers/net/phy/meson-gxl.c
> @@ -7,6 +7,7 @@
>   * Author: Neil Armstrong <narmstrong@baylibre.com>
>   */
>  #include <linux/kernel.h>
> +#include <linux/delay.h>
>  #include <linux/module.h>
>  #include <linux/mii.h>
>  #include <linux/ethtool.h>
> @@ -209,12 +210,7 @@ static int meson_gxl_config_intr(struct phy_device *phydev)
>  		if (ret)
>  			return ret;
>  
> -		val = INTSRC_ANEG_PR
> -			| INTSRC_PARALLEL_FAULT
> -			| INTSRC_ANEG_LP_ACK
> -			| INTSRC_LINK_DOWN
> -			| INTSRC_REMOTE_FAULT
> -			| INTSRC_ANEG_COMPLETE;
> +		val = INTSRC_LINK_DOWN | INTSRC_ANEG_COMPLETE;
>  		ret = phy_write(phydev, INTSRC_MASK, val);
>  	} else {
>  		val = 0;
> @@ -240,6 +236,9 @@ static irqreturn_t meson_gxl_handle_interrupt(struct phy_device *phydev)
>  	if (irq_status == 0)
>  		return IRQ_NONE;
>  
> +	if (irq_status & INTSRC_ANEG_COMPLETE)
> +		msleep(100);
> +
>  	phy_trigger_machine(phydev);
>  
>  	return IRQ_HANDLED;

