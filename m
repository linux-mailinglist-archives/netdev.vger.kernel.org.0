Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9050E3C57C6
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 12:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354575AbhGLIhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 04:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377658AbhGLIgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 04:36:14 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F225C0613DD
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 01:33:26 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id g8-20020a1c9d080000b02901f13dd1672aso9353943wme.0
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 01:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VcU94+ptn+XXJgtDASoyuu+m6mLynxa+itdXnSarVzs=;
        b=Q0GXn5D2daFjQ7XthmdujUFYTPUPjI2N5ZzoWKOfW51YlP/sfMLCi6mbN6Pak9vbo/
         n0OaC3eFdOSYTUh3HGxuJOW5XVap6OzPV2yTwDnyGr3VWTO5RJ9cXyzmLUZJV9ToUB9D
         mEgnAgLIzgn0RWQT6ociA02aO/L6OxEPI3J4uVr8Bxdx3jv/mgti6zN6Y8VMMciFAmKm
         n89MGoaNTxAcb8gr2bHL5kUf6T5/8H+UnakKErKM9Rh3Q0ohD552FrJiQ9tU+Y8kw5w/
         PQUq5U9AWgB2/GeJKW5AwrRLIyl+Nl9aS5JJyVCqLRHMoIUIDbvlJZ7K0XY+dDlOBFP+
         xRnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VcU94+ptn+XXJgtDASoyuu+m6mLynxa+itdXnSarVzs=;
        b=q/AyHNFIL7iehUy955CB2/SsCcq4dXTbC5L68mGSgXZ3RkfnvlYb955rdyKgl2pmSn
         lpgspHvyOK4Zxwf+1onYHrt0zX5S5H99b3dwprMqSj9EKfiExUHmqiFesSbjnDPTwBeI
         GqyPy4XFYwZOLy96q+lo3qYE17N3YLYxQVy8nMOo6nN13YW/i5YtEjbveCk/OCu7ulcE
         d9cjDMz4Qkt8izCfgheY/jUsIuREU/8D/2eKvdB1rYVmISdwqPZZw6m1HGrX0hwgbEnW
         FLvq5m4vT7pn04PtlIz2kOVSJ5j6YxUORUvp9QtC8LSeIyMALnqhQh3nxVUhT8p5d/zY
         C0Pg==
X-Gm-Message-State: AOAM530vKH2Gd5pmGVer5qx4RqcY6u+zKU+pqoFpIbzdRQh3CxPnMNvH
        KYV2kBEe9FscF0DhPT7vT7ywKeImYFyulQ==
X-Google-Smtp-Source: ABdhPJyDG45EnSffqoGLJhLdPUDrLV67BDGvMWpPKdseKkMsRDCItHhpcDxOk72bHrMsswQ9D3RzCg==
X-Received: by 2002:a1c:1bc3:: with SMTP id b186mr13263661wmb.27.1626078804400;
        Mon, 12 Jul 2021 01:33:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f3f:3d00:38ee:56fd:735d:6934? (p200300ea8f3f3d0038ee56fd735d6934.dip0.t-ipconnect.de. [2003:ea:8f3f:3d00:38ee:56fd:735d:6934])
        by smtp.googlemail.com with ESMTPSA id u1sm19460428wmn.23.2021.07.12.01.33.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 01:33:24 -0700 (PDT)
Subject: Re: [PATCH] r8169: Disable eee when device init
To:     lingfuyi <lingfuyi@126.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210709090638.26468-1-lingfuyi@126.com>
 <652670b6-0cd1-6820-3475-567bbb1cf86d@gmail.com>
 <3ae26549.1434.17a9893d000.Coremail.lingfuyi@126.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <0b95d2c8-bdcf-04d0-5e84-95ed5134c8f0@gmail.com>
Date:   Mon, 12 Jul 2021 10:33:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3ae26549.1434.17a9893d000.Coremail.lingfuyi@126.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.07.2021 04:37, lingfuyi wrote:
> I found through git bisect that the delay was introduced after the commid id: b6c7fa401625d949e5e370f32e74f22c3bbaed51. At the same time, I tested many subsequent versions of this commit id, which basically floated between 8000 and 15000. If this option is disabled, it will remain stable at about 27000.
> 
> I tested 8169 and 8168, the performance is the same, I think this option should be set as a power management option, rather than the default activation
> 

What you call performance here refers to latency.iperf3 gives me ca. 950Mbps
also with EEE enabled.If EEE-induced latency is a problem for you, then just
disable EEE.

> 
> 
> 
> 
> 
> 
> At 2021-07-11 06:15:44, "Heiner Kallweit" <hkallweit1@gmail.com> wrote:
>>On 09.07.2021 11:06, lingfuyi wrote:
>>> The kernel default option enables the EEE function of the network card
>>> When this option is turned on, both TCP_RR and UDP_RR of netperf will
>>> be reduced.
>>> The test data is as follows ：
>>>                 EEE enable      EEE disable
>>> TCP_RR          15333           25895
>>> UDP_RR          15888           26908
>>
>>AFAIK it's normal that EEE adds some latency. Was the latency you
>>measured greater than what you expected?
>>
>>With which chip versions did you test? r8169 supports ~ 50 chip versions
>>and they may behave quite different regarding EEE.
>>Did you also test with the r8168 vendor driver? Is it the same there?
>>
>>Other users (especially of mobile devices) may weight the energy saving
>>higher than latency. Therefore there may be different opinions on what
>>should be the default.
>>
>>> Now modify the kernel code to disable the EEE function by default to
>>> improve system performance. If you need to open it, you can use the
>>> following command：
>>> ethtool --set-eee DEVICENAME eee on/off
>>> 
>>> Signed-off-by: lingfuyi <lingfuyi@126.com>
>>> ---
>>>  drivers/net/ethernet/realtek/r8169_main.c | 8 +++++---
>>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>> 
>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>> index f744557c33a3..507005fac98e 100644
>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>> @@ -1959,7 +1959,7 @@ static const struct ethtool_ops rtl8169_ethtool_ops = {
>>>  	.set_pauseparam		= rtl8169_set_pauseparam,
>>>  };
>>>  
>>> -static void rtl_enable_eee(struct rtl8169_private *tp)
>>> +static void rtl_init_eee(struct rtl8169_private *tp)
>>>  {
>>>  	struct phy_device *phydev = tp->phydev;
>>>  	int adv;
>>> @@ -2209,7 +2209,7 @@ static void rtl8169_init_phy(struct rtl8169_private *tp)
>>>  	phy_speed_up(tp->phydev);
>>>  
>>>  	if (rtl_supports_eee(tp))
>>> -		rtl_enable_eee(tp);
>>> +		rtl_init_eee(tp);
>>>  
>>>  	genphy_soft_reset(tp->phydev);
>>>  }
>>> @@ -5260,7 +5260,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>  	tp->dev = dev;
>>>  	tp->pci_dev = pdev;
>>>  	tp->supports_gmii = ent->driver_data == RTL_CFG_NO_GBIT ? 0 : 1;
>>> -	tp->eee_adv = -1;
>>
>>If you remove this then not much functionality is left in
>>rtl_enable_eee() and it could be inlined.
>>
>>> +
>>> +	/* Disable eee when device init */
>>> +	tp->eee_adv = 0;
>>>  	tp->ocp_base = OCP_STD_PHY_BASE;
>>>  
>>>  	dev->tstats = devm_netdev_alloc_pcpu_stats(&pdev->dev,
>>> 
> 
> 
> 
>  
> 

