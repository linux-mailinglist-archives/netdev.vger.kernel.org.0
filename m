Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760256DE916
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 03:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjDLBt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 21:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjDLBtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 21:49:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C42213A;
        Tue, 11 Apr 2023 18:49:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B236462695;
        Wed, 12 Apr 2023 01:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C00C433D2;
        Wed, 12 Apr 2023 01:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681264194;
        bh=aKG+1zNkh2FK/EvUu9fFjD33/8YFSQKUso17chrT7tM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MJJOzLaykGHYDe6d3WiKIwp66YlU3rDUomUj46ePjS+In4YTtE8XBrSzn7Xdg7jaq
         22CL5P9d8jx3ZDMk5Gd8II+kPUWnmG8cI/fVQzcprfpghMKvI/dDHRK3qC71nQSlKV
         wowvNJemYSPgXEqScRHsUZh/c7i/xhgKVlEN+WmoR+xtM7lTcwDvKaoMvr4AmNrWt3
         j3y+ewmrxwyJU5w8/YHWSbznXvc1e+/lpSfQG4WwgPeKeH9Aqs2B1I3H7emhzX2De8
         UPvPpr04kQyBHqo+EOtS/mm85gU7NNuMVRtEZJq4lt+yhQSeyU5TnskThUmaBtq+o9
         rpOKS6ogeLaKw==
Date:   Tue, 11 Apr 2023 18:49:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     xu xin <xu.xin.sc@gmail.com>
Cc:     bridge@lists.linux-foundation.org, davem@davemloft.net,
        edumazet@google.com, jiang.xuexin@zte.com.cn,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, roopa@nvidia.com, yang.yang29@zte.com.cn,
        zhang.yunkai@zte.com.cn, xu.xin16@zte.com.cn, razor@blackwall.org
Subject: Re: [PATCH net-next] net/bridge: add drop reasons for bridge
 forwarding
Message-ID: <20230411184952.1657b8c9@kernel.org>
In-Reply-To: <20230412013310.174561-1-xu.xin16@zte.com.cn>
References: <20230407200319.72fd763f@kernel.org>
        <20230412013310.174561-1-xu.xin16@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Apr 2023 09:33:10 +0800 xu xin wrote:
> >You can return the reason from this function. That's the whole point of
> >SKB_NOT_DROPPED_YET existing and being equal to 0.
> 
> If returning the reasons, then the funtion will have to be renamed because
> 'should_deliever()' is expected to return a non-zero value  when it's ok to
> deliever. I don't want to change the name here, and it's better to keep its
> name and use the pointer to store the reasons.

Sure. You have to touch all callers, anyway, you can as well adjust 
the name.
