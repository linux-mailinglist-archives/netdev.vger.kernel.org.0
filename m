Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D6520E093
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389800AbgF2Urc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389786AbgF2UrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:47:24 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B110C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 13:47:24 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id h39so9026674ybj.3
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 13:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UYdsVW3BBX8OC9WrPhf4Ap0SclutgAMBOwsFuhmAiUc=;
        b=sj3Z3WaQ1XCj7qzBWUHl68lvUTLwnu6zeQufplCvQ7tx0Qlt+QJveoGV1nfGTLWyLv
         M9vMyUf7RdkMji4al4luUrBJcN0XeDmkmrOP/FKVt6KzO3zJABVlVDOmki4v00ZinZsG
         W3QatwpjQU/iv2XPFNkb3pk0fgKTqufJuLYy7G9ouIXrZNHI0mXMv8bpiQaKt1wr0Hey
         zXQiFGGxuXjY2dwQ4qTyezFna1+McjHL8mJYxtwlnFmhj8/4Na+fIdw6DCLrOsEZz6vp
         nrfN7LVua3jDjmxgQfa07/uAThOHhECLgI6qrP4c4P5428H7aUw8G6BVfA7qjCy+fXsF
         LhdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UYdsVW3BBX8OC9WrPhf4Ap0SclutgAMBOwsFuhmAiUc=;
        b=cHIzZa/RuWBvMzGYNqwH5oczbHylPADjsZQrZh1TMDi39lTa2P+yG3eqneWvq2F6sh
         IDisnd2tKPbi9BErtHmeAsQUsEJE1mCoJOij449OhqCqp3pnxUwxvjGzjA7yA7j2qCAC
         iT3GFdMWeBEi19wAKaDRoyUwVOAcyeuPAsyXwxqcyG2O/cEsWGPU3iZK6FUAcjsiUPWL
         t6aWZFR1LtYy2HzulvDajiSSLnQHs9zzZqWsBMX+L0Z9PwMiO+w3VKSnV0gKh0utLcZ0
         9F9XPrg1H3iQ3e2KcMHnjTqLnsn2PVAHmPQwo6PjuHeAejyTpQZGy7LapBymA1q/iIbb
         I8WA==
X-Gm-Message-State: AOAM531b1ypyLmShPEzTO6mRvq40luzNVQQ6ExKD1iMvrZat7I9ZWMuA
        06Kf7YoZIAFNzDus004pmHntcehnCjjnnj2rC3lKQg==
X-Google-Smtp-Source: ABdhPJxtcxHf4vay9U02xLtRTxdahfswH8fg2jT+pmXLYU6yoQ0LrxrKPuLTeJOmlFoMAdLKDEoo0vUghrQVCwVvJug=
X-Received: by 2002:a25:cd87:: with SMTP id d129mr27206628ybf.395.1593463642859;
 Mon, 29 Jun 2020 13:47:22 -0700 (PDT)
MIME-Version: 1.0
References: <341326348.19635.1589398715534.JavaMail.zimbra@efficios.com>
 <CANn89i+GH2ukLZUcWYGquvKg66L9Vbto0FxyEt3pOJyebNxqBg@mail.gmail.com>
 <CANn89iL26OMWWAi18PqoQK4VBfFvRvxBJUioqXDk=8ZbKq_Efg@mail.gmail.com> <1132973300.15954.1593459836756.JavaMail.zimbra@efficios.com>
In-Reply-To: <1132973300.15954.1593459836756.JavaMail.zimbra@efficios.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 29 Jun 2020 13:47:11 -0700
Message-ID: <CANn89iJ4nh6VRsMt_rh_YwC-pn=hBqsP-LD9ykeRTnDC-P5iog@mail.gmail.com>
Subject: Re: [regression] TCP_MD5SIG on established sockets
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 12:43 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> ----- On May 13, 2020, at 3:56 PM, Eric Dumazet edumazet@google.com wrote:
>
> > On Wed, May 13, 2020 at 12:49 PM Eric Dumazet <edumazet@google.com> wrote:
> >>
> >>
> >> On Wed, May 13, 2020 at 12:38 PM Mathieu Desnoyers
> >> <mathieu.desnoyers@efficios.com> wrote:
> >> >
> >> > Hi,
> >> >
> >> > I am reporting a regression with respect to use of TCP_MD5SIG/TCP_MD5SIG_EXT
> >> > on established sockets. It is observed by a customer.
> >> >
> >> > This issue is introduced by this commit:
> >> >
> >> > commit 721230326891 "tcp: md5: reject TCP_MD5SIG or TCP_MD5SIG_EXT on
> >> > established sockets"
> >> >
> >> > The intent of this commit appears to be to fix a use of uninitialized value in
> >> > tcp_parse_options(). The change introduced by this commit is to disallow setting
> >> > the TCP_MD5SIG{,_EXT} socket options on an established socket.
> >> >
> >> > The justification for this change appears in the commit message:
> >> >
> >> >    "I believe this was caused by a TCP_MD5SIG being set on live
> >> >     flow.
> >> >
> >> >     This is highly unexpected, since TCP option space is limited.
> >> >
> >> >     For instance, presence of TCP MD5 option automatically disables
> >> >     TCP TimeStamp option at SYN/SYNACK time, which we can not do
> >> >     once flow has been established.
> >> >
> >> >     Really, adding/deleting an MD5 key only makes sense on sockets
> >> >     in CLOSE or LISTEN state."
> >> >
> >> > However, reading through RFC2385 [1], this justification does not appear
> >> > correct. Quoting to the RFC:
> >> >
> >> >    "This password never appears in the connection stream, and the actual
> >> >     form of the password is up to the application. It could even change
> >> >     during the lifetime of a particular connection so long as this change
> >> >     was synchronized on both ends"
> >> >
> >> > The paragraph above clearly underlines that changing the MD5 signature of
> >> > a live TCP socket is allowed.
> >> >
> >> > I also do not understand why it would be invalid to transition an established
> >> > TCP socket from no-MD5 to MD5, or transition from MD5 to no-MD5. Quoting the
> >> > RFC:
> >> >
> >> >   "The total header size is also an issue.  The TCP header specifies
> >> >    where segment data starts with a 4-bit field which gives the total
> >> >    size of the header (including options) in 32-byte words.  This means
> >> >    that the total size of the header plus option must be less than or
> >> >    equal to 60 bytes -- this leaves 40 bytes for options."
> >> >
> >> > The paragraph above seems to be the only indication that some TCP options
> >> > cannot be combined on a given TCP socket: if the resulting header size does
> >> > not fit. However, I do not see anything in the specification preventing any
> >> > of the following use-cases on an established TCP socket:
> >> >
> >> > - Transition from no-MD5 to MD5,
> >> > - Transition from MD5 to no-MD5,
> >> > - Changing the MD5 key associated with a socket.
> >> >
> >> > As long as the resulting combination of options does not exceed the available
> >> > header space.
> >> >
> >> > Can we please fix this KASAN report in a way that does not break user-space
> >> > applications expectations about Linux' implementation of RFC2385 ?
> [...]
> >> > [1] RFC2385: https://tools.ietf.org/html/rfc2385
> >>
> >>
> >> I do not think we want to transition sockets in the middle. since
> >> packets can be re-ordered in the network.
> >>
> >> MD5 is about security (and a loose form of it), so better make sure
> >> all packets have it from the beginning of the flow.
> >>
> >> A flow with TCP TS on can not suddenly be sending packets without TCP TS.
> >>
> >> Clearly, trying to support this operation is a can of worms, I do not
> >> want to maintain such atrocity.
> >>
> >> RFC can state whatever it wants, sometimes reality forces us to have
> >> sane operations.
> >>
> >> Thanks.
> >>
> > Also the RFC states :
> >
> > "This password never appears in the connection stream, and the actual
> >    form of the password is up to the application. It could even change
> >    during the lifetime of a particular connection so long as this change
> >    was synchronized on both ends"
> >
> > It means the key can be changed, but this does not imply the option
> > can be turned on/off dynamically.
> >
>
> The change discussed previously (introduced by commit 721230326891 "tcp:
> md5: reject TCP_MD5SIG or TCP_MD5SIG_EXT on established sockets") breaks
> user-space ABI. As an example, the following BGP application uses
> setsockopt TCP_MD5SIG on a live TCP socket:
>
> https://github.com/IPInfusion/SDN-IP
>
> In addition to break user-space, it also breaks network protocol
> expectations for network equipment vendors implementing RFC2385.
> Considering that the goal of these protocols is interaction between
> different network equipment, breaking compatibility on that side
> is unexpected as well. Requiring to bring down/up the connection
> just to change the TCP MD5 password is a no-go in networks with
> high availability requirements. Changing the BGP authentication
> password must be allowed without tearing down and re-establishing
> the TCP sockets. Otherwise it doesn't scale for large network
> operators to have to individually manage each individual TCP socket
> in their network. However, based on the feedback I received, it
> would be acceptable to tear-down the TCP connections and re-establish
> them when enabling or disabling the MD5 option.
>
> Here is a list of a few network vendors along with their behavior
> with respect to TCP MD5:
>
> - Cisco: Allows for password to be changed, but within the hold-down
> timer (~180 seconds).
> - Juniper: When password is initially set on active connection it will
> reset, but after that any subsequent password changes no network
> resets.
> - Nokia: No notes on if they flap the tcp connection or not.
> - Ericsson/RedBack: Allows for 2 password (old/new) to co-exist until
> both sides are ok with new passwords.
> - Meta-Switch: Expects the password to be set before a connection is
> attempted, but no further info on whether they reset the TCP
> connection on a change.
> - Avaya: Disable the neighbor, then set password, then re-enable.
> - Zebos: Would normally allow the change when socket connected.
>
>

If you want to be able to _change_ md5 key, this is fine by me, please
send a patch.

We can not dynamically turn on MD5, this is mentioned briefly in
tcp_synack_options().

If you want to turn on MD5 on an established flow, then you must
ensure that both SACK and TS were not enabled in the 3WHS,
and then make sure nothing blows up in the stack.
