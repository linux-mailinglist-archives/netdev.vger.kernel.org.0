Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF8736F3D5
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 03:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhD3Bsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 21:48:52 -0400
Received: from mga18.intel.com ([134.134.136.126]:1029 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhD3Bsv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 21:48:51 -0400
IronPort-SDR: X+g1ejYcjJ2JXyZvSASSPzFXNyvYYPhXEXBz9x8QV5D72pr0XxNh6y+g5rabSC3g2hZk42E2uE
 ADw0yXK1IwTw==
X-IronPort-AV: E=McAfee;i="6200,9189,9969"; a="184646243"
X-IronPort-AV: E=Sophos;i="5.82,260,1613462400"; 
   d="scan'208";a="184646243"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2021 18:48:03 -0700
IronPort-SDR: VCNCi44upo9HW3I6bWsf05cfpZFM8Nfapyq8zjSxUuparGWrXoSKUUhB0YE+Tzb9aHx5t92MMt
 U2O1V25OFqRg==
X-IronPort-AV: E=Sophos;i="5.82,260,1613462400"; 
   d="scan'208";a="431182560"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.109.170])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2021 18:48:03 -0700
Date:   Thu, 29 Apr 2021 18:48:02 -0700
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
Message-ID: <20210429184802.0000641e@intel.com>
In-Reply-To: <CAFki+Lm0W_brLu31epqD3gAV+WNKOJfVDfX2M8ZM__aj3nv9uA@mail.gmail.com>
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
        <20210414091100.000033cf@intel.com>
        <54ecc470-b205-ea86-1fc3-849c5b144b3b@redhat.com>
        <CAFki+Lm0W_brLu31epqD3gAV+WNKOJfVDfX2M8ZM__aj3nv9uA@mail.gmail.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nitesh Lal wrote:

> @Jesse do you think the Part-1 findings explain the behavior that you have
> observed in the past?
> 
> Also, let me know if there are any suggestions or experiments to try here.

Wow Nitesh, nice work! That's quite a bit of spelunking you had to do
there!

Your results that show the older kernels with ranged affinity issues is
consistent with what I remember from that time, and the original
problem.

I'm glad to see that a) Thomas fixed the kernel to even do better than
ranged affinity masks, and that b) if you revert my patch, the new
behavior is better and still maintains the fix from a).

For me this explains the whole picture and makes me feel comfortable
with the patch that reverts the initial affinity mask (that also
introduces a subtle bug with the reserved CPUs that I believe you've
noted already).

Thanks for this work!
Jesse
