Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717232A4886
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 15:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgKCOrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 09:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728158AbgKCOqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 09:46:37 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BFEC0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 06:46:37 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id b3so12937437wrx.11
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 06:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qqIH738Hu7ZLATF33TUis6u5ZAl66ZQfDlzCXI1HYGs=;
        b=mhLQg4ynD7QoLMAboFpYxY36eqSsLIpMr5g8Aqtpdk+Kt2N2AC61OE9vQfXFZ8q/cv
         XPhg1M7PeLJxqnW3C8fPJ5custSVRrX6f5n08yJU0lARRZA7252H3P1Sq++svHOGmoFa
         mVMsjYFfp/z1C77/KjcVTynVsx8RDHrbHSmgPEylFiPdVGSTAMSSsOW/BDCnbOFqRSJv
         +z3LS3V0m5rdqYUAKhC9AgC4bNLB2e/s21cLZutLGV6byr45uGaF7SJWhQ4yYiehhmQv
         FvAnZlhxd51GuKKJ+1xbdM5mItnKbQYCHOna1qtqIk8simJ/kanADPqWxJ4tWG2MKogE
         ia9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qqIH738Hu7ZLATF33TUis6u5ZAl66ZQfDlzCXI1HYGs=;
        b=SfyJlKoOPWcqf8XqxLAoajCIa4yd9h20YnA+EoAUHvply7l85ACmd5RDdL+ioiiONW
         k3YLGlbSXZ2fy/xIAFKSlliz2plT2mxidbmDduGHAeUUQqqFKK+nJFL0a+T6ePTRbaZo
         8bKIahRmC6eGj/vKvFwqulLsryeEdEMCMNazHa/I+LjFc61XkVlnODRQz6E/tCCLtriv
         WxszrgeyGNRIldL6M5wMKb1PuRXF5kbiyrfypHFBenUJ5q8kDiHL8kxWyTxKvqoN4eLD
         S01EGWhgCrjEUbZsDe6Gny8iKCQVkSklu5NZBrZ4MsTJiWVZgSiyjKujSTwbcXWmrt7p
         SLEg==
X-Gm-Message-State: AOAM530u9PvVNCarF7agVoScn3RnRkGRemQcAb9l5GWK3qBBIMj4wDi+
        DwFKNcYOj5jLLtpphuAC2h4=
X-Google-Smtp-Source: ABdhPJxBGwJY3zANt4xwYhaBFupWRCIi+eggKWI50/QEpcpivc4bm8DtzT9T9KrjePN7uWGhUgg2pg==
X-Received: by 2002:adf:dd50:: with SMTP id u16mr28061510wrm.419.1604414795975;
        Tue, 03 Nov 2020 06:46:35 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:a5f9:d289:8ac7:4785? (p200300ea8f232800a5f9d2898ac74785.dip0.t-ipconnect.de. [2003:ea:8f23:2800:a5f9:d289:8ac7:4785])
        by smtp.googlemail.com with ESMTPSA id g66sm3361438wmg.37.2020.11.03.06.46.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 06:46:35 -0800 (PST)
Subject: Re: [PATCH net-next 0/5] net: add and use dev_get_tstats64
To:     Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
References: <25c7e008-c3fb-9fcd-f518-5d36e181c0cb@gmail.com>
 <4ca1f21d5f8a119fe6483df370b64af6a33e565e.camel@kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <eb4122bb-4bcd-0c32-14e9-30aca76d4365@gmail.com>
Date:   Tue, 3 Nov 2020 15:46:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <4ca1f21d5f8a119fe6483df370b64af6a33e565e.camel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.11.2020 23:36, Saeed Mahameed wrote:
> On Sun, 2020-11-01 at 13:33 +0100, Heiner Kallweit wrote:
>> It's a frequent pattern to use netdev->stats for the less frequently
>> accessed counters and per-cpu counters for the frequently accessed
>> counters (rx/tx bytes/packets). Add a default ndo_get_stats64()
>> implementation for this use case. Subsequently switch more drivers
>> to use this pattern.
>>
>> Heiner Kallweit (5):
>>   net: core: add dev_get_tstats64 as a ndo_get_stats64 implementation
>>   net: make ip_tunnel_get_stats64 an alias for dev_get_tstats64
>>   ip6_tunnel: use ip_tunnel_get_stats64 as ndo_get_stats64 callback
>>   net: dsa: use net core stats64 handling
>>   tun: switch to net core provided statistics counters
>>
> 
> not many left,
> 
> $ git grep dev_fetch_sw_netstats drivers/
> 
> drivers/infiniband/hw/hfi1/ipoib_main.c:        dev_fetch_sw_netstats(s
> torage, priv->netstats);
> drivers/net/macsec.c:   dev_fetch_sw_netstats(s, dev->tstats);
> drivers/net/usb/qmi_wwan.c:     dev_fetch_sw_netstats(stats, priv-
>> stats64);
> drivers/net/usb/usbnet.c:       dev_fetch_sw_netstats(stats, dev-
>> stats64);
> drivers/net/wireless/quantenna/qtnfmac/core.c:  dev_fetch_sw_netstats(s
> tats, vif->stats64);
> 
> Why not convert them as well ?
> macsec has a different implementation, but all others can be converted.
> 
OK, I can do this. Then the series becomes somewhat bigger.
@Jakub: Would it be ok to apply the current series and I provide the
additionally requested migrations as follow-up series?


