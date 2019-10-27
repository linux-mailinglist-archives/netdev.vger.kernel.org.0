Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AD3E6539
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 21:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfJ0UFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 16:05:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727235AbfJ0UFv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 16:05:51 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B71E2070B;
        Sun, 27 Oct 2019 20:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572206750;
        bh=CUyR3fuoRdKrJf9nZf1t8S4z237j7l+D00ncfqIoSsU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=agxvakRkTOgijn/qKghHaoBmSxLV42tfG+3mDaEYBQaWHZAkmKod8SYfXy4MpEWo6
         Dprkv23dHk6aJ3UmcpP4M8lhhTvS7xXEaYUcPvmJap/tZyHGkHa2Inqt5Kicypqv4d
         meAoiKQjcdHD9W3YcUkXv7dyo7Dh3OrLSJTGPLUs=
Date:   Sun, 27 Oct 2019 21:05:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     maowenan <maowenan@huawei.com>
Cc:     Ajay Kaher <akaher@vmware.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        srivatsab@vmware.com, srivatsa@csail.mit.edu, amakhalov@vmware.com,
        srinidhir@vmware.com, bvikas@vmware.com, anishs@vmware.com,
        vsirnapalli@vmware.com, srostedt@vmware.com
Subject: Re: [PATCH 4.9.y] Revert "net: sit: fix memory leak in
 sit_init_net()"
Message-ID: <20191027200547.GB2588299@kroah.com>
References: <1571216634-44834-1-git-send-email-akaher@vmware.com>
 <20191016183027.GC801860@kroah.com>
 <d0cbd39d-9fb7-dad8-b951-12aa299f13e8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0cbd39d-9fb7-dad8-b951-12aa299f13e8@huawei.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 09:48:05AM +0800, maowenan wrote:
> 
> 
> On 2019/10/17 2:30, Greg KH wrote:
> > On Wed, Oct 16, 2019 at 02:33:54PM +0530, Ajay Kaher wrote:
> >> This reverts commit 375d6d454a95ebacb9c6eb0b715da05a4458ffef which is
> >> commit 07f12b26e21ab359261bf75cfcb424fdc7daeb6d upstream.
> >>
> >> Unnecessarily calling free_netdev() from sit_init_net().
> >> ipip6_dev_free() of 4.9.y called free_netdev(), so no need
> >> to call again after ipip6_dev_free().
> >>
> >> Cc: Mao Wenan <maowenan@huawei.com>
> >> Cc: David S. Miller <davem@davemloft.net>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> Signed-off-by: Ajay Kaher <akaher@vmware.com>
> >> ---
> >>  net/ipv6/sit.c | 1 -
> >>  1 file changed, 1 deletion(-)
> >>
> >> diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
> >> index 47ca2a2..16eba7b 100644
> >> --- a/net/ipv6/sit.c
> >> +++ b/net/ipv6/sit.c
> >> @@ -1856,7 +1856,6 @@ static int __net_init sit_init_net(struct net *net)
> >>  
> >>  err_reg_dev:
> >>  	ipip6_dev_free(sitn->fb_tunnel_dev);
> >> -	free_netdev(sitn->fb_tunnel_dev);
> >>  err_alloc_dev:
> >>  	return err;
> >>  }
> >> -- 
> >> 2.7.4
> >>
> > 
> > Mao, are you ok with this change?
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Greg, ipip6_dev_free has already called free_netdev in stable 4.9.
> 
> Reviewed-by: Mao Wenan <maowenan@huawei.com>

Thanks, now queued up.

greg k-h
