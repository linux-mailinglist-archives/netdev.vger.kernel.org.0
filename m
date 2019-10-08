Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65476CF0F0
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 04:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbfJHCvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 22:51:08 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45641 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729536AbfJHCvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 22:51:08 -0400
Received: by mail-qt1-f194.google.com with SMTP id c21so22712574qtj.12;
        Mon, 07 Oct 2019 19:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7WlCL5e5wR4Y3WzXCMqV9001lRnZ7W6i7ZjEKnWaJYo=;
        b=sMtoWRExl6BkRBvZCY0ySQ8awA03Y8o8rbaqxXprm693s6dDfs1zUiUuE5UWK0uk+a
         7KA1YOQfAkoNlH5wHLl5Z5NIBOZ/vSvZ3QlmLFkt+zLjGRYwssqhNL/RE+wod7X47qsk
         fi8gBjM9Vavh0dbyWj52F9dwhA/CYI8RgJXi+5E+PqX8t4uQQBTPHG+iCaQ5bdhG0hi9
         h0I/8Dlt+WhqMtxYoc7Xqtpv8LTIUu17siNwdbPTe9wDU/krPMuPsxstQTZHCQtxBQzG
         D0e9Lv4BKofz3B1S5HBpMXCO1yqTi71JA6bt+GxEjazSygBHJlch7X3BecskMbMyHguR
         FXpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7WlCL5e5wR4Y3WzXCMqV9001lRnZ7W6i7ZjEKnWaJYo=;
        b=UydYWacPzsKiA4Zm8PMnZ/FReHh1xamiJeuo/9PDblT9kc/pRg9KdQqHMuxI5SGkso
         32q4uiuxq5p20XtA4dqTPdWS0yoU88PHyfi6RQIZZKIoZ/XBfBoW8BDLpTIVZcSLlBiC
         hkmwZuZgaFJFbSgppL4up9E1qMkRluuOmKIB8itbUSYeZyCHj6JtT5VyZPdkgr4H5iVH
         c7mOTMy3p9KitXitCvp0MGBhNg9njuvAYsjCmg4POEgCfsV25kMKEEXKltnuP9wPx6Cu
         1PJiC2jqHTK4C6FHQtmiE06PBuO3NQDgY3zLFaaebzEzCkk6Mje4ewdKMg7okfjQylzy
         oKEA==
X-Gm-Message-State: APjAAAVfj7ci6qM13fItpXXu5XXjPNtBpPhoesENTB66nrxT7lnh4h0S
        DoO7EdALYBzvEkHsHUfHcY4=
X-Google-Smtp-Source: APXvYqza8nRdbe7qVVvD+EZMFiLehU7z/V9Jliv2X/WPic56AxgzorjqxIoghKu8XwFhmdARRx2vZA==
X-Received: by 2002:ac8:2966:: with SMTP id z35mr34499115qtz.348.1570503066641;
        Mon, 07 Oct 2019 19:51:06 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id z141sm8370748qka.126.2019.10.07.19.51.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 19:51:05 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 8B7952129D;
        Mon,  7 Oct 2019 22:51:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 07 Oct 2019 22:51:03 -0400
X-ME-Sender: <xms:lfmbXRktBV8elzfAy9nydNtmUJIS4FxVGTfIy6V-XpG_ijxrQYj4Hw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheekgdeiudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpeeuohhquhhn
    ucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecukfhppedutd
    durdekiedrgeefrddvtdeinecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhm
    vghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdeigedqudejjeekhe
    ehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghm
    vgenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:lfmbXRGf6f1g8THvwQxhK0iJuE5dPK2DS1z4yXsnJKNm2HDe-WY4hg>
    <xmx:lfmbXSrtuCTvZScbP4NFfRy2nytCtwBH25wIR4Xngxvn_4D1S-CyBQ>
    <xmx:lfmbXV7Ah-XUzv8eR8PWkYmk5RW3peYeUWqMz50bERea8TKK_cg-fw>
    <xmx:l_mbXauXMzFiHcD7WBZ0x8WnngetDxcroyF_g3ZwflWlGvpX-fVcsiQWdhE>
Received: from localhost (unknown [101.86.43.206])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6D5988005C;
        Mon,  7 Oct 2019 22:51:00 -0400 (EDT)
Date:   Tue, 8 Oct 2019 10:50:56 +0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Marco Elver <elver@google.com>,
        syzbot <syzbot+134336b86f728d6e55a0@syzkaller.appspotmail.com>,
        josh@joshtriplett.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
        rcu@vger.kernel.org, a@unstable.cc,
        b.a.t.m.a.n@lists.open-mesh.org, davem@davemloft.net,
        LKML <linux-kernel@vger.kernel.org>, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Subject: Re: KCSAN: data-race in find_next_bit / rcu_report_exp_cpu_mult
Message-ID: <20191008025056.GA2701514@tardis>
References: <000000000000604e8905944f211f@google.com>
 <CANpmjNNmSOagbTpffHr4=Yedckx9Rm2NuGqC9UqE+AOz5f1-ZQ@mail.gmail.com>
 <20191007134304.GA2609633@tardis>
 <20191008001131.GB255532@google.com>
 <20191008021233.GD2689@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008021233.GD2689@paulmck-ThinkPad-P72>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 07:12:33PM -0700, Paul E. McKenney wrote:
> On Mon, Oct 07, 2019 at 08:11:31PM -0400, Joel Fernandes wrote:
> > On Mon, Oct 07, 2019 at 09:43:04PM +0800, Boqun Feng wrote:
> > > Hi Marco,
> > 
> > Hi Boqun, Steve and Paul, fun times!
> > 
> > Marco, good catch ;-)
> 
> Indeed!  ;-)
> 
[...]
> > > +	mask_ofl_ipi_snap = mask_ofl_ipi;
> > >  	/* IPI the remaining CPUs for expedited quiescent state. */
> > > -	for_each_leaf_node_cpu_mask(rnp, cpu, rnp->expmask) {
> > > +	for_each_leaf_node_cpu_mask(rnp, cpu, mask_ofl_ipi_snap) {
> 
> Why can't we just use mask_ofl_ipi?  The bits removed are only those
> bits just now looked at, right?  Also, the test of mask_ofl_ipi can be
> dropped, since that branch will never be taken, correct?
> 

You're correct. But I think we can further simplify the code a little
bit so that we won't need to modify the mask_ofl_ipi:

In the second loop:

1) if the target CPU is online and response the IPI we do nothing.

2) if the target CPU is offline but it doesn't block current GP, we do
nothing.

3) otherwise, the target CPU is offline and blocks current GP, we add
the corresponding bit in mask_ofl_test.

Thoughts?

Please see the end of email for a patch.

> > This looks good to me. Just a nit, I prefer if the comment to IPI the
> > remaining CPUs is before the assignment to mask_ofl_ipi_snap since the
> > new assignment is done for consumption by the for_each..(..) loop itself.
> > 
> > Steve's patch looks good as well and I was thinking along the same lines but
> > Boqun's patch is slightly better because he doesn't need to snapshot exp_mask
> > inside the locked section.
> 
> There are also similar lockless accesses to ->expmask in the stall-warning
> code.
> 
> > Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> But thank all three of you for looking this over!  My original patch
> was overly ornate.  ;-)
> 
> 							Thanx, Paul
> 

-------------------->8
Subject: [PATCH v2] rcu: exp: Avoid race on lockless rcu_node::expmask loop

KCSAN reported an issue:

| BUG: KCSAN: data-race in find_next_bit / rcu_report_exp_cpu_mult
|
| write to 0xffffffff85a7f140 of 8 bytes by task 7 on cpu 0:
|   rcu_report_exp_cpu_mult+0x4f/0xa0 kernel/rcu/tree_exp.h:244
|   rcu_report_exp_rdp+0x6c/0x90 kernel/rcu/tree_exp.h:254
|   rcu_preempt_deferred_qs_irqrestore+0x3bb/0x580 kernel/rcu/tree_plugin.h:475
|   rcu_read_unlock_special+0xec/0x370 kernel/rcu/tree_plugin.h:659
|   __rcu_read_unlock+0xcf/0xe0 kernel/rcu/tree_plugin.h:394
|   rcu_read_unlock include/linux/rcupdate.h:645 [inline]
|   batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:411 [inline]
|   batadv_nc_worker+0x13a/0x390 net/batman-adv/network-coding.c:718
|   process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
|   worker_thread+0xa0/0x800 kernel/workqueue.c:2415
|   kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
|   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352
|
| read to 0xffffffff85a7f140 of 8 bytes by task 7251 on cpu 1:
|   _find_next_bit lib/find_bit.c:39 [inline]
|   find_next_bit+0x57/0xe0 lib/find_bit.c:70
|   sync_rcu_exp_select_node_cpus+0x28e/0x510 kernel/rcu/tree_exp.h:375
|   sync_rcu_exp_select_cpus+0x30c/0x590 kernel/rcu/tree_exp.h:439
|   rcu_exp_sel_wait_wake kernel/rcu/tree_exp.h:575 [inline]
|   wait_rcu_exp_gp+0x25/0x40 kernel/rcu/tree_exp.h:589
|   process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
|   worker_thread+0xa0/0x800 kernel/workqueue.c:2415
|   kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
|   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

The root cause of this is the second for_each_leaf_node_cpu_mask() loop
in sync_rcu_exp_select_node_cpus() accesses the rcu_node::expmask
without holding rcu_node's lock. This is by design, because the second
loop may issue IPIs to other CPUs, and the IPI handler (rcu_exp_handler)
may acquire the same rcu_node's lock. So the rcu_node's lock has to be
dropped before the second loop.

The problem will occur when the normal unsetting of rcu_node::expmask
results into some intermediate state (because it's a plain access),
where an extra bit gets zeroed. The second loop will skip the
corrensponding CPU, but treat it as offline and in quesient state. This
will cause trouble because that CPU may be in a RCU read-side critical
section.

To fix this, make the second loop iterate on mask_ofl_ipi, as a result,
the find_next_bit() of the second loop doesn't access any variables that
may get changed in parallel, so the race is avoided. While we are at it,
remove the unset of mask_ofl_ipi to improve the readiblity, because we
can always use mask_ofl_test to record which CPU's QS should be
reported.

Reported-by: syzbot+134336b86f728d6e55a0@syzkaller.appspotmail.com
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 kernel/rcu/tree_exp.h | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/kernel/rcu/tree_exp.h b/kernel/rcu/tree_exp.h
index af7e7b9c86af..fb51752ac9a6 100644
--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -372,12 +372,10 @@ static void sync_rcu_exp_select_node_cpus(struct work_struct *wp)
 	raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
 
 	/* IPI the remaining CPUs for expedited quiescent state. */
-	for_each_leaf_node_cpu_mask(rnp, cpu, rnp->expmask) {
+	for_each_leaf_node_cpu_mask(rnp, cpu, mask_ofl_ipi) {
 		unsigned long mask = leaf_node_cpu_bit(rnp, cpu);
 		struct rcu_data *rdp = per_cpu_ptr(&rcu_data, cpu);
 
-		if (!(mask_ofl_ipi & mask))
-			continue;
 retry_ipi:
 		if (rcu_dynticks_in_eqs_since(rdp, rdp->exp_dynticks_snap)) {
 			mask_ofl_test |= mask;
@@ -389,10 +387,10 @@ static void sync_rcu_exp_select_node_cpus(struct work_struct *wp)
 		}
 		ret = smp_call_function_single(cpu, rcu_exp_handler, NULL, 0);
 		put_cpu();
-		if (!ret) {
-			mask_ofl_ipi &= ~mask;
+		/* the CPU responses the IPI, and it will report QS itself */
+		if (!ret)
 			continue;
-		}
+
 		/* Failed, raced with CPU hotplug operation. */
 		raw_spin_lock_irqsave_rcu_node(rnp, flags);
 		if ((rnp->qsmaskinitnext & mask) &&
@@ -403,13 +401,12 @@ static void sync_rcu_exp_select_node_cpus(struct work_struct *wp)
 			schedule_timeout_uninterruptible(1);
 			goto retry_ipi;
 		}
-		/* CPU really is offline, so we can ignore it. */
-		if (!(rnp->expmask & mask))
-			mask_ofl_ipi &= ~mask;
+		/* CPU really is offline, and we need its QS. */
+		if (rnp->expmask & mask)
+			mask_ofl_test |= mask;
 		raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
 	}
 	/* Report quiescent states for those that went offline. */
-	mask_ofl_test |= mask_ofl_ipi;
 	if (mask_ofl_test)
 		rcu_report_exp_cpu_mult(rnp, mask_ofl_test, false);
 }
-- 
2.23.0

