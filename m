Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E47405A142
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 18:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfF1Qpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 12:45:44 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:36177 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbfF1Qpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 12:45:44 -0400
Received: by mail-wr1-f44.google.com with SMTP id n4so7007841wrs.3
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 09:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EHWz5v6TPLTsWLPcgdOPZrwN+qZxASgjDKXjzQJKIu8=;
        b=iUqvr8N/u1rQPv0xB/tBEm5l7sgIL2GPbqJga0MTa4/QrPl2kNW4MDfZnJNDpCK8Ta
         AOSn7JZHiFZigJguNp6WFWNrsq+dBdWnt9CaPzAUKmgvbpPp0PSEtY6yvaRyr7gEG4Ux
         H0WoRunPnFmtFQUnTsrQGCwD2M+6ahE4BLF81iejjjpkbfy56A0HfR5oq7ibo9eZdoIo
         Q4ti3eRhV1TeKOyOZUkN82IW2m7YcQ/Ln+Yg0vviEeoUDs8J288cRo7TEtx5BU+doaR4
         uCzNX/7jwD/zpw0o4QmVZTDDLbhE2qMuOsgPbxJnn9UQ9vus2ah9sUykfEJ1oTccZqRn
         SFbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=EHWz5v6TPLTsWLPcgdOPZrwN+qZxASgjDKXjzQJKIu8=;
        b=P/QtW1d0HkYn94mrX6/c2H4bDqz6BvksnGmZ/VrmTo8iHhuw50DAgl195LqYJoENz+
         8hBzkA4ic1fXVlV8oQFwRLdkP01evqFTfee6BC0VdZ3uRYnjP5uXV3OJkl1gZZEhW5WS
         /unARkIT1NEXKmo3udMsRSM2axUNBQlscYk3VRj24KUkTUwYtOs2gDF/Yi/9wAx07yZy
         VIqvEOulWcQ2AqzPuTDPYXxXZvpvM5ArpA4YFhLdTo6gXtqv76mXzXjGOlSvuiNRhLJa
         eL66DZvyZplFIHFL20f+BInt/gFaBE+ZiKI+1L771wgZtlIVdVsApXGDwq0N/Kfxc3Up
         k4lQ==
X-Gm-Message-State: APjAAAXh2L+OecgWr9z5HHlv6UwdBwA1zhpCfos7Q17C8Cr+KeO3zQTo
        AmRms8VC7krG0hARUbtmuK0=
X-Google-Smtp-Source: APXvYqyInv4BgLp377Nj7gFObS8LGaTKrFWj6PtjP2vK6G5mBbDR54rhgW3VqGwv4ul/EfM4ftWxgQ==
X-Received: by 2002:adf:ea87:: with SMTP id s7mr8883601wrm.24.1561740340982;
        Fri, 28 Jun 2019 09:45:40 -0700 (PDT)
Received: from [10.67.50.91] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y6sm2923318wmd.16.2019.06.28.09.45.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 09:45:40 -0700 (PDT)
Subject: Re: What to do when a bridge port gets its pvid deleted?
To:     Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        stephen@networkplumber.org
References: <CA+h21hrRMrLH-RjBGhEJSTZd6_QPRSd3RkVRQF-wNKkrgKcRSA@mail.gmail.com>
 <20190628123009.GA10385@splinter>
 <CA+h21hpPD6E_qOS-SxWKeXZKLOnN8og1BN_vSgk1+7XXQVTnBw@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <bb99eabb-1410-e7c2-4226-ee6c5fef6880@gmail.com>
Date:   Fri, 28 Jun 2019 09:45:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <CA+h21hpPD6E_qOS-SxWKeXZKLOnN8og1BN_vSgk1+7XXQVTnBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/19 5:37 AM, Vladimir Oltean wrote:
> On Fri, 28 Jun 2019 at 15:30, Ido Schimmel <idosch@idosch.org> wrote:
>>
>> On Tue, Jun 25, 2019 at 11:49:29PM +0300, Vladimir Oltean wrote:
>>> A number of DSA drivers (BCM53XX, Microchip KSZ94XX, Mediatek MT7530
>>> at the very least), as well as Mellanox Spectrum (I didn't look at all
>>> the pure switchdev drivers) try to restore the pvid to a default value
>>> on .port_vlan_del.
>>
>> I don't know about DSA drivers, but that's not what mlxsw is doing. If
>> the VLAN that is configured as PVID is deleted from the bridge port, the
>> driver instructs the port to discard untagged and prio-tagged packets.
>> This is consistent with the bridge driver's behavior.
>>
>> We do have a flow the "restores" the PVID, but that's when a port is
>> unlinked from its bridge master. The PVID we set is 4095 which cannot be
>> configured by the 8021q / bridge driver. This is due to the way the
>> underlying hardware works. Even if a port is not bridged and used purely
>> for routing, packets still do L2 lookup first which sends them directly
>> to the router block. If PVID is not configured, untagged packets could
>> not be routed. Obviously, at egress we strip this VLAN.
>>
>>> Sure, the port stops receiving traffic when its pvid is a VLAN ID that
>>> is not installed in its hw filter, but as far as the bridge core is
>>> concerned, this is to be expected:
>>>
>>> # bridge vlan add dev swp2 vid 100 pvid untagged
>>> # bridge vlan
>>> port    vlan ids
>>> swp5     1 PVID Egress Untagged
>>>
>>> swp2     1 Egress Untagged
>>>          100 PVID Egress Untagged
>>>
>>> swp3     1 PVID Egress Untagged
>>>
>>> swp4     1 PVID Egress Untagged
>>>
>>> br0      1 PVID Egress Untagged
>>> # ping 10.0.0.1
>>> PING 10.0.0.1 (10.0.0.1) 56(84) bytes of data.
>>> 64 bytes from 10.0.0.1: icmp_seq=1 ttl=64 time=0.682 ms
>>> 64 bytes from 10.0.0.1: icmp_seq=2 ttl=64 time=0.299 ms
>>> 64 bytes from 10.0.0.1: icmp_seq=3 ttl=64 time=0.251 ms
>>> 64 bytes from 10.0.0.1: icmp_seq=4 ttl=64 time=0.324 ms
>>> 64 bytes from 10.0.0.1: icmp_seq=5 ttl=64 time=0.257 ms
>>> ^C
>>> --- 10.0.0.1 ping statistics ---
>>> 5 packets transmitted, 5 received, 0% packet loss, time 4188ms
>>> rtt min/avg/max/mdev = 0.251/0.362/0.682/0.163 ms
>>> # bridge vlan del dev swp2 vid 100
>>> # bridge vlan
>>> port    vlan ids
>>> swp5     1 PVID Egress Untagged
>>>
>>> swp2     1 Egress Untagged
>>>
>>> swp3     1 PVID Egress Untagged
>>>
>>> swp4     1 PVID Egress Untagged
>>>
>>> br0      1 PVID Egress Untagged
>>>
>>> # ping 10.0.0.1
>>> PING 10.0.0.1 (10.0.0.1) 56(84) bytes of data.
>>> ^C
>>> --- 10.0.0.1 ping statistics ---
>>> 8 packets transmitted, 0 received, 100% packet loss, time 7267ms
>>>
>>> What is the consensus here? Is there a reason why the bridge driver
>>> doesn't take care of this?
>>
>> Take care of what? :) Always maintaining a PVID on the bridge port? It's
>> completely OK not to have a PVID.
>>
> 
> Yes, I didn't think it through during the first email. I came to the
> same conclusion in the second one.
> 
>>> Do switchdev drivers have to restore the pvid to always be
>>> operational, even if their state becomes inconsistent with the upper
>>> dev? Is it just 'nice to have'? What if VID 1 isn't in the hw filter
>>> either (perfectly legal)?
>>
>> Are you saying that DSA drivers always maintain a PVID on the bridge
>> port and allow untagged traffic to ingress regardless of the bridge
>> driver's configuration? If so, I think this needs to be fixed.
> 
> Well, not at the DSA core level.
> But for Microchip:
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/drivers/net/dsa/microchip/ksz9477.c#n576
> For Broadcom:
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/drivers/net/dsa/b53/b53_common.c#n1376
> For Mediatek:
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/drivers/net/dsa/mt7530.c#n1196
> 
> There might be others as well.

That sounds bogus indeed, and I bet that the two other drivers just
followed the b53 driver there. I will have to test this again and come
up with a patch eventually.

When the port leaves the bridge we do bring it back into a default PVID
(which is different than the bridge's default PVID) so that part should
be okay.
-- 
Florian
