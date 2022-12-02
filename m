Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB1E640EAE
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 20:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbiLBTp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 14:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234842AbiLBTpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 14:45:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7E1F3FAA
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 11:45:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E3A0B8227C
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 19:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92060C433C1;
        Fri,  2 Dec 2022 19:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670010352;
        bh=vUtP8x9B8LUf5/RA8ktdj9/DeOwpldr1fHQ3zkNKuo8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L0Ja4EOUZobr+qlN3ZdkTVwZYpWUpwsPaTnTJBpR0cCBSdJbao+fye5WZ7SOu+4pT
         S73c9bMWPSK0vC5LRKQoEwOCqgiv+5xDVfB/RU9FUpQ8ABl77pMQglqdJxKFh6khx2
         5q6+FjklOwUm3e2cCkjmC/457arZDXB/bQj1azVAP9X/RX4KQ9IkIs0o80XiRfmWXh
         eamEW0eWu4LsuhNdu07Ujg6Q1aHWQ16BO87MSr+7Nvw+2dya/heZe8mG5swcsEE2ZQ
         es5r0exHSDq2vY6LsTTfljqntZ2xGdimeBwz1PhOdCyaOIU8reOegDyShrYz6uOm14
         Klzx8kP24CO6A==
Date:   Fri, 2 Dec 2022 21:45:47 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH xfrm-next v9 0/8] Extend XFRM core to allow packet
 offload configuration
Message-ID: <Y4pV6+LxhyDO2Ufz@unreal>
References: <cover.1669547603.git.leonro@nvidia.com>
 <20221202094243.GA704954@gauss3.secunet.de>
 <Y4o+X0bOz0hHh9bL@unreal>
 <20221202101000.0ece5e81@kernel.org>
 <Y4pEknq2Whbw/Z2S@unreal>
 <20221202112607.5c55033a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202112607.5c55033a@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 11:26:07AM -0800, Jakub Kicinski wrote:
> On Fri, 2 Dec 2022 20:31:46 +0200 Leon Romanovsky wrote:
> > Not really, it is a matter of trust.
> 
> More of a question of whether we can reasonably expect to merge all 
> the driver code in a single release cycle. If not then piecemeal
> merging is indeed inevitable. But if Steffen is happy with the core
> changes whether they are in tree for 6.2 or not should not matter.
> An upstream user can't access them anyway, it'd only matter to an
> out-of-tree consumer.
> 
> That's just my 2 cents, whatever Steffen prefers matters most.

There are no out-of-tree users, just ton of mlx5 refactoring to natively
support packet offload.

> 
> > The driver exists https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=xfrm-next
> > and it is a lot of code (28 patches for now) which is more natural for us to route through
> > traditional path.
> > 
> > If you are not convinced, I can post all these patches to the ML right now
> > and Steffen will send them to you.
