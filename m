Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF4B3704FF
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 04:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhEACWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 22:22:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:39491 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230508AbhEACWf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 22:22:35 -0400
IronPort-SDR: HH/KKVWXGV33XBRlA566Hpa1GRlCMMS+qGFtKRZDJU4GtjO2BkP8bz9Juey/u0nzKJM4Kv1QM6
 Qp+xizNgHaaA==
X-IronPort-AV: E=McAfee;i="6200,9189,9970"; a="184541737"
X-IronPort-AV: E=Sophos;i="5.82,264,1613462400"; 
   d="scan'208";a="184541737"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2021 19:21:46 -0700
IronPort-SDR: up+4B6cGqINpHOFiCvGSgCTCBH4t2C4586MGhDuo2WWqiBBS84WvP1j909tWdrSVmYAFKIORCF
 /P8gAY3KbxZw==
X-IronPort-AV: E=Sophos;i="5.82,264,1613462400"; 
   d="scan'208";a="387594007"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.64.230])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2021 19:21:45 -0700
Date:   Fri, 30 Apr 2021 19:21:45 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Nitesh Lal <nilal@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, abelits@marvell.com,
        Robin Murphy <robin.murphy@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
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
Message-ID: <20210430192145.00000e23@intel.com>
In-Reply-To: <CAFki+L=_dd+JgAR12_eBPX0kZO2_6=1dGdgkwHE=u=K6chMeLQ@mail.gmail.com>
References: <20200625223443.2684-1-nitesh@redhat.com>
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
        <20210414091100.000033cf@intel.com>
        <54ecc470-b205-ea86-1fc3-849c5b144b3b@redhat.com>
        <CAFki+Lm0W_brLu31epqD3gAV+WNKOJfVDfX2M8ZM__aj3nv9uA@mail.gmail.com>
        <87czucfdtf.ffs@nanos.tec.linutronix.de>
        <CAFki+LmmRyvOkWoNNLk5JCwtaTnabyaRUKxnS+wyAk_kj8wzyw@mail.gmail.com>
        <87sg37eiqa.ffs@nanos.tec.linutronix.de>
        <CAFki+L=_dd+JgAR12_eBPX0kZO2_6=1dGdgkwHE=u=K6chMeLQ@mail.gmail.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nitesh Lal wrote:

> On Fri, Apr 30, 2021 at 2:21 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Nitesh,
> >
> > On Fri, Apr 30 2021 at 12:14, Nitesh Lal wrote:
> > > Based on this analysis and the fact that with your re-work the interrupts
> > > seems to be naturally spread across the CPUs, will it be safe to revert
> > > Jesse's patch
> > >
> > > e2e64a932 genirq: Set initial affinity in irq_set_affinity_hint()
> > >
> > > as it overwrites the previously set IRQ affinity mask for some of the
> > > devices?
> >
> > That's a good question. My gut feeling says yes.
> >
> 
> Jesse do you want to send the revert for the patch?
> 
> Also, I think it was you who suggested cc'ing
> intel-wired-lan ml as that allows intel folks, to do some initial
> testing?
> If so, we can do that here (IMHO).

Patch sent here:
https://lore.kernel.org/lkml/20210501021832.743094-1-jesse.brandeburg@intel.com/T/#u

Any testing appreciated!

Jesse
