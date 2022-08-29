Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843065A43DF
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 09:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiH2Hj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 03:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiH2Hjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 03:39:53 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1192E3C
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 00:39:50 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id h1so3824054wmd.3
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 00:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc;
        bh=KaZgMwplnuslzJhhVuBzd2g94LKqdlAIhgCC8zBrKio=;
        b=4ctmSWlsTinjR4aogFpSa3+8Tl5TuYZVGZPnGi/meHCFhS+Es2+ukl0qtQzlxjPBOC
         ub5C7pHBHMGB9DK9SaQppjdJHnG1hxOpAHDiq+8D3iiKvKvkYVIcE1dfpO5EfmsXoeeb
         EPXx+eCujdgzZLamjuhDrDHU37qJUlQZeKCfU/Wte2dphz27KpU+xk9yYW8+mERjSsmh
         htLcDjhoAnrMFCPbXD/tKEnwJoWLlur/EO+rmRk8Lmjt9hdhzfaSSwHHdGeQ2ZxGarlO
         rzzI0q5css4+uCMmpSV0nXdwiMCtxOwJdRNoRXXZ4vrcYFjNTvDVXP/7dqeFVZkCkLaF
         Qadw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=KaZgMwplnuslzJhhVuBzd2g94LKqdlAIhgCC8zBrKio=;
        b=Cwjc3EpR0+a0RWo+ogflfY3X/Bhpke164M0Gth1XyptDBoMXRSE+HdUi/CePJedj//
         qxPsAq1oJvtqLOk4Zp7ER03V23XJUrTpdeiJviPfyOnjzhEQGrtvNu1IL7RIfe7fly0F
         GaLPYC0R+cb4Eo1s9NZpRkrmHtYFXXAQyWvL/2ue1eCGePUCDQ6LdfGai2UWT3kFtB+b
         M/5+5dDaCh4LP4PRmRE7op/o1M7jE6oSdrEBu70ZmkxfL6z1KC/GHi3Ub3Fva8FkI3JC
         3Adj5cHJZ01pwaEhcS3gaBJ43azUxOetdTJebC1y7q/uhI03fa3Qxr6p39kMPgn1YLAG
         6QqQ==
X-Gm-Message-State: ACgBeo0qXxHIduSO4CiFQgnoWLJEAx3+g0ySknZmYFrX4/pTHPZo6vmL
        8NUt6GrHragjT/9IJfbSocJpxA==
X-Google-Smtp-Source: AA6agR4PjCzCrzONMklaqlVgrB6zt/yFnNhS9+nt+svr6PX/OnOfLU/DCpvPilsONxyDTEnPfeHFFA==
X-Received: by 2002:a05:600c:a18f:b0:3a5:bf94:6abe with SMTP id id15-20020a05600ca18f00b003a5bf946abemr6172274wmb.160.1661758789286;
        Mon, 29 Aug 2022 00:39:49 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:6124:6b74:2847:d37b? ([2a01:e0a:982:cbb0:6124:6b74:2847:d37b])
        by smtp.gmail.com with ESMTPSA id l6-20020a5d4bc6000000b00226d3fdee41sm5817127wrt.81.2022.08.29.00.39.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Aug 2022 00:39:48 -0700 (PDT)
Message-ID: <362ed4b7-c3f8-8941-3614-2ad44a722e6e@baylibre.com>
Date:   Mon, 29 Aug 2022 09:39:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC/RFT PATCH] net: stmmac: do not poke MAC_CTRL_REG twice on
 link up
Content-Language: en-US
To:     Da Xue <da@lessconfused.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Erico Nunes <nunes.erico@gmail.com>, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Vyacheslav <adeep@lexina.in>, Qi Duan <qi.duan@amlogic.com>
References: <20220707101423.90106-1-jbrunet@baylibre.com>
 <00f1e968-c140-29b9-dc82-a6f831171d6f@gmail.com>
 <CACdvmAiyFQTUgEzkva9j8xYJYYBRXg_sfB562f3F515AHmkUoA@mail.gmail.com>
 <5c8f4cc4-9807-cfe5-7e0a-7961aef5057f@gmail.com>
 <CACdvmAjrQ6WgDm2pYtFQmR-Yts+4jYeOskpNWxuLe=vFWP_R7Q@mail.gmail.com>
From:   Neil Armstrong <narmstrong@baylibre.com>
Organization: Baylibre
In-Reply-To: <CACdvmAjrQ6WgDm2pYtFQmR-Yts+4jYeOskpNWxuLe=vFWP_R7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/08/2022 22:23, Da Xue wrote:
> On Fri, Aug 26, 2022 at 4:36 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> On 26.08.2022 17:45, Da Xue wrote:
>>> Hi Heiner,
>>>
>>> I have been running with the patch reverted for about two weeks now
>>> without issue but I have a modified u-boot with ethernet bringup
>>> disabled.
>>>
>>> If u-boot brings up ethernet, all of the GXL boards with more than 1GB
>>> memory experience various bugs. I had to bring the PHY initialization
>>> patch into Linux proper:
>>> https://github.com/libre-computer-project/libretech-linux/commit/1a4004c11877d4239b57b182da1ce69a81c0150c
>>>
>> Thanks for the follow-up. To be acceptable upstream I'm pretty sure that
>> the maintainer is going to request replacing magic number 0x10110181
>> with or'ing proper constants for the respective bits and fields.
> 
> Yes, it's a 32-bit field with a 32-bit value per the datasheet so a
> full write will do without bits and xors. This was just a quick patch
> from Duan. The patch as-is is not meant for upstream. I don't have any
> ODROID-C2 to test GXBB so can someone please confirm it doesn't blow
> anything up there? or maybe this should be a quirk for GXL only.

This register is only valid on GXL& GXM, and is part of the PHY MUX.

Today we use the MDIO MMIO mux, whoch works but is verly limited, we should
instead have a proper MDIO mux for GXL like we have for G12A.

With such driver we would initialize all PHY MUX registers, including this one.

Neil

> 
>>
>>> Hope this helps someone.
>>>
>>> Best,
>>>
>>> Da
>>>
>>> On Fri, Aug 26, 2022 at 5:51 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>>
>>>> On 07.07.2022 12:14, Jerome Brunet wrote:
>>>>> For some reason, poking MAC_CTRL_REG a second time, even with the same
>>>>> value, causes problem on a dwmac 3.70a.
>>>>>
>>>>> This problem happens on all the Amlogic SoCs, on link up, when the RMII
>>>>> 10/100 internal interface is used. The problem does not happen on boards
>>>>> using the external RGMII 10/100/1000 interface. Initially we suspected the
>>>>> PHY to be the problem but after a lot of testing, the problem seems to be
>>>>> coming from the MAC controller.
>>>>>
>>>>>> meson8b-dwmac c9410000.ethernet: IRQ eth_wake_irq not found
>>>>>> meson8b-dwmac c9410000.ethernet: IRQ eth_lpi not found
>>>>>> meson8b-dwmac c9410000.ethernet: PTP uses main clock
>>>>>> meson8b-dwmac c9410000.ethernet: User ID: 0x11, Synopsys ID: 0x37
>>>>>> meson8b-dwmac c9410000.ethernet:     DWMAC1000
>>>>>> meson8b-dwmac c9410000.ethernet: DMA HW capability register supported
>>>>>> meson8b-dwmac c9410000.ethernet: RX Checksum Offload Engine supported
>>>>>> meson8b-dwmac c9410000.ethernet: COE Type 2
>>>>>> meson8b-dwmac c9410000.ethernet: TX Checksum insertion supported
>>>>>> meson8b-dwmac c9410000.ethernet: Wake-Up On Lan supported
>>>>>> meson8b-dwmac c9410000.ethernet: Normal descriptors
>>>>>> meson8b-dwmac c9410000.ethernet: Ring mode enabled
>>>>>> meson8b-dwmac c9410000.ethernet: Enable RX Mitigation via HW Watchdog Timer
>>>>>
>>>>> The problem is not systematic. Its occurence is very random from 1/50 to
>>>>> 1/2. It is fairly easy to detect by setting the kernel to boot over NFS and
>>>>> possibly setting it to reboot automatically when reaching the prompt.
>>>>>
>>>>> When problem happens, the link is reported up by the PHY but no packet are
>>>>> actually going out. DHCP requests eventually times out and the kernel reset
>>>>> the interface. It may take several attempts but it will eventually work.
>>>>>
>>>>>> meson8b-dwmac ff3f0000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
>>>>>> Sending DHCP requests ...... timed out!
>>>>>> meson8b-dwmac ff3f0000.ethernet eth0: Link is Down
>>>>>> IP-Config: Retrying forever (NFS root)...
>>>>>> meson8b-dwmac ff3f0000.ethernet eth0: PHY [0.1:08] driver [Meson G12A Internal PHY] (irq=POLL)
>>>>>> meson8b-dwmac ff3f0000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
>>>>>> meson8b-dwmac ff3f0000.ethernet eth0: No Safety Features support found
>>>>>> meson8b-dwmac ff3f0000.ethernet eth0: PTP not supported by HW
>>>>>> meson8b-dwmac ff3f0000.ethernet eth0: configuring for phy/rmii link mode
>>>>>> meson8b-dwmac ff3f0000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
>>>>>> Sending DHCP requests ...... timed out!
>>>>>> meson8b-dwmac ff3f0000.ethernet eth0: Link is Down
>>>>>> IP-Config: Retrying forever (NFS root)...
>>>>>> [...] 5 retries ...
>>>>>> IP-Config: Retrying forever (NFS root)...
>>>>>> meson8b-dwmac ff3f0000.ethernet eth0: PHY [0.1:08] driver [Meson G12A Internal PHY] (irq=POLL)
>>>>>> meson8b-dwmac ff3f0000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
>>>>>> meson8b-dwmac ff3f0000.ethernet eth0: No Safety Features support found
>>>>>> meson8b-dwmac ff3f0000.ethernet eth0: PTP not supported by HW
>>>>>> meson8b-dwmac ff3f0000.ethernet eth0: configuring for phy/rmii link mode
>>>>>> meson8b-dwmac ff3f0000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
>>>>>> Sending DHCP requests ., OK
>>>>>> IP-Config: Got DHCP answer from 10.1.1.1, my address is 10.1.3.229
>>>>>
>>>>> Of course the same problem happens when not using NFS and it fairly
>>>>> difficult for IoT products to detect this situation and recover.
>>>>>
>>>>> The call to stmmac_mac_set() should be no-op in our case, the bits it sets
>>>>> have already been set by an earlier call to stmmac_mac_set(). However
>>>>> removing this call solves the problem. We have no idea why or what is the
>>>>> actual problem.
>>>>>
>>>>> Even weirder, keeping the call to stmmac_mac_set() but inserting a
>>>>> udelay(1) between writel() and stmmac_mac_set() solves the problem too.
>>>>>
>>>>> Suggested-by: Qi Duan <qi.duan@amlogic.com>
>>>>> Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
>>>>> ---
>>>>>
>>>>>   Hi,
>>>>>
>>>>>   There is no intention to get this patch merged as it is.
>>>>>   It is sent with the hope to get a better understanding of the issue
>>>>>   and more testing.
>>>>>
>>>>>   The discussion on this issue initially started on this thread
>>>>>   https://lore.kernel.org/all/CAK4VdL3-BEBzgVXTMejrAmDjOorvoGDBZ14UFrDrKxVEMD2Zjg@mail.gmail.com/
>>>>>
>>>>>   The patches previously proposed in this thread have not solved the
>>>>>   problem.
>>>>>
>>>>>   The line removed in this patch should be a no-op when it comes to the
>>>>>   value of MAC_CTRL_REG. So the change should make not a difference but
>>>>>   it does. Testing result have been very good so far so there must be an
>>>>>   unexpected consequence on the HW. I hope that someone with more
>>>>>   knowledge on this controller will be able to shine some light on this.
>>>>>
>>>>>   Cheers
>>>>>   Jerome
>>>>>
>>>>>   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 -
>>>>>   1 file changed, 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>>>> index d1a7cf4567bc..3dca3cc61f39 100644
>>>>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>>>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>>>> @@ -1072,7 +1072,6 @@ static void stmmac_mac_link_up(struct phylink_config *config,
>>>>>
>>>>>        writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
>>>>>
>>>>> -     stmmac_mac_set(priv, priv->ioaddr, true);
>>>>>        if (phy && priv->dma_cap.eee) {
>>>>>                priv->eee_active = phy_init_eee(phy, 1) >= 0;
>>>>>                priv->eee_enabled = stmmac_eee_init(priv);
>>>>
>>>> Now that we have a3a57bf07de2 ("net: stmmac: work around sporadic tx issue on link-up")
>>>> in linux-next and scheduled for stable:
>>>>
>>>> Jerome, can you confirm that after this commit the following is no longer needed?
>>>> 2c87c6f9fbdd ("net: phy: meson-gxl: improve link-up behavior")
>>>>
>>>> Then I'd revert it, referencing the successor workaround / fix in stmmac.
>>

