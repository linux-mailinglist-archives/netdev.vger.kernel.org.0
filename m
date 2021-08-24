Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A152E3F56CA
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 05:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbhHXDfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 23:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbhHXDfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 23:35:03 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B7AC061575;
        Mon, 23 Aug 2021 20:34:17 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so1171590pje.0;
        Mon, 23 Aug 2021 20:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c4X2hGPWaVlQ6GtKxvEpJQp2AW5a0gYAW9+FheV6Pcc=;
        b=M58R1NutlahGzkXTxU8kjGXK3On8ctSVu8hRCGZXm7D53yIJFEilVdfDqx+71a76zV
         1z5nz8y6UeX1cY3ouXZ0x7zf+u2mex25l/iASMyKfrofee/4ZXtVRPJn/qbfK5UVvO34
         jNLDPSBf3DjdDl9tdQ0IynZzQDMN2UiJONrZhUSJXxdF49kvBElqtqfEHqIkPaUxRyap
         FlOThjcHU65FDIgx7/1U5VIhicBG4s/qCfvtlZy4nsx/FxtYmuiq3GKLnp83QKWhrMyg
         dOnQ6v6jOAuuOUmRKDNIfsIokuJNVi9Mova1apSnXfueyCcTYkaDFonTxvAvl+unYUuU
         af1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c4X2hGPWaVlQ6GtKxvEpJQp2AW5a0gYAW9+FheV6Pcc=;
        b=J0Om+y8Tm4scIxxgeAkjQnLSz5qkIsTjcUdMk/wSrmdytXRk4jUiRQ2T/OuxhDSigp
         GcbkbRbbg4rPto3n+C+WpR2D5FIxIzIPJ2FDCBoiOjkY6zVompOfTHcxrRcs7dlpC2eC
         b/0KDe++v1jGQum29GmRh1nElzqYzdvbLke1+MupBhpc2mMLq+rq+iRrdQm88S5K23s7
         +nuV5KDONfymBbXZzlnVV+xTmtkL9akPgHZNnMrTXKoK8WR4+2dvBY1HJh4f0H2d/+uv
         Myi1fqvzeWwz7P1Fs7RMw54NvJIjG3j2ERflkriSzBRnQAiY/XNq6k/U3WXY4idGzFpC
         3RkA==
X-Gm-Message-State: AOAM532SN9uFvr0QI6QldF0ZlzluMV4wFwbCzg0CjSXvXMtNWAXmntss
        mwrisYGL9wJ0Im9WubrGkMA=
X-Google-Smtp-Source: ABdhPJyzFeKXXog3uuEKaC3aeIUxKU8NbhD9P0ADq8rvyksYe+uXPe9PsTja1SWkhSaPfMek8dY/PA==
X-Received: by 2002:a17:902:c40e:b029:12c:cbce:2d18 with SMTP id k14-20020a170902c40eb029012ccbce2d18mr31385724plk.60.1629776057036;
        Mon, 23 Aug 2021 20:34:17 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.119])
        by smtp.googlemail.com with ESMTPSA id x4sm17465633pfu.65.2021.08.23.20.34.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 20:34:16 -0700 (PDT)
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
 <83b8bae8-d524-36a1-302e-59198410d9a9@gmail.com>
 <f0d935b9-45fe-4c51-46f0-1f526167877f@huawei.com>
 <619b5ca5-a48b-49e9-2fef-a849811d62bb@gmail.com>
 <744e88b6-7cb4-ea99-0523-4bfa5a23e15c@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <80701f7a-e7c6-eb86-4018-67033f0823bf@gmail.com>
Date:   Mon, 23 Aug 2021 20:34:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <744e88b6-7cb4-ea99-0523-4bfa5a23e15c@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/21 9:32 PM, Yunsheng Lin wrote:
> 
> I assumed the "either Rx or Tx is cpu bound" meant either Rx or Tx is the
> bottleneck?

yes.

> 
> It seems iperf3 support the Tx ZC, I retested using the iperf3, Rx settings
> is not changed when testing, MTU is 1500:

-Z == sendfile API. That works fine to a point and that point is well
below 100G.

I mean TCP with MSG_ZEROCOPY and SO_ZEROCOPY.

> 
> IOMMU in strict mode:
> 1. Tx ZC case:
>    22Gbit with Tx being bottleneck(cpu bound)
> 2. Tx non-ZC case with pfrag pool enabled:
>    40Git with Rx being bottleneck(cpu bound)
> 3. Tx non-ZC case with pfrag pool disabled:
>    30Git, the bottleneck seems not to be cpu bound, as the Rx and Tx does
>    not have a single CPU reaching about 100% usage.
> 
>>
>> At 1500 MTU lowering CPU usage on the Tx side does not accomplish much
>> on throughput since the Rx is 100% cpu.
> 
> As above performance data, enabling ZC does not seems to help when IOMMU
> is involved, which has about 30% performance degrade when pfrag pool is
> disabled and 50% performance degrade when pfrag pool is enabled.

In a past response you should numbers for Tx ZC API with a custom
program. That program showed the dramatic reduction in CPU cycles for Tx
with the ZC API.

> 
>>
>> At 3300 MTU you have ~47% the pps for the same throughput. Lower pps
>> reduces Rx processing and lower CPU to process the incoming stream. Then
>> using the Tx ZC API you lower the Tx overehad allowing a single stream
>> to faster - sending more data which in the end results in much higher
>> pps and throughput. At the limit you are CPU bound (both ends in my
>> testing as Rx side approaches the max pps, and Tx side as it continually
>> tries to send data).
>>
>> Lowering CPU usage on Tx the side is a win regardless of whether there
>> is a big increase on the throughput at 1500 MTU since that configuration
>> is an Rx CPU bound problem. Hence, my point that we have a good start
>> point for lowering CPU usage on the Tx side; we should improve it rather
>> than add per-socket page pools.
> 
> Acctually it is not a per-socket page pools, the page pool is still per
> NAPI, this patchset adds multi allocation context to the page pool, so that
> the tx can reuse the same page pool with rx, which is quite usefully if the
> ARFS is enabled.
> 
>>
>> You can stress the Tx side and emphasize its overhead by modifying the
>> receiver to drop the data on Rx rather than copy to userspace which is a
>> huge bottleneck (e.g., MSG_TRUNC on recv). This allows the single flow
> 
> As the frag page is supported in page pool for Rx, the Rx probably is not
> a bottleneck any more, at least not for IOMMU in strict mode.
> 
> It seems iperf3 does not support MSG_TRUNC yet, any testing tool supporting
> MSG_TRUNC? Or do I have to hack the kernel or iperf3 tool to do that?

https://github.com/dsahern/iperf, mods branch

--zc_api is the Tx ZC API; --rx_drop adds MSG_TRUNC to recv.


> 
>> stream to go faster and emphasize Tx bottlenecks as the pps at 3300
>> approaches the top pps at 1500. e.g., doing this with iperf3 shows the
>> spinlock overhead with tcp_sendmsg, overhead related to 'select' and
>> then gup_pgd_range.
> 
> When IOMMU is in strict mode, the overhead with IOMMU seems to be much
> bigger than spinlock(23% to 10%).
> 
> Anyway, I still think ZC mostly benefit to packet which is bigger than a
> specific size and IOMMU disabling case.
> 
> 
>> .
>>

