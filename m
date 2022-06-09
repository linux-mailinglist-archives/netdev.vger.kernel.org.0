Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409E3545627
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 23:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbiFIVHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 17:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbiFIVHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 17:07:40 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8850A10193B
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 14:07:39 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id b8so16108106edj.11
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 14:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1sSVMBYpvJaLt9luffWfuT6jgaNaQa7Fb4of1JtG4GI=;
        b=qaHEDk8oBsa85PA1WSFUSkANAUy4PL6zvGh+CtPb2lfFluohhdZbLzEQj0vg74/KTV
         Rqiqnp+jWkmy5UZ0JS8Sifufnaeg3l2hS9xBxsVMfaGkaZVyTgobCOY1qIOrceBM2cBx
         TJVMUHIxAz0bAyMtE+1zi//E54fg9hOLdKA+7/kc0nVyryXAPHT+oJewkju4JYmRxwnm
         UsoSqTgYernmF8ShAjDbkJ0HDjSc7YWTyVfpI0UwglTILV8SHlsBAKvcLi+AxpCpYSxA
         06ER0aQOTSJHHIKJ8OHg4ZVXhj9IRcpen+YlYlAKDpadsjAF53sgwSgNG62Ubc78Trsc
         OAWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1sSVMBYpvJaLt9luffWfuT6jgaNaQa7Fb4of1JtG4GI=;
        b=B+4QaL3vvtNtlWaPxbcO4tO9yWOBtp8fiJMXKmpl4p6hxhU1cmwDVyB/ivFu3RZ4Ik
         SyxBzr8sWVvL1pGQxDA94A0SIrVCGECM0TCPXhC3WFk815HaCVioS15Qj6DS8n+/8SSu
         dzTQ5Rr5Jzb4Ja7TSIF7NAoiia8AzwLvfi7J0Fp6ghpyuD5Z17dMTRhzOHboIFCxzIx2
         9nN8dbJKSpGbskoLr6QaumKEJqNdC37XhMrE1RNP1BciIt280j7ptgrI7j1nIU2lYlle
         WlQ9QS5x1U3CUu6SAq9m3IzsVlUdJ4xGKyiZx55knP0VKnOoRum10HwOWYgQylwvQyVU
         WGlw==
X-Gm-Message-State: AOAM5304dYZjqanOVEdwABq3nh4D3LQJtWJfG9vwu3946y7c+xPc/JIU
        AM45duU+WG1dKIcKzw72z2qPvnbVNA3s4e3v19VRTzIjAyw=
X-Google-Smtp-Source: ABdhPJw6TmmQfvmV1ML382g/J2dXKWrDiIJRyW6ztVc+aLESRtBjSW2DL8lE8/T4MvCymy507nTIxxCa6NJXtgndiH8=
X-Received: by 2002:aa7:d88a:0:b0:431:32be:f2d4 with SMTP id
 u10-20020aa7d88a000000b0043132bef2d4mr32356141edq.360.1654808858006; Thu, 09
 Jun 2022 14:07:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220609210516.2311379-1-jeffreyjilinux@gmail.com>
In-Reply-To: <20220609210516.2311379-1-jeffreyjilinux@gmail.com>
From:   Jeffrey Ji <jeffreyjilinux@gmail.com>
Date:   Thu, 9 Jun 2022 14:07:26 -0700
Message-ID: <CACB8nPkSn+Q5Bi4VwggS5so+ZsrU8OiBMdbC_y7czCU8EGeOjg@mail.gmail.com>
Subject: Re: [PATCH iproute2-next v2] show rx_otherehost_dropped stat in ip
 link show
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Brian Vazquez <brianvv@google.com>, netdev@vger.kernel.org,
        Jeffrey Ji <jeffreyji@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sample output:

mypc[netns:ns-123771-2]:~# ip netns exec $ns2 ./ip -s -s link sh
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
mode DEFAULT group default qlen 1000
link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
RX: bytes packets errors dropped missed mcast
0 0 0 0 0 0
RX errors: length crc frame fifo overrun
0 0 0 0 0
TX: bytes packets errors dropped carrier collsns
0 0 0 0 0 0
TX errors: aborted fifo window heartbt transns
0 0 0 0 0
2: veth2@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
state UP mode DEFAULT group default qlen 1000
link/ether 8e:c0:a5:7d:87:ad brd ff:ff:ff:ff:ff:ff link-netns ns-123771-1
RX: bytes packets errors dropped missed mcast
1766 22 0 0 0 0
RX errors: length crc frame fifo overrun otherhost
0 0 0 0 0 10
TX: bytes packets errors dropped carrier collsns
1126 13 0 0 0 0
TX errors: aborted fifo window heartbt transns
0 0 0 0 2

On Thu, Jun 9, 2022 at 2:05 PM Jeffrey Ji <jeffreyjilinux@gmail.com> wrote:
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
> changelog:
> v2: otherhost <- otherhost_dropped
>
>  ip/ipaddress.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
>
> diff --git a/ip/ipaddress.c b/ip/ipaddress.c
> index 142731933ba3..d7d047cf901e 100644
> --- a/ip/ipaddress.c
> +++ b/ip/ipaddress.c
> @@ -692,6 +692,7 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
>                 strlen("heartbt"),
>                 strlen("overrun"),
>                 strlen("compressed"),
> +               strlen("otherhost"),
>         };
>
>         if (is_json_context()) {
> @@ -730,6 +731,10 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
>                         if (s->rx_nohandler)
>                                 print_u64(PRINT_JSON,
>                                            "nohandler", NULL, s->rx_nohandler);
> +                       if (s->rx_otherhost_dropped)
> +                               print_u64(PRINT_JSON,
> +                                          "otherhost", NULL,
> +                                          s->rx_otherhost_dropped);
>                 }
>                 close_json_object();
>
> @@ -778,7 +783,8 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
>                         size_columns(cols, ARRAY_SIZE(cols), 0,
>                                      s->rx_length_errors, s->rx_crc_errors,
>                                      s->rx_frame_errors, s->rx_fifo_errors,
> -                                    s->rx_over_errors, s->rx_nohandler);
> +                                    s->rx_over_errors, s->rx_nohandler,
> +                                    s->rx_otherhost_dropped);
>                 size_columns(cols, ARRAY_SIZE(cols),
>                              s->tx_bytes, s->tx_packets, s->tx_errors,
>                              s->tx_dropped, s->tx_carrier_errors,
> @@ -811,11 +817,14 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
>                 /* RX error stats */
>                 if (show_stats > 1) {
>                         fprintf(fp, "%s", _SL_);
> -                       fprintf(fp, "    RX errors:%*s %*s %*s %*s %*s %*s %*s%s",
> +                       fprintf(fp, "    RX errors:%*s %*s %*s %*s %*s %*s%*s%*s%s",
>                                 cols[0] - 10, "", cols[1], "length",
>                                 cols[2], "crc", cols[3], "frame",
>                                 cols[4], "fifo", cols[5], "overrun",
> -                               cols[6], s->rx_nohandler ? "nohandler" : "",
> +                               s->rx_nohandler ? cols[6] + 1 : 0,
> +                               s->rx_nohandler ? " nohandler" : "",
> +                               s->rx_otherhost_dropped ? cols[7] + 1 : 0,
> +                               s->rx_otherhost_dropped ? " otherhost" : "",
>                                 _SL_);
>                         fprintf(fp, "%*s", cols[0] + 5, "");
>                         print_num(fp, cols[1], s->rx_length_errors);
> @@ -825,6 +834,9 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
>                         print_num(fp, cols[5], s->rx_over_errors);
>                         if (s->rx_nohandler)
>                                 print_num(fp, cols[6], s->rx_nohandler);
> +                       if (s->rx_otherhost_dropped)
> +                               print_num(fp, cols[7],
> +                               s->rx_otherhost_dropped);
>                 }
>                 fprintf(fp, "%s", _SL_);
>
> --
> 2.36.1.476.g0c4daa206d-goog
>
