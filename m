Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E36E6A1434
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 01:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjBXAOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 19:14:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjBXAOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 19:14:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FD7367F0;
        Thu, 23 Feb 2023 16:14:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD2F3B81B62;
        Fri, 24 Feb 2023 00:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D6FC4339B;
        Fri, 24 Feb 2023 00:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677197647;
        bh=pxsOlmDcn8rqApXYpi2YrQEedwKEHyetbC9Qk5eYDmw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TdUoHijHx2Fo3uYYbPKS9tIBfcK6rDvpr1aGWyGgnq92h8OKrdyjnd3vN5+y7xqaV
         3h195BfFTPFQnQ82JJON2axQM7TXtI8Snw+5tjODLD2s8K5DC9lA9pSzxaEB3tmADD
         T+Ze2j/sUpOaK1p3IjankdsqR/zG3XjOAuqnkPGqkcCCrgV/GUK2h1VDi0sng9xkmL
         AcXGMxRRn8b8ROxHf+UkbfeMy523Idyu7OTGKsj207CG4P3JqCt6L89gtJ/ZZtH/1A
         ux6Xc8dJNV40ROxVpaEQAsrzWC4/gMIe36nZYvHkJs9JLUaHsxQZa4C5Cb/x7CUj8h
         Mzlwnr3TVBmeA==
Date:   Thu, 23 Feb 2023 16:14:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Leon Romanovsky <leon@kernel.org>, davem@davemloft.net,
        phaddad@nvidia.com, edumazet@google.com,
        linux-rdma@vger.kernel.org, markzhang@nvidia.com,
        netdev@vger.kernel.org, pabeni@redhat.com, raeds@nvidia.com,
        saeedm@nvidia.com
Subject: Re: [PATCH net v1] net/mlx5: Fix memory leak in IPsec RoCE creation
Message-ID: <20230223161405.7dc7843b@kernel.org>
In-Reply-To: <Y/ftZTzCkyW/vn4Z@x130>
References: <a69739482cca7176d3a466f87bbf5af1250b09bb.1677056384.git.leon@kernel.org>
        <167714821660.3301.1148990623254072691.git-patchwork-notify@kernel.org>
        <Y/ftZTzCkyW/vn4Z@x130>
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

On Thu, 23 Feb 2023 14:49:09 -0800 Saeed Mahameed wrote:
> On 23 Feb 10:30, patchwork-bot+netdevbpf@kernel.org wrote:
> >Hello:
> >
> >This patch was applied to netdev/net.git (master)
> >by Paolo Abeni <pabeni@redhat.com>:
> >
> >On Wed, 22 Feb 2023 11:06:40 +0200 you wrote:  
> >> From: Patrisious Haddad <phaddad@nvidia.com>
> >>
> >> During IPsec RoCE TX creation a struct for the flow group creation is
> >> allocated, but never freed. Free that struct once it is no longer in use.
> >>
> >> Fixes: 22551e77e550 ("net/mlx5: Configure IPsec steering for egress RoCEv2 traffic")
> >> Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
> >> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> >>
> >> [...]  
> >
> >Here is the summary with links:
> >  - [net,v1] net/mlx5: Fix memory leak in IPsec RoCE creation
> >    https://git.kernel.org/netdev/net/c/c749e3f82a15
> >  
> 
> hmm, I don't see this one in net branch, should i resubmit via my queue? 

It's there:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=c749e3f82a15e10a798bb55f60368ee102c793cb

But keep in mind that master is gone (long live main).
