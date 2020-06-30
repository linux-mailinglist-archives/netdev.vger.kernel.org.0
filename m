Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4539C20FE94
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 23:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbgF3VRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 17:17:48 -0400
Received: from mail.efficios.com ([167.114.26.124]:48592 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgF3VRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 17:17:48 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 125932C72E3;
        Tue, 30 Jun 2020 17:17:47 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id dX8LJcERVS4j; Tue, 30 Jun 2020 17:17:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id B14522C7393;
        Tue, 30 Jun 2020 17:17:46 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com B14522C7393
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1593551866;
        bh=dzOtmJ7mD/siyGoPxQC/+AbiDTyc52D1unXi3sYhHw4=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=BMWsT4ae0NFCJ7Ar9Wj/SDYypbB4SF4CqanRW+dwWOnP+GK8ukFotA8/0X3ZNkB/T
         1V95PFBjmkA5EYmVmvP3OKlTGV7mLADFG4gJ62Nm2NV4PQCGiBWaRktNCvUmZlckwu
         r7ZWl5ZhfWVO8a3kcgf9YovcOjsHZ/HYtGUAxThOmKOvsnsmtBlN5hz8RRoNR3zdEv
         MolT2QWCjHCKHUoyJkeBtPOXhn2r+G4/sT+OaxU3KE9i4psxZ02NjnPLQuBJST3H5f
         jIU1V9zvvQyWxBuezPLl8Tv38IGeQlrelEw8V7iNEUrUu2Vwtjs9kTtUP8j00T3SMb
         tuMOsYxVkRlEw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id RjPVrSqWHdX1; Tue, 30 Jun 2020 17:17:46 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 9DE582C71DC;
        Tue, 30 Jun 2020 17:17:46 -0400 (EDT)
Date:   Tue, 30 Jun 2020 17:17:46 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Message-ID: <474095696.17969.1593551866537.JavaMail.zimbra@efficios.com>
In-Reply-To: <CANn89i+b-LeaPvaaHvj0yc0mJ2qwZ0981fQHVp0+sqXYp=kdkA@mail.gmail.com>
References: <CAHk-=wjEghg5_pX_GhNP+BfcUK6CRZ+4mh3bciitm9JwXvR7aQ@mail.gmail.com> <312079189.17903.1593549293094.JavaMail.zimbra@efficios.com> <CANn89iJ+rkMrLrHrKXO-57frXNb32epB93LYLRuHX00uWc-0Uw@mail.gmail.com> <20200630.134429.1590957032456466647.davem@davemloft.net> <CANn89i+b-LeaPvaaHvj0yc0mJ2qwZ0981fQHVp0+sqXYp=kdkA@mail.gmail.com>
Subject: Re: [regression] TCP_MD5SIG on established sockets
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3945 (ZimbraWebClient - FF77 (Linux)/8.8.15_GA_3928)
Thread-Topic: TCP_MD5SIG on established sockets
Thread-Index: bT5tgAuCnz/dlB46lWW2qWJ3mIXuLQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Jun 30, 2020, at 4:56 PM, Eric Dumazet edumazet@google.com wrote:

> On Tue, Jun 30, 2020 at 1:44 PM David Miller <davem@davemloft.net> wrote:
>>
>> From: Eric Dumazet <edumazet@google.com>
>> Date: Tue, 30 Jun 2020 13:39:27 -0700
>>
>> > The (C) & (B) case are certainly doable.
>> >
>> > A) case is more complex, I have no idea of breakages of various TCP
>> > stacks if a flow got SACK
>> > at some point (in 3WHS) but suddenly becomes Reno.
>>
>> I agree that C and B are the easiest to implement without having to
>> add complicated code to handle various negotiated TCP option
>> scenerios.
>>
>> It does seem to be that some entities do A, or did I misread your
>> behavioral analysis of various implementations Mathieu?
>>
>> Thanks.
> 
> Yes, another question about Mathieu cases is do determine the behavior
> of all these stacks vs :
> SACK option
> TCP TS option.

I will ask my customer's networking team to investigate these behaviors,
which will allow me to prepare a thorough reply to the questions raised
by Eric and David. I expect to have an answer within 2-3 weeks at most.

Thank you!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
