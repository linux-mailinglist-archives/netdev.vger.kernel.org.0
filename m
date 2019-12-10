Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46EE7119276
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 21:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfLJUxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 15:53:03 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37526 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfLJUxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 15:53:03 -0500
Received: by mail-lf1-f68.google.com with SMTP id b15so14860704lfc.4
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 12:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fmEDmfNgnyzrZ9VU2XdpzBoL/tPjn0qLVvtc+e2r5Oc=;
        b=e/m83JTC4nzbv0VlJKT759lat2DxFAV1JO9gV9wxjF0R5Yzaj5KEgMvHgSe7iDlWtl
         9NYuG/xynOebC8eY6gGKmUGR/l7TG6X6zk0rl1lB5GWhSPS/WA7gp+KvLifJuRLlXllq
         LRzSl+cE0UrQUNwU+f/m7IMF3aYK6jefaQZr0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fmEDmfNgnyzrZ9VU2XdpzBoL/tPjn0qLVvtc+e2r5Oc=;
        b=oG0NiKOCBL8HfUw46cmW9DBIL1vEmhDyjIOm32TIXA3575UWP2JBpXqSS1jfe8UrlO
         bElm2dT6X869wD1rVFNjxDdHAqFXPw0WHRTC7PFDcB44alj6t379znFVS8xY0Jfc43nZ
         sWASlU0tc2TxDGuNtHABJNIyqIqBjtSopTYRuwfommxVDjx5Rgx7TdF7eWOQYOgIDa4P
         hywUcjST2ENg6GYz1I1m8IoCb2FNKEhFnUkBo12iUEe3bFoQHfYRgV6vZZJsrbgaHzMq
         S8AT5SqE+p1r6fZELMzG9rEzIA32cqp9F9xauX3alxOrZ4hV7LXAZKRUrHMtwS8f6/lo
         U7nQ==
X-Gm-Message-State: APjAAAUfAcz4yru+VCxslmJDRyYoXEW+PjT5wW2M5TsFzMHmGMuYPuj2
        tmW4u5G5+P2iZXzriu3aLtXwQw==
X-Google-Smtp-Source: APXvYqztVGhd39FvfMSc3HRG4lNOgzYmTNPv5ZkG2/05mrVJPhxKKzf0q98tjbnD0vmM8sQuuLFIWg==
X-Received: by 2002:a19:6d13:: with SMTP id i19mr20713750lfc.6.1576011181363;
        Tue, 10 Dec 2019 12:53:01 -0800 (PST)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b63sm1829309lfg.79.2019.12.10.12.53.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 12:53:00 -0800 (PST)
Subject: Re: [PATCH net-next] net: bridge: add STP xstats
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20191209230522.1255467-1-vivien.didelot@gmail.com>
 <a3b8e24d-5152-7243-545f-8a3e5fbaa53a@cumulusnetworks.com>
 <20191210143931.GF1344570@t480s.localdomain>
 <2f4e351c-158a-4f00-629f-237a63742f66@cumulusnetworks.com>
 <20191210151047.GB1423505@t480s.localdomain>
 <1aa8b6e4-6a73-60b0-c5fb-c0dfa05e27e6@cumulusnetworks.com>
 <20191210153441.GB1429230@t480s.localdomain>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <40090370-4d81-0ea9-e81a-da59534161b7@cumulusnetworks.com>
Date:   Tue, 10 Dec 2019 22:52:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191210153441.GB1429230@t480s.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/2019 22:34, Vivien Didelot wrote:
> On Tue, 10 Dec 2019 22:15:26 +0200, Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:
>>>>>> Why do you need percpu ? All of these seem to be incremented with the
>>>>>> bridge lock held. A few more comments below.
>>>>>
>>>>> All other xstats are incremented percpu, I simply followed the pattern.
>>>>>
>>>>
>>>> We have already a lock, we can use it and avoid the whole per-cpu memory handling.
>>>> It seems to be acquired in all cases where these counters need to be changed.
>>>
>>> Since the other xstats counters are currently implemented this way, I prefer
>>> to keep the code as is, until we eventually change them all if percpu is in
>>> fact not needed anymore.
>>>
>>> The new series is ready and I can submit it now if there's no objection.
>>
>> There is a reason other counters use per-cpu - they're incremented without any locking from fast-path.
>> The bridge STP code already has a lock which is acquired in all of these paths and we don't need
>> this overhead and the per-cpu memory allocations. Unless you can find a STP codepath which actually
>> needs per-cpu, I'd prefer you drop it.
> 
> Ho ok I understand what you mean now. I'll drop the percpu attribute.
> 
> 
> Thanks,
> 
> 	Vivien
> 

Great, thanks again.
I think it's clear, but I'll add just in case to avoid extra work - you can drop
the dynamic memory allocation altogether and make the struct part of net_bridge_port.

Cheers,
 Nik

