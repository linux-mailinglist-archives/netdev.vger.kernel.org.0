Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4405C466694
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 16:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359025AbhLBPiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 10:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358984AbhLBPiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 10:38:10 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7515AC06174A;
        Thu,  2 Dec 2021 07:34:47 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id u11so20495031plf.3;
        Thu, 02 Dec 2021 07:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uDWxolb0OqtHKB4fKXPCc+zsagXL08BS8V3CqyXaOR4=;
        b=X6AiT4U8iUfomEWuT1XhKlXnFMYwOmjeg/ucbcvfGTcQHDH9naMZnZRRJNw7Wp1nm5
         jLaUzr3w7qIWRH9UpxqeULBIQYSWSdDOCS6vmxYWCeuz45Hv2ojOp4KsAENUyht/mViE
         Jy/E5FjF+w6vnca5qNN47VQTOXCbUfC5OsBtLBvGwyKec41HDVwbCBTibycVScSpldrt
         I0JhrLr3Uh946GCYYGpPUdfE5xf2HWRMHB/bEPEh2pVwvU4jkc1tAtXmb4nude5L4NMf
         Z9WS9NimwocCDAalKX9JioFVkvj/iDiO4sNRJ8DTuqo4PcCyfnj7neQdPEPr8U2KXrju
         2XQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uDWxolb0OqtHKB4fKXPCc+zsagXL08BS8V3CqyXaOR4=;
        b=6VVuq7o+kcWEFY2wycELFLn6NTNX14/gyaQI5EUht1zrYCtXkibS00y5y+Uc65M6S6
         ojwdamwhzwysukTZ3IwJxMT43PJDsuXuQFZ3gKU80CTdLdvzpwSYs6d6SbLHzXSKCR61
         3QvmwMTBXPr+Pf3PtymujcZPQki0drF0VHE2yo3OlGicq63WQ6QDOgKaNy6cOfTuL3ey
         ywjet/aOHvO84TtpDrmEcRIrx3t2LqfnThxIZ5eI6eVT2blQghrGR9Ws1eFRw72HJF+0
         +G7NhkUHWMMMzOwID0UAcAue7UtvAZDdjMn6b4h9RAwD+Xx751zJxCSjuuFnB055Iieg
         R+Fg==
X-Gm-Message-State: AOAM531s7j3gSUr+XXTp7jMwUVs8eEYgchwJcam/g/Q4MAs7bslEHyNx
        s3/Q+u8fbYt8mXQwYj/Yv4B6PHdOHG0oLe6moyU3oO78
X-Google-Smtp-Source: ABdhPJyLbnAxanq+pggWtpgv5XgeL/6gLOqJ+UyeprNu4u/eezoRktisT2yjFB+ZKKcQAc9tf0H+5jnCY/j9ioB+OFk=
X-Received: by 2002:a17:902:b588:b0:143:b732:834 with SMTP id
 a8-20020a170902b58800b00143b7320834mr16304369pls.22.1638459286910; Thu, 02
 Dec 2021 07:34:46 -0800 (PST)
MIME-Version: 1.0
References: <1638410784-48646-1-git-send-email-cuibixuan@linux.alibaba.com>
 <20211201192643.ecb0586e0d53bf8454c93669@linux-foundation.org>
 <10cb0382-012b-5012-b664-c29461ce4de8@linux.alibaba.com> <20211201202905.b9892171e3f5b9a60f9da251@linux-foundation.org>
 <YaiiFxD7jfFT9cSR@azazel.net>
In-Reply-To: <YaiiFxD7jfFT9cSR@azazel.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 2 Dec 2021 07:34:36 -0800
Message-ID: <CAADnVQLV4Tf3LemvZoZHw7jcywZ4qqckv_EMQx3JF9kXtHhY-Q@mail.gmail.com>
Subject: Re: [PATCH -next] mm: delete oversized WARN_ON() in kvmalloc() calls
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Bixuan Cui <cuibixuan@linux.alibaba.com>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Leon Romanovsky <leon@kernel.org>, Willy Tarreau <w@1wt.eu>,
        Kees Cook <keescook@chromium.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 2, 2021 at 2:38 AM Jeremy Sowden <jeremy@azazel.net> wrote:
>
> On 2021-12-01, at 20:29:05 -0800, Andrew Morton wrote:
> > On Thu, 2 Dec 2021 12:05:15 +0800 Bixuan Cui wrote:
> > > =E5=9C=A8 2021/12/2 =E4=B8=8A=E5=8D=8811:26, Andrew Morton =E5=86=99=
=E9=81=93:
> > > >> Delete the WARN_ON() and return NULL directly for oversized
> > > >> parameter in kvmalloc() calls.
> > > >> Also add unlikely().
> > > >>
> > > >> Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
> > > >> Signed-off-by: Bixuan Cui<cuibixuan@linux.alibaba.com>
> > > >> ---
> > > >> There are a lot of oversize warnings and patches about kvmalloc()
> > > >> calls recently. Maybe these warnings are not very necessary.
> > > >
> > > > Or maybe they are.  Please let's take a look at these warnings,
> > > > one at a time.  If a large number of them are bogus then sure,
> > > > let's disable the runtime test.  But perhaps it's the case that
> > > > calling code has genuine issues and should be repaired.
> > >
> > > Such as=EF=BC=9A
> >
> > Thanks, that's helpful.
> >
> > Let's bring all these to the attention of the relevant developers.
> >
> > If the consensus is "the code's fine, the warning is bogus" then let's
> > consider retiring the warning.
> >
> > If the consensus is otherwise then hopefully they will fix their stuff!
> >
> > > https://syzkaller.appspot.com/bug?id=3D24452f89446639c901ac07379ccc70=
2808471e8e
> >
> > (cc bpf@vger.kernel.org)
> >
> > > https://syzkaller.appspot.com/bug?id=3Df7c5a86e747f9b7ce333e7295875cd=
4ede2c7a0d
> >
> > (cc netdev@vger.kernel.org, maintainers)
> >
> > > https://syzkaller.appspot.com/bug?id=3D8f306f3db150657a1f6bbe19274670=
84531602c7
> >
> > (cc kvm@vger.kernel.org)
> >
> > > https://syzkaller.appspot.com/bug?id=3D6f30adb592d476978777a1125d1f68=
0edfc23e00
> >
> > (cc netfilter-devel@vger.kernel.org)
>
> The netfilter bug has since been fixed:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/=
?id=3D7bbc3d385bd813077acaf0e6fdb2a86a901f5382

How is this a "fix" ?
u32 was the limit and because of the new warn the limit
got reduced to s32.
Every subsystem is supposed to do this "fix" now?

> > > https://syzkaller.appspot.com/bug?id=3D4c9ab8c7d0f8b551950db06559dc9c=
de4119ac83
> >
> > (bpf again).
>
> J.
