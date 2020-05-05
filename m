Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3551C4FE6
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 10:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgEEIKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 04:10:00 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:40924 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgEEIKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 04:10:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588666200; x=1620202200;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=CWbeNyZVYb77+f9+ECjqappEP6OpT02jOEzU/LtCItI=;
  b=FS9isCQbg4Rw0Lod4l2B9OnOHpTwUHYDK6co14b/e1oLIxYB8TG1JYdE
   8Yu8tb9rNzBcuF2PX+qlDz2n1QLxrnMtcn1nA4TofSmaEDLTmJVd3NPXT
   qFF+SAC7+mtE31rQf3nXN6EZynMIGKt9n4BAsVZbuwtCDJ71wrY5S2fkJ
   4=;
IronPort-SDR: /J2FYKAaa9IUpOlccLWMPcjUXk3g/hhkLxhHJv45rLi4gJmN7uWzPSKx6zf3ntrMFAlqSyhKJX
 /ll1Q4O3DxMQ==
X-IronPort-AV: E=Sophos;i="5.73,354,1583193600"; 
   d="scan'208";a="28772447"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 05 May 2020 08:09:47 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id AB73BA1D37;
        Tue,  5 May 2020 08:09:44 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 08:09:44 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.162.200) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 08:09:39 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     SeongJae Park <sjpark@amazon.com>, <davem@davemloft.net>,
        <viro@zeniv.linux.org.uk>, <kuba@kernel.org>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, SeongJae Park <sjpark@amazon.de>
Subject: Re: Re: [PATCH net 2/2] Revert "sockfs: switch to ->free_inode()"
Date:   Tue, 5 May 2020 10:09:23 +0200
Message-ID: <20200505080923.6970-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505074535.GB4054974@kroah.com> (raw)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.200]
X-ClientProxiedBy: EX13D25UWB003.ant.amazon.com (10.43.161.33) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 May 2020 09:45:35 +0200 Greg KH <gregkh@linuxfoundation.org> wrote:

> On Tue, May 05, 2020 at 09:28:41AM +0200, SeongJae Park wrote:
> > From: SeongJae Park <sjpark@amazon.de>
> > 
> > This reverts commit 6d7855c54e1e269275d7c504f8f62a0b7a5b3f18.
> > 
> > The commit 6d7855c54e1e ("sockfs: switch to ->free_inode()") made the
> > deallocation of 'socket_alloc' to be done asynchronously using RCU, as
> > same to 'sock.wq'.
> > 
> > The change made 'socket_alloc' live longer than before.  As a result,
> > user programs intensively repeating allocations and deallocations of
> > sockets could cause memory pressure on recent kernels.
> > 
> > To avoid the problem, this commit reverts the change.
> > ---
> >  net/socket.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Same problems here as in patch 1/2 :(

Yes, indeed.  I will send next version right now.


Thanks,
SeongJae Park

> 
