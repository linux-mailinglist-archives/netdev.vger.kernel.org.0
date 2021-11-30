Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C501D462E2E
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 09:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239379AbhK3IHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 03:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233878AbhK3IHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 03:07:39 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3BCC061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 00:04:20 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id a9so42436069wrr.8
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 00:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BU/92BaHe4dmhxB7ODPEPDd8pWIhuBNxhjbCDaTqdWU=;
        b=AZmDE9fdueUn/T0dHIJB1TzmQsVXXTv8TY9mdeE1F2fVB8mzq14Yohcm1Vp63LQmOG
         Eh3UyVuS4arKBbKrSiKxUvZ5j+4DNBPKVLRSl4ObT2iTUgtkJNfX4M5/0ccYiNawnLg3
         3ZavZu0F0pkLHfc6yPkTWUjx3tHekc0zuCIbp7EsLXKg7bFgvalN0HC4LOpGYiwQymAh
         4+O0VP0legaDJzU+n8WYjRlOiaZe4uh7iH0doDGoFwzUQVzcLyPC2p9rDZnLiTwCBFhr
         byXPANXecqV0StnsuRIKHPAHUmlCo9dEZ/R666mQwfenO59mlbUVxucOB3MBKthzUBej
         2pYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=BU/92BaHe4dmhxB7ODPEPDd8pWIhuBNxhjbCDaTqdWU=;
        b=ZwxuKaAOHZXp8zxsf/a8We0GiFV5WC+OZ4NkkXKgv+hUQzdyS3ItWDO9tY1MK8Zyut
         gjxKWEGe8GdoUHN+jv92lA20u6OPRuG4Y+QrGnmGiqGo80qkUvoXs1TCOdK6oT3/17oT
         yfTcmAbZNjBE2OJ+neHTQTJtEBTFJ+1qUZatQidCS5wPqyNqzIuO9sfsIT5CcVkZsbmR
         dIpTXh9dqMAH9WLlOjm+m+yPZ/NjYEsQGrosERFuOHckZ/q5WMEBEeuVvBIuHiVofwRB
         D9BpaAF0QSV0aeJA+UrAjrFv+Hq7vnP+9lYFCfK3vzl5yjVhXS8NbfRFLdjkJQWXAFO0
         XtNQ==
X-Gm-Message-State: AOAM532Naj+1tsuW1PZLeQEpMt24BlXK3htKkbWtGyjaXlKQS+VlYEHn
        Xgoe59NbNIrhSzWDxwTkJUagGObFSD8OqA==
X-Google-Smtp-Source: ABdhPJyfSJjFG0B4n5OzGpez2NvPlmJSnncpzcf677PLSriAXGEQ1nAfTZdDL4LLZ9+EejIFE90s8A==
X-Received: by 2002:adf:fe8e:: with SMTP id l14mr39805670wrr.177.1638259459269;
        Tue, 30 Nov 2021 00:04:19 -0800 (PST)
Received: from ?IPv6:2a01:e0a:b41:c160:854f:2f27:d1d8:2752? ([2a01:e0a:b41:c160:854f:2f27:d1d8:2752])
        by smtp.gmail.com with ESMTPSA id c6sm1907661wmq.46.2021.11.30.00.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 00:04:18 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v3] rtnetlink: Support fine-grained netdevice
 bulk deletion
To:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>
Cc:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org
References: <20211125165146.21298-1-lschlesinger@drivenets.com>
 <YaMwrajs8D5OJ3yS@unreal> <20211128111313.hjywmtmnipg4ul4f@kgollan-pc>
 <YaNrd6+9V18ku+Vk@unreal> <09296394-a69a-ee66-0897-c9018185cfde@gmail.com>
 <20211129135307.mxtfw6j7v4hdex4f@kgollan-pc>
 <21da13fb-e629-0d6e-1aa1-56e2eb86d1c3@gmail.com>
 <20211129101031.25d35a5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <ef12108a-6355-de79-d20e-4576561197f6@6wind.com>
Date:   Tue, 30 Nov 2021 09:04:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211129101031.25d35a5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 29/11/2021 à 19:10, Jakub Kicinski a écrit :
> On Mon, 29 Nov 2021 08:30:16 -0700 David Ahern wrote:
>> On 11/29/21 6:53 AM, Lahav Schlesinger wrote:
>>> Hi David, while I also don't have any strong preference here, my
>>> reasoning for failing the whole request if one device can't be deleted
>>> was so it will share the behaviour we currently have with group deletion.
>>> If you're okay with this asymmetry I'll send a V4.  
>>
>> good point - new features should be consistent with existing code.
>>
>> You can add another attribute to the request to say 'Skip devices that
>> can not be deleted'.
> 
> The patch is good as is then? I can resurrect it from 'Changes
> Requested' and apply.
> 
> Any opinion on wrapping the ifindices into separate attrs, Dave?
> I don't think the 32k vs 64k max distinction matters all that much,
I agree.

> user can send multiple messages, and we could point the extack at
> the correct ifindex's attribute.
> 
Good point, it would be clearer from an API POV.
