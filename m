Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E774B55D9AB
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbiF0KU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 06:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbiF0KU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 06:20:28 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C95B10FB;
        Mon, 27 Jun 2022 03:20:27 -0700 (PDT)
Received: from [192.168.10.6] (unknown [39.45.206.71])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: usama.anjum)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 98CEE6601822;
        Mon, 27 Jun 2022 11:20:23 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1656325226;
        bh=A9r/BSry6EJHsBgDufrR9K+SKyuhrzoYWIWq3KRiJoU=;
        h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
        b=SCPIB5zfhRm85OMUNUvxAS01wbSjUx/hvQS/YVerLcCtUPyqEp8b1Ul/Uh14ZPddU
         buQGjzKEDvEW/b3E3b0yc0D9qyU388lUPH6Btl+2bfjQ7br2tgqnlNAivbN1DidRxA
         CDcL7TckuRPUYMWoPDtj1apYcQn2WnMwkaQsCSHJ+UW+gQMY8YV1lv4Uzh/K8eJyRt
         nGNYR5e3vMUlOXS/jWQIiJDjq+E5c5xE+MKd6oiS9s30DWT7YOKH5YPhJcO2RRYPRu
         8NPPgn8k7zhljmlk4q6nOvBWlxudlWhJGTP/OPo/FJKDEhVmG62mWxiN/Rn2psUh6D
         3IVw7jYasXD8A==
Message-ID: <63316ba7-f612-af5a-3f33-125cf89de754@collabora.com>
Date:   Mon, 27 Jun 2022 15:20:16 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Cc:     usama.anjum@collabora.com, "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        open list <linux-kernel@vger.kernel.org>,
        Collabora Kernel ML <kernel@collabora.com>,
        Paul Gofman <pgofman@codeweavers.com>,
        "open list:NETWORKING [TCP]" <netdev@vger.kernel.org>,
        Sami Farin <hvtaifwkbgefbaei@gmail.com>
Subject: Re: [RFC] EADDRINUSE from bind() on application restart after killing
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
References: <5099dc39-c6d9-115a-855b-6aa98d17eb4b@collabora.com>
 <CANn89i+R9RgmD=AQ4vX1Vb_SQAj4c3fi7-ZtQz-inYY4Sq4CMQ@mail.gmail.com>
 <8eb9b438-7018-4fe3-8be6-bb023df99594@collabora.com>
 <CANn89iJ1DfmuPz5pGdw=j9o+3O4R9tnTNFKi-ppW1O2sfmnN4g@mail.gmail.com>
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <CANn89iJ1DfmuPz5pGdw=j9o+3O4R9tnTNFKi-ppW1O2sfmnN4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On 5/30/22 8:28 PM, Eric Dumazet wrote:
>> The following command and patch work for my use case. The socket in
>> TIME_WAIT_2 or TIME_WAIT state are closed when zapped.
>>
>> Can you please upstream this patch?
> Yes, I will when net-next reopens, thanks for testing it.
Have you tried upstreaming it?

Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>

> 
>>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>>> index 9984d23a7f3e1353d2e1fc9053d98c77268c577e..1b7bde889096aa800b2994c64a3a68edf3b62434
>>> 100644
>>> --- a/net/ipv4/tcp.c
>>> +++ b/net/ipv4/tcp.c
>>> @@ -4519,6 +4519,15 @@ int tcp_abort(struct sock *sk, int err)
>>>                         local_bh_enable();
>>>                         return 0;
>>>                 }
>>> +               if (sk->sk_state == TCP_TIME_WAIT) {
>>> +                       struct inet_timewait_sock *tw = inet_twsk(sk);
>>> +
>>> +                       refcount_inc(&tw->tw_refcnt);
>>> +                       local_bh_disable();
>>> +                       inet_twsk_deschedule_put(tw);
>>> +                       local_bh_enable();
>>> +                       return 0;
>>> +               }
>>>                 return -EOPNOTSUPP;
>>>         }

-- 
Muhammad Usama Anjum
