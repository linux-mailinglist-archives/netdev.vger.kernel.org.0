Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1966E1680
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 23:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjDMVat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 17:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjDMVaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 17:30:46 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A2912A
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 14:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1681421418; i=frank-w@public-files.de;
        bh=O1i7qtwQ5roEuoma3ymgAEKruJqtBh0msvW4KikFQPE=;
        h=X-UI-Sender-Class:Date:From:To:CC:Subject:Reply-to:In-Reply-To:
         References;
        b=qILzoiRJ4fKbFkFgbAKlFX/jksd5V62yO0ha+YFQ0dQaxlwkiheeJXh+mHZYPSQGh
         UBfNtw0lfj5cp9iBDM3jAePNPeP6ljWgBr+1jqc92qp129vW3if37DpILFhMVNW0jS
         GxmSn9JIJzHZuAgMqT9Z55005ROfO0j12FS3TlV1ciugqYt7a04CKtfEewGW7/BC61
         w68rnwBxJd56+XQDNdVQMfsgldWsnRwyDH+0tovmnFtwxqzMYKWXycmbWa7rMvmY8Z
         M6ToYSI55oLbTReL0KQNZnE3ZgLb2n9KnIKmp+fW5ZN7fO7ivYeGn+x8Nljul8wn1M
         0t7jo4x6O+pVw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [127.0.0.1] ([80.245.77.65]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MeU0q-1qNVGf3T8u-00aWut; Thu, 13
 Apr 2023 23:30:17 +0200
Date:   Thu, 13 Apr 2023 23:30:14 +0200
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Felix Fietkau <nbd@nbd.name>, netdev <netdev@vger.kernel.org>,
        erkin.bozoglu@xeront.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: Choose a default DSA CPU port
User-Agent: K-9 Mail for Android
Reply-to: frank-w@public-files.de
In-Reply-To: <trinity-ab593227-766b-4e77-a8ee-6d93323b9613-1681409392321@3c-app-gmx-bs48>
References: <trinity-5a3fbd85-79ce-4021-957f-aea9617bb320-1677333013552@3c-app-gmx-bap06> <f9fcf74b-7e30-9b51-776b-6a3537236bf6@arinc9.com> <6383a98a-1b00-913d-0db1-fe33685a8410@arinc9.com> <trinity-6ad483d2-5c50-4f38-b386-f4941c85c1fd-1677413524438@3c-app-gmx-bs15> <20230228115846.4r2wuyhsccmrpdfh@skbuf> <CB415113-7581-475E-9BB9-48F6A8707C15@public-files.de> <20230228225622.yc42xlkrphx4gbdy@skbuf> <0842D2D2-E71C-4DEF-BBCD-2D0C0869046E@public-files.de> <20230301123743.qifnk34pqwuyhf7u@skbuf> <trinity-a6b4447d-52b8-42a6-a4ce-b06543872534-1678126825554@3c-app-gmx-bs54> <20230307174323.sbzhb7gy6blgj2jf@skbuf> <trinity-ab593227-766b-4e77-a8ee-6d93323b9613-1681409392321@3c-app-gmx-bs48>
Message-ID: <0F1324C1-5E17-42AF-B8EC-C999B1537F59@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:cPJWiOM/S31brDvVbYWWo12vk/2iFLJfnChtGK6l6fRrtXzfDQw
 WX27BJWDlGY/1ngbvO3lHlcEskDiBuUG47NS/NmxjR0B6iaFegfliWL393Qe++uczi9EeIX
 PNX7T6nOf4+lQWSMS66QdvDdOQ0DS2j6C/SkqJLfHWceDigc4kzZRe6dpdvs6CzmcLl10tT
 2OiSAEibnwTqTS7CORPBQ==
UI-OutboundReport: notjunk:1;M01:P0:I3MiwlzF6Vk=;6tDvOmJ7xVKi9mtdAx0UNsml4vi
 ogwpr82NYiYnCjcAQwh7xDKzFqKgtLwQyO1mrTzfxUlGUrYDpT++sGe1uoVfjbi/mFeYesR3a
 B/DnPCnfHppaHXqefekgHDXybrzjc+sB8+PZ3wH6gYA5gUWq3A7Td7EGkCCL88u9gL88Puoj+
 HV9U7cU5pz2nBJtR/4tAf7UloqWFT2t5R04CKXeFMPU3pXHaaZKLzQJ76XreDh6uppZzEYOjL
 AR48sEXfmh/gPGLu8EgFvGwOWq7Gwu09hvIINiM4quONcsex6tRqJbWQ8mPGrnWjZKwS+m3YB
 fbo6/aM2SSiygonRLw6Co8aE2wvsHr8FioTK3VunipehNDPDELVJuO9gwuBOxiQjpPVoyIe6g
 /Kj4DkhVJCvqIa7FCeSSx9bKAgS5C54rDFjrL5GVeAOrxaGKEedwYcsJ5w1M7z9ud9cYvE13L
 gHt8BQTa84mf0EGhFLdg3F0fheCTWaZfT+xeFhRp7EldcQVos5nzG13Sbd9N3RPr8XOddc0In
 hESHKtHNbpXRpoU7Iq7+llN+hEnTHgKsIC/kTmIn0Lil6N+knuRNHw9uRf2IIi6BCl10stG1b
 wAfrg8Ag7Mp+LfmpkDJTkzFrArFxckA/sDKaVgzVDnUGscJ9y/XHKX+uB2yRmQDDPE6AksL8D
 Y1VT+Z88Pi3H0Gll4pANATf1VBM1LTGaNT04JpfC9qza9pxcT0fvhKlXGvuyd3q/grKb3TpK5
 AsR6cYJHocFbeTwJlw1dbDGOySPzVy1oN/KZBMLmeEqYm42c+szZKUal1GscyC8n8bUJA7NwY
 LDB87CC5mO1VSyeD+4yb+ssjD+xptEHdbx8jhES+Tvp5YE061m3fPfQ2aR2ePvbT+dXKsz9Oe
 AQojll3x/bh5fETQSOpQFdXqGVMCkSGSfTr6FDFsNLfTxEgtVPZBFYFJUkTu46/xYiZFXYbOc
 rbQXw7PuYdKXkJVJbPozHR3EAb4=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 13=2E April 2023 20:09:52 MESZ schrieb Frank Wunderlich <frank-w@public-=
files=2Ede>:
>Hi
>> Gesendet: Dienstag, 07=2E M=C3=A4rz 2023 um 19:43 Uhr
>> Von: "Vladimir Oltean" <olteanv@gmail=2Ecom>
>> Betreff: Re: Choose a default DSA CPU port
>>
>> On Mon, Mar 06, 2023 at 07:20:25PM +0100, Frank Wunderlich wrote:
>> > is it possible to map this function only to mt7530, not mt7531?
>> >=20
>> > as one way i would add a check for the chip
>> >=20
>> > if (priv->id !=3D ID_MT7530) { return NULL; }
>> > //existing content for mt7531
>>=20
>> yeah, returning "NULL" to ds->ops->preferred_default_local_cpu_port()
>> would mean "don't know, don't care" and DSA would choose by itself=2E
>>=20
>> although I feel we're not at the stage where we should discuss about
>> that just yet=2E
>>=20
>> > where did you find the comment about multicast?
>>=20
>> well, I didn't find "link-local multicast", but "BPDU to CPU port" and
>> may have ran a little bit too far with that info=2E
>>=20
>> If you search for the "Bridge Group Address" keyword in IEEE 802=2E1Q o=
r
>> IEEE 802=2E1D (older) documents, you'll see that STP BPDUs are sent to =
a
>> reserved multicast MAC DA of 01-80-C2-00-00-00, which is link-local,
>> meaning that switches don't forward it but trap it=2E Since I knew that=
,
>> I just assumed that "BPDU to CPU port" means "trapping of any frames
>> with that MAC DA to the CPU port", since if I were a hardware designer,
>> that's what I would do=2E It's possible to identify STP BPDUs (to trap
>> just those) by examining the LLC header, but I wouldn't bother since th=
e
>> MAC DA is reserved for this kind of stuff and I'd be locking myself out
>> of being compatible with possible protocol changes in the future=2E
>>=20
>> > https://elixir=2Ebootlin=2Ecom/linux/v6=2E3-rc1/source/drivers/net/ds=
a/mt7530=2Ec has
>> > "multicast" only in the packet-counters (mib_desc)
>> >=20
>> > > The next most obvious thing would be L2 PTP (ptp4l -2), but since m=
t7530
>> > > doesn't support hw timestamping, you'd need to try software timesta=
mping
>> > > instead ("ptp4l -i swpX -2 -P -S -m", plus the equivalent command o=
n a
>> > > link partner)=2E
>> >=20
>> > have not done anything with l2 p2p yet, and no server running=2E=2E=
=2Ei'm not sure
>> > i can check this the right way=2E
>>=20
>> Anyway, it doesn't have to be PTP, it can be literally any application
>> using a PF_PACKET socket to send sequence-numbered packets towards a
>> mt7530 port with the 01:80:c2:00:00:00 MAC DA, and using 2 tcpdump
>> instances on the 2 GMACs to check whether packets are received once or
>> twice=2E
>>=20
>> If this is still too complicated, just send 5 actual BPDUs and see if
>> you receive them on both CPU ports:
>>=20
>> mausezahn eth0 -b 01:80:c2:00:00:00 -c 5 -t bpdu
>
>
>hi i tried last approach on bananapi r64 as it is the one and only board =
i have with mt7531 which has both gmacs connected to the switch=2E
>
>base is my 6=2E3-rc tree (modified r64 dts for having second gmac):
>
>https://github=2Ecom/frank-w/BPI-Router-Linux/commits/6=2E3-rc
>
>root@bpi-r64:~# ip a s eth0                                              =
                                           =20
>2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1504 qdisc mq state UP gro=
up default qlen 1000                       =20
>    link/ether 66:ea:04:18:30:6f brd ff:ff:ff:ff:ff:ff                   =
                                           =20
>root@bpi-r64:~# ip a s eth1                                              =
                                           =20
>3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP gro=
up default qlen 1000                       =20
>    link/ether 86:97:05:8f:80:63 brd ff:ff:ff:ff:ff:ff                   =
                                           =20
>    inet6 fe80::8497:5ff:fe8f:8063/64 scope link                         =
                                           =20
>       valid_lft forever preferred_lft forever=20
>
>root@bpi-r64:~# tcpdump -i eth0 > eth0=2Elog &                           =
                                             =20
>[1] 3774                                                                 =
                                           =20
>                                                                         =
                                           e
>listening on eth0, link-type NULL (BSD loopback), snapshot length 262144 =
bytes                                      =20
>root@bpi-r64:~# tcpdump -i eth1 > eth1=2Elog &                           =
                                             =20
>[2] 3779                                                                 =
                                           =20
>                                                                         =
                                           e
>tcpdump: verbose output suppressed, use -v[v]=2E=2E=2E for full protocol =
decode                                           =20
>listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 by=
tes                                        =20
>root@bpi-r64:~# mausezahn eth0 -b 01:80:c2:00:00:00 -c 5 -t bpdu         =
                                           =20
>0=2E00 seconds (30864 packets per second)                                =
                                             =20
>root@bpi-r64:~# killall tcpdump                                          =
                                           =20
>5 packets captur[ 2981=2E315951] mtk_soc_eth 1b100000=2Eethernet eth1: le=
ft promiscuous mode                            =20
>ed                                                                       =
                                           =20
>5 packets received by filter                                             =
                                           =20
>0 packets dropped by kernel                                              =
                                           =20
>0 packets captured                                                       =
                                           =20
>0 packets received by filter                                             =
                                           =20
>0 packets dropped by kernel                                              =
                                           =20
>[1]-  Done                    tcpdump -i eth0 > eth0=2Elog               =
                                             =20
>[2]+  Done                    tcpdump -i eth1 > eth1=2Elog
>
>root@bpi-r64:~# cat eth0=2Elog                                           =
                                             =20
>20:04:47=2E124519 AF Unknown (25215488), length 60:                      =
                                             =20
>        0x0000:  0000 66ea 0418 306f 0026 4242 0300 0000  =2E=2Ef=2E=2E=
=2E0o=2E&BB=2E=2E=2E=2E                                          =20
>        0x0010:  0000 0000 66ea 0418 306f 0000 0000 0000  =2E=2E=2E=2Ef=
=2E=2E=2E0o=2E=2E=2E=2E=2E=2E                                          =20
>        0x0020:  66ea 0418 306f 0000 0000 1400 0200 0f00  f=2E=2E=2E0o=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E                                          =20
>        0x0030:  0000 0000 0000 0000                      =2E=2E=2E=2E=2E=
=2E=2E=2E                                                  =20
>20:04:47=2E124555 AF Unknown (25215488), length 60:                      =
                                             =20
>        0x0000:  0000 66ea 0418 306f 0026 4242 0300 0000  =2E=2Ef=2E=2E=
=2E0o=2E&BB=2E=2E=2E=2E                                          =20
>        0x0010:  0000 0000 66ea 0418 306f 0000 0000 0000  =2E=2E=2E=2Ef=
=2E=2E=2E0o=2E=2E=2E=2E=2E=2E                                          =20
>        0x0020:  66ea 0418 306f 0000 0000 1400 0200 0f00  f=2E=2E=2E0o=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E                                          =20
>        0x0030:  0000 0000 0000 0000                      =2E=2E=2E=2E=2E=
=2E=2E=2E                                                  =20
>20:04:47=2E124568 AF Unknown (25215488), length 60:                      =
                                             =20
>        0x0000:  0000 66ea 0418 306f 0026 4242 0300 0000  =2E=2Ef=2E=2E=
=2E0o=2E&BB=2E=2E=2E=2E                                          =20
>        0x0010:  0000 0000 66ea 0418 306f 0000 0000 0000  =2E=2E=2E=2Ef=
=2E=2E=2E0o=2E=2E=2E=2E=2E=2E                                          =20
>        0x0020:  66ea 0418 306f 0000 0000 1400 0200 0f00  f=2E=2E=2E0o=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E                                          =20
>        0x0030:  0000 0000 0000 0000                      =2E=2E=2E=2E=2E=
=2E=2E=2E                                                  =20
>20:04:47=2E124580 AF Unknown (25215488), length 60:                      =
                                             =20
>        0x0000:  0000 66ea 0418 306f 0026 4242 0300 0000  =2E=2Ef=2E=2E=
=2E0o=2E&BB=2E=2E=2E=2E                                          =20
>        0x0010:  0000 0000 66ea 0418 306f 0000 0000 0000  =2E=2E=2E=2Ef=
=2E=2E=2E0o=2E=2E=2E=2E=2E=2E                                          =20
>        0x0020:  66ea 0418 306f 0000 0000 1400 0200 0f00  f=2E=2E=2E0o=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E                                          =20
>        0x0030:  0000 0000 0000 0000                      =2E=2E=2E=2E=2E=
=2E=2E=2E                                                  =20
>20:04:47=2E124592 AF Unknown (25215488), length 60:                      =
                                             =20
>        0x0000:  0000 66ea 0418 306f 0026 4242 0300 0000  =2E=2Ef=2E=2E=
=2E0o=2E&BB=2E=2E=2E=2E                                          =20
>        0x0010:  0000 0000 66ea 0418 306f 0000 0000 0000  =2E=2E=2E=2Ef=
=2E=2E=2E0o=2E=2E=2E=2E=2E=2E                                          =20
>        0x0020:  66ea 0418 306f 0000 0000 1400 0200 0f00  f=2E=2E=2E0o=2E=
=2E=2E=2E=2E=2E=2E=2E=2E=2E                                          =20
>        0x0030:  0000 0000 0000 0000                      =2E=2E=2E=2E=2E=
=2E=2E=2E                                                  =20
>                                                                         =
                                           =20
>root@bpi-r64:~# cat eth1=2Elog                                           =
                                             =20
>                                                                         =
                                           =20
>root@bpi-r64:~#=20
>
>so it looks like packets are not duplicated
>
>regards Frank

tried from my laptop wirh additional usb2eth adapter and see no bpdu

$ sudo mausezahn enx00e04c6c1dd3 -b 01:80:c2:00:00:00 -c 5 -t bpdu
0=2E00 seconds (22727 packets per second)

connected lan0 (eth0) to my laptop and wan to my switch (changed this to e=
th1)

eth0 is empty, eth1 contains some packets (but this is not where i sent th=
e bpdu)

seems dsa-user-port does not accept packets to this mac=2E=2E=2Edo not see=
 them on lan0 interface too

regards Frank
