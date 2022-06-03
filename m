Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF6E53D3CA
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 01:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349590AbiFCXNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 19:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbiFCXNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 19:13:31 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFA21D0D1
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 16:13:30 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso8187760pjg.0
        for <netdev@vger.kernel.org>; Fri, 03 Jun 2022 16:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LSrraWC3tFCdgmhlnDY2Q6glgRYdmbP1A46BBlPMXug=;
        b=mPnbBLsNswj0NyJHd+lqprKzMM5zKD6I2+2O5QpWxaQESJiAMNB7lAovfTYZTbsXjJ
         zhn3YkH+hi0YSz8rU89s7iHfLggboLYuHpqtajlM8s+MDYVREZmCeP8m27APLvp4vmRe
         8wG80mRcAca3rO0rNp+KmL+zUpfbs4jnH57LFBehc9dmcX0vnlA0oR1tUSBrm9Ed9SML
         X77uh/oSropxwxJmGolg0sHZCCr88fwRu4LMneCNib+5AGcRo8WMPn3AG286x+ADAekG
         Ft1SgO8xNleSLaM5CIck+CHmd5gJ4nxplaFefw+it3UXOol2kqCGDh2Pqp252NzJNAiV
         Lu/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LSrraWC3tFCdgmhlnDY2Q6glgRYdmbP1A46BBlPMXug=;
        b=16mVg5DReHFiVVq58IgmFn0pG4AyTTwEtvSz/v/doaPn/dh94Q/3niElQEBBoocQB8
         KYoGUcZBxcyD3K5KJ7eWmxijFbTSI/4olXiy3vMqw1QRL0Bf5/jAKhVO1Qg7bv4GUL+D
         Rvq6t29kp544kz4VxUW/nJ9L3N73tWIFJsPwpfyd84pFsqrQiZEEGEWqEPw6+0N+Zx9z
         7z2KEXGa4/JSX4xHqt9UWWe8Eh+MfzFD1SaaMESNjg3odv1RTDQoMLGF09xdjXR6cYG/
         NekS+iHf9B+QKPOn6swwVBc4HZPcVMlpkXrfxDhQtXi6/ylRturS5rJLVh4ePkyES2zp
         XKQQ==
X-Gm-Message-State: AOAM5302TElhQ3lHIZoNN3JUEidgifQgqkA24Tkv5A7z0PmUgP1nBu3R
        O0N4huKbOg+6SLQf6IDpnKJEJe6RzdIWGeqwIliJEJzl3YU=
X-Google-Smtp-Source: ABdhPJwM8lFiQp/MN8gj9lRHCvTXOTNTM8X6CoYUTUHkTKHuBtb10IqniEvi6toevkP/4NjlpsNO6dHD+F2gBFJZNZY=
X-Received: by 2002:a17:90b:188:b0:1e3:1feb:edb2 with SMTP id
 t8-20020a17090b018800b001e31febedb2mr13396373pjs.195.1654298009450; Fri, 03
 Jun 2022 16:13:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220601190218.2494963-1-sdf@google.com> <20220601190218.2494963-9-sdf@google.com>
 <CAEf4BzYewhP+RbV9H1+8Htr73Y0fPNT4tN3E6v4-_GwEiJud-A@mail.gmail.com>
In-Reply-To: <CAEf4BzYewhP+RbV9H1+8Htr73Y0fPNT4tN3E6v4-_GwEiJud-A@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 3 Jun 2022 16:13:15 -0700
Message-ID: <CAKH8qBthw-7Nse+=xeys1t=Q+f8VwQWu-zuHMGC+_CJUSrX6zg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 08/11] libbpf: implement bpf_prog_query_opts
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 3, 2022 at 2:35 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Jun 1, 2022 at 12:02 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Implement bpf_prog_query_opts as a more expendable version of
> > bpf_prog_query. Expose new prog_attach_flags and attach_btf_func_id as
> > well:
> >
> > * prog_attach_flags is a per-program attach_type; relevant only for
> >   lsm cgroup program which might have different attach_flags
> >   per attach_btf_id
> > * attach_btf_func_id is a new field expose for prog_query which
> >   specifies real btf function id for lsm cgroup attachments
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  tools/include/uapi/linux/bpf.h |  3 +++
> >  tools/lib/bpf/bpf.c            | 40 +++++++++++++++++++++++++++-------
> >  tools/lib/bpf/bpf.h            | 15 +++++++++++++
> >  tools/lib/bpf/libbpf.map       |  2 +-
> >  4 files changed, 51 insertions(+), 9 deletions(-)
> >
>
> Few consistency nits, but otherwise:
>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>

Thank you for the review, agreed, will address everything in a respin.
