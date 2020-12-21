Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67052E02DA
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 00:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgLUXRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 18:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgLUXRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 18:17:48 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BC6C0613D3
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 15:17:06 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id f9so7325200pfc.11
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 15:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kYFf5s1P+nuMuZWoqvsxMtx/pvK4H8dFWC/9BRNgWAs=;
        b=CxxqQ4FiRJEuNXKB/DhWVXUpkmouU84qPxs4/SyuRcqzNkGcSWSav7EYLJ9CG6Bjv9
         jkYbl9xBlRhLWl/0IMubtF7T9Wgx4HBtF2c4SzawsdC5PIQSWFvVuOQGVLpLoYAcsifo
         pGGb8446OZoXz8xrkCVNjMzDtZhOBpC4i7SJnyDHKqzDAo/OGP/SEgPsgdFpuE20kAF7
         6kw+WPxY1mpu1XHL0MaPgpLwoBRdlX+6KcOtMtk9wwSac2F/vRxKy7OaM0JQBDjzGKo8
         jCwBHHJY+I1cML7/Wj5H3C2QwX2D3Xc8FBK14jpqqjHqdaTW7GeXPyxMoTvW2VwbdGyd
         zqVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kYFf5s1P+nuMuZWoqvsxMtx/pvK4H8dFWC/9BRNgWAs=;
        b=qdmHowDebFN61h5iurl1tUIoC+VurdlhCaczsAq9jbjbg8sPo1oZYlKfbl+t+85yqF
         0M0BfBa9osOD2ahwU59XcbU8I+EOq7NaWtqoRPsmxt4DsYwWcj4BHRyma5otJRcWTTgO
         cOVVi1jK91Z6prI7+cDIiLLWmOBzBvW0qLB3f+W8vJQTRiIwZhvWSECOjZ5RzjAZIKKS
         ZVx/PAT5yBdYXaV/xjR2sM+MWG4WsK7sAMjTgm5DHtXg0jFVCYA4Pxx3syWOfDs1vtun
         0DP9r8WMJirxAhWxZwDFwcUfkhCntk02/WgGs78X9n4eux4lr8HFWh+JVFfofs3oGJKq
         h5Rw==
X-Gm-Message-State: AOAM533/nu2tq0CW9RzjU6Vl2Ey3xlKaKxjxN4rMauOpL734lrRMVfi/
        vOmOzxu0bihSVLKX4V1IrrsNnk/5YUc=
X-Google-Smtp-Source: ABdhPJzxC39oIEVaulX7nA5KZGT7vLW2gNMmcWXf+AJGytIqjnvWKplC8xR4nxy0DrFz6szSuZF4ww==
X-Received: by 2002:a63:1115:: with SMTP id g21mr15051866pgl.210.1608592625062;
        Mon, 21 Dec 2020 15:17:05 -0800 (PST)
Received: from [10.230.29.166] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c10sm12055665pjn.22.2020.12.21.15.17.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 15:17:04 -0800 (PST)
Subject: Re: [RFC PATCH net-next 3/4] net: systemport: use standard netdevice
 notifier to detect DSA presence
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20201218223852.2717102-1-vladimir.oltean@nxp.com>
 <20201218223852.2717102-4-vladimir.oltean@nxp.com>
 <e9f3188d-558c-cb3a-6d5c-17d7d93c5416@gmail.com>
 <20201219121237.tq3pxquyaq4q547t@skbuf>
 <f2f420d3-baa0-e999-d23a-3e817e706cc7@gmail.com>
 <9bc9ff1c-13c5-f01c-ede2-b5cd21c09a38@gmail.com>
 <20201221230618.4pnwuil4qppoj6f5@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b106399b-e341-2aa2-d92e-24f5a0c243c9@gmail.com>
Date:   Mon, 21 Dec 2020 15:17:02 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201221230618.4pnwuil4qppoj6f5@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/21/2020 3:06 PM, Vladimir Oltean wrote:
> On Mon, Dec 21, 2020 at 02:33:16PM -0800, Florian Fainelli wrote:
>> On 12/20/2020 8:53 PM, Florian Fainelli wrote:
>>> The call to netif_set_real_num_tx_queues() succeeds and
>>> slave_dev->real_num_tx_queues is changed to 4 accordingly. The loop that
>>> assigns the internal queue mapping (priv->ring_map) is correctly limited
>>> to 4, however we get two calls per switch port instead of one. I did not
>>> have much time to debug why we get called twice but I will be looking
>>> into this tomorrow.
>>
>> There was not any bug other than there are two instances of a SYSTEMPORT
>> device in my system and they both receive the same notification.
>>
>> So we do need to qualify which of the notifier block matches the device
>> of interest, because if we do extract the private structure from the
>> device being notified, it is always going to match.
>>
>> Incremental fixup here:
>>
>> https://github.com/ffainelli/linux/commit/0eea16e706a73c56a36d701df483ff73211aae7f
> 
> ...duh.
> And when you come to think that I had deleted that code in my patch, not
> understanding what it's for... Coincidentally this is also the reason
> why I got the prints twice. Sorry :(

No worries, I had it "automatically" in my experiment with the
REGISTER/UNREGISTER and it only clicked this morning this was the key
thing here.

> 
>>
>> and you can add Tested-by: Florian Fainelli <f.fainelli@gmail.com> when
>> you resubmit.
>>
>> Thanks, this is a really nice cleanup.
> 
> Thanks.
> 
> Do you think we need some getters for dp->index and dp->ds->index, to preserve
> some sort of data structure encapsulation from the outside world (although it's
> not as if the members of struct dsa_switch and struct dsa_port still couldn't
> be accessed directly)?
> 
> But then, there's the other aspect. We would have some shiny accessors for DSA
> properties, but we're resetting the net_device's number of TX queues.
> So much for data encapsulation.

If we move the dsa_port structure definition to be more private, and say
within dsa_priv.h, we will have to create quite some bit of churn within
the DSA driver to make them use getters and setters. Russell did a nice
job with the encapsulation with phylink and that would really be a good
model to follow, however this was a clean slate. It seems to me for now
that this is not worth the trouble.

Despite accessing the TX queues directly, the original DSA notifier was
trying to provide all the necessary data to the recipient of the
notification without having to know too much about what a DSA device is
but the amount of code eliminated is of superior value IMHO.
-- 
Florian
