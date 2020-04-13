Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FF51A6BE2
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 20:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387621AbgDMSHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 14:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387498AbgDMSG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 14:06:57 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568CEC0A3BDC
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 11:06:57 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f13so11050381wrm.13
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 11:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8lv3Q7BrWFdK1j4ph0E7kucYPHvM/D4yVVF7DiL57r4=;
        b=Ux2eTliJhcH4uWe4oEtfu4xdand0L/OSqSXaC/9FCeizxBVl6G6N+9Prrq6WCyNYbo
         k+W7g19coYorV6of8soH3kn1ty53Eqio7zevTKFi6qnle59iKcFnyyD4fEIGSxSEqXui
         yV9e9owXjAgxRMpJ46terowPYYexEs3lhQ7dZJjJYXwTqh10zKy4kOH61ympucmJHbWe
         xzb2/1Moey2Uw3nVf7O4JeqATA7biGh2xzoWFFH78qFmKPWFHVqI7m397o20PZOSq028
         YCW/g8LvhTn0flrZBtAYyiEFQ8QSTl+M4XdfFv0IGrz8OQikQsj8QVT1gPwWlAXLyRmX
         ZDrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8lv3Q7BrWFdK1j4ph0E7kucYPHvM/D4yVVF7DiL57r4=;
        b=V1Nerl+SGEqRrr2JBAw+ZXQxPWEL/F1ybzWZmzAvs/s2I8fVO+7douMLPosR/A/YOP
         RnnXTHsRAtvI4lC8Od4w6J2BdyGZpi43B/8SF8/lGcJa4CKAX8FG/G7EF+dUOvVkzWet
         LyiZLyjuPcDV/4aTlDCnYwBcvZ43qzUugKo0EovKVG8KqsxZbiVt1VejNBxGLvNn8w4P
         ohmzqFownRVpBAZwQ+ZJSqnREYwg5rOTB9JeMqgQnJX2YqEruRX4UiWDARnL+FxJ+sXW
         2UX44ms/7C8FsDWzE6biuRNDHOPeCAdpfywQL8UsQGdIZx2gI4yL+RC3KhInONLhNpyV
         kiAA==
X-Gm-Message-State: AGi0PubMt1g6yZzvhWrOTxEjDK+rltgrn0r0jmwq7xgo/fiaeqRlD4GZ
        rU5Z92eogb9u8/buhP5xJUxnx6+v
X-Google-Smtp-Source: APiQypLWRCZCdYguxOPzecJI2AZOi+hYATDSPuiRKMI5AxFOhmJfHqvrZ+W5htTcYJArWaOUo+LCtg==
X-Received: by 2002:adf:fa41:: with SMTP id y1mr18854566wrr.131.1586801215623;
        Mon, 13 Apr 2020 11:06:55 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:ecd0:ef61:dfee:4535? (p200300EA8F296000ECD0EF61DFEE4535.dip0.t-ipconnect.de. [2003:ea:8f29:6000:ecd0:ef61:dfee:4535])
        by smtp.googlemail.com with ESMTPSA id a2sm16464930wra.71.2020.04.13.11.06.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 11:06:54 -0700 (PDT)
Subject: Re: [PATCH net] r8169: fix multicast tx issue with macvlan interface
To:     Charles DAYMAND <charles.daymand@wifirst.fr>
Cc:     Eric Dumazet <edumazet@google.com>, netdev <netdev@vger.kernel.org>
References: <20200327090800.27810-1-charles.daymand@wifirst.fr>
 <0bab7e0b-7b22-ad0f-2558-25602705e807@gmail.com>
 <d7a0eca8-15aa-10da-06cc-1eeef3a7a423@gmail.com>
 <CANn89iKA8k3GyxCKCJRacB42qcFqUDsiRhFOZxOQ7JCED0ChyQ@mail.gmail.com>
 <42f81a4a-24fc-f1fb-11db-ea90a692f249@gmail.com>
 <CANn89i+A=Mu=9LMscd2Daqej+uVLc3E6w33MZzTwpe2v+k89Mw@mail.gmail.com>
 <CAFJtzm03QpjGRs70tth26BdUFN_o8zsJOccbnA58ma+2uwiGcg@mail.gmail.com>
 <c02274b9-1ba0-d5e9-848f-5d6761df20f4@gmail.com>
 <CAFJtzm0H=pztSp_RQt_YNnPHQkq4N4Z5S-PqMFgE=Fp=Fo-G_w@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <297e210f-1784-44a9-17fb-7fbe8b6f9ec3@gmail.com>
Date:   Mon, 13 Apr 2020 20:06:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAFJtzm0H=pztSp_RQt_YNnPHQkq4N4Z5S-PqMFgE=Fp=Fo-G_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.04.2020 16:12, Charles DAYMAND wrote:
> Hello,
> Sorry for the long delay, I didn't have physical access to the
> hardware last week. I did more testing today by connecting directly my
> laptop to the hardware and the issue not only affects multicast but
> also unicast with macvlan.
> Only ping packets are correctly sent.
> Using wireshark I can only see malformed ethernet packets (example
> with multicast packet below)
> Frame 1: 106 bytes on wire (848 bits), 106 bytes captured (848 bits)
> IEEE 802.3 Ethernet
>     Destination: IPv4mcast_09 (01:00:5e:00:00:09)
>     Source: b2:41:6f:04:c1:86 (b2:41:6f:04:c1:86)
>     Length: 96
>         [Expert Info (Error/Malformed): Length field value goes past
> the end of the payload]
> Logical-Link Control
>     DSAP: Unknown (0x45)
>     SSAP: Unknown (0xc0)
>     Control field: I, N(R)=46, N(S)=0 (0x5C00)
> Data (88 bytes)
>     Data: 50320c780111087fac159401e0000009020802080048207a...
>     [Length: 88]
> Please find the full pcap file at this url with also a tentative to
> establish a ssh connection :
> https://fourcot.fr/temp/malformed_ethernet2.pcap
> 

A problem with HW checksumming should manifest as checksum failure,
I don't think HW checksumming touches length information in headers.
You could enable tracing network events to see whether packets look
suspicious before reaching the network driver.
(or do some printf debugging for the affected multicast packets)

Because you initially suspected a problem with HW checksumming
in a specific RTL8168 chip variant:
- Check macvlan with another network driver supporting HW checksumming
- Check macvlan with r8169 and another RTL8168 chip variant

The fact that the issue doesn't exist w/o macvlan seems to indicate
that the network driver can't be blamed here.

> Best regards
> 
> Charles
> 
> 
> Le mar. 31 mars 2020 à 16:07, Heiner Kallweit <hkallweit1@gmail.com> a écrit :
>>
>> Thanks for further testing! The good news from my perspective is that the issue doesn't occur
>> w/o macvlen, therefore it doesn't seem to be a r8169 network driver issue.
>>
>> W/o knowing tcpdump in detail I think it switches the NIC to promiscuous mode, means
>> it should see all packets, incl. the ones with checksum errors.
>> Maybe you can mirror the port to which the problematic system is connected and
>> analyze the traffic. Or for whatever reason the switch doesn't forward the multicast
>> packets to your notebook.
>>
>> Heiner
>>
>>
>> On 31.03.2020 15:44, Charles DAYMAND wrote:
>>> Hello,
>>> We tested to enable tx checksumming manually (via ethtool) on a kernel 4.19.0-5-amd64 which is the oldest kernel compatible with our software and we observed exactly the same issue.
>>> For information when connecting a laptop directly to the interface we can't see any multicast packet when tx checksumming is enabled on tcpdump.
>>> Our network is composed of a cisco switch and we can still see the multicast counters correctly increasing even when we have the issue.
>>>
>>> I also confirm that when not using macvlan but the real interface there is no issue on the multicast packets, they are correctly sent and received.
>>> I have a stupid question, if the IP checksum was bad on the multicast packet, would the receiver NIC drop the packet or would it be seen by tcpdump by the receiver ?
>>>
>>> Le ven. 27 mars 2020 à 20:43, Eric Dumazet <edumazet@google.com <mailto:edumazet@google.com>> a écrit :
>>>
>>>     On Fri, Mar 27, 2020 at 12:17 PM Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> wrote:
>>>     >
>>>     > On 27.03.2020 19:52, Eric Dumazet wrote:
>>>     > > On Fri, Mar 27, 2020 at 10:41 AM Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> wrote:
>>>     > >>
>>>     > >> On 27.03.2020 10:39, Heiner Kallweit wrote:
>>>     > >>> On 27.03.2020 10:08, Charles Daymand wrote:
>>>     > >>>> During kernel upgrade testing on our hardware, we found that macvlan
>>>     > >>>> interface were no longer able to send valid multicast packet.
>>>     > >>>>
>>>     > >>>> tcpdump run on our hardware was correctly showing our multicast
>>>     > >>>> packet but when connecting a laptop to our hardware we didn't see any
>>>     > >>>> packets.
>>>     > >>>>
>>>     > >>>> Bisecting turned up commit 93681cd7d94f
>>>     > >>>> "r8169: enable HW csum and TSO" activates the feature NETIF_F_IP_CSUM
>>>     > >>>> which is responsible for the drop of packet in case of macvlan
>>>     > >>>> interface. Note that revision RTL_GIGA_MAC_VER_34 was already a specific
>>>     > >>>> case since TSO was keep disabled.
>>>     > >>>>
>>>     > >>>> Deactivating NETIF_F_IP_CSUM using ethtool is correcting our multicast
>>>     > >>>> issue, but we believe that this hardware issue is important enough to
>>>     > >>>> keep tx checksum off by default on this revision.
>>>     > >>>>
>>>     > >>>> The change is deactivating the default value of NETIF_F_IP_CSUM for this
>>>     > >>>> specific revision.
>>>     > >>>>
>>>     > >>>
>>>     > >>> The referenced commit may not be the root cause but just reveal another
>>>     > >>> issue that has been existing before. Root cause may be in the net core
>>>     > >>> or somewhere else. Did you check with other RTL8168 versions to verify
>>>     > >>> that it's indeed a HW issue with this specific chip version?
>>>     > >>>
>>>     > >>> What you could do: Enable tx checksumming manually (via ethtool) on
>>>     > >>> older kernel versions and check whether they are fine or not.
>>>     > >>> If an older version is fine, then you can start a new bisect with tx
>>>     > >>> checksumming enabled.
>>>     > >>>
>>>     > >>> And did you capture and analyze traffic to verify that actually the
>>>     > >>> checksum is incorrect (and packets discarded therefore on receiving end)?
>>>     > >>>
>>>     > >>>
>>>     > >>>> Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
>>>     > >>>> Signed-off-by: Charles Daymand <charles.daymand@wifirst.fr <mailto:charles.daymand@wifirst.fr>>
>>>     > >>>> ---
>>>     > >>>>  net/drivers/net/ethernet/realtek/r8169_main.c | 3 +++
>>>     > >>>>  1 file changed, 3 insertions(+)
>>>     > >>>>
>>>     > >>>> diff --git a/net/drivers/net/ethernet/realtek/r8169_main.c b/net/drivers/net/ethernet/realtek/r8169_main.c
>>>     > >>>> index a9bdafd15a35..3b69135fc500 100644
>>>     > >>>> --- a/net/drivers/net/ethernet/realtek/r8169_main.c
>>>     > >>>> +++ b/net/drivers/net/ethernet/realtek/r8169_main.c
>>>     > >>>> @@ -5591,6 +5591,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>     > >>>>              dev->vlan_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
>>>     > >>>>              dev->hw_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
>>>     > >>>>              dev->features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
>>>     > >>>> +            if (tp->mac_version == RTL_GIGA_MAC_VER_34) {
>>>     > >>>> +                    dev->features &= ~NETIF_F_IP_CSUM;
>>>     > >>>> +            }
>>>     > >>>>      }
>>>     > >>>>
>>>     > >>>>      dev->hw_features |= NETIF_F_RXALL;
>>>     > >>>>
>>>     > >>>
>>>     > >>
>>>     > >> After looking a little bit at the macvlen code I think there might be an
>>>     > >> issue in it, but I'm not sure, therefore let me add Eric (as macvlen doesn't
>>>     > >> seem to have a dedicated maintainer).
>>>     > >>
>>>     > >> r8169 implements a ndo_features_check callback that disables tx checksumming
>>>     > >> for the chip version in question and small packets (due to a HW issue).
>>>     > >> macvlen uses passthru_features_check() as ndo_features_check callback, this
>>>     > >> seems to indicate to me that the ndo_features_check callback of lowerdev is
>>>     > >> ignored. This could explain the issue you see.
>>>     > >>
>>>     > >
>>>     > > macvlan_queue_xmit() calls dev_queue_xmit_accel() after switching skb->dev,
>>>     > > so the second __dev_queue_xmit() should eventually call the real_dev
>>>     > > ndo_features_check()
>>>     > >
>>>     > Thanks, Eric. There's a second path in macvlan_queue_xmit() calling
>>>     > dev_forward_skb(vlan->lowerdev, skb). Does what you said apply also there?
>>>
>>>     This path wont send packets to the physical NIC, packets are injected
>>>     back via dev_forward_skb()
>>>
>>>     >
>>>     > Still I find it strange that a tx hw checksumming issue should affect multicasts
>>>     > only. Also the chip version in question is quite common and I would expect
>>>     > others to have hit the same issue.
>>>     > Maybe best would be to re-test on the affected system w/o involving macvlen.
>>>     >
>>>     > >
>>>     > >
>>>     > >> Would be interesting to see whether it fixes your issue if you let the
>>>     > >> macvlen ndo_features_check call lowerdev's ndo_features_check. Can you try this?
>>>     > >>
>>>     > >> By the way:
>>>     > >> Also the ndo_fix_features callback of lowerdev seems to be ignored.
>>>     >
>>>
>>>
>>>
>>> --
>>>
>>> logo wifirst <http://www.wifirst.fr/en>
>>>
>>> Charles Daymand
>>>
>>> Développeur infrastructure
>>>
>>> 26 rue de Berri 75008 Paris
>>>
>>> Assistance dédiée responsable de site - 01 70 70 46 70
>>> Assistance utilisateur - 01 70 70 46 26
>>>
>>
> 
> 

