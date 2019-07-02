Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9755D467
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfGBQio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:38:44 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:41154 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfGBQin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:38:43 -0400
Received: by mail-ot1-f67.google.com with SMTP id o101so17532523ota.8;
        Tue, 02 Jul 2019 09:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UKXv4h9SKegeQCsv4/O0oRPR/IAKKAyLeFaWSRKIHY4=;
        b=IC3/zVDAUTM8AkL/cKJxA/sv08Yc5HPLh5l55OtY2nagtP6fYGV//fFQI3haqFRcy3
         LWIviBAPLNAj1+vD0V/bQV43VSq+tklVOPktxx5PIE23CXYw06AOpEcfE0lp66iY/F8f
         NU2EcIcink8hXagmG8Y6ZCz+v5YpMUxgsiKo3MuM4DsT+zGSZmssZGKm+zWVl2WToiO3
         vdaDnnOBV4U3k9EKeOAqVXpefdPjcrvcOz0Jb+lDs56vspgFvEx/tR+brR2jV2uI2Rmk
         m6/Esl2KEmBcKFK5u+ZQuyz3+rZvA7jZ6LPK6V3b5q4D5SxJomqFNmJ2NQYLELHHhSRp
         +ffw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UKXv4h9SKegeQCsv4/O0oRPR/IAKKAyLeFaWSRKIHY4=;
        b=jDHGn0H7CLxBHYQ87hX3c9moJ5Pj/hWP1sJO9zHIhDJDFyr86wyWuoqVvCRVZU5Ixl
         a3ayguErQ3g/QYfOy5G+b9YR3yaCtlaL5IEXXtgFlEDQs2cCVvQMwr5gUTQ/D1VzYXV3
         xUa9N8DSuaAPt3Z2d8SmwLwQbpvZq7Et5dm6Ucfz5b/hibrgeGDIcZeMpC3GIi6QJgZQ
         c9uBMBnKnmuSdxx49F+VIdqhQtR18XmEPZH5nqo7LLHvNLZ37CuM3PrBpSoR6I43OGFY
         IOMzwtw8HpZ/5qPgL/4Uz47sJCQUrBReTuiIjdhw8ETQlO3KRDs0JhkpShCwMkZE29Km
         Kxjw==
X-Gm-Message-State: APjAAAXAqlpG97Lsj2YpXlI6ux9OwH57AHx/1OcUd2eGh0PteSpFgkLl
        w0KWdZTp6Wmn5mT3qkgpDJBZK1ufEZOWdoLHWrM=
X-Google-Smtp-Source: APXvYqzdT0/5AsiSmm+ZN8GqzMADd1frb1Dut5fCUJfQygNPDGWATginm9NWpyK8DQvIKc8AJoG5PIgtE6Kc7j7UCMI=
X-Received: by 2002:a9d:77c2:: with SMTP id w2mr6609367otl.192.1562085523075;
 Tue, 02 Jul 2019 09:38:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190702151620.3382559-1-andriin@fb.com> <CAH3MdRWeH=Ko_mAvWk2mUaMK50iNHLbZkHKK=dVTzuwihZeRuA@mail.gmail.com>
In-Reply-To: <CAH3MdRWeH=Ko_mAvWk2mUaMK50iNHLbZkHKK=dVTzuwihZeRuA@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 2 Jul 2019 18:38:32 +0200
Message-ID: <CAJ8uoz37Ukj1qaZre1-=Rm3GZkkxGW8zxQ85fg5YLHaMWXNp3g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: fix GCC8 warning for strncpy
To:     Y Song <ys114321@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 6:11 PM Y Song <ys114321@gmail.com> wrote:
>
> On Tue, Jul 2, 2019 at 8:17 AM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > GCC8 started emitting warning about using strncpy with number of bytes
> > exactly equal destination size, which is generally unsafe, as can lead
> > to non-zero terminated string being copied. Use IFNAMSIZ - 1 as number
> > of bytes to ensure name is always zero-terminated.
> >
> > Cc: Magnus Karlsson <magnus.karlsson@intel.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Acked-by: Yonghong Song <yhs@fb.com>

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

>
> > ---
> >  tools/lib/bpf/xsk.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > index bf15a80a37c2..b33740221b7e 100644
> > --- a/tools/lib/bpf/xsk.c
> > +++ b/tools/lib/bpf/xsk.c
> > @@ -327,7 +327,8 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
> >
> >         channels.cmd = ETHTOOL_GCHANNELS;
> >         ifr.ifr_data = (void *)&channels;
> > -       strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ);
> > +       strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
> > +       ifr.ifr_name[IFNAMSIZ - 1] = '\0';
> >         err = ioctl(fd, SIOCETHTOOL, &ifr);
> >         if (err && errno != EOPNOTSUPP) {
> >                 ret = -errno;
> > --
> > 2.17.1
> >
