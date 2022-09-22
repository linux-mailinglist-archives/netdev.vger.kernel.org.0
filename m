Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFCD75E5C86
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 09:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiIVHgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 03:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiIVHf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 03:35:59 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4A2CDCE1
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 00:35:57 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1439E2050A;
        Thu, 22 Sep 2022 09:35:56 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fyktX0dg2AL1; Thu, 22 Sep 2022 09:35:55 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 907CC20265;
        Thu, 22 Sep 2022 09:35:55 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 7F56180004A;
        Thu, 22 Sep 2022 09:35:55 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 09:35:55 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 22 Sep
 2022 09:35:54 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 7EB2C3180DDF; Thu, 22 Sep 2022 09:35:54 +0200 (CEST)
Date:   Thu, 22 Sep 2022 09:35:54 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH RFC xfrm-next v3 0/8] Extend XFRM core to allow full
 offload configuration
Message-ID: <20220922073554.GH2950045@gauss3.secunet.de>
References: <cover.1662295929.git.leonro@nvidia.com>
 <Yyg23x8HtBqiB1Oc@unreal>
 <YywMCztNrTxE5QqC@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YywMCztNrTxE5QqC@unreal>
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

On Thu, Sep 22, 2022 at 10:17:31AM +0300, Leon Romanovsky wrote:
> On Mon, Sep 19, 2022 at 12:31:11PM +0300, Leon Romanovsky wrote:
> > On Sun, Sep 04, 2022 at 04:15:34PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > <...>
> > 
> > > Leon Romanovsky (8):
> > >   xfrm: add new full offload flag
> > >   xfrm: allow state full offload mode
> > >   xfrm: add an interface to offload policy
> > >   xfrm: add TX datapath support for IPsec full offload mode
> > >   xfrm: add RX datapath protection for IPsec full offload mode
> > >   xfrm: enforce separation between priorities of HW/SW policies
> > >   xfrm: add support to HW update soft and hard limits
> > >   xfrm: document IPsec full offload mode
> > 
> > Kindly reminder.
> 
> Hi Steffen,
> 
> Can we please progress with the series? I would like to see it is merged
> in this merge window, so I will be able to progress with iproute2 and mlx5
> code too.
> 
> It is approximately 3 weeks already in the ML without any objections.
> The implementation proposed here has nothing specific to our HW and
> applicable to other vendors as well.

I've just replied to our private thread about this. I'll have a look
at the patches tomorrow. I've just returned from vacation and still
a bit backloged...
