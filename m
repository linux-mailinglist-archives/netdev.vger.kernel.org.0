Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE3741F975
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 04:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhJBC6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 22:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhJBC6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 22:58:48 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15951C061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 19:57:03 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id v25so7668027wra.2
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 19:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XqcrpNCXUTbGmp0Uo0WcqX8Pb1J/nxDV1JHjicH4+sc=;
        b=NH5gD5BLjkXTMnz3rq9Fj+jzO0DN3woHzsPaaTTMj3sP/7/cdQSaHbdZSB8nws/AZK
         8kSiBvJZkIDycKtyxuVOm/MIsCjzxOTc7NYH4WtA8U+pWe21JiEIMPa2p62x9N/GgNPt
         FTjtC6GuXLDZ/8qG9lcQcjtohFUR/PAcQu5YoxQiD1EFceKgyFxhiOrNGGHaisxyvpCt
         pQSIxupihwlhHldADZT8JYX+lw3Xsi9KrGpdJwki0J3um7YXUh/+TIYq/KEOZ0Y23s11
         uhf0IE8JN2Pc+bWTROO8XDbCJirFDE7KEr/v1B6ohRJvFbGkZymXitYy/QGlfZhFPkxT
         YwfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XqcrpNCXUTbGmp0Uo0WcqX8Pb1J/nxDV1JHjicH4+sc=;
        b=fd6rKiPuWVF2b0EflIFrLxLZRIw5PHJRW7NO80u1IpJgaRUorSpjCrVR8B1IAeXXGB
         ClTaojyMaqrcpMFzZnhr0HebM2ISpEru/UxSnWvPV/q3cr+uhaii707HX+mCrYVsIFzv
         BCxk1NNJgMZ2oUyhErUDuIW8IfoV58caLoTHW7ewizfFYsDDHUEtQHvjdQPYKZj7EUy8
         ScL7N5p6cgFZwZuBsAEfdbk5EQSwkrxUmRNCA5Rv1amXIPkalwE/b8SmdYVyS/xIeCk1
         VSaTBfF1TTOBV6ruWuDf3pRT6VHvFEfn2TrQ1GIsAMxE1vjEXBZz35MhKQT8hHAZ0ik1
         6ZXA==
X-Gm-Message-State: AOAM532Ujypb5V69NHj2vu1WRGhnbp5MDpwsbDBsp/KAfWoMWiHlozxJ
        gy069I+FFslI5hjPE5k1Ik6COyVlQpNzUhNbyfPZ0XU2VLzvwQ==
X-Google-Smtp-Source: ABdhPJysJKaSMlMQpJWpd+U0TJKrZ5xFW888YA10OkadvWyojyZk3asVY6Mq7Jm3wMsyOImOl0H2GgDStLuFPObB0d4=
X-Received: by 2002:a5d:4882:: with SMTP id g2mr1175809wrq.399.1633143421335;
 Fri, 01 Oct 2021 19:57:01 -0700 (PDT)
MIME-Version: 1.0
References: <20211001081844.3408786-1-jk@codeconstruct.com.au> <20211001081844.3408786-2-jk@codeconstruct.com.au>
In-Reply-To: <20211001081844.3408786-2-jk@codeconstruct.com.au>
From:   David Gow <davidgow@google.com>
Date:   Sat, 2 Oct 2021 10:56:50 +0800
Message-ID: <CABVgOSm_YCOUUmr1AqzZQ2K1_P-HPS1633khKSao_Lrzs55Frw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] mctp: Add initial test structure and
 fragmentation test
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     Networking <netdev@vger.kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 1, 2021 at 4:19 PM Jeremy Kerr <jk@codeconstruct.com.au> wrote:
>
> This change adds the first kunit test for the mctp subsystem, and an
> initial test for the fragmentation path.
>
> We're adding tests under a new net/mctp/test/ directory.
>
> Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
> ---

Thanks for writing these tests. There are (as you've probably noticed)
a couple of issues with them at the moment, but it shouldn't take too
much to fix.

A few comments below.

-- David

>  net/mctp/Kconfig           |   5 +
>  net/mctp/route.c           |   5 +
>  net/mctp/test/route-test.c | 206 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 216 insertions(+)
>  create mode 100644 net/mctp/test/route-test.c
>
> diff --git a/net/mctp/Kconfig b/net/mctp/Kconfig
> index 2cdf3d0a28c9..15267a5043d9 100644
> --- a/net/mctp/Kconfig
> +++ b/net/mctp/Kconfig
> @@ -11,3 +11,8 @@ menuconfig MCTP
>           This option enables core MCTP support. For communicating with other
>           devices, you'll want to enable a driver for a specific hardware
>           channel.
> +
> +config MCTP_TEST
> +        tristate "MCTP core tests" if !KUNIT_ALL_TESTS
> +        depends on MCTP && KUNIT
> +        default KUNIT_ALL_TESTS
> diff --git a/net/mctp/route.c b/net/mctp/route.c
> index 9bea232cf250..b7e4e6281806 100644
> --- a/net/mctp/route.c
> +++ b/net/mctp/route.c
> @@ -11,6 +11,7 @@
>   */
>
>  #include <linux/idr.h>
> +#include <linux/kconfig.h>
>  #include <linux/mctp.h>
>  #include <linux/netdevice.h>
>  #include <linux/rtnetlink.h>
> @@ -1275,3 +1276,7 @@ void __exit mctp_routes_exit(void)
>         rtnl_unregister(PF_MCTP, RTM_GETROUTE);
>         dev_remove_pack(&mctp_packet_type);
>  }
> +
> +#if IS_ENABLED(CONFIG_MCTP_TEST)
> +#include "test/route-test.c"
> +#endif

FYI: This is not going to work if MCTP is built as a module.

Basically, KUnit's module support currently provides its own
module_init()/module_exit(), so really needs the test to be part of
its own separate module, rather than #included into the mctp module.

Hopefully we'll find a nicer way of handling this sort of thing in
KUnit, but in the meantime, the options are to compile the tests
separately (which would require exporting any functions being tested,
at least if CONFIG_MCTP_TEST is enabled), or to just drop module
support from the test (making MCTP_TEST bool, and having it depend on
MCTP=y).


> diff --git a/net/mctp/test/route-test.c b/net/mctp/test/route-test.c
> new file mode 100644
> index 000000000000..cf3b51183613
> --- /dev/null
> +++ b/net/mctp/test/route-test.c
> @@ -0,0 +1,206 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <kunit/test.h>
> +
> +struct mctp_test_route {
> +       struct mctp_route       rt;
> +       struct sk_buff_head     pkts;
> +};
> +
> +static int mctp_test_route_output(struct mctp_route *rt, struct sk_buff *skb)
> +{
> +       struct mctp_test_route *test_rt = container_of(rt, struct mctp_test_route, rt);
> +
> +       skb_queue_tail(&test_rt->pkts, skb);
> +
> +       return 0;
> +}
> +
> +/* local version of mctp_route_alloc() */
> +static struct mctp_test_route *mctp_route_test_alloc(void)
> +{
> +       struct mctp_test_route *rt;
> +
> +       rt = kzalloc(sizeof(*rt), GFP_KERNEL);
> +       if (!rt)
> +               return NULL;
> +
> +       INIT_LIST_HEAD(&rt->rt.list);
> +       refcount_set(&rt->rt.refs, 1);
> +       rt->rt.output = mctp_test_route_output;
> +
> +       skb_queue_head_init(&rt->pkts);
> +
> +       return rt;
> +}
> +
> +static struct mctp_test_route *mctp_test_create_route(struct net *net,
> +                                                     mctp_eid_t eid,
> +                                                     unsigned int mtu)
> +{
> +       struct mctp_test_route *rt;
> +
> +       rt = mctp_route_test_alloc();
> +       if (!rt)
> +               return NULL;
> +
> +       rt->rt.min = eid;
> +       rt->rt.max = eid;
> +       rt->rt.mtu = mtu;
> +       rt->rt.type = RTN_UNSPEC;
> +       rt->rt.dev = NULL; /* somewhat illegal, but fine for current tests */

This actually causes a crash for me:

BUG: kernel NULL pointer dereference, address: 00000004
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
<snip>
Call Trace:
mctp_route_release+0x28/0x70
mctp_do_fragment_route+0x25a/0x2a0
mctp_test_fragment+0x150/0x770
? kunit_fail_assert_format+0x70/0x70
? __schedule+0x1a7/0x480
kunit_try_run_case+0x4c/0x80
kunit_generic_run_threadfn_adapter+0x11/0x20
kthread+0xe7/0x110
? kunit_binary_str_assert_format+0x120/0x120
? set_kthread_struct+0x40/0x40
ret_from_fork+0x1c/0x28
CR2: 0000000000000004
---[ end trace fbe68c67c18e04a5 ]---

Only calling mctp_dev_put() if rt->dev is non-NULL in
mctp_route_release() fixes it, e.g.:

diff --git a/net/mctp/route.c b/net/mctp/route.c
index 04781459b2be..3692e7e8a555 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -469,7 +469,8 @@ static int mctp_route_output(struct mctp_route
*route, struct sk_buff *skb)
static void mctp_route_release(struct mctp_route *rt)
{
       if (refcount_dec_and_test(&rt->refs)) {
-               mctp_dev_put(rt->dev);
+               if (rt->dev)
+                       mctp_dev_put(rt->dev);
               kfree_rcu(rt, rcu);

       }
}


> +
> +       list_add_rcu(&rt->rt.list, &net->mctp.routes);
> +
> +       return rt;
> +}
> +
> +static void mctp_test_route_destroy(struct mctp_test_route *rt)
> +{
> +       rtnl_lock();
> +       list_del_rcu(&rt->rt.list);
> +       rtnl_unlock();
> +
> +       skb_queue_purge(&rt->pkts);
> +
> +       kfree_rcu(&rt->rt, rcu);
> +}
> +
> +static struct sk_buff *mctp_test_create_skb(struct mctp_hdr *hdr,
> +                                           unsigned int data_len)
> +{
> +       size_t hdr_len = sizeof(*hdr);
> +       struct sk_buff *skb;
> +       unsigned int i;
> +       u8 *buf;
> +
> +       skb = alloc_skb(hdr_len + data_len, GFP_KERNEL);
> +       if (!skb)
> +               return NULL;
> +
> +       memcpy(skb_put(skb, hdr_len), hdr, hdr_len);
> +
> +       buf = skb_put(skb, data_len);
> +       for (i = 0; i < data_len; i++)
> +               buf[i] = i & 0xff;
> +
> +       return skb;
> +}
> +
> +struct mctp_frag_test {
> +       unsigned int mtu;
> +       unsigned int msgsize;
> +       unsigned int n_frags;
> +};
> +
> +static void mctp_test_fragment(struct kunit *test)
> +{
> +       const struct mctp_frag_test *params;
> +       int rc, i, n, mtu, msgsize;
> +       struct mctp_test_route *rt;
> +       struct sk_buff *skb;
> +       struct mctp_hdr hdr;
> +       u8 seq;
> +
> +       params = test->param_value;
> +       mtu = params->mtu;
> +       msgsize = params->msgsize;
> +
> +       hdr.ver = 1;
> +       hdr.src = 8;
> +       hdr.dest = 10;
> +       hdr.flags_seq_tag = MCTP_HDR_FLAG_TO;
> +
> +       skb = mctp_test_create_skb(&hdr, msgsize);
> +       KUNIT_ASSERT_TRUE(test, skb);
> +
> +       rt = mctp_test_create_route(&init_net, 10, mtu);
> +       KUNIT_ASSERT_TRUE(test, rt);
> +
> +       rc = mctp_do_fragment_route(&rt->rt, skb, mtu, MCTP_TAG_OWNER);
> +       KUNIT_EXPECT_FALSE(test, rc);
> +
> +       n = rt->pkts.qlen;
> +
> +       KUNIT_EXPECT_EQ(test, n, params->n_frags);
> +
> +       for (i = 0;; i++) {
> +               struct mctp_hdr *hdr2;
> +               struct sk_buff *skb2;
> +               u8 tag_mask, seq2;
> +               bool first, last;
> +
> +               first = i == 0;
> +               last = i == (n - 1);
> +
> +               skb2 = skb_dequeue(&rt->pkts);
> +
> +               if (!skb2)
> +                       break;
> +
> +               hdr2 = mctp_hdr(skb2);
> +
> +               tag_mask = MCTP_HDR_TAG_MASK | MCTP_HDR_FLAG_TO;
> +
> +               KUNIT_EXPECT_EQ(test, hdr2->ver, hdr.ver);
> +               KUNIT_EXPECT_EQ(test, hdr2->src, hdr.src);
> +               KUNIT_EXPECT_EQ(test, hdr2->dest, hdr.dest);
> +               KUNIT_EXPECT_EQ(test, hdr2->flags_seq_tag & tag_mask,
> +                               hdr.flags_seq_tag & tag_mask);
> +
> +               KUNIT_EXPECT_EQ(test,
> +                               !!(hdr2->flags_seq_tag & MCTP_HDR_FLAG_SOM), first);
> +               KUNIT_EXPECT_EQ(test,
> +                               !!(hdr2->flags_seq_tag & MCTP_HDR_FLAG_EOM), last);
> +
> +               seq2 = (hdr2->flags_seq_tag >> MCTP_HDR_SEQ_SHIFT) &
> +                       MCTP_HDR_SEQ_MASK;
> +
> +               if (first) {
> +                       seq = seq2;
> +               } else {
> +                       seq++;
> +                       KUNIT_EXPECT_EQ(test, seq2, seq & MCTP_HDR_SEQ_MASK);
> +               }
> +
> +               if (!last)
> +                       KUNIT_EXPECT_EQ(test, skb2->len, mtu);
> +               else
> +                       KUNIT_EXPECT_LE(test, skb2->len, mtu);
> +
> +               kfree_skb(skb2);
> +       }
> +
> +       mctp_test_route_destroy(rt);
> +}
> +
> +static const struct mctp_frag_test mctp_frag_tests[] = {
> +       {.mtu = 68, .msgsize = 63, .n_frags = 1},
> +       {.mtu = 68, .msgsize = 64, .n_frags = 1},
> +       {.mtu = 68, .msgsize = 65, .n_frags = 2},
> +       {.mtu = 68, .msgsize = 66, .n_frags = 2},
> +       {.mtu = 68, .msgsize = 127, .n_frags = 2},
> +       {.mtu = 68, .msgsize = 128, .n_frags = 2},
> +       {.mtu = 68, .msgsize = 129, .n_frags = 3},
> +       {.mtu = 68, .msgsize = 130, .n_frags = 3},
> +};
> +
> +static void mctp_frag_test_to_desc(const struct mctp_frag_test *t, char *desc)
> +{
> +       sprintf(desc, "mtu %d len %d -> %d frags",
> +               t->msgsize, t->mtu, t->n_frags);
> +}
> +
> +KUNIT_ARRAY_PARAM(mctp_frag, mctp_frag_tests, mctp_frag_test_to_desc);
> +
> +static struct kunit_case mctp_test_cases[] = {
> +       KUNIT_CASE_PARAM(mctp_test_fragment, mctp_frag_gen_params),
> +       {}
> +};
> +
> +static struct kunit_suite mctp_test_suite = {
> +       .name = "mctp",
> +       .test_cases = mctp_test_cases,
> +};
> +
> +kunit_test_suite(mctp_test_suite);
> --
> 2.33.0
>
