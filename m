Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898E734D024
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 14:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhC2Md0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 08:33:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52584 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230446AbhC2Mc7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 08:32:59 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lQr4U-00Dojl-R6; Mon, 29 Mar 2021 14:32:42 +0200
Date:   Mon, 29 Mar 2021 14:32:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, michael.chan@broadcom.com,
        damian.dybek@intel.com, paul.greenwalt@intel.com,
        rajur@chelsio.com, jaroslawx.gawin@intel.com, vkochan@marvell.com,
        alobakin@pm.me, snelson@pensando.io, shayagr@amazon.com,
        ayal@nvidia.com, shenjian15@huawei.com, saeedm@nvidia.com,
        mkubecek@suse.cz, roopa@nvidia.com
Subject: Re: [PATCH net-next 6/6] ethtool: clarify the ethtool FEC interface
Message-ID: <YGHI6ucPwFZDQE06@lunn.ch>
References: <20210325011200.145818-1-kuba@kernel.org>
 <20210325011200.145818-7-kuba@kernel.org>
 <435d5a68-95bf-81b6-2d29-75d2888e62cd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <435d5a68-95bf-81b6-2d29-75d2888e62cd@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 12:56:30PM +0100, Edward Cree wrote:
> On 25/03/2021 01:12, Jakub Kicinski wrote:
> > Drivers should reject mixing %ETHTOOL_FEC_AUTO_BIT with other
> > + * FEC modes, because it's unclear whether in this case other modes constrain
> > + * AUTO or are independent choices.
> 
> Does this mean you want me to spin a patch to sfc to reject this?
> Currently for us e.g. AUTO|RS means use RS if the cable and link partner
>  both support it, otherwise let firmware choose (presumably between BASER
>  and OFF) based on cable/module & link partner caps and/or parallel detect.
> We took this approach because our requirements writers believed that
>  customers would have a need for this setting; they called it "prefer FEC",
>  and I think the idea was to use FEC if possible (even on cables where the
>  IEEE-recommended default is no FEC, such as CA-25G-N 3m DAC) but allow
>  fallback to no FEC if e.g. link partner doesn't advertise FEC in AN.
> Similarly, AUTO|BASER ("prefer BASE-R FEC") might be desired by a user who
>  wants to use BASE-R if possible to minimise latency, but fall back to RS
>  FEC if the cable or link partner insists on it (eg CA-25G-L 5m DAC).
> Whether we were right and all this is actually useful, I couldn't say.

Jacub was talking about adding a netlink API as the next step. You
should feed this in as a requirement for that. Being able to express
preferences in the API in an explicitly documented way.

It there any other existing ethtool setting which could be used as a
model? EEE, master/slave? I would class pause as an anti model, that
is frequently done wrong :-(

       Andrew
