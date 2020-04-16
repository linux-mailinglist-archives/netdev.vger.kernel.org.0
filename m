Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11F71AC6CF
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 16:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409115AbgDPN7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 09:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2441892AbgDPN7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 09:59:40 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D090AC061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 06:59:39 -0700 (PDT)
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jP53K-0003D4-8d; Thu, 16 Apr 2020 15:59:38 +0200
Date:   Thu, 16 Apr 2020 15:59:38 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net 2/2] net: gro: Let the timeout timer expire in
 softirq context with `threadirqs'
Message-ID: <20200416135938.jiglv4ctjayg5qmg@linutronix.de>
References: <20191126222013.1904785-1-bigeasy@linutronix.de>
 <20191126222013.1904785-3-bigeasy@linutronix.de>
 <CANn89iJtCwB=RdYnAYXU-uZvv=gHJgYD=dcfhohuLi_Qjfv6Ag@mail.gmail.com>
 <20191127093521.6achiubslhv7u46c@linutronix.de>
 <CANn89iL=q2wwjdSj1=veBE0hDATm_K=akKhz3Dyddnk28DRJhg@mail.gmail.com>
 <CANn89i+Aje5j2iJDoq9FCU966kxC-gaD=ObxwVL49VC9L85_vA@mail.gmail.com>
 <20191127173719.q3hrdthuvkt2h2ul@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191127173719.q3hrdthuvkt2h2ul@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

any comments from the timer department?

On 2019-11-27 18:37:19 [+0100], To Eric Dumazet wrote:
> On 2019-11-27 09:11:40 [-0800], Eric Dumazet wrote:
> > Resent in non HTML mode :/
> don't worry, mutt handles both :)
> 
> > Long story short, why hrtimer are not by default using threaded mode
> > in threadirqs mode ?
> 
> Because it is only documented to thread only interrupts. Not sure if we
> want change this.
> In RT we expire most of the hrtimers in softirq context for other
> reasons. A subset of them still expire in hardirq context.
>
> > Idea of having some (but not all of them) hard irq handlers' now being
> > run from BH mode,
> > is rather scary.
> 
> As I explained in my previous email: All IRQ-handlers fire in
> threaded-mode if enabled. Only the hrtimer is not affected by this
> change.
> 
> > Also, hrtimers got the SOFT thing only in 4.16, while the GRO patch
> > went in linux-3.19
> > 
> > What would be the plan for stable trees ?
> No idea yet. We could let __napi_schedule_irqoff() behave like
> __napi_schedule(). 

Sebastian
