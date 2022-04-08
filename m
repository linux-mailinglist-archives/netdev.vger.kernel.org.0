Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76544F9F3A
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 23:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234881AbiDHVf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 17:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiDHVf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 17:35:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37502709;
        Fri,  8 Apr 2022 14:33:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D9F562054;
        Fri,  8 Apr 2022 21:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559A5C385A1;
        Fri,  8 Apr 2022 21:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649453630;
        bh=fU029qbTSWa9XGPuG1iTmZoPdbPNfI8weVyzJF2bQQs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tziQ2Jt1lEIVX6vPSNCaMwUU06Wk0VfYDfw4gDe497KN/8mMuYCWaISp8U6GAHqA0
         m/B2JjbrEsnNWsX7Qhu9huu3F+kGFhh117qPWpP0ermd+deGuB0vBH588XjJ9ZscZy
         r85o5cEjpXXxyQuu81MBn8wK+0LF5LudP7VrOWEI9R5GrMDSM4N7+6YCmGPu0bXg2t
         RuSJwSHYWjbsCmY4F6hOKc7Bp7M62HtcN1XxEcfPhAgIpYFnB39rOSktGgA1kTNlCC
         Fgk2QY7s3/t4baxuhwkkPJI3/lAgTLhX/z0uSUJ8yLX+doXoN1hCwPxxf/uIsnhIVS
         Omq4ZDQXPcVUQ==
Date:   Fri, 8 Apr 2022 14:33:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Coco Li <lixiaoyan@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        willem de bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH net-next] fou: Remove XRFM from NET_FOU Kconfig
Message-ID: <20220408143349.1e3413eb@kernel.org>
In-Reply-To: <20220407171554.2712631-1-lixiaoyan@google.com>
References: <20220407171554.2712631-1-lixiaoyan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Apr 2022 10:15:54 -0700 Coco Li wrote:
> XRFM is no longer needed for configuring FOU tunnels
> (CONFIG_NET_FOU_IP_TUNNELS), remove from Kconfig.

What's the full story? The original code mentions udp_encap_rcv 
but would be used to note where that dependency got removed.

> Built and installed kernel and setup GUE/FOU tunnels.
> 
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> ---
>  net/ipv4/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
> index 87983e70f03f..e983bb0c5012 100644
> --- a/net/ipv4/Kconfig
> +++ b/net/ipv4/Kconfig
> @@ -321,7 +321,6 @@ config NET_UDP_TUNNEL
>  
>  config NET_FOU
>  	tristate "IP: Foo (IP protocols) over UDP"
> -	select XFRM
>  	select NET_UDP_TUNNEL
>  	help
>  	  Foo over UDP allows any IP protocol to be directly encapsulated

I think we can also remove the include of xfrm.h from fou.c ?
