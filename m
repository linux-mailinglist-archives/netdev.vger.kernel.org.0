Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C90A49F781
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 11:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238524AbiA1Kko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 05:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiA1Kkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 05:40:43 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5C2C061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 02:40:43 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id m14so9775586wrg.12
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 02:40:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=ijjiIU++D+zO2riFjTE3g7ekk0pBcJWJkd6bn+z3ZZE=;
        b=HdLETtYSxjCF5HbeQVR5EVWkUE1D0ctjHkRYCoCNxa3iHDo/cC/J0fN+T00/WFTYHe
         paCL3oeZKrcFqKesosOQ5gd6/WMGFjmNpBQk5lY0Yc190sVJEfN3zDmkOWEJdT/pTnQg
         9I+spkFtLzP8DgDQpWuxUItLHXuOJEh/9m5oqZ3iuDQg7vBkxo4+kITsDDDglsHQ4ClC
         M9BDvrSMjXo6/nzF9dEkJ3myCS9cEbLz2T53ZPfFE6GdqwKVoHCOFc89qKBNFyf3lpib
         /vauleQyUkgR59Xf+99UA4mXtdDN4LU/I1SqMisolYTFBymtGsupL1U3sFdRJJ11zQn8
         0n8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=ijjiIU++D+zO2riFjTE3g7ekk0pBcJWJkd6bn+z3ZZE=;
        b=J3PJlGEc8OyIU9ybUipC7zCyiT0xsJ4XLHvrgjBCLllGuqdc3WsCvsNfdMQvEf1JzF
         4D2Y0RQ7Lx46r73Anfko5LpMFQB7dHOMI3GdzqSGuT8eKmFqRQguYeH6K/kP84up9/zV
         TnbwO9FWeQMplyuYdZwqMj0PdgJM13akrH+Ivza089UMqPOjHYoHGhWTL3+hr++mVlXU
         Pd13V/0iE1UutQby0G6vgshRLf2fqL0Sj1U1GjgdkbGkzym4k6QDy9gwusnIF2A+d6oq
         wNCZu9DpSEJ7C+zlA9BvyJ+qvwTseCgub5IEKzMpz+OB/j7t/YP3i5lmNDD/rxVoNud+
         9hmg==
X-Gm-Message-State: AOAM5315YRJ37BHikOr8s3sjc0HSjl7y5FiA3BhOpDio8UAJ1fG2YZV6
        C67T757BWL6511MOkBJatKAuPmoWlM4=
X-Google-Smtp-Source: ABdhPJzjGro6he4gCqCrpBDjL8t8Y+H43bJ9/o4QHj15kWhfbfFAFxOsAa2tLN3xKLVjb8CpAB2qDA==
X-Received: by 2002:a5d:618d:: with SMTP id j13mr6861454wru.58.1643366442090;
        Fri, 28 Jan 2022 02:40:42 -0800 (PST)
Received: from ?IPV6:2003:ea:8f4d:2b00:da2:d6d8:da09:58ae? (p200300ea8f4d2b000da2d6d8da0958ae.dip0.t-ipconnect.de. [2003:ea:8f4d:2b00:da2:d6d8:da09:58ae])
        by smtp.googlemail.com with ESMTPSA id s9sm4288939wrr.84.2022.01.28.02.40.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 02:40:41 -0800 (PST)
Message-ID: <ee4f20bd-f32d-ae2d-3767-b927cae9ef7f@gmail.com>
Date:   Fri, 28 Jan 2022 11:40:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Content-Language: en-US
To:     Hau <hau@realtek.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        nic_swsd <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "grundler@chromium.org" <grundler@chromium.org>
References: <f448b546-5b0a-79e0-f09a-dcfabb4fc8a5@gmail.com>
 <0124f075142a458d91e5b41ce3b0ed5a@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] r8169: add rtl_disable_exit_l1()
In-Reply-To: <0124f075142a458d91e5b41ce3b0ed5a@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.01.2022 09:09, Hau wrote:
> 
> 
>> -----Original Message-----
>> From: Heiner Kallweit [mailto:hkallweit1@gmail.com]
>> Sent: Friday, January 28, 2022 6:15 AM
>> To: Jakub Kicinski <kuba@kernel.org>; David Miller <davem@davemloft.net>;
>> nic_swsd <nic_swsd@realtek.com>
>> Cc: netdev@vger.kernel.org; Hau <hau@realtek.com>
>> Subject: [PATCH net-next] r8169: add rtl_disable_exit_l1()
>>
>> Add rtl_disable_exit_l1() for ensuring that the chip doesn't inadvertently exit
>> ASPM L1 when being in a low-power mode.
>> The new function is called from rtl_prepare_power_down() which has to be
>> moved in the code to avoid a forward declaration.
>>
>> According to Realtek OCP register 0xc0ac shadows ERI register 0xd4 on
>> RTL8168 versions from RTL8168g. This allows to simplify the code a little.
>>
>> Suggested-by: Chun-Hao Lin <hau@realtek.com>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/ethernet/realtek/r8169_main.c | 65 ++++++++++++++---------
>>  1 file changed, 39 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c
>> b/drivers/net/ethernet/realtek/r8169_main.c
>> index 3c3d1506b..104ebc0fb 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -2231,28 +2231,6 @@ static int rtl_set_mac_address(struct net_device
>> *dev, void *p)
>>  	return 0;
>>  }
>>
>> -static void rtl_wol_enable_rx(struct rtl8169_private *tp) -{
>> -	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
>> -		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
>> -			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
>> -}
>> -
>> -static void rtl_prepare_power_down(struct rtl8169_private *tp) -{
>> -	if (tp->dash_type != RTL_DASH_NONE)
>> -		return;
>> -
>> -	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
>> -	    tp->mac_version == RTL_GIGA_MAC_VER_33)
>> -		rtl_ephy_write(tp, 0x19, 0xff64);
>> -
>> -	if (device_may_wakeup(tp_to_dev(tp))) {
>> -		phy_speed_down(tp->phydev, false);
>> -		rtl_wol_enable_rx(tp);
>> -	}
>> -}
>> -
>>  static void rtl_init_rxcfg(struct rtl8169_private *tp)  {
>>  	switch (tp->mac_version) {
>> @@ -2667,10 +2645,7 @@ static void rtl_enable_exit_l1(struct
>> rtl8169_private *tp)
>>  	case RTL_GIGA_MAC_VER_37 ... RTL_GIGA_MAC_VER_38:
>>  		rtl_eri_set_bits(tp, 0xd4, 0x0c00);
>>  		break;
>> -	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:
>> -		rtl_eri_set_bits(tp, 0xd4, 0x1f80);
>> -		break;
>> -	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
>> +	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_63:
>>  		r8168_mac_ocp_modify(tp, 0xc0ac, 0, 0x1f80);
>>  		break;
>>  	default:
>> @@ -2678,6 +2653,20 @@ static void rtl_enable_exit_l1(struct
>> rtl8169_private *tp)
>>  	}
>>  }
>>
>> +static void rtl_disable_exit_l1(struct rtl8169_private *tp) {
>> +	switch (tp->mac_version) {
>> +	case RTL_GIGA_MAC_VER_34 ... RTL_GIGA_MAC_VER_38:
>> +		rtl_eri_clear_bits(tp, 0xd4, 0x1f00);
>> +		break;
>> +	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_63:
>> +		r8168_mac_ocp_modify(tp, 0xc0ac, 0x1f80, 0);
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +}
>> +
>>  static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool
>> enable)  {
>>  	/* Don't enable ASPM in the chip if OS can't control ASPM */ @@ -
>> 4689,6 +4678,30 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
>>  	return 0;
>>  }
>>
>> +static void rtl_wol_enable_rx(struct rtl8169_private *tp) {
>> +	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
>> +		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
>> +			AcceptBroadcast | AcceptMulticast | AcceptMyPhys); }
>> +
>> +static void rtl_prepare_power_down(struct rtl8169_private *tp) {
>> +	if (tp->dash_type != RTL_DASH_NONE)
>> +		return;
>> +
>> +	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
>> +	    tp->mac_version == RTL_GIGA_MAC_VER_33)
>> +		rtl_ephy_write(tp, 0x19, 0xff64);
>> +
>> +	if (device_may_wakeup(tp_to_dev(tp))) {
>> +		phy_speed_down(tp->phydev, false);
>> +		rtl_wol_enable_rx(tp);
>> +	} else {
>> +		rtl_disable_exit_l1(tp);
>> +	}
>> +}
>> +
> Hi Heiner,
> 
Hi Hau,

> rtl_disable_exit_l1(tp) can be called before device enter D3 state. I think you don’t need to check wol status.
> You may update the code link following. 

my thought was that if DASH or WoL are enabled then we might miss
something on the bus if not waking from L1 in time.
You think this shouldn't be a problem?

By the way, because I'm no DASH expert:
Should we go to D3 at all if DASH is enabled? Will it still work?

> 
> static void rtl_prepare_power_down(struct rtl8169_private *tp) {
> 	rtl_disable_exit_l1(tp);
> 
> 	if (tp->dash_type != RTL_DASH_NONE)
> 		return;
> 
> 	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
> 	    tp->mac_version == RTL_GIGA_MAC_VER_33)
> 		rtl_ephy_write(tp, 0x19, 0xff64);
> 
> 	if (device_may_wakeup(tp_to_dev(tp))) {
> 		phy_speed_down(tp->phydev, false);
> 		rtl_wol_enable_rx(tp);
> 	} 
> }
> 
> Thanks.
>>  static void rtl8169_down(struct rtl8169_private *tp)  {
>>  	/* Clear all task flags */
>> --
>> 2.35.0
>>
>> ------Please consider the environment before printing this e-mail.

