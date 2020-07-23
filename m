Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB0222B6D0
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 21:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgGWTfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 15:35:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:53050 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgGWTfo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 15:35:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DCBC3AB89;
        Thu, 23 Jul 2020 19:35:50 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 5C59B604C9; Thu, 23 Jul 2020 21:35:42 +0200 (CEST)
Date:   Thu, 23 Jul 2020 21:35:42 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Chi Song <chisong@microsoft.com>
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 net-next] net: hyperv: dump TX indirection table to
 ethtool regs
Message-ID: <20200723193542.6vwu4cbokbihw3nh@lion.mk-sys.cz>
References: <alpine.LRH.2.23.451.2007222356070.2641@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.23.451.2007222356070.2641@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 11:59:09PM -0700, Chi Song wrote:
> An imbalanced TX indirection table causes netvsc to have low
> performance. This table is created and managed during runtime. To help
> better diagnose performance issues caused by imbalanced tables, it needs
> make TX indirection tables visible.
> 
> Because TX indirection table is driver specified information, so
> display it via ethtool register dump.

Is the Tx indirection table really unique to netvsc or can we expect
other drivers to support similar feature? Also, would it make sense to
allow also setting the table with ethtool? (AFAICS it can be only set
from hypervisor at the moment.)

It kind of feels that the actual reason for using register dump was that
it's there and it was easy to use rather than that the information would
logically belong there. We already have a specific interface for getting
and seting receive indirection table; perhaps it would make sense to
have also one for the transmit indirection table.

Michal
