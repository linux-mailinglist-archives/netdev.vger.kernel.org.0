Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C76E6CFB74
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 08:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjC3GXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 02:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjC3GXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 02:23:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989E32720;
        Wed, 29 Mar 2023 23:23:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28649B825E9;
        Thu, 30 Mar 2023 06:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E141C4339B;
        Thu, 30 Mar 2023 06:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680157414;
        bh=35+b81mwaRluJ6TgE8e0K/buT6xsMedun7q+hsyUAnU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EnIhxxT7pm5ZfPOPsdbIksn3dfqxaSREYNxpueJoxt8WHzM+fpGOZUTq0XOrssizK
         aJpn3HY3ysCnoQzkyNyQhGLiQXN6YnhRYc3QVmRTPc9v8b/sBGbI4ZZprLzaqgCKvE
         v/X48DKsW9tO6Ka6akF8lBvH4DkoLxK5VWcO2FtTrvt8REa4KPCpQXPCGR4fIW2U8t
         zbXswVAh/WbDS52pZ6ENoRS/C5ZSYiBWTKX+8y9H66ILGuxNRDlew1aO0Orba6vKr5
         oD3VpCtKS0cI4cuugvY7Fdg2k4SS3oSANMVtBB47cFSwO9Y7PsveQsKWMufg7n1GGH
         TYEuy8o5J/kKA==
Date:   Thu, 30 Mar 2023 09:23:30 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        richardcochran@gmail.com, Subbaraya Sundeep <sbhatta@marvell.com>
Subject: Re: [net PATCH 7/7] octeontx2-pf: Disable packet I/O for graceful
 exit
Message-ID: <20230330062330.GP831478@unreal>
References: <20230329170619.183064-1-saikrishnag@marvell.com>
 <20230329170619.183064-8-saikrishnag@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329170619.183064-8-saikrishnag@marvell.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 10:36:19PM +0530, Sai Krishna wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> At the stage of enabling packet I/O in otx2_open, If mailbox
> timeout occurs then interface ends up in down state where as
> hardware packet I/O is enabled. Hence disable packet I/O also
> before bailing out. This patch also free the LMTST per cpu structure
> on teardown, if the lmt_info pointer is not NULL.
> 
> Fixes: 1ea0166da050 ("octeontx2-pf: Fix the device state on error")
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 11 ++++++++++-
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c |  8 +++++---
>  2 files changed, 15 insertions(+), 4 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
