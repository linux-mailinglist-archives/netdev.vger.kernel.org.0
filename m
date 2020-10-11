Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3897228AAF1
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 00:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387708AbgJKWaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 18:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387645AbgJKWaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 18:30:01 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E12C0613CE;
        Sun, 11 Oct 2020 15:29:59 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id t20so8649566edr.11;
        Sun, 11 Oct 2020 15:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tQ91KlC16+iOxVZEy8exzFaomSm6trhPKyMZYS/SYiU=;
        b=PP9UpdZvCKxodnhOYk4LuNzIiPq8nQmjYXzFJGBVU8T13xxMaMqw6hOGHhSIaGlu+d
         OKJFfKtjG/RHYeEBg8xLVQfzwZmArdPUU+M3hqJir1FuFbe3V2qVQgmbqzHcDfadfMow
         KUG01+d89GZ2W5VcxD6+k6Lq/1vvDvN/AZGNqX4TbFFmX07qDc5SslLMXEDHqgxi44o6
         m6ZAKXvUGiFzdux3takZtPZYu34B3qtoNricau8sf9dwS3HjhxFdpDw0LRcZEW23XZhi
         YE/SeGnjEHYM9SCIBuyueZ2XT1cTAmDwTrqF2Fz5BAvsAhyxQtaByifhP2a8nynKsRid
         QpOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tQ91KlC16+iOxVZEy8exzFaomSm6trhPKyMZYS/SYiU=;
        b=iTPkeJ/EFoWrr0ILDtWmrTZN+jlcEVM9QGKcJMQ19ewc33YFOHQwb7jA9VKo5Gu2Xm
         CKxCHsiVRl2HwOLRcqAJe/q69m6Vtzd7qThenG+BTNGPGjb7Nni6x85wyGGQz1wvbxYG
         gEH5XlERlYUwrP/dtbsJPmAcFMQedrAjYZMqtoP+KRCViWUMpT6VemDZDBrCldPHUAF2
         kwzS9dVIzhWjyW4EKOVHvEDez94QwaYgj14/3lmNJewg/JlyweSYaHixMdisUxXZxfZQ
         5u30yyBIflL7K8HnGatir/FjocGhCN53QYfD+cBy9/ZQ/+CmR2vqMZYC0+3SwW2RNwfh
         Uqig==
X-Gm-Message-State: AOAM533UZuMAqB4Za3beqL52MJs7IH/eiOHB5EDO0zRRpJQByj9xj1Pd
        bco0pxwYwD4BjKlKNLH4+CmIrBl69CuBHg==
X-Google-Smtp-Source: ABdhPJzZaZNRjl8mTC6/3K6Kbe3g6oU5FIaoTuoDQyO1l6FMBXkmLSLzRXLMgs6aJQaBPGs26QkZ+A==
X-Received: by 2002:aa7:d4d8:: with SMTP id t24mr11374732edr.247.1602455398051;
        Sun, 11 Oct 2020 15:29:58 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:51b7:bf4f:604:7d3d? (p200300ea8f006a0051b7bf4f06047d3d.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:51b7:bf4f:604:7d3d])
        by smtp.googlemail.com with ESMTPSA id a13sm9760845edx.53.2020.10.11.15.29.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 15:29:57 -0700 (PDT)
Subject: Re: [PATCH net-next 00/12] net: add and use function
 dev_fetch_sw_netstats for fetching pcpu_sw_netstats
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bridge@lists.linux-foundation.org
References: <a46f539e-a54d-7e92-0372-cd96bb280729@gmail.com>
 <20201011151030.05ad88dd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <1f1dceab-bab0-ff9e-dae6-ed35be504a9c@gmail.com>
Date:   Mon, 12 Oct 2020 00:29:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201011151030.05ad88dd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.10.2020 00:10, Jakub Kicinski wrote:
> On Sun, 11 Oct 2020 21:34:58 +0200 Heiner Kallweit wrote:
>> In several places the same code is used to populate rtnl_link_stats64
>> fields with data from pcpu_sw_netstats. Therefore factor out this code
>> to a new function dev_fetch_sw_netstats().
> 
> FWIW probably fine to convert nfp_repr_get_host_stats64() as well, just
> take out the drop counter and make it a separate atomic. If you're up
> for that.
> 
Looking at nfp_repr_get_host_stats64() I'm not sure why the authors
decided to add a 64bit tx drop counter, struct net_device_stats has
an unsigned long tx_dropped counter already. And that the number of
dropped tx packets exceeds 32bit (on 32bit systems) seems not very
likely.
