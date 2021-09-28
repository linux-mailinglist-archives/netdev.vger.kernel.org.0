Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBC941BAEB
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 01:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243203AbhI1XVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 19:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbhI1XVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 19:21:23 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D0EC06161C;
        Tue, 28 Sep 2021 16:19:43 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id r4so1234333ybp.4;
        Tue, 28 Sep 2021 16:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HlT73lfJxchf0zLuIWO8p+lD0FcseO53IgbxvuS6dZY=;
        b=I/SfFlZkSgsd1YHG20/hJiPUV9oWeZZ83nhxZJdpT9Yr6JIloO/10JwNqTVVnYVJpq
         b3hpyaWyZn1v1vRGuXx7xW4Ez5GtWrSXhbMo7uWMz9mfKWslR19Q87umwlU0m2OLQEdF
         JhFtJQBUTtd2WTE4Kbfile6YF+5qS0vgXdL3rCgSLj46LAZ/Y/l3y4Y0PNaEjZYpJykH
         J5Z8i4xYrGAi3ICnJZDrsi/7vgjJE2eNlIxm3NSPL+URsbEwLeMDNec8xLnqcfgq4QyK
         qOUxuGUW8CAIK6PC8uK8mvbxdYXBpC7GtFZX4VDBRWKWbFNc7n/L89qvR5iCq4c7XPue
         /ADA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HlT73lfJxchf0zLuIWO8p+lD0FcseO53IgbxvuS6dZY=;
        b=c+0R2RBI9nGp2WsQhSmvIRrEzi5JuLDfB+focXzsPUnlFXJqdoKExo2lmQuRatLU54
         unNKd7yvpwf8tSDKtw/YsQsGYoJCjprSRsU2e++UNv6TjEyJz3pCWaUOQ0YwUSZfqW6H
         dOpSOupqU7QHjIifCeiFF9z0s/LPdEsfDVTn9fuUoKQ1kdwQKCDEJIUbOJTyvHwlxfsN
         ypbVCn6vFQDe0o5P8slTjhFdeDfOtMjP++LuIf2TwlKKQgixsvbzO+lBIkGKpjpnrZgL
         t2Ug4uZu8aiipGfWyRwjsLYwkrcxXRz9q7WDWy9LPOOa2M3NmXgeTrn3OGT/vUwH+J5o
         jwPg==
X-Gm-Message-State: AOAM533gnw+a52JRgNv/sSwi4Ab/S61YJjFQN7TrbRecuwU5icCZdzeb
        tJv8jbJpy6dDlm5U0B6VELRcJ3r8sev1wcxpcV4=
X-Google-Smtp-Source: ABdhPJzfZyvHv320oG9dGAYSUCqcdL/Dg5l8yJuxMg1Wd82mtrRa/UlgEqZCCIHmHFmE44zzM7aTK80t65CFltBsK6U=
X-Received: by 2002:a25:2d4e:: with SMTP id s14mr9449341ybe.2.1632871182241;
 Tue, 28 Sep 2021 16:19:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210928025228.88673-1-houtao1@huawei.com> <20210928025228.88673-6-houtao1@huawei.com>
In-Reply-To: <20210928025228.88673-6-houtao1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Sep 2021 16:19:31 -0700
Message-ID: <CAEf4BzaE4_c7fcMCfFe7nukivVrFgpPZcbr5z-FfSa=erNKiTw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/5] selftests/bpf: test return value handling
 for struct_ops prog
To:     Hou Tao <houtao1@huawei.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 7:38 PM Hou Tao <houtao1@huawei.com> wrote:
>
> Running a BPF_PROG_TYPE_STRUCT_OPS prog for dummy_st_ops::init()
> through bpf_prog_test_run(). Three test cases are added:
> (1) attach dummy_st_ops should fail
> (2) function return value of bpf_dummy_ops::init() is expected
> (3) pointer argument of bpf_dummy_ops::init() works as expected
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  .../selftests/bpf/prog_tests/dummy_st_ops.c   | 81 +++++++++++++++++++
>  .../selftests/bpf/progs/dummy_st_ops.c        | 33 ++++++++
>  2 files changed, 114 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c
>  create mode 100644 tools/testing/selftests/bpf/progs/dummy_st_ops.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c b/tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c
> new file mode 100644
> index 000000000000..4b1b52b847e6
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c
> @@ -0,0 +1,81 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2021. Huawei Technologies Co., Ltd */
> +#include <test_progs.h>
> +#include "dummy_st_ops.skel.h"
> +
> +/* Need to keep consistent with definitions in include/linux/bpf_dummy_ops.h */
> +struct bpf_dummy_ops_state {
> +       int val;
> +};
> +
> +static void test_dummy_st_ops_attach(void)
> +{
> +       struct dummy_st_ops *skel;
> +       struct bpf_link *link;
> +
> +       skel = dummy_st_ops__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "dummy_st_ops_load"))
> +               goto out;

no need for __destroy() as we haven't created skeleton, so this could
be just a return

> +
> +       link = bpf_map__attach_struct_ops(skel->maps.dummy_1);
> +       if (!ASSERT_EQ(libbpf_get_error(link), -EOPNOTSUPP,
> +                      "dummy_st_ops_attach"))
> +               goto out;

nit: unless you expect to add something here soon, probably doing
ASSERT_EQ() and let it fall through to out: and destroy would be a bit
more readable

> +out:
> +       dummy_st_ops__destroy(skel);
> +}
> +
> +static void test_dummy_init_ret_value(void)
> +{
> +       struct dummy_st_ops *skel;
> +       int err, fd;
> +       __u32 duration = 0, retval = 0;
> +
> +       skel = dummy_st_ops__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "dummy_st_ops_load"))
> +               goto out;

same, just return is fine and no need for out: label

> +
> +       fd = bpf_program__fd(skel->progs.init_1);
> +       err = bpf_prog_test_run(fd, 1, NULL, 0,
> +                               NULL, NULL, &retval, &duration);
> +       ASSERT_OK(err, "test_run");
> +       ASSERT_EQ(retval, 0xf2f3f4f5, "test_ret");
> +out:
> +       dummy_st_ops__destroy(skel);
> +}
> +
> +static void test_dummy_init_ptr_arg(void)
> +{
> +       struct dummy_st_ops *skel;
> +       int err, fd;
> +       __u32 duration = 0, retval = 0;
> +       struct bpf_dummy_ops_state in_state, out_state;
> +       __u32 state_size;
> +
> +       skel = dummy_st_ops__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "dummy_st_ops_load"))
> +               goto out;

here as well

> +
> +       fd = bpf_program__fd(skel->progs.init_1);
> +       memset(&in_state, 0, sizeof(in_state));
> +       in_state.val = 0xbeef;
> +       memset(&out_state, 0, sizeof(out_state));
> +       err = bpf_prog_test_run(fd, 1, &in_state, sizeof(in_state),
> +                               &out_state, &state_size, &retval, &duration);
> +       ASSERT_OK(err, "test_run");
> +       ASSERT_EQ(state_size, sizeof(out_state), "test_data_out");
> +       ASSERT_EQ(out_state.val, 0x5a, "test_ptr_ret");
> +       ASSERT_EQ(retval, in_state.val, "test_ret");
> +out:
> +       dummy_st_ops__destroy(skel);
> +}
> +
> +void test_dummy_st_ops(void)
> +{
> +       if (test__start_subtest("dummy_st_ops_attach"))
> +               test_dummy_st_ops_attach();
> +       if (test__start_subtest("dummy_init_ret_value"))
> +               test_dummy_init_ret_value();
> +       if (test__start_subtest("dummy_init_ptr_arg"))
> +               test_dummy_init_ptr_arg();
> +}
> diff --git a/tools/testing/selftests/bpf/progs/dummy_st_ops.c b/tools/testing/selftests/bpf/progs/dummy_st_ops.c
> new file mode 100644
> index 000000000000..133c328f082a
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/dummy_st_ops.c
> @@ -0,0 +1,33 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2021. Huawei Technologies Co., Ltd */
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +struct bpf_dummy_ops_state {
> +       int val;
> +} __attribute__((preserve_access_index));
> +
> +struct bpf_dummy_ops {
> +       int (*init)(struct bpf_dummy_ops_state *state);
> +};
> +
> +char _liencse[] SEC("license") = "GPL";

typo: _license (but it doesn't matter to libbpf, it looks at the
section name only

> +
> +SEC("struct_ops/init_1")
> +int BPF_PROG(init_1, struct bpf_dummy_ops_state *state)
> +{
> +       int ret;
> +
> +       if (!state)
> +               return 0xf2f3f4f5;
> +
> +       ret = state->val;
> +       state->val = 0x5a;
> +       return ret;
> +}
> +
> +SEC(".struct_ops")
> +struct bpf_dummy_ops dummy_1 = {
> +       .init = (void *)init_1,
> +};
> --
> 2.29.2
>
