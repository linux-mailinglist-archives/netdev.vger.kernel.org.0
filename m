Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5478199820
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 16:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730857AbgCaOH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 10:07:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34586 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730216AbgCaOH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 10:07:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id 65so26161967wrl.1
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 07:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lQ/tKkC2aOUwK7USx/Fsg24eHECPJ0VIbQFCZ/N4n1k=;
        b=TWt42Cl0WjBRovhnqOv0mP6yvjrKDbi6c3J4YbHnBrkW9kUVQHsL1TnrpHZrc+km7o
         +MeJg7cgQdybJunKRpvTjTTGTxdlYWodeYNJL6xkK8eWvu797LXTG+z1BgvJRNh796iI
         Q+rLVbepk8r6lECRCIxxAqz3CsPEsIuM9xFwgxXnM23WtO/WNHMtoAyH/+bNPJ9QvNRl
         7PdWN5zzdr3qFwNYH0w2Xf+zgYEsokaxELiuwM6qqWZeQXc3JVg0G0KQffwL4weyyxMi
         M/4Vg9Dd4aV+oGNXibcmeFh3bIToefBPGlzg/VS52ejQ4I0YxH6MuTaSHARw/rHzSjAm
         Nqfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lQ/tKkC2aOUwK7USx/Fsg24eHECPJ0VIbQFCZ/N4n1k=;
        b=PWdyj6gnhePxlXinRyD3fBgD9TTDwQYF31GmrI9PpBgATSj5CW1VjsuGd824/rbdA1
         vLkd5/rxCoAqOjtiKMtMvnVOVhemj+R301eNTf5OCPNqL5Rdkbzldm8ejOkPfptPy9Dl
         5NcuvJwZiivroki+cVEd0aB1Y9tNrqSgLQwxILPo0C9wXxwS1FHBu8F8tIXihdlNHFeH
         z/0B/dlESciPRsNC8Wqk29f6KnNY+5KsuuBnXq5C+FFiYScc+kQfRoWbsbPxmxOa1NSk
         yvcV7myDdlp7wWDkzSXOrlFIn1qv1ah7YFYGEonj2J3ZIYJr2y9AewCygnfsyYzginRA
         5kSw==
X-Gm-Message-State: ANhLgQ3o+twiYimvuMRKpZH05f06XleQjWY5MxZcQ5S5IxKeiGxNe0IR
        40MyolqWeZzPmFkEYwBDg+8zpCAc
X-Google-Smtp-Source: ADFU+vvJ5zWjd+f2pR6rtVbOZyEPIAIZTNPT6edjRXVgdtxWZpoj75jZakehbS/naKUzmUOkLvqupw==
X-Received: by 2002:adf:9e08:: with SMTP id u8mr20720531wre.155.1585663644553;
        Tue, 31 Mar 2020 07:07:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:8036:1536:684b:1ebf? (p200300EA8F29600080361536684B1EBF.dip0.t-ipconnect.de. [2003:ea:8f29:6000:8036:1536:684b:1ebf])
        by smtp.googlemail.com with ESMTPSA id m5sm3923443wmg.13.2020.03.31.07.07.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 07:07:23 -0700 (PDT)
Subject: Re: [PATCH net] r8169: fix multicast tx issue with macvlan interface
To:     Charles DAYMAND <charles.daymand@wifirst.fr>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>
References: <20200327090800.27810-1-charles.daymand@wifirst.fr>
 <0bab7e0b-7b22-ad0f-2558-25602705e807@gmail.com>
 <d7a0eca8-15aa-10da-06cc-1eeef3a7a423@gmail.com>
 <CANn89iKA8k3GyxCKCJRacB42qcFqUDsiRhFOZxOQ7JCED0ChyQ@mail.gmail.com>
 <42f81a4a-24fc-f1fb-11db-ea90a692f249@gmail.com>
 <CANn89i+A=Mu=9LMscd2Daqej+uVLc3E6w33MZzTwpe2v+k89Mw@mail.gmail.com>
 <CAFJtzm03QpjGRs70tth26BdUFN_o8zsJOccbnA58ma+2uwiGcg@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c02274b9-1ba0-d5e9-848f-5d6761df20f4@gmail.com>
Date:   Tue, 31 Mar 2020 16:07:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAFJtzm03QpjGRs70tth26BdUFN_o8zsJOccbnA58ma+2uwiGcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for further testing! The good news from my perspective is that the issue doesn't occur
w/o macvlen, therefore it doesn't seem to be a r8169 network driver issue.

W/o knowing tcpdump in detail I think it switches the NIC to promiscuous mode, means
it should see all packets, incl. the ones with checksum errors.
Maybe you can mirror the port to which the problematic system is connected and
analyze the traffic. Or for whatever reason the switch doesn't forward the multicast
packets to your notebook.

Heiner


On 31.03.2020 15:44, Charles DAYMAND wrote:
> Hello,
> We tested to enable tx checksumming manually (via ethtool) on a kernel 4.19.0-5-amd64 which is the oldest kernel compatible with our software and we observed exactly the same issue.
> For information when connecting a laptop directly to the interface we can't see any multicast packet when tx checksumming is enabled on tcpdump.
> Our network is composed of a cisco switch and we can still see the multicast counters correctly increasing even when we have the issue.
> 
> I also confirm that when not using macvlan but the real interface there is no issue on the multicast packets, they are correctly sent and received.
> I have a stupid question, if the IP checksum was bad on the multicast packet, would the receiver NIC drop the packet or would it be seen by tcpdump by the receiver ?
> 
> Le ven. 27 mars 2020 à 20:43, Eric Dumazet <edumazet@google.com <mailto:edumazet@google.com>> a écrit :
> 
>     On Fri, Mar 27, 2020 at 12:17 PM Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> wrote:
>     >
>     > On 27.03.2020 19:52, Eric Dumazet wrote:
>     > > On Fri, Mar 27, 2020 at 10:41 AM Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> wrote:
>     > >>
>     > >> On 27.03.2020 10:39, Heiner Kallweit wrote:
>     > >>> On 27.03.2020 10:08, Charles Daymand wrote:
>     > >>>> During kernel upgrade testing on our hardware, we found that macvlan
>     > >>>> interface were no longer able to send valid multicast packet.
>     > >>>>
>     > >>>> tcpdump run on our hardware was correctly showing our multicast
>     > >>>> packet but when connecting a laptop to our hardware we didn't see any
>     > >>>> packets.
>     > >>>>
>     > >>>> Bisecting turned up commit 93681cd7d94f
>     > >>>> "r8169: enable HW csum and TSO" activates the feature NETIF_F_IP_CSUM
>     > >>>> which is responsible for the drop of packet in case of macvlan
>     > >>>> interface. Note that revision RTL_GIGA_MAC_VER_34 was already a specific
>     > >>>> case since TSO was keep disabled.
>     > >>>>
>     > >>>> Deactivating NETIF_F_IP_CSUM using ethtool is correcting our multicast
>     > >>>> issue, but we believe that this hardware issue is important enough to
>     > >>>> keep tx checksum off by default on this revision.
>     > >>>>
>     > >>>> The change is deactivating the default value of NETIF_F_IP_CSUM for this
>     > >>>> specific revision.
>     > >>>>
>     > >>>
>     > >>> The referenced commit may not be the root cause but just reveal another
>     > >>> issue that has been existing before. Root cause may be in the net core
>     > >>> or somewhere else. Did you check with other RTL8168 versions to verify
>     > >>> that it's indeed a HW issue with this specific chip version?
>     > >>>
>     > >>> What you could do: Enable tx checksumming manually (via ethtool) on
>     > >>> older kernel versions and check whether they are fine or not.
>     > >>> If an older version is fine, then you can start a new bisect with tx
>     > >>> checksumming enabled.
>     > >>>
>     > >>> And did you capture and analyze traffic to verify that actually the
>     > >>> checksum is incorrect (and packets discarded therefore on receiving end)?
>     > >>>
>     > >>>
>     > >>>> Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
>     > >>>> Signed-off-by: Charles Daymand <charles.daymand@wifirst.fr <mailto:charles.daymand@wifirst.fr>>
>     > >>>> ---
>     > >>>>  net/drivers/net/ethernet/realtek/r8169_main.c | 3 +++
>     > >>>>  1 file changed, 3 insertions(+)
>     > >>>>
>     > >>>> diff --git a/net/drivers/net/ethernet/realtek/r8169_main.c b/net/drivers/net/ethernet/realtek/r8169_main.c
>     > >>>> index a9bdafd15a35..3b69135fc500 100644
>     > >>>> --- a/net/drivers/net/ethernet/realtek/r8169_main.c
>     > >>>> +++ b/net/drivers/net/ethernet/realtek/r8169_main.c
>     > >>>> @@ -5591,6 +5591,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>     > >>>>              dev->vlan_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
>     > >>>>              dev->hw_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
>     > >>>>              dev->features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
>     > >>>> +            if (tp->mac_version == RTL_GIGA_MAC_VER_34) {
>     > >>>> +                    dev->features &= ~NETIF_F_IP_CSUM;
>     > >>>> +            }
>     > >>>>      }
>     > >>>>
>     > >>>>      dev->hw_features |= NETIF_F_RXALL;
>     > >>>>
>     > >>>
>     > >>
>     > >> After looking a little bit at the macvlen code I think there might be an
>     > >> issue in it, but I'm not sure, therefore let me add Eric (as macvlen doesn't
>     > >> seem to have a dedicated maintainer).
>     > >>
>     > >> r8169 implements a ndo_features_check callback that disables tx checksumming
>     > >> for the chip version in question and small packets (due to a HW issue).
>     > >> macvlen uses passthru_features_check() as ndo_features_check callback, this
>     > >> seems to indicate to me that the ndo_features_check callback of lowerdev is
>     > >> ignored. This could explain the issue you see.
>     > >>
>     > >
>     > > macvlan_queue_xmit() calls dev_queue_xmit_accel() after switching skb->dev,
>     > > so the second __dev_queue_xmit() should eventually call the real_dev
>     > > ndo_features_check()
>     > >
>     > Thanks, Eric. There's a second path in macvlan_queue_xmit() calling
>     > dev_forward_skb(vlan->lowerdev, skb). Does what you said apply also there?
> 
>     This path wont send packets to the physical NIC, packets are injected
>     back via dev_forward_skb()
> 
>     >
>     > Still I find it strange that a tx hw checksumming issue should affect multicasts
>     > only. Also the chip version in question is quite common and I would expect
>     > others to have hit the same issue.
>     > Maybe best would be to re-test on the affected system w/o involving macvlen.
>     >
>     > >
>     > >
>     > >> Would be interesting to see whether it fixes your issue if you let the
>     > >> macvlen ndo_features_check call lowerdev's ndo_features_check. Can you try this?
>     > >>
>     > >> By the way:
>     > >> Also the ndo_fix_features callback of lowerdev seems to be ignored.
>     >
> 
> 
> 
> -- 
> 
> logo wifirst <http://www.wifirst.fr/en> 	
> 
> Charles Daymand
> 
> Développeur infrastructure
> 
> 26 rue de Berri 75008 Paris
> 
> Assistance dédiée responsable de site - 01 70 70 46 70
> Assistance utilisateur - 01 70 70 46 26
> 

