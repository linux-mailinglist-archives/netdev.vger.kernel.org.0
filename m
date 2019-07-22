Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B8370644
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 18:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730299AbfGVQ6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 12:58:05 -0400
Received: from mail-io1-f49.google.com ([209.85.166.49]:41664 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728343AbfGVQ6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 12:58:05 -0400
Received: by mail-io1-f49.google.com with SMTP id j5so71315028ioj.8
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 09:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=gIf352xDBbXRR+P0OVKHmjFl0hejjnlnQ7lP7lK+bnY=;
        b=EZNKZbqdd7Wry4zdBVH70ii8cUpPHhFjKgzimIky1NCGBfNbo8KsudQ3SLHGXFVRfy
         KGVzG5zmr6Kao/Jms+iuryg5G2RF6NTdu86O9oRiK56IEmkcHhlGc2zAxBoZlEVei1sX
         Mc95OYTU0QHxFXP7xdMrR88IakmrjYYraAjBRsx/e27fMiJHcYjXZuiXZdhYpC2z73p6
         14QDEf96TfC7/7T8dgywcT1nWckBIdFJS05vdYHjHnQDB2CIl9D4U+q3QkR57rz/mzj3
         vaBTOccqBySKFBYlia/PDve8ZzOYd4EDlvg8W+ktn983Pvary5ChqK7kWL+asYD1RILJ
         PbBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=gIf352xDBbXRR+P0OVKHmjFl0hejjnlnQ7lP7lK+bnY=;
        b=E1Emg119kWu1fzu8tojxX9lqlSGk63G8uA/9DrDjQ60YC1A8XTkctQKl8n6odxGjLZ
         UWnwgvQwVgCRpdQNaReCsN2U/6APJi0muBRaT8kVbm3exgVlKtvyY6fLpc4ThiSpBb5q
         9UUqogfrMqZ3j+1k//d3iMqGerWmhuxP9kKi89oGwt2/uaYgyOavkJE6rJl2F7kkCA5O
         G3p0NPu3v0Y4YRdN98BJTRqD9XcdyrAwYyo0JzfzL8wM/vcLG/0RsZWJ890fCGRIeexy
         Jh72Ve8qrl0jfnlplWjCWrCrm3fNg/9mhr9R+Rszd5+3TFErnUnQcx9OGBypbKHw2g+p
         XGxg==
X-Gm-Message-State: APjAAAUjT1FY59C3q+Kf6yezW5i/wCpS4hX1774BfE1JtdPI6X+cpk7q
        mVb5JnXYV1I+SoKM9dApQZ9xRyEHjeXamw/lFTbgMZ/0
X-Google-Smtp-Source: APXvYqz5sZzPPU7ZIfAUAQ5GldpAIF6Z6bZ3F5DJcoY6ct/y1wLNEqACmiQEV7rQ6oKL6Da+yuSijY8ARL06jEHvJGk=
X-Received: by 2002:a02:1c0a:: with SMTP id c10mr76342556jac.69.1563814684284;
 Mon, 22 Jul 2019 09:58:04 -0700 (PDT)
MIME-Version: 1.0
From:   Anand Raj Manickam <anandrm@gmail.com>
Date:   Mon, 22 Jul 2019 18:57:52 +0200
Message-ID: <CAEyr1FS-8uBEMBS+7U4K8wBLJgPZD0Lxa4FyzuvYZ0RGhTH8fA@mail.gmail.com>
Subject: b53 DSA : vlan tagging broken ?
To:     f.fainelli@gmail.com, netdev@vger.kernel.org, andrew@lunn.ch
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi ,
I had working DSA with 4.9.184 kernel, with BCM53125, rev 4 hardware .
It had 2 bridges with
br0            8000.00       no              lan1
                                                        lan2
                                                        lan3
                                                        eth0.101

br1            8000.01     no             eth0.102
                                                    wan
# bridge vlan
port    vlan ids
wan      102 PVID Egress Untagged
wan      102 PVID Egress Untagged
lan3     101 PVID Egress Untagged
lan3     101 PVID Egress Untagged
lan2     101 PVID Egress Untagged
lan2     101 PVID Egress Untagged
lan1     101 PVID Egress Untagged
lan1     101 PVID Egress Untagged
eth0.102  102 PVID
eth0.102
br1     1 PVID Egress Untagged
eth0.101  101 PVID
eth0.101
br0     1 PVID Egress Untagged

I upgrade the kernel to 5.2 . The behavior is broken. I had to rip the
config and check what was broken from the init scripts.
the bridge vlan commands failed to add , as the newer kernel requires
the vlan interfaces to be up .
https://lkml.org/lkml/2018/5/22/887  - i had the same behaviour as this thread .
I re added them manually  , so the we have the same bridge to vlan
mapping as the previous kernel .
but the ingress packets for WAN where going to LAN(bridge) and the
egress packets where on WAN(bridge)  but the packets never leaves the
interface .

I test this with a simple config :
 ip link add link eth0 name eth0.101 type vlan id 101
 ip link add link eth0 name eth0.102 type vlan id 102
 ip link set eth0.101 up
 ip link set eth0.102 up
 ip link add br0 type bridge
  ip link add br1 type bridge
  ip link set lan1 master br1
  ip link set lan2 master br1
  ip link set lan3 master br1
  ip link set wan master br0
  bridge vlan add vid 101 dev lan1 pvid untagged
  bridge vlan add vid 101 dev lan2 pvid untagged
  bridge vlan add vid 101 dev lan3 pvid untagged
  bridge vlan add vid 102 dev wan pvid untagged
  bridge vlan del vid 1 dev wan
  bridge vlan del vid 1 dev lan1
  bridge vlan del vid 1 dev lan2
  bridge vlan del vid 1 dev lan3
  ip link set eth0.101 master br1
  ip link set eth0.102 master br0
  bridge vlan del vid 1 dev eth0.102
 bridge vlan del vid 1 dev eth0.101
  bridge vlan add vid 102 dev eth0.102 pvid
  bridge vlan add vid 101 dev eth0.101 pvid
  ifconfig br0 up
  ifconfig br1 up
  ifconfig wan up
  ifconfig lan1 up
  ifconfig lan2 up
  ifconfig lan3 up

I donot see any packets with a tag on eth0
~# bridge vlan
port    vlan ids
wan      102 PVID Egress Untagged
lan3     101 PVID Egress Untagged
lan2     101 PVID Egress Untagged
lan1     101 PVID Egress Untagged
eth0.101         101 PVID
eth0.102         102 PVID
br0      1 PVID Egress Untagged
br1      1 PVID Egress Untagged

These are the loaded modules:
# lsmod
Module                  Size  Used by
b53_mdio               16384  0
b53_mmap               16384  0
b53_common             28672  2 b53_mdio,b53_mmap
tag_8021q              16384  0
dsa_core               32768  9 b53_mdio,b53_common,b53_mmap,tag_8021q
phylink                20480  2 b53_common,dsa_core

if i re config
#bridge vlan add vid 102 dev wan pvid untagged
#bridge vlan add vid 102 dev eth0.102 pvid
Then i see the tags for ingress packets . but no packets are
transmitted out on the wire , but the stats in ifconfig show as
transmitted .
# ifconfig br0
br0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.17.33.137  netmask 255.255.255.0  broadcast 10.17.33.255
        inet6 fe80::3ef8:4aff:fe9c:5a04  prefixlen 64  scopeid 0x20<link>
        ether 3c:f8:4a:9c:5a:04  txqueuelen 1000  (Ethernet)
        RX packets 616  bytes 32351 (31.5 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 679  bytes 30286 (29.5 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

#ifconfig eth0
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet6 fe80::d6:5ff:fec2:93af  prefixlen 64  scopeid 0x20<link>
        ether 02:d6:05:c2:93:af  txqueuelen 1000  (Ethernet)
        RX packets 58017  bytes 4004093 (3.8 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 4322  bytes 301365 (294.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 56

Can some shed some light on this config .
-Anand
