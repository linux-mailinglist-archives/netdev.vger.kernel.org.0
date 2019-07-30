Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5887AFBA
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 19:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729631AbfG3RXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 13:23:34 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:55171 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfG3RXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 13:23:34 -0400
Received: by mail-wm1-f51.google.com with SMTP id p74so57890172wme.4
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 10:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CebsPQQ+A/tAcok2X5TEltsBQZm10wgsb2ydNwe/jUE=;
        b=ciKx901FLxMho74O4qfh1g8mYd8eUybnoMlvQTYTurAwU1Rmi/lwC7+o9oHVmnBKCb
         2hEpZpZOwwCJLhJa8ql5I/6EzFULyd1ZsEdHUYQmJ+FX9D2Bi1ZZ0suUvjZwiP/vWlCk
         3FUPdxNp1z1MBU8cRNSbMm99sTR78J0R4GFa8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CebsPQQ+A/tAcok2X5TEltsBQZm10wgsb2ydNwe/jUE=;
        b=B7MYS1RxO4HXxzDdlXzqvyi8nPICmi6udLAsdu8PftMKQ0Rj5Bc7Hj24eRXIDb2c0j
         iNN4ZNncK0X81OYBBdt16B1CmQB7Uluu60pg7xvCOGVfsGrE/6AkB6rN935oWMNwOdNT
         BwxFJtDy7QphD2Xnx0ydN/gez4YbGeks9WfFLMgwFNkuEfvmynP4Hvkny1JW0aUtymmC
         MCtVnTEp9byy3UxfBdSdChcGUmaoFagyYl0a3gavNM9kD3PsMsyioi0UX+LzaEDGjLM4
         Svql31uGC+i5I6STEyuRTEGeetIZYTygOXodBAGU7vqkgA6K+z6QdzoybAgQJUN32CYD
         BqgQ==
X-Gm-Message-State: APjAAAUs7Gzw+3o/xzUv9VCW62XW7wGAu3Tp0Ci/m5pv7zhJbljS2NVk
        NQsOpcGSyoODEqkfDuaT2wdxVw==
X-Google-Smtp-Source: APXvYqz/ZWjEksJjIOZzVc+blL525yUYPR265Dh5tgpKjHoOpfH/wSPcqpGqsZMQbPzRBHSxNwad4A==
X-Received: by 2002:a7b:cc86:: with SMTP id p6mr98188078wma.123.1564507412017;
        Tue, 30 Jul 2019 10:23:32 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x17sm48628704wrq.64.2019.07.30.10.23.31
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 10:23:31 -0700 (PDT)
Subject: Re: [PATCH net] net: bridge: mcast: don't delete permanent entries
 when fast leave is enabled
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
References: <20190730112100.18156-1-nikolay@cumulusnetworks.com>
 <20190730.101811.1836331521043535108.davem@davemloft.net>
 <a3de94a3-5976-9035-69bf-2aee6454b45e@cumulusnetworks.com>
Message-ID: <651caecf-00dc-cb1a-1908-cb606f263843@cumulusnetworks.com>
Date:   Tue, 30 Jul 2019 20:23:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <a3de94a3-5976-9035-69bf-2aee6454b45e@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/07/2019 20:21, Nikolay Aleksandrov wrote:
> On 30/07/2019 20:18, David Miller wrote:
>> From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
>> Date: Tue, 30 Jul 2019 14:21:00 +0300
>>
>>> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
>>> index 3d8deac2353d..f8cac3702712 100644
>>> --- a/net/bridge/br_multicast.c
>>> +++ b/net/bridge/br_multicast.c
>>> @@ -1388,6 +1388,9 @@ br_multicast_leave_group(struct net_bridge *br,
>>>  			if (!br_port_group_equal(p, port, src))
>>>  				continue;
>>>  
>>> +			if (p->flags & MDB_PG_FLAGS_PERMANENT)
>>> +				break;
>>> +
>>
>> Like David, I also don't understand why this can be a break.  Is it because
>> permanent entries are always the last on the list?  Why will there be no
>> other entries that might need to be processed on the list?
>>
> 
> The reason is that only one port can match. See the first clause of br_port_group_equal,
> that port can participate only once. We could easily add a break statement in the end
> when a match is found and it will be correct. Even in the presence of MULTICAST_TO_UNICAST
> flag, the port must match and can be added only once.
> 

Like I wrote in the patch I plan to re-work that code in net-next to remove the
duplication and make it more understandable to avoid such confusions. This code
will be functionally equivalent if I put continue there, we'll just walk over
all of them even after a match or permanent are found. There can only be one
match though as I said, so walking the rest of the ports is a waste.


