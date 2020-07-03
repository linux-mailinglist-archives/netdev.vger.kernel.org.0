Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7BE21323C
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 05:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgGCDeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 23:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbgGCDeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 23:34:36 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CC5C08C5DD
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 20:34:36 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id z24so10191429ljn.8
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 20:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4wli8ZcJVLYQtZApOQ4JVDxFTolfDVKYqXzyK7UfBOE=;
        b=XkXiNIaFugtsbR5MF0IvoekJeeOpbXuPFGZ5DuEEReeRvY3Jg69vp+irshARRv8GRT
         dFOpxpATFrJ36zAWxQIxPZ86OZe7w/NSoYwqQ0MEpjCplgxLXcnZwTk8yKUXpfchQw5R
         AafWJzGSEByYHSIXtQjx9ZMAT17Ww4IKv2954=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4wli8ZcJVLYQtZApOQ4JVDxFTolfDVKYqXzyK7UfBOE=;
        b=jRTL+2flgVLOsxqsoMsGi4NhPLJkUoxZiW62MtsfziqX9NZhyQERjls0PDhbn43YyM
         vpnXfq7+iYeTA1xbcYCOMOzkK0c+AM3xfY+0xlax3MvEBdUUftJ8kAQ6bjkVUpBxkkZq
         qRtWaVBZ1uSP/GyqqpBxg0UubYyVCyXu68ETSm+l3O6HIjZqwhhkunIw5QAHErb7CKCR
         5bqwVi/cISBGVZxLK8ckDY/jz+V3IOlsFmVRq4vqRlwsd1nhU147gmjLKS9O2blizF16
         FQ+ALurozCuwAjCgMqp9p5lI8S+9MmcthFQxjsjDRE3V6ON1K5ShLyzgcoC8iS/6qE/X
         yzaA==
X-Gm-Message-State: AOAM532eNYCb8jQs7SEfWkpArj81bhbBzcC0rwOs/5io9s8LwnKEJ5bx
        iRnkiJKS/rweOFlbQU8wUwfQ5QZxoFE=
X-Google-Smtp-Source: ABdhPJwDuVSR5YIgG4gNlFOaGl7H7OKU0e3PHWwIxyDx94inxV771O+YMIPZzvoFhG7IqAuPzc69Ng==
X-Received: by 2002:a2e:9bda:: with SMTP id w26mr13520958ljj.107.1593747274435;
        Thu, 02 Jul 2020 20:34:34 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id m10sm60502lji.72.2020.07.02.20.34.33
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 20:34:33 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id z24so10191347ljn.8
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 20:34:33 -0700 (PDT)
X-Received: by 2002:a05:651c:1b6:: with SMTP id c22mr15442024ljn.421.1593747272949;
 Thu, 02 Jul 2020 20:34:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200702200329.83224-1-alexei.starovoitov@gmail.com>
 <20200702200329.83224-4-alexei.starovoitov@gmail.com> <CAHk-=wgP8g-9RdVh_AHHi9=Jpw2Qn=sSL8j9DqhqGyTtG+MWBA@mail.gmail.com>
 <20200703023547.qpu74obn45qvb2k7@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200703023547.qpu74obn45qvb2k7@ast-mbp.dhcp.thefacebook.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 2 Jul 2020 20:34:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiBi3sjtL0JNzcPTYEOFomU9Oqz_vD=oHznxyQYGBRi5Q@mail.gmail.com>
Message-ID: <CAHk-=wiBi3sjtL0JNzcPTYEOFomU9Oqz_vD=oHznxyQYGBRi5Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] bpf: Add kernel module with user mode driver
 that populates bpffs.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 7:35 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Jul 02, 2020 at 06:05:29PM -0700, Linus Torvalds wrote:
> > On Thu, Jul 2, 2020 at 1:03 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > The BPF program dump_bpf_prog() in iterators.bpf.c is printing this data about
> > > all BPF programs currently loaded in the system. This information is unstable
> > > and will change from kernel to kernel.
> >
> > If so, it should probably be in debugfs, not in /sys/fs/
>
> /sys/fs/bpf/ is just a historic location where we chose to mount bpffs.

It's more the "information is unstable and will change from kernel to kernel"

No such interfaces exist. If people start parsing it and depending it,
it's suddenly an ABI, whether you want to or not (and whether you
documented it or not).

At least if it's in /sys/kernel/debug/bpf/ or something, it's less
likely that anybody will do that.

               Linus
