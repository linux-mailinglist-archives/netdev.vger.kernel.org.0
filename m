Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCB445CF7C
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 22:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhKXVzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 16:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhKXVy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 16:54:58 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30987C061574;
        Wed, 24 Nov 2021 13:51:48 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id d2so5324183qki.12;
        Wed, 24 Nov 2021 13:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+hTyLBi56R6LO1PZjfv+m89OWgmpG35Zc0D6Wb/Dnmo=;
        b=OzHGoEslAh71QlfociKY3/uxT3xv5mxWvVzGnNGZo/QZCCt+ubAMeVfaQ91xHZcMYo
         DwaFoTCAMoXBVyViPwNHyCCiS7yNRI5Lzr//RNVXz0Z/UVyAg0zYdckzoSJzlzC2oyp1
         G6EAmnBbto73db3gxyyqxm0anIk6t0Vez9wNET5DI6hHiGtBLhbNYU+b+pQToxVyYlen
         r4kqPaTPYFHz6Jj3gIq8pN4e/D7GgTsvrdbNQKaLhvyYSI1IOLxlz8ZFHqQI7MRXEPRD
         EHBjV2sBSnnOyEaDanb/Q/RcShgO3EcNlWb8yRV7no1g+5bMz5QhyYrrorXLEl0qNbfK
         FZoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+hTyLBi56R6LO1PZjfv+m89OWgmpG35Zc0D6Wb/Dnmo=;
        b=M59232Q8bSiM+3wSA9aSj4SydTtXPlhe5m1ZEeCGvkVe1TAdcfR6Thutf4yU1CusB5
         6fQy75i+2YgxQf/miQlOOlqywrtBQ8++Ky3pRBgdFPAPVU8bQbj92A8rixw03u/4FNzt
         j7eXqiEXK5JW9fjc7ckpc4gPH34pTX2uBtOQxW++NVMesN3cF/+7R+8z/BB0kQv1vOOA
         mSbZEy7eVVIlLfGNwviyIBUdluOMBbz7goCk3RNwsX9nX3Wh1Vripkul/DP6c3f8j/DA
         4A3oFW626viFE0hjJ939lyY51BdbqccOwnLNRfgtZBQWlPUTggQHXhmeyUxuWt/6UI62
         dvEQ==
X-Gm-Message-State: AOAM532rSWN2MEpxiOkpJUCv1chvqvpYVeKJX3Lt/T/prEW2WTdtER3e
        JWQH75sMHri4YeKLb06QmEKZTiOYUoYoyyimUNM=
X-Google-Smtp-Source: ABdhPJy+T/mWPQew0hkrOXKMMUtZ+jwO1Cx2rUgnXgubTbq3fpckCL4w3eAz/fVDewOYy8J40mXsbf2Hdd9hWxc72PU=
X-Received: by 2002:a25:d16:: with SMTP id 22mr357053ybn.51.1637790707342;
 Wed, 24 Nov 2021 13:51:47 -0800 (PST)
MIME-Version: 1.0
References: <20211118112455.475349-1-jolsa@kernel.org> <20211118112455.475349-10-jolsa@kernel.org>
 <20211119041159.7rebb5lz2ybnygqr@ast-mbp.dhcp.thefacebook.com> <YZv6VLAuv+4gPy/4@krava>
In-Reply-To: <YZv6VLAuv+4gPy/4@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 24 Nov 2021 13:51:36 -0800
Message-ID: <CAEf4Bzad=O3PgZ9Z55HpuiobQTkhA57GHFEV2M6JveG_nzP40A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 09/29] bpf: Add support to load multi func
 tracing program
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 12:15 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Nov 18, 2021 at 08:11:59PM -0800, Alexei Starovoitov wrote:
> > On Thu, Nov 18, 2021 at 12:24:35PM +0100, Jiri Olsa wrote:
> > > +
> > > +DEFINE_BPF_MULTI_FUNC(unsigned long a1, unsigned long a2,
> > > +                 unsigned long a3, unsigned long a4,
> > > +                 unsigned long a5, unsigned long a6)
> >
> > This is probably a bit too x86 specific. May be make add all 12 args?
> > Or other places would need to be tweaked?
>
> I think si, I'll check
>
> >
> > > +BTF_ID_LIST_SINGLE(bpf_multi_func_btf_id, func, bpf_multi_func)
> > ...
> > > -   prog->aux->attach_btf_id = attr->attach_btf_id;
> > > +   prog->aux->attach_btf_id = multi_func ? bpf_multi_func_btf_id[0] : attr->attach_btf_id;
> >
> > Just ignoring that was passed in uattr?
> > Maybe instead of ignoring dopr BPF_F_MULTI_FUNC and make libbpf
> > point to that btf_id instead?
> > Then multi or not can be checked with if (attr->attach_btf_id == bpf_multi_func_btf_id[0]).
> >
>
> nice idea, it might fit better than the flag

Instead of a flag we can also use a different expected_attach_type
(FENTRY vs FENTRY_MULTI, etc). As for attach_btf_id, why can't we just
enforce it as 0?

>
> thanks,
> jirka
>
