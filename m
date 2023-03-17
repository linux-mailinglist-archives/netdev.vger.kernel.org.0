Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4F26BF1F8
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 20:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjCQTyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 15:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjCQTym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 15:54:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5994B1A67D;
        Fri, 17 Mar 2023 12:54:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C48666124D;
        Fri, 17 Mar 2023 19:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F91C433EF;
        Fri, 17 Mar 2023 19:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679082877;
        bh=plZ2SW2Lu16rpy5AE1z8m4uxtB0xubOaGSbXpISohF8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L7fRuwepZU7J9Usd7QVwM2Ka9sYb8JXxoIT1eKcdEvGL1ypdwU4WZzJALmSqVxqXR
         OeCh9f7y9Nu6/7/l3LKYJMaTG4bkUHseYFchHo4oYl9Zls6NQ8CEvO9dQ7Ng6DbSDU
         Uwnd6z8CQc8d66mx8ZLqwJoSJOmAfg6IVz4wl/RXMdeW+F6y3qe41RoWPDB2v3bKyi
         hXxTWMtJSgLV7avEoKOZNZSyR40gCT996FkJu5Seq+H0JUDUa8mcl1q8v2YcteUtfq
         qG6wyBRfw1vTdTsMu4yrelNFSDyrOdGBRHFeKX+RhRgKbJlYpBThal9YFfuVL+NQxU
         elE6B1pwoawJw==
Date:   Fri, 17 Mar 2023 12:54:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kang Chen <void0red@gmail.com>
Cc:     horatiu.vultur@microchip.com, borisp@nvidia.com,
        davem@davemloft.net, dirk.vandermerwe@netronome.com,
        edumazet@google.com, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH net v2] net/tls: refine the branch condition in
 tls_dev_event
Message-ID: <20230317125436.18bdcacf@kernel.org>
In-Reply-To: <20230317083338.1085194-1-void0red@gmail.com>
References: <20230317081513.ktllct3rqaisummm@soft-dev3-1>
        <20230317083338.1085194-1-void0red@gmail.com>
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

On Fri, 17 Mar 2023 16:33:38 +0800 Kang Chen wrote:
> dev->tlsdev_ops may be null and cause null pointer dereference later.

It'd be a driver bug to report NETIF_F_HW_TLS_RX but not have ops.
