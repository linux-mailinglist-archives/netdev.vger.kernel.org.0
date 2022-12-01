Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDEA263E95D
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 06:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiLAFe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 00:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiLAFeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 00:34:25 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A667BA1A13;
        Wed, 30 Nov 2022 21:34:24 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-3cbdd6c00adso6437547b3.11;
        Wed, 30 Nov 2022 21:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yPdtGa6X3njfkFNkuvIG1qenpvjnTKe9wgiSnfM3voc=;
        b=hOfUUbQ3/4SbT8e6Qpm4Vn3+0WdIaFTWwmGp/sRNi7SNJlOd7/a0PFieTj+vkdHwPl
         Rhuplcg0LaUhKeaEAFqJOUHI+15Rp/2I0n/7tBkMYAVezo6+KA3sPbkgCcX8UKjTZ/9F
         LHqJhNL0VevOxYaHHU51TUC+B+GlSOq/eoN2glIxSV88rZdHVC6ml0yBqG7HPX2mh0ws
         FqLClLKK89dexo1DhpvHSsdkN62SdlFPAypw+QP0kpj7KkpK58NSw/0Tgg6AJc8otOjZ
         z4n4AakDtlNnD2z5BELzKtBb6G0AEZNpw+Z/gxdyWpMj5lZtwEH6zSSlsV9FCZtBN7aZ
         kMpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yPdtGa6X3njfkFNkuvIG1qenpvjnTKe9wgiSnfM3voc=;
        b=wYsmX6ozHz/7XF47rspU6q/FM1o7yMUPrxMHsY6Qok3no3f+PZ3KE6XxuBxVkTvEG8
         ZC52B/yqb9rcUP0Rry/uveAU1MtPwKpUtlrJhrK1515Lf71/J8QUTMFFLOjBIjt6qv/e
         D1Z7CXReWW39o1E8L+UA+1nhqZQzx3hgZAmEbjozPBYwEm9EmxMOvcD4o8s76PiKs++l
         udWn0sHB+AiBN7cyH5ap5nzqROAHLEp/QJHuncKLGNkmoCrF3E4Mtht/aNBpgIN83pBf
         6KeDgC/6kPbu7HLRBscg5UA4yHzBdbczTIxN+LM0Yv72qF+brWv/V3WxGcEnw1Dqdn0t
         ylSQ==
X-Gm-Message-State: ANoB5pmXkX73BqvR+ZQ77AgvsA15MOl5VH1YK+N/4Kjvob5ODTpLRz1C
        xuSfDBhrdwhuGaY2FitctCfpVu9EjR05wmZyCbs=
X-Google-Smtp-Source: AA0mqf4XJ1TiPBWbEqXGtFgbBFsJ+YTwfqfKpqMvFH1bXLTWBwga8Je0fYTYTSjsVlwcMEP8IcP41jk6IMyv/5H1fXI=
X-Received: by 2002:a05:690c:312:b0:377:54e8:337d with SMTP id
 bg18-20020a05690c031200b0037754e8337dmr43352602ywb.117.1669872863399; Wed, 30
 Nov 2022 21:34:23 -0800 (PST)
MIME-Version: 1.0
References: <20221129132018.985887-1-eyal.birger@gmail.com>
 <20221129132018.985887-4-eyal.birger@gmail.com> <ba1a8717-7d9a-9a78-d80a-ad95bb902085@linux.dev>
In-Reply-To: <ba1a8717-7d9a-9a78-d80a-ad95bb902085@linux.dev>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Thu, 1 Dec 2022 07:34:12 +0200
Message-ID: <CAHsH6Gvb94O6ir-emzop1FoDsbHh7QNVFrtDuohzvXpVe0S4Vg@mail.gmail.com>
Subject: Re: [PATCH ipsec-next,v2 3/3] selftests/bpf: add xfrm_info tests
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        andrii@kernel.org, daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, shuah@kernel.org
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

Hi Martin,

On Wed, Nov 30, 2022 at 8:41 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 11/29/22 5:20 AM, Eyal Birger wrote:
> > Test the xfrm_info kfunc helpers.
> >
> > Note: the tests require support for xfrmi "external" mode in iproute2.
> >
> > The test setup creates three name spaces - NS0, NS1, NS2.
> >
> > XFRM tunnels are setup between NS0 and the two other NSs.
> >
> > The kfunc helpers are used to steer traffic from NS0 to the other
> > NSs based on a userspace populated map and validate that the
> > return traffic had arrived from the desired NS.
> >
> > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> >
> > ---
> >
> > v2:
> >    - use an lwt route in NS1 for testing that flow as well
> >    - indendation fix
> > ---
> >   tools/testing/selftests/bpf/config            |   2 +
> >   .../selftests/bpf/prog_tests/test_xfrm_info.c | 343 ++++++++++++++++++
> >   .../selftests/bpf/progs/test_xfrm_info_kern.c |  74 ++++
> >   3 files changed, 419 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/test_xfrm_info.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/test_xfrm_info_kern.c
> >
> > diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
> > index 9213565c0311..9f39943d6ebd 100644
> > --- a/tools/testing/selftests/bpf/config
> > +++ b/tools/testing/selftests/bpf/config
> > @@ -20,6 +20,7 @@ CONFIG_IKCONFIG_PROC=y
> >   CONFIG_IMA=y
> >   CONFIG_IMA_READ_POLICY=y
> >   CONFIG_IMA_WRITE_POLICY=y
> > +CONFIG_INET_ESP=y
> >   CONFIG_IP_NF_FILTER=y
> >   CONFIG_IP_NF_RAW=y
> >   CONFIG_IP_NF_TARGET_SYNPROXY=y
> > @@ -71,3 +72,4 @@ CONFIG_TEST_BPF=y
> >   CONFIG_USERFAULTFD=y
> >   CONFIG_VXLAN=y
> >   CONFIG_XDP_SOCKETS=y
> > +CONFIG_XFRM_INTERFACE=y
> > diff --git a/tools/testing/selftests/bpf/prog_tests/test_xfrm_info.c b/tools/testing/selftests/bpf/prog_tests/test_xfrm_info.c
> > new file mode 100644
> > index 000000000000..3aef72540934
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/test_xfrm_info.c
>
> Nit. Just xfrm_info.c

Ok.

>
> > @@ -0,0 +1,343 @@
> > +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> > +
> > +/*
> > + * Topology:
> > + * ---------
> > + *   NS0 namespace         |   NS1 namespace        | NS2 namespace
> > + *                         |                        |
> > + *   +---------------+     |   +---------------+    |
> > + *   |    ipsec0     |---------|    ipsec0     |    |
> > + *   | 192.168.1.100 |     |   | 192.168.1.200 |    |
> > + *   | if_id: bpf    |     |   +---------------+    |
> > + *   +---------------+     |                        |
> > + *           |             |                        |   +---------------+
> > + *           |             |                        |   |    ipsec0     |
> > + *           \------------------------------------------| 192.168.1.200 |
> > + *                         |                        |   +---------------+
> > + *                         |                        |
> > + *                         |                        | (overlay network)
> > + *      ------------------------------------------------------
> > + *                         |                        | (underlay network)
> > + *   +--------------+      |   +--------------+     |
> > + *   |    veth01    |----------|    veth10    |     |
> > + *   | 172.16.1.100 |      |   | 172.16.1.200 |     |
> > + *   ---------------+      |   +--------------+     |
> > + *                         |                        |
> > + *   +--------------+      |                        |   +--------------+
> > + *   |    veth02    |-----------------------------------|    veth20    |
> > + *   | 172.16.2.100 |      |                        |   | 172.16.2.200 |
> > + *   +--------------+      |                        |   +--------------+
> > + *
> > + *
[...]
> > +
> > +#define RUN_TEST(name)                                                       \
> > +     ({                                                              \
> > +             if (test__start_subtest(#name)) {                       \
> > +                     test_ ## name();                                \
> > +             }                                                       \
> > +     })
> > +
> > +static void *test_xfrm_info_run_tests(void *arg)
> > +{
> > +     cleanup();
> > +
> > +     config_underlay();
> > +     config_overlay();
>
> config_*() is returning ok/err but no error checking here.  Does it make sense
> to continue if the config_*() failed?

I'll assert their success.

>
> > +
> > +     RUN_TEST(xfrm_info);
>
> nit.  Remove this macro indirection.  There is only one test.

Ok. I was considering other possible tests in the future, but this can
be added then.

>
> > +
> > +     cleanup();
> > +
> > +     return NULL;
> > +}
> > +
> > +static int probe_iproute2(void)
> > +{
> > +     if (SYS_NOFAIL("ip link add type xfrm help 2>&1 | "
> > +                    "grep external > /dev/null")) {
> > +             fprintf(stdout, "%s:SKIP: iproute2 with xfrm external support needed for this test\n", __func__);
>
> Unfortunately, the BPF CI iproute2 does not have this support also :(
> I am worry it will just stay SKIP for some time and rot.  Can you try to
> directly use netlink here?

Yeah, I wasn't sure if adding a libmnl (or alternative) dependency
was ok here, and also didn't want to copy all that nl logic here.
So I figured it would get there eventually.

I noticed libmnl is used by the nf tests, so maybe its inclusion isn't too
bad. Unless there's a better approach.

As you noted, I should add this for the "external" support. However, I don't
think adding the LWT route directly using nl is a good idea here so I'll
make the NS1 use a regular xfrmi.
>
> https://github.com/kernel-patches/bpf/actions/runs/3578467213/jobs/6019370754#step:6:6395
>
> > +             return -1;
> > +     }
> > +     return 0;
> > +}
> > +
> > +void serial_test_xfrm_info(void)
>
> Remove "serial_".  New test must be able to run in parallel ("./test_progs -j").

Ok.

>
> > +{
> > +     pthread_t test_thread;
> > +     int err;
> > +
> > +     if (probe_iproute2()) {
> > +             test__skip();
> > +             return;
> > +     }
> > +
> > +     /* Run the tests in their own thread to isolate the namespace changes
> > +      * so they do not affect the environment of other tests.
> > +      * (specifically needed because of unshare(CLONE_NEWNS) in open_netns())
> > +      */
>
> I think this comment is mostly inherited from other tests (eg. tc_redirect.c)
> but the pthread dance is actually unnecessary.  The test_progs.c will restore
> the original netns before running the next test.  I am abort to remove this from
> the tc_redirect.c also.  Please also avoid this pthread create here.

Ok. Indeed was inherited.

>
> > +     err = pthread_create(&test_thread, NULL, &test_xfrm_info_run_tests, NULL);
> > +     if (ASSERT_OK(err, "pthread_create"))
> > +             ASSERT_OK(pthread_join(test_thread, NULL), "pthread_join");
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/test_xfrm_info_kern.c b/tools/testing/selftests/bpf/progs/test_xfrm_info_kern.c
> > new file mode 100644
> > index 000000000000..98991a83c1e9
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_xfrm_info_kern.c
>
>
> Nit. Same here. Just xfrm_info.c.

Ok.

>
> > @@ -0,0 +1,74 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/bpf.h>
> > +#include <linux/pkt_cls.h>
> > +#include <bpf/bpf_helpers.h>
> > +
> > +#define log_err(__ret) bpf_printk("ERROR line:%d ret:%d\n", __LINE__, __ret)
>
> Please try not to use unnecessary bpf_printk().  BPF CI is not capturing it also.

Ok.

>
> > +
> > +struct {
> > +     __uint(type, BPF_MAP_TYPE_ARRAY);
> > +     __uint(max_entries, 2);
> > +     __type(key, __u32);
> > +     __type(value, __u32);
> > +} dst_if_id_map SEC(".maps");
>
> It is easier to use global variables instead of a map.

Would these be available for read/write from the test application (as the
map is currently populated/read from userspace)?

>
> > +
> > +struct bpf_xfrm_info {
> > +     __u32 if_id;
> > +     int link;
> > +};
>
> This needs __attribute__((preserve_access_index) for CO-RE.
> It is easier to just include vmlinux.h to get the struct xfrm_md_info { ... }.

Ok.

>
> > +
> > +int bpf_skb_set_xfrm_info(struct __sk_buff *skb_ctx,
> > +                       const struct bpf_xfrm_info *from) __ksym;
> > +int bpf_skb_get_xfrm_info(struct __sk_buff *skb_ctx,
> > +                       struct bpf_xfrm_info *to) __ksym;
> > +
> > +SEC("tc")
> > +int set_xfrm_info(struct __sk_buff *skb)
> > +{
> > +     struct bpf_xfrm_info info = {};
> > +     __u32 *if_id = NULL;
> > +     __u32 index = 0;
> > +     int ret = -1;
> > +
> > +     if_id = bpf_map_lookup_elem(&dst_if_id_map, &index);
> > +     if (!if_id) {
> > +             log_err(ret);
> > +             return TC_ACT_SHOT;
> > +     }
> > +
> > +     info.if_id = *if_id;
> > +     ret = bpf_skb_set_xfrm_info(skb, &info);
> > +     if (ret < 0) {
> > +             log_err(ret);
> > +             return TC_ACT_SHOT;
> > +     }
> > +
> > +     return TC_ACT_UNSPEC;
> > +}
> > +
> > +SEC("tc")
> > +int get_xfrm_info(struct __sk_buff *skb)
> > +{
> > +     struct bpf_xfrm_info info = {};
> > +     __u32 *if_id = NULL;
> > +     __u32 index = 1;
> > +     int ret = -1;
> > +
> > +     if_id = bpf_map_lookup_elem(&dst_if_id_map, &index);
> > +     if (!if_id) {
> > +             log_err(ret);
> > +             return TC_ACT_SHOT;
> > +     }
> > +
> > +     ret = bpf_skb_get_xfrm_info(skb, &info);
> > +     if (ret < 0) {
> > +             log_err(ret);
> > +             return TC_ACT_SHOT;
> > +     }
> > +
> > +     *if_id = info.if_id;
> > +
> > +     return TC_ACT_UNSPEC;
> > +}
> > +
> > +char _license[] SEC("license") = "GPL";
>

Thanks for the review!
Eyal.
