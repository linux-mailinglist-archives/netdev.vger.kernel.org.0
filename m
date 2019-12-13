Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFB011E77A
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 17:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbfLMQEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 11:04:00 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36032 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727932AbfLMQD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 11:03:56 -0500
Received: by mail-lj1-f194.google.com with SMTP id r19so3228104ljg.3;
        Fri, 13 Dec 2019 08:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LjRFBghPWC1v8bTF3vc7k1OpeUoeVtYERU+mUsFqUAE=;
        b=hGuH/7BhoJdI2P520qwvg27rEsSgx6OIHf62UxFGsvjYTA7ZxjolYu9/QaT7J+546H
         fkRM1FLh/KakOsX0B6kwF36qFtnrPmhe3CxVL9lAvx+rfypoZzHgREtSRpNrRCmhSzjL
         N5KmWPV6zC6//ZDXdGxQGLKqTKYmafVU+kuiBIjAcjr/xvf1GWLzzfVNqrcrAa4/DLFc
         K/F39cSEw/zBoFSu7LgqVtPtLUxsxy37d7XmdqS0qhhuI/WBpY/zRcZO274PodP76oPX
         M1WxCxXL+RHT4CJeQ7vqA2oxM2C+G6tyF63ZlUuUjW6f9yNUXrCrErRgIE3V1GE/Z0Aw
         QuRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LjRFBghPWC1v8bTF3vc7k1OpeUoeVtYERU+mUsFqUAE=;
        b=jpDDH68HK9CK6NjdJkuAZYV2KtJx8EvffkPjIPBwqu2WRaW5eMHjCOGe5lcDP4Kqm1
         Gqap/uf17bcWjCkGe+JzBIoaeR6kamQI08p1/NUQb3ceEqRnigwHZLhoyheW0uNXe1yQ
         IkjHVcdMrxFzx2JUQmOWUvm1Td96rghE7Dp+9XwCRhyOAsIILWZE36FvRG3Duoec7Cgn
         D8VeZClBLYKAGC1xhh7nnQZu0jxW8xy3hXpsPbDKOe8Hw/QvgnIJKTlNcbJ3TeMOiUBb
         7l193mw+/Viw6pFXj1UmVX1Z/e9uRyYmlvpeSvzF9EKmKiSRkyXQmR9e3NhsxSg3ok+V
         kLlQ==
X-Gm-Message-State: APjAAAWS8v1fEAc5gj0lYvXLvLb6KFb6rFmzKl73vlNCbctU60j7MyZX
        WTGuezHxLG/b6SikwTD7OMUi+23kmPVTwvvALig=
X-Google-Smtp-Source: APXvYqwi8E3YS3qeh5ndArZW8hWuXuXkgKYujuDCBwEkiWaMkqztzNp8yc8ciaMA9WZqiQHyQhfZ9RHz7aIO9iBf4m4=
X-Received: by 2002:a2e:3609:: with SMTP id d9mr9986785lja.188.1576253033316;
 Fri, 13 Dec 2019 08:03:53 -0800 (PST)
MIME-Version: 1.0
References: <20191211123017.13212-1-bjorn.topel@gmail.com> <20191211123017.13212-3-bjorn.topel@gmail.com>
 <20191213053054.l3o6xlziqzwqxq22@ast-mbp> <CAJ+HfNiYHM1v8SXs54rkT86MrNxuB5V_KyHjwYupcjUsMf1nSQ@mail.gmail.com>
 <20191213150407.laqt2n2ue2ahsu2b@ast-mbp.dhcp.thefacebook.com>
 <CAJ+HfNgjvT2O=ux=AqdDdO=QSwBkALvXSBjZhib6zGu=AeARwA@mail.gmail.com>
 <CAADnVQLPJPDGY8aJwrTjOxVaDkZ3KM1_aBVc5jGwxxtNB+dBrg@mail.gmail.com> <CAJ+HfNg4uAA+++LvhPG8cvkz7X_wjJkB8vYGNeZROaDV6eDXmA@mail.gmail.com>
In-Reply-To: <CAJ+HfNg4uAA+++LvhPG8cvkz7X_wjJkB8vYGNeZROaDV6eDXmA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 13 Dec 2019 08:03:42 -0800
Message-ID: <CAADnVQ+eD-=FZrg8L+YcdCyAS+E30W=Z-ShtEXAXVFjmxV4usg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/6] bpf: introduce BPF dispatcher
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <thoiland@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 7:59 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> On Fri, 13 Dec 2019 at 16:52, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Dec 13, 2019 at 7:49 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmai=
l.com> wrote:
> > >
> > > On Fri, 13 Dec 2019 at 16:04, Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Fri, Dec 13, 2019 at 08:51:47AM +0100, Bj=C3=B6rn T=C3=B6pel wro=
te:
> > > > >
> > > > > > I hope my guess that compiler didn't inline it is correct. Then=
 extra noinline
> > > > > > will not hurt and that's the only thing needed to avoid the iss=
ue.
> > > > > >
> > > > >
> > > > > I'd say it's broken not marking it as noinline, and I was lucky. =
It
> > > > > would break if other BPF entrypoints that are being called from
> > > > > filter.o would appear. I'll wait for more comments, and respin a =
v5
> > > > > after the weekend.
> > > >
> > > > Also noticed that EXPORT_SYMBOL for dispatch function is not necess=
ary atm.
> > > > Please drop it. It can be added later when need arises.
> > > >
> > >
> > > It's needed for module builds, so I cannot drop it!
> >
> > Not following. Which module it's used out of?
>
> The trampoline is referenced from bpf_prog_run_xdp(), which is
> inlined. Without EXPORT, the symbol is not visible for the module. So,
> if, say i40e, is built as a module, you'll get a linker error.

I'm still not following. i40e is not using this dispatch logic any more.
