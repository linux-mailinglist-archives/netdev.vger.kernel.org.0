Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B07C2BB2CA
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbgKTSZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728698AbgKTSZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 13:25:34 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F44C0613CF;
        Fri, 20 Nov 2020 10:25:32 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id v92so9432225ybi.4;
        Fri, 20 Nov 2020 10:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KBYX9TYTbJdxYhEwWVL/NQM7uRu/QHpfNrlmGwGN0TY=;
        b=aUPIPXUX+Wn8gXRl/PyDsG1CGYbL+NL0DVNsSZJO4PwWHXVzpXxYePX4AN+oPugQxP
         bDt2rYDBbYdLJMbj38Vnra4rhqodXQRGFWxn2VHiZc+HzozVRBRfpIniBmrl68O/H1rL
         EJc2Klyr3gjjGFq1KEj9zoMB1qMzX/lUDcaNSr3STkmVP8IoK0UvMqGyiY5M50dH3C6I
         aSbPXZ9fuk/DZYBdTBzMoNbGtC4pXkHO9u75DefATJ1c4Vx8KGirX3uXMVLuVq4/tGnz
         Nc+nFE+dmnCYoeYCCQqGT5p5WI4Rcugf8qawCwRRFjDkiQIUFqvUoiK3N/66hZuXBiAM
         Yo5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KBYX9TYTbJdxYhEwWVL/NQM7uRu/QHpfNrlmGwGN0TY=;
        b=RWwIuSjdUasTABLh0+NrhYzjkWKZvDpJ9giSxIXMdnbHj1EuXsKvYM4rrmhasXikJx
         6a4PkJt15v7jZZGr0fIPZQT1PE+9FlfpqFfQ8w/7n0hwe6jmHiUGV5kfP10dfMxyw3if
         gAG9tN7bL+uwJEpGrCiMduwpJIErVihFC1K1Ix7dREpJxAS4L3QicWUTyc+cBJlyU+Tw
         wwx9+iRG+Uk6bI7ssICi1O6BmMDLXDRRFil2a8qlDpf3rardFVIeyAi66hf4DfZcRRtU
         1DBbZmTQCAwlUSlooaTJWanjhm5mNma3L5IFMaaEW+cTTRe/jrJqjHcwHZ/2YCFJm49v
         6POg==
X-Gm-Message-State: AOAM53377kgaadx7IzXo9cY9KlAs4lK9vx564UEtHtx0STnymh8mEW8n
        BL+0zqpY0swrDUlstRvaD/g8+naE8t2ZA5kxkKk=
X-Google-Smtp-Source: ABdhPJwNO6gyMO/4ACaFrSCTa8WxKkeWKgf/SvHYqG5ud43m/7hrMnrahQYgjP/3AFTYvBVbqy+svxpCIC+sHGQHTuQ=
X-Received: by 2002:a25:585:: with SMTP id 127mr20922695ybf.425.1605896732144;
 Fri, 20 Nov 2020 10:25:32 -0800 (PST)
MIME-Version: 1.0
References: <20201119232244.2776720-1-andrii@kernel.org> <20201119232244.2776720-3-andrii@kernel.org>
 <20201120182019.zlzmntlnaewcc5ue@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201120182019.zlzmntlnaewcc5ue@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 Nov 2020 10:25:21 -0800
Message-ID: <CAEf4BzZmkR80AF-gz6NyLH21q=un1Wfpobo=TwpahX+YJ-t3ww@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: add internal helper to load BTF data
 by FD
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 10:20 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Nov 19, 2020 at 03:22:40PM -0800, Andrii Nakryiko wrote:
> [ ... ]
>
> > +int btf__get_from_id(__u32 id, struct btf **btf)
> > +{
> > +     struct btf *res;
> > +     int btf_fd;
> > +
> > +     *btf = NULL;
> > +     btf_fd = bpf_btf_get_fd_by_id(id);
> > +     if (btf_fd < 0)
> > +             return 0;
> It should return an error.
>

That would break the original behavior with (ret == 0 && btf == NULL),
but I think it's more consistent, so I'll fix this and will add Fixes:
tag.

> > +
> > +     res = btf_get_from_fd(btf_fd, NULL);
> > +     close(btf_fd);
> > +     if (IS_ERR(res))
> > +             return PTR_ERR(res);
> > +
> > +     *btf = res;
> > +     return 0;
> >  }
> >
