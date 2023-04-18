Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188EB6E6FA8
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 00:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjDRWwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 18:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjDRWwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 18:52:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1BD1FFE;
        Tue, 18 Apr 2023 15:52:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FF4F62C8F;
        Tue, 18 Apr 2023 22:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF57C433EF;
        Tue, 18 Apr 2023 22:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681858336;
        bh=de+HR91aylZyjaPhYykVk5+9J82pw/GilutzW+IbEZA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a9k6pUklOiFdFWtJKWwtr3E5csuPk8CJsxJV2jv14DpS0shBJK4sLGqGwlYtxoatw
         SRlz/b90fX46Qj96NsUT2Do7/DkaOFOJmpTnxbKqxIXcgQXz0Y3dvhIajF7d4IawPZ
         tUb3dvRd2eoyThZRlNpl8CO7SdU7GuqopSIC1vjKf0M2+nEcUWkK23pxSODPBdiVuY
         7pFL8+CywdVSHXKzFsrICNjUzSujPHrr3PL+dfjFGMzdiHoouiqSZ4/z34EdR5jBdf
         SRAULUzq9r3/DvbaJlWZqWlOkBwnd7mpoRFLaXbmSUfC+V7Q3I3x9B+cknZg9DE1lQ
         DHVj7YzZgljNw==
Date:   Tue, 18 Apr 2023 15:52:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gencen Gan <gangecen@hust.edu.cn>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: amd: Fix link leak when verifying config failed
Message-ID: <20230418155215.24e7e140@kernel.org>
In-Reply-To: <20230417144750.3976715-1-gangecen@hust.edu.cn>
References: <20230417144750.3976715-1-gangecen@hust.edu.cn>
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

On Mon, 17 Apr 2023 22:47:50 +0800 Gencen Gan wrote:
> From: Gecen Gan <gangecen@hust.edu.cn>
> 
> After failing to verify configuration, it returns directly without 
> releasing link, which may cause memory leak.
> 
> Signed-off-by: Gecen Gan <gangecen@hust.edu.cn>
> ---
>  drivers/net/ethernet/amd/nmclan_cs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/amd/nmclan_cs.c
> index 823a329a921f..0dd391c84c13 100644
> --- a/drivers/net/ethernet/amd/nmclan_cs.c
> +++ b/drivers/net/ethernet/amd/nmclan_cs.c
> @@ -651,7 +651,7 @@ static int nmclan_config(struct pcmcia_device *link)
>   } else {
>       pr_notice("mace id not found: %x %x should be 0x40 0x?9\n",
>  	  sig[0], sig[1]);
> -     return -ENODEV;
> +     goto failed;
>     }
>   }

The patch looks whitespace-damaged, it doesn't apply cleanly.
AFAICT there is one space missing in the indentation.
Probably your email server is doing something funny to it.

--
pw-bot: cr
