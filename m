Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19BFC4E6374
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 13:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350189AbiCXMhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 08:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbiCXMhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 08:37:19 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AEB9C0F
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 05:35:45 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id yy13so8887942ejb.2
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 05:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0a0LGJgQTjvhaM+tgQmxbQaIxsq6bmOJkrlq2lEUES0=;
        b=hyHNjtS4l4PhxlzlVgMruoxNQFrYynYWyb7jWNZMLsEUQrGLegYIyKD2s6uHgYI3Gu
         gf5n1nHxw5TEJfpsDSXN81qYhBUfYo0U6oRpDrKlULQ+kNIO34KjtjKyAlfWZLXPpQ5r
         E20TQTG+pkwz6uAuZgPLvXUwMtAgrbhKd5Ar+C7SRgwcXqgK1URLd7aSXN5jQRvWMXkt
         PDanRguE5x7Id5qVDa2RflJHOhxabBeuM3uM7e0K3+6PvnCz4vnhrTPFhoSIlPmNc12i
         IxuPBbOzD2fIWukggeMWOimyV1TdPa6QuQcRm+MggdWzT04jBdzLgF+DHqMpFy88HCuM
         Qs3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0a0LGJgQTjvhaM+tgQmxbQaIxsq6bmOJkrlq2lEUES0=;
        b=IPFFE5MDwedqNBh9As4FiRVadQcSNXGQ0M0Z1c6vCIvVP6lLn9JG94PW2az2haYW6q
         BozSWqqZEUBhXMBruyiIezwMm3N3zyUycx7qIXDAGLIchbTJeJzIIvqYZLXNng9Pa0JO
         KrHfJQvBzHM158LJKKf8woL5kzQ5CSNLQ7BRTTnZM3SmBxFGP7s4ilF0lwbB5IpkPbct
         TUXQBh6XJbgBds+emE74R/FRth7HVt9PZwINuALeOPkOsoA5Mjaf0PaMoy25TUhPFr2x
         JqCBqMTJuAdkCNnafvST5rkXDawBNCNzXjSPyTOAwy8X/DLBSnLbq9EzMYxv+1C/Z90T
         /9FA==
X-Gm-Message-State: AOAM5306RmwYmuN7lvAdb9C2L/l5btDaHeZjm4zCbGFpr5pbHqdHSTOJ
        vYZwNER+B7yD9XfnYRlJNuXUUszmuBbOJE/yMTuBuuDM
X-Google-Smtp-Source: ABdhPJwFFMR6KFWVpAL/2EUk5TWty4ZMpEhhp8smFeoPO+Oq37LNdxSYodjCT7A7osoI+0mc2iN0wkT+cY/urmG001s=
X-Received: by 2002:a17:907:c05:b0:6db:f118:8834 with SMTP id
 ga5-20020a1709070c0500b006dbf1188834mr5634671ejc.536.1648125343577; Thu, 24
 Mar 2022 05:35:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220323015326.26478-1-xiangxia.m.yue@gmail.com> <a188f84e4ded43f5e5e828ba8e32d7130bec80ec.camel@redhat.com>
In-Reply-To: <a188f84e4ded43f5e5e828ba8e32d7130bec80ec.camel@redhat.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 24 Mar 2022 20:35:04 +0800
Message-ID: <CAMDZJNURyrodNAOHYfhTz4Pi+VJJvDBeFCj3w+ZJSk3YSn+juQ@mail.gmail.com>
Subject: Re: [net-next v2] net: core: use shared sysctl macro
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 5:18 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Wed, 2022-03-23 at 09:53 +0800, xiangxia.m.yue@gmail.com wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > This patch introdues the SYSCTL_THREE, and replace the
> > two, three and long_one to SYSCTL_XXX accordingly.
> >
> >  KUnit:
> >  [23:03:58] ================ sysctl_test (10 subtests) =================
> >  [23:03:58] [PASSED] sysctl_test_api_dointvec_null_tbl_data
> >  [23:03:58] [PASSED] sysctl_test_api_dointvec_table_maxlen_unset
> >  [23:03:58] [PASSED] sysctl_test_api_dointvec_table_len_is_zero
> >  [23:03:58] [PASSED] sysctl_test_api_dointvec_table_read_but_position_set
> >  [23:03:58] [PASSED] sysctl_test_dointvec_read_happy_single_positive
> >  [23:03:58] [PASSED] sysctl_test_dointvec_read_happy_single_negative
> >  [23:03:58] [PASSED] sysctl_test_dointvec_write_happy_single_positive
> >  [23:03:58] [PASSED] sysctl_test_dointvec_write_happy_single_negative
> >  [23:03:58] [PASSED] sysctl_test_api_dointvec_write_single_less_int_min
> >  [23:03:58] [PASSED] sysctl_test_api_dointvec_write_single_greater_int_max
> >  [23:03:58] =================== [PASSED] sysctl_test ===================
> >
> >  ./run_kselftest.sh -c sysctl
> >  ...
> >  # Running test: sysctl_test_0006 - run #49
> >  # Checking bitmap handler... ok
> >  # Wed Mar 16 14:58:41 UTC 2022
> >  # Running test: sysctl_test_0007 - run #0
> >  # Boot param test only possible sysctl_test is built-in, not module:
> >  # CONFIG_TEST_SYSCTL=m
> >  ok 1 selftests: sysctl: sysctl.sh
> >
> > Cc: Luis Chamberlain <mcgrof@kernel.org>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Iurii Zaikin <yzaikin@google.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: Simon Horman <horms@verge.net.au>
> > Cc: Julian Anastasov <ja@ssi.bg>
> > Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> > Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> > Cc: Florian Westphal <fw@strlen.de>
> > Cc: Dmitry Vyukov <dvyukov@google.com>
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Cc: Akhmat Karakotov <hmukos@yandex-team.ru>
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > ---
> > v2: add KUnit and selftests in commit msg
> > ---
> >  fs/proc/proc_sysctl.c          |  2 +-
> >  include/linux/sysctl.h         | 13 +++++++------
> >  net/core/sysctl_net_core.c     | 14 +++++---------
> >  net/ipv4/sysctl_net_ipv4.c     | 16 ++++++----------
> >  net/ipv6/sysctl_net_ipv6.c     |  6 ++----
> >  net/netfilter/ipvs/ip_vs_ctl.c |  4 +---
> >  6 files changed, 22 insertions(+), 33 deletions(-)
>
> Currently we are in the merge window and net-next is accepting only
> fixes. Please repost this after net-next re-open, thanks!
Ok, thanks
> Paolo
>


-- 
Best regards, Tonghao
