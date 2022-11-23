Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14901635B38
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 12:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237185AbiKWLKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 06:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236676AbiKWLIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 06:08:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55812EA1;
        Wed, 23 Nov 2022 03:08:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF11E61BD6;
        Wed, 23 Nov 2022 11:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756D7C433D7;
        Wed, 23 Nov 2022 11:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669201722;
        bh=DawtEQRaLys4ndNs0wAfEL55EBLaTd8iBsWdNmensMU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yt1eTFqw8F/qCDrGv8Xd8AYJLVuWcTXSYUGOWKR2n5YcnhscY9OG50o0ydhHLBgux
         6/1BvZ0NSLstMlNPttpy2OJvmr8ctcxIR9BBvoVjwif+B3qAIQsVcpvxLuDi1BIJYg
         vV8rkVmd5DElHyAx2Hz1B/6q0YYHbF19nkbqrXx+Egr2clYjMj7jfNiOvOnRbXmN+9
         FcX5g35cBHVzwgqpXai9DQW37ENEAEwcdWvWkqtmHdsvWtiSEQlwoghsh+3kQMPTjG
         gHDbqGnDkHbuF6nvzGgIwUdHC+jrUPFjeuJdhiDEAgL8IZFFJsuEgpbDauYu4obmn2
         /KfJWDPYd3z5Q==
Date:   Wed, 23 Nov 2022 13:08:37 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Suman Ghosh <sumang@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sgoutham@marvell.com, sbhatta@marvell.com,
        jerinj@marvell.com, gakula@marvell.com, hkelam@marvell.com,
        lcherian@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net PATCH V2] octeontx2-pf: Fix pfc_alloc_status array overflow
Message-ID: <Y33/NWTHNznMetWB@unreal>
References: <20221123105938.2824933-1-sumang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123105938.2824933-1-sumang@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 04:29:38PM +0530, Suman Ghosh wrote:
> This patch addresses pfc_alloc_status array overflow occurring for
> send queue index value greater than PFC priority. Queue index can be
> greater than supported PFC priority for multiple scenarios (e.g. QoS,
> during non zero SMQ allocation for a PF/VF).
> In those scenarios the API should return default tx scheduler '0'.
> This is causing mbox errors as otx2_get_smq_idx returing invalid smq value.
> 
> Fixes: 99c969a83d82 ("octeontx2-pf: Add egress PFC support")
> Signed-off-by: Suman Ghosh <sumang@marvell.com>
> ---
> Changes since v1:
> - Updated commit message.
> 
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
