Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C5F34E14B
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 08:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhC3Ggr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 02:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhC3Ggn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 02:36:43 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3E9C061762;
        Mon, 29 Mar 2021 23:36:43 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id v186so10992140pgv.7;
        Mon, 29 Mar 2021 23:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7pN7MXcXsn1Px8YArmSwJzwIpKjY+5whROnmy5NXENU=;
        b=EQppdB1h2/GkdhcTPBR6bL+8yiJNtcymQB6iNS/vmVBGZfKrHMMtghVt+B4vgaadUL
         xkaoGDAGos29eahDd0a+Kim/VgZroW0GhpAenJk3uUje0hLM+M0ph6nYn9Os0A3n5uoK
         Fk920v5I9QgaH1Bw/mTNTkIp01bkrfvTR3ap7KQUZhxwIHpDxnksQEg8euQG5hY+LHtS
         CnBIq8Owc4GRkx2195vRMrlmzNorVBse23VkiwKme5I38mvh4cFOTZuYGuawPCrSBFKp
         daeio2fBFrSDCKGfWQati027zCSRFWr4vrQL52mitZYC+i3brnGBQIGA2L+atdpmgKLb
         O0wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7pN7MXcXsn1Px8YArmSwJzwIpKjY+5whROnmy5NXENU=;
        b=VEI95nHhHnYp4cXUduU7g0MaHO8msJh9JR+dWwAIzSJPR6w9y/RGE00+Sd44/10XG0
         a7XznBmEhxG8AtSlJtC01wu2J2/U8GjzdsnDVYE4oDXOTtTBT2w75TxYbhpAGPqum8jH
         IViCCz8TwqQ1t4lEpnf5o94vYZkEwOB1tO1TN023EvVum5NHY0seS54qAAMUH3wl9LIl
         vrvvPfQ3h4+RC9qQrntuI9ptknXIpvh6Q7nQV5F5CYViLLdBmuh/CczIuf3b4wq4Lp2m
         zBiSQTMnM9eqEtGfe8jRykpmz+LUPSBRPuO8IXFJw4voXFjEgdp+ZciAneH3/rOlqQv2
         tsGw==
X-Gm-Message-State: AOAM5333VStcW/jszn0CZfHPIq03pOoIljie9HMV3nlUoYz9ESYz3Tex
        MM1tMV1V8TVLtIyLmZokdXJsg7cLQT9ttEFpmpwJ/GaJRJLILw==
X-Google-Smtp-Source: ABdhPJxMl42QnpBwgLfmBVGIVqNv4k6LZ4s+yLT/CKn1NLVFqj8fE+JSFxqcH8DMOIw99FzDmSYNE09x6Hhvn6Fn7lQ=
X-Received: by 2002:a63:2ec7:: with SMTP id u190mr1876430pgu.18.1617086203101;
 Mon, 29 Mar 2021 23:36:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
 <20210328202013.29223-10-xiyou.wangcong@gmail.com> <60623e6fdd870_401fb20818@john-XPS-13-9370.notmuch>
 <CAM_iQpVgdP1w73skJ3W-MHkO-pPVKT7WM06Fqc35XkXjDcWf_Q@mail.gmail.com> <6062c3d37db9e_600ea20898@john-XPS-13-9370.notmuch>
In-Reply-To: <6062c3d37db9e_600ea20898@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 29 Mar 2021 23:36:31 -0700
Message-ID: <CAM_iQpXVYcrhZ083uFdNqMSuAqq-qPQgp+Hx1KUYaquZmSz1Zw@mail.gmail.com>
Subject: Re: [Patch bpf-next v7 09/13] udp: implement ->read_sock() for sockmap
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 11:23 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > On Mon, Mar 29, 2021 at 1:54 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > >
> > > Cong Wang wrote:
> > > > From: Cong Wang <cong.wang@bytedance.com>
> > > >
> > > > This is similar to tcp_read_sock(), except we do not need
> > > > to worry about connections, we just need to retrieve skb
> > > > from UDP receive queue.
> > > >
> > > > Note, the return value of ->read_sock() is unused in
> > > > sk_psock_verdict_data_ready().
> > > >
> > > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > > ---
>
> [...]
>
> > > >  }
> > > >  EXPORT_SYMBOL(__skb_recv_udp);
> > > >
> > > > +int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> > > > +               sk_read_actor_t recv_actor)
> > > > +{
> > > > +     int copied = 0;
> > > > +
> > > > +     while (1) {
> > > > +             int offset = 0, err;
> > >
> > > Should this be
> > >
> > >  int offset = sk_peek_offset()?
> >
> > What are you really suggesting? sk_peek_offset() is just 0 unless
> > we have MSG_PEEK here and we don't, because we really want to
> > dequeue the skb rather than peeking it.
> >
> > Are you suggesting we should do peeking? I am afraid we can't.
> > Please be specific, guessing your mind is not an effective way to
> > address your reviews.
>
> I was only asking for further details because the offset addition
> below struck me as odd.
>
> >
> > >
> > > MSG_PEEK should work from recv side, at least it does on TCP side. If
> > > its handled in some following patch a comment would be nice. I was
> > > just reading udp_recvmsg() so maybe its not needed.
> >
> > Please explain why do we need peeking in sockmap? At very least
> > it has nothing to do with my patchset.
>
> We need MSG_PEEK to work from application side. From sockmap
> side I agree its not needed.

How does the application reach udp_read_sock()? UDP does not support
splice() as I already mentioned, as ->splice_read() is still missing.

>
> >
> > I do not know why you want to use TCP as a "standard" here, TCP
> > also supports splice(), UDP still doesn't even with ->read_sock().
> > Of course they are very different.
>
> Not claiming any "standard" here only that user application needs
> to work correctly if it passes MSG_PEEK.

I do not see how an application could pass any msg flag to
udp_read_sock().

>
> >
> > >
> > > > +             struct sk_buff *skb;
> > > > +
> > > > +             skb = __skb_recv_udp(sk, 0, 1, &offset, &err);
> > > > +             if (!skb)
> > > > +                     return err;
> > > > +             if (offset < skb->len) {
> > > > +                     size_t len;
> > > > +                     int used;
> > > > +
> > > > +                     len = skb->len - offset;
> > > > +                     used = recv_actor(desc, skb, offset, len);
> > > > +                     if (used <= 0) {
> > > > +                             if (!copied)
> > > > +                                     copied = used;
> > > > +                             break;
> > > > +                     } else if (used <= len) {
> > > > +                             copied += used;
> > > > +                             offset += used;
> > >
> > > The while loop is going to zero this? What are we trying to do
> > > here with offset?
> >
> > offset only matters for MSG_PEEK and we do not support peeking
> > in sockmap case, hence it is unnecessary here. I "use" it here just
> > to make the code as complete as possible.
>
> huh? If its not used the addition is just confusing. Can we drop it?

If you mean dropping this single line of code, yes. If you mean
dropping 'offset' completely, no, as both __skb_recv_udp() and
recv_actor() still need it. If you mean I should re-write
__skb_recv_udp() and recv_actor() just to drop 'offset', I am afraid
that is too much with too little gain.

>
> >
> > To further answer your question, it is set to 0 when we return a
> > valid skb on line 201 inside __skb_try_recv_from_queue(), as
> > "_off" is set to 0 and won't change unless we have MSG_PEEK.
> >
> > 173         bool peek_at_off = false;
> > 174         struct sk_buff *skb;
> > 175         int _off = 0;
> > 176
> > 177         if (unlikely(flags & MSG_PEEK && *off >= 0)) {
> > 178                 peek_at_off = true;
> > 179                 _off = *off;
> > 180         }
> > 181
> > 182         *last = queue->prev;
> > 183         skb_queue_walk(queue, skb) {
> > 184                 if (flags & MSG_PEEK) {
> > 185                         if (peek_at_off && _off >= skb->len &&
> > 186                             (_off || skb->peeked)) {
> > 187                                 _off -= skb->len;
> > 188                                 continue;
> > 189                         }
> > 190                         if (!skb->len) {
> > 191                                 skb = skb_set_peeked(skb);
> > 192                                 if (IS_ERR(skb)) {
> > 193                                         *err = PTR_ERR(skb);
> > 194                                         return NULL;
> > 195                                 }
> > 196                         }
> > 197                         refcount_inc(&skb->users);
> > 198                 } else {
> > 199                         __skb_unlink(skb, queue);
> > 200                 }
> > 201                 *off = _off;
> > 202                 return skb;
> >
> > Of course, when we return NULL, we return immediately without
> > using offset:
> >
> > 1794                 skb = __skb_recv_udp(sk, 0, 1, &offset, &err);
> > 1795                 if (!skb)
> > 1796                         return err;
> >
> > This should not be hard to figure out. Hope it is clear now.
> >
>
> Yes, but tracking offset only to clear it a couple lines later
> is confusing.

Yeah, but that's __skb_recv_udp()'s fault, not mine. We can refactor
__skb_recv_udp() a bit for !MSG_PEEK case, but I do not see
much gain here.

Thanks.
