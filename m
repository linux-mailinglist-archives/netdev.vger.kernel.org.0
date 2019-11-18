Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4088FFD96
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 05:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfKREuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 23:50:06 -0500
Received: from mail-il1-f174.google.com ([209.85.166.174]:34226 "EHLO
        mail-il1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfKREuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 23:50:05 -0500
Received: by mail-il1-f174.google.com with SMTP id p6so14787680ilp.1;
        Sun, 17 Nov 2019 20:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=YKSzNSLCGVARoV4IzLhVDV/kTBoDozr3C6yn2Fuxg1k=;
        b=Z2xjwOAmfKKqdvg5n8To/ssWafXo4w4yBsXKbEC6TdowR5PYUXCtjbmzzZUxe+cJPB
         7aljvhGs8UoUYeIv64+AbvFlvXGG55hlS3+yWlE55zSoD+tbISSJTho3E4/ACuU+wnPR
         GAi3wPBswZ/8oXNcRklpeqc9n+3vdOPsNWlmyj5E+WGpYrT1NFgiUliUi+lgTM0l31F0
         mRcFAhWb/j4QSzCW77hb216sOrC4hmJCt0m25mp7LcQmB9qGWrJSC/5uTBwFtLOFTnkv
         R6Om+e3GCiod9m9fLgKHQ1Yc1uM+jIM2Wp7XuZOjba/ztY6rXe2MrsFPUs42eNgtpnOw
         dgDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=YKSzNSLCGVARoV4IzLhVDV/kTBoDozr3C6yn2Fuxg1k=;
        b=NM+VIeyLcBcD37Iq9ITz4uiEn0Ggqef3AH21Sui63GuDHWD1raA2QcwIBcAqvmxXJC
         b+aKeQxjXKKFI+s9e4ZNzwcM+8QuQVpDRSd6zbYSZxzN2qAVPzf+x5rMbVZMyLY+tEab
         ET7AZ17qsEFo3/l2V43BfUVC2UKI0GElrg8z30/bWi3NFBM0e0zpFWA7alIkVZjvBCYq
         JNJUVgoIqlzBrVOe/CNRwvR1T9APTWqsrJH5gDgn4o4MFwGjIliZO6UtG4XqRWxOLxf0
         OquzqX8hFkhOnp30wIEbeBFx7uPvFbw3w7tX0PjlX6M7BqU4yc49Urn/qAkpn4PtZW3I
         EUuQ==
X-Gm-Message-State: APjAAAWcLyK2QESbHjsAELEhtE9enXwQ6g5eFgmSkUuBKWlE8N9ga1U9
        I3N5jznWJQfpJvsz3vZa9eJkVwET
X-Google-Smtp-Source: APXvYqycncGGpWNXBEbCLHcFAEotjKyFI4i6edHZh+rF9DgYORTzeAAMunmmvyZjj9XD53pDCuYmrw==
X-Received: by 2002:a92:1705:: with SMTP id u5mr13975207ill.151.1574052604513;
        Sun, 17 Nov 2019 20:50:04 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c16sm3242110ioh.57.2019.11.17.20.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Nov 2019 20:50:03 -0800 (PST)
Date:   Sun, 17 Nov 2019 20:49:54 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5dd222f214374_63b82b118b2685b42d@john-XPS-13-9370.notmuch>
In-Reply-To: <CA+FuTSdaAawmZ2N8nfDDKu3XLpXBbMtcCT0q4FntDD2gn8ASUw@mail.gmail.com>
References: <CA+FuTSfTMuKv8s0zdS6YzLC14bNdPQxi2mu7ak6e_sS+qyyrFg@mail.gmail.com>
 <5dcf24ddc492e_66d2acadef865b4b2@john-XPS-13-9370.notmuch>
 <CA+FuTSdaAawmZ2N8nfDDKu3XLpXBbMtcCT0q4FntDD2gn8ASUw@mail.gmail.com>
Subject: Re: combining sockmap + ktls
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willem de Bruijn wrote:
> > > For this workload, more interesting is sk_msg directly to icept
> > > egress, anyway. This works without ktls. Support for ktls is added in
> > > commit d3b18ad31f93 ("tls: add bpf support to sk_msg handling"). The
> > > relevant callback function tls_sw_sendpage_locked was not immediately
> > > used and subsequently removed in commit cc1dbdfed023 ("Revert
> > > "net/tls: remove unused function tls_sw_sendpage_locked""). It appears
> > > to work once reverting that change, plus registering the function
> >
> > I don't fully understand this. Are you saying a BPF_SK_MSG_VERDICT
> > program attach to a ktls socket is not being called? Or packets are
> > being dropped or ...? Or that the program doesn't work even with
> > just KTLS and no bpf involved.
> 
> Not the verdict program. The setup is as follows:
> 
>   client --> icept.1 -- (optionally ktls) --> icept.2 --> server
> 
> I'm trying to redirect on send from the client directly into the send
> side of the ktls socket, to avoid waking up the icept.1 process
> completely. The ktls enabled socket has no BPF programs associated.
> 

Ah ok. This is probably the least optimized case, we've focused mostly
on the ingress sk_msg case so far.

> >
> > >
> > >         @@ -859,6 +861,7 @@ static int __init tls_register(void)
> > >
> > >                 tls_sw_proto_ops = inet_stream_ops;
> > >                 tls_sw_proto_ops.splice_read = tls_sw_splice_read;
> > >         +       tls_sw_proto_ops.sendpage_locked   = tls_sw_sendpage_locked,
> > >
> > > and additionally allowing MSG_NO_SHARED_FRAGS:
> > >
> > >          int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
> > >                                     int offset, size_t size, int flags)
> > >          {
> > >                if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
> > >         -                     MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
> > >         +                     MSG_SENDPAGE_NOTLAST |
> > > MSG_SENDPAGE_NOPOLICY | MSG_NO_SHARED_FRAGS))
> > >                          return -ENOTSUPP;
> > >
> >
> > If you had added MSG_NO_SHARED_FRAGS to the existing tls_sw_sendpage
> > would that have been sufficient?
> 
> No, the stack trace I observed is
> 
>   tcp_bpf_sendmsg_redir
>     tcp_bpf_push_locked
>       tcp_bpf_push
>         kernel_sendpage_locked
>           sock->ops->sendpage_locked
> 
> which never tries tls_sw_sendpage. Perhaps the relevant part is the
> following in tcp_bpf_push?
> 
>                 if (has_tx_ulp) {
>                         flags |= MSG_SENDPAGE_NOPOLICY;
>                         ret = kernel_sendpage_locked(sk,
>                                                      page, off, size, flags);
>                 } else {
>                         ret = do_tcp_sendpages(sk, page, off, size, flags);
>                 }
> 

Got it, want to submit a fix? Or I can this is a bug.

> > > and not registering parser+verdict programs on the destination socket.
> > > Note that without ktls this mode also works with such programs
> > > attached.
> >
> > Right ingress + ktls is known to be broken at the moment. Also I have
> > plans to cleanup ingress side at some point. The current model is a
> > bit clumsy IMO. The workqueue adds latency spikes on the 99+
> > percentiles. At this point it makes the ingress side similar to the
> > egress side without a workqueue and with verdict+parser done in a
> > single program.
> 
> Good to know thanks. Then I won't spend too much time on this.
> 
> > >
> > > Lastly, sockmap splicing from icept ingress to egress (no sk_msg) also
> > > stops working when I enable ktls on the egress socket. I'm taking a
> > > look at that next. But this email is long enough already ;)
> >
> > Yes this is a known bug I've got a set of patches to address this.
> 
> Same thing. Good to know I'm not crazy :)
> 
> > I've
> > been trying to get to it for awhile now and just resolved a few other
> > things on my side so plan to do this Monday/Tuesday next week.
> 
> To be clear, I don't mean to pressure at all. Was just running through
> a variety of points in the option space. The sk_msg  plus redirect to
> egress of a ktls-enabled socket is the variant I'm most interested in.

No pressure I need to get my queue here out I've been sitting on it
for awhile.

> 
> Do let me know if there's anything I can help out with. Thanks for
> your quick answer!

Can you send out a fix for above sendpage_locked case?

Thanks,
John
