Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59A321C03B
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 01:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgGJXAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 19:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbgGJXAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 19:00:06 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829F7C08C5DC;
        Fri, 10 Jul 2020 16:00:06 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id y13so4057363lfe.9;
        Fri, 10 Jul 2020 16:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jOyRkVYNyzB5sIEvwpqgHfoAG8N+0xJYHL0WCt25Quk=;
        b=FIZ8Wmp2eocHMoDDQhTwYtXzyK9/bI4KNA0XjuKFmXxnTDtSu6dh5y4BxLRJYZd2XJ
         X9aB6rKsrGp3XS/aOM5EhFRtLuwXakYhQoxW15MVLETDBozLE1PTYNDyYMsfpOX20a3w
         WMz/zDW3r/gngwU+kkVjaYFthOQx2j+cTwGqq6plXVU8O1n4FRCO2gjWr3kN1Irz/ITU
         mDirrun8kgQo20riwPldZu+Vum6RgiNS5/Ib7vqmApkgSTqyj1kzEDO5oSYWVfCNozJU
         QNbi7+LNQi/l3AFB/dokndeBXhDTUGH73IMy05Qjb2zsCm44y8zto2TilcdhceWfnbrl
         IoEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jOyRkVYNyzB5sIEvwpqgHfoAG8N+0xJYHL0WCt25Quk=;
        b=LIAed2dHo70i6y7OYNEnSAJ1ze56Aj1mgXAHH1+mcASh6krwuz87Ut/C/GsDfHMdMz
         kz1gy5oAgxp4Q9xGcTQW1CYJLL1qj58wS9XoX7t/5jbirV1thmqVLcATemwszvw66L2V
         VWpBmbCDcLVTG8jlsmAqeVVdbJfDXPf3la7f5U4UmsP7HEtR2rse8QhwS9zWTSwWsLY0
         12U53Jwzlhci5ZdtjMMlEBbFARS8UvQlJ2N81uP32sFBUUSYn5tHoWKkT4PKEzrF2FSs
         LoARuWFlU31jyz8/mf2JtFrVC103EX88KOplR80uO8hIrpIcX9T5s8hx9yAuOt8BVmKL
         K7oQ==
X-Gm-Message-State: AOAM531BLji1fpW+blh2VQjEZULGnacdwc+x61LpKWHGyH8WLTSky9Ri
        pfzdWzsE0Re5qFaTsiPaeoE9FktkBXHMfneu4dPP3g==
X-Google-Smtp-Source: ABdhPJxj13YWI8mu+GDghj8EPOJAw+ECgpYiJfjwVMp8yaD+vHmGLzAsj0UCWWCHFQtQNKuOc59F2L4r8+gKdxyWZCw=
X-Received: by 2002:a05:6512:49d:: with SMTP id v29mr45300496lfq.134.1594422004967;
 Fri, 10 Jul 2020 16:00:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
 <20200630043343.53195-3-alexei.starovoitov@gmail.com> <d0c6b6a6-7b82-e620-8ced-8a1acfaf6f6d@iogearbox.net>
 <20200630234117.arqmjpbivy5fhhmk@ast-mbp.dhcp.thefacebook.com>
 <CACYkzJ5kGxxA1E70EKah_hWbsb7hoUy8s_Y__uCeSyYxVezaBA@mail.gmail.com>
 <5596445c-7474-9913-6765-5d699c6c5c4e@iogearbox.net> <CAADnVQLoVfPWNBR-_56ofgaUFv8k3NT2aiGjV9jj_gOt0aoJ5g@mail.gmail.com>
 <20200710170010.GC7487@kernel.org>
In-Reply-To: <20200710170010.GC7487@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 10 Jul 2020 15:59:53 -0700
Message-ID: <CAADnVQJQFD2NTZRyqv1DHCFMcNRWn10Qnwnff-tL8iUYSbM91g@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 2/5] bpf: Introduce sleepable BPF programs
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 10:00 AM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Wed, Jul 01, 2020 at 08:21:13AM -0700, Alexei Starovoitov escreveu:
> > On Wed, Jul 1, 2020 at 2:34 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > >
> > > +1, I think augmenting mid-term would be the best given check_sleepable_blacklist()
> > > is rather a very fragile workaround^hack and it's also a generic lsm/sec hooks issue
> >
> > I tried to make that crystal clear back in march during bpf virtual conference.
> > imo whitelist is just as fragile as blacklist. Underlying
> > implementation can change.
> >
> > > (at least for BPF_PROG_TYPE_LSM type & for the sake of documenting it for other LSMs).
> > > Perhaps there are function attributes that could be used and later retrieved via BTF?
> >
> > Even if we convince gcc folks to add another function attribute it
> > won't appear in dwarf.
>
> Warning, hack ahead!
>
> Perhaps we could do that with some sort of convention, i.e. define some
> type and make a function returning that type to have the desired
> attribute?
>
> I.e.
>
> typedef __attribute__foo__int int;
>
> __attribute__foo__int function_bla(...)
> {
> }
>
> ?

What about lsm hooks returning void ?
I guess for lsm we can hack something like that,
but for __rcu and __user that won't really work.
The kernel changes will be too massive.
