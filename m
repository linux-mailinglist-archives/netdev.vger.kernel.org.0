Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A30FF62DA8C
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239327AbiKQMUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbiKQMUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:20:46 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBE1CDB
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:20:46 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id F1084204D9;
        Thu, 17 Nov 2022 13:20:44 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7KXTPRjn0OPE; Thu, 17 Nov 2022 13:20:44 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 78C5E2019C;
        Thu, 17 Nov 2022 13:20:44 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 7329080004A;
        Thu, 17 Nov 2022 13:20:44 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 13:20:44 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 17 Nov
 2022 13:20:43 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id A747D31808E0; Thu, 17 Nov 2022 13:20:43 +0100 (CET)
Date:   Thu, 17 Nov 2022 13:20:43 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH xfrm-next v7 0/8] Extend XFRM core to allow packet
 offload configuration
Message-ID: <20221117122043.GM704954@gauss3.secunet.de>
References: <cover.1667997522.git.leonro@nvidia.com>
 <Y3PV7HM5cDoZogCY@unreal>
 <20221115183020.GA704954@gauss3.secunet.de>
 <Y3Ph4Lnf2vV0Hx3U@unreal>
 <Y3VtIWHAyjZeJVDh@x130.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y3VtIWHAyjZeJVDh@x130.lan>
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

On Wed, Nov 16, 2022 at 03:07:13PM -0800, Saeed Mahameed wrote:
> On 15 Nov 21:00, Leon Romanovsky wrote:
> > On Tue, Nov 15, 2022 at 07:30:20PM +0100, Steffen Klassert wrote:
> > > On Tue, Nov 15, 2022 at 08:09:48PM +0200, Leon Romanovsky wrote:
> > > > On Wed, Nov 09, 2022 at 02:54:28PM +0200, Leon Romanovsky wrote:
> > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > >
> > > > > Changelog:
> > > > > v7: As was discussed in IPsec workshop:
> > > >
> > > > Steffen, can we please merge the series so we won't miss another kernel
> > > > release?
> > > 
> > > I'm already reviewing the patchset. But as I said at the
> > > IPsec workshop, there is no guarantee that it will make
> > > it during this release cycle.
> > 
> 
> BTW mlx5 patches are almost ready and fully reviewed, will be ready by
> early next week.
> 
> Steffen in case you will be ready, how do you want to receive the whole
> package? I guess we will need to post all the patches for a final time,
> including mlx5 driver.

I guess you want me to take both, the xfrm and mlx5 patches, right?
I'm ok with that if nobody else objects to it.

Please split it anyways into a xfrm and a mlx5 pachset. I'll
merge both separate once we are ready.


Thanks!
