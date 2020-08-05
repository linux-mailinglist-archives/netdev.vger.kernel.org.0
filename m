Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2383923CB7B
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 16:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbgHEO0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 10:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728021AbgHEMfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 08:35:39 -0400
X-Greylist: delayed 3285 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 05 Aug 2020 04:39:24 PDT
Received: from smtp.tuxdriver.com (tunnel92311-pt.tunnel.tserv13.ash1.ipv6.he.net [IPv6:2001:470:7:9c9::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E36FDC034603;
        Wed,  5 Aug 2020 04:39:20 -0700 (PDT)
Received: from [2605:a601:a627:ca00:664d:4b4b:674f:5257] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1k3Gu7-0002qe-90; Wed, 05 Aug 2020 06:44:16 -0400
Date:   Wed, 5 Aug 2020 06:44:09 -0400
From:   Neil Horman <nhorman@localhost.localdomain>
To:     David Miller <davem@davemloft.net>
Cc:     izabela.bakollari@gmail.com, nhorman@tuxdriver.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCHv2 net-next] dropwatch: Support monitoring of dropped
 frames
Message-ID: <20200805104409.GA118086@localhost.localdomain>
References: <20200707171515.110818-1-izabela.bakollari@gmail.com>
 <20200804160908.46193-1-izabela.bakollari@gmail.com>
 <20200804.161414.149428114422381017.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804.161414.149428114422381017.davem@davemloft.net>
X-Spam-Score: -2.0 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 04:14:14PM -0700, David Miller wrote:
> From: izabela.bakollari@gmail.com
> Date: Tue,  4 Aug 2020 18:09:08 +0200
> 
> > @@ -1315,6 +1334,53 @@ static int net_dm_cmd_trace(struct sk_buff *skb,
> >  	return -EOPNOTSUPP;
> >  }
> >  
> > +static int net_dm_interface_start(struct net *net, const char *ifname)
> > +{
> > +	struct net_device *nd = dev_get_by_name(net, ifname);
> > +
> > +	if (nd)
> > +		interface = nd;
> > +	else
> > +		return -ENODEV;
> > +
> > +	return 0;
> > +}
> > +
> > +static int net_dm_interface_stop(struct net *net, const char *ifname)
> > +{
> > +	dev_put(interface);
> > +	interface = NULL;
> > +
> > +	return 0;
> > +}
> 
> Where is the netdev notifier that will drop this reference if the network
> device is unregistered?
> 
See the changes to dropmon_net_event in the patch.  Its there under the case for
NETDEV_UNREGISTER

Neil
