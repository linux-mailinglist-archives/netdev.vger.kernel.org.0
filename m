Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F652B8CC4
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 09:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgKSIDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 03:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgKSIDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 03:03:08 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AD5C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 00:03:08 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id h21so5844513wmb.2
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 00:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U3b4Q5BvJPb5RuBSlOaD1cP1dD0N0TDTGfiT2Snv8m4=;
        b=VSaHbI7nhJJ6En2lKFt4ax2ar6numaPvn6SkHbsSezEMinKhGxqQea8BWT9A4rMRcq
         55sA90hO5MRZoW9le723pIc2wCvLz3CDdk8aM+b+BW6wnvY5n1HTY0f/SdXtogqBvGXB
         ouLnpVHSajrFMkmWPQHMYoSfoM0J5hFUi30Q19lZ+YG78xuT9HQS66z5a1HNkfsqbqVS
         0ZkPwxPts12uYYtqXf2Ceh/keJd/bqQ/3p7Kq4+x9n08T40uRGMB0w3DD7LOi06FlOA4
         gZybu4hP+NzsGIrhnHCNeVVYIRvHh69jOSfNSW0T2l8NfpQvgkm0YyhfQ4LZUc3VWTAu
         +4Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=U3b4Q5BvJPb5RuBSlOaD1cP1dD0N0TDTGfiT2Snv8m4=;
        b=eu23V1uzl1sBImB8G/kMJTqW0ijG/VtgumC/cd9aW6R6olt95RRf8MhykMCQmlsy8X
         ydm1UQdeZsIP0FvyfuonqkbWpeIvQr6nEacx5p+Tk0Wvi37IbgjZNUoOiV0idk1N/JfI
         PWuvLP315HZ1chnYnEYqKmGKfc+0mjtzW4Amw5ocC2syiQNrAYufqKQQiiFiSn3yQrhy
         pxlUZNWnNJDG6MLA33F1xW9hyYvg5nfJ+kLG5sK5ZpQHklrGLBpGVU4PVzzbUOERGlfK
         8QNEOXqGLS4hrcEv89GCUEJe1TSHFctcuy0apW2iTmuqLj3JzFbWe+GAIy9jDWuFt8sj
         bkpQ==
X-Gm-Message-State: AOAM531SON7rEWhNcVjbdxDk6V08MLe+AJD3hjPtAY/j4fld64qVeWjG
        WG1o0v4P4JTiOTT2z0oWoBW1VQ==
X-Google-Smtp-Source: ABdhPJxVQTFHkMPr2QaEBCCsscuUubK4LPtSNAr7NgjOnInsc/EiADjQPnMu1Pny7vRTMk//2PdSUg==
X-Received: by 2002:a1c:7318:: with SMTP id d24mr3246021wmb.39.1605772986875;
        Thu, 19 Nov 2020 00:03:06 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:4d55:9a74:c1b4:3b01? ([2a01:e0a:410:bb00:4d55:9a74:c1b4:3b01])
        by smtp.gmail.com with ESMTPSA id o17sm7979490wmd.34.2020.11.19.00.03.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 00:03:06 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be
 controlled
To:     =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS1?=
         =?UTF-8?B?4KS+4KSwKQ==?= <maheshb@google.com>
Cc:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Jian Yang <jianyang@google.com>,
        Eric Dumazet <edumazet@google.com>
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
 <20201114101709.42ee19e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9jgYgUa4DPVT8CSsbMs9HFjE5fn_U8-P=JuZeOecfiYt-g@mail.gmail.com>
 <20201116123447.2be5a827@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9ji24VkLipTCFSAU+L8yqKt9nfPSNfks9_V1Tnb0ztPrfA@mail.gmail.com>
 <20201117171830.GA286718@shredder.lan>
 <CAF2d9jhJq76KWaMGZLTTX4rLGvLDp+jLxCG9cTvv6jWZCtcFAA@mail.gmail.com>
 <b3445db2-5c64-fd31-b555-6a49b0fa524e@gmail.com>
 <7e16f1f3-2551-dff5-8039-bcede955bbfc@6wind.com>
 <CAF2d9jiD5OpqB83fyyutsJqtGRg0AsuDkTsS6j4Fc-H-FHWiUQ@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <eb1a89d2-f0c0-1c10-6588-c92939162713@6wind.com>
Date:   Thu, 19 Nov 2020 09:03:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAF2d9jiD5OpqB83fyyutsJqtGRg0AsuDkTsS6j4Fc-H-FHWiUQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 18/11/2020 à 18:39, Mahesh Bandewar (महेश बंडेवार) a écrit :
> On Wed, Nov 18, 2020 at 8:58 AM Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>>
>> Le 18/11/2020 à 02:12, David Ahern a écrit :
>> [snip]
>>> If there is no harm in just creating lo in the up state, why not just do
>>> it vs relying on a sysctl? It only affects 'local' networking so no real
>>> impact to containers that do not do networking (ie., packets can't
>>> escape). Linux has a lot of sysctl options; is this one really needed?
>>>
> I started with that approach but then I was informed about these
> containers that disable networking all together including loopback.
> Also bringing up by default would break backward compatibility hence
> resorted to sysctl.
>> +1
>>
>> And thus, it will benefit to everybody.
> 
> Well, it benefits everyone who uses networking (most of us) inside
Sure.

> netns but would create problems for workloads that create netns to
> disable networking. One can always disable it after creating the netns
> but that would mean change in the workflow and it could be viewed as
> regression.
The networking is very limited with only a loopback. Do you have some real use
case in mind?
