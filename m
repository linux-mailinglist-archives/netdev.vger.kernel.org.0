Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40A93BC2FB
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 21:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhGETIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 15:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhGETIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 15:08:45 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA811C061574;
        Mon,  5 Jul 2021 12:06:07 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id w22so13750504pff.5;
        Mon, 05 Jul 2021 12:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UuZh8eJmQ1lIEadR8z/9iR40GstH8GqfR3g6tCx7cRE=;
        b=WJQx9NA8BlzVRMafs+7EpMWi9x3rYpCEMMXMC1Ug33QN7MAfMRBh94GJhwCibzemus
         iJcwK/0iE9ddqwI6SQMjUMDFDVLHvu+HV55386PbGPr9F+dKnQkokj1QpnCWW9mtArHh
         jpILZUSOgLC+7ulmGkfLrB+3T9kd5fmujRIroAVpuNcbAjYEnRfhX3bAcLTHKlZckFQ3
         YREPXxjt7YglLinDmsMpMSOzEum9OZ7UGJkW6JC74oIkPreY58UJ1C3+2uYkV3TQZzeg
         5vPeL94bY3wV1z3QJj/yefgZQjEyJftH0s79OomsaPClPOk9T2fKQhKK8Hg8P/fHVTmW
         RIwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UuZh8eJmQ1lIEadR8z/9iR40GstH8GqfR3g6tCx7cRE=;
        b=p53Hfzjxs8Jre9vM3xnjSVxKdDoeXZVqTfRsfqUV5fpSWzTGuoZ/PSK8B9Zz8xIizA
         /7c6Ajo/N1sJKEItHKeAl1dC4bXyO64+Ky6hc3FzrEoFP6E+5b4rh3Ywhw7/cCNaLc/3
         bquXdOSPksMsVV1cV3QRTUTaBQGrk0vKNCN53Vgw+3cH4/wZkOPWnLF2bDne/zlZTfnz
         p2s9+3Agf8SGW/pl5aH3ObCTGQCtuwm7kG+flu83IHmt2Iyhb7H+22qqzLqeEQzkM98G
         BvuKZ9Y1pK9OapYHr4pEujKd+tYeKWP5hb3A73CFDhRAAX0EIPOafziNVF8kJsUHZsVL
         FYGA==
X-Gm-Message-State: AOAM530zHwb+MsmUBZFyqt1gNdPsE6/YQeLR0QVJz0Y42oLAWDxMrSBf
        WR0TYm251xbB3TqOh5zp7wRBPoCcOkrhD22M7eU=
X-Google-Smtp-Source: ABdhPJzBtBfYSQTDKaFdu9uHDDFSuLkh44ARNTnK7EYRd7Fh8DbqQD1vimLJIZZeQcUJ8XkToCJGZtqoXm1ttwjjbcE=
X-Received: by 2002:a63:d014:: with SMTP id z20mr17034219pgf.203.1625511967330;
 Mon, 05 Jul 2021 12:06:07 -0700 (PDT)
MIME-Version: 1.0
References: <1625457455-4667-1-git-send-email-linyunsheng@huawei.com>
 <YOLXTB6VxtLBmsuC@smile.fi.intel.com> <c6844e2b-530f-14b2-0ec3-d47574135571@huawei.com>
 <20210705142555-mutt-send-email-mst@kernel.org> <YONRKnDzCzSAXptx@smile.fi.intel.com>
 <20210705143952-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210705143952-mutt-send-email-mst@kernel.org>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 5 Jul 2021 22:05:30 +0300
Message-ID: <CAHp75VcsUxOqu48E1+RNqn=RhJqfd7XG8e3AKRHyMb3ywzSPrg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] refactor the ringtest testing for ptr_ring
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>, ndesaulniers@gooogle.com,
        Joe Perches <joe@perches.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 5, 2021 at 9:45 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Jul 05, 2021 at 09:36:26PM +0300, Andy Shevchenko wrote:
> > On Mon, Jul 05, 2021 at 02:26:32PM -0400, Michael S. Tsirkin wrote:
> > > On Mon, Jul 05, 2021 at 08:06:50PM +0800, Yunsheng Lin wrote:
> > > > On 2021/7/5 17:56, Andy Shevchenko wrote:
> > > > > On Mon, Jul 05, 2021 at 11:57:33AM +0800, Yunsheng Lin wrote:
> > > > >> tools/include/* have a lot of abstract layer for building
> > > > >> kernel code from userspace, so reuse or add the abstract
> > > > >> layer in tools/include/ to build the ptr_ring for ringtest
> > > > >> testing.
> > > > >
> > > > > ...
> > > > >
> > > > >>  create mode 100644 tools/include/asm/cache.h
> > > > >>  create mode 100644 tools/include/asm/processor.h
> > > > >>  create mode 100644 tools/include/generated/autoconf.h
> > > > >>  create mode 100644 tools/include/linux/align.h
> > > > >>  create mode 100644 tools/include/linux/cache.h
> > > > >>  create mode 100644 tools/include/linux/slab.h
> > > > >
> > > > > Maybe somebody can change this to be able to include in-tree headers directly?
> > > >
> > > > If the above works, maybe the files in tools/include/* is not
> > > > necessary any more, just use the in-tree headers to compile
> > > > the user space app?
> > > >
> > > > Or I missed something here?
> > >
> > > why would it work? kernel headers outside of uapi are not
> > > intended to be consumed by userspace.
> >
> > The problem here, that we are almost getting two copies of the headers, and
> > tools are not in a good maintenance, so it's often desynchronized from the
> > actual Linux headers. This will become more and more diverse if we keep same
> > way of operation. So, I would rather NAK any new copies of the headers from
> > include/ to tools/include.
>
> We already have the copies
> yes they are not maintained well ... what's the plan then?
> NAK won't help us improve the situation.

I understand and the proposal is to leave only the files which are not
the same (can we do kinda wrappers or so in tools/include rather than
copying everything?).

> I would say copies are kind of okay just make sure they are
> built with kconfig. Then any breakage will be
> detected.
>
> > > > > Besides above, had you tested this with `make O=...`?
> > > >
> > > > You are right, the generated/autoconf.h is in another directory
> > > > with `make O=...`.
> > > >
> > > > Any nice idea to fix the above problem?


-- 
With Best Regards,
Andy Shevchenko
