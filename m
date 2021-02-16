Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05DE31C676
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 07:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbhBPGEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 01:04:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:50708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhBPGEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 01:04:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F80764DDA;
        Tue, 16 Feb 2021 06:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613455440;
        bh=r+OZB827JaqOfN2ks887+1Upc8nphXhkC94g+YGIn8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AsklDOfrNTLRJuOs3a9ZsgoPK35EJNkFEC4dBkKun7xSuklBW1Z4qnO5wWd4F/Q3Z
         WUlFY1EUXs2pQ/vDl6Y0eY/lQ5tJRWZehE+lyAXEbJhQqzsqUe0kDnlmBfrKvWQce9
         2wqYom6NxA9Hmtqfb2Wd0xxUL4dZLY5iah2NjES+mCY2fX6SJ7X7vb2ZlH6iSjgZsr
         245oU9pKE9i1Kh794k7i5GLtmJNdlnPOQzQH9VP86R4dXS6PU7/CvKgMo4PtD0aVHX
         ZikNO7d5DJ032Fma4jMNGJwpld1pJCgXE3TmdRLzzejQzkDwp8+JcoQAOETq+rlIHs
         bQFKv0B75OBKw==
Date:   Tue, 16 Feb 2021 08:03:56 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH net-next RFC v3] net: hdlc_x25: Queue outgoing LAPB frames
Message-ID: <YCtgTBvR6TD8sPpe@unreal>
References: <20210215072703.43952-1-xie.he.0141@gmail.com>
 <YCo96zjXHyvKpbUM@unreal>
 <CAJht_EOQBDdwa0keS9XTKZgXE44_b5cHJt=fFaKy-wFDpe6iaw@mail.gmail.com>
 <YCrDcMYgSgdKp4eX@unreal>
 <CAJht_EPy1Us72YGMune2G3s1TLB4TOCBFJpZt+KbVUV8uoFbfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJht_EPy1Us72YGMune2G3s1TLB4TOCBFJpZt+KbVUV8uoFbfA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 11:08:02AM -0800, Xie He wrote:
> On Mon, Feb 15, 2021 at 10:54 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Mon, Feb 15, 2021 at 09:23:32AM -0800, Xie He wrote:
> > > On Mon, Feb 15, 2021 at 1:25 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > >
> > > > > +     /* When transmitting data:
> > > > > +      * first we'll remove a pseudo header of 1 byte,
> > > > > +      * then the LAPB module will prepend an LAPB header of at most 3 bytes.
> > > > > +      */
> > > > > +     dev->needed_headroom = 3 - 1;
> > > >
> > > > 3 - 1 = 2
> > > >
> > > > Thanks
> > >
> > > Actually this is intentional. It makes the numbers more meaningful.
> > >
> > > The compiler should automatically generate the "2" so there would be
> > > no runtime penalty.
> >
> > If you want it intentional, write it in the comment.
> >
> > /* When transmitting data, we will need extra 2 bytes headroom,
> >  * which are 3 bytes of LAPB header minus one byte of pseudo header.
> >  */
> >  dev->needed_headroom = 2;
>
> I think this is unnecessary. The current comment already explains the
> meaning of the "1" and the "3". There's no need for a reader of this
> code to understand what a "2" is. That is the job of the compiler, not
> the human reader.

It is not related to compiler/human format. If you need to write "3 - 1"
to make it easy for users, it means that your comment above is not
full/correct/e.t.c.

Thanks
