Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E856C41C444
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 14:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245686AbhI2MHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 08:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245149AbhI2MHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 08:07:14 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6F9C06161C;
        Wed, 29 Sep 2021 05:05:32 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id c4so1355592pls.6;
        Wed, 29 Sep 2021 05:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:organization:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ym/1oOlP5kxw9x+Vgc1zg2uXuJW7Z+Ydo358yPxD/RA=;
        b=pDOA425J+CXZkssE75ijtIypIAN5Sz9cXe0mpTAInbuAwE30PcfuRubFKW2zWV3viR
         QEUjcPwENJKsjWJ64tFHUW/louCg0zSNA2EbOZrZheZ6R54k3J6gYrF5cWBLuyFIzhSH
         VJ6jbHN3glPAppP6TUBcbMAtnFnORDT3BWpqJw4APf9mrSMqXn87RkyFHhb4h6bpbI0t
         0M1GbhMn13Mrvf8i/HEmMstFJ+hkrD2qQa55QMDVKTSyu/pPS5e5SY/IJMzXs8Sz3Xga
         GsMScXxL6r0UCe5wnII4JAP/P81e9N5e8kp0J/Vk1LnDe/SDKCOZgt5w6Ka67yObbUYS
         puYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Ym/1oOlP5kxw9x+Vgc1zg2uXuJW7Z+Ydo358yPxD/RA=;
        b=fqGDpNrQqdDJ5z74nPj4+jc5JkRxo59oOqmrizS+/tsGazod7B0fuPtxE6Eckr6cCH
         YxjXxSpf5fDSulPdCq7T3c1++Het8uB8M9RLgfDm2ymoHPq1BbbKmE+1ON22IetIgQ3R
         2Orm5IKIrWniD33gG7rXJTms0z+a8Gu1gFjkHp4XzAgmoxpnzMSoVA8pSMldDuwMRm9w
         D9EbKWoK27x688PRv6oLgU0hct2j3+DNjiKGAtfwUwqZ/odC/IeBCywzNI3U7PHhkxb6
         raJjaOlYxoCnl75Xd+vhPjqZuW9wNwSve5silmE6RT8pT35XTX470rr/TZL+Nwe/HU5e
         nwLw==
X-Gm-Message-State: AOAM530hCG94SG672DYNtIaSVyOFot+2a1SsyJRCN0CJ6jLPLszXGio9
        Czdi6wY6cdFPBB7T0ddcs8k=
X-Google-Smtp-Source: ABdhPJzObRKOJGazifBvyBw9YZJbcssRJ/dDKuPOGuat5ILRFWc+Oaq3erHsq9CrOvU4RdjQn0FTvw==
X-Received: by 2002:a17:90a:1db:: with SMTP id 27mr6106297pjd.106.1632917132377;
        Wed, 29 Sep 2021 05:05:32 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id n9sm1965993pjk.3.2021.09.29.05.05.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 05:05:32 -0700 (PDT)
To:     Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, like.xu@linux.intel.com
References: <0E5E6FCA-23ED-4CAA-ADEA-967430C62F6F@fb.com>
 <YVQXT5piFYa/SEY/@hirez.programming.kicks-ass.net>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: bpf_get_branch_snapshot on qemu-kvm
Message-ID: <d75f6a9a-dbb3-c725-c001-ec9bdd55173f@gmail.com>
Date:   Wed, 29 Sep 2021 20:05:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YVQXT5piFYa/SEY/@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/9/2021 3:35 pm, Peter Zijlstra wrote:
> On Wed, Sep 29, 2021 at 12:04:21AM +0000, Song Liu wrote:
>> Hi Peter,
>>
>> We have see the warning below while testing the new bpf_get_branch_snapshot
>> helper, on a QEMU vm (/usr/bin/qemu-system-x86_64 -enable-kvm -cpu host ...).
>> This issue doesn't happen on bare metal systems (no QEMU).
>>
>> We didn't cover this case, as LBR didn't really work in QEMU. But it seems to
>> work after I upgrade the host kernel to 5.12.

The guest LBR is enabled since the v5.12.

>>
>> At the moment, we don't have much idea on how to debug and fix the issue. Could
>> you please share your thoughts on this?
> 
> Well, that's virt, afaik stuff not working is like a feature there or
> something, who knows. I've Cc'ed Like Xu who might have clue since he
> did the patches.
> 
> Virt just ain't worth the pain if you ask me.

Just cc me for any vPMU/x86 stuff.

> 
>>
>> Thanks in advance!
>>
>> Song
>>
>>
>>
>>
>> ============================== 8< ============================
>>
>> [  139.494159] unchecked MSR access error: WRMSR to 0x3f1 (tried to write 0x0000000000000000) at rIP: 0xffffffff81011a8b (intel_pmu_snapshot_branch_stack+0x3b/0xd0)

Uh, it uses a PEBS counter to sample or count, which is not yet upstream but 
should be soon.

Song, can you try to fix bpf_get_branch_snapshot on a normal PMC counter,
or where is the src for bpf_get_branch_snapshot? I am more than happy to help.

>> [  139.495587] Call Trace:
>> [  139.495845]  bpf_get_branch_snapshot+0x17/0x40
>> [  139.496285]  bpf_prog_35810402cd1d294c_test1+0x33/0xe6c
>> [  139.496791]  bpf_trampoline_10737534536_0+0x4c/0x1000
>> [  139.497274]  bpf_testmod_loop_test+0x5/0x20 [bpf_testmod]
>> [  139.497799]  bpf_testmod_test_read+0x71/0x1f0 [bpf_testmod]
>> [  139.498332]  ? bpf_testmod_loop_test+0x20/0x20 [bpf_testmod]
>> [  139.498878]  ? sysfs_kf_bin_read+0xbe/0x110
>> [  139.499284]  ? bpf_testmod_loop_test+0x20/0x20 [bpf_testmod]
>> [  139.499829]  kernfs_fop_read_iter+0x1ac/0x2c0
>> [  139.500245]  ? kernfs_create_link+0x110/0x110
>> [  139.500667]  new_sync_read+0x24b/0x360
>> [  139.501037]  ? __x64_sys_llseek+0x1e0/0x1e0
>> [  139.501444]  ? rcu_read_lock_held_common+0x1a/0x50
>> [  139.501942]  ? rcu_read_lock_held_common+0x1a/0x50
>> [  139.502404]  ? rcu_read_lock_sched_held+0x5f/0xd0
>> [  139.502865]  ? rcu_read_lock_bh_held+0xb0/0xb0
>> [  139.503294]  ? security_file_permission+0xe7/0x2c0
>> [  139.503758]  vfs_read+0x1a4/0x2a0
>> [  139.504091]  ksys_read+0xc0/0x160
>> [  139.504413]  ? vfs_write+0x510/0x510
>> [  139.504756]  ? ktime_get_coarse_real_ts64+0xe4/0xf0
>> [  139.505234]  do_syscall_64+0x3a/0x80
>> [  139.505581]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> [  139.506066] RIP: 0033:0x7fb8a05728b2
>> [  139.506413] Code: 97 20 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b6 0f 1f 80 00 00 00 00 f3 0f 1e fa 8b 05 96 db 20 00 85 c0 75 12 31 c0 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 41 54 49 89 d4 55 48 89
>> [  139.508164] RSP: 002b:00007ffe66315a28 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
>> [  139.508870] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb8a05728b2
>> [  139.509545] RDX: 0000000000000064 RSI: 0000000000000000 RDI: 0000000000000010
>> [  139.510225] RBP: 00007ffe66315a60 R08: 0000000000000000 R09: 00007ffe66315907
>> [  139.510897] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000040c8b0
>> [  139.511570] R13: 00007ffe66315cc0 R14: 0000000000000000 R15: 0000000000000000
