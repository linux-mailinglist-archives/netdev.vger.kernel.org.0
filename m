Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F50536AE9
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 07:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354614AbiE1F2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 01:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiE1F2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 01:28:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715003AA40;
        Fri, 27 May 2022 22:28:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EA82B826A7;
        Sat, 28 May 2022 05:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACA2C34100;
        Sat, 28 May 2022 05:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653715690;
        bh=kJC1YQ2Fcox47AmJFx59AV8GPwK/+Co3XeZND2MgUD0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oM1KOh7BNwvd6HG5WKH+wymWh6ECTXj4VNm9a6SUjwm2YZMtHbeVeDHlRgoZSe8h4
         /estUBk3ZmMQ+f3Ov+XkqDawufdhLe0OxGQlXST9ODwU3Kft4hQA8IG98fxitRqDEu
         ZTKixQk6UHsdNJejB55KuHZGKLifTGih7VI4MFivxgtGqtddESUVd3+zjHEa3H7eKj
         R6ekxailC76nHO3KkTca6YjHdLXnXMfakXTYGViRx8AxaNzU8HEpxNBn8QD9DGnkIU
         6sGi5AJoCaWqB3bW5RjBwLTDhnv9KnASn3bPowQ1w//9WxDOcBM4XAi3tea36GCdhc
         3zhi92cZkOXAA==
Date:   Fri, 27 May 2022 22:28:09 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Eric Dumazet <edumazet@google.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <markb@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net] net/mlx5: Don't use already freed action pointer
Message-ID: <20220528052809.raf6bjndaxs2fvxk@sx1>
References: <7fe70bbb120422cc71e6b018531954d58ea2e61e.1653397057.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <7fe70bbb120422cc71e6b018531954d58ea2e61e.1653397057.git.leonro@nvidia.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24 May 15:59, Leon Romanovsky wrote:
>From: Leon Romanovsky <leonro@nvidia.com>
>
>The call to mlx5dr_action_destroy() releases "action" memory. That
>pointer is set to miss_action later and generates the following smatch
>error:
>
> drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c:53 set_miss_action()
> warn: 'action' was already freed.
>
>Make sure that the pointer is always valid by setting NULL after destroy.
>
>Fixes: 6a48faeeca10 ("net/mlx5: Add direct rule fs_cmd implementation")
>Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Applied to net-mlx5. I am still working on other critical fixes in my
net queue, will submit all at once next week so we can make it to rc1.

Thanks,
Saeed


