Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA7FC811D3
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 07:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfHEF53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 01:57:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbfHEF52 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 01:57:28 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0961B20657;
        Mon,  5 Aug 2019 05:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564984647;
        bh=CluuMJNOmsHOA+mAZyMfZg778egHHWNYSrWjkWdY6cI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LEnRxcXU43u2fZXKbn6MhQzNUjxbHOrdqfVA1Y0H/3qTz5hhcdCwvvAxMtGuObd4k
         6S/gfgGtA1mzMSK0vwmWmonBjHg7SeOvW1gEJc1OnMp3kZIyssFGVFqpo0g8YXmHYI
         y7xrk7M3Sn88ATaKkP+Ys7RbQqz5rj4Hcn2SgbcY=
Date:   Mon, 5 Aug 2019 08:57:23 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Use refcount_t for refcount
Message-ID: <20190805055723.GM4832@mtr-leonro.mtl.com>
References: <20190802121035.1315-1-hslester96@gmail.com>
 <20190804124820.GH4832@mtr-leonro.mtl.com>
 <CANhBUQ0rMKHmh4ibktwRmVN6NU=HAjs-Q7PrF9yX5x5yOyOB2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANhBUQ0rMKHmh4ibktwRmVN6NU=HAjs-Q7PrF9yX5x5yOyOB2A@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 04, 2019 at 10:58:19PM +0800, Chuhong Yuan wrote:
> On Sun, Aug 4, 2019 at 8:48 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Fri, Aug 02, 2019 at 08:10:35PM +0800, Chuhong Yuan wrote:
> > > Reference counters are preferred to use refcount_t instead of
> > > atomic_t.
> > > This is because the implementation of refcount_t can prevent
> > > overflows and detect possible use-after-free.
> > >
> > > First convert the refcount field to refcount_t in mlx5/driver.h.
> > > Then convert the uses to refcount_() APIs.
> >
> > You can't do it, because you need to ensure that driver compiles and
> > works between patches. By converting driver.h alone to refcount_t, you
> > simply broke mlx5 driver.
> >
>
> It is my fault... I am not clear how to send patches which cross
> several subsystems, so I sent them in series.
> Maybe I should merge these patches together?

In case of conversion patches, yes, you need to perform such change
in one shot.

>
>
> > NAK, to be clear.
> >
> > And please don't sent series of patches as standalone patches.
> >
>
> Due to the reason mentioned above, I sent them seperately.

Create patch, run ./scripts/get_maintainer.pl on it and send according
to generated output. You are not doing kernel core changes and there is
no need to worry about cross subsystem complexity as long as you will
put relevant maintainers in TO: field.

Thanks

>
> > Thanks,
