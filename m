Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAA044EAAE
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 16:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbfFUOeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 10:34:02 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33924 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbfFUOeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 10:34:01 -0400
Received: by mail-qt1-f196.google.com with SMTP id m29so7151831qtu.1;
        Fri, 21 Jun 2019 07:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Dg3NQA4s7i7yXiqLc8b8VYabNDHnBzjqCi0/49y+82o=;
        b=u/egA7TKy7DGFgGyQycnlnknW/8rbe49PdZLkFSd6JNo1v0PYbB2iidrTq6JcLK0V9
         8U2RxCIjYqxOK8GGlYs45/R5rUZQx40Cl2YukrpjBlDUQjX7ircTjtqf+h8Q2tP+X426
         0Rcm1fzzcu5gjau2bzv+40o5h8RU3yhc3o1R1Nk17OkV1l3c7eaqME+MSyG0WqEDRV+M
         V6ruRXxxaQPtfKbcVMbzNFge84yh9w3MfiwbHJv00OOrC2a820+8IP4yAYHigusTgtjx
         RHRoyf4loY3jivqvAjN765xjBwKfaiMdQSZvlb2dnOPy3uCji4uSGGgEQYY8Ygi4CgmI
         kxVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dg3NQA4s7i7yXiqLc8b8VYabNDHnBzjqCi0/49y+82o=;
        b=b+UvS4mkL/PJvemO5PJgGY3W+g4OUd/qQQwagjIvzJi0xWg69b7mtoSrRn/0SzguwU
         S1gPN4rKa3cMcw0z0kqlvDB7pqhHtMzEsYsvA/KlogmSSfEISKLO/MSyZi3GVUeTJOIb
         l9QcTrANSkuWSJ6KnRAE0U75/Wita7v9/He0gLXSoUt4fcAqllGTr8asYX7TePrL1PVW
         A/ajnbHeHecIzFujgUApZl5td5xBUY23c1G4FG2PKNeIU4LHN+V6itRgNym/11B+dvxb
         AZ1hYJO8NVHTtwIaGzdHOJ00QZZzzdOFKHLfcYAF/QArgdERlUWTZBxn66rg2BlEZgag
         WkyA==
X-Gm-Message-State: APjAAAXEdLIXnkCFIdPutRYt9aGhywwhT50wH8W+oBhoO/T6AqtflQZn
        iALlZuLecnz3T7okKuSkgjQ=
X-Google-Smtp-Source: APXvYqxWfwNjNsoILKb6y2tR1gWm3EAhsYEvuapj9cKy1cbkrjG/ZjvYwcyVWuqjyhXCtwoq/19Rig==
X-Received: by 2002:aed:254c:: with SMTP id w12mr121359074qtc.127.1561127640187;
        Fri, 21 Jun 2019 07:34:00 -0700 (PDT)
Received: from [10.195.149.182] ([144.121.20.163])
        by smtp.gmail.com with ESMTPSA id e8sm1333389qkn.95.2019.06.21.07.33.58
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 07:33:59 -0700 (PDT)
Subject: Re: [RFC bpf-next 0/7] Programming socket lookup with BPF
To:     Florian Westphal <fw@strlen.de>,
        Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com
References: <20190618130050.8344-1-jakub@cloudflare.com>
 <20190618135258.spo6c457h6dfknt2@breakpoint.cc>
 <87sgs6ey43.fsf@cloudflare.com>
 <20190621125155.2sdw7pugepj3ityx@breakpoint.cc>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f373a4d7-c16b-bce2-739d-788525ea4f96@gmail.com>
Date:   Fri, 21 Jun 2019 10:33:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190621125155.2sdw7pugepj3ityx@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/21/19 5:51 AM, Florian Westphal wrote:
> Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>> So, at least for this part I don't see a technical reason why this
>>> has to grab a reference for listener socket.
>>
>> That's helpful, thanks! We rely on TPROXY, so I would like to help with
>> that. Let me see if I can get time to work on it.
> 
> AFAICS so far this would be enough:
> 
> 1. remove the BUG_ON() in skb_orphan, letting it clear skb->sk instead
> 2. in nf_queue_entry_get_refs(), if skb->sk and no destructor:
>    call nf_tproxy_assign_sock() so a reference gets taken.
> 3. change skb_steal_sock:
>    static inline struct sock *skb_steal_sock(struct sk_buff *skb, bool *refcounted)
>     [..]
>     *refcounted = skb->destructor != NULL;
> 4. make tproxy sk assign elide the destructor assigment in case of
>    a listening sk.
> 

Okay, but how do we make sure the skb->sk association does not leak from rcu section ?

Note we have the noref/refcounted magic for skb_dst(), we might try to use something similar
for skb->sk

> This should work because TPROXY target is restricted to PRE_ROUTING, and
> __netif_receive_skb_core runs with rcu readlock already held.
> 
> On a side note, it would also be interesting to see what breaks if the
> nf_tproxy_sk_is_transparent() check in the tprox eval function is
> removed -- if we need the transparent:1 marker only for output, i think
> it would be ok to raise the bit transparently in the kernel in case
> we assign skb->sk = found_sk; i.e.
>  if (unlikely(!sk_is_transparent(sk))
> 	 make_sk_transparent(sk);
> 
> I don't see a reason why we need the explicit setsockopt(IP_TRANSPARENT)
> from userspace.
> 
