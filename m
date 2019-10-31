Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C14D6EA8C7
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 02:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfJaB1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 21:27:33 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43435 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfJaB1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 21:27:32 -0400
Received: by mail-pl1-f194.google.com with SMTP id a18so745437plm.10
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 18:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tYFECShuL3ae70Rv5xJ58SjD1jsmc4BK9klu7aiwIDo=;
        b=gl7OM+G+3e7uwDEg8adwfyI+RCk2hNsD3VGBsBNM+Jrqwwv34aiaOdjcOKmyCXgLvd
         3PKPtyZacL8ViwNlr7ZnC01PB7I7lUAaI40o4b1AQBCK7jvz+JCmt6SvX/cHACH9Fxub
         yl76PRogrQnEPvar0o/His0cTzrWHBZvauG5UH0UA3y0J+QgyZ08+5tL9Y7A0nDbbsKP
         1wIDN+tPx6YUfSbuf51hPjJ/zRLECXUTdvxBBdaIeAGegYUuABu3UgUW3tgFR7Wqpyk2
         h1DvMebQDMHeyCmbWAuDLqt2dE9Ffx5HgL9CWeAFjwkFmcfBHbDnDjTYL7rydI7agfUr
         Wftw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tYFECShuL3ae70Rv5xJ58SjD1jsmc4BK9klu7aiwIDo=;
        b=XckD8KiYDjLjjsyK1yv8bwydsd5McQ8hOCKHP5tWqtbYyGgs0UTcCW7N/guil2OaFs
         cNHtjhHLngFN7Yq/BqTPmvtNTlCVky04RmRJWjvf88tZf03ukIysF5aYcrVMwRXV4d2X
         B9ogK/PtyLQh8XFq56AGKJN0+BJl+VvN79fqYufgWGteVla7LcrUMBQtnNTyUAgEfB3X
         O6ATQy52SJbQRsve7OrMzaF5s3337005f23I0KgFVEge3S9r4IluKhEi8PDYXR3Li77d
         p8Zh2P5BZpVv/390s1QkhUzuuuDiv+D2k6OtX4qBGLJCoYtYzuKGuNaPVOGba26KeiyW
         oFbg==
X-Gm-Message-State: APjAAAWjeLZ6sYnU3eY6gcwmFKdwypzJK2+OcXaptUxu7tDqrKk0WbnZ
        a1K8moJsBK6n+yX9Tpzfw2k=
X-Google-Smtp-Source: APXvYqxseK6qnsvonEOY9j50Cq48JZZUF++ikvRXjjE9sLMSMelXM6YXqj1vZYbyaFQ4LlXZ8rEhYg==
X-Received: by 2002:a17:902:7c07:: with SMTP id x7mr3273064pll.210.1572485251905;
        Wed, 30 Oct 2019 18:27:31 -0700 (PDT)
Received: from [192.168.88.111] (189.8.197.35.bc.googleusercontent.com. [35.197.8.189])
        by smtp.gmail.com with ESMTPSA id f189sm1050517pgc.94.2019.10.30.18.27.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2019 18:27:30 -0700 (PDT)
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
To:     Josh Hunt <johunt@akamai.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Neal Cardwell <ncardwell@google.com>
Cc:     Netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
 <CADVnQynFeJCpv4irANd8O63ck0ewUq66EDSHHRKdv-zieGZ+UA@mail.gmail.com>
 <f7a0507ce733dd722b1320622dfd1caa@codeaurora.org>
 <CADVnQy=SDgiFH57MUv5kNHSjD2Vsk+a-UD0yXQKGNGY-XLw5cw@mail.gmail.com>
 <2279a8988c3f37771dda5593b350d014@codeaurora.org>
 <CADVnQykjfjPNv6F1EtWWvBT0dZFgf1QPDdhNaCX3j3bFCkViwA@mail.gmail.com>
 <f9ae970c12616f61c6152ebe34019e2b@codeaurora.org>
 <CADVnQymqKpMh3iRfrdiAYjb+2ejKswk8vaZCY6EW4-3ppDnv_w@mail.gmail.com>
 <81ace6052228e12629f73724236ade63@codeaurora.org>
 <CADVnQymDSZb=K8R1Gv=RYDLawW9Ju1tuskkk8LZG4fm3yxyq3w@mail.gmail.com>
 <74827a046961422207515b1bb354101d@codeaurora.org>
 <827f0898-df46-0f05-980e-fffa5717641f@akamai.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <cae50d97-5d19-7b35-0e82-630f905c1bf6@gmail.com>
Date:   Wed, 30 Oct 2019 18:27:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <827f0898-df46-0f05-980e-fffa5717641f@akamai.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/30/19 2:48 PM, Josh Hunt wrote:
> On 10/30/19 11:27 AM, Subash Abhinov Kasiviswanathan wrote:
>>> Thanks. Do you mind sharing what your patch looked like, so we can
>>> understand precisely what was changed?
>>>
>>> Also, are you able to share what the workload looked like that tickled
>>> this issue? (web client? file server?...)
>>
>> Sure. This was seen only on our regression racks and the workload there
>> is a combination of FTP, browsing and other apps.
>>
>> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
>> index 4374196..9af7497 100644
>> --- a/include/linux/tcp.h
>> +++ b/include/linux/tcp.h
>> @@ -232,7 +232,8 @@ struct tcp_sock {
>>                  fastopen_connect:1, /* FASTOPEN_CONNECT sockopt */
>>                  fastopen_no_cookie:1, /* Allow send/recv SYN+data without a cookie */
>>                  is_sack_reneg:1,    /* in recovery from loss with SACK reneg? */
>> -               unused:2;
>> +               unused:1,
>> +               wqp_called:1;
>>          u8      nonagle     : 4,/* Disable Nagle algorithm? */
>>                  thin_lto    : 1,/* Use linear timeouts for thin streams */
>>                  recvmsg_inq : 1,/* Indicate # of bytes in queue upon recvmsg */
>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>> index 1a1fcb3..0c29bdd 100644
>> --- a/net/ipv4/tcp.c
>> +++ b/net/ipv4/tcp.c
>> @@ -2534,6 +2534,9 @@ void tcp_write_queue_purge(struct sock *sk)
>>          INIT_LIST_HEAD(&tcp_sk(sk)->tsorted_sent_queue);
>>          sk_mem_reclaim(sk);
>>          tcp_clear_all_retrans_hints(tcp_sk(sk));
>> +       tcp_sk(sk)->highest_sack = NULL;
>> +       tcp_sk(sk)->sacked_out = 0;
>> +       tcp_sk(sk)->wqp_called = 1;
>>          tcp_sk(sk)->packets_out = 0;
>>          inet_csk(sk)->icsk_backoff = 0;
>>   }
>>
>>
> 
> Neal
> 
> Since tcp_write_queue_purge() calls tcp_rtx_queue_purge() and we're deleting everything in the retrans queue there, doesn't it make sense to zero out all of those associated counters? Obviously clearing sacked_out is helping here, but is there a reason to keep track of lost_out, retrans_out, etc if retrans queue is now empty? Maybe calling tcp_clear_retrans() from tcp_rtx_queue_purge() ?

First, I would like to understand if we hit this problem on current upstream kernels.

Maybe a backport forgot a dependency.

tcp_write_queue_purge() calls tcp_clear_all_retrans_hints(), not tcp_clear_retrans(),
this is probably for a reason.

Brute force clearing these fields might hide a serious bug.
