Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664EF4736AB
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 22:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239148AbhLMVov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 16:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbhLMVov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 16:44:51 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A34C061574;
        Mon, 13 Dec 2021 13:44:50 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id j2so41552830ybg.9;
        Mon, 13 Dec 2021 13:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HF6bhg1hkm0Kvolzcm7W4L5IX7hq3GMJC+dyll0cGz4=;
        b=WJ8CN807+oSKnh1CQ2U1is3GObc5yQkapOGdoE1kd+7u4OqmKkgJgQMByFxjKzfxNG
         dehxifgfXFGBIC+4D9nmkSVTVnYcqiuH/GBG1aLf46BR19DaaVe1GHJEYrnM4wuLNjMe
         tJKtdG/nmqu0acnM1UkCZA5JjAgCd+ONPHQ34raf7teUotC27f+oWNBcIVLavJj/w3oR
         1ooJCvW4VwCJ0yqC5gIwcCRtHq9PuipzTrWZh0DnvfxFJVfGYw6q2/r2Z2HSp1mDPXmB
         CXrI24ClxivbS/EKGfsH22dr6TB5WMaf0NnTOrr+6pBFCbpRdl90tFLVqrdvDbA828yH
         Mydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HF6bhg1hkm0Kvolzcm7W4L5IX7hq3GMJC+dyll0cGz4=;
        b=KppEbRurpg/X7tQW3B3lUFx4kEo0AhjT5Q0VTGukc65r3kyxvs3UBwMEA+5E/6l8wi
         pjpe6MLv2AUY8bVVIbi2BzaY4+K/QvLVn9jOXqxvuY8qUmUnukSFwLDcmZ7w+Mo1OB9+
         gmK9mbXKSKDEMYUQYLMVses51TxQZHMiBZZIRjq9qrLExvo0xTCqXbOzh7MpTwplo+ux
         Mr9tIL/TPh296WB9LyNl5ZkSBxiBajW/AKUBDvxcWU6TQRkkey+4S2hncFD4J6RCH5IS
         3S4iUeJq1cv+ddoCHhzAEwkJRbhAbdfWDnsPVaAGg0G3PahWnqkRSTDNVM6OqXTVxldM
         uHyQ==
X-Gm-Message-State: AOAM5338tZ6E5mmMXrDhbuk3P/9UFSvSBLAndD6Wmklo2pg9z5rfYhUh
        SlTbdJ8uYGEOL3crEt3FlG7clRutAvKkBePUmak=
X-Google-Smtp-Source: ABdhPJxPdD4DH04/IPRHbMukA1WGoWSqPjU1QxqziFpt+1jyvuI9v2o8+HEO316a8wZi01ujDwgNNlFEKkZdGKhFrO8=
X-Received: by 2002:a25:e406:: with SMTP id b6mr1302125ybh.529.1639431889604;
 Mon, 13 Dec 2021 13:44:49 -0800 (PST)
MIME-Version: 1.0
References: <20211207225635.113904-1-mathjadin@gmail.com> <20211207225635.113904-2-mathjadin@gmail.com>
In-Reply-To: <20211207225635.113904-2-mathjadin@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Dec 2021 13:44:38 -0800
Message-ID: <CAEf4BzakcfoYT6KfP0mHFLHiLeZmfdmxgbRJTXBfjXtXnjVaxg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/3] selftests/bpf: Test for IPv6 ext header parsing
To:     Mathieu Jadin <mathjadin@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, KP Singh <kpsingh@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 7, 2021 at 2:58 PM Mathieu Jadin <mathjadin@gmail.com> wrote:
>
> This test creates a client and a server exchanging a single byte
> with a Segment Routing Header and the eBPF program saves
> the inner segment in a sk_storage. The test program checks that
> the segment is correct.
>
> Signed-off-by: Mathieu Jadin <mathjadin@gmail.com>
> ---
>  .../bpf/prog_tests/tcp_ipv6_exthdr_srh.c      | 171 ++++++++++++++++++
>  .../selftests/bpf/progs/tcp_ipv6_exthdr_srh.c |  78 ++++++++
>  2 files changed, 249 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/tcp_ipv6_exthdr_srh.c
>  create mode 100644 tools/testing/selftests/bpf/progs/tcp_ipv6_exthdr_srh.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_ipv6_exthdr_srh.c b/tools/testing/selftests/bpf/prog_tests/tcp_ipv6_exthdr_srh.c
> new file mode 100644
> index 000000000000..70f7ee230975
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/tcp_ipv6_exthdr_srh.c
> @@ -0,0 +1,171 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include <linux/seg6.h>
> +#include "cgroup_helpers.h"
> +#include "network_helpers.h"
> +
> +struct tcp_srh_storage {
> +       struct in6_addr inner_segment;
> +};
> +
> +static void send_byte(int fd)
> +{
> +       char b = 0x55;
> +
> +       if (CHECK_FAIL(send(fd, &b, sizeof(b), 0) != 1))
> +               perror("Failed to send single byte");
> +}
> +
> +static int verify_srh(int map_fd, int server_fd, struct ipv6_sr_hdr *client_srh)
> +{
> +       int err = 0;
> +       struct tcp_srh_storage val;
> +
> +       if (CHECK_FAIL(bpf_map_lookup_elem(map_fd, &server_fd, &val) < 0)) {

please use ASSERT_XXX() macros instead of CHECK and especially instead
of CHECK_FAIL

> +               perror("Failed to read socket storage");
> +               return -1;
> +       }
> +
> +       if (memcmp(&val.inner_segment, &client_srh->segments[1],
> +                  sizeof(struct in6_addr))) {
> +               log_err("The inner segment of the received SRH differs from the sent one");
> +               err++;
> +       }
> +
> +       return err;
> +}
> +
> +static int run_test(int cgroup_fd, int listen_fd)
> +{
> +       struct bpf_prog_load_attr attr = {
> +               .prog_type = BPF_PROG_TYPE_SOCK_OPS,
> +               .file = "./tcp_ipv6_exthdr_srh.o",
> +               .expected_attach_type = BPF_CGROUP_SOCK_OPS,
> +       };
> +       size_t srh_size = sizeof(struct ipv6_sr_hdr) +
> +               2 * sizeof(struct in6_addr);
> +       struct ipv6_sr_hdr *client_srh;
> +       struct bpf_object *obj;
> +       struct bpf_map *map;
> +       struct timeval tv;
> +       int client_fd;
> +       int server_fd;
> +       int prog_fd;
> +       int map_fd;
> +       char byte;
> +       int err;
> +
> +       err = bpf_prog_load_xattr(&attr, &obj, &prog_fd);

bpf_prog_load_xattr() is deprecated, please use BPF skeleton for the test

> +       if (err) {
> +               log_err("Failed to load BPF object");
> +               return -1;
> +       }
> +
> +       map = bpf_object__next_map(obj, NULL);
> +       map_fd = bpf_map__fd(map);
> +

[...]

> +
> +void test_tcp_ipv6_exthdr_srh(void)
> +{
> +       int server_fd, cgroup_fd;
> +
> +       cgroup_fd = test__join_cgroup("/tcp_ipv6_exthdr_srh");
> +       if (CHECK_FAIL(cgroup_fd < 0))
> +               return;
> +
> +       server_fd = start_server(AF_INET6, SOCK_STREAM, "::1", 0, 0);
> +       if (CHECK_FAIL(server_fd < 0))
> +               goto close_cgroup_fd;
> +
> +       if (CHECK_FAIL(system("sysctl net.ipv6.conf.all.seg6_enabled=1")))
> +               goto close_server;
> +
> +       if (CHECK_FAIL(system("sysctl net.ipv6.conf.lo.seg6_enabled=1")))
> +               goto reset_sysctl;
> +
> +       CHECK_FAIL(run_test(cgroup_fd, server_fd));
> +
> +       if (CHECK_FAIL(system("sysctl net.ipv6.conf.lo.seg6_enabled=0")))
> +               log_err("Cannot reset sysctl net.ipv6.conf.lo.seg6_enabled to 0");
> +
> +reset_sysctl:
> +       if (CHECK_FAIL(system("sysctl net.ipv6.conf.all.seg6_enabled=0")))
> +               log_err("Cannot reset sysctl net.ipv6.conf.all.seg6_enabled to 0");
> +

same here, please no CHECK_FAIL()s


> +close_server:
> +       close(server_fd);
> +close_cgroup_fd:
> +       close(cgroup_fd);
> +}

[...]
