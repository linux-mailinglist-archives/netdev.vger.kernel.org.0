Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E031B17D3
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 06:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfIME73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 00:59:29 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38446 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbfIME72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 00:59:28 -0400
Received: by mail-qt1-f195.google.com with SMTP id j31so5590082qta.5;
        Thu, 12 Sep 2019 21:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=54Llr8m/eaJ/yNpZV2+6kUEC7ZWLaAYUyQF1/0Ykgmk=;
        b=spTZPTkGTUTBR7OmthNn69KcOk1Ao9wR3Fl04+gUenQ6aS6u0Wneo9YnJW8dgnUSJK
         ytbvHnSMbpKwLOnsS20xrDuFH4A/c0zfdScV8orsS/jsxUbCKIV7tF65bT8O2A5Wz5s7
         +aOvP5S33+Nfjc/EjMTR35Dw7XohjHcPJirot2t8DVYwehHZKwNW5BPkhJEqFjo98QJP
         PmBXC66KgY8U/cr26y8bqWrY3c9D7bHj6CrHFa/XtqKIugXcVYsb/ApdmeiVwBQMI1uX
         WReth35BZhBR0MKzR0phu/VqkihL/MxGT8ent0hTUwIDeYM+VhIquPRkc2MLVo2A4UFw
         xx6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=54Llr8m/eaJ/yNpZV2+6kUEC7ZWLaAYUyQF1/0Ykgmk=;
        b=K8yisP1io1nr5X+V1JqisqMCQULdiOdIOizbdA0sh+P3YDSIxtX5DWoVtH5YLRuhIh
         pOr+TLCjvXQvLq0lwaVRurhosSqSLzR0URHlYsn+/q/zQZAvikP2wd7F4wSHCet1V2Y0
         GZORCoLg/B39x9LtPBMzevfwSSZPBFQ60NDelJGTV5oyR4DdHsaKA2Ja3j1NveXm3rX+
         QPYYrOIyqikzNYW5fyN/2hnkaFvhHTRrT522WEtaJFOMMlHVSqeoDVqSLXUPnReY9oDC
         3EUz//B350mRMMHnO9NBph92l1ccU2xPYqCeLQmHrwJB4apwtNm7w/TM4CuQpxenO/19
         1rUw==
X-Gm-Message-State: APjAAAUaSTEJbQPwrJlA0jEQTb0WmqfD+4OorjaEi4uWBKW6JhAUzRYo
        ck2mbPvw9H1SeQphIAOF1naygcHKK1YZj2hlzus=
X-Google-Smtp-Source: APXvYqx1lXuTGRVRTYEVNWG3R85CKA4QeDnhRNwbLV5mWTyVtY2wI3Yfgas3EEtCOhxZcvvn4qlIcJzcQxKSMRHXL4g=
X-Received: by 2002:ac8:75d2:: with SMTP id z18mr1125094qtq.46.1568350766212;
 Thu, 12 Sep 2019 21:59:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190912072840.20947-1-kevin.laatz@intel.com>
In-Reply-To: <20190912072840.20947-1-kevin.laatz@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 13 Sep 2019 06:59:10 +0200
Message-ID: <CAJ+HfNgQY6muwzGgBW6xLFzKeiCMQUwrz_yrywB3F_VSKbaadQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: add xsk_umem__adjust_offset
To:     Kevin Laatz <kevin.laatz@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Bruce Richardson <bruce.richardson@intel.com>,
        ciara.loftus@intel.com, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Sep 2019 at 17:47, Kevin Laatz <kevin.laatz@intel.com> wrote:
>
> Currently, xsk_umem_adjust_offset exists as a kernel internal function.
> This patch adds xsk_umem__adjust_offset to libbpf so that it can be used
> from userspace. This will take the responsibility of properly storing the
> offset away from the application, making it less error prone.
>
> Since xsk_umem__adjust_offset is called on a per-packet basis, we need to
> inline the function to avoid any performance regressions.  In order to
> inline xsk_umem__adjust_offset, we need to add it to xsk.h. Unfortunately
> this means that we can't dereference the xsk_umem_config struct directly
> since it is defined only in xsk.c. We therefore add an extra API to retur=
n
> the flags field to the user from the structure, and have the inline
> function use this flags field directly.
>

Can you expand this to a series, with an additional patch where these
functions are used in XDP socket sample application, so it's more
clear for users?


Thanks,
Bj=C3=B6rn

> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
> ---
>  tools/lib/bpf/libbpf.map |  1 +
>  tools/lib/bpf/xsk.c      |  5 +++++
>  tools/lib/bpf/xsk.h      | 14 ++++++++++++++
>  3 files changed, 20 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index d04c7cb623ed..760350c9b81c 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -189,4 +189,5 @@ LIBBPF_0.0.4 {
>  LIBBPF_0.0.5 {
>         global:
>                 bpf_btf_get_next_id;
> +               xsk_umem__get_flags;
>  } LIBBPF_0.0.4;
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 842c4fd55859..a4250a721ea6 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -84,6 +84,11 @@ int xsk_socket__fd(const struct xsk_socket *xsk)
>         return xsk ? xsk->fd : -EINVAL;
>  }
>
> +__u32 xsk_umem__get_flags(struct xsk_umem *umem)
> +{
> +       return umem->config.flags;
> +}
> +
>  static bool xsk_page_aligned(void *buffer)
>  {
>         unsigned long addr =3D (unsigned long)buffer;
> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> index 584f6820a639..bf782facb274 100644
> --- a/tools/lib/bpf/xsk.h
> +++ b/tools/lib/bpf/xsk.h
> @@ -183,8 +183,22 @@ static inline __u64 xsk_umem__add_offset_to_addr(__u=
64 addr)
>         return xsk_umem__extract_addr(addr) + xsk_umem__extract_offset(ad=
dr);
>  }
>
> +/* Handle the offset appropriately depending on aligned or unaligned mod=
e.
> + * For unaligned mode, we store the offset in the upper 16-bits of the a=
ddress.
> + * For aligned mode, we simply add the offset to the address.
> + */
> +static inline __u64 xsk_umem__adjust_offset(__u32 umem_flags, __u64 addr=
,
> +                                           __u64 offset)
> +{
> +       if (umem_flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG)
> +               return addr + (offset << XSK_UNALIGNED_BUF_OFFSET_SHIFT);
> +       else
> +               return addr + offset;
> +}
> +
>  LIBBPF_API int xsk_umem__fd(const struct xsk_umem *umem);
>  LIBBPF_API int xsk_socket__fd(const struct xsk_socket *xsk);
> +LIBBPF_API __u32 xsk_umem__get_flags(struct xsk_umem *umem);
>
>  #define XSK_RING_CONS__DEFAULT_NUM_DESCS      2048
>  #define XSK_RING_PROD__DEFAULT_NUM_DESCS      2048
> --
> 2.17.1
>
