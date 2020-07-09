Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A52A2194D2
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 02:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgGIADp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 20:03:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:43796 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbgGIADo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 20:03:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 41DF9ADD6;
        Thu,  9 Jul 2020 00:03:44 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 5280B60567; Thu,  9 Jul 2020 02:03:43 +0200 (CEST)
Date:   Thu, 9 Jul 2020 02:03:43 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com
Subject: Re: [PATCH net-next 4/9] ethtool: add tunnel info interface
Message-ID: <20200709000343.k22d2kxaq3ix3o5i@lion.mk-sys.cz>
References: <20200707212434.3244001-1-kuba@kernel.org>
 <20200707212434.3244001-5-kuba@kernel.org>
 <20200708223224.rpaye4arndlz6c7h@lion.mk-sys.cz>
 <20200708163049.4414d7d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708163049.4414d7d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 08, 2020 at 04:30:49PM -0700, Jakub Kicinski wrote:
> > > +	ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY,		/* nest - _UDP_ENTRY_* */
> > > +
> > > +	/* add new constants above here */
> > > +	__ETHTOOL_A_TUNNEL_UDP_TABLE_CNT,
> > > +	ETHTOOL_A_TUNNEL_UDP_TABLE_MAX = (__ETHTOOL_A_TUNNEL_UDP_TABLE_CNT - 1)
> > > +};
> > > +
> > > +enum {
> > > +	ETHTOOL_A_TUNNEL_UDP_ENTRY_UNSPEC,
> > > +
> > > +	ETHTOOL_A_TUNNEL_UDP_ENTRY_PORT,		/* be16 */  
> > 
> > Do we get some benefit from passing the port in network byte order? It
> > would be helpful if we expected userspace to copy it e.g. into struct
> > sockaddr_in but that doesn't seem to be the case.

Let's leave it as be16 for consistency then.

> > How big can the message get? Can we be sure the information for one
> > device will always fit into a reasonably sized message? Attribute
> > ETHTOOL_A_TUNNEL_INFO_UDP_PORTS is limited by 65535 bytes (attribute
> > size is u16), can we always fit into this size?
> 
> I don't think I've seen any driver with more than 2 tables 
> or 16 entries total, and they don't seem to be growing in newer
> HW (people tend to use standard ports).
> 
> 188B + 16 * 20B = 508B - so we should be pretty safe with 64k.

So we are safe even if things grow by a factor of 100. Sounds good
enough, thanks.

Michal
