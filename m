Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36FBE647E66
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiLIHTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLIHTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:19:01 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533AFD2E6
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 23:19:00 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4435E204E5;
        Fri,  9 Dec 2022 08:18:58 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vRPE4meqB9w4; Fri,  9 Dec 2022 08:18:57 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id BE14E204A4;
        Fri,  9 Dec 2022 08:18:57 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id B85D080004A;
        Fri,  9 Dec 2022 08:18:57 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 9 Dec 2022 08:18:57 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 9 Dec
 2022 08:18:57 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 15C1E3182989; Fri,  9 Dec 2022 08:18:57 +0100 (CET)
Date:   Fri, 9 Dec 2022 08:18:57 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH xfrm-next 00/13] mlx5 IPsec packet offload support (Part
 I)
Message-ID: <20221209071857.GW424616@gauss3.secunet.de>
References: <cover.1670011885.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1670011885.git.leonro@nvidia.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 10:14:44PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Hi,
> 
> This is second part with implementation of packet offload.
> 
> Thanks
> 
> Leon Romanovsky (12):
>   net/mlx5e: Create IPsec policy offload tables
>   net/mlx5e: Add XFRM policy offload logic
>   net/mlx5e: Use same coding pattern for Rx and Tx flows
>   net/mlx5e: Configure IPsec packet offload flow steering
>   net/mlx5e: Improve IPsec flow steering autogroup
>   net/mlx5e: Skip IPsec encryption for TX path without matching policy
>   net/mlx5e: Provide intermediate pointer to access IPsec struct
>   net/mlx5e: Store all XFRM SAs in Xarray
>   net/mlx5e: Update IPsec soft and hard limits
>   net/mlx5e: Handle hardware IPsec limits events
>   net/mlx5e: Handle ESN update events
>   net/mlx5e: Open mlx5 driver to accept IPsec packet offload
> 
> Raed Salem (1):
>   net/mlx5e: Add statistics for Rx/Tx IPsec offloaded flows

Series applied, thanks a lot!
