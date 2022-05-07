Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87C851E536
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 09:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346929AbiEGHc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 03:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238791AbiEGHc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 03:32:26 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6215764C5
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 00:28:39 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 28CB220501;
        Sat,  7 May 2022 09:28:37 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id l9ZUqdJwKGbd; Sat,  7 May 2022 09:28:36 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5D9E6200A2;
        Sat,  7 May 2022 09:28:36 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 55E8A80004A;
        Sat,  7 May 2022 09:28:36 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 7 May 2022 09:28:36 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 7 May
 2022 09:28:35 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 5B3E53180AAB; Sat,  7 May 2022 09:28:35 +0200 (CEST)
Date:   Sat, 7 May 2022 09:28:35 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <intel-wired-lan@lists.osuosl.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH ipsec-next 0/8] Be explicit with XFRM offload direction
Message-ID: <20220507072835.GI680067@gauss3.secunet.de>
References: <cover.1651743750.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1651743750.git.leonro@nvidia.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 01:06:37PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Hi Steffen,
> 
> I may admit that the title of this series is not the best one as it
> contains straightforward cleanups and code that converts flags to
> something less confusing.
> 
> This series follows removal of FPGA IPsec code from the mlx5 driver and
> based on net-next commit 4950b6990e3b ("Merge branch 'ocelot-vcap-cleanups'").
> 
> As such, first two patches delete code that was used by mlx5 FPGA code
> but isn't needed anymore.
> 
> Third patch is simple struct rename.
> 
> Rest of the patches separate user's provided flags variable from driver's
> usage. This allows us to created more simple in-kernel interface, that
> supports type checking without blending different properties into one
> variable. It is achieved by converting flags to specific bitfield variables
> with clear, meaningful names.
>     
> Such change allows us more clear addition of new input flags needed to
> mark IPsec offload type.
> 
> The followup code uses this extensively:
> https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=xfrm-next
> 
> Thanks
> 
> Leon Romanovsky (8):
>   xfrm: free not used XFRM_ESP_NO_TRAILER flag
>   xfrm: delete not used number of external headers
>   xfrm: rename xfrm_state_offload struct to allow reuse
>   xfrm: store and rely on direction to construct offload flags
>   ixgbe: propagate XFRM offload state direction instead of flags
>   netdevsim: rely on XFRM state direction instead of flags
>   net/mlx5e: Use XFRM state direction instead of flags
>   xfrm: drop not needed flags variable in XFRM offload struct

Series applied, thanks a lot Leon!
