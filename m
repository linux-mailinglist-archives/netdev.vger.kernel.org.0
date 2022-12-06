Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B1D64436B
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbiLFMr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbiLFMrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:47:52 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62984E70
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 04:47:48 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6555920491;
        Tue,  6 Dec 2022 13:47:46 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Nt7J5Lk15Xrz; Tue,  6 Dec 2022 13:47:45 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id DF0D3200A3;
        Tue,  6 Dec 2022 13:47:45 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id D95AA80004A;
        Tue,  6 Dec 2022 13:47:45 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 6 Dec 2022 13:47:45 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 6 Dec
 2022 13:47:45 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 28818318296D; Tue,  6 Dec 2022 13:47:45 +0100 (CET)
Date:   Tue, 6 Dec 2022 13:47:45 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH xfrm-next v10 0/8] Extend XFRM core to allow packet
 offload configuration
Message-ID: <20221206124745.GH704954@gauss3.secunet.de>
References: <cover.1670005543.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1670005543.git.leonro@nvidia.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 08:41:26PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
...
> 
> Leon Romanovsky (8):
>   xfrm: add new packet offload flag
>   xfrm: allow state packet offload mode
>   xfrm: add an interface to offload policy
>   xfrm: add TX datapath support for IPsec packet offload mode
>   xfrm: add RX datapath protection for IPsec packet offload mode
>   xfrm: speed-up lookup of HW policies
>   xfrm: add support to HW update soft and hard limits
>   xfrm: document IPsec packet offload mode
> 
>  Documentation/networking/xfrm_device.rst      |  62 +++++-
>  .../inline_crypto/ch_ipsec/chcr_ipsec.c       |   4 +
>  .../net/ethernet/intel/ixgbe/ixgbe_ipsec.c    |   5 +
>  drivers/net/ethernet/intel/ixgbevf/ipsec.c    |   5 +
>  .../mellanox/mlx5/core/en_accel/ipsec.c       |   4 +
>  .../net/ethernet/netronome/nfp/crypto/ipsec.c |   5 +
>  drivers/net/netdevsim/ipsec.c                 |   5 +
>  include/linux/netdevice.h                     |   4 +
>  include/net/xfrm.h                            | 124 +++++++++---
>  include/uapi/linux/xfrm.h                     |   6 +
>  net/xfrm/xfrm_device.c                        | 109 +++++++++-
>  net/xfrm/xfrm_output.c                        |  12 +-
>  net/xfrm/xfrm_policy.c                        |  85 +++++++-
>  net/xfrm/xfrm_state.c                         | 191 ++++++++++++++++--
>  net/xfrm/xfrm_user.c                          |  20 ++
>  15 files changed, 577 insertions(+), 64 deletions(-)

Series applied, thanks a lot Leon!
