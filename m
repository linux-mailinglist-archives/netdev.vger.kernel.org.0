Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49DB6A0374
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 08:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbjBWH7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 02:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjBWH7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 02:59:11 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343E21A95E;
        Wed, 22 Feb 2023 23:59:10 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id h14so1234493wru.4;
        Wed, 22 Feb 2023 23:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Il8snxql8ozdG2/FJTHrbWky6YEzgialCwP80s4gEs=;
        b=oQHMl1nwEZva0H7MyfHd8UslaX1sRFNliauoq+2suP0Cmk83Vta8hZ04SZHkrVx5hE
         yfLy2FDlPyS1Q/8DEyFBJPNU9130wSNyGzoInVWi6L0icMlTsc+DmycLV8xIc6phUbzM
         VKdTHpsb24RP+KGv5uCvWCHMvTIKuY9LaH/+FeZyUK6L7hbPUU9vzEvqX+2EKe39uFmT
         appwfDtj5u/DjofsZHzG8gs9Anis+C6yoarAnlwixYoOb93TUUdiscc99+1ldx4b44O3
         KlTgmrrHulDWVLNDzvfx0ZgtvqAE29IXxQ9lDcMHUC1qMxL8uky1reSYFDNInwGIXEj/
         HYsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Il8snxql8ozdG2/FJTHrbWky6YEzgialCwP80s4gEs=;
        b=2mqCaUlK8wTi7BqzWsQe1rfj40ffEwIEuNR1SKTvOUn8pRZQ64IsgUuGVNa/AE4Ikj
         fQNw10JjHA9N30V8iEXWNZQkRQBz0n2s6cZFExAneccNBoDbRhAxhstJARPQkYUH/ojw
         erBWgoPQZ/53XtKf9pad3h8REzH6yluGMmDLiK1D2A17fZ93FccC9Yy936+t0IvPW2iM
         PmkIKwcxJpMGEfuuEMTuqTZmKxsjIaOgE/cPrVEkou/HM5AyWJ+zsCt78+z6K+XXCKk0
         km/iaOl98bWwu2EyI4IASjMRt6MpIxr/gDXpJDJayfQ75NWjMzB1/ckjsXU1i0FTTx40
         LTvw==
X-Gm-Message-State: AO0yUKWVFJaTUkcnTzzk0yXcUD44lIkAg0/9LcuEyvKaDGhrYJPaIRfi
        fgimOF3JkUjfVTPj6B3exK8=
X-Google-Smtp-Source: AK7set9MLr/MHa5L+CeOzL7RmVFKKC5a8u8ezAEhTAHR0VTtzjkKQUBeIzWiKjZ75VyBlA0RgKolWg==
X-Received: by 2002:a5d:4566:0:b0:2bf:e8f5:fd6e with SMTP id a6-20020a5d4566000000b002bfe8f5fd6emr10845421wrc.17.1677139148487;
        Wed, 22 Feb 2023 23:59:08 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id a18-20020adfe5d2000000b002be505ab59asm10122239wrn.97.2023.02.22.23.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 23:59:08 -0800 (PST)
Date:   Thu, 23 Feb 2023 10:59:05 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Li Qiong <liqiong@nfschina.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Yu Zhe <yuzhe@nfschina.com>
Subject: Re: [PATCH] net/atm/mpc: Fix dereference NULL pointer in
 mpc_send_packet()
Message-ID: <Y/ccya+o7zBqMyhJ@kadam>
References: <20230223065446.24173-1-liqiong@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223065446.24173-1-liqiong@nfschina.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 02:54:46PM +0800, Li Qiong wrote:
> The 'non_ip' statement need do 'mpc' pointer dereference,
> so return '-ENODEV' if 'mpc' is NULL.
> 
> Signed-off-by: Li Qiong <liqiong@nfschina.com>
> ---
>  net/atm/mpc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/atm/mpc.c b/net/atm/mpc.c
> index 033871e718a3..1cd6610b8a12 100644
> --- a/net/atm/mpc.c
> +++ b/net/atm/mpc.c
> @@ -577,7 +577,7 @@ static netdev_tx_t mpc_send_packet(struct sk_buff *skb,
>  	mpc = find_mpc_by_lec(dev); /* this should NEVER fail */
>  	if (mpc == NULL) {
>  		pr_info("(%s) no MPC found\n", dev->name);
> -		goto non_ip;
> +		return -ENODEV;
>  	}

The comment says that find_mpc_by_lec() can't fail.  This business of
handling impossible situations is very complicated.  Should this
free the skb before returning?  Eventually static checkers will detect
that.

Generally the rule is that we don't have checks for impossible
conditions.  That would trigger a warning for certain static checkers
but it would be a false positive.  Otherwise we need to add a whole
bunch of code to silence all warnings about handling an impossible
situation correctly.

regards,
dan carpenter

