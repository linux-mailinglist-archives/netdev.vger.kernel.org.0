Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7298959CD1A
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 02:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239044AbiHWARL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 20:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238815AbiHWARK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 20:17:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE897F14
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 17:17:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F4E6B8199E
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 00:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D2AC433C1;
        Tue, 23 Aug 2022 00:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661213827;
        bh=mQGFsJHJJ78gIcXRUAz4TFghli9l/QGaAoRbsmOA1/A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L3TzBe8h9RsAxNulAZvFshk1i/NGrelq4AmtFfCBCAn5S+W/LR4apTP23UT3DJHYD
         M82Jju1FUaGwTaV6xcUThxdjWxNOqwUEItLfCs9+HjyoEbsHPQqNbbQQMCuonpT6dU
         vKCvZSfZhDRI1hCrXm2V6G9IWc6nzY/g4E5rGQCtO9WvyqjiqXnCbrWN5wWxadhD55
         nBHzjNElNURU8icvNzORgFEDZljvpOmlVM/qb+8HnZiyXJxOR8ekBC5tw7QfZu3oTM
         4p8++N7756SGk7Hh6xo59hmXl4RcMiVF9h8tDKbCwOdwqOpTaMCvS6V60zIxjVeF8i
         HSUqSGu016P5w==
Date:   Mon, 22 Aug 2022 17:17:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <20220822171706.3287ee18@kernel.org>
In-Reply-To: <20220822212716.yji3ugbppse7snfy@sx1>
References: <20220817111052.0ddf40b0@kernel.org>
        <Yv3M/T5K/f35R5UM@unreal>
        <20220818193449.35c79b63@kernel.org>
        <Yv8lGtYIz4z043aI@unreal>
        <20220819084707.7ed64b72@kernel.org>
        <Yv+z0nBW60SBFAmZ@nvidia.com>
        <20220819105356.100003d5@kernel.org>
        <20220822084105.GI2602992@gauss3.secunet.de>
        <YwNEUguW7aTXC2Vs@unreal>
        <20220822093304.7ddc5d35@kernel.org>
        <20220822212716.yji3ugbppse7snfy@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Aug 2022 14:27:16 -0700 Saeed Mahameed wrote:
> >My questions about performance were more about where does
> >the performance loss originate. Is it because of loss of GRO?  
> 
> Performance loss between full and baseline ? it's hardly measurable .. 
> less than 3% in the worst case.

The loss for crypto only vs baseline is what I meant. Obviously if we
offload everything the CPU perf may look great but we're giving up
flexibility and ability to fix problems in SW. 
