Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A48F14AEB3
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 01:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbfFRXX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 19:23:58 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42848 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfFRXXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 19:23:55 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so8519497pff.9
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 16:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yizxKA+GyJli3eqqrpbb4DYDLLjXbQU+Q22/YuAt3Ks=;
        b=RB6nB51FPJF8i8/ze5DXVlQyZEayBAeO6VsefUkPyuO8DBgfpVd9WEBMLC27LmWD8H
         GqU2xQkM6MnYTxoe38q8Ik/7zYMqZ+NbY4cm1CQnYy7D80pqweUyT2oM8RSQPoQq3Zra
         inxDhXDXUa+Y/xsumGLMCq7/OE6EA6kWVln//t4u5xoSa0CM3RSFpA/MushpSt2waH+U
         5zzCVSNAMYneDP7bbRNUzvvchS6ypGjBWcrAjpYtt3YvtIRHQDZc1lnYRzHoItr4OvUe
         Yb6dbjm8oo58LOr69GDfh74xarzLnxfApZUVhFLtHby19/y1TewisS9ydT9u2z3ILYrD
         cHEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yizxKA+GyJli3eqqrpbb4DYDLLjXbQU+Q22/YuAt3Ks=;
        b=c9Al812nHWonvfOXv2sjXkc5Vk1gBil07s53iKIcUDUH4B06n2BXbFz0idESi2MYWM
         u+TJFs4hJG34xoPFpTd/wV4c/fEWtjqy3Drc7wezZw88fUt5sdQvidw1kvW/c4qLZ/4o
         BcSiwyLicV7ZD942u/+XGiFNeSIBnfKCihFyFIWNj2ZdadMBJexgoaEMICzlTvO6dYAc
         uX+ea/BI7teiyrs7fAhXf6QTtHtPW2iuba7aFqfXFTnG7MRVDtZ1uf7WgwUMUwB4yp7Q
         W1nK4iU8Q91dtw4Jb2Jp9ZQHhZAJcUu/AcDx1vPbrBs4x1iLLB3sxfmXdVcxQHyT15Gw
         H/qA==
X-Gm-Message-State: APjAAAVp5l81wLpC7aYtqbudxp0q0q7CVL14AsFPM5Gz0ul3uvabPTr2
        ixCq5cyVZsDZTfboeWzrbtabZuw+QlKXjo0jBGjM0jqOJPI=
X-Google-Smtp-Source: APXvYqwfFlH7wp6h280gsbZSdIDu49HSzsQIrIjdAtKu8MLNTDCOshQCrZWw7VVDADBOJH8JeDoC70TiuyJniXPxmuE=
X-Received: by 2002:a63:52:: with SMTP id 79mr4888663pga.381.1560900234263;
 Tue, 18 Jun 2019 16:23:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190618211440.54179-1-mka@chromium.org> <20190618230420.GA84107@archlinux-epyc>
In-Reply-To: <20190618230420.GA84107@archlinux-epyc>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 18 Jun 2019 16:23:43 -0700
Message-ID: <CAKwvOd=i2qsEO90cHn-Zvgd7vbhK5Z4RH89gJGy=Cjzbi9QRMA@mail.gmail.com>
Subject: Re: [PATCH] net/ipv4: fib_trie: Avoid cryptic ternary expressions
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexander Duyck <alexander.h.duyck@redhat.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Nathan Huckleberry <nhuck@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 4:04 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Tue, Jun 18, 2019 at 02:14:40PM -0700, Matthias Kaehlcke wrote:
> > empty_child_inc/dec() use the ternary operator for conditional
> > operations. The conditions involve the post/pre in/decrement
> > operator and the operation is only performed when the condition
> > is *not* true. This is hard to parse for humans, use a regular
> > 'if' construct instead and perform the in/decrement separately.
> >
> > This also fixes two warnings that are emitted about the value
> > of the ternary expression being unused, when building the kernel
> > with clang + "kbuild: Remove unnecessary -Wno-unused-value"
> > (https://lore.kernel.org/patchwork/patch/1089869/):
> >
> > CC      net/ipv4/fib_trie.o
> > net/ipv4/fib_trie.c:351:2: error: expression result unused [-Werror,-Wunused-value]
> >         ++tn_info(n)->empty_children ? : ++tn_info(n)->full_children;
> >
>
> As an FYI, this is also being fixed in clang:
>
> https://bugs.llvm.org/show_bug.cgi?id=42239
>
> https://reviews.llvm.org/D63369

While I'm glad we found and fixed a bug in Clang; I'm still for fixing
the underlying code from a readability perspective.  If it takes
longer than a few seconds to understand a statement to the non-author,
the code as written may be too clever.

As a side note, I'm going to try to see if MAINTAINERS and
scripts/get_maintainers.pl supports regexes on the commit messages in
order to cc our mailing list (clang-built-linux
<clang-built-linux@googlegroups.com>) automatically; but in the
meantime please try to remember to cc the list manually.  I usually
find it quickly from the bookmarked https://clangbuiltlinux.github.io/
which lists it there) (but I should still automate this).

>
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> > I have no good understanding of the fib_trie code, but the
> > disentangled code looks wrong, and it should be equivalent to the
> > cryptic version, unless I messed it up. In empty_child_inc()
> > 'full_children' is only incremented when 'empty_children' is -1. I
> > suspect a bug in the cryptic code, but am surprised why it hasn't
> > blown up yet. Or is it intended behavior that is just
> > super-counterintuitive?
> >
> > For now I'm leaving it at disentangling the cryptic expressions,
> > if there is a bug we can discuss what action to take.
> > ---
> >  net/ipv4/fib_trie.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> > index 868c74771fa9..cf7788e336b7 100644
> > --- a/net/ipv4/fib_trie.c
> > +++ b/net/ipv4/fib_trie.c
> > @@ -338,12 +338,18 @@ static struct tnode *tnode_alloc(int bits)
> >
> >  static inline void empty_child_inc(struct key_vector *n)
> >  {
> > -     ++tn_info(n)->empty_children ? : ++tn_info(n)->full_children;
> > +     tn_info(n)->empty_children++;
> > +
> > +     if (!tn_info(n)->empty_children)
> > +             tn_info(n)->full_children++;
> >  }
> >
> >  static inline void empty_child_dec(struct key_vector *n)
> >  {
> > -     tn_info(n)->empty_children-- ? : tn_info(n)->full_children--;
> > +     if (!tn_info(n)->empty_children)
> > +             tn_info(n)->full_children--;
> > +
> > +     tn_info(n)->empty_children--;

This change looks correct to me, so thanks for the patch and:
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

(Bikeshed; I prefer pre-inc/dec to post-inc/dec unless you really care
about the previous value. Should be irrelevant with a sufficiently
smart compiler though. ;) )
-- 
Thanks,
~Nick Desaulniers
