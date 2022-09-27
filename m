Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3B05EBA40
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 07:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiI0F7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 01:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiI0F7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 01:59:08 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FCA9A689
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 22:59:07 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5B1C1204B4;
        Tue, 27 Sep 2022 07:59:05 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wThiOc5fhoWP; Tue, 27 Sep 2022 07:59:04 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D860C2008D;
        Tue, 27 Sep 2022 07:59:04 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id C58D580004A;
        Tue, 27 Sep 2022 07:59:04 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 07:59:04 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 27 Sep
 2022 07:59:04 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D87EC31829E5; Tue, 27 Sep 2022 07:59:03 +0200 (CEST)
Date:   Tue, 27 Sep 2022 07:59:03 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH RFC xfrm-next v3 0/8] Extend XFRM core to allow full
 offload configuration
Message-ID: <20220927055903.GN2950045@gauss3.secunet.de>
References: <cover.1662295929.git.leonro@nvidia.com>
 <Yxm8QFvtMcpHWzIy@unreal>
 <20220921075927.3ace0307@kernel.org>
 <YytLwlvza1ulmyTd@unreal>
 <20220925094039.GV2602992@gauss3.secunet.de>
 <YzFM8RF0suHc4cKI@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YzFM8RF0suHc4cKI@unreal>
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

On Mon, Sep 26, 2022 at 09:55:45AM +0300, Leon Romanovsky wrote:
> On Sun, Sep 25, 2022 at 11:40:39AM +0200, Steffen Klassert wrote:
> > On Wed, Sep 21, 2022 at 08:37:06PM +0300, Leon Romanovsky wrote:
> > > On Wed, Sep 21, 2022 at 07:59:27AM -0700, Jakub Kicinski wrote:
> > > > On Thu, 8 Sep 2022 12:56:16 +0300 Leon Romanovsky wrote:
> > > > > I have TX traces too and can add if RX are not sufficient. 
> > > > 
> > > > The perf trace is good, but for those of us not intimately familiar
> > > > with xfrm, could you provide some analysis here?
> > > 
> > > The perf trace presented is for RX path of IPsec crypto offload mode. In that
> > > mode, decrypted packet enters the netdev stack to perform various XFRM specific
> > > checks.
> > 
> > Can you provide the perf traces and analysis for the TX side too? That
> > would be interesting in particular, because the policy and state lookups
> > there happen still in software.
> 
> Single core TX (crypto mode) from the same run:
> Please notice that it is not really bottleneck, probably RX caused to the situation
> where TX was not executed enough. It is also lighter path than RX.

Thanks for this! How many policies and SAs were installed when you ran
this? A run with 'many' policies and SAs would be interesting, in
particualar a comparison between crypto and full offload. That would
show us where the performance of the full offload comes from.
