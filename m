Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07EC59D065
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 07:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239897AbiHWFWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 01:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiHWFWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 01:22:08 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003F24F6A9
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 22:22:06 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1556720573;
        Tue, 23 Aug 2022 07:22:05 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Pwl48e0BPuqt; Tue, 23 Aug 2022 07:22:04 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 74111204E0;
        Tue, 23 Aug 2022 07:22:04 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 5F4B080004A;
        Tue, 23 Aug 2022 07:22:04 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 23 Aug 2022 07:22:04 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 23 Aug
 2022 07:22:03 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 7A11F3182BC2; Tue, 23 Aug 2022 07:22:03 +0200 (CEST)
Date:   Tue, 23 Aug 2022 07:22:03 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeed@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, "Raed Salem" <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <20220823052203.GI2950045@gauss3.secunet.de>
References: <20220818193449.35c79b63@kernel.org>
 <Yv8lGtYIz4z043aI@unreal>
 <20220819084707.7ed64b72@kernel.org>
 <Yv+z0nBW60SBFAmZ@nvidia.com>
 <20220819105356.100003d5@kernel.org>
 <20220822084105.GI2602992@gauss3.secunet.de>
 <YwNEUguW7aTXC2Vs@unreal>
 <20220822093304.7ddc5d35@kernel.org>
 <20220822212716.yji3ugbppse7snfy@sx1>
 <20220822171706.3287ee18@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220822171706.3287ee18@kernel.org>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
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

On Mon, Aug 22, 2022 at 05:17:06PM -0700, Jakub Kicinski wrote:
> On Mon, 22 Aug 2022 14:27:16 -0700 Saeed Mahameed wrote:
> > >My questions about performance were more about where does
> > >the performance loss originate. Is it because of loss of GRO?  
> > 
> > Performance loss between full and baseline ? it's hardly measurable .. 
> > less than 3% in the worst case.
> 
> The loss for crypto only vs baseline is what I meant. Obviously if we
> offload everything the CPU perf may look great but we're giving up
> flexibility and ability to fix problems in SW. 

The main difference between baseline TCP and crypto offload
is the policy/state lookup and ESP encapsulation/decapsulation.

We don't loose GRO on crypto offload. The ESP header/trailer
is stripped away in the GRO layer so that the inner TCP
packet gets GRO. But we loose hardware LRO, as the ESP
headers are not stripped in HW.

It would be really good to see where the bottlenecks are
with crypto offload (RX or TX).

Also, it would be good to see why the full offload performs
better. Some perf traces would be helpfull.

When I thought about possible offloads, I came to three
different types:

1. encapsulation offload:
   - Kernel does policy enforcement
   - NIC does encapsulation
   - NIC manages anti replay window and lifetime of SAs
   - NIC sends lifetime and anti replay notifications to the kernel
   - The Kernel talks to the keymanager

2. statefull offload with fallback:
   - NIC handles the full datapath, but kernel can take over (fragments
     etc.)
   - Kernel and NIC hold the full SA and policy database
   - Kernel and NIC must sync the state (lifetime, replay window etc.)
     of SAs and policies
   - The Kernel talks to the keymanager

3. statefull offload:
   - NIC handles the full datapath
   - NIC talks directly with the keymanager
   - Kernel xfrm acts as a stub layer to pass messages from
     userspace to the NIC.

The offload that is implemented here comes option 2 closest.
The statefull handling is shared between host and NIC.
Unfortunalely, this is the most complicated one.

If just encapsulation/decapsulation brings the performance
we could also go with option 1. That would be still a
stateless offload.

Option 3 is what I would consider as a full offload.
Kernel acts as a stateless stub layer, NIC does
statefull IPsec.
