Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1106A5EF886
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 17:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235850AbiI2PTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 11:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235840AbiI2PTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 11:19:48 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1F7FD33;
        Thu, 29 Sep 2022 08:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=U7bbJF0jn65LRvA7kkp1q5XkbyDAHF1u73Vxz4VnaPA=; b=TNYpi3AnzfGkywcOp8kSjesbBz
        QBgo6A6sKjikfK3AsLDWfHNthnC0Vd6OwWM8O5Ahx8S2pCQpAKpJ1uvN2g+FDAFsE4YEZRv4kDguY
        izSXcqmUjgB+upm+9lhXY+4N2mXxydDkMqlUgYeJmE72ax2mZXoliWsUYZaAbeQQMr58=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1odvK1-000cyu-5O; Thu, 29 Sep 2022 17:19:33 +0200
Date:   Thu, 29 Sep 2022 17:19:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: Re: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
Message-ID: <YzW3hfyZAPvj58Tv@lunn.ch>
References: <20220928152509.141490-1-shenwei.wang@nxp.com>
 <YzT2An2J5afN1w3L@lunn.ch>
 <PAXPR04MB9185141B58499FD00C43BB6889579@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <YzWcI+U1WYJuZIdk@lunn.ch>
 <PAXPR04MB918545B92E493CB57CDE612B89579@PAXPR04MB9185.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PAXPR04MB918545B92E493CB57CDE612B89579@PAXPR04MB9185.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > I actually did some compare testing regarding the page pool for normal
> > > traffic.  So far I don't see significant improvement in the current
> > > implementation. The performance for large packets improves a little,
> > > and the performance for small packets get a little worse.
> > 
> > What hardware was this for? imx51? imx6? imx7 Vybrid? These all use the FEC.
> 
> I tested on imx8qxp platform. It is ARM64.

Please also test the older platforms. imx8 is quite powerful, so some
performance loss does not matter too much. But for the older systems,
i know people has spent a lot of time and effort optimising network
performance, and they will be unhappy if you make it slower.

> > By small packets, do you mean those under the copybreak limit?
> > 
> > Please provide some benchmark numbers with your next patchset.
> 

> Yes, the packet size is 64 bytes and it is under the copybreak
> limit. As the impact is not significant, I would prefer to remove
> the copybreak logic.

Lets look at the benchmark numbers, what you actually mean by not
significant, and across a range of hardware.

	     Andrew
