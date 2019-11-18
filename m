Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 608B9100896
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 16:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbfKRPpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 10:45:50 -0500
Received: from mail-yb1-f174.google.com ([209.85.219.174]:35063 "EHLO
        mail-yb1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727336AbfKRPpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 10:45:49 -0500
Received: by mail-yb1-f174.google.com with SMTP id h23so7334408ybg.2
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 07:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t2zuEyn8I7p1mNj98yy6MxDVu3fLzdXpcwhzheurb4I=;
        b=Dit3Pz8vYwzKzERW12kbVo9IUBPUMKwLRxGt9cWijvQMJLPKvqO8Z58GxRgZcjw7d3
         sOwN55eGV1NHAe+wQe/cgrZM0tsGdrwdfuPwzCcyH3HTK03ihqsY0rRxnKY+eW+hrMeU
         OyRwVbWFxTcXhyUorkue920WuAzWFOjrAiSIMTXBBzS0KwuQB1nZ4ENIjQxKGbrn7LpY
         mAUPCEjaReQMQ3VNmghSWyAsa3wZTkMTiMA2EYdpPLC0eq9RJrcD6b5kt0335PErcagA
         afqL/E/MnvunUi+myVfuJKpgcc7QF8SAHVOGpOCXDODR7jmBsEpI7NQfYHwF8o10cw9r
         gc/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t2zuEyn8I7p1mNj98yy6MxDVu3fLzdXpcwhzheurb4I=;
        b=FKwZOHOCX7D7El/k6vp93vvdJ6F/zotQp7TtyYiDJD+f0+T7xyzWWDFq81/p7IL0ex
         0D9rYZaWDLD51iIST5zHvtPHnlad+ytmwWctBCPQC1pv2ZxkW4DwpDCIoOU0xtsBkXBR
         7FVi45VE8/CYzLiRGZpgRGnea993DniqILkXOSW1w1BX4Vb2XvBr2utIL5hja9ILwIkf
         8xaebLvIkfqlTVfOzHq0XvEEClqE1p5bYHPnL5vktU64xrE7nXH8N6ZyBmuEVY3PQnrz
         gtUgNNDE1vBfbMpyunQyj66qSBfMGgDkUwAz2ihMC15UQqlUeqDbsB0AVkj3Gqm1/rEL
         0q2w==
X-Gm-Message-State: APjAAAU0GcEu2FwS6K9gxp2QQxF0PBTCt+U5ctw30sbiV6Fs5P9chm6V
        pd9YeSHo4RYT6AnPjORX20lbS8Go
X-Google-Smtp-Source: APXvYqw7zt7c0StA6HHT3uT11TGGu7SHJJkPAz/YOTfnfifn6GYHAvIUoWNzYYFsN7ueJwNpHInmQQ==
X-Received: by 2002:a25:cf43:: with SMTP id f64mr24399014ybg.248.1574091947985;
        Mon, 18 Nov 2019 07:45:47 -0800 (PST)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id d203sm11124422ywh.48.2019.11.18.07.45.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2019 07:45:46 -0800 (PST)
Received: by mail-yw1-f43.google.com with SMTP id v84so6020077ywc.4
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 07:45:46 -0800 (PST)
X-Received: by 2002:a0d:e808:: with SMTP id r8mr19763651ywe.275.1574091946088;
 Mon, 18 Nov 2019 07:45:46 -0800 (PST)
MIME-Version: 1.0
References: <CA+FuTSfTMuKv8s0zdS6YzLC14bNdPQxi2mu7ak6e_sS+qyyrFg@mail.gmail.com>
 <5dcf24ddc492e_66d2acadef865b4b2@john-XPS-13-9370.notmuch>
 <CA+FuTSdaAawmZ2N8nfDDKu3XLpXBbMtcCT0q4FntDD2gn8ASUw@mail.gmail.com> <5dd222f214374_63b82b118b2685b42d@john-XPS-13-9370.notmuch>
In-Reply-To: <5dd222f214374_63b82b118b2685b42d@john-XPS-13-9370.notmuch>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 18 Nov 2019 10:45:09 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfdx-T5teraitmFuT-D+8O_LM03MEj6tXgTmr+EB0Zi+A@mail.gmail.com>
Message-ID: <CA+FuTSfdx-T5teraitmFuT-D+8O_LM03MEj6tXgTmr+EB0Zi+A@mail.gmail.com>
Subject: Re: combining sockmap + ktls
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > >         @@ -859,6 +861,7 @@ static int __init tls_register(void)
> > > >
> > > >                 tls_sw_proto_ops = inet_stream_ops;
> > > >                 tls_sw_proto_ops.splice_read = tls_sw_splice_read;
> > > >         +       tls_sw_proto_ops.sendpage_locked   = tls_sw_sendpage_locked,
> > > >
> > > > and additionally allowing MSG_NO_SHARED_FRAGS:
> > > >
> > > >          int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
> > > >                                     int offset, size_t size, int flags)
> > > >          {
> > > >                if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
> > > >         -                     MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
> > > >         +                     MSG_SENDPAGE_NOTLAST |
> > > > MSG_SENDPAGE_NOPOLICY | MSG_NO_SHARED_FRAGS))
> > > >                          return -ENOTSUPP;
> > > >
> > >
> > > If you had added MSG_NO_SHARED_FRAGS to the existing tls_sw_sendpage
> > > would that have been sufficient?
> >
> > No, the stack trace I observed is
> >
> >   tcp_bpf_sendmsg_redir
> >     tcp_bpf_push_locked
> >       tcp_bpf_push
> >         kernel_sendpage_locked
> >           sock->ops->sendpage_locked
> >
> > which never tries tls_sw_sendpage. Perhaps the relevant part is the
> > following in tcp_bpf_push?
> >
> >                 if (has_tx_ulp) {
> >                         flags |= MSG_SENDPAGE_NOPOLICY;
> >                         ret = kernel_sendpage_locked(sk,
> >                                                      page, off, size, flags);
> >                 } else {
> >                         ret = do_tcp_sendpages(sk, page, off, size, flags);
> >                 }
> >
>
> Got it, want to submit a fix? Or I can this is a bug.
>
> > Do let me know if there's anything I can help out with. Thanks for
> > your quick answer!
>
> Can you send out a fix for above sendpage_locked case?

Done:

 net/tls: enable sk_msg redirect to tls socket egress
 http://patchwork.ozlabs.org/patch/1196825/

It addresses both issues at the same time. This seemed preferable than
two separate patches. MSG_NO_SHARED_FRAGS precedes commit 0608c69c9a80
("bpf: sk_msg, sock{map|hash} redirect through ULP"), so no additional
Fixes tag for that.
