Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75A7C83780
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733009AbfHFRAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732729AbfHFRAx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 13:00:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 849F420578;
        Tue,  6 Aug 2019 17:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565110852;
        bh=KjoROOZ47TPJTAJYZltLMVR1qeSiPJPrOcZd+il1Jok=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VybcV06C/AEtsp3xnx4YHHMMQ5PynKaXrSXfi9ZRCrHgDpWr7YbaHC+nU+8vQbtGu
         iNJdd8JgYfuRKbIWISEeHbIfNFmOVbzpU2guTgCpxmOR8cd6lNGpYgmQ+GVwf6yJ9A
         H6S+Rvkm55Rp86veDppsVb0R8SgqFgyQAGfiyLtM=
Date:   Tue, 6 Aug 2019 19:00:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Edwin Peer <edwin.peer@netronome.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        oss-drivers@netronome.com
Subject: Re: [PATCH 08/17] nfp: no need to check return value of
 debugfs_create functions
Message-ID: <20190806170049.GA12269@kroah.com>
References: <20190806161128.31232-1-gregkh@linuxfoundation.org>
 <20190806161128.31232-9-gregkh@linuxfoundation.org>
 <20190806095008.57007f2f@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806095008.57007f2f@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 06, 2019 at 09:50:08AM -0700, Jakub Kicinski wrote:
> On Tue,  6 Aug 2019 18:11:19 +0200, Greg Kroah-Hartman wrote:
> > When calling debugfs functions, there is no need to ever check the
> > return value.  The function can work or not, but the code logic should
> > never do something different based on this.
> > 
> > Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Edwin Peer <edwin.peer@netronome.com>
> > Cc: Yangtao Li <tiny.windzz@gmail.com>
> > Cc: Simon Horman <simon.horman@netronome.com>
> > Cc: oss-drivers@netronome.com
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> 
> I take it this is the case since commit ff9fb72bc077 ("debugfs: return
> error values, not NULL")? I.e. v5.0? It'd be useful to know for backport
> purposes.

You were always safe to ignore debugfs calls before that, but in 5.0 and
then 5.2 we got a bit more "robust" with some internal debugfs logic to
make it even easier.  These can be backported to 2.6.11+ if you really
want to, no functionality should change.

But why would you want to backport them?  This really isn't a "bugfix"
for a stable kernel.  No one should ever noticed the difference except
for less memory being used.

thanks,

greg k-h
