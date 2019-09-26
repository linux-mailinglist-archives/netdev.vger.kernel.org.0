Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 241D2BF9C6
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 21:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbfIZTFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 15:05:14 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43334 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727920AbfIZTFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 15:05:14 -0400
Received: by mail-pf1-f194.google.com with SMTP id a2so38354pfo.10
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 12:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YjGPEBxtUwCkpgRdRYbT62m36B7ZaqPDdOy5AlB0ZZM=;
        b=HLm6d9xPpTSoobaQxzzOjDqH1cTkhxXDnHkZDp3rtJ2PAqGiw2E9oWQYQqbdwjSmV9
         FV3lqmSEdX06/1InZP4rluaEv69GAD9f3vwPNRkFOM/rn8R0P/Rk202Q/G20w7OcNcEh
         skcyKgYv77Q6sZ+yu7J/aI7HUCfB353zwLDU/IDVUjP/s6vHsclDD8hSlT9gCrdf4SpN
         4lIEcunZFQM1Sh21TLKlwrKhYf9YXr8QNSz4cntescfq57mGMYdZuSD86/9Tt09uflq1
         bP2TyzSBTLT34TtXdtsWNNsf8V3V1LAib8fylcn8bFzbWHNEgWsTBrKEn8gOdbkUzkf1
         ocjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YjGPEBxtUwCkpgRdRYbT62m36B7ZaqPDdOy5AlB0ZZM=;
        b=kZOl1cADlfF/pQ3sJ5lMd4Y+RA533tT//hrajlpqtq5HQxyAV108Br3JZjM3sHhAMN
         rMV7ud09DLBBRYuDmqNw0F1Qp5kjl0xJ63CInxPJIb9KiiC2l0iTMRn7wzxpo5yxDQtM
         omElWt9MAX1cAPfEYOLwoeTRoDK4VnrdQadj7B8Q+1qeNak4kpSOpN3iwfscCAJmMsVO
         IgOBaYBw6Zi62VnHqyroRPwGLgiNEBJwDl/B/tbtRqE58yNqS6wd5FKvpU5WuuSuiU5N
         GhCtomCY4NXu38i1R+0dgsnOeOwIFzoi72dc8nTO3stKVEFC15NDaEBQlrRpGyPWmd/i
         RLCw==
X-Gm-Message-State: APjAAAWL2WIuyzc+5Nv6SV933Aorc0Mvh9n3gg9zw98c9O2qinqmtLST
        H/xDXePS9uEopSC9DIbtPZRrQ9JX
X-Google-Smtp-Source: APXvYqxO6PpN3UDCXZhSxvW2ZuK+8R1WH3oVwc85vWB7LFhJFGonn8XkKrst9NFRxOWUHDwYm8lhxA==
X-Received: by 2002:a63:6988:: with SMTP id e130mr5140993pgc.203.1569524713360;
        Thu, 26 Sep 2019 12:05:13 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id y7sm23632pfn.142.2019.09.26.12.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 12:05:12 -0700 (PDT)
Subject: Re: [PATCH v2 net] sk_buff: drop all skb extensions on free and skb
 scrubbing
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, paulb@mellanox.com,
        vladbu@mellanox.com
References: <20190926183705.16951-1-fw@strlen.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1ad4b9f0-c9d4-954b-eafe-8652ea6ce409@gmail.com>
Date:   Thu, 26 Sep 2019 12:05:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190926183705.16951-1-fw@strlen.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/26/19 11:37 AM, Florian Westphal wrote:
> Now that we have a 3rd extension, add a new helper that drops the
> extension space and use it when we need to scrub an sk_buff.
> 

>  }
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index f12e8a050edb..01d65206f4fb 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5119,7 +5119,7 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)
>  	skb->skb_iif = 0;
>  	skb->ignore_df = 0;
>  	skb_dst_drop(skb);
> -	secpath_reset(skb);
> +	skb_ext_reset(skb);
>  	nf_reset(skb);
>  	nf_reset_trace(skb);


It is unfortunate nf_reset(skb) will call skb_ext_del(skb, SKB_EXT_BRIDGE_NF),
which is useless after skb_ext_reset(skb) 

Maybe time for a nf_ct_reset() helper only dealing with nfct.


