Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0071B11E718
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 16:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbfLMPwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 10:52:07 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37052 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbfLMPwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 10:52:07 -0500
Received: by mail-lj1-f196.google.com with SMTP id u17so3179215lja.4;
        Fri, 13 Dec 2019 07:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=i7YTkA1cQTp5eGp2y0iD7RE/V0troD05dR2FE4I3UBU=;
        b=bSQKFvuTsitiapoo0Dbtw2hAScrQu1lyS0OpUdvvoFusz+5LQhCM1nYn9SBW6VkrYk
         9TP+TVxEmJibaV24eE375vbI6X+IRpdIyyMjuVgA5HbpCNZGU3iK+PKKGk3XVjP0jLh0
         0UYiKnJlrvM7C+zljKWQ17cWi+jiLmPfvAVi+XdgCxtESLtYy69qb/RrVgGGGLaQHAKc
         C/mqpPHh42/sAVPLY7ysk282FJ3jdKk2JplhDNUnjRhlyXqy4duxP8GT7WkdytLVVKWK
         VLi7KXvRcwa6tDWecmqjZMDoOLeTvfxohbHckhLKs97nGU+adrMHuiXXl5qyYEh6Ezzl
         pypQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=i7YTkA1cQTp5eGp2y0iD7RE/V0troD05dR2FE4I3UBU=;
        b=Fs1jX/JMQ7/mYBNTWE75JjT1ml8GT0sRKN6vtXt1ENmHhmGv+T6UlUvjbDYUmmBKXo
         0n+ulde4Pn8FxGuJ48nvTWk4Q4fN6weJzmsIs96wnPcgTSZyVzoTwn5pKD/mfSnzMYoi
         JiQi1n8Im7WpwFunndEs6xypkSsjcP1JIIJR3D9DyYtZm3b02kiC/DXxURyCjZ6+glmV
         h83pI4OdCGCjJKC00PshzDhs8+R4h19cIBqbWDQDeYt8kVSMcmG8RfLP+wwwyX2m4JO5
         p73BeOCYuFxKXtVzWEVvHiEl5O7zipTTluPfraKm2bDpKn8zmChziYGZ8cbe7FtJTT2H
         dbqA==
X-Gm-Message-State: APjAAAWuqKVXrBii0IHqW328af8+jjAT0iE/p2thuC1NmSBZgSTO5Aas
        K+WuMmNxAsTwWSXvDdnpIKAkD/TqJ+ouQib9Pio=
X-Google-Smtp-Source: APXvYqwQfwjWXPwDgT6mU0Fj8lyQ0OXOEkBNdxZ9KK8TWwNcY1tCuFnPxaYGSj52T5X92XXMrBpcS4ZmG7wklTxJ7Qs=
X-Received: by 2002:a2e:999a:: with SMTP id w26mr10346440lji.142.1576252324642;
 Fri, 13 Dec 2019 07:52:04 -0800 (PST)
MIME-Version: 1.0
References: <20191211123017.13212-1-bjorn.topel@gmail.com> <20191211123017.13212-3-bjorn.topel@gmail.com>
 <20191213053054.l3o6xlziqzwqxq22@ast-mbp> <CAJ+HfNiYHM1v8SXs54rkT86MrNxuB5V_KyHjwYupcjUsMf1nSQ@mail.gmail.com>
 <20191213150407.laqt2n2ue2ahsu2b@ast-mbp.dhcp.thefacebook.com> <CAJ+HfNgjvT2O=ux=AqdDdO=QSwBkALvXSBjZhib6zGu=AeARwA@mail.gmail.com>
In-Reply-To: <CAJ+HfNgjvT2O=ux=AqdDdO=QSwBkALvXSBjZhib6zGu=AeARwA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 13 Dec 2019 07:51:53 -0800
Message-ID: <CAADnVQLPJPDGY8aJwrTjOxVaDkZ3KM1_aBVc5jGwxxtNB+dBrg@mail.gmail.com>
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

On Fri, Dec 13, 2019 at 7:49 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> On Fri, 13 Dec 2019 at 16:04, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Dec 13, 2019 at 08:51:47AM +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> > >
> > > > I hope my guess that compiler didn't inline it is correct. Then ext=
ra noinline
> > > > will not hurt and that's the only thing needed to avoid the issue.
> > > >
> > >
> > > I'd say it's broken not marking it as noinline, and I was lucky. It
> > > would break if other BPF entrypoints that are being called from
> > > filter.o would appear. I'll wait for more comments, and respin a v5
> > > after the weekend.
> >
> > Also noticed that EXPORT_SYMBOL for dispatch function is not necessary =
atm.
> > Please drop it. It can be added later when need arises.
> >
>
> It's needed for module builds, so I cannot drop it!

Not following. Which module it's used out of?
