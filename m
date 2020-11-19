Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980B82B9D10
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 22:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbgKSVnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 16:43:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:54980 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726306AbgKSVnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 16:43:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4D4E7AC41;
        Thu, 19 Nov 2020 21:43:06 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 6D3C1603F9; Thu, 19 Nov 2020 22:43:05 +0100 (CET)
Date:   Thu, 19 Nov 2020 22:43:05 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Huazhong Tan <tanhuazhong@huawei.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [RFC net-next 1/2] ethtool: add support for controling the type
 of adaptive coalescing
Message-ID: <20201119214305.qjwlg7imqw46bltx@lion.mk-sys.cz>
References: <1605758050-21061-1-git-send-email-tanhuazhong@huawei.com>
 <1605758050-21061-2-git-send-email-tanhuazhong@huawei.com>
 <20201119041557.GR1804098@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119041557.GR1804098@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 05:15:57AM +0100, Andrew Lunn wrote:
> > diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
> > index e2bf36e..e3458d9 100644
> > --- a/include/uapi/linux/ethtool_netlink.h
> > +++ b/include/uapi/linux/ethtool_netlink.h
> > @@ -366,6 +366,7 @@ enum {
> >  	ETHTOOL_A_COALESCE_TX_USECS_HIGH,		/* u32 */
> >  	ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH,		/* u32 */
> >  	ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,	/* u32 */
> > +	ETHTOOL_A_COALESCE_USE_DIM,			/* u8 */
> 
> This appears to be a boolean? So /* flag */ would be better. Or do you
> think there is scope for a few different algorithms, and an enum would
> be better. If so, you should add the enum with the two current
> options.

NLA_FLAG would suffice for a read only bool attribute but if the
attribute is expected to be set, we need to distinguish three cases:
set to true, set to false and keep current value. That's why we use
NLA_U8 for read write bool attributes (0 false, anything else true and
attribute not present means leave untouched).

Michal
