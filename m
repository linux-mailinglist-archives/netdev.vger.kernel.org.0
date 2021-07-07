Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B0F3BEBC8
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 18:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhGGQIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 12:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbhGGQIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 12:08:44 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFC4C061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 09:06:03 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id u11so3951837oiv.1
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 09:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oudRBq1Rk5egeBH3NzVNys300tAESIWWoAvTqh5WVCw=;
        b=ea/r1/bgBoWAEymVYt1BFUTUO/wpmVaE1x/8J8dSDy5GqeKSOnLQhyx7TRJklHmKKq
         iq6nt0PnJlfcUCXQILOmai+z3nteWAdS+/u41zYyLOHwSiOGvdOqXILTKeGk2bpOAVgC
         LbRRKTSpyQB+01MA9beUHVubNoOYRZBUL1quLFa/hxpqpP+ZrHVBQWMgBUVoFduDqMWN
         rQlojYrl9q4Ewcz7VfqBJ6GB74Fu+ST+IkHklRVMWxjDyxGqTn89BgDtDRKbZz68GgTX
         xUH1Ex5dPI8zF+LVOmUx3I05eb3EOnHZEErLpsP6NoNImxFNBPOhLYzDH6Z7h48ooIuX
         a35w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oudRBq1Rk5egeBH3NzVNys300tAESIWWoAvTqh5WVCw=;
        b=oA8MnIHBqu2K/u9ZleP5mUaclLt4EESgwD5VPqLUf3lThzLIY4oAtdDbWxjNrE+Rw8
         92zaHwIM8VESpmE4MC/fWLDdgqtktvTAwcKxTRDxzNSWL2OLXZqFMKX+jgChjTINiE+v
         q+YtcQhwCHJ7pEtXJg2hsXwvYNOruXajyhIbh6wx1+D/IGIWGR2UPui3k/xUN7THDivV
         0EBdsWAtg0EwSBnjP8Prk1CDtZrg965D2i8QpkcYlMlWbNyj23aaZiM/XkamXoj4Byal
         xi1pu8ODh2wTfpm/+nW45AfH+Sls+1Tl8zti50fuDes6JJOwxejUwPEOl8d89D/xZz2R
         kIhQ==
X-Gm-Message-State: AOAM532KWrZwOmuMWxi3+wpS4KcyOCK7ABdZ1TPwLBaKiRkggBtuZoSV
        tkZOaJweV0+e0EQQqOa1Ug0=
X-Google-Smtp-Source: ABdhPJyJJzmVCRvzQ/TRpSU2RSO6JY6ZOiBPHZPxJHWxrnGp5qCMYPnY/1xnAr9DsRde55IsHLKWfA==
X-Received: by 2002:a05:6808:b33:: with SMTP id t19mr275440oij.88.1625673962507;
        Wed, 07 Jul 2021 09:06:02 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id j194sm1995655oih.43.2021.07.07.09.06.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 09:06:02 -0700 (PDT)
Subject: Re: Fw: [Bug 213669] New: PMTU dicovery not working for IPsec
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>
References: <20210707070752.47946d92@hermes.local>
 <3957720a-874b-6e89-e58c-3e16dc4570af@novek.ru>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <05ff89e1-1df1-a4df-14f1-ad6b15550481@gmail.com>
Date:   Wed, 7 Jul 2021 10:06:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3957720a-874b-6e89-e58c-3e16dc4570af@novek.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/21 9:52 AM, Vadim Fedorenko wrote:
> On 07.07.2021 15:07, Stephen Hemminger wrote:
>>
>>
>> Begin forwarded message:
>>
>> Date: Wed, 07 Jul 2021 09:08:07 +0000
>> From: bugzilla-daemon@bugzilla.kernel.org
>> To: stephen@networkplumber.org
>> Subject: [Bug 213669] New: PMTU dicovery not working for IPsec
>>
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=213669
>>
>>              Bug ID: 213669
>>             Summary: PMTU dicovery not working for IPsec
>>             Product: Networking
>>             Version: 2.5
>>      Kernel Version: 5.12.13
>>            Hardware: x86-64
>>                  OS: Linux
>>                Tree: Mainline
>>              Status: NEW
>>            Severity: high
>>            Priority: P1
>>           Component: IPV4
>>            Assignee: stephen@networkplumber.org
>>            Reporter: marek.gresko@protonmail.com
>>          Regression: No
>>
>> Hello,
>>
>> I have two sites interconnected using ipsec (libreswan)
>>
>> the situation is as follows:
>>
>> X <=> (a) <=> (Internet) <=> (b) <=> Y
>>
>> So you have two gateways a and b connected to the internet and their
>> corresponding internal subnets X and Y. The gateway a is connected to the
>> provider p using pppoe. The ipsec tunnel is created between a and b to
>> interconnect subnets X and Y. When gateway b with internal address y
>> itself is
>> communication to the gateway a using its internal address x. Addresses
>> x and y
>> are defined by leftsourceif and rightsourceip in the libreswan
>> configuration,
>> you get this behavior:
>>
>> b# ping -M do x -s 1392 -c 1
>> PING x (x.x.x.x) 1392(1420) bytes of data.
>>
>> --- ping statistics ---
>> 1 packets transmitted, 0 received, 100% packet loss, time 0ms
>>
>> b# ping -M do a -s 1460 -c 3
>> PING a (a.a.a.a) 1460(1488) bytes of data.
>>  From p (p.p.p.p) icmp_seq=1 Frag needed and DF set (mtu = 1480)
>> ping: local error: message too long, mtu=1480
>> ping: local error: message too long, mtu=1480
>>
>> --- ping statistics ---
>> 3 packets transmitted, 0 received, +3 errors, 100% packet loss, time
>> 2014ms
>>
>> b# ping -M do x -s 1392 -c 3
>> PING x (x.x.x.x) 1392(1420) bytes of data.
>> ping: local error: message too long, mtu=1418
>> ping: local error: message too long, mtu=1418
>> ping: local error: message too long, mtu=1418
>>
>> --- ping statistics ---
>> 3 packets transmitted, 0 received, +3 errors, 100% packet loss, time
>> 2046ms
>>
>>
>> Legend:
>> x.x.x.x is an inner ip address if the gateway (a) (or x from the inside).
>> a.a.a.a is an outer address of the gateway (a).
>> p.p.p.p is some address in the provider's network of the (a) side.
>>
>> So definitely the ipsec tunnel is aware of the mtu only when some outer
>> communication is in progress. The inner communication itself is not
>> aware of
>> icmp packets using for PMTU discovery. I had also a situation when
>> also the
>> outer pings did not help the ipsec to be aware of the MTU and after
>> reboot it
>> started to behave like discribed again.
>>
>> Did I describe it understandably or should I clarify things?
>>
>> Thanks
>>
>> Marek
>>
> 
> Looks like I didn't cover one more case in my MTU patch series. I'll try
> to look
> deeper


pmtu.sh test script covers xfrm (esp) cases with vti devices. Could add
more ipsec test cases to it.

