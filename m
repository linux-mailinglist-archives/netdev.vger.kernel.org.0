Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E4D496796
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 22:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbiAUVv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 16:51:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiAUVv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 16:51:27 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5FAC06173B
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 13:51:26 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id n16-20020a17090a091000b001b46196d572so10160143pjn.5
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 13:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KMgZ+hFNpxKQh8zmJxw0whmaYtwTxbU8YZmmPFxjVfA=;
        b=SUl84698EAfjEnH8/fku4Lq07fQ8zwlpzOPrwMFhCcjXiMO8ZW6OhJcmMNfKHsyfk0
         JWnsiAvoX0HAiwKmS0veZNmINCb5oFWl2UDD87VFQbJkxIDyjnNhp4vDlnB0Hrq8xHdJ
         sRxpV7VW+/RFtBmjHRn1heutUgdFyHg0n1/0Lq1T6VeY4CqmER5CpB/W3jUCLJtFrM0W
         hHFFgNk6Y7gRnlkuHfPe6GFasxZmfRmh+SIyKqCl/rTAKQUFLYTNf3Ua8R34S3YUUtht
         ESdOC7RZiEogj6nKlGb5C4XQoG20PlIP7icd765PWgSGQlsMUM2UwpXWIq3XTOeiRuDw
         NiVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KMgZ+hFNpxKQh8zmJxw0whmaYtwTxbU8YZmmPFxjVfA=;
        b=MTW9ftelU4UmTy6H32pj3fpxEa60dHRXLG4oB2m9Xz6OwZVRDIWwxkpVS0hOwuAPx9
         JEZQjyL8pIy2h++GAantgW528yJunTdnO4d/Blbdqgipgu94NgNstxXe1pnlQD8MfCic
         yZ5rbzovpszrD1xf2kqEcYtFfcEIuVgr0vwKCdzd8J8upgVCdzb9X03EVDOCBGjJT+J9
         y9bXso7EajU8LGEOU+cicKaBzLe+HZi3DoLNllaMh9ILfCSaGnq5I3TQpdjENaWCQBRA
         3xhtzFV5g1ztYd2tYmPeDHYWf/uw5SiNn6fnkr/XK6EZJt20tLrc1rRGO+Y2jTBumQOr
         nQDQ==
X-Gm-Message-State: AOAM532xGyhuALyVISH/9hT7+3/nsDPXk/nywwyT8NrHIXuwGV1UQufz
        q34UAgtQ5ePcY9oJMPgDj2xlky/Luq6eNtl+Oko=
X-Google-Smtp-Source: ABdhPJx032Ik0CeT1yc3YtW3QnE5yUzT087xDfsEvKWCl0iUZXUZDvih6fztdXheU9Mtd3Ziq/vGVjEZCoi15f3LJKU=
X-Received: by 2002:a17:902:7401:b0:14b:1339:58cf with SMTP id
 g1-20020a170902740100b0014b133958cfmr5260117pll.66.1642801886029; Fri, 21 Jan
 2022 13:51:26 -0800 (PST)
MIME-Version: 1.0
References: <87r19e5e8w.fsf@bang-olufsen.dk> <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
 <87v8ynbylk.fsf@bang-olufsen.dk> <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
 <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
 <Yea+uTH+dh9/NMHn@lunn.ch> <20220120151222.dirhmsfyoumykalk@skbuf>
 <CAJq09z6UE72zSVZfUi6rk_nBKGOBC0zjeyowHgsHDHh7WyH0jA@mail.gmail.com>
 <20220121020627.spli3diixw7uxurr@skbuf> <CAJq09z5HbnNEcqN7LZs=TK4WR1RkjoefF_6ib-hFu2RLT54Nug@mail.gmail.com>
 <20220121185009.pfkh5kbejhj5o5cs@skbuf>
In-Reply-To: <20220121185009.pfkh5kbejhj5o5cs@skbuf>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 21 Jan 2022 18:51:14 -0300
Message-ID: <CAJq09z7v90AU=kxraf5CTT0D4S6ggEkVXTQNsk5uWPH-pGr7NA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I'm still getting used to it ;-)
> >
> > In this thread, Alvin suggested adding a new property to define which
> > port will be used as trap_port instead of using the last CPU port.
> > Should I try something different?
> >
> >         switch1 {
> >                compatible =3D "realtek,rtl8367s";
> >                reg =3D <29>;
> >
> >                realtek,trap-port =3D <&port7>;
> >
> >                ports {
> >                         ....
> >                         port7: port@7 {
> >                             ...
> >                        };
> >         };
> >
> > Should I do something differently?
>
> To clarify, I don't know what a trap_port is. I just saw this
> description in rtl8365mb.c:
>
>  * @trap_port: forward trapped frames to this port
>
> but I still don't know to which packets does this configuration apply
> (where are the packet traps installed, and for what kind of packets).

Thank you, Vladimir.

trap_port seems to be where the switch will send any packet captured
from LAN ports. There are a couple of situations it will be used like:
1) untagged or unmatched vlan packets (if configured to do so)
2) some multicasting packets (Reserved Multicast Address), for some
cases like capturing STP or LACP
3) IGMP and 802.1X EAPOL packets
4) Switch ACL rules that could match a packet and send it to the trap port.

In my early tests, I only saw some IGMP packets trapped to CPU. I also
do not know how important they are.

> Speculating here, but it appears quite arbitrary, and I'd guess also
> broken, to make the trap_port the last CPU port. Is this also part of
> the things which you didn't really test? See commit 8d5f7954b7c8 ("net:
> dsa: felix: break at first CPU port during init and teardown") for a
> similar issue with this. When there are multiple 'ethernet =3D <&phandle>=
'
> properties in the device tree, DSA makes the owners of all those
> phandles a DSA master, and all those switch ports as CPU ports. But out
> of all those CPU ports, only the first one is an active CPU port. The
> others have no dp->cpu_dp pointing to them.
> See dsa_tree_setup_default_cpu() -> dsa_tree_find_first_cpu().
> Even when DSA gets full-blown support for multiple CPU ports, I think
> it's safe to say that this default will remain the way it is: a single
> CPU port will be active to begin with: the first one. Given that fact
> (and depending on what you need to do with the trap_port info exactly),
> it might be broken to set as the trap port a CPU port that isn't used.
> Stuff like dsa_port_host_fdb_add()/dsa_port_host_fdb_del() will be
> broken, because they rely on the dp->cpu_dp association, and
> dp->cpu_dp->index will be !=3D trap_port.

Although it would be interesting to have some sniffed traffic sent to
a second CPU port, I agree it might break more things than
it will help. Until multiple CPU ports can be used as first-class
citizens, I'll simply force it to be the first CPU port.

The multiple CPU port is not a target but a byproduct of removing the
assumption that "CPU port" is equal to "external interface port".
The real change is to allow an external interface to be configured,
even if it is not the CPU port, as it could be used to stack a second
switch.
I'll leave the multiple CPU as a note in the commit message and not
the subject. It was wrong to emphasize that.

> > > I think I know what the problem is. But I'd need to know what the dri=
ver
> > > for the DSA master is, to confirm. To be precise, what I'd like to ch=
eck
> > > is the value of master->vlan_features.
> >
> > Here it is 0x1099513266227 (I hope).
>
> That's quite an extraordinary set of vlan_features. In that number, I
> notice BIT(2) is set, which corresponds to __UNUSED_NETIF_F_1. So it
> probably isn't correctly printed.

Oh my... I printed it as an unsigned decimal. Sorry.

>
> This is what I would have liked to see:
>
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 22241afcac81..b41f1b414c69 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1909,6 +1909,7 @@ void dsa_slave_setup_tagger(struct net_device *slav=
e)
>         p->xmit =3D cpu_dp->tag_ops->xmit;
>
>         slave->features =3D master->vlan_features | NETIF_F_HW_TC;
> +       netdev_err(slave, "master %s vlan_features 0x%llx\n", master->nam=
e, master->vlan_features);
>         slave->hw_features |=3D NETIF_F_HW_TC;
>         slave->features |=3D NETIF_F_LLTX;
>         if (slave->needed_tailroom)

0x10000190033. If I got it right:

NETIF_F_SG_BIT
NETIF_F_IP_CSUM_BIT
NETIF_F_IPV6_CSUM_BIT
NETIF_F_HIGHDMA_BIT
NETIF_F_GSO_SHIFT
NETIF_F_TSO_MANGLEID_BIT
NETIF_F_TSO6_BIT
NETIF_F_RXCSUM_BIT

> And I don't think you fully answered Florian's questions either, really.
> Can we see the a link to the code of the Ethernet controller whose role
> is to be a host port (DSA master) for the rtl8365mb switch?

The code is from the OpenWrt tree.
https://github.com/openwrt/openwrt/tree/master/target/linux/ramips/files/dr=
ivers/net/ethernet/ralink

I only patched it to accept Jumbo Frames (it was dropping incoming
packets with MTU 1508)
https://patchwork.ozlabs.org/project/openwrt/list/?series=3D279773

> If that DSA
> master is a DSA switch itself, could you please unroll the chain all the
> way with more links to drivers? No matter whether upstream or downstream,
> just what you use.

OpenWrt (soc mt7620a) eth0 (mtk_eth_soc) connected to internal SoC
MT7530 switch port 6 (, mediatek,mt7620-gsw).
MT7530 port 5 connected to RTL8367S port 7 (RGMII).

The internal SoC switch is behaving as an unmanaged switch, with no
vlans. It would be just extra overhead to have it working as a DSA
switch, specially
as those two switches tags are not compatible. I still have the
swconfig driver installed but I was only using it for some debugging
(checking metrics). I think that the state the bootloader leaves that
switchis enough to make it forward packets to the Realtek switch. In
device-tree conf, I'm directly using that eth0 as the CPU port.

> I hate to guess, but since both you and Ar=C4=B1n=C3=A7 have mentioned th=
e
> mt7620a/mt7621 SoCs,

Sorry for the incomplete answer. If it helps, this is my device
https://github.com/luizluca/openwrt/blob/tplink_c5v4_dsa/target/linux/ramip=
s/dts/mt7620a_tplink_archer-c5-v4.dts

I try to keep my remote branch updated, although it has some dirty changes:
https://github.com/luizluca/openwrt/tree/tplink_c5v4_dsa

> I'd guess that the top-most DSA driver in both cases is "mediatek,eth-mac=
" (drivers/net/ethernet/mediatek/mtk_eth_soc.c).

Not in my case. The driver I use also supports mt7621 but the upstream
driver skipped the mt7620a support.

> If so, this would confirm my suspicions, since it sets its vlan_features
> to include NETIF_F_IP_CSUM and NETIF_F_IPV6_CSUM. Please confirm that
> master->vlan_features contains these 2 bits.

Yes.

> > Oh, this DSA driver still does not implement vlan nor bridge offload.
> > Maybe it would matter.
>
> It doesn't matter. The vlan_features is a confusing name for what it
> really does here. I'll explain in a bit once you clarify the other
> things I asked for.

That is good news as we can deal with it independently. I wish to
focus on that afterwards.

Regards,

Luiz
