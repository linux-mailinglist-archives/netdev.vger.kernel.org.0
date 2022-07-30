Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2226585821
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 04:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbiG3C6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 22:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiG3C6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 22:58:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9281102
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 19:58:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADEAAB829CB
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 02:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E77C433D6;
        Sat, 30 Jul 2022 02:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659149926;
        bh=0t6/0FFZTTOgQ6u2UKLSdI4nYgYhYF5zMuA7VRgPGa8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bjUGXJWPIPr+zgYBh9hnQ2EM0oZesjG0+0EumcsTB+58pMvsOLHpN6BrQEISATUw4
         DhKZDUfoTpqquOP+VxhaL5LX1VTzGUjUgaPBN6jsJYAuN+mUAWi6x+Rpf5sdFgWBZj
         ZzjN9rX0QXg0j+Tc3pTquU8y5ADjZw72Ft4M6GTEOg+0XlEnodZPzsyBFl8TZF13up
         dqknwiB6AiOLKQRPj9ROiSWHQSIfo/V83kiRFuqv+QyHQXQ2K+39UPHk/I9LhbueE5
         p3FA+Qk7RLFu7We6x0/TbaShqVlE3/TtFMUoRV9xJERR4yZs+As76rhgKdymFAGoX7
         cDSlU1uRuVE9g==
Date:   Fri, 29 Jul 2022 19:58:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <horms@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [net-next 06/15] net/mlx5e: TC, Support tc action api for
 police
Message-ID: <20220729195844.23285f4d@kernel.org>
In-Reply-To: <YuQP+cBUkyR1V1GT@vergenet.net>
References: <20220728205728.143074-1-saeed@kernel.org>
        <20220728205728.143074-7-saeed@kernel.org>
        <20220728221852.432ff5a7@kernel.org>
        <YuN6v+L7LQNQdbQf@corigine.com>
        <YuQP+cBUkyR1V1GT@vergenet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jul 2022 17:51:05 +0100 Simon Horman wrote:
> my reading of things is that the handling of offload of police (meter)
> actions in flower rules by the mlx5 driver is such that it can handle
> offloading actions by index - actions that it would now be possible
> to add to hardware with this patch in place.
> 
> My reasoning assumes that mlx5e_tc_add_flow_meter() is called to offload
> police (meter) actions in flower rules. And that it calls
> mlx5e_tc_meter_get(), which can find actions based on an index.
> 
> I could, however, be mistaken as I have so much knowledge of the mlx5
> driver. And rather than dive deeper I wanted to respond as above - I am
> mindful of the point we are in the development cycle.
> 
> I would be happy to dive deeper into this as a mater of priority if
> desired.

Thank you! No very deep dives necessary from my perspective, just 
wanted for the authors of the action offload API to look over.
