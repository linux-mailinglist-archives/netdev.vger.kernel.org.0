Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA99767921D
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 08:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbjAXHiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 02:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjAXHiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 02:38:04 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF185FC4;
        Mon, 23 Jan 2023 23:38:03 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 54200320094B;
        Tue, 24 Jan 2023 02:37:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 24 Jan 2023 02:38:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1674545878; x=1674632278; bh=FGL4rvaE9HrAhK3uR60Bja3Q3YqT
        7eV6rbw/0OzNS1s=; b=JCL9nF/J049eFQ2+y9NYHILehtNZU1JF+BewOJp4nHFq
        WqRrRF1eBB2Bb1PAGjD2SILTgWBl/pnupk41zM3tiSt+7IF64ChM36Wr1GrFFuW1
        g7FEjW/rkBUvgmgPfjrUyB76n9VHknz3f6r2ZWQJLUktTElGm+P7DTTdOjV3tqac
        NNMVP6vEgblnNQSm8D92vvQyONNIHVFxWqJo5lMaahYzUwvGRoC773DRtVTPXANH
        4iVJg8Fjl1nyLl6+FkSXDYl4ZqkekOGRvS0q/vQTAO/fBABk4ftRTP/2RcicTPBI
        Q6FpNWzaNF3ozNljR81mHlX78RRQoyGKXWcmwWW0Zw==
X-ME-Sender: <xms:1orPY8_qLClK_j0UiPIF49KyaZl_C72C1WWkKKFwQxPt81i3LE-Q6g>
    <xme:1orPY0sQ4CMR2zU6AMCkdxdfNk2Ae919w426cqqDLgeD3-qwllvuQGqR7JmLqJwNt
    dqRHoBUPFo1lfk>
X-ME-Received: <xmr:1orPYyCqjpvfs-BSalAcpih-5Gj51OQwBqva_rFSGp2xakSgDNnK2R_GUAaCj00npshuLiywpJgq3Gv-52735jazuMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudduledgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesth
    dtredttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehi
    ughoshgthhdrohhrgheqnecuggftrfgrthhtvghrnhepvddufeevkeehueegfedtvdevfe
    fgudeifeduieefgfelkeehgeelgeejjeeggefhnecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:1orPY8eb-kJCkXuHzSSy8xOoHLTMFqg7NWDrKk8ePOXUaWgrfrbLxg>
    <xmx:1orPYxPiYBZyldXxvFiDI31NEAuATKLNKl0tvXxalHm6xV8bGXtX6g>
    <xmx:1orPY2nwx_b_x1A7RfaHbRZaE0498XE8IjQF5oyBT_2eKuVp4c3S1Q>
    <xmx:1orPYyEfYJEci8ItuZhJ42VVrtdY7zr95kIEhxoCgD7We2nsKdYhLQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Jan 2023 02:37:57 -0500 (EST)
Date:   Tue, 24 Jan 2023 09:37:53 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@nvidia.com, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH net-next] netlink: fix spelling mistake in dump size
 assert
Message-ID: <Y8+K0Rvc1ojVoaUM@shredder>
References: <20230123222224.732338-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123222224.732338-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 02:22:24PM -0800, Jakub Kicinski wrote:
> Commit 2c7bc10d0f7b ("netlink: add macro for checking dump ctx size")
> misspelled the name of the assert as asset, missing an R.
> 
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Thanks!
