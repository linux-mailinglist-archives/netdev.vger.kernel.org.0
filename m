Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA454D8EA3
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 22:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240329AbiCNV0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 17:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235766AbiCNV0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 17:26:02 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DBB2C111
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 14:24:50 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a8so36975159ejc.8
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 14:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5GE4ZlMnX9hJoNytO75OKsvWegBsfokD7EGQmLVwtTA=;
        b=NhKj/u2804fVDCsD9EqbvTG2MqilnYNBe2ZD7/Pq1ydswd6+uAz2gQhfOnZ9RhG/rc
         x5iORh8/8Rc8+XKGmE8JPhukXA1SxzoVKNzPb/e4N+OLv/D9vQXJqCCMQRtlJBAPcbU4
         WMoYqnXNhLn0ZEu5qOJuY7gJOB52/iVCjew77VSuLmrpZaMLQKuBqfNy5w6fmpxPdM2D
         D5HFa+VUOseYleg3RWk0us5p2toRkqTRf2MJyNcomydjC0xUs+sBnbiDa6Km1hlPrnO7
         +rQizPh9xr2glb9GlRTU6lWm6M6rzU/G2w3R1nXdboal74HbtQwMN0Ym5pfM1DI16odO
         8qLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5GE4ZlMnX9hJoNytO75OKsvWegBsfokD7EGQmLVwtTA=;
        b=1lEQhCuFXGX0ChWgHcwg1Q1Zz1NZguhAQOWRSL98NfhKkmDYmDZ2KcTMl5q25r4xf4
         lhbvZK/5vBo3UIBeGDVAO4PliN5j0hDlW1CTW8F1YrK0PzPkeJwrSbKGJF3niFcwKEON
         mVtL3lnGjGRmV3F+XVCSuEfoZ96xKdlCNgfYQVkH6NbQZHMWcZwrXNaN4jsWI0jelm7I
         ro9ex4GN9sDFmgMJS4eyPVkqrZX9b4d9jD8mPz4ZRHC2gE2wJ/rlYLgb+YtFZb0ZFavL
         FNvexKEn5C1/GFA4i0C0R3Q8eFuIGa68XClJqGYWFEMBBXTtjPKQVSunhMoaYwiMYNFs
         TgZA==
X-Gm-Message-State: AOAM533AtAY9ENxFToQ4IiQ0TAKLph62ib6KRSVEmhPJbwcLzshosNjV
        ayg9sKmZveEfm0uTJqJwyZQ=
X-Google-Smtp-Source: ABdhPJxmi9OGW5z2lxm4BUJn2Foh6DxPQUpBcwC4GLCTdCpkRKNNDshuEpMaVVo7lXCXEyL6lEJhiw==
X-Received: by 2002:a17:906:d54d:b0:6db:ab37:60d0 with SMTP id cr13-20020a170906d54d00b006dbab3760d0mr13563244ejc.234.1647293089146;
        Mon, 14 Mar 2022 14:24:49 -0700 (PDT)
Received: from ?IPV6:2a01:c23:bcb5:5a00:f598:7a:57a1:abb9? (dynamic-2a01-0c23-bcb5-5a00-f598-007a-57a1-abb9.c23.pool.telefonica.de. [2a01:c23:bcb5:5a00:f598:7a:57a1:abb9])
        by smtp.googlemail.com with ESMTPSA id lj2-20020a170906f9c200b006da6f29bc01sm7180575ejb.158.2022.03.14.14.24.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 14:24:48 -0700 (PDT)
Message-ID: <79606fda-ad17-954b-a2f2-7f155f142264@gmail.com>
Date:   Mon, 14 Mar 2022 22:24:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: r8169: rtl8168ep_driver_stop disables the DASH port
Content-Language: en-US
To:     Yanko Kaneti <yaneti@declera.com>,
        Kevin_cheng <kevin_cheng@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nicfae <Nicfae@realtek.com>
References: <d654c98b90d98db13b84752477fe2c63834bcf59.camel@declera.com>
 <42304a71ed72415c803ec22d3a750b33@realtek.com>
 <ed2850b12b304a7cb89972850e503026@realtek.com>
 <37bd0b005af4e10fd7e9ada2437775a4735d40a0.camel@declera.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <37bd0b005af4e10fd7e9ada2437775a4735d40a0.camel@declera.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.03.2022 15:05, Yanko Kaneti wrote:
> On Mon, 2022-03-14 at 01:00 +0000, Kevin_cheng wrote:
> Hello Kevin,
> 
>> Thanks for your email. Linux DASH requires specific driver and client
>> tool. It depends on the manufacturer’s requirement. You need to
>> contact ASRock to make sure they support Linux DASH and have verified
>> it.
> 
> Thanks for the answer but its not much help for me.
> I am not going to use a driver that's not in mainline.
> 
> I wasn't really expecting full DASH support but that at least
> r8169/linux does not prevent the limied DASH web interface functionality
> from working.
> 
> Currently this is not the case on this board with the current BIOS:
>  - Once the kernel is loaded the DASH web interface power management
> (reset, hard off) no longer works
>  - Normal shutdown or r8169 module unload actually disconnects the phy.
>  
> It would be nice if DASH basics worked without being broken/supported by
> the OS.
> 
> Regards
> Yanko
> 
>>
>> Best Regards
>> Kevin Cheng
>> Technical Support Dept.
>> Realtek Semiconductor Corp.
>>
>> -----Original Message-----
>> From: Yanko Kaneti <yaneti@declera.com> 
>> Sent: Friday, March 11, 2022 9:12 PM
>> To: Heiner Kallweit <hkallweit1@gmail.com>; nic_swsd
>> <nic_swsd@realtek.com>
>> Cc: netdev <netdev@vger.kernel.org>
>> Subject: r8169: rtl8168ep_driver_stop disables the DASH port
>>
>> Hello,
>>
>> Testing DASH on a ASRock A520M-HDVP/DASH, which has a RTL8111/8168 EP
>> chip. DASH is enabled and seems to work on BIOS/firmware level.
>>
>> It seems that r8169's cleanup/exit in rtl8168ep_driver_stop manages to
>> actually stop the LAN port, hence cutting the system remote
>> management.
>>
>> This is evident on plain shutdown or rmmod r8169.
>> If one does a hardware reset or echo "b" > /proc/sysrq-trigger  the
>> cleanup doesn't happen and the DASH firmware remains in working order
>> and the LAN port remains up.
>>
>> A520M-HDVP/DASH BIOS ver 1.70
>> Reatlek fw:
>>  Firmware Version:               3.0.0.20200423
>>  Version String:         20200428.1200000113
>>  
>> I have no idea if its possible or how to update the realtek firmware,
>> preferably from Linux.
>>
>> Various other DASH functionality seems to not work but basic working
>> power managements is really a deal breaker for the whole thing.
>>
>>
>> Regards
>> Yanko
>> ------Please consider the environment before printing this e-mail.
> 

Realtek doesn't provide any public datasheets, therefore it's hard to say
how DASH is handled in the chip.
However there are few places left where the PHY may be suspended w/o
checking for DASH. Can you try the following?


diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 67014eb76..95788ce7a 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1397,8 +1397,13 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 	rtl_lock_config_regs(tp);
 
 	device_set_wakeup_enable(tp_to_dev(tp), wolopts);
-	rtl_set_d3_pll_down(tp, !wolopts);
-	tp->dev->wol_enabled = wolopts ? 1 : 0;
+	if (tp->dash_type == RTL_DASH_NONE) {
+		rtl_set_d3_pll_down(tp, !wolopts);
+		tp->dev->wol_enabled = wolopts ? 1 : 0;
+	} else {
+		/* keep PHY from suspending if DASH is enabled */
+		tp->dev->wol_enabled = 1;
+	}
 }
 
 static int rtl8169_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
@@ -4672,7 +4677,7 @@ static void r8169_phylink_handler(struct net_device *ndev)
 	if (netif_carrier_ok(ndev)) {
 		rtl_link_chg_patch(tp);
 		pm_request_resume(&tp->pci_dev->dev);
-	} else {
+	} else if (tp->dash_type == RTL_DASH_NONE) {
 		pm_runtime_idle(&tp->pci_dev->dev);
 	}
 
@@ -4978,7 +4983,8 @@ static void rtl_shutdown(struct pci_dev *pdev)
 	/* Restore original MAC address */
 	rtl_rar_set(tp, tp->dev->perm_addr);
 
-	if (system_state == SYSTEM_POWER_OFF) {
+	if (system_state == SYSTEM_POWER_OFF &&
+	    tp->dash_type == RTL_DASH_NONE) {
 		if (tp->saved_wolopts)
 			rtl_wol_shutdown_quirk(tp);
 
-- 
2.35.1

