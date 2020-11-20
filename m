Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E41D2BAB6C
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgKTNjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:39:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41184 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726590AbgKTNjn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 08:39:43 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kg6dW-0087B0-Fl; Fri, 20 Nov 2020 14:39:38 +0100
Date:   Fri, 20 Nov 2020 14:39:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     tanhuazhong <tanhuazhong@huawei.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [RFC net-next 1/2] ethtool: add support for controling the type
 of adaptive coalescing
Message-ID: <20201120133938.GG1804098@lunn.ch>
References: <1605758050-21061-1-git-send-email-tanhuazhong@huawei.com>
 <1605758050-21061-2-git-send-email-tanhuazhong@huawei.com>
 <20201119041557.GR1804098@lunn.ch>
 <e43890d1-5596-3439-f4a7-d704c069a035@huawei.com>
 <20201119220203.fv2uluoeekyoyxrv@lion.mk-sys.cz>
 <8e9ba4c4-3ef4-f8bc-ab2f-92d695f62f12@huawei.com>
 <20201120072322.slrpgqydcupm63ep@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120072322.slrpgqydcupm63ep@lion.mk-sys.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 08:23:22AM +0100, Michal Kubecek wrote:
> On Fri, Nov 20, 2020 at 10:59:59AM +0800, tanhuazhong wrote:
> > On 2020/11/20 6:02, Michal Kubecek wrote:
> > > 
> > > We could use a similar approach as struct ethtool_link_ksettings, e.g.
> > > 
> > > 	struct kernel_ethtool_coalesce {
> > > 		struct ethtool_coalesce base;
> > > 		/* new members which are not part of UAPI */
> > > 	}
> > > 
> > > get_coalesce() and set_coalesce() would get pointer to struct
> > > kernel_ethtool_coalesce and ioctl code would be modified to only touch
> > > the base (legacy?) part.
> > >  > While already changing the ops arguments, we could also add extack
> > > pointer, either as a separate argument or as struct member (I slightly
> > > prefer the former).
> > 
> > If changing the ops arguments, each driver who implement
> > set_coalesce/get_coalesce of ethtool_ops need to be updated. Is it
> > acceptable adding two new ops to get/set ext_coalesce info (like
> > ecc31c60240b ("ethtool: Add link extended state") does)? Maybe i can send V2
> > in this way, and then could you help to see which one is more suitable?
> 
> If it were just this one case, adding an extra op would be perfectly
> fine. But from long term point of view, we should expect extending also
> other existing ethtool requests and going this way for all of them would
> essentially double the number of callbacks in struct ethtool_ops.

coccinella might be useful here.

	   Andrew
