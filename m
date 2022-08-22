Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF2559BABA
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 10:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbiHVIBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 04:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbiHVIBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 04:01:15 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367532A41E
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 01:01:14 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8E36B20504;
        Mon, 22 Aug 2022 10:01:10 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RGcnhViUoZ_Q; Mon, 22 Aug 2022 10:01:09 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4658C2063B;
        Mon, 22 Aug 2022 10:01:09 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 3184C80004A;
        Mon, 22 Aug 2022 10:01:09 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 22 Aug 2022 10:01:09 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 22 Aug
 2022 10:01:08 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 8334B3182A10; Mon, 22 Aug 2022 10:01:08 +0200 (CEST)
Date:   Mon, 22 Aug 2022 10:01:08 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 2/6] xfrm: allow state full offload mode
Message-ID: <20220822080108.GE2602992@gauss3.secunet.de>
References: <cover.1660639789.git.leonro@nvidia.com>
 <de9490892eefc33723c1ae803adf881ad8ea621a.1660639789.git.leonro@nvidia.com>
 <20220818101220.GD566407@gauss3.secunet.de>
 <Yv4+bFE3Ck96TFP3@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Yv4+bFE3Ck96TFP3@unreal>
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

On Thu, Aug 18, 2022 at 04:28:12PM +0300, Leon Romanovsky wrote:
> On Thu, Aug 18, 2022 at 12:12:20PM +0200, Steffen Klassert wrote:
> > On Tue, Aug 16, 2022 at 11:59:23AM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Allow users to configure xfrm states with full offload mode.
> > > The full mode must be requested both for policy and state, and
> > > such requires us to do not implement fallback.
> > > 
> > > We explicitly return an error if requested full mode can't
> > > be configured.
> > > 
> > > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > 
> > This one needs to be ACKed by the driver maintainers.
> 
> Why? Only crypto is supported in upstream kernel.

Because it touches code hat is under their maintainance.
They should at least be CCed on this patch.

