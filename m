Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCF66C0C97
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 09:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbjCTI4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 04:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbjCTI4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 04:56:47 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9667110405
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 01:56:45 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8A3CC20184;
        Mon, 20 Mar 2023 09:56:43 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9eJwoI2M2ima; Mon, 20 Mar 2023 09:56:43 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0366F20080;
        Mon, 20 Mar 2023 09:56:43 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id E885480004A;
        Mon, 20 Mar 2023 09:56:42 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Mon, 20 Mar 2023 09:56:42 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Mon, 20 Mar
 2023 09:56:42 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 14D5C3182CBC; Mon, 20 Mar 2023 09:56:42 +0100 (CET)
Date:   Mon, 20 Mar 2023 09:56:42 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Blakey <paulb@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH xfrm-next 0/9] Extend packet offload to fully support
 libreswan
Message-ID: <ZBgfyumyJL10F4g6@gauss3.secunet.de>
References: <cover.1678714336.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1678714336.git.leon@kernel.org>
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

On Tue, Mar 14, 2023 at 10:58:35AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Hi Steffen,
> 
> The following patches are an outcome of Raed's work to add packet
> offload support to libreswan [1].
> 
> The series includes:
>  * Priority support to IPsec policies
>  * Statistics per-SA (visible through "ip -s xfrm state ..." command)
>  * Support to IKE policy holes
>  * Fine tuning to acquire logic.
> 
> --------------------------
> Future submission roadmap, which can be seen here [2]:
>  * Support packet offload in IPsec tunnel mode
>  * Rework lifetime counters support to avoid HW bugs/limitations
>  * Some general cleanup.
> 
> So how do you want me to route the patches, as they have a dependency between them?
> xfrm-next/net-next/mlx5-next?

As the changes to the xfrm core are just minor compared to the rest
of the patchset, I'd not absolutely require to route it through
ipsec-next. Do it as you prefer, but let me know how you plan
to do it.
