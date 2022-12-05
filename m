Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB636425B6
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiLEJXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbiLEJXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:23:08 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43D9B48E
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 01:23:07 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8B669201D5;
        Mon,  5 Dec 2022 10:23:05 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8-y1fY4eyr-3; Mon,  5 Dec 2022 10:23:05 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 18BFF201A1;
        Mon,  5 Dec 2022 10:23:05 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 129BA80004A;
        Mon,  5 Dec 2022 10:23:05 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Dec 2022 10:23:04 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 5 Dec
 2022 10:23:04 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 5D94F3182D71; Mon,  5 Dec 2022 10:23:04 +0100 (CET)
Date:   Mon, 5 Dec 2022 10:23:04 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH xfrm-next v9 0/8] Extend XFRM core to allow packet
 offload configuration
Message-ID: <20221205092304.GC704954@gauss3.secunet.de>
References: <cover.1669547603.git.leonro@nvidia.com>
 <20221202094243.GA704954@gauss3.secunet.de>
 <Y4o+X0bOz0hHh9bL@unreal>
 <20221202101000.0ece5e81@kernel.org>
 <Y4pEknq2Whbw/Z2S@unreal>
 <20221202112607.5c55033a@kernel.org>
 <Y4pV6+LxhyDO2Ufz@unreal>
 <20221202115213.0055aa4a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221202115213.0055aa4a@kernel.org>
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

On Fri, Dec 02, 2022 at 11:52:13AM -0800, Jakub Kicinski wrote:
> On Fri, 2 Dec 2022 21:45:47 +0200 Leon Romanovsky wrote:
> > > More of a question of whether we can reasonably expect to merge all 
> > > the driver code in a single release cycle. If not then piecemeal
> > > merging is indeed inevitable. But if Steffen is happy with the core
> > > changes whether they are in tree for 6.2 or not should not matter.
> > > An upstream user can't access them anyway, it'd only matter to an
> > > out-of-tree consumer.
> > > 
> > > That's just my 2 cents, whatever Steffen prefers matters most.  
> > 
> > There are no out-of-tree users, just ton of mlx5 refactoring to natively
> > support packet offload.
> 
> 30 patches is just two series, that's mergeable in a week.
> You know, if it builds cleanly.. :S  Dunno.

The core changes are ready, so there is no real reason
to hold them off.

I had not yet a closer look to the driver changes, though.

I've just updated ipsec-next, whatever builds with ipsec-next
should build with net-next now. In case the driver changes
do not genarate any fallouts, I can take them into ipsec-next
as well.

The two driver series and the core series would be about 40
patches. If you are ok with taking such a last minute PR
into net-next, we can go that way.
