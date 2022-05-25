Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2CA6533744
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 09:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243506AbiEYHUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 03:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239469AbiEYHUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 03:20:09 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD2A113A;
        Wed, 25 May 2022 00:20:07 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id h186so18214766pgc.3;
        Wed, 25 May 2022 00:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c3NN2a98vQ67oBdy58k4ALAhQdAN1uSvB09A0CcmiJY=;
        b=mBcbVGb3wNLi5hNPLMu/XoOvLWcCk4sqM8U0MLyhriNhx+FA5oKEsABeEVw2hPkIYw
         1QRrqx3sFIFYWGINrNZ57Q+nJZmjAeBdpHgORWba7mJC9Npa/QaDdaXZwmM+d0kpHPjk
         CtnhC6WvPlztLh8INB9OjcEea7gcwRTetIwZXh01miBnvzHwCOe2vLHBfui86TktvHpK
         wQ9iRZMTflwV251+iVAoyqFaFR0aH2SyuQHH0SgaA009BrDs6Dz43wf9jdsZ52U9z1Xo
         1jPLIjYxbgCUyIn5eY0Hy75XUoG5UN7X50u2TAJDNagp9vUylM6ddP65pmyQuV2Vj0m8
         LZng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c3NN2a98vQ67oBdy58k4ALAhQdAN1uSvB09A0CcmiJY=;
        b=ThNntfvJZbClD/pY9bqbOPn2KOxOS7b9CTylGtK7X3Bm7IzL/8iO2jgXNn6cgKWEX4
         tnBPCJa+i6l868dLjFV6dNZ3wdrlB1IQygqX0wuHZUpZ+3yiLxrXGUv4zlD/WgLBQgYj
         FPG6kBJwwL+3nLjh/clYqjhDe+QUMiif0/33B1gbLkoFC+HpyAvEplMqdd00AH0tDUdZ
         TaTXCG9neT+SoTqBfVfbd94v1Io3s5KtnEzRCMDDF9EE/AEGBQv+m3RTHrGxyD5AXqjK
         50B29xl0JnMz9+8DCWqVbONQqkgY6yuSx07g06s6UgoPF5DZ3o9Sa7tbPNo+l9E9p8cG
         av7Q==
X-Gm-Message-State: AOAM533eWcqvbureeO+M5wL+YH7t1zl60uCWew6Ls8xeNJ0zKUZJjiqJ
        Tm3+y36lIpF5biZ/ifWTDcU=
X-Google-Smtp-Source: ABdhPJy4SzjDG9HgY2opuZXTbupL+Jja3hb5i7r++rjCcqLLwoKwoafmNx3vWrkya6xc0kk2NjTxDQ==
X-Received: by 2002:a05:6a00:114e:b0:4c8:55f7:faad with SMTP id b14-20020a056a00114e00b004c855f7faadmr32105069pfm.86.1653463207201;
        Wed, 25 May 2022 00:20:07 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x15-20020a170902a38f00b00162496617b9sm2657121pla.286.2022.05.25.00.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 00:20:06 -0700 (PDT)
Date:   Wed, 25 May 2022 15:20:01 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Yun Lu <luyun_611@163.com>
Cc:     willemb@google.com, davem@davemloft.net, edumazet@google.com,
        willemdebruijn.kernel@gmail.com, liuyun01@kylinos.cn,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2] selftests/net: enable lo.accept_local in psock_snd
 test
Message-ID: <Yo3YoZWRkygFyqUc@Laptop-X1>
References: <20220525031819.866684-1-luyun_611@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525031819.866684-1-luyun_611@163.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 11:18:19AM +0800, Yun Lu wrote:
> From: luyun <luyun@kylinos.cn>
> 
> The psock_snd test sends and recieves packets over loopback, and
> the test results depend on parameter settings:
> Set rp_filter=0,
> or set rp_filter=1 and accept_local=1
> so that the test will pass. Otherwise, this test will fail with
> Resource temporarily unavailable:
> sudo ./psock_snd.sh
> dgram
> tx: 128
> rx: 142
> ./psock_snd: recv: Resource temporarily unavailable
> 
> For most distro kernel releases(like Ubuntu or Centos), the parameter
> rp_filter is enabled by default, so it's necessary to enable the
> parameter lo.accept_local in psock_snd test. And this test runs
> inside a netns, changing a sysctl is fine.
> 
> v2: add detailed description.
> 
> Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Signed-off-by: luyun <luyun@kylinos.cn>
> Reviewed-by: Jackie Liu <liuyun01@kylinos.cn>
> ---
>  tools/testing/selftests/net/psock_snd.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/net/psock_snd.c b/tools/testing/selftests/net/psock_snd.c
> index 7d15e10a9fb6..edf1e6f80d41 100644
> --- a/tools/testing/selftests/net/psock_snd.c
> +++ b/tools/testing/selftests/net/psock_snd.c
> @@ -389,6 +389,8 @@ int main(int argc, char **argv)
>  		error(1, errno, "ip link set mtu");
>  	if (system("ip addr add dev lo 172.17.0.1/24"))
>  		error(1, errno, "ip addr add");
> +	if (system("sysctl -w net.ipv4.conf.lo.accept_local=1"))
> +		error(1, errno, "sysctl lo.accept_local");
>  
>  	run_test();
>  
> -- 
> 2.25.1

Great, this also fixed my problem. Please feel free to add my

Tested-by: Hangbin Liu <liuhangbin@gmail.com>
