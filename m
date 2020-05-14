Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B244A1D3D9A
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgENTfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726128AbgENTfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 15:35:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5A3C061A0C;
        Thu, 14 May 2020 12:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2cAIpvlCjeek2UlOhaJLhP9ft/jEX+ktFmYjxRqXe+8=; b=VKrUJVLC1QZKeaeXa89WwIPrud
        xWN6tLhwKrf0IpJKq477Gsgmnmh5IAspTgAHgDcohLeDdrarSFbeKBc4Rw2VutH7Wdqvp+u4GJ57w
        S0xlexgFqHGVwvMQi6/gLdhHcd2BhEAtEJoKic/a9cMDbNfSZrkHXscgCV9WUJWrinXP0EAaolivK
        hCE8IgM4uAPNE59ZVrZ32j3gM0r62sSoSbqGvAOLM1yqh1PJXDV7uEOvyuE6GKFQZHwxYJw4fajs3
        Axa1m0R1dUG8mD1OUgFnasRlFQOsu7tu4NrpejMq4uvEZ+5h/r1+/qUH0gkhEmZ3YbfFR3xYXvB1l
        kED1vgQw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jZJdf-0003fM-JH; Thu, 14 May 2020 19:35:27 +0000
Date:   Thu, 14 May 2020 12:35:27 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Christoph Hellwig' <hch@lst.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        'Joe Perches' <joe@perches.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jon Maloy <jmaloy@redhat.com>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] remove kernel_setsockopt and kernel_getsockopt
Message-ID: <20200514193527.GB16070@bombadil.infradead.org>
References: <20200513062649.2100053-1-hch@lst.de>
 <ecc165c33962d964d518c80de605af632eee0474.camel@perches.com>
 <756758e8f0e34e2e97db470609f5fbba@AcuMS.aculab.com>
 <20200514101838.GA12548@lst.de>
 <a76440f7305c4653877ff2abff499f4e@AcuMS.aculab.com>
 <20200514103450.GA12901@lst.de>
 <c2034daa0a23454abb5e5c5714807735@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2034daa0a23454abb5e5c5714807735@AcuMS.aculab.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 11:11:34AM +0000, David Laight wrote:
> From: 'Christoph Hellwig'
> > Sent: 14 May 2020 11:35
> > On Thu, May 14, 2020 at 10:26:41AM +0000, David Laight wrote:
> > > From: Christoph Hellwig
> > > > Only for those were we have users, and all those are covered.
> > >
> > > What do we tell all our users when our kernel SCTP code
> > > no longer works?
> > 
> > We only care about in-tree modules, just like for every other interface
> > in the kernel.
> 
> Even if our management agreed to release the code and the code
> layout matched the kernel guidelines you still wouldn't want
> two large drivers that implement telephony functionality
> for hardware that very few people actually have.

Oh, good point, we'll change the policy for all modules and make every
interface in the kernel stable from now on to cater to your special case.
