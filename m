Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F20A1B51C2
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 03:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgDWBTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 21:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725961AbgDWBTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 21:19:16 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39784C03C1AA
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 18:19:15 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id m67so4679247qke.12
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 18:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nsJdeAag8h2cHo3nuAcibmhgXqyJ/BuS73qv2gqhvjo=;
        b=SrSVKOoSODWdwXdSrkQTJ/dHCDKjPV5Ayssr7Wl8Rz723qahOdAAfPMTaWAWwGLb6W
         xwaTgECkM54DoHA7FLANAtgOGO7ladh4tAR1LX8OD8LlNbLXfoWG+2iiK9jlrwxpbm+g
         Zn0BH9NslEMvSCITmftfqpqZzYBhgpFE4FtH7RizttKnZrulhWF1CD4yePysPTMkEIIa
         3rCkxCLms92v+GqwCFGnEmowt6NHVRoNLqXdbYDo0BxaGd2ZP6jIxIkfAwlF1artjNca
         Mj/pOIAcn2cU5adrsfYSDT6f9TsP84b+0a3TFnZTwg9bSbAcguWk0WSYyYr+1uQ0wI9f
         4i1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nsJdeAag8h2cHo3nuAcibmhgXqyJ/BuS73qv2gqhvjo=;
        b=dq8OZrqUCXnQ5ep6DCZB9W11ohlGfOWsk4E/FznGINmBDlBtG5nFTkzP9ElyFD1RbL
         nFOeGjpsCT0OHC3A7mNRBGr/1WGRmTW82zRtifwb6xpIEA1nmyhHMNYd+ZLeEAxYO/L7
         ua7HdP7Y1hTehA0UFh/s7FRj8C8fc854NL2VPVKrbkPFmyN1nNpWRj3NCQ/ZYG7nrlkK
         lVroJRn6pRUwJbmSFLok5DgUROq2/t/bfs+9dbqk8yC3cM/fe0pTtassGNCm/R6FrWG0
         msyh/kzg2OnacgBOS/eK5pUesLYVEkjdmd4OQk+cJTqgKijpCHL2qJOsrTpKdNgEQwTU
         +s/w==
X-Gm-Message-State: AGi0PuYE+GqfXTAgHU4Tx1PwkcOrWvqIo8y53c6V2XTYPOA/2yRp8c4+
        lQ4FgePcVhDcXKpryDzTfs7CQ/z5OEB75LZOhrI=
X-Google-Smtp-Source: APiQypIXwUayf7P2o06Nl6scuTt05C7FA7p/Gy2wbe6IbK9MyAuBPMQ6bbz0/2UvsAh/hsjRHWJJcHfqX2XZ0wwv/6E=
X-Received: by 2002:a37:787:: with SMTP id 129mr1228051qkh.92.1587604754375;
 Wed, 22 Apr 2020 18:19:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200420200055.49033-1-dsahern@kernel.org> <20200420200055.49033-13-dsahern@kernel.org>
In-Reply-To: <20200420200055.49033-13-dsahern@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 22 Apr 2020 18:19:03 -0700
Message-ID: <CAEf4Bzb1Zu1pYvPm+UhT9v7JVBjxOhABA9-fVEza=p0Wpr4e9Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 12/16] libbpf: Add egress XDP support
To:     David Ahern <dsahern@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        David Ahern <dsahern@gmail.com>,
        David Ahern <dahern@digitalocean.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 1:02 PM David Ahern <dsahern@kernel.org> wrote:
>
> From: David Ahern <dahern@digitalocean.com>
>
> Patch adds egress XDP support in libbpf.
>
> New section name hint, xdp_egress, is added to set expected attach
> type at program load. Programs can use xdp_egress as the prefix in
> the SEC statement to load the program with the BPF_XDP_EGRESS
> attach type set.
>
> egress is added to bpf_xdp_set_link_opts to specify egress type for
> use with bpf_set_link_xdp_fd_opts. Update library side to check
> for flag and set nla_type to IFLA_XDP_EGRESS.
>
> Add egress version of bpf_get_link_xdp* info and id apis with core
> code refactored to handle both rx and tx paths.
>
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> Co-developed-by: David Ahern <dahern@digitalocean.com>
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> ---
>  tools/lib/bpf/libbpf.c   |  2 ++
>  tools/lib/bpf/libbpf.h   |  9 +++++-
>  tools/lib/bpf/libbpf.map |  2 ++
>  tools/lib/bpf/netlink.c  | 63 +++++++++++++++++++++++++++++++++++-----
>  4 files changed, 67 insertions(+), 9 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 8f480e29a6b0..32fc970495d9 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -6366,6 +6366,8 @@ static const struct bpf_sec_def section_defs[] = {
>                 .is_attach_btf = true,
>                 .expected_attach_type = BPF_LSM_MAC,
>                 .attach_fn = attach_lsm),
> +       BPF_EAPROG_SEC("xdp_egress",            BPF_PROG_TYPE_XDP,
> +                                               BPF_XDP_EGRESS),
>         BPF_PROG_SEC("xdp",                     BPF_PROG_TYPE_XDP),
>         BPF_PROG_SEC("perf_event",              BPF_PROG_TYPE_PERF_EVENT),
>         BPF_PROG_SEC("lwt_in",                  BPF_PROG_TYPE_LWT_IN),
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index f1dacecb1619..3feb1242f78e 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -453,14 +453,16 @@ struct xdp_link_info {
>         __u32 drv_prog_id;
>         __u32 hw_prog_id;
>         __u32 skb_prog_id;
> +       __u32 egress_core_prog_id;

This changes layout of struct xdp_link_info in ABI-breaking way. New
fields have to be added at the end.

>         __u8 attach_mode;
>  };
>
>  struct bpf_xdp_set_link_opts {
>         size_t sz;
>         int old_fd;
> +       __u8  egress;

Is this a true/false field? If yes, why not bool then?

>  };
> -#define bpf_xdp_set_link_opts__last_field old_fd
> +#define bpf_xdp_set_link_opts__last_field egress
>
>  LIBBPF_API int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags);
>  LIBBPF_API int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,
> @@ -468,6 +470,11 @@ LIBBPF_API int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,
>  LIBBPF_API int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags);
>  LIBBPF_API int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
>                                      size_t info_size, __u32 flags);
> +LIBBPF_API int bpf_get_link_xdp_egress_id(int ifindex, __u32 *prog_id,
> +                                         __u32 flags);
> +LIBBPF_API int bpf_get_link_xdp_egress_info(int ifindex,
> +                                           struct xdp_link_info *info,
> +                                           size_t info_size, __u32 flags);
>
>  struct perf_buffer;
>
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index bb8831605b25..51576c8a02fe 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -253,4 +253,6 @@ LIBBPF_0.0.8 {
>                 bpf_program__set_attach_target;
>                 bpf_program__set_lsm;
>                 bpf_set_link_xdp_fd_opts;
> +               bpf_get_link_xdp_egress_id;
> +               bpf_get_link_xdp_egress_info;

This should go into 0.0.9 section, 0.0.8 is sealed now.

>  } LIBBPF_0.0.7;

[...]

> @@ -203,6 +204,7 @@ static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
>  int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,
>                              const struct bpf_xdp_set_link_opts *opts)
>  {
> +       __u16 nla_type = IFLA_XDP;
>         int old_fd = -1;
>
>         if (!OPTS_VALID(opts, bpf_xdp_set_link_opts))
> @@ -213,14 +215,22 @@ int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,
>                 flags |= XDP_FLAGS_REPLACE;
>         }
>
> +       if (OPTS_HAS(opts, egress)) {

I don't think you need to check OPTS_HAS here, just OPTS_GET with
proper default would work.

> +               __u8 egress = OPTS_GET(opts, egress, 0);
> +
> +               if (egress)
> +                       nla_type = IFLA_XDP_EGRESS;
> +       }
> +
>         return __bpf_set_link_xdp_fd_replace(ifindex, fd,
>                                              old_fd,
> -                                            flags);
> +                                            flags,

nit: old_fd, flags fit on the same line as ifindex, fd, not sure why
there are so many lines for this?

> +                                            nla_type);
>  }
>
>  int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
>  {
> -       return __bpf_set_link_xdp_fd_replace(ifindex, fd, 0, flags);
> +       return __bpf_set_link_xdp_fd_replace(ifindex, fd, 0, flags, IFLA_XDP);
>  }
>

[...]

>
> +int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
> +                         size_t info_size, __u32 flags)
> +{
> +       return __bpf_get_link_xdp_info(ifindex, info, info_size, flags,
> +                                      IFLA_XDP);
> +}
> +
> +int bpf_get_link_xdp_egress_info(int ifindex, struct xdp_link_info *info,
> +                                size_t info_size, __u32 flags)
> +{
> +       return __bpf_get_link_xdp_info(ifindex, info, info_size, flags,
> +                                      IFLA_XDP_EGRESS);
> +}
> +
>  static __u32 get_xdp_id(struct xdp_link_info *info, __u32 flags)
>  {
>         if (info->attach_mode != XDP_ATTACHED_MULTI && !flags)
> @@ -345,6 +376,22 @@ int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
>         return ret;
>  }
>
> +int bpf_get_link_xdp_egress_id(int ifindex, __u32 *prog_id, __u32 flags)

Is bpf_get_link_xdp_egress_id() even needed? This is a special case of
bpf_get_link_xdp_egress_info(), I don't think we have to add another
API to support it specifically.

Also, just curious, would it be better to have a generalized
XDP/XDP_EGRESS xdp_info() functions instead of two separate ones?
Could there be some third variant of XDP program later, whatever that
might be?

> +{
> +       struct xdp_link_info info;
> +       int ret;
> +
> +       /* egress path does not support SKB, DRV or HW mode */
> +       if (flags & XDP_FLAGS_MODES)
> +               return -EINVAL;
> +
> +       ret = bpf_get_link_xdp_egress_info(ifindex, &info, sizeof(info), flags);
> +       if (!ret)
> +               *prog_id = get_xdp_id(&info, flags);
> +
> +       return ret;
> +}
> +
>  int libbpf_nl_get_link(int sock, unsigned int nl_pid,
>                        libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie)
>  {
> --
> 2.21.1 (Apple Git-122.3)
>
