Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FD65AF845
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 01:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiIFXMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 19:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiIFXMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 19:12:12 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFC188DDF
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 16:12:11 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-333a4a5d495so111362347b3.10
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 16:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=3JQEOWLEnbq0vh0DexQWukCn32UtKuHAkuSePHvQS0U=;
        b=s6AtETKvIEGich4NCsx1yel+1DolsO2sKsFgEpHqRTbeTGZKGrClDeG5GhhXWR8hrx
         daoxWL1CWmFXt3fW7Kc913NbYFOc80Yl0xiZAiXiS7Y9Vw4NrQLf+Y4E3OhCVXbQT4js
         5SXv3R9HRws6h2IRAX3r/RqoMei7PiPzQv9x38YCrkvMqQpbM8vkLbK+yZ9/9mqML9ls
         3AdN5CV8ovXKy+OOw+n4XLhCdGJDy5vsp9HOc5HhozgfQIQMagNp2DWdq9TA+8ltnSMn
         CLVg2KaED+KzF4Ym6/eIEsIKXnJRo0nLbjanorWy/1dSgRT9JfGny3EfyOpUt1U8IcxT
         EV6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=3JQEOWLEnbq0vh0DexQWukCn32UtKuHAkuSePHvQS0U=;
        b=nlK+Z/hjJzrFNU2rttHvq/as8phu8k8vdrcXaSqQ+J1awyq3F6E9Q/kscOFxyQBb2M
         6vnLWrQ39x3eWdsOJJQAtnYWrfYCBWfc2sGM09AKP9dHIC+zxI1L2oNDqVXsJViyctC9
         ancesvhbhAq8meyFyc4FPVyiOmR5+C6/BzQ7JNrKZJIMSw+K1GWYDkmVBcRSmZpqzLLf
         rY94zh0HpznUmlCjFToaLEoMmytcc1zRbozwkygWir4awZkk/YMD/KQCgCSww1CqIlWh
         wowDsTUonDMKtDfmotBONS9Emqxd32MgUrjJjJyPBWw71eNpsIzq8DXKPzO4myaOf8jk
         3x6A==
X-Gm-Message-State: ACgBeo2/r9ta06HS9fdprNgrCu2W5jdomGbQUhExLWQS7pDeAuKKb4lb
        IxnNH7hznXJXcU+df9Gw223J6cYqg6N60spWspATxQ==
X-Google-Smtp-Source: AA6agR6iJPahWCZn85Dc9fpexgOabsPzYuH4RyQqw98pcGpM4zf2Y0z3+NUjPM5vbUISzN+6VH8o2Bz9HzkQCu3F1KQ=
X-Received: by 2002:a0d:d5cd:0:b0:345:68b1:c06e with SMTP id
 x196-20020a0dd5cd000000b0034568b1c06emr780033ywd.489.1662505929988; Tue, 06
 Sep 2022 16:12:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1662361354.git.cdleonard@gmail.com> <298e4e87ce3a822b4217b309438483959082e6bb.1662361354.git.cdleonard@gmail.com>
In-Reply-To: <298e4e87ce3a822b4217b309438483959082e6bb.1662361354.git.cdleonard@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 6 Sep 2022 16:11:58 -0700
Message-ID: <CANn89iKq4rUkCwSSD-35u+Lb8s9u-8t5bj1=aZuQ8+oYwuC-Eg@mail.gmail.com>
Subject: Re: [PATCH v8 08/26] tcp: authopt: Disable via sysctl by default
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Salam Noureddine <noureddine@arista.com>,
        Philip Paeps <philip@trouble.is>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
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

On Mon, Sep 5, 2022 at 12:06 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>
> This is mainly intended to protect against local privilege escalations
> through a rarely used feature so it is deliberately not namespaced.
>
> Enforcement is only at the setsockopt level, this should be enough to
> ensure that the tcp_authopt_needed static key never turns on.
>
> No effort is made to handle disabling when the feature is already in
> use.
>
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.rst |  6 ++++
>  include/net/tcp_authopt.h              |  1 +
>  net/ipv4/sysctl_net_ipv4.c             | 39 ++++++++++++++++++++++++++
>  net/ipv4/tcp_authopt.c                 | 25 +++++++++++++++++
>  4 files changed, 71 insertions(+)
>
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index a759872a2883..41be0e69d767 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -1038,10 +1038,16 @@ tcp_challenge_ack_limit - INTEGER
>         Note that this per netns rate limit can allow some side channel
>         attacks and probably should not be enabled.
>         TCP stack implements per TCP socket limits anyway.
>         Default: INT_MAX (unlimited)
>
> +tcp_authopt - BOOLEAN
> +       Enable the TCP Authentication Option (RFC5925), a replacement for TCP
> +       MD5 Signatures (RFC2835).
> +
> +       Default: 0
> +
>  UDP variables
>  =============
>
>  udp_l3mdev_accept - BOOLEAN
>         Enabling this option allows a "global" bound socket to work
> diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
> index 7ad34a6987ec..1f5020b790dd 100644
> --- a/include/net/tcp_authopt.h
> +++ b/include/net/tcp_authopt.h
> @@ -80,10 +80,11 @@ struct tcphdr_authopt {
>  };
>
>  #ifdef CONFIG_TCP_AUTHOPT
>  DECLARE_STATIC_KEY_FALSE(tcp_authopt_needed_key);
>  #define tcp_authopt_needed (static_branch_unlikely(&tcp_authopt_needed_key))
> +extern int sysctl_tcp_authopt;
>  void tcp_authopt_free(struct sock *sk, struct tcp_authopt_info *info);
>  void tcp_authopt_clear(struct sock *sk);
>  int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen);
>  int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key);
>  int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen);
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 5490c285668b..908a3ef15b47 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -17,10 +17,11 @@
>  #include <net/udp.h>
>  #include <net/cipso_ipv4.h>
>  #include <net/ping.h>
>  #include <net/protocol.h>
>  #include <net/netevent.h>
> +#include <net/tcp_authopt.h>
>
>  static int tcp_retr1_max = 255;
>  static int ip_local_port_range_min[] = { 1, 1 };
>  static int ip_local_port_range_max[] = { 65535, 65535 };
>  static int tcp_adv_win_scale_min = -31;
> @@ -413,10 +414,37 @@ static int proc_fib_multipath_hash_fields(struct ctl_table *table, int write,
>
>         return ret;
>  }
>  #endif
>
> +#ifdef CONFIG_TCP_AUTHOPT
> +static int proc_tcp_authopt(struct ctl_table *ctl,
> +                           int write, void *buffer, size_t *lenp,
> +                           loff_t *ppos)
> +{
> +       int val = sysctl_tcp_authopt;

val = READ_ONCE(sysctl_tcp_authopt);

> +       struct ctl_table tmp = {
> +               .data = &val,
> +               .mode = ctl->mode,
> +               .maxlen = sizeof(val),
> +               .extra1 = SYSCTL_ZERO,
> +               .extra2 = SYSCTL_ONE,
> +       };
> +       int err;
> +
> +       err = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
> +       if (err)
> +               return err;
> +       if (sysctl_tcp_authopt && !val) {

READ_ONCE(sysctl_tcp_authopt)

Note that this test would still be racy, because another cpu might
change sysctl_tcp_authopt right after the read.

> +               net_warn_ratelimited("Enabling TCP Authentication Option is permanent\n");
> +               return -EINVAL;
> +       }
> +       sysctl_tcp_authopt = val;

WRITE_ONCE(sysctl_tcp_authopt, val),  or even better:

if (val)
     cmpxchg(&sysctl_tcp_authopt, 0, val);

> +       return 0;
> +}
> +#endif
> +
>  static struct ctl_table ipv4_table[] = {
>         {
>                 .procname       = "tcp_max_orphans",
>                 .data           = &sysctl_tcp_max_orphans,
>                 .maxlen         = sizeof(int),
> @@ -524,10 +552,21 @@ static struct ctl_table ipv4_table[] = {
>                 .mode           = 0644,
>                 .proc_handler   = proc_douintvec_minmax,
>                 .extra1         = &sysctl_fib_sync_mem_min,
>                 .extra2         = &sysctl_fib_sync_mem_max,
>         },
> +#ifdef CONFIG_TCP_AUTHOPT
> +       {
> +               .procname       = "tcp_authopt",
> +               .data           = &sysctl_tcp_authopt,
> +               .maxlen         = sizeof(int),
> +               .mode           = 0644,
> +               .proc_handler   = proc_tcp_authopt,
> +               .extra1         = SYSCTL_ZERO,
> +               .extra2         = SYSCTL_ONE,
> +       },
> +#endif
>         { }
>  };
>
>  static struct ctl_table ipv4_net_table[] = {
>         /* tcp_max_tw_buckets must be first in this table. */
> diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
> index 4f7cbe1e17f3..9d02da8d6964 100644
> --- a/net/ipv4/tcp_authopt.c
> +++ b/net/ipv4/tcp_authopt.c
> @@ -4,10 +4,15 @@
>  #include <net/ipv6.h>
>  #include <net/tcp.h>
>  #include <linux/kref.h>
>  #include <crypto/hash.h>
>
> +/* This is mainly intended to protect against local privilege escalations through
> + * a rarely used feature so it is deliberately not namespaced.
> + */
> +int sysctl_tcp_authopt;
> +
>  /* This is enabled when first struct tcp_authopt_info is allocated and never released */
>  DEFINE_STATIC_KEY_FALSE(tcp_authopt_needed_key);
>  EXPORT_SYMBOL(tcp_authopt_needed_key);
>
>  /* All current algorithms have a mac length of 12 but crypto API digestsize can be larger */
> @@ -437,17 +442,30 @@ static int _copy_from_sockptr_tolerant(u8 *dst,
>                 memset(dst + srclen, 0, dstlen - srclen);
>
>         return err;
>  }
>
> +static int check_sysctl_tcp_authopt(void)
> +{
> +       if (!sysctl_tcp_authopt) {

READ_ONCE(...)

> +               net_warn_ratelimited("TCP Authentication Option disabled by sysctl.\n");
> +               return -EPERM;
> +       }
> +
> +       return 0;
> +}
> +
>  int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
>  {
>         struct tcp_authopt opt;
>         struct tcp_authopt_info *info;
>         int err;
>
>         sock_owned_by_me(sk);
> +       err = check_sysctl_tcp_authopt();
> +       if (err)
> +               return err;
>
>         err = _copy_from_sockptr_tolerant((u8 *)&opt, sizeof(opt), optval, optlen);
>         if (err)
>                 return err;
>
> @@ -465,13 +483,17 @@ int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
>
>  int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
>  {
>         struct tcp_sock *tp = tcp_sk(sk);
>         struct tcp_authopt_info *info;
> +       int err;
>
>         memset(opt, 0, sizeof(*opt));
>         sock_owned_by_me(sk);
> +       err = check_sysctl_tcp_authopt();
> +       if (err)
> +               return err;
>
>         info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
>         if (!info)
>                 return -ENOENT;
>
> @@ -493,10 +515,13 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
>         struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
>         struct tcp_authopt_alg_imp *alg;
>         int err;
>
>         sock_owned_by_me(sk);
> +       err = check_sysctl_tcp_authopt();
> +       if (err)
> +               return err;
>         if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
>                 return -EPERM;
>
>         err = _copy_from_sockptr_tolerant((u8 *)&opt, sizeof(opt), optval, optlen);
>         if (err)
> --
> 2.25.1
>
