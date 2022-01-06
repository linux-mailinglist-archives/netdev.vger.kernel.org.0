Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03CE14864A2
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 13:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbiAFMyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 07:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239098AbiAFMyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 07:54:37 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB7BC061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 04:54:37 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id ke6so2212066qvb.1
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 04:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WVWxWBzU2Aj850k7wNpapYDFk+2bf43BphwQgCoZvXc=;
        b=KRL7XhrTR/31CuTxdSEdKpjxEJ6fotfYpZ2orCuTO59tOnU2XFkkGOLzHIwu6N8udT
         /L+KkIZxZxY8ju/CkBqz9G7lmekp6ZMv7D4p+iiwNSCmKvKgz/sqaRR+yJZkm2M7MZzb
         FkTC7OmSBf3Vq9jlXtkWEt6D0+DHXV68mW+7/BR05OErnRM5BtWQAYblZPm81Vu/oZ0k
         62ViuvEqVxRf7dW6Vo3DZIZNzb+9YP08MSo8K6PB1/Cb8mZ0J46wzDR27QzlywOwiwgc
         2sjV5PKMEG4MXu0QBZBqnFX9C7mMH+luvxERucbEFa7ao5EwhigugvQwZXSmJSShFHkv
         Gqyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WVWxWBzU2Aj850k7wNpapYDFk+2bf43BphwQgCoZvXc=;
        b=gn/pGDRTcDH/+kIheyXncT7SO0y3Qun8p2WP5PX72TjIY0CtNQYqeKSOTV10v4Q1tS
         ib4xiIC9SrUb0N7IbetUNkJAw2vX7+4fLQiG+qAZGM2vQiBhMfKH6zrOiB75Di+yZlxb
         6GFjPt8+QJgmwRl2PQVXWhHjIfuC5DRZPfmaqOIZXXb/2cxcUZ8swSsPLfUK07SPJ19o
         gEXE3QzppJqCPV2bKbsC4dpJnmkoyrTNSf/hJ5S18yIMCa1XF4Nkn+EfxON7qjTnkGLU
         pxxc/TSVbV0sXPOgirqL1yiW8Mw69j6KNMKSiXGFywscg5n8aKxDDON6zLp3htGcOf1X
         Dp5Q==
X-Gm-Message-State: AOAM533DLpf331pd/HgS/WQNpARKcm+r+wmTLd81nO3MZQLAMv7AjK8H
        Kb/ik9GH2SgdLp8iIKSL6PNjZA==
X-Google-Smtp-Source: ABdhPJzQt/7yVFVvM08DwW1F65uN2cygHKdAOhICBmyU3zph/20l2j7ROhdt2RGV5GbnJsUfjS5xFA==
X-Received: by 2002:a05:6214:2a88:: with SMTP id jr8mr54274249qvb.79.1641473676445;
        Thu, 06 Jan 2022 04:54:36 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id o5sm1541001qkp.132.2022.01.06.04.54.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jan 2022 04:54:35 -0800 (PST)
Message-ID: <0d81227f-944c-47f2-9cba-2ae063f3a44c@mojatatu.com>
Date:   Thu, 6 Jan 2022 07:54:34 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net 1/1] net: openvswitch: Fix ct_state nat flags for
 conns arriving from tc
Content-Language: en-US
To:     Paul Blakey <paulb@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>, davem@davemloft.net,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, john.fastabend@gmail.com
References: <20220104082821.22487-1-paulb@nvidia.com>
 <776c2688-72db-4ad6-45e5-73bc08b78615@mojatatu.com>
 <72368c25-83c5-565f-0512-ca5d58315685@iogearbox.net>
 <5599f6-e02e-9ad5-3585-db252e946f43@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <5599f6-e02e-9ad5-3585-db252e946f43@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-05 11:18, Paul Blakey wrote:
> 
> 
> On Wed, 5 Jan 2022, Daniel Borkmann wrote:
> 

[..]

>> Full ack on the bloat for corner cases like ovs offload, especially
>> given distros just enable most stuff anyway and therefore no light
>> fast path as with !CONFIG_NET_TC_SKB_EXT. :(
>>
>> Could this somehow be hidden behind static key or such if offloads
>> are not used, so we can shrink it back to just calling into plain
>> __tcf_classify() for sw-only use cases (like BPF)?
>>
>>
> 
> It is used for both tc -> ovs and driver -> tc path.
> 
> I think I can do what you suggest adn will work on something like
> that,  but this specific patch  doesn't really change the ext
> allocation/derefences count (and probably  not the size as well).
> So can  we take  this (not yet posted v2 after fixing what already
> mentioned) and I'll do a patch of what you suggest in net-next?
> 

Sounds reasonable.

The main outstanding challenge is still going to be all these bit
declarations (and i am sure more to come) that are specific for
specific components in TC (act_ct in this case); if every component
started planting their flags(pun intended) then both backwards and
forwards compatibility are going to be needed for maintainance.

The _cb spaces are supposed to be opaque and meaning to whats in
that space is only sensible to the component that is storing and
retrieving. Something like chain id is ok in that namespaces
because it has global meaning to TC, the others are not. My
suggestion is going forward try to not add more component specific
variables.
For a proper solution:
I think we need some sort of "metadata bus" to resolve this in the
long run. Something which is a bigger surgery...

cheers,
jamal

cheers,
jamal


