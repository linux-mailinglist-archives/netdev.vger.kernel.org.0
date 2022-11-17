Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE4A62DA96
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239675AbiKQMYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiKQMYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:24:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36FFBCA6
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:24:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75274B81FE9
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 12:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DB8C433C1;
        Thu, 17 Nov 2022 12:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668687868;
        bh=/6r9bsZ51eJncQSLdOnLnVSosxSPH53WrodyobxXhMg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CzM84lNi0XV3MvwKs2WeiIwEJaA5wQsYz+SRXgbGK0SmpmFdaq2o78/WYDdqzkZR7
         RN9fstzIh4Pg184jgzu33L0pMxgJIrcuxFQmgh8HaY11csuGTUwHJPR75oCT31mDW8
         3k1ktdA63GBxXaOM6mKLOy8vrOKT7GKnljlYWF12iDfJEGHLyYND78KJFvsJVl+zyt
         cZFji/70T2YaBLzArSNc86r9I0dTKdld04AJkSiptUjYx9MRX/ZFJF834jKT85JnpB
         0670vCK3A4ZWBa75eYGCopMzjnhp06uI740e/G+xT85x3zp62xqrWZTIVMVeo8Lknq
         zS5OLkLvZ784A==
Date:   Thu, 17 Nov 2022 14:24:23 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 0/8] Extend XFRM core to allow packet
 offload configuration
Message-ID: <Y3Yn90QVqa8xiOx8@unreal>
References: <cover.1667997522.git.leonro@nvidia.com>
 <Y3PV7HM5cDoZogCY@unreal>
 <20221115183020.GA704954@gauss3.secunet.de>
 <Y3Ph4Lnf2vV0Hx3U@unreal>
 <Y3VtIWHAyjZeJVDh@x130.lan>
 <20221117122043.GM704954@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117122043.GM704954@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 01:20:43PM +0100, Steffen Klassert wrote:
> On Wed, Nov 16, 2022 at 03:07:13PM -0800, Saeed Mahameed wrote:
> > On 15 Nov 21:00, Leon Romanovsky wrote:
> > > On Tue, Nov 15, 2022 at 07:30:20PM +0100, Steffen Klassert wrote:
> > > > On Tue, Nov 15, 2022 at 08:09:48PM +0200, Leon Romanovsky wrote:
> > > > > On Wed, Nov 09, 2022 at 02:54:28PM +0200, Leon Romanovsky wrote:
> > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > >
> > > > > > Changelog:
> > > > > > v7: As was discussed in IPsec workshop:
> > > > >
> > > > > Steffen, can we please merge the series so we won't miss another kernel
> > > > > release?
> > > > 
> > > > I'm already reviewing the patchset. But as I said at the
> > > > IPsec workshop, there is no guarantee that it will make
> > > > it during this release cycle.
> > > 
> > 
> > BTW mlx5 patches are almost ready and fully reviewed, will be ready by
> > early next week.
> > 
> > Steffen in case you will be ready, how do you want to receive the whole
> > package? I guess we will need to post all the patches for a final time,
> > including mlx5 driver.
> 
> I guess you want me to take both, the xfrm and mlx5 patches, right?

Yes

> I'm ok with that if nobody else objects to it.
> 
> Please split it anyways into a xfrm and a mlx5 pachset. I'll
> merge both separate once we are ready.
> 
> 
> Thanks!
