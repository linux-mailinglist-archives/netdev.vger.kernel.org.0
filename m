Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF6912A551
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 01:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfLYA7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 19:59:03 -0500
Received: from mga07.intel.com ([134.134.136.100]:44857 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726237AbfLYA7D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Dec 2019 19:59:03 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Dec 2019 16:59:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,353,1571727600"; 
   d="scan'208";a="229769304"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by orsmga002.jf.intel.com with ESMTP; 24 Dec 2019 16:59:02 -0800
Date:   Tue, 24 Dec 2019 17:10:20 -0800
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     David Miller <davem@davemloft.net>
Cc:     michael.chan@broadcom.com, netdev@vger.kernel.org,
        tglx@linutronix.de, luto@kernel.org, peterz@infradead.org,
        tony.luck@intel.com, David.Laight@ACULAB.COM,
        ravi.v.shankar@intel.com
Subject: Re: [PATCH] drivers/net/b44: Change to non-atomic bit operations
Message-ID: <20191225011020.GE241295@romley-ivt3.sc.intel.com>
References: <1576884551-9518-1-git-send-email-fenghua.yu@intel.com>
 <20191224.161826.37676943451935844.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224.161826.37676943451935844.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 24, 2019 at 04:18:26PM -0800, David Miller wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> Date: Fri, 20 Dec 2019 15:29:11 -0800
> 
> > On x86, accessing data across two cache lines in one atomic bit
> > operation (aka split lock) can take over 1000 cycles.
> 
> This happens during configuration of WOL, nobody cares that the atomic
> operations done in this function take 1000 cycles each.
> 
> I'm not applying this patch.  It is gratuitous, and the commit message
> talks about "performance" considuations (cycle counts) that completely
> don't matter here.
> 
> If you are merely just arbitrarily trying to remove locked atomic
> operations across the tree for it's own sake, then you should be
> completely honest about that in your commit message.

We are enabling split lock in the kernel (by default):
https://lkml.org/lkml/2019/12/12/1129

After applying the split lock detection patch, the set_bit() in b44.c
may cause split lock and kernel dies.

So should I change the commit message to add the above info?

Thanks.

-Fenghua
