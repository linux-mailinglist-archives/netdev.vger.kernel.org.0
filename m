Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78C11A9E65
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 13:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897914AbgDOLze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 07:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2897902AbgDOLzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 07:55:15 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D226FC061A0C
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 04:55:14 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x25so17079025wmc.0
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 04:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst-fr.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=j5yOHinN6EwMoj9zxKD4euD0wp6CN2AVukKFsIplJJ4=;
        b=mNjleRkSrTKz6uFW1ExySgLrzETLiIyNtE16tq6jKSPsnyh8COrH6537B8klq9NiQB
         LF8jf7jQ8AAD2eAqrzGlChPhv2ygdKMQ+wjzA2OqMg4S0Oesj+uNnkM6t6uqrgtqZCwP
         VHRHkPKayuFi57XNt6NSsbgL6jRpHaY8+nFxGh2vAmPy8lFp4U9hS+KwNby3xfRLRrus
         8g87mkcXtAPUYqLZz4m1A+CNH68DzCs9ClAcf21g0Vls2tHkmcrHoR/YALF3aRQn9YIe
         5114T9NBYww1TPjjx0DxDfs4ALTHHjM2yBAl00x/ib36IO0SXOV9DAbRLgJKBj+/8WD/
         udzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=j5yOHinN6EwMoj9zxKD4euD0wp6CN2AVukKFsIplJJ4=;
        b=jt4fYZyDmFDcwAhjjvkZMcO39i7eUhCNswYNwFB9atw5ms2FrCBrzJ3nNrNwFiLXI3
         nFa/8t0q9c1X75Xs4UZPU4MA0vILb1lmfy5af+1bRGUHGUtkMjJvluheiv+1pXWVEGqR
         VxSO0+Px+xP7lMsPWJobjn+VF23IG7evlv9kgkAQRC7GsrD6sKpo06BWYQH/gXQOMdqY
         +z9YL8ua9PFMyrP5Iv8UZNR2afTsLOLh1nrVEY1DATnigvG15OQ4NMssfcUv5R54XJ9Y
         8Mv8zzIWttw9bX5BulSSCxcx95nbHZ3zlWVxbnLeK49waHjc0ct/JWTLCUZKKLxt1iR8
         WWGQ==
X-Gm-Message-State: AGi0PubSpHF8bpja7MxQmC4SpsHVByLlMGyIxI6EPMRuGnUHgtM787Sl
        cLl6tD1F2QvDawemfGeVer4elFNRkYw=
X-Google-Smtp-Source: APiQypKfWQT0QmXw8kwgNwPmmyc8sxJhuevwmxr7Yr1gamnK6CR+KhyGfAapdnR8+vI1LhGbcZFvDg==
X-Received: by 2002:a1c:68d7:: with SMTP id d206mr4545958wmc.29.1586951712703;
        Wed, 15 Apr 2020 04:55:12 -0700 (PDT)
Received: from ?IPv6:2a01:cb00:17f:7f00:eb65:350d:cb7f:23a3? (2a01cb00017f7f00eb65350dcb7f23a3.ipv6.abo.wanadoo.fr. [2a01:cb00:17f:7f00:eb65:350d:cb7f:23a3])
        by smtp.gmail.com with ESMTPSA id g186sm24020036wmg.36.2020.04.15.04.55.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 04:55:12 -0700 (PDT)
Subject: Re: [PATCH net] r8169: fix multicast tx issue with macvlan interface
To:     Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
References: <20200327090800.27810-1-charles.daymand@wifirst.fr>
 <0bab7e0b-7b22-ad0f-2558-25602705e807@gmail.com>
 <d7a0eca8-15aa-10da-06cc-1eeef3a7a423@gmail.com>
 <CANn89iKA8k3GyxCKCJRacB42qcFqUDsiRhFOZxOQ7JCED0ChyQ@mail.gmail.com>
 <42f81a4a-24fc-f1fb-11db-ea90a692f249@gmail.com>
 <CANn89i+A=Mu=9LMscd2Daqej+uVLc3E6w33MZzTwpe2v+k89Mw@mail.gmail.com>
 <CAFJtzm03QpjGRs70tth26BdUFN_o8zsJOccbnA58ma+2uwiGcg@mail.gmail.com>
 <c02274b9-1ba0-d5e9-848f-5d6761df20f4@gmail.com>
 <CAFJtzm0H=pztSp_RQt_YNnPHQkq4N4Z5S-PqMFgE=Fp=Fo-G_w@mail.gmail.com>
 <297e210f-1784-44a9-17fb-7fbe8b6f9ec3@gmail.com>
 <CANn89iKA8MAef-XfkbLG3W+3=qUx4pqmKuWPBfrxAcupohLkyA@mail.gmail.com>
From:   Charles Daymand <charles.daymand@wifirst.fr>
Message-ID: <cead98cd-b396-f261-5680-534453a07694@wifirst.fr>
Date:   Wed, 15 Apr 2020 13:55:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CANn89iKA8MAef-XfkbLG3W+3=qUx4pqmKuWPBfrxAcupohLkyA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: fr-FR
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry apparently I had an issue when sending the mail to the netdev mailing list yesterday.
Actually in our architecture we are creating vlan interface from a
macvlan interface (that explains the 802.1Q traffic)
I did more testing on the issue today and I observed that the macvlan
interface itself is not affected by the issue, it's only the vlan
interfaces created from the macvlan interface which is affected by the
issue.

I did the following network configuration on the hardware to simplify
the testing :

    +----------------------------------------+                 +--------------------------+
    | Hardware                               |                 | Laptop                   |
    | +---------+                            |                 |            +---------+   |
    | | vlan2833+-+                          |                 |      +-----+ vlan2833|   |
    | +---------+ |                          |                 |      |     +---------+   |
192.168.200.1/24 |  +---------+          +--+-+             +-+--+   |  192.168.200.2/24 |
    |             +--+mymacvlan+----------+eth0+-------------+eth0+---+--+                |
    |             |  +---------+          +----+             +----+      |                |
    | +---------+ | 192.168.120.1/24 192.168.100.1/24   192.168.100.2/24 |  +---------+   |
    | | vlan1000+-+                          |          192.168.120.2/24 +--+ vlan1000|   |
    | +---------+                            |                 |            +---------+   |
192.168.150.1/24                            |                 |         192.168.150.2/24 |
    +----------------------------------------+                 +--------------------------+

For testing purpose I connected by ssh to 192.168.100.1 and sent udp
packets to the laptop IPs with the following result:
* When sending an UDP packet to 192.168.120.2 ==> No issue
* When sending an UDP packet to 192.168.200.2 (vlan 2833) ==> I have the malformed packet issue
* When sending an UDP packet to 192.168.150.2 (vlan 1000) ==> I receive no network traffic
and I lose the ssh connection during 2 minutes with nothing in dmesg during this period.

Le 13/04/2020 à 20:20, Eric Dumazet a écrit :
> On Mon, Apr 13, 2020 at 11:06 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>> On 06.04.2020 16:12, Charles DAYMAND wrote:
>>> Hello,
>>> Sorry for the long delay, I didn't have physical access to the
>>> hardware last week. I did more testing today by connecting directly my
>>> laptop to the hardware and the issue not only affects multicast but
>>> also unicast with macvlan.
>>> Only ping packets are correctly sent.
>>> Using wireshark I can only see malformed ethernet packets (example
>>> with multicast packet below)
>>> Frame 1: 106 bytes on wire (848 bits), 106 bytes captured (848 bits)
>>> IEEE 802.3 Ethernet
>>>      Destination: IPv4mcast_09 (01:00:5e:00:00:09)
>>>      Source: b2:41:6f:04:c1:86 (b2:41:6f:04:c1:86)
>>>      Length: 96
>>>          [Expert Info (Error/Malformed): Length field value goes past
>>> the end of the payload]
>>> Logical-Link Control
>>>      DSAP: Unknown (0x45)
>>>      SSAP: Unknown (0xc0)
>>>      Control field: I, N(R)=46, N(S)=0 (0x5C00)
>>> Data (88 bytes)
>>>      Data: 50320c780111087fac159401e0000009020802080048207a...
>>>      [Length: 88]
>>> Please find the full pcap file at this url with also a tentative to
>>> establish a ssh connection :
>>> https://fourcot.fr/temp/malformed_ethernet2.pcap
>>>
>> A problem with HW checksumming should manifest as checksum failure,
>> I don't think HW checksumming touches length information in headers.
>> You could enable tracing network events to see whether packets look
>> suspicious before reaching the network driver.
>> (or do some printf debugging for the affected multicast packets)
>>
>> Because you initially suspected a problem with HW checksumming
>> in a specific RTL8168 chip variant:
>> - Check macvlan with another network driver supporting HW checksumming
>> - Check macvlan with r8169 and another RTL8168 chip variant
>>
>> The fact that the issue doesn't exist w/o macvlan seems to indicate
>> that the network driver can't be blamed here.
> trace includes evidence of 802.1Q traffic though, maybe "macvlan" is a
> red herring,
> some confusion on wording maybe...
>
> 802.1Q Virtual LAN, PRI: 0, DEI: 0, ID: 2833
>      000. .... .... .... = Priority: Best Effort (default) (0)
>      ...0 .... .... .... = DEI: Ineligible
>      .... 1011 0001 0001 = ID: 2833
>
>
>>> Best regards
>>>
>>> Charles
>>>
>>>
>>> Le mar. 31 mars 2020 à 16:07, Heiner Kallweit <hkallweit1@gmail.com> a écrit :
>>>> Thanks for further testing! The good news from my perspective is that the issue doesn't occur
>>>> w/o macvlen, therefore it doesn't seem to be a r8169 network driver issue.
>>>>
>>>> W/o knowing tcpdump in detail I think it switches the NIC to promiscuous mode, means
>>>> it should see all packets, incl. the ones with checksum errors.
>>>> Maybe you can mirror the port to which the problematic system is connected and
>>>> analyze the traffic. Or for whatever reason the switch doesn't forward the multicast
>>>> packets to your notebook.
>>>>
>>>> Heiner
>>>>
>>>>
>>>> On 31.03.2020 15:44, Charles DAYMAND wrote:
>>>>> Hello,
>>>>> We tested to enable tx checksumming manually (via ethtool) on a kernel 4.19.0-5-amd64 which is the oldest kernel compatible with our software and we observed exactly the same issue.
>>>>> For information when connecting a laptop directly to the interface we can't see any multicast packet when tx checksumming is enabled on tcpdump.
>>>>> Our network is composed of a cisco switch and we can still see the multicast counters correctly increasing even when we have the issue.
>>>>>
>>>>> I also confirm that when not using macvlan but the real interface there is no issue on the multicast packets, they are correctly sent and received.
>>>>> I have a stupid question, if the IP checksum was bad on the multicast packet, would the receiver NIC drop the packet or would it be seen by tcpdump by the receiver ?
>>>>>
>>>>> Le ven. 27 mars 2020 à 20:43, Eric Dumazet <edumazet@google.com <mailto:edumazet@google.com>> a écrit :
>>>>>
>>>>>      On Fri, Mar 27, 2020 at 12:17 PM Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> wrote:
>>>>>      >
>>>>>      > On 27.03.2020 19:52, Eric Dumazet wrote:
>>>>>      > > On Fri, Mar 27, 2020 at 10:41 AM Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> wrote:
>>>>>      > >>
>>>>>      > >> On 27.03.2020 10:39, Heiner Kallweit wrote:
>>>>>      > >>> On 27.03.2020 10:08, Charles Daymand wrote:
>>>>>      > >>>> During kernel upgrade testing on our hardware, we found that macvlan
>>>>>      > >>>> interface were no longer able to send valid multicast packet.
>>>>>      > >>>>
>>>>>      > >>>> tcpdump run on our hardware was correctly showing our multicast
>>>>>      > >>>> packet but when connecting a laptop to our hardware we didn't see any
>>>>>      > >>>> packets.
>>>>>      > >>>>
>>>>>      > >>>> Bisecting turned up commit 93681cd7d94f
>>>>>      > >>>> "r8169: enable HW csum and TSO" activates the feature NETIF_F_IP_CSUM
>>>>>      > >>>> which is responsible for the drop of packet in case of macvlan
>>>>>      > >>>> interface. Note that revision RTL_GIGA_MAC_VER_34 was already a specific
>>>>>      > >>>> case since TSO was keep disabled.
>>>>>      > >>>>
>>>>>      > >>>> Deactivating NETIF_F_IP_CSUM using ethtool is correcting our multicast
>>>>>      > >>>> issue, but we believe that this hardware issue is important enough to
>>>>>      > >>>> keep tx checksum off by default on this revision.
>>>>>      > >>>>
>>>>>      > >>>> The change is deactivating the default value of NETIF_F_IP_CSUM for this
>>>>>      > >>>> specific revision.
>>>>>      > >>>>
>>>>>      > >>>
>>>>>      > >>> The referenced commit may not be the root cause but just reveal another
>>>>>      > >>> issue that has been existing before. Root cause may be in the net core
>>>>>      > >>> or somewhere else. Did you check with other RTL8168 versions to verify
>>>>>      > >>> that it's indeed a HW issue with this specific chip version?
>>>>>      > >>>
>>>>>      > >>> What you could do: Enable tx checksumming manually (via ethtool) on
>>>>>      > >>> older kernel versions and check whether they are fine or not.
>>>>>      > >>> If an older version is fine, then you can start a new bisect with tx
>>>>>      > >>> checksumming enabled.
>>>>>      > >>>
>>>>>      > >>> And did you capture and analyze traffic to verify that actually the
>>>>>      > >>> checksum is incorrect (and packets discarded therefore on receiving end)?
>>>>>      > >>>
>>>>>      > >>>
>>>>>      > >>>> Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
>>>>>      > >>>> Signed-off-by: Charles Daymand <charles.daymand@wifirst.fr <mailto:charles.daymand@wifirst.fr>>
>>>>>      > >>>> ---
>>>>>      > >>>>  net/drivers/net/ethernet/realtek/r8169_main.c | 3 +++
>>>>>      > >>>>  1 file changed, 3 insertions(+)
>>>>>      > >>>>
>>>>>      > >>>> diff --git a/net/drivers/net/ethernet/realtek/r8169_main.c b/net/drivers/net/ethernet/realtek/r8169_main.c
>>>>>      > >>>> index a9bdafd15a35..3b69135fc500 100644
>>>>>      > >>>> --- a/net/drivers/net/ethernet/realtek/r8169_main.c
>>>>>      > >>>> +++ b/net/drivers/net/ethernet/realtek/r8169_main.c
>>>>>      > >>>> @@ -5591,6 +5591,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>>>      > >>>>              dev->vlan_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
>>>>>      > >>>>              dev->hw_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
>>>>>      > >>>>              dev->features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
>>>>>      > >>>> +            if (tp->mac_version == RTL_GIGA_MAC_VER_34) {
>>>>>      > >>>> +                    dev->features &= ~NETIF_F_IP_CSUM;
>>>>>      > >>>> +            }
>>>>>      > >>>>      }
>>>>>      > >>>>
>>>>>      > >>>>      dev->hw_features |= NETIF_F_RXALL;
>>>>>      > >>>>
>>>>>      > >>>
>>>>>      > >>
>>>>>      > >> After looking a little bit at the macvlen code I think there might be an
>>>>>      > >> issue in it, but I'm not sure, therefore let me add Eric (as macvlen doesn't
>>>>>      > >> seem to have a dedicated maintainer).
>>>>>      > >>
>>>>>      > >> r8169 implements a ndo_features_check callback that disables tx checksumming
>>>>>      > >> for the chip version in question and small packets (due to a HW issue).
>>>>>      > >> macvlen uses passthru_features_check() as ndo_features_check callback, this
>>>>>      > >> seems to indicate to me that the ndo_features_check callback of lowerdev is
>>>>>      > >> ignored. This could explain the issue you see.
>>>>>      > >>
>>>>>      > >
>>>>>      > > macvlan_queue_xmit() calls dev_queue_xmit_accel() after switching skb->dev,
>>>>>      > > so the second __dev_queue_xmit() should eventually call the real_dev
>>>>>      > > ndo_features_check()
>>>>>      > >
>>>>>      > Thanks, Eric. There's a second path in macvlan_queue_xmit() calling
>>>>>      > dev_forward_skb(vlan->lowerdev, skb). Does what you said apply also there?
>>>>>
>>>>>      This path wont send packets to the physical NIC, packets are injected
>>>>>      back via dev_forward_skb()
>>>>>
>>>>>      >
>>>>>      > Still I find it strange that a tx hw checksumming issue should affect multicasts
>>>>>      > only. Also the chip version in question is quite common and I would expect
>>>>>      > others to have hit the same issue.
>>>>>      > Maybe best would be to re-test on the affected system w/o involving macvlen.
>>>>>      >
>>>>>      > >
>>>>>      > >
>>>>>      > >> Would be interesting to see whether it fixes your issue if you let the
>>>>>      > >> macvlen ndo_features_check call lowerdev's ndo_features_check. Can you try this?
>>>>>      > >>
>>>>>      > >> By the way:
>>>>>      > >> Also the ndo_fix_features callback of lowerdev seems to be ignored.
>>>>>      >
>>>>>
>>>>>
>>>>>
>>>>> --
>>>>>
>>>>> logo wifirst <http://www.wifirst.fr/en>
>>>>>
>>>>> Charles Daymand
>>>>>
>>>>> Développeur infrastructure
>>>>>
>>>>> 26 rue de Berri 75008 Paris
>>>>>
>>>>> Assistance dédiée responsable de site - 01 70 70 46 70
>>>>> Assistance utilisateur - 01 70 70 46 26
>>>>>
>>>
