Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F588195E79
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgC0TSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:18:01 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40325 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgC0TSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 15:18:01 -0400
Received: by mail-wm1-f65.google.com with SMTP id a81so13619181wmf.5
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 12:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9AWCR6Gv+vaim3uVH7XizZqHvTEld06agedU8WMlewU=;
        b=W1w4GDSC82nD0MvK9tSWzwhtK7WkkTtYsgGIs2czpJUlP42SYhSPoeUzjSCe4YftZB
         7yTLsMS4ifo79buA9u0mZbv9oMyaIPQWXGaPpVCji535pXwo244bhdsrvhtE2k2cPQ5H
         xcbBtvHAndKmCpUnVNhynah9scuL5hMnjjjdEXJ8IUPUQwXy5lLvCaMoz6onipfTFeVj
         Pp/g7A7Cc9xYfzJfyfismptyiMnUpFk6csdJ07gDcNh6VxTpNO4o5bUpLkWEKEPhLt96
         8R8kPv6rBUnhbFJfNfzQQ8PXq3eA6rPD8shMneJJqWIWleuTZQen3+MfLc1FpjlaulUN
         835A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9AWCR6Gv+vaim3uVH7XizZqHvTEld06agedU8WMlewU=;
        b=s9vDfWMrHOFPSVP2Yy6ETQFGT7X5yCi8lon2pvu3HraKNk6k6IkUSwwvklrs07oO70
         JUB/jiGXA9VZJu65/X7Jb4Gukddpoqw0B+qC0j/OBhE31+uv0CEBZXga9WcbCxEZhIx3
         UCHvGMPqUadTGZ2O4ujuMVK8nJfL9AYkOYZk4tweIDTURdshBs3RRhhwuRO6lTGpfsYK
         8HTKlF6Hj7Tya8pqFs/cn9Fks8GlD2uoES+YFAs5+ynO40XmVSBTev69GlIevseiu28P
         w752AVfWTf5sHmkTeyjOKPsLDK4xag/6GqBAP1r8Xg7QJ/jnBccjBuRxVKotJJHm00cu
         FeXw==
X-Gm-Message-State: ANhLgQ0x1WMJlxkmwiZAiedcFKwqBTll23jj/EqcnawCOMF2zquY7W/8
        3LCcT72vtWWTNvVB7++v3SdQ+kHv
X-Google-Smtp-Source: ADFU+vsCbjgQWZclYlKwNQZQy3QOJMX2P75lhVtr7lGtHHqCKP+2HB/THkh0FUhuDKCcjmb8PVW8Vw==
X-Received: by 2002:a7b:c3cd:: with SMTP id t13mr140720wmj.15.1585336677870;
        Fri, 27 Mar 2020 12:17:57 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:9d76:401f:98cb:c084? (p200300EA8F2960009D76401F98CBC084.dip0.t-ipconnect.de. [2003:ea:8f29:6000:9d76:401f:98cb:c084])
        by smtp.googlemail.com with ESMTPSA id 9sm8794267wmm.6.2020.03.27.12.17.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2020 12:17:57 -0700 (PDT)
Subject: Re: [PATCH net] r8169: fix multicast tx issue with macvlan interface
To:     Eric Dumazet <edumazet@google.com>,
        Charles Daymand <charles.daymand@wifirst.fr>
Cc:     netdev <netdev@vger.kernel.org>
References: <20200327090800.27810-1-charles.daymand@wifirst.fr>
 <0bab7e0b-7b22-ad0f-2558-25602705e807@gmail.com>
 <d7a0eca8-15aa-10da-06cc-1eeef3a7a423@gmail.com>
 <CANn89iKA8k3GyxCKCJRacB42qcFqUDsiRhFOZxOQ7JCED0ChyQ@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <42f81a4a-24fc-f1fb-11db-ea90a692f249@gmail.com>
Date:   Fri, 27 Mar 2020 20:17:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CANn89iKA8k3GyxCKCJRacB42qcFqUDsiRhFOZxOQ7JCED0ChyQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.03.2020 19:52, Eric Dumazet wrote:
> On Fri, Mar 27, 2020 at 10:41 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> On 27.03.2020 10:39, Heiner Kallweit wrote:
>>> On 27.03.2020 10:08, Charles Daymand wrote:
>>>> During kernel upgrade testing on our hardware, we found that macvlan
>>>> interface were no longer able to send valid multicast packet.
>>>>
>>>> tcpdump run on our hardware was correctly showing our multicast
>>>> packet but when connecting a laptop to our hardware we didn't see any
>>>> packets.
>>>>
>>>> Bisecting turned up commit 93681cd7d94f
>>>> "r8169: enable HW csum and TSO" activates the feature NETIF_F_IP_CSUM
>>>> which is responsible for the drop of packet in case of macvlan
>>>> interface. Note that revision RTL_GIGA_MAC_VER_34 was already a specific
>>>> case since TSO was keep disabled.
>>>>
>>>> Deactivating NETIF_F_IP_CSUM using ethtool is correcting our multicast
>>>> issue, but we believe that this hardware issue is important enough to
>>>> keep tx checksum off by default on this revision.
>>>>
>>>> The change is deactivating the default value of NETIF_F_IP_CSUM for this
>>>> specific revision.
>>>>
>>>
>>> The referenced commit may not be the root cause but just reveal another
>>> issue that has been existing before. Root cause may be in the net core
>>> or somewhere else. Did you check with other RTL8168 versions to verify
>>> that it's indeed a HW issue with this specific chip version?
>>>
>>> What you could do: Enable tx checksumming manually (via ethtool) on
>>> older kernel versions and check whether they are fine or not.
>>> If an older version is fine, then you can start a new bisect with tx
>>> checksumming enabled.
>>>
>>> And did you capture and analyze traffic to verify that actually the
>>> checksum is incorrect (and packets discarded therefore on receiving end)?
>>>
>>>
>>>> Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
>>>> Signed-off-by: Charles Daymand <charles.daymand@wifirst.fr>
>>>> ---
>>>>  net/drivers/net/ethernet/realtek/r8169_main.c | 3 +++
>>>>  1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/net/drivers/net/ethernet/realtek/r8169_main.c b/net/drivers/net/ethernet/realtek/r8169_main.c
>>>> index a9bdafd15a35..3b69135fc500 100644
>>>> --- a/net/drivers/net/ethernet/realtek/r8169_main.c
>>>> +++ b/net/drivers/net/ethernet/realtek/r8169_main.c
>>>> @@ -5591,6 +5591,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>>              dev->vlan_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
>>>>              dev->hw_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
>>>>              dev->features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
>>>> +            if (tp->mac_version == RTL_GIGA_MAC_VER_34) {
>>>> +                    dev->features &= ~NETIF_F_IP_CSUM;
>>>> +            }
>>>>      }
>>>>
>>>>      dev->hw_features |= NETIF_F_RXALL;
>>>>
>>>
>>
>> After looking a little bit at the macvlen code I think there might be an
>> issue in it, but I'm not sure, therefore let me add Eric (as macvlen doesn't
>> seem to have a dedicated maintainer).
>>
>> r8169 implements a ndo_features_check callback that disables tx checksumming
>> for the chip version in question and small packets (due to a HW issue).
>> macvlen uses passthru_features_check() as ndo_features_check callback, this
>> seems to indicate to me that the ndo_features_check callback of lowerdev is
>> ignored. This could explain the issue you see.
>>
> 
> macvlan_queue_xmit() calls dev_queue_xmit_accel() after switching skb->dev,
> so the second __dev_queue_xmit() should eventually call the real_dev
> ndo_features_check()
> 
Thanks, Eric. There's a second path in macvlan_queue_xmit() calling
dev_forward_skb(vlan->lowerdev, skb). Does what you said apply also there?

Still I find it strange that a tx hw checksumming issue should affect multicasts
only. Also the chip version in question is quite common and I would expect
others to have hit the same issue.
Maybe best would be to re-test on the affected system w/o involving macvlen.

> 
> 
>> Would be interesting to see whether it fixes your issue if you let the
>> macvlen ndo_features_check call lowerdev's ndo_features_check. Can you try this?
>>
>> By the way:
>> Also the ndo_fix_features callback of lowerdev seems to be ignored.

