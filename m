Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDF41171E5
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 17:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfLIQgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 11:36:10 -0500
Received: from mail.toke.dk ([45.145.95.4]:53939 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbfLIQgK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 11:36:10 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1575909367; bh=r+Rx8MLw8sxzvfU95qxOzmqsemswIgeX3vuPUrpAlDE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=e5exDt5JZXoRscX/Rx34Edzikn3YnegkCC5Uaqo7uke5F7+TZpBPcEHIyN3cy9sq+
         e8nRhGazyNriDea67azmUN8Q4qcFK2NRwwAFxBCbs0aVyA6MjjaDTn6jJO8nA7fs9M
         8VojCeheZGq89h8n7N0EvjYcJmfKEp8bsOtfW5T4KfoK51dFxFemqePjAZme8V09vu
         Cpc3qROAoBpY45C6j8Q2cSpJyRwe2mOJ+WmV8IBAES5UiRuMB++95n+tZtYmJu6CJ3
         MGf86ioj7WpV/cmahvDe++L/oqZNytJUESkhFQWawgsava9ZR+DgP4dCUiljRDM6U7
         LkBglpcaMvAUw==
To:     David Ahern <dsahern@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: organization of wireguard linux kernel repos moving forward
In-Reply-To: <8a5bdf0f-c7f8-4667-ecba-ecb671bea2e5@gmail.com>
References: <CAHmME9p1-5hQXv5QNqqHT+OBjn-vf16uAU2HtYcmwKMtLhnsTA@mail.gmail.com> <87d0cxlldu.fsf@toke.dk> <CAHmME9oUfp_1udMFNMpeXPeoa7aacdNp9Q31eKvoTBpu+G5rpQ@mail.gmail.com> <8a5bdf0f-c7f8-4667-ecba-ecb671bea2e5@gmail.com>
Date:   Mon, 09 Dec 2019 17:36:07 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <875zipihhk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 12/9/19 5:49 AM, Jason A. Donenfeld wrote:
>> I'd definitely be interested in this. Back in 2015, that was the plan.
>> Then it took a long time to get to where we are now, and since then
>> wg(8) has really evolved into its own useful thing. The easiest thing
>> would be to move wg(8) wholesale into iproute2 like you suggested;
>> that'd allow people to continue using their infrastructure and whatnot
>> they've used for a long time now. A more nuanced approach would be
>> coming up with a _parallel_ iproute2 tool with mostly the same syntax
>> as wg(8) but as a subcommand of ip(8). Originally the latter appealed
>> to me, but at this point maybe the former is better after all. I
>> suppose something to consider is that wg(8) is actually a
>> cross-platform tool now, with a unified syntax across a whole bunch of
>> operating systems. But it's also just boring C.
>
> If wg is to move into iproute2, it needs to align with the other
> commands and leverage the generic facilities where possible. ie., any
> functionality that overlaps with existing iproute2 code to be converted
> to use iproute2 code.

Thought that might be the case :)

That means a re-implementation, then. In which case the question becomes
whether it's better to do it as an 'ip' subcommand (or even just new
parameters to 'ip link'), or a new top-level utility striving for
compatibility with 'wg'. But that's mostly a UI issue...

-Toke
