Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EC76ACC5A
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 19:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjCFSVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 13:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjCFSVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 13:21:44 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D480392AB
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 10:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1678126825; i=frank-w@public-files.de;
        bh=uXIxqXfjoGc26UqeFA3iV1cgvjp7C16oVYcIvdavjvw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=myxpD+VD6snMA/MpYA7+qdBjUbJZk8SWdQzagZqkRuTNVn1nNzRUGv94vsjRbWGKZ
         w4hHQFtJka0r0+K+zsdYf9tPY68GbBtpM0ETHe4tXlJluiqE4d16fRIbKivXb1UlZh
         LRjtYve0mV2BFVS8JTHq7+CS5ZSxO9+b13QkxHKGwzrA4pa6rUAfOznl7C09G6meo2
         26Oq0rQDbpncTttTkD5Dj/C/KjJJC+5mZFH2SY1UvVW1+w0/Q/MyHAWxpSxTMGQ7yX
         TnKoMBzcwbze720XRxspiFFp3Fw/EpPmJc/TDu2toIDBrcC0xkm+4qwKd6UIG52GqV
         nSsstvvIO2HNg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.146.215] ([217.61.146.215]) by web-mail.gmx.net
 (3c-app-gmx-bs54.server.lan [172.19.170.138]) (via HTTP); Mon, 6 Mar 2023
 19:20:25 +0100
MIME-Version: 1.0
Message-ID: <trinity-a6b4447d-52b8-42a6-a4ce-b06543872534-1678126825554@3c-app-gmx-bs54>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     =?UTF-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Felix Fietkau <nbd@nbd.name>, netdev <netdev@vger.kernel.org>,
        erkin.bozoglu@xeront.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Aw: Re: Choose a default DSA CPU port
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 6 Mar 2023 19:20:25 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <20230301123743.qifnk34pqwuyhf7u@skbuf>
References: <trinity-4ef08653-c2e7-4da8-8572-4081dca0e2f7-1677271483935@3c-app-gmx-bap70>
 <20230224210852.np3kduoqhrbzuqg3@skbuf>
 <trinity-5a3fbd85-79ce-4021-957f-aea9617bb320-1677333013552@3c-app-gmx-bap06>
 <f9fcf74b-7e30-9b51-776b-6a3537236bf6@arinc9.com>
 <6383a98a-1b00-913d-0db1-fe33685a8410@arinc9.com>
 <trinity-6ad483d2-5c50-4f38-b386-f4941c85c1fd-1677413524438@3c-app-gmx-bs15>
 <20230228115846.4r2wuyhsccmrpdfh@skbuf>
 <CB415113-7581-475E-9BB9-48F6A8707C15@public-files.de>
 <20230228225622.yc42xlkrphx4gbdy@skbuf>
 <0842D2D2-E71C-4DEF-BBCD-2D0C0869046E@public-files.de>
 <20230301123743.qifnk34pqwuyhf7u@skbuf>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:S1l7h3el1iJucdUIzHzG4iCboJilUyPq9Jj9XX+rkSbSbGPTHeoZkE4UDs9QIlrSB5Kpl
 NgRasFWSsEonocgFAb+1SZgfRnK99cPI/6fpI3Lu4pNr67tDwVK6caop/uWVIVaxx/V8nq3FQIUl
 DaE3fMwDHXHRrwsYJlAyCk8MxDprcxcob/wSPk4zhnDzCwPUmMJ45RkFJGwvgkX6o8BXCLfpmatj
 3TjcwbtZ6tsQHvuwOdMUMlHzWQYPWa5EZYo5+p4AjwtqvomyiiLH1QTnLhQBi1OpnUFME3ouFdOL
 u4=
UI-OutboundReport: notjunk:1;M01:P0:g0ACftpqf7s=;igGzE/vwGVk3VddLf5bFz3kLRNf
 is5j8UorB4AxRK0773WUOfaLmGHoTFWuEDFK9ACRp7H2gIr5+sL2PYjGtGK5YtERGMyu3ru8Q
 N6srd30ZgSoX3jEtY1lTPCoO324HSRlXUXYSN3+k5RcgYO6HVc1+/0aOySZADHvyRhcVzLLp6
 CCLDPfyL35Bps6xrrRASQq0dHCF35UkAnGg9ENkBeSS4EV0OjBy5vEiHCDJQE441ZDPXfq0tI
 dAWM80uKhVqJOWweFBY8ex4dP+Ofsi3fwNhcfhjs9OmNq/aVh8G6NW3ZLUhl1PGjMf4qO4M1m
 pB98XW8yHGMD61DZ3F98nz/MwfZuWk+VNp06m/HLLYGz0yN8XXgAfOj9ENDcu0zVEpEjc1S3y
 3VWUZM2GN4/Kod7ig7kTXM0+6KraBbumGx9mSkPF6nDgc5C5USIjKTCb0NRroNdN3xbU8mN2B
 GAExz1+d2IOuV3LJvJi7/VC7pAzBJr0YX5sRalcTo8fGu07g/3UNWscN3lz1ZKHPagEi5RaYK
 0U/4JPRWlbuqznFqXp6YB7RmTA+Q8fSieFzElTp5soLkgvvGSuVQIH8s8fn6SEkGVUxPmtYBp
 HRxnRBwzfD6kPwV6g7MujXG1rMAiF8b2e9Ys+oMEMFLHUGdcCdmbqPbiMMaTry8WaY2R1fJz7
 KhjclRrfICQvPMiI4wKqjnONe0QVSn8RG5mXvWVt0bN1HO//LQcvea2hMzvaJI2m/h1pqGp5D
 JJ7hRfDclK1zzdxZf4qosaj0Pn83ntu/7P+gdHEohZYfeHqJy66aMtXPHuh80c6q/J/ilg/OU
 1aq1019VRRjA91mvdSPMCqFw==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

sorry for the delay, but have not yet found time to test :(

> Gesendet: Mittwoch, 01=2E M=C3=A4rz 2023 um 13:37 Uhr
> Von: "Vladimir Oltean" <olteanv@gmail=2Ecom>
> Betreff: Re: Choose a default DSA CPU port
>
> On Wed, Mar 01, 2023 at 07:38:10AM +0100, Frank Wunderlich wrote:
> > It was a userspace way to use the second ethernet lane p5-mac1 without
> > defining p5 as cpu-port (and so avoiding this cpu-port handling)=2E
> > I know it is completely different,but maybe using multiple cpu-ports
> > require some vlan assignment inside the switch to not always flood
> > both cpu-ports with same packets=2E So p5 could only accept tagged
> > packets which has to been tagged by userport=2E
> >=20
> > How can i check if same packets processed by linux  on gmacs (in case
> > i drop the break for testing)? Looking if rx increases the same way
> > for both macs looks not like a reliable test=2E
>=20
> I'd say that using a protocol with sequence numbers would be a good way
> to do that=2E Most obvious would be ping (ICMP), but if the code comment
> is right and MT7531_CFC[MT7531_CPU_PMAP_MASK] only affects link-local
> multicast packet trapping (the 01:80:c2:00:00:xx MAC DA range), then
> this won't do anything, because ping is unicast=2E

is it possible to map this function only to mt7530, not mt7531?

as one way i would add a check for the chip

if (priv->id !=3D ID_MT7530) { return NULL; }
//existing content for mt7531

where did you find the comment about multicast?

https://elixir=2Ebootlin=2Ecom/linux/v6=2E3-rc1/source/drivers/net/dsa/mt7=
530=2Ec has
"multicast" only in the packet-counters (mib_desc)

> The next most obvious thing would be L2 PTP (ptp4l -2), but since mt7530
> doesn't support hw timestamping, you'd need to try software timestamping
> instead ("ptp4l -i swpX -2 -P -S -m", plus the equivalent command on a
> link partner)=2E

have not done anything with l2 p2p yet, and no server running=2E=2E=2Ei'm =
not sure
i can check this the right way=2E

> When testing, make sure that both CPU ports are active and their DSA
> masters are up! Otherwise, the switch may send duplicate link-local
> packets to both CPU ports, but DSA would only process one of them,
> leading us to believe that there isn't any duplication=2E

> Putting a tcpdump -i eth0 -w eth0=2Epcap and a tcpdump -i eth1 -w eth1=
=2Epcap
> in parallel would also be a good way to double-check=2E

regards Frank
