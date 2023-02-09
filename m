Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2ED668FC25
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 01:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbjBIAsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 19:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjBIAsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 19:48:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F221A948;
        Wed,  8 Feb 2023 16:48:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7ED2B81FDB;
        Thu,  9 Feb 2023 00:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6494C433EF;
        Thu,  9 Feb 2023 00:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675903689;
        bh=3c0hexa1YYrmxVLwEZ3WOjGCeQvFP2vjS060t04wVcc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WR1ATR8BQoMQ/uxW3ax04CnlCLZy18Lupc2BVVuj6J2oPh/4pCC9uPUxQPg9fIYcJ
         2JW+kzqU+EM65mfdKDoIogx+/D5Gmc8+Nqvf89Db0GGJzfM/JXl6Fwc7JUdkrrm+9g
         EPISQNCx+CXU/k6uysfOc+HhqvVAr3KrjhZVPnY1w88m9ZQjdmOk3flkP0g4LFY6+u
         YGWkm3pcwXYFDyecqJA1QZvgp8qjKv08ZNsLV5zMn3Ck/4rJLKlEVcxRoW1pt86T9u
         gvCxDsPiD+pEK2m2gUa56zqdsLe/DtF+DUvopK8vKtpPidfaYgTlJut06+1CCot/Bn
         ns5Z+91TkNCkg==
Date:   Wed, 8 Feb 2023 16:48:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <20230208164807.291d232f@kernel.org>
In-Reply-To: <Y+Q95U+61VaLC+RJ@nvidia.com>
References: <Y91pJHDYRXIb3rXe@x130>
        <20230203131456.42c14edc@kernel.org>
        <Y92kaqJtum3ImPo0@nvidia.com>
        <20230203174531.5e3d9446@kernel.org>
        <Y+EVsObwG4MDzeRN@nvidia.com>
        <20230206163841.0c653ced@kernel.org>
        <Y+KsG1zLabXexB2k@nvidia.com>
        <20230207140330.0bbb92c3@kernel.org>
        <Y+PKDOyUeU/GwA3W@nvidia.com>
        <20230208151922.3d2d790d@kernel.org>
        <Y+Q95U+61VaLC+RJ@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Feb 2023 20:27:17 -0400 Jason Gunthorpe wrote:
> On Wed, Feb 08, 2023 at 03:19:22PM -0800, Jakub Kicinski wrote:
> > On Wed, 8 Feb 2023 12:13:00 -0400 Jason Gunthorpe wrote:  
> > > I can't accept yours because it means RDMA stops existing. So we must
> > > continue with what has been done for the last 15 years - RDMA
> > > (selectively) mirrors the IP and everything running at or below the IP
> > > header level.  
> > 
> > Re-implement bits you need for configuration, not stop existing.  
> 
> This is completely technically infeasible. They share IP addresess, we
> cannot have two stacks running IPSEC on top of othe same IP address
> without co-ordinating. Almost every part is like that to some degree.
> 
> And even if we somehow did keep things 100% seperated, with seperated
> IPs - Linus isn't going to let me copy and paste the huge swaths of
> core netdev code required to do IP stuff (arp, nd, routing, icmp,
> bonding, etc) into RDMA for a reason like this.
> 
> So, it really is a complete death blow to demand to keep these things
> separated.
> 
> Let alone what would happen if we applied the same logic to all the
> places sharing the IP with HW - remember iscsi? FCoE?

Who said IP configuration.

> > > What do you mean? "make it all the same" can be done with private or
> > > open standards?  
> > 
> > Oh. If it's someone private specs its probably irrelevant to the open
> > source community?  
> 
> No, it's what I said I dislike. Private specs, private HW, private
> userspace, proprietary kernel forks, but people still try to get
> incomplete pieces of stuff into the mainline kernel.
> 
> > Sad situation. Not my employer and not in netdev, I hope.  
> 
> AFAIK your and my employer have done a good job together on joint
> projects over the years and have managed to end up with open source
> user spaces for almost everything subtantive in the kernel.

Great. Let's make a note of that so there are not more accusations 
that my objectives for netdev are somehow driven by evil hyperscalers.

> > > I have no idea how you are jumping to some conclusion that since the
> > > RDMA team made their patches it somehow has anything to do with the
> > > work Leon and the netdev team will deliver in future?  
> > 
> > We shouldn't reneg what was agreed on earlier.  
> 
> Who reneg'd? We always said we'd do it and we are still saying we plan
> to do it.
> 
> > > Hasn't our netdev team done enough work on TC stuff to earn some
> > > faith that we do actually care about TC as part of our portfolio?  
> > 
> > Shouldn't have brought it up in the past discussion then :|
> > Being asked to implement something tangential to your goals for 
> > the community to accept your code is hardly unheard of.  
> 
> We agreed to implement. I'm asking for patience since we have a good
> historical track record.

If you can't make a strong commitment, what's the point in time,
at which if I were angry that the tc redirect was not posted yet -
you'd consider it understandable?
Perhaps that's sufficiently not legally binding? :)
