Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8BF316B16
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 17:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbhBJQX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 11:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbhBJQXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 11:23:24 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40002C061756
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 08:22:44 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id w1so1186687ilm.12
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 08:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JSh8ExYxdty8HZ11KujafrMp7iovLQF4x5Wy4WPKtFY=;
        b=MqBF5ZEr+daNm21Pgbp5M3xc3FrA2e2xhHAo0Dk1bkOF988nmvj/JIs0ba1jcPJ203
         rl6mzOsv2xikvam4uDDIWkXM2lxulDO5Pw/Sz92l1FqLWb4bICKwNCirxhULXoxgy6w7
         RnfuncRvRYQFUiRv98y3Apa/O2gIu6jPfC9xo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JSh8ExYxdty8HZ11KujafrMp7iovLQF4x5Wy4WPKtFY=;
        b=emgZtyMrtcNsM2rb4wKcCaUqq393dKczulth269gebvCiNM0L9uOrHc5XA56fUeHSC
         GHbBhIZe3j/ObqYoVM9MzA+BaTL0lNPgyizYuViXweuHDuAwuGTTjb2mLY2AKl3+liT4
         L+pnrisBRWwZYsVcQA4ILQQ/qXm9G7HuUFYujLZAJ3G3pXYdRysyf27wZnEkyh5rP1I6
         aXg4aMjKBcBe06k63iIc2CsQPRkKgzu+rtB2pfgiUFplbnp6YVAVZuRSkOC9voOd+9LV
         5LwTCeegcSsv05BSmZJ0OucFnK9rEWaIL8MNQ4Xy0Ui6P5F3z6WcUcSUDNnfQi2M956J
         GuRQ==
X-Gm-Message-State: AOAM5316HvHR53lZsfPY8e4sogBxB1KB72Nvbll26K4KaqquKIpWCJtK
        VU2vIGLn17HEqiKJqW+g7VAO4k+6jKC2sg==
X-Google-Smtp-Source: ABdhPJzXyC8AmV48saKbwVck5pzWW/8Ry9H6e0li1SH7HuPENRqrnsNCXgsFgCru0G3RWsdbnHR4Nw==
X-Received: by 2002:a92:dcc6:: with SMTP id b6mr1836908ilr.295.1612974163736;
        Wed, 10 Feb 2021 08:22:43 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k11sm1129540iop.45.2021.02.10.08.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 08:22:43 -0800 (PST)
Subject: Re: [PATCH 2/5] ath10k: fix WARNING: suspicious RCU usage
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <23a1333dfb0367cc69e7177a2e373df0b6d42980.1612915444.git.skhan@linuxfoundation.org>
 <20210210081320.2FBE5C433CA@smtp.codeaurora.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <7230c9e5-2632-b77e-c4f9-10eca557a5bb@linuxfoundation.org>
Date:   Wed, 10 Feb 2021 09:22:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210210081320.2FBE5C433CA@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/21 1:13 AM, Kalle Valo wrote:
> Shuah Khan <skhan@linuxfoundation.org> wrote:
> 
>> ieee80211_find_sta_by_ifaddr() must be called under the RCU lock and
>> the resulting pointer is only valid under RCU lock as well.
>>
>> Fix ath10k_wmi_tlv_parse_peer_stats_info() to hold RCU lock before it
>> calls ieee80211_find_sta_by_ifaddr() and release it when the resulting
>> pointer is no longer needed. The log below shows the problem.
>>
>> While at it, fix ath10k_wmi_tlv_op_pull_peer_stats_info() to do the same.
>>
>> =============================
>> WARNING: suspicious RCU usage
>> 5.11.0-rc7+ #20 Tainted: G        W
>> -----------------------------
>> include/linux/rhashtable.h:594 suspicious rcu_dereference_check() usage!
>> other info that might help us debug this:
>>                 rcu_scheduler_active = 2, debug_locks = 1
>> no locks held by ksoftirqd/5/44.
>>
>> stack backtrace:
>> CPU: 5 PID: 44 Comm: ksoftirqd/5 Tainted: G        W         5.11.0-rc7+ #20
>> Hardware name: LENOVO 10VGCTO1WW/3130, BIOS M1XKT45A 08/21/2019
>> Call Trace:
>>   dump_stack+0x7d/0x9f
>>   lockdep_rcu_suspicious+0xdb/0xe5
>>   __rhashtable_lookup+0x1eb/0x260 [mac80211]
>>   ieee80211_find_sta_by_ifaddr+0x5b/0xc0 [mac80211]
>>   ath10k_wmi_tlv_parse_peer_stats_info+0x3e/0x90 [ath10k_core]
>>   ath10k_wmi_tlv_iter+0x6a/0xc0 [ath10k_core]
>>   ? ath10k_wmi_tlv_op_pull_mgmt_tx_bundle_compl_ev+0xe0/0xe0 [ath10k_core]
>>   ath10k_wmi_tlv_op_rx+0x5da/0xda0 [ath10k_core]
>>   ? trace_hardirqs_on+0x54/0xf0
>>   ? ath10k_ce_completed_recv_next+0x4e/0x60 [ath10k_core]
>>   ath10k_wmi_process_rx+0x1d/0x40 [ath10k_core]
>>   ath10k_htc_rx_completion_handler+0x115/0x180 [ath10k_core]
>>   ath10k_pci_process_rx_cb+0x149/0x1b0 [ath10k_pci]
>>   ? ath10k_htc_process_trailer+0x2d0/0x2d0 [ath10k_core]
>>   ? ath10k_pci_sleep.part.0+0x6a/0x80 [ath10k_pci]
>>   ath10k_pci_htc_rx_cb+0x15/0x20 [ath10k_pci]
>>   ath10k_ce_per_engine_service+0x61/0x80 [ath10k_core]
>>   ath10k_ce_per_engine_service_any+0x7d/0xa0 [ath10k_core]
>>   ath10k_pci_napi_poll+0x48/0x120 [ath10k_pci]
>>   net_rx_action+0x136/0x500
>>   __do_softirq+0xc6/0x459
>>   ? smpboot_thread_fn+0x2b/0x1f0
>>   run_ksoftirqd+0x2b/0x60
>>   smpboot_thread_fn+0x116/0x1f0
>>   kthread+0x14b/0x170
>>   ? smpboot_register_percpu_thread+0xe0/0xe0
>>   ? __kthread_bind_mask+0x70/0x70
>>   ret_from_fork+0x22/0x30
>>
>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> 
> Unlucky timing also on this one, it conflicts with a patch I applied yesterday:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=ath-next&id=2615e3cdbd9c0e864f5906279c952a309871d225
> 
> Can you redo the patch to only change ath10k_wmi_event_tdls_peer()?
> 

Yes. I will send the patch just for ath10k_wmi_event_tdls_peer()
on top of your patch.

> error: patch failed: drivers/net/wireless/ath/ath10k/wmi-tlv.c:240
> error: drivers/net/wireless/ath/ath10k/wmi-tlv.c: patch does not apply
> stg import: Diff does not apply cleanly
> 
> Patch set to Changes Requested.
> 

thanks,
-- Shuah
