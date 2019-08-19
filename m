Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14F769518A
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 01:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbfHSXMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 19:12:31 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35504 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728204AbfHSXMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 19:12:30 -0400
Received: by mail-lj1-f196.google.com with SMTP id l14so3319219lje.2
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 16:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VZM5Ad7JAfvEpYFsvCZGZjteFpOYwn1L2UozgkN6qk0=;
        b=GPo5ayisSQ6V5l6ARreCKIbWwSdiur9iAUhgl8Gu9cJa76pK2twMeS3ORtYLX9oVoL
         efxcwwkTDVst7QnfeLYkkRB6JStIhjpMfxQJFF4IPzc6F7NVBFXFQ9jBlaOAjR0cto/J
         xZ6Zn24qrlrWHeLeIrP+hTW300pKWc+cni1HA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VZM5Ad7JAfvEpYFsvCZGZjteFpOYwn1L2UozgkN6qk0=;
        b=GL1HvdJ4o4XmxRrmfEQebWs3JmbijvJCOAJbRFHWEUw8+sYVfaJrMWLftTXePMLp/1
         HvPIBzGRjsOL1q2ayalg2buEohoOLOhmwdQNt9Lk84ZD+Im/mTgq3vhEj0/B4qbGZ24O
         YSp1HW18Us+y4JDwadrKOtw3nn8dadG/sAbgxWlGPCbL/eBivRNxMetwARaYHoxOPgwh
         FOwJbj9pb7el/EZaRQEFpsOgv8+ZWuZsnPwc6o74utJxvMuiDQ/o1mwUGqQ+BtzelzxF
         rgtUQGyU30IAvveZ/hz/JrwLafEmzIfvtHZRSZGLABtIYnl60+EL/RkGLLY7z0BPR8RM
         aBVQ==
X-Gm-Message-State: APjAAAX3uqHlQWrG5vRh4MwX0z62sKNwo3nXiub7IYT/QuizOQ9LlJh5
        D4SS0VCiNG7ZpHW4mCNoMd7ROQ==
X-Google-Smtp-Source: APXvYqyZH5n8SKLkRsr6LU7ZmB01n+AtwHv/+Phkg25D95FMUayM3q5Yh253+2EHDaWpUyGoWEkCjA==
X-Received: by 2002:a2e:9f02:: with SMTP id u2mr14044429ljk.4.1566256348034;
        Mon, 19 Aug 2019 16:12:28 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.googlemail.com with ESMTPSA id l14sm2820614ljb.63.2019.08.19.16.12.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2019 16:12:27 -0700 (PDT)
Subject: Re: What to do when a bridge port gets its pvid deleted?
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        stephen@networkplumber.org
References: <CA+h21hrRMrLH-RjBGhEJSTZd6_QPRSd3RkVRQF-wNKkrgKcRSA@mail.gmail.com>
 <20190628123009.GA10385@splinter>
 <CA+h21hpPD6E_qOS-SxWKeXZKLOnN8og1BN_vSgk1+7XXQVTnBw@mail.gmail.com>
 <bb99eabb-1410-e7c2-4226-ee6c5fef6880@gmail.com>
 <4756358f-6717-0fbc-3fe8-9f6359583367@gmail.com>
 <20190819201502.GA25207@splinter>
 <CA+h21hrt9SXPDZq8i1=dZsa4iPHzKwzHnTGUM+ysXascUoKOpQ@mail.gmail.com>
 <031521d2-2fb5-dd0f-2cb0-a75daa76022d@cumulusnetworks.com>
Message-ID: <fa3f5a3b-3107-7867-22ba-da6aa531031e@cumulusnetworks.com>
Date:   Tue, 20 Aug 2019 02:12:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <031521d2-2fb5-dd0f-2cb0-a75daa76022d@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/19 2:01 AM, Nikolay Aleksandrov wrote:
> On 8/20/19 12:10 AM, Vladimir Oltean wrote:
> [snip]
>> It's good to know that it's there (like you said, it explains some
>> things) but I can't exactly say that removing it helps in any way.
>> In fact, removing it only overwrites the dsa_8021q VLANs with 1 during
>> bridge_join, while not actually doing anything upon a vlan_filtering
>> toggle.
>> So the sja1105 driver is in a way shielded by DSA from the bridge, for
>> the better.
>> It still appears to be true that the bridge doesn't think it's
>> necessary to notify through SWITCHDEV_OBJ_ID_PORT_VLAN again. So my
>> best bet is to restore the pvid on my own.
>> However I've already stumbled upon an apparent bug while trying to do
>> that. Does this look off? If it doesn't, I'll submit it as a patch:
>>
>> commit 788f03991aa576fc0b4b26ca330af0f412c55582
>> Author: Vladimir Oltean <olteanv@gmail.com>
>> Date:   Mon Aug 19 22:57:00 2019 +0300
>>
>>     net: bridge: Keep the BRIDGE_VLAN_INFO_PVID flag in net_bridge_vlan
>>
>>     Currently this simplified code snippet fails:
>>
>>             br_vlan_get_pvid(netdev, &pvid);
>>             br_vlan_get_info(netdev, pvid, &vinfo);
>>             ASSERT(!(vinfo.flags & BRIDGE_VLAN_INFO_PVID));
>>
>>     It is intuitive that the pvid of a netdevice should have the
>>     BRIDGE_VLAN_INFO_PVID flag set.
>>
>>     However I can't seem to pinpoint a commit where this behavior was
>>     introduced. It seems like it's been like that since forever.
>>
>>     Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
>>
>> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
>> index 021cc9f66804..f49b2758bcab 100644
>> --- a/net/bridge/br_vlan.c
>> +++ b/net/bridge/br_vlan.c
>> @@ -68,10 +68,13 @@ static bool __vlan_add_flags(struct
>> net_bridge_vlan *v, u16 flags)
>>      else
>>          vg = nbp_vlan_group(v->port);
>>
>> -    if (flags & BRIDGE_VLAN_INFO_PVID)
>> +    if (flags & BRIDGE_VLAN_INFO_PVID) {
>>          ret = __vlan_add_pvid(vg, v->vid);
>> -    else
>> +        v->flags |= BRIDGE_VLAN_INFO_PVID;
>> +    } else {
>>          ret = __vlan_delete_pvid(vg, v->vid);
>> +        v->flags &= ~BRIDGE_VLAN_INFO_PVID;
>> +    }
>>
>>      if (flags & BRIDGE_VLAN_INFO_UNTAGGED)
>>          v->flags |= BRIDGE_VLAN_INFO_UNTAGGED;
>>
> 
> Hi Vladimir,
> I know it looks logical to have it, but there are a few reasons why we don't
> do it, most importantly because we need to have only one visible pvid at any single
> time, even if it's stale - it must be just one. Right now that rule will not
> be violated  by your change, but people will try using this flag and could see

Obviously, I'm talking about RCU pvid/vlan use cases similar to the dumps.
The locked cases are fine.

> two pvids simultaneously. You can see that the pvid code is even using memory
> barriers to propagate the new value faster and everywhere the pvid is read only once.
> That is the reason the flag is set dynamically when dumping entries, too.
> A second (weaker) argument against would be given the above we don't want
> another way to do the same thing, specifically if it can provide us with

i.e. I would like to avoid explaining why this shouldn't be relied upon without locking

> two pvids (e.g. if walking the vlan list) or if it can provide us with a pvid
> different from the one set in the vg.
> If you do need that flag, you can change br_vlan_get_info() to set the flag like
> the other places do - if the vid matches the current vg pvid, or you could change
> the whole pvid handling code to this new scheme as long as it can guarantee a single
> pvid when walking the vlan list and fast pvid retrieval in the fast-path.
> 
> Cheers,
>  Nik
>  
> 

