Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15824288DA
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 10:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbhJKIgO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 11 Oct 2021 04:36:14 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:50771 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234936AbhJKIgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 04:36:11 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-10-3xCUUb26MU6vXGQv3KSaTQ-1; Mon, 11 Oct 2021 09:34:09 +0100
X-MC-Unique: 3xCUUb26MU6vXGQv3KSaTQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Mon, 11 Oct 2021 09:34:06 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Mon, 11 Oct 2021 09:34:06 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Steven Rostedt' <rostedt@goodmis.org>,
        Jan Engelhardt <jengelh@inai.de>
CC:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Lai Jiangshan" <jiangshanlai@gmail.com>,
        "Joel Fernandes, Google" <joel@joelfernandes.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Jozsef Kadlecsik" <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, rcu <rcu@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam <coreteam@netfilter.org>,
        netdev <netdev@vger.kernel.org>
Subject: RE: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
Thread-Topic: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
Thread-Index: AQHXui9pmtYafoLH60aZNYgeQxdcxKvNgGPQ
Date:   Mon, 11 Oct 2021 08:34:06 +0000
Message-ID: <c30feda1b1e0457d97beafe3e3ca7ce4@AcuMS.aculab.com>
References: <20211005094728.203ecef2@gandalf.local.home>
        <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk>
        <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com>
        <826o327o-3r46-3oop-r430-8qr0ssp537o3@vanv.qr>
        <20211005144002.34008ea0@gandalf.local.home>
        <srqsppq-p657-43qq-np31-pq5pp03271r6@vanv.qr>
        <20211005154029.46f9c596@gandalf.local.home>
        <20211005163754.66552fb3@gandalf.local.home>
        <pn2qp6r2-238q-rs8n-p8n0-9s37sr614123@vanv.qr>
 <20211005172435.190c62d9@gandalf.local.home>
In-Reply-To: <20211005172435.190c62d9@gandalf.local.home>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steven Rostedt
> Sent: 05 October 2021 22:25
> 
...
> 
> Basically (one alternative I was looking at) was simply passing around a
> void pointer. Not sure how the RCU macros would handle that. But to
> completely abstract it out, I was thinking of just returning void * and
> accepting void *, but I didn't want to do that because now we just lost any
> kind of type checking done by the compiler. The tricks I was playing was to
> keep some kind of type checking.

Yes, don't use 'void *'.
Sun used it for all the pointers in their DDI/DKI - made it impossible
to ensure you were passing in the right type of 'token'.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

