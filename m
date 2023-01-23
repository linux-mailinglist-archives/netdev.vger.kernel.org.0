Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3151E678AC8
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 23:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbjAWWdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 17:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbjAWWc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 17:32:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CF31CF41
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 14:32:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D15961176
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 22:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D6AC433D2;
        Mon, 23 Jan 2023 22:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674513177;
        bh=ce3Fi87oaRT9h+fNOdiAr/ICmhsILZ9XDh7dtWnGVwQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jlXmLEiKJE1xHRWHjjmK+s9aPtkgvvj/s51G4/BZDzF2eIbGaf7U9xsbP3zI81UoP
         pORcl0HEMxDZM9INaStz8qmyFCysBscs6WaUqJIw583RtzqHv9uAp+8GCvWlFu3OXc
         kV3pmP+4rshC/wS3H7OKeYfrNnvTtxo0kS/QQi+2LbhcrZFghydH7fh9ATsWNP+EzG
         TBzoljJ0sgT7nRACi31PEjKXhWi2r4fAwu/JTLxZnMwLXC6C98J8vjhhVOLvK93tGL
         5JmxbM4VIkd0y+MvIr81V7EtkYO49tNuPI7vMc6G7rFf3XjOW+xAmBDj651qQytarw
         e9WyxFDdnVpag==
Date:   Mon, 23 Jan 2023 14:32:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net,
        aurelien.aptel@gmail.com, smalin@nvidia.com, malin1024@gmail.com,
        ogerlitz@nvidia.com, yorayz@nvidia.com, borisp@nvidia.com
Subject: Re: [PATCH v9 02/25] net/ethtool: add new stringset
 ETH_SS_ULP_DDP_{CAPS,STATS}
Message-ID: <20230123143256.0666646d@kernel.org>
In-Reply-To: <253r0vlrtld.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
        <20230117153535.1945554-3-aaptel@nvidia.com>
        <20230119183646.0c85ac52@kernel.org>
        <253r0vlrtld.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
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

On Mon, 23 Jan 2023 20:31:10 +0200 Aurelien Aptel wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > This should be in uAPI and used as attribute IDs.  
> 
> Following the discussion from [1] ("you can add the dynamic string set
> if you like.") we deliberately did not expose the enum to userspace so
> that ethtool doesn't have to be updated or recompiled to list newer
> kernel ULP DDP statistics.
> 
> Should we change this approach?
> 
> 1: https://lore.kernel.org/netdev/20230111204644.040d0a9d@kernel.org/

Not at all, but the names are really mostly for human consumption.
If any programmer wants to use the stats (and assuming they use C/C++)
it will be more convenient for them to use attribute ids from the enum.
Without having to resolve them using stat names.

This is how other stats are implemented in ethtool-netlink.
