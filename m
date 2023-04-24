Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E766EC3A2
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 04:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjDXCgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 22:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjDXCgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 22:36:35 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55A8210A
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 19:36:33 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1a68f2345c5so32681755ad.2
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 19:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1682303793; x=1684895793;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iARGD0irL4Yc/bNVNeGMOiThaeQ4r2v83oKfliG2kss=;
        b=vKr/YrnVJYolHgpERHqWXD3STznvWc6sAIfmAWDWZMhp7DTqmk2zNgjK6hv8B0WYsb
         ItXIDfgDrlkk8+UcmYsFfmg+rfdMQM5MI+n6l5fEgcMymtSGIogFJa4pWsnRYtBs9U9s
         cbOCihlVXzvb9c8jz3Qyr1EYkFfhDcWLKw5An6qtTxi1OubKm6gt5NBFqE/d5YIDtUNg
         YAIGkR1r3VhnC0EWQqn/dOsunJ+XJpPH5CbrOhXElXNj+yWq00qedtJsTanlku8tg/7W
         UlZtm0bcIGWUS6UwPg/AP0VGiAxzmtjWQzBlQioK7gUDwH58eeXg2hhvGkCPGgtggynJ
         ZmUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682303793; x=1684895793;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iARGD0irL4Yc/bNVNeGMOiThaeQ4r2v83oKfliG2kss=;
        b=eQdgGGRMgiIbF2EJoUJMYRgFiaisMuP22+XzwgNZKtBgXaC9lzfO3g3dKYbqxoS4iJ
         yf9VEUeyDjmkpO7iRFuxnI2nQG9YTeK3ixCLA+sthlszHpflVPx60R61QYl9vtjVsofq
         7oaapqENhJ3iAA+1UnqtjrQZF/ZeAl6G+6wZZQFIO60VRSZyIy4W9TTyIBQrhg1FiZBj
         tPdnW8i4BekF5CFdwO3kc1Z9LPUtvqEj1qOm32u96z7PSTTN7vqn8ZSIS/HOhqduZfjj
         v8v3pC+vXeLWDQGesiGyfaOSft4Sf5plc/vW1k5SSzXwFBxMdU8a4FMRyq0UV/I5PMf+
         DYDA==
X-Gm-Message-State: AAQBX9d+wk8pZm/gdY94T1uHALEtxcrtl7CfA6eV8mn27qbsSVZ68+FJ
        Qz2a8ANNyxm6IHYyWeU1yXV5BEDrJCatPxeFaUy3yw==
X-Google-Smtp-Source: AKy350Y8E6lBgC6BEznA+LldtzMCn6ca0MnLcaBkrsw1HeiNuNzRcWPcKmxJQ8XLvF4wLyLN/hpLFg==
X-Received: by 2002:a17:902:b614:b0:1a6:52f9:d4c7 with SMTP id b20-20020a170902b61400b001a652f9d4c7mr10525737pls.60.1682303792916;
        Sun, 23 Apr 2023 19:36:32 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id f3-20020a170902ab8300b0019a97a4324dsm5606435plr.5.2023.04.23.19.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 19:36:31 -0700 (PDT)
Date:   Sun, 23 Apr 2023 19:36:29 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com
Cc:     netdev@vger.kernel.org
Subject: Fw: [Bug 217362] New: Low performance on Realtek RTL8125 2.5Gb NIC
 using r8169 driver
Message-ID: <20230423193629.7eaf63f6@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Sun, 23 Apr 2023 15:36:07 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 217362] New: Low performance on Realtek RTL8125 2.5Gb NIC usi=
ng r8169 driver


https://bugzilla.kernel.org/show_bug.cgi?id=3D217362

            Bug ID: 217362
           Summary: Low performance on Realtek RTL8125 2.5Gb NIC using
                    r8169 driver
           Product: Networking
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: jon780@gmail.com
        Regression: No

Poor performance on receive-side only when using RTL8125 NIC with the in-tr=
ee
r8169 driver.  The performance problems occur only in the receive direction=
. If
I reverse the sender I can get the full 2.5Gb (2.35Gb+overhead) over the li=
nk.=20
=46rom my client if I run iperf3 to other hosts on the same switch I see 2.5G=
b in
both directions.  The Realtek maintained driver (r8125) supposedly fixes the
issue from what I've read but unfortunately I'm unable to compile it on my =
OS
(Rocky 8.7). =20

$ iperf3 -c server
[  5] local 10.200.16.20 port 58358 connected to 10.200.16.40 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   176 MBytes  1.47 Gbits/sec  1113   41.0 KBytes   =
   =20
[  5]   1.00-2.00   sec   169 MBytes  1.42 Gbits/sec  1070   46.7 KBytes   =
   =20
[  5]   2.00-3.00   sec   176 MBytes  1.47 Gbits/sec  1287   49.5 KBytes   =
   =20
[  5]   3.00-4.00   sec   172 MBytes  1.44 Gbits/sec  1121   35.4 KBytes   =
   =20
[  5]   4.00-5.00   sec   176 MBytes  1.47 Gbits/sec  1105   33.9 KBytes   =
   =20
[  5]   5.00-6.00   sec   167 MBytes  1.40 Gbits/sec  1100   39.6 KBytes   =
   =20
[  5]   6.00-7.00   sec   175 MBytes  1.47 Gbits/sec  1134   46.7 KBytes   =
   =20
[  5]   7.00-8.00   sec   173 MBytes  1.45 Gbits/sec  1147   33.9 KBytes   =
   =20
[  5]   8.00-9.00   sec   167 MBytes  1.40 Gbits/sec  966   46.7 KBytes    =
  =20
[  5]   9.00-10.00  sec   177 MBytes  1.48 Gbits/sec  1164   41.0 KBytes   =
   =20
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.69 GBytes  1.45 Gbits/sec  11207             sen=
der
[  5]   0.00-10.04  sec  1.69 GBytes  1.44 Gbits/sec                  recei=
ver


And now we just reverse the sender:
$ iperf3 -Rc server
[  5] local 10.200.16.20 port 41788 connected to 10.200.16.40 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   277 MBytes  2.32 Gbits/sec                 =20
[  5]   1.00-2.00   sec   279 MBytes  2.34 Gbits/sec                 =20
[  5]   2.00-3.00   sec   280 MBytes  2.35 Gbits/sec                 =20
[  5]   3.00-4.00   sec   280 MBytes  2.35 Gbits/sec                 =20
[  5]   4.00-5.00   sec   279 MBytes  2.34 Gbits/sec                 =20
[  5]   5.00-6.00   sec   280 MBytes  2.35 Gbits/sec                 =20
[  5]   6.00-7.00   sec   279 MBytes  2.34 Gbits/sec                 =20
[  5]   7.00-8.00   sec   279 MBytes  2.34 Gbits/sec                 =20
[  5]   8.00-9.00   sec   278 MBytes  2.33 Gbits/sec                 =20
[  5]   9.00-10.00  sec   280 MBytes  2.35 Gbits/sec                 =20
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.04  sec  2.73 GBytes  2.33 Gbits/sec    4             sender
[  5]   0.00-10.00  sec  2.73 GBytes  2.34 Gbits/sec                  recei=
ver


Kernel version:
Linux ultrix 4.18.0-425.19.2.el8_7.x86_64 #1 SMP Tue Apr 4 22:38:11 UTC 2023
x86_64 x86_64 x86_64 GNU/Linux

modinfo on r8169:
filename:     =20
/lib/modules/4.18.0-425.19.2.el8_7.x86_64/kernel/drivers/net/ethernet/realt=
ek/r8169.ko.xz
firmware:       rtl_nic/rtl8125b-2.fw
firmware:       rtl_nic/rtl8125a-3.fw
firmware:       rtl_nic/rtl8107e-2.fw
firmware:       rtl_nic/rtl8107e-1.fw
firmware:       rtl_nic/rtl8168fp-3.fw
firmware:       rtl_nic/rtl8168h-2.fw
firmware:       rtl_nic/rtl8168h-1.fw
firmware:       rtl_nic/rtl8168g-3.fw
firmware:       rtl_nic/rtl8168g-2.fw
firmware:       rtl_nic/rtl8106e-2.fw
firmware:       rtl_nic/rtl8106e-1.fw
firmware:       rtl_nic/rtl8411-2.fw
firmware:       rtl_nic/rtl8411-1.fw
firmware:       rtl_nic/rtl8402-1.fw
firmware:       rtl_nic/rtl8168f-2.fw
firmware:       rtl_nic/rtl8168f-1.fw
firmware:       rtl_nic/rtl8105e-1.fw
firmware:       rtl_nic/rtl8168e-3.fw
firmware:       rtl_nic/rtl8168e-2.fw
firmware:       rtl_nic/rtl8168e-1.fw
firmware:       rtl_nic/rtl8168d-2.fw
firmware:       rtl_nic/rtl8168d-1.fw
license:        GPL
softdep:        pre: realtek
description:    RealTek RTL-8169 Gigabit Ethernet driver
author:         Realtek and the Linux r8169 crew <netdev@vger.kernel.org>
rhelversion:    8.7
srcversion:     97902AC339128804EACE041
alias:          pci:v000010ECd00003000sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008125sv*sd*bc*sc*i*
alias:          pci:v00000001d00008168sv*sd00002410bc*sc*i*
alias:          pci:v00001737d00001032sv*sd00000024bc*sc*i*
alias:          pci:v000016ECd00000116sv*sd*bc*sc*i*
alias:          pci:v00001259d0000C107sv*sd*bc*sc*i*
alias:          pci:v00001186d00004302sv*sd*bc*sc*i*
alias:          pci:v00001186d00004300sv*sd*bc*sc*i*
alias:          pci:v00001186d00004300sv00001186sd00004B10bc*sc*i*
alias:          pci:v000010ECd00008169sv*sd*bc*sc*i*
alias:          pci:v000010FFd00008168sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008168sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008167sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008162sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008161sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008136sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008129sv*sd*bc*sc*i*
alias:          pci:v000010ECd00002600sv*sd*bc*sc*i*
alias:          pci:v000010ECd00002502sv*sd*bc*sc*i*
depends:       =20
intree:         Y
name:           r8169
vermagic:       4.18.0-425.19.2.el8_7.x86_64 SMP mod_unload modversions=20
sig_id:         PKCS#7
signer:         Rocky kernel signing key
sig_key:        31:6B:5A:38:DC:7F:D6:69:81:FF:0E:A0:F3:A0:40:1F:9E:9D:02:27
sig_hashalgo:   sha256
signature:      97:97:FA:A9:56:9A:59:3A:E4:FB:BC:02:09:7A:AE:6A:0D:82:95:2A:
                31:09:9C:78:AD:62:54:D2:73:82:8E:C0:D6:7A:D8:A5:16:F4:3B:FF:
                A0:DB:61:04:9D:DC:3C:CD:61:E0:92:F9:81:FC:87:EF:C0:BC:BA:A7:
                60:24:59:4A:C5:B5:2F:51:F5:97:C2:18:18:18:42:5A:E1:90:5F:78:
                14:75:C8:67:D0:3D:03:93:E5:98:D8:48:B2:8E:64:B4:73:DA:3C:A5:
                6D:7D:24:79:2C:76:34:21:3F:35:5D:E8:93:5F:6B:FD:13:13:6F:9C:
                C3:F6:F2:0A:25:6C:1D:14:FF:23:84:87:94:01:F9:3F:C9:65:6B:4F:
                F3:44:65:F7:21:03:D9:9C:5F:60:A5:3B:2D:91:E3:BE:88:49:3B:2A:
                97:41:81:6C:87:0A:47:C3:E9:46:FD:15:85:8E:07:A8:6C:5E:69:45:
                E9:A1:4B:68:89:04:73:00:35:61:85:7C:A2:5B:7F:FC:C6:DB:7B:A2:
                8B:E6:36:1C:09:7A:02:8E:C5:72:5D:1C:F4:78:A9:C7:42:84:0B:E1:
                B6:5C:A4:B5:F8:AB:1F:FA:1B:51:E9:A3:78:17:90:BC:5B:03:CA:AC:
                C5:34:BB:4C:EE:CE:75:BE:15:F2:C6:C6:8C:6F:A8:5B:E0:38:7F:6F:
                9F:18:63:5C:F0:2D:50:26:BD:DD:A2:D3:AF:C0:CA:64:82:6D:F7:39:
                AD:5A:C3:87:88:57:8F:F6:28:15:2F:F4:86:85:F7:71:BA:E8:9E:6B:
                DB:9C:10:B1:5D:90:77:47:27:DD:F4:68:C8:68:E3:60:BE:C4:FC:CD:
                B2:C0:B4:B0:44:F4:1B:37:6E:37:55:39:17:EE:00:AE:5A:51:8F:02:
                09:AF:A7:59:DF:E1:E6:09:A0:50:6D:51:41:11:E0:9D:D9:68:4A:43:
                B3:8A:4E:00:80:A7:4C:B4:7C:7B:00:1E:F1:AA:2D:F6:1D:DE:B7:07:
                F6:50:6A:AF

lshw -C network output:
  *-network                =20
       description: Ethernet interface
       product: RTL8125 2.5GbE Controller
       vendor: Realtek Semiconductor Co., Ltd.
       physical id: 0
       bus info: pci@0000:02:00.0
       logical name: enp2s0
       version: 05
       serial: 78:72:64:40:6b:53
       capacity: 1Gbit/s
       width: 64 bits
       clock: 33MHz
       capabilities: pm msi pciexpress msix vpd bus_master cap_list ethernet
physical tp mii 10bt 10bt-fd 100bt 100bt-fd 1000bt-fd autonegotiation
       configuration: autonegotiation=3Don broadcast=3Dyes driver=3Dr8169
driverversion=3D4.18.0-425.19.2.el8_7.x86_64 duplex=3Dfull
firmware=3Drtl8125b-2_0.0.2 07/13/20 ip=3D10.200.16.43 latency=3D0 link=3Dy=
es
multicast=3Dyes port=3DMII
       resources: irq:18 ioport:3000(size=3D256) memory:7ff00000-7ff0ffff
memory:7ff10000-7ff13fff
  *-network
       description: Ethernet interface
       product: RTL8125 2.5GbE Controller
       vendor: Realtek Semiconductor Co., Ltd.
       physical id: 0
       bus info: pci@0000:03:00.0
       logical name: enp3s0
       version: 05
       serial: 78:72:64:40:6b:54
       capacity: 1Gbit/s
       width: 64 bits
       clock: 33MHz
       capabilities: pm msi pciexpress msix vpd bus_master cap_list ethernet
physical tp mii 10bt 10bt-fd 100bt 100bt-fd 1000bt-fd autonegotiation
       configuration: autonegotiation=3Don broadcast=3Dyes driver=3Dr8169
driverversion=3D4.18.0-425.19.2.el8_7.x86_64 firmware=3Drtl8125b-2_0.0.2 07=
/13/20
latency=3D0 link=3Dno multicast=3Dyes port=3DMII
       resources: irq:19 ioport:2000(size=3D256) memory:7fe00000-7fe0ffff
memory:7fe10000-7fe13fff


ethtool output:
Settings for enp2s0:
        Supported ports: [ TP    MII ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
                                2500baseT/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
                                2500baseT/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  10baseT/Half 10baseT/Full
                                             100baseT/Half 100baseT/Full
                                             1000baseT/Half 1000baseT/Full
                                             10000baseT/Full
                                             2500baseT/Full
                                             5000baseT/Full
        Link partner advertised pause frame use: No
        Link partner advertised auto-negotiation: Yes
        Link partner advertised FEC modes: Not reported
        Speed: 2500Mb/s
        Duplex: Full
        Auto-negotiation: on
        master-slave cfg: preferred slave
        master-slave status: slave
        Port: MII
        PHYAD: 0
        Transceiver: external
        Supports Wake-on: pumbg
        Wake-on: d
        Link detected: yes

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
