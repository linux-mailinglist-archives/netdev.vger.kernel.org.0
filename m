Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAE51B4861
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 17:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgDVPSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 11:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgDVPS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 11:18:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52849C03C1A9;
        Wed, 22 Apr 2020 08:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pYMMSN8qhxK9Rkme8UcFyi4WlSIE2Qxdgi21qfoUXzU=; b=aKOjeJ0EnyyUBEUDG+g8uMBCMN
        Z6szyzHcyTD5j+iI6i8Om8ipuaiO+0Rumq3HPRgleVpRRmsizL57viIfxH1LKC65p0/Bx4zJQRr5n
        shg+ispNIDtDBWB0bgwc9NNI6SzcUuo36IwRRylxJD6XinT+a/FnShF7L7vgJ+qQ6ym9ZYNR36Mcp
        JeXuW2v9NwqFxRSKlztPqjlLLBJBMokazFbW2ZCTdH5w70MJzwSnjAHwE/FokhDD8xoFAuoXFjy/i
        zHRC2a8lb/dwUwA4i8pZrk0jgufnPSR/9R4K0P3W8AQl6GxDBa6Xq8q/fW2MXv5+6PUhHh4xsuqtt
        jaSUEjXg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jRH8h-0007XY-UX; Wed, 22 Apr 2020 15:18:15 +0000
Date:   Wed, 22 Apr 2020 08:18:15 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Nate Karstens <nate.karstens@garmin.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-parisc@vger.kernel.org,
        sparclinux@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: Re: Implement close-on-fork
Message-ID: <20200422151815.GT5820@bombadil.infradead.org>
References: <20200420071548.62112-1-nate.karstens@garmin.com>
 <20200422150107.GK23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422150107.GK23230@ZenIV.linux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 04:01:07PM +0100, Al Viro wrote:
> On Mon, Apr 20, 2020 at 02:15:44AM -0500, Nate Karstens wrote:
> > Series of 4 patches to implement close-on-fork. Tests have been
> > published to https://github.com/nkarstens/ltp/tree/close-on-fork.
> > 
> > close-on-fork addresses race conditions in system(), which
> > (depending on the implementation) is non-atomic in that it
> > first calls a fork() and then an exec().
> > 
> > This functionality was approved by the Austin Common Standards
> > Revision Group for inclusion in the next revision of the POSIX
> > standard (see issue 1318 in the Austin Group Defect Tracker).
> 
> What exactly the reasons are and why would we want to implement that?
> 
> Pardon me, but going by the previous history, "The Austin Group Says It's
> Good" is more of a source of concern regarding the merits, general sanity
> and, most of all, good taste of a proposal.
> 
> I'm not saying that it's automatically bad, but you'll have to go much
> deeper into the rationale of that change before your proposal is taken
> seriously.

https://www.mail-archive.com/austin-group-l@opengroup.org/msg05324.html
might be useful
