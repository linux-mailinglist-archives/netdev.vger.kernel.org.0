Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86903E31EC
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 00:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243612AbhHFWux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 18:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbhHFWux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 18:50:53 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E871C0613CF;
        Fri,  6 Aug 2021 15:50:36 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id b133so17856488ybg.4;
        Fri, 06 Aug 2021 15:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MeDIOzhvahu2/mWIuk2582Ex8e4vxrJQqvzWXFLkMAM=;
        b=lF0gv4B6MTGOmvsUh3k+vlAavXQq2EQv72LNSc6KJ4i1zdU5/PiJEHNWP/QQ8Pbov3
         2vZq7lqp4nw+0MQmzZ0F0/Buk4ytkWCLcdwik+bxhi2jaGmsPeznSUa49HX/4CuqMMLP
         v6N3uSBc1t7uPmomoHLSaH4URZq6KGjk9nb8rMIYRudz7pFZViRZhzLsPVwQjSXGK/Bs
         VMT7munniJUs/LlJMZjJQwWbVlz760T8ky1IkzF/ErhuOEQzTcZWqdYjFH19yTcfPGNf
         QksDqJbvWvuIDa7ss5uMaYbIUGHLEnHzhOAGujsUwLUWlfR6yEVWtrFvjgDZUnTpL8H/
         ro+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MeDIOzhvahu2/mWIuk2582Ex8e4vxrJQqvzWXFLkMAM=;
        b=YrQJEutXSPSJ8ZxEahOcJRzXz4jtjcpistfhTMZKDmJZYJaZcSU/u2Mj8dxRSHAeKA
         RLCTrftvESvxBo1l85yyXjqUJ+smT5uB1caFxd48nHmk1Wob4KdYVNoDzsrHx3tCmybH
         vxWv/11DR/M68MCWjKHjJe+R7165I3fFuUzc+K9qKVBEb+a6M7gICC5UR04Z2hKE/NRF
         Nx/Ht9iZdgIkFQUPyimle2jHbzFfS7FZXH0+I9sDdrqd0BX9Eq4w504LTBzLsqpcf3HW
         pqxQYj+ITo1aMY8Ft7GKwNjconZP9C7z7C5IMRz9QJN7xEb8kt8Ixynji12Je0tcimWP
         sN4w==
X-Gm-Message-State: AOAM532jDGdj2zEg8zEq9+S89N3c3VcQbEX4LgcXcv+OK2v0WojFNetd
        CSKvpWw6P9M5pbH9yklenfMxFPdm+Hv1jNb1EW0=
X-Google-Smtp-Source: ABdhPJyJEu5z4M66r6A5ETuR+2cAWSXA/5P6zOGqGPi00XJEiEjrPutqQSIVBSaXGC6tUfvzdotcgdf19uLyDOWFQW0=
X-Received: by 2002:a25:cdc7:: with SMTP id d190mr15612476ybf.425.1628290235453;
 Fri, 06 Aug 2021 15:50:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210609135537.1460244-1-joamaki@gmail.com> <20210731055738.16820-1-joamaki@gmail.com>
 <20210731055738.16820-8-joamaki@gmail.com>
In-Reply-To: <20210731055738.16820-8-joamaki@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Aug 2021 15:50:24 -0700
Message-ID: <CAEf4BzZvojbuHseDbnqRUMAAfn-j4J+_3omWJw8=W6cTPmf0dw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 7/7] selftests/bpf: Add tests for XDP bonding
To:     Jussi Maki <joamaki@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, j.vosburgh@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>, vfalico@gmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 5, 2021 at 9:10 AM Jussi Maki <joamaki@gmail.com> wrote:
>
> Add a test suite to test XDP bonding implementation
> over a pair of veth devices.
>
> Signed-off-by: Jussi Maki <joamaki@gmail.com>
> ---
>  .../selftests/bpf/prog_tests/xdp_bonding.c    | 520 ++++++++++++++++++
>  1 file changed, 520 insertions(+)
>

I don't pretend to understand what's going on in this selftests, but
it looks good from the generic selftest standpoint. One and half small
issues below, please double-check (and probably fix the fd close
issue).

Acked-by: Andrii Nakryiko <andrii@kernel.org>


[...]

> +
> +/* Test the broadcast redirection using xdp_redirect_map_multi_prog and adding
> + * all the interfaces to it and checking that broadcasting won't send the packet
> + * to neither the ingress bond device (bond2) or its slave (veth2_1).
> + */
> +static void test_xdp_bonding_redirect_multi(struct skeletons *skeletons)
> +{
> +       static const char * const ifaces[] = {"bond2", "veth2_1", "veth2_2"};
> +       int veth1_1_rx, veth1_2_rx;
> +       int err;
> +
> +       if (bonding_setup(skeletons, BOND_MODE_ROUNDROBIN, BOND_XMIT_POLICY_LAYER23,
> +                         BOND_ONE_NO_ATTACH))
> +               goto out;
> +
> +
> +       if (!ASSERT_OK(setns_by_name("ns_dst"), "could not set netns to ns_dst"))
> +               goto out;
> +
> +       /* populate the devmap with the relevant interfaces */
> +       for (int i = 0; i < ARRAY_SIZE(ifaces); i++) {
> +               int ifindex = if_nametoindex(ifaces[i]);
> +               int map_fd = bpf_map__fd(skeletons->xdp_redirect_multi_kern->maps.map_all);
> +
> +               if (!ASSERT_GT(ifindex, 0, "could not get interface index"))
> +                       goto out;
> +
> +               err = bpf_map_update_elem(map_fd, &ifindex, &ifindex, 0);
> +               if (!ASSERT_OK(err, "add interface to map_all"))
> +                       goto out;
> +       }
> +
> +       if (xdp_attach(skeletons,
> +                      skeletons->xdp_redirect_multi_kern->progs.xdp_redirect_map_multi_prog,
> +                      "bond2"))
> +               goto out;
> +
> +       restore_root_netns();

the "goto out" below might call restore_root_netns() again, is that ok?

> +
> +       if (send_udp_packets(BOND_MODE_ROUNDROBIN))
> +               goto out;
> +
> +       veth1_1_rx = get_rx_packets("veth1_1");
> +       veth1_2_rx = get_rx_packets("veth1_2");
> +
> +       ASSERT_EQ(veth1_1_rx, 0, "expected no packets on veth1_1");
> +       ASSERT_GE(veth1_2_rx, NPACKETS, "expected packets on veth1_2");
> +
> +out:
> +       restore_root_netns();
> +       bonding_cleanup(skeletons);
> +}
> +

[...]

> +
> +void test_xdp_bonding(void)
> +{
> +       libbpf_print_fn_t old_print_fn;
> +       struct skeletons skeletons = {};
> +       int i;
> +
> +       old_print_fn = libbpf_set_print(libbpf_debug_print);
> +
> +       root_netns_fd = open("/proc/self/ns/net", O_RDONLY);
> +       if (!ASSERT_GE(root_netns_fd, 0, "open /proc/self/ns/net"))
> +               goto out;
> +
> +       skeletons.xdp_dummy = xdp_dummy__open_and_load();
> +       if (!ASSERT_OK_PTR(skeletons.xdp_dummy, "xdp_dummy__open_and_load"))
> +               goto out;
> +
> +       skeletons.xdp_tx = xdp_tx__open_and_load();
> +       if (!ASSERT_OK_PTR(skeletons.xdp_tx, "xdp_tx__open_and_load"))
> +               goto out;
> +
> +       skeletons.xdp_redirect_multi_kern = xdp_redirect_multi_kern__open_and_load();
> +       if (!ASSERT_OK_PTR(skeletons.xdp_redirect_multi_kern,
> +                          "xdp_redirect_multi_kern__open_and_load"))
> +               goto out;
> +
> +       if (!test__start_subtest("xdp_bonding_attach"))
> +               test_xdp_bonding_attach(&skeletons);
> +
> +       for (i = 0; i < ARRAY_SIZE(bond_test_cases); i++) {
> +               struct bond_test_case *test_case = &bond_test_cases[i];
> +
> +               if (!test__start_subtest(test_case->name))
> +                       test_xdp_bonding_with_mode(
> +                               &skeletons,
> +                               test_case->mode,
> +                               test_case->xmit_policy);
> +       }
> +
> +       if (!test__start_subtest("xdp_bonding_redirect_multi"))
> +               test_xdp_bonding_redirect_multi(&skeletons);
> +
> +out:
> +       xdp_dummy__destroy(skeletons.xdp_dummy);
> +       xdp_tx__destroy(skeletons.xdp_tx);
> +       xdp_redirect_multi_kern__destroy(skeletons.xdp_redirect_multi_kern);
> +
> +       libbpf_set_print(old_print_fn);
> +       if (root_netns_fd)

technically, fd could be 0, so for fds we have if (fd >= 0)
everywhere. Also, if open() above fails, root_netns_fd will be -1 and
you'll still attempt to close it.

> +               close(root_netns_fd);
> +}
> --
> 2.17.1
>
