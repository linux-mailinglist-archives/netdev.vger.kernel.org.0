Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78752D3558
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 22:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbgLHVf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 16:35:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:35554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgLHVf0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 16:35:26 -0500
Date:   Tue, 8 Dec 2020 13:34:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607463286;
        bh=anQ5zlsiUMWc0K5Z1tIkkFd7L2YfSKpo8LqBMrRGEPA=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Smuyd2xQ6OJv6aU31vQ6+il/6T2P81UyZhEIaxNjSPPDygiw/WeDOGDCbe35CEwWb
         KmYhcYfZh6GqqQ5uCaR8xDkIJtEdrIXsZakNztgWeLrar4mnY6J/qo5mTOLvG6cJIM
         XxMZ+oTHAq2HdkTdGdhIycWCnxzZKvjS+tLfHxSZ2dV5N9/bM8VlCcrxdmq+yJ4vMq
         sSX8g9im/ruO//6V8go8ktz/hTsENyomt3l+WNjb+bLvutT9+DM/E5CUHoBNRf7yCz
         xA8uSSoptpWFwUUbSlgcBhNvkvnm0Lx3v+ajlYFLkcask+N0zrnGGZEu2W7PTuF9ne
         xg3hUz5exZr+w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>, <davem@davemloft.net>,
        <sbhatta@marvell.com>
Subject: Re: [PATCH v2] octeontx2-pf: Add RSS multi group support
Message-ID: <20201208133444.62618a42@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201207161018.25127-1-gakula@marvell.com>
References: <20201207161018.25127-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Dec 2020 21:40:18 +0530 Geetha sowjanya wrote:
> Hardware supports 8 RSS groups per interface. Currently we are using
> only group '0'. This patch allows user to create new RSS groups/contexts
> and use the same as destination for flow steering rules.
> 
> usage:
> To steer the traffic to RQ 2,3
> 
> ethtool -X eth0 weight 0 0 1 1 context new
> (It will print the allocated context id number)
> New RSS context is 1
> 
> ethtool -N eth0 flow-type tcp4 dst-port 80 context 1 loc 1
> 
> To delete the context
> ethtool -X eth0 context 1 delete
> 
> When an RSS context is removed, the active classification
> rules using this context are also removed.
> 
> Change-log:
> v2
> - Removed unrelated whitespace
> - Coverted otx2_get_rxfh() to use new function.

Thanks, I gave otx2_get_rxfh() as an example, please also convert
otx2_set_rxfh().
