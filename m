Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E59B674BF2
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbjATFPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbjATFO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:14:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19228458B8
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 21:03:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01A28B827E2
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 02:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E08C433EF;
        Fri, 20 Jan 2023 02:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674182207;
        bh=dA6FudxFlGwYSuXbJExTlbBu/fZY9rOHhcSDGeijDy4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tN9EIOnSr9ePay0/8PKo8IPU7y3U44tDh/zCVzqHoQzSOVbydIrSGHEBza/UtbJz6
         6XBQ4b9yv+MXyJs3zJz/zWfioVXyLXQJ3NHD7/2D6W0+YnqHIlVj9fkkGk/SZRtfJG
         6bsxlCEs6H6uAzXSRUhQWSJlp0GGcd365SNxZTudtGyEbCqpVSzeMigdLHgCvC8p61
         G7DCX3tgqCe2lVV7q+ITIr4CtAruDPi9ZZcjadLNk3TYROsLU3s5mYWTQ7P2nTHSrp
         UVdUKGeHRBfOnomPcWSkbSVDuGWWv8Hb+rIMSWkre6JsDh6B3BL+Zx5sySRVX4XjWu
         6isUqISsIzAdw==
Date:   Thu, 19 Jan 2023 18:36:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net,
        aurelien.aptel@gmail.com, smalin@nvidia.com, malin1024@gmail.com,
        ogerlitz@nvidia.com, yorayz@nvidia.com, borisp@nvidia.com
Subject: Re: [PATCH v9 02/25] net/ethtool: add new stringset
 ETH_SS_ULP_DDP_{CAPS,STATS}
Message-ID: <20230119183646.0c85ac52@kernel.org>
In-Reply-To: <20230117153535.1945554-3-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
        <20230117153535.1945554-3-aaptel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Jan 2023 17:35:12 +0200 Aurelien Aptel wrote:
> +enum {
> +	ETH_ULP_DDP_RX_NVMEOTCP_SK_ADD,
> +	ETH_ULP_DDP_RX_NVMEOTCP_SK_ADD_FAIL,
> +	ETH_ULP_DDP_RX_NVMEOTCP_SK_DEL,
> +	ETH_ULP_DDP_RX_NVMEOTCP_DDP_SETUP,
> +	ETH_ULP_DDP_RX_NVMEOTCP_DDP_SETUP_FAIL,
> +	ETH_ULP_DDP_RX_NVMEOTCP_DDP_TEARDOWN,
> +	ETH_ULP_DDP_RX_NVMEOTCP_DROP,
> +	ETH_ULP_DDP_RX_NVMEOTCP_RESYNC,
> +	ETH_ULP_DDP_RX_NVMEOTCP_PACKETS,
> +	ETH_ULP_DDP_RX_NVMEOTCP_BYTES,
> +
> +	__ETH_ULP_DDP_STATS_CNT,
> +};

This should be in uAPI and used as attribute IDs.
