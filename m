Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1539EAAE8
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 08:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbfJaHRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 03:17:24 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37484 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbfJaHRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 03:17:23 -0400
Received: by mail-ot1-f66.google.com with SMTP id 53so4510722otv.4;
        Thu, 31 Oct 2019 00:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ozIcHNKQPT34dQ3NZXK+RxDfQHDIKDpKM/sQ109e9Z8=;
        b=aInMRLO2Sp0fQvkSt1Ml71wOsd8wlGs3KN6WOVA9lIPKUJNPr+PZA+BQFbo3XEIMIC
         dIQv6M2qMeRUkrqYAii3WFRjRFYcrtYE+ikqja9m/tN5MoWkLMncyzX4id1cTaUNdaOl
         P8EHk/5BdSD3J3jo1Mh3YCqmOF8iFm1+qckER5b6dvN02tomPj2FbTGguh7p0xpeVK6M
         1u8Rmpdya9vLEtivObvIZNEnK7WVW0QGame6SRB0c1z0X8AkPkqiYeCkNGcP0Sl1p1Sz
         V6qD8ufbhnuqnYgVsqt/9rA2XKxopiBPuYEAVgPtmiKiAWGwFnOssL54Yn9Fy78YB+/9
         ExZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ozIcHNKQPT34dQ3NZXK+RxDfQHDIKDpKM/sQ109e9Z8=;
        b=tf1VZtwOTgnpLwuNiKWrJCfTCzkSTKAVB7OnQqMGA1TAL/hsvbDmO04u0C9vivLCtQ
         bBPlQ1s0c5l4q1jjGfZvp9E1acHthwfrmY3ptECzV1Hi81scCH2eC+Kgkh/EIFz/TBWh
         /h7SMA1Fi/gSl2pHq8Tkusyx1FItIg0SziOa7nu2aX3i2RSX4CBcLvrHDdh94eC4krqP
         86j/WObIX/XMK1TwDhDJv7WTkq/x0K9ZAgqGAfVrSuw+jT5bN7sKRkNqn086EKBmsT5I
         80ws6TKkKiQi9KD77GF3VcBD9xJ9ofbkKk27jbyh8lBgv7NYGgYWIA0M8WR2ddhcC5s5
         I/2A==
X-Gm-Message-State: APjAAAUQ2XYMSlJs9LHv8K8YckpKfcpMWsuJ5lF8GI8wYEsvFLDEvLvE
        kT+bngkjpwgvqdqfuHIPlYg2YXpmoJprk1GZqZg=
X-Google-Smtp-Source: APXvYqy1k6uuFBQQoVwPp7kEZkwZEHOmwq3hKgDJNuEFzArfJ+i2JORRk1UTZ5eB4UcgD14PzwGhEGuiDvs3eKUoHPA=
X-Received: by 2002:a9d:286:: with SMTP id 6mr3352540otl.192.1572506242264;
 Thu, 31 Oct 2019 00:17:22 -0700 (PDT)
MIME-Version: 1.0
References: <1571995035-21889-1-git-send-email-magnus.karlsson@intel.com> <87tv7qpdbt.fsf@toke.dk>
In-Reply-To: <87tv7qpdbt.fsf@toke.dk>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 31 Oct 2019 08:17:11 +0100
Message-ID: <CAJ8uoz3BPA41wmT8-Jhhs=kJ=GbsAswSvx2pEmuWJDvh+b+_yw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: fix compatibility for kernels without need_wakeup
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, degeneloy@gmail.com,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 2:36 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Magnus Karlsson <magnus.karlsson@intel.com> writes:
>
> > When the need_wakeup flag was added to AF_XDP, the format of the
> > XDP_MMAP_OFFSETS getsockopt was extended. Code was added to the
> > kernel to take care of compatibility issues arrising from running
> > applications using any of the two formats. However, libbpf was
> > not extended to take care of the case when the application/libbpf
> > uses the new format but the kernel only supports the old
> > format. This patch adds support in libbpf for parsing the old
> > format, before the need_wakeup flag was added, and emulating a
> > set of static need_wakeup flags that will always work for the
> > application.
>
> Hi Magnus
>
> While you're looking at backwards compatibility issues with xsk: libbpf
> currently fails to compile on a system that has old kernel headers
> installed (this is with kernel-headers 5.3):
>
> $ echo "#include <bpf/xsk.h>" | gcc -x c -
> In file included from <stdin>:1:
> /usr/include/bpf/xsk.h: In function =E2=80=98xsk_ring_prod__needs_wakeup=
=E2=80=99:
> /usr/include/bpf/xsk.h:82:21: error: =E2=80=98XDP_RING_NEED_WAKEUP=E2=80=
=99 undeclared (first use in this function)
>    82 |  return *r->flags & XDP_RING_NEED_WAKEUP;
>       |                     ^~~~~~~~~~~~~~~~~~~~
> /usr/include/bpf/xsk.h:82:21: note: each undeclared identifier is reporte=
d only once for each function it appears in
> /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extract_addr=E2=80=
=99:
> /usr/include/bpf/xsk.h:173:16: error: =E2=80=98XSK_UNALIGNED_BUF_ADDR_MAS=
K=E2=80=99 undeclared (first use in this function)
>   173 |  return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
>       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extract_offset=E2=
=80=99:
> /usr/include/bpf/xsk.h:178:17: error: =E2=80=98XSK_UNALIGNED_BUF_OFFSET_S=
HIFT=E2=80=99 undeclared (first use in this function)
>   178 |  return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
>
>
> How would you prefer to handle this? A patch like the one below will fix
> the compile errors, but I'm not sure it makes sense semantically?

Thanks Toke for finding this. Of course it should be possible to
compile this on an older kernel, but without getting any of the newer
functionality that is not present in that older kernel. My preference
is if we just remove these functions completely if you compile it with
a kernel that does not have support for it. For the need_wakeup
feature, we cannot provide semantics that make sense in the function
above. If we return 0, Tx will break. If we return 1, Rx will become
really slow. And we cannot detect /without an ugly hack) if it is the
fill queue or the Tx queue that was provided to the function. So what
do you think of just removing these functions if the kernel does not
have the corresponding defines in its kernel header? The user should
not use them in that case.

We should also think about the case when someone takes the new libbpf
source, compiles it with an older kernel then runs the binary on the
newer kernel. It will for sure happen :-). We should add some code in
the xsk_socket__create call that checks so that users do not try to
use a bind flag that did not exist on the system libbpf was compiled
for. In that case, we should return an error. We need the same code
that we have in the kernel for checking against illegal flags to be
present in the xsk part of libbpf.

/Magnus

> -Toke
>
> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> index 584f6820a639..954d66e85208 100644
> --- a/tools/lib/bpf/xsk.h
> +++ b/tools/lib/bpf/xsk.h
> @@ -79,7 +79,11 @@ xsk_ring_cons__rx_desc(const struct xsk_ring_cons *rx,=
 __u32 idx)
>
>  static inline int xsk_ring_prod__needs_wakeup(const struct xsk_ring_prod=
 *r)
>  {
> +#ifdef XDP_RING_NEED_WAKEUP
>         return *r->flags & XDP_RING_NEED_WAKEUP;
> +#else
> +       return 0;
> +#endif
>  }
>
>  static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb)
> @@ -170,12 +174,20 @@ static inline void *xsk_umem__get_data(void *umem_a=
rea, __u64 addr)
>
>  static inline __u64 xsk_umem__extract_addr(__u64 addr)
>  {
> +#ifdef XSK_UNALIGNED_BUF_ADDR_MASK
>         return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
> +#else
> +       return addr;
> +#endif
>  }
>
>  static inline __u64 xsk_umem__extract_offset(__u64 addr)
>  {
> +#ifdef XSK_UNALIGNED_BUF_OFFSET_SHIFT
>         return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
> +#else
> +       return 0;
> +#endif
>  }
>
>  static inline __u64 xsk_umem__add_offset_to_addr(__u64 addr)
>
