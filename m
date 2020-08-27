Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6475254906
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgH0PTb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 27 Aug 2020 11:19:31 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40950 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727814AbgH0PTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 11:19:16 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kBJfz-007FA8-US; Thu, 27 Aug 2020 09:18:55 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1kBJfy-0007id-QG; Thu, 27 Aug 2020 09:18:55 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Wang Long <w@laoqinren.net>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, edumazet@google.com,
        eric.dumazet@gmail.com, opurdila@ixiacom.com,
        vegard.nossum@gmail.com, LKML <linux-kernel@vger.kernel.org>
References: <40f6ec87-0c27-ca6f-383b-0602e78b0802@laoqinren.net>
Date:   Thu, 27 Aug 2020 10:15:11 -0500
In-Reply-To: <40f6ec87-0c27-ca6f-383b-0602e78b0802@laoqinren.net>+B0013AC41EFFDC1F
        (Wang Long's message of "Thu, 27 Aug 2020 19:03:25 +0800")
Message-ID: <878se0ktmo.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1kBJfy-0007id-QG;;;mid=<878se0ktmo.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/Nt7wifU2j/ZN8Vtlw5gW64Ra5vWe7El4=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.4 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,FVGT_m_MULTI_ODD,LotsOfNums_01,
        T_TM2_M_HEADER_IN_MSG,XM_B_Unicode autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
        *  0.0 XM_B_Unicode BODY: Testing for specific types of unicode
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 0; Body=1 Fuz1=1 Fuz2=1]
        *  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
X-Spam-DCC: ; sa07 0; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Wang Long <w@laoqinren.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 721 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 10 (1.5%), b_tie_ro: 9 (1.3%), parse: 0.94 (0.1%),
         extract_message_metadata: 22 (3.0%), get_uri_detail_list: 2.5 (0.3%),
        tests_pri_-1000: 27 (3.8%), tests_pri_-950: 1.20 (0.2%),
        tests_pri_-900: 0.99 (0.1%), tests_pri_-90: 120 (16.7%), check_bayes:
        118 (16.4%), b_tokenize: 10 (1.4%), b_tok_get_all: 11 (1.5%),
        b_comp_prob: 2.6 (0.4%), b_tok_touch_all: 91 (12.6%), b_finish: 0.93
        (0.1%), tests_pri_0: 525 (72.8%), check_dkim_signature: 0.75 (0.1%),
        check_dkim_adsp: 2.4 (0.3%), poll_dns_idle: 0.78 (0.1%), tests_pri_10:
        2.1 (0.3%), tests_pri_500: 6 (0.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: RFC: inet_timewait_sock->tw_timer list corruption
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Long <w@laoqinren.net> writes:

> Hi，
>
> we encountered a kernel panic as following:
>
> [4394470.273792] general protection fault: 0000 [#1] SMP NOPTI
> [4394470.274038] CPU: 0 PID: 0 Comm: swapper/0 Kdump: loaded Tainted: G    W
> --------- -  - 4.18.0-80.el8.x86_64 #1
> [4394470.274477] Hardware name: Sugon I620-G30/60P24-US, BIOS MJGS1223
> 04/07/2020
> [4394470.274727] RIP: 0010:run_timer_softirq+0x34e/0x440
> [4394470.274957] Code: 84 3f ff ff ff 49 8b 04 24 48 85 c0 74 58 49 8b 1c 24 48
> 89 5d 08 0f 1f 44 00 00 48 8b 03 48 8b 53 08 48 85 c0 48 89 02 74 04 <48> 89 50
> 08 f6 43 22 20 48 c7 43 08 00 00 00 00 48 89 ef 4c 89 2b
> [4394470.275505] RSP: 0018:ffff88f000803ee0 EFLAGS: 00010086
> [4394470.275783] RAX: dead000000000200 RBX: ffff88e5e33ea078 RCX:
> 0000000000000100
> [4394470.276087] RDX: ffff88f000803ee8 RSI: 0000000000000000 RDI:
> ffff88f00081aa00
> [4394470.276391] RBP: ffff88f00081aa00 R08: 0000000000000001 R09:
> 0000000000000000
> [4394470.276697] R10: ffff88e5e33eb1f0 R11: 0000000000000000 R12:
> ffff88f000803ee8
> [4394470.277030] R13: dead000000000200 R14: ffff88f000803ee0 R15:
> 0000000000000000
> [4394470.277350] FS:  0000000000000000(0000) GS:ffff88f000800000(0000)
> knlGS:0000000000000000
> [4394470.277684] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [4394470.278020] CR2: 00007f200eddd160 CR3: 0000000e0b20a002 CR4:
> 00000000007606f0
> [4394470.278412] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [4394470.278799] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [4394470.279194] PKRU: 55555554
> [4394470.279543] Call Trace:
> [4394470.279889]  <IRQ>
> [4394470.280237]  ? __hrtimer_init+0xb0/0xb0
> [4394470.280618]  ? sched_clock+0x5/0x10
> [4394470.281000]  __do_softirq+0xe8/0x2ef
> [4394470.281397]  irq_exit+0xf1/0x100
> [4394470.281761]  smp_apic_timer_interrupt+0x74/0x130
> [4394470.282132]  apic_timer_interrupt+0xf/0x20
> [4394470.282548]  </IRQ>
> [4394470.282954] RIP: 0010:cpuidle_enter_state+0xa0/0x2b0
> [4394470.283341] Code: 8b 3d 6c fb 59 4c e8 0f ed a6 ff 48 89 c3 0f 1f 44 00 00
> 31 ff e8 80 00 a7 ff 45 84 f6 0f 85 c3 01 00 00 fb 66 0f 1f 44 00 00 <4c> 29 fb
> 48 ba cf f7 53 e3 a5 9b c4 20 48 89 d8 48 c1 fb 3f 48 f7
> [4394470.284219] RSP: 0018:ffffffffb4603e78 EFLAGS: 00000246 ORIG_RAX:
> ffffffffffffff13
> [4394470.284671] RAX: ffff88f000823080 RBX: 000f9cbf579e86c6 RCX:
> 000000000000001f
> [4394470.285129] RDX: 000f9cbf579e86c6 RSI: 0000000037a6f674 RDI:
> 0000000000000000
> [4394470.285623] RBP: 0000000000000002 R08: 00000000000000c4 R09:
> 0000000000000027
> [4394470.286088] R10: ffffffffb4603e58 R11: 000000000000004c R12:
> ffff88f00082df00
> [4394470.286566] R13: ffffffffb4724118 R14: 0000000000000000 R15:
> 000f9cbf579d44e0
> [4394470.287045]  ? cpuidle_enter_state+0x90/0x2b0
> [4394470.287527]  do_idle+0x200/0x280
> [4394470.288010]  cpu_startup_entry+0x6f/0x80
> [4394470.288501]  start_kernel+0x533/0x553
> [4394470.288994]  secondary_startup_64+0xb7/0xc0
>
>
> After analysis, we found that the timer which expires has timer->entry.next ==
> POISON2 !(the list corruption )
>
> the crash scenario is the same as https://lkml.org/lkml/2017/3/21/732,
>
> I cannot reproduce this issue, but I found that the timer cause crash is the
> inet_timewait_sock->tw_timer(its callback function is tw_timer_handler), and the
> value of tcp_tw_reuse is 1.
>
> # cat /proc/sys/net/ipv4/tcp_tw_reuse
> 1
>
> In the production environment, we encountered this problem many times, and every
> time it was a problem with the inet_timewait_sock->tw_timer.
>
> Do anyone have any ideas for this issue? Thanks.

You might enble list debugging if it isn't already.  That might give you
enough information to track this down.

You might also contact redhat support as it appears you are running a
redhat kernel.

Eric

