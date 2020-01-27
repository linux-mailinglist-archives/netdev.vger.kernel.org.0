Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD1D7149EFC
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 07:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgA0GY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 01:24:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:48196 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgA0GY7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 01:24:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 608F3AE09;
        Mon, 27 Jan 2020 06:24:57 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id A1530E0B78; Mon, 27 Jan 2020 07:24:56 +0100 (CET)
Date:   Mon, 27 Jan 2020 07:24:56 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/7] ethtool: set message mask with DEBUG_SET
 request
Message-ID: <20200127062456.GC570@unicorn.suse.cz>
References: <cover.1580075977.git.mkubecek@suse.cz>
 <844bf6bf518640fbfc67b5dd7976d9e8683c2d2d.1580075977.git.mkubecek@suse.cz>
 <20200127010422.GD12816@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127010422.GD12816@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 02:04:22AM +0100, Andrew Lunn wrote:
> > +	ret = ethnl_parse_header(&req_info, tb[ETHTOOL_A_DEBUG_HEADER],
> > +				 genl_info_net(info), info->extack, true);
> 
> > +	dev_put(dev);
> 
> Hi Michal
> 
> While reviewing this patch i noticed this dev_put() and wondered where
> the dev_get() was. It is hiding inside ethnl_parse_header(). The
> documentation does make it clear it takes a reference on the device,
> but how many people read the documentation? I would not be too
> surprised if at some point in the future we have bugs from missing
> dev_put().
> 
> Could we make this a bit more explicit by calling it
> ethnl_parse_header_dev_get(). It is rather long though.

Good point, I'll think about the name some more and send a cleanup patch
when net-next reopens.

Michal
