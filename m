Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A9C18EC4F
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 21:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgCVUvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 16:51:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:51420 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726756AbgCVUvM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 16:51:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8E084AD3F;
        Sun, 22 Mar 2020 20:51:10 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id BCC1FE0FD3; Sun, 22 Mar 2020 21:51:09 +0100 (CET)
Date:   Sun, 22 Mar 2020 21:51:09 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ethtool: fix reference leak in some *_SET handlers
Message-ID: <20200322205109.GF31519@unicorn.suse.cz>
References: <20200322201551.E11BAE0FD3@unicorn.suse.cz>
 <20200322134356.55f7d9b8@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200322134356.55f7d9b8@kicinski-fedora-PC1C0HJN>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 22, 2020 at 01:43:56PM -0700, Jakub Kicinski wrote:
> On Sun, 22 Mar 2020 21:15:51 +0100 (CET) Michal Kubecek wrote:
> > Andrew noticed that some handlers for *_SET commands leak a netdev
> > reference if required ethtool_ops callbacks do not exist. A simple
> > reproducer would be e.g.
> > 
> >   ip link add veth1 type veth peer name veth2
> >   ethtool -s veth1 wol g
> >   ip link del veth1
> > 
> > Make sure dev_put() is called when ethtool_ops check fails.
> 
> Fixes: e54d04e3afea ("ethtool: set message mask with DEBUG_SET request")
> Fixes: a53f3d41e4d3 ("ethtool: set link settings with LINKINFO_SET request")
> Fixes: bfbcfe2032e7 ("ethtool: set link modes related data with LINKMODES_SET request")
> Fixes: 8d425b19b305 ("ethtool: set wake-on-lan settings with WOL_SET request")

Yes, thank you, I forgot about Fixes tags.

Should I resubmit or will patchworks pick the tags from your reply?

Michal

> > Reported-by: Andrew Lunn <andrew@lunn.ch>
> > Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
