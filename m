Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A516BDA54
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 21:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjCPUmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 16:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjCPUmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 16:42:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134BE54CA6
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 13:42:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 987DB62119
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 20:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C540C433EF;
        Thu, 16 Mar 2023 20:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678999367;
        bh=HbCsG1WKD67HGxHFuvKNU5vOtQI8QVeO0Qcs8mj+3YU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YELGZrTwJhhnCkDRPTDZmHHcy5Yt5U4K5FU1vw8oJgQDngc6jeiPeWx3KC1mCA7hD
         VEvh3hUu5wCnkC4aI1n5qp0/eupiDq1S6vri4BYSWKySDL1xbLuaHPagpWTgURIzMB
         NJBuDq3kAaBmbUiVUw07qvtVmi1FbuhHzhhh5Oas4Fd0J3N3Q5Loi2jIPz+zdErK9/
         7TCtRVeNpElRaR5WYRCmK/kb2+orz317Q5rePZqr63t8bbZNuR/aLnpUjUtCxt5JgI
         dwIa8uPd05d4jwTxbrjgcgpmXcju3tjY2EvQvKxKsub/YuTKhdf6sXtLkEDvKWZgAT
         M28p+MeQtpumA==
Date:   Thu, 16 Mar 2023 13:42:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     Shay Agroskin <shayagr@amazon.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH v4 net-next 1/5] ethtool: Add support for configuring
 tx_push_buf_len
Message-ID: <20230316134244.56727793@kernel.org>
In-Reply-To: <30cb3990-80ce-ca07-6d73-cdc00d0ad7b8@nvidia.com>
References: <20230309131319.2531008-1-shayagr@amazon.com>
        <20230309131319.2531008-2-shayagr@amazon.com>
        <316ee596-e184-8613-d136-cd2cb13a589f@nvidia.com>
        <20230309225326.2976d514@kernel.org>
        <d438ef12-86f8-7415-4690-3e378ac1048f@nvidia.com>
        <20230313120942.75599b8e@kernel.org>
        <pj41zlbkkv2v6z.fsf@u570694869fb251.ant.amazon.com>
        <30cb3990-80ce-ca07-6d73-cdc00d0ad7b8@nvidia.com>
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

On Thu, 16 Mar 2023 13:57:26 +0200 Gal Pressman wrote:
> On 14/03/2023 17:38, Shay Agroskin wrote:
> >> Shay, could you add a paragraph in the docs regarding copybreak in v5?  
> > 
> > Document that tx_copybreak defines the threshold below which the packet
> > is copied into a preallocated DMA'ed buffer and that tx_push_buf defines
> > the same but for device memory?
> > Are we sure we want to make this distinction ? While the meaning of both
> > params can overlap in their current definition, the motivation to use
> > them is pretty different.
> > A driver can implement both for different purposes (and still copy both
> > into the device).  
> 
> I don't understand what it means to implement both.

If skb head is large you can copy part into the iomem, part into 
a pre-mapped space.

> It's confusing because both parameters result in skipping the DMA map
> operation, but their usage motivation is different?
> What are we instructing our customers? Use copybreak when your iommu is
> slow, but when should they use this new parameter?

Your customers? Is mlx5 going to implement the iomem based push which
needs explicit slot size control?

> IMO, a reasonable way to use both would be to only account for the
> tx_push_buf_len when tx_push is enabled, otherwise use copybreak.

I thought Shay already agreed. Let's get the v5 out.
