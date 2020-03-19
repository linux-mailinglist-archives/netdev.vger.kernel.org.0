Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA6D18BCF9
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgCSQpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:45:49 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46026 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727739AbgCSQps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:45:48 -0400
Received: by mail-pf1-f194.google.com with SMTP id j10so1704428pfi.12;
        Thu, 19 Mar 2020 09:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rqoxRu5uTV9HdpBRh5ZrKoR06yptV6U1vRvMIWMLqWk=;
        b=gYc0DWaYJUGrkknc68PCAmoedaYWvGk2WPN5jLPkV/MTJ8EuIa7/CP5cOqOAD7+5vv
         C9jXyAXOm/qvendCa7gOgJ9B80kJw+2SOPIquD2w0RfLFTeeuGXC1zddK9x+E1YZC4No
         tDMt66CY7gs1O1DOxcD3qaaFcp9DNSxnb6XCILY4fJxlOo7D+Ld/DGUdnLyM9ZyScBsP
         3kSqYqED7SRDBvm0I6qHCNilsv9STQgP9gsbbJrWC92pEqVHCIsjN+xGhvLV/456UqIb
         N9nF71Huf2UZNOLuwW9IqIjcv5cuymHyHQx/gp19xy4dRfs+LAfZI5GTrav3jteh10PL
         f+6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rqoxRu5uTV9HdpBRh5ZrKoR06yptV6U1vRvMIWMLqWk=;
        b=VHK2yTSXXhXRWwb2v5nT7L9E4Qer5OfHWlNT9UK0VIewrz4RnsKNY09EROZA9Ekx8/
         7HPHzp0eKUJyDwwEfTLWfCa+ek9A1RvsPjrqCR/L5IqQScpETh+tPX5Kpn1dLyznGLq8
         QiC4vk52MEyEuglsbnoA56+f2/Trl5XIaDE+fFDYPHN3WIw7a0mnT/tPLiGU0svvtrYK
         W7Rrkgl0Qz1ZHacGpw3BR7j1hoyLJt83Jxdi5usAUytlDnAMzBNJCCu9DmynPK8b0TDF
         AUuN+VXnvTCFvZAjS/TF5hGSfJIMMXdeGaYKZaMGslyBtTDDtn6ZkI1TonryM8Cc5WDR
         967w==
X-Gm-Message-State: ANhLgQ1QzObQ9lM97qe+LAc4dx44pokUVzflWz7ZhKPPiaoH7qUBclEl
        VmBnysvQGH06iNTzlb22wMx2VLJT
X-Google-Smtp-Source: ADFU+vtd1EcregzpOuJLRbg4mfZJJwu7a8XDtTUwoAzxdwD+cy6BlKF+LL9klkqMF44sfAsy57Ioxw==
X-Received: by 2002:aa7:9a01:: with SMTP id w1mr4893396pfj.256.1584636347009;
        Thu, 19 Mar 2020 09:45:47 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id a2sm2549789pjq.20.2020.03.19.09.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 09:45:46 -0700 (PDT)
Subject: Re: Bug URGENT Report with new kernel 5.5.10-5.6-rc6
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Martin Zaharinov <micron10@gmail.com>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <CALidq=XsQy66n-pTMOMN=B7nEsk7BpRZnUHery5RJyjnMsiXZQ@mail.gmail.com>
 <CALidq=VVpixeJFJFkUSeDqTW=OX0+dhA04ypE=y949B+Aqaq0w@mail.gmail.com>
 <CALidq=UXHz+rjiG5JxAz-CJ1mKsFLVupsH3W+z58L2nSPKE-7w@mail.gmail.com>
 <20200319003823.3b709ad8@elisabeth>
 <CALidq=Xow0EkAP4LkqvQiDOmVDduEwLKa4c-A54or3GMj6+qVw@mail.gmail.com>
 <20200319103438.GO979@breakpoint.cc> <20200319104750.x2zz7negjbm6lwch@salvia>
 <20200319105248.GP979@breakpoint.cc>
 <fff10500-8b87-62f0-ec89-49453cf9ae57@gmail.com>
Message-ID: <4d9f339c-b0a7-1861-7d76-e0f2cee92b8c@gmail.com>
Date:   Thu, 19 Mar 2020 09:45:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <fff10500-8b87-62f0-ec89-49453cf9ae57@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/19/20 9:40 AM, Eric Dumazet wrote:
> 
> 
> On 3/19/20 3:52 AM, Florian Westphal wrote:
>> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>> On Thu, Mar 19, 2020 at 11:34:38AM +0100, Florian Westphal wrote:
>>>> Martin Zaharinov <micron10@gmail.com> wrote:
>>>>
>>>> [ trimming CC ]
>>>>
>>>> Please revert
>>>>
>>>> commit 28f8bfd1ac948403ebd5c8070ae1e25421560059
>>>> netfilter: Support iif matches in POSTROUTING
>>>
>>> Please, specify a short description to append to the revert.
>>
>> TCP makes use of the rb_node in sk_buff for its retransmit queue,
>> amongst others.
> 
> 
> Only for master skbs kept in TCP internal queues (rtx rb tree)
> 
> However the packets leaving TCP stack are clones.
> 
>   skb->dev aliases to this storage, i.e., passing
>> skb->dev as the input interface in postrouting may point to another
>> sk_buff instead.
>> This will cause crashes and data corruption with nf_queue, as we will
>> attempt to increment a random pcpu variable when calling dev_hold().
>>
>> Also, the memory address may also be free'd, which gives UAF splat.
>>
> 
> This seems to suggest clones skb->dev should be cleared before leaving TCP stack,
> if some layer is confused because skb->dev has not yet been set by IP layer ?
> 
> Untested patch :
> 
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 306e25d743e8de1bfe23d6e3b3a9fb0f23664912..c40fb3880307aa3156d01a8b49f1296657346cfd 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1228,6 +1228,7 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
>         /* Cleanup our debris for IP stacks */
>         memset(skb->cb, 0, max(sizeof(struct inet_skb_parm),
>                                sizeof(struct inet6_skb_parm)));
> +       skb->dev = NULL;
>  
>         tcp_add_tx_delay(skb, tp);
>  
> 

Or clear the field only after cloning :

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 306e25d743e8de1bfe23d6e3b3a9fb0f23664912..13dd0d8003baee3febcfb85df84421f8f91132ef 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1109,6 +1109,7 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 
                if (unlikely(!skb))
                        return -ENOBUFS;
+               skb->dev = NULL;
        }
 
        inet = inet_sk(sk);

