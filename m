Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E91BEA84C
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 01:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfJaAib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 20:38:31 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38422 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfJaAia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 20:38:30 -0400
Received: by mail-pf1-f193.google.com with SMTP id c13so2943256pfp.5
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 17:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Yas4+3NlvGk+Xt7qf9y46uaOC/IF4lYn1OXpj44u6Cc=;
        b=Jsjdzjk5+wj3SoIZPjGUM0QV/qDuEmueC+X8oMs09lba1SKq8sCRx0TlSSVhRr+WZ6
         q6IrqPt+DJFmdckn+kELO+90RuXvSg/KTMaXcTF25suwxKel9Gb1A2gdJj23/OmheSYh
         CM1V82LLPx3v/cj7EAcMHAHEHatLxVamG2yYTbtBED5Ob5Cao5oRMNTybtjU0toEOgA2
         8FdXMoi+dLv7Ohd7NlGBC9mLrEJb0gRvx5vRWgsa0WTATo5aqA/utEWH6KkJWiBRJEK5
         z2CPdRGk5qWdC+sRkoYe+mTpkG0oDFK4jQLzOeApjwIHhsCsD6BWeEZlyqpUo6qtl9sd
         h1bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yas4+3NlvGk+Xt7qf9y46uaOC/IF4lYn1OXpj44u6Cc=;
        b=M3nClZg6FupaU+fhNs2bYvggBNvcAY76vcFPMqkI1t43BJpfF39ngQxM6QHQ5WyEyR
         3WehaA32SDjYVp7Iqw56lsXC57H7Qfd4I+STMDtvT0ssoj0rS6WCT5JSs6AHyJbs6i3o
         iW/UW/k5jpI8DHBaOTo2I9PCdNrfEgDtPZ/RDSR02RSmjmIjYc+GcYPnY9+vUQnAzJVc
         t04zZ6dawl3Ej8KdYhFjBy1ewNtHvrYhz8dZOAEp+2lmsRLKIpsxDR2PhmFYWXCRnXLU
         VYrZ7+n+gqp71y7SorKcLJ6FZ9ZjwyUYxkmJJoUmY00FhHyo+eWL1jVg7/Mxm/WtcYHx
         dpvA==
X-Gm-Message-State: APjAAAWxaP3gFBFLoMqGxxv3TeIxKyvF9ADEvziBjKGTB6qE/88qUrlV
        oou1WxPLOAmiSwg3yTHYBi0=
X-Google-Smtp-Source: APXvYqwdKKuzP1gRfA81S7eRyxzuOjKq1rhO6mFUfRTXXvSxd1QluTT/7zy5flCZeUJcdEp1AA3RRw==
X-Received: by 2002:a17:90a:326b:: with SMTP id k98mr2835324pjb.50.1572482309982;
        Wed, 30 Oct 2019 17:38:29 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id m68sm1091285pfb.122.2019.10.30.17.38.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2019 17:38:29 -0700 (PDT)
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
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
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8d24cb15-7c55-523f-b783-49f18913d03f@gmail.com>
Date:   Wed, 30 Oct 2019 17:38:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <74827a046961422207515b1bb354101d@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/30/19 11:27 AM, Subash Abhinov Kasiviswanathan wrote:
>> Thanks. Do you mind sharing what your patch looked like, so we can
>> understand precisely what was changed?
>>
>> Also, are you able to share what the workload looked like that tickled
>> this issue? (web client? file server?...)
> 
> Sure. This was seen only on our regression racks and the workload there
> is a combination of FTP, browsing and other apps.
> 
> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> index 4374196..9af7497 100644
> --- a/include/linux/tcp.h
> +++ b/include/linux/tcp.h
> @@ -232,7 +232,8 @@ struct tcp_sock {
>                 fastopen_connect:1, /* FASTOPEN_CONNECT sockopt */
>                 fastopen_no_cookie:1, /* Allow send/recv SYN+data without a cookie */
>                 is_sack_reneg:1,    /* in recovery from loss with SACK reneg? */
> -               unused:2;
> +               unused:1,
> +               wqp_called:1;
>         u8      nonagle     : 4,/* Disable Nagle algorithm?             */
>                 thin_lto    : 1,/* Use linear timeouts for thin streams */
>                 recvmsg_inq : 1,/* Indicate # of bytes in queue upon recvmsg */
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 1a1fcb3..0c29bdd 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2534,6 +2534,9 @@ void tcp_write_queue_purge(struct sock *sk)
>         INIT_LIST_HEAD(&tcp_sk(sk)->tsorted_sent_queue);
>         sk_mem_reclaim(sk);
>         tcp_clear_all_retrans_hints(tcp_sk(sk));
> +       tcp_sk(sk)->highest_sack = NULL;
> +       tcp_sk(sk)->sacked_out = 0;
> +       tcp_sk(sk)->wqp_called = 1;

What is this wqp_called exactly ?

