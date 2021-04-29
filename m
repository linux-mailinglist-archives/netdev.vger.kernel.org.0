Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F2636F0A5
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 22:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbhD2Thv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 15:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbhD2Thq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 15:37:46 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34269C06138D;
        Thu, 29 Apr 2021 12:36:58 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l189-20020a1cbbc60000b0290140319ad207so433011wmf.2;
        Thu, 29 Apr 2021 12:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qlS5r8WmHQxo/OnVogOgr3WbtBIkoT2r6t/FJvPT26E=;
        b=T/hQMTIZ3pyBoTAy+RMNEvXKAEpOFTuvPeDjS0Rh/ZIguls3ySUmSO5PK7//dP0M4k
         t1rq7mvkXLurJvg2vYnD9A15WmUMxRsgFg2NVgCSBmUnn147NAw1qvh88Y5OlS7bGxW6
         bvoz9T+VTjstvQWyVLoBB6mIeqfxQUxdis9VhgQ3zsHwC4nAGFKFGfSXxk08FR7TAcwG
         /TGbv34RGL1en9pzfO9KC0rrmbvNqN9CDJnTj0KRQv3yk5Re/MoJIOwo0i5ZkJjW0fWg
         o5csF4emT6xSmkWNSu489CFmWYiCCy3wVAEBYAInOLA1jVSNnukKAzNptFpy3VqcUqVP
         2jdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qlS5r8WmHQxo/OnVogOgr3WbtBIkoT2r6t/FJvPT26E=;
        b=EAZDr1/NXt9vdgZix/vNChFji3ydDEjPaTf8hRX6xtLtChuzK3z2AcnqUE+kPKuIfu
         5lTvh/SO6cEp8E5IlAaD1cDNpkbXxyiRFpRuce9MYDIk8+XRdo10k1eo38ruCnE+sc0r
         /fC/4KC6D72wJN1LAXxDI2fOKrJimeGVLyj0mShZzsStkyzCJev2Zj/2JZ9roOoH6i/G
         NLA4c++tMq44zjkLE9wg06OrXVD+YQ4uld5GeBgRgZfaWlT/Q7CTFoLPrVEUda13Kk9s
         XD10crsewl/CgPu4EJQjL4cDQzBS6j2V8X2gnO+h2dURs9LMCK6hNZ/Gm7gDb2/vASIU
         gdBw==
X-Gm-Message-State: AOAM532HAc+xS6dRjyJyzp7OuzwYh4Z6LKhq8W/yFeV+l5YZvdcO7Jbj
        S7vnlgUqCcWHF0Rye+Rlvt27hP9AwIrwfA==
X-Google-Smtp-Source: ABdhPJxTPT0NN5zDcd579l6YoyPR8Y5UVFbq+pg1ztsyA9rKh/TkKXB3o6GAO3XYG3U62sBzIorgnQ==
X-Received: by 2002:a1c:4c09:: with SMTP id z9mr1911617wmf.104.1619725016646;
        Thu, 29 Apr 2021 12:36:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:9534:e42b:7544:4530? (p200300ea8f3846009534e42b75444530.dip0.t-ipconnect.de. [2003:ea:8f38:4600:9534:e42b:7544:4530])
        by smtp.googlemail.com with ESMTPSA id g12sm11941407wmh.24.2021.04.29.12.36.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 12:36:56 -0700 (PDT)
Subject: Re: [PATCH] net: called rtnl_unlock() before runpm resumes devices
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        AceLan Kao <acelan.kao@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210420075406.64105-1-acelan.kao@canonical.com>
 <CAJKOXPfp875V3zHorfyf+QLwia5HYX3N=AXe=xRCxCDi6ifbtg@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <f2c051e9-aee6-3409-37a8-1d9d9add8211@gmail.com>
Date:   Thu, 29 Apr 2021 21:33:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CAJKOXPfp875V3zHorfyf+QLwia5HYX3N=AXe=xRCxCDi6ifbtg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.04.2021 13:58, Krzysztof Kozlowski wrote:
> On Tue, 20 Apr 2021 at 09:55, AceLan Kao <acelan.kao@canonical.com> wrote:
>>
>> From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
>>
>> The rtnl_lock() has been called in rtnetlink_rcv_msg(), and then in
>> __dev_open() it calls pm_runtime_resume() to resume devices, and in
>> some devices' resume function(igb_resum,igc_resume) they calls rtnl_lock()
>> again. That leads to a recursive lock.
>>
>> It should leave the devices' resume function to decide if they need to
>> call rtnl_lock()/rtnl_unlock(), so call rtnl_unlock() before calling
>> pm_runtime_resume() and then call rtnl_lock() after it in __dev_open().
>>
>> [  967.723577] INFO: task ip:6024 blocked for more than 120 seconds.
>> [  967.723588]       Not tainted 5.12.0-rc3+ #1
>> [  967.723592] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [  967.723594] task:ip              state:D stack:    0 pid: 6024 ppid:  5957 flags:0x00004000
>> [  967.723603] Call Trace:
>> [  967.723610]  __schedule+0x2de/0x890
>> [  967.723623]  schedule+0x4f/0xc0
>> [  967.723629]  schedule_preempt_disabled+0xe/0x10
>> [  967.723636]  __mutex_lock.isra.0+0x190/0x510
>> [  967.723644]  __mutex_lock_slowpath+0x13/0x20
>> [  967.723651]  mutex_lock+0x32/0x40
>> [  967.723657]  rtnl_lock+0x15/0x20
>> [  967.723665]  igb_resume+0xee/0x1d0 [igb]
>> [  967.723687]  ? pci_pm_default_resume+0x30/0x30
>> [  967.723696]  igb_runtime_resume+0xe/0x10 [igb]
>> [  967.723713]  pci_pm_runtime_resume+0x74/0x90
>> [  967.723718]  __rpm_callback+0x53/0x1c0
>> [  967.723725]  rpm_callback+0x57/0x80
>> [  967.723730]  ? pci_pm_default_resume+0x30/0x30
>> [  967.723735]  rpm_resume+0x547/0x760
>> [  967.723740]  __pm_runtime_resume+0x52/0x80
>> [  967.723745]  __dev_open+0x56/0x160
>> [  967.723753]  ? _raw_spin_unlock_bh+0x1e/0x20
>> [  967.723758]  __dev_change_flags+0x188/0x1e0
>> [  967.723766]  dev_change_flags+0x26/0x60
>> [  967.723773]  do_setlink+0x723/0x10b0
>> [  967.723782]  ? __nla_validate_parse+0x5b/0xb80
>> [  967.723792]  __rtnl_newlink+0x594/0xa00
>> [  967.723800]  ? nla_put_ifalias+0x38/0xa0
>> [  967.723807]  ? __nla_reserve+0x41/0x50
>> [  967.723813]  ? __nla_reserve+0x41/0x50
>> [  967.723818]  ? __kmalloc_node_track_caller+0x49b/0x4d0
>> [  967.723824]  ? pskb_expand_head+0x75/0x310
>> [  967.723830]  ? nla_reserve+0x28/0x30
>> [  967.723835]  ? skb_free_head+0x25/0x30
>> [  967.723843]  ? security_sock_rcv_skb+0x2f/0x50
>> [  967.723850]  ? netlink_deliver_tap+0x3d/0x210
>> [  967.723859]  ? sk_filter_trim_cap+0xc1/0x230
>> [  967.723863]  ? skb_queue_tail+0x43/0x50
>> [  967.723870]  ? sock_def_readable+0x4b/0x80
>> [  967.723876]  ? __netlink_sendskb+0x42/0x50
>> [  967.723888]  ? security_capable+0x3d/0x60
>> [  967.723894]  ? __cond_resched+0x19/0x30
>> [  967.723900]  ? kmem_cache_alloc_trace+0x390/0x440
>> [  967.723906]  rtnl_newlink+0x49/0x70
>> [  967.723913]  rtnetlink_rcv_msg+0x13c/0x370
>> [  967.723920]  ? _copy_to_iter+0xa0/0x460
>> [  967.723927]  ? rtnl_calcit.isra.0+0x130/0x130
>> [  967.723934]  netlink_rcv_skb+0x55/0x100
>> [  967.723939]  rtnetlink_rcv+0x15/0x20
>> [  967.723944]  netlink_unicast+0x1a8/0x250
>> [  967.723949]  netlink_sendmsg+0x233/0x460
>> [  967.723954]  sock_sendmsg+0x65/0x70
>> [  967.723958]  ____sys_sendmsg+0x218/0x290
>> [  967.723961]  ? copy_msghdr_from_user+0x5c/0x90
>> [  967.723966]  ? lru_cache_add_inactive_or_unevictable+0x27/0xb0
>> [  967.723974]  ___sys_sendmsg+0x81/0xc0
>> [  967.723980]  ? __mod_memcg_lruvec_state+0x22/0xe0
>> [  967.723987]  ? kmem_cache_free+0x244/0x420
>> [  967.723991]  ? dentry_free+0x37/0x70
>> [  967.723996]  ? mntput_no_expire+0x4c/0x260
>> [  967.724001]  ? __cond_resched+0x19/0x30
>> [  967.724007]  ? security_file_free+0x54/0x60
>> [  967.724013]  ? call_rcu+0xa4/0x250
>> [  967.724021]  __sys_sendmsg+0x62/0xb0
>> [  967.724026]  ? exit_to_user_mode_prepare+0x3d/0x1a0
>> [  967.724032]  __x64_sys_sendmsg+0x1f/0x30
>> [  967.724037]  do_syscall_64+0x38/0x90
>> [  967.724044]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
>> ---
>>  net/core/dev.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 1f79b9aa9a3f..427cbc80d1e5 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -1537,8 +1537,11 @@ static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
>>
>>         if (!netif_device_present(dev)) {
>>                 /* may be detached because parent is runtime-suspended */
>> -               if (dev->dev.parent)
>> +               if (dev->dev.parent) {
>> +                       rtnl_unlock();
>>                         pm_runtime_resume(dev->dev.parent);
> 
> A side topic, maybe a little bit silly question (I don't know that
> much about net core):
> Why not increase the parent or current PM runtime usage counter
> instead? The problem with calling pm_runtime_resume() is that if the
> parent device was already suspended (so it's usage counter ==0), it
> might get suspended right after this call. IOW, you do not have any
> guarantee that the device will be really resumed. Probably it should
> be pm_runtime_resume_and_get() (and later "put" on close or other
> events). This however might not solve the lock problem at all.
> 
The point of runtime-resuming the parent here isn't to ensure it's
resumed for the complete time the device is open. It's called
because netif_device_present() may be (initially) false just because
the parent is runtime-suspended.
We want the device to be able to runtime-suspend later if e.g.
the link is down.

> Best regards,
> Krzysztof
> 

