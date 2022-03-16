Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDB84DB479
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356985AbiCPPLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357047AbiCPPKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:10:49 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C448466AE5
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:16 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id pv16so4946205ejb.0
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1uM3Ajnc2/MBiNc9CcMnaQVg+VU4YA+9xRWqL9SnqK4=;
        b=Vr50vsM+V7VSPJGTIt2LQ1kCywVc+UU33/U2fR9LsV0SnuFvYUm/jd/1bua+xSZRR6
         3UNwgbYIS7VrbuyUoLfrWdDHuUF5aumDHImDN9wNmsunEU9+DQxKqfVfkFvWv9HWDR+c
         tDJ9smDqjHRdGxgCbi6AQ4ABXej0d3fFkN4Qa0PHHJlp/P9/JGcvYv7BsXX+UyfggjPI
         UppSfqKKbuGdzeNOILqK1JYk7WxQIp8PXdrJBnD9TTTSY+f1IB8oEe+hWvHNdmxVMyie
         u2zjlc/hcHxCH1Zo7bjvxvrJ/sZGdNLNVwPBhb/oZmUOW6NcZovivOMc4csWdaxLwixv
         dqAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1uM3Ajnc2/MBiNc9CcMnaQVg+VU4YA+9xRWqL9SnqK4=;
        b=EVMauNO1jAWH7I+OUIaznTWnew9vSqxbAZ5afEpDN5UftYF7f44goLnBVaC4WncjzK
         X+5wI0X2cXCTkY7WpxSOvQaCZ1NT183pEuAyKfPR76rqh5RC5A3asje1f6fVYL0OlPpc
         8Sp+1V65ZNDAIlj569D1qpLaU+vicUX82F5hqUd3NusJPCE4CF1RXfkgKppkhroLfgUM
         Qw4NNLkhv2E85CR4un5e8QIpIDDkfInJGH7lDAnIBfnXBWNEjndP15Da+aAlF1MfttyU
         ekXz4yVFQD9YdS5SUrzE3L6hbjWgn66+98TAlfOxUzzHWze7mzr9PFi5t5dNyBXWD0wx
         XfLg==
X-Gm-Message-State: AOAM530GFmF2xyduYlRVH6GvkXnkS2WzTZ5+kmaqKtGkUKWdRpoDk7R5
        DnlcpFothXueYu1OP0lRstV4xPzFxOt/mQ1JhdQ=
X-Google-Smtp-Source: ABdhPJxaKNUN/lmrw0ZSjFVQp6B8yCYEG4yfJqjrafZkBW6kKzGv5AygylE7xqW1SLLhyZbh0VuwPqRax1Y81DkdFHQ=
X-Received: by 2002:a17:907:c05:b0:6db:f118:8834 with SMTP id
 ga5-20020a1709070c0500b006dbf1188834mr368890ejc.536.1647443355125; Wed, 16
 Mar 2022 08:09:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220222125628.39363-1-xiangxia.m.yue@gmail.com> <YhWOETp0UB9IpU6R@bombadil.infradead.org>
In-Reply-To: <YhWOETp0UB9IpU6R@bombadil.infradead.org>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 16 Mar 2022 23:08:38 +0800
Message-ID: <CAMDZJNVtxNGiSXvGsBqcZ_Xkq+DjH9qzr-NZTUsBmOCZTEqPxA@mail.gmail.com>
Subject: Re: [net-next] net: core: use shared sysctl macro
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
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

On Wed, Feb 23, 2022 at 9:29 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Tue, Feb 22, 2022 at 08:56:28PM +0800, xiangxia.m.yue@gmail.com wrote:
> > diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> > index 6353d6db69b2..b2ac6542455f 100644
> > --- a/include/linux/sysctl.h
> > +++ b/include/linux/sysctl.h
> > @@ -42,12 +42,13 @@ struct ctl_dir;
> >  #define SYSCTL_ZERO                  ((void *)&sysctl_vals[1])
> >  #define SYSCTL_ONE                   ((void *)&sysctl_vals[2])
> >  #define SYSCTL_TWO                   ((void *)&sysctl_vals[3])
> > -#define SYSCTL_FOUR                  ((void *)&sysctl_vals[4])
> > -#define SYSCTL_ONE_HUNDRED           ((void *)&sysctl_vals[5])
> > -#define SYSCTL_TWO_HUNDRED           ((void *)&sysctl_vals[6])
> > -#define SYSCTL_ONE_THOUSAND          ((void *)&sysctl_vals[7])
> > -#define SYSCTL_THREE_THOUSAND                ((void *)&sysctl_vals[8])
> > -#define SYSCTL_INT_MAX                       ((void *)&sysctl_vals[9])
> > +#define SYSCTL_THREE                 ((void *)&sysctl_vals[4])
> > +#define SYSCTL_FOUR                  ((void *)&sysctl_vals[5])
> > +#define SYSCTL_ONE_HUNDRED           ((void *)&sysctl_vals[6])
> > +#define SYSCTL_TWO_HUNDRED           ((void *)&sysctl_vals[7])
> > +#define SYSCTL_ONE_THOUSAND          ((void *)&sysctl_vals[8])
> > +#define SYSCTL_THREE_THOUSAND                ((void *)&sysctl_vals[9])
> > +#define SYSCTL_INT_MAX                       ((void *)&sysctl_vals[10])
>
> xiangxia, thanks for you patch!
>
> I welcome this change but can you please also extend lib/test_sysctl.c
> (selftests) and/or kernel/sysctl-test.c (UML kunit test) to ensure we
> don't regress any existing mappings here.
>
> The test can be really simply and would seem stupid but it would be of
> great help. It would just make sure SYSCTL_ONE == 1, SYSCTL_TWO == 2, etc.
>
> I think using kunit makes more sense here. Once you then then have this
> test, you can use it to verify you have not introduced a regression and
> re-send the patch.
Sorry for taking so long to reply.

KUnit:
[23:03:58] ================ sysctl_test (10 subtests) =================
[23:03:58] [PASSED] sysctl_test_api_dointvec_null_tbl_data
[23:03:58] [PASSED] sysctl_test_api_dointvec_table_maxlen_unset
[23:03:58] [PASSED] sysctl_test_api_dointvec_table_len_is_zero
[23:03:58] [PASSED] sysctl_test_api_dointvec_table_read_but_position_set
[23:03:58] [PASSED] sysctl_test_dointvec_read_happy_single_positive
[23:03:58] [PASSED] sysctl_test_dointvec_read_happy_single_negative
[23:03:58] [PASSED] sysctl_test_dointvec_write_happy_single_positive
[23:03:58] [PASSED] sysctl_test_dointvec_write_happy_single_negative
[23:03:58] [PASSED] sysctl_test_api_dointvec_write_single_less_int_min
[23:03:58] [PASSED] sysctl_test_api_dointvec_write_single_greater_int_max
[23:03:58] =================== [PASSED] sysctl_test ===================


./run_kselftest.sh -c sysctl
....
# Running test: sysctl_test_0006 - run #49
# Checking bitmap handler... ok
# Wed Mar 16 14:58:41 UTC 2022
# Running test: sysctl_test_0007 - run #0
# Boot param test only possible sysctl_test is built-in, not module:
# CONFIG_TEST_SYSCTL=m
ok 1 selftests: sysctl: sysctl.sh


> Thanks!
>
>   Luis



-- 
Best regards, Tonghao
