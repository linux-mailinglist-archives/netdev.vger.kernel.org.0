Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1144A10AA34
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 06:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfK0Fa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 00:30:56 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43003 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfK0Faz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 00:30:55 -0500
Received: by mail-pl1-f194.google.com with SMTP id j12so9213983plt.9
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 21:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Pry8sHm18iaYdh9nTkly6gPbwzxBlw5F5m4I1EHWKRU=;
        b=azq3zsH/v16fkFWqywekiGZQVyTPhxqn0ji0wS9pYr6rjaOA9g7I0LK/qflA6Wtlog
         ugRHBMi/ZmKEXU5uHsrfJsGEb3a+jgVTZyKElCpvCTJdO4d2nDnj7R7grUFRaUb8Bqxv
         z/kNLHGzuSeSu717ZAT5xY+REBL+ulvYbwdVIiAygdO1WOhTQ9dA/Oya3XfFqhS7kgb7
         rNnNTdk65+2/5P/zZdrRCF2V7zbwChlw/8P1sTuCO6BBtlMkAHtBEYaQCX/O9GbIXdxj
         9aHs3FOFKT7AzA7bD57+1hebT5M8oz258t/gwisl4UYqJXnpLen4xRBsoIyie6zZBV0o
         oMIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pry8sHm18iaYdh9nTkly6gPbwzxBlw5F5m4I1EHWKRU=;
        b=UP2hoYC0ALeT4G3hcL0ob51Q56PFpdhUx5LWpCjQbIVLf+agVJcqiO9o+hQ8OWKGJq
         cHlDMlGLKmKdHK2xk/dtKGI+T1wwIkK9i6oVQommlxdxDlRFNF2nZOgOIO7zeiuUFZPr
         zV12mo1UDuzZXjkzfe5gXZ4txNe6V3Ku2sZd8bu2umlgew0JvypwY2udxzdMAteC3iYv
         hm/54Z3R6M853kLAy9Lgj4IHSVLBTiGZ3/8kxc9F+yUy91xOIoNmfFwpw14uf515a66t
         HDkCS5bqGdWcg2SQ4fuydGu9IXXoYULvHWNaM5yq95sBe8NKRANQWlPPinQ4d/AtuxxK
         WeZQ==
X-Gm-Message-State: APjAAAVJNBUDgXgzypF9D7mV39/D4bG55l7t73oXbfXHgxCckehqLuGg
        iwiY/Uh0PojOcBlFAXABmZCPo37R
X-Google-Smtp-Source: APXvYqzB+TPRFxzONVsoR8GOiaeLOxt/7KYfR1WaDaQVQpzACRq4OqxE5oC3vldyBaH8/mNITAHE0Q==
X-Received: by 2002:a17:90b:3108:: with SMTP id gc8mr3589040pjb.54.1574832655002;
        Tue, 26 Nov 2019 21:30:55 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id k15sm2254083pfg.37.2019.11.26.21.30.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2019 21:30:53 -0800 (PST)
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Josh Hunt <johunt@akamai.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Neal Cardwell <ncardwell@google.com>
Cc:     Netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>
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
 <cae50d97-5d19-7b35-0e82-630f905c1bf6@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5a267a9d-2bf5-4978-b71d-0c8e71a64807@gmail.com>
Date:   Tue, 26 Nov 2019 21:30:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <cae50d97-5d19-7b35-0e82-630f905c1bf6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/30/19 6:27 PM, Eric Dumazet wrote:
> 
> 
> On 10/30/19 2:48 PM, Josh Hunt wrote:
>> On 10/30/19 11:27 AM, Subash Abhinov Kasiviswanathan wrote:
>>>> Thanks. Do you mind sharing what your patch looked like, so we can
>>>> understand precisely what was changed?
>>>>
>>>> Also, are you able to share what the workload looked like that tickled
>>>> this issue? (web client? file server?...)
>>>
>>> Sure. This was seen only on our regression racks and the workload there
>>> is a combination of FTP, browsing and other apps.
>>>
>>> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
>>> index 4374196..9af7497 100644
>>> --- a/include/linux/tcp.h
>>> +++ b/include/linux/tcp.h
>>> @@ -232,7 +232,8 @@ struct tcp_sock {
>>>                  fastopen_connect:1, /* FASTOPEN_CONNECT sockopt */
>>>                  fastopen_no_cookie:1, /* Allow send/recv SYN+data without a cookie */
>>>                  is_sack_reneg:1,    /* in recovery from loss with SACK reneg? */
>>> -               unused:2;
>>> +               unused:1,
>>> +               wqp_called:1;
>>>          u8      nonagle     : 4,/* Disable Nagle algorithm? */
>>>                  thin_lto    : 1,/* Use linear timeouts for thin streams */
>>>                  recvmsg_inq : 1,/* Indicate # of bytes in queue upon recvmsg */
>>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>>> index 1a1fcb3..0c29bdd 100644
>>> --- a/net/ipv4/tcp.c
>>> +++ b/net/ipv4/tcp.c
>>> @@ -2534,6 +2534,9 @@ void tcp_write_queue_purge(struct sock *sk)
>>>          INIT_LIST_HEAD(&tcp_sk(sk)->tsorted_sent_queue);
>>>          sk_mem_reclaim(sk);
>>>          tcp_clear_all_retrans_hints(tcp_sk(sk));
>>> +       tcp_sk(sk)->highest_sack = NULL;
>>> +       tcp_sk(sk)->sacked_out = 0;
>>> +       tcp_sk(sk)->wqp_called = 1;
>>>          tcp_sk(sk)->packets_out = 0;
>>>          inet_csk(sk)->icsk_backoff = 0;
>>>   }
>>>
>>>
>>
>> Neal
>>
>> Since tcp_write_queue_purge() calls tcp_rtx_queue_purge() and we're deleting everything in the retrans queue there, doesn't it make sense to zero out all of those associated counters? Obviously clearing sacked_out is helping here, but is there a reason to keep track of lost_out, retrans_out, etc if retrans queue is now empty? Maybe calling tcp_clear_retrans() from tcp_rtx_queue_purge() ?
> 
> First, I would like to understand if we hit this problem on current upstream kernels.
> 
> Maybe a backport forgot a dependency.
> 
> tcp_write_queue_purge() calls tcp_clear_all_retrans_hints(), not tcp_clear_retrans(),
> this is probably for a reason.
> 
> Brute force clearing these fields might hide a serious bug.
> 

I guess we are all too busy to get more understanding on this :/
