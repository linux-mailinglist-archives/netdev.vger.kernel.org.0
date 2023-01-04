Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C14565CDB7
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 08:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbjADHjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 02:39:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbjADHjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 02:39:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080931929C
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 23:39:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E3B7615A8
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 07:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F959C433EF;
        Wed,  4 Jan 2023 07:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672817952;
        bh=pXGIxrQT0g8QNAxvRF2T96MW1lWBoEh+WiMLx63M3S4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JjPaUwaVuOiFQXAuqcctufZhJ7tzOXjByM4+7ite4R/dugUWmGQdnBnzqS5SwfCB2
         z1qQHXOvmOo66YyDt/09ATa2qQxGQ8Pqtt5r9n9fjbnCM29AE3JxXcYiR46zjY/xZ9
         LalhoqWrj/S2J2WyWPSg0b4Caa971a8m3HT+pyfiCMR8RWgO/QiIVcsacjVkZ6Yeum
         rBkIswN6Xouxqv5McoOoOZI7aQ9rkPiD9byCzqZ5ttpOY1Bwc3B5DyRO0D+4Ll07k5
         nZkaf9bRAPqv1D4UqGW431wF4iPaBcewapdhT5RE/fz/j189M71XSZ8ysyksAn/oNW
         5OJ0f6SzGFUhQ==
Date:   Wed, 4 Jan 2023 09:39:07 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux_oss@crudebyte.com,
        tom@opengridcomputing.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH v2] 9p/rdma: unmap receive dma buffer in
 rdma_request()/post_recv()
Message-ID: <Y7UtGw6nBLFpXpPh@unreal>
References: <20230104020424.611926-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104020424.611926-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 10:04:24AM +0800, Zhengchao Shao wrote:
> When down_interruptible() or ib_post_send() failed in rdma_request(),
> receive dma buffer is not unmapped. Add unmap action to error path.
> Also if ib_post_recv() failed in post_recv(), dma buffer is not unmapped.
> Add unmap action to error path.
> 
> Fixes: fc79d4b104f0 ("9p: rdma: RDMA Transport Support for 9P")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
> v2: add unmap action if ib_post_send() or ib_post_recv() failed
> ---
>  net/9p/trans_rdma.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
