Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D74C60548D
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 02:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiJTAmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 20:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiJTAmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 20:42:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFB8196B47;
        Wed, 19 Oct 2022 17:42:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 832C26101F;
        Thu, 20 Oct 2022 00:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864F2C433D6;
        Thu, 20 Oct 2022 00:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666226550;
        bh=2i2TU/chYRViGs6o0UqmsoDbDk+GHNK2T+VUhf5H6cc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bOv8LMpy1Y9zh6G06dnTU5mzblPLC778VlPDn+bWEGfA2zN+ZXqnXAxjHxIYLPGrs
         lG9mXXAyuW8ITSiuKhGS6+x0PWYlpXE96lQUSVc9zuYhdq20/B1lIxpP6keBK4r5nf
         CzNUHvTtzP9uIlTjJ7J0T6PpfDfFUTUZjLV2xrzsNPRBfvJLbIJU4WeKagflSRzIkB
         7XETlxj9LMxLWqV2KBEPqydSDDU3doYGScAaDYe78a8Q5vw9Ce9UKvhu8lnXt4oXoL
         If1SsaqWC8fznztyagx7l3N/Z0pEVLjnY44L/c76m4DmJTNUwRHc83mkBiN8am8d5O
         ZRkC5LFdWsCTQ==
Date:   Wed, 19 Oct 2022 17:42:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexandru Tachici <alexandru.tachici@analog.com>
Cc:     <linux-kernel@vger.kernel.org>, <andrew@lunn.ch>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
Subject: Re: [net-next] net: ethernet: adi: adin1110: Fix notifiers
Message-ID: <20221019174229.5faaaaea@kernel.org>
In-Reply-To: <20221019101750.8978-1-alexandru.tachici@analog.com>
References: <20221019101750.8978-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Oct 2022 13:17:50 +0300 Alexandru Tachici wrote:
> ADIN1110 was registering netdev_notifiers on each device probe.
> This leads to warnings/probe failures because of double registration
> of the same notifier when to adin1110/2111 devices are connected to
> the same system.
> 
> Move the registration of netdev_notifiers in module init call,
> in this way multiple driver instances can use the same notifiers.
> 
> Fixes: bc93e19d088b ("net: ethernet: adi: Add ADIN1110 support")
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>

Could you please repost with [PATCH net] as the subject prefix 
(the change you're fixing has made its way to Linus's tree by now
so you need to target the tree for fixes [1]), and please CC Lennart
since he co-developed the original change.

[1]
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#how-do-i-indicate-which-tree-net-vs-net-next-my-patch-should-be-in
