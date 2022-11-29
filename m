Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960A263C65E
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 18:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236605AbiK2RX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 12:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236598AbiK2RX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 12:23:26 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B10468C5A;
        Tue, 29 Nov 2022 09:23:25 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id c2so10299079qko.1;
        Tue, 29 Nov 2022 09:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :feedback-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7jlcVHL9xXutHyudxpWgmNyuiG9QsSh1Xo0dK9zsWjA=;
        b=Nov5hLqCze7EZR8kEb6NBupeNB9jWyAdl6Dw9hSGGMGGm5OPqU/mgPXzGOvCl/88ut
         mD5GIuQXdKYrHvtkj18slwPS+RDLfkmA38senKJMfjzBQr0bZBDvIR46UycvRsPFmamo
         5qthavMLzepH+BTZs+rMYsZbXMnIUtGejX3VhvI8OPqDFXBLqRkBc9vinLUOs8Z9oB0r
         Ivi0rX3sH0dzyG5W57V/AgCsjz0+NSir1qvXuoX96SzyzfJYpD0z2iwNkUXxa6d9rXpN
         te5em0/EpPWv1qS/JuArwp/lwzl+f7iPEN2T0JxnrWc089nCVhW1hH1XKt/dHlH8myN/
         9dvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :feedback-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7jlcVHL9xXutHyudxpWgmNyuiG9QsSh1Xo0dK9zsWjA=;
        b=cD7lJj05Bv18AauPFM88JR2s0j7oQqCzxKxb5yv6iUIzn2ERqct72jpDUbbkxDkB7F
         ksJDsNr1x5Jf0Zc/fIpMQbjrHYkc5MevozqpzRIICMU07kdlDIQgHytAbRA++l27x00f
         idsVnM+Qz22iEktEANNbkFl+tdoop5bl+vPoTAttqxUW4u4Pw3ap1HTR9OsGZIyR6Dk5
         UCtJi2BcGhlPksmmFFx9MQfznfLmuP9Z2+AU9E7vHLSk/bpUlJJKnAksmd9BLdpbo2Tj
         anqgYDWaxMbUBrCmW/Tf5eHLa5eSwqOO/vP/RkM/5Q9zx9jVbhEfkXVGBipDpd4PdVR3
         pvYg==
X-Gm-Message-State: ANoB5pn5usH0W/izC8ZzhJw3sN4Rc4BVnj6mQzHyq8PL8wy3xxzYfVsT
        /qORriHKKBR2wuILeGxE9Xk=
X-Google-Smtp-Source: AA0mqf6IDL2RWE/H33qWuzB+/OwKdtxvd/iJIOwpxmlKGEm/zYT9LD2OYB9TH2WQWzdbh2CSWom+dA==
X-Received: by 2002:a37:f516:0:b0:6fa:32ca:4944 with SMTP id l22-20020a37f516000000b006fa32ca4944mr52045610qkk.738.1669742604409;
        Tue, 29 Nov 2022 09:23:24 -0800 (PST)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id t20-20020a05620a451400b006fba0a389a4sm11185702qkp.88.2022.11.29.09.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 09:23:23 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailauth.nyi.internal (Postfix) with ESMTP id 224C727C0054;
        Tue, 29 Nov 2022 12:23:22 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 29 Nov 2022 12:23:23 -0500
X-ME-Sender: <xms:CUCGYwMLw060-Ttp4R89ym-Rb7m5Dim28FREUaPNzXGuHl8Xw7MpAw>
    <xme:CUCGY29-qs3FQI2rGq78JauGjmnH4BUhOfNZx1VaagzJxGnLt7bMZcmcOZXXMsI-i
    qC9ZN3r3VoSMFRLmQ>
X-ME-Received: <xmr:CUCGY3Tn44bLjgIikEGZbMYi-V29MM-Qcwqg6dwC2rRjr_ElNthy0Wcc3gq843K3fWXh0UjL0UzTUhFmiKaKGN2RypImojL2Hug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrtddtgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeevuedtteetledvhfdtudekfffggeelhfejlefhgffgfedviefhgeeifeel
    vddtgeenucffohhmrghinheplhhkmhhlrdhorhhgpdhqvghmuhdrohhrghenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghs
    mhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdeigedqudejjeekheehhe
    dvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:CUCGY4swz2xa-cH9gLIe5K78XXKkDE0_FXWYZ_SgDhinIyPNyxtRvw>
    <xmx:CUCGY4dRPAAviVrLYE0H6uxRqbCkE4-ZQjYrWiJq9SJeKSmCpA0pTg>
    <xmx:CUCGY82cSAb1_AQ1qjoKvlJXbjIh-b2Dl8KsaTnPoz3fLOBSCVhd-w>
    <xmx:CkCGY284FjIDhtsUINsru4paIS8xYQHVLE3xXe5i61hDwhrUm1LLbpXrdknDuUXY>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 29 Nov 2022 12:23:21 -0500 (EST)
Date:   Tue, 29 Nov 2022 09:23:18 -0800
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
Message-ID: <Y4ZABpDSs4/uRutC@Boquns-Mac-mini.local>
References: <9278cf3f-dfb6-78eb-8862-553545dac7ed@huawei.com>
 <41eda0ea-0ed4-1ffb-5520-06fda08e5d38@huawei.com>
 <CAMDZJNVSv3Msxw=5PRiXyO8bxNsA-4KyxU8BMCVyHxH-3iuq2Q@mail.gmail.com>
 <fdb3b69c-a29c-2d5b-a122-9d98ea387fda@huawei.com>
 <CAMDZJNWTry2eF_n41a13tKFFSSLFyp3BVKakOOWhSDApdp0f=w@mail.gmail.com>
 <CA+khW7jgsyFgBqU7hCzZiSSANE7f=A+M-0XbcKApz6Nr-ZnZDg@mail.gmail.com>
 <07a7491e-f391-a9b2-047e-cab5f23decc5@huawei.com>
 <CAMDZJNUTaiXMe460P7a7NfK1_bbaahpvi3Q9X85o=G7v9x-w=g@mail.gmail.com>
 <59fc54b7-c276-2918-6741-804634337881@huaweicloud.com>
 <541aa740-dcf3-35f5-9f9b-e411978eaa06@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <541aa740-dcf3-35f5-9f9b-e411978eaa06@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 11:06:51AM -0500, Waiman Long wrote:
> On 11/29/22 07:45, Hou Tao wrote:
> > Hi,
> > 
> > On 11/29/2022 2:06 PM, Tonghao Zhang wrote:
> > > On Tue, Nov 29, 2022 at 12:32 PM Hou Tao <houtao1@huawei.com> wrote:
> > > > Hi,
> > > > 
> > > > On 11/29/2022 5:55 AM, Hao Luo wrote:
> > > > > On Sun, Nov 27, 2022 at 7:15 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > > > > Hi Tonghao,
> > > > > 
> > > > > With a quick look at the htab_lock_bucket() and your problem
> > > > > statement, I agree with Hou Tao that using hash &
> > > > > min(HASHTAB_MAP_LOCK_MASK, n_bucket - 1) to index in map_locked seems
> > > > > to fix the potential deadlock. Can you actually send your changes as
> > > > > v2 so we can take a look and better help you? Also, can you explain
> > > > > your solution in your commit message? Right now, your commit message
> > > > > has only a problem statement and is not very clear. Please include
> > > > > more details on what you do to fix the issue.
> > > > > 
> > > > > Hao
> > > > It would be better if the test case below can be rewritten as a bpf selftests.
> > > > Please see comments below on how to improve it and reproduce the deadlock.
> > > > > > Hi
> > > > > > only a warning from lockdep.
> > > > Thanks for your details instruction.  I can reproduce the warning by using your
> > > > setup. I am not a lockdep expert, it seems that fixing such warning needs to set
> > > > different lockdep class to the different bucket. Because we use map_locked to
> > > > protect the acquisition of bucket lock, so I think we can define  lock_class_key
> > > > array in bpf_htab (e.g., lockdep_key[HASHTAB_MAP_LOCK_COUNT]) and initialize the
> > > > bucket lock accordingly.
> > The proposed lockdep solution doesn't work. Still got lockdep warning after
> > that, so cc +locking expert +lkml.org for lockdep help.
> > 
> > Hi lockdep experts,
> > 
> > We are trying to fix the following lockdep warning from bpf subsystem:
> > 
> > [   36.092222] ================================
> > [   36.092230] WARNING: inconsistent lock state
> > [   36.092234] 6.1.0-rc5+ #81 Tainted: G            E
> > [   36.092236] --------------------------------
> > [   36.092237] inconsistent {INITIAL USE} -> {IN-NMI} usage.
> > [   36.092238] perf/1515 [HC1[1]:SC0[0]:HE0:SE1] takes:
> > [   36.092242] ffff888341acd1a0 (&htab->lockdep_key){....}-{2:2}, at:
> > htab_lock_bucket+0x4d/0x58
> > [   36.092253] {INITIAL USE} state was registered at:
> > [   36.092255]   mark_usage+0x1d/0x11d
> > [   36.092262]   __lock_acquire+0x3c9/0x6ed
> > [   36.092266]   lock_acquire+0x23d/0x29a
> > [   36.092270]   _raw_spin_lock_irqsave+0x43/0x7f
> > [   36.092274]   htab_lock_bucket+0x4d/0x58
> > [   36.092276]   htab_map_delete_elem+0x82/0xfb
> > [   36.092278]   map_delete_elem+0x156/0x1ac
> > [   36.092282]   __sys_bpf+0x138/0xb71
> > [   36.092285]   __do_sys_bpf+0xd/0x15
> > [   36.092288]   do_syscall_64+0x6d/0x84
> > [   36.092291]   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > [   36.092295] irq event stamp: 120346
> > [   36.092296] hardirqs last  enabled at (120345): [<ffffffff8180b97f>]
> > _raw_spin_unlock_irq+0x24/0x39
> > [   36.092299] hardirqs last disabled at (120346): [<ffffffff81169e85>]
> > generic_exec_single+0x40/0xb9
> > [   36.092303] softirqs last  enabled at (120268): [<ffffffff81c00347>]
> > __do_softirq+0x347/0x387
> > [   36.092307] softirqs last disabled at (120133): [<ffffffff810ba4f0>]
> > __irq_exit_rcu+0x67/0xc6
> > [   36.092311]
> > [   36.092311] other info that might help us debug this:
> > [   36.092312]  Possible unsafe locking scenario:
> > [   36.092312]
> > [   36.092313]        CPU0
> > [   36.092313]        ----
> > [   36.092314]   lock(&htab->lockdep_key);
> > [   36.092315]   <Interrupt>
> > [   36.092316]     lock(&htab->lockdep_key);
> > [   36.092318]
> > [   36.092318]  *** DEADLOCK ***
> > [   36.092318]
> > [   36.092318] 3 locks held by perf/1515:
> > [   36.092320]  #0: ffff8881b9805cc0 (&cpuctx_mutex){+.+.}-{4:4}, at:
> > perf_event_ctx_lock_nested+0x8e/0xba
> > [   36.092327]  #1: ffff8881075ecc20 (&event->child_mutex){+.+.}-{4:4}, at:
> > perf_event_for_each_child+0x35/0x76
> > [   36.092332]  #2: ffff8881b9805c20 (&cpuctx_lock){-.-.}-{2:2}, at:
> > perf_ctx_lock+0x12/0x27
> > [   36.092339]
> > [   36.092339] stack backtrace:
> > [   36.092341] CPU: 0 PID: 1515 Comm: perf Tainted: G            E
> > 6.1.0-rc5+ #81
> > [   36.092344] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> > rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> > [   36.092349] Call Trace:
> > [   36.092351]  <NMI>
> > [   36.092354]  dump_stack_lvl+0x57/0x81
> > [   36.092359]  lock_acquire+0x1f4/0x29a
> > [   36.092363]  ? handle_pmi_common+0x13f/0x1f0
> > [   36.092366]  ? htab_lock_bucket+0x4d/0x58
> > [   36.092371]  _raw_spin_lock_irqsave+0x43/0x7f
> > [   36.092374]  ? htab_lock_bucket+0x4d/0x58
> > [   36.092377]  htab_lock_bucket+0x4d/0x58
> > [   36.092379]  htab_map_update_elem+0x11e/0x220
> > [   36.092386]  bpf_prog_f3a535ca81a8128a_bpf_prog2+0x3e/0x42
> > [   36.092392]  trace_call_bpf+0x177/0x215
> > [   36.092398]  perf_trace_run_bpf_submit+0x52/0xaa
> > [   36.092403]  ? x86_pmu_stop+0x97/0x97
> > [   36.092407]  perf_trace_nmi_handler+0xb7/0xe0
> > [   36.092415]  nmi_handle+0x116/0x254
> > [   36.092418]  ? x86_pmu_stop+0x97/0x97
> > [   36.092423]  default_do_nmi+0x3d/0xf6
> > [   36.092428]  exc_nmi+0xa1/0x109
> > [   36.092432]  end_repeat_nmi+0x16/0x67
> > [   36.092436] RIP: 0010:wrmsrl+0xd/0x1b
> 
> So the lock is really taken in a NMI context. In general, we advise again
> using lock in a NMI context unless it is a lock that is used only in that
> context. Otherwise, deadlock is certainly a possibility as there is no way
> to mask off again NMI.
> 

I think here they use a percpu counter as an "outer lock" to make the
accesses to the real lock exclusive:

	preempt_disable();
	a = __this_cpu_inc(->map_locked);
	if (a != 1) {
		__this_cpu_dec(->map_locked);
		preempt_enable();
		return -EBUSY;
	}
	preempt_enable();
		return -EBUSY;
	
	raw_spin_lock_irqsave(->raw_lock);

and lockdep is not aware that ->map_locked acts as a lock.

However, I feel this may be just a reinvented try_lock pattern, Hou Tao,
could you see if this can be refactored with a try_lock? Otherwise, you
may need to introduce a virtual lockclass for ->map_locked.

Regards,
Boqun

> Cheers,
> Longman
> 
