Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEA64F5BD7
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240731AbiDFK4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 06:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348485AbiDFKzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 06:55:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7C6242201;
        Wed,  6 Apr 2022 00:17:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAE6F61B00;
        Wed,  6 Apr 2022 07:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606F5C385A1;
        Wed,  6 Apr 2022 07:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649229429;
        bh=kO+CWeM3t3ySUYaB/XXLH+IahNF0qSXnWYdw+NAtgUM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l5OVEg7ZEGlljU7VwGLJ5xsqLTqFCe6IfpHBWhQ3Xjj/xHVH6W97zc9BqowKGKG/Y
         8mwKq/cZ2ay9jvPjaCjc+bbwUE6RwtZJ7RH0a8T7zWyGJdqDi2pPBmBP2Tff/ijecG
         aSYhJ40nZgLfeBWoiwAqcrvy1N8CAm3K+HPYCmfWKjdRfBsnnwo4oZ+xjoiwtwuyI9
         zmXwoBD7d9YnRIeWVA6FqBvRtrM8MD5ge+Of2ntk3yuzuiCg1q+QmcApjMANr0s2Vc
         ILNkYUQqGYdlUkzRJsLdz7pNbPK9dVFROzmUMcfCMCyNC+uSQsP2KeUDL2SRxOxHkV
         3hHHXozjI8u7Q==
Date:   Wed, 6 Apr 2022 10:17:04 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH 10/11] IB/mlx5: Fix undefined behavior due to shift
 overflowing the constant
Message-ID: <Yk0+cBw01DVfQ3LJ@unreal>
References: <20220405151517.29753-1-bp@alien8.de>
 <20220405151517.29753-11-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220405151517.29753-11-bp@alien8.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 05:15:16PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Fix:
> 
>   drivers/infiniband/hw/mlx5/main.c: In function ‘translate_eth_legacy_proto_oper’:
>   drivers/infiniband/hw/mlx5/main.c:370:2: error: case label does not reduce to an integer constant
>     case MLX5E_PROT_MASK(MLX5E_50GBASE_KR2):
>     ^~~~
> 
> See https://lore.kernel.org/r/YkwQ6%2BtIH8GQpuct@zn.tnic for the gory
> details as to why it triggers with older gccs only.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: linux-rdma@vger.kernel.org
> Cc: netdev@vger.kernel.org
> ---
>  include/linux/mlx5/port.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, applied to mlx5-next.

0276bd3a94c0 ("IB/mlx5: Fix undefined behavior due to shift overflowing the constant")
