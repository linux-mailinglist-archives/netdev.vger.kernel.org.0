Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3186D66D
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 23:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbfGRV2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 17:28:52 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:46535 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727921AbfGRV2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 17:28:51 -0400
Received: by mail-vs1-f65.google.com with SMTP id r3so20137596vsr.13
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 14:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IyK1/KrXVcCjWB4+QnzI7G/fiGV+kyeRskwzWya7BVY=;
        b=J9Qur1k8uNZ28gr48EMeSZ5ZTadMyC+P0cOv8o6AarTthN35uwczlGRmvY8UZsH9at
         CtA9IoRohHkMgwB2ebkWUm7Nx+LFI4mYGXIkaRub7bqQKmxvFwPByme+wpvPG/Hr6rsz
         u/OWhQbIFBZ1PO2pfsVrrKzY4ev5fGAtvetHGXN3Cuta0dNkxiwqEr4V5/+Ce22z0bnO
         TRoTnfPnz0wCmcTiy9LhuQwbUwEZZI4u2q44Ekr5D7Wjnnz393BabKupdNWUO8keo5TF
         +EUpE6Romg+Pmp6jS2Q5FJGUR4FyQYcmq8xMpG2kVmn2APPnTZmHQx4DDwepa15Vkv5a
         7mhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IyK1/KrXVcCjWB4+QnzI7G/fiGV+kyeRskwzWya7BVY=;
        b=Nk20wx8ul+6WKdv3OJv2BDL0pO/FOKiOy4j1AG2vRh7SR8ffObFTKQTVNa15k9BWEL
         IGiTCzkvnsB9rwkhnhVei8m3kZ6H0YedWD2T4PhtAybHq+7Ktgk06qRTr9YejiTh+44z
         icwJIKQZxYd0a2YRwEW4Gy8AJsH7mrwUkPnQ52P53e+a5Vt2g5/KPkmdNA2AtZObakZr
         lTeDVoDAT1tp7c1/q34VY7ICIJOJnNo9RBpDlX1GZKOxaYsy4xU8Q3xoa+kQCzV6FSx+
         qS3kLbl8wtyVpeVqN7/xJ/ovvt81KhZFJAaXKpsfK8z+UX34ldqyKSRFFCD9cL71J6Hi
         dVFA==
X-Gm-Message-State: APjAAAUR/l5RT3GqJHFpIddpXBSDAma/WB9DbSeuTeSw2p8UyJXbinhN
        o0Yr8DTCl+ZtnLVcZByp0t67S87mySCv7N6AYBxj
X-Google-Smtp-Source: APXvYqzExSySUxynZMmwMGCuSd9ZHoeZd8IEzBzfN0Xzew4NVEGhby0MPyLAOWrGO4tC+scR8VOj/sF/JVKFOUiEUKk=
X-Received: by 2002:a67:d39e:: with SMTP id b30mr30406445vsj.212.1563485330475;
 Thu, 18 Jul 2019 14:28:50 -0700 (PDT)
MIME-Version: 1.0
References: <1562959401-19815-1-git-send-email-cai@lca.pw> <20190712.154606.493382088615011132.davem@davemloft.net>
 <EFD25845-097A-46B1-9C1A-02458883E4DA@lca.pw> <20190712.175038.755685144649934618.davem@davemloft.net>
 <D7E57421-A6F4-4453-878A-8F173A856296@lca.pw> <CAKwvOdkCfqfpJYYX+iu2nLCUUkeDorDdVP3e7koB9NYsRwgCNw@mail.gmail.com>
 <CAGG=3QWkgm+YhC=TWEWwt585Lbm8ZPG-uFre-kBRv+roPzZFbA@mail.gmail.com> <CAKwvOd=B=Lj-hTtbe88bo89wLxJrDAsm3fJisSMD=hKkRHf6zw@mail.gmail.com>
In-Reply-To: <CAKwvOd=B=Lj-hTtbe88bo89wLxJrDAsm3fJisSMD=hKkRHf6zw@mail.gmail.com>
From:   Bill Wendling <morbo@google.com>
Date:   Thu, 18 Jul 2019 14:28:39 -0700
Message-ID: <CAGG=3QXGqOkfTXC6LRqALJkWaX1L_nnYs3+1xXeojqKF3kftbw@mail.gmail.com>
Subject: Re: [PATCH] be2net: fix adapter->big_page_size miscaculation
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Qian Cai <cai@lca.pw>, James Y Knight <jyknight@google.com>,
        David Miller <davem@davemloft.net>, sathya.perla@broadcom.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, netdev@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Possibly. I'd need to ask him. :-)

On Thu, Jul 18, 2019 at 2:22 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Thu, Jul 18, 2019 at 2:18 PM Bill Wendling <morbo@google.com> wrote:
> >
> > Top-of-tree clang says that it's const:
> >
> > $ gcc a.c -O2 && ./a.out
> > a is a const.
> >
> > $ clang a.c -O2 && ./a.out
> > a is a const.
>
> Right, so I know you (Bill) did a lot of work to refactor
> __builtin_constant_p handling in Clang and LLVM in the
> pre-llvm-9-release timeframe.  I suspect Qian might not be using
> clang-9 built from source (as clang-8 is the current release) and thus
> observing differences.
>
> >
> > On Thu, Jul 18, 2019 at 2:10 PM Nick Desaulniers <ndesaulniers@google.com> wrote:
> >>
> >> On Thu, Jul 18, 2019 at 2:01 PM Qian Cai <cai@lca.pw> wrote:
> >> >
> >> >
> >> >
> >> > > On Jul 12, 2019, at 8:50 PM, David Miller <davem@davemloft.net> wrote:
> >> > >
> >> > > From: Qian Cai <cai@lca.pw>
> >> > > Date: Fri, 12 Jul 2019 20:27:09 -0400
> >> > >
> >> > >> Actually, GCC would consider it a const with -O2 optimized level because it found that it was never modified and it does not understand it is a module parameter. Considering the following code.
> >> > >>
> >> > >> # cat const.c
> >> > >> #include <stdio.h>
> >> > >>
> >> > >> static int a = 1;
> >> > >>
> >> > >> int main(void)
> >> > >> {
> >> > >>      if (__builtin_constant_p(a))
> >> > >>              printf("a is a const.\n");
> >> > >>
> >> > >>      return 0;
> >> > >> }
> >> > >>
> >> > >> # gcc -O2 const.c -o const
> >> > >
> >> > > That's not a complete test case, and with a proper test case that
> >> > > shows the externalization of the address of &a done by the module
> >> > > parameter macros, gcc should not make this optimization or we should
> >> > > define the module parameter macros in a way that makes this properly
> >> > > clear to the compiler.
> >> > >
> >> > > It makes no sense to hack around this locally in drivers and other
> >> > > modules.
> >> >
> >> > If you see the warning in the original patch,
> >> >
> >> > https://lore.kernel.org/netdev/1562959401-19815-1-git-send-email-cai@lca.pw/
> >> >
> >> > GCC definitely optimize rx_frag_size  to be a constant while I just confirmed clang
> >> > -O2 does not. The problem is that I have no clue about how to let GCC not to
> >> > optimize a module parameter.
> >> >
> >> > Though, I have added a few people who might know more of compilers than myself.
> >>
> >> + Bill and James, who probably knows more than they'd like to about
> >> __builtin_constant_p and more than other LLVM folks at this point.
> >>
> >> --
> >> Thanks,
> >> ~Nick Desaulniers
>
>
>
> --
> Thanks,
> ~Nick Desaulniers
