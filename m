Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03781FC475
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 05:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgFQDKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 23:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgFQDKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 23:10:07 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88EECC061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 20:10:07 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id w9so485770qtv.3
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 20:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JzwoIRo+jz3awIIP74LltqThEFXranbPHOwsuuIZT24=;
        b=jAzHQFzZVM1Q1cwVzW0v1aCc9vYHK4/9oyD23kzYFaGDNYn09m5XjiJMk6BMEC5sHr
         J74Y0H6z8PmuHxQJG67yvSoMR3fxI0YY7H23wIsuyW9pR2ssocYjxl2ESUf3V/E4Wj3M
         6vvcIL+7xTCj+5pSWPwIQyB9MIljqgrB05AA6MSgFIeEtmJcmJ/3kFgsvBHcYj0AUrPq
         KTXO2muUc936JeupeZ2Q7lYEd5CAMf6xI9C3L8ZkRlcfjFGCUmdi6M81dwSD1vJ1Kk2R
         rqXG92g/8UIdd7ATNtOVMtLEcm4jEBAVi1A95+6Cu39/D7rZhcVYg6aCoX74HX+x/zHi
         rYOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JzwoIRo+jz3awIIP74LltqThEFXranbPHOwsuuIZT24=;
        b=HRm+nNFtj6E8sY/tUwFXOO68hsluwIQ7UrKHQrrQWgYA2sFt+xbaHdPlrDtrA198LZ
         o0zW4t7OKcSQBHWUU5j6p1fdJpiSEziCf4SZZLlaN3AZjHzpR1+cX9rM9ZL+UNfhnDPk
         MRZL3/2Ao8QbQen1ntNMtgySIbtGsAIW9+2Iutr1rFN32ItnM3H/bqUIOYfsKxEUQ7uQ
         TjbzC8KHe35/2a7bFAsVO/4RODF5dtb7r/kf1YHenBPcXPZTv7kncW+hGzmtR69jmwJp
         /YKnNpqi7pdByQ9OartSPWrWaFKsE1MaJ19fF88Clv+S6tYiT8nbTk2Vx13HaMhsFyO2
         L/6Q==
X-Gm-Message-State: AOAM530e6DhugTEmn7kgliq+OAN56+hHEc7S+EYnLhGpXzP7kAgVO7xC
        S8l2lircuPF6zLTXkcLHqGE=
X-Google-Smtp-Source: ABdhPJwuLL2JfyJBk+f91ZLUy3pw4qDpXudS+ZddBZq4VnZpnWMad4apyLXrHU3bd2xwGz3/0V0chw==
X-Received: by 2002:ac8:4d0e:: with SMTP id w14mr24830524qtv.266.1592363406814;
        Tue, 16 Jun 2020 20:10:06 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b48d:5aec:2ff2:2476? ([2601:282:803:7700:b48d:5aec:2ff2:2476])
        by smtp.googlemail.com with ESMTPSA id a38sm18723664qtb.37.2020.06.16.20.10.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2020 20:10:06 -0700 (PDT)
Subject: Re: [PATCH] net: Fix the arp error in some cases
To:     guodeqing <geffrey.guo@huawei.com>, davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, netdev@vger.kernel.org,
        dsa@cumulusnetworks.com, kuba@kernel.org
References: <1592359636-107798-1-git-send-email-geffrey.guo@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <39780a81-8ac8-871b-2176-2102322f9321@gmail.com>
Date:   Tue, 16 Jun 2020 21:10:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1592359636-107798-1-git-send-email-geffrey.guo@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/16/20 8:07 PM, guodeqing wrote:
> ie.,
> $ ifconfig eth0 6.6.6.6 netmask 255.255.255.0
> 
> $ ip rule add from 6.6.6.6 table 6666
> 
> $ ip route add 9.9.9.9 via 6.6.6.6
> 
> $ ping -I 6.6.6.6 9.9.9.9
> PING 9.9.9.9 (9.9.9.9) from 6.6.6.6 : 56(84) bytes of data.
> 
> 3 packets transmitted, 0 received, 100% packet loss, time 2079ms
> 
> $ arp
> Address     HWtype  HWaddress           Flags Mask            Iface
> 6.6.6.6             (incomplete)                              eth0
> 
> The arp request address is error, this is because fib_table_lookup in 
> fib_check_nh lookup the destnation 9.9.9.9 nexthop, the scope of 
> the fib result is RT_SCOPE_LINK,the correct scope is RT_SCOPE_HOST.  
> Here I add a check of whether this is RT_TABLE_MAIN to solve this problem.

fib_check_nh* is only used when the route is installed into the FIB to
verify the gateway is legit. It is not used when processing arp
requests. Why then, do you believe this fixes something?
