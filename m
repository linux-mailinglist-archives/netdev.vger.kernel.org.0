Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798764D537B
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 22:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343889AbiCJVON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 16:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343905AbiCJVOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 16:14:12 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250D1CFB98
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 13:13:10 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 63CA93201805;
        Thu, 10 Mar 2022 16:13:07 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 10 Mar 2022 16:13:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=d0hfR+3vqD+pUfTks
        VBh7MPDay0SYutkoW9FR+/myak=; b=P4FxgZD3vK9dza8aexeV4anjiJTDbkQIM
        Gx1zOpQE5VbLBuG7Uz8rO0JDfnvbROq2Ucl5QTK3mvKTJvJvaTrPHJOeHB5jlYXj
        dwnMKFMzLh6D2aiS0W+HyshbAqlOlMnweadVZoFGnV0enpEPtH9OeHc0hlBS+VgH
        jtvJnf6wOgbGtXsebKSmclVsAQj2K4tRfP6/K8gCs+2ESMYG6VpZUxsQI/49LT2R
        p5gScCV80CumWnICGoRtXs3DaMCd35Ek4WufcmVdqP9xl/xKXmGnrfpOsa7DFIfM
        iCqU7aHTBpCZtSGif00st4PM8hh0al6Ai4mDkNbJ+rNv4v4SDh/TA==
X-ME-Sender: <xms:4mkqYjGhtOx1MwuJ0S2KDGdWF8xDg6CWwCEVRWLneWa32OB4Oo1Ggw>
    <xme:4mkqYgXE3HADZpxH1-kBPcwiwabGnLCAM4HlBVyKARLGVYeRIRRHkd3WkzVU1QIBk
    rTlprDBYqH6IEg>
X-ME-Received: <xmr:4mkqYlJMGGiTuhzW_M5R0LUKdbWDQyY0PJL657YtgiaZGmtL3C-WhFIgXd0lzAzZq5rLPQvulUXcFdxksscYCtTTx9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddvtddgudegjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpefgvefgveeuudeuffeiffehieffgf
    ejleevtdetueetueffkeevgffgtddugfekveenucffohhmrghinhepkhgvrhhnvghlrdho
    rhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:4mkqYhGXZePE72qvz7QdRNzL2Uqtug4uPQ6d5cTTIzGX4_SqJdBsdA>
    <xmx:4mkqYpVc6lXh3UCEMMqNCgIK_S37nyuJVtJwOWPSilA-CHoUSH-ryw>
    <xmx:4mkqYsPlOTS47CeXQo17UAUtVBvK_YySfRJeA7QmIYe14XQ-uzeUog>
    <xmx:4mkqYvyqmyQnmik4lhRdAXd2bzcbiBf1crqyaSBnTYlyL_-3TqY0QA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Mar 2022 16:13:05 -0500 (EST)
Date:   Thu, 10 Mar 2022 23:13:02 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, leonro@nvidia.com, jiri@resnulli.us
Subject: Re: [RFT net-next 0/6] devlink: expose instance locking and simplify
 port splitting
Message-ID: <Yipp3sQewk9y0RVP@shredder>
References: <20220310001632.470337-1-kuba@kernel.org>
 <Yim9aIeF8oHG59tG@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yim9aIeF8oHG59tG@shredder>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 10:57:17AM +0200, Ido Schimmel wrote:
> On Wed, Mar 09, 2022 at 04:16:26PM -0800, Jakub Kicinski wrote:
> > This series puts the devlink ports fully under the devlink instance
> > lock's protection. As discussed in the past it implements my preferred
> > solution of exposing the instance lock to the drivers. This way drivers
> > which want to support port splitting can lock the devlink instance
> > themselves on the probe path, and we can take that lock in the core
> > on the split/unsplit paths.
> > 
> > nfp and mlxsw are converted, with slightly deeper changes done in
> > nfp since I'm more familiar with that driver.
> > 
> > Now that the devlink port is protected we can pass a pointer to
> > the drivers, instead of passing a port index and forcing the drivers
> > to do their own lookups. Both nfp and mlxsw can container_of() to
> > their own structures.
> > 
> > I'd appreciate some testing, I don't have access to this HW.
> 
> Thanks for working on this. I ran a few tests that exercise these code
> paths with a debug config and did not see any immediate problems. I will
> go over the patches later today

Went over the patches and they look good to me. Thanks again. Will run a
full regression with them on Sunday.

I read [1] and [2] again to refresh my memory about this conversion. Can
you provide a rough outline of how you plan to go about it? Asking so
that I will know what to expect and how it all fits together. I expect
that eventually 'DEVLINK_NL_FLAG_NO_LOCK' will be removed from
'DEVLINK_CMD_RELOAD' and then the devl_lock()/devl_unlock() that you
left in drivers will be moved to earlier in the probe path so that we
don't deadlock on reload.

[1] https://lore.kernel.org/lkml/YYgJ1bnECwUWvNqD@shredder/
[2] https://lore.kernel.org/netdev/20211030231254.2477599-1-kuba@kernel.org/
