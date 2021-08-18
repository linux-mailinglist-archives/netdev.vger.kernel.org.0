Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A247E3F0DDC
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 00:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbhHRWGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 18:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234106AbhHRWGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 18:06:33 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70786C061764;
        Wed, 18 Aug 2021 15:05:58 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 61-20020a9d0d430000b02903eabfc221a9so6091484oti.0;
        Wed, 18 Aug 2021 15:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0rNS2PoZrMPVMBxbsnOQrGtXMRMxqJ7zXicAn/pdXAY=;
        b=hb4q7IuwbzqucH4vCCuT4NXU/3RGVRqzzhzpL7Ml56j1/GHt5mt3pRLpI81HJqU3gk
         ZqmVsIBjJOfZXU+COfY+u7JGtTKJeEgQ47IK4309a8py/4yM0GqZ6NKgxfHzHW5SXcPB
         cOUJ2neC2YYD8/5Kr1QZvDagbyYvU/Tig+Td4ZHl5oTcoXQLtoYnQvB0ET/O97hir6+S
         +enJyA5aOPZPEM1T8E2qF6h+9a1NX60H+B2BLFnWHCs0lgPl8oA2kteIlLAACw/YZ7MT
         7Sglbe3WadDs6pb51U/S9VX7CK6KPA23B6dg9G1AWiPLiatfH7WIhKL7Ezp6Fu4n3kjX
         FpVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0rNS2PoZrMPVMBxbsnOQrGtXMRMxqJ7zXicAn/pdXAY=;
        b=j9yaR0v6XKLRnRdZME/9DsEU5N5JvlHA3rmq2g9/1fxZEDXGhawX0kywUg6M1rP1iW
         z7QphwqwRVW2VUtHVoKLzTqqPcGJW/a0hQYT5uhICNqSbIBcREYUqeTQVdBWInpUf9fE
         Mt/qMi+fSUrvZeiiqlOAfX9VkgSFKZz8ESSLRa6Ji6m4H/j0xyFImeytA8fWvXmucz57
         Lqhjtxu/m3HIbk09QxqrRCe96ASJJQEdSWvM5WWk6Z7HvxZB2PVYoqeK56uQQkUqPJqj
         9+83NtPVIDYtEsyiP0WupdK0/0dIkRr8JXohE8KKQhjdBIidLT1JuegzV6DIxlVVj2W1
         PdUQ==
X-Gm-Message-State: AOAM531i98/xuPv05IM68JjLsFyJk4bS6pzRw+0u8F8VryjS0EKrirES
        7+Ik2m5xLp6yCPNKW6oTXeI=
X-Google-Smtp-Source: ABdhPJw4rSeTRjxg3dAfoQ8EWVv+CMGy1hX5lWIs9KORSQ4E7XcLcttTcKqXjG0lSImPiuh9fa7F7Q==
X-Received: by 2002:a9d:3e16:: with SMTP id a22mr9122960otd.101.1629324357778;
        Wed, 18 Aug 2021 15:05:57 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id d26sm212266oos.41.2021.08.18.15.05.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 15:05:57 -0700 (PDT)
Subject: Re: [PATCH RFC 0/7] add socket to netdev page frag recycling support
To:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     alexander.duyck@gmail.com, linux@armlinux.org.uk, mw@semihalf.com,
        linuxarm@openeuler.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, thomas.petazzoni@bootlin.com,
        hawk@kernel.org, ilias.apalodimas@linaro.org, ast@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com,
        akpm@linux-foundation.org, peterz@infradead.org, will@kernel.org,
        willy@infradead.org, vbabka@suse.cz, fenghua.yu@intel.com,
        guro@fb.com, peterx@redhat.com, feng.tang@intel.com, jgg@ziepe.ca,
        mcroce@microsoft.com, hughd@google.com, jonathan.lemon@gmail.com,
        alobakin@pm.me, willemb@google.com, wenxu@ucloud.cn,
        cong.wang@bytedance.com, haokexin@gmail.com, nogikh@google.com,
        elver@google.com, yhs@fb.com, kpsingh@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, chenhao288@hisilicon.com, edumazet@google.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, memxor@gmail.com,
        linux@rempel-privat.de, atenart@kernel.org, weiwan@google.com,
        ap420073@gmail.com, arnd@arndb.de,
        mathew.j.martineau@linux.intel.com, aahringo@redhat.com,
        ceggers@arri.de, yangbo.lu@nxp.com, fw@strlen.de,
        xiangxia.m.yue@gmail.com, linmiaohe@huawei.com
References: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <83b8bae8-d524-36a1-302e-59198410d9a9@gmail.com>
Date:   Wed, 18 Aug 2021 16:05:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/17/21 9:32 PM, Yunsheng Lin wrote:
> This patchset adds the socket to netdev page frag recycling
> support based on the busy polling and page pool infrastructure.
> 
> The profermance improve from 30Gbit to 41Gbit for one thread iperf
> tcp flow, and the CPU usages decreases about 20% for four threads
> iperf flow with 100Gb line speed in IOMMU strict mode.
> 
> The profermance improve about 2.5% for one thread iperf tcp flow
> in IOMMU passthrough mode.
> 

Details about the test setup? cpu model, mtu, any other relevant changes
/ settings.

How does that performance improvement compare with using the Tx ZC API?
At 1500 MTU I see a CPU drop on the Tx side from 80% to 20% with the ZC
API and ~10% increase in throughput. Bumping the MTU to 3300 and
performance with the ZC API is 2x the current model with 1/2 the cpu.

Epyc 7502, ConnectX-6, IOMMU off.

In short, it seems like improving the Tx ZC API is the better path
forward than per-socket page pools.
