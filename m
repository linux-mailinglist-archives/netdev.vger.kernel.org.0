Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545B334964D
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhCYQDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229871AbhCYQCf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 12:02:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCEFA61A11;
        Thu, 25 Mar 2021 16:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616688155;
        bh=BnQwbsAgeN90HxwDtj63JygAOPsd3Rl1rpXtzOV9l+E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B+qp0h6wpKskfBwX4hB4P5j7eKdFKulJHo4gRn0GnkYByksS8jL3YxQNRM8wB0Q4g
         vjjz5mr4hVKaBwqxt1YmaymDxZF6bjsqCchDiz13uzaQ7P0rlr+BfS0e7rB4/YpNQO
         k+iN2KqxBiuTs9bqMqmMIX0caerYSP4gIQLV2vUkapCxQZNGM+h2T7DrPAovKBa4T0
         SKxTt3o+qZ63dbTdGWS+fn+RKbLmfLC9r1yEVco/RZlnd2Ft1WUVocUkgILdqRiJL0
         2oG/TLCdNyEUucocF6iQhwL/ytW0b/H2FZ/sJe8BNggGvoMGwLCZdyScMIoWOF712O
         C0AYzh/H21kFg==
Date:   Thu, 25 Mar 2021 09:02:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, michael.chan@broadcom.com,
        damian.dybek@intel.com, paul.greenwalt@intel.com,
        rajur@chelsio.com, jaroslawx.gawin@intel.com, vkochan@marvell.com,
        alobakin@pm.me, snelson@pensando.io, shayagr@amazon.com,
        ayal@nvidia.com, shenjian15@huawei.com, saeedm@nvidia.com,
        mkubecek@suse.cz, roopa@nvidia.com
Subject: Re: [PATCH net-next 3/6] ethtool: fec: sanitize
 ethtool_fecparam->reserved
Message-ID: <20210325090233.3128075f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YFyAl36ShF8mZbM8@lunn.ch>
References: <20210325011200.145818-1-kuba@kernel.org>
        <20210325011200.145818-4-kuba@kernel.org>
        <YFyAl36ShF8mZbM8@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Mar 2021 13:22:47 +0100 Andrew Lunn wrote:
> On Wed, Mar 24, 2021 at 06:11:57PM -0700, Jakub Kicinski wrote:
> > struct ethtool_fecparam::reserved is never looked at by the core.
> > Make sure it's actually 0. Unfortunately we can't return an error
> > because old ethtool doesn't zero-initialize the structure for SET.  
> 
> Hi Jakub
> 
> What makes it totally useless for future uses with SET. So the
> documentation should probably be something like:
> 
> * @reserved: Reserved for future GET extensions.
> *
> * Older ethtool(1) leave @reserved uninitialised when calling SET or
> * GET.  Hence it can only be used to return a value to userspace with
> * GET. Currently the value returned is guaranteed to be zero.
> 
> The rest looks O.K.

I didn't spell this out because we'll move to netlink as next
step so the ioctl structure is less relevant, but will do!
