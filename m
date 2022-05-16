Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8FB528D8A
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 20:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345220AbiEPS4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 14:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345213AbiEPS4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 14:56:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36BA10FFE
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 11:56:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EC65614B5
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 18:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3DDC385AA;
        Mon, 16 May 2022 18:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652727396;
        bh=1Jrsisefyx7gryXCMtEMpdeXmuU04Tn09BK0UktrJ1A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UTUh/aFGjy5gCSBIYqjesAU+SzGhQ3eHPdOZzo2M3M1ApNb3X48QUEg9e+dCbczIR
         3dz/EQYummQYrtoEklncpzGcaf3RsUo749rAU0u9m8xowz3TsTSmMcoA29WEjcleWI
         tbWDJZk2btbeG2snpioorA3/4a//1bvouF2uOjxOasZKy1F06F6y6s8tejMwJixfEU
         c+dX6KGaR9TudQZqkVv/4fGsCK/UOMXKDn2b2rf5XBnr2qUN6x5FpZHm86ylu3zkcd
         MdjlqSp5Rk0wSCQ71rAN2xglCtFLIM5nK4TRogAwsydRIJCzKAAujVqU+Q3FFAtHbt
         slvFmLaJhyIgg==
Date:   Mon, 16 May 2022 11:56:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 4/4] net: call skb_defer_free_flush() before
 each napi_poll()
Message-ID: <20220516115634.4417e3eb@kernel.org>
In-Reply-To: <CANn89iL9xw83hEGA4=K-F1qkjyRhvAJ85c9W5nY1Fsmq777V0A@mail.gmail.com>
References: <20220516042456.3014395-1-eric.dumazet@gmail.com>
        <20220516042456.3014395-5-eric.dumazet@gmail.com>
        <20220516112140.0f088427@kernel.org>
        <CANn89iL9xw83hEGA4=K-F1qkjyRhvAJ85c9W5nY1Fsmq777V0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 May 2022 11:26:14 -0700 Eric Dumazet wrote:
> On Mon, May 16, 2022 at 11:21 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Sun, 15 May 2022 21:24:56 -0700 Eric Dumazet wrote:  
> > > -end:
> > > -     skb_defer_free_flush(sd);
> > > +end:;  
> >
> > Sorry for the nit pick but can I remove this and just return like we
> > did before f3412b3879b4? Is there a reason such "label:;}" is good?  
> 
> I thought that having a return in the middle of this function would
> hurt us at some point.

I guess personal preference. Let's leave it unless someone else shares
my disregard for pointlessly jumping to the closing bracket :)
