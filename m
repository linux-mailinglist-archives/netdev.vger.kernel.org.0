Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6666C367AAD
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 09:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbhDVHKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 03:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhDVHKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 03:10:17 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75F7C06174A;
        Thu, 22 Apr 2021 00:09:42 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id g5so60461047ejx.0;
        Thu, 22 Apr 2021 00:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X338HNooootoGgLp4Uh2rRwvRKYDOVvH5vsvPe4Uc28=;
        b=A4XeclTyEu5VZVCgWBT7mGSoaa+ezp2msSvlhn3okMVtX8kfU5RTlI0DB9GK8Bfy1c
         YsZ+tEqCWOg/FfoWRnk+uwU/bW9ynDbdPAkNUDc0judgL9b//hLi8sw8YrJuYAKoQTdQ
         bBthX0C89A7XDfJ9/XCmHFiPk/EzStAMu0BW8+KCped+pUq/lRJFX2xrZJ4MyzgfSZPW
         ySCMEbY9lqECYczEpDOPc+5XgQIvvxg3t7czWVhDnsOTV5BUCfPfHcDEh+jLu6wTU66U
         hh4kHAmtWM5ElPVOxLmhQK0SF1nDcAeXn5gc7/l85MyXFa+X3m77+OmxcJFzMkeRG1BF
         Ijjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X338HNooootoGgLp4Uh2rRwvRKYDOVvH5vsvPe4Uc28=;
        b=ZV605v+x2dc0fLSwirbcouzlOZoduPuTZaPEuNLte3tk79+tdAtNW8W9OPTHVkODPR
         ac8CmFqXC8707ccmTpjuWkgqlVs5zhZfGaYzAbud3oLUGqFq/m8W8Dy8vxwScnX/l1dF
         aFkrkmFkC5mthatHRG6CRqzMHv6l9KFr2iciUkZc0pR/IO2wGQJ5EvDsOwqbp2SWJWgK
         11L8+LmnzQB1Bvspc0hXgqF01DinCWSu2GuFZJFUgYWXskskeLUf7HOJ0idWw4rEBwaN
         60pVPujkiGMKiZy0nX3MOoz7jhQO5guIrwdVBV7D2nIrGRAPhqVS7AI4jbe2Pg8B39Mi
         0mEg==
X-Gm-Message-State: AOAM5329uQIz6xSgEq4vcJVcg/RlcTQj4AU5h0DbfBqrTkmQpF2mAb1L
        b9VvFrmH1nSBuNA0ROtocmG0h5StPH6h7w==
X-Google-Smtp-Source: ABdhPJw7AiSOCXLuAM3X1uaXnIrKWtUTvd48Dx8U7MRWPzUfhI1/uIkMX6vMkTzWuyMk2zTsy38yhw==
X-Received: by 2002:a17:906:b01:: with SMTP id u1mr1875232ejg.310.1619075381367;
        Thu, 22 Apr 2021 00:09:41 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:bdfe:7c1a:e805:a0da? (p200300ea8f384600bdfe7c1ae805a0da.dip0.t-ipconnect.de. [2003:ea:8f38:4600:bdfe:7c1a:e805:a0da])
        by smtp.googlemail.com with ESMTPSA id s8sm1258056edj.25.2021.04.22.00.09.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 00:09:40 -0700 (PDT)
Subject: Re: [PATCH] net: called rtnl_unlock() before runpm resumes devices
To:     AceLan Kao <acelan.kao@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210420075406.64105-1-acelan.kao@canonical.com>
 <CANn89iJLSmtBNoDo8QJ6a0MzsHjdLB0Pf=cs9e4g8Y6-KuFiMQ@mail.gmail.com>
 <20210420122715.2066b537@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFv23Q=ywiuZp7Y=bj=SAZmDdAnanAXA954hdO3GpkjmDo=RpQ@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c10a6c72-9db7-18c8-6b03-1f8c40b8fd87@gmail.com>
Date:   Thu, 22 Apr 2021 09:09:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CAFv23Q=ywiuZp7Y=bj=SAZmDdAnanAXA954hdO3GpkjmDo=RpQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.04.2021 08:30, AceLan Kao wrote:
> Yes, should add
> 
> Fixes: 9474933caf21 ("igb: close/suspend race in netif_device_detach")
> and also
> Fixes: 9513d2a5dc7f ("igc: Add legacy power management support")
> 
Please don't top-post. Apart from that:
If the issue was introduced with driver changes, then adding a workaround
in net core may not be the right approach.

> Jakub Kicinski <kuba@kernel.org> 於 2021年4月21日 週三 上午3:27寫道：
>>
>> On Tue, 20 Apr 2021 10:34:17 +0200 Eric Dumazet wrote:
>>> On Tue, Apr 20, 2021 at 9:54 AM AceLan Kao <acelan.kao@canonical.com> wrote:
>>>>
>>>> From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
>>>>
>>>> The rtnl_lock() has been called in rtnetlink_rcv_msg(), and then in
>>>> __dev_open() it calls pm_runtime_resume() to resume devices, and in
>>>> some devices' resume function(igb_resum,igc_resume) they calls rtnl_lock()
>>>> again. That leads to a recursive lock.
>>>>
>>>> It should leave the devices' resume function to decide if they need to
>>>> call rtnl_lock()/rtnl_unlock(), so call rtnl_unlock() before calling
>>>> pm_runtime_resume() and then call rtnl_lock() after it in __dev_open().
>>>>
>>>>
>>>
>>> Hi Acelan
>>>
>>> When was the bugg added ?
>>> Please add a Fixes: tag
>>
>> For immediate cause probably:
>>
>> Fixes: 9474933caf21 ("igb: close/suspend race in netif_device_detach")
>>
>>> By doing so, you give more chances for reviewers to understand why the
>>> fix is not risky,
>>> and help stable teams work.
>>
>> IMO the driver lacks internal locking. Taking rtnl from resume is just
>> one example, git history shows many more places that lacked locking and
>> got papered over with rtnl here.

