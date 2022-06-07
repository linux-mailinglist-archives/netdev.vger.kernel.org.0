Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E8F54204D
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385277AbiFHAVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448889AbiFGXJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 19:09:06 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B74382E40
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 13:45:06 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id s6so30080902lfo.13
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 13:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=on30OEe/DO5zamISOEay2WIQIU04GrMtf4oLpYULsi0=;
        b=qiK8I6WsrgYjyC91chUFuazIMqEbG3bN/GrHqaSMF4F8x6MV8QSOzCE71g3Nm8aqBY
         GkphlLTEkCrLci6izemxw/C9WRQBv0IXrmoR1/KWbahNRw7cGoDMRwr5A/9l3/GzShi+
         JRNwJT9PDXB63R0cJa3JnoL1VCWjQ1Cw1KWCrjyLqSoei6nvABDIIIhTw64rVpOQW1Kg
         q1rMMkLT+fM3bK5K1OUIlEHDQDNblUNPpHV3zEMjJkKkxaj0qLC8V8JO+mZY8C44m+YZ
         prF8n8lV7evp1UVmD7avSiGmHM86dDosTsCNkBqWSZoZeC8M3ague2Ctr85fdwk5aXGn
         nRqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=on30OEe/DO5zamISOEay2WIQIU04GrMtf4oLpYULsi0=;
        b=Cw8O074xM0mhaE47GYEzUfVTK6hjX9uz3cPgxbmI/onQ27yMT0CCz5XxCtjAHbaXPz
         e1CuKrHtLkwNrJvCfdUSUrVyCJQ2+bYv1AhiueXIhy5jT1NPQrvfFJlgadI+qMhIh/Fk
         sbj7ctSzzo2ZjhVGqr4ariRrzFqCXyhCHGGI15/GAEVkDywLYAtCxkDi46/SKexaheph
         cZfd5Pa2auGzIS3O5IwwHLLN3IkQcrBzCX/DUhp0XgWZJdr64BmnEIBtsEu2cYv7vA0h
         bQcOIxqQEARxU7AQLxNVYCNFLk59J1isUC6fndlOSjYsij2OdQwU7wd8u0iV4b6y2yeF
         gA1w==
X-Gm-Message-State: AOAM531LOSO+s9k1jJBLPadqdtoiP8DadEL03dBsfIAFpRBM0uzypU5l
        Ct4gMMvlOUwzjOkLnNexnEe0bUfQc88tzEEBucCcGg==
X-Google-Smtp-Source: ABdhPJydJnHSMFNA7KkWvxEBYxxyscRFA6vipqsuXxkhyRm5UrhSrOPz9WDL3yIG52KtyuSzUpI+acnnvERqzMf/7Ko=
X-Received: by 2002:a05:6512:401c:b0:479:7232:5444 with SMTP id
 br28-20020a056512401c00b0047972325444mr2089108lfb.403.1654634701789; Tue, 07
 Jun 2022 13:45:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220607191119.20686-1-jstitt007@gmail.com>
In-Reply-To: <20220607191119.20686-1-jstitt007@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 7 Jun 2022 13:44:50 -0700
Message-ID: <CAKwvOdkHb9W1dePaKAuSKv2D0e0uMGLGCZGeakzgD3ZWxf-2iA@mail.gmail.com>
Subject: Re: [PATCH] net: amd-xgbe: fix clang -Wformat warning
To:     Justin Stitt <jstitt007@gmail.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Tom Rix <trix@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 7, 2022 at 12:11 PM Justin Stitt <jstitt007@gmail.com> wrote:
>
> see warning:
> | drivers/net/ethernet/amd/xgbe/xgbe-drv.c:2787:43: warning: format specifies
> | type 'unsigned short' but the argument has type 'int' [-Wformat]
> |        netdev_dbg(netdev, "Protocol: %#06hx\n", ntohs(eth->h_proto));
> |                                      ~~~~~~     ^~~~~~~~~~~~~~~~~~~
>
> Variadic functions (printf-like) undergo default argument promotion.
> Documentation/core-api/printk-formats.rst specifically recommends
> using the promoted-to-type's format flag.
>
> Also, as per C11 6.3.1.1:
> (https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1548.pdf)
> `If an int can represent all values of the original type ..., the
> value is converted to an int; otherwise, it is converted to an
> unsigned int. These are called the integer promotions.`
>
> Since the argument is a u16 it will get promoted to an int and thus it is
> most accurate to use the %x format specifier here. It should be noted that the
> `#06` formatting sugar does not alter the promotion rules.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/378
> Signed-off-by: Justin Stitt <jstitt007@gmail.com>

LGTM; thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Don't forget to cc everyone from ./scripts/get_maintainer.pl!
$ /scripts/get_maintainer.pl
20220607_jstitt007_net_amd_xgbe_fix_clang_wformat_warning.mbx
Tom Lendacky <thomas.lendacky@amd.com> (supporter:AMD XGBE DRIVER)
"David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING DRIVERS)
Eric Dumazet <edumazet@google.com> (maintainer:NETWORKING DRIVERS)
Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING DRIVERS)
Paolo Abeni <pabeni@redhat.com> (maintainer:NETWORKING DRIVERS)
Nathan Chancellor <nathan@kernel.org> (supporter:CLANG/LLVM BUILD SUPPORT)
Nick Desaulniers <ndesaulniers@google.com> (supporter:CLANG/LLVM BUILD SUPPORT)
Tom Rix <trix@redhat.com> (reviewer:CLANG/LLVM BUILD SUPPORT)
netdev@vger.kernel.org (open list:AMD XGBE DRIVER)
linux-kernel@vger.kernel.org (open list)
llvm@lists.linux.dev (open list:CLANG/LLVM BUILD SUPPORT)

> ---
>  drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> index a3593290886f..4d46780fad13 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> @@ -2784,7 +2784,7 @@ void xgbe_print_pkt(struct net_device *netdev, struct sk_buff *skb, bool tx_rx)
>
>         netdev_dbg(netdev, "Dst MAC addr: %pM\n", eth->h_dest);
>         netdev_dbg(netdev, "Src MAC addr: %pM\n", eth->h_source);
> -       netdev_dbg(netdev, "Protocol: %#06hx\n", ntohs(eth->h_proto));
> +       netdev_dbg(netdev, "Protocol: %#06x\n", ntohs(eth->h_proto));
>
>         for (i = 0; i < skb->len; i += 32) {
>                 unsigned int len = min(skb->len - i, 32U);
> --
> 2.30.2
>


-- 
Thanks,
~Nick Desaulniers
