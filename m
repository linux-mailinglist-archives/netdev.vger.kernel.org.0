Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEA266A998
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 07:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjANGST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 01:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjANGSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 01:18:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5753E44BE;
        Fri, 13 Jan 2023 22:18:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C208B80763;
        Sat, 14 Jan 2023 06:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44807C433EF;
        Sat, 14 Jan 2023 06:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673677094;
        bh=XO5qQDrGB1SkuDqPI/fNGFzA+nmV2oR05ZKZ6r36nQk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZhC48YUPq94cy97XutcNKjNda7EeRsXAhBshHVyD0TTmMR9OsParufD7Ggyi1zR1o
         b24wVOk+Ro0KQTLUswjnsJohmNZMI7XNLrL5OfOQ8p+sOHQtYczicIMvgt7eL5ognh
         OcA+9SY76ypcCVjh1Y1IclP71U58wumzjcgrPIx5TnMkV0FM+TyanD/0jAMEwNc8Tx
         YMMbuap+QuVht4tM7GRcKf3JzBaeKUsIEmtK32OffQ4v98YdTw9UeNqyYVBkpz+jZv
         S/svg04/i2zxx0AgkBCOJOERSLtZbwSmTdOmFOVIniOHUEs2q+TzsEftxXZGWUnrPj
         8iKfXFIVzAXkA==
Date:   Fri, 13 Jan 2023 22:18:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Carpenter <error27@gmail.com>
Cc:     Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] devlink: remove some unnecessary code
Message-ID: <20230113221813.35ebfb6a@kernel.org>
In-Reply-To: <Y8EJz8oxpMhfiPUb@kili>
References: <Y8EJz8oxpMhfiPUb@kili>
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

On Fri, 13 Jan 2023 10:35:43 +0300 Dan Carpenter wrote:
> This code checks if (attrs[DEVLINK_ATTR_TRAP_POLICER_ID]) twice.  Once
> at the start of the function and then a couple lines later.  Delete the
> second check since that one must be true.
> 
> Because the second condition is always true, it means the:
> 
> 	policer_item = group_item->policer_item;
> 
> assignment is immediately over-written.  Delete that as well.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
