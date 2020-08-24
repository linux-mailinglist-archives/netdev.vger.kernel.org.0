Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725D724F12C
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 04:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgHXCdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 22:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgHXCdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 22:33:53 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCAAC061573
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 19:33:52 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id a65so6114048otc.8
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 19:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6R6P/NA4ILLqA/tRejRRnZIRe7AE0kNOKk6gAhNpSLU=;
        b=Phx4AZoidyy+jcfuzZgiOzJlbMW8XxSzg10zgnjxBfXm31UcippoPBx2khctg1Acwx
         PsdGy0RBFzR1yEy5U7K/nc9sAQG7TfgRYjCWc9M/6dMPHodUI17WC4rpP2/5qyPwNyC4
         nnbK9yFY42bfULAX5sKT8AQ58sKPEqh1QDhqvrI8B3xhdXvhg75pBnXN6CKXqHk5vUMg
         kkebw4gR7FoCiirI2+E0S+siovZ85BcHnR0FMPJS6sUaMFTxvUqns743ePxCH98Gk3rO
         cxb5xlJQe1UejyLal04qan+3YR0e2r78MhBoCwb+bEDVPBoxLosBkudEWt35UzAG2fjo
         mOMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6R6P/NA4ILLqA/tRejRRnZIRe7AE0kNOKk6gAhNpSLU=;
        b=pP5Hu7zreMOZbJDS7g/a13qnupqkDIioaKoci0ofdfDTT6J13uUDuW3Qc5bLiGBcmV
         tfqfDHn/3ojgP5qfBJKI/qm7egqimQCbX09DJlPyohhTc+CySlpdhBZ+fONXAaSHYcea
         zxsGuE+mf+5JN4sATJSUawCLUhUEzar8BexA5W7xWTKlMKWpJbAju1JYAY06mumIthIW
         xo9TTKV+Ek9jCzMuGvwnU07BgavTUNPX+OPn8Gyls1/UajDXyak0UxrE9ccWmMJG1yoa
         N358vN/tIsl+mIp/kTikS2/7VaBmxbi8M0IeBOrBZ8BYkxCtQLgaWJmKKwwR/VMADWNO
         6GGg==
X-Gm-Message-State: AOAM532zZxmV1EWXNmTH9sQ7xNUiAKohQFzoMKIbUX36OltbU4SKwC14
        bT/hmy1XaxaVZCjgkYmprzjuQUvy0a0UGg==
X-Google-Smtp-Source: ABdhPJwLjTpExKQ0ETpky5bVwa9gsFMoStXg8Gic12CjwnRJUOZG2UJGl/xTWGZUEk+fQlNWYzpkRw==
X-Received: by 2002:a9d:7458:: with SMTP id p24mr2134142otk.372.1598236432074;
        Sun, 23 Aug 2020 19:33:52 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:39b0:ac18:30c6:b094])
        by smtp.googlemail.com with ESMTPSA id f11sm2045250oom.38.2020.08.23.19.33.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Aug 2020 19:33:51 -0700 (PDT)
Subject: Re: [PATCH] ipv4: fix the problem of ping failure in some cases
To:     guodeqing <geffrey.guo@huawei.com>, davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org
References: <1598082397-115790-1-git-send-email-geffrey.guo@huawei.com>
 <0b7e931b-f159-4f53-1b9b-5bf84a072712@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <63e26f77-ccf0-4c07-8eaf-e571dcf2204f@gmail.com>
Date:   Sun, 23 Aug 2020 20:33:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <0b7e931b-f159-4f53-1b9b-5bf84a072712@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/23/20 8:27 PM, David Ahern wrote:
> On 8/22/20 1:46 AM, guodeqing wrote:
>> ie.,
>> $ ifconfig eth0 9.9.9.9 netmask 255.255.255.0
>>
>> $ ping -I lo 9.9.9.9

If that ever worked it was wrong; the address is scoped to eth0, not lo.

>> ping: Warning: source address might be selected on device other than lo.
>> PING 9.9.9.9 (9.9.9.9) from 9.9.9.9 lo: 56(84) bytes of data.
>>
>> 4 packets transmitted, 0 received, 100% packet loss, time 3068ms
>>
>> This is because the return value of __raw_v4_lookup in raw_v4_input
>> is null, the packets cannot be sent to the ping application.
>> The reason of the __raw_v4_lookup failure is that sk_bound_dev_if and
>> dif/sdif are not equal in raw_sk_bound_dev_eq.
>>
>> Here I add a check of whether the sk_bound_dev_if is LOOPBACK_IFINDEX
>> to solve this problem.
>>
>> Fixes: 19e4e768064a8 ("ipv4: Fix raw socket lookup for local traffic")
>> Signed-off-by: guodeqing <geffrey.guo@huawei.com>
>> ---
>>  include/net/inet_sock.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
>> index a3702d1..7707b1d 100644
>> --- a/include/net/inet_sock.h
>> +++ b/include/net/inet_sock.h
>> @@ -144,7 +144,7 @@ static inline bool inet_bound_dev_eq(bool l3mdev_accept, int bound_dev_if,
>>  {
>>  	if (!bound_dev_if)
>>  		return !sdif || l3mdev_accept;
>> -	return bound_dev_if == dif || bound_dev_if == sdif;
>> +	return bound_dev_if == dif || bound_dev_if == sdif || bound_dev_if == LOOPBACK_IFINDEX;
>>  }
>>  
>>  struct inet_cork {
>>
> 
> this is used by more than just raw socket lookups.
> 

And assuming it should work, this is definitely the wrong fix.
