Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1A0F8F7CD
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 02:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfHPAEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 20:04:52 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44242 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbfHPAEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 20:04:52 -0400
Received: by mail-lj1-f194.google.com with SMTP id e24so3700413ljg.11;
        Thu, 15 Aug 2019 17:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jzbN2PRH8Zka7/UW6V9P9gljkC65SAE1K/ca6kY90Jk=;
        b=IBoLD6rDviQRwHAl25S9RqHtKJdhQuuQ5EQB+9Csv5Ed3z1w19vps4KTivjxTxDXF0
         1CTC0TK2+7KrTMt+QO0c16vNVM/PkHG36Z9Ksd3hdjqz/cisCcU4g+/RcqWW68WEPFoe
         x9JEdwy84E00LXz9tI7qP37OA0rAl+ZZ/DPImbNqOmt+vcclu1NzwYdAATLFKob9avHS
         /EZ3SKUNGZCkjhnUdxOhi1zN1+cpraK7Ow9WPQ4F25YqqLUUoJbz97TIjAzxDNeHJJ10
         PpA6g4RmIKd4IPt25sRR4Tn25arVS2ikHJ6aFc2BpZaD//64Xt2JbZaF2ZG4xcnqwvRO
         LAjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jzbN2PRH8Zka7/UW6V9P9gljkC65SAE1K/ca6kY90Jk=;
        b=MeHGyW1rcjT8dvDhlLhYIZEs9MKblaoCkdQNA44L0CPeS2z5gyUeMRwa6RrcQS7B4y
         CDYwotns+mlW/dQLDmA8pAJcmodOU5ZifoHicRlXvR9C8lEr6NpBDIlaXMdT/SO28TPq
         CvQx3Z7WkKJcBAX1NxofBkYPNDb/m2Gepa4sP5IP4hnAXuXFQY7uGvmLmCsbEfM03p8X
         shltZmwh16i4x91Sdn9wsXWfYMbrbWBzq8nHvQn2C7pnm3akqRlzOYpKoN8r3U6qDNxV
         ZKp/IgRH6VJaCneCHn1u7DAk/9e10BDm7FEiUsF74gLjo/iwhJeja3WLQsBgiG55hvJh
         1b+g==
X-Gm-Message-State: APjAAAV9wVVx0BP2J4NMvpkD/QDwaR21MO4LskZyBfcNtKVkP74IXR9B
        4i1zmNtholDsQJv6gc4zCmVjuvG0j8MPzrXVIuE=
X-Google-Smtp-Source: APXvYqys5comZwKsd0o+lPZLpXbcPeHdu8hAG/BECLU/1pT+hg1ambzUtEc6HHvj+hiPEK1rnZCD0pIyOSMZ1kwi32Q=
X-Received: by 2002:a2e:93cc:: with SMTP id p12mr4101539ljh.11.1565913890470;
 Thu, 15 Aug 2019 17:04:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190814200548.623033-1-andriin@fb.com> <20190814213335.GA90959@rdna-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190814213335.GA90959@rdna-mbp.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 15 Aug 2019 17:04:39 -0700
Message-ID: <CAADnVQKR1g_Se9L0Lob7hY8wzb3oZn+0hwex3=WwWUXGcJ1ehw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next] libbpf: make libbpf.map source of truth for
 libbpf version
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 3:16 PM Andrey Ignatov <rdna@fb.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> [Wed, 2019-08-14 13:57 -0700]:
> > Currently libbpf version is specified in 2 places: libbpf.map and
> > Makefile. They easily get out of sync and it's very easy to update one,
> > but forget to update another one. In addition, Github projection of
> > libbpf has to maintain its own version which has to be remembered to be
> > kept in sync manually, which is very error-prone approach.
> >
> > This patch makes libbpf.map a source of truth for libbpf version and
> > uses shell invocation to parse out correct full and major libbpf version
> > to use during build. Now we need to make sure that once new release
> > cycle starts, we need to add (initially) empty section to libbpf.map
> > with correct latest version.
> >
> > This also will make it possible to keep Github projection consistent
> > with kernel sources version of libbpf by adopting similar parsing of
> > version from libbpf.map.
> >
> > v2->v3:
> > - grep -o + sort -rV (Andrey);
> >
> > v1->v2:
> > - eager version vars evaluation (Jakub);
> > - simplified version regex (Andrey);
>
> Acked-by: Andrey Ignatov <rdna@fb.com>

Applied. Thanks
