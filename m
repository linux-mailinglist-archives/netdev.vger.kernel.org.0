Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8227A426D76
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 17:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242975AbhJHP2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 11:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242662AbhJHP2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 11:28:51 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122DEC061570;
        Fri,  8 Oct 2021 08:26:56 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id i189so3422317ioa.1;
        Fri, 08 Oct 2021 08:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=A/oayawmuy+VyA5QsA82KpXbIgkfgnumRWalv0CRXnM=;
        b=UN2QyC9IMcewHJjiGTBQ/mLtBY0sDy/VWCbZ/0TChVec1IesnmQi+IqJ/LLIe74k/N
         Oag+YfmFyAkPvnO29Bt+TSX3jcuDsLo92StDp7P02TYeJVaAZkCz3AzYYjwumSp2GBju
         4a73fsIhFkZSzU/vyN0sfGGS5KTlxv4IHeiMwxr5IxCQhVMU3IelttCsnDGXq81Au0Rs
         mWbaaZlQb97hlSfxv1e0NXyDDAayowPrW0d+GNu5fROznwUWuM2hj3Jv77/McQcMN/6m
         6cC4mwrmXQdU4MgFnbGSb1Z3eS9CFnQmBWPlrisyK87S8C8rOMvUZyfkU3/WVqIPrhMq
         COiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=A/oayawmuy+VyA5QsA82KpXbIgkfgnumRWalv0CRXnM=;
        b=rq2/EcaxtqmRilcVlpe5wsmJ83lBb0B8B8j2JNRDwBbbCvnUviZfACnv2p1sHxdy3H
         ktXKP5VQicYpofPqjnZZ4YVpXw/+EXK+BXj7FXsxL2UUrc+7SuF55x6T70HK3QI+0/nP
         aS4I7F0YdhAUQOBAvjcvPiaHOvJliBLiHvsztLDjnFtbCUslxyEczfD2DIub5oq1FJwZ
         yAoBgYhVgdtXma1E3H9CdTZX91XbO9NMdTqH0oLWJqDQ8UbRID8ntcm3yMLpOf+S+zvi
         9i5eqlq6DXo+9utp/QfDlRVcrumqdm94XtUkpyyOLdGIIszk/oncQEiFOkdtHo/2GUTE
         jIzA==
X-Gm-Message-State: AOAM530ejT00ZqEZf9em7MLml9T1rmwQsOIa1EIm4zofNyTeMRfwOPtx
        iq1IM6KSuUKSg3crkUSDz9U=
X-Google-Smtp-Source: ABdhPJzQm+uf5SVKswyRWf8micBUEGQuZiVLxia1Up2FbzoI31muuiRnCyUlPNlHM7HtA8wb7i6FYA==
X-Received: by 2002:a02:ab8f:: with SMTP id t15mr8056129jan.47.1633706815517;
        Fri, 08 Oct 2021 08:26:55 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id s8sm1169494ilt.47.2021.10.08.08.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 08:26:54 -0700 (PDT)
Date:   Fri, 08 Oct 2021 08:26:45 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Yucong Sun <sunyucong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <61606335e85ae_1bf1208bb@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpXy5HOHOU=T_FVVydBniL=tOW9sYTAMsc_nRWcZsqo8Yg@mail.gmail.com>
References: <20211002003706.11237-1-xiyou.wangcong@gmail.com>
 <20211002003706.11237-4-xiyou.wangcong@gmail.com>
 <582ff8e9-c7b7-88c1-6cf0-e143da92836f@iogearbox.net>
 <CAM_iQpXy5HOHOU=T_FVVydBniL=tOW9sYTAMsc_nRWcZsqo8Yg@mail.gmail.com>
Subject: Re: [Patch bpf v3 3/4] net: implement ->sock_is_readable() for UDP
 and AF_UNIX
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Thu, Oct 7, 2021 at 1:00 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 10/2/21 2:37 AM, Cong Wang wrote:
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > Yucong noticed we can't poll() sockets in sockmap even
> > > when they are the destination sockets of redirections.
> > > This is because we never poll any psock queues in ->poll(),
> > > except for TCP. With ->sock_is_readable() now we can
> > > overwrite >sock_is_readable(), invoke and implement it for
> > > both UDP and AF_UNIX sockets.
> > >
> > > Reported-by: Yucong Sun <sunyucong@gmail.com>
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > ---
> > >   net/ipv4/udp.c      | 2 ++
> > >   net/ipv4/udp_bpf.c  | 1 +
> > >   net/unix/af_unix.c  | 4 ++++
> > >   net/unix/unix_bpf.c | 2 ++
> > >   4 files changed, 9 insertions(+)
> > >
> > > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > > index 2a7825a5b842..4a7e15a43a68 100644
> > > --- a/net/ipv4/udp.c
> > > +++ b/net/ipv4/udp.c
> > > @@ -2866,6 +2866,8 @@ __poll_t udp_poll(struct file *file, struct socket *sock, poll_table *wait)
> > >           !(sk->sk_shutdown & RCV_SHUTDOWN) && first_packet_length(sk) == -1)
> > >               mask &= ~(EPOLLIN | EPOLLRDNORM);
> > >
> > > +     if (sk_is_readable(sk))
> > > +             mask |= EPOLLIN | EPOLLRDNORM;
> >
> > udp_poll() has this extra logic around first_packet_length() which drops all bad csum'ed
> > skbs. How does this stand in relation to sk_msg_is_readable()? Is this a concern as well
> > there? Maybe makes sense to elaborate a bit more in the commit message for context / future
> > reference.
> 
> We don't validate UDP checksums on sockmap RX path, so
> it is okay to leave it as it is, but it is worth a comment like
> you suggest. I will add a comment in this code.
> 
> If we really need to validate the checksum, it should be addressed
> in a separate patch(set), not in this one.
> 
> Thanks.

We should validate the checksum before creating the sk_msg so that any parsers running
on top of UDP don't parse a bad checksum payload or pass a bad checksum up to user
space. I thought there would be a check in the read_sock side, but I didn't see it.
