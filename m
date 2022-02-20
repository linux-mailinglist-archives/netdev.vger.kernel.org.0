Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3F94BCBCE
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 03:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiBTCz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 21:55:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiBTCz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 21:55:58 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15254506D
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 18:55:37 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id d16so11229776pgd.9
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 18:55:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bVuNRMZgNfYnUidfKrsiS9yuRezRu55H5b3kYHkH/OU=;
        b=nCTqi2PVVEIkzcqIngFlYxVZ6uNbUfceabvaKW4XQ4u8CagWNiqE4Fr4n2XPpZJsmY
         Pmei6XxEltQCV8RqPVT/lBxjxas+ca6vCfH6vXAyEXmaQRpbWzA1i45JGbvNjOk3uvVb
         hLj7GeglTyDJlo98T1sfUPRff2VxbzFv3gWCzJjZhY7q/2Q3PFMdj0S3jxItrljfds2d
         vU7xjjyEVstkiS6ffCQc5EzfXx94klqy6YqNDQvOwX40Kz5yVJAWat2QUFlxUPyBGf4X
         39E4Gm6YkThnV4N749+QB5hECuXbhcnGE57qF73BNGR5Vx9keI1RfiHQcJIhWR4zEkfU
         ftkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bVuNRMZgNfYnUidfKrsiS9yuRezRu55H5b3kYHkH/OU=;
        b=rUZFmQpV3PhjGwpq3aQZWramu0cmFy2ZNinTSofqOhMyRAPgyTJBHEkuC88TPDHjRV
         mGCH+dr1H89an8kqjz077emNP/gONcIPLwLc7jUgJot2qwyg/cJsODBtNE8drehOKOeg
         3/b80LFIY+EzuoG06bsCdcUgW6A/kciPvMopW1V9YlKocU1A5XAvnT3f+P8oF+ZTmwmY
         gm/a/D77Chz7+1Z76Br3HHMzll08PiDSlDzXr49ZZC3rYpOOx7QpruRrV9/x5ka6sM3Y
         PiCzbJUctsT+TL4W7NjZlmdqcWqnGjuGqw+SeWHYahmJJfglQTgTz1USPzgeQWfdp1wK
         ev0w==
X-Gm-Message-State: AOAM5333a0fq3+tijzMFPtOrRvUP3pAvEnn94/u7CqA9bKJ1WWMVt4qI
        /3Rj/M6h5DcW0V8W/gHYY0c=
X-Google-Smtp-Source: ABdhPJyIHGbTFiIj5krhlBb5qzrFEbecFF7SOvkh/HEbflgsDOPzFND2UPz8ksaQ71Rb+a17kaKOKQ==
X-Received: by 2002:a05:6a00:188a:b0:4e0:1cfc:2bfa with SMTP id x10-20020a056a00188a00b004e01cfc2bfamr14211127pfh.28.1645325737251;
        Sat, 19 Feb 2022 18:55:37 -0800 (PST)
Received: from [192.168.86.21] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id q5sm8437147pfu.199.2022.02.19.18.55.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Feb 2022 18:55:36 -0800 (PST)
Message-ID: <70de0cc3-c8c6-b973-fcc7-ac19b02fbbec@gmail.com>
Date:   Sat, 19 Feb 2022 18:55:33 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v3] net: hsr: fix suspicious RCU usage warning in
 hsr_node_get_first()
Content-Language: en-US
To:     patchwork-bot+netdevbpf@kernel.org,
        Juhee Kang <claudiajkang@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ennoerlangen@gmail.com, george.mccollister@gmail.com,
        olteanv@gmail.com, marco.wenzel@a-eberle.de,
        syzbot+f0eb4f3876de066b128c@syzkaller.appspotmail.com
References: <20220219152959.5761-1-claudiajkang@gmail.com>
 <164528940965.11889.6977167914313513410.git-patchwork-notify@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <164528940965.11889.6977167914313513410.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/19/22 08:50, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
>
> This patch was applied to netdev/net-next.git (master)
> by David S. Miller <davem@davemloft.net>:
>
> On Sat, 19 Feb 2022 15:29:59 +0000 you wrote:
>> When hsr_create_self_node() calls hsr_node_get_first(), the suspicious
>> RCU usage warning is occurred. The reason why this warning is raised is
>> the callers of hsr_node_get_first() use rcu_read_lock_bh() and
>> other different synchronization mechanisms. Thus, this patch solved by
>> replacing rcu_dereference() with rcu_dereference_bh_check().
>>
>> The kernel test robot reports:
>>      [   50.083470][ T3596] =============================
>>      [   50.088648][ T3596] WARNING: suspicious RCU usage
>>      [   50.093785][ T3596] 5.17.0-rc3-next-20220208-syzkaller #0 Not tainted
>>      [   50.100669][ T3596] -----------------------------
>>      [   50.105513][ T3596] net/hsr/hsr_framereg.c:34 suspicious rcu_dereference_check() usage!
>>      [   50.113799][ T3596]
>>      [   50.113799][ T3596] other info that might help us debug this:
>>      [   50.113799][ T3596]
>>      [   50.124257][ T3596]
>>      [   50.124257][ T3596] rcu_scheduler_active = 2, debug_locks = 1
>>      [   50.132368][ T3596] 2 locks held by syz-executor.0/3596:
>>      [   50.137863][ T3596]  #0: ffffffff8d3357e8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3be/0xb80
>>      [   50.147470][ T3596]  #1: ffff88807ec9d5f0 (&hsr->list_lock){+...}-{2:2}, at: hsr_create_self_node+0x225/0x650
>>      [   50.157623][ T3596]
>>      [   50.157623][ T3596] stack backtrace:
>>      [   50.163510][ T3596] CPU: 1 PID: 3596 Comm: syz-executor.0 Not tainted 5.17.0-rc3-next-20220208-syzkaller #0
>>      [   50.173381][ T3596] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>      [   50.183623][ T3596] Call Trace:
>>      [   50.186904][ T3596]  <TASK>
>>      [   50.189844][ T3596]  dump_stack_lvl+0xcd/0x134
>>      [   50.194640][ T3596]  hsr_node_get_first+0x9b/0xb0
>>      [   50.199499][ T3596]  hsr_create_self_node+0x22d/0x650
>>      [   50.204688][ T3596]  hsr_dev_finalize+0x2c1/0x7d0
>>      [   50.209669][ T3596]  hsr_newlink+0x315/0x730
>>      [   50.214113][ T3596]  ? hsr_dellink+0x130/0x130
>>      [   50.218789][ T3596]  ? rtnl_create_link+0x7e8/0xc00
>>      [   50.223803][ T3596]  ? hsr_dellink+0x130/0x130
>>      [   50.228397][ T3596]  __rtnl_newlink+0x107c/0x1760
>>      [   50.233249][ T3596]  ? rtnl_setlink+0x3c0/0x3c0
>>      [   50.238043][ T3596]  ? is_bpf_text_address+0x77/0x170
>>      [   50.243362][ T3596]  ? lock_downgrade+0x6e0/0x6e0
>>      [   50.248219][ T3596]  ? unwind_next_frame+0xee1/0x1ce0
>>      [   50.253605][ T3596]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
>>      [   50.259669][ T3596]  ? __sanitizer_cov_trace_cmp4+0x1c/0x70
>>      [   50.265423][ T3596]  ? is_bpf_text_address+0x99/0x170
>>      [   50.270819][ T3596]  ? kernel_text_address+0x39/0x80
>>      [   50.275950][ T3596]  ? __kernel_text_address+0x9/0x30
>>      [   50.281336][ T3596]  ? unwind_get_return_address+0x51/0x90
>>      [   50.286975][ T3596]  ? create_prof_cpu_mask+0x20/0x20
>>      [   50.292178][ T3596]  ? arch_stack_walk+0x93/0xe0
>>      [   50.297172][ T3596]  ? kmem_cache_alloc_trace+0x42/0x2c0
>>      [   50.302637][ T3596]  ? rcu_read_lock_sched_held+0x3a/0x70
>>      [   50.308194][ T3596]  rtnl_newlink+0x64/0xa0
>>      [   50.312524][ T3596]  ? __rtnl_newlink+0x1760/0x1760
>>      [   50.317545][ T3596]  rtnetlink_rcv_msg+0x413/0xb80
>>      [   50.322631][ T3596]  ? rtnl_newlink+0xa0/0xa0
>>      [   50.327159][ T3596]  netlink_rcv_skb+0x153/0x420
>>      [   50.331931][ T3596]  ? rtnl_newlink+0xa0/0xa0
>>      [   50.336436][ T3596]  ? netlink_ack+0xa80/0xa80
>>      [   50.341095][ T3596]  ? netlink_deliver_tap+0x1a2/0xc40
>>      [   50.346532][ T3596]  ? netlink_deliver_tap+0x1b1/0xc40
>>      [   50.351839][ T3596]  netlink_unicast+0x539/0x7e0
>>      [   50.356633][ T3596]  ? netlink_attachskb+0x880/0x880
>>      [   50.361750][ T3596]  ? __sanitizer_cov_trace_const_cmp8+0x1d/0x70
>>      [   50.368003][ T3596]  ? __sanitizer_cov_trace_const_cmp8+0x1d/0x70
>>      [   50.374707][ T3596]  ? __phys_addr_symbol+0x2c/0x70
>>      [   50.379753][ T3596]  ? __sanitizer_cov_trace_cmp8+0x1d/0x70
>>      [   50.385568][ T3596]  ? __check_object_size+0x16c/0x4f0
>>      [   50.390859][ T3596]  netlink_sendmsg+0x904/0xe00
>>      [   50.395715][ T3596]  ? netlink_unicast+0x7e0/0x7e0
>>      [   50.400722][ T3596]  ? __sanitizer_cov_trace_const_cmp4+0x1c/0x70
>>      [   50.407003][ T3596]  ? netlink_unicast+0x7e0/0x7e0
>>      [   50.412119][ T3596]  sock_sendmsg+0xcf/0x120
>>      [   50.416548][ T3596]  __sys_sendto+0x21c/0x320
>>      [   50.421052][ T3596]  ? __ia32_sys_getpeername+0xb0/0xb0
>>      [   50.426427][ T3596]  ? lockdep_hardirqs_on_prepare+0x400/0x400
>>      [   50.432721][ T3596]  ? __context_tracking_exit+0xb8/0xe0
>>      [   50.438188][ T3596]  ? lock_downgrade+0x6e0/0x6e0
>>      [   50.443041][ T3596]  ? lock_downgrade+0x6e0/0x6e0
>>      [   50.447902][ T3596]  __x64_sys_sendto+0xdd/0x1b0
>>      [   50.452759][ T3596]  ? lockdep_hardirqs_on+0x79/0x100
>>      [   50.457964][ T3596]  ? syscall_enter_from_user_mode+0x21/0x70
>>      [   50.464150][ T3596]  do_syscall_64+0x35/0xb0
>>      [   50.468565][ T3596]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>      [   50.474452][ T3596] RIP: 0033:0x7f3148504e1c
>>      [   50.479052][ T3596] Code: fa fa ff ff 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28 48 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 f0 ff ff 77 34 89 ef 48 89 44 24 08 e8 20 fb ff ff 48 8b
>>      [   50.498926][ T3596] RSP: 002b:00007ffeab5f2ab0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
>>      [   50.507342][ T3596] RAX: ffffffffffffffda RBX: 00007f314959d320 RCX: 00007f3148504e1c
>>      [   50.515393][ T3596] RDX: 0000000000000048 RSI: 00007f314959d370 RDI: 0000000000000003
>>      [   50.523444][ T3596] RBP: 0000000000000000 R08: 00007ffeab5f2b04 R09: 000000000000000c
>>      [   50.531492][ T3596] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
>>      [   50.539455][ T3596] R13: 00007f314959d370 R14: 0000000000000003 R15: 0000000000000000
>>
>> [...]
> Here is the summary with links:
>    - [net-next,v3] net: hsr: fix suspicious RCU usage warning in hsr_node_get_first()
>      https://git.kernel.org/netdev/net-next/c/e7f27420681f
>
> You are awesome, thank you!


This patch broke the build, please revert or fix.


ERROR: modpost: "lockdep_is_held" [net/hsr/hsr.ko] undefined!




