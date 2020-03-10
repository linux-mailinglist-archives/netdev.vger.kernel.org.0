Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6421801CB
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgCJP16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:27:58 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]:37962 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgCJP15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:27:57 -0400
Received: by mail-qt1-f174.google.com with SMTP id e20so9945053qto.5
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 08:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IgrTYteBKTbEmOfaI7gCgsUk4gIf0PC9kOfOWYsikcw=;
        b=WCjs9HdE7hsQSl4+kXOFKDADFzCFOkU4JSwFJ9HSEx6pyT/m/CkgbZ9fpCA/jknzWW
         3MmSUchVKFqtPyQ0oc482bJcND3X9Vmr/azqsRzM8VeWshkvhv8jrJJpOoxXljOITwSJ
         Dk6FCKtEjs4GKzvZyVE1cC1ZCJG6R1rxy0n3f3HAot131mct+jST3HIDrkWDsmqykBGw
         sAr8I7XXK2+EbjXfQQ0is2p5INUNXE8pBUqvCjLfR0WWv/lVF1ioXnUVPGXcJvQJizmU
         JSFZOVGjVzBmJWCj4hNIcYesIPu5j7LE8qo8+5yi/Kjqec7FqD/PUEEHxw7fqmesSin7
         HOOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IgrTYteBKTbEmOfaI7gCgsUk4gIf0PC9kOfOWYsikcw=;
        b=N1tGI3UQHJ7rB54YTT2gMFN7DTDaJyNZBTCOvmgllTEUMhw6R3D18pnaameeCiZM7/
         bdJarmyogjrS/Z5Zf/POJA70JzynodJtghcV//PF0717x+NCaDCDZr3uTfFTU4LTPzng
         awzPnPhK9BnuJmqjr8E17Be1gG1jMw9bfs9dbKHgi7F7gE41N6w0Ol4ptS9Ql9qSWhc1
         kPgjhKb2xLO6n7q7POrOdRyJQwhKmFHPwz5/6vc3zoCwv1gnsBcB0a8akXRGF8Kqxncs
         buX/Dx/4Pqv05LE5ZRshDTEMS5qxOFxh8Tzexvu37dDiYHaZSyKWgMuGP6C1kUfeKRL/
         pROw==
X-Gm-Message-State: ANhLgQ2EyZtIM0pj+LbLoagBTNLyf/gNRB6nl6v+TI10Fl063Fx8ChU3
        Uobob6cxKTBEtF90e6AEtiE=
X-Google-Smtp-Source: ADFU+vunJX0vhEiGWr+cF6nyUd9Wl4qRvukRmkuzYyhzFQ9QRI9vRfCkaeMZ4NbBxWu8X8beLeF0Ag==
X-Received: by 2002:ac8:4442:: with SMTP id m2mr19169229qtn.86.1583854076499;
        Tue, 10 Mar 2020 08:27:56 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b876:5d04:c7e4:4480? ([2601:282:803:7700:b876:5d04:c7e4:4480])
        by smtp.googlemail.com with ESMTPSA id g8sm15181301qke.1.2020.03.10.08.27.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 08:27:55 -0700 (PDT)
Subject: Re: IPv6 regression introduced by commit
 3b6761d18bc11f2af2a6fc494e9026d39593f22c
To:     Alarig Le Lay <alarig@swordarmor.fr>
Cc:     netdev@vger.kernel.org, jack@basilfillan.uk,
        Vincent Bernat <bernat@debian.org>
References: <20200305081747.tullbdlj66yf3w2w@mew.swordarmor.fr>
 <d8a0069a-b387-c470-8599-d892e4a35881@gmail.com>
 <20200308105729.72pbglywnahbl7hs@mew.swordarmor.fr>
 <27457094-b62a-f029-e259-f7a274fee49d@gmail.com>
 <20200310103541.aplhwhfsvcflczhp@mew.swordarmor.fr>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <92f8ca32-af23-effd-55d8-8d1065f644f8@gmail.com>
Date:   Tue, 10 Mar 2020 09:27:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200310103541.aplhwhfsvcflczhp@mew.swordarmor.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/20 4:35 AM, Alarig Le Lay wrote:
> On dim.  8 mars 20:15:14 2020, David Ahern wrote:
>> If you are using x86 based CPU you can do this:
>>     perf probe ip6_dst_alloc%return ret=%ax
>>
>>     perf record -e probe:* -a -g -- sleep 10
>>     --> run this during the flapping
>>
>>     perf script
> 
> For this probe I see that: https://paste.swordarmor.fr/raw/pt9b

none of the dst allocations are failing.

Are the failing windows always ~30 seconds long?


> 
>> this will show if the flapping is due to dst alloc failures.
>>
>> Other things to try:
>>     perf probe ip6_dst_gc
>>     perf stat -e probe:* -a -I 1000
>>     --> will show calls/sec to running dst gc
> 
> https://paste.swordarmor.fr/raw/uBnm

This is not lining up with dst allocations above. gc function is only
invoked from dst_alloc, and for ipv6 all dst allocations go through
ip6_dst_alloc.

> 
>>     perf probe __ip6_rt_update_pmtu
>>     perf stat -e probe:* -a -I 1000
>>     --> will show calls/sec to mtu updating
> 
> This probe always stays at 0 even when the NDP is failing.
>  
>>     perf probe rt6_insert_exception
>>     perf state -e probe:* -a -I 1000
>>     --> shows calls/sec to inserting exceptions
> 
> Same as the last one.

so no exception handling.

How many ipv6 sockets are open? (ss -6tpn)

How many ipv6 neighbor entries exist? (ip -6 neigh sh)
