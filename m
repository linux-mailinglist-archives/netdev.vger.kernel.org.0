Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A8F63A23A
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 08:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiK1Hln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 02:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbiK1Hl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 02:41:28 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412F61704F
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 23:41:04 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 6077A32005CA;
        Mon, 28 Nov 2022 02:40:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 28 Nov 2022 02:40:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669621248; x=1669707648; bh=TqmvkL9ckXURKfWpZhcGQ8ZaGaQK
        +bl4JICBgoKFatQ=; b=aCaHexoZA7xQq/M3X6djNsnwBhamy2PW9enNk2kRMkKh
        HpVZLuoGMNH23Bz0R+LZa7EmSvE9l10nUB66hUQNFJSwoBvUUiSrZuF34MfbhNU5
        o9fT5cnUwbLbUy5mliIGm9UEILGYegLVgCOki9Nn77t6KUIvXOhi+byZazm2Lxtb
        WIn8j+yAk7pQfkTLzr/ujSbhLWdlZlF6Qvetk3OzOLMBK0IW7cDJeDn8BArrdte3
        wbvdSAWoxlUHwf70AAEkdW/oMU50g7xiHTbEDK5ROsauyV6QItb21ng/b4HzQKjr
        b7Tph93JgZtf9P4xgA04+GR9Z1Qr7ZqzdpbdTatlFg==
X-ME-Sender: <xms:AGaEYxe0sLvh8PnZkJ69ZH7yIZwfRicZ3iIRStOU80naArzxi6LuCw>
    <xme:AGaEY_NzM-uj7q9jkZ0jlECSorvnQcsyrR--gOlJW12IrRwi2u5_QDu332MJFlFY2
    sQyeXQySyqYZeI>
X-ME-Received: <xmr:AGaEY6gIefTvrk6wqDFlfA2egP6XhHbUH55iIJZfKdeoGM0qQXjm5Yz3-LHJ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrjedugdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhephefhtdejvdeiffefudduvdffgeetieeigeeugfduffdvffdtfeehieejtdfh
    jeeknecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:AGaEY68LE8U2Nm7azlndd9E6WjviQEagScSIJ_xDqLn0lQ986lkYXQ>
    <xmx:AGaEY9v3MslJj2PIebwZ1b3VGkPnU33_ihVIGg5PvVHLAckX46PFvg>
    <xmx:AGaEY5HmLF5OEwa0lNjwovAB9eqZIGF4joYF4OIGrMH3JI7nTOvrqg>
    <xmx:AGaEY1Itm07wd3b9ttZja1GIcAc26VCSsMMSj31NDmT_eZeG1CqM7A>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Nov 2022 02:40:48 -0500 (EST)
Date:   Mon, 28 Nov 2022 09:40:45 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Hangbin Liu <liuhangbin@gmail.com>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2] ip: fix return value for rtnl_talk failures
Message-ID: <Y4Rl/fhdhgWwccwv@shredder>
References: <20221108124344.192326-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108124344.192326-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 08:43:44PM +0800, Hangbin Liu wrote:
> Since my last commit "rtnetlink: add new function rtnl_echo_talk()" we
> return the kernel rtnl exit code directly, which breaks some kernel
> selftest checking. As there are still a lot of tests checking -2 as the
> error return value, to keep backward compatibility, let's keep using
> -2 for all the rtnl return values.
> 
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Fixes: 6c09257f1bf6 ("rtnetlink: add new function rtnl_echo_talk()")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Stephen, I believe this patch was missed. It appears as "New, archived"
in patchwork:
https://patchwork.kernel.org/project/netdevbpf/patch/20221108124344.192326-1-liuhangbin@gmail.com/

Can you please apply it? It fixes regressions in kernel selftests that
use iproute2 with blamed commit. See:

https://lore.kernel.org/netdev/Y2oWDRIIR6gjkM4a@shredder/

Thanks
