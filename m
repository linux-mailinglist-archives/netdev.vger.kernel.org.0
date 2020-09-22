Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8F8274A27
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 22:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgIVUdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 16:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgIVUdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 16:33:22 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AF6C061755;
        Tue, 22 Sep 2020 13:27:29 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id 133so6503199ybg.11;
        Tue, 22 Sep 2020 13:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XYP3v/svhy0yYgmeKvK7dxWjOaVHz8DlAqzQlTiKAbw=;
        b=ZHuovsbBBDK0iAZwGOh6s+6X7A66lMgiyr+Yey/7+QV5e+MDUYfzkDYAvpAJy/eISH
         OrOdByNBr8X86AVMUqu3h2CnLCN0sKUnjqfMoG3T3hE7EbsUGTEh+EzS6ws341lvCeaf
         6uGIP+vtOgquv0BBK7eN2cK79yq2NfaHe2zJKc1P7Sz4G/mB3Ule3kGxt8P/3Wd49LPO
         sO5DiW+ddR35epWA3VyBR2NXZZzElOoXo2j122kccHTfUhOm5vauQQKE5agDI9ykr+pQ
         dRR8sleqpoDelALPnbnvLxvK0Bv4CmrVCj0xz6/dcW4zDjZMy1NHDOeUBI3JXRt9xosr
         ziWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XYP3v/svhy0yYgmeKvK7dxWjOaVHz8DlAqzQlTiKAbw=;
        b=ExzZlohlRuDcuAvuAkKebULDh3XZOjq4LXJBa04XDClIY8Ysy/Em40K43wH8FWRbP/
         pljCwzgyk6hxhk7+PX8hw46BOlXcrGuQzRRSI8Hh6vlz9YdzcTZDlhBXR+PdyrUsrNVq
         ZFj8NOm6Pksdk6I6JE5aHgdu87IA5iP1c4sbYM+8gJoOukvAqi/qOR2M4JKxtAmL70Xc
         o08zt4xplHXUKdcKJcV8l0fU1+0tmjiDKDvLKRpHARSYyF3nZhM5fwiuHcwqCnTkj/qD
         ULiskOrDhNTQRRqXpKPxe6MBe6fr4zx/BdWfDLPNWxN/Q8h0RJTgY321fJ4xzQvhxk1h
         WRJQ==
X-Gm-Message-State: AOAM530nbAk+hUVW+XdVU9bz7lSb1YIzEx5VziXi6tlmZcJCxKByCMRR
        j+bAFw+WqL9Suf/p6H6LU4wEpX8GsfS5iIT6Dh8=
X-Google-Smtp-Source: ABdhPJwqzlbFILVg5ZiOaRgJotMz0P9WC7C9BRzTWRwXrG6nSQVJTs5pPMv8tt8mzhSEQWne4I1ai3RaRRVezmNMvgU=
X-Received: by 2002:a25:4446:: with SMTP id r67mr9219107yba.459.1600806448675;
 Tue, 22 Sep 2020 13:27:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200918122654.2625699-1-jolsa@kernel.org> <CAEf4BzZc6DE85wUTGwE=2FKPuwuuH4480Fh+v63q8J=PRxjgEw@mail.gmail.com>
 <20200922184755.GD2718767@krava>
In-Reply-To: <20200922184755.GD2718767@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Sep 2020 13:27:17 -0700
Message-ID: <CAEf4BzZJaVkck7y_YH5Cd2rhx6M8T0trKmGz1dRnGCz2+Uh=bQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Use --no-fail option if CONFIG_BPF is
 not enabled
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 11:48 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, Sep 21, 2020 at 02:55:27PM -0700, Andrii Nakryiko wrote:
> > On Fri, Sep 18, 2020 at 5:30 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > Currently all the resolve_btfids 'users' are under CONFIG_BPF
> > > code, so if we have CONFIG_BPF disabled, resolve_btfids will
> > > fail, because there's no data to resolve.
> > >
> > > In case CONFIG_BPF is disabled, using resolve_btfids --no-fail
> > > option, that makes resolve_btfids leave quietly if there's no
> > > data to resolve.
> > >
> > > Fixes: c9a0f3b85e09 ("bpf: Resolve BTF IDs in vmlinux image")
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> >
> > If no CONFIG_BTF is specified, there is no need to even run
> > resolve_btfids. So why not do just that -- run resolve_btfids only
> > if both CONFIG_BPF and CONFIG_DEBUG_INFO_BTF are specified?
>
> we can have CONFIG_DEBUG_INFO_BTF without CONFIG_BPF being enabled,
> so we could in theory have in future some BTF ID user outside bpf code,
> but I guess we can enable that, when it actually happens
>

Right. Let's cross that bridge when we get there.

> jirka
>
> >
> >
> > >  scripts/link-vmlinux.sh | 9 +++++++--
> > >  1 file changed, 7 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > > index e6e2d9e5ff48..3173b8cf08cb 100755
> > > --- a/scripts/link-vmlinux.sh
> > > +++ b/scripts/link-vmlinux.sh
> > > @@ -342,8 +342,13 @@ vmlinux_link vmlinux "${kallsymso}" ${btf_vmlinux_bin_o}
> > >
> > >  # fill in BTF IDs
> > >  if [ -n "${CONFIG_DEBUG_INFO_BTF}" ]; then
> > > -info BTFIDS vmlinux
> > > -${RESOLVE_BTFIDS} vmlinux
> > > +       info BTFIDS vmlinux
> > > +       # Let's be more permissive if CONFIG_BPF is disabled
> > > +       # and do not fail if there's no data to resolve.
> > > +       if [ -z "${CONFIG_BPF}" ]; then
> > > +         no_fail=--no-fail
> > > +       fi
> > > +       ${RESOLVE_BTFIDS} $no_fail vmlinux
> > >  fi
> > >
> > >  if [ -n "${CONFIG_BUILDTIME_TABLE_SORT}" ]; then
> > > --
> > > 2.26.2
> > >
> >
>
