Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08EC05EBF2D
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 12:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbiI0KDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 06:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbiI0KDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 06:03:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776BD9552A
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 03:03:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33CF2B81A9A
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 10:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F6BC433D7;
        Tue, 27 Sep 2022 10:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664272981;
        bh=I+5Lu4Xa8nxZQ9FivaowX6IwijvJgdFzHgEJxu9ZxBY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l6j2NuJK6TCHgTwn4iYAUNm0PIGKvDZk/nMxuyhZLn9y2BRMRj89QUBP0TKDxylRO
         hzWoO+ycsIi8iCbEL0u4TthqXlwl388+5tjXAbBRSvfcZCRMd99+4fJUSXNAhuVsB0
         3Pv+rusWguu+xqOkw1ipe3eCbAndKKYLGPKrh8mjN6KT91KRbIkblZcLigyu3Uupdi
         MSjScBysrE9BzDQ9PNpvPAuuWOgRoXXJg7qr9jvt+7YaUN/PS4KHRoZlAfWwNDixUL
         pHHb76SRYhSNjp1wdPWJhLa4FUarE10uluaLxHDHCxcZ44sFwR16Elr9XCUkoRCG9D
         2j5OjMMxXMt5w==
Date:   Tue, 27 Sep 2022 13:02:56 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH RFC xfrm-next v3 0/8] Extend XFRM core to allow full
 offload configuration
Message-ID: <YzLKUO9deDyWHiWo@unreal>
References: <cover.1662295929.git.leonro@nvidia.com>
 <Yxm8QFvtMcpHWzIy@unreal>
 <20220921075927.3ace0307@kernel.org>
 <YytLwlvza1ulmyTd@unreal>
 <20220925094039.GV2602992@gauss3.secunet.de>
 <YzFM8RF0suHc4cKI@unreal>
 <20220927055903.GN2950045@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927055903.GN2950045@gauss3.secunet.de>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 07:59:03AM +0200, Steffen Klassert wrote:
> On Mon, Sep 26, 2022 at 09:55:45AM +0300, Leon Romanovsky wrote:
> > On Sun, Sep 25, 2022 at 11:40:39AM +0200, Steffen Klassert wrote:
> > > On Wed, Sep 21, 2022 at 08:37:06PM +0300, Leon Romanovsky wrote:
> > > > On Wed, Sep 21, 2022 at 07:59:27AM -0700, Jakub Kicinski wrote:
> > > > > On Thu, 8 Sep 2022 12:56:16 +0300 Leon Romanovsky wrote:
> > > > > > I have TX traces too and can add if RX are not sufficient. 
> > > > > 
> > > > > The perf trace is good, but for those of us not intimately familiar
> > > > > with xfrm, could you provide some analysis here?
> > > > 
> > > > The perf trace presented is for RX path of IPsec crypto offload mode. In that
> > > > mode, decrypted packet enters the netdev stack to perform various XFRM specific
> > > > checks.
> > > 
> > > Can you provide the perf traces and analysis for the TX side too? That
> > > would be interesting in particular, because the policy and state lookups
> > > there happen still in software.
> > 
> > Single core TX (crypto mode) from the same run:
> > Please notice that it is not really bottleneck, probably RX caused to the situation
> > where TX was not executed enough. It is also lighter path than RX.
> 
> Thanks for this! How many policies and SAs were installed when you ran
> this? A run with 'many' policies and SAs would be interesting, in
> particualar a comparison between crypto and full offload. That would
> show us where the performance of the full offload comes from.

It was 160 CPU machine with policy/SA per-CPU and direction. In total,
320 policies and 320 SAs.

Thanks
