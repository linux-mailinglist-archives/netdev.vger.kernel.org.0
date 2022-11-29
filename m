Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC89363C678
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 18:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236628AbiK2Rcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 12:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235494AbiK2Rce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 12:32:34 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D1D69328;
        Tue, 29 Nov 2022 09:32:31 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id i9so10322110qkl.5;
        Tue, 29 Nov 2022 09:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :feedback-id:from:to:cc:subject:date:message-id:reply-to;
        bh=i5+X2S0sQTT/dz8zVpuwfVxr/4pRPCeBbFwlDo4hLyw=;
        b=PtWu6S4Jbm6gGgywBiM/IulfkXcTmra1mAPOI+9Zxsh6W0XAptrnIPv/VKr1pVXyBh
         a1WIyyc85eAfl2tcv/nzLrYWjp/B1rJN8jiKR7PQi2xjOzdL/6CK7Z28nFOo7BatyIez
         OP3CTYPTgFbCxPH1I2GUzQKkodRYZs0yqLCVj1BxPuMVhR8XR1ct7BoTzajzclM54ehX
         g5KyfzvWleDIJJYO7ibMYCJQJN9bJPrh2oVqgxCtSk6ciDestVR66NAAV7n4dngvsuRR
         jlFr5pm/HFm9mFoqTYGc8KnIgkKIh6Ok6csrlF+bvaZhwDGRtCxSihEy8tl2e8HkHt6b
         M1lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :feedback-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i5+X2S0sQTT/dz8zVpuwfVxr/4pRPCeBbFwlDo4hLyw=;
        b=t2o4FdEHaQCbhd3AafkRTc6JrNIFo8yvgTL8tVnv4dSeozN9933rG5lCwsv2fzgwLh
         9RAPU+Qz2JcLHEThF8LOMpLvsQKlPo5wm0nFl8oOrTmboDB7/3we26BOiF+R6L2VBDqS
         /AtoiGDunlXy3dGXKyScTwntJ2M4BgKw+d4PajbjdYWyjEMQAusjlixwblSfcbNCLOuH
         AI5Um1DnO/YQt+JJwcgTry/bzM1VxtP/RoMil7ehnifsH5AdhcNH0kSPXkyg+DpDe5xZ
         WWMOyzUHnaVWbSzTbfzMM87EImH7rM3kbZRw6Eb11DLRfUYf39Rbot0Mz7fC3JEej3+Q
         AN9g==
X-Gm-Message-State: ANoB5pnBPjb1Fk7BAJ2Gz5Pdjjc04QdQGNVe5EQvtK5zfPWMrUC9+Jmp
        oHw0gr0qQgFldgOaif15krE=
X-Google-Smtp-Source: AA0mqf7A7oH0Mwk9Yv27Pn8p6wWgLsWWPkbqNkV2jY5MJu17ZZj26Ak92OsKELuUeRvRLC/9/EkWDA==
X-Received: by 2002:a05:620a:15b7:b0:6fa:3f37:5af with SMTP id f23-20020a05620a15b700b006fa3f3705afmr52317324qkk.572.1669743150198;
        Tue, 29 Nov 2022 09:32:30 -0800 (PST)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id bq38-20020a05620a46a600b006fc40dafaa2sm10958685qkb.8.2022.11.29.09.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 09:32:29 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailauth.nyi.internal (Postfix) with ESMTP id E761C27C005A;
        Tue, 29 Nov 2022 12:32:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 29 Nov 2022 12:32:28 -0500
X-ME-Sender: <xms:LEKGY7fyt9YrvkUY8FDlMux5Ybw1CwaZw-GMP4JLxhJbCdOw3spSRg>
    <xme:LEKGYxPeDGsJCuPixJmhZqVxOp0mqm5k_adXVTO0982ty4sRXJrvnlMpaVxjUzTNk
    mu1wIt7bnuOMBbvcg>
X-ME-Received: <xmr:LEKGY0j4405yH4mmNAwtlEth6cb-UyorHcJYOlkPgR-DnUMmHVqplkZbwLCYBy3W0km3Nhjjvh8NE6YGok7cnKwalmwAyiNNI24>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrtddtgdejvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeevuedtteetledvhfdtudekfffggeelhfejlefhgffgfedviefhgeeifeel
    vddtgeenucffohhmrghinheplhhkmhhlrdhorhhgpdhqvghmuhdrohhrghenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghs
    mhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdeigedqudejjeekheehhe
    dvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:LEKGY8_SZP9PKlx7G2EocSAN6UdF8fqRZkJXs41DWCiWSYwzjMZprg>
    <xmx:LEKGY3uAa2jx-06iVNbI4fgi3v-obxyI_WqF01-A8wI_KH2bn5oJKg>
    <xmx:LEKGY7HSfqd8IhmISfXUnJi7DKK6UViAI9pTAbl5LDlaR8_F7dkHxQ>
    <xmx:LEKGYwP-BNwXgb3kbYRNuZj66xDnz1sVFKIu4xqe5Dac7UZV2WAsZUh7B6z84phc>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 29 Nov 2022 12:32:27 -0500 (EST)
Date:   Tue, 29 Nov 2022 09:32:25 -0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     Waiman Long <longman@redhat.com>
Cc:     Hou Tao <houtao@huaweicloud.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Jiri Olsa <jolsa@kernel.org>, bpf <bpf@vger.kernel.org>,
        Hao Luo <haoluo@google.com>,
        "houtao1@huawei.com" <houtao1@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [net-next] bpf: avoid hashtab deadlock with try_lock
Message-ID: <Y4ZCKaQFqDY3aLTy@Boquns-Mac-mini.local>
References: <41eda0ea-0ed4-1ffb-5520-06fda08e5d38@huawei.com>
 <CAMDZJNVSv3Msxw=5PRiXyO8bxNsA-4KyxU8BMCVyHxH-3iuq2Q@mail.gmail.com>
 <fdb3b69c-a29c-2d5b-a122-9d98ea387fda@huawei.com>
 <CAMDZJNWTry2eF_n41a13tKFFSSLFyp3BVKakOOWhSDApdp0f=w@mail.gmail.com>
 <CA+khW7jgsyFgBqU7hCzZiSSANE7f=A+M-0XbcKApz6Nr-ZnZDg@mail.gmail.com>
 <07a7491e-f391-a9b2-047e-cab5f23decc5@huawei.com>
 <CAMDZJNUTaiXMe460P7a7NfK1_bbaahpvi3Q9X85o=G7v9x-w=g@mail.gmail.com>
 <59fc54b7-c276-2918-6741-804634337881@huaweicloud.com>
 <541aa740-dcf3-35f5-9f9b-e411978eaa06@redhat.com>
 <Y4ZABpDSs4/uRutC@Boquns-Mac-mini.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y4ZABpDSs4/uRutC@Boquns-Mac-mini.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 09:23:18AM -0800, Boqun Feng wrote:
> On Tue, Nov 29, 2022 at 11:06:51AM -0500, Waiman Long wrote:
> > On 11/29/22 07:45, Hou Tao wrote:
> > > Hi,
> > > 
> > > On 11/29/2022 2:06 PM, Tonghao Zhang wrote:
> > > > On Tue, Nov 29, 2022 at 12:32 PM Hou Tao <houtao1@huawei.com> wrote:
> > > > > Hi,
> > > > > 
> > > > > On 11/29/2022 5:55 AM, Hao Luo wrote:
> > > > > > On Sun, Nov 27, 2022 at 7:15 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > > > > Hi Tonghao,
> > > > > > 
> > > > > > With a quick look at the htab_lock_bucket() and your problem
> > > > > > statement, I agree with Hou Tao that using hash &
> > > > > > min(HASHTAB_MAP_LOCK_MASK, n_bucket - 1) to index in map_locked seems
> > > > > > to fix the potential deadlock. Can you actually send your changes as
> > > > > > v2 so we can take a look and better help you? Also, can you explain
> > > > > > your solution in your commit message? Right now, your commit message
> > > > > > has only a problem statement and is not very clear. Please include
> > > > > > more details on what you do to fix the issue.
> > > > > > 
> > > > > > Hao
> > > > > It would be better if the test case below can be rewritten as a bpf selftests.
> > > > > Please see comments below on how to improve it and reproduce the deadlock.
> > > > > > > Hi
> > > > > > > only a warning from lockdep.
> > > > > Thanks for your details instruction.  I can reproduce the warning by using your
> > > > > setup. I am not a lockdep expert, it seems that fixing such warning needs to set
> > > > > different lockdep class to the different bucket. Because we use map_locked to
> > > > > protect the acquisition of bucket lock, so I think we can define  lock_class_key
> > > > > array in bpf_htab (e.g., lockdep_key[HASHTAB_MAP_LOCK_COUNT]) and initialize the
> > > > > bucket lock accordingly.
> > > The proposed lockdep solution doesn't work. Still got lockdep warning after
> > > that, so cc +locking expert +lkml.org for lockdep help.
> > > 
> > > Hi lockdep experts,
> > > 
> > > We are trying to fix the following lockdep warning from bpf subsystem:
> > > 
> > > [   36.092222] ================================
> > > [   36.092230] WARNING: inconsistent lock state
> > > [   36.092234] 6.1.0-rc5+ #81 Tainted: G            E
> > > [   36.092236] --------------------------------
> > > [   36.092237] inconsistent {INITIAL USE} -> {IN-NMI} usage.
> > > [   36.092238] perf/1515 [HC1[1]:SC0[0]:HE0:SE1] takes:
> > > [   36.092242] ffff888341acd1a0 (&htab->lockdep_key){....}-{2:2}, at:
> > > htab_lock_bucket+0x4d/0x58
> > > [   36.092253] {INITIAL USE} state was registered at:
> > > [   36.092255]   mark_usage+0x1d/0x11d
> > > [   36.092262]   __lock_acquire+0x3c9/0x6ed
> > > [   36.092266]   lock_acquire+0x23d/0x29a
> > > [   36.092270]   _raw_spin_lock_irqsave+0x43/0x7f
> > > [   36.092274]   htab_lock_bucket+0x4d/0x58
> > > [   36.092276]   htab_map_delete_elem+0x82/0xfb
> > > [   36.092278]   map_delete_elem+0x156/0x1ac
> > > [   36.092282]   __sys_bpf+0x138/0xb71
> > > [   36.092285]   __do_sys_bpf+0xd/0x15
> > > [   36.092288]   do_syscall_64+0x6d/0x84
> > > [   36.092291]   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > [   36.092295] irq event stamp: 120346
> > > [   36.092296] hardirqs last  enabled at (120345): [<ffffffff8180b97f>]
> > > _raw_spin_unlock_irq+0x24/0x39
> > > [   36.092299] hardirqs last disabled at (120346): [<ffffffff81169e85>]
> > > generic_exec_single+0x40/0xb9
> > > [   36.092303] softirqs last  enabled at (120268): [<ffffffff81c00347>]
> > > __do_softirq+0x347/0x387
> > > [   36.092307] softirqs last disabled at (120133): [<ffffffff810ba4f0>]
> > > __irq_exit_rcu+0x67/0xc6
> > > [   36.092311]
> > > [   36.092311] other info that might help us debug this:
> > > [   36.092312]  Possible unsafe locking scenario:
> > > [   36.092312]
> > > [   36.092313]        CPU0
> > > [   36.092313]        ----
> > > [   36.092314]   lock(&htab->lockdep_key);
> > > [   36.092315]   <Interrupt>
> > > [   36.092316]     lock(&htab->lockdep_key);
> > > [   36.092318]
> > > [   36.092318]  *** DEADLOCK ***
> > > [   36.092318]
> > > [   36.092318] 3 locks held by perf/1515:
> > > [   36.092320]  #0: ffff8881b9805cc0 (&cpuctx_mutex){+.+.}-{4:4}, at:
> > > perf_event_ctx_lock_nested+0x8e/0xba
> > > [   36.092327]  #1: ffff8881075ecc20 (&event->child_mutex){+.+.}-{4:4}, at:
> > > perf_event_for_each_child+0x35/0x76
> > > [   36.092332]  #2: ffff8881b9805c20 (&cpuctx_lock){-.-.}-{2:2}, at:
> > > perf_ctx_lock+0x12/0x27
> > > [   36.092339]
> > > [   36.092339] stack backtrace:
> > > [   36.092341] CPU: 0 PID: 1515 Comm: perf Tainted: G            E
> > > 6.1.0-rc5+ #81
> > > [   36.092344] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> > > rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> > > [   36.092349] Call Trace:
> > > [   36.092351]  <NMI>
> > > [   36.092354]  dump_stack_lvl+0x57/0x81
> > > [   36.092359]  lock_acquire+0x1f4/0x29a
> > > [   36.092363]  ? handle_pmi_common+0x13f/0x1f0
> > > [   36.092366]  ? htab_lock_bucket+0x4d/0x58
> > > [   36.092371]  _raw_spin_lock_irqsave+0x43/0x7f
> > > [   36.092374]  ? htab_lock_bucket+0x4d/0x58
> > > [   36.092377]  htab_lock_bucket+0x4d/0x58
> > > [   36.092379]  htab_map_update_elem+0x11e/0x220
> > > [   36.092386]  bpf_prog_f3a535ca81a8128a_bpf_prog2+0x3e/0x42
> > > [   36.092392]  trace_call_bpf+0x177/0x215
> > > [   36.092398]  perf_trace_run_bpf_submit+0x52/0xaa
> > > [   36.092403]  ? x86_pmu_stop+0x97/0x97
> > > [   36.092407]  perf_trace_nmi_handler+0xb7/0xe0
> > > [   36.092415]  nmi_handle+0x116/0x254
> > > [   36.092418]  ? x86_pmu_stop+0x97/0x97
> > > [   36.092423]  default_do_nmi+0x3d/0xf6
> > > [   36.092428]  exc_nmi+0xa1/0x109
> > > [   36.092432]  end_repeat_nmi+0x16/0x67
> > > [   36.092436] RIP: 0010:wrmsrl+0xd/0x1b
> > 
> > So the lock is really taken in a NMI context. In general, we advise again
> > using lock in a NMI context unless it is a lock that is used only in that
> > context. Otherwise, deadlock is certainly a possibility as there is no way
> > to mask off again NMI.
> > 
> 
> I think here they use a percpu counter as an "outer lock" to make the
> accesses to the real lock exclusive:
> 
> 	preempt_disable();
> 	a = __this_cpu_inc(->map_locked);
> 	if (a != 1) {
> 		__this_cpu_dec(->map_locked);
> 		preempt_enable();
> 		return -EBUSY;
> 	}
> 	preempt_enable();
> 		return -EBUSY;
> 	
> 	raw_spin_lock_irqsave(->raw_lock);
> 
> and lockdep is not aware that ->map_locked acts as a lock.
> 
> However, I feel this may be just a reinvented try_lock pattern, Hou Tao,
> could you see if this can be refactored with a try_lock? Otherwise, you

Just to be clear, I meant to refactor htab_lock_bucket() into a try
lock pattern. Also after a second thought, the below suggestion doesn't
work. I think the proper way is to make htab_lock_bucket() as a
raw_spin_trylock_irqsave().

Regards,
Boqun

> may need to introduce a virtual lockclass for ->map_locked.
> 
> Regards,
> Boqun
> 
> > Cheers,
> > Longman
> > 
