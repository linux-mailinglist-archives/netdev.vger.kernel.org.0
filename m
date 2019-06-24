Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2F151F1D
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 01:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbfFXXZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 19:25:49 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:47060 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbfFXXZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 19:25:49 -0400
Received: by mail-qk1-f196.google.com with SMTP id x18so11109138qkn.13
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 16:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AhnDykrMunP8nr+Ed+zxL3P+ZN/hw4ZbL9gnxKuR1jE=;
        b=qW93cARKs2zwSKR1fX8XFehczQU0tkBxoiorMoTqwJl/xtmcQJU/g2wPMtkoy9IdUX
         SdGo8kBxM1AKDIlhV430fyL8WEi7ktFpaoJ6FjwCzl3xvn75FvT8Z++OZwwMV4AlQM6y
         H84a30L3VY9fkzjOZh6ojEfSZBuLFqVmVIlYFZCH14UTFAGiyCZg+npcwDxbYZuUOb5m
         sQ33AUawidxN7FLcYAk/OjxsyjY6hol0+bh36WQvpuXN+YbccRv/AIca03dj2K7oyc/t
         kjrB55jrajvf9Auf4nJxGkl+7QZWVENA9HEUP4+ONimmQCWE5Jkbt+VweLwTSWXoGu+M
         VuPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AhnDykrMunP8nr+Ed+zxL3P+ZN/hw4ZbL9gnxKuR1jE=;
        b=httj+upNhM2fgLzxYN5K57aIAM2mZDdJG9TqZbm7/Q4IFmh7lejKjvTvFue7Pg303B
         T5IuIV546HNS9BCOAffVt3SmMR4gZrzFRiTiuNo5r9gPNPA2Wb74Rw0BKum67iLFNiIu
         wVG5uF+PTD/gH04CWEbidFnLtmGNavLJ5/aTp69L5pfvqKrDCKjcX9KgRxlmdTn+fa0O
         CBWeuc7mM5TJyRl77J6QNhKa/n+YGCtZvzEb4ISlYTmpZnpl308OMXVclv42FUFNYeoF
         KZaJXSaQKKReKIAhffS9Gz8G5DOHwOdV78NOaDqjQo28e61ZGEG5cNntcHbnzU22e/mD
         XDGQ==
X-Gm-Message-State: APjAAAWq+CqBzbVf32z5DPwETcRwnTr83zwDqOHMckuk+3I6OuXF5pBY
        grkYlmKl6t6LmKUpaYFcGgpHQ9O5GReVkGXzvg8=
X-Google-Smtp-Source: APXvYqwu//ivVrX/U3zSHAujJVvhgDCr77vqjNjr0M6PamXmMjnBK4pBwL1aCtYGjK249XazEizpq1/lElhuwYC5xKY=
X-Received: by 2002:a37:6984:: with SMTP id e126mr18941320qkc.487.1561418748009;
 Mon, 24 Jun 2019 16:25:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190624112009.20048-1-danieltimlee@gmail.com>
In-Reply-To: <20190624112009.20048-1-danieltimlee@gmail.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Mon, 24 Jun 2019 16:25:37 -0700
Message-ID: <CAPhsuW5_KJXBcYr3AYa78Gw4Lx4TX73ri3-6wx8kEiX=ENoAVA@mail.gmail.com>
Subject: Re: [PATCH] samples: bpf: make the use of xdp samples consistent
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 6:57 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Currently, each xdp samples are inconsistent in the use.
> Most of the samples fetch the interface with it's name.
> (ex. xdp1, xdp2skb, xdp_redirect, xdp_sample_pkts, etc.)
>
> But only xdp_adjst_tail and xdp_tx_iptunnel fetch the interface with
> ifindex by command argument.
>
> This commit enables those two samples to fetch interface with it's name
> without changing the original index interface fetching.
> (<ifname|ifindex> fetching in the same way as xdp_sample_pkts_user.c does.)
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

From patchworks, I assume you will send v2.

Please also CC bpf@vger.kernel.org in v2.

Thanks,
Song

> ---
>  samples/bpf/xdp_adjust_tail_user.c | 12 ++++++++++--
>  samples/bpf/xdp_tx_iptunnel_user.c | 12 ++++++++++--
>  2 files changed, 20 insertions(+), 4 deletions(-)
>
> diff --git a/samples/bpf/xdp_adjust_tail_user.c b/samples/bpf/xdp_adjust_tail_user.c
> index 586ff751aba9..a3596b617c4c 100644
> --- a/samples/bpf/xdp_adjust_tail_user.c
> +++ b/samples/bpf/xdp_adjust_tail_user.c
> @@ -13,6 +13,7 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> +#include <net/if.h>
>  #include <sys/resource.h>
>  #include <arpa/inet.h>
>  #include <netinet/ether.h>
> @@ -69,7 +70,7 @@ static void usage(const char *cmd)
>         printf("Start a XDP prog which send ICMP \"packet too big\" \n"
>                 "messages if ingress packet is bigger then MAX_SIZE bytes\n");
>         printf("Usage: %s [...]\n", cmd);
> -       printf("    -i <ifindex> Interface Index\n");
> +       printf("    -i <ifname|ifindex> Interface\n");
>         printf("    -T <stop-after-X-seconds> Default: 0 (forever)\n");
>         printf("    -S use skb-mode\n");
>         printf("    -N enforce native mode\n");
> @@ -102,7 +103,9 @@ int main(int argc, char **argv)
>
>                 switch (opt) {
>                 case 'i':
> -                       ifindex = atoi(optarg);
> +                       ifindex = if_nametoindex(optarg);
> +                       if (!ifindex)
> +                               ifindex = atoi(optarg);
>                         break;
>                 case 'T':
>                         kill_after_s = atoi(optarg);
> @@ -136,6 +139,11 @@ int main(int argc, char **argv)
>                 return 1;
>         }
>
> +       if (!ifindex) {
> +               fprintf(stderr, "Invalid ifname\n");
> +               return 1;
> +       }
> +
>         snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
>         prog_load_attr.file = filename;
>
> diff --git a/samples/bpf/xdp_tx_iptunnel_user.c b/samples/bpf/xdp_tx_iptunnel_user.c
> index 394896430712..dfb68582e243 100644
> --- a/samples/bpf/xdp_tx_iptunnel_user.c
> +++ b/samples/bpf/xdp_tx_iptunnel_user.c
> @@ -9,6 +9,7 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> +#include <net/if.h>
>  #include <sys/resource.h>
>  #include <arpa/inet.h>
>  #include <netinet/ether.h>
> @@ -83,7 +84,7 @@ static void usage(const char *cmd)
>                "in an IPv4/v6 header and XDP_TX it out.  The dst <VIP:PORT>\n"
>                "is used to select packets to encapsulate\n\n");
>         printf("Usage: %s [...]\n", cmd);
> -       printf("    -i <ifindex> Interface Index\n");
> +       printf("    -i <ifname|ifindex> Interface\n");
>         printf("    -a <vip-service-address> IPv4 or IPv6\n");
>         printf("    -p <vip-service-port> A port range (e.g. 433-444) is also allowed\n");
>         printf("    -s <source-ip> Used in the IPTunnel header\n");
> @@ -181,7 +182,9 @@ int main(int argc, char **argv)
>
>                 switch (opt) {
>                 case 'i':
> -                       ifindex = atoi(optarg);
> +                       ifindex = if_nametoindex(optarg);
> +                       if (!ifindex)
> +                               ifindex = atoi(optarg);
>                         break;
>                 case 'a':
>                         vip.family = parse_ipstr(optarg, vip.daddr.v6);
> @@ -253,6 +256,11 @@ int main(int argc, char **argv)
>                 return 1;
>         }
>
> +       if (!ifindex) {
> +               fprintf(stderr, "Invalid ifname\n");
> +               return 1;
> +       }
> +
>         snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
>         prog_load_attr.file = filename;
>
> --
> 2.17.1
>
