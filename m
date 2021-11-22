Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F673458BCD
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 10:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239127AbhKVJ5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 04:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhKVJ5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 04:57:09 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5660C061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 01:54:02 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id i12so14687050wmq.4
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 01:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=FVe5pTAJIv0zbSgfgyfzXNka21cAoMBL2gZ0AWo0KLo=;
        b=yZPo/4348iLU3pbYX2QWjaBrHt0foqW1Pu1r3s8prv9GKicPHCserxqJzG+kWCmtQS
         qttajLrTlVQWnuwfgICNtxsUiRrvZJgUpJiXkxbXI8iW76u3YD+t+1urW6QrglA5RqQM
         WgLlyqKdzS7W/d7UvFOrQnjKQy+svF+111wKhHwBe8Wi9uanx3Zd+XhKvtKpmQXZ7lSx
         AKytlNzsEZivyKiujwPhjxDcXvpfp4rkdQiKdpCKbPcJ7k6x5jHyHYkJZN8Mjt479xoy
         FOTMyF+cy9w8HzEwJVR+3rO6+g60PREAFSW4pXuY3O5wtZPxdk7j25eZBr89ZC0GxXkB
         ez1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FVe5pTAJIv0zbSgfgyfzXNka21cAoMBL2gZ0AWo0KLo=;
        b=js+EdeMsHswFjUQkimSJxGWShuaGxeTBf9xSW6MxqcbjfHPr5x5Dh/2vZo8oWwgn66
         0xtpkI6yOexX9JGKVvnxEfZQSL/UeR5FYlUvj2DfWxAHGi5MAhwdIqiKMTTi6DYW1INX
         EbNpCWTnRhbd0eSoaf1AaJ4FElNXMvuCfl8ahf9TUP2Ym7QCABgT0VtpNtLxGinC0Xtn
         1O2QzWR0N4DpYCZZZPXDTf3wv/KyMihrpPxugyMg78kGEUFbMXUZhFcRO/lkjgABeepy
         867dNUILgTHGYIeL8O8cGD8bu67xyZWreTmLfrT/WnjmQNIOUcToXoiG6nQXIbEj8JPT
         1m2w==
X-Gm-Message-State: AOAM530TAeF5L/jDR9/UlbeGstZLeGdzwHwOkphmjzF2TfxpDTEtVMKS
        YHOQinXlXUcW+gLg7ptYmrpPJg==
X-Google-Smtp-Source: ABdhPJyi//dOyinujSl0dpEr65ssGGEWGe8lT/04vS5OGO6kD/KzFzEXWuTAPkWS1ZOXNcgrW0K6Ag==
X-Received: by 2002:a1c:ed0a:: with SMTP id l10mr23535711wmh.140.1637574841218;
        Mon, 22 Nov 2021 01:54:01 -0800 (PST)
Received: from [192.168.0.111] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id p19sm10043062wmq.4.2021.11.22.01.54.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 01:54:00 -0800 (PST)
Message-ID: <3a0dd68e-94e1-3473-3938-24b4f8bdfdee@blackwall.org>
Date:   Mon, 22 Nov 2021 11:53:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net 0/3] net: nexthop: fix refcount issues when replacing
 groups
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com
References: <20211121152453.2580051-1-razor@blackwall.org>
 <YZqIBVcFwIzj6VZG@shredder> <d902fd06-00c2-fbff-1df2-4db3e890724a@nvidia.com>
 <YZtncGsgIbo+q390@shredder>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <YZtncGsgIbo+q390@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/11/2021 11:48, Ido Schimmel wrote:
> On Sun, Nov 21, 2021 at 08:17:49PM +0200, Nikolay Aleksandrov wrote:
>> On 21/11/2021 19:55, Ido Schimmel wrote:
>>> On Sun, Nov 21, 2021 at 05:24:50PM +0200, Nikolay Aleksandrov wrote:
>>>> From: Nikolay Aleksandrov <nikolay@nvidia.com>
>>>>
>>>> Hi,
>>>> This set fixes a refcount bug when replacing nexthop groups and
>>>> modifying routes. It is complex because the objects look valid when
>>>> debugging memory dumps, but we end up having refcount dependency between
>>>> unlinked objects which can never be released, so in turn they cannot
>>>> free their resources and refcounts. The problem happens because we can
>>>> have stale IPv6 per-cpu dsts in nexthops which were removed from a
>>>> group. Even though the IPv6 gen is bumped, the dsts won't be released
>>>> until traffic passes through them or the nexthop is freed, that can take
>>>> arbitrarily long time, and even worse we can create a scenario[1] where it
>>>> can never be released. The fix is to release the IPv6 per-cpu dsts of
>>>> replaced nexthops after an RCU grace period so no new ones can be
>>>> created. To do that we add a new IPv6 stub - fib6_nh_release_dsts, which
>>>> is used by the nexthop code only when necessary. We can further optimize
>>>> group replacement, but that is more suited for net-next as these patches
>>>> would have to be backported to stable releases.
>>>
>>> Will run regression with these patches tonight and report tomorrow
>>>
>>
>> Thank you, I've prepared v2 with the selftest mausezahn check and will hold
>> it off to see how the tests would go. Also if any comments show up in the
>> meantime. :)
>>
>> By the way I've been running a torture test all day for multiple IPv6 route
>> forwarding + local traffic through different CPUs while also replacing multiple
>> nh groups referencing multiple nexthops, so far it looks good.
> 
> Regression looks good. Later today I will also have results from a debug
> kernel, but I think it should be fine.
> 
> Regarding patch #2, can you add a comment (or edit the commit message)
> to explain why the fix is only relevant for IPv4? I made this comment,
> but I think it was missed:
> 

I saw it, I've updated the commit msg to reflect why IPv4 isn't affected.

> "This problem is specific to IPv6 because IPv4 dst entries do not hold
> references on routes / FIB info thereby avoiding the circular dependency
> described in the commit message?"
> > Thanks!
> 

Cheers,
 Nik


