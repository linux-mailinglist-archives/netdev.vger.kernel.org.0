Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D1864563B
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 10:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiLGJO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 04:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiLGJOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 04:14:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BBF2A279
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 01:13:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBFF8B80189
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 09:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAABBC433C1;
        Wed,  7 Dec 2022 09:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670404409;
        bh=eS/FqO4dJ70H+Gw9HdEBtknKGdxHesbCy+r25riz/G8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cBzmAWspWNRBSswWavNnGco+Lf8bRF41RxCGsNnmIOpiwbP9F4fAgLdWZ7AomrpTQ
         ybfBXA4Vz7eYAYMfvyCY8BtfZgJ7P2ZkBJPyg8CLGJ36o6ML7EBdIrCyZvTB77/kyM
         liGQKUiFlYJyIqkK4ExOR9g2JTXm99I8VvbO0C/Ihs2yJLeFw21Ns11VCjspHye5/2
         gy9+MNjZZh0/8FkbV2PmHZaCT+xyBxeIrHJ/Pho/5OwfNVFAozx2nxoSg1E+W7o1Fw
         Ej2Hp2e9i8jWppE3izNfds9wHqI2O6hPuj4mefgZcQw+0XiZRzQ/YJlpeVnKDCGcz4
         /HXUEBUAg9URQ==
Date:   Wed, 7 Dec 2022 11:13:24 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, boon.leong.ong@intel.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net] net: stmmac: fix possible memory leak in
 stmmac_dvr_probe()
Message-ID: <Y5BZNKkSpE4W/aUF@unreal>
References: <20221207083413.1758113-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207083413.1758113-1-cuigaosheng1@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 04:34:13PM +0800, Gaosheng Cui wrote:
> The bitmap_free() should be called to free priv->af_xdp_zc_qps
> when create_singlethread_workqueue() fails, otherwise there will
> be a memory leak, so we add the err path error_wq_init to fix it.
> 
> Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
