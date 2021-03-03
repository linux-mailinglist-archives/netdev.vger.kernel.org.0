Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2860A32B39C
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbhCCEIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448449AbhCCDvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 22:51:54 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAEDC06121E
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 19:51:13 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id u11so13262473plg.13
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 19:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=btSyVcUz2f887COubIE5pQvTrmhQZ96vILuNh1QhsE8=;
        b=beI+XgatJKBS7j1wPnQHksilrCSKOerOBtoDwjvXC970qbu5NfAcXbrJ1IAUheTbuZ
         /tuu56UL8pmZV/0+QZKGOVOF2V/pdQDEqyOWv5APj7LuYSzMi9Og8ORj4jycOGBbYYZS
         LCWOMEcBWB+RpEHXr3qr2e2r0GYXccdH6zIGb0BEjssGoN8WoPY6KSQaz5R6UutmeRdm
         8TXt3ruYTvmE5h2OiCPML31iT2xCYYiWVHAsRu8KrjBQgBwFzH2MsdX7vP3eLcjRDSkg
         4Y1ktw//tSe34gTLF57cOyAZLl5g7DyoC3Hgu5XhMoXdSUlpdGLzS4RRm1H1sNE4YEXP
         ELtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=btSyVcUz2f887COubIE5pQvTrmhQZ96vILuNh1QhsE8=;
        b=rHiLsV0sgg8I+rukcD7T3WKZNNaanCYDHIjkgutDV6Sj35XRReSQMNCEoKVxRzEDsV
         fVsxdl6wEBETLPp6Ldrnl4wpctMP/MOLdjTy4TOQxG+GTUuuoHXMzy1mWT2lufR7sjlI
         bdMtW/yLy5tTHweFEqRLPW+ESFVSgtsDe9LXNUmhTpZmfTZFY8haJJaDzEuoowaE4YXq
         Rr2S5H739zu4V4Yu/pSsYXky0T5uYBWuX7qooF0CmPO/4DLs4e2Hs9a4U93Q/LgIrEQO
         HUJIMe+NDkaU/TSsqAA2ZETSj9oTfKDQlXnf7fgjbdaO4/qHl5awnNhDBi+kjhdcNgwO
         JQ0g==
X-Gm-Message-State: AOAM532AmLFJiplWT0xdFmdf8Ev75cfR2UKw3WaxqZsjiMTtlIGig7pH
        k5zgB2VEU3OjsJhM+MjulUL2Ag==
X-Google-Smtp-Source: ABdhPJy3bXJ04ezyVZJZAsNZkA0YC4Pv2zyvro1P/rMVFTMdgNrz/WiSgB7+dL4zC15a0gzJQ6hpVQ==
X-Received: by 2002:a17:90a:a789:: with SMTP id f9mr7916760pjq.192.1614743472840;
        Tue, 02 Mar 2021 19:51:12 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o23sm22936220pfp.89.2021.03.02.19.51.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Mar 2021 19:51:12 -0800 (PST)
Subject: Re: [PATCH] iwlwifi: ensure that DMI scan table is properly
 terminated
From:   Jens Axboe <axboe@kernel.dk>
To:     "Coelho, Luciano" <luciano.coelho@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
References: <0d52ff85-323f-67b8-5fdb-bbf3093b0ccf@kernel.dk>
 <782d5382b0c8c9b33277422c8e41180c49044128.camel@intel.com>
 <3f8e28b1-0c15-7539-ef50-5cfb71a3591f@kernel.dk>
Message-ID: <20cdd691-0872-523d-e565-909f75e62956@kernel.dk>
Date:   Tue, 2 Mar 2021 20:51:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3f8e28b1-0c15-7539-ef50-5cfb71a3591f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/21 8:49 PM, Jens Axboe wrote:
> On 3/2/21 11:34 AM, Coelho, Luciano wrote:
>> On Tue, 2021-03-02 at 11:20 -0700, Jens Axboe wrote:
>>> My laptop crashes at boot, and I ran the same kernel with KASAN enabled.
>>> Turns out the DMI addition for iwlwifi is broken (and untested?), since
>>> it doesn't properly terminate the scan table. Ensure that we do so.
>>>
>>> ==================================================================
>>> BUG: KASAN: global-out-of-bounds in dmi_check_system+0x5a/0x70
>>> Read of size 1 at addr ffffffffc16af750 by task NetworkManager/1913
>>>
>>> CPU: 4 PID: 1913 Comm: NetworkManager Not tainted 5.12.0-rc1+ #10057
>>> Hardware name: LENOVO 20THCTO1WW/20THCTO1WW, BIOS N2VET27W (1.12 ) 12/21/2020
>>> Call Trace:
>>>  dump_stack+0x90/0xbe
>>>  print_address_description.constprop.0+0x1d/0x140
>>>  ? dmi_check_system+0x5a/0x70
>>>  ? dmi_check_system+0x5a/0x70
>>>  kasan_report.cold+0x7b/0xd4
>>>  ? dmi_check_system+0x5a/0x70
>>>  __asan_load1+0x4d/0x50
>>>  dmi_check_system+0x5a/0x70
>>>  iwl_mvm_up+0x1360/0x1690 [iwlmvm]
>>>  ? iwl_mvm_send_recovery_cmd+0x270/0x270 [iwlmvm]
>>>  ? setup_object.isra.0+0x27/0xd0
>>>  ? kasan_poison+0x20/0x50
>>>  ? ___slab_alloc.constprop.0+0x483/0x5b0
>>>  ? mempool_kmalloc+0x17/0x20
>>>  ? ftrace_graph_ret_addr+0x2a/0xb0
>>>  ? kasan_poison+0x3c/0x50
>>>  ? cfg80211_iftype_allowed+0x2e/0x90 [cfg80211]
>>>  ? __kasan_check_write+0x14/0x20
>>>  ? mutex_lock+0x86/0xe0
>>>  ? __mutex_lock_slowpath+0x20/0x20
>>>  __iwl_mvm_mac_start+0x49/0x290 [iwlmvm]
>>>  iwl_mvm_mac_start+0x37/0x50 [iwlmvm]
>>>  drv_start+0x73/0x1b0 [mac80211]
>>>  ieee80211_do_open+0x53e/0xf10 [mac80211]
>>>  ? ieee80211_check_concurrent_iface+0x266/0x2e0 [mac80211]
>>>  ieee80211_open+0xb9/0x100 [mac80211]
>>>  __dev_open+0x1b8/0x280
>>>  ? dev_set_rx_mode+0x40/0x40
>>>  __dev_change_flags+0x32f/0x3a0
>>>  ? dev_set_allmulti+0x20/0x20
>>>  ? is_bpf_text_address+0x24/0x30
>>>  ? kernel_text_address+0xbb/0xd0
>>>  dev_change_flags+0x63/0xc0
>>>  do_setlink+0xb59/0x18c0
>>>  ? rtnetlink_put_metrics+0x2e0/0x2e0
>>>  ? stack_trace_consume_entry+0x90/0x90
>>>  ? if6_seq_show+0xb0/0xb0
>>>  ? kasan_save_stack+0x42/0x50
>>>  ? kasan_save_stack+0x23/0x50
>>>  ? kasan_set_track+0x20/0x30
>>>  ? kasan_set_free_info+0x24/0x40
>>>  ? __kasan_slab_free+0xea/0x120
>>>  ? kfree+0x94/0x250
>>>  ? memset+0x3c/0x50
>>>  ? __nla_validate_parse+0xc1/0x12d0
>>>  ? ____sys_sendmsg+0x430/0x450
>>>  ? ___sys_sendmsg+0xf2/0x160
>>>  ? __sys_sendmsg+0xc8/0x150
>>>  ? __x64_sys_sendmsg+0x48/0x50
>>>  ? do_syscall_64+0x32/0x80
>>>  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>  ? nla_get_range_signed+0x1c0/0x1c0
>>>  ? nla_put_ifalias+0x86/0xf0
>>>  ? __cgroup_bpf_run_filter_skb+0xc1/0x6f0
>>>  ? memcpy+0x4e/0x60
>>>  ? __kasan_check_read+0x11/0x20
>>>  __rtnl_newlink+0x905/0xde0
>>>  ? ipv6_dev_get_saddr+0x4c0/0x4c0
>>>  ? rtnl_setlink+0x250/0x250
>>>  ? ftrace_graph_ret_addr+0x2a/0xb0
>>>  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>  ? bpf_ksym_find+0x94/0xe0
>>>  ? __rcu_read_unlock+0x39/0x60
>>>  ? is_bpf_text_address+0x24/0x30
>>>  ? kernel_text_address+0xbb/0xd0
>>>  ? __kernel_text_address+0x12/0x40
>>>  ? unwind_get_return_address+0x36/0x50
>>>  ? create_prof_cpu_mask+0x30/0x30
>>>  ? arch_stack_walk+0x98/0xf0
>>>  ? stack_trace_save+0x94/0xc0
>>>  ? stack_trace_consume_entry+0x90/0x90
>>>  ? arch_stack_walk+0x98/0xf0
>>>  ? __kasan_kmalloc+0x81/0xa0
>>>  ? kmem_cache_alloc_trace+0xf4/0x220
>>>  rtnl_newlink+0x55/0x80
>>>  rtnetlink_rcv_msg+0x22f/0x560
>>>  ? __kasan_slab_alloc+0x5f/0x80
>>>  ? rtnl_calcit.isra.0+0x1e0/0x1e0
>>>  ? __x64_sys_sendmsg+0x48/0x50
>>>  ? do_syscall_64+0x32/0x80
>>>  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>  ? kernel_text_address+0xbb/0xd0
>>>  ? __kernel_text_address+0x12/0x40
>>>  ? unwind_get_return_address+0x36/0x50
>>>  netlink_rcv_skb+0xe7/0x210
>>>  ? rtnl_calcit.isra.0+0x1e0/0x1e0
>>>  ? netlink_ack+0x580/0x580
>>>  ? netlink_deliver_tap+0x68/0x3d0
>>>  rtnetlink_rcv+0x15/0x20
>>>  netlink_unicast+0x3a8/0x4f0
>>>  ? netlink_attachskb+0x430/0x430
>>>  ? __alloc_skb+0xd7/0x1e0
>>>  netlink_sendmsg+0x3ff/0x710
>>>  ? __rcu_read_unlock+0x39/0x60
>>>  ? netlink_unicast+0x4f0/0x4f0
>>>  ? iovec_from_user+0x6c/0x170
>>>  ? __import_iovec+0x137/0x1c0
>>>  ? netlink_unicast+0x4f0/0x4f0
>>>  sock_sendmsg+0x74/0x80
>>>  ____sys_sendmsg+0x430/0x450
>>>  ? kernel_sendmsg+0x40/0x40
>>>  ? do_recvmmsg+0x440/0x440
>>>  ? kasan_save_stack+0x42/0x50
>>>  ? kasan_save_stack+0x23/0x50
>>>  ? kasan_record_aux_stack+0xac/0xc0
>>>  ? call_rcu+0x5a/0x450
>>>  ? __fput+0x1d7/0x3d0
>>>  ? ____fput+0xe/0x10
>>>  ___sys_sendmsg+0xf2/0x160
>>>  ? sendmsg_copy_msghdr+0x120/0x120
>>>  ? __kasan_check_write+0x14/0x20
>>>  ? _raw_spin_lock+0x82/0xd0
>>>  ? _raw_read_lock_irq+0x50/0x50
>>>  ? __fget_files+0xce/0x110
>>>  ? __fget_light+0x72/0x100
>>>  ? __fdget+0x13/0x20
>>>  __sys_sendmsg+0xc8/0x150
>>>  ? __sys_sendmsg_sock+0x20/0x20
>>>  ? __kasan_check_read+0x11/0x20
>>>  ? fpregs_assert_state_consistent+0x5a/0x70
>>>  __x64_sys_sendmsg+0x48/0x50
>>>  do_syscall_64+0x32/0x80
>>>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>> RIP: 0033:0x7f752cc7312d
>>> Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 ca ee ff ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 2f 44 89 c7 48 89 44 24 08 e8 fe ee ff ff 48
>>> RSP: 002b:00007ffd1962bc70 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
>>> RAX: ffffffffffffffda RBX: 000055e6574ba880 RCX: 00007f752cc7312d
>>> RDX: 0000000000000000 RSI: 00007ffd1962bcc0 RDI: 000000000000000c
>>> RBP: 00007ffd1962bcc0 R08: 0000000000000000 R09: 0000000000000000
>>> R10: 0000000000000001 R11: 0000000000000293 R12: 000055e6574ba880
>>> R13: 00007ffd1962be78 R14: 00007ffd1962be6c R15: 0000000000000000
>>>
>>> The buggy address belongs to the variable:
>>>  dmi_ppag_approved_list+0x570/0xffffffffffffde20 [iwlmvm]
>>>
>>> Memory state around the buggy address:
>>>  ffffffffc16af600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>>  ffffffffc16af680: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>>> ffffffffc16af700: 00 00 00 00 00 00 00 00 f9 f9 f9 f9 00 00 00 01
>>>                                                  ^
>>>  ffffffffc16af780: f9 f9 f9 f9 00 00 00 00 00 00 02 f9 f9 f9 f9 f9
>>>  ffffffffc16af800: 00 00 00 07 f9 f9 f9 f9 00 00 00 00 00 00 00 01
>>> ==================================================================
>>>
>>> Fixes: a2ac0f48a07c ("iwlwifi: mvm: implement approved list for the PPAG feature")
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>> ---
>>>
>>> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
>>> index 15e2773ce7e7..71e5306bd695 100644
>>> --- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
>>> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
>>> @@ -1083,6 +1083,7 @@ static const struct dmi_system_id dmi_ppag_approved_list[] = {
>>>  			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTek COMPUTER INC."),
>>>  		},
>>>  	},
>>> +	{ },
>>>  };
>>>  
>>>
>>>  static int iwl_mvm_ppag_init(struct iwl_mvm *mvm)
>>>
>>
>> Hi Jens,
>>
>> Thanks for the report and patch! And I'm sorry that we broke your
>> laptop's boot...
>>
>> We already have a patch to fix this:
>>
>> https://patchwork.kernel.org/project/linux-wireless/patch/20210223140039.1708534-1-weiyongjun1@huawei.com/
>>
>> I thought I had already acked it for Kalle to take it directly to
>> wireless-drivers, but apparently I hadn't.
>>
>> I acked now and assigned it to him.
> 
> All good thanks, as long as it gets fixed and goes upstream I don't care
> where it's from :-)

I looked at the link, and feel free to steal my commit trace/message it
you want.

-- 
Jens Axboe

