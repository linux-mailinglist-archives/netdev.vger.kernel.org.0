Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8975A6A2127
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjBXSHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjBXSHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:07:51 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1D5E0
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1677262043; i=frank-w@public-files.de;
        bh=1aUQLl5okgwKsWP2v+C2nnD1WzJsopi4IrmV1u/Ovlw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=lU5xt9WsGS/qaajyyLcJ1Id43veKpUTcPTrlV3QXiMjysiieWGhY+pn7+2yDYhijc
         E9rldTSHXkq3d79nR/qk/Oos/5jOimMQw8HkMPqbkTWsSVm6/hJYAPq6YjaUj5hzsw
         CUbXRdqnWX2sngzywZP9yLj8mBqMElx4WglAh2G/G//Lhz3gL4Fp480ibV6wm8MXNe
         2RM92dz8Vj/pkZdy+jW4do8178abPtECwX52nnXPnkvP6MqqcVL6OoJ6nd6PEFpen2
         w0aJ1ikLoSnyUE24TSWZTBplhj5zTRDB7xQuNNuBucvzdN/D2Q4PnVRBBPrTWj+UdN
         qNcQ1E4pupMzQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [157.180.225.28] ([157.180.225.28]) by web-mail.gmx.net
 (3c-app-gmx-bap70.server.lan [172.19.172.170]) (via HTTP); Fri, 24 Feb 2023
 19:07:23 +0100
MIME-Version: 1.0
Message-ID: <trinity-c58a37c3-aa55-48b3-9d6c-71520ad2a81d-1677262043715@3c-app-gmx-bap70>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     =?UTF-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Aw: Re: Choose a default DSA CPU port
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 24 Feb 2023 19:07:23 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <e89af7bd-2f4c-3865-afa5-276a6acbc16f@arinc9.com>
References: <5833a789-fa5a-ce40-f8e5-d91f4969a7c4@arinc9.com>
 <20230218205204.ie6lxey65pv3mgyh@skbuf>
 <a4936eb8-dfaa-e2f8-b956-75e86546fbf3@arinc9.com>
 <trinity-4025f060-3bb8-4260-99b7-e25cbdcf9c27-1676800164589@3c-app-gmx-bs35>
 <20230221002713.qdsabxy7y74jpbm4@skbuf>
 <trinity-105e0c2e-38e7-4f44-affd-0bc41d0a426b-1677086262623@3c-app-gmx-bs54>
 <20230222180623.cct2kbhyqulofzad@skbuf>
 <9c9ab755-9b5e-4e76-0e3c-119d567fc39d@arinc9.com>
 <20230222193440.c2vzg7j7r32xwr5l@skbuf>
 <e89af7bd-2f4c-3865-afa5-276a6acbc16f@arinc9.com>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:EaobdICuDdBzkM3x47HnTGotKRaMICdSpfe4Tz4mLiNaEoniYIxIr+sp8kaTzrJU09WVI
 kgFf75GUHsAqmJycS9AtNjBLqtm0gPqoQ6L6nFuVQpcL7jd4aIeiAH8LtZBFUtIxI+8l1XqhR47O
 DBUChKhM0bAJ1PPpsYvryFGyiYGDXN65tzNSxgWjgxCKumz4m+B7sA95T5DI2f/58U7XBbN3EXnM
 rV1VdVD+xqCQ5+eAzFakduIxtz1UjTodleAGu7HWJcFTeZi1pu8rO/F5rnxbUFXQKVgZvCHo5C36
 OQ=
UI-OutboundReport: notjunk:1;M01:P0:1Krb/hPrZHU=;A6O6bRg92Y4oE8vLNzn9P3ssntk
 ESmztO9COTgkqsxnGg6SHHId1NgIR0OcfAdDfKMZSV70iGVvGJxhZ3KipaXauM9u2DDSPnluo
 2bqWE1a1WoAWevA5KxhdjI5v7PAMGfMpfInCLiPY6Nhu52sOkGMghlknEoKE9n7TZ/bmhLEYT
 fVPvh1Pde89W/5ROPAn7xYemZFcXu7Ea0j8M5TpYJRQ3MO6IwFA7O75Hh/nDEp61tVlIbkNmT
 dqlwG2xkgRXs2V1Dec18XDjmKeiSqFF/JsKuNQTI5jPY8FDtXbSl6KSLQGaeM9lapwP+hPfYI
 wjY6eLBSK68qXlgzDgQJuco+t+lj1IFyUDgZRwrdA4DHdA40tnCAkGy1A1vdZdh1vlj+Bhnn+
 gFFhVZArlYF9qZ8tZobVATnHdxZlSgsDWpYfDyN+7eWy+QHhSiIJWuY0FU4r6Ztz0XpuBc+R9
 KWGTQKSwgc7jHnqIR66+X6SSV1XRF4Q7F6aZYuejbI4noDesi2GbgVFjsL31nGZVhf1qIYMoC
 NBwXiLaSG+vhPDcAyFT9ublJ4vZII2iXlm+yr13D6gYcOmNq+ghM9CaYr0HS8IWf3SIzpb2Uv
 Ybiex22E4VJVKaAy3e/HCsQ1BUPg9Xuqyc11SV5LjziaCqTza4htnkgAWl7nLy56H+sUc5MKV
 PZWGp6nuolMLhrzd327LwE1Co1m4Pdfn6uTKpUgEl6t8394P0/echDJlTnSBhFv4KDuW7y2xj
 IE9gk9VFff+34IE5ITxOXMhCQBiGfPm0SctZC20hazeGSpyWdWI6ZJEG2/0j5jbhq+5g5ZB5H
 tBa2t05m+4KMDSyrOqTy/Vkar6RotAHBHcIyPd5m/U/hg=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

> Gesendet: Mittwoch, 22=2E Februar 2023 um 20:42 Uhr
> Von: "Ar=C4=B1n=C3=A7 =C3=9CNAL" <arinc=2Eunal@arinc9=2Ecom>
> On 22=2E02=2E2023 22:34, Vladimir Oltean wrote:
> > The posted ethtool stats are not sufficient to determine the cause of
> > the issue=2E It would be necessary to see all non-zero Ethernet counte=
rs
> > on both CPU port pairs:
> >=20
> > ethtool -S eth0 | grep -v ': 0'
> > ethtool -S eth1 | grep -v ': 0'
> >=20
> > to determine whether the cause of the performance degradation is packe=
t
> > loss or just a lossless slowdown of some sorts=2E For example, the
> > degradation might be caused by the added flow control + uncalibrated
> > watermarks, not by the activation of the other GMAC=2E
>=20
> I'll keep this in mind thanks=2E
>=20
> Frank, here's my task page for this issue, for your information=2E
>=20
> https://arinc9=2Enotion=2Esite/MT7530-port5-performance-issue-98ac5fa19d=
c248e0b12fab08dcb2e387

tried after adding the fix from daniel, but same issue, here the iperf and=
 ethtool-results (does not look wrong except tx-speed)


root@bpi-r2:~# iperf3 -c 192=2E168=2E0=2E21                               =
           =20
Connecting to host 192=2E168=2E0=2E21, port 5201                          =
           =20
[  5] local 192=2E168=2E0=2E11 port 36832 connected to 192=2E168=2E0=2E21 =
port 5201        =20
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd          =
     =20
[  5]   0=2E00-1=2E00   sec  75=2E4 MBytes   633 Mbits/sec    0    361 KBy=
tes        =20
[  5]   1=2E00-2=2E00   sec  74=2E4 MBytes   624 Mbits/sec    0    361 KBy=
tes        =20
[  5]   2=2E00-3=2E00   sec  74=2E1 MBytes   622 Mbits/sec    0    361 KBy=
tes        =20
[  5]   3=2E00-4=2E00   sec  74=2E2 MBytes   622 Mbits/sec    0    361 KBy=
tes        =20
[  5]   4=2E00-5=2E00   sec  74=2E6 MBytes   626 Mbits/sec    0    361 KBy=
tes        =20
[  5]   5=2E00-6=2E00   sec  74=2E4 MBytes   624 Mbits/sec    0    379 KBy=
tes        =20
[  5]   6=2E00-7=2E00   sec  74=2E1 MBytes   621 Mbits/sec    0    379 KBy=
tes        =20
[  5]   7=2E00-8=2E00   sec  74=2E7 MBytes   627 Mbits/sec    0    379 KBy=
tes        =20
[  5]   8=2E00-9=2E00   sec  74=2E5 MBytes   625 Mbits/sec    0    564 KBy=
tes        =20
[  5]   9=2E00-10=2E00  sec  74=2E3 MBytes   623 Mbits/sec    0    564 KBy=
tes        =20
- - - - - - - - - - - - - - - - - - - - - - - - -                         =
     =20
[ ID] Interval           Transfer     Bitrate         Retr                =
     =20
[  5]   0=2E00-10=2E00  sec   745 MBytes   625 Mbits/sec    0             =
sender   =20
[  5]   0=2E00-10=2E04  sec   744 MBytes   621 Mbits/sec                  =
receiver =20
                                                                          =
     =20
iperf Done=2E                                                             =
       =20
root@bpi-r2:~# iperf3 -c 192=2E168=2E0=2E21 -R                            =
           =20
Connecting to host 192=2E168=2E0=2E21, port 5201                          =
           =20
Reverse mode, remote host 192=2E168=2E0=2E21 is sending                   =
           =20
[  5] local 192=2E168=2E0=2E11 port 44428 connected to 192=2E168=2E0=2E21 =
port 5201        =20
[ ID] Interval           Transfer     Bitrate                             =
     =20
[  5]   0=2E00-1=2E00   sec   112 MBytes   939 Mbits/sec                  =
         =20
[  5]   1=2E00-2=2E00   sec   112 MBytes   940 Mbits/sec                  =
         =20
[  5]   2=2E00-3=2E00   sec   112 MBytes   939 Mbits/sec                  =
         =20
[  5]   3=2E00-4=2E00   sec   112 MBytes   940 Mbits/sec                  =
         =20
[  5]   4=2E00-5=2E00   sec   112 MBytes   940 Mbits/sec                  =
         =20
[  5]   5=2E00-6=2E00   sec   112 MBytes   940 Mbits/sec                  =
         =20
[  5]   6=2E00-7=2E00   sec   112 MBytes   940 Mbits/sec                  =
         =20
[  5]   7=2E00-8=2E00   sec   112 MBytes   940 Mbits/sec                  =
         =20
[  5]   8=2E00-9=2E00   sec   112 MBytes   940 Mbits/sec                  =
         =20
[  5]   9=2E00-10=2E00  sec   112 MBytes   940 Mbits/sec                  =
         =20
- - - - - - - - - - - - - - - - - - - - - - - - -                         =
     =20
[ ID] Interval           Transfer     Bitrate         Retr                =
     =20
[  5]   0=2E00-10=2E04  sec  1=2E10 GBytes   938 Mbits/sec    0           =
  sender   =20
[  5]   0=2E00-10=2E00  sec  1=2E09 GBytes   940 Mbits/sec                =
  receiver =20
                                                                          =
     =20
iperf Done=2E                                                             =
       =20
root@bpi-r2:~# ethtool -S eth0 | grep -v ': 0'                            =
     =20
NIC statistics:                                                           =
     =20
     tx_bytes: 1643364546                                                 =
     =20
     tx_packets: 1121377                                                  =
     =20
     rx_bytes: 1270088499                                                 =
     =20
     rx_packets: 1338400                                                  =
     =20
     p06_TxUnicast: 1338274                                               =
     =20
     p06_TxMulticast: 120                                                 =
     =20
     p06_TxBroadcast: 6                                                   =
     =20
     p06_TxPktSz65To127: 525948                                           =
     =20
     p06_TxPktSz128To255: 5                                               =
     =20
     p06_TxPktSz256To511: 16                                              =
     =20
     p06_TxPktSz512To1023: 4                                              =
     =20
     p06_Tx1024ToMax: 812427                                              =
     =20
     p06_TxBytes: 1275442099                                              =
     =20
     p06_RxFiltering: 16                                                  =
     =20
     p06_RxUnicast: 1121339                                               =
     =20
     p06_RxMulticast: 37                                                  =
     =20
     p06_RxBroadcast: 1                                                   =
     =20
     p06_RxPktSz64: 3                                                     =
     =20
     p06_RxPktSz65To127: 43757                                            =
     =20
     p06_RxPktSz128To255: 3                                               =
     =20
     p06_RxPktSz256To511: 3                                               =
     =20
     p06_RxPktSz1024ToMax: 1077611                                        =
     =20
     p06_RxBytes: 1643364546                                              =
     =20
root@bpi-r2:~# ethtool -S eth1 | grep -v ': 0'                            =
     =20
NIC statistics:                                                           =
     =20
root@bpi-r2:~#=20

breaking mt7531 as stated by vladimir is bad=2E=2E=2Ecurrently afaik no ot=
her board uses second cpu-port (r2pro uses only port5, r3 uses port 5 as us=
er-port for SFP)=2E

if interested this is my tree:

https://github=2Ecom/frank-w/BPI-Router-Linux/tree/6=2E2-rc8-r2-dsa

regards Frank
