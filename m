Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505722C1FA3
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 09:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730426AbgKXILl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 03:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730418AbgKXILl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 03:11:41 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA086C0613CF;
        Tue, 24 Nov 2020 00:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=56SWde4JhhrtqSbsoYBwRczXlriwLiWOejfBIuhGL2s=; b=CEIY4M6uPnXwo4ws/7eZsmccyc
        ks65040mEj12b9vJA8zo/so9QqczDa1iapa6FEtYrMmc58mrj2/s0wnqKJImknYyk0KUG2DJNHSMm
        qHEa2Nod5CxBuyu4bAXG9SHrdtBgUE+ntkQTqMRtQHWx3SABiFIlArTemekHfqvbNT5shEeYNzqcM
        zjrF+ZA4Fp5kzEPfEFQO2MWBAUu9hzkMSwYg3faOe69Tpo6aXrZIN7ueZJWhJYbSDbm/cx2IP+qg6
        A6uDGE+e2zNSsk6PMzeDy49l9Be53LuW04bdoVZTfTChmutMwtEBSSn1ZDy3W/pjESXILzYWbN7Sx
        47DihCzw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1khTPt-0002lq-9h; Tue, 24 Nov 2020 08:11:13 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 61150304D28;
        Tue, 24 Nov 2020 09:11:12 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 218C82C603635; Tue, 24 Nov 2020 09:11:12 +0100 (CET)
Date:   Tue, 24 Nov 2020 09:11:12 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>, mingo@redhat.com,
        will@kernel.org, viro@zeniv.linux.org.uk, kyk.segfault@gmail.com,
        davem@davemloft.net, linmiaohe@huawei.com,
        martin.varghese@nokia.com, pabeni@redhat.com, pshelar@ovn.org,
        fw@strlen.de, gnault@redhat.com, steffen.klassert@secunet.com,
        vladimir.oltean@nxp.com, edumazet@google.com, saeed@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next v2 1/2] lockdep: Introduce in_softirq lockdep
 assert
Message-ID: <20201124081112.GF2414@hirez.programming.kicks-ass.net>
References: <1605927976-232804-1-git-send-email-linyunsheng@huawei.com>
 <1605927976-232804-2-git-send-email-linyunsheng@huawei.com>
 <20201123142725.GQ3021@hirez.programming.kicks-ass.net>
 <20201123121259.312dcb82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123121259.312dcb82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 12:12:59PM -0800, Jakub Kicinski wrote:
> One liner would be:
> 
> 	* Acceptable for protecting per-CPU resources accessed from BH
> 	
> We can add:
> 
> 	* Much like in_softirq() - semantics are ambiguous, use carefully. *
> 
> 
> IIUC we basically want to protect the nc array and counter here:

Works for me, thanks!
