Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8FBF66E50C
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 18:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbjAQRei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 12:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234871AbjAQRct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 12:32:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EADC30E88
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 09:31:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC75A614D3
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 17:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CEC1C433F0;
        Tue, 17 Jan 2023 17:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673976677;
        bh=Rc/TOGl/Go9lfMBk/q0pIQpZ52X4rC9bYgTJSNfLZpY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W55UkHJaEEj0MS2zbs9jNho4PqsIJNWLNj6WsRPjrXNCzP89Fo+Td0a3eNEm4V/mv
         AMr5ZeRIQuPOw7954W9ZU+AEK6X90UWHL5N405ZW9n3OkUSbiWgLl/X1ApE5WohmMd
         bPc+1W/LczFKLJTxIG+bZ3e2y4ZLq6DxSrKseokXfpSKCsQ67WXpjpitrgDPWvfi+c
         MJALdY5APcxqfdGsmvcZahjG1UfSWekw59411Pe84wZbL6DVjfXE8GnDGPkgmChIHw
         P2sXjDytGyGMz9+sLsMGitRmlr5U8bexNmcTN/Ln+avqc3qeKbNDnxe63sapWWHkU0
         rHvBNRr5s2/oA==
Date:   Tue, 17 Jan 2023 09:31:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     Shay Agroskin <shayagr@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH V1 net-next 0/5] Add devlink support to ena
Message-ID: <20230117093115.03d3dc13@kernel.org>
In-Reply-To: <157d3005-29a8-939e-f63a-784833dbf17b@nvidia.com>
References: <20230108103533.10104-1-darinzon@amazon.com>
        <20230109164500.7801c017@kernel.org>
        <574f532839dd4e93834dbfc776059245@amazon.com>
        <20230110124418.76f4b1f8@kernel.org>
        <865255fd30cd4339966425ea1b1bd8f9@amazon.com>
        <20230111110043.036409d0@kernel.org>
        <29a2fdae8f344ff48aeb223d1c3c78ad@amazon.com>
        <20230111120003.1a2e2357@kernel.org>
        <f2fd4262-58b7-147d-2784-91f2431c53df@nvidia.com>
        <pj41zltu0vn9o7.fsf@u570694869fb251.ant.amazon.com>
        <20230112115613.0a33f6c4@kernel.org>
        <157d3005-29a8-939e-f63a-784833dbf17b@nvidia.com>
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

On Sun, 15 Jan 2023 12:05:33 +0200 Gal Pressman wrote:
> > IDK, the semantics don't feel close enough.
> > 
> > As a user I'd set tx_copybreak only on systems which have IOMMU enabled 
> > (or otherwise have high cost of DMA mapping), to save CPU cycles.
> > 
> > The ena feature does not seem to be about CPU cycle saving (likely 
> > the opposite, in fact), and does not operate on full segments AFAIU.  
> 
> Segments?

Complete DMA buffers. Basically whether the optimization
only kicks in if skb->len < configured_len or 
skb_headlen() < configured_len.

> > Hence my preference to expose it as a new tx_push_buf_len, combining
> > the semantics of tx_push and rx_buf_len.  
> 
> Sounds like a good idea.
> To clarify, buf_len here refers to the size of the inline'd part, not
> the WQE itself, correct? The driver will use whatever WQE size it needs
> in order to accommodate the requested inline size?

We can decide either way, but I _think_ rx_buf_len refers to the size
as allocated, not necessarily usable size (in case the first buffer has
padding / headroom). But as long as we clearly document - either way is
fine.
