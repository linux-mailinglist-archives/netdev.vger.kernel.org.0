Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E54DB28C9A
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388372AbfEWVq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:46:28 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35050 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388232AbfEWVq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 17:46:28 -0400
Received: by mail-ed1-f67.google.com with SMTP id p26so11282000edr.2;
        Thu, 23 May 2019 14:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hS1J+L8InX8t+S5g40fUDrEZZWAutsMmjF58rVNfY4A=;
        b=vF7wzIafOwzPH1p6LsShpR37Mg3sBS7pnLiT2O9iV6X1EtYSjTwLFwI1Br/cLiMXt2
         RwhRLJ6sJ8W8XSai7YLJK5m3TJbd46SuWj7BgeZG4WUd4KKSpPrpTbI+ff62ThALF71C
         odj8iC1OSSKR/yrb1wuok+xjLsOJO0qivUJqCPfh9PBISpU6oulbKPK4Vf1ZdTq4f//q
         3N4a0kdGoEHNkmU/wZx5V5PaWeMeebWVmHcI783Ik9w5f+UmCmSyThzR/d02njmGhDq+
         XzHD//Fm/PwpHXQf1ljwBKIyq9nnSNpVikR1A3hDfePxb8GaqeIJCk4D8XaeNI1moqnl
         5qCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hS1J+L8InX8t+S5g40fUDrEZZWAutsMmjF58rVNfY4A=;
        b=d1AEp2ysj2JLc09oB3E281wUGCkk8dSHQr50i0HT73+zlJeJ0HIJPrdthuh55zALl3
         wP79v8SfzlWt8+lnXpbUHu5OpoX+aOfKbi+Kibd/PbbcLzyK8Anb9QQ3DRL82edUpsUk
         Q2eCpGgogHh2fGbSu5gQSV0ygokG7FFYVC5I4PvNBrpcfINJxptvtc1JIPaBI4M6E45D
         /nWr2Ma0LZsHyMI1FFvOkNsHlZ361LpQwJGJXAsO4wJBHCiKYXOPYG/zudObp8xQ777h
         LM8xjaa9kNnnPSOjmF9+K2uHyShs+nEvSrlmKxto+8b3VYHwfZUz0ow4yA2sszcvj9Pu
         ge1g==
X-Gm-Message-State: APjAAAXF3YXgeRx22mGBGVM9aUwu41zPAZ9GJNPq/hhiJ9sn1R706iSh
        DI7g73mqhy/scJdvOLUGqVdEw1QoGvIMboUVrLA=
X-Google-Smtp-Source: APXvYqwRs1XOL8neFbNGaC+e+ESBojE/AQYVeCKksTEz4shDZdYlC7mr4NocdxwmtEAjUnfC/5JJpyz2nvSkbDYoeDo=
X-Received: by 2002:a50:b665:: with SMTP id c34mr99149662ede.148.1558647986054;
 Thu, 23 May 2019 14:46:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190523210651.80902-1-fklassen@appneta.com> <20190523210651.80902-3-fklassen@appneta.com>
In-Reply-To: <20190523210651.80902-3-fklassen@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 23 May 2019 17:45:49 -0400
Message-ID: <CAF=yD-Lcg2wkGoKm8yGNnb_z5925PJztEAej-ahvz=2G35ke4g@mail.gmail.com>
Subject: Re: [PATCH net 2/4] net/udpgso_bench_tx: options to exercise TX CMSG
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 5:11 PM Fred Klassen <fklassen@appneta.com> wrote:
>
> This enhancement adds options that facilitate load testing with
> additional TX CMSG options, and to optionally print results of
> various send CMSG operations.
>
> These options are especially useful in isolating situations
> where error-queue messages are lost when combined with other
> CMSG operations (e.g. SO_ZEROCOPY).
>
> New options:
>
>     -T - add TX CMSG that requests TX software timestamps
>     -H - similar to -T except request TX hardware timestamps
>     -q - add IP_TOS/IPV6_TCLASS TX CMSG
>     -P - call poll() before reading error queue
>     -v - print detailed results
>
> Fixes: 3a687bef148d ("selftests: udp gso benchmark")

This is not a fix, but an extension. Fixes tags help with backporting
to stable kernels. There is something to be said to backport the main
change and support SO_TIMESTAMPING + UDP_GSO on older kernels,
especially since it is very concise. But the tests should probably be
in a separate patch set targeting net-next.


> Signed-off-by: Fred Klassen <fklassen@appneta.com>
> ---
>  tools/testing/selftests/net/udpgso_bench_tx.c | 290 ++++++++++++++++++++++++--
>  1 file changed, 273 insertions(+), 17 deletions(-)
>
> diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
> index 4074538b5df5..a900f016b9e7 100644
> --- a/tools/testing/selftests/net/udpgso_bench_tx.c
> +++ b/tools/testing/selftests/net/udpgso_bench_tx.c
> @@ -5,6 +5,8 @@
>  #include <arpa/inet.h>
>  #include <errno.h>
>  #include <error.h>
> +#include <linux/errqueue.h>
> +#include <linux/net_tstamp.h>
>  #include <netinet/if_ether.h>
>  #include <netinet/in.h>
>  #include <netinet/ip.h>
> @@ -19,6 +21,7 @@
>  #include <string.h>
>  #include <sys/socket.h>
>  #include <sys/time.h>
> +#include <sys/poll.h>
>  #include <sys/types.h>
>  #include <unistd.h>
>
> @@ -34,6 +37,10 @@
>  #define SO_ZEROCOPY    60
>  #endif
>
> +#ifndef SO_EE_ORIGIN_ZEROCOPY
> +#define SO_EE_ORIGIN_ZEROCOPY 5
> +#endif
> +
>  #ifndef MSG_ZEROCOPY
>  #define MSG_ZEROCOPY   0x4000000
>  #endif
> @@ -48,9 +55,14 @@ static uint16_t      cfg_mss;
>  static int     cfg_payload_len = (1472 * 42);
>  static int     cfg_port        = 8000;
>  static int     cfg_runtime_ms  = -1;
> +static bool    cfg_poll;
>  static bool    cfg_segment;
>  static bool    cfg_sendmmsg;
>  static bool    cfg_tcp;
> +static uint32_t        cfg_tx_ts = SOF_TIMESTAMPING_TX_SOFTWARE;
> +static bool    cfg_tx_tstamp;
> +static uint32_t        cfg_tos;
> +static bool    cfg_verbose;
>  static bool    cfg_zerocopy;
>  static int     cfg_msg_nr;
>  static uint16_t        cfg_gso_size;
> @@ -58,6 +70,10 @@ static uint16_t      cfg_gso_size;
>  static socklen_t cfg_alen;
>  static struct sockaddr_storage cfg_dst_addr;
>
> +struct my_scm_timestamping {
> +       struct timespec ts[3];
> +};
> +

This and the above should not be needed if including <linux/errqueue.h>

It may be absent if relying on the host header files, but the
kselftest build system should correctly use the files from the kernel
source tree.

>  static bool interrupted;
>  static char buf[NUM_PKT][ETH_MAX_MTU];
>
> @@ -89,20 +105,20 @@ static int set_cpu(int cpu)
>
>  static void setup_sockaddr(int domain, const char *str_addr, void *sockaddr)
>  {
> -       struct sockaddr_in6 *addr6 = (void *) sockaddr;
> -       struct sockaddr_in *addr4 = (void *) sockaddr;
> +       struct sockaddr_in6 *addr6 = (void *)sockaddr;
> +       struct sockaddr_in *addr4 = (void *)sockaddr;
>
>         switch (domain) {
>         case PF_INET:
>                 addr4->sin_family = AF_INET;
>                 addr4->sin_port = htons(cfg_port);
> -               if (inet_pton(AF_INET, str_addr, &(addr4->sin_addr)) != 1)
> +               if (inet_pton(AF_INET, str_addr, &addr4->sin_addr) != 1)
>                         error(1, 0, "ipv4 parse error: %s", str_addr);
>                 break;
>         case PF_INET6:
>                 addr6->sin6_family = AF_INET6;
>                 addr6->sin6_port = htons(cfg_port);
> -               if (inet_pton(AF_INET6, str_addr, &(addr6->sin6_addr)) != 1)
> +               if (inet_pton(AF_INET6, str_addr, &addr6->sin6_addr) != 1)

Please do not include style changes like these. Try to minimize
changes required to add the new feature.
