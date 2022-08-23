Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D3D59E4BB
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 15:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235804AbiHWNzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 09:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbiHWNyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 09:54:52 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6251222E03
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 04:00:09 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ce26so10924110ejb.11
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 04:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=Kt7xBAZm6XZJpBfFUivLuISnl2CrReNh2+8nMEP3l4M=;
        b=jEwA1BZ9sxhmxVWMPRqL2OMy29SJWIQnX7UtGBmjxe7Ime6EaPp9EPbOJ/LEX6+XtR
         TfT3OieB+pPHKqYf0uJrpdLcMzzl7dwv0BIB6BHFD08wkdSCmB8UyHmB9If/yRx4eg+F
         4yKirvx7l4Ge5btmgi5BJI6Cnu4AuifkNPFJKucVUdeouvJhAvm8r6efEU4KuWBYTFZ2
         oA0pBuOynoliHko+p7vg5C3F0FvnBEiQwpmESys3XMLb0Va91XzteBn6N93duyM7pyYH
         B4g/IkzkzZPc0SI+eXOWBZECc/evy8Foy4/Y9F0nKyoLaUnqH2BhsC2BrL1vBJ2khFkm
         Aj0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Kt7xBAZm6XZJpBfFUivLuISnl2CrReNh2+8nMEP3l4M=;
        b=45hXOrEgMWC9zu/xSLLFm3KsD64uRESpipyVdHMe70rcPrPewHA9a7BJ3/YPgkWUY3
         TG/+6ozQTaIuBIjb4t8vi9cAnSsqpNboolM+W5xGa9rWaAuVtxiZBm3OOtIXZDHdiAvC
         NqZuNd13DrpP4GksgNXLzngbKsaM7okRiZ6PKKvabLvsprGgvwTZUq208ckvUP+1RdPV
         bzz8rG85NbW209c6dLngbvielXvhva8RixEccFsUgFxhsaFyvIXni7bFy0ht5uiZxoNp
         XZeTuB3mc9PnfB6ItL+VyTCL1wONUzqBaz21KfcsnDRstp5QukaWweA/u0SI8GK98W2o
         hmLg==
X-Gm-Message-State: ACgBeo0SqzgZtvKB9Tc5oMlYgRWmRz4/liASwTOPIo+y5cz+i/5C/NLE
        mIctnRuL28xKEbegY/9A4AE=
X-Google-Smtp-Source: AA6agR48Em01N8nNjPsLr/rd8kPjzculhcW6K4OgzJlYpPR/SPvirasQAe91y68udFdr1Dsolp/bxw==
X-Received: by 2002:a17:907:60c7:b0:731:14e2:af10 with SMTP id hv7-20020a17090760c700b0073114e2af10mr15813328ejc.92.1661252347817;
        Tue, 23 Aug 2022 03:59:07 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7758:1500:d4cf:79a3:3d29:c3f8? (dynamic-2a01-0c22-7758-1500-d4cf-79a3-3d29-c3f8.c22.pool.telefonica.de. [2a01:c22:7758:1500:d4cf:79a3:3d29:c3f8])
        by smtp.googlemail.com with ESMTPSA id s12-20020a056402036c00b0043bbcd94ee4sm1260535edw.51.2022.08.23.03.59.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 03:59:07 -0700 (PDT)
Message-ID: <51de30fe-4066-1d11-75d9-d7cfda860442@gmail.com>
Date:   Tue, 23 Aug 2022 12:58:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next 3/5] r8169: remove support for chip version 49
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e3d2fc9d-3ce7-b545-9cd1-6ad9fbe0adb7@gmail.com>
 <470b2f1c-54bd-f6e9-1398-64d0cc204684@gmail.com>
 <1f647343d0755f9ba0deabb98cd83bf32f0c9d36.camel@redhat.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <1f647343d0755f9ba0deabb98cd83bf32f0c9d36.camel@redhat.com>
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

On 23.08.2022 12:16, Paolo Abeni wrote:
> On Sat, 2022-08-20 at 15:53 +0200, Heiner Kallweit wrote:
>> Detection of this chip version has been disabled for few kernel versions now.
>> Nobody complained, so remove support for this chip version.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/ethernet/realtek/r8169.h          |  2 +-
>>  drivers/net/ethernet/realtek/r8169_main.c     | 26 ++-----------------
>>  .../net/ethernet/realtek/r8169_phy_config.c   | 22 ----------------
>>  3 files changed, 3 insertions(+), 47 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
>> index a66b10850..7c85c4696 100644
>> --- a/drivers/net/ethernet/realtek/r8169.h
>> +++ b/drivers/net/ethernet/realtek/r8169.h
>> @@ -59,7 +59,7 @@ enum mac_version {
>>  	RTL_GIGA_MAC_VER_46,
>>  	/* support for RTL_GIGA_MAC_VER_47 has been removed */
>>  	RTL_GIGA_MAC_VER_48,
>> -	RTL_GIGA_MAC_VER_49,
>> +	/* support for RTL_GIGA_MAC_VER_49 has been removed */
>>  	RTL_GIGA_MAC_VER_50,
>>  	RTL_GIGA_MAC_VER_51,
>>  	RTL_GIGA_MAC_VER_52,
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 0e7d10cd6..b22b80aab 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -134,7 +134,6 @@ static const struct {
>>  	[RTL_GIGA_MAC_VER_44] = {"RTL8411b",		FIRMWARE_8411_2 },
>>  	[RTL_GIGA_MAC_VER_46] = {"RTL8168h/8111h",	FIRMWARE_8168H_2},
>>  	[RTL_GIGA_MAC_VER_48] = {"RTL8107e",		FIRMWARE_8107E_2},
>> -	[RTL_GIGA_MAC_VER_49] = {"RTL8168ep/8111ep"			},
>>  	[RTL_GIGA_MAC_VER_50] = {"RTL8168ep/8111ep"			},
>>  	[RTL_GIGA_MAC_VER_51] = {"RTL8168ep/8111ep"			},
>>  	[RTL_GIGA_MAC_VER_52] = {"RTL8168fp/RTL8117",  FIRMWARE_8168FP_3},
>> @@ -885,7 +884,6 @@ static void rtl8168g_phy_suspend_quirk(struct rtl8169_private *tp, int value)
>>  {
>>  	switch (tp->mac_version) {
>>  	case RTL_GIGA_MAC_VER_40:
>> -	case RTL_GIGA_MAC_VER_49:
>>  		if (value & BMCR_RESET || !(value & BMCR_PDOWN))
>>  			rtl_eri_set_bits(tp, 0x1a8, 0xfc000000);
>>  		else
>> @@ -1199,7 +1197,7 @@ static enum rtl_dash_type rtl_check_dash(struct rtl8169_private *tp)
>>  	case RTL_GIGA_MAC_VER_28:
>>  	case RTL_GIGA_MAC_VER_31:
>>  		return r8168dp_check_dash(tp) ? RTL_DASH_DP : RTL_DASH_NONE;
>> -	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_53:
>> +	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:
> 
> The above chunk looks incorrect. I think should be:
> 	case RTL_GIGA_MAC_VER_50 ... RTL_GIGA_MAC_VER_53:
> 
Indeed, thanks for spotting this typo!

> instead.
> 
> Thanks!
> 
> Paolo
> 

