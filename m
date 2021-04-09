Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38CB35A743
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbhDITnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233883AbhDITnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 15:43:04 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E410AC061762;
        Fri,  9 Apr 2021 12:42:49 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id d12so2946436iod.12;
        Fri, 09 Apr 2021 12:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=unhXl+pc6TQKlLmCDsXgLF+ApdAzewtHVr0DGc7OWBg=;
        b=f2hdiychRjsOn8HFQsEHRpn3J3u72FP6ZBQllbbc2iP/kknhSxeI9kU50NbkEAtK6S
         9dXyu1iujuvWy5Mfcrvp+snXJJlKT98hXmCC6fcZzJS/0N5Vb8RHXFoV5mnNWlxZCgPH
         Em9WMUsNrkmbq+IVihoEo7tObIJAWFFziw/mUgMRiKxr/L8gyWTbHbX4Py20mf1Bazh+
         5GgFoWIhoArd0QVx9hN/iiJSqd+PSUrOZx0B4+Sz5NyDBBx3+HoLHww7fAqYiOeq9huj
         4yvNd2Zo8dM4NzmU2x2pLCv35lDbcYGwF7C3dzy7695rCMW5U6OL9BB6teJcNIU13BPs
         S3wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=unhXl+pc6TQKlLmCDsXgLF+ApdAzewtHVr0DGc7OWBg=;
        b=oFMmFeKYfD2c2eqMM8a5NyUEwelptxd7bhtuApQmWccpMZd6T2atrXd6QMur53ar84
         N8/kaRN9jjFYcPa24PycdGSL/VWz+97ZPNUpEUG5wNK3OrUNvwMJLzbH2y7c8DP+hs0G
         w+mphId4dnxYlEVkKP7t5lWVQhzvYr0NE4NKGAqIyw5hGVji+q35SkLAGnSvzO9vuy8m
         Z/7vqnns4C6aA9bmurjYf/bXoe5xSl36Jnzf206EalCV/Ba6lF++5sH4Uwk0SktFbbDS
         8tSU+8iKmJJcgKlqJeFxkTwBW/cLbr1HqPnejuCaR8GGsSuM/65O+uMAXKPGbekPEUwr
         XT4A==
X-Gm-Message-State: AOAM5322fh/oVKaQ8p8tRVLxZU0Y25yYEIptYY7HmYLTgqvzmwfbpICc
        TzX7PWwTvldmkF6y+Yc5D5lKHNsnFqI=
X-Google-Smtp-Source: ABdhPJy1Zh8Y8VDtLj006N7EOtGQhnfi3RnrzGgPPX50UHKI1MZgrKsoDWfZrWJpTqIdGB602nz4Kw==
X-Received: by 2002:a02:cac9:: with SMTP id f9mr9172453jap.85.1617997369397;
        Fri, 09 Apr 2021 12:42:49 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id 11sm1582398iln.74.2021.04.09.12.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 12:42:49 -0700 (PDT)
Date:   Fri, 09 Apr 2021 12:42:41 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+7b6548ae483d6f4c64ae@syzkaller.appspotmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <6070ae3185d63_4526f20878@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpXqfAXPoesdXskH7BaE206zc5QDEsfjFnfSRck2FH+wLg@mail.gmail.com>
References: <20210408030556.45134-1-xiyou.wangcong@gmail.com>
 <606f9f2b26b1a_c8b9208a4@john-XPS-13-9370.notmuch>
 <CAM_iQpXqfAXPoesdXskH7BaE206zc5QDEsfjFnfSRck2FH+wLg@mail.gmail.com>
Subject: Re: [Patch bpf-next] sock_map: fix a potential use-after-free in
 sock_map_close()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Thu, Apr 8, 2021 at 5:26 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > The last refcnt of the psock can be gone right after
> > > sock_map_remove_links(), so sk_psock_stop() could trigger a UAF.
> > > The reason why I placed sk_psock_stop() there is to avoid RCU read
> > > critical section, and more importantly, some callee of
> > > sock_map_remove_links() is supposed to be called with RCU read lock,
> > > we can not simply get rid of RCU read lock here. Therefore, the only
> > > choice we have is to grab an additional refcnt with sk_psock_get()
> > > and put it back after sk_psock_stop().
> > >
> > > Reported-by: syzbot+7b6548ae483d6f4c64ae@syzkaller.appspotmail.com
> > > Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > ---
> > >  net/core/sock_map.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> > > index f473c51cbc4b..6f1b82b8ad49 100644
> > > --- a/net/core/sock_map.c
> > > +++ b/net/core/sock_map.c
> > > @@ -1521,7 +1521,7 @@ void sock_map_close(struct sock *sk, long timeout)
> > >
> > >       lock_sock(sk);
> > >       rcu_read_lock();
> >
> > It looks like we can drop the rcu_read_lock()/unlock() section then if we
> > take a reference on the psock? Before it was there to ensure we didn't
> > lose the psock from some other context, but with a reference held this
> > can not happen.
> 
> Some callees under sock_map_remove_links() still assert RCU read
> lock, so we can not simply drop the RCU read lock here. Some
> additional efforts are needed to take care of those assertions, which
> can be a separate patch.
> 
> Thanks.

OK at least this case exists,

 sock_map_close
  sock_map_remove_links
   sock_map_unlink
    sock_hash_delete_from_link
      WARN_ON_ONCE(!rcu_read_lock_held()); 

also calls into sock_map_unref through similar path use sk_psock(sk)
depending on rcu critical section.

Its certainly non-trivial to remove. I don't really like taking a ref
here but seems necessary for now.

Acked-by: John Fastabend <john.fastabend@gmail.com>
