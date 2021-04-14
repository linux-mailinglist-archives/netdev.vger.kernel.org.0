Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F11035F8C8
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351493AbhDNQMs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Apr 2021 12:12:48 -0400
Received: from mga18.intel.com ([134.134.136.126]:61296 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233932AbhDNQMo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 12:12:44 -0400
IronPort-SDR: ULjpjgWAVva8sQp+KMXUy3W2BWguWzkSPvHq8dp5+V+tMulYAMey0Nr438Qg4d09DCGX/s3IQF
 Jm4EaFVi84cg==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="182178246"
X-IronPort-AV: E=Sophos;i="5.82,222,1613462400"; 
   d="scan'208";a="182178246"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 09:11:03 -0700
IronPort-SDR: DE6B4YjCMUkQy2gZIwMLAjYT0pE96JDNgn3iwVrYeXbtL8GTIAgKFTBCvsh2Xdc//hnObTfNwJ
 GR3Z3MHOxxPg==
X-IronPort-AV: E=Sophos;i="5.82,222,1613462400"; 
   d="scan'208";a="418378619"
Received: from glenande-mobl1.amr.corp.intel.com (HELO localhost) ([10.209.19.126])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 09:11:02 -0700
Date:   Wed, 14 Apr 2021 09:11:00 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "frederic@kernel.org" <frederic@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
        "abelits@marvell.com" <abelits@marvell.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "rppt@linux.vnet.ibm.com" <rppt@linux.vnet.ibm.com>,
        "jinyuqi@huawei.com" <jinyuqi@huawei.com>,
        "zhangshaokun@hisilicon.com" <zhangshaokun@hisilicon.com>,
        netdev@vger.kernel.org, chris.friesen@windriver.com
Subject: Re: [Patch v4 1/3] lib: Restrict cpumask_local_spread to
 houskeeping CPUs
Message-ID: <20210414091100.000033cf@intel.com>
In-Reply-To: <1a044a14-0884-eedb-5d30-28b4bec24b23@redhat.com>
References: <20200625223443.2684-1-nitesh@redhat.com>
        <20200625223443.2684-2-nitesh@redhat.com>
        <3e9ce666-c9cd-391b-52b6-3471fe2be2e6@arm.com>
        <20210127121939.GA54725@fuller.cnet>
        <87r1m5can2.fsf@nanos.tec.linutronix.de>
        <20210128165903.GB38339@fuller.cnet>
        <87h7n0de5a.fsf@nanos.tec.linutronix.de>
        <20210204181546.GA30113@fuller.cnet>
        <cfa138e9-38e3-e566-8903-1d64024c917b@redhat.com>
        <20210204190647.GA32868@fuller.cnet>
        <d8884413-84b4-b204-85c5-810342807d21@redhat.com>
        <87y2g26tnt.fsf@nanos.tec.linutronix.de>
        <d0aed683-87ae-91a2-d093-de3f5d8a8251@redhat.com>
        <7780ae60-efbd-2902-caaa-0249a1f277d9@redhat.com>
        <07c04bc7-27f0-9c07-9f9e-2d1a450714ef@redhat.com>
        <20210406102207.0000485c@intel.com>
        <1a044a14-0884-eedb-5d30-28b4bec24b23@redhat.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nitesh Narayan Lal wrote:

> > The original issue as seen, was that if you rmmod/insmod a driver
> > *without* irqbalance running, the default irq mask is -1, which means
> > any CPU. The older kernels (this issue was patched in 2014) used to use
> > that affinity mask, but the value programmed into all the interrupt
> > registers "actual affinity" would end up delivering all interrupts to
> > CPU0,
> 
> So does that mean the affinity mask for the IRQs was different wrt where
> the IRQs were actually delivered?
> Or, the affinity mask itself for the IRQs after rmmod, insmod was changed
> to 0 instead of -1?

The smp_affinity was 0xfff, and the kernel chooses which interrupt to
place the interrupt on, among any of the bits set.

 
> I did a quick test on top of 5.12.0-rc6 by comparing the i40e IRQ affinity
> mask before removing the kernel module and after doing rmmod+insmod
> and didn't find any difference.

with the patch in question removed? Sorry, I'm confused what you tried.

> 
> >  and if the machine was under traffic load incoming when the
> > driver loaded, CPU0 would start to poll among all the different netdev
> > queues, all on CPU0.
> >
> > The above then leads to the condition that the device is stuck polling
> > even if the affinity gets updated from user space, and the polling will
> > continue until traffic stops.
> >
> >> The problem with the commit is that when we overwrite the affinity mask
> >> based on the hinting mask we completely ignore the default SMP affinity
> >> mask. If we do want to overwrite the affinity based on the hint mask we
> >> should atleast consider the default SMP affinity.
> 
> For the issue where the IRQs don't follow the default_smp_affinity mask
> because of this patch, the following are the steps by which it can be easily
> reproduced with the latest linux kernel:
> 
> # Kernel
> 5.12.0-rc6+

<snip>

> As we can see in the above trace the initial affinity for the IRQ 1478 was
> correctly set as per the default_smp_affinity mask which includes CPU 42,
> however, later on, it is updated with CPU3 which is returned from
> cpumask_local_spread().
> 
> > Maybe the right thing is to fix which CPUs are passed in as the valid
> > mask, or make sure the kernel cross checks that what the driver asks
> > for is a "valid CPU"?
> >
> 
> Sure, if we can still reproduce the problem that your patch was fixing then
> maybe we can consider adding a new API like cpumask_local_spread_irq in
> which we should consider deafult_smp_affinity mask as well before returning
> the CPU.

I'm sure I don't have a reproducer of the original problem any more, it
is lost somewhere 8 years ago. I'd like to be able to repro the original
issue, but I can't.

Your description of the problem makes it obvious there is an issue. It
appears as if cpumask_local_spread() is the wrong function to use here.
If you have any suggestions please let me know.

We had one other report of this problem as well (I'm not sure if it's
the same as your report)
https://lkml.org/lkml/2021/3/28/206
https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20210125/023120.html

