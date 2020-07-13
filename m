Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD8521E31E
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgGMWlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbgGMWlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 18:41:15 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E03BC061755;
        Mon, 13 Jul 2020 15:41:15 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id z63so13886666qkb.8;
        Mon, 13 Jul 2020 15:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c6CanqfySF4iLEaP47cgvG1KOQzCKk6opIIIQMoQVsg=;
        b=ZRd8MvR8SS3lFEVOG/aW07WLjR3cAtxjYDA4hMSCjN+ZXS0lCldwFbRcrFqsiRk6GX
         ho95C8CgDTaZS3HFxyHO1aj1z8t4kQYPO7SCtm5VTF6cP3ST3xt+DZf5t8Jrc6yV25K1
         VCE/LPnhH+7ccs9bzvBISxd8KpVwq44Nk+y0ox/EVGckTXB0KsQlsEu6sCRt+pQshcUy
         0X50tmL0NgHdDI7/FqC+Fs02WqLh91TeNFyOZ21vUK9qpEm7l/zMQZiDb7yDjzVo3nYr
         YUVNrCz+EKrDNZYqau6mrhDK74aah9dYJ10IFMpg+r1cREZ5+48xLf9i4bhhfIdgLFDR
         qnQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c6CanqfySF4iLEaP47cgvG1KOQzCKk6opIIIQMoQVsg=;
        b=eQJxi/u3K6a3kBykEZXug7AeNAb6XZ3Rup9q2NznUn7hzHemKbdWwkC8Th3WbTgh+Q
         5xqZYr9qIOlKp/EuhQvfqd5YYwLZyzq3i9LGmTJLceMBwHm8yOwvXHmUVDals17Hk085
         IyJUoW6sA62AA20YvqcD/5HMFQjS1DdGVAT5iHsPAC5Tqd3Z8Qk3NdlLBJrUnWU2yL7b
         QULSTNmme9AJ+/WCkZgFPeFmP3FPAslyw9jcMldOPe4OMRKybB2GMlWw2COzvMWmb3T6
         iuA79H26QqUNRabtesFXXJ9BYSIRnGul9Pmg4mL0eVgHJtKCUw1R3O67JNMjP5sR7FBs
         n3tA==
X-Gm-Message-State: AOAM530mD+uMtPrbUUw2CC96hkS+xjeccgPachqPYmKj1rVTnTbpCNE7
        dY5jpEK3b3tTQijwQOn0btg8IR/c5nVRZXkieWs=
X-Google-Smtp-Source: ABdhPJwX4NcVyxh/LJb6QxgeP4QCz+5nkS+44G1x7ry7/PfTpKSdB3Ph0BYl35dH1XuZfj3hWUNv4C3uMGXTXBrPWDE=
X-Received: by 2002:a37:270e:: with SMTP id n14mr1859086qkn.92.1594680074412;
 Mon, 13 Jul 2020 15:41:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200710224924.4087399-1-andriin@fb.com> <20200710224924.4087399-5-andriin@fb.com>
 <7a68d9cc-f8dc-a11f-f1d4-7307519be866@gmail.com>
In-Reply-To: <7a68d9cc-f8dc-a11f-f1d4-7307519be866@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Jul 2020 15:41:03 -0700
Message-ID: <CAEf4BzZw_1B8bafnxXThOvaAts5WFbE-mYgzM3f8ZMpwnedvHQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/7] bpf: implement BPF XDP link-specific
 introspection APIs
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Jakub Kicinski <kicinski@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Takshak Chahande <ctakshak@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 7:32 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 7/10/20 4:49 PM, Andrii Nakryiko wrote:
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 025687120442..a9c634be8dd7 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -8973,6 +8973,35 @@ static void bpf_xdp_link_dealloc(struct bpf_link *link)
> >       kfree(xdp_link);
> >  }
> >
> > +static void bpf_xdp_link_show_fdinfo(const struct bpf_link *link,
> > +                                  struct seq_file *seq)
> > +{
> > +     struct bpf_xdp_link *xdp_link = container_of(link, struct bpf_xdp_link, link);
> > +     u32 ifindex = 0;
> > +
> > +     rtnl_lock();
> > +     if (xdp_link->dev)
> > +             ifindex = xdp_link->dev->ifindex;
> > +     rtnl_unlock();
>
> Patch 2 you set dev but don't hold a refcnt on it which is why you need
> the locking here. How do you know that the dev pointer is even valid here?
>
> If xdp_link is going to have dev reference you need to take the refcnt
> and you need to handle NETDEV notifications to cleanup the bpf_link when
> the device goes away.

Here I'm following the approach taken for cgroup and netns, where we
don't want to hold cgroup with extra refcnt (as well as netns for
bpf_netns_link). The dev is guaranteed to be valid because
dev_xdp_uninstall() will be called (under rtnl_lock) before net_device
is removed/destroyed. dev_xdp_uninstall() is the only one that can set
xdp_link->dev to NULL. So if we got rtnl_lock() and see non-NULL dev
here, it means that at worst we are waiting on a rtnl lock in
dev_xdp_uninstall() in a separate thread, and until this thread
releases that lock, it's ok to query dev.

Even if we do extra refcnt, due to dev_xdp_uninstall() which sets
xdp_link->dev to NULL, any code (fill_info, show_fdinfo, update, etc)
that does something with xdp_link->dev will have to take a lock
anyways.
