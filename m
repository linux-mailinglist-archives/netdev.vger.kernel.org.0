Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888FE5A46B8
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 12:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiH2KDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 06:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiH2KDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 06:03:01 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6169A5F200
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 03:02:48 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n23-20020a7bc5d7000000b003a62f19b453so7884560wmk.3
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 03:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc;
        bh=RSpmWWW2M/EWteGkYL0M+RoGkA0XlRzUIHA3kJZw6io=;
        b=C7QI+KhHNkL+iE9j2ryBVdubetvYv3+hhQLWmQPLJlQvCRppXHx1NhOSDoY4q4golZ
         n7XVVNN9zYV6kCPlp5PYFcku6Y44Jwx2rjghuwATEclTwaLZ/gMFWrV+FxCsFksZZsKA
         YH19MyHHFlQ4dBxIVCU79y1N2T9da/eKwzpZZzEaGh4Rk9LdSLTh4cmEwlUD6b2FMCur
         aWF0BolgkmLzk+Z1o7YsyQuxwKrxj4rKC4pInKKNP1Myg0eZtpukpWFxROwoGJWfL0Rw
         pJV8qlyB5rf8FAKyXwsO1RbH1CUtPX25ML9HqvvhYJxrYLafygxruEYqL77RiQvcJroG
         GEPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc;
        bh=RSpmWWW2M/EWteGkYL0M+RoGkA0XlRzUIHA3kJZw6io=;
        b=zTHjLaJFXSJj9eDNEsDNS7AzchJYos702/JLyiocxX//ymab4Fl0uhjFOGfhnMzbcW
         XA3rYqduYjqm0PXMztt25yOqsgbvi8UpKQnIAL78EWZT/aAHVJjsHAQZDKkFiQU4YDz1
         +kRJFnI6jDaqFTvWPsR901O1sMUPGUy9Fa5MHqdbXXQGMxOcl8XJOzR3vo30NQrhS7Y5
         ec+c4kYSx71DR7aTXDAXasxc6c1EgFApB9eFsSbBMv8Lq1Ojg9WKWA6Y1VNCu+8+90bp
         gzKMfmT1mhW0f16Rxo0Co8UAcTc+G3ENB6krmS4EmzUYeRsLrbkDCQYc+PTd6JwHTSvo
         l2nw==
X-Gm-Message-State: ACgBeo1P6P/5mNsEF5xLR4pjHabVyzIF4fmWvH/Awd4uz2KoWWde/bLJ
        XaxAsUMuyWaN+Ju4S5jQW2ZDOA==
X-Google-Smtp-Source: AA6agR7mxBaRRcpw1PPBpOPIMhkDgJT5Y631/WBJP6nWabn00hs1ynhvbCpugbG0qvTWb8rjERnEbA==
X-Received: by 2002:a1c:a383:0:b0:3a5:af21:1ef0 with SMTP id m125-20020a1ca383000000b003a5af211ef0mr6213450wme.123.1661767365871;
        Mon, 29 Aug 2022 03:02:45 -0700 (PDT)
Received: from localhost (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id bd22-20020a05600c1f1600b003a8436e2a94sm4424113wmb.16.2022.08.29.03.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 03:02:45 -0700 (PDT)
References: <20220707101423.90106-1-jbrunet@baylibre.com>
 <00f1e968-c140-29b9-dc82-a6f831171d6f@gmail.com>
 <CACdvmAiyFQTUgEzkva9j8xYJYYBRXg_sfB562f3F515AHmkUoA@mail.gmail.com>
 <5c8f4cc4-9807-cfe5-7e0a-7961aef5057f@gmail.com>
User-agent: mu4e 1.8.7; emacs 28.1
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Da Xue <da@lessconfused.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Erico Nunes <nunes.erico@gmail.com>, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Vyacheslav <adeep@lexina.in>, Qi Duan <qi.duan@amlogic.com>
Subject: Re: [RFC/RFT PATCH] net: stmmac: do not poke MAC_CTRL_REG twice on
 link up
Date:   Mon, 29 Aug 2022 12:01:25 +0200
In-reply-to: <5c8f4cc4-9807-cfe5-7e0a-7961aef5057f@gmail.com>
Message-ID: <1jfshftliz.fsf@starbuckisacylon.baylibre.com>
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


On Fri 26 Aug 2022 at 22:36, Heiner Kallweit <hkallweit1@gmail.com> wrote:

> On 26.08.2022 17:45, Da Xue wrote:
>> Hi Heiner,
>> 
>> I have been running with the patch reverted for about two weeks now
>> without issue but I have a modified u-boot with ethernet bringup
>> disabled.
>> 
>> If u-boot brings up ethernet, all of the GXL boards with more than 1GB
>> memory experience various bugs. I had to bring the PHY initialization
>> patch into Linux proper:
>> https://github.com/libre-computer-project/libretech-linux/commit/1a4004c11877d4239b57b182da1ce69a81c0150c
>> 
> Thanks for the follow-up. To be acceptable upstream I'm pretty sure that
> the maintainer is going to request replacing magic number 0x10110181
> with or'ing proper constants for the respective bits and fields.
>
>> Hope this helps someone.
>> 
>> Best,
>> 
>> Da
>> 
>> On Fri, Aug 26, 2022 at 5:51 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>
>>> On 07.07.2022 12:14, Jerome Brunet wrote:
>>>> For some reason, poking MAC_CTRL_REG a second time, even with the same
>>>> value, causes problem on a dwmac 3.70a.
>>>>
>>>> This problem happens on all the Amlogic SoCs, on link up, when the RMII
>>>> 10/100 internal interface is used. The problem does not happen on boards
>>>> using the external RGMII 10/100/1000 interface. Initially we suspected the
>>>> PHY to be the problem but after a lot of testing, the problem seems to be
>>>> coming from the MAC controller.
>>>>
>>>>> meson8b-dwmac c9410000.ethernet: IRQ eth_wake_irq not found
>>>>> meson8b-dwmac c9410000.ethernet: IRQ eth_lpi not found
>>>>> meson8b-dwmac c9410000.ethernet: PTP uses main clock
>>>>> meson8b-dwmac c9410000.ethernet: User ID: 0x11, Synopsys ID: 0x37
>>>>> meson8b-dwmac c9410000.ethernet:     DWMAC1000
>>>>> meson8b-dwmac c9410000.ethernet: DMA HW capability register supported
>>>>> meson8b-dwmac c9410000.ethernet: RX Checksum Offload Engine supported
>>>>> meson8b-dwmac c9410000.ethernet: COE Type 2
>>>>> meson8b-dwmac c9410000.ethernet: TX Checksum insertion supported
>>>>> meson8b-dwmac c9410000.ethernet: Wake-Up On Lan supported
>>>>> meson8b-dwmac c9410000.ethernet: Normal descriptors
>>>>> meson8b-dwmac c9410000.ethernet: Ring mode enabled
>>>>> meson8b-dwmac c9410000.ethernet: Enable RX Mitigation via HW Watchdog Timer
>>>>
>>>> The problem is not systematic. Its occurence is very random from 1/50 to
>>>> 1/2. It is fairly easy to detect by setting the kernel to boot over NFS and
>>>> possibly setting it to reboot automatically when reaching the prompt.
>>>>
>>>> When problem happens, the link is reported up by the PHY but no packet are
>>>> actually going out. DHCP requests eventually times out and the kernel reset
>>>> the interface. It may take several attempts but it will eventually work.
>>>>
>>>>> meson8b-dwmac ff3f0000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
>>>>> Sending DHCP requests ...... timed out!
>>>>> meson8b-dwmac ff3f0000.ethernet eth0: Link is Down
>>>>> IP-Config: Retrying forever (NFS root)...
>>>>> meson8b-dwmac ff3f0000.ethernet eth0: PHY [0.1:08] driver [Meson G12A Internal PHY] (irq=POLL)
>>>>> meson8b-dwmac ff3f0000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
>>>>> meson8b-dwmac ff3f0000.ethernet eth0: No Safety Features support found
>>>>> meson8b-dwmac ff3f0000.ethernet eth0: PTP not supported by HW
>>>>> meson8b-dwmac ff3f0000.ethernet eth0: configuring for phy/rmii link mode
>>>>> meson8b-dwmac ff3f0000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
>>>>> Sending DHCP requests ...... timed out!
>>>>> meson8b-dwmac ff3f0000.ethernet eth0: Link is Down
>>>>> IP-Config: Retrying forever (NFS root)...
>>>>> [...] 5 retries ...
>>>>> IP-Config: Retrying forever (NFS root)...
>>>>> meson8b-dwmac ff3f0000.ethernet eth0: PHY [0.1:08] driver [Meson G12A Internal PHY] (irq=POLL)
>>>>> meson8b-dwmac ff3f0000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
>>>>> meson8b-dwmac ff3f0000.ethernet eth0: No Safety Features support found
>>>>> meson8b-dwmac ff3f0000.ethernet eth0: PTP not supported by HW
>>>>> meson8b-dwmac ff3f0000.ethernet eth0: configuring for phy/rmii link mode
>>>>> meson8b-dwmac ff3f0000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
>>>>> Sending DHCP requests ., OK
>>>>> IP-Config: Got DHCP answer from 10.1.1.1, my address is 10.1.3.229
>>>>
>>>> Of course the same problem happens when not using NFS and it fairly
>>>> difficult for IoT products to detect this situation and recover.
>>>>
>>>> The call to stmmac_mac_set() should be no-op in our case, the bits it sets
>>>> have already been set by an earlier call to stmmac_mac_set(). However
>>>> removing this call solves the problem. We have no idea why or what is the
>>>> actual problem.
>>>>
>>>> Even weirder, keeping the call to stmmac_mac_set() but inserting a
>>>> udelay(1) between writel() and stmmac_mac_set() solves the problem too.
>>>>
>>>> Suggested-by: Qi Duan <qi.duan@amlogic.com>
>>>> Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
>>>> ---
>>>>
>>>>  Hi,
>>>>
>>>>  There is no intention to get this patch merged as it is.
>>>>  It is sent with the hope to get a better understanding of the issue
>>>>  and more testing.
>>>>
>>>>  The discussion on this issue initially started on this thread
>>>>  https://lore.kernel.org/all/CAK4VdL3-BEBzgVXTMejrAmDjOorvoGDBZ14UFrDrKxVEMD2Zjg@mail.gmail.com/
>>>>
>>>>  The patches previously proposed in this thread have not solved the
>>>>  problem.
>>>>
>>>>  The line removed in this patch should be a no-op when it comes to the
>>>>  value of MAC_CTRL_REG. So the change should make not a difference but
>>>>  it does. Testing result have been very good so far so there must be an
>>>>  unexpected consequence on the HW. I hope that someone with more
>>>>  knowledge on this controller will be able to shine some light on this.
>>>>
>>>>  Cheers
>>>>  Jerome
>>>>
>>>>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 -
>>>>  1 file changed, 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>>> index d1a7cf4567bc..3dca3cc61f39 100644
>>>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>>> @@ -1072,7 +1072,6 @@ static void stmmac_mac_link_up(struct phylink_config *config,
>>>>
>>>>       writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
>>>>
>>>> -     stmmac_mac_set(priv, priv->ioaddr, true);
>>>>       if (phy && priv->dma_cap.eee) {
>>>>               priv->eee_active = phy_init_eee(phy, 1) >= 0;
>>>>               priv->eee_enabled = stmmac_eee_init(priv);
>>>
>>> Now that we have a3a57bf07de2 ("net: stmmac: work around sporadic tx issue on link-up")
>>> in linux-next and scheduled for stable:

I will

>>>
>>> Jerome, can you confirm that after this commit the following is no longer needed?
>>> 2c87c6f9fbdd ("net: phy: meson-gxl: improve link-up behavior")

This never had any meaningful impact for me. I have already reverted it
for testing.

I'm all for reverting it

>>>
>>> Then I'd revert it, referencing the successor workaround / fix in stmmac.

