Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B026EACD9
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbjDUO2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjDUO2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:28:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF25030E9;
        Fri, 21 Apr 2023 07:28:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 448CD619AC;
        Fri, 21 Apr 2023 14:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB40C433D2;
        Fri, 21 Apr 2023 14:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682087318;
        bh=AzfPnAUc3z8qzBjnjgulDz6zl9zCld31PMAUqciQslw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bHb/jLpHdKFAi1nDJtxWoUBINsBxoBKEeXYcW8nFOxUoG72B1fVizGLgfJgM/0tnV
         m+YW/jFTmVGnPRg6ggs43pnYlsBL+lWWYgVPET/1NbO6VRTITrFg1CiiOJHcFiGBFH
         qjw/vAsBaX+okguwAada5Ntlvvkq9V4X7AD3tCo3s3JzlXNUFrl15/mpSd3Wgfu7rS
         DnGqcitl72wIz+UWJfEqjnlYzHnIAHLgvxH5TzwJOLkxFEpxNK6jnxUDWPXNkDQ7I2
         U9tiZGmo5SZx5yuNb6Z6RZWqsAYx+DwqzCRwwhWF0zlo62+Yq+6LnTq8XjJW54jhmP
         UhXcFNC0vr2nQ==
Date:   Fri, 21 Apr 2023 07:28:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tejun Heo <tj@kernel.org>
Cc:     jiangshanlai@gmail.com, linux-kernel@vger.kernel.org,
        kernel-team@meta.com, Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH 06/22] net: thunderx: Use alloc_ordered_workqueue() to
 create ordered workqueues
Message-ID: <20230421072837.1495599b@kernel.org>
In-Reply-To: <ZEKaABXSb-KppyMO@slm.duckdns.org>
References: <20230421025046.4008499-1-tj@kernel.org>
        <20230421025046.4008499-7-tj@kernel.org>
        <20230421070108.638cce01@kernel.org>
        <ZEKaABXSb-KppyMO@slm.duckdns.org>
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

On Fri, 21 Apr 2023 04:13:20 -1000 Tejun Heo wrote:
> On Fri, Apr 21, 2023 at 07:01:08AM -0700, Jakub Kicinski wrote:
> > On Thu, 20 Apr 2023 16:50:30 -1000 Tejun Heo wrote:  
> > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > > Cc: Sunil Goutham <sgoutham@marvell.com>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > Cc: linux-arm-kernel@lists.infradead.org
> > > Cc: netdev@vger.kernel.org  
> > 
> > You take this via your tree directly to Linus T?  
> 
> Yeah, that'd be my preference unless someone is really against it.

Acked-by: Jakub Kicinski <kuba@kernel.org>
