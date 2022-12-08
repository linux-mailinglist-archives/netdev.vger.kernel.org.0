Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D032F646BFF
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 10:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiLHJfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 04:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiLHJfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 04:35:52 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC2959FFA
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 01:35:51 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A0EAB20299;
        Thu,  8 Dec 2022 10:35:49 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZkzwBXVaYvpM; Thu,  8 Dec 2022 10:35:48 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id DDFF6200BB;
        Thu,  8 Dec 2022 10:35:48 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id D805C80004A;
        Thu,  8 Dec 2022 10:35:48 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Dec 2022 10:35:48 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 8 Dec
 2022 10:35:48 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id EB21C318296A; Thu,  8 Dec 2022 10:35:47 +0100 (CET)
Date:   Thu, 8 Dec 2022 10:35:47 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH xfrm-next 00/16] mlx5 IPsec packet offload support (Part
 I)
Message-ID: <20221208093547.GK704954@gauss3.secunet.de>
References: <cover.1670011671.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1670011671.git.leonro@nvidia.com>
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

On Fri, Dec 02, 2022 at 10:10:21PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Hi,
> 
> This series follows previously sent "Extend XFRM core to allow packet
> offload configuration" series [1].
> 
> It is first part with refactoring to mlx5 allow us natively extend
> mlx5 IPsec logic to support both crypto and packet offloads.
> 
> Thanks
> 
> [1] https://lore.kernel.org/all/cover.1670005543.git.leonro@nvidia.com
> 
> Leon Romanovsky (16):
>   net/mlx5: Return ready to use ASO WQE
>   net/mlx5: Add HW definitions for IPsec packet offload
>   net/mlx5e: Advertise IPsec packet offload support
>   net/mlx5e: Store replay window in XFRM attributes
>   net/mlx5e: Remove extra layers of defines
>   net/mlx5e: Create symmetric IPsec RX and TX flow steering structs
>   net/mlx5e: Use mlx5 print routines for low level IPsec code
>   net/mlx5e: Remove accesses to priv for low level IPsec FS code
>   net/mlx5e: Create Advanced Steering Operation object for IPsec
>   net/mlx5e: Create hardware IPsec packet offload objects
>   net/mlx5e: Move IPsec flow table creation to separate function
>   net/mlx5e: Refactor FTE setup code to be more clear
>   net/mlx5e: Flatten the IPsec RX add rule path
>   net/mlx5e: Make clear what IPsec rx_err does
>   net/mlx5e: Group IPsec miss handles into separate struct
>   net/mlx5e: Generalize creation of default IPsec miss group and rule

Series applied, thanks Leon!
