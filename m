Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3815161E59A
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 20:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiKFTkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 14:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiKFTkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 14:40:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7E4F5A3
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 11:40:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 25025CE0BAE
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 19:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87573C433D7;
        Sun,  6 Nov 2022 19:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667763603;
        bh=sPGQFhHgR0jBeyQxCNxCkjr93T0FJ+IRNI+D8uhjCjI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QC7nuJ1F61hsGY4uWfPJUkALJBtEYgACtzcrgCvmmQuTCUky2f90QsaHJ88v7oDTt
         HWJUMEOkb2UHgjM2my44T6I+iKYoyisYZdonI39Yfle305AuQYLxEuDWGquoGI4VBA
         QZCNm1O7S3iOyIv0dSotI2mGHY4MaEewKdMWpZeoI3bvqGvxy1GfM3v89t47iKMvMl
         x8eLB1FGPpWo/MXhw3aAfG8esMMD9JJCUmGHgepbktpfKlKaZMEEbPimYBdpLUGQ9e
         GmV1DhIT//MFoXgrL2nWmKSsU/s9cu15Wz1aY2otllOBDp6sL4XnmsNE0PnLLmALwj
         meXQjb0FCCCUw==
Date:   Sun, 6 Nov 2022 21:39:59 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Chentian Liu <chengtian.liu@corigine.com>,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next v3 1/3] nfp: extend capability and control words
Message-ID: <Y2gNj+VI1AEZl4wd@unreal>
References: <20221101110248.423966-1-simon.horman@corigine.com>
 <20221101110248.423966-2-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101110248.423966-2-simon.horman@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 12:02:46PM +0100, Simon Horman wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> Currently the 32-bit capability word is almost exhausted, now
> allocate some more words to support new features, and control
> word is also extended accordingly. Packet-type offloading is
> implemented in NIC application firmware, but it's not used in
> kernel driver, so reserve this bit here in case it's redefined
> for other use.
> 
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Reviewed-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net.h       |  2 ++
>  .../net/ethernet/netronome/nfp/nfp_net_common.c    |  1 +
>  drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h  | 14 +++++++++++---
>  3 files changed, 14 insertions(+), 3 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
