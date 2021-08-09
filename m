Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C963E3E477E
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 16:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbhHIOZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 10:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234987AbhHIOZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 10:25:29 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7AD5C0613D3;
        Mon,  9 Aug 2021 07:25:08 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id bl13so3251151qvb.5;
        Mon, 09 Aug 2021 07:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5yNSrZ9OgRElplEMES641bIq1GicFeBQVlnMIQt9msg=;
        b=cr0QN7T9NuKMC8eoPx1PBtHNvm5/eJYg9W6w5gJV1PnPzXTr6B2T5WSF7VC5NV3aB1
         wENS6iHRimQtYdPQ76nKMYo3szlnF3z7EKMXTDb5CgsxroPmzT7YAjUcMuOFb4hB/Oyp
         f5rmOl+fJDA8XSuqUFRtd/7wPFiaVBcoXhJgswlfsK59SK684+o6lTawdb63X3QQ0CG7
         HCsK5AZ79tC6LjPBeCMZVOrfetk+czZmH27AqikZWjpsTSspC7qXaS8jRqYwf5xZLpvk
         Vh4tXo8lZHrI1TgOyjduJloM7SfRNa7YgAY//2y4qFKi6sOkoyQK5EWCN8DxNtSzixBp
         f9wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5yNSrZ9OgRElplEMES641bIq1GicFeBQVlnMIQt9msg=;
        b=gayPpcnc9IN1S4uZi7xUm78wBkdbSA0BeV3Yd9fWJ2vqOFmz0sC6AC5ROiiYwtaFol
         RY21//5nPDjIv6vC4CR2yNnl8DwYyammRi3ozIN2Ul3J7qAh0r4gNjwBVGiUzetnnZ2y
         RMuHoGjc+TFw9rZpV1Is1BsrUG8C2FmRgK1qh3lDXJu0KW7XVMrILw9tSouitfbjqhrv
         fHC0yyPjWZm9kj/1f7iIvbNNxw8pOs+YqY7oH6gf4Lx42QkA/KdD7RTRp0tGwD/mzeLr
         HNj+Aq77X1wjAsD043XJT9r1+jB57uLOULj72kpYH7o56mFG0peaXhmsTxZWBYRuQeQP
         knZw==
X-Gm-Message-State: AOAM530BnHKrtNtoaTRZ14IIYGce2BT1iE9+CCA4YmwphSz+IARi83oq
        2pGQ78qpSlHpF18FwLy2TSXC51pFCk40d952mg==
X-Google-Smtp-Source: ABdhPJw/Nuxtz1GLTUgwUnqx8Eh8xwqmbJ6TNzgXO/Ur3HhHjrTjIkVg09uyNDhlfNRxRid75ifP5h5n/pAWh/8ekdY=
X-Received: by 2002:a05:6214:2482:: with SMTP id gi2mr2738564qvb.40.1628519107917;
 Mon, 09 Aug 2021 07:25:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210609135537.1460244-1-joamaki@gmail.com> <20210731055738.16820-1-joamaki@gmail.com>
 <20210731055738.16820-8-joamaki@gmail.com> <CAEf4BzZvojbuHseDbnqRUMAAfn-j4J+_3omWJw8=W6cTPmf0dw@mail.gmail.com>
In-Reply-To: <CAEf4BzZvojbuHseDbnqRUMAAfn-j4J+_3omWJw8=W6cTPmf0dw@mail.gmail.com>
From:   Jussi Maki <joamaki@gmail.com>
Date:   Mon, 9 Aug 2021 16:24:56 +0200
Message-ID: <CAHn8xcnBQhO_=YEO2cd_uCRYQDZkfQjW2r8aExu8=FYTi_=X5A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 7/7] selftests/bpf: Add tests for XDP bonding
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, j.vosburgh@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>, vfalico@gmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 7, 2021 at 12:50 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Aug 5, 2021 at 9:10 AM Jussi Maki <joamaki@gmail.com> wrote:
> >
> > Add a test suite to test XDP bonding implementation
> > over a pair of veth devices.
> >
> > Signed-off-by: Jussi Maki <joamaki@gmail.com>
> > ---
> >  .../selftests/bpf/prog_tests/xdp_bonding.c    | 520 ++++++++++++++++++
> >  1 file changed, 520 insertions(+)
> >
>
> I don't pretend to understand what's going on in this selftests, but
> it looks good from the generic selftest standpoint. One and half small
> issues below, please double-check (and probably fix the fd close
> issue).

Thanks for the reviews!

> > +       if (xdp_attach(skeletons,
> > +                      skeletons->xdp_redirect_multi_kern->progs.xdp_redirect_map_multi_prog,
> > +                      "bond2"))
> > +               goto out;
> > +
> > +       restore_root_netns();
>
> the "goto out" below might call restore_root_netns() again, is that ok?

Yep that's fine.

> > +       if (!test__start_subtest("xdp_bonding_redirect_multi"))
> > +               test_xdp_bonding_redirect_multi(&skeletons);
> > +
> > +out:
> > +       xdp_dummy__destroy(skeletons.xdp_dummy);
> > +       xdp_tx__destroy(skeletons.xdp_tx);
> > +       xdp_redirect_multi_kern__destroy(skeletons.xdp_redirect_multi_kern);
> > +
> > +       libbpf_set_print(old_print_fn);
> > +       if (root_netns_fd)
>
> technically, fd could be 0, so for fds we have if (fd >= 0)
> everywhere. Also, if open() above fails, root_netns_fd will be -1 and
> you'll still attempt to close it.

Good catch. Daniel, could you fix this when applying to be "if
(root_netns_fd >= 0)"?
