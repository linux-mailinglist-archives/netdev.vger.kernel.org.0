Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDBF967A802
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 01:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjAYAw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 19:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjAYAw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 19:52:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4727113F2
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 16:52:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FE67613DC
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 00:52:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697DBC433EF;
        Wed, 25 Jan 2023 00:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674607944;
        bh=g8mqXCkGgu/i2jx+BuliZ8ltz30hLxDgkIwMR0sP0IM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c5S78nLR6/rgYMA7EIn9XJZEoIE7lXQ2teEYhfyonmMAvlXhMlZzyJyp4jFtynhmt
         oTCI8Adqey1YhIIFO//rg00rbJrEAU3MQqtlT65cfUyNvXVUmQWiIlxq+jxH7WmRTu
         +K7S0Vcn1DeWog3AV6vC8MvJeLBTI28Up5NWtVgFa5whhgDW1HwLlRdJtTudUep7kH
         FcynoQXoJo63yjhAHGtQdIUiIu870UFg4gc36eQQbfl3707qCnqFqXxRV7mVP2cehg
         8DaFcyJO8zoo+V6WOPWiZ7cKR4dojBwA/y0Ume6rSIuEcgjndCI+YEcoJ3LXHmJD3P
         iBPWy9SdJYQlQ==
Date:   Tue, 24 Jan 2023 16:52:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next] net: ethtool: fix NULL pointer dereference in
 stats_prepare_data()
Message-ID: <20230124165223.49ab04b5@kernel.org>
In-Reply-To: <20230125004517.74c7ssj47zykciuv@skbuf>
References: <20230124110801.3628545-1-vladimir.oltean@nxp.com>
        <20230124162347.48bdae92@kernel.org>
        <20230125004517.74c7ssj47zykciuv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Jan 2023 02:45:17 +0200 Vladimir Oltean wrote:
> > Choose one:
> >  - you disagree with my comment on the report
> >  - you don't think that we should mix the immediate fix with the
> >    structural change
> >  - you agree but "don't have the time" to fix this properly  
> 
> Yeah, sorry, I shouldn't have left your question unanswered ("should we make
> a fake struct genl_info * to pass here?") - but I don't think I'm qualified
> enough to have an opinion, either. Whereas the immediate fix is neutral
> enough to not be controversial, or so I thought.
> 
> The problem is not so much "the time to fix this properly", but rather,
> I'm not even sure how to trigger the ethtool dumpit() code...

Ack, makes sense. I just wanted to make sure you weren't disagreeing.
