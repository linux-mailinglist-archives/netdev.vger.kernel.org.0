Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A59E2A5A82
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 00:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729780AbgKCXYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 18:24:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727688AbgKCXYg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 18:24:36 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E901B21556;
        Tue,  3 Nov 2020 23:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604445876;
        bh=wxohYSy+qpLg+pc770qckHg4FE50qyCIoxKqnrLUzFM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fNk53cZrZXrjKtNdmO9UWNI2rrqr9rfxv6dbXfPdh/4SeZ6vheqE4CeEy2QYORCEt
         1FQbUolgMUNwGszL1Uh5FJubWE/WgtdPZDEXRpUs7Ozsm4PZuR3QA4lL7P7sG/3bfW
         4nOZeaH6OYaMOOFAdsovTLH8cZPd8ygnXxLwfk4o=
Date:   Tue, 3 Nov 2020 15:24:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next] vxlan: Use a per-namespace nexthop listener
 instead of a global one
Message-ID: <20201103152435.71fe4b0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ca51f883-736e-f862-a3b2-5f6f34b99d4d@gmail.com>
References: <20201101113926.705630-1-idosch@idosch.org>
        <ca51f883-736e-f862-a3b2-5f6f34b99d4d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Nov 2020 18:45:10 -0700 David Ahern wrote:
> On 11/1/20 4:39 AM, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > The nexthop notification chain is a per-namespace chain and not a global
> > one like the netdev notification chain.
> > 
> > Therefore, a single (global) listener cannot be registered to all these
> > chains simultaneously as it will result in list corruptions whenever
> > listeners are registered / unregistered.
> > 
> > Instead, register a different listener in each namespace.
> > 
> > Currently this is not an issue because only the VXLAN driver registers a
> > listener to this chain, but this is going to change with netdevsim and
> > mlxsw also registering their own listeners.
> > 
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>

Applied, thanks!
