Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22A822B797
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 22:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgGWUWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 16:22:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:38746 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726686AbgGWUWx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 16:22:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8326AAB55;
        Thu, 23 Jul 2020 20:22:59 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 1D40A604C9; Thu, 23 Jul 2020 22:22:51 +0200 (CEST)
Date:   Thu, 23 Jul 2020 22:22:51 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     Chi Song <Song.Chi@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 net-next] net: hyperv: dump TX indirection table to
 ethtool regs
Message-ID: <20200723202251.vwh4xr7ogp72gcsg@lion.mk-sys.cz>
References: <alpine.LRH.2.23.451.2007222356070.2641@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
 <20200723193542.6vwu4cbokbihw3nh@lion.mk-sys.cz>
 <BL0PR2101MB09308AB4F78EA5B1B27B1CCBCA760@BL0PR2101MB0930.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL0PR2101MB09308AB4F78EA5B1B27B1CCBCA760@BL0PR2101MB0930.namprd21.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 07:55:20PM +0000, Haiyang Zhang wrote:
> > -----Original Message-----
> > From: Michal Kubecek <mkubecek@suse.cz>
> > Sent: Thursday, July 23, 2020 3:36 PM
> > To: Chi Song <Song.Chi@microsoft.com>
> > Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> > <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> > Wei Liu <wei.liu@kernel.org>; David S. Miller <davem@davemloft.net>; Jakub
> > Kicinski <kuba@kernel.org>; linux-hyperv@vger.kernel.org;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH v7 net-next] net: hyperv: dump TX indirection table to
> > ethtool regs
> > 
> > On Wed, Jul 22, 2020 at 11:59:09PM -0700, Chi Song wrote:
> > > An imbalanced TX indirection table causes netvsc to have low
> > > performance. This table is created and managed during runtime. To help
> > > better diagnose performance issues caused by imbalanced tables, it needs
> > > make TX indirection tables visible.
> > >
> > > Because TX indirection table is driver specified information, so
> > > display it via ethtool register dump.
> > 
> > Is the Tx indirection table really unique to netvsc or can we expect
> > other drivers to support similar feature? Also, would it make sense to
> > allow also setting the table with ethtool? (AFAICS it can be only set
> > from hypervisor at the moment.)
> 
> Currently, TX indirection table is only used by the Hyper-V synthetic NIC. I'm 
> not aware of any other NIC planning to use this.
> This table is created by host dynamically based on host side CPU usage, 
> and provided to the VM periodically. Our protocol doesn't let the guest side 
> to change it.

If host is expected to rewrite the table periodically, it would indeed
be of little use to set it on guest side. OK, let's do it as register
dump and see if someone else comes with similar feature.

Michal
