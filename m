Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6967518EC69
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 22:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgCVVGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 17:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbgCVVGZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 17:06:25 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC45920658;
        Sun, 22 Mar 2020 21:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584911185;
        bh=tRJ4p7lKYiN6wX+ALChAuCV0TylJs+y6wN/8sB1COwo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gT6DVqwXG6yLiPzou40rj+Z1VEwlqihyMU06pRPfCfRyUk1ddJn3Gk4H87N47oTm+
         Zy8pT0eVNZu0wu3040m8kefDmZeanKVdGIVN9DImzZYxpffMlY3gFf+5NLU0fs0naU
         97Wb0Y8d+71NvFeK37zooQERZcA2i7z7pU8sVi2Q=
Date:   Sun, 22 Mar 2020 14:06:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ethtool: fix reference leak in some *_SET handlers
Message-ID: <20200322140623.633d3446@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200322205109.GF31519@unicorn.suse.cz>
References: <20200322201551.E11BAE0FD3@unicorn.suse.cz>
        <20200322134356.55f7d9b8@kicinski-fedora-PC1C0HJN>
        <20200322205109.GF31519@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Mar 2020 21:51:09 +0100 Michal Kubecek wrote:
> On Sun, Mar 22, 2020 at 01:43:56PM -0700, Jakub Kicinski wrote:
> > On Sun, 22 Mar 2020 21:15:51 +0100 (CET) Michal Kubecek wrote:  
> > > Andrew noticed that some handlers for *_SET commands leak a netdev
> > > reference if required ethtool_ops callbacks do not exist. A simple
> > > reproducer would be e.g.
> > > 
> > >   ip link add veth1 type veth peer name veth2
> > >   ethtool -s veth1 wol g
> > >   ip link del veth1
> > > 
> > > Make sure dev_put() is called when ethtool_ops check fails.  
> > 
> > Fixes: e54d04e3afea ("ethtool: set message mask with DEBUG_SET request")
> > Fixes: a53f3d41e4d3 ("ethtool: set link settings with LINKINFO_SET request")
> > Fixes: bfbcfe2032e7 ("ethtool: set link modes related data with LINKMODES_SET request")
> > Fixes: 8d425b19b305 ("ethtool: set wake-on-lan settings with WOL_SET request")  
> 
> Yes, thank you, I forgot about Fixes tags.
> 
> Should I resubmit or will patchworks pick the tags from your reply?

Patchwork sees them, I think, but I don't think it adds them to the
patch as downloaded by git-pw. Probably easiest to repost.

> > > Reported-by: Andrew Lunn <andrew@lunn.ch>
> > > Signed-off-by: Michal Kubecek <mkubecek@suse.cz>  
> > 
> > Reviewed-by: Jakub Kicinski <kuba@kernel.org>  

