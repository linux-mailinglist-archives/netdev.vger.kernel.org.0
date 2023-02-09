Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88FC568FC91
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 02:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjBIBRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 20:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbjBIBQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 20:16:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0A4DBF9;
        Wed,  8 Feb 2023 17:16:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0AEF2CE2357;
        Thu,  9 Feb 2023 01:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92316C433D2;
        Thu,  9 Feb 2023 01:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675905408;
        bh=QgD+Wr8/tOUVJeWZJi5X3zVWBTmcoSCWT5R322PQDIc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k2ZeQq/+6l/C2FsX27s5pBk5+PV99Gf8L+OUXwBsKM6rEhgUP3NLrid7JtVmZyObz
         9ifHYnzWsf7xmNUOTwpz6uC8hkHjy8ldh6sLKD7qWGZ6W9q4NhEsACLvmEUTzeci8Q
         2oBczZVeIH5UjlhaHvthKT7PbObtIE52lgDyHZsh8pOwiGbFkJiNOuE0EonnqkHHUt
         85+hyhdqAoWSJcF+edZJ+ZjhGUKvSbvtEtk1OlXEfkG5HxekMhuLMccp5iCm+rIa3Q
         YvWedRv9fV+4jL2iNo/tV+MccL4MHB9FkV682SSmGv2mJpozNtC6LZbfCaZxaxLE6A
         xQaotJB0tuh/w==
Date:   Wed, 8 Feb 2023 17:16:46 -0800
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
Message-ID: <20230208171646.052e62fd@kernel.org>
In-Reply-To: <Y+RFj3QfGIsmvTab@nvidia.com>
References: <Y92kaqJtum3ImPo0@nvidia.com>
        <20230203174531.5e3d9446@kernel.org>
        <Y+EVsObwG4MDzeRN@nvidia.com>
        <20230206163841.0c653ced@kernel.org>
        <Y+KsG1zLabXexB2k@nvidia.com>
        <20230207140330.0bbb92c3@kernel.org>
        <Y+PKDOyUeU/GwA3W@nvidia.com>
        <20230208151922.3d2d790d@kernel.org>
        <Y+Q95U+61VaLC+RJ@nvidia.com>
        <20230208164807.291d232f@kernel.org>
        <Y+RFj3QfGIsmvTab@nvidia.com>
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

On Wed, 8 Feb 2023 20:59:59 -0400 Jason Gunthorpe wrote:
> > Who said IP configuration.  
> 
> Please explain to me your vision how we could do IPSEC in rdma and
> continue to use an IP address owned by netdev while netdev is also
> running IPSEC on the same IP address for netdev traffic.

I'm no expert on IPsec but AFAIK it doesn't treat the entire endpoint
as a single unit.

> I can't see how it is even technically possible.
> 
> Tell me how the NIC knows, on a packet by packet basis, if the IPSEC
> or IKE packet should be delivered to netdev or to RDMA.

Just a forwarding problem. Whether NIC matches on UDP port or ESP+SPI
programmed via some random API is a detail.


Could you please go back to answering the question of how we deliver
on the compromise that was established to merge the full xfrm offload?

There's only so much time I can spend circling the subject.
