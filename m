Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58485309457
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 11:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbhA3KUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 05:20:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232563AbhA3A2Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 19:28:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C5D26146D;
        Sat, 30 Jan 2021 00:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611966463;
        bh=Sn4hBFjsbIg/c6asYVsLB3c5VMRgZFN1G+ByjRzclrI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eUlKcTaQYMyXspQUqyqTAi/AfZMOn5sLrqlrmlWlXiQ4uG4uKXjaZ9JJO/AHRpMzG
         qAnCtzOR0bkoC+/QOWowW3LAVY+zHPDPBRIOMC6CU7Kre/mPjpBM9OqkvubFomvXo7
         V2TWIo/3iwLs3ynbtUfa8wm5D7DIWyA4CbkRtttFTYzeLv4hqo1C3cf1EWJJBZlKBQ
         plVR/WGTG43R4UZZESKxw4S4/fsFCwZpRrs5tCAt0ueqffDjDTliPMur54SzOSZelX
         UcA4ilVLFQza3WEx/SKmth5XMr6xOfeJAibthdUaanvOhYr4eGOQ96Zxwwn5YhshnN
         Fi1dTMaYA4BMA==
Date:   Fri, 29 Jan 2021 16:27:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v3 2/8] taprio: Add support for frame
 preemption offload
Message-ID: <20210129162742.6092753b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <878s8bs5fp.fsf@vcostago-mobl2.amr.corp.intel.com>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
        <20210122224453.4161729-3-vinicius.gomes@intel.com>
        <20210126000924.jjkjruzmh5lgrkry@skbuf>
        <87wnvvsayz.fsf@vcostago-mobl2.amr.corp.intel.com>
        <20210129135702.0f8cf702@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <878s8bs5fp.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 15:12:58 -0800 Vinicius Costa Gomes wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> >> Good catch :-)
> >> 
> >> I wanted to have this (at least one express queue) handled in a
> >> centralized way, but perhaps this should be handled best per driver.  
> >
> > Centralized is good. Much easier than reviewing N drivers to make sure
> > they all behave the same, and right.  
> 
> The issue is that it seems that not all drivers/hw have the same
> limitation: that at least one queue needs to be configured as
> express/not preemptible.

Oh, I thought that was something driven by the standard.
For HW specific checks driver doing it is obviously fine.

> That's the point I was trying to make when I suggested for the check to
> be done per-driver, different limitations.
