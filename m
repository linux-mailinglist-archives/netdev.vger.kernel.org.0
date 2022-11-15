Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C523462A092
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 18:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiKORn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 12:43:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiKORn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 12:43:26 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED09BF2;
        Tue, 15 Nov 2022 09:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EjU9bcCXjwveYmZh/YpPwg4A3p0yA659OLTANrMlLc0=; b=trt0jheKKFxW3nR60Ke+vo6T9d
        1aQcpfJi7ZMCpc2GGJPQeJOyUzoAGTRPZLNLP6JUkh9d12s/2LkzvYwgfs6yMr56JEWiqDntwhqQu
        CW2DUmXd77xmhJq4gHizQ6GIqsXJbj8ZKa1vp8N6CriMPY5pNHEvoEf03h2jfqGEbdWc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ouzxh-002TzB-U1; Tue, 15 Nov 2022 18:43:05 +0100
Date:   Tue, 15 Nov 2022 18:43:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: Re: [EXT] Re: [PATCH v4 1/2] net: page_pool: export page_pool_stats
 definition
Message-ID: <Y3PPqVK1p+9vso8T@lunn.ch>
References: <20221115155744.193789-1-shenwei.wang@nxp.com>
 <20221115155744.193789-2-shenwei.wang@nxp.com>
 <Y3PIYg+VsuBxq5cW@lunn.ch>
 <PAXPR04MB9185EEE74B09159C18C0FBDD89049@PAXPR04MB9185.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PAXPR04MB9185EEE74B09159C18C0FBDD89049@PAXPR04MB9185.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I agree the API is broken, but i think there is a better fix.
> > 
> > There should be a stub of page_pool_get_stats() for when
> > CONFIG_PAGE_POOL_STATS is disabled.
> > 
> > Nothing actually dereferences struct page_pool_stats when you have this stub.
> > So it might be enough to simply have
> > 
> > struct page_pool_stats{
> > };
> > 
> 
> As the structure is open when the CONFIG_PAGE_POOL_STATS is enabled, you can not
> prevent a user to access its members. The empty stub will still have problems in this
> kind of situations.

The users, i.e. the driver, has no need to access its members. The
members can change, new ones can be added, and it will not cause a
problem, given the way this API is defined. Ideally, page_pool_stats
would of been an opaque cookie, but that is not how it was
implemented :-(

	    Andrew
