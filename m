Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB8B1D6223
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 17:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgEPPhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 11:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbgEPPhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 11:37:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E25CC061A0C;
        Sat, 16 May 2020 08:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TG5YZgmRlXVS7HvhJz7DOFxKZzjqL5DT1HxTsi4ato4=; b=RnggIlJMvxkkVJkInT4pqpaVSA
        SmN+fQmJr6rXEhoA27zDDtoVe3MfLbqyOGnjbFroFdUEa2bz7T8LXqJhdZ04Kn8zUaw7zqnqucvEE
        jylJg+5o3OTrPcU/9WnNB5DHJG6s2r/4zP/X7rBAVxQdC6M19CKb7CjJPN7ckvsf+3VEUSWXTjPOs
        h4KyUBqEslvU/z84GxRvc0uH9xKOs7/moDDDKZUR3/JC6le8XeM7SlwM6eCF1D2ew/AfzjZ81WeGR
        TID2vSDI6gItLhZe+n8N/K+Igbx6wbsz1MCCu7X4o5NOmt5PKestOUG7qfbgkfaJZ9h4Kw4hb2rBr
        xNF175SA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jZyrs-000842-U1; Sat, 16 May 2020 15:36:52 +0000
Date:   Sat, 16 May 2020 08:36:52 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     'David Howells' <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 27/33] sctp: export sctp_setsockopt_bindx
Message-ID: <20200516153652.GM16070@bombadil.infradead.org>
References: <20200514062820.GC8564@lst.de>
 <20200513062649.2100053-1-hch@lst.de>
 <20200513062649.2100053-28-hch@lst.de>
 <20200513180058.GB2491@localhost.localdomain>
 <129070.1589556002@warthog.procyon.org.uk>
 <05d946ae948946158dbfcbc07939b799@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05d946ae948946158dbfcbc07939b799@AcuMS.aculab.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 16, 2020 at 03:11:40PM +0000, David Laight wrote:
> From: David Howells
> > Sent: 15 May 2020 16:20
> > Christoph Hellwig <hch@lst.de> wrote:
> > 
> > > > The advantage on using kernel_setsockopt here is that sctp module will
> > > > only be loaded if dlm actually creates a SCTP socket.  With this
> > > > change, sctp will be loaded on setups that may not be actually using
> > > > it. It's a quite big module and might expose the system.
> > >
> > > True.  Not that the intent is to kill kernel space callers of setsockopt,
> > > as I plan to remove the set_fs address space override used for it.
> > 
> > For getsockopt, does it make sense to have the core kernel load optval/optlen
> > into a buffer before calling the protocol driver?  Then the driver need not
> > see the userspace pointer at all.
> > 
> > Similar could be done for setsockopt - allocate a buffer of the size requested
> > by the user inside the kernel and pass it into the driver, then copy the data
> > back afterwards.
> 
> Yes, it also simplifies all the compat code.
> And there is a BPF test in setsockopt that also wants to
> pass on a kernel buffer.
> 
> I'm willing to sit and write the patch.
> Quoting from a post I made later on Friday.
> 
> Basically:
> 
> This patch sequence (to be written) does the following:
> 
> Patch 1: Change __sys_setsockopt() to allocate a kernel buffer,
>          copy the data into it then call set_fs(KERNEL_DS).
>          An on-stack buffer (say 64 bytes) will be used for
>          small transfers.
> 
> Patch 2: The same for __sys_getsockopt().
> 
> Patch 3: Compat setsockopt.
> 
> Patch 4: Compat getsockopt.
> 
> Patch 5: Remove the user copies from the global socket options code.
> 
> Patches 6 to n-1; Remove the user copies from the per-protocol code.
> 
> Patch n: Remove the set_fs(KERNEL_DS) from the entry points.
> 
> This should be bisectable.

I appreciate your dedication to not publishing the source code to
your kernel module, but Christoph's patch series is actually better.
It's typesafe rather than passing void pointers around.
