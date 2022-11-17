Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7311662D937
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 12:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbiKQLRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 06:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbiKQLQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 06:16:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E600FB02
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 03:16:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81BE0611D6
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 11:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0FDC433C1;
        Thu, 17 Nov 2022 11:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668683811;
        bh=xvpyMy0H7Dms60D++rgdO2Wh02CtCYDav+NXS7Bu1yM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YdYEbRFead8/tA5l8yDrGwElyGvdcjECVZjBDbzTZTDkSk7+x2vTnL3Pb1l6tNF7d
         UbGGvplCdtsjBC1eHZg6d07s37PJ856ArtUebGjQyWUAwejwOYHsWySIs8y9pqoW7c
         9NbACnr7X6bY9MbwY3ny3MChvfA4+/rWizJscqL3RzwjISffbssKN6Fgebso5SvZY1
         6mjNgDO2yufcHHvzQ34uCBw12KweGd390uY+1f0KAzSTpHiUEDVgMUdj9tsKInpHgt
         ogoZwBSXgYBkzYiYDmgdGyh8yolQmWX7BBvPPyW8z5Iy2vFkwZ0/rj/bRjaVvyJCU+
         vB0qyGPcZlyJA==
Date:   Thu, 17 Nov 2022 13:16:47 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Derek Chickles <dchickles@marvell.com>,
        Eric Dumazet <edumazet@google.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Satanand Burla <sburla@marvell.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>
Subject: Re: [PATCH net] net: liquidio: simplify if expression
Message-ID: <Y3YYHwvsPxyQZEgC@unreal>
References: <9845cbd62721437f946035669381a9719240fc89.1668533583.git.leonro@nvidia.com>
 <Y3VruaIDzVH7jqPQ@x130.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3VruaIDzVH7jqPQ@x130.lan>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 03:01:13PM -0800, Saeed Mahameed wrote:
> On 15 Nov 19:34, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Fix the warning reported by kbuild:
> > 
> > cocci warnings: (new ones prefixed by >>)
> > > > drivers/net/ethernet/cavium/liquidio/lio_main.c:1797:54-56: WARNING !A || A && B is equivalent to !A || B
> >   drivers/net/ethernet/cavium/liquidio/lio_main.c:1827:54-56: WARNING !A || A && B is equivalent to !A || B
> > 
> > Fixes: 8979f428a4af ("net: liquidio: release resources when liquidio driver open failed")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> > The fixed patch was in net, so sending the fix to net too.
> > ---
> 
> I don't follow the above note, but anyway:

Patch 8979f428a4af ("net: liquidio: release resources when liquidio
driver open failed") was accepted to net tree.
https://lore.kernel.org/netdev/166842061503.15162.7865291005287723428.git-patchwork-notify@kernel.org/

> 
> Reviewed-by: Saeed Mahameed <saeed@kernel.org>
> 
