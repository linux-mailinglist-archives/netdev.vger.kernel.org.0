Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD079312680
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 18:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhBGRyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 12:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhBGRyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 12:54:24 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D16C06174A
        for <netdev@vger.kernel.org>; Sun,  7 Feb 2021 09:53:44 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id s107so12037829otb.8
        for <netdev@vger.kernel.org>; Sun, 07 Feb 2021 09:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mEVNB6jnXZbsPPU4+9jkUDLMR/RAKX3G2sUl39TydP8=;
        b=tjGEi1nrVa57lXbj0FzkPeVEkMQuflv+u3mlTm/TW/cLbwZS8y1cjNCIHMnuJFdi8u
         +jWFw/rC9fcZvI4qwHwNsCuLcGpOoFX7zr4u14SJlnc2IAWUOpdqJDGAa8hdtvruDen8
         ND8U+Po+BEC3N4XIfyAtZg+WxkdhDjb498BWe0Gn7/VtPZvRViuZfzFSQ2Emai5K2eXi
         ldhVxUHQgMnKmUlrptGplQuHM12x4Qtl/kVwtD0GKv3qKHuTJjYGIV34J0cjnUEevAlM
         2uOx1Y9e/iBWBUuxUKoK9hqsOaGTm0A7q1bfduMpIwWqfi8HrRbfFaROXAuMcDHPAGV1
         iJJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mEVNB6jnXZbsPPU4+9jkUDLMR/RAKX3G2sUl39TydP8=;
        b=kv6XVFM6BYnPeY3M2urZ5spVJ2KbgQ0mo025m4CCb3lhcKt9juzFj9PxxpKqkXVM7w
         qP/RPC9XE4f0MNq6CxUAjGMmHnA+Tg80LISaPErATUE4Q1qK4gncPSctHHRpfOKARsMo
         xxpW7bYW+f2nzlL4Dnj9s12Zs8kx4FNw3w9jceSPg0wtTXezl2GlS0pL5XqvDESxNyEj
         p70XDHKxpdmhKnHC/HeIN7mUoxQ30DS7fe+3CDr2yiNf1ikz7uohiVl0pMwIb9NDm9Rd
         4Up+xc37QHt9B+5TKJSqX9DuJ3fYYcH8LAtIy4dcbm9Y/tZiC5wM6NVCdC4faemDn16V
         +4bw==
X-Gm-Message-State: AOAM531GjaAyy83AlZkTatyXmQ+DL+twt+g8WqrDYkqyOeVq9rJJksBk
        UTtCHGXM4ZzXnzK6PYCZxIc=
X-Google-Smtp-Source: ABdhPJx05HeMi+mwVy+Lbh2YaqSEeSEw5hH73Zhqki1DFtRrJgkm7aI9xh/v8MxDqKqhzV7fyw4lsQ==
X-Received: by 2002:a9d:4d0a:: with SMTP id n10mr9812008otf.73.1612720423584;
        Sun, 07 Feb 2021 09:53:43 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id p23sm3273249otk.51.2021.02.07.09.53.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Feb 2021 09:53:43 -0800 (PST)
Subject: Re: [net-next v2] tcp: Explicitly mark reserved field in
 tcp_zerocopy_receive args.
From:   David Ahern <dsahern@gmail.com>
To:     Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210206203648.609650-1-arjunroy.kdev@gmail.com>
 <c81f79ee-e8d0-2f83-6926-c370e9540730@gmail.com>
Message-ID: <78c74404-755a-66c8-1ebd-256b3dfca76c@gmail.com>
Date:   Sun, 7 Feb 2021 10:53:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <c81f79ee-e8d0-2f83-6926-c370e9540730@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/21 10:49 AM, David Ahern wrote:
> On 2/6/21 1:36 PM, Arjun Roy wrote:
>> From: Arjun Roy <arjunroy@google.com>
>>
>> Explicitly define reserved field and require it to be 0-valued.
>>
>> Fixes: 7eeba1706eba ("tcp: Add receive timestamp support for receive zerocopy.")
>> Signed-off-by: Arjun Roy <arjunroy@google.com>
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
>> Suggested-by: David Ahern <dsahern@gmail.com>
>> Suggested-by: Leon Romanovsky <leon@kernel.org>
>> Suggested-by: Jakub Kicinski <kuba@kernel.org>
>> ---
>>  include/uapi/linux/tcp.h | 2 +-
>>  net/ipv4/tcp.c           | 2 ++
>>  2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
>> index 42fc5a640df4..8fc09e8638b3 100644
>> --- a/include/uapi/linux/tcp.h
>> +++ b/include/uapi/linux/tcp.h
>> @@ -357,6 +357,6 @@ struct tcp_zerocopy_receive {
>>  	__u64 msg_control; /* ancillary data */
>>  	__u64 msg_controllen;
>>  	__u32 msg_flags;
>> -	/* __u32 hole;  Next we must add >1 u32 otherwise length checks fail. */
>> +	__u32 reserved; /* set to 0 for now */
>>  };
>>  #endif /* _UAPI_LINUX_TCP_H */
>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>> index e1a17c6b473c..c8469c579ed8 100644
>> --- a/net/ipv4/tcp.c
>> +++ b/net/ipv4/tcp.c
>> @@ -4159,6 +4159,8 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
>>  		}
>>  		if (copy_from_user(&zc, optval, len))
>>  			return -EFAULT;
>> +		if (zc.reserved)
>> +			return -EINVAL;
>>  		lock_sock(sk);
>>  		err = tcp_zerocopy_receive(sk, &zc, &tss);
>>  		release_sock(sk);
>>
> 
> 
> The 'switch (len)' statement needs to be updated now that 'len' is not
> going to end on the 'msg_flags' boundary? But then, how did that work
> before if there was 4 byte padding?
> 
> Maybe I am missing something here. You currently have:
> 
> 	switch (len) {
> 	case offsetofend(struct tcp_zerocopy_receive, msg_flags):
> 

Ah, I missed the lines before it:

                if (len >= offsetofend(struct tcp_zerocopy_receive,
msg_flags))
                        goto zerocopy_rcv_cmsg;


Also, I see a check on zc.msg_flags for a specific flag option being
set. What about other invalid bits in msg_flags? I do not see a check like:

#define TCP_VALID_ZC_MSG_FLAGS   (TCP_CMSG_TS)

	if (zc.msg_flags & ~(TCP_VALID_ZC_MSG_FLAGS))
		return -EINVAL;
