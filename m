Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2AF293201
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 01:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389090AbgJSXa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 19:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbgJSXa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 19:30:59 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45592C0613D0
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 16:30:59 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q25so157459ioh.4
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 16:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OdguJ3Y0jLnjNpZn7Y6IWQDcD4wulbO8AfbQhQ5OC9M=;
        b=HQoygyqJxZHQN7S5L31exsyKh5gieoSqjPwB5Tf599h5Ev+1kdd+xCPEfkpVRMCTBJ
         iuzRe9nCiJc1UM1IEut7EBXqNRlI5SoYsSPmM2tICJ85g5xi4ersZEa8IrwNR7H91ara
         FXMJcI+pU7hS+dMZTsxSIS+s6KZ+AX3mXqk2b6ta+QW6ZIQvezL9MA6oceqqd07bhmLl
         dLuLep8MjmUzCnk13tSrtlByPrHG3iQsgT3usf3K8Dfmh3TamSA5mcLAQSH+eZdTjgGn
         sAoAQfiQtblen0UEbcKo93VgZHrwDjgKbhTjZVMvreMUZX0chQqJCOqVpGtXoDU5t0dD
         VhyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OdguJ3Y0jLnjNpZn7Y6IWQDcD4wulbO8AfbQhQ5OC9M=;
        b=KPHt4DZCP0UT/9vfxZ21tq+7516WqC/CI/jJFtumq0KUxI1arzJTYqq+J2hil9S9mX
         eO4gpEXb5r+t8cF/qFTMQdu3d1BrYleP33Ean+srEFIlV684dPgWMsA/F3IvgtIUO/f7
         N1RwwMknePSmOkIARs3i2OgT6tvSMJVpkU60Aj49U8u2lKn5LC9+lz3iF7H7A0ry4XHI
         NDLnWoLSktvVkeCPBPMeVUivjf0AbYZAN4MrzDz/xzo9NBGJDeGqSSI3IdOMK0Yd7QHl
         jJtEmMVUCbpSbp7nl2Ga5g+liglvFe6x+flwk17jAAHXW7goOrasx9rbTZZXJWc2186R
         kJUw==
X-Gm-Message-State: AOAM532Js5fypwmO4B0Nwup1tZkBO8TeVZhwEQapFEVVOXGNWb2dtxqL
        Mw8YNygXdTqgnzXGJIUupW5u3dTdspPy5JT7aDJvyQ==
X-Google-Smtp-Source: ABdhPJz9jwqn1hhicTP3NVTFEEsviBrQC81QN1eNJBNaFAHNAdCsd6jRjwyfTppDcISIbsnkGHE9QpLD0A+RgrRid+k=
X-Received: by 2002:a5e:8347:: with SMTP id y7mr119568iom.1.1603150258305;
 Mon, 19 Oct 2020 16:30:58 -0700 (PDT)
MIME-Version: 1.0
References: <20201019202431.3472335-1-dlatypov@google.com> <CAHmME9qYWRRBeNTP=f5sxmpYeXaxgT82TtvJWS5nt2+F5TiOtw@mail.gmail.com>
In-Reply-To: <CAHmME9qYWRRBeNTP=f5sxmpYeXaxgT82TtvJWS5nt2+F5TiOtw@mail.gmail.com>
From:   Daniel Latypov <dlatypov@google.com>
Date:   Mon, 19 Oct 2020 16:30:46 -0700
Message-ID: <CAGS_qxrCRNXhoMcmCbzW6QaO-=FRTw0=NqJZRN7gnfgKtFDihw@mail.gmail.com>
Subject: Re: [PATCH] wireguard: convert selftest/{counter,ratelimiter}.c to KUnit
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Brendan Higgins <brendanhiggins@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 3:36 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Daniel,
>
> Thanks for this patch. KUnit looks interesting. But I'm not totally
> sure what this would gain here, except more complicated infrastructure
> to handle. We're already running these tests in our CI on every single
> commit made to a variety of trees on a variety of architectures -- see
> https://www.wireguard.com/build-status/ -- runnable via `make -C
> tools/testing/selftests/wireguard/qemu -j$(nproc)`. It looks like this
> commit breaks that while making everything slightly more complex. Is

Thanks for the informative response and the pointer to the
build-status/ page, I was unaware of its existence.
Digging into that a bit deeper, I'd agree with you that this patch
isn't worth it.

Yes, this would stop these two tests from running under selftests, and
thus in your CI.
A not-too-long glance at the code made it seem like the specific
code-under-test here was reasonably arch-independent, but yes, this
would make it more annoying to test different arches.

> there a good reason to switch over to this other than fad? From a
> development perspective, I don't see this as really helping with much.

In my mind, the breakdown is

Pros:
* more minimal environment
  * config file is 6 lines, instead of 87
  * doesn't rely on a userspace or a custom init, etc.
* slightly faster build times on my machine (with -j8)
* the option to provide a bit more structure via its MACROS
  * but that's optional, can fall back to `if (success) KUNIT_FAIL("my
message")`

Cons:
* separate set of tooling needed to run tests
* needs to be then integrated into WireGuard's CI
* not as mature, so it lacks integration via KernelCI, etc.
  * Brendan (CC'd) is working on this KernelCI integration in particular.
* qemu/init.c has more features that KUnit currently lacks, like kmemleak checks
* and others I'm not able to think of.

WG's tooling is really nice, so these cons are much more apparent.

I think a feature that might make this worth looking at again later on
is if selftest modules could be written using KUnit.
Commit c475c77d5b56 ("kunit: allow kunit tests to be loaded as a
module") was necessary but not sufficient here.

If that becomes possible, KUnit would mainly provide the boilerplate
for tracking pass-fail, generating error messages, and the *option* of
running the tests via either KUnit or Kselftest.
Until that time, I'd agree that WG is better off as-is.

Cheers,
Daniel

>
> Jason
>
> On Mon, Oct 19, 2020 at 10:24 PM Daniel Latypov <dlatypov@google.com> wrote:
> >
> > These tests already focus on testing individual functions that can run
> > in a more minimal environment like KUnit.
> >
> > The primary motivation for this change it to make it faster and easier
> > to run these tests, and thus encourage the addition of more test cases.
> >
> > E.g.
> > Test timing after make mrproper: 47.418s building, 0.000s running
> > With an incremental build: 3.891s building, 0.000s running
> >
> > KUnit also provides a bit more structure, like tracking overall
> > pass/fail status and printing failure messages like
> > >  # wg_packet_counter_test: EXPECTATION FAILED at drivers/net/wireguard/counter_test.c:32
> > >  Expected counter_validate(counter, (COUNTER_WINDOW_SIZE + 1)) == false, but
> >
> > Note: so we no longer need to track test_num in counter_test.c.
> > But deleting the /*1*/ test_num comments means git (with the default
> > threshold) no longer recognizes that the file was moved.
> >
> > Signed-off-by: Daniel Latypov <dlatypov@google.com>
> > Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> > Cc: David Miller <davem@davemloft.net>
> > Cc: Brendan Higgins <brendanhiggins@google.com>
> > ---
> >  drivers/net/Kconfig                           | 12 ++++
> >  .../{selftest/counter.c => counter_test.c}    | 45 ++++++------
> >  drivers/net/wireguard/main.c                  |  3 +-
> >  drivers/net/wireguard/queueing.h              |  4 --
> >  drivers/net/wireguard/ratelimiter.c           |  4 +-
> >  .../ratelimiter.c => ratelimiter_test.c}      | 68 +++++++++++--------
> >  drivers/net/wireguard/receive.c               |  6 +-
> >  7 files changed, 80 insertions(+), 62 deletions(-)
> >  rename drivers/net/wireguard/{selftest/counter.c => counter_test.c} (73%)
> >  rename drivers/net/wireguard/{selftest/ratelimiter.c => ratelimiter_test.c} (85%)
> >
> > diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> > index c3dbe64e628e..208ed162bcc0 100644
> > --- a/drivers/net/Kconfig
> > +++ b/drivers/net/Kconfig
> > @@ -114,6 +114,18 @@ config WIREGUARD_DEBUG
> >
> >           Say N here unless you know what you're doing.
> >
> > +config WIREGUARD_KUNIT_TEST
> > +       tristate "KUnit tests for WireGuard"
> > +       default KUNIT_ALL_TESTS
> > +       depends on KUNIT && WIREGUARD
> > +       help
> > +         This enables KUnit tests for Wireguard.
> > +
> > +         For more information on KUnit and unit tests in general please refer
> > +         to the KUnit documentation in Documentation/dev-tools/kunit/.
> > +
> > +         Say N here unless you know what you're doing.
> > +
> >  config EQUALIZER
> >         tristate "EQL (serial line load balancing) support"
> >         help
> > diff --git a/drivers/net/wireguard/selftest/counter.c b/drivers/net/wireguard/counter_test.c
> > similarity index 73%
> > rename from drivers/net/wireguard/selftest/counter.c
> > rename to drivers/net/wireguard/counter_test.c
> > index ec3c156bf91b..167153fc249f 100644
> > --- a/drivers/net/wireguard/selftest/counter.c
> > +++ b/drivers/net/wireguard/counter_test.c
> > @@ -3,32 +3,23 @@
> >   * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> >   */
> >
> > -#ifdef DEBUG
> > -bool __init wg_packet_counter_selftest(void)
> > +#include <kunit/test.h>
> > +
> > +static void wg_packet_counter_test(struct kunit *test)
> >  {
> >         struct noise_replay_counter *counter;
> > -       unsigned int test_num = 0, i;
> > -       bool success = true;
> > +       unsigned int i;
> >
> > -       counter = kmalloc(sizeof(*counter), GFP_KERNEL);
> > -       if (unlikely(!counter)) {
> > -               pr_err("nonce counter self-test malloc: FAIL\n");
> > -               return false;
> > -       }
> > +       counter = kunit_kmalloc(test, sizeof(*counter), GFP_KERNEL);
> > +       KUNIT_ASSERT_NOT_ERR_OR_NULL(test, counter);
> >
> >  #define T_INIT do {                                    \
> >                 memset(counter, 0, sizeof(*counter));  \
> >                 spin_lock_init(&counter->lock);        \
> >         } while (0)
> >  #define T_LIM (COUNTER_WINDOW_SIZE + 1)
> > -#define T(n, v) do {                                                  \
> > -               ++test_num;                                           \
> > -               if (counter_validate(counter, n) != (v)) {            \
> > -                       pr_err("nonce counter self-test %u: FAIL\n",  \
> > -                              test_num);                             \
> > -                       success = false;                              \
> > -               }                                                     \
> > -       } while (0)
> > +#define T(n, v) \
> > +               KUNIT_EXPECT_EQ(test, counter_validate(counter, n), v)
> >
> >         T_INIT;
> >         /*  1 */ T(0, true);
> > @@ -102,10 +93,18 @@ bool __init wg_packet_counter_selftest(void)
> >  #undef T
> >  #undef T_LIM
> >  #undef T_INIT
> > -
> > -       if (success)
> > -               pr_info("nonce counter self-tests: pass\n");
> > -       kfree(counter);
> > -       return success;
> >  }
> > -#endif
> > +
> > +static struct kunit_case wg_packet_counter_test_cases[] = {
> > +       KUNIT_CASE(wg_packet_counter_test),
> > +       {}
> > +};
> > +
> > +static struct kunit_suite wg_packet_counter_test_suite = {
> > +       .name = "wg_packet_counter",
> > +       .test_cases = wg_packet_counter_test_cases,
> > +};
> > +
> > +kunit_test_suites(&wg_packet_counter_test_suite);
> > +
> > +MODULE_LICENSE("GPL v2");
> > diff --git a/drivers/net/wireguard/main.c b/drivers/net/wireguard/main.c
> > index 7a7d5f1a80fc..bfd3312d5133 100644
> > --- a/drivers/net/wireguard/main.c
> > +++ b/drivers/net/wireguard/main.c
> > @@ -22,8 +22,7 @@ static int __init mod_init(void)
> >         int ret;
> >
> >  #ifdef DEBUG
> > -       if (!wg_allowedips_selftest() || !wg_packet_counter_selftest() ||
> > -           !wg_ratelimiter_selftest())
> > +       if (!wg_allowedips_selftest())
> >                 return -ENOTRECOVERABLE;
> >  #endif
> >         wg_noise_init();
> > diff --git a/drivers/net/wireguard/queueing.h b/drivers/net/wireguard/queueing.h
> > index dfb674e03076..5d428ddf176f 100644
> > --- a/drivers/net/wireguard/queueing.h
> > +++ b/drivers/net/wireguard/queueing.h
> > @@ -186,8 +186,4 @@ static inline void wg_queue_enqueue_per_peer_napi(struct sk_buff *skb,
> >         wg_peer_put(peer);
> >  }
> >
> > -#ifdef DEBUG
> > -bool wg_packet_counter_selftest(void);
> > -#endif
> > -
> >  #endif /* _WG_QUEUEING_H */
> > diff --git a/drivers/net/wireguard/ratelimiter.c b/drivers/net/wireguard/ratelimiter.c
> > index 3fedd1d21f5e..f7a7c48aee40 100644
> > --- a/drivers/net/wireguard/ratelimiter.c
> > +++ b/drivers/net/wireguard/ratelimiter.c
> > @@ -220,4 +220,6 @@ void wg_ratelimiter_uninit(void)
> >         mutex_unlock(&init_lock);
> >  }
> >
> > -#include "selftest/ratelimiter.c"
> > +#if IS_ENABLED(CONFIG_WIREGUARD_KUNIT_TEST)
> > +#include "ratelimiter_test.c"
> > +#endif
> > diff --git a/drivers/net/wireguard/selftest/ratelimiter.c b/drivers/net/wireguard/ratelimiter_test.c
> > similarity index 85%
> > rename from drivers/net/wireguard/selftest/ratelimiter.c
> > rename to drivers/net/wireguard/ratelimiter_test.c
> > index 007cd4457c5f..a49f508cccb2 100644
> > --- a/drivers/net/wireguard/selftest/ratelimiter.c
> > +++ b/drivers/net/wireguard/ratelimiter_test.c
> > @@ -3,8 +3,7 @@
> >   * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> >   */
> >
> > -#ifdef DEBUG
> > -
> > +#include <kunit/test.h>
> >  #include <linux/jiffies.h>
> >
> >  static const struct {
> > @@ -32,7 +31,7 @@ static __init unsigned int maximum_jiffies_at_index(int index)
> >
> >  static __init int timings_test(struct sk_buff *skb4, struct iphdr *hdr4,
> >                                struct sk_buff *skb6, struct ipv6hdr *hdr6,
> > -                              int *test)
> > +                              int *test_num)
> >  {
> >         unsigned long loop_start_time;
> >         int i;
> > @@ -51,7 +50,7 @@ static __init int timings_test(struct sk_buff *skb4, struct iphdr *hdr4,
> >                 if (wg_ratelimiter_allow(skb4, &init_net) !=
> >                                         expected_results[i].result)
> >                         return -EXFULL;
> > -               ++(*test);
> > +               ++(*test_num);
> >
> >                 hdr4->saddr = htonl(ntohl(hdr4->saddr) + i + 1);
> >                 if (time_is_before_jiffies(loop_start_time +
> > @@ -59,7 +58,7 @@ static __init int timings_test(struct sk_buff *skb4, struct iphdr *hdr4,
> >                         return -ETIMEDOUT;
> >                 if (!wg_ratelimiter_allow(skb4, &init_net))
> >                         return -EXFULL;
> > -               ++(*test);
> > +               ++(*test_num);
> >
> >                 hdr4->saddr = htonl(ntohl(hdr4->saddr) - i - 1);
> >
> > @@ -72,7 +71,7 @@ static __init int timings_test(struct sk_buff *skb4, struct iphdr *hdr4,
> >                 if (wg_ratelimiter_allow(skb6, &init_net) !=
> >                                         expected_results[i].result)
> >                         return -EXFULL;
> > -               ++(*test);
> > +               ++(*test_num);
> >
> >                 hdr6->saddr.in6_u.u6_addr32[0] =
> >                         htonl(ntohl(hdr6->saddr.in6_u.u6_addr32[0]) + i + 1);
> > @@ -81,7 +80,7 @@ static __init int timings_test(struct sk_buff *skb4, struct iphdr *hdr4,
> >                         return -ETIMEDOUT;
> >                 if (!wg_ratelimiter_allow(skb6, &init_net))
> >                         return -EXFULL;
> > -               ++(*test);
> > +               ++(*test_num);
> >
> >                 hdr6->saddr.in6_u.u6_addr32[0] =
> >                         htonl(ntohl(hdr6->saddr.in6_u.u6_addr32[0]) - i - 1);
> > @@ -95,7 +94,7 @@ static __init int timings_test(struct sk_buff *skb4, struct iphdr *hdr4,
> >  }
> >
> >  static __init int capacity_test(struct sk_buff *skb4, struct iphdr *hdr4,
> > -                               int *test)
> > +                               int *test_num)
> >  {
> >         int i;
> >
> > @@ -104,45 +103,45 @@ static __init int capacity_test(struct sk_buff *skb4, struct iphdr *hdr4,
> >
> >         if (atomic_read(&total_entries))
> >                 return -EXFULL;
> > -       ++(*test);
> > +       ++(*test_num);
> >
> >         for (i = 0; i <= max_entries; ++i) {
> >                 hdr4->saddr = htonl(i);
> >                 if (wg_ratelimiter_allow(skb4, &init_net) != (i != max_entries))
> >                         return -EXFULL;
> > -               ++(*test);
> > +               ++(*test_num);
> >         }
> >         return 0;
> >  }
> >
> > -bool __init wg_ratelimiter_selftest(void)
> > +static void wg_ratelimiter_test(struct kunit *test)
> >  {
> >         enum { TRIALS_BEFORE_GIVING_UP = 5000 };
> >         bool success = false;
> > -       int test = 0, trials;
> > +       int test_num = 0, trials;
> >         struct sk_buff *skb4, *skb6 = NULL;
> >         struct iphdr *hdr4;
> >         struct ipv6hdr *hdr6 = NULL;
> >
> >         if (IS_ENABLED(CONFIG_KASAN) || IS_ENABLED(CONFIG_UBSAN))
> > -               return true;
> > +               return;
> >
> >         BUILD_BUG_ON(MSEC_PER_SEC % PACKETS_PER_SECOND != 0);
> >
> >         if (wg_ratelimiter_init())
> >                 goto out;
> > -       ++test;
> > +       ++test_num;
> >         if (wg_ratelimiter_init()) {
> >                 wg_ratelimiter_uninit();
> >                 goto out;
> >         }
> > -       ++test;
> > +       ++test_num;
> >         if (wg_ratelimiter_init()) {
> >                 wg_ratelimiter_uninit();
> >                 wg_ratelimiter_uninit();
> >                 goto out;
> >         }
> > -       ++test;
> > +       ++test_num;
> >
> >         skb4 = alloc_skb(sizeof(struct iphdr), GFP_KERNEL);
> >         if (unlikely(!skb4))
> > @@ -151,7 +150,7 @@ bool __init wg_ratelimiter_selftest(void)
> >         hdr4 = (struct iphdr *)skb_put(skb4, sizeof(*hdr4));
> >         hdr4->saddr = htonl(8182);
> >         skb_reset_network_header(skb4);
> > -       ++test;
> > +       ++test_num;
> >
> >  #if IS_ENABLED(CONFIG_IPV6)
> >         skb6 = alloc_skb(sizeof(struct ipv6hdr), GFP_KERNEL);
> > @@ -164,7 +163,7 @@ bool __init wg_ratelimiter_selftest(void)
> >         hdr6->saddr.in6_u.u6_addr32[0] = htonl(1212);
> >         hdr6->saddr.in6_u.u6_addr32[1] = htonl(289188);
> >         skb_reset_network_header(skb6);
> > -       ++test;
> > +       ++test_num;
> >  #endif
> >
> >         for (trials = TRIALS_BEFORE_GIVING_UP;;) {
> > @@ -173,16 +172,16 @@ bool __init wg_ratelimiter_selftest(void)
> >                 ret = timings_test(skb4, hdr4, skb6, hdr6, &test_count);
> >                 if (ret == -ETIMEDOUT) {
> >                         if (!trials--) {
> > -                               test += test_count;
> > +                               test_num += test_count;
> >                                 goto err;
> >                         }
> >                         msleep(500);
> >                         continue;
> >                 } else if (ret < 0) {
> > -                       test += test_count;
> > +                       test_num += test_count;
> >                         goto err;
> >                 } else {
> > -                       test += test_count;
> > +                       test_num += test_count;
> >                         break;
> >                 }
> >         }
> > @@ -192,13 +191,13 @@ bool __init wg_ratelimiter_selftest(void)
> >
> >                 if (capacity_test(skb4, hdr4, &test_count) < 0) {
> >                         if (!trials--) {
> > -                               test += test_count;
> > +                               test_num += test_count;
> >                                 goto err;
> >                         }
> >                         msleep(50);
> >                         continue;
> >                 }
> > -               test += test_count;
> > +               test_num += test_count;
> >                 break;
> >         }
> >
> > @@ -216,11 +215,20 @@ bool __init wg_ratelimiter_selftest(void)
> >         /* Uninit one extra time to check underflow detection. */
> >         wg_ratelimiter_uninit();
> >  out:
> > -       if (success)
> > -               pr_info("ratelimiter self-tests: pass\n");
> > -       else
> > -               pr_err("ratelimiter self-test %d: FAIL\n", test);
> > -
> > -       return success;
> > +       if (!success)
> > +               KUNIT_FAIL(test, "test #%d failed", test_num);
> >  }
> > -#endif
> > +
> > +static struct kunit_case wg_ratelimiter_test_cases[] = {
> > +       KUNIT_CASE(wg_ratelimiter_test),
> > +       {}
> > +};
> > +
> > +static struct kunit_suite wg_ratelimiter_test_suite = {
> > +       .name = "wg_ratelimiter",
> > +       .test_cases = wg_ratelimiter_test_cases,
> > +};
> > +
> > +kunit_test_suites(&wg_ratelimiter_test_suite);
> > +
> > +MODULE_LICENSE("GPL v2");
> > diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
> > index 2c9551ea6dc7..30d3d9685e8d 100644
> > --- a/drivers/net/wireguard/receive.c
> > +++ b/drivers/net/wireguard/receive.c
> > @@ -336,8 +336,6 @@ static bool counter_validate(struct noise_replay_counter *counter, u64 their_cou
> >         return ret;
> >  }
> >
> > -#include "selftest/counter.c"
> > -
> >  static void wg_packet_consume_data_done(struct wg_peer *peer,
> >                                         struct sk_buff *skb,
> >                                         struct endpoint *endpoint)
> > @@ -588,3 +586,7 @@ void wg_packet_receive(struct wg_device *wg, struct sk_buff *skb)
> >  err:
> >         dev_kfree_skb(skb);
> >  }
> > +
> > +#if IS_ENABLED(CONFIG_WIREGUARD_KUNIT_TEST)
> > +#include "counter_test.c"
> > +#endif
> >
> > base-commit: 7cf726a59435301046250c42131554d9ccc566b8
> > --
> > 2.29.0.rc1.297.gfa9743e501-goog
