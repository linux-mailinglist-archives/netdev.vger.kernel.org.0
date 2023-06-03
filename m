Return-Path: <netdev+bounces-7680-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 74B80721186
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 20:22:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED2491C20A75
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 18:22:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43670E54D;
	Sat,  3 Jun 2023 18:22:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CFD290B
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 18:22:36 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393ACC2
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 11:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=bCdM9rQtuInPfJnPyhXJ0qHCuMiQrwKX96J8638O3eY=; b=GTdxDBp/q4jti0HthgryfpeRTB
	1F1BeTjaPlZZA8ddid/FSQ8Nk0Nac6zTSw61uI+ylwL3Zsv6vefpJxv6XiR0hPDWSabZgyUvvCHex
	fYGuaUXgVo/Dvcw6wr5zBcK1iz2cNv1fkEu7UtRBRRlfvX/2K2duH48b4jGInKfwJizQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q5VtK-00ElU5-IX; Sat, 03 Jun 2023 20:22:18 +0200
Date: Sat, 3 Jun 2023 20:22:18 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: David Miller <davem@davemloft.net>
Cc: Russell King <rmk+kernel@armlinux.org.uk>, hkallweit1@gmail.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: sfp: fix state loss when updating state_hw_mask
Message-ID: <842907db-6450-4032-b0d6-a3de5b230258@lunn.ch>
References: <E1pd4VM-00DjWW-2N@rmk-PC.armlinux.org.uk>
 <167922421698.31905.11495733031560601244.git-patchwork-notify@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167922421698.31905.11495733031560601244.git-patchwork-notify@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Mar 19, 2023 at 11:10:16AM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net.git (main)
> by David S. Miller <davem@davemloft.net>:
> 
> On Fri, 17 Mar 2023 07:28:00 +0000 you wrote:
> > Andrew reports that the SFF modules on one of the ZII platforms do not
> > indicate link up due to the SFP code believing that LOS indicating that
> > there is no signal being received from the remote end, but in fact the
> > LOS signal is showing that there is signal.
> > 
> > What makes SFF modules different from SFPs is they typically have an
> > inverted LOS, which uncovered this issue. When we read the hardware
> > state, we mask it with state_hw_mask so we ignore anything we're not
> > interested in. However, we don't re-read when state_hw_mask changes,
> > leading to sfp->state being stale.
> > 
> > [...]
> 
> Here is the summary with links:
>   - [net] net: sfp: fix state loss when updating state_hw_mask
>     https://git.kernel.org/netdev/net/c/04361b8bb818

Hi David

This patch was submitted to net, and we can see it was also merged to
netdev/net.git. The Fixes tag of 8475c4b70b04 indicates the problem
was introduced in v6.1-rc1. Yet this fix does not appear in v6.1.31.

Do you have any idea why it has not been backported? It does cleanly
cherry-pick.

Thanks
	Andrew

