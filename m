Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8133C5B7D0F
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 00:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiIMWa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 18:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiIMWaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 18:30:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFF05A2D6;
        Tue, 13 Sep 2022 15:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A38EE615F3;
        Tue, 13 Sep 2022 22:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27421C433D6;
        Tue, 13 Sep 2022 22:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663108223;
        bh=rVjxb2dQV8sLfi2r4499txSukl32Y+SJ5+wsRFGJh9I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sbZ6+KQwG7HZOcmSmYGdTspEWGshOnI69SlPdjBNxO4onmvt9RpC81lf6sJG52NX5
         CyAvNhz8T9I/QRrkyvKr2hB0xz5WSRctUO43LF/3bIV4M13AIHDIJMELp3TPCqUY6i
         +xShwPL+uKC7FTUyevbOQ96XXDH75zSH7Cu1S6yx1e8wABnnG5lqUKqJw2JCIDpnzT
         eNp4txLmHFsh9b6I3yO+9aHv4/OW4JXsE/OvdQryXtRMqNlo5+sw7xtjqAGWMcgSUf
         9kxB04Xm9GoB1zQEOoZj7becoGiFRasAHByjJf5oHDNLYUj+PJb/OTdpAEz/c+G3y4
         5scn1cqo13NgA==
Date:   Tue, 13 Sep 2022 15:30:20 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Maxim Kiselev <bigunclemax@gmail.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ti: davinci_emac: Fix return type of
 emac_dev_xmit
Message-ID: <YyEEfEHlY5zMjWHg@dev-arch.thelio-3990X>
References: <20220912195023.810319-1-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912195023.810319-1-nhuck@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 12:50:19PM -0700, Nathan Huckleberry wrote:
> The ndo_start_xmit field in net_device_ops is expected to be of type
> netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).
> 
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition.
> 
> The return type of emac_dev_xmit should be changed from int to
> netdev_tx_t.
> 
> Reported-by: Dan Carpenter <error27@gmail.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1703
> Cc: llvm@lists.linux.dev
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  drivers/net/ethernet/ti/davinci_emac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
> index 2a3e4e842fa5..e203a5984f03 100644
> --- a/drivers/net/ethernet/ti/davinci_emac.c
> +++ b/drivers/net/ethernet/ti/davinci_emac.c
> @@ -949,7 +949,7 @@ static void emac_tx_handler(void *token, int len, int status)
>   *
>   * Returns success(NETDEV_TX_OK) or error code (typically out of desc's)
>   */
> -static int emac_dev_xmit(struct sk_buff *skb, struct net_device *ndev)
> +static netdev_tx_t emac_dev_xmit(struct sk_buff *skb, struct net_device *ndev)
>  {
>  	struct device *emac_dev = &ndev->dev;
>  	int ret_code;
> -- 
> 2.37.2.789.g6183377224-goog
> 
