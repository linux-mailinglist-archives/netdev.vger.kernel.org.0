Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82785205D3
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 22:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiEIU2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 16:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiEIU2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 16:28:31 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7001D1C9648
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 13:10:55 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id h29so25773582lfj.2
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 13:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rT7YZE3Rpnro7ms1QgM5M6t01Btb0lYC4Iw9G2/tffo=;
        b=F8NAGQmeeDvyF3JbzdcP1Kh47+XNSVBOrrpDtR9NdWTh7oZnC3zphUjwIFkTh0v6cq
         CYiS5UDmrvG6Ypi2LxMycY0DwH37Kk2xq0JIRQbBYm5iu+SitfPEEiaLJf9Lvjvl13i8
         M7Q3+eFZwt5izyvTk1nFkfsh860SQVVXtfl3pbD9//M0zKL9DXY8buydBeGzRM7bWngk
         PhzTnX07p8GsYSMaF5BdukhZDANcmyI2cs2Gkbxivt5gqK/gshpJMr/a2AWJt804866i
         vXPShrt4V00Gj8asyc4v0BJwv58TV0BiPaimaHE9i4QGDIoc0KJv0cyYKHsN3YVdLxkf
         QHrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rT7YZE3Rpnro7ms1QgM5M6t01Btb0lYC4Iw9G2/tffo=;
        b=wdlVbdScJs3iq9De1Iscr5NEIYdaOW/84VfUR3yE8k/+lKa4kvDarppp6j9QbKmCda
         VaZ+WXf1F68Uure2QgmTb0XcQO4VVcpXPxQfGsbpvl1GMkJJtzYwa+6kIyJqmYCdXyqD
         E6d4Ffdr5dSbQFzN181vHQqPl3gw/KNLgM/BmPpOK6QPr8Ijugm9tw5HLHI9fXwPUELv
         9lDbMBj8mHllFg0hi6tsQk0ijetI2KrGf9uCZ2ytuwFqG/X4lDeSKHwDXhCZ92dqF1hS
         k4vdG4HMhSV2V3OKhbI30fiWYNPCq3gHgSkqa5RKAIIeqVMUbLKkxkh1MnkdfgzPNFn4
         lGiw==
X-Gm-Message-State: AOAM532PlVB0mnyVJhrf52G7K2sxdycw41vwCOvW1EvTP/jcBJ7hxQs9
        CwmZcGTbV4R25YE6RuTV8l8PFEGntkVq14Eprl4xlQ==
X-Google-Smtp-Source: ABdhPJx/R5qRF5XEROe3y8D5fDil5gozZE7Z3ccZu5gNCXCbjzi7qAXklKfQmkGBEjdyhgRvl7bglXL1FgdYtvfBbVI=
X-Received: by 2002:ac2:4a78:0:b0:472:2106:4b94 with SMTP id
 q24-20020ac24a78000000b0047221064b94mr13893868lfp.632.1652127053475; Mon, 09
 May 2022 13:10:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220509191810.2157940-1-jeffreyjilinux@gmail.com>
In-Reply-To: <20220509191810.2157940-1-jeffreyjilinux@gmail.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Mon, 9 May 2022 13:10:42 -0700
Message-ID: <CAMzD94RAV2WWBGAar_S729DU9rQBtgJy5iUReJ_diOj5DRb=ug@mail.gmail.com>
Subject: Re: [PATCH net-next] show rx_otherhost_dropped stat in ip link show
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Jeffrey Ji <jeffreyji@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Jeffrey, thanks for working on this, some comments:

I think you meant iproute2-next in the subject. Could you resend, please?

On Mon, May 9, 2022 at 12:18 PM Jeffrey Ji <jeffreyjilinux@gmail.com> wrote:
>
> From: Jeffrey Ji <jeffreyji@google.com>
>
> This stat was added in commit 794c24e9921f ("net-core: rx_otherhost_dropped to core_stats")
>
> Tested: sent packet with wrong MAC address from 1
> network namespace to another, verified that counter showed "1" in
> `ip -s -s link sh` and `ip -s -s -j link sh`
>
> Signed-off-by: Jeffrey Ji <jeffreyji@google.com>
> ---
>  include/uapi/linux/if_link.h |  2 ++
>  ip/ipaddress.c               | 15 +++++++++++++--
>  2 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 22e21e57afc9..50477985bfea 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -243,6 +243,8 @@ struct rtnl_link_stats64 {
>         __u64   rx_compressed;
>         __u64   tx_compressed;
>         __u64   rx_nohandler;
> +
> +       __u64   rx_otherhost_dropped;
>  };
>
>  /* Subset of link stats useful for in-HW collection. Meaning of the fields is as
> diff --git a/ip/ipaddress.c b/ip/ipaddress.c
> index a80996efdc28..9d6af56e2a72 100644
> --- a/ip/ipaddress.c
> +++ b/ip/ipaddress.c
> @@ -692,6 +692,7 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
>                 strlen("heartbt"),
>                 strlen("overrun"),
>                 strlen("compressed"),
> +               strlen("otherhost_dropped"),
>         };
>         int ret;
>
> @@ -713,6 +714,10 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
>                 if (s->rx_compressed)
>                         print_u64(PRINT_JSON,
>                                    "compressed", NULL, s->rx_compressed);
> +               if (s->rx_otherhost_dropped)
> +                       print_u64(PRINT_JSON,
> +                                  "otherhost_dropped",
> +                                  NULL, s->rx_otherhost_dropped);
>
>                 /* RX error stats */
>                 if (show_stats > 1) {
> @@ -795,11 +800,15 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
>                                      rta_getattr_u32(carrier_changes) : 0);
>
>                 /* RX stats */
> -               fprintf(fp, "    RX: %*s %*s %*s %*s %*s %*s %*s%s",
> +               fprintf(fp, "    RX: %*s %*s %*s %*s %*s %*s %*s%*s%s",
I think you're missing a space in the line above (but code shouldn't
be here, see my comment below)
>                         cols[0] - 4, "bytes", cols[1], "packets",
>                         cols[2], "errors", cols[3], "dropped",
>                         cols[4], "missed", cols[5], "mcast",
> -                       cols[6], s->rx_compressed ? "compressed" : "", _SL_);
> +                       s->rx_compressed ? cols[6] : 0,
> +                       s->rx_compressed ? "compressed " : "",
> +                       s->rx_otherhost_dropped ? cols[7] : 0,
> +                       s->rx_otherhost_dropped ? "otherhost_dropped" : "",
> +                       _SL_);
rx_otherhost_dropped code should be below in the "RX error stats" not
here, it should be after the rx_nohandler stat. Also IIUC, the code
should be:
  cols[7], s->rx_otherhost_dropped? "otherhost_dropped" : "",

>
>                 fprintf(fp, "    ");
>                 print_num(fp, cols[0], s->rx_bytes);
> @@ -810,6 +819,8 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
>                 print_num(fp, cols[5], s->multicast);
>                 if (s->rx_compressed)
>                         print_num(fp, cols[6], s->rx_compressed);
> +               if (s->rx_otherhost_dropped)
> +                       print_num(fp, cols[7], s->rx_otherhost_dropped);
>
>                 /* RX error stats */
>                 if (show_stats > 1) {
> --
> 2.36.0.512.ge40c2bad7a-goog
>
