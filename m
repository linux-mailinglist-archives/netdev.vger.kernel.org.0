Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11424DE2F3
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240878AbiCRUzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240879AbiCRUyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:54:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B903F13E8C;
        Fri, 18 Mar 2022 13:53:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B639360C97;
        Fri, 18 Mar 2022 20:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2620EC340F0;
        Fri, 18 Mar 2022 20:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647636800;
        bh=TjVN2fp278eXriOI9SR6DI17Nzf6AbyB2oL/GOkjMSU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LE7IkSJtJcvUA9l8s14Eua2UjZusYTTGAlsXevOO/KVns3P9Yf6HsQ15xvXRFLgLB
         Fvefv1LIARd8obBDjgUiRbGOOD/drHgtBiL7kAg6kWLR9tjywlClzu0RxRPg7DXd6Q
         cWx+kXvVgzxlXnt+uDKO3Vb5z5dd8ms5AyLti37yKGgsywjFR3s73XlRuJzF1xUTyU
         C9I/GlBpSDI6FQLnKVZ4y4LdM8lK66290i+CTqynYAcVZj4TK5lTVsThZL501tAmrP
         gsSq0Dd4xxF9MwlRr7cuysEWzSP6iGyWhwsQEwG8ym9/A5jyE/SMk71Kngy3r1SroV
         0A5KjqLjGz8nQ==
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-2e5757b57caso103580397b3.4;
        Fri, 18 Mar 2022 13:53:20 -0700 (PDT)
X-Gm-Message-State: AOAM531WJ5FBgcSM5ojDk0ajhDkKsbkxo0zQIJd3aeDc6iV5PYNHRlTP
        TMsCsDKcAvDh5bB7synoQs6AczMaCXe7Vb0NzSU=
X-Google-Smtp-Source: ABdhPJyVyC2ZLXg4kmlJFxKJg2KyYONhq97Iuh52wagVWeUp3bDUvJMgQJ6vRVLcXY98856NjnhNNUNcFUI6YJdkoRQ=
X-Received: by 2002:a81:951:0:b0:2e5:9e38:147c with SMTP id
 78-20020a810951000000b002e59e38147cmr13231148ywj.211.1647636799151; Fri, 18
 Mar 2022 13:53:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com> <20220318161528.1531164-5-benjamin.tissoires@redhat.com>
In-Reply-To: <20220318161528.1531164-5-benjamin.tissoires@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 18 Mar 2022 13:53:08 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7k2Z-Kex2wbBxUqC9xCi55U-Y7LHDkEGnU_BRfuf0AKg@mail.gmail.com>
Message-ID: <CAPhsuW7k2Z-Kex2wbBxUqC9xCi55U-Y7LHDkEGnU_BRfuf0AKg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 04/17] libbpf: add HID program type and API
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 9:18 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> HID-bpf program type are needing new SECs.
> To bind a hid-bpf program, we can rely on bpf_program__attach_fd()
> so export a new function to the API.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Acked-by: Song Liu <songliubraving@fb.com>
>
> ---
>
> changes in v3:
> - squashed the libbpf changes into 1
> - moved bpf_program__attach_hid to 0.8.0
> - added SEC_DEF("hid/driver_event")
>
> changes in v2:
> - split the series by bpf/libbpf/hid/selftests and samples
> ---
>  tools/include/uapi/linux/bpf.h | 31 +++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.c         | 23 +++++++++++++++++------
>  tools/lib/bpf/libbpf.h         |  2 ++
>  tools/lib/bpf/libbpf.map       |  1 +
>  4 files changed, 51 insertions(+), 6 deletions(-)
>
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 99fab54ae9c0..0e8438e93768 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -952,6 +952,7 @@ enum bpf_prog_type {
>         BPF_PROG_TYPE_LSM,
>         BPF_PROG_TYPE_SK_LOOKUP,
>         BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
> +       BPF_PROG_TYPE_HID,
>  };
>
>  enum bpf_attach_type {
> @@ -997,6 +998,10 @@ enum bpf_attach_type {
>         BPF_SK_REUSEPORT_SELECT,
>         BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
>         BPF_PERF_EVENT,
> +       BPF_HID_DEVICE_EVENT,
> +       BPF_HID_RDESC_FIXUP,
> +       BPF_HID_USER_EVENT,
> +       BPF_HID_DRIVER_EVENT,
>         __MAX_BPF_ATTACH_TYPE
>  };
>
> @@ -1011,6 +1016,7 @@ enum bpf_link_type {
>         BPF_LINK_TYPE_NETNS = 5,
>         BPF_LINK_TYPE_XDP = 6,
>         BPF_LINK_TYPE_PERF_EVENT = 7,
> +       BPF_LINK_TYPE_HID = 8,
>
>         MAX_BPF_LINK_TYPE,
>  };
> @@ -1118,6 +1124,16 @@ enum bpf_link_type {
>   */
>  #define BPF_F_XDP_HAS_FRAGS    (1U << 5)
>
> +/* HID flag used in BPF_LINK_CREATE command
> + *
> + * NONE(default): The bpf program will be added at the tail of the list
> + * of existing bpf program for this type.
> + *
> + * BPF_F_INSERT_HEAD: The bpf program will be added at the beginning
> + * of the list of existing bpf program for this type..
> + */
> +#define BPF_F_INSERT_HEAD      (1U << 0)
> +
>  /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
>   * the following extensions:
>   *
> @@ -5129,6 +5145,16 @@ union bpf_attr {
>   *             The **hash_algo** is returned on success,
>   *             **-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
>   *             invalid arguments are passed.
> + *
> + * void *bpf_hid_get_data(void *ctx, u64 offset, u64 size)
> + *     Description
> + *             Returns a pointer to the data associated with context at the given
> + *             offset and size (in bytes).
> + *
> + *             Note: the returned pointer is refcounted and must be dereferenced
> + *             by a call to bpf_hid_discard;
> + *     Return
> + *             The pointer to the data. On error, a null value is returned.
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -5325,6 +5351,7 @@ union bpf_attr {
>         FN(copy_from_user_task),        \
>         FN(skb_set_tstamp),             \
>         FN(ima_file_hash),              \
> +       FN(hid_get_data),               \
>         /* */
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> @@ -5925,6 +5952,10 @@ struct bpf_link_info {
>                 struct {
>                         __u32 ifindex;
>                 } xdp;
> +               struct  {
> +                       __s32 hidraw_number;
> +                       __u32 attach_type;
> +               } hid;
>         };
>  } __attribute__((aligned(8)));
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 43161fdd44bb..6b9ba313eb5b 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -8675,6 +8675,10 @@ static const struct bpf_sec_def section_defs[] = {
>         SEC_DEF("cgroup/setsockopt",    CGROUP_SOCKOPT, BPF_CGROUP_SETSOCKOPT, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
>         SEC_DEF("struct_ops+",          STRUCT_OPS, 0, SEC_NONE),
>         SEC_DEF("sk_lookup",            SK_LOOKUP, BPF_SK_LOOKUP, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
> +       SEC_DEF("hid/device_event",     HID, BPF_HID_DEVICE_EVENT, SEC_ATTACHABLE_OPT),
> +       SEC_DEF("hid/rdesc_fixup",      HID, BPF_HID_RDESC_FIXUP, SEC_ATTACHABLE_OPT),
> +       SEC_DEF("hid/user_event",       HID, BPF_HID_USER_EVENT, SEC_ATTACHABLE_OPT),
> +       SEC_DEF("hid/driver_event",     HID, BPF_HID_DRIVER_EVENT, SEC_ATTACHABLE_OPT),
>  };
>
>  static size_t custom_sec_def_cnt;
> @@ -10630,10 +10634,11 @@ static int attach_lsm(const struct bpf_program *prog, long cookie, struct bpf_li
>
>  static struct bpf_link *
>  bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, int btf_id,
> -                      const char *target_name)
> +                      const char *target_name, __u32 flags)
>  {
>         DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
> -                           .target_btf_id = btf_id);
> +                           .target_btf_id = btf_id,
> +                           .flags = flags);
>         enum bpf_attach_type attach_type;
>         char errmsg[STRERR_BUFSIZE];
>         struct bpf_link *link;
> @@ -10667,19 +10672,19 @@ bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, int btf_id
>  struct bpf_link *
>  bpf_program__attach_cgroup(const struct bpf_program *prog, int cgroup_fd)
>  {
> -       return bpf_program__attach_fd(prog, cgroup_fd, 0, "cgroup");
> +       return bpf_program__attach_fd(prog, cgroup_fd, 0, "cgroup", 0);
>  }
>
>  struct bpf_link *
>  bpf_program__attach_netns(const struct bpf_program *prog, int netns_fd)
>  {
> -       return bpf_program__attach_fd(prog, netns_fd, 0, "netns");
> +       return bpf_program__attach_fd(prog, netns_fd, 0, "netns", 0);
>  }
>
>  struct bpf_link *bpf_program__attach_xdp(const struct bpf_program *prog, int ifindex)
>  {
>         /* target_fd/target_ifindex use the same field in LINK_CREATE */
> -       return bpf_program__attach_fd(prog, ifindex, 0, "xdp");
> +       return bpf_program__attach_fd(prog, ifindex, 0, "xdp", 0);
>  }
>
>  struct bpf_link *bpf_program__attach_freplace(const struct bpf_program *prog,
> @@ -10705,7 +10710,7 @@ struct bpf_link *bpf_program__attach_freplace(const struct bpf_program *prog,
>                 if (btf_id < 0)
>                         return libbpf_err_ptr(btf_id);
>
> -               return bpf_program__attach_fd(prog, target_fd, btf_id, "freplace");
> +               return bpf_program__attach_fd(prog, target_fd, btf_id, "freplace", 0);
>         } else {
>                 /* no target, so use raw_tracepoint_open for compatibility
>                  * with old kernels
> @@ -10760,6 +10765,12 @@ static int attach_iter(const struct bpf_program *prog, long cookie, struct bpf_l
>         return libbpf_get_error(*link);
>  }
>
> +struct bpf_link *
> +bpf_program__attach_hid(const struct bpf_program *prog, int hid_fd, __u32 flags)
> +{
> +       return bpf_program__attach_fd(prog, hid_fd, 0, "hid", flags);
> +}
> +
>  struct bpf_link *bpf_program__attach(const struct bpf_program *prog)
>  {
>         struct bpf_link *link = NULL;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index c1b0c2ef14d8..13dff4865da5 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -529,6 +529,8 @@ struct bpf_iter_attach_opts {
>  LIBBPF_API struct bpf_link *
>  bpf_program__attach_iter(const struct bpf_program *prog,
>                          const struct bpf_iter_attach_opts *opts);
> +LIBBPF_API struct bpf_link *
> +bpf_program__attach_hid(const struct bpf_program *prog, int hid_fd, __u32 flags);
>
>  /*
>   * Libbpf allows callers to adjust BPF programs before being loaded
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index df1b947792c8..cd8da9a8bf36 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -442,6 +442,7 @@ LIBBPF_0.7.0 {
>
>  LIBBPF_0.8.0 {
>         global:
> +               bpf_program__attach_hid;
>                 libbpf_register_prog_handler;
>                 libbpf_unregister_prog_handler;
>  } LIBBPF_0.7.0;
> --
> 2.35.1
>
