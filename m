Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED25180E8E
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 04:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgCKDef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 23:34:35 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46627 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727659AbgCKDee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 23:34:34 -0400
Received: by mail-qt1-f196.google.com with SMTP id t13so554040qtn.13;
        Tue, 10 Mar 2020 20:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pUV0rX2vW+ZsRJLO/LC2/Xyy7DtxKT4R5EIehHFqI3s=;
        b=alqlQ1lFHA0LSKy4o+88UKc0SqavULRpGBKcuxUARbBKuW+U+j48n98WQ9qmC9eJG9
         rTrrmouMQyYKmYW4TD+JzCfDMXiCqAayu5LJox+1RrPUbB6NBS70/biRJxMzBqIBOJd/
         rRs6axEv9KsKhLdGcjjwFHz7/V9nPT0ZB6RMv0KWIqqN948ZBN4NXcAlItPpIXiyh6/M
         KAUJu6sxu1h+IbfG9oxGE6f+AazpTcst9ck1DXlQNdi4g//dk4NL2olCZwKWjYLpetmI
         /StDRd++67mLg7M+epZTfEf+pxW0vk3FmBF94X5nWADpEQY0k+7+EHPGJ26cvHPThjoe
         27/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pUV0rX2vW+ZsRJLO/LC2/Xyy7DtxKT4R5EIehHFqI3s=;
        b=FFMYe8o7sun5fzZ9x9CaND5f8/en8VqWJ2nRC9sfrM630iSgNYwR13L2J8DszEz2rS
         7+juyZq+gFdIx1tCzvzsuF/aDiaO2Y2l/ToeK0tub0gxb7Oedyr8QOyMMMM5G3b1d+tW
         ne3mdAAFS6Du+Mhe7GM0C6ROE3JQRlLfSM3ob42AYU6HqSAxZLU8dJcDx/OrlrZA+YMg
         d/Fb+ceMSx0IBzFg7TkbR1Tzqm7thT/2h6uumrdIml69z/B8mU/e3rvBbCq7xeaINWaB
         nBU0wDGVTkXzwK+Nf8dB91ML4SPrioqaWTIZIDu/YeTQxv6gGP6ua96IeC/1rxmNX9IU
         x1yw==
X-Gm-Message-State: ANhLgQ096sT7H19Klsem/+0Rh+mfTzHQk3vKfUh1STkjfXOzk5RUJtSq
        bqIcThBfVsIcjVku2IjdpZY=
X-Google-Smtp-Source: ADFU+vvbBlaWNYiLvyCRZEzbozAOS3rZneCxDHiwBCVLStd2reg1Q4o8x8Wk3UBX1aH8EqDx/eclYA==
X-Received: by 2002:ac8:76d0:: with SMTP id q16mr902276qtr.73.1583897671750;
        Tue, 10 Mar 2020 20:34:31 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f028:aa40:30e3:a413:313c:50ab])
        by smtp.gmail.com with ESMTPSA id j85sm9816695qke.20.2020.03.10.20.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 20:34:30 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 8690DC163B; Wed, 11 Mar 2020 00:34:28 -0300 (-03)
Date:   Wed, 11 Mar 2020 00:34:28 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jere Leppanen <jere.leppanen@nokia.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "michael.tuexen@lurchi.franken.de" <michael.tuexen@lurchi.franken.de>
Subject: Re: [PATCH net] sctp: return a one-to-one type socket when doing
 peeloff
Message-ID: <20200311033428.GD2547@localhost.localdomain>
References: <b3091c0764023bbbb17a26a71e124d0f81349f20.1583132235.git.lucien.xin@gmail.com>
 <HE1PR0702MB3610BB291019DD7F51DBC906ECE40@HE1PR0702MB3610.eurprd07.prod.outlook.com>
 <CADvbK_ewk7mGNr6T4smWeQ0TcW3q4yabKZwGX3dK=XcH7gv=KQ@mail.gmail.com>
 <alpine.LFD.2.21.2003041349400.19073@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.21.2003041349400.19073@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 07:13:14PM +0200, Jere Leppanen wrote:
> On Wed, 4 Mar 2020, Xin Long wrote:
> 
> > On Wed, Mar 4, 2020 at 2:38 AM Leppanen, Jere (Nokia - FI/Espoo)
> > <jere.leppanen@nokia.com> wrote:
> > > 
> > > On Mon, 2 Mar 2020, Xin Long wrote:
> > > 
> > > > As it says in rfc6458#section-9.2:
> > > > 
> > > >   The application uses the sctp_peeloff() call to branch off an
> > > >   association into a separate socket.  (Note that the semantics are
> > > >   somewhat changed from the traditional one-to-one style accept()
> > > >   call.)  Note also that the new socket is a one-to-one style socket.
> > > >   Thus, it will be confined to operations allowed for a one-to-one
> > > >   style socket.
> > > > 
> > > > Prior to this patch, sctp_peeloff() returned a one-to-many type socket,
> > > > on which some operations are not allowed, like shutdown, as Jere
> > > > reported.
> > > > 
> > > > This patch is to change it to return a one-to-one type socket instead.
> > > 
> > > Thanks for looking into this. I like the patch, and it fixes my simple
> > > test case.
> > > 
> > > But with this patch, peeled-off sockets are created by copying from a
> > > one-to-many socket to a one-to-one socket. Are you sure that that's
> > > not going to cause any problems? Is it possible that there was a
> > > reason why peeloff wasn't implemented this way in the first place?
> > I'm not sure, it's been there since very beginning, and I couldn't find
> > any changelog about it.
> > 
> > I guess it was trying to differentiate peeled-off socket from TCP style
> > sockets.

Me too.

> 
> Well, that's probably the reason for UDP_HIGH_BANDWIDTH style. And maybe
> there is legitimate need for that differentiation in some cases, but I think
> inventing a special socket style is not the best way to handle it.

I agree, but.. (in the end of the email)

> 
> But actually I meant why is a peeled-off socket created as SOCK_SEQPACKET
> instead of SOCK_STREAM. It could be to avoid copying from SOCK_SEQPACKET to
> SOCK_STREAM, but why would we need to avoid that?
> 
> Mark Butler commented in 2006
> (https://sourceforge.net/p/lksctp/mailman/message/10122693/):
> 
>     In short, SOCK_SEQPACKET could/should be replaced with SOCK_STREAM
>     right there, but there might be a minor dependency or two that would
>     need to be fixed.
> 
> > 
> > > 
> > > With this patch there's no way to create UDP_HIGH_BANDWIDTH style
> > > sockets anymore, so the remaining references should probably be
> > > cleaned up:
> > > 
> > > ./net/sctp/socket.c:1886:       if (!sctp_style(sk, UDP_HIGH_BANDWIDTH) && msg->msg_name) {
> > > ./net/sctp/socket.c:8522:       if (sctp_style(sk, UDP_HIGH_BANDWIDTH))
> > > ./include/net/sctp/structs.h:144:       SCTP_SOCKET_UDP_HIGH_BANDWIDTH,
> > > 
> > > This patch disables those checks. The first one ignores a destination
> > > address given to sendmsg() with a peeled-off socket - I don't know
> > > why. The second one prevents listen() on a peeled-off socket.
> > My understanding is:
> > UDP_HIGH_BANDWIDTH is another kind of one-to-one socket, like TCP style.
> > it can get asoc by its socket when sending msg, doesn't need daddr.
> 
> But on that association, the peer may have multiple addresses. The RFC says
> (https://tools.ietf.org/html/rfc6458#section-4.1.8):
> 
>     When sending, the msg_name field [...] is used to indicate a preferred
>     peer address if the sender wishes to discourage the stack from sending
>     the message to the primary address of the receiver.

Which means the currect check in 1886 is wrong and should be fixed regardless.

> 
> > 
> > Now I thinking to fix your issue in sctp_shutdown():
> > 
> > @@ -5163,7 +5163,7 @@ static void sctp_shutdown(struct sock *sk, int how)
> >        struct net *net = sock_net(sk);
> >        struct sctp_endpoint *ep;
> > 
> > -       if (!sctp_style(sk, TCP))
> > +       if (sctp_style(sk, UDP))
> >                return;
> > 
> > in this way, we actually think:
> > one-to-many socket: UDP style socket
> > one-to-one socket includes: UDP_HIGH_BANDWIDTH and TCP style sockets.
> > 
> 
> That would probably fix shutdown(), but there are other problems as well.
> sctp_style() is called in nearly a hundred different places, I wonder if
> anyone systematically went through all of them back when UDP_HIGH_BANDWIDTH
> was added.

I suppose, and with no grounds, just random thoughts, that
UDP_HIGH_BANDWIDTH is a left-over from an early draft/implementation.

> 
> I think getting rid of UDP_HIGH_BANDWIDTH altogether is a much cleaner
> solution. That's what your patch does, which is why I like it. But such a
> change could easily break something.

Xin's initial patch here or this without backward compatibility, will
create some user-noticeable differences, yes. For example, in
sctp_recvmsg():
        if (sctp_style(sk, TCP) && !sctp_sstate(sk, ESTABLISHED) &&
            !sctp_sstate(sk, CLOSING) && !sctp_sstate(sk, CLOSED)) {
                err = -ENOTCONN;
                goto out;

And in sctp_setsockopt_autoclose():
" * This socket option is applicable to the UDP-style socket only. When"
        /* Applicable to UDP-style socket only */
        if (sctp_style(sk, TCP))
                return -EOPNOTSUPP;

Although on RFC it was updated to:
8.1.8.  Automatic Close of Associations (SCTP_AUTOCLOSE)
   This socket option is applicable to the one-to-many style socket
   only.

These would start to be checked with such change. The first is a
minor, because that return code is already possible from within
sctp_wait_for_packet(), it's mostly just enforced later. But the
second..  Yes, we're violating the RFC in there, but OTOH, I'm afraid
it may be too late to fix it.

Removing UDP_HIGH_BANDWIDTH would thus require some weird checks, like
in the autoclose example above, something like:
        /* Applicable to one-to-many sockets only */
        if (sctp_style(sk, TCP) && !sctp_peeledoff(sk))
                return -EOPNOTSUPP;

Which doesn't help much by now. Yet, maybe there is only a few cases
like this around?

  Marcelo
