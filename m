Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 227016DEFE8
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 10:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjDLI4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 04:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbjDLI4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 04:56:04 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC82A5CA
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 01:55:46 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3B25D207CA;
        Wed, 12 Apr 2023 10:55:27 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rfSR8ACPCgFM; Wed, 12 Apr 2023 10:55:26 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id C9298207AC;
        Wed, 12 Apr 2023 10:55:26 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id C418280004A;
        Wed, 12 Apr 2023 10:55:26 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 10:55:26 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 12 Apr
 2023 10:55:26 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id E13273180C1D; Wed, 12 Apr 2023 10:55:25 +0200 (CEST)
Date:   Wed, 12 Apr 2023 10:55:25 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>,
        Christian Langrock <christian.langrock@secunet.com>,
        Antony Antony <antony.antony@secunet.com>
Subject: Re: [PATCH ipsec] xfrm: don't check the default policy if the policy
 allows the packet
Message-ID: <ZDZx/Up5cbm1L07s@gauss3.secunet.de>
References: <0cafbebeba54747b04a72d0fc06aa2ad569f3739.1680613644.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0cafbebeba54747b04a72d0fc06aa2ad569f3739.1680613644.git.sd@queasysnail.net>
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

On Tue, Apr 04, 2023 at 03:12:16PM +0200, Sabrina Dubroca wrote:
> The current code doesn't let a simple "allow" policy counteract a
> default policy blocking all incoming packets:
> 
>     ip x p setdefault in block
>     ip x p a src 192.168.2.1/32 dst 192.168.2.2/32 dir in action allow
> 
> At this stage, we have an allow policy (with or without transforms)
> for this packet. It doesn't matter what the default policy says, since
> the policy we looked up lets the packet through. The case of a
> blocking policy is already handled separately, so we can remove this
> check.
> 
> Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Applied, thanks a lot Sabrina!
