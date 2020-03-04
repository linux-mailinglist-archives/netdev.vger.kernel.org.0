Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8278717932D
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 16:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbgCDPUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 10:20:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:55728 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727930AbgCDPUH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 10:20:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 79E97ABCF;
        Wed,  4 Mar 2020 15:20:01 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 7AA04E037F; Wed,  4 Mar 2020 16:19:58 +0100 (CET)
Date:   Wed, 4 Mar 2020 16:19:58 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net, thomas.lendacky@amd.com, benve@cisco.com,
        _govind@gmx.com, pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org
Subject: Re: [PATCH net-next 01/12] ethtool: add infrastructure for
 centralized checking of coalescing parameters
Message-ID: <20200304151958.GI4264@unicorn.suse.cz>
References: <20200304035501.628139-1-kuba@kernel.org>
 <20200304035501.628139-2-kuba@kernel.org>
 <20200304145439.GC3553@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304145439.GC3553@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 03:54:39PM +0100, Andrew Lunn wrote:
> On Tue, Mar 03, 2020 at 07:54:50PM -0800, Jakub Kicinski wrote:
> > @@ -2336,6 +2394,11 @@ ethtool_set_per_queue_coalesce(struct net_device *dev,
> >  			goto roll_back;
> >  		}
> >  
> > +		if (!ethtool_set_coalesce_supported(dev, &coalesce)) {
> > +			ret = -EINVAL;
> > +			goto roll_back;
> > +		}
> 
> Hi Jakub
> 
> EOPNOTSUPP? 

Out of the 11 drivers patched in the rest of the series, 4 used
EOPNOTSUPP, 3 EINVAL and 4 just ignored unsupported parameters so there
doesn't seem to be a clear consensus. Personally I find EOPNOTSUPP more
appropriate but it's quite common that drivers return EINVAL for
parameters they don't understand or support.

BtW, there is a v2 later.

Michal
