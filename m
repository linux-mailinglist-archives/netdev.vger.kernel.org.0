Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125D9640389
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 10:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbiLBJmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 04:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbiLBJms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 04:42:48 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283F026133
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 01:42:46 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E161B20527;
        Fri,  2 Dec 2022 10:42:44 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1FN9Tur1LQbJ; Fri,  2 Dec 2022 10:42:44 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 09769200A3;
        Fri,  2 Dec 2022 10:42:44 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 03B8980004A;
        Fri,  2 Dec 2022 10:42:44 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 10:42:43 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 2 Dec
 2022 10:42:43 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 2D379318298A; Fri,  2 Dec 2022 10:42:43 +0100 (CET)
Date:   Fri, 2 Dec 2022 10:42:43 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH xfrm-next v9 0/8] Extend XFRM core to allow packet
 offload configuration
Message-ID: <20221202094243.GA704954@gauss3.secunet.de>
References: <cover.1669547603.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1669547603.git.leonro@nvidia.com>
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

On Sun, Nov 27, 2022 at 01:18:10PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Changelog:
> v9:
>  * Added acquire support
> v8: https://lore.kernel.org/all/cover.1668753030.git.leonro@nvidia.com
>  * Removed not-related blank line
>  * Fixed typos in documentation
> v7: https://lore.kernel.org/all/cover.1667997522.git.leonro@nvidia.com
> As was discussed in IPsec workshop:
>  * Renamed "full offload" to be "packet offload".
>  * Added check that offloaded SA and policy have same device while sending packet
>  * Added to SAD same optimization as was done for SPD to speed-up lookups.
> v6: https://lore.kernel.org/all/cover.1666692948.git.leonro@nvidia.com
>  * Fixed misplaced "!" in sixth patch.
> v5: https://lore.kernel.org/all/cover.1666525321.git.leonro@nvidia.com
>  * Rebased to latest ipsec-next.
>  * Replaced HW priority patch with solution which mimics separated SPDs
>    for SW and HW. See more description in this cover letter.
>  * Dropped RFC tag, usecase, API and implementation are clear.
> v4: https://lore.kernel.org/all/cover.1662295929.git.leonro@nvidia.com
>  * Changed title from "PATCH" to "PATCH RFC" per-request.
>  * Added two new patches: one to update hard/soft limits and another
>    initial take on documentation.
>  * Added more info about lifetime/rekeying flow to cover letter, see
>    relevant section.
>  * perf traces for crypto mode will come later.
> v3: https://lore.kernel.org/all/cover.1661260787.git.leonro@nvidia.com
>  * I didn't hear any suggestion what term to use instead of
>    "packet offload", so left it as is. It is used in commit messages
>    and documentation only and easy to rename.
>  * Added performance data and background info to cover letter
>  * Reused xfrm_output_resume() function to support multiple XFRM transformations
>  * Add PMTU check in addition to driver .xdo_dev_offload_ok validation
>  * Documentation is in progress, but not part of this series yet.
> v2: https://lore.kernel.org/all/cover.1660639789.git.leonro@nvidia.com
>  * Rebased to latest 6.0-rc1
>  * Add an extra check in TX datapath patch to validate packets before
>    forwarding to HW.
>  * Added policy cleanup logic in case of netdev down event
> v1: https://lore.kernel.org/all/cover.1652851393.git.leonro@nvidia.com
>  * Moved comment to be before if (...) in third patch.
> v0: https://lore.kernel.org/all/cover.1652176932.git.leonro@nvidia.com
> -----------------------------------------------------------------------

Please move the Changelog to the end of the commit message.

Except of the minor nit I had in patch 4/8, the patchset looks
ready for merging. I'd prefer to merge it after the upcomming
merge window. But Linus might do a rc8, so I leave it up to you
in that case.

Thanks a lot Leon for your effort to make this patchset ready!
