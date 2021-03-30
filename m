Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E33934E170
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 08:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhC3Gpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 02:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhC3GpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 02:45:16 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB23C061762;
        Mon, 29 Mar 2021 23:45:16 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id r193so15316998ior.9;
        Mon, 29 Mar 2021 23:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=7luhtVz9W7Sx/e0f7IPhmrJ4jb6u/2zMKnkjYUyWxUc=;
        b=XXT5glrUc03RkVnad5P37C6uAwiog5Tcp4tK1huYAXlkPFLVXWImWDedtTJWACs68l
         MLYqtNI/5mLqdYQDyRhE07H1+yCjty4sqZ3aIFuRVgQ/HeqbfXUTOu2CpXuI+3xOyrHF
         4r1AX+5+0xdJZFBywVxWdv+PNIdBGtBYhiGg5E84TLX7qJF6P3vMJPH/fYDJcKUd+BHa
         UUdd09RwUfrVx2qrl4ivJV7C12iiXMd9XU35+TZhCsPLnqNuu+4j0ZJ5JesDLJRFxNiF
         H4CN9j5ITmpCEU2vWHhOYbuQfnqGisZAAYjCmznEm0DkvoRf19wf/VMLdwhffnXBjEM8
         Ix5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=7luhtVz9W7Sx/e0f7IPhmrJ4jb6u/2zMKnkjYUyWxUc=;
        b=aEB7F3/kPbPiMOMeGHRwWS69fr/q5AbV2Akr6l+7FiqEHuHajF91q5ysgBYE+WYnkz
         wd2pFdI9+MTFQZCtuTtnZlAZX13fJwm+hdnNuNewEg6EMN7vC7tpsDhQqrSrFRyBFovF
         kcMr8tCcNhFyQvZFxLLC0QurGKViTZjMlt5eE616jLH9ATzy++L6nneP9QHB0sA9MZDZ
         2oOnDTEP7VetZaHH0J2qaYeK0R5gMcNXLA2hJEOGwE+rnPqHN2aBa5T1HZFH8HjqtLvi
         dH9CPeVPXoAbcjz/9+LgT3Nq0L+6kErI0tqXJB9dahB6/Li83Gwv9q7p7ubrA6RBSekr
         yDrw==
X-Gm-Message-State: AOAM530xbH9jTGg03o/wFswHqiKh1WCwDmZ7PeHEm3nZpzOxRuWZoV5a
        +Lzxig+MdwgU9ln4z6/ATZI=
X-Google-Smtp-Source: ABdhPJyhVJ0kOJlB9EEkIyeMNgkJL31o6cZ5yyL7hB3b5OqhfdXZIGDSolN5LgyE/mo6e2gwERRTIg==
X-Received: by 2002:a02:c8d4:: with SMTP id q20mr27587520jao.90.1617086715769;
        Mon, 29 Mar 2021 23:45:15 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id a12sm11053142ilt.53.2021.03.29.23.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 23:45:15 -0700 (PDT)
Date:   Mon, 29 Mar 2021 23:45:05 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <6062c8f187367_62cf120817@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpXVYcrhZ083uFdNqMSuAqq-qPQgp+Hx1KUYaquZmSz1Zw@mail.gmail.com>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
 <20210328202013.29223-10-xiyou.wangcong@gmail.com>
 <60623e6fdd870_401fb20818@john-XPS-13-9370.notmuch>
 <CAM_iQpVgdP1w73skJ3W-MHkO-pPVKT7WM06Fqc35XkXjDcWf_Q@mail.gmail.com>
 <6062c3d37db9e_600ea20898@john-XPS-13-9370.notmuch>
 <CAM_iQpXVYcrhZ083uFdNqMSuAqq-qPQgp+Hx1KUYaquZmSz1Zw@mail.gmail.com>
Subject: Re: [Patch bpf-next v7 09/13] udp: implement ->read_sock() for
 sockmap
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Mon, Mar 29, 2021 at 11:23 PM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > On Mon, Mar 29, 2021 at 1:54 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > > >
> > > > Cong Wang wrote:
> > > > > From: Cong Wang <cong.wang@bytedance.com>
> > > > >
> > > > > This is similar to tcp_read_sock(), except we do not need
> > > > > to worry about connections, we just need to retrieve skb
> > > > > from UDP receive queue.
> > > > >
> > > > > Note, the return value of ->read_sock() is unused in
> > > > > sk_psock_verdict_data_ready().
> > > > >
> > > > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > > > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > > > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > > > ---
> >
> > [...]
> >
> > > > >  }
> > > > >  EXPORT_SYMBOL(__skb_recv_udp);
> > > > >
> > > > > +int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> > > > > +               sk_read_actor_t recv_actor)
> > > > > +{
> > > > > +     int copied = 0;
> > > > > +
> > > > > +     while (1) {
> > > > > +             int offset = 0, err;
> > > >
> > > > Should this be
> > > >
> > > >  int offset = sk_peek_offset()?
> > >
> > > What are you really suggesting? sk_peek_offset() is just 0 unless
> > > we have MSG_PEEK here and we don't, because we really want to
> > > dequeue the skb rather than peeking it.
> > >
> > > Are you suggesting we should do peeking? I am afraid we can't.
> > > Please be specific, guessing your mind is not an effective way to
> > > address your reviews.
> >
> > I was only asking for further details because the offset addition
> > below struck me as odd.
> >
> > >
> > > >
> > > > MSG_PEEK should work from recv side, at least it does on TCP side. If
> > > > its handled in some following patch a comment would be nice. I was
> > > > just reading udp_recvmsg() so maybe its not needed.
> > >
> > > Please explain why do we need peeking in sockmap? At very least
> > > it has nothing to do with my patchset.
> >
> > We need MSG_PEEK to work from application side. From sockmap
> > side I agree its not needed.
> 
> How does the application reach udp_read_sock()? UDP does not support
> splice() as I already mentioned, as ->splice_read() is still missing.

It doesn't. All I was trying to say is if an application calls
recvmsg(..., MSG_PEEK) it should work correctly. It wasn't a
comment about this specific patch.

> 
> >
> > >
> > > I do not know why you want to use TCP as a "standard" here, TCP
> > > also supports splice(), UDP still doesn't even with ->read_sock().
> > > Of course they are very different.
> >
> > Not claiming any "standard" here only that user application needs
> > to work correctly if it passes MSG_PEEK.
> 
> I do not see how an application could pass any msg flag to
> udp_read_sock().

Agree.

> 
> >
> > >
> > > >
> > > > > +             struct sk_buff *skb;
> > > > > +
> > > > > +             skb = __skb_recv_udp(sk, 0, 1, &offset, &err);
> > > > > +             if (!skb)
> > > > > +                     return err;
> > > > > +             if (offset < skb->len) {
> > > > > +                     size_t len;
> > > > > +                     int used;
> > > > > +
> > > > > +                     len = skb->len - offset;
> > > > > +                     used = recv_actor(desc, skb, offset, len);
> > > > > +                     if (used <= 0) {
> > > > > +                             if (!copied)
> > > > > +                                     copied = used;
> > > > > +                             break;
> > > > > +                     } else if (used <= len) {
> > > > > +                             copied += used;
> > > > > +                             offset += used;
> > > >
> > > > The while loop is going to zero this? What are we trying to do
> > > > here with offset?
> > >
> > > offset only matters for MSG_PEEK and we do not support peeking
> > > in sockmap case, hence it is unnecessary here. I "use" it here just
> > > to make the code as complete as possible.
> >
> > huh? If its not used the addition is just confusing. Can we drop it?
> 
> If you mean dropping this single line of code, yes. If you mean
> dropping 'offset' completely, no, as both __skb_recv_udp() and
> recv_actor() still need it. If you mean I should re-write
> __skb_recv_udp() and recv_actor() just to drop 'offset', I am afraid
> that is too much with too little gain.

All I'm saying is drop the single line of code above. This specific
one

 'offset += used'

And add a comment in the commit msg that just says peeking is not
supported. I think we need at least one more respin of the patches
anyways to address a different small comment so should be easy.

> 
> >
> > >
> > > To further answer your question, it is set to 0 when we return a
> > > valid skb on line 201 inside __skb_try_recv_from_queue(), as
> > > "_off" is set to 0 and won't change unless we have MSG_PEEK.
> > >
> > > 173         bool peek_at_off = false;
> > > 174         struct sk_buff *skb;
> > > 175         int _off = 0;
> > > 176
> > > 177         if (unlikely(flags & MSG_PEEK && *off >= 0)) {
> > > 178                 peek_at_off = true;
> > > 179                 _off = *off;
> > > 180         }
> > > 181
> > > 182         *last = queue->prev;
> > > 183         skb_queue_walk(queue, skb) {
> > > 184                 if (flags & MSG_PEEK) {
> > > 185                         if (peek_at_off && _off >= skb->len &&
> > > 186                             (_off || skb->peeked)) {
> > > 187                                 _off -= skb->len;
> > > 188                                 continue;
> > > 189                         }
> > > 190                         if (!skb->len) {
> > > 191                                 skb = skb_set_peeked(skb);
> > > 192                                 if (IS_ERR(skb)) {
> > > 193                                         *err = PTR_ERR(skb);
> > > 194                                         return NULL;
> > > 195                                 }
> > > 196                         }
> > > 197                         refcount_inc(&skb->users);
> > > 198                 } else {
> > > 199                         __skb_unlink(skb, queue);
> > > 200                 }
> > > 201                 *off = _off;
> > > 202                 return skb;
> > >
> > > Of course, when we return NULL, we return immediately without
> > > using offset:
> > >
> > > 1794                 skb = __skb_recv_udp(sk, 0, 1, &offset, &err);
> > > 1795                 if (!skb)
> > > 1796                         return err;
> > >
> > > This should not be hard to figure out. Hope it is clear now.
> > >
> >
> > Yes, but tracking offset only to clear it a couple lines later
> > is confusing.
> 
> Yeah, but that's __skb_recv_udp()'s fault, not mine. We can refactor
> __skb_recv_udp() a bit for !MSG_PEEK case, but I do not see
> much gain here.

No don't bother here. I don't see much gain in doing that either. If
you want do it in another series not this one.

> 
> Thanks.
