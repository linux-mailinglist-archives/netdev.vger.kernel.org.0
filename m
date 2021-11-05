Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7745344642C
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 14:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbhKENdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 09:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbhKENdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 09:33:54 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF664C061714;
        Fri,  5 Nov 2021 06:31:14 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id u18so13743524wrg.5;
        Fri, 05 Nov 2021 06:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gMX/UK1c/Pgfy++V0gm8fG3W7DC1irWPzRW83EBXmbw=;
        b=fvqvyne4qHEXvk5y2bb1wutYlN7Y7Xerlg8OcVuzELMARBeA3RnfDbwYAxEOYVGB3u
         5LfSuU29k36rQfQnCln8Gk6BiA3b/tQUCyQ8o4aB/cmLAXeOHh5hwgJmBD01aKGIDe7Y
         yzn+CKCPQ8JD0Y6G5NxlCCJdh+05pHFgKve1vQ0p8zaCuHYanCF+RXWtpnyPucH4IvPP
         wonRTmy0rxwbDAZ+NQsBcRXbNqKMViJ4sH339rvKLpnwlLlzkHjU8qvsiwljlys+uain
         mhY/AhWNqDw5GlpJpzEGw4KXfh0LAd4GOL0uVBnGtW1d6Ypcsuyv9hyZQdkCz1fp9WE1
         pR2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gMX/UK1c/Pgfy++V0gm8fG3W7DC1irWPzRW83EBXmbw=;
        b=OzKj20wV/YWXs634i3B2gkUCvRPp6JLSqmjVHoA9iii3Ght6SkLKzq8tLQKMlI1hre
         frYlLMGEQNLyzGR474ewh7a6Whebs64d+vgzAJu45X6Z5DRycDKvWr1wmIQIAoNBqnKh
         E8enFMkmjvZiSxrurC6SLgCzytp3Y7tnuHXHbQsAMBarkQoTi49vmTKlnOpwwWdjRW1U
         1Mn7gqXTOsWcEoWMasvD8iuYZWUdC15r6XBvoqAQUrC4O1C2DxMQtx4+aPEBns7cMPNY
         K1Lu9OAha0fOjWfhopAQg4/QiOc+Urn27/yLPxAZ34hYxChg27LMqAzFQR0KyHtv1wTb
         X6ag==
X-Gm-Message-State: AOAM532I83y0atc+rTek0HlIoO9xKFmDnaFd8gVKwRXr6HfWVLx7MYYq
        qRWO2xWb9Pt5E+SWjXfYmeE=
X-Google-Smtp-Source: ABdhPJy+1vIrqOuy12eXJaWnfHTuWgmDg0S7rmJVgyPZFgxx7iUAU0omJLL3c94agcBzCFvpmtEXyQ==
X-Received: by 2002:a5d:4e0f:: with SMTP id p15mr33256420wrt.48.1636119073384;
        Fri, 05 Nov 2021 06:31:13 -0700 (PDT)
Received: from ?IPV6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id v191sm7698146wme.36.2021.11.05.06.31.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 06:31:12 -0700 (PDT)
Message-ID: <36dd4742-fa40-0907-7aa4-cb20a511bf42@gmail.com>
Date:   Fri, 5 Nov 2021 13:31:11 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/5] tcp/md5: Don't BUG_ON() failed kmemdup()
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org
Cc:     Andy Lutomirski <luto@amacapital.net>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org
References: <20211105014953.972946-1-dima@arista.com>
 <20211105014953.972946-2-dima@arista.com>
 <15c0469e-9433-0a8d-50f0-de6517365464@gmail.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
In-Reply-To: <15c0469e-9433-0a8d-50f0-de6517365464@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/21 02:55, Eric Dumazet wrote:
> 
> 
> On 11/4/21 6:49 PM, Dmitry Safonov wrote:
>> static_branch_unlikely(&tcp_md5_needed) is enabled by
>> tcp_alloc_md5sig_pool(), so as long as the code doesn't change
>> tcp_md5sig_pool has been already populated if this code is being
>> executed.
>>
>> In case tcptw->tw_md5_key allocaion failed - no reason to crash kernel:
>> tcp_{v4,v6}_send_ack() will send unsigned segment, the connection won't be
>> established, which is bad enough, but in OOM situation totally
>> acceptable and better than kernel crash.
>>
>> Introduce tcp_md5sig_pool_ready() helper.
>> tcp_alloc_md5sig_pool() usage is intentionally avoided here as it's
>> fast-path here and it's check for sanity rather than point of actual
>> pool allocation. That will allow to have generic slow-path allocator
>> for tcp crypto pool.
>>
>> Signed-off-by: Dmitry Safonov <dima@arista.com>
>> ---
>>  include/net/tcp.h        | 1 +
>>  net/ipv4/tcp.c           | 5 +++++
>>  net/ipv4/tcp_minisocks.c | 5 +++--
>>  3 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/net/tcp.h b/include/net/tcp.h
>> index 4da22b41bde6..3e5423a10a74 100644
>> --- a/include/net/tcp.h
>> +++ b/include/net/tcp.h
>> @@ -1672,6 +1672,7 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
>>  #endif
>>  
>>  bool tcp_alloc_md5sig_pool(void);
>> +bool tcp_md5sig_pool_ready(void);
>>  
>>  struct tcp_md5sig_pool *tcp_get_md5sig_pool(void);
>>  static inline void tcp_put_md5sig_pool(void)
>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>> index b7796b4cf0a0..c0856a6af9f5 100644
>> --- a/net/ipv4/tcp.c
>> +++ b/net/ipv4/tcp.c
>> @@ -4314,6 +4314,11 @@ bool tcp_alloc_md5sig_pool(void)
>>  }
>>  EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
>>  
>> +bool tcp_md5sig_pool_ready(void)
>> +{
>> +	return tcp_md5sig_pool_populated;
>> +}
>> +EXPORT_SYMBOL(tcp_md5sig_pool_ready);
>>  
>>  /**
>>   *	tcp_get_md5sig_pool - get md5sig_pool for this user
>> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
>> index cf913a66df17..c99cdb529902 100644
>> --- a/net/ipv4/tcp_minisocks.c
>> +++ b/net/ipv4/tcp_minisocks.c
>> @@ -293,11 +293,12 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
>>  			tcptw->tw_md5_key = NULL;
>>  			if (static_branch_unlikely(&tcp_md5_needed)) {
>>  				struct tcp_md5sig_key *key;
>> +				bool err = WARN_ON(!tcp_md5sig_pool_ready());
>>  
>>  				key = tp->af_specific->md5_lookup(sk, sk);
>> -				if (key) {
>> +				if (key && !err) {
>>  					tcptw->tw_md5_key = kmemdup(key, sizeof(*key), GFP_ATOMIC);
>> -					BUG_ON(tcptw->tw_md5_key && !tcp_alloc_md5sig_pool());
>> +					WARN_ON_ONCE(tcptw->tw_md5_key == NULL);
>>  				}
>>  			}
>>  		} while (0);
>>
> 
> Hmmm.... how this BUG_ON() could trigger exactly ?
> 
> tcp_md5_needed can only be enabled after __tcp_alloc_md5sig_pool has succeeded.

Yeah, I've misread this part as
: BUG_ON(!tcptw->tw_md5_key || !tcp_alloc_md5sig_pool());

Still, there is an issue with checking tcp_alloc_md5sig_pool():
currently the condition is never true, but if it ever becomes true, the
tcp_alloc_md5sig_pool() call may cause tcp_time_wait() to sleep with bh
disabled (i.e. __tcp_close()). So, if this condition ever becomes true,
it will cause an issue checking it here.

I'll squash this with patch 3 and send when the merge window closes.

Thanks,
          Dmitry
