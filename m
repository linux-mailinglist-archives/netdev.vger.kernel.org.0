Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6981891D8
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 00:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgCQXOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 19:14:40 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40848 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgCQXOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 19:14:40 -0400
Received: by mail-pg1-f194.google.com with SMTP id t24so12561475pgj.7
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 16:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/rWQP1Yg51797tjo4yZXnukRdpjSAiEDIrzmWPJBcG8=;
        b=k1BsSflZT/HplgHCXJir0MOmCTLGpfGNUtbMh/PmHbBUv6XNfNm/mhrTi62q49BNA6
         BWrQlB1iukl/aO9e8GrXOMGiL23rUFGc83oK/UKWIwzPv5QbYjzV/2spuWE/2voY64X2
         tV62qBkcO/aH+Bq456g2On7mh/jnZpTshh9nzcdrVWAI6LOcU3jqnxsYTZCqXJm5z2xu
         rvpR0mgXxEAFLwAjQTJilZBfKIjg0ufV2VUgv6DfcFQRkFd+p/b4kmqDn8a6l/g71npR
         aZudr/Wi9baOt3sJzdEdxZJP8ejwCMReccs4QVA4mOj94KEeC/CqPuo39rMqaIwnrrnu
         t2NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/rWQP1Yg51797tjo4yZXnukRdpjSAiEDIrzmWPJBcG8=;
        b=aEL9Zqcw9M0AvaQhTPlLL/p2NUO6b0UVWLO8hpnP7xRdWpOQ6l87/KOQOXnsE42bEM
         qnd7v/ETencWHCcUDk9X3A6WSjeNC+Eq63POS0KJ+kwUM53vImeam89j12gWY/GePaSl
         Kpx/97gPacmI9pswrQKk6DXlt4EoOs8sRA0LgUYmW7CS1PCENe6f+7rZz02B65eyidpD
         P2qUAnckTQc647qr4HBfCDoLHppS2GPjSa0mSWKP/BEt9m858dtFc7jmhtoTLqqFj5gU
         6yeJ5xNKI1X+hWadRgmJXmBFzHEl8imsnh6TndaVKiFc4TOnrT0TIiS3ZU2ElULBQLLc
         7JSg==
X-Gm-Message-State: ANhLgQ3Iudl3uUFBhlUPsUBv8SbO8m2YuqUeGiKpUm4GdJF/H7x1amb1
        yhAFu0kiU3wgztG0oIE1wnLd7SZHrRa0ZW8usm9U+w==
X-Google-Smtp-Source: ADFU+vuJYRDLvrqcLQA3uWtk/RibZwczyeGIv1e+ErH/w5zFQRaWnWIq5y5ipj6pl6TmuR70CK/gDeFBVhGBBmQbtDI=
X-Received: by 2002:a63:4d6:: with SMTP id 205mr1575391pge.10.1584486878738;
 Tue, 17 Mar 2020 16:14:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200317211649.o4fzaxrzy6qxvz4f@google.com> <20200317215100.GC2459609@mini-arch.hsd1.ca.comcast.net>
 <20200317220136.srrt6rpxdjhptu23@google.com> <CAKwvOd=gaX1CBTirziwK8MxQuERTqH65xMBHNzRXHR4uOTY4bw@mail.gmail.com>
 <CAKH8qBteBDQp_Jw2RhM5u6x2q75+PtRwX6jZZQggjpeohWQEzg@mail.gmail.com>
In-Reply-To: <CAKH8qBteBDQp_Jw2RhM5u6x2q75+PtRwX6jZZQggjpeohWQEzg@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 17 Mar 2020 16:14:27 -0700
Message-ID: <CAKwvOdkVtDjXNM1pA=sZvrGhxK3amYbLmsQvQWKnTtXyvxaR3w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5] bpf: Support llvm-objcopy and llvm-objdump
 for vmlinux BTF
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Fangrui Song <maskray@google.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 3:13 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Tue, Mar 17, 2020 at 3:08 PM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> >
> > On Tue, Mar 17, 2020 at 3:01 PM Fangrui Song <maskray@google.com> wrote:
> > >
> > > On 2020-03-17, Stanislav Fomichev wrote:
> > > >Please keep small changelog here, for example:
> > > >
> > > >v5:
> > > >* rebased on top of bpfnext
> > >
> > > Thanks for the tip. Add them at the bottom?
> >
> > "Below the fold" see this patch I just sent out:
> > https://lore.kernel.org/lkml/20200317215515.226917-1-ndesaulniers@google.com/T/#u
> > grep "Changes"
> >
> > $ git format-patch -v2 HEAD~
> > $ vim 0001-...patch
> > <manually add changelog "below the fold">
> BPF subtree prefers the changelog in the commit body, not the comments
> (iow, before ---).
> Add them at the end of you message, see, for example:
> https://lore.kernel.org/bpf/a428fb88-9b53-27dd-a195-497755944921@iogearbox.net/T/

Sigh, every maintainer is a special snowflake.  In our tree, you're
only allowed to commit on Thursdays under a blood moon. /s

But thanks for the note.
-- 
Thanks,
~Nick Desaulniers
