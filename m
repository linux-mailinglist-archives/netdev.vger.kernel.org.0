Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEF329F877
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbgJ2Wh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgJ2Wh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 18:37:56 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403A0C0613CF;
        Thu, 29 Oct 2020 15:37:56 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id m188so3546529ybf.2;
        Thu, 29 Oct 2020 15:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+pmaCWq1lwd8fGXXeIhLsyun579Dy2XSMTyxc1Yc4Sk=;
        b=HjxPcYHvvt0tHDYmOamx/YlVCEe/lxAy7+CFzAYD+c8zxgP9c1RFT72wDsqW6LqP7u
         T30G2ab0pSdU99LdSbA9de7c/ooT+k0G+4gy+eBDkKbnb9TW3x9cBOueJe/dW5Cuk37t
         M9Zecd77TDYdDSaiWAHpY7uqJ2IcUCyw4mpyGchu1eTKpM19re1rn0H7j5Y2oryPG0a8
         CCHfGP29HpLxy6gKBh20oqBMT0fVS1RMD1LlA0P3OJFYH7z7Hdv/lxxszpjhZzKPaZF+
         MFUCXhyphs0xXmRVyBIHP5adbHH4iE38ZRN8Dt9eU79CsEALYCXgFcpDdYhFZMR3wKiC
         iABA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+pmaCWq1lwd8fGXXeIhLsyun579Dy2XSMTyxc1Yc4Sk=;
        b=RUPRFJkyvxwKYX3n5dZ2evrZchIvK1Vx/oJZXTOIGxbJ8Pfdt5tzHTxfJA27Flh7kM
         /pYybutgvKSVnv1rFHAVAoVPX5gF/kAzbK4ZbXHbpvilHFCrqvl+jEt965qfyl+MojyI
         X2cTI1jnk22LryAS6dC2gWhfka90iakY37q8/K4wNzZbQvl1U7sG83HG1iIochn11zRP
         piGaSwb1rbwI53RixfeqB89bj5DdsXfWR1CoS+3tA01olHP/Q39zh9nDc208v6iF4yT5
         t+K6r/+Qoy0g+gWClPezCMmhreFIYgOLdU2n9L+5gQYXC2OtRIeQFwdT8M7vhH3sHag6
         WLFw==
X-Gm-Message-State: AOAM533ZCxIjDnS0uPKQad5hp/RpAdvz11lUhFD98rzOJsE469y97VII
        wO3E08XPsWGKeSSQPTkig+c4RVwrkq+yeLU0B/TdMOJDT0c=
X-Google-Smtp-Source: ABdhPJyJtuyavdabx00uagD+Kz5KpzG62XLsslrX4Cva/YBXJ6HN7tvz2eKZLe6mPkI2ILOHSdRIy0UDZL4IyZpa3AU=
X-Received: by 2002:a25:3443:: with SMTP id b64mr9178495yba.510.1604011075342;
 Thu, 29 Oct 2020 15:37:55 -0700 (PDT)
MIME-Version: 1.0
References: <20201029111730.6881-1-david.verbeiren@tessares.net> <CAPhsuW7o7D-6VW-Z3Umdw8z-7Ab+kkZrJf2EU9nCDFh0Xbn7sA@mail.gmail.com>
In-Reply-To: <CAPhsuW7o7D-6VW-Z3Umdw8z-7Ab+kkZrJf2EU9nCDFh0Xbn7sA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 29 Oct 2020 15:37:44 -0700
Message-ID: <CAEf4BzZaZ2PT7nOrXGo-XM7ysgQ8JpDObUysnS+oxGV7e6GQgA@mail.gmail.com>
Subject: Re: [PATCH bpf] selftest/bpf: Validate initial values of per-cpu hash elems
To:     Song Liu <song@kernel.org>
Cc:     David Verbeiren <david.verbeiren@tessares.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 11:36 AM Song Liu <song@kernel.org> wrote:
>
> On Thu, Oct 29, 2020 at 4:19 AM David Verbeiren
> <david.verbeiren@tessares.net> wrote:
> >
> > Tests that when per-cpu hash map or LRU hash map elements are
> > re-used as a result of a bpf program inserting elements, the
> > element values for the other CPUs than the one executing the
> > BPF code are reset to 0.
> >
> > This validates the fix proposed in:
> > https://lkml.kernel.org/bpf/20201027221324.27894-1-david.verbeiren@tessares.net/
> >
> > Change-Id: I38bc7b3744ed40704a7b2cc6efa179fb344c4bee
> > Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> > Signed-off-by: David Verbeiren <david.verbeiren@tessares.net>
> > ---
> >  .../selftests/bpf/prog_tests/map_init.c       | 204 ++++++++++++++++++
> >  1 file changed, 204 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/map_init.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/map_init.c b/tools/testing/selftests/bpf/prog_tests/map_init.c
> > new file mode 100644
> > index 000000000000..9640cf925908
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/map_init.c
> > @@ -0,0 +1,204 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +// Copyright (c) 2020 Tessares SA <http://www.tessares.net>
> > +
> > +#include <test_progs.h>
> > +
> > +#define TEST_VALUE 0x1234
> > +
> > +static int nr_cpus;
> > +static int duration;
> > +static char bpf_log_buf[BPF_LOG_BUF_SIZE];
> > +
> > +typedef unsigned long long map_key_t;
> > +typedef unsigned long long map_value_t;
> > +typedef struct {
> > +       map_value_t v; /* padding */
> > +} __bpf_percpu_val_align pcpu_map_value_t;
> > +
> > +/* executes bpf program that updates map with key, value */
> > +static int bpf_prog_insert_elem(int fd, map_key_t key, map_value_t value)
> > +{
> > +       struct bpf_load_program_attr prog;
> > +       struct bpf_insn insns[] = {
> > +               BPF_LD_IMM64(BPF_REG_8, key),
> > +               BPF_LD_IMM64(BPF_REG_9, value),
> > +
> > +               /* update: R1=fd, R2=&key, R3=&value, R4=flags */
> > +               BPF_LD_MAP_FD(BPF_REG_1, fd),
> > +               BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
> > +               BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
> > +               BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_8, 0),
> > +               BPF_MOV64_REG(BPF_REG_3, BPF_REG_2),
> > +               BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, -8),
> > +               BPF_STX_MEM(BPF_DW, BPF_REG_3, BPF_REG_9, 0),
> > +               BPF_MOV64_IMM(BPF_REG_4, 0),
> > +               BPF_EMIT_CALL(BPF_FUNC_map_update_elem),
> > +
> > +               BPF_MOV64_IMM(BPF_REG_0, 0),
> > +               BPF_EXIT_INSN(),
> > +       };
>
> Impressive hand written assembly. ;-) I would recommend using skeleton
> for future work. For example:
>
>     BPF program: selftests/bpf/progs/bpf_iter_bpf_map.c
>     Use the program in tests:
> selftests/bpf/prog_tests/bpf_iter.c:#include "bpf_iter_bpf_map.skel.h"
>

Let's keep a manually-constructed assembly to test_verifier tests only.

David, please also check progs/test_endian.c and prog_tests/endian.c
as one of the most minimal self-tests with no added complexity, but
complete end-to-end setup.


>
> > +       char buf[64] = {};
> > +       int pfd, err;
> > +       __u32 retval = 0;
> > +
> > +       memset(&prog, 0, sizeof(prog));
> > +       prog.prog_type = BPF_PROG_TYPE_SCHED_CLS;
> > +       prog.insns = insns;
> > +       prog.insns_cnt = ARRAY_SIZE(insns);
> > +       prog.license = "GPL";
> > +
> > +       pfd = bpf_load_program_xattr(&prog, bpf_log_buf, BPF_LOG_BUF_SIZE);
> > +       if (CHECK(pfd < 0, "bpf_load_program_xattr", "failed: %s\n%s\n",
> > +                 strerror(errno), bpf_log_buf))
> > +               return -1;
> > +
> > +       err = bpf_prog_test_run(pfd, 1, buf, sizeof(buf), NULL, NULL,
> > +                               &retval, NULL);
> > +       if (CHECK(err || retval, "bpf_prog_test_run",
> > +                 "err=%d retval=%d errno=%d\n", err, retval, errno))
> > +               err = -1;
> > +
> > +       close(pfd);
> > +
> > +       return err;
> > +}
> > +
> > +static int check_values_one_cpu(pcpu_map_value_t *value, map_value_t expected)
> > +{
> > +       int i, nzCnt = 0;
> > +       map_value_t val;
> > +
> > +       for (i = 0; i < nr_cpus; i++) {
> > +               val = bpf_percpu(value, i);
> > +               if (val) {
> > +                       if (val != expected) {
> > +                               PRINT_FAIL("Unexpected value (cpu %d): 0x%llx\n",
> > +                                          i, val);
>
> I guess we can also use CHECK() here?
>
> > +                               return -1;
> > +                       }
> [...]
>
> > +
> > +       /* delete key=1 element so it will later be re-used*/
> > +       key = 1;
> > +       err = bpf_map_delete_elem(map_fd, &key);
> > +       if (CHECK(err, "bpf_map_delete_elem", "failed: %s\n", strerror(errno)))
> > +               goto error_map;
> > +
> > +       /* run bpf prog that inserts new elem, re-using the slot just freed */
> > +       err = bpf_prog_insert_elem(map_fd, key, TEST_VALUE);
> > +       if (!ASSERT_OK(err, "bpf_prog_insert_elem"))
> > +               goto error_map;
>
> What's the reason to use ASSERT_OK() instead of CHECK()?

I've recently added the ASSERT_xxx() family of macros to accommodate
most common checks and provide sensible details printing. So I now
always prefer ASSERT() macroses, it saves a bunch of typing and time.

>
> > +
> > +       /* check that key=1 was re-created by bpf prog */
> > +       err = bpf_map_lookup_elem(map_fd, &key, value);
> > +       if (CHECK(err, "bpf_map_lookup_elem", "failed: %s\n", strerror(errno)))
> > +               goto error_map;
> > +
> > +       /* and has expected value for just a single CPU, 0 for all others */
> > +       check_values_one_cpu(value, TEST_VALUE);
> > +
> > +error_map:
> > +       close(map_fd);
> > +}
> > +
> > +/* Add key=1 and key=2 elems with values set for all CPUs
> > + * Run bpf prog that inserts new key=3 elem
> > + *   (only for current cpu; other cpus should have initial value = 0)
> > + * Lookup Key=1 and check value is as expected for all CPUs
> > + */
> > +static void test_pcpu_lru_map_init(void)
> > +{
> > +       pcpu_map_value_t value[nr_cpus];
> > +       int map_fd, err;
> > +       map_key_t key;
> > +
> > +       /* Set up LRU map with 2 elements, values filled for all CPUs.
> > +        * With these 2 elements, the LRU map is full
> > +        */
> > +       map_fd = map_setup(BPF_MAP_TYPE_LRU_PERCPU_HASH, 2, 2);
> > +       if (CHECK(map_fd < 0, "map_setup", "failed\n"))
> > +               return;
> > +
> > +       /* run bpf prog that inserts new key=3 element, re-using LRU slot */
> > +       key = 3;
> > +       err = bpf_prog_insert_elem(map_fd, key, TEST_VALUE);
> > +       if (!ASSERT_OK(err, "bpf_prog_insert_elem"))
> > +               goto error_map;
>
> ditto
>
> > +
> > +       /* check that key=3 present */
> > +       err = bpf_map_lookup_elem(map_fd, &key, value);
> > +       if (CHECK(err, "bpf_map_lookup_elem", "failed: %s\n", strerror(errno)))
> > +               goto error_map;
> > +
> > +       /* and has expected value for just a single CPU, 0 for all others */
> > +       check_values_one_cpu(value, TEST_VALUE);
> > +
> > +error_map:
> > +       close(map_fd);
> > +}
> > +
> > +void test_map_init(void)
> > +{
> > +       nr_cpus = bpf_num_possible_cpus();
> > +       if (CHECK(nr_cpus <= 1, "nr_cpus", "> 1 needed for this test"))
> > +               return;
>
> Instead of failing the test, let's skip the tests with something like:
>
>                 printf("%s:SKIP: >1 cpu needed for this test\n", __func__);
>                 test__skip();
>

+1

> > +
> > +       if (test__start_subtest("pcpu_map_init"))
> > +               test_pcpu_map_init();
> > +       if (test__start_subtest("pcpu_lru_map_init"))
> > +               test_pcpu_lru_map_init();
> > +}
> > --
> > 2.29.0
> >
