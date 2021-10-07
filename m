Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62898425543
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 16:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242037AbhJGOXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 10:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242050AbhJGOXt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 10:23:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FD3A610CC;
        Thu,  7 Oct 2021 14:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633616515;
        bh=hUbto/tiGNtxsnkPSLNntLOLmVddRNULNxTJLt9H9x4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OhfP+Hth5tZZIkXSCeMq+A6+KLNoNdbs9tU1n5ed5/Y55vOCRp/yMgEB7kMM2TJU/
         J+Itpmcegddolf69C/RLpZgLy4l2v5t/qgzqcWm9+zJmGoR4JP5dWqcgqJdfJJQl/7
         TsBj/V6P3bMOS8U1cjO0kxwD0Hs7ElsncevxKREqH29k5oxuxKxVKQ1j7bBu6GmDDx
         szZxntOsZIxZhCn+ti8ccAzuatgAzhRMkpHwNQnfY+7r5yWTjB//jMFGJXSGXbHqr6
         aHF2Jk1zz2epol+976OcmXR5qZKPWTrx7Q2XvKC9LoeYJqY+sdVmrG/e+jmDzvnRS4
         UicE3975lQNuA==
Date:   Thu, 7 Oct 2021 07:21:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>, davem@davemloft.net,
        netdev@vger.kernel.org, vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next 2/3] eth: platform: add a helper for loading
 netdev->dev_addr
Message-ID: <20211007072154.32de24dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YV7/0wqmxuuPB/yJ@lunn.ch>
References: <20211007132511.3462291-1-kuba@kernel.org>
        <20211007132511.3462291-3-kuba@kernel.org>
        <16f34ede9a885a443bb7c46255ee804f@walle.cc>
        <20211007065701.1ee88762@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YV7/0wqmxuuPB/yJ@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Oct 2021 16:10:27 +0200 Andrew Lunn wrote:
> On Thu, Oct 07, 2021 at 06:57:01AM -0700, Jakub Kicinski wrote:
> > > this eventually calls ether_addr_copy(), which has a note:
> > >    Please note: dst & src must both be aligned to u16.
> > > 
> > > Is this true for this addr on the stack?  
> > 
> > It will but I don't think there's anything in the standard that
> > requires it. Let me slap __aligned(2) on it to be sure.  
> 
> Hi Jakub
> 
> I though you changed ether_addr_copy() to be a memcpy?
> Or was that some other helper?

I changed eth_hw_addr_set(), I think Michael is referring to 
a ether_addr_copy() inside eth_platform_get_mac_address().
