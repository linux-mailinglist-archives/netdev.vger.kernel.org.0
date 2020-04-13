Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFFA1A6C02
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 20:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732985AbgDMSU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 14:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728022AbgDMSU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 14:20:57 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F613C0A3BDC
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 11:20:56 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id o70so5703319ybg.10
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 11:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y06H51600mWB591S/UP/6kYIRxhe3bQEtmLPnqLaiRc=;
        b=baVqC0f2KI3BjViiGsRkMUBEChd+G9sN4ksAI35lNJ59oIGd+5WvinF4nz932+Jskb
         X7HbAHg4T4tuXO44qOwbaBfBrPVYIwX1SM86ovh+1INqlpWjG/bPlakbKoZFsoiZVsgB
         rOmHQ91akbo3P+fK7u767CSEMlxLd97EQtxp29NAplyMP92UM1SvQzdfee9hpQ1q1SXC
         bev/irCoFHlf5xMtWlLH81dljQ1dYcSdQQo9ccq4zA9IK8axNRaU+A/26rFvDSOI1bfl
         SLbpTECAk82dhHDFqe+I6Vh0l3ResvGXgEgtOPZBowCQgTUEOMJue8dsWT9guiN/YzQN
         bkBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Y06H51600mWB591S/UP/6kYIRxhe3bQEtmLPnqLaiRc=;
        b=YI0mhnvlu6Y8cZWyD02StKxq+MIQwejJUklSBkK/NypjD/IhBdJhByXuD2VG9MrMTK
         c/wIhTVgs109kBOd4VzRldQZ+8wEgxl7aU1LnSeKWtdzGG/GmyoOyhJCGulNk9RT7GIF
         D9lgt8ysNJVkkRnOXx1rCjoIFxKXEdtV/RINQm+O8NzZELztnfvw4F12C4AAJao0zsY+
         FcJvKUgl0OnBukDeYuxmYQrDS10hFJ5tfiXvjRoIi7nUaS7oPFDcj7GUxyn6DhOZ3hn3
         k+ynt2LGSLEoR/SrUZAUvdo4SqWZDLHpgE7cVIJ15RnwTQxUb03jr06n4qJ5yiKSEiI/
         fK4Q==
X-Gm-Message-State: AGi0PuaKGDl4hI1gefvlOz5qZKtWbJSTqmZS3NKLE0QWXyHjDJsMEuwp
        k1mhHp3gjG4YOw3d8+39rJ7XHpswRG9tluL9DrMdfw==
X-Google-Smtp-Source: APiQypImqVojmR+hDgFdkd+7sDfGHxDcrhb7IVAhBq59TQ265vsKu0TMk559SWGe3U2cQzyRAQUIKeZTN6KK2DB6Mic=
X-Received: by 2002:a5b:bc8:: with SMTP id c8mr28643544ybr.395.1586802054832;
 Mon, 13 Apr 2020 11:20:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200327090800.27810-1-charles.daymand@wifirst.fr>
 <0bab7e0b-7b22-ad0f-2558-25602705e807@gmail.com> <d7a0eca8-15aa-10da-06cc-1eeef3a7a423@gmail.com>
 <CANn89iKA8k3GyxCKCJRacB42qcFqUDsiRhFOZxOQ7JCED0ChyQ@mail.gmail.com>
 <42f81a4a-24fc-f1fb-11db-ea90a692f249@gmail.com> <CANn89i+A=Mu=9LMscd2Daqej+uVLc3E6w33MZzTwpe2v+k89Mw@mail.gmail.com>
 <CAFJtzm03QpjGRs70tth26BdUFN_o8zsJOccbnA58ma+2uwiGcg@mail.gmail.com>
 <c02274b9-1ba0-d5e9-848f-5d6761df20f4@gmail.com> <CAFJtzm0H=pztSp_RQt_YNnPHQkq4N4Z5S-PqMFgE=Fp=Fo-G_w@mail.gmail.com>
 <297e210f-1784-44a9-17fb-7fbe8b6f9ec3@gmail.com>
In-Reply-To: <297e210f-1784-44a9-17fb-7fbe8b6f9ec3@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 13 Apr 2020 11:20:43 -0700
Message-ID: <CANn89iKA8MAef-XfkbLG3W+3=qUx4pqmKuWPBfrxAcupohLkyA@mail.gmail.com>
Subject: Re: [PATCH net] r8169: fix multicast tx issue with macvlan interface
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Charles DAYMAND <charles.daymand@wifirst.fr>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 11:06 AM Heiner Kallweit <hkallweit1@gmail.com> wro=
te:
>
> On 06.04.2020 16:12, Charles DAYMAND wrote:
> > Hello,
> > Sorry for the long delay, I didn't have physical access to the
> > hardware last week. I did more testing today by connecting directly my
> > laptop to the hardware and the issue not only affects multicast but
> > also unicast with macvlan.
> > Only ping packets are correctly sent.
> > Using wireshark I can only see malformed ethernet packets (example
> > with multicast packet below)
> > Frame 1: 106 bytes on wire (848 bits), 106 bytes captured (848 bits)
> > IEEE 802.3 Ethernet
> >     Destination: IPv4mcast_09 (01:00:5e:00:00:09)
> >     Source: b2:41:6f:04:c1:86 (b2:41:6f:04:c1:86)
> >     Length: 96
> >         [Expert Info (Error/Malformed): Length field value goes past
> > the end of the payload]
> > Logical-Link Control
> >     DSAP: Unknown (0x45)
> >     SSAP: Unknown (0xc0)
> >     Control field: I, N(R)=3D46, N(S)=3D0 (0x5C00)
> > Data (88 bytes)
> >     Data: 50320c780111087fac159401e0000009020802080048207a...
> >     [Length: 88]
> > Please find the full pcap file at this url with also a tentative to
> > establish a ssh connection :
> > https://fourcot.fr/temp/malformed_ethernet2.pcap
> >
>
> A problem with HW checksumming should manifest as checksum failure,
> I don't think HW checksumming touches length information in headers.
> You could enable tracing network events to see whether packets look
> suspicious before reaching the network driver.
> (or do some printf debugging for the affected multicast packets)
>
> Because you initially suspected a problem with HW checksumming
> in a specific RTL8168 chip variant:
> - Check macvlan with another network driver supporting HW checksumming
> - Check macvlan with r8169 and another RTL8168 chip variant
>
> The fact that the issue doesn't exist w/o macvlan seems to indicate
> that the network driver can't be blamed here.

trace includes evidence of 802.1Q traffic though, maybe "macvlan" is a
red herring,
some confusion on wording maybe...

802.1Q Virtual LAN, PRI: 0, DEI: 0, ID: 2833
    000. .... .... .... =3D Priority: Best Effort (default) (0)
    ...0 .... .... .... =3D DEI: Ineligible
    .... 1011 0001 0001 =3D ID: 2833


>
> > Best regards
> >
> > Charles
> >
> >
> > Le mar. 31 mars 2020 =C3=A0 16:07, Heiner Kallweit <hkallweit1@gmail.co=
m> a =C3=A9crit :
> >>
> >> Thanks for further testing! The good news from my perspective is that =
the issue doesn't occur
> >> w/o macvlen, therefore it doesn't seem to be a r8169 network driver is=
sue.
> >>
> >> W/o knowing tcpdump in detail I think it switches the NIC to promiscuo=
us mode, means
> >> it should see all packets, incl. the ones with checksum errors.
> >> Maybe you can mirror the port to which the problematic system is conne=
cted and
> >> analyze the traffic. Or for whatever reason the switch doesn't forward=
 the multicast
> >> packets to your notebook.
> >>
> >> Heiner
> >>
> >>
> >> On 31.03.2020 15:44, Charles DAYMAND wrote:
> >>> Hello,
> >>> We tested to enable tx checksumming manually (via ethtool) on a kerne=
l 4.19.0-5-amd64 which is the oldest kernel compatible with our software an=
d we observed exactly the same issue.
> >>> For information when connecting a laptop directly to the interface we=
 can't see any multicast packet when tx checksumming is enabled on tcpdump.
> >>> Our network is composed of a cisco switch and we can still see the mu=
lticast counters correctly increasing even when we have the issue.
> >>>
> >>> I also confirm that when not using macvlan but the real interface the=
re is no issue on the multicast packets, they are correctly sent and receiv=
ed.
> >>> I have a stupid question, if the IP checksum was bad on the multicast=
 packet, would the receiver NIC drop the packet or would it be seen by tcpd=
ump by the receiver ?
> >>>
> >>> Le ven. 27 mars 2020 =C3=A0 20:43, Eric Dumazet <edumazet@google.com =
<mailto:edumazet@google.com>> a =C3=A9crit :
> >>>
> >>>     On Fri, Mar 27, 2020 at 12:17 PM Heiner Kallweit <hkallweit1@gmai=
l.com <mailto:hkallweit1@gmail.com>> wrote:
> >>>     >
> >>>     > On 27.03.2020 19:52, Eric Dumazet wrote:
> >>>     > > On Fri, Mar 27, 2020 at 10:41 AM Heiner Kallweit <hkallweit1@=
gmail.com <mailto:hkallweit1@gmail.com>> wrote:
> >>>     > >>
> >>>     > >> On 27.03.2020 10:39, Heiner Kallweit wrote:
> >>>     > >>> On 27.03.2020 10:08, Charles Daymand wrote:
> >>>     > >>>> During kernel upgrade testing on our hardware, we found th=
at macvlan
> >>>     > >>>> interface were no longer able to send valid multicast pack=
et.
> >>>     > >>>>
> >>>     > >>>> tcpdump run on our hardware was correctly showing our mult=
icast
> >>>     > >>>> packet but when connecting a laptop to our hardware we did=
n't see any
> >>>     > >>>> packets.
> >>>     > >>>>
> >>>     > >>>> Bisecting turned up commit 93681cd7d94f
> >>>     > >>>> "r8169: enable HW csum and TSO" activates the feature NETI=
F_F_IP_CSUM
> >>>     > >>>> which is responsible for the drop of packet in case of mac=
vlan
> >>>     > >>>> interface. Note that revision RTL_GIGA_MAC_VER_34 was alre=
ady a specific
> >>>     > >>>> case since TSO was keep disabled.
> >>>     > >>>>
> >>>     > >>>> Deactivating NETIF_F_IP_CSUM using ethtool is correcting o=
ur multicast
> >>>     > >>>> issue, but we believe that this hardware issue is importan=
t enough to
> >>>     > >>>> keep tx checksum off by default on this revision.
> >>>     > >>>>
> >>>     > >>>> The change is deactivating the default value of NETIF_F_IP=
_CSUM for this
> >>>     > >>>> specific revision.
> >>>     > >>>>
> >>>     > >>>
> >>>     > >>> The referenced commit may not be the root cause but just re=
veal another
> >>>     > >>> issue that has been existing before. Root cause may be in t=
he net core
> >>>     > >>> or somewhere else. Did you check with other RTL8168 version=
s to verify
> >>>     > >>> that it's indeed a HW issue with this specific chip version=
?
> >>>     > >>>
> >>>     > >>> What you could do: Enable tx checksumming manually (via eth=
tool) on
> >>>     > >>> older kernel versions and check whether they are fine or no=
t.
> >>>     > >>> If an older version is fine, then you can start a new bisec=
t with tx
> >>>     > >>> checksumming enabled.
> >>>     > >>>
> >>>     > >>> And did you capture and analyze traffic to verify that actu=
ally the
> >>>     > >>> checksum is incorrect (and packets discarded therefore on r=
eceiving end)?
> >>>     > >>>
> >>>     > >>>
> >>>     > >>>> Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
> >>>     > >>>> Signed-off-by: Charles Daymand <charles.daymand@wifirst.fr=
 <mailto:charles.daymand@wifirst.fr>>
> >>>     > >>>> ---
> >>>     > >>>>  net/drivers/net/ethernet/realtek/r8169_main.c | 3 +++
> >>>     > >>>>  1 file changed, 3 insertions(+)
> >>>     > >>>>
> >>>     > >>>> diff --git a/net/drivers/net/ethernet/realtek/r8169_main.c=
 b/net/drivers/net/ethernet/realtek/r8169_main.c
> >>>     > >>>> index a9bdafd15a35..3b69135fc500 100644
> >>>     > >>>> --- a/net/drivers/net/ethernet/realtek/r8169_main.c
> >>>     > >>>> +++ b/net/drivers/net/ethernet/realtek/r8169_main.c
> >>>     > >>>> @@ -5591,6 +5591,9 @@ static int rtl_init_one(struct pci_d=
ev *pdev, const struct pci_device_id *ent)
> >>>     > >>>>              dev->vlan_features &=3D ~(NETIF_F_ALL_TSO | N=
ETIF_F_SG);
> >>>     > >>>>              dev->hw_features &=3D ~(NETIF_F_ALL_TSO | NET=
IF_F_SG);
> >>>     > >>>>              dev->features &=3D ~(NETIF_F_ALL_TSO | NETIF_=
F_SG);
> >>>     > >>>> +            if (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_3=
4) {
> >>>     > >>>> +                    dev->features &=3D ~NETIF_F_IP_CSUM;
> >>>     > >>>> +            }
> >>>     > >>>>      }
> >>>     > >>>>
> >>>     > >>>>      dev->hw_features |=3D NETIF_F_RXALL;
> >>>     > >>>>
> >>>     > >>>
> >>>     > >>
> >>>     > >> After looking a little bit at the macvlen code I think there=
 might be an
> >>>     > >> issue in it, but I'm not sure, therefore let me add Eric (as=
 macvlen doesn't
> >>>     > >> seem to have a dedicated maintainer).
> >>>     > >>
> >>>     > >> r8169 implements a ndo_features_check callback that disables=
 tx checksumming
> >>>     > >> for the chip version in question and small packets (due to a=
 HW issue).
> >>>     > >> macvlen uses passthru_features_check() as ndo_features_check=
 callback, this
> >>>     > >> seems to indicate to me that the ndo_features_check callback=
 of lowerdev is
> >>>     > >> ignored. This could explain the issue you see.
> >>>     > >>
> >>>     > >
> >>>     > > macvlan_queue_xmit() calls dev_queue_xmit_accel() after switc=
hing skb->dev,
> >>>     > > so the second __dev_queue_xmit() should eventually call the r=
eal_dev
> >>>     > > ndo_features_check()
> >>>     > >
> >>>     > Thanks, Eric. There's a second path in macvlan_queue_xmit() cal=
ling
> >>>     > dev_forward_skb(vlan->lowerdev, skb). Does what you said apply =
also there?
> >>>
> >>>     This path wont send packets to the physical NIC, packets are inje=
cted
> >>>     back via dev_forward_skb()
> >>>
> >>>     >
> >>>     > Still I find it strange that a tx hw checksumming issue should =
affect multicasts
> >>>     > only. Also the chip version in question is quite common and I w=
ould expect
> >>>     > others to have hit the same issue.
> >>>     > Maybe best would be to re-test on the affected system w/o invol=
ving macvlen.
> >>>     >
> >>>     > >
> >>>     > >
> >>>     > >> Would be interesting to see whether it fixes your issue if y=
ou let the
> >>>     > >> macvlen ndo_features_check call lowerdev's ndo_features_chec=
k. Can you try this?
> >>>     > >>
> >>>     > >> By the way:
> >>>     > >> Also the ndo_fix_features callback of lowerdev seems to be i=
gnored.
> >>>     >
> >>>
> >>>
> >>>
> >>> --
> >>>
> >>> logo wifirst <http://www.wifirst.fr/en>
> >>>
> >>> Charles Daymand
> >>>
> >>> D=C3=A9veloppeur infrastructure
> >>>
> >>> 26 rue de Berri 75008 Paris
> >>>
> >>> Assistance d=C3=A9di=C3=A9e responsable de site - 01 70 70 46 70
> >>> Assistance utilisateur - 01 70 70 46 26
> >>>
> >>
> >
> >
>
