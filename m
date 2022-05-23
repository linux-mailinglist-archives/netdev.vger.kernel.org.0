Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7463531F40
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 01:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiEWXeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 19:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiEWXeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 19:34:00 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E1F77F24;
        Mon, 23 May 2022 16:33:59 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id o16so10852410ilq.8;
        Mon, 23 May 2022 16:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=476l4F/D25kQOCryGZZoOaZyzK6uQ7tT24Y3edD6ytI=;
        b=QYNFBhlOZzxOA0oFygMpe3R/z8AYqTAZ1vkPJN8POkpHrqk0VkRxICzbXRXp4sjpUi
         mcPLquXexRiaYq8Te00XrSiVXVZ/I/D1H9kOLmfxbUv+NEABVExd+RK+JfnvboKRNbdI
         WiH2c6SzLGFJGQPA2cQrkYGnLqzp7oft7jO67w8hKxX81IdC5uBBtZpUZq78oxjD/StS
         807YuSIOt6u87B3SgLOBvHlgcFse9c+3DLz6Tb/AGaSJ4u/o179Qz3cH0IYAn2U41aSJ
         g9IGo0JPdWJ8vUtT7V1OiRlRS0jDBGTPAZhArLywOj1LkJb/KSNVR0hjsb7oDzG7/NFG
         swqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=476l4F/D25kQOCryGZZoOaZyzK6uQ7tT24Y3edD6ytI=;
        b=YiWDgu/9ou/WMu1qe/2uo/OtYUpQW/FNoPICm/DAOLQHKM2roe+yVoSDuUwc9TE5zz
         A2bchyEWVhL2LIgtMjLQ0jQALtLttKcxFIHf7uxwOyyuTjLXtnjYgVFUUBGZGQOpLI+9
         2hyxt3c3SaAbR2El6RPqMEza+0PfX541bz3vMRF+a4YEwyC8Tf3y+addN2yxC3+VL5of
         HYU8bHl3W8BuFdxV9wnU38tR2pkEj0K+dXe0RgWY4GluUemKazNhlFRaTTfuob39I2qm
         /5z1JFoMUuIL0i7fyQGYRhUoDzg1V4WML79Q8NSUsrblESZGIM2x53EHKpH+ABGSX6jD
         9deQ==
X-Gm-Message-State: AOAM53346kA6OahvETIR/y4hQ3LsRhAywKH9ASDwqVNqHFzMUTohjugK
        UO4Ih8CiSSIaQ2XuR4R3TI8bv3lAMtpUJCdRX58=
X-Google-Smtp-Source: ABdhPJywvhrHXotPmsWNBsR0ADXyhG7BWADyrBZFQCJTCydL6Msq2a+bhDph78pmFIkUeqVtrAh35dnQf/zVTAin0i0=
X-Received: by 2002:a05:6e02:1352:b0:2d1:6424:60b8 with SMTP id
 k18-20020a056e02135200b002d1642460b8mr11873417ilr.305.1653348838757; Mon, 23
 May 2022 16:33:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com> <20220518225531.558008-12-sdf@google.com>
In-Reply-To: <20220518225531.558008-12-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 May 2022 16:33:47 -0700
Message-ID: <CAEf4BzaG2bOcyVfGZxcNU1p8i0Xipez7v-789bq8qYDE1Ce-sQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 11/11] selftests/bpf: verify lsm_cgroup struct
 sock access
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
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

On Wed, May 18, 2022 at 3:56 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> sk_priority & sk_mark are writable, the rest is readonly.
>
> One interesting thing here is that the verifier doesn't
> really force me to add NULL checks anywhere :-/
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  .../selftests/bpf/prog_tests/lsm_cgroup.c     | 69 +++++++++++++++++++
>  1 file changed, 69 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c b/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
> index 29292ec40343..64b6830e03f5 100644
> --- a/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
> +++ b/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
> @@ -270,8 +270,77 @@ static void test_lsm_cgroup_functional(void)
>         lsm_cgroup__destroy(skel);
>  }
>
> +static int field_offset(const char *type, const char *field)
> +{
> +       const struct btf_member *memb;
> +       const struct btf_type *tp;
> +       const char *name;
> +       struct btf *btf;
> +       int btf_id;
> +       int i;
> +
> +       btf = btf__load_vmlinux_btf();
> +       if (!btf)
> +               return -1;
> +
> +       btf_id = btf__find_by_name_kind(btf, type, BTF_KIND_STRUCT);
> +       if (btf_id < 0)
> +               return -1;
> +
> +       tp = btf__type_by_id(btf, btf_id);
> +       memb = btf_members(tp);
> +
> +       for (i = 0; i < btf_vlen(tp); i++) {
> +               name = btf__name_by_offset(btf,
> +                                          memb->name_off);
> +               if (strcmp(field, name) == 0)
> +                       return memb->offset / 8;
> +               memb++;
> +       }
> +
> +       return -1;
> +}
> +
> +static bool sk_writable_field(const char *type, const char *field, int size)
> +{
> +       LIBBPF_OPTS(bpf_prog_load_opts, opts,
> +                   .expected_attach_type = BPF_LSM_CGROUP);
> +       struct bpf_insn insns[] = {
> +               /* r1 = *(u64 *)(r1 + 0) */
> +               BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, 0),
> +               /* r1 = *(u64 *)(r1 + offsetof(struct socket, sk)) */
> +               BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, field_offset("socket", "sk")),
> +               /* r2 = *(u64 *)(r1 + offsetof(struct sock, <field>)) */
> +               BPF_LDX_MEM(size, BPF_REG_2, BPF_REG_1, field_offset(type, field)),
> +               /* *(u64 *)(r1 + offsetof(struct sock, <field>)) = r2 */
> +               BPF_STX_MEM(size, BPF_REG_1, BPF_REG_2, field_offset(type, field)),
> +               BPF_MOV64_IMM(BPF_REG_0, 1),
> +               BPF_EXIT_INSN(),
> +       };
> +       int fd;

This is really not much better than test_verifier assembly. What I had
in mind when I was suggesting to use test_progs was that you'd have a
normal C source code for BPF part, something like this:

__u64 tmp;

SEC("?lsm_cgroup/socket_bind")
int BPF_PROG(access1_bad, struct socket *sock, struct sockaddr
*address, int addrlen)
{
    *(volatile u16 *)(sock->sk.skc_family) = *(volatile u16
*)sock->sk.skc_family;
    return 0;
}


SEC("?lsm_cgroup/socket_bind")
int BPF_PROG(access2_bad, struct socket *sock, struct sockaddr
*address, int addrlen)
{
    *(volatile u64 *)(sock->sk.sk_sndtimeo) = *(volatile u64
*)sock->sk.sk_sndtimeo;
    return 0;
}

and so on. From user-space you'd be loading just one of those
accessX_bad programs at a time (note SEC("?"))


But having said that, what you did is pretty self-contained, so not
too bad. It's just not what I was suggesting :)

> +
> +       opts.attach_btf_id = libbpf_find_vmlinux_btf_id("socket_post_create",
> +                                                       opts.expected_attach_type);
> +
> +       fd = bpf_prog_load(BPF_PROG_TYPE_LSM, NULL, "GPL", insns, ARRAY_SIZE(insns), &opts);
> +       if (fd >= 0)
> +               close(fd);
> +       return fd >= 0;
> +}
> +
> +static void test_lsm_cgroup_access(void)
> +{
> +       ASSERT_FALSE(sk_writable_field("sock_common", "skc_family", BPF_H), "skc_family");
> +       ASSERT_FALSE(sk_writable_field("sock", "sk_sndtimeo", BPF_DW), "sk_sndtimeo");
> +       ASSERT_TRUE(sk_writable_field("sock", "sk_priority", BPF_W), "sk_priority");
> +       ASSERT_TRUE(sk_writable_field("sock", "sk_mark", BPF_W), "sk_mark");
> +       ASSERT_FALSE(sk_writable_field("sock", "sk_pacing_rate", BPF_DW), "sk_pacing_rate");
> +}
> +
>  void test_lsm_cgroup(void)
>  {
>         if (test__start_subtest("functional"))
>                 test_lsm_cgroup_functional();
> +       if (test__start_subtest("access"))
> +               test_lsm_cgroup_access();
>  }
> --
> 2.36.1.124.g0e6072fb45-goog
>
