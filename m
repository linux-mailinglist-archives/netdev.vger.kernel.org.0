Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E949B71A48
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 16:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730456AbfGWO02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 10:26:28 -0400
Received: from mail-io1-f44.google.com ([209.85.166.44]:40732 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729666AbfGWO01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 10:26:27 -0400
Received: by mail-io1-f44.google.com with SMTP id h6so82186773iom.7
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 07:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=IozzUXfRfCiIIEHSqnlEhUJa2Kj66jKRA7sPvJWeaG0=;
        b=V81oySZKMVJ+49oFjY12tt5T5XujO9YLQQnyD+Hy/UNeZwM9Wl3OeO8YRdqD4heI3f
         lIv5R3ss0I5TXK5HDXADJ5iD6IQ+N3kDKICHWtFrQbsHSpFTrE+5jbUqgHIJPODQmY+6
         CYwrO+ofCYuLWDozWBceVRgM3srppK2O0ny0BMkH2OrHhMgm6JiVkZbA4JaNj7rN7zMn
         VYnIO5w/eKWfLJ+eSFKI4SybXNxzUV7xUIbu4OCQzWR6DA7N6YHnCEIq8+yc/TO1QsDR
         Qeg+3fyV3E0ARoEuaQttN2xTrImacdy+fwaRDy4jmUyRDTO19TjlZUmPpKqHC6cYfRar
         n6fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=IozzUXfRfCiIIEHSqnlEhUJa2Kj66jKRA7sPvJWeaG0=;
        b=U8IknnsDab/JSdsKXWVUVnNSbpYOCL9OiPCHF384QZbn98VUSQ8M4/P1yRxlEG0VwQ
         Epk2lHXdnmf3SaKGbutwmldlSk2Am5amvsTXKFMM27O+QtlyKAL1NWlM7wP45U11qmFQ
         MWnH7KQuDfsU/DmlT8/HuhpLQhcPs43menp8dD6A8G5MK43xYCAST6kmcvtuoJnWx5oW
         NycHvk9uxc4UlBZdAE1aZkoS31kV3tlLgn7CFD/j7dVApk445c8ww8uzYitvXhRUnpH2
         7L3MEhKfibT5UpDfw+FKpRd8nvdeWheEPXT6kQAqhhIBtEeYfKlyMEnmWJ0fy0cT50ti
         GlXQ==
X-Gm-Message-State: APjAAAXtlXWzSz8HAHBaRcUJ+GILqItYmSAGIa9egQ2qfF0E+xAnjV0y
        Udu5Dvcm9D6ODSPPx3M0ESSGmt/OAQiAl2QuBJ0=
X-Google-Smtp-Source: APXvYqw3PcSzYIvvo+Hm0KxG4wf9V5j1kp+m/0nC3DA/7QxTY0banjsuFe/gKQTzqzNbMjoKFBRJqgNFtYZkiT7GWw8=
X-Received: by 2002:a05:6638:149:: with SMTP id y9mr79808145jao.76.1563891986513;
 Tue, 23 Jul 2019 07:26:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAEyr1FS-8uBEMBS+7U4K8wBLJgPZD0Lxa4FyzuvYZ0RGhTH8fA@mail.gmail.com>
In-Reply-To: <CAEyr1FS-8uBEMBS+7U4K8wBLJgPZD0Lxa4FyzuvYZ0RGhTH8fA@mail.gmail.com>
From:   Anand Raj Manickam <anandrm@gmail.com>
Date:   Tue, 23 Jul 2019 16:26:14 +0200
Message-ID: <CAEyr1FSGYCxKqN0_L+42Kuw3hXEVQkV2J6f9hrHZWFOnZ7PzOg@mail.gmail.com>
Subject: Re: b53 DSA : vlan tagging broken ?
To:     f.fainelli@gmail.com, netdev@vger.kernel.org, andrew@lunn.ch
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The issue is resolved by enabling vlan_filtering for the bridge and
fix the phy-mode to "rgmii" from "rgmii-txid" in the dts file.


On Mon, Jul 22, 2019 at 6:57 PM Anand Raj Manickam <anandrm@gmail.com> wrote:
>
> Hi ,
> I had working DSA with 4.9.184 kernel, with BCM53125, rev 4 hardware .
> It had 2 bridges with
> br0            8000.00       no              lan1
>                                                         lan2
>                                                         lan3
>                                                         eth0.101
>
> br1            8000.01     no             eth0.102
>                                                     wan
> # bridge vlan
> port    vlan ids
> wan      102 PVID Egress Untagged
> wan      102 PVID Egress Untagged
> lan3     101 PVID Egress Untagged
> lan3     101 PVID Egress Untagged
> lan2     101 PVID Egress Untagged
> lan2     101 PVID Egress Untagged
> lan1     101 PVID Egress Untagged
> lan1     101 PVID Egress Untagged
> eth0.102  102 PVID
> eth0.102
> br1     1 PVID Egress Untagged
> eth0.101  101 PVID
> eth0.101
> br0     1 PVID Egress Untagged
>
> I upgrade the kernel to 5.2 . The behavior is broken. I had to rip the
> config and check what was broken from the init scripts.
> the bridge vlan commands failed to add , as the newer kernel requires
> the vlan interfaces to be up .
> https://lkml.org/lkml/2018/5/22/887  - i had the same behaviour as this thread .
> I re added them manually  , so the we have the same bridge to vlan
> mapping as the previous kernel .
> but the ingress packets for WAN where going to LAN(bridge) and the
> egress packets where on WAN(bridge)  but the packets never leaves the
> interface .
>
> I test this with a simple config :
>  ip link add link eth0 name eth0.101 type vlan id 101
>  ip link add link eth0 name eth0.102 type vlan id 102
>  ip link set eth0.101 up
>  ip link set eth0.102 up
>  ip link add br0 type bridge
>   ip link add br1 type bridge
>   ip link set lan1 master br1
>   ip link set lan2 master br1
>   ip link set lan3 master br1
>   ip link set wan master br0
>   bridge vlan add vid 101 dev lan1 pvid untagged
>   bridge vlan add vid 101 dev lan2 pvid untagged
>   bridge vlan add vid 101 dev lan3 pvid untagged
>   bridge vlan add vid 102 dev wan pvid untagged
>   bridge vlan del vid 1 dev wan
>   bridge vlan del vid 1 dev lan1
>   bridge vlan del vid 1 dev lan2
>   bridge vlan del vid 1 dev lan3
>   ip link set eth0.101 master br1
>   ip link set eth0.102 master br0
>   bridge vlan del vid 1 dev eth0.102
>  bridge vlan del vid 1 dev eth0.101
>   bridge vlan add vid 102 dev eth0.102 pvid
>   bridge vlan add vid 101 dev eth0.101 pvid
>   ifconfig br0 up
>   ifconfig br1 up
>   ifconfig wan up
>   ifconfig lan1 up
>   ifconfig lan2 up
>   ifconfig lan3 up
>
> I donot see any packets with a tag on eth0
> ~# bridge vlan
> port    vlan ids
> wan      102 PVID Egress Untagged
> lan3     101 PVID Egress Untagged
> lan2     101 PVID Egress Untagged
> lan1     101 PVID Egress Untagged
> eth0.101         101 PVID
> eth0.102         102 PVID
> br0      1 PVID Egress Untagged
> br1      1 PVID Egress Untagged
>
> These are the loaded modules:
> # lsmod
> Module                  Size  Used by
> b53_mdio               16384  0
> b53_mmap               16384  0
> b53_common             28672  2 b53_mdio,b53_mmap
> tag_8021q              16384  0
> dsa_core               32768  9 b53_mdio,b53_common,b53_mmap,tag_8021q
> phylink                20480  2 b53_common,dsa_core
>
> if i re config
> #bridge vlan add vid 102 dev wan pvid untagged
> #bridge vlan add vid 102 dev eth0.102 pvid
> Then i see the tags for ingress packets . but no packets are
> transmitted out on the wire , but the stats in ifconfig show as
> transmitted .
> # ifconfig br0
> br0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
>         inet 10.17.33.137  netmask 255.255.255.0  broadcast 10.17.33.255
>         inet6 fe80::3ef8:4aff:fe9c:5a04  prefixlen 64  scopeid 0x20<link>
>         ether 3c:f8:4a:9c:5a:04  txqueuelen 1000  (Ethernet)
>         RX packets 616  bytes 32351 (31.5 KiB)
>         RX errors 0  dropped 0  overruns 0  frame 0
>         TX packets 679  bytes 30286 (29.5 KiB)
>         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
>
> #ifconfig eth0
> eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
>         inet6 fe80::d6:5ff:fec2:93af  prefixlen 64  scopeid 0x20<link>
>         ether 02:d6:05:c2:93:af  txqueuelen 1000  (Ethernet)
>         RX packets 58017  bytes 4004093 (3.8 MiB)
>         RX errors 0  dropped 0  overruns 0  frame 0
>         TX packets 4322  bytes 301365 (294.3 KiB)
>         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
>         device interrupt 56
>
> Can some shed some light on this config .
> -Anand
