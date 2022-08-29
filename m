Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4535A448F
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 10:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiH2IHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 04:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiH2IHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 04:07:39 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B5052FC6
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 01:07:36 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 576C220571;
        Mon, 29 Aug 2022 10:07:34 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2hm_r8KNrW7v; Mon, 29 Aug 2022 10:07:33 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id CFCBA2008D;
        Mon, 29 Aug 2022 10:07:33 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id C015280004A;
        Mon, 29 Aug 2022 10:07:33 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 29 Aug 2022 10:07:33 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 29 Aug
 2022 10:07:33 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 0C09C3182ABC; Mon, 29 Aug 2022 10:07:33 +0200 (CEST)
Date:   Mon, 29 Aug 2022 10:07:33 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH xfrm-next v3 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <20220829080733.GM566407@gauss3.secunet.de>
References: <cover.1661260787.git.leonro@nvidia.com>
 <20220825143610.4f13f730@kernel.org>
 <YwhnsWtzwC/wLq1i@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YwhnsWtzwC/wLq1i@unreal>
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

On Fri, Aug 26, 2022 at 09:26:57AM +0300, Leon Romanovsky wrote:
> On Thu, Aug 25, 2022 at 02:36:10PM -0700, Jakub Kicinski wrote:
> > On Tue, 23 Aug 2022 16:31:57 +0300 Leon Romanovsky wrote:
> > >  * I didn't hear any suggestion what term to use instead of
> > >    "full offload", so left it as is. It is used in commit messages
> > >    and documentation only and easy to rename.
> > >  * Added performance data and background info to cover letter
> > >  * Reused xfrm_output_resume() function to support multiple XFRM transformations
> > >  * Add PMTU check in addition to driver .xdo_dev_offload_ok validation
> > >  * Documentation is in progress, but not part of this series yet.
> > 
> > Since the use case is somewhat in question, perhaps switch to RFC
> > postings until the drivers side incl. tc forwarding is implemented?

+1

Please mark it as RFC as long as the full picture is not yet clear.
This is still far away from being ready for merging.

> 
> > Also the perf traces, I don't see them here.
> 
> It is worth to separate it to standalone discussion with a title:
> "why crypto is not fast enough?".

This is not the question. I want to know whether performance
comes from encapsulation/decapsulation offload, or lookup
offload, or something else.

Please provide the traces.

> I don't think that mixed discussions
> about full offload which Steffen said that he is interested and
> research about crypto bottlenecks will be productive. These discussions
> are orthogonal.

I'm interested in a 'full offload' but we need to make sure
this 'full offload' is able to support most of the common
usecases. It is still not clear whether this particular
offload you are proposing is the one that can make it.
