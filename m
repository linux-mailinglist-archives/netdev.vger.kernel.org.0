Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46E74AF2A8
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 23:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbfIJVoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 17:44:00 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38577 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfIJVoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 17:44:00 -0400
Received: by mail-pf1-f194.google.com with SMTP id h195so12324562pfe.5
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 14:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=sQSYyZ6dY5ImBEaJbWxj7q4gRwhQ5FcXdtHgInsLvd8=;
        b=zGROtehW1J+fcMy4ZoT9psi14mDgU/DKfgpmcchzQI280wFEvvRd2omj74cO4hTn6z
         WzfDV/xTFlaBf9N5Neg7LfxLv/5aE4JVLOpHyH3SqW6i7niB1b+bnZeDaSf4gGXos9BB
         MA8fHbjHGCxVN+Wyn9kNMGAVJEJ8h8R5c3qJJhBaLzVaVcHcUFeqYyz/M/myYmsIzo4H
         hVCkJeMC9PdeKlYQRxnaQ3kVYaa07pXQGY9QWH/VcjCVB50+Vbg/wDrC5I9dw3StDTrE
         ncwfuZd5OuSHDKZpCEC8BCbOuUOZgxqE82ZyyXMMp9ZX+K7t9/UKevMjiyQAR1SNKUgI
         TLaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=sQSYyZ6dY5ImBEaJbWxj7q4gRwhQ5FcXdtHgInsLvd8=;
        b=g10cfDkyJ6+2m8SK+kHZG5qiZ1DDDoBSMvBrrFxtBElzOTppoQ9xa5QN4yGknn6JTZ
         O8ag60xFVKWWpfAhgjUL+D3KxqFrgsFaFdc+4Fx0zL9pQKiRT3JTHi7lPQGoaC3t65Fi
         kr4HC/pKzDP1sTpdvauOAoZBZDsp6y6bF57dkNUgCjvjtVjboxF1FCQkuOmdvd6pCWe8
         3jtTBZhsEaUA3yCFN9qKrFc9oOUUmmbWh6vn+IS7BtTBmoqG8zl87peSSifUJGYlC5uh
         plPUEoxl6ZFAK7pUXloj87RtC+dUcwYgPHqe/t7nX77ThpsR6WrlyXKrH3FNV0rrPpBf
         Abdg==
X-Gm-Message-State: APjAAAVfqiYmfT2cdKJp//wOoCHOG+xRy4fd6+m8m33CoIoDyDuN7l//
        Lt9Ou1B1i2tOzhRoHe5HM9lJHg==
X-Google-Smtp-Source: APXvYqz7i+KpcvobiFs3H/mQHFRFdjFU8LomOE6wVF/LVsFtQow/YRVtmKDS6iJT5hPV+HdlPfLnwg==
X-Received: by 2002:a17:90a:a604:: with SMTP id c4mr1789664pjq.16.1568151838988;
        Tue, 10 Sep 2019 14:43:58 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id j9sm19895527pfi.128.2019.09.10.14.43.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 14:43:58 -0700 (PDT)
Subject: Re: ixgbe: driver drops packets routed from an IPSec interface with a
 "bad sa_idx" error
To:     Michael Marley <michael@michaelmarley.com>
Cc:     netdev@vger.kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        steffen.klassert@secunet.com
References: <10ba81d178d4ade76741c1a6e1672056@michaelmarley.com>
 <4caa4fb7-9963-99ab-318f-d8ada4f19205@pensando.io>
 <fb63dec226170199e9b0fd1b356d2314@michaelmarley.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <90dd9f8c-57fa-14c7-5d09-207b84ec3292@pensando.io>
Date:   Tue, 10 Sep 2019 22:43:54 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <fb63dec226170199e9b0fd1b356d2314@michaelmarley.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/19 11:45 AM, Michael Marley wrote:
> On 2019-09-09 14:21, Shannon Nelson wrote:
>> On 9/6/19 11:13 AM, Michael Marley wrote:
>>> (This is also reported at 
>>> https://bugzilla.kernel.org/show_bug.cgi?id=204551, but it was 
>>> recommended that I send it to this list as well.)
>>>
>>> I have a put together a router that routes traffic from several 
>>> local subnets from a switch attached to an i82599ES card through an 
>>> IPSec VPN interface set up with StrongSwan. (The VPN is running on 
>>> an unrelated second interface with a different driver.)  Traffic 
>>> from the local interfaces to the VPN works as it should and 
>>> eventually makes it through the VPN server and out to the Internet.  
>>> The return traffic makes it back to the router and tcpdump shows it 
>>> leaving by the i82599, but the traffic never actually makes it onto 
>>> the wire and I instead get one of
>>>
>>> enp1s0: ixgbe_ipsec_tx: bad sa_idx=64512 handle=0
>>>
>>> for each packet that should be transmitted.  (The sa_idx and handle 
>>> values are always the same.)
>>>
>>> I realized this was probably related to ixgbe's IPSec offloading 
>>> feature, so I tried with the motherboard's integrated e1000e device 
>>> and didn't have the problem.  I tried using ethtool to disable all 
>>> the IPSec-related offloads (tx-esp-segmentation, esp-hw-offload, 
>>> esp-tx-csum-hw-offload), but the problem persisted.  I then tried 
>>> recompiling the kernel with CONFIG_IXGBE_IPSEC=n and that worked 
>>> around the problem.
>>>
>>> I was also able to find another instance of the same problem 
>>> reported in Debian at 
>>> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=930443. That 
>>> person seems to be having exactly the same issue as me, down to the 
>>> sa_idx and handle values being the same.
>>>
>>> If there are any more details I can provide to make this easier to 
>>> track down, please let me know.
>>>
>>> Thanks,
>>>
>>> Michael Marley
>>
>> Hi Michael,
>>
>> Thanks for pointing this out.  The issue this error message is
>> complaining about is that the handle given to the driver is a bad
>> value.  The handle is what helps the driver find the right encryption
>> information, and in this case is an index into an array, one array for
>> Rx and one for Tx, each of which have up to 1024 entries.  In order to
>> encode them into a single value, 1024 is added to the Tx values to
>> make the handle, and 1024 is subtracted to use the handle later.  Note
>> that the bad sa_idx is 64512, which happens to also be -1024; if the
>> Tx handle given to ixgbe for xmit is 0, we subtract 1024 from that and
>> get this bad sa_idx value.
>>
>> That handle is supposed to be an opaque value only used by the
>> driver.  It looks to me like either (a) the driver is not setting up
>> the handle correctly when the SA is first set up, or (b) something in
>> the upper levels of the ipsec code is clearing the handle value. We
>> would need to know more about all the bits in your SA set up to have a
>> better idea what parts of the ipsec code are being exercised when this
>> problem happens.
>>
>> I currently don't have access to a good ixgbe setup on which to
>> test/debug this, and I haven't been paying much attention lately to
>> what's happening in the upper ipsec layers, so my help will be
>> somewhat limited.  I'm hoping the the Intel folks can add a little
>> help, so I've copied Jeff Kirsher on this (they'll probably point back
>> to me since I wrote this chunk :-) ).  I've also copied Stephen
>> Klassert for his ipsec thoughts.
>>
>> In the meantime, can you give more details on the exact ipsec rules
>> that are used here, and are there any error messages coming from ixgbe
>> regarding the ipsec rule setup that might help us identify what's
>> happening?
>>
>> Thanks,
>> sln
>
> Hi Shannon,
>
> Thanks for your response!  I apologize, I am a bit of a newbie to 
> IPSec myself, so I'm not 100% sure what is the best way to provide the 
> information you need, but here is the (slightly-redacted) output of 
> swanctl --list-sas first from the server and then from the client:
>
> <servername>: #24, ESTABLISHED, IKEv2, 3cb75c180ee5dc68_i 
> cc7dae551b603bb7_r*
>   local  '<serverip>' @ <serverip>[4500]
>   remote '<clientip>' @ <clientip>[4500]
>   AES_GCM_16-256/PRF_HMAC_SHA2_512/ECP_384
>   established 174180s ago
>   <servername>: #110, reqid 12, INSTALLED, TUNNEL-in-UDP, 
> ESP:AES_GCM_16-256/ECP_384
>     installed 469s ago
>     in  c51a0f11 (-|0x00000064), 1548864 bytes, 19575 packets, 6s ago
>     out c3bd9741 (-|0x00000064), 23618807 bytes, 22865 packets,     7s 
> ago
>     local  0.0.0.0/0 ::/0
>     remote 0.0.0.0/0 ::/0
>
> <clientname>: #1, ESTABLISHED, IKEv2, 3cb75c180ee5dc68_i* 
> cc7dae551b603bb7_r
>   local  '<clientip>' @ <clientip>[4500]
>   remote '<serverip>' @ <serverip>[4500]
>   AES_GCM_16-256/PRF_HMAC_SHA2_512/ECP_384
>   established 174013s ago
>   <clientname>: #54, reqid 1, INSTALLED, TUNNEL-in-UDP, 
> ESP:AES_GCM_16-256/ECP_384
>     installed 303s ago, rekeying in 2979s, expires in 3657s
>     in  c3bd9741 (-|0x00000064), 23178523 bytes, 20725 packets,     0s 
> ago
>     out c51a0f11 (-|0x00000064), 1429124 bytes, 17719 packets, 0s ago
>     local  0.0.0.0/0 ::/0
>     remote 0.0.0.0/0 ::/0
>
> It might also be worth mentioning that I am using an xfrm interface to 
> do "regular" routing rather than the policy-based routing that 
> StrongSwan/IPSec normally uses. If there is anything else that would 
> help more, I would be happy to provide it.
>
> Just to be clear though, I'm not trying to run IPSec on the ixgbe 
> interface at all.  The ixgbe adapter is being used to connect the 
> router to the switch on the LAN side of the network.  IPSec is running 
> on the WAN interface without any hardware acceleration (besides 
> AES-NI).  The problem occurs when a computer on the LAN tries to 
> access the WAN.  The outgoing packets work as expected and the 
> incoming packets are routed back out through the ixgbe device toward 
> the LAN client, but the driver drops the packets with the sa_idx error.
>
> I hope this helps.
>
> Thanks,
>
> Michael

I'm not familiar with StrongSwan and its configurations, but I'm 
guessing that if you didn't expressly enable it, perhaps StrongSwan 
enabled the ipsec offload capability.  I would suggest turning it off to 
at least get you passed the immediate issue.  If there isn't an obvious 
configuration knob in StrongSwan, perhaps you can at least use ethtool 
to disable the offload, which should be off be default anyway.

You can check it with "ethtool -k ethX | grep esp-hw-offload" and see if 
it is set.  You can disable it with "ethtool -K ethX esp-hw-offload off"

Meanwhile, can you please send the output of the following commands:
uname -a
ip xfrm s
ip xfrm p
dmesg | grep ixgbe

And any other /var/log/syslog or /var/log/messages that look suspicious 
and might give any more insight to what's happening.

Thanks,
sln

