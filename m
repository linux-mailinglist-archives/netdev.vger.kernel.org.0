Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFBDB29705D
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 15:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S464725AbgJWNZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 09:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373829AbgJWNZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 09:25:20 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68244C0613CE;
        Fri, 23 Oct 2020 06:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HEsMZW6VUzWZDcaTQFGuaqHUigGcMc17DOxpKIiHD3U=; b=1Jpp6aUef3ZNl/fpS536OWGOTZ
        o4VHLn/1/CVcI3hsGyiAlldbrSaHH2Lp77z1BHDLPXCLVbzr1mpe0ipzTm/4LMjybDReOxC4EDnlH
        u6SbYBUdzmxNxCGNGnTJVdm5/Z4YYYqmzwfry8pZe+iGi/kkIaUy0znCaDb4znXBwIribIVwzXimD
        wwBgnxpZPWjcY6TCzbi7mqeGtvDQA6SNvqCQ2zwj6z/ofQ78mowl1FYn/+6Rr0neaIpw4u8aoZlcU
        IPdVcpZuEx4u8wBKya8J++OLqHQUrCQqsVQILjky4/t3vj7hixqUguwYEku8yPWZwddAtOOU6/8XA
        um4xU4Qw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kVx47-00026G-SL; Fri, 23 Oct 2020 13:25:08 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BDEE8300B22;
        Fri, 23 Oct 2020 15:25:05 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id AD9C023268B98; Fri, 23 Oct 2020 15:25:05 +0200 (CEST)
Date:   Fri, 23 Oct 2020 15:25:05 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, lgoncalv@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4 2/4] sched/isolation: Extend nohz_full to isolate
 managed IRQs
Message-ID: <20201023132505.GZ2628@hirez.programming.kicks-ass.net>
References: <20200928183529.471328-1-nitesh@redhat.com>
 <20200928183529.471328-3-nitesh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928183529.471328-3-nitesh@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 02:35:27PM -0400, Nitesh Narayan Lal wrote:
> Extend nohz_full feature set to include isolation from managed IRQS. This

So you say it's for managed-irqs, the feature is actually called
MANAGED_IRQ, but, AFAICT, it does *NOT* in fact affect managed IRQs.

Also, as per Thomas' earlier points, managed-irqs are in fact perfectly
fine and don't need help at at...

> is required specifically for setups that only uses nohz_full and still
> requires isolation for maintaining lower latency for the listed CPUs.
> 
> Suggested-by: Frederic Weisbecker <frederic@kernel.org>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  kernel/sched/isolation.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 5a6ea03f9882..9df9598a9e39 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -141,7 +141,7 @@ static int __init housekeeping_nohz_full_setup(char *str)
>  	unsigned int flags;
>  
>  	flags = HK_FLAG_TICK | HK_FLAG_WQ | HK_FLAG_TIMER | HK_FLAG_RCU |
> -		HK_FLAG_MISC | HK_FLAG_KTHREAD;
> +		HK_FLAG_MISC | HK_FLAG_KTHREAD | HK_FLAG_MANAGED_IRQ;
>  
>  	return housekeeping_setup(str, flags);
>  }
> -- 
> 2.18.2
> 
