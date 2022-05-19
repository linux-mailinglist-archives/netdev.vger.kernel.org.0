Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C61C52E071
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 01:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343519AbiESXRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 19:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237386AbiESXRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 19:17:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895F3E8BA0;
        Thu, 19 May 2022 16:17:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 437D8B828D4;
        Thu, 19 May 2022 23:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF9FC385AA;
        Thu, 19 May 2022 23:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653002248;
        bh=FDxKvt20YoDXr8Bm7tgCaGymC59FE8E9GRHh3mTeuEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PHMZ4EJyOqhsf4Uvougsi717EDEZosl7F2qLKJ5kjUoJgCwXwGG1qbNSlcZr9M9fr
         c9Wbpqz5qiK9FfjAv48d+zr5xhyw4ldPzOx4I0/H3YGblRJLqW6atvsvHG7QRDova3
         3YfdnmwqcRDDS/9E9zYwqpewqA4ukN72uFdt4aTRF4fLUtSOA9MKB0Qqh7yhJClpZM
         XTijom0LhGHQ4Y+knwKN63CrrWkci8yqJEGr9e/1spYOYUszFN2ryRYISsa0A+KGZK
         SmtMpzN/xmIJ8wuhKcUBO4+M5zlxuLBBj7avbjvPSs2gwZldUMmFEzY3JFvblVRvaU
         eEU0rOyiOGMPw==
Date:   Thu, 19 May 2022 16:17:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: linux-next: Tree for May 19 (net/ethernet/mellanox/mlx5/core/)
Message-ID: <20220519161726.08cd9301@kernel.org>
In-Reply-To: <47e365e7-60a3-62ea-65e2-e046cbdcc999@infradead.org>
References: <20220519194922.5d1bac4a@canb.auug.org.au>
        <47e365e7-60a3-62ea-65e2-e046cbdcc999@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 May 2022 13:57:05 -0700 Randy Dunlap wrote:
> On 5/19/22 02:49, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20220518:  
> 
> on i386 or x86_64:
> 
> drivers/net/ethernet/mellanox/mlx5/core/lag/lag.o: in function `mlx5_lag_mpesw_init':
> lag.c:(.text+0x408): multiple definition of `mlx5_lag_mpesw_init'; ld: DWARF error: could not find abbrev number 25
> drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.o:debugfs.c:(.text+0x41c): first defined here
> ld: drivers/net/ethernet/mellanox/mlx5/core/lag/lag.o: in function `mlx5_lag_mpesw_cleanup':
> lag.c:(.text+0x40e): multiple definition of `mlx5_lag_mpesw_cleanup'; drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.o:debugfs.c:(.text+0x422): first defined here
> 
> 
> x86_64 randconfig file is attached.

Thanks, should be fixed by commit d935053a62fa ("net/mlx5: fix multiple
definitions of mlx5_lag_mpesw_init / mlx5_lag_mpesw_cleanup") in net-next.

