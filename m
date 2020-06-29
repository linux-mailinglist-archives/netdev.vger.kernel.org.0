Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A471F20D914
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387933AbgF2ToB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:44:01 -0400
Received: from mail.efficios.com ([167.114.26.124]:33194 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732797AbgF2Tn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:43:58 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 57E8026BE90;
        Mon, 29 Jun 2020 15:43:57 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id jKS2OsRBiPF4; Mon, 29 Jun 2020 15:43:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id E456326BE04;
        Mon, 29 Jun 2020 15:43:56 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com E456326BE04
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1593459836;
        bh=iP3PjzJ6XSqU6iD5jcFMqznuwbwfOTCeMrtF+SzoIxA=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=Zb+p9V5XcwPNNTTPWdcilNsn2aGU2lz7a7/PgtBKt1e2OjYnYtasalPhFQHv4ygdd
         RkRpqOQNC5cXdmRmS+PZ+1R70E4ZmDs7Kr6tVw3oCykO7aRMtPklSP9nCYfccmzCjG
         F2OOszRVIlpNIL5uFP2fU24d5we1PKVV4hiBKQULZhBQqUY9y7EnArJF+Blx+eNaVf
         ooV5Bm2ZGojLC+Ntbfp1RjN3+t6syLAin22SMllmW5brKuATpfFUqnwjhk2EWNmQGm
         l5o5b5rOJXwzFqhFaW60/Vp7e4OvpH0Iw4TnlBzKuxIKzi+iibJankV9mFCenWMIwS
         tekm46Nbemxyg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id QlU3a6Iszu31; Mon, 29 Jun 2020 15:43:56 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id D147626B9F3;
        Mon, 29 Jun 2020 15:43:56 -0400 (EDT)
Date:   Mon, 29 Jun 2020 15:43:56 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Eric Dumazet <edumazet@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Message-ID: <1132973300.15954.1593459836756.JavaMail.zimbra@efficios.com>
In-Reply-To: <CANn89iL26OMWWAi18PqoQK4VBfFvRvxBJUioqXDk=8ZbKq_Efg@mail.gmail.com>
References: <341326348.19635.1589398715534.JavaMail.zimbra@efficios.com> <CANn89i+GH2ukLZUcWYGquvKg66L9Vbto0FxyEt3pOJyebNxqBg@mail.gmail.com> <CANn89iL26OMWWAi18PqoQK4VBfFvRvxBJUioqXDk=8ZbKq_Efg@mail.gmail.com>
Subject: Re: [regression] TCP_MD5SIG on established sockets
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3945 (ZimbraWebClient - FF77 (Linux)/8.8.15_GA_3928)
Thread-Topic: TCP_MD5SIG on established sockets
Thread-Index: 0Jvbhp6DCumjwNDk8z7Y2feQgYejnA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On May 13, 2020, at 3:56 PM, Eric Dumazet edumazet@google.com wrote:

> On Wed, May 13, 2020 at 12:49 PM Eric Dumazet <edumazet@google.com> wrote:
>>
>>
>> On Wed, May 13, 2020 at 12:38 PM Mathieu Desnoyers
>> <mathieu.desnoyers@efficios.com> wrote:
>> >
>> > Hi,
>> >
>> > I am reporting a regression with respect to use of TCP_MD5SIG/TCP_MD5SIG_EXT
>> > on established sockets. It is observed by a customer.
>> >
>> > This issue is introduced by this commit:
>> >
>> > commit 721230326891 "tcp: md5: reject TCP_MD5SIG or TCP_MD5SIG_EXT on
>> > established sockets"
>> >
>> > The intent of this commit appears to be to fix a use of uninitialized value in
>> > tcp_parse_options(). The change introduced by this commit is to disallow setting
>> > the TCP_MD5SIG{,_EXT} socket options on an established socket.
>> >
>> > The justification for this change appears in the commit message:
>> >
>> >    "I believe this was caused by a TCP_MD5SIG being set on live
>> >     flow.
>> >
>> >     This is highly unexpected, since TCP option space is limited.
>> >
>> >     For instance, presence of TCP MD5 option automatically disables
>> >     TCP TimeStamp option at SYN/SYNACK time, which we can not do
>> >     once flow has been established.
>> >
>> >     Really, adding/deleting an MD5 key only makes sense on sockets
>> >     in CLOSE or LISTEN state."
>> >
>> > However, reading through RFC2385 [1], this justification does not appear
>> > correct. Quoting to the RFC:
>> >
>> >    "This password never appears in the connection stream, and the actual
>> >     form of the password is up to the application. It could even change
>> >     during the lifetime of a particular connection so long as this change
>> >     was synchronized on both ends"
>> >
>> > The paragraph above clearly underlines that changing the MD5 signature of
>> > a live TCP socket is allowed.
>> >
>> > I also do not understand why it would be invalid to transition an established
>> > TCP socket from no-MD5 to MD5, or transition from MD5 to no-MD5. Quoting the
>> > RFC:
>> >
>> >   "The total header size is also an issue.  The TCP header specifies
>> >    where segment data starts with a 4-bit field which gives the total
>> >    size of the header (including options) in 32-byte words.  This means
>> >    that the total size of the header plus option must be less than or
>> >    equal to 60 bytes -- this leaves 40 bytes for options."
>> >
>> > The paragraph above seems to be the only indication that some TCP options
>> > cannot be combined on a given TCP socket: if the resulting header size does
>> > not fit. However, I do not see anything in the specification preventing any
>> > of the following use-cases on an established TCP socket:
>> >
>> > - Transition from no-MD5 to MD5,
>> > - Transition from MD5 to no-MD5,
>> > - Changing the MD5 key associated with a socket.
>> >
>> > As long as the resulting combination of options does not exceed the available
>> > header space.
>> >
>> > Can we please fix this KASAN report in a way that does not break user-space
>> > applications expectations about Linux' implementation of RFC2385 ?
[...]
>> > [1] RFC2385: https://tools.ietf.org/html/rfc2385
>>
>>
>> I do not think we want to transition sockets in the middle. since
>> packets can be re-ordered in the network.
>>
>> MD5 is about security (and a loose form of it), so better make sure
>> all packets have it from the beginning of the flow.
>>
>> A flow with TCP TS on can not suddenly be sending packets without TCP TS.
>>
>> Clearly, trying to support this operation is a can of worms, I do not
>> want to maintain such atrocity.
>>
>> RFC can state whatever it wants, sometimes reality forces us to have
>> sane operations.
>>
>> Thanks.
>>
> Also the RFC states :
> 
> "This password never appears in the connection stream, and the actual
>    form of the password is up to the application. It could even change
>    during the lifetime of a particular connection so long as this change
>    was synchronized on both ends"
> 
> It means the key can be changed, but this does not imply the option
> can be turned on/off dynamically.
> 

The change discussed previously (introduced by commit 721230326891 "tcp:
md5: reject TCP_MD5SIG or TCP_MD5SIG_EXT on established sockets") breaks
user-space ABI. As an example, the following BGP application uses
setsockopt TCP_MD5SIG on a live TCP socket:

https://github.com/IPInfusion/SDN-IP

In addition to break user-space, it also breaks network protocol
expectations for network equipment vendors implementing RFC2385.
Considering that the goal of these protocols is interaction between
different network equipment, breaking compatibility on that side
is unexpected as well. Requiring to bring down/up the connection
just to change the TCP MD5 password is a no-go in networks with
high availability requirements. Changing the BGP authentication
password must be allowed without tearing down and re-establishing
the TCP sockets. Otherwise it doesn't scale for large network
operators to have to individually manage each individual TCP socket
in their network. However, based on the feedback I received, it
would be acceptable to tear-down the TCP connections and re-establish
them when enabling or disabling the MD5 option.

Here is a list of a few network vendors along with their behavior
with respect to TCP MD5:

- Cisco: Allows for password to be changed, but within the hold-down
timer (~180 seconds).
- Juniper: When password is initially set on active connection it will
reset, but after that any subsequent password changes no network
resets.
- Nokia: No notes on if they flap the tcp connection or not.
- Ericsson/RedBack: Allows for 2 password (old/new) to co-exist until
both sides are ok with new passwords.
- Meta-Switch: Expects the password to be set before a connection is
attempted, but no further info on whether they reset the TCP
connection on a change.
- Avaya: Disable the neighbor, then set password, then re-enable.
- Zebos: Would normally allow the change when socket connected.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
