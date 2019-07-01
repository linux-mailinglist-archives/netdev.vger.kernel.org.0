Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03FB35B706
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 10:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbfGAImR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 04:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbfGAImQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 04:42:16 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C22C320881;
        Mon,  1 Jul 2019 08:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561970536;
        bh=EuJJCr8afeJG/qvEREgqqIK72eu1U4Vw/fvqo5aoqwk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E5WHAS4jl8qvLVvuSQLeN9j3xI4FREcZ7YbHHJ4ub+MqHDljdFQeTnXp6BkkqeJDm
         JLlwZBMnG0LvJXX4mL+hWt8a79RnvVaaR/bBLaOGYrYh3xlf2CY4FT1r9D/7UvVKO7
         9kZtoVOEK7AoHdNot6llg+8Q/1ehODG8L+inmNsY=
Date:   Mon, 1 Jul 2019 11:42:13 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v4 06/17] RDMA/counter: Add "auto"
 configuration mode support
Message-ID: <20190701084213.GJ4727@mtr-leonro.mtl.com>
References: <20190618172625.13432-1-leon@kernel.org>
 <20190618172625.13432-7-leon@kernel.org>
 <20190630004048.GB7173@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190630004048.GB7173@mellanox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 30, 2019 at 12:40:54AM +0000, Jason Gunthorpe wrote:
> On Tue, Jun 18, 2019 at 08:26:14PM +0300, Leon Romanovsky wrote:
>
> > +static void __rdma_counter_dealloc(struct rdma_counter *counter)
> > +{
> > +	mutex_lock(&counter->lock);
> > +	counter->device->ops.counter_dealloc(counter);
> > +	mutex_unlock(&counter->lock);
> > +}
>
> Does this lock do anything? The kref is 0 at this point, so no other
> thread can have a pointer to this lock.

Yes, it is leftover from atomic_read implementation.

>
> > +
> > +static void rdma_counter_dealloc(struct rdma_counter *counter)
> > +{
> > +	if (!counter)
> > +		return;
>
> Counter is never NULL.

Ohh, right, I'll clean some code near rdma_counter_dealloc/__rdma_counter_dealloc.

Thanks

>
> Jason
