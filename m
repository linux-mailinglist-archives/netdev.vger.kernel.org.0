Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A492AE764
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 05:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgKKET6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 23:19:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgKKET5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 23:19:57 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D844C0613D1;
        Tue, 10 Nov 2020 20:19:57 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id n142so698446ybf.7;
        Tue, 10 Nov 2020 20:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AWB1XnVQckH5+rUmx+be8cfhrydsQYCSrkMS7rKMccA=;
        b=eYW9mXX/RHCNJ4ay++cNSSt03NyIQMS8c33qGcdW7ii1KailkiBX5Nvit6/BVajG7x
         cJdHLtYHR/BHekzpKpMQvIlce20JvrHpMJsloIKjRwBU4uM/itw9SdQtHsl7Gv5WPeFB
         UR0oZiLAiilzdR99083N7zvHvAts9iu37kn5qHFe/CjeGovru1EuTSuKA4UOs5QF8yIl
         EkZvJdHWTEDKM3BbLfjNgIusM/1Yz4mN3UgShKoPGceLBZPCvl9ZlrUwjNpN3ywBaibA
         4OeLrcZArRQITIXbKwL/ty4gIRMtjZ5lDMcnBXercbVBeB5Zx1zbuHoMSod/G99DU6kY
         RDXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AWB1XnVQckH5+rUmx+be8cfhrydsQYCSrkMS7rKMccA=;
        b=IwURyQIyKFt80XBj6K5i56IfnGanAHxWt1qtw4u2nPK9IbzVIdL9DUQXy6eSVK6UJ0
         SvHQnxSOWkwGM+/jQMDLZpzDQcXN/IsTFaCu+2Ouk7C5JKKjdJQBFlXamfJw8/Drn/Sj
         Uy06S244KWd4MpXyV87bnquKMuqWUbcIPJoBhKRPndjr8D8WK32PrA5gXocgMa5flY90
         aV6VuI2NeizwsOudsBH9GqHnp18a/H3L4YfxWn5goF8vb/JPVhuNqOfFySk4VEOpPLEV
         PpDaLOi917GV5L/GnLUyhrN1COEBvC3SGaQjeC8RVHEIP7G06sYdOgq7YsxQTQ0+j2g/
         EedA==
X-Gm-Message-State: AOAM532SYxyKe0xRJeyq5AImZL28Fz/55yzXHtSpcBzuQ6ah+luaOide
        q8QQhYJBDr9/4awZY1dTu593CnLDIqz95JWGVkM=
X-Google-Smtp-Source: ABdhPJxsgiWPd/mA1q7BmJgrRexMcdk4i6vSUBKXO1lOcRC2imrKhty/TSKnaxAgosmj9ENOnJdw0av3fCpGQOnXl6s=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr31716562ybe.403.1605068396905;
 Tue, 10 Nov 2020 20:19:56 -0800 (PST)
MIME-Version: 1.0
References: <20201110011932.3201430-1-andrii@kernel.org> <20201110011932.3201430-6-andrii@kernel.org>
 <8A2A9182-F22C-4A3B-AF52-6FC56D3057AA@fb.com>
In-Reply-To: <8A2A9182-F22C-4A3B-AF52-6FC56D3057AA@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 Nov 2020 20:19:46 -0800
Message-ID: <CAEf4Bzamkc29nHsixj1EJ5embPFG=ZCnys9CgPsvPDEMm9bS3A@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 5/5] tools/bpftool: add support for in-kernel
 and named BTF in `btf show`
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Maguire <alan.maguire@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 5:15 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Nov 9, 2020, at 5:19 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>
> [...]
>
> > ...
> >
> > Tested-by: Alan Maguire <alan.maguire@oracle.com>
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> With one nit:
>
> > ---
> > tools/bpf/bpftool/btf.c | 28 +++++++++++++++++++++++++++-
> > 1 file changed, 27 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
> > index c96b56e8e3a4..ed5e97157241 100644
> > --- a/tools/bpf/bpftool/btf.c
> > +++ b/tools/bpf/bpftool/btf.c
> > @@ -742,9 +742,14 @@ show_btf_plain(struct bpf_btf_info *info, int fd,
> >              struct btf_attach_table *btf_map_table)
> > {
> >       struct btf_attach_point *obj;
> > +     const char *name = u64_to_ptr(info->name);
> >       int n;
> >
> >       printf("%u: ", info->id);
> > +     if (info->kernel_btf)
> > +             printf("name [%s]  ", name);
> > +     else if (name && name[0])
> > +             printf("name %s  ", name);
>
> Maybe explicitly say "name <anonymous>" for btf without a name? I think
> it will benefit plain output.

This patch set is already landed. But I can do a follow-up patch to add this.

>
> >       printf("size %uB", info->btf_size);
> >
> >       n = 0;
>
> [...]
