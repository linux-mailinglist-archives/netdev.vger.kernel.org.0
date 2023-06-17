Return-Path: <netdev+bounces-11743-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A84A73420A
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 17:48:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0E6928163F
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 15:48:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF7AEAD5D;
	Sat, 17 Jun 2023 15:48:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40326FAE
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 15:48:27 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8C113E
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 08:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=1sfBM3XaQk3fVyLQwb6CKbm8it2hv6TBg/Eiksl0S54=; b=M9+i3KHbFW+o5z8AxCXV+SwuHh
	VEs50VjU2vt4IgK+GfewlrWUCTO3BJJ+sAs9BPAk1KZGzeSWQpf9KFWzgYOI+rxiE4/Mek2whyNHR
	oJ55fpfO6Dq21qurT+UeN3HsZqkkwSb6a+hdJr/253JZ/4FthqdjTFmGSBeDmH/mE3+I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qAY9x-00Go4W-6N; Sat, 17 Jun 2023 17:48:17 +0200
Date: Sat, 17 Jun 2023 17:48:17 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Lucas Stach <l.stach@pengutronix.de>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Wei Fang <wei.fang@nxp.com>, Shenwei Wang <shenwei.wang@nxp.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
	kernel@pengutronix.de, patchwork-lst@pengutronix.de
Subject: Re: [PATCH] net: fec: allow to build without PAGE_POOL_STATS
Message-ID: <cf2f001a-ffa3-4620-a657-bb6845ca17bf@lunn.ch>
References: <20230616191832.2944130-1-l.stach@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616191832.2944130-1-l.stach@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 09:18:32PM +0200, Lucas Stach wrote:
> Commit 6970ef27ff7f ("net: fec: add xdp and page pool statistics") selected
> CONFIG_PAGE_POOL_STATS from the FEC driver symbol, making it impossible
> to build without the page pool statistics when this driver is enabled. The
> help text of those statistics mentions increased overhead. Allow the user
> to choose between usefulness of the statistics and the added overhead.

Hi Lucas

Do you have any sort of numbers?

Object size should be easy to do.  How much difference does the #ifdef
CONFIG_PAGE_POOL_STATS make to the code segment? Those come with a
small amount of maintenance cost. And there does appear to be stubs
for when PAGE_POOL_STATS is disabled.

    Andrew

