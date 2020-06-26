Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2997320BD3D
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 01:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgFZXvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 19:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgFZXvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 19:51:45 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B546C03E97A
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 16:51:45 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id z2so8832384qts.5
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 16:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5HAzHVKjrYO4VpUiFo7NSwAyj73hZEtoS3n6tcbdE6k=;
        b=Qt3laTlXH/b95foUgF/8tE8Jdb+VGJvzG3VCVAMD0Xo7wylU3pgT2ADLKhvA84j/EA
         VKOAVD3wP9h7WmaX1DuIsYdGU3N6sF62rWiPROLZ0TvZpLzxK3sAWe6FiyvJy0Yv9rcF
         COiBVZCgcEDaIilHAFGo5usDv+0IVDy1er1n+KrMd0RVjZxjvomzBer2UdwagKkAFMPf
         LRsa6cuIiWFTQ70wZ2eQymPXjmpcTnPb+9xtcCit5JHiTFoGiokJ109hZkMfLrJE1AaR
         MLvk1WpHBl2c6IrRF1AzVCrVDlYxzkklyvZsy53yB0ge7eiueViYR/r4BrSsiq5KIE+Z
         3YuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5HAzHVKjrYO4VpUiFo7NSwAyj73hZEtoS3n6tcbdE6k=;
        b=AvPdp4GIre/oxbQB9QRdgGPr5srHWttBm3Njz2kSU6Xs7JiKLgtiMzimrlHIv0vgpO
         lwFZQvQ3HWcwzbZdMjLyNgaFN91Mef97hXX3koLSwiAUbs47pTj+AEdG6erhjL5Oi7NF
         TS9FEI8q99NWLcjEi9QLn8GnGLpvDXgOCUQZEmpzb6TSOBpsW52YdLdGaJVA8wVqm+Sd
         Gi9QIRu/7Ve4+MKV7xkXsLqekIAXbuemJ/NfUrxCmETr7jpwb11MhiB7Jeix4/tffmbJ
         LFkW+Grevb0vebjZZG9FOOldQuWJSRgoKePrPgkarHvDw9oI1N/Aj2Cx3LcmFLNBZjHY
         pC/g==
X-Gm-Message-State: AOAM533hnFZGa4NTCbLzC5+r7EBbrQqOpddlsDVD/olSorwUj/MEalWN
        f1HdqAlx7eebJlyVLnoQhmZtY9+mI7bMin43DtgAOg==
X-Google-Smtp-Source: ABdhPJxUb9ogdYtGpTYgZilw4ctza0Hb6+j27VWDtPMReEJ6ii/8qfCwavPTWONaAh1svV3z9fgW2etaIQ3Xwj8mujc=
X-Received: by 2002:aed:3048:: with SMTP id 66mr3687191qte.326.1593215504021;
 Fri, 26 Jun 2020 16:51:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200626000929.217930-1-sdf@google.com> <20200626000929.217930-2-sdf@google.com>
 <CAEf4Bza+j4KsuCs3pyRGNUvUTWmJ=qc4GRUYNkca3F6XFvrvAQ@mail.gmail.com>
In-Reply-To: <CAEf4Bza+j4KsuCs3pyRGNUvUTWmJ=qc4GRUYNkca3F6XFvrvAQ@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 26 Jun 2020 16:51:33 -0700
Message-ID: <CAKH8qBsdNOBDrmMAKEyYsr8_T=6D9ED6cM9MNNUoTPZhN-LTYw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] libbpf: add support for BPF_CGROUP_INET_SOCK_RELEASE
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 3:02 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Jun 25, 2020 at 5:13 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Add auto-detection for the cgroup/sock_release programs.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>
>
> >  tools/include/uapi/linux/bpf.h | 1 +
> >  tools/lib/bpf/libbpf.c         | 2 ++
> >  2 files changed, 3 insertions(+)
> >
> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> > index c65b374a5090..d7aea1d0167a 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -226,6 +226,7 @@ enum bpf_attach_type {
> >         BPF_CGROUP_INET4_GETSOCKNAME,
> >         BPF_CGROUP_INET6_GETSOCKNAME,
> >         BPF_XDP_DEVMAP,
> > +       BPF_CGROUP_INET_SOCK_RELEASE,
> >         __MAX_BPF_ATTACH_TYPE
> >  };
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 7f01be2b88b8..acbab6d0672d 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -6670,6 +6670,8 @@ static const struct bpf_sec_def section_defs[] = {
> >         BPF_APROG_SEC("cgroup_skb/egress",      BPF_PROG_TYPE_CGROUP_SKB,
> >                                                 BPF_CGROUP_INET_EGRESS),
> >         BPF_APROG_COMPAT("cgroup/skb",          BPF_PROG_TYPE_CGROUP_SKB),
> > +       BPF_EAPROG_SEC("cgroup/sock_release",   BPF_PROG_TYPE_CGROUP_SOCK,
> > +                                               BPF_CGROUP_INET_SOCK_RELEASE),
> >         BPF_APROG_SEC("cgroup/sock",            BPF_PROG_TYPE_CGROUP_SOCK,
>
> might want to add another alias to match _release: "cgroup/sock_create"?
Sure, will do!
