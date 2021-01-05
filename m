Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B4D2EA4F9
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 06:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbhAEFjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 00:39:43 -0500
Received: from smtp1.emailarray.com ([65.39.216.14]:24940 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbhAEFjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 00:39:43 -0500
Received: (qmail 68839 invoked by uid 89); 5 Jan 2021 05:39:01 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 5 Jan 2021 05:39:01 -0000
Date:   Mon, 4 Jan 2021 21:38:59 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [RFC PATCH v3 00/12] Generic zcopy_* functions
Message-ID: <20210105053859.krqfzfnsoqr7qdt7@bsd-mbp.dhcp.thefacebook.com>
References: <20201230191244.610449-1-jonathan.lemon@gmail.com>
 <CAF=yD-Jb-tkxYPHrnAk3x641RY6tnrGOJB0UkrBWrXmvuRiM9w@mail.gmail.com>
 <20210105041707.m574sk4ivjsxvtxi@bsd-mbp.dhcp.thefacebook.com>
 <CAF=yD-KbkYTHG+MC5y3qOCFp=9EVsk=TPb=7RoHtVTZqnL0OyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-KbkYTHG+MC5y3qOCFp=9EVsk=TPb=7RoHtVTZqnL0OyQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 04, 2021 at 11:22:35PM -0500, Willem de Bruijn wrote:
> On Mon, Jan 4, 2021 at 11:17 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> >
> > On Mon, Jan 04, 2021 at 12:39:35PM -0500, Willem de Bruijn wrote:
> > > On Wed, Dec 30, 2020 at 2:12 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> > > >
> > > > From: Jonathan Lemon <bsd@fb.com>
> > > >
> > > > This is set of cleanup patches for zerocopy which are intended
> > > > to allow a introduction of a different zerocopy implementation.
> > > >
> > > > The top level API will use the skb_zcopy_*() functions, while
> > > > the current TCP specific zerocopy ends up using msg_zerocopy_*()
> > > > calls.
> > > >
> > > > There should be no functional changes from these patches.
> > > >
> > > > v2->v3:
> > > >  Rename zc_flags to 'flags'.  Use SKBFL_xxx naming, similar
> > > >  to the SKBTX_xx naming.  Leave zerocopy_success naming alone.
> > > >  Reorder patches.
> > > >
> > > > v1->v2:
> > > >  Break changes to skb_zcopy_put into 3 patches, in order to
> > > >  make it easier to follow the changes.  Add Willem's suggestion
> > > >  about renaming sock_zerocopy_
> > >
> > > Overall, this latest version looks fine to me.
> > >
> > > The big question is how this fits in with the broader rx direct
> > > placement feature. But it makes sense to me to checkpoint as is at
> > > this point.
> > >
> > > One small comment: skb_zcopy_* is a logical prefix for functions that
> > > act on sk_buffs, Such as skb_zcopy_set, which associates a uarg with
> > > an skb. Less for functions that operate directly on the uarg, and do
> > > not even take an skb as argument: skb_zcopy_get and skb_zcopy_put.
> > > Perhaps net_zcopy_get/net_zcopy_put?
> >
> > Or even just zcopy_get / zcopy_put ?
> 
> Zerocopy is such an overloaded term, that I'd keep some prefix, at least.

I'll make that change and repost the series when net-next opens.
--
Jonathan
