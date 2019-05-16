Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92AF620DAC
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 19:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbfEPRDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 13:03:20 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44749 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbfEPRDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 13:03:19 -0400
Received: by mail-pg1-f195.google.com with SMTP id z16so1849216pgv.11
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 10:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rWBPoxSBCFyoquf40F4fxRrlZ4eMuCB4vMLWv5G+HUM=;
        b=Q3YxJ5f0Y+1+mvDAldCMbWmR8KwBMHsCCPMmDYFlCjCRFCMxOvNvaFcEYruWDoouMW
         Lxsbm9CO5hUd6Yy1Km2IVo5Z6YjP+9wNX+wIFUADgnrbVfNIfWWjGsSjqChCPancTnVN
         9T8Urx0RpIzc5URZiGpjLXtpEQwn7zIuo0NdbSxmiIb41npgzRAn41yR7IcsWcN+cTjK
         Jw3rfbWiWrKaieqRjaH/7V+DYZJynlJKkl+wsh8XxYIF4z6FHGfSz/4iZbzv9NwLZP9L
         IGi84X6XyI+1uyfuKcoCSVV4vwAo3TRn0IMq2JNGDqvP8L1BzHn+HBaefonLvzlT3I+t
         o57w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rWBPoxSBCFyoquf40F4fxRrlZ4eMuCB4vMLWv5G+HUM=;
        b=t6WZ9SDKZT1fCLI/Wl0Yfkwk9XwGZXiiXpf7LYy16yuIqUVv5VHPCxKpenN9An0soh
         1DvVI75Om3L6ptan1a6BeF0wmbzu1x+45Gwp7OjPWX+CJwoRIH9U5I4xMdVmGl49HIvn
         i5haq/X862bPFSksVv2Q5nslPyLsIJ825lgORqQOuXQ1O9E9BuNhQGlAlIxS6fFWPqXf
         QSG1Ic/OddXrLW29kLU+IAhTZQsDdSt34ATooP0IFns/UDtp+m3osdKS6VgCV95klKY7
         1nbutv1WAEQ6yOi+gcMcHGSn8HYCRMY8muoXiIisMpIg+UVaNHHCBQXt93Ywr0nhr2l9
         xLcQ==
X-Gm-Message-State: APjAAAXvYxborvSGzxqMmLEBYJpiZBg/MOpoKxXj46KQF7xhMVP1fsNp
        tzKUSt5MwIr6gldsoya4kCesu+fG
X-Google-Smtp-Source: APXvYqxJ7NdWr1V46lW1l0JAZPMFk6RKLgTSJKCGVbzSvIURq6UyDRMh9LcolGL+BzmHYGC/AEMdTA==
X-Received: by 2002:a63:6bc3:: with SMTP id g186mr39061323pgc.21.1558026198768;
        Thu, 16 May 2019 10:03:18 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id e78sm14356310pfh.134.2019.05.16.10.03.16
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 10:03:17 -0700 (PDT)
Subject: Re: Kernel UDP behavior with missing destinations
To:     Adam Urban <adam.urban@appleguru.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>
References: <CABUuw65R3or9HeHsMT_isVx1f-7B6eCPPdr+bNR6f6wbKPnHOQ@mail.gmail.com>
 <CAF=yD-Kdb4UrgzOJmeEhiqmeKndb9-X5WwttR-X4xd5m7DE5Dw@mail.gmail.com>
 <0d50023e-0a3b-b92b-59d6-39d0c02fa182@gmail.com>
 <18aefee7-4c47-d330-c6c1-7d1442551fa6@gmail.com>
 <CABUuw67crf5yb0G_KRR94WLBP8YYLgABBgv1SFW0SvKB_ntK4w@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1f6a6c3f-d723-4739-da77-58a55cfa2170@gmail.com>
Date:   Thu, 16 May 2019 10:03:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CABUuw67crf5yb0G_KRR94WLBP8YYLgABBgv1SFW0SvKB_ntK4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/16/19 9:32 AM, Adam Urban wrote:
> Eric, thanks. Increasing wmem_default from 229376 to 2293760 indeed
> makes the issue go away on my test bench. What's a good way to
> determine the optimal value here? I assume this is in bytes and needs
> to be large enough so that the SO_SNDBUF doesn't fill up before the
> kernel drops the packets. How often does that happen?

You have to count the max number of arp queues your UDP socket could hit.

Say this number is X

Then wmem_default should be set  to X * unres_qlen_bytes + Y

With Y =  229376  (the default  wmem_default)

Then, you might need to increase the qdisc limits.

If no arp queue is active, all UDP packets could be in the qdisc and might hit sooner
the qdisc limit, thus dropping packets on the qdisc.

(This is assuming your UDP application can blast packets at a rate above the link rate)

> 
> On Thu, May 16, 2019 at 12:14 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>>
>> On 5/16/19 9:05 AM, Eric Dumazet wrote:
>>
>>> We probably should add a ttl on arp queues.
>>>
>>> neigh_probe() could do that quite easily.
>>>
>>
>> Adam, all you need to do is to increase UDP socket sndbuf.
>>
>> Either by increasing /proc/sys/net/core/wmem_default
>>
>> or using setsockopt( ... SO_SNDBUF ... )
>>
