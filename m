Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 587B7629ED
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbfGHTzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:55:23 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36251 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbfGHTzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:55:23 -0400
Received: by mail-qk1-f196.google.com with SMTP id g18so14291902qkl.3;
        Mon, 08 Jul 2019 12:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZP6Wi2bcW8eMV5fY66aNmoLqPc0K1GHr7SKGXvo3cIM=;
        b=qX8zF8XzK6OmbEHzWqgDKB8SiO/R/PCsxGPGscK/uY40RWGcpUbagNybvAymlpU7cU
         3jiccHPxj3TlTtkMkTo2sSfSlgdH5FeTjpnci6Uq8dpyufmyDYGdhb9g0udMlSQZlPwk
         NfnCd83wS1ErLdP+VGsrv+3Rv98i3gSmKEFn/99ua8PbuuqIwSue94yuPsFhrVgYhQvv
         TdjnbpS+SzxA1y0Z8pZcJO24LfUDcW5bBNJAhgtvQIzPpZS/2HsDVBmzd4em9iB81o/p
         hf7zVwSOPhtC8cwmdKOxQznN1MK7dSDF1xoexQsy+yHjr1NxrCCxzTOds+IE2yVYHlGc
         qSqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZP6Wi2bcW8eMV5fY66aNmoLqPc0K1GHr7SKGXvo3cIM=;
        b=XSP8H8h7qdz2kh6I0fEBfnaEmcWiDPbkX6UV5qQjKo7dtQJ0+3GiLreq7du75H41o9
         i6o0TRd7l4tkcZG/Aa+top4WtpOR7cCX41IBdsy3XrDph8ZjbAGIEqA2DoA8ush9yCqQ
         jaUxcJOi/hyhW6wWBGNzZhcyACS1wse9SLyiLva/k3vtmoUYAwFpUK2p5svY+Uyxf80r
         MW7lj4VjvtDB+V/BUUWrObVIIxlAdZr7HpQmOiFQFS/oTk2i4Z8Nyzs1elAcl5EHcHOT
         6/vl4TbkCfGXUQWUWFVKa5++nCOOyho/+r/qFeVVxVT/OYCJdpe6bzBRwxu7CUa2KVKk
         aHnQ==
X-Gm-Message-State: APjAAAVveN1vseH1cWKRq9S12rGj41arTjxJwrCDpqSiecWPXpINCzDI
        EMf/tjob8X+y5G8apdM5mJoXvQmC2Kr3hO7P648=
X-Google-Smtp-Source: APXvYqwYvdBzSZ9xA/YZxULD4qS3l4wuYZK6EgM2PHbJUwyNNhbmPXHLQRTdFBGC7RYQ1gJfE8SVmji4c8gtK/YbTp8=
X-Received: by 2002:a05:620a:16a6:: with SMTP id s6mr15390985qkj.39.1562615722356;
 Mon, 08 Jul 2019 12:55:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAH+k93FQkiwRXwgRGrUJEpmAGZBL03URKDmx8uVA9MnLrDKn0Q@mail.gmail.com>
 <CAEf4Bzb-EM41TLAkshQa=nVwiVuYnEYyhVL38gcaG=OaHoJJ6Q@mail.gmail.com> <CAH+k93G=qGLfEKe+3dSZPKhmxrc8JiPqDppGa-yLSwaQYRJU=Q@mail.gmail.com>
In-Reply-To: <CAH+k93G=qGLfEKe+3dSZPKhmxrc8JiPqDppGa-yLSwaQYRJU=Q@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Jul 2019 12:55:11 -0700
Message-ID: <CAEf4BzazxVu8ym35Y8GqYH2rDmeXivyEBxtpcMzpux93svyApg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 4/9] libbpf: add kprobe/uprobe attach API
To:     Matt Hart <matthew.hart@linaro.org>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 8, 2019 at 12:27 PM Matt Hart <matthew.hart@linaro.org> wrote:
>
> On Mon, 8 Jul 2019 at 18:58, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
> >
> > On Mon, Jul 8, 2019 at 8:11 AM Matt Hart <matthew.hart@linaro.org> wrot=
e:
> > >
> > > Hi all,
> > >
> > > I bisected a perf build error on ARMv7 to this patch:
> > > libbpf.c: In function =E2=80=98perf_event_open_probe=E2=80=99:
> > > libbpf.c:4112:17: error: cast from pointer to integer of different
> > > size [-Werror=3Dpointer-to-int-cast]
> > >   attr.config1 =3D (uint64_t)(void *)name; /* kprobe_func or uprobe_p=
ath */
> > >                  ^
> > >
> > > Is this a known issue?
> >
> > No, thanks for reporting!
> >
> > It should be
> >
> > attr.config1 =3D (uint64_t)(uintptr_t)(void *)name;
> >
> > to avoid warning on 32-bit architectures.
>
> Tested with manual change and can confirm perf now builds without errors.

Thanks for testing!

I'll add Tested-by: Matt Hart <matthew.hart@linaro.org> when posting a fix.

>
> >
> > I'll post a fix later today, but if you could verify this fixes
> > warning for you, I'd really appreciate that! Thanks!
