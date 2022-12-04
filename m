Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F430641D25
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 14:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiLDNBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 08:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiLDNBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 08:01:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691BF1144B
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 05:01:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13F60B8074E
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 13:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3638C433D6;
        Sun,  4 Dec 2022 13:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670158867;
        bh=9JrPsPwDbvN31cMKbLVyoYDTXsO3Cr+g2pg/+7QT0lY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZGEJXtfO0cbcNzjH7YKT3XhfwtYFFCtRR1CarOQXUFLi9SDcXl4p/z7HB/t2IQgsW
         wYv3C7/7g6vrDT63QF9Ttb4Z0hQIDP6ZWSfq2MH6onIP8+QCuV3cmrbdXO50k/9dYV
         fzr9viJccb/cWGHaYtlC0v0J5/bYEAB2oryV2tUg2ShE10ZuaN4vbeMQ2JXQ9xtiRr
         OO9H6Op/N4tfg/l/dC2E3xkDsSjiV5ZxYx1RCaKrlXt/a0YNQjycboso1sHZUr4FKK
         5L709a2kALSrrQZCug+ow7Z+WA4A0n+6D+ngMVYCRPDRONXsOPgOVJnjF3KG1es6kI
         DeVY95Zcc6vUA==
Date:   Sun, 4 Dec 2022 15:01:02 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yinjun Zhang <yinjun.zhang@corigine.com>,
        Richard Donkin <richard.donkin@corigine.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@corigine.com>
Subject: Re: [PATCH net] nfp: correct desc type when header dma len is 4096
Message-ID: <Y4yaDtOYppIAVSxS@unreal>
References: <20221202134646.311108-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221202134646.311108-1-simon.horman@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 02:46:46PM +0100, Simon Horman wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> When there's only one buffer to dma and its length is 4096, then
> only one data descriptor is needed to carry it according to current
> descriptor definition. So the descriptor type should be `simple`
> instead of `gather`, the latter requires more than one descriptor,
> otherwise it'll be dropped by application firmware.
> 
> Fixes: c10d12e3dce8 ("nfp: add support for NFDK data path")
> Fixes: d9d950490a0a ("nfp: nfdk: implement xdp tx path for NFDK")
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Reviewed-by: Richard Donkin <richard.donkin@corigine.com>
> Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/ethernet/netronome/nfp/nfdk/dp.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
