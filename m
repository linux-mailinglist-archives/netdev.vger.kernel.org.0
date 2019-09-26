Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9E8BF737
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 18:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfIZQ5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 12:57:48 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:43071 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbfIZQ5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 12:57:47 -0400
Received: by mail-pf1-f169.google.com with SMTP id a2so2155801pfo.10
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 09:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=kexk24EJ7LFkeRbo1uXfupcpzjhrOwe8xEjc6M5Y9CY=;
        b=bZBCerFFqIyEUcGzsJ/fWrQ1J1RIMONE0MkAN0kmeBZbonLlHQEVmXPDXptrCrwkEv
         6puzqHLB5HdOZVPff/BcDV81RUU5bHQofaxN/ytB7GhoA83zpfGgRXkQufK2u7O1oHjn
         54XTSs2Ju6J7DCQ++onohRvuDoIigZeEoeKjI2MMSEE1c3LTHvLMHBIJZ3ggkKEnh6q6
         mMb1NJUNL4tD+wev0Fre44NfXutqhUx9cFkqxSmua/+vuV+0Y5//uz48xwsOSgdmMD2B
         qxyN6OTca72kD9CJjOKy1vDQuUbZft/SjDPnSS8C/wcKl0rTJVfvZFiVwdZQB+TdV24v
         jHCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kexk24EJ7LFkeRbo1uXfupcpzjhrOwe8xEjc6M5Y9CY=;
        b=h0nKEvhF32Kz+Wf3LA/K/dVr7yCW1GVxMqETaX9jMoS7PjFvOmJgGsNePrSZWfEc6z
         pvDRtpAZb5HI2dETgV6tXmjXYfqF+OvGLsFcArKkeqkNgc2Fhlisir0DMwa102vnJ5GG
         pD1G2NP9lVrf+sxFyTXFUdlhFLqOtIDN7jugAjB+2FGhzeb1m/wfmCUlj7kA6BdAYEc9
         d1u+UxhAkCQKmIVTzbGrdAZVPuSMLpVJ6ABvaj7+gcL+oLZMD7QXDHc7Udws+2DU+d2G
         62cLmR9LIxAhbZt3Vd/PYfhqfgjIGCXkQSzWwNF5T43PKsOMAUZ7nBVtNtv2nKcn38UH
         OhJw==
X-Gm-Message-State: APjAAAWkdXDktqU3PGrOmDEbuvhXswbKj9wGxTTFF5A3blPVoN3h19f8
        qZpXe1jOAQUDhm9KjkK0dBm22ZwF
X-Google-Smtp-Source: APXvYqwcR3wUOT/P7wG5c+MPTpbE0pqmnIjwsYfiPPVCNWBYj+972ig1aaeSWGN9Zt34YBhMvbE7Lw==
X-Received: by 2002:a17:90a:c096:: with SMTP id o22mr4712544pjs.29.1569517066700;
        Thu, 26 Sep 2019 09:57:46 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id h14sm2788167pfo.15.2019.09.26.09.57.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 09:57:45 -0700 (PDT)
Subject: Re: TCP_USER_TIMEOUT, SYN-SENT and tcp_syn_retries
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Marek Majkowski <marek@cloudflare.com>, netdev@vger.kernel.org
References: <CAJPywTL0PiesEwiRWHdJr0Te_rqZ62TXbgOtuz7NTYmQksE_7w@mail.gmail.com>
 <c682fe41-c5ee-83b9-4807-66fcf76388a4@gmail.com>
 <61e4c437-cb1e-bcd6-b978-e5317d1e76c3@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <74175c7e-21f3-1f68-96d4-149fe968e90f@gmail.com>
Date:   Thu, 26 Sep 2019 09:57:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <61e4c437-cb1e-bcd6-b978-e5317d1e76c3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/26/19 9:46 AM, Eric Dumazet wrote:
> 
> 
> On 9/26/19 8:05 AM, Eric Dumazet wrote:
>>
>>
>> On 9/25/19 1:46 AM, Marek Majkowski wrote:
>>> Hello my favorite mailing list!
>>>
>>> Recently I've been looking into TCP_USER_TIMEOUT and noticed some
>>> strange behaviour on fresh sockets in SYN-SENT state. Full writeup:
>>> https://blog.cloudflare.com/when-tcp-sockets-refuse-to-die/
>>>
>>> Here's a reproducer. It does a simple thing: sets TCP_USER_TIMEOUT and
>>> does connect() to a blackholed IP:
>>>
>>> $ wget https://gist.githubusercontent.com/majek/b4ad53c5795b226d62fad1fa4a87151a/raw/cbb928cb99cd6c5aa9f73ba2d3bc0aef22fbc2bf/user-timeout-and-syn.py
>>>
>>> $ sudo python3 user-timeout-and-syn.py
>>> 00:00.000000 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>>> 00:01.007053 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>>> 00:03.023051 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>>> 00:05.007096 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>>> 00:05.015037 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>>> 00:05.023020 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>>> 00:05.034983 IP 192.1.1.1.52974 > 244.0.0.1.1234: Flags [S]
>>>
>>> The connect() times out with ETIMEDOUT after 5 seconds - as intended.
>>> But Linux (5.3.0-rc3) does something weird on the network - it sends
>>> remaining tcp_syn_retries packets aligned to the 5s mark.
>>>
>>> In other words: with TCP_USER_TIMEOUT we are sending spurious SYN
>>> packets on a timeout.
>>>
>>> For the record, the man page doesn't define what TCP_USER_TIMEOUT does
>>> on SYN-SENT state.
>>>
>>
>> Exactly, so far this option has only be used on established flows.
>>
>> Feel free to send patches if you need to override the stack behavior
>> for connection establishment (Same remark for passive side...)
> 
> Also please take a look at TCP_SYNCNT,  which predates TCP_USER_TIMEOUT
> 
> 

I will test the following :

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index dbd9d2d0ee63aa46ad2dda417da6ec9409442b77..1182e51a6b794d75beb8c130354d7804fc83a307 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -220,7 +220,6 @@ static int tcp_write_timeout(struct sock *sk)
                        sk_rethink_txhash(sk);
                }
                retry_until = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_syn_retries;
-               expired = icsk->icsk_retransmits >= retry_until;
        } else {
                if (retransmits_timed_out(sk, net->ipv4.sysctl_tcp_retries1, 0)) {
                        /* Black hole detection */
@@ -242,9 +241,9 @@ static int tcp_write_timeout(struct sock *sk)
                        if (tcp_out_of_resources(sk, do_reset))
                                return 1;
                }
-               expired = retransmits_timed_out(sk, retry_until,
-                                               icsk->icsk_user_timeout);
        }
+       expired = retransmits_timed_out(sk, retry_until,
+                                       icsk->icsk_user_timeout);
        tcp_fastopen_active_detect_blackhole(sk, expired);
 
        if (BPF_SOCK_OPS_TEST_FLAG(tp, BPF_SOCK_OPS_RTO_CB_FLAG))
