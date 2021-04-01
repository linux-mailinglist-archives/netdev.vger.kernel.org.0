Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461A4350CD2
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 04:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbhDAC4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 22:56:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhDAC4V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 22:56:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD1AD600EF;
        Thu,  1 Apr 2021 02:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617245781;
        bh=w7NVPPGTTh0gPs1DoBHzvxj/J6sTyov5mzsx9iIJ54g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y9LqF7PTplzcK0+UOiPMiWusr8MxAR1pAvt3HH4leJ96Vsxzwb/5GKvHOUWFviKhw
         tx0as+f9gqvs9db+BdKxKVBKaxhPSzBfVXTg3aBwf7S/bRRF8bv4qRiyoNi5Q3XJgT
         6+HkeLsUgXrFLNzKNRq1wCUBi69htaYWHRpt1hQAYcX9f7T86PJOU8SAGx14Niiarp
         P8bTodFZ0B0EJk40KGsm6JEuTBE2/ZR1vkoEJf0ck1ugXaU4M/IrHuxMvDgXHZFKey
         iBWrvCBcN9eFxekq99+fsI+oToiVJqLiL/MZBrgZd9J0c+/O0Y3GpypfCWGHfB5X15
         8Vc0q95KOjwqg==
Date:   Wed, 31 Mar 2021 22:56:20 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        liuyacan <yacanliu@163.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 10/38] net: correct sk_acceptq_is_full()
Message-ID: <YGU2VD+IzR6rVyK0@sashalap>
References: <20210329222133.2382393-1-sashal@kernel.org>
 <20210329222133.2382393-10-sashal@kernel.org>
 <e08f40b5-7f5b-0714-dfab-f24ed7f348fc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e08f40b5-7f5b-0714-dfab-f24ed7f348fc@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 06:17:27PM +0200, Eric Dumazet wrote:
>
>
>On 3/30/21 12:21 AM, Sasha Levin wrote:
>> From: liuyacan <yacanliu@163.com>
>>
>> [ Upstream commit f211ac154577ec9ccf07c15f18a6abf0d9bdb4ab ]
>>
>> The "backlog" argument in listen() specifies
>> the maximom length of pending connections,
>> so the accept queue should be considered full
>> if there are exactly "backlog" elements.
>>
>> Signed-off-by: liuyacan <yacanliu@163.com>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  include/net/sock.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/net/sock.h b/include/net/sock.h
>> index 129d200bccb4..a95f38a4b8c6 100644
>> --- a/include/net/sock.h
>> +++ b/include/net/sock.h
>> @@ -936,7 +936,7 @@ static inline void sk_acceptq_added(struct sock *sk)
>>
>>  static inline bool sk_acceptq_is_full(const struct sock *sk)
>>  {
>> -	return READ_ONCE(sk->sk_ack_backlog) > READ_ONCE(sk->sk_max_ack_backlog);
>> +	return READ_ONCE(sk->sk_ack_backlog) >= READ_ONCE(sk->sk_max_ack_backlog);
>>  }
>>
>>  /*
>>
>
>
>????
>
>I have not seen this patch going in our trees.
>
>First, there was no Fixes: tag, so this is quite unfortunate.
>
>Second, we already had such wrong patches in the past.
>
>Please look at commits
>64a146513f8f12ba204b7bf5cb7e9505594ead42 [NET]: Revert incorrect accept queue backlog changes.
>8488df894d05d6fa41c2bd298c335f944bb0e401 [NET]: Fix bugs in "Whether sock accept queue is full" checking
>
>Please revert  this patch, thanks !

Dropped, thanks for letting me know!

-- 
Thanks,
Sasha
