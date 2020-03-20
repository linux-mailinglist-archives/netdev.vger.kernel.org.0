Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC5F818D585
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 18:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgCTRQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 13:16:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgCTRQd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 13:16:33 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69DD320709;
        Fri, 20 Mar 2020 17:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584724592;
        bh=pA35YsYyEzh7J5AFrQ+55ycCcMb0kGjl2SvJtIqc/vE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=elcBt5UVGQVmY4n+ynRa71jo2zh+TtsQGqha1xdIrb3RDS54qCYOVCAkgq2hN2XCW
         s5fezh1wVbG/1IRw5bKOlMS2XgzWB+gfy6LHKTdQjp4cvFrlZgloAO1zjPa8DozsLt
         /Jr8wKN+KMVvsqpxe90UFnJ8ZJA+g03pzP6lghr4=
Date:   Fri, 20 Mar 2020 10:16:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 4/6] ionic: ignore eexist on rx filter add
Message-ID: <20200320101630.13d80223@kicinski-fedora-PC1C0HJN>
In-Reply-To: <e681ace5-bd70-4f7b-144f-3d5c0d140d12@pensando.io>
References: <20200320023153.48655-1-snelson@pensando.io>
        <20200320023153.48655-5-snelson@pensando.io>
        <20200319204358.7e141f1a@kicinski-fedora-PC1C0HJN>
        <e681ace5-bd70-4f7b-144f-3d5c0d140d12@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Mar 2020 22:21:35 -0700 Shannon Nelson wrote:
> On 3/19/20 8:43 PM, Jakub Kicinski wrote:
> > On Thu, 19 Mar 2020 19:31:51 -0700 Shannon Nelson wrote:  
> >> Don't worry if the rx filter add firmware request fails on
> >> EEXIST, at least we know the filter is there.  Same for
> >> the delete request, at least we know it isn't there.
> >>
> >> Fixes: 2a654540be10 ("ionic: Add Rx filter and rx_mode ndo support")
> >> Signed-off-by: Shannon Nelson <snelson@pensando.io>  
> > Why could the filter be there? Seems like the FW shouldn't have filters
> > the driver didn't add, could a flush/reset command help to start from
> > clean state?
> >
> > Just curious.  
> Because there are use cases where the device is configured by an 
> external centralized agent and may have already stuck the appropriate 
> filters into the its list.

Thanks, seems a little leaky for the host to be able to probe the state
installed by the agent, but it does explain the need.
