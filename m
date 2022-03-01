Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4374C84B4
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 08:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbiCAHMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 02:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbiCAHMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 02:12:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0517A9B1;
        Mon, 28 Feb 2022 23:11:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B7FC61215;
        Tue,  1 Mar 2022 07:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5306C340EE;
        Tue,  1 Mar 2022 07:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646118711;
        bh=10FFhhdusBJsRo3SaGVpNBEGQ/FHlM/hqY5zKkMJWBc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rLllz5tdAeismz+ePL6D+0NxSshab00OfZLcXkXL+XWcfEeC5js9YR6/yG2nwdD1x
         uS8nb02Iibkjeq8JRlQgWWylnZTOMIBkfpNTuJby3JCJIcehA7xqC2SoSzp1lGCR3d
         NWzmzeHtvHuCtyd15cqEsmvGNAbIbR4d1tepR1vgPLY6l3YucpN0JHlraWgug8rF49
         xHN5UHXpgAWDl1E5NLEGZH5VcpTaAc0hHdiZWbsP3o+kynyniUCKaLoiagLKhtmP1W
         rFD5FEfgFlBiIcr9jSePQSZOj1K2BO8u40U8szPV+b9VxCKmoOsDELM/dmGbRQNsrB
         a3/TZUCnFtKBw==
Date:   Mon, 28 Feb 2022 23:11:49 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] net/mlx5e: Fix return of a kfree'd object instead of NULL
Message-ID: <20220301071149.msbfgs2kztcx4okl@sx1>
References: <20220224221525.147744-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220224221525.147744-1-colin.i.king@gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24 Feb 22:15, Colin Ian King wrote:
>Currently in the case where parse_attr fails to be allocated the memory
>pointed to by attr2 is kfree'd but the non-null pointer attr2 is returned
>and a potential use of a kfree'd object can occur.  Fix this by returning
>NULL to indicate a memory allocation error.
>
>Addresses issue found by clang-scan:
>drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:3401:3: warning: Use of
>memory after it is freed [unix.Malloc]
>
>Fixes: 8300f225268b ("net/mlx5e: Create new flow attr for multi table actions")
>Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Applied to net-next-mlx5
Thanks.

