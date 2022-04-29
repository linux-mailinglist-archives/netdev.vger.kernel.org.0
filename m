Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59123513FDC
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 02:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353604AbiD2BAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 21:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345344AbiD2BAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 21:00:11 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DE94FC4E;
        Thu, 28 Apr 2022 17:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=NDXFJRM7G+3xMHDd/nLJHZ8nkgsa89rne//SVuZyCYw=; b=n3yQheLliCunMagcTCQKTn1N/Q
        7GFgv+RtxaFd3YXqdZqpmmiEGCJQVgu8UQoCdnCTKz3/jWNiAJTMML6sS40ZyckLIaovXw5ZqOaFh
        3FuFSCziyZtxnwXhC3VsplJ7nNdEaZbIZD2yp0ILc7WsAZmvsmDjke4nckGHClTOFy9Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkEw6-000Owc-G4; Fri, 29 Apr 2022 02:56:42 +0200
Date:   Fri, 29 Apr 2022 02:56:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jianqun Xu <jay.xu@rock-chips.com>
Cc:     kuba@kernel.org, davem@davemloft.net, joabreu@synopsys.com,
        alexandre.torgue@st.com, peppe.cavallaro@st.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH V2] ethernet: stmmac: support driver work for DTs without
 child queue node
Message-ID: <Yms3ynT8RGmldAkm@lunn.ch>
References: <20220428010927.526310-1-jay.xu@rock-chips.com>
 <20220429004605.1010751-1-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220429004605.1010751-1-jay.xu@rock-chips.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 08:46:05AM +0800, Jianqun Xu wrote:
> The driver use the value of property 'snps,rx-queues-to-use' to loop
> same numbers child nodes as queues, such as:
> 
>     gmac {
>         rx-queues-config {
>             snps,rx-queues-to-use = <1>;
>             queue0 {
>                 // nothing need here.
> 	    };
> 	};
>     };
> 
> Since a patch for dtc from rockchip will delete all node without any
> properties or child node, the queue0 node will be deleted, that caused
> the driver fail to probe:

Is this the in tree dtc? Do you have a commit hash for it? That should
probably be used as a Fixes: tag. Or that change to dtc needs
reverting because it breaks stuff.

	  Andrew
