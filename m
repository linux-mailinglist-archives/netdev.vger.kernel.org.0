Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898783BEA27
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 16:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhGGO7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 10:59:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44600 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232158AbhGGO7U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 10:59:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ozqjo23XDuJtwPCl6/VAR5AvRQRfRAP7QUcvNp2ZFp0=; b=GbljNL05qZJgr33DtPFXT1vioW
        lZmYvGrIzcpCLl+vaKHCkvw4ZCDxnfe13Lg0ssPfecHvset9QecAi7NynCXLh7Nqb3v1WDesnJ3nM
        uGvqw38u58X948GQVMCoaXc6KGo9FruGm40kHxb0XmgXJWOkRMCknS+o4C+OIynZQmGk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m18yP-00CWwo-2s; Wed, 07 Jul 2021 16:56:25 +0200
Date:   Wed, 7 Jul 2021 16:56:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Callum Sinclair <Callum.Sinclair@alliedtelesis.co.nz>
Cc:     "dsahern@kernel.org" <dsahern@kernel.org>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.luessing@c0d3.blue" <linus.luessing@c0d3.blue>
Subject: Re: [PATCH] net: Allow any address multicast join for IP sockets
Message-ID: <YOXAmZXIPukotquk@lunn.ch>
References: <20210706011548.2201-1-callum.sinclair@alliedtelesis.co.nz>
 <YORaY83GiD56/su0@lunn.ch>
 <1625623229789.98509@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1625623229789.98509@alliedtelesis.co.nz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 07, 2021 at 02:00:29AM +0000, Callum Sinclair wrote:
> Hi Andrew
> 
> Yes I want to receive all multicast frames.This is to configure
> a userspace switch driver to prevent unknown multicast
> routes being flooded unexpectedly to all switch ports.

Don't you just need the signalling, not the data?

Also, netdev is not friendly to user space switch drivers. You should
be using an in kernel switch driver. So we are unlikely to add an API
which is only going to be used by a user space switch driver. If you
provide patches to mrouted, or frr pim routing daemon which makes use
of this new API, it might get accepted, and then you can also use it
in your user space switch driver as well. Otherwise, i would suggest
you keep to the existing APIs, BPF and pcap for example.

   Andrew
