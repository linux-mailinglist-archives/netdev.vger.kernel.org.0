Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D97CBF8A3
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 20:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbfIZSEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 14:04:01 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:32864 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbfIZSEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 14:04:00 -0400
Received: by mail-pg1-f182.google.com with SMTP id i30so1999123pgl.0
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 11:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YnahzE8jxGZj1AhlJYfeAsziQ1ZnHChAz8FcEdVC9uo=;
        b=iMmFRzpSAoNmzYGTXQcRufZqeNHWbCH8fwn0luXd2xn0iFIfyxxZsB+ZfClQuPYxSG
         mY9+sFwOmqYL5hTV1/N1Oj/EQM7cvptd6UX5LMoQks8qXzxSGpLzPiD0S5vjh9UlMHpq
         j7MY9E3/inh0RXIvxIsWi3cJyWVp2jCpTjgkbiiRGFPeWvf/8QWyKuRREAwEYylu4Yeo
         43CKIS9brSKeODWSufslFBz3+giUo59xO8W+QCyMd2t7OJLFNFG4jJve+aseKLf9vs0X
         xqGBfjAc+Tiptv7NGZPRcA2SYDTkqIEcGyQvqxPgna8N2zpnAVmPwE69a9uzxz9Y29hO
         7P9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YnahzE8jxGZj1AhlJYfeAsziQ1ZnHChAz8FcEdVC9uo=;
        b=n7aDTSIPCySsEYrccQSsvQuPCrK4gTgV6PnFfkJKM9gVqEbt41/SjCDqPZYcXalo8r
         j0VSxPWURbDrqcNdFm13LzJso3l3byY+TF6L95sZwSecyzr8L5d7euyTVxJsBkKSiijL
         5O1qfSA3lhK1+0yIB4NutNplUkwkaBGn1H+IMFJwKhNi2y2ozJ5nx/rhB1vSNjMnuF4h
         LsmIfFHeyKEVs9CEPUk7pI4ZSSH1HWRNFryxRZIz++XZ9+5T461cPn+p/mIeT4CZi0kx
         kn1aWB6zE8zzxb10cxyeBVB7ItJvxvE5JXShJIEvlrIcGM/qucRwmUxGspKwLz6GjY6z
         XFeA==
X-Gm-Message-State: APjAAAUJq3+gBJ/y1YfTnbZVu+u3fPRA60xQqtzogtMjKb1gJu1dWO2b
        iCEJrqDw4xcYYUzgRfqGrvu12iHL
X-Google-Smtp-Source: APXvYqz192m/QtJN36BE3+My4R0TKbvV+Ru2tgoNccmZ8Tpq+eNoACyZS4zvS3d03gSnLJb0QLPokA==
X-Received: by 2002:a62:db42:: with SMTP id f63mr5306863pfg.225.1569521039471;
        Thu, 26 Sep 2019 11:03:59 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id 37sm2731263pgv.32.2019.09.26.11.03.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 11:03:58 -0700 (PDT)
Subject: Re: TCP_USER_TIMEOUT, SYN-SENT and tcp_syn_retries
To:     Marek Majkowski <marek@cloudflare.com>, netdev@vger.kernel.org
References: <CAJPywTL0PiesEwiRWHdJr0Te_rqZ62TXbgOtuz7NTYmQksE_7w@mail.gmail.com>
 <c682fe41-c5ee-83b9-4807-66fcf76388a4@gmail.com>
 <61e4c437-cb1e-bcd6-b978-e5317d1e76c3@gmail.com>
 <74175c7e-21f3-1f68-96d4-149fe968e90f@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a669987a-66c7-b4a1-7c5f-0b2494c4f14a@gmail.com>
Date:   Thu, 26 Sep 2019 11:03:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <74175c7e-21f3-1f68-96d4-149fe968e90f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/26/19 9:57 AM, Eric Dumazet wrote:
> 
> 
> On 9/26/19 9:46 AM, Eric Dumazet wrote:
>>
>>
>> On 9/26/19 8:05 AM, Eric Dumazet wrote:
>>>
>>>
>>> On 9/25/19 1:46 AM, Marek Majkowski wrote:
>>>> Hello my favorite mailing list!
>>>>
>>>> Recently I've been looking into TCP_USER_TIMEOUT and noticed some
>>>> strange behaviour on fresh sockets in SYN-SENT state. Full writeup:
>>>> https://blog.cloudflare.com/when-tcp-sockets-refuse-to-die/
>>>>
>>>> Here's a reproducer. It does a simple thing: sets TCP_USER_TIMEOUT and
>>>> does connect() to a blackholed IP:
>>>>
>>>> $ wget https://gist.githubusercontent.com/majek/b4ad53c5795b226d62fad1fa4a87151a/raw/cbb928cb99cd6c5aa9f73ba2d3bc0aef22fbc2bf/user-timeout-and-syn.py
>>>>
>>>> $ sudo python3 user-timeout-and-syn.py
>>>> 00:00.000000 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>>>> 00:01.007053 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>>>> 00:03.023051 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>>>> 00:05.007096 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>>>> 00:05.015037 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>>>> 00:05.023020 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>>>> 00:05.034983 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>>>>
>>>> The connect() times out with ETIMEDOUT after 5 seconds - as intended.
>>>> But Linux (5.3.0-rc3) does something weird on the network - it sends
>>>> remaining tcp_syn_retries packets aligned to the 5s mark.
>>>>
>>>> In other words: with TCP_USER_TIMEOUT we are sending spurious SYN
>>>> packets on a timeout.
>>>>
>>>> For the record, the man page doesn't define what TCP_USER_TIMEOUT does
>>>> on SYN-SENT state.
>>>>
>>>
>>> Exactly, so far this option has only be used on established flows.
>>>
>>> Feel free to send patches if you need to override the stack behavior
>>> for connection establishment (Same remark for passive side...)
>>
>> Also please take a look at TCP_SYNCNT,  which predates TCP_USER_TIMEOUT
>>
>>
> 
> I will test the following :
> 
> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> index dbd9d2d0ee63aa46ad2dda417da6ec9409442b77..1182e51a6b794d75beb8c130354d7804fc83a307 100644
> --- a/net/ipv4/tcp_timer.c
> +++ b/net/ipv4/tcp_timer.c
> @@ -220,7 +220,6 @@ static int tcp_write_timeout(struct sock *sk)
>                         sk_rethink_txhash(sk);
>                 }
>                 retry_until = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_syn_retries;
> -               expired = icsk->icsk_retransmits >= retry_until;
>         } else {
>                 if (retransmits_timed_out(sk, net->ipv4.sysctl_tcp_retries1, 0)) {
>                         /* Black hole detection */
> @@ -242,9 +241,9 @@ static int tcp_write_timeout(struct sock *sk)
>                         if (tcp_out_of_resources(sk, do_reset))
>                                 return 1;
>                 }
> -               expired = retransmits_timed_out(sk, retry_until,
> -                                               icsk->icsk_user_timeout);
>         }
> +       expired = retransmits_timed_out(sk, retry_until,
> +                                       icsk->icsk_user_timeout);
>         tcp_fastopen_active_detect_blackhole(sk, expired);
>  
>         if (BPF_SOCK_OPS_TEST_FLAG(tp, BPF_SOCK_OPS_RTO_CB_FLAG))
> 

The patch works well, but reading again the man page, I see the existing behavior as
been clearly documented.

If we change the behavior, we might break applications that were setting TCP_USER_TIMEOUT
on the listener, expecting the value to b inherited to children at accept() time
but not expecting to change SYNACK rtx behavior.

On the other hand, John Maxell patch (tcp: Add tcp_clamp_rto_to_user_timeout() helper to improve accuracy)
has added this weird effect of sending remaining SYN every jiffie


     remaining = icsk->icsk_user_timeout - elapsed;
     if (remaining <= 0)
         return 1; /* user timeout has passed; fire ASAP */ 

So we probably just should extend TCP_USER_TIMEOUT to SYN_SENT/SYN_RECV states
and change the man page accordingly. 



       TCP_USER_TIMEOUT (since Linux 2.6.37)
              This  option takes an unsigned int as an argument.  When the value is
              greater than 0, it specifies the maximum amount of time in  millisec‐
              onds  that transmitted data may remain unacknowledged before TCP will
              forcibly close the corresponding connection and return  ETIMEDOUT  to
              the  application.  If the option value is specified as 0, TCP will to
              use the system default.

              Increasing user timeouts allows a TCP connection to survive  extended
              periods  without  end-to-end  connectivity.  Decreasing user timeouts
              allows applications to "fail fast", if so desired.  Otherwise,  fail‐
              ure  may  take up to 20 minutes with the current system defaults in a
              normal WAN environment.

              This option can be set during any state of a TCP connection,  but  is
              effective only during the synchronized states of a connection (ESTAB‐
              LISHED, FIN-WAIT-1, FIN-WAIT-2, CLOSE-WAIT, CLOSING,  and  LAST-ACK).
              Moreover,  when  used  with  the TCP keepalive (SO_KEEPALIVE) option,
              TCP_USER_TIMEOUT will override keepalive to determine when to close a
              connection due to keepalive failure.

              The option has no effect on when TCP retransmits a packet, nor when a
              keepalive probe is sent.

              This option, like many others, will be inherited by  the  socket  re‐
              turned by accept(2), if it was set on the listening socket.

              Further  details  on the user timeout feature can be found in RFC 793
              and RFC 5482 ("TCP User Timeout Option").

