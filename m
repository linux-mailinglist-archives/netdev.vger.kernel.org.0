Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029A345615A
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 18:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234070AbhKRRWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 12:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234081AbhKRRWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 12:22:42 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D96C061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 09:19:41 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id np3so5642492pjb.4
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 09:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o5TdC2WrrT9RKMPoUKhsRNFfK/BKeWguuQ0ey9ElpQc=;
        b=FchYmR7rQPIEN8kFGzXn4cXyD4RDruMnDrJ6ajhRtxillQoMZcUXE8mx4/m2ZLXOO3
         jnrQkkW9SP8sLufaLuy8dWfhlSa1QFCOVCmryhr8JXP30UQP5mrAh0jjYK9wK8EUZ5uk
         3nqqdl7pwCy2BTGY+V7kXEI2EACMV5/PeXxrOpfDpxWxJ35C3oNAgUs317slc87FuskA
         wlMtOS9YhW8I0o2518o+Wbidz2q17cG1FqvxLdjtfidI8FL4hydhXBken9fGZ6YpRmDY
         wR9ixPe5dwWGLXXy6ZO+su4CXg8HXZPGGfb4pD3p/3hVhLtXq0t01I5vYsFp5gCATt99
         gUlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o5TdC2WrrT9RKMPoUKhsRNFfK/BKeWguuQ0ey9ElpQc=;
        b=u4Kn1al4N9R9adau7cdeFtcjuFpPHbFAIWhsfL6aCJazT3R33kbzRpo2FUG1TlOhVv
         rpExnf9GqH9/QcY5d0z2MDTVZz+aa8ey3LUBlBjwC/a52rGY6yenZjAIeClWQCaT2uAT
         Gkv3XhTDVhDEwPA71B8gPOrh6kPKV2uBDeOBlkMHx4z4rh/eh31CyR12nL5pmFx8zjRj
         29tr74zvbZBVsVKGJXohqSub4c5oIY7aW026mur7GJ6Yw6UyuczCQuy6s78fylfkRl4m
         7QJOsaOa8jE31cdJa5R8ow5oea5/5s/v5HDtflNUS+JXKnLPGRbTW2wVP1uV5WeqXAzA
         lUMQ==
X-Gm-Message-State: AOAM5305n7SZ4LxjAXuyh7WqsjJg8xpc+qTezSnahM4FMREZfZehpKW0
        5ksiwGNtkNKYiSqAjchGeK0=
X-Google-Smtp-Source: ABdhPJz6EDq9WqgF9Ty92p3BUQlyPDOMZ+DWVMlJNc/S561Xl5hrTPlTHT8QcUuaHktqz+Df9eRwfg==
X-Received: by 2002:a17:90a:e54c:: with SMTP id ei12mr12341269pjb.81.1637255981184;
        Thu, 18 Nov 2021 09:19:41 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id h3sm195129pfc.204.2021.11.18.09.19.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 09:19:40 -0800 (PST)
Subject: Re: Bad performance in RX with sfc 40G
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>, habetsm.xilinx@gmail.com
Cc:     netdev@vger.kernel.org, Dinan Gunawardena <dinang@xilinx.com>,
        Pablo Cascon <pabloc@xilinx.com>
References: <CACT4oudChHDKecLfDdA7R8jpQv2Nmz5xBS3hH_jFWeS37CnQGg@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <beef3b28-6818-df7b-eaad-8569cac5d79b@gmail.com>
Date:   Thu, 18 Nov 2021 09:19:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CACT4oudChHDKecLfDdA7R8jpQv2Nmz5xBS3hH_jFWeS37CnQGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/21 7:14 AM, Íñigo Huguet wrote:
> Hello,
> 
> Doing some tests a few weeks ago I noticed a very low performance in
> RX using 40G Solarflare NICs. Doing tests with iperf3 I got more than
> 30Gbps in TX, but just around 15Gbps in RX. Other NICs from other
> vendors could send and receive over 30Gbps.
> 
> I was doing the tests with multiple threads in iperf3 (-P 8).
> 
> The models used are SFC9140 and SFC9220.
> 
> Perf showed that most of the time was being expended in
> `native_queued_spin_lock_slowpath`. Tracing the calls to it with
> bpftrace I got that most of the calls were from __napi_poll > efx_poll
>> efx_fast_push_rx_descriptors > __alloc_pages >
> get_page_from_freelist > ...
> 
> Please can you help me investigate the issue? At first sight, it seems
> a not very optimal memory allocation strategy, or maybe a failure in
> pages recycling strategy...
> 
> This is the output of bpftrace, the 2 call chains that repeat more
> times, both from sfc
> 
> @[
>     native_queued_spin_lock_slowpath+1
>     _raw_spin_lock+26
>     rmqueue_bulk+76
>     get_page_from_freelist+2295
>     __alloc_pages+214
>     efx_fast_push_rx_descriptors+640
>     efx_poll+660
>     __napi_poll+42
>     net_rx_action+547
>     __softirqentry_text_start+208
>     __irq_exit_rcu+179
>     common_interrupt+131
>     asm_common_interrupt+30
>     cpuidle_enter_state+199
>     cpuidle_enter+41
>     do_idle+462
>     cpu_startup_entry+25
>     start_kernel+2465
>     secondary_startup_64_no_verify+194
> ]: 2650
> @[
>     native_queued_spin_lock_slowpath+1
>     _raw_spin_lock+26
>     rmqueue_bulk+76
>     get_page_from_freelist+2295
>     __alloc_pages+214
>     efx_fast_push_rx_descriptors+640
>     efx_poll+660
>     __napi_poll+42
>     net_rx_action+547
>     __softirqentry_text_start+208
>     __irq_exit_rcu+179
>     common_interrupt+131
>     asm_common_interrupt+30
>     cpuidle_enter_state+199
>     cpuidle_enter+41
>     do_idle+462
>     cpu_startup_entry+25
>     secondary_startup_64_no_verify+194
> ]: 17119
> 
> --
> Íñigo Huguet
> 


You could try to :

Make the RX ring buffers bigger (ethtool -G eth0 rx 8192)

and/or

Make sure your tcp socket receive buffer is smaller than number of frames in the ring buffer

echo "4096 131072 2097152" >/proc/sys/net/ipv4/tcp_rmem

You can also try latest net-next, as TCP got something to help this case.

f35f821935d8df76f9c92e2431a225bdff938169 tcp: defer skb freeing after socket lock is released
