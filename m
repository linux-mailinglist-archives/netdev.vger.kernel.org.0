Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9957C3E0AE1
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 01:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235705AbhHDXde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 19:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbhHDXdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 19:33:31 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B9CC0613D5;
        Wed,  4 Aug 2021 16:33:15 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id c137so5911611ybf.5;
        Wed, 04 Aug 2021 16:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s8mGh6ZU46o1NxoX4tZMuQ/6IYMuNAX9LrEMJOwwa3E=;
        b=E30HpGe+8gc1PNJODaL9+/DSvm4sOumHrVlJJ/47/aeM8IqkA14eeRmkFU8DkPHiUJ
         nlLs3NUe5vdMRglcghUEJNAQOy4bN+nOAPqia9GMbKESusZCMHZNWcU/23qfuV6T8uTP
         94itVrWxTfryvyjffB7HysG8OPu1N677af4B2GdCTgAOeGHouULfmKfYXYEHRMQkV5Oa
         RyYPeK3itzG+/Fd4+PZOHpaGkPMbjYBhiX+AoBWJYoKXL7eq2t4NJ8rAkTHnI5jTL/ra
         YAz0vFSmHbuVVcKDeDt5P5DeJmMiUKta/WfpiJ35K8g9cIl90mfJngCIFP0Ol4zr5zE1
         +K5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s8mGh6ZU46o1NxoX4tZMuQ/6IYMuNAX9LrEMJOwwa3E=;
        b=QcykIETBDzMV6S89Jpu6fJf1CTu0pagCRLySnauL+N+G9oQcURfZ6dnxSF3cNoLgjd
         t2kmTR6PowdWyDwU8Y49oYjbKk5zh0iUhHK7As8TEtcBJ7LWhWgKO1bfNqu4FPMlbFo8
         zRLjTOfqBXqiRAmGwYNT+9AzkAB721Ds9pR0H7Jc2trrI7+d98NCoDHaBa0hmbLBva9n
         V+Wp3lRLsJo17EOEY4yaFQh635vmQ6/Tzvq81k+2K5R/gvnEDDB0r9PdqCi2DRKWhzsl
         5KWZ0o98OWaSM+0tfTSKc7zj7d5icb2GV6oWT2GpETZ7+yqQ/gSUeQ35o65DEI8GTzp+
         LLVg==
X-Gm-Message-State: AOAM531NdIm4WuALNaB6UaQxqZXmoPAF0hd+xhlj4efX9GvkFeh2Fzcv
        S8N7dYqFEojTyK+J7pWgklE0Jz6BaDgDw4IgA6A=
X-Google-Smtp-Source: ABdhPJw0gysMvKoSB3ITG2DHPQ+N+j7NDYNtQizBM8a4Rs97iV2lq36LLGFgdKnegw5379VtLe6aOykdUHnkxtJycXQ=
X-Received: by 2002:a25:cdc7:: with SMTP id d190mr2243458ybf.425.1628119994837;
 Wed, 04 Aug 2021 16:33:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210609135537.1460244-1-joamaki@gmail.com> <20210730061822.6600-1-joamaki@gmail.com>
 <20210730061822.6600-8-joamaki@gmail.com>
In-Reply-To: <20210730061822.6600-8-joamaki@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 4 Aug 2021 16:33:03 -0700
Message-ID: <CAEf4BzbSAAHibT2r47MPOB_9-ohk6B-RR=-n7+V+GkBA0=EpTA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 7/7] selftests/bpf: Add tests for XDP bonding
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

On Wed, Aug 4, 2021 at 5:45 AM Jussi Maki <joamaki@gmail.com> wrote:
>
> Add a test suite to test XDP bonding implementation
> over a pair of veth devices.
>
> Signed-off-by: Jussi Maki <joamaki@gmail.com>
> ---
>  .../selftests/bpf/prog_tests/xdp_bonding.c    | 533 ++++++++++++++++++
>  1 file changed, 533 insertions(+)
>

[...]

> +
> +static int xdp_attach(struct skeletons *skeletons, struct bpf_program *prog, char *iface)
> +{
> +       struct bpf_link *link;
> +       int ifindex;
> +
> +       ifindex = if_nametoindex(iface);
> +       if (!ASSERT_GT(ifindex, 0, "get ifindex"))
> +               return -1;
> +
> +       if (!ASSERT_LE(skeletons->nlinks, MAX_BPF_LINKS, "too many XDP programs attached"))

If it's already less or equal to MAX_BPF_LINKS, then you'll bump
nlinks below one more time and write beyond the array boundaries?

> +               return -1;
> +
> +       link = bpf_program__attach_xdp(prog, ifindex);
> +       if (!ASSERT_OK_PTR(link, "attach xdp program"))
> +               return -1;
> +
> +       skeletons->links[skeletons->nlinks++] = link;
> +       return 0;
> +}
> +

[...]

> +
> +static void bonding_cleanup(struct skeletons *skeletons)
> +{
> +       restore_root_netns();
> +       while (skeletons->nlinks) {
> +               skeletons->nlinks--;
> +               bpf_link__detach(skeletons->links[skeletons->nlinks]);

You want bpf_link__destroy, not bpf_link__detach (detach will leave
underlying BPF link FD open and ensure that bpf_link__destory() won't
do anything with it, just frees memory).

> +       }
> +       ASSERT_OK(system("ip link delete bond1"), "delete bond1");
> +       ASSERT_OK(system("ip link delete veth1_1"), "delete veth1_1");
> +       ASSERT_OK(system("ip link delete veth1_2"), "delete veth1_2");
> +       ASSERT_OK(system("ip netns delete ns_dst"), "delete ns_dst");
> +}
> +

> +out:
> +       bonding_cleanup(skeletons);
> +}
> +
> +

nit: extra line

> +/* Test the broadcast redirection using xdp_redirect_map_multi_prog and adding
> + * all the interfaces to it and checking that broadcasting won't send the packet
> + * to neither the ingress bond device (bond2) or its slave (veth2_1).
> + */
> +void test_xdp_bonding_redirect_multi(struct skeletons *skeletons)
> +{
> +       static const char * const ifaces[] = {"bond2", "veth2_1", "veth2_2"};
> +       int veth1_1_rx, veth1_2_rx;
> +       int err;
> +
> +       if (!test__start_subtest("xdp_bonding_redirect_multi"))
> +               return;
> +
> +       if (bonding_setup(skeletons, BOND_MODE_ROUNDROBIN, BOND_XMIT_POLICY_LAYER23,
> +                         BOND_ONE_NO_ATTACH))
> +               goto out;
> +
> +

nit: another extra empty line, please check if there are more

> +       if (!ASSERT_OK(setns_by_name("ns_dst"), "could not set netns to ns_dst"))
> +               goto out;
> +

[...]

> +       /* enslaving with a XDP program loaded fails */
> +       link = bpf_program__attach_xdp(skeletons->xdp_dummy->progs.xdp_dummy_prog, veth);
> +       if (!ASSERT_OK_PTR(link, "attach program to veth"))
> +               goto out;
> +
> +       err = system("ip link set veth master bond");
> +       if (!ASSERT_NEQ(err, 0, "attaching slave with xdp program expected to fail"))
> +               goto out;
> +
> +       bpf_link__detach(link);

same here and in few more places, you need destroy

> +       link = NULL;
> +
> +       err = system("ip link set veth master bond");
> +       if (!ASSERT_OK(err, "set veth master"))
> +               goto out;
> +
> +       /* attaching to slave when master has no program is allowed */
> +       link = bpf_program__attach_xdp(skeletons->xdp_dummy->progs.xdp_dummy_prog, veth);
> +       if (!ASSERT_OK_PTR(link, "attach program to slave when enslaved"))
> +               goto out;
> +
> +       /* attaching to master not allowed when slave has program loaded */
> +       link2 = bpf_program__attach_xdp(skeletons->xdp_dummy->progs.xdp_dummy_prog, bond);
> +       if (!ASSERT_ERR_PTR(link2, "attach program to master when slave has program"))
> +               goto out;
> +
> +       bpf_link__detach(link);
> +       link = NULL;
> +
> +       /* attaching XDP program to master allowed when slave has no program */
> +       link = bpf_program__attach_xdp(skeletons->xdp_dummy->progs.xdp_dummy_prog, bond);
> +       if (!ASSERT_OK_PTR(link, "attach program to master"))
> +               goto out;
> +
> +       /* attaching to slave not allowed when master has program loaded */
> +       link2 = bpf_program__attach_xdp(skeletons->xdp_dummy->progs.xdp_dummy_prog, bond);
> +       ASSERT_ERR_PTR(link2, "attach program to slave when master has program");
> +
> +out:
> +       if (link)
> +               bpf_link__detach(link);
> +       if (link2)
> +               bpf_link__detach(link2);

bpf_link__destroy() handles NULLs just fine, you don't have to do extra checks

> +
> +       system("ip link del veth");
> +       system("ip link del bond");
> +}
> +
> +static int libbpf_debug_print(enum libbpf_print_level level,
> +                             const char *format, va_list args)
> +{
> +       if (level != LIBBPF_WARN)
> +               vprintf(format, args);
> +       return 0;
> +}
> +
> +struct bond_test_case {
> +       char *name;
> +       int mode;
> +       int xmit_policy;
> +};
> +
> +static struct bond_test_case bond_test_cases[] = {
> +       { "xdp_bonding_roundrobin", BOND_MODE_ROUNDROBIN, BOND_XMIT_POLICY_LAYER23, },
> +       { "xdp_bonding_activebackup", BOND_MODE_ACTIVEBACKUP, BOND_XMIT_POLICY_LAYER23 },
> +
> +       { "xdp_bonding_xor_layer2", BOND_MODE_XOR, BOND_XMIT_POLICY_LAYER2, },
> +       { "xdp_bonding_xor_layer23", BOND_MODE_XOR, BOND_XMIT_POLICY_LAYER23, },
> +       { "xdp_bonding_xor_layer34", BOND_MODE_XOR, BOND_XMIT_POLICY_LAYER34, },
> +};
> +
> +void test_xdp_bonding(void)

this should be the only non-static function in this file, please fix
all the functions above

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
> +       test_xdp_bonding_attach(&skeletons);

check for errors

> +
> +       for (i = 0; i < ARRAY_SIZE(bond_test_cases); i++) {
> +               struct bond_test_case *test_case = &bond_test_cases[i];
> +
> +               test_xdp_bonding_with_mode(
> +                       &skeletons,
> +                       test_case->name,
> +                       test_case->mode,
> +                       test_case->xmit_policy);
> +       }
> +
> +       test_xdp_bonding_redirect_multi(&skeletons);
> +
> +out:
> +       if (skeletons.xdp_dummy)
> +               xdp_dummy__destroy(skeletons.xdp_dummy);
> +       if (skeletons.xdp_tx)
> +               xdp_tx__destroy(skeletons.xdp_tx);
> +       if (skeletons.xdp_redirect_multi_kern)
> +               xdp_redirect_multi_kern__destroy(skeletons.xdp_redirect_multi_kern);

similarly, all libbpf destructors handle NULL and error pointers
cleanly, no need for extra ifs


> +
> +       libbpf_set_print(old_print_fn);
> +       if (root_netns_fd)
> +               close(root_netns_fd);
> +}
> --
> 2.17.1
>
