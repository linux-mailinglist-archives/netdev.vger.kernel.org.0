Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455EF1E582A
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgE1HFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE1HFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 03:05:08 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB00C05BD1E
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 00:05:08 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id f89so12468971qva.3
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 00:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jx3eCqpG4Pu6gctCp+szOACaY4NZReUOmLL5Rewaq08=;
        b=k6/H4FnC2PReiDg1B7eylvsG7E33CXHsIDTyKf5vK3okQOv2fsdi8DF2iVIrN0pGAK
         YFbNKmn325LWPcUWF0yBI4lnQc2Ru2TPlJOP5kvVxEjlcw0p4VRT33ooFEdH/xtnhQxy
         OUeRQAgcgnrWzoKEv260lSW8Wapp0wqmmlR1DYYGPhYKBEjblfDS14sfXUohrF/wDloG
         uHonprXrk+4cs/m6/KjGg3l4/nKDxcB8lqKX4q7LUlycTA//UR7R/XFuVQEX0OuBvFB2
         cGtVUWtDj65mSWkajW6GS0AdhkIPerMSkONshiGtPesXuQs18HfU/TsSd+0fQeBjkncC
         s+cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jx3eCqpG4Pu6gctCp+szOACaY4NZReUOmLL5Rewaq08=;
        b=t31JhsGMb0cf5Wsh7Qk5BRMhB+KBWe7EqY1ExjD+8G3yscoRaFPB1znScSsb5tk5Eu
         jVipDX/FxzDPBXqp/pwNWUzZ0Iq9aqPw42ETiihoFaMx5tztHcu+2PknsIQjY6kF1j1Z
         d2VkyowEbdgGyzX0ZmuglmcEc+XfjIBxMqFqROJfsE3/UrAUXAAxtRusGPpks2U62leX
         aQtSzmWhw2LNaGB+vGYZe8eCMcgt9oC5zTRzSa8vFhNmnbAvF/PwPW30XxrxvD+Z+m2R
         nikCAKuxAmuwVoxBT7+HTp/sQZ4R0+bFqvtFPZaYZ3ElSfsBOwWX/7booiIcKXuPVY24
         bypQ==
X-Gm-Message-State: AOAM531218dtHKpHGGSua6CTzy7LpTAXHP5CObSorAKNLEpvc98rsKM6
        RzyGl+sfyZLxT9k4iqTWdXul2LAKEPXC+pVU5fY=
X-Google-Smtp-Source: ABdhPJwm/lDs/9ABOoknWOATTPRitiTwsUZGZcZucvAMPH5dXE4rdK20gTjNiD4g3QKK2IS/MDhsun46sQCqRNRz1/o=
X-Received: by 2002:a0c:a9c6:: with SMTP id c6mr1718743qvb.224.1590649507269;
 Thu, 28 May 2020 00:05:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200528001423.58575-1-dsahern@kernel.org> <20200528001423.58575-5-dsahern@kernel.org>
In-Reply-To: <20200528001423.58575-5-dsahern@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 28 May 2020 00:04:56 -0700
Message-ID: <CAEf4BzbwB+ON56HmRqhPD=iyiviYF9EwBvf-n5tPKn0qhzHjgA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/5] libbpf: Add SEC name for xdp programs
 attached to device map
To:     David Ahern <dsahern@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 5:17 PM David Ahern <dsahern@kernel.org> wrote:
>
> Support SEC("xdp_dm*") as a short cut for loading the program with
> type BPF_PROG_TYPE_XDP and expected attach type BPF_XDP_DEVMAP.
>
> Signed-off-by: David Ahern <dsahern@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 5d60de6fd818..493909d5d3d3 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -6657,6 +6657,8 @@ static const struct bpf_sec_def section_defs[] = {
>                 .expected_attach_type = BPF_TRACE_ITER,
>                 .is_attach_btf = true,
>                 .attach_fn = attach_iter),
> +       BPF_EAPROG_SEC("xdp_dm",                BPF_PROG_TYPE_XDP,
> +                                               BPF_XDP_DEVMAP),

naming is hard and subjective, but does "dm" really associate with
DEVMAP to you, rather than "direct message" or "direct memory" or
something along those line? Is there any harm to call this
"xdp_devmap"? It's still short enough, IMO.

>         BPF_PROG_SEC("xdp",                     BPF_PROG_TYPE_XDP),
>         BPF_PROG_SEC("perf_event",              BPF_PROG_TYPE_PERF_EVENT),
>         BPF_PROG_SEC("lwt_in",                  BPF_PROG_TYPE_LWT_IN),
> --
> 2.21.1 (Apple Git-122.3)
>
