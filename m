Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B5F61DBA4
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 16:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiKEP1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 11:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKEP1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 11:27:13 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7176222515
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 08:27:12 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 874D5201E4;
        Sat,  5 Nov 2022 16:27:10 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ew7IdnLSI5OQ; Sat,  5 Nov 2022 16:27:10 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0D09A201E2;
        Sat,  5 Nov 2022 16:27:10 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 0304180004A;
        Sat,  5 Nov 2022 16:27:10 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 5 Nov 2022 16:27:09 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 5 Nov
 2022 16:27:09 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id BFFB531829E1; Sat,  5 Nov 2022 16:27:08 +0100 (CET)
Date:   Sat, 5 Nov 2022 16:27:08 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Leon Romanovsky <leon@kernel.org>,
        "Chentian Liu" <chengtian.liu@corigine.com>,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        <netdev@vger.kernel.org>, <oss-drivers@corigine.com>
Subject: Re: [PATCH net-next v3 0/3] nfp: IPsec offload support
Message-ID: <20221105152708.GB2602992@gauss3.secunet.de>
References: <20221101110248.423966-1-simon.horman@corigine.com>
 <20221103204800.23e3adcf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221103204800.23e3adcf@kernel.org>
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

On Thu, Nov 03, 2022 at 08:48:00PM -0700, Jakub Kicinski wrote:
> On Tue,  1 Nov 2022 12:02:45 +0100 Simon Horman wrote:
> > It covers three enhancements:
> > 
> > 1. Patches 1/3:
> >    - Extend the capability word and control word to to support
> >      new features.
> > 
> > 2. Patch 2/3:
> >    - Add framework to support IPsec offloading for NFP driver,
> >      but IPsec offload control plane interface xfrm callbacks which
> >      interact with upper layer are not implemented in this patch.
> > 
> > 3. Patch 3/3:
> >    - IPsec control plane interface xfrm callbacks are implemented
> >      in this patch.
> 
> Steffen, Leon, does this look good to you?

The xfrm offload API is used correct, but can't speak
for the driver code.

For the xfrm API related part:

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
