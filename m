Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590704511B8
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 20:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236737AbhKOTNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 14:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237058AbhKOTLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:11:23 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E38C0431A9
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:59:59 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 188so15232556pgb.7
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mRdzLUEsF4bSBpT5zYKf40vqqQlFaXFiBUUQJbaAsrY=;
        b=GjWqCBJMiv0nk/xTaWwxjs4hGItoJV0p7WnTz1toWVNJ6/BWpHhMKa6R3S40OPskpQ
         tXIujZaww7KBSReKngfvHZpOpiaJ8rjz9yYARsQFCOeqsbY131Rp5lTO5aGTxKphXcxF
         OPQ+W8WUL91rWknETQawtYSAWBoO18qU7JqJngi9hPLFNkf78S243cCdcVSsUPqxKUHH
         8NCXEV2IjZ2AC6HTbLayUGBe5SMKo3k73Fxnr1nDzWphXXv/GQIVYfrFBMpSwCBM5zlG
         BfFxrGm4c/GcWtg42+93zVklGWchfj9i8spipDtMPTaKKnugYfQLXeJxb7heIohjMTHW
         AaGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mRdzLUEsF4bSBpT5zYKf40vqqQlFaXFiBUUQJbaAsrY=;
        b=jg+jlJQRE3+O+NJ0jWV+/WSoMgO4x2r5pUXRjeoavjeXsxrzP7o1eVJziw/bJL1qHe
         t/mSLPcbgCPSxl31UDst73yNSpmxgXusNZd9PMILN0v6XBWQ5SAbt44Y78W+RA9RMZ//
         rqJyGNveSuRqRSiddUGbztKGNKvzK+9k+c2lStsPCspQ3DNt39fUX1uwkykcwrUxNS3x
         Bhqzd3g8bpU8BOu2IkaDXDBQKycVdGcM6TqaDJrw7bC9HHkEU85ZYnoGr94/Mq48DZYU
         cT+0sJJ14+6VJHd7KtgUfrZzP9WRKxDu7jIROrSS+X4j7qbLlFpyqvdOq8i2ekT0Tjvf
         yjiw==
X-Gm-Message-State: AOAM533ft9Mdx6HkaYZ1zo/btdtl27iYE9iffD4pCw3XqTs290FtiaGe
        UljZ6hhIPNp84S0fF59Cg5o=
X-Google-Smtp-Source: ABdhPJyEKEuHU5siEqbNq7r5Jet/Q2hEbWn4MKAffrqju5m3vubmWLp8xyOvhdDuFaYoPDuiCDbsCA==
X-Received: by 2002:a63:2c8:: with SMTP id 191mr444454pgc.293.1636999198596;
        Mon, 15 Nov 2021 09:59:58 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id c5sm11725pjm.52.2021.11.15.09.59.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 09:59:57 -0800 (PST)
Subject: Re: [RFC net-next] net: guard drivers against shared skbs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, hawk@kernel.org,
        syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
References: <20211115163205.1116673-1-kuba@kernel.org>
 <88391a1a-b8e4-96ca-7d80-df5c6674796d@gmail.com>
 <20211115093512.63404c26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d719cc02-7963-bdf9-b6cd-494022b5d361@gmail.com>
Date:   Mon, 15 Nov 2021 09:59:56 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211115093512.63404c26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/15/21 9:35 AM, Jakub Kicinski wrote:
> On Mon, 15 Nov 2021 08:56:10 -0800 Eric Dumazet wrote:
>> On 11/15/21 8:32 AM, Jakub Kicinski wrote:
>>> Commit d8873315065f ("net: add IFF_SKB_TX_SHARED flag to priv_flags")
>>> introduced IFF_SKB_TX_SHARED to protect drivers which are not ready
>>> for getting shared skbs from pktgen sending such frames.
>>>
>>> Some drivers dutifully clear the flag but most don't, even though
>>> they modify the skb or call skb helpers which expect private skbs.
>>>
>>> syzbot has also discovered more sources of shared skbs than just
>>> pktgen (e.g. llc).
>>>
>>> I think defaulting to opt-in is doing more harm than good, those
>>> who care about fast pktgen should inspect their drivers and opt-in.
>>> It's far too risky to enable this flag in ether_setup().
> 
>>> diff --git a/net/core/dev.c b/net/core/dev.c
>>> index 15ac064b5562..476a826bb4f0 100644
>>> --- a/net/core/dev.c
>>> +++ b/net/core/dev.c
>>> @@ -3661,6 +3661,10 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
>>>  	if (unlikely(!skb))
>>>  		goto out_null;
>>>  
>>> +	if (unlikely(skb_shared(skb)) &&
>>> +	    !(dev->priv_flags & IFF_TX_SKB_SHARING))
>>> +		goto out_kfree_skb;  
>>
>> So this will break llc, right ?
> 
> Likely. I haven't checked why LLC thinks it's a good idea to send
> shared skbs, probably convenience.
> 
>> I am sad we are adding so much tests in fast path.
> 
> What's our general stance on shared skbs in the Tx path? If we think
> that it's okay maybe it's time to turn the BUG_ON(shared_skb)s in pskb
> functions into return -EINVALs?

Yes, I think that a WARN_ON_ONCE() should be enough to keep syzbot reports
from alerting us, while not crashing regular hosts.

> 
> The IFF_TX_SKB_SHARING flag is pretty toothless as it stands.
> 

skb_padto() needs to be replaced by something better.
so that skb can be cloned if needed.


static inline int skb_padto(struct sk_buff *skb, unsigned int len)

->

static inline struct sk_buff *skb_padto(struct sk_buff *skb, unsigned int len)
{
}
