Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BDB2AFD39
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgKLBcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:32:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727913AbgKKX1e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 18:27:34 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 922342072E;
        Wed, 11 Nov 2020 23:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605137253;
        bh=y+kUScvAbvqHcf67AENkdfPkvk27gGrD0WRjIOrBvWs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c1my7h4j0VJa3iR9KZpi1XxPrUwk4JdttTRRBSQyubO5faoupx3Unhn2seYyBo8Q8
         sysE7XJU+6ll1NWy7ODYQzaJ4OuG6WipGWW40I6ufWJ7UHdOHbpwRNKpVJS5TPed08
         y/hQhetgZ+889366xolhVanbRV3INwCzjfAnI8PI=
Date:   Wed, 11 Nov 2020 15:27:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: 6352: parse VTU data
 before loading STU data
Message-ID: <20201111152732.6328f5be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201108223810.15266-1-tobias@waldekranz.com>
References: <20201108223810.15266-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  8 Nov 2020 23:38:10 +0100 Tobias Waldekranz wrote:
> On the 6352, doing a VTU GetNext op, followed by an STU GetNext op
> will leave you with both the member- and state- data in the VTU/STU
> data registers. But on the 6097 (which uses the same implementation),
> the STU GetNext will override the information gathered from the VTU
> GetNext.
> 
> Separate the two stages, parsing the result of the VTU GetNext before
> doing the STU GetNext.
> 
> We opt to update the existing implementation for all applicable chips,
> as opposed to creating a separate callback for 6097. Though the
> previous implementation did work for (at least) 6352, the datasheet
> does not mention the masking behavior.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
> 
> I was not sure if I should have created a separate callback, but I
> have not found any documentation that suggests that you can expect the
> STU GetNext op to mask the bits that are used to store VTU membership
> information in the way that 6352 does. So depending on undocumented
> behavior felt like something we would want to get rid of anyway.
> 
> Tested on 6097F and 6352.

I'm unclear what this fixes. What functionality is broken on 6097?
Can we identify the commit for a fixes tag?
