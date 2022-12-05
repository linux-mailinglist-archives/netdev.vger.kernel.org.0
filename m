Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9241364237C
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbiLEHRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbiLEHRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:17:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53F712741;
        Sun,  4 Dec 2022 23:17:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A10F60F8B;
        Mon,  5 Dec 2022 07:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7CEC433C1;
        Mon,  5 Dec 2022 07:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670224621;
        bh=4t39H79w3UgII3zPKaC3pIYoax+Gz2ab6cnMuJDbjaA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jUv33oHTXYucLzOZbbNzXI3qK4BZ1h/LUslgnT5z4k4D4fUOCPpq+HYig4oQ0RD/v
         +0a/r2fA0B8uE0lx6K17pDEcImA5bww4jJ3hzdtvXkjJYdusMV/PIMRNrQWl1K5yt3
         sFuGDGxjJiVtHasYwbXLWLP55OCu99lUR4xGHge+kIpzqU8549NKLVAsXzyDKKxtKg
         PrKVWoKr/1NkOhqSKuHpPJTCW5iFeSmuXhqjedWWr9N4XqMCRniQLB5WEAdb5tVOSr
         ruXeXb/IHOgsLiLEWBz+RA0fbkHoTw/L8mrqJnQDkeDlNacZCQengFl18LN9EE7mda
         YfRwFQR6Z/3BQ==
Date:   Mon, 5 Dec 2022 09:16:57 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Andreas Larsson <andreas@gaisler.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kristoffer Glembo <kristoffer@gaisler.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ethernet: aeroflex: fix potential skb leak in
 greth_init_rings()
Message-ID: <Y42a6UJ9krDNc6xg@unreal>
References: <1670134149-29516-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1670134149-29516-1-git-send-email-zhangchangzhong@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 02:09:08PM +0800, Zhang Changzhong wrote:
> The greth_init_rings() function won't free the newly allocated skb when
> dma_mapping_error() returns error, so add dev_kfree_skb() to fix it.
> 
> Compile tested only.
> 
> Fixes: d4c41139df6e ("net: Add Aeroflex Gaisler 10/100/1G Ethernet MAC driver")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/aeroflex/greth.c | 1 +
>  1 file changed, 1 insertion(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
