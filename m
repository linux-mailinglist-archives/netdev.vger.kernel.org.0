Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3311D3491D0
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhCYMXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:23:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46732 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230096AbhCYMWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 08:22:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lPP0i-00Cwms-0V; Thu, 25 Mar 2021 13:22:48 +0100
Date:   Thu, 25 Mar 2021 13:22:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, michael.chan@broadcom.com,
        damian.dybek@intel.com, paul.greenwalt@intel.com,
        rajur@chelsio.com, jaroslawx.gawin@intel.com, vkochan@marvell.com,
        alobakin@pm.me, snelson@pensando.io, shayagr@amazon.com,
        ayal@nvidia.com, shenjian15@huawei.com, saeedm@nvidia.com,
        mkubecek@suse.cz, roopa@nvidia.com
Subject: Re: [PATCH net-next 3/6] ethtool: fec: sanitize
 ethtool_fecparam->reserved
Message-ID: <YFyAl36ShF8mZbM8@lunn.ch>
References: <20210325011200.145818-1-kuba@kernel.org>
 <20210325011200.145818-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325011200.145818-4-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 06:11:57PM -0700, Jakub Kicinski wrote:
> struct ethtool_fecparam::reserved is never looked at by the core.
> Make sure it's actually 0. Unfortunately we can't return an error
> because old ethtool doesn't zero-initialize the structure for SET.

Hi Jakub

What makes it totally useless for future uses with SET. So the
documentation should probably be something like:

* @reserved: Reserved for future GET extensions.
*
* Older ethtool(1) leave @reserved uninitialised when calling SET or
* GET.  Hence it can only be used to return a value to userspace with
* GET. Currently the value returned is guaranteed to be zero.

The rest looks O.K.

    Andrew
