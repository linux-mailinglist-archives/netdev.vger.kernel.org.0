Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D23116E384B
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 14:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjDPMrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 08:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbjDPMrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 08:47:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C873A80;
        Sun, 16 Apr 2023 05:46:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72AC261A97;
        Sun, 16 Apr 2023 12:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56356C433EF;
        Sun, 16 Apr 2023 12:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681649210;
        bh=CdIev8G31Xv1hKEqnZUIMkMixH8yp6bb7bSl5j0YXB0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LSCcjN31JrEW2iG+zJBkq0AMcsIhhub3YGI/HxGNk/d3EqX/2WAOy4WzAhkWBHCVQ
         NANU98O1TUREO7sXeEybh0aSuXF6PfPnI9qaVzV6IrOoXO44TZIb21+erHQNlDHufa
         uU2tCX1JKbEfT4Zs922KvysYQQ8qU2mTGYpilii0=
Date:   Sun, 16 Apr 2023 14:46:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hector Martin <marcan@marcan.st>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, asahi@lists.linux.dev,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] wifi: brcmfmac: Demote vendor-specific attach/detach
 messages to info
Message-ID: <2023041631-crying-contour-5e11@gregkh>
References: <20230416-brcmfmac-noise-v1-0-f0624e408761@marcan.st>
 <20230416-brcmfmac-noise-v1-1-f0624e408761@marcan.st>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230416-brcmfmac-noise-v1-1-f0624e408761@marcan.st>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 16, 2023 at 09:42:17PM +0900, Hector Martin wrote:
> People are getting spooked by brcmfmac errors on their boot console.
> There's no reason for these messages to be errors.
> 
> Cc: stable@vger.kernel.org
> Fixes: d6a5c562214f ("wifi: brcmfmac: add support for vendor-specific firmware api")
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c | 4 ++--
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c | 4 ++--
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c | 4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
> index ac3a36fa3640..c83bc435b257 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
> @@ -12,13 +12,13 @@
>  
>  static int brcmf_bca_attach(struct brcmf_pub *drvr)
>  {
> -	pr_err("%s: executing\n", __func__);
> +	pr_info("%s: executing\n", __func__);

Why are these here at all?  Please just remove these entirely, you can
get this information normally with ftrace.

Or, just delete these functions, why have empty ones at all?

thanks,

greg k-h
