Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1631D1FC1
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390817AbgEMT4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732218AbgEMT4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:56:43 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EF1C061A0E
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:56:42 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id a136so617514qkg.6
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0GFIUDstFYl47OE0S5dumvGBoOXhEcqpXzIXXnwWLGc=;
        b=fhdJx2rqzk2VBm+S7aXWXMmQoqgSad2dGTC9La2Q5wWNYw+nk3ue4Z3AltjDtKqRZw
         jdcTmQZ9OH4JyCaL2AlyHcZmTLxW3OSA6x26BPXwaVK0brgB1igUXWRQBmf/nRW8h104
         DUW2JF36mXR31JLaL2LyzvcWDMGwdyKAH45WdiYsCE011NTLvi6s+gpxV/IwWplmDBCK
         NVtbBkoPE0SU636I9eASJjoNxwz4jh60gCITGok8yl0oI4n5880jLJ3WZ7WnnzwywgRl
         6jFbxySy5bYHMHM2wK/FsC/7bNfWBXYzT6j96LzaCS8VFAGGRyGCrl4vgGClcwVypg6G
         KMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0GFIUDstFYl47OE0S5dumvGBoOXhEcqpXzIXXnwWLGc=;
        b=JEpC1ibQa1FB0HinYf7o7aaT+t3qdJousrsl0yym7wWnf2cF2EeIxb9nv/E4A1QDWS
         UDsdurBefrtsP/CLFZrO6hfx9su8xzCTB9NJgBziQ0cZi/4YUN2mZurGH0sECv7Z3Jgg
         T9Cm3Aq04oH3WQrP4qXXCMHARNggBJsR8h7iC+WDUk5iNuzcdqmdTZkYah82NoCX9VD4
         k86ABk2aGnT1Pd0+V00BhcWr4+udj6mu+oY2BBHVPtHwu/oFCLWSJ5mO0yXJs2EyrDta
         C2cpXtqUf+GvCKdAVY/sJKq+81s+S0CuDD5iIqNY0vQ5U9CzDXJxueUs7gg6SPX5YgMV
         EN0A==
X-Gm-Message-State: AOAM5316NBHVH3cmWB0WgF4J/vyo6SKx4uHCkSGjBPU70nYtUjuXmLxH
        mzIJbKIGbRz7XFFHy+2HGHuHWdHGpCE7mqKiZRV2BQ==
X-Google-Smtp-Source: ABdhPJwdY2fxfp0XGP0xEvkEmLoMrHZlMceoFvX/apNQdlp9i1pSKwGUYVCY4+UsXOtNif0KPeoGoP7bAPi8hE1mUDs=
X-Received: by 2002:a25:8182:: with SMTP id p2mr1189542ybk.408.1589399801510;
 Wed, 13 May 2020 12:56:41 -0700 (PDT)
MIME-Version: 1.0
References: <341326348.19635.1589398715534.JavaMail.zimbra@efficios.com> <CANn89i+GH2ukLZUcWYGquvKg66L9Vbto0FxyEt3pOJyebNxqBg@mail.gmail.com>
In-Reply-To: <CANn89i+GH2ukLZUcWYGquvKg66L9Vbto0FxyEt3pOJyebNxqBg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 13 May 2020 12:56:30 -0700
Message-ID: <CANn89iL26OMWWAi18PqoQK4VBfFvRvxBJUioqXDk=8ZbKq_Efg@mail.gmail.com>
Subject: Re: [regression] TC_MD5SIG on established sockets
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 12:49 PM Eric Dumazet <edumazet@google.com> wrote:
>
> I do not think we want to transition sockets in the middle. since
> packets can be re-ordered in the network.
>
> MD5 is about security (and a loose form of it), so better make sure
> all packets have it from the beginning of the flow.
>
> A flow with TCP TS on can not suddenly be sending packets without TCP TS.
>
> Clearly, trying to support this operation is a can of worms, I do not
> want to maintain such atrocity.
>
> RFC can state whatever it wants, sometimes reality forces us to have
> sane operations.
>
> Thanks.


Also the RFC states :

"This password never appears in the connection stream, and the actual
    form of the password is up to the application. It could even change
    during the lifetime of a particular connection so long as this change
    was synchronized on both ends"

It means the key can be changed, but this does not imply the option
can be turned on/off dynamically.



>
> On Wed, May 13, 2020 at 12:38 PM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> >
> > Hi,
> >
> > I am reporting a regression with respect to use of TCP_MD5SIG/TCP_MD5SIG_EXT
> > on established sockets. It is observed by a customer.
> >
> > This issue is introduced by this commit:
> >
> > commit 721230326891 "tcp: md5: reject TCP_MD5SIG or TCP_MD5SIG_EXT on established sockets"
> >
> > The intent of this commit appears to be to fix a use of uninitialized value in
> > tcp_parse_options(). The change introduced by this commit is to disallow setting
> > the TCP_MD5SIG{,_EXT} socket options on an established socket.
> >
> > The justification for this change appears in the commit message:
> >
> >    "I believe this was caused by a TCP_MD5SIG being set on live
> >     flow.
> >
> >     This is highly unexpected, since TCP option space is limited.
> >
> >     For instance, presence of TCP MD5 option automatically disables
> >     TCP TimeStamp option at SYN/SYNACK time, which we can not do
> >     once flow has been established.
> >
> >     Really, adding/deleting an MD5 key only makes sense on sockets
> >     in CLOSE or LISTEN state."
> >
> > However, reading through RFC2385 [1], this justification does not appear
> > correct. Quoting to the RFC:
> >
> >    "This password never appears in the connection stream, and the actual
> >     form of the password is up to the application. It could even change
> >     during the lifetime of a particular connection so long as this change
> >     was synchronized on both ends"
> >
> > The paragraph above clearly underlines that changing the MD5 signature of
> > a live TCP socket is allowed.
> >
> > I also do not understand why it would be invalid to transition an established
> > TCP socket from no-MD5 to MD5, or transition from MD5 to no-MD5. Quoting the
> > RFC:
> >
> >   "The total header size is also an issue.  The TCP header specifies
> >    where segment data starts with a 4-bit field which gives the total
> >    size of the header (including options) in 32-byte words.  This means
> >    that the total size of the header plus option must be less than or
> >    equal to 60 bytes -- this leaves 40 bytes for options."
> >
> > The paragraph above seems to be the only indication that some TCP options
> > cannot be combined on a given TCP socket: if the resulting header size does
> > not fit. However, I do not see anything in the specification preventing any
> > of the following use-cases on an established TCP socket:
> >
> > - Transition from no-MD5 to MD5,
> > - Transition from MD5 to no-MD5,
> > - Changing the MD5 key associated with a socket.
> >
> > As long as the resulting combination of options does not exceed the available
> > header space.
> >
> > Can we please fix this KASAN report in a way that does not break user-space
> > applications expectations about Linux' implementation of RFC2385 ?
> >
> > Thanks,
> >
> > Mathieu
> >
> > [1] RFC2385: https://tools.ietf.org/html/rfc2385
> >
> > --
> > Mathieu Desnoyers
> > EfficiOS Inc.
> > http://www.efficios.com
