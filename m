Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FA01AD87B
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 10:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbgDQIZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 04:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729166AbgDQIZ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 04:25:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F94C207FC;
        Fri, 17 Apr 2020 08:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587111958;
        bh=fK/cXiYShdspx23uIMbNjC7y/u6N+6cfwWHvoDHM2e4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DCAbhgwue3ZLmVb8MV6QQ8lqfJm+5ZU4+vFl2rnTKJLniAByGIE8N5d5EeehJhHqB
         TzQtN5tB0leny2fS8bCR1574WzlOUQm340Twh7YSJ+O/clEmzKiotPbinBfiTKweAa
         gKwPDfOzuj2SP1cu8NTwZaelNQ53Qpf7EsSrH/+Q=
Date:   Fri, 17 Apr 2020 10:25:55 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200417082555.GA140064@kroah.com>
References: <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
 <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
 <20200414205755.GF1068@sasha-vm>
 <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
 <20200416000009.GL1068@sasha-vm>
 <CAJ3xEMjfWL=c=voGqV4pUCzWXmiTn-R6mrRi82UAVHMVysKU1g@mail.gmail.com>
 <20200416172001.GC1388618@kroah.com>
 <b8651ce6d7d6c6dcb8b2d66f07148413892b48d0.camel@mellanox.com>
 <20200416130828.1f35b6cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4a5bc4cf3225682e3d79590eeec1ae81774e3c2a.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a5bc4cf3225682e3d79590eeec1ae81774e3c2a.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 09:11:38PM +0000, Saeed Mahameed wrote:
> On Thu, 2020-04-16 at 13:08 -0700, Jakub Kicinski wrote:
> > On Thu, 16 Apr 2020 19:31:25 +0000 Saeed Mahameed wrote:
> > > > > IMHO it doesn't make any sense to take into stable
> > > > > automatically
> > > > > any patch that doesn't have fixes line. Do you have 1/2/3/4/5
> > > > > concrete
> > > > > examples from your (referring to your Microsoft employee hat
> > > > > comment
> > > > > below) or other's people production environment where patches
> > > > > proved to
> > > > > be necessary but they lacked the fixes tag - would love to see
> > > > > them.  
> > > > 
> > > > Oh wow, where do you want me to start.  I have zillions of these.
> > > > 
> > > > But wait, don't trust me, trust a 3rd party.  Here's what
> > > > Google's
> > > > security team said about the last 9 months of 2019:
> > > > 	- 209 known vulnerabilities patched in LTS kernels, most
> > > > without
> > > > 	  CVEs
> > > > 	- 950+ criticial non-security bugs fixes for device XXXX alone
> > > > 	  with LTS releases
> > > 
> > > So opt-in for these critical or _always_ in use basic kernel
> > > sections.
> > > but make the default opt-out.. 
> > 
> > But the less attentive/weaker the maintainers the more benefit from
> > autosel they get. The default has to be correct for the group which 
> > is more likely to take no action.
> 
> or the more exposed they are to false positives :), unnoticed bugs due
> to wrong patches getting backported.. this could go for years for less
> attentive weaker modules, until someone steps on it.

Bugs due to only a limited set of patches being backported are generally
very rare compared to the known bugs being present that are not fixed by
not backporting patches.

Play the odds, they are not in your favor at the moment :)

thanks,

greg k-h
