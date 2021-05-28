Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646133945BE
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 18:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbhE1QXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 12:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbhE1QXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 12:23:05 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1363C061574;
        Fri, 28 May 2021 09:21:30 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 29so2886267pgu.11;
        Fri, 28 May 2021 09:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sMAehbts2FqAsSkzKIWhQHl/CAW20RrXPRH1psEuAmI=;
        b=fABVgtdifAA9JN+fRaXZZzmr5CXI9nH3mBpqYs/sNc+XEGnqkN6bnt/gulAfSBLnlP
         8UaOLft2S6PU/f+wbT8awoEzcpXhNtnUdB013upZKUgnTclyWcLo9mlH8DUSVFcpSQIG
         n71cyaBckowGl/mpqWurv47y533Amoha3OGji0v+Buwv3lTCfM/2yNF0sD5P4x2cpkgn
         YRi3PZSNxOxMkdP4RIIHqBygxTfQvuL5dSIfgVziCr7tvqk7maM+l+UtnB2/f8GRLoOt
         LPqHnd5TIRZPvxlDMzh/yxoy3U/4NgbO20XOEZZSJwpJHZwXq6EKL6xkr5czNfwkvrjs
         TSYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sMAehbts2FqAsSkzKIWhQHl/CAW20RrXPRH1psEuAmI=;
        b=Id8IobRuwkD9a+sRkQJHKBiVKpkSv4KK3qBkVGU4GkNjPKdLWqJRbAGb80+5+GrXWA
         +wHfps46/nuLV8Ch1PRSYQ3VIQjspHRirf3F0Zk7OeAWyzxvuaE8NWjChWaZ+OZyelmf
         Gh+4p5DyDBD9usHs1LPysFcmop2/rCB/O/n7btTPCdco/Q6n1TOsfwAORHYm4fUjiYkZ
         7uKs1YUpmhidFHMCQncuz9YPrstXWQokgBMDtUDwiWsYM9sTZPGWXVaIe80B/+zcSwIB
         vRvjkKsYQwvQ86zMtROCkE2U8T0YdErPd+nnklD33M0GWgb/TgXfHXfbkJx9wU0T4cAn
         yFAw==
X-Gm-Message-State: AOAM530cgpJKHdE30fSMXjnyO+l5ufhZEIc61nnZ3oauf6I9r3JafBDk
        zYVWVm7OPCgzKl8oYcXuHkE=
X-Google-Smtp-Source: ABdhPJxkizaGQQ88kBWeWsFDrzis29fCwV4z9mG4nI96RY51fJFoX9yeR5rgqxpClAearxln8yGkTg==
X-Received: by 2002:a63:e402:: with SMTP id a2mr9791645pgi.181.1622218890265;
        Fri, 28 May 2021 09:21:30 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id cu2sm4541858pjb.43.2021.05.28.09.21.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 May 2021 09:21:29 -0700 (PDT)
Subject: Re: Kernel Panic in skb_release_data using genet
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>
Cc:     Doug Berger <opendmb@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenz@kernel.org>
References: <20210524130147.7xv6ih2e3apu2zvu@gilmour>
 <a53f6192-3520-d5f8-df4b-786b3e4e8707@gmail.com>
 <20210524151329.5ummh4dfui6syme3@gilmour>
 <1482eff4-c5f4-66d9-237c-55a096ae2eb4@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6caa98e7-28ba-520c-f0cc-ee1219305c17@gmail.com>
Date:   Fri, 28 May 2021 09:21:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1482eff4-c5f4-66d9-237c-55a096ae2eb4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/24/21 8:37 AM, Florian Fainelli wrote:
> 
> 
> On 5/24/2021 8:13 AM, Maxime Ripard wrote:
>> Hi Florian,
>>
>> On Mon, May 24, 2021 at 07:49:25AM -0700, Florian Fainelli wrote:
>>> Hi Maxime,
>>>
>>> On 5/24/2021 6:01 AM, Maxime Ripard wrote:
>>>> Hi Doug, Florian,
>>>>
>>>> I've been running a RaspberryPi4 with a mainline kernel for a while,
>>>> booting from NFS. Every once in a while (I'd say ~20-30% of all boots),
>>>> I'm getting a kernel panic around the time init is started.
>>>>
>>>> I was debugging a kernel based on drm-misc-next-2021-05-17 today with
>>>> KASAN enabled and got this, which looks related:
>>>
>>> Is there a known good version that could be used for bisection or you
>>> just started to do this test and you have no reference point?
>>
>> I've had this issue for over a year and never (I think?) got a good
>> version, so while it might be a regression, it's not a recent one.
> 
> OK, this helps and does not really help.
> 
>>
>>> How stable in terms of clocking is the configuration that you are using?
>>> I could try to fire up a similar test on a Pi4 at home, or use one of
>>> our 72112 systems which is the closest we have to a Pi4 and see if that
>>> happens there as well.
>>
>> I'm not really sure about the clocking. Is there any clock you want to
>> look at in particular?
> 
> ARM, DDR, AXI, anything that could cause some memory corruption to occur
> essentially. GENET clocks are fairly fixed, you have a 250MHz clock and
> a 125MHz clock feeding the data path.
> 
>>
>> My setup is fairly simple: the firmware and kernel are loaded over TFTP
>> and the rootfs is mounted over NFS, and the crash always occur around
>> init start, so I guess when it actually starts to transmit a decent
>> amount of data?
> 
> Do you reproduce this problem with KASAN disabled, do you eventually
> have a crash pointing back to the same location?
> 
> I have a suspicion that this is all Pi4 specific because we regularly
> run the GENET driver through various kernel versions (4.9, 5.4 and 5.10
> and mainline) and did not run into that.

I have not had time to get a set-up to reproduce what you are seeing,
could you share your .config meanwhile? Thanks
--
Florian
