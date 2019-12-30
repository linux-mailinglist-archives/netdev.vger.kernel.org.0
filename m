Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B22C812CC4F
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 05:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfL3EuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Dec 2019 23:50:05 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36998 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfL3EuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 23:50:04 -0500
Received: by mail-qk1-f194.google.com with SMTP id 21so25584672qky.4
        for <netdev@vger.kernel.org>; Sun, 29 Dec 2019 20:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PNEHg64lAH1riDAV6nwWHYGPK/Wr8anQGySmb0UmVIM=;
        b=SS1iLRaAQERqtkacbTFdU3+t+XbjxDysoTYL3IAhzBvTLts0G26Y4ojistd5y36f8Q
         1saOS6gGMN9LJ2ir5+u2ORIJvEFFAenkq4onsKZhhglyxeK4gQjVFphPyagjSWPM/f3K
         FDTAC/M156YFlS1btkWJwzfrgsVkvJPTootP6jPZFoXQYqOHPwrjVhkvz0Nb9hyO2+X7
         W44MrBfW2Qgwj4Sp+ukVhQkgoUzydolSb9Sij3d34Ygy3N4NjMDGzOIEHBXBEVEDyr5J
         N/4iUpwhD39rxayCdmhoeoZib+rcgQrlbCv90F7bzLxNyXe6gf6ID/JKDL8ivJb8ot25
         /hKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PNEHg64lAH1riDAV6nwWHYGPK/Wr8anQGySmb0UmVIM=;
        b=Zq0MA0rkhc8ySuyeE0tXThXBqVd0A1mSZfr2cHRfyKcCH85FyfjcJEXUuDZuCqt0Hb
         a7M0pZHBbXoJc4C5ROlhK1tO83DHfgPAC2EnqHWhahO44gPOOnCTbN5YxoJ8dVKDcbzR
         ftRWhSGibu4ek9y4xjVn0FgmBKitmuwpzylYPdfNc6TtTbyE0uXaShZVY3wJaumfjUz6
         Rtq1bPmJgLUV2BLphat12qk9CZ/cRaDwJoS65j7Qzn/xm6qct8PPh1dG+5ccEObRo0JB
         a4zlMkrLk9fYWvcfLbUHGZ8AHnCpaKNBBp3AaLH8A2y86xvzsEsuPXdCZRAbGNgK7NiY
         ZK1Q==
X-Gm-Message-State: APjAAAVS/8hsLKcUIk6t4NKLGTB6uxNLimT6frIfA1pi6KuIBK7w6BBb
        rv2pzXggiA5/a8ORCQJRunY/kaS1bWNbPGP7V18=
X-Google-Smtp-Source: APXvYqzcp8/TlqxoPBOYLLTSaY3klDFrgWynCS6td/zfebKpv+75/WZVRORuMPfP33NRurBhyclkHgb8Zyg241MyV4Y=
X-Received: by 2002:a05:620a:14a2:: with SMTP id x2mr54019729qkj.36.1577681403910;
 Sun, 29 Dec 2019 20:50:03 -0800 (PST)
MIME-Version: 1.0
References: <20191226023200.21389-1-prashantbhole.linux@gmail.com> <20191226023200.21389-4-prashantbhole.linux@gmail.com>
In-Reply-To: <20191226023200.21389-4-prashantbhole.linux@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 29 Dec 2019 20:49:52 -0800
Message-ID: <CAEf4Bza=AT5NcBkQnJucgY5+QfkQTVX_S2CfiV6o6p_oGrr=ng@mail.gmail.com>
Subject: Re: [RFC v2 net-next 03/12] libbpf: api for getting/setting link xdp options
To:     Prashant Bhole <prashantbhole.linux@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 25, 2019 at 6:34 PM Prashant Bhole
<prashantbhole.linux@gmail.com> wrote:
>
> This patch introduces and uses new APIs:
>
> struct bpf_link_xdp_opts {
>         struct xdp_link_info *link_info;
>         size_t link_info_sz;
>         __u32 flags;
>         __u32 prog_id;
>         int prog_fd;
> };

Please see the usage of DECLARE_LIBBPF_OPTS and OPTS_VALID/OPTS_GET
(e.g., in bpf_object__open_file). This also seems like a rather
low-level API, so might be more appropriate to follow the naming of
low-level API in bpf.h (see Andrey Ignatov's recent
bpf_prog_attach_xattr() changes).

As is this is not backwards/forward compatible, unless you use
LIBBPF_OPTS approach (that's what Alexei meant).


>
> enum bpf_link_cmd {
>         BPF_LINK_GET_XDP_INFO,
>         BPF_LINK_GET_XDP_ID,
>         BPF_LINK_SET_XDP_FD,
> };
>
> int bpf_get_link_opts(int ifindex, struct bpf_link_xdp_opts *opts,
>                       enum bpf_link_cmd cmd);
> int bpf_set_link_opts(int ifindex, struct bpf_link_xdp_opts *opts,
>                       enum bpf_link_cmd cmd);
>
> The operations performed by these two functions are equivalent to
> existing APIs.
>
> BPF_LINK_GET_XDP_ID equivalent to bpf_get_link_xdp_id()
> BPF_LINK_SET_XDP_FD equivalent to bpf_set_link_xdp_fd()
> BPF_LINK_GET_XDP_INFO equivalent to bpf_get_link_xdp_info()
>
> It will be easy to extend this API by adding members in struct
> bpf_link_xdp_opts and adding different operations. Next patch
> will extend this API to set XDP program in the tx path.

Not really, and this has been extensively discussed previously. One of
the problems is old user code linked against newer libbpf version
(shared library). New libbpf will assume struct with more fields,
while old user code will provide too short struct. That's why all the
LIBBPF_OPTS stuff.

>
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> ---
>  tools/lib/bpf/libbpf.h   | 36 +++++++++++++++++++
>  tools/lib/bpf/libbpf.map |  2 ++
>  tools/lib/bpf/netlink.c  | 77 ++++++++++++++++++++++++++++++++++++----
>  3 files changed, 109 insertions(+), 6 deletions(-)
>

[...]
