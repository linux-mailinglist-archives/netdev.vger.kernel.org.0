Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56B55DEFBB
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbfJUOfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:35:21 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:32818 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbfJUOfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:35:21 -0400
Received: by mail-lf1-f65.google.com with SMTP id y127so10340436lfc.0;
        Mon, 21 Oct 2019 07:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Puqp1vtFCoAgpGfPnGRZebXKj2ghL+E6SExDr1g1jGw=;
        b=UwZaMeyCRsX92I8J/toz6UrEdz88OUsQB+aZtJCqly16I4LSs4RIIf8ugLcDjPlzZj
         WRPF9tZoc+t7ZzpOwPP9Fv57jxpx5cO9NkIcaIySva09Hu8hFwvINeefE4/pJz9m7XAA
         cEU6u7l+KFMXgljUDcqOgr0XnCWPhTjiTz6kCAG6D+6egipp8n/vSLyO3OvJPp9p1mP8
         MeDqb4EN43ioUC8FCZIAnB87CYzWAa/dIfQzIbepe/iBqYLq7fJfVffztLIPsuwkkQGJ
         xjA/MGPFB5eEt39VSIlSkpYQMU6tmv8SmnQBCXzGqQtbGiYWVKOn3Qj33C4W9QrxOq9Z
         /Vqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Puqp1vtFCoAgpGfPnGRZebXKj2ghL+E6SExDr1g1jGw=;
        b=LJzk5EHfaBjGndM7HYPLedZss7aYKmcAXXIpPHYiS6IICDLjhNosLD8E1/l2c99kPr
         NQvTznjePIHs80oilQT1lrQnOhUGXdLKsGnmHbVLGXB85T/fKb/Wg9f+Uw7xj6GMwRvs
         RwHpHbm0lUJ1HPuvjqTz8Tpe4dAtRWYaC5xwNAilY0j7mEeDGRy33ZJfDq1A1ohuQlqS
         cxLcfQoTF1rkNpfQt2uwLmI/vyg+bzg8VovwHcpuS2+FHOgQ6EW7qKsTZxdMsu2PJqeN
         ZqyvWTIJZWdBLDlHu1iXjKhcAljtbHa1HcKOmBH3XoF75WK/LKT/J1+cs3OPCJ0bsru7
         rQxQ==
X-Gm-Message-State: APjAAAVzRuvBSJQHBvaEToX3GkStuUJSKjjFHGlLaATxtBxVXy6oJEBg
        cParhWgGdPq7trPeDW4CBlxuD1i1LaIRdIYjB9s=
X-Google-Smtp-Source: APXvYqxNBHFLREfBvxJOXdO5tgqJMa90zRpePn2kDTl5vjP8CrcCbfg30g6ajSXr9CvYv0Mf0n13lgc8EFwk5gQiuXw=
X-Received: by 2002:a19:cc07:: with SMTP id c7mr15915504lfg.107.1571668519156;
 Mon, 21 Oct 2019 07:35:19 -0700 (PDT)
MIME-Version: 1.0
References: <20191021105938.11820-1-bjorn.topel@gmail.com> <87h842qpvi.fsf@toke.dk>
 <CAJ+HfNiNwTbER1NfaKamx0p1VcBHjHSXb4_66+2eBff95pmNFg@mail.gmail.com>
 <87bluaqoim.fsf@toke.dk> <CAJ+HfNgWeY7oLwun2Lt4nbT-Mh2yETZfHOGcYhvD=A+-UxWVOw@mail.gmail.com>
In-Reply-To: <CAJ+HfNgWeY7oLwun2Lt4nbT-Mh2yETZfHOGcYhvD=A+-UxWVOw@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 21 Oct 2019 16:35:06 +0200
Message-ID: <CAJ+HfNjd+eMAmeBnZ8iANjcea9ZT2cnvm3axuRwvUEMDpa5zHw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: use implicit XSKMAP lookup from
 AF_XDP XDP program
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Jiong Wang <jiong.wang@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 at 15:37, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>=
 wrote:
>
> On Mon, 21 Oct 2019 at 14:19, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
> >
> > Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
> >
> [...]
> > >
> > > bpf_redirect_map() returns a 32-bit signed int, so the upper 32-bit
> > > will need to be cleared. Having an explicit AND is one instruction
> > > less than two shifts. So, it's an optimization (every instruction is
> > > sacred).
> >
> > OIC. Well, a comment explaining that might be nice (since you're doing
> > per-instruction comments anyway)? :)
> >
>
> Sure, I can do a v3 with a comment, unless someone has a better idea
> avoiding both shifts and AND.
>
> Thanks for taking a look!
>

Now wait, there are the JMP32 instructions that Jiong added. So,
shifts/AND can be avoided. Now, regarding backward compat... JMP32 is
pretty new. I need to think a bit how to approach this. I mean, I'd
like to be able to use new BPF instructions.


Bj=C3=B6rn

>
> Bj=C3=B6rn
>
>
> > -Toke
> >
