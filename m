Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53426508862
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 14:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244900AbiDTMqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 08:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbiDTMqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 08:46:39 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACE4205C2
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 05:43:52 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id i27so3261070ejd.9
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 05:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z0OzyXaV5p/AcyiBC22STlUCDTMHnv+/r3Kvw45kWZM=;
        b=TMvfyQkJxHdtdZuB+ru5J4rjXppDmTJWWr+g2ulJ0DDrXwezUFUCt9Gmo/TFqEmoyX
         wH5z1GYKSC76DgSQdLeZiScsVW3F2nCfINa3AMGWHAl7FVgiFPQICIg2w1SnQ9oFAjlH
         X8OhuRQziRHWiPfvvtedwFF+tczSzy19WtDbxzgl4PfjCK/yBgXlf2zWiVLOBczqAqUC
         +w4VHQT+i6uozWqNgxFB1+TczKHlF7NpMoGR4YH1rROgo0tgL7HtKtXVa7Z+SRh7Glka
         MgBTXrcOllr3FH4nXIk3pkbvAixDKR3ZRsQEPxTVcjIhYS9NvXfI22dYDQl+pmL/wcbh
         6TOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z0OzyXaV5p/AcyiBC22STlUCDTMHnv+/r3Kvw45kWZM=;
        b=j3UsdnI9ubo5MUwlGVBGQ52X8uv1GHJFT1805+k3Rxd8TrvQBtbKnIhSK0QH8RK/9x
         RAFYXjTo8G2Af5sGXYjAbbgyCoA2/xhuwjB+QVr2R1xJ5bEQc7/zvjskUkIMWnghdx3s
         mustYeFufdkMQMgyfjpNuHL2AVJzGiZYCbkRvmwK4ASV5n0ws5fQpYIWqlsjgXo0NAIK
         vIM9xnTLnvRJNcHyENgIoOGD6e4sSG0U3+MHstLykDf1loBbXdZo4UcmT8t7bNzsy41Y
         1RhkxfeWnmkjn7YDu7RgRgOOXCcIDjXbvNwaq2m60NGyBsiev1JvOxm2urLZcvvww+Mx
         xyKg==
X-Gm-Message-State: AOAM530y4D7vh4t9Bcd7iiUU5B1mYZe37ECnQ7uIQbTWpexkBLaXZ1yA
        7X8EhrlZAh4+/a+fC4T47QTE0KSTaKVZhKxvnwg=
X-Google-Smtp-Source: ABdhPJwjoE0+C7lGhDYn9uKx50vwoTN56u85K8RlBApTU0tUzFI7b7QNjXlsGAfnCZWI99o3fOZiZsoT48nvBcyPEDg=
X-Received: by 2002:a17:906:94d6:b0:6e8:d608:c960 with SMTP id
 d22-20020a17090694d600b006e8d608c960mr18495548ejy.96.1650458630996; Wed, 20
 Apr 2022 05:43:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220415163912.26530-1-xiangxia.m.yue@gmail.com> <20220415163912.26530-3-xiangxia.m.yue@gmail.com>
In-Reply-To: <20220415163912.26530-3-xiangxia.m.yue@gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 20 Apr 2022 20:43:14 +0800
Message-ID: <CAMDZJNXb8bwXbbSoum3488c+zYA_4Ow3o5dXiWvquywnBtNg=A@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] net: sysctl: introduce sysctl SYSCTL_THREE
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 16, 2022 at 12:40 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> This patch introdues the SYSCTL_THREE.
Hi Luis, Jakub
any thoughts? I have fixed v2.
> KUnit:
> [00:10:14] ================ sysctl_test (10 subtests) =================
> [00:10:14] [PASSED] sysctl_test_api_dointvec_null_tbl_data
> [00:10:14] [PASSED] sysctl_test_api_dointvec_table_maxlen_unset
> [00:10:14] [PASSED] sysctl_test_api_dointvec_table_len_is_zero
> [00:10:14] [PASSED] sysctl_test_api_dointvec_table_read_but_position_set
> [00:10:14] [PASSED] sysctl_test_dointvec_read_happy_single_positive
> [00:10:14] [PASSED] sysctl_test_dointvec_read_happy_single_negative
> [00:10:14] [PASSED] sysctl_test_dointvec_write_happy_single_positive
> [00:10:14] [PASSED] sysctl_test_dointvec_write_happy_single_negative
> [00:10:14] [PASSED] sysctl_test_api_dointvec_write_single_less_int_min
> [00:10:14] [PASSED] sysctl_test_api_dointvec_write_single_greater_int_max
> [00:10:14] =================== [PASSED] sysctl_test ===================
>
> ./run_kselftest.sh -c sysctl
> ...
> ok 1 selftests: sysctl: sysctl.sh
>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Iurii Zaikin <yzaikin@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Julian Anastasov <ja@ssi.bg>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Cc: Akhmat Karakotov <hmukos@yandex-team.ru>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  fs/proc/proc_sysctl.c          | 2 +-
>  include/linux/sysctl.h         | 9 +++++----
>  net/core/sysctl_net_core.c     | 3 +--
>  net/ipv4/sysctl_net_ipv4.c     | 3 +--
>  net/ipv6/sysctl_net_ipv6.c     | 3 +--
>  net/netfilter/ipvs/ip_vs_ctl.c | 4 +---
>  6 files changed, 10 insertions(+), 14 deletions(-)
>
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 7d9cfc730bd4..5851c2a92c0d 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -26,7 +26,7 @@ static const struct file_operations proc_sys_dir_file_operations;
>  static const struct inode_operations proc_sys_dir_operations;
>
>  /* shared constants to be used in various sysctls */
> -const int sysctl_vals[] = { -1, 0, 1, 2, 4, 100, 200, 1000, 3000, INT_MAX, 65535 };
> +const int sysctl_vals[] = { 0, 1, 2, 3, 4, 100, 200, 1000, 3000, INT_MAX, 65535, -1 };
>  EXPORT_SYMBOL(sysctl_vals);
>
>  const unsigned long sysctl_long_vals[] = { 0, 1, LONG_MAX };
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index 6353d6db69b2..80263f7cdb77 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -38,10 +38,10 @@ struct ctl_table_header;
>  struct ctl_dir;
>
>  /* Keep the same order as in fs/proc/proc_sysctl.c */
> -#define SYSCTL_NEG_ONE                 ((void *)&sysctl_vals[0])
> -#define SYSCTL_ZERO                    ((void *)&sysctl_vals[1])
> -#define SYSCTL_ONE                     ((void *)&sysctl_vals[2])
> -#define SYSCTL_TWO                     ((void *)&sysctl_vals[3])
> +#define SYSCTL_ZERO                    ((void *)&sysctl_vals[0])
> +#define SYSCTL_ONE                     ((void *)&sysctl_vals[1])
> +#define SYSCTL_TWO                     ((void *)&sysctl_vals[2])
> +#define SYSCTL_THREE                   ((void *)&sysctl_vals[3])
>  #define SYSCTL_FOUR                    ((void *)&sysctl_vals[4])
>  #define SYSCTL_ONE_HUNDRED             ((void *)&sysctl_vals[5])
>  #define SYSCTL_TWO_HUNDRED             ((void *)&sysctl_vals[6])
> @@ -51,6 +51,7 @@ struct ctl_dir;
>
>  /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
>  #define SYSCTL_MAXOLDUID               ((void *)&sysctl_vals[10])
> +#define SYSCTL_NEG_ONE                 ((void *)&sysctl_vals[11])
>
>  extern const int sysctl_vals[];
>
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index 3a0ce309ffcd..195ca5c28771 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -25,7 +25,6 @@
>
>  #include "dev.h"
>
> -static int three = 3;
>  static int int_3600 = 3600;
>  static int min_sndbuf = SOCK_MIN_SNDBUF;
>  static int min_rcvbuf = SOCK_MIN_RCVBUF;
> @@ -553,7 +552,7 @@ static struct ctl_table net_core_table[] = {
>                 .mode           = 0644,
>                 .proc_handler   = proc_dointvec_minmax,
>                 .extra1         = SYSCTL_ZERO,
> -               .extra2         = &three,
> +               .extra2         = SYSCTL_THREE,
>         },
>         {
>                 .procname       = "high_order_alloc_disable",
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 9ff60a389cd0..cd448cdd3b38 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -20,7 +20,6 @@
>  #include <net/protocol.h>
>  #include <net/netevent.h>
>
> -static int three __maybe_unused = 3;
>  static int tcp_retr1_max = 255;
>  static int ip_local_port_range_min[] = { 1, 1 };
>  static int ip_local_port_range_max[] = { 65535, 65535 };
> @@ -1056,7 +1055,7 @@ static struct ctl_table ipv4_net_table[] = {
>                 .mode           = 0644,
>                 .proc_handler   = proc_fib_multipath_hash_policy,
>                 .extra1         = SYSCTL_ZERO,
> -               .extra2         = &three,
> +               .extra2         = SYSCTL_THREE,
>         },
>         {
>                 .procname       = "fib_multipath_hash_fields",
> diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
> index 560c48d0ddb7..94a0a294c6a1 100644
> --- a/net/ipv6/sysctl_net_ipv6.c
> +++ b/net/ipv6/sysctl_net_ipv6.c
> @@ -23,7 +23,6 @@
>  #endif
>  #include <linux/ioam6.h>
>
> -static int three = 3;
>  static int flowlabel_reflect_max = 0x7;
>  static int auto_flowlabels_max = IP6_AUTO_FLOW_LABEL_MAX;
>  static u32 rt6_multipath_hash_fields_all_mask =
> @@ -171,7 +170,7 @@ static struct ctl_table ipv6_table_template[] = {
>                 .mode           = 0644,
>                 .proc_handler   = proc_rt6_multipath_hash_policy,
>                 .extra1         = SYSCTL_ZERO,
> -               .extra2         = &three,
> +               .extra2         = SYSCTL_THREE,
>         },
>         {
>                 .procname       = "fib_multipath_hash_fields",
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 7f645328b47f..efab2b06d373 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -1767,8 +1767,6 @@ static int ip_vs_zero_all(struct netns_ipvs *ipvs)
>
>  #ifdef CONFIG_SYSCTL
>
> -static int three = 3;
> -
>  static int
>  proc_do_defense_mode(struct ctl_table *table, int write,
>                      void *buffer, size_t *lenp, loff_t *ppos)
> @@ -1977,7 +1975,7 @@ static struct ctl_table vs_vars[] = {
>                 .mode           = 0644,
>                 .proc_handler   = proc_dointvec_minmax,
>                 .extra1         = SYSCTL_ZERO,
> -               .extra2         = &three,
> +               .extra2         = SYSCTL_THREE,
>         },
>         {
>                 .procname       = "nat_icmp_send",
> --
> 2.27.0
>


--
Best regards, Tonghao
