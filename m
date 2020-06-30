Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206F320F80D
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 17:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389324AbgF3PPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 11:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389258AbgF3PPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 11:15:46 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AC9C061755;
        Tue, 30 Jun 2020 08:15:47 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id q198so18931798qka.2;
        Tue, 30 Jun 2020 08:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TBWBW0OxQzn1SK9RkG16YT4BA8nuVUsehysg/82t6P8=;
        b=OoEEqp0iL9D7XxCKrYNrh3ZGtEsg9rmgVJdfB7pjEfvD4dQQhpxDbjkt2EEB26i5lE
         IAknb6gwJwqc9kUYoOYk1zAFR9KOeQ6OEM/Iyczu/ktanF2x/WlAx1/5pb2wGGehQrEu
         hTZ5M+spa/SkL/P/Obc3C3BWJb0dUNu9uzfn91loILXhgw4RyvR1f1A/Gz1anhzSMRmX
         n+a663wrjDOpKfCnYcQVnzQxTDdSx6I4MJdFDLMB9ZpgktOEAPqy/S7rav7L0YJT6cXU
         kOr+B+/5aQJi+Go3oK/TheblCAbT9Y8TBrvBLcvaGqqnfPHpGTinYGJ4xfonC8bF/h7s
         0MNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TBWBW0OxQzn1SK9RkG16YT4BA8nuVUsehysg/82t6P8=;
        b=h4jiWDU6G9XoV9qbY7OhS69SNK71E4RO80d9g2w0yq6FIJgIqZ+vzlgD2I63//GH5K
         utRo3+kpR7T8tKIfYT+HJ7TjuX7K56gtH3jvTSC8LJvJ1Mp74GFq2rVTfA5HxHaOEt2Q
         LBUkhcLrwbkdi21TwkzL/A3H7NOgFioVBtOaXUjkQEVCfrm6uHCA4wjq7+C+4Yn/0k6X
         f4X9I5dwQcAzJndgkA1UzBByvlTRLe/e4nx+BDPwU7l6DAzHCNdb9ZJTiQoH9AGEOVJ0
         yhrt89iIfa9/Kdb4v9RdipHsloQ8YlNeyWmZIeliMAsoAhPys/s+GNILvf0vPfVKh9I6
         mWHg==
X-Gm-Message-State: AOAM530d1osebH4XIlhj3OyzkvNqhIsfwYbtEf5FPZmn0gta5THeS/dR
        2dAlXKf2EEb2VGPGcQPfvJIU1ElPqfhhl4HSsZY=
X-Google-Smtp-Source: ABdhPJwAtKezoBo0RIUK+2AQwEIl47CIk0idcnmPK5e+H6Xbb9oUJc3lNcYkoliupi4BM567tzltqUDUUpGRHOblgq8=
X-Received: by 2002:a05:620a:2409:: with SMTP id d9mr21160370qkn.36.1593530145511;
 Tue, 30 Jun 2020 08:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200630061500.1804799-1-andriin@fb.com> <285e32b1-daa5-1be4-5939-c86249680311@iogearbox.net>
In-Reply-To: <285e32b1-daa5-1be4-5939-c86249680311@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Jun 2020 08:15:33 -0700
Message-ID: <CAEf4BzZDJyEfSqnnDv0pe6J8GZwQVE8tucJWs3hHNeQemwVN9w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf] bpf: enforce BPF ringbuf size to be the power of 2
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 7:52 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 6/30/20 8:15 AM, Andrii Nakryiko wrote:
> > BPF ringbuf assumes the size to be a multiple of page size and the power of
> > 2 value. The latter is important to avoid division while calculating position
> > inside the ring buffer and using (N-1) mask instead. This patch fixes omission
> > to enforce power-of-2 size rule.
> >
> > Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Lgtm, applied, thanks!
>

Thanks, Daniel!

> [...]
> > @@ -166,9 +157,16 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
> >               return ERR_PTR(-EINVAL);
> >
> >       if (attr->key_size || attr->value_size ||
> > -         attr->max_entries == 0 || !PAGE_ALIGNED(attr->max_entries))
> > +         !is_power_of_2(attr->max_entries) ||
> > +         !PAGE_ALIGNED(attr->max_entries))
>
> Technically !IS_ALIGNED(attr->max_entries, PAGE_SIZE) might have been a bit cleaner
> since PAGE_ALIGNED() is only intended for pointers, though, not wrong here given
> max_entries is u32.

I've found a bunch of uses on non-pointers, e.g., `if
(!PAGE_ALIGNED(fs_info->nodesize)) {` in BTRFS code, so assumed it's
intended to be used more generically. But let me know if you want me
to do IS_ALIGNED change.

>
> Thanks,
> Daniel
