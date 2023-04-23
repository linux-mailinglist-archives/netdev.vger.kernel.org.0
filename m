Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB866EC13D
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 18:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjDWQyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 12:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjDWQyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 12:54:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF38194;
        Sun, 23 Apr 2023 09:54:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC28761B6C;
        Sun, 23 Apr 2023 16:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF86C4339C;
        Sun, 23 Apr 2023 16:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682268871;
        bh=K2PCVDidtL1CIAzJLh0b8bsIdwltLgCArv73TTrbDdw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GlXDsiuVbzNrV6qH0kWLsqGQs8e++TbktYXjdD0Vs3NatP7IDvEygLhIYKs3O9ol7
         7J3wT/W9Ba2XeP0eUPxtfu6OCAoihfsGrfNrHm2O/HZKgz6ScK1/YfTVIh/vNrKr1H
         zJGTACSUuHqG4j7a99RdUqjgyV7DwwPBbla9my3wnkzXLgzVyqN4WMpmXnD1om2Ux0
         CVrQAWWXulowWbRFvYHXGxQrn4z943/bbUUn1PWm0qQqM67NoIXRuPJJxA/3tEH/ih
         BDzb7qmdmUpRHyMtberC6TkPu6HL1XNVU0gg8xZruacQ4p7iYOrW0+JKZvsS8T1LsD
         ElWJNj+pJbaJw==
Date:   Sun, 23 Apr 2023 19:54:27 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com, sgoutham@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
Subject: Re: [net PATCH 8/9] octeontx2-pf: mcs: Fix shared counters logic
Message-ID: <20230423165427.GK4782@unreal>
References: <20230423095454.21049-1-gakula@marvell.com>
 <20230423095454.21049-9-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230423095454.21049-9-gakula@marvell.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 03:24:53PM +0530, Geetha sowjanya wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> Macsec stats like InPktsLate and InPktsDelayed share
> same counter in hardware. If SecY replay_protect is true
> then counter represents InPktsLate otherwise InPktsDelayed.
> This mode change was tracked based on protect_frames
> instead of replay_protect mistakenly. Similarly InPktsUnchecked
> and InPktsOk share same counter and mode change was tracked
> based on validate_check instead of validate_disabled.
> This patch fixes those problems.
> 
> Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> ---
>  .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c  | 14 +++++++-------
>  .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  2 +-
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
