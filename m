Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8FA3347EC
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbhCJT2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbhCJT1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 14:27:31 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE3CC061760;
        Wed, 10 Mar 2021 11:27:31 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id l8so19032593ybe.12;
        Wed, 10 Mar 2021 11:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+afERrZACBSDM/epkPt76C1oUwcdWvQIXn6rl1uX6xE=;
        b=meDgZjxzmUwSC3zLETkZNMT7Ybdo3bvmOhD77SiLuAs7Xonzl175nWPSkzjiTmPHTU
         U1UPO/Lo+FPtSfAq3NTT1ZPnbZaLryKvhvSxI90eZ8Qnta7KU893tNT1uyI9wsmTOgBp
         r+WZGQTX0Onb33p0f1ostgbk/Wa59p5wzEq/pcHUKrTjgm7WiiuM15gOsdbYjw4v1L9m
         tgzdrKhg2xfuZHdvVlIetSibSE+i+OTjGsIcjecojtR9jowPajWayxVl7eh2CWQBgKke
         mEO/yq7H5ETs/YJQ51tUWz8c7bPS85o3H/9U/VsVyt3IC/ZvCC5+ynkSGUfQYV32l0kX
         77Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+afERrZACBSDM/epkPt76C1oUwcdWvQIXn6rl1uX6xE=;
        b=OPTrQMiQk6K0Tk043o4NKlwhbTLDB1RSTWw6QHiN3GW1XC2+gYkmaZv25AOSsl0pHR
         QGWxBr1jNvcAQM6aKEcSjAa3g/26FYbiBTEorJGDMY9Pu0GaYXp37ZWjzsb6OCUSoDHz
         9hSQu4NSLVUpgNorOT260ceMViekfPCiQEn4RxrCgwgw8z+tfGfeA5kuQ8ymH4prZgKL
         N7+hSNhmgk4ueuZ8Py5OLXFrlutSR/qy3JY7qtkWg0upPjNFpIhsdkJK2WBiO3LiGYoo
         0pVfAHXfJFcvkZZHjSCR59aopdeibhyq2WKP9QuXQj2oOaK6Uy+sTIgoAFTiIf/zHUu3
         c8gQ==
X-Gm-Message-State: AOAM533ZodqpJecMWJ+Y63r3FX6gDaU0x/vSYwwP+XPDpfaJfBD97rmm
        FozbAqkE4OnATBsSELaxbIwjbp8oGMnGTc75MvE=
X-Google-Smtp-Source: ABdhPJxjRRGLt4SjZNOyHVYpmZFX8W7chBMJkEM/yl7xRcCnjW+yG5Xnn4WUTfGvs/WTZ/MLjkt4tpkwFwA40Mqc004=
X-Received: by 2002:a25:cc13:: with SMTP id l19mr6293249ybf.260.1615404450455;
 Wed, 10 Mar 2021 11:27:30 -0800 (PST)
MIME-Version: 1.0
References: <20210205124020.683286-1-jolsa@kernel.org> <20210205124020.683286-2-jolsa@kernel.org>
 <5a48579b-9aff-72a5-7b25-accb40c4dd52@freenet.de>
In-Reply-To: <5a48579b-9aff-72a5-7b25-accb40c4dd52@freenet.de>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Mar 2021 11:27:19 -0800
Message-ID: <CAEf4BzYYG=3ZEu70CV0t0+T583082=FcytCv=jg2b83QaqyQRA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] tools/resolve_btfids: Build libbpf and
 libsubcmd in separate directories
To:     =?UTF-8?B?VmlrdG9yIErDpGdlcnNrw7xwcGVy?= 
        <viktor_jaegerskuepper@freenet.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 9:35 AM Viktor J=C3=A4gersk=C3=BCpper
<viktor_jaegerskuepper@freenet.de> wrote:
>
> Hi,
>
> > Setting up separate build directories for libbpf and libpsubcmd,
> > so it's separated from other objects and we don't get them mixed
> > in the future.
> >
> > It also simplifies cleaning, which is now simple rm -rf.
> >
> > Also there's no need for FEATURE-DUMP.libbpf and bpf_helper_defs.h
> > files in .gitignore anymore.
> >
> > Acked-by: Song Liu <songliubraving@fb.com>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
>
> when I invoke 'git status' on the master branch of my local git repositor=
y
> (cloned from stable/linux.git), which I have used to compile several kern=
els,
> it lists two untracked files:
>
>         tools/bpf/resolve_btfids/FEATURE-DUMP.libbpf
>         tools/bpf/resolve_btfids/bpf_helper_defs.h
>
> 'git status' doesn't complain about these files with v5.11, and I can't g=
et rid
> of them by 'make clean' with v5.11 or v5.12-rc1/rc2. So I used 'git bisec=
t' and
> found that this is caused by commit fc6b48f692f89cc48bfb7fd1aa65454dfe9b2=
d77,
> which links to this thread.
>
> Looking at the diff it's obvious because of the change in the .gitignore =
file,
> but I don't know why these files are there and I have never touched anyth=
ing in
> the 'tools' directory.
>
> Can I savely delete the files? Do I even have to delete them before I com=
pile
> v5.12-rcX?

yes, those were auto-generated files. You can safely remove them.

>
> Thanks,
> Viktor
>

[...]
