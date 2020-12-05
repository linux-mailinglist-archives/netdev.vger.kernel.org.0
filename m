Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF2A2CFD00
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 19:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729343AbgLEST2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 13:19:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727223AbgLERvD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 12:51:03 -0500
Date:   Sat, 5 Dec 2020 09:50:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607190622;
        bh=eXv3+mv1r4rGBZPQXy5JncBjXLX4m1Jn75DZFqAu9ms=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=DnUx2vP9Y/VyqMsTenPfI2Uez+RKawzq8uWTV7Up1/vIETGZN4t001HBoruL1L45g
         0KRHe0lLA1Zrv66m9nJPwasmebj3fzOTzs6Fze4BUn52ekwY1y2Nl9e5UNC0Yy8ecK
         Gb04C8nUJF/Zyzp5d6uTb7OEGS+dsj5Wmw5Z9zsr6kBh4E4R6gQRdEJNOqZ46l7ZOz
         jFz2h3iiKdcUMj/f10/6IuT/rwLdqcVAfGK97DRQGEvOrVCaBwOb7VYqhVH+kEqclK
         GPcF/fkLs8qSptxLShcJVoM43oLj8S5qVmG4NNVKrIDLPWa0IMbVx52k/Gr4W3+5UH
         j8MIA7OQGQElQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v1 0/9] ethtool: Add support for frame
 preemption
Message-ID: <20201205095021.36e1a24d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202045325.3254757-1-vinicius.gomes@intel.com>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Dec 2020 20:53:16 -0800 Vinicius Costa Gomes wrote:
> $ tc qdisc replace dev $IFACE parent root handle 100 taprio \
>       num_tc 3 \
>       map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>       queues 1@0 1@1 2@2 \
>       base-time $BASE_TIME \
>       sched-entry S 0f 10000000 \
>       preempt 1110 \
>       flags 0x2 
> 
> The "preempt" parameter is the only difference, it configures which
> queues are marked as preemptible, in this example, queue 0 is marked
> as "not preemptible", so it is express, the rest of the four queues
> are preemptible.

Does it make more sense for the individual queues to be preemptible 
or not, or is it better controlled at traffic class level?
I was looking at patch 2, and 32 queues isn't that many these days..
We either need a larger type there or configure this based on classes.
