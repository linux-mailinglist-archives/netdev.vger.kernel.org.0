Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0278A21010A
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 02:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgGAAkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 20:40:07 -0400
Received: from mail.efficios.com ([167.114.26.124]:40112 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgGAAkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 20:40:07 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id F16642C8E06;
        Tue, 30 Jun 2020 20:40:05 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 9Xyz3YZvm-tH; Tue, 30 Jun 2020 20:40:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id AAD9E2C8D0A;
        Tue, 30 Jun 2020 20:40:05 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com AAD9E2C8D0A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1593564005;
        bh=DuOAh+hws9bHhw4qlA4wWSCnW8HLlzyyeGBtlmX8tMo=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=Km6jedPvP+qVTuh+lwtyghJpJko6Crrf5bFe76At74YGwJ9zmG5bjyxRMzSAmpLmS
         t747a75oipfrwfNJyqmGaYUJoVpSGiSMfiXDzYW65Ii2r5fw9XYHH/Sqgok2GAHK83
         F8quSi8OLo3tqvVcYp5e30AxLysS/ZaI+rg1nsWahx7mgovRoG7pAZJP4oaeokcT8H
         3/vIXlYkfgt+7ErTvn5oEzGtV2XZ8vx/r02jGPBJQ0k8rWg7e7JTCs1TMN9VpERoff
         47MUBSNOboM42U2s/9SX5J3LNCuWwTAZph+ga+x8yIe7fyi8CIMhkSMvEvcR6VdUkb
         pT1jxqG1IsjuA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id DEDeJ_mqywZM; Tue, 30 Jun 2020 20:40:05 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 9C8E52C8AD1;
        Tue, 30 Jun 2020 20:40:05 -0400 (EDT)
Date:   Tue, 30 Jun 2020 20:40:05 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <240687586.18247.1593564005555.JavaMail.zimbra@efficios.com>
In-Reply-To: <CANn89iLvSSLRzRr0vPDNBfe_ukGecQZp4AN4ZODYjpebq643NQ@mail.gmail.com>
References: <20200630234101.3259179-1-edumazet@google.com> <1359584061.18162.1593560822147.JavaMail.zimbra@efficios.com> <CANn89iKHBkTbT9fZ3qbfZKE25MuS=av+frnRerGvP+_gUHPSAA@mail.gmail.com> <731827688.18225.1593563240917.JavaMail.zimbra@efficios.com> <CANn89iLvSSLRzRr0vPDNBfe_ukGecQZp4AN4ZODYjpebq643NQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: md5: add missing memory barriers in
 tcp_md5_do_add()/tcp_md5_hash_key()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3945 (ZimbraWebClient - FF77 (Linux)/8.8.15_GA_3928)
Thread-Topic: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()
Thread-Index: S1l+XrHLEp3pqrM5TvvpGiM3/H3Hhw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Jun 30, 2020, at 8:34 PM, Eric Dumazet edumazet@google.com wrote:

> On Tue, Jun 30, 2020 at 5:27 PM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>>
>> ----- On Jun 30, 2020, at 7:50 PM, Eric Dumazet edumazet@google.com wrote:
>>
>> > On Tue, Jun 30, 2020 at 4:47 PM Mathieu Desnoyers
>> > <mathieu.desnoyers@efficios.com> wrote:
>> >>
>> >> ----- On Jun 30, 2020, at 7:41 PM, Eric Dumazet edumazet@google.com wrote:
>> >>
>> >> > MD5 keys are read with RCU protection, and tcp_md5_do_add()
>> >> > might update in-place a prior key.
>> >> >
>> >> > Normally, typical RCU updates would allocate a new piece
>> >> > of memory. In this case only key->key and key->keylen might
>> >> > be updated, and we do not care if an incoming packet could
>> >> > see the old key, the new one, or some intermediate value,
>> >> > since changing the key on a live flow is known to be problematic
>> >> > anyway.
>> >>
>> >> What makes it acceptable to observe an intermediate bogus key during the
>> >> transition ?
>> >
>> > If you change a key while packets are in flight, the result is that :
>> >
>> > 1) Either your packet has the correct key and is handled
>> >
>> > 2) Or the key do not match, packet is dropped.
>> >
>> > Sender will retransmit eventually.
>>
>> This train of thoughts seem to apply to incoming traffic, what about outgoing ?
> 
> 
> Outgoing path is protected by the socket lock.
> 
> You can not change the TCP MD5 key while xmit is in progress.

Allright, this is the part I missed, thanks!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
