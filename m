Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B1B1D9FC3
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 20:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgESSnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 14:43:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbgESSnp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 14:43:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AE74207D3;
        Tue, 19 May 2020 18:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589913825;
        bh=t0V7sRQBTN6xmjvm4XJ02g4tMoK119eArIOfsK3lGMA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=v9ZxN+gIpenydRDk4w0Uf9BTfRzfc11ZwGkogzyjxgRH6ug9RBGxNZ0pl+gp3YRGo
         I87o8qlSJgOYnamTFJguqCIf9tVb7fX2oSFXHraf4A1SsThcqovfNkXzpGlHT2iBj4
         gEKIMKBK5SIuU28auQ2cCO0mBOjgJEs385xX0jKs=
Date:   Tue, 19 May 2020 11:43:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Message-ID: <20200519114342.331ff0f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <VI1PR0402MB387101A0B3D3382B08DBE07CE0B90@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200515184753.15080-1-ioana.ciornei@nxp.com>
        <20200515122035.0b95eff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387165B351F0DF0FA1E78BF4E0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515124059.33c43d03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB3871F0358FE1369A2F00621DE0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515152500.158ca070@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB38719FE975320D9E0E47A6F9E0BA0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200518123540.3245b949@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387101A0B3D3382B08DBE07CE0B90@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 May 2020 07:38:57 +0000 Ioana Ciornei wrote:
> > Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic classes
> > 
> > On Sat, 16 May 2020 08:16:47 +0000 Ioana Ciornei wrote:  
> > > > With the Rx QoS features users won't even be able to tell via
> > > > standard Linux interfaces what the config was.  
> > >
> > > Ok, that is true. So how should this information be exported to the user?  
> > 
> > I believe no such interface currently exists.  
> 
> I am having a bit of trouble understanding what should be the route
> for this feature to get accepted.

What's the feature you're trying to get accepted? Driver's datapath to
behave correctly when some proprietary out-of-tree API is used to do the
actual configuration? Unexciting.

> Is the problem having the classification to a TC based on the VLAN
> PCP or is there anything else?

What you have is basically RX version of mqprio, right? Multiple rings
per "channel" each gets frames with specific priorities? This needs to
be well integrated with the rest of the stack, but I don't think TC
qdisc offload is a fit. Given we don't have qdiscs on ingress. As I
said a new API for this would most likely have to be created.
