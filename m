Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E9513CDD5
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 21:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729877AbgAOULW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 15:11:22 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43833 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729442AbgAOULV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 15:11:21 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C96082222E;
        Wed, 15 Jan 2020 15:11:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 15 Jan 2020 15:11:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Hrs1us
        qs1mtZ1S12sxOORgd0r1wdct91FnDUKvIj+nA=; b=oBJCRmXV7YFh7UlTwB6juf
        Bb7NR+V7mgrTH6kghUygG6NQFxtmwzBKw2sppG/hUVCskw9ltutxvPLt38MOp6wa
        I29A1GIf6x8Y9myDqjnO7AqilgRllGrR7qH8Y9JEVgNivxUvQaeVxJJaruAry2QX
        T70M/w6YsjPd2AyMMD43EI7kJt0YcU23dDvMHC83CbUpLReThIsJtzoUBMzhUpVb
        Yapt1psci4+463nQqOtRbj8x/XVRRbtaF08VOaSVHz6zRogwYexsPJATfTZpJ6CW
        42MDECNDynlo8SbEtCMy0Q7bLYvGbLBYmkZ/TwhQax+qh0E7t5RLLII8039X/uqQ
        ==
X-ME-Sender: <xms:6HEfXm_fTpURRr-dEtckHn7ndJOrfx4NhWMXsITOqMI7PfUd7vH2DQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtdefgddufedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepjeejrd
    dufeekrddvgeelrddvtdelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:6HEfXls9MCxLjp_z-UBIUJLaFSXx6hqn3YPxYRchonLk40zRvvfZDg>
    <xmx:6HEfXkR5NNF91tUSf3AaWZchR2JSqHtEGAvllSB0EVBU2alWmn8Qzg>
    <xmx:6HEfXq3PbCC3mZvn6CAg6Tk3fYi2hcWjqofiuw9phlCRNHfXs2Gdzg>
    <xmx:6HEfXry7D9SODNNa052Zc-XSeAcbKQmTng7GMmPrwsyM9MgqhJzY-Q>
Received: from localhost (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id 17E3C30600A8;
        Wed, 15 Jan 2020 15:11:19 -0500 (EST)
Date:   Wed, 15 Jan 2020 22:11:07 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next] netdevsim: fix nsim_fib6_rt_create() error path
Message-ID: <20200115201107.GA1513116@splinter>
References: <20200115195741.86879-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115195741.86879-1-edumazet@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 11:57:41AM -0800, Eric Dumazet wrote:
> It seems nsim_fib6_rt_create() intent was to return
> either a valid pointer or an embedded error code.

...

> 
> Fixes: 48bb9eb47b27 ("netdevsim: fib: Add dummy implementation for FIB offload")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Ido Schimmel <idosch@mellanox.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>

Thanks, Eric.
