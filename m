Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACFA85BEB6F
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 18:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiITQzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 12:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiITQzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 12:55:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877482CDF8;
        Tue, 20 Sep 2022 09:54:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CB8262B70;
        Tue, 20 Sep 2022 16:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79C0C433D7;
        Tue, 20 Sep 2022 16:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663692893;
        bh=naQ9TGqjs/6Tv01+ZlpFJ6fRMOW6xD9axuS8tfmfwLw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aKCeMcz1wGH7PRG+qwP9yuMzTD/THIS5jhksGX9qNxedZ0j/ejP0B+bt9syhoXM6l
         GlPXwpwI7bqnvOo4pTIEeIKcGELAAnFf4cZT/V2uu+KYEEdaS6RX1BMypmGGfzpUay
         SEA1Gz93NNT1qqlLDHY7T0hP+3sL2wA7c615JQj6PD8gCX98k24clMoJlcUhZ73J8s
         RY78PBCvQWGvai7wJSy2ta1KaaZNfe+l8wd5PRdJSr9rogdm9ryDE19dgJmOdxUW/k
         y5Bk5HRf0tJ6DyWPNqFbSNW66h/kcz5sboO4FO1QE1u+3KSJTtv329fp2ltjBfADHd
         GDlFKIHOqYL6A==
Date:   Tue, 20 Sep 2022 19:54:49 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Long Li <longli@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [Patch v5 00/12] Introduce Microsoft Azure Network Adapter
 (MANA) RDMA driver
Message-ID: <YynwWTNv04r0xAvL@unreal>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
 <PH7PR21MB3263E057A08312F679F8576ACE439@PH7PR21MB3263.namprd21.prod.outlook.com>
 <YxvRkW+u1jgOLD5X@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxvRkW+u1jgOLD5X@ziepe.ca>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 09, 2022 at 08:51:45PM -0300, Jason Gunthorpe wrote:
> On Fri, Sep 09, 2022 at 09:41:25PM +0000, Long Li wrote:
> 
> > Can you take a look at this patch set. I have addressed all the
> > comments from previous review.
> 
> The last time I looked I thought it was looking OK, I was thinking of
> putting it in linux-next for a while to get the static checkers
> happy. But the netdev patches gave me pause on that plan.
> 
> However, Leon and I will be at LPC all next week so I don't know if it
> will happen.
> 
> I would also like to see that the netdev patches are acked, and ask how
> you expect this cross-tree series to be merged?

?????? 

> 
> Jason
