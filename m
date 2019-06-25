Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC645545E
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 18:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbfFYQXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 12:23:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11247 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726740AbfFYQXn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 12:23:43 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ECFF1316291C;
        Tue, 25 Jun 2019 16:23:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFF781001281;
        Tue, 25 Jun 2019 16:23:39 +0000 (UTC)
Message-ID: <0e1075c74d5c71acd9fbbc5ad76c07cc158324f2.camel@redhat.com>
Subject: Re: [PATCH net] net/sched: flower: fix infinite loop in fl_walk()
From:   Davide Caratti <dcaratti@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Lucas Bates <lucasb@mojatatu.com>
In-Reply-To: <6650f0da68982ffa5bb71a773c5a3d588bd972c4.camel@redhat.com>
References: <9068475730862e1d9014c16cee0ad2734a4dd1f9.1560978242.git.dcaratti@redhat.com>
         <CAM_iQpUVJ9sG9ETE0zZ_azbDgWp_oi320nWy_g-uh2YJWYDOXw@mail.gmail.com>
         <53b8c3118900b31536594e98952640c03a4456e0.camel@redhat.com>
         <CAM_iQpVVMBUdhv3o=doLhpWxee91zUPKjAOtUwryUEj0pfowdg@mail.gmail.com>
         <6650f0da68982ffa5bb71a773c5a3d588bd972c4.camel@redhat.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Tue, 25 Jun 2019 18:23:38 +0200
Mime-Version: 1.0
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Tue, 25 Jun 2019 16:23:43 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-06-25 at 17:47 +0200, Davide Caratti wrote:
> On Thu, 2019-06-20 at 10:33 -0700, Cong Wang wrote:
> > On Thu, Jun 20, 2019 at 5:52 AM Davide Caratti <dcaratti@redhat.com> wrote:
> > > hello Cong, thanks for reading.
> > > 
> > > On Wed, 2019-06-19 at 15:04 -0700, Cong Wang wrote:
> > > > On Wed, Jun 19, 2019 at 2:10 PM Davide Caratti <dcaratti@redhat.com> wrote:
> > > > > on some CPUs (e.g. i686), tcf_walker.cookie has the same size as the IDR.
> > > > > In this situation, the following script:
> > > > > 
> > > > >  # tc filter add dev eth0 ingress handle 0xffffffff flower action ok
> > > > >  # tc filter show dev eth0 ingress
> > > > > 
> > > > > results in an infinite loop.
> 
> So, when the radix tree contains one slot with index equal to ULONG_MAX,
> whatever can be the value of 'id',

oops, this phrase is of course wrong. the value of 'id' matters to
determine the condition of the if().

>  the condition in that if() will always 
> be false (and the function will keep  returning non-NULL, hence the 
> infinite loop).

what I wanted to say is, when the radix tree contains a single slot with
index equal to ULONG_MAX, whatever value I put in 'id' the function will
always return a pointer to that slot.

-- 
davide

