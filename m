Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA86C660CB0
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 07:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjAGGho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 01:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjAGGhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 01:37:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8DD714BA;
        Fri,  6 Jan 2023 22:37:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B0BEB81EFE;
        Sat,  7 Jan 2023 06:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D732C433D2;
        Sat,  7 Jan 2023 06:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673073457;
        bh=0m0iEcQ/rUw96vXul6Nm7VxnMIAr9UmRVFM/KKbJW7o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uqHyaO72u/1PuJOzhW2DquuPsaSntmsgRn4oPx9+riMd74/4+VvFrPpCaM2IHNeYg
         TeiCbWhVLrHonLDVBdcrCSumRzZ/1pNfddupoFUTVoT95TKw5am9g0F4cdvN5K2VCV
         UEw8MHL2J1dZ1mSA3K+Bz6ssstCWVPAqxBOoTBGgCcVA5EyI8Jn2OuPoELyVd6Ndht
         hTq7NQrlLExupt23X5e+2qpr4BPaODYfwyv0ChGsAS0EO/njA7IXob7BwK2mwCUFV/
         4as/gb0fiqDjBc103hhDEpXPu7b9qd9mYpL4UyuujmpIcanT4tIbFigO8Eha34h0k8
         hOEBykAJXXw0w==
Date:   Sat, 7 Jan 2023 08:37:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH mlx5-next 0/8] mlx5 IPsec RoCEv2 support and netdev
 events fixes in RDMA
Message-ID: <Y7kTLRSeFHzAvcom@unreal>
References: <20230105041756.677120-1-saeed@kernel.org>
 <20230105103846.6dc776a3@kernel.org>
 <Y7h4Cl/69g2yQzKh@x130>
 <20230106131723.2c7596e3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106131723.2c7596e3@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 01:17:23PM -0800, Jakub Kicinski wrote:
> On Fri, 6 Jan 2023 11:35:38 -0800 Saeed Mahameed wrote:
> > On 05 Jan 10:38, Jakub Kicinski wrote:
> > >On Wed,  4 Jan 2023 20:17:48 -0800 Saeed Mahameed wrote:  
> > >>   net/mlx5: Configure IPsec steering for ingress RoCEv2 traffic
> > >>   net/mlx5: Configure IPsec steering for egress RoCEv2 traffic  
> > >
> > >How is the TC forwarding coming along?  
> > 
> > Not aware of such effort, can you please elaborate ? 
> 
> When Leon posted the IPsec patches I correctly guessed that it's for
> RDMA and expressed my strong preference for RDMA to stop using netdev
> interfaces for configuration. He made the claim that the full IPsec
> offload will be used for eswitch offload as well, so I'm asking how 
> is that work going.

It is planned, as we need this support too for ASAP program, but I simply
can't say for sure if I success to make it in this cycle due to my personal
constraints.

On my plate, without going into much details:
1. Overcome cx7 HW limitation when dealing with hard/soft lifetime counters.
2. Tunnel mode support. 
3. IPsec on FDB. This is TC forwarding support.

Thanks
