Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8986B30DE9F
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 16:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbhBCPsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 10:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234675AbhBCPsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 10:48:16 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6669C061573;
        Wed,  3 Feb 2021 07:47:35 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id h6so311776oie.5;
        Wed, 03 Feb 2021 07:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KqCrFEwsAhtnFeIorqRA/rKqSfxV1je7A4BKbhzoOpw=;
        b=lXeerfx1ilDU8ru4NnJNHjvF5qArAJWZk2qG9W1rAXbZbZ0hvmiBjAnhG/v+5W41Ut
         GwTr3qHtc1mSJGziS2lu7hZAL0Ddr2iSpIr0lRJTKb6kAUSPB6do+430nWw7wK7QXrXz
         DgKR6s6x2Xh/fLsLtJT4JodPoGv3QrdwPrRRNiniN1KvaDTBiRYaCa48nT8kdXrpvdLQ
         i0eGpAqadPiM3qu7ybh6WrgnnITTI2gBJqMyAHfZ03zxJ6R7VSb1LgpAlzU0q9KzLQI7
         7VUPCpxn+TgwlcrqyG20yH3ai6xEcbrNVh7HAV/c/2Yf09i3nGv1y1XbWNDb50233mrQ
         PaWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KqCrFEwsAhtnFeIorqRA/rKqSfxV1je7A4BKbhzoOpw=;
        b=fos7OAuMeyv2WKJmfIh23Ly4lQfMpZCp1W2HfGORCekCNRban178iZEPNxrUca5CQG
         2pi/1O/z1yt0+iYaHsI3JsQ6z0q3U4r4FqBjnd918pupuFVrAQe/J5EUdAQ2SPjBiDaN
         EhDIp3qd7pNh8+TUM/p/HeA2UATZmwkXhkqblTS5wmhBk4ctJS411Ww9IsFQdCsUQCSo
         3u/e9y6/DcrMxH4Y4be79rydIOAEim7kGW/PrGgkM4hwSG3M//LUXUcuJqq7XkxmCfZz
         Xa5IOZvzxeS8HrOJlWbjJrE1ZezNEQ43a/RDZMKLRMcq45I3AM9xlQLPN7ozXpTx5hQz
         9KsQ==
X-Gm-Message-State: AOAM532kAfmTXi1qxmMUBnUaoQluAH5J5xYzOyQlMsPcvjYPqPXVq3J+
        T/UsdcOFaizEIvereAwd7Mx69ooIjdM=
X-Google-Smtp-Source: ABdhPJzz/CjEmJOipOpNaQH86v2JktkA5O0wVkFSzWhjP0h6C77UJiEi+/eH7MwsgmtnOvOdimTEdw==
X-Received: by 2002:aca:b906:: with SMTP id j6mr2288894oif.159.1612367255057;
        Wed, 03 Feb 2021 07:47:35 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id p23sm482577otk.51.2021.02.03.07.47.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 07:47:34 -0800 (PST)
Subject: Re: [PATCH RESEND iproute2 5.11] iplink_can: add Classical CAN frame
 LEN8_DLC support
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org
References: <20210125104055.79882-1-socketcan@hartkopp.net>
 <b835a46c-f950-6c58-f50f-9b2f4fd66b46@gmail.com>
 <d8ba08c4-a1c2-78b8-1b09-36c522b07a8c@hartkopp.net>
 <586c2310-17ee-328e-189c-f03aae1735e9@gmail.com>
 <fe697032-88f2-c1f1-8afc-f4469a5f3bd5@hartkopp.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1bf605b4-70e5-e5f2-f076-45c9b52a5758@gmail.com>
Date:   Wed, 3 Feb 2021 08:47:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <fe697032-88f2-c1f1-8afc-f4469a5f3bd5@hartkopp.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/21 10:30 AM, Oliver Hartkopp wrote:
> 
> 
> On 02.02.21 16:35, David Ahern wrote:
>> On 2/2/21 3:48 AM, Oliver Hartkopp wrote:
>>>
>>> Are you sure this patch is correctly assigned to iproute2-next?
>>>
>>> IMO it has to be applied to iproute2 as the functionality is already in
>>> v5.11 which is in rc6 right now.
>>>
>>
>> new features land in iproute2-next just as they do for the kernel with
>> net-next.
>>
>> Patches adding support for kernel features should be sent in the same
>> development window if you want the iproute2 support to match kernel
>> version.
>>
> 
> Oh, I followed the commits from iproute2 until the new include files
> from (in this case) 5.11 pre rc1 had been updated (on 2020-12-24):
> 
> https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=2953235e61eb672bbdd2de84eb5b91c388f9a9b5
> 
> 
> I thought the uapi updates in iproute2 are *always* pulled from the
> kernel and not from iprout2-next which was new to me.

I sync kernel headers for iproute2-next with net-next, not linux-next.

> 
> Do you expect patches for iproute2-next when the relevant changes become
> available in linux-next then?
> 
> Even though I did not know about iproute2-next the patch is needed for
> the 5.11 kernel (as written in the subject).
> 


From a cursory look it appears CAN commits do not go through the netdev
tree yet the code is under net/can and the admin tool is through
iproute2 and netdevs. Why is that? If features patches flowed through
net-next, we would not have this problem.
