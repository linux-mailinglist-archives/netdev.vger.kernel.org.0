Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642081DC96E
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 11:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgEUJIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 05:08:19 -0400
Received: from verein.lst.de ([213.95.11.211]:53789 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728702AbgEUJIS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 05:08:18 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B08C668BEB; Thu, 21 May 2020 11:08:12 +0200 (CEST)
Date:   Thu, 21 May 2020 11:08:12 +0200
From:   'Christoph Hellwig' <hch@lst.de>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Christoph Hellwig' <hch@lst.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Miller <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "vyasevich@gmail.com" <vyasevich@gmail.com>,
        "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 31/33] sctp: add sctp_sock_set_nodelay
Message-ID: <20200521090812.GA8330@lst.de>
References: <20200520195509.2215098-1-hch@lst.de> <20200520195509.2215098-32-hch@lst.de> <20200520231001.GU2491@localhost.localdomain> <20200520.162355.2212209708127373208.davem@davemloft.net> <20200520233913.GV2491@localhost.localdomain> <20200521083442.GA7771@lst.de> <0a6839ab0ba04fcf9b9c92784c9564aa@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a6839ab0ba04fcf9b9c92784c9564aa@AcuMS.aculab.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 09:06:19AM +0000, David Laight wrote:
> > > The comment still applies, though. (re the duplication)
> > 
> > Where do you see duplication?
> 
> The whole thing just doesn't scale.
> 
> As soon as you get to the slightly more complex requests
> like SCTP_INITMSG (which should probably be called to
> set the required number of data streams) you've either
> got replicated code or nested wrappers.

None of that is relevant to setting the nodelay option.  If you actually
read through the series you'd say that whenever there was non-trivial
logic it is shared with getopt.  However sharing just for purpose of
sharing doesn't make sense, so where the kernel API ended up just
setting a flag after taking the sock lock I did not opt for it.
