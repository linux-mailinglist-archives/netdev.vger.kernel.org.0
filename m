Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98902D1A86
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 21:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgLGU3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 15:29:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgLGU3t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 15:29:49 -0500
Date:   Mon, 7 Dec 2020 12:29:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607372949;
        bh=s17KF6Uf/kURCgouafNCRTkUDn9TuvUd4JRVtwPqQPg=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=X63zncDQCWNQejn/yaECX7MPrjZ7YtnWRXzLhGZZxmE7znW62ZX43qK22gUUTm9uL
         oHh+E9QQmlgL1FNnjH8l7QFInHVnbbf87QvLV1aUps7VRkuly6vKzUTb3gJAYEtEwx
         D45fPfFg74Gk0iQY+u7zLFMK0R8l3s+ZWPqQao/ZIYjqbKyZylSe9SC72EJn4oVAa/
         pmVA7EhE1HkWgkG0q4m0aATFxmefxaDJNmfCuJWENCVW1WAjGcZmHtH5kdAafQJN8w
         JuZ16ePmcuCzNfVcKkjjog9WeY7pGRHrjGIW4je5BWYA8zrAvzzk8WPxUQNDkKCP/Z
         Aj+JhqpCV4bxA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eran Ben Elisha <eranbe@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Tariq Toukan" <tariqt@nvidia.com>
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
Message-ID: <20201207122907.359796c0@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <43d6d07c-c75d-4a10-f49d-80f78ea07d39@nvidia.com>
References: <20201203042108.232706-1-saeedm@nvidia.com>
        <20201203042108.232706-9-saeedm@nvidia.com>
        <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <b761c676af87a4a82e3ea4f6f5aff3d1159c63e7.camel@kernel.org>
        <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <999c9328747d4edbfc8d2720b886aaa269e16df8.camel@kernel.org>
        <20201204151743.4b55da5c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <43d6d07c-c75d-4a10-f49d-80f78ea07d39@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 6 Dec 2020 15:36:38 +0200 Eran Ben Elisha wrote:
> On 12/5/2020 1:17 AM, Jakub Kicinski wrote:
> >> We only forward ptp traffic to the new special queue but we create more
> >> than one to avoid internal locking as we will utilize the tx softirq
> >> percpu.  
> > In other words to make the driver implementation simpler we'll have
> > a pretty basic feature hidden behind a ethtool priv knob and a number
> > of queues which doesn't match reality reported to user space. Hm.  
> 
> We are not hiding these queues from the netdev stack. We report them in 
> real num of TX queues and manage them as any other queue. The only 
> change is that select_queue() will select a stream to them if and only 
> if they match specific criteria.

Please read more carefully what you're replying to. That helps
communication and limits frustration quite a lot.

I said the queues are hidden behind the ethtool knob, as in they are
only instantiated when knob is turned from its default position.
Then you report to the stack that you have n+m queues, but in fact
there is only n queues that are of general use.
