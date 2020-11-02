Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EC52A3660
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 23:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgKBWUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 17:20:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:52564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbgKBWUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 17:20:42 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2100120786;
        Mon,  2 Nov 2020 22:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604355641;
        bh=RPnrsyxMAkztMhvusutWD4TqjQCquKiSwYb/vlIe3Gg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=peaRwy53vhIUeGizgjAikIlKSTfvxLSDemKEiiaCBJ8WYSP/eBkAKd8aYXFus2msc
         eLMVwTfEdhalqAt1tT6fINLZMD/foRO88k2iv+GDmIqvalVm8vkNX9h/pOyjR4nYdz
         AorXyOZH6SmpJD5ZDVWGEglJJLaEDCmjrOOq8W98=
Date:   Mon, 2 Nov 2020 14:20:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ti: cpsw: disable PTPv1 hw timestamping
 advertisement
Message-ID: <20201102142040.4c9decbe@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201101020227.GB2683@hoboy.vegasvil.org>
References: <20201029190910.30789-1-grygorii.strashko@ti.com>
        <20201031114042.7ccdf507@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201101020227.GB2683@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 19:02:27 -0700 Richard Cochran wrote:
> On Sat, Oct 31, 2020 at 11:40:42AM -0700, Jakub Kicinski wrote:
> > On Thu, 29 Oct 2020 21:09:10 +0200 Grygorii Strashko wrote:  
> > > The TI CPTS does not natively support PTPv1, only PTPv2. But, as it
> > > happens, the CPTS can provide HW timestamp for PTPv1 Sync messages, because
> > > CPTS HW parser looks for PTP messageType id in PTP message octet 0 which
> > > value is 0 for PTPv1. As result, CPTS HW can detect Sync messages for PTPv1
> > > and PTPv2 (Sync messageType = 0 for both), but it fails for any other PTPv1
> > > messages (Delay_req/resp) and will return PTP messageType id 0 for them.
> > > 
> > > The commit e9523a5a32a1 ("net: ethernet: ti: cpsw: enable
> > > HWTSTAMP_FILTER_PTP_V1_L4_EVENT filter") added PTPv1 hw timestamping
> > > advertisement by mistake, only to make Linux Kernel "timestamping" utility
> > > work, and this causes issues with only PTPv1 compatible HW/SW - Sync HW
> > > timestamped, but Delay_req/resp are not.
> > > 
> > > Hence, fix it disabling PTPv1 hw timestamping advertisement, so only PTPv1
> > > compatible HW/SW can properly roll back to SW timestamping.
> > > 
> > > Fixes: e9523a5a32a1 ("net: ethernet: ti: cpsw: enable HWTSTAMP_FILTER_PTP_V1_L4_EVENT filter")
> > > Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>  
> > 
> > CC: Richard  
> 
> Acked-by: Richard Cochran <richardcochran@gmail.com>

Applied, thanks!
