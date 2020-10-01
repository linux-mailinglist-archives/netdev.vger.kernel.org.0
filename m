Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F08328065C
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 20:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbgJASRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 14:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729493AbgJASRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 14:17:19 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E48C0613D0;
        Thu,  1 Oct 2020 11:17:19 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id f70so4700537ybg.13;
        Thu, 01 Oct 2020 11:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RAC5Se9PuPOggrcST5NI+UPYKW6AY39SOgPucfQ9Cis=;
        b=W2Kw28BCkt8KhKuBpkExAaNDKuC2kojSMVHOn/t2Z2ZleF1ZAwaxsfiPkNHMvo+usK
         YsLjdc0kVfqAhHAa0VapXpId+Gt2BTh3pUkAjGcd1so4mZPCl4VxKxFi24y1f2d/PqIn
         eG1eBiBljfUHo7Gj/hG/+8ZxZmZ/YrlL6uJ2Sk795mgSHl4QZXgwxZrM9U5cwXhZsmkL
         be+A9rodogga7l2dUJSVmo56W1kyWLDtw2W15g5+tQJ5sRf8HCUOkkXOXqzeCvXfh6lN
         NZJhp/kbAZIvxetee2HAXbZTHd1105ytQA4tSDfi+RCUGrjNeAxs+3ibbC1nI9OY4T5d
         oO4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RAC5Se9PuPOggrcST5NI+UPYKW6AY39SOgPucfQ9Cis=;
        b=AKylTAwfMAeVRZTWb57kVn4SWhsG9BlV9EuMCfw9tufczPMBe5HRPSattmc42QImFR
         NeIHSS2TuQtuVwv6I9BXpt0TXDSXLLwTaGoujTqfxrfjOTp3XgRgpBT5QtoEeKSW43Zx
         PD/lDlBNKp9HW0ZMwSXxuOz8JyU6eM1+EGgVPYi7OSZ8nuGmaS/WtVcYfWbZDoPlRaM2
         JTBIYtTGBd0KKHzxVY40wAfOz9aAgfpp9ANkF6NtM8WsWZy0YWpvsIgK1u0QS8LQakk6
         VRClYuQt8qkLouzMPie6n4N3xDiW4Sx0cx4kkdxeXRM4pI9sWpBOv0dsfGt0fCrlFdsI
         bJhQ==
X-Gm-Message-State: AOAM5325QBkgehd9SZ1muzJRKUq2Qj52h0iRFGs6oS6RUV5URumLZkGG
        ch18mZnt8M/i2/21itbZhX6r1czkOskzzxoSj18=
X-Google-Smtp-Source: ABdhPJygbkl/A8PX82cYfHnjLVSkwHcdrZhuK5g09YeLVdGkcORS7ChJ4aZ9dCoFM6sbt/xirLejWvb5cThfuzgi3+Y=
X-Received: by 2002:a25:8541:: with SMTP id f1mr11163136ybn.230.1601576238244;
 Thu, 01 Oct 2020 11:17:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200929031845.751054-1-liuhangbin@gmail.com> <CAEf4BzYKtPgSxKqduax1mW1WfVXKuCEpbGKRFvXv7yNUmUm_=A@mail.gmail.com>
 <20200929094232.GG2531@dhcp-12-153.nay.redhat.com> <CAEf4BzZy9=x0neCOdat-CWO4nM3QYgWOKaZpN31Ce5Uz9m_qfg@mail.gmail.com>
 <20200930023405.GH2531@dhcp-12-153.nay.redhat.com> <CAEf4BzYVVUq=eNwb4Z1JkVmRc4i+nxC4zWxbv2qGQAs-2cxkhw@mail.gmail.com>
 <CAPwn2JT6KGPxKD0fGZLfR8EsRHhYcfbvCATWO9WsiH_wqhheFg@mail.gmail.com>
In-Reply-To: <CAPwn2JT6KGPxKD0fGZLfR8EsRHhYcfbvCATWO9WsiH_wqhheFg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 1 Oct 2020 11:17:07 -0700
Message-ID: <CAEf4BzZ+ffmWfGfDSYTv6OGOy8KjC95=XnA18MSkUEPEA_7zgQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: export bpf_object__reuse_map() to libbpf api
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 1, 2020 at 4:34 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Thu, 1 Oct 2020 at 02:30, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index 32dc444224d8..5412aa7169db 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -4215,7 +4215,7 @@ bpf_object__create_maps(struct bpf_object *obj)
> > >                 if (map->fd >= 0) {
> > >                         pr_debug("map '%s': skipping creation (preset fd=%d)\n",
> > >                                  map->name, map->fd);
> > > -                       continue;
> > > +                       goto check_pin_path;
> > >                 }
> > >
> > >                 err = bpf_object__create_map(obj, map);
> > > @@ -4258,6 +4258,7 @@ bpf_object__create_maps(struct bpf_object *obj)
> > >                         map->init_slots_sz = 0;
> > >                 }
> > >
> > > +check_pin_path:
> > >                 if (map->pin_path && !map->pinned) {
> > >                         err = bpf_map__pin(map, NULL);
> > >                         if (err) {
> > >
> > >
> > > Do you think if this change be better?
> >
> > Yes, of course. Just don't do it through use of goto. Guard map
> > creation with that if instead.
>
> Hi Andrii,
>
> Looks I missed something, Would you like to explain why we should not use goto?

Because goto shouldn't be a default way of altering the control flow.

> And for "guard map creation with the if", do you mean duplicate the
> if (map->pin_path && !map->pinned) in if (map->fd >= 0)? like

I mean something like:


if (map->pin_path) { ... }

if (map fd < 0) {
  bpf_object__create_map(..);
  if (bpf_map__is_internal(..)) { ... }
  if (map->init_slot_sz) { ...}
}

if (map->pin_path && !map->pinned) { ...  }


>
> diff --git a/src/libbpf.c b/src/libbpf.c
> index 3df1f4d..705abcb 100644
> --- a/src/libbpf.c
> +++ b/src/libbpf.c
> @@ -4215,6 +4215,15 @@ bpf_object__create_maps(struct bpf_object *obj)
>                 if (map->fd >= 0) {
>                         pr_debug("map '%s': skipping creation (preset fd=%d)\n",
>                                  map->name, map->fd);
> +                       if (map->pin_path && !map->pinned) {
> +                               err = bpf_map__pin(map, NULL);
> +                               if (err) {
> +                                       pr_warn("map '%s': failed to
> auto-pin at '%s': %d\n",
> +                                               map->name, map->pin_path, err);
> +                                       zclose(map->fd);
> +                                       goto err_out;
> +                               }
> +                       }
>                         continue;
>                 }
>
> (Sorry if the code format got corrupted as I replied in web gmail....)
>
> Thanks
> Hangbin
