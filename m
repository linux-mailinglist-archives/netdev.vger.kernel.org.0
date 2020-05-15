Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A0D1D5C5A
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgEOWZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:25:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbgEOWZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 18:25:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 178A420643;
        Fri, 15 May 2020 22:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589581502;
        bh=mVfojW+lrKb3iDqalblrTeKaVFrg1WCcPkwAYC0tkrM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Frx8uXkdhtm2KjB/FfrJAU0h/w3cGfLKUDedPEOqzUfdKvr+R2CFQ/j/Xu9AenPT8
         tChcOkUfGGqT0CvizMnVkFxMEXVPg5qqSNPAN8pgqBfSmmN6+K1mvjpiJfvchWOGb2
         qeYRAiyJRa5jK0Vf3BD+eE3kOXV8ZPXCklGL4u8o=
Date:   Fri, 15 May 2020 15:25:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Message-ID: <20200515152500.158ca070@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <VI1PR0402MB3871F0358FE1369A2F00621DE0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200515184753.15080-1-ioana.ciornei@nxp.com>
        <20200515122035.0b95eff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387165B351F0DF0FA1E78BF4E0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515124059.33c43d03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB3871F0358FE1369A2F00621DE0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 May 2020 20:48:27 +0000 Ioana Ciornei wrote:
> > > There is no input taken from the user at the moment. The traffic class
> > > id is statically selected based on the VLAN PCP field. The
> > > configuration for this is added in patch 3/7.  
> > 
> > Having some defaults for RX queue per TC is understandable. But patch 1
> > changes how many RX queues are used in the first place. Why if user does not
> > need RX queues per TC?  
> 
> In DPAA2 we have a boot time configurable system in which the user can select
> for each interface how many queues and how many traffic classes it needs.

Looking at the UG online DPNI_CREATE has a NUM_RX_TCS param. You're not
using that for the kernel driver?

> The driver picks these up from firmware and configures the traffic class
> distribution only if there is more than one requested.
> With one TC the behavior of the driver is exactly as before.

This configuring things statically via some direct FW interface when
system boots really sounds like a typical "using Linux to boot a
proprietary networking stack" scenario.

With the Rx QoS features users won't even be able to tell via standard
Linux interfaces what the config was.

