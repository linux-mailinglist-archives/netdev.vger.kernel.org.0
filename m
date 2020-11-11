Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324BC2AF5F4
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 17:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgKKQPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 11:15:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:49830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgKKQPW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 11:15:22 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3DDD2074B;
        Wed, 11 Nov 2020 16:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605111321;
        bh=lww1r/gvxdzFjDsdtjnvj5YFCTgC/bm3wzYpOO9tRec=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HwhfcPYbU4CcL7uAApt2gcqv9+m4YwAuAXUs7O6BZeXU+UE3CtNcHpIlYeNS85YM6
         7pvL1EJTLWM8O5IcZyHXN5QVOhEGCkFePNOFA9e7d7ZduDPcVvdhSvqkkjESTwNi7o
         d9+pLrJRi+cQ31N9tRycN0vauwBfSYeTUNGawEAo=
Date:   Wed, 11 Nov 2020 08:15:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     tanhuazhong <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH V2 net-next 11/11] net: hns3: add debugfs support for
 interrupt coalesce
Message-ID: <20201111081520.670fc37f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <faf8854a-329d-8064-a832-02b08d3f5bad@huawei.com>
References: <1604892159-19990-1-git-send-email-tanhuazhong@huawei.com>
        <1604892159-19990-12-git-send-email-tanhuazhong@huawei.com>
        <20201110172858.5eddc276@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <faf8854a-329d-8064-a832-02b08d3f5bad@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 11:16:37 +0800 tanhuazhong wrote:
> On 2020/11/11 9:28, Jakub Kicinski wrote:
> > On Mon, 9 Nov 2020 11:22:39 +0800 Huazhong Tan wrote:  
> >> Since user may need to check the current configuration of the
> >> interrupt coalesce, so add debugfs support for query this info,
> >> which includes DIM profile, coalesce configuration of both software
> >> and hardware.
> >>
> >> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>  
> > 
> > Please create a file per vector so that users can just read it instead
> > of dumping the info into the logs.
> >   
> 
> This patch should be removed from this series right now. Since this new 
> read method needs some adaptations and verifications, and there maybe 
> another better ways to dump this info.
> 
> > Even better we should put as much of this information as possible into
> > the ethtool API. dim state is hardly hardware-specific.
> >   
> 
> Should the ethtool API used to dump the hardware info? Could you provide 
> some hints to do it?

Not necessarily hardware info but if there is a use case for inspecting
DIM state we can extend

coalesce_fill_reply() in net/ethtool/coalesce.c 

to report it.
