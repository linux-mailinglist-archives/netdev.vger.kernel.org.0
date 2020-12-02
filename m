Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC472CC2A7
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbgLBQpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:45:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:53894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbgLBQpJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 11:45:09 -0500
Date:   Wed, 2 Dec 2020 08:44:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606927468;
        bh=54ir8DuSHv2dVOcjfEpo5viW2Z4M6dDo8QXbDexZd1w=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=LNLYPSDUxrJtKxZSbUfkzpVpBlEc+LkKwUgOvzC6p4O6qDPzjyU14LYpRkSNCQtgC
         yiIN+Ag3USdKB4ttDZXyo7QDeTAnZacTtOwi8eNUTUZOfuxMBb9eG+BsnZJWPcqvfY
         NBNhQw+yBE1U3nM0+J2pphI/+qoIayEItpSruI6Y=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Karlsson <thomas.karlsson@paneda.se>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <jiri@resnulli.us>, <kaber@trash.net>, <edumazet@google.com>,
        <vyasevic@redhat.com>, <alexander.duyck@gmail.com>
Subject: Re: [PATCH net-next v3] macvlan: Support for high multicast packet
 rate
Message-ID: <20201202084427.0a3879a8@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <333d17ee-b01c-3286-bc7c-30d100b223ae@paneda.se>
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
        <147b704ac1d5426fbaa8617289dad648@paneda.se>
        <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <0c88607c-1b63-e8b5-8a84-14b63e55e8e2@paneda.se>
        <20201201111143.2a82d744@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <333d17ee-b01c-3286-bc7c-30d100b223ae@paneda.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Dec 2020 12:28:47 +0100 Thomas Karlsson wrote:
> >> +		if (vlan->bc_queue_len_requested > max_bc_queue_len_requested)
> >> +			max_bc_queue_len_requested = vlan->bc_queue_len_requested;
> >> +	}
> >> +	port->bc_queue_len_used = max_bc_queue_len_requested;
> >> +}
> >> +
> >>  static int macvlan_device_event(struct notifier_block *unused,
> >>  				unsigned long event, void *ptr)
> >>  {  
> 
> I also noticed I got a few line length warnings in patchworks but none when I ran the ./scrips/checkpatch.pl
> locally. So is the net tree using strict 80 chars? I would prefer not to introduce extra line breaks
> on those lines as I think it will hurt readability but of course I will if needed.

I run checkpatch with --max-line-length=80, I think the 80 char
limitation is quite reasonable and leads to more readable code.

In your case I'd do s/bc_queue_len_requested/bc_queue_len_req/.
But it's up to you.
