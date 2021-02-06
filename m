Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44AE6311FF6
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 21:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhBFUiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 15:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhBFUiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 15:38:10 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D0CC061756
        for <netdev@vger.kernel.org>; Sat,  6 Feb 2021 12:37:30 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id z21so7087176pgj.4
        for <netdev@vger.kernel.org>; Sat, 06 Feb 2021 12:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/XkrXTNLlt4KjFNcZZkTjDpFyKQZyu8thbdZMY5TQ7U=;
        b=rcSkYVl/27UtnbjgDCwAkqOVBjc9JQqZtdZ/J9OS95+i5P2L1sVnllwJ09JVBuoLxk
         JxcxRzd7u44cBWLKud7mmeFXI/F2Uw2MA/6opUl5ew7yYPsvW3eR+yBBddng28nKTzwn
         6/n8B1skLa+vZhoP/1t4QgQjKZUgEm1ADQdU/Wi4RURA29cdZVKZhhHJ0n1IoOs/bbs5
         Gnq5oxiEvPL7RRYGT/VCGPoNSRHdzvoZKZMNJxANiI/ztqL30wkK8ySvM+h7NC86Hr3w
         Ml04WszfSnszvcfOWvzgDeaTrkkXsrjWelq1AqSvRbZh08n9LnHzdoF9LJKAp5rdmrr/
         TGRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/XkrXTNLlt4KjFNcZZkTjDpFyKQZyu8thbdZMY5TQ7U=;
        b=mvAcPAb29dtKNcr1DGfwNOYYgAypZTPzFXWWx68xokMlFjf0h5oZEjWYg9n5yrc+Io
         fi6wGA0pGFcZda+C9xEUQFcs5BrEVRGL5Ni8zxuEjBY2RRj719HG9WCWskgbx++4sWEF
         OS0h04ZzCqKpvRElreXjmJCpPPRG6Zsw/C/D2USNq+kYl+XVgSz/xIDPyOvGAz2nfA7R
         IRUCV8B7ZY3BB1SACj9Fjktwh81fq3iJLPUUaFJpxF2cVpDYG4GQJFIi3RCKNfCH/llK
         wzO6AJ3BnieNJiGSmld99O6IgnFV2daWd3QBJ2jZE1tm5tl7IjoTdDUf3C6bJiDty4mT
         HkAQ==
X-Gm-Message-State: AOAM533YcjJWtKcyMIMXflvSQIRI04hHYCAZoBCxbu/iHqkM8kI9jpfO
        NDYTwZlcqHFPQL2sWVau5gkyteKVdfThMQ0Vk2HOtw==
X-Google-Smtp-Source: ABdhPJxqgDxp9yre3aF2tRZZfarQS0s2dwGU57QLzow72BbD6U9hUgBTffOiAxn/C5avA4dAvt6OOuYv5XJKlMcwx4c=
X-Received: by 2002:a63:515e:: with SMTP id r30mr6225403pgl.253.1612643849420;
 Sat, 06 Feb 2021 12:37:29 -0800 (PST)
MIME-Version: 1.0
References: <20210206070203.483362-1-arjunroy.kdev@gmail.com>
 <20210206091903.3c02f584@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20210206092041.77eb5455@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210206092041.77eb5455@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Sat, 6 Feb 2021 12:37:18 -0800
Message-ID: <CAOFY-A0BCDNy1VE_cauuYhwWUZ3=u9mtCVPS3O5kbPFKxGm7yw@mail.gmail.com>
Subject: Re: [net v2] tcp: Explicitly mark reserved field in
 tcp_zerocopy_receive args.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        David Ahern <dsahern@gmail.com>,
        Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 6, 2021 at 9:20 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 6 Feb 2021 09:19:03 -0800 Jakub Kicinski wrote:
> > On Fri,  5 Feb 2021 23:02:03 -0800 Arjun Roy wrote:
> > > From: Arjun Roy <arjunroy@google.com>
> > >
> > > Explicitly define reserved field and require it to be 0-valued.
> > >
> > > Fixes: 7eeba1706eba ("tcp: Add receive timestamp support for receive zerocopy.")
> > > Signed-off-by: Arjun Roy <arjunroy@google.com>
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> > > Suggested-by: David Ahern <dsahern@gmail.com>
> > > Suggested-by: Leon Romanovsky <leon@kernel.org>
> > > Suggested-by: Jakub Kicinski <kuba@kernel.org>
> >
> > Applying: tcp: Explicitly mark reserved field in tcp_zerocopy_receive args.
> > Using index info to reconstruct a base tree...
> > M     include/uapi/linux/tcp.h
> > M     net/ipv4/tcp.c
> > Falling back to patching base and 3-way merge...
> > Auto-merging net/ipv4/tcp.c
> > Auto-merging include/uapi/linux/tcp.h
> > CONFLICT (content): Merge conflict in include/uapi/linux/tcp.h
> > error: Failed to merge in the changes.
> > hint: Use 'git am --show-current-patch=diff' to see the failed patch
> > Patch failed at 0001 tcp: Explicitly mark reserved field in tcp_zerocopy_receive args.
> > When you have resolved this problem, run "git am --continue".
> > If you prefer to skip this patch, run "git am --skip" instead.
> > To restore the original branch and stop patching, run "git am --abort".
>
> Ah, you just marked it for the wrong tree. Please repost with net-next
> in the subject tag, otherwise build bot won't handle it.

Resent with net-next.

Thanks,
-Arjun
