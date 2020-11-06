Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C112A990E
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 17:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgKFQGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 11:06:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbgKFQGv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 11:06:51 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AA5E2078B;
        Fri,  6 Nov 2020 16:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604678810;
        bh=d9Gi07iaKLOb6bYB85zhOUrzxMsKmvTb4B3WbC93xyk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T1WynHEc7leJzJZzHbDHezQ67N930g/hMbtg3wtJfD7rVSSzOv0kZ4ULHgzAE05r7
         EHkbxrxOHUYzF2/A9PV3QTKXe+wk1oqGT4qlRNUOG7xJfeRWABriGoSFogWnwgLCgK
         L1vBPfCVk83uRSPbbDh6ZgEn1mFDNVHngHSrGDWw=
Date:   Fri, 6 Nov 2020 08:06:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     andrew.hendry@gmail.com, davem@davemloft.net, edumazet@google.com,
        xiyuyang19@fudan.edu.cn, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/x25: Fix null-ptr-deref in x25_connect
Message-ID: <20201106080649.122dfb22@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9751fc51170c9bf776e03d079a3e92e3@dev.tdt.de>
References: <20201006054558.19453-1-ms@dev.tdt.de>
        <9751fc51170c9bf776e03d079a3e92e3@dev.tdt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 06 Nov 2020 07:23:05 +0100 Martin Schiller wrote:
> On 2020-10-06 07:45, Martin Schiller wrote:
> > This fixes a regression for blocking connects introduced by commit
> > 4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when x25 
> > disconnect").
> > 
> > The x25->neighbour is already set to "NULL" by x25_disconnect() now,
> > while a blocking connect is waiting in
> > x25_wait_for_connection_establishment(). Therefore x25->neighbour must
> > not be accessed here again and x25->state is also already set to
> > X25_STATE_0 by x25_disconnect().
> > 
> > Fixes: 4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when x25 
> > disconnect")
> > Signed-off-by: Martin Schiller <ms@dev.tdt.de>
> 
> @David
> Is there anything left I need to do, to get this fix merged?

Hm, no idea what happened here (you could try to check the state in
patchwork but it's gonna take some digging to find a month old patch).

Please resend and we'll take it from there.
