Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F2F2CFEB1
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 21:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgLEUO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 15:14:29 -0500
Received: from mail-vi1eur05on2130.outbound.protection.outlook.com ([40.107.21.130]:11781
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725270AbgLEUO2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 15:14:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6bT8Jrp7qYBHBwGp1z55FueuU5IZq3129cBsCNlkyIf7My8qKILCPKEnDCXw81JIE/CjtqvL6ZGeetm98CZ7cnDGksW6RRHAYEU8ONyitTcpZGRrMAJjdaB/ndg53PM1ZKaMv7nmmlg0Ub4lcdMpXKWQG3p9YH6ed1l63B24CGip+Now9DjgnzwkA+t20QfU0Wy4JUEsO+RvSAimkvePTE2I9l+rj1xwfqAbH7y0r0WmxHHbceWvTTGcxmUKmYqksc8hJz1Fz2lxL8oQdvuqAWFLvJLR+OonDyBca5ez8RJJEQSOHB/2y/wSPsCTfk/Nf3ZnrVuMs6pxvJkJFtupA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3kL9u5pfWpytpLctL+qMpZy/eNwHfzZV0AvJ5R1bp1k=;
 b=i5X/ICkls+hTYIJPVRMRQuD81xEGa1uG8DjpUaENWzHX6fFyYS3kBw9VA1/iutOX0MRemxA4rXophX3fhfBWdANDBGrm5OUcvwX0psUj0uX6h4DWtMYx8jcbWaajve9+sQntAKS/YyLSBsij4teHnVfIREZ1Vd7Y3ZN8ae4Gb8TeZlmjOF4OvZVQmbUgdwsaAt0YvG43cB3qbvzVSYWrs4mttdS72bh1sxsxGJujI7Qh+bX/BTuOiGmHtZYSLD6W7pM8rZOC3WYMXNLz4Jkv52zJm5Xr2vzQ6WRBzenQwXCxUQDBfffew1hdftqjnbXZeSy3Dn4YHvJYdUffRUohDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3kL9u5pfWpytpLctL+qMpZy/eNwHfzZV0AvJ5R1bp1k=;
 b=kgUx4SdMnhuSIk2PTyoko6+wf6CxOqMP17MdhP9w7df7FTWnJMeakeBSat5qvcg+YA7lIVHntfEkElBSX2Qk7UkXoXOEWwROwbEwcq206ueykMzhmazWZE/t7XCCkGxqcBwqGKz3vZDd9f64GlSb7oQ8pSBZ9GPY8I8rdYFAeH8=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB1923.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:49::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Sat, 5 Dec
 2020 20:13:38 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 20:13:38 +0000
Subject: Re: vlan_filtering=1 breaks all traffic
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
References: <b4adfc0b-cd48-b21d-c07f-ad35de036492@prevas.dk>
 <20201130160439.a7kxzaptt5m3jfyn@skbuf>
 <61a2e853-9d81-8c1a-80f0-200f5d8dc650@prevas.dk>
 <6424c14e-bd25-2a06-cf0b-f1a07f9a3604@prevas.dk>
 <20201205190310.wmxemhrwxfom3ado@skbuf>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <ecb50a5e-45e5-a6a6-5439-c0b5b60302a9@prevas.dk>
Date:   Sat, 5 Dec 2020 21:13:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201205190310.wmxemhrwxfom3ado@skbuf>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM7PR04CA0005.eurprd04.prod.outlook.com
 (2603:10a6:20b:110::15) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM7PR04CA0005.eurprd04.prod.outlook.com (2603:10a6:20b:110::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Sat, 5 Dec 2020 20:13:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af76bc5d-a2b6-4c12-ee88-08d8995a40ce
X-MS-TrafficTypeDiagnostic: AM0PR10MB1923:
X-Microsoft-Antispam-PRVS: <AM0PR10MB1923A53E39DD8540375DF1DE93F00@AM0PR10MB1923.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HVWumQTDRBnmp8BBx6pJYEV/T2gSeNMRkiBEnEMG4FZ1MUdlpcRRCRZLvdetI4kuRIoFZ5ag/xt7KMocLXT2wHqKTz5ZdsytO+S2wR1jBhk9GeK8VxUD8+bWV1R/GNwqGGl3utYxZ6TpQUPFv1mEedcSAlbuDBOLiAFyFZEF6aKOF9NzbEGHjBqbpgV69FIX5km50XwdIZKzYzCdZap/cDy+Zhs/WkSK6AhX2//4HQDtoal7TJshTrEYIhrwQg9SQnWwnOmweaDZt6X+5CDVm0S/f0VeJEvjwDlSmHrUphQciYUAAF/Polz9BBeI2NBGcl4OqhdLC+rpPpWG/FxG8mHLhUNoQOY5S+w6JG7EfhkEQWVMqFc6Zza5ZVJ4q7BP1qOll+62iLTuyATr5ORDCZLgzX6lkPRIRuT9On8sYc4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(376002)(346002)(39840400004)(31696002)(86362001)(83380400001)(66946007)(8976002)(66556008)(5660300002)(36756003)(66476007)(2616005)(44832011)(2906002)(4326008)(186003)(6916009)(16526019)(54906003)(6486002)(478600001)(26005)(16576012)(8936002)(956004)(316002)(8676002)(52116002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?sRcECNx/XJKXFIvHqtVqC/+XsAjS0sD4ar5LLAnKVZPsgYCVn27FbggX?=
 =?Windows-1252?Q?xJ/KxuXzXAQrYqiiEZRaGUTxfGl7szj939vxpcwHTnK50E6gyd9Olp8Z?=
 =?Windows-1252?Q?pQbeT1/ZOzrtgUORdOeYxlD7kzeR95Scdxy12f/ZfrqnoZdCO148QddO?=
 =?Windows-1252?Q?mCRmlQ7yB18j+EKKEWkFvNE0/poGpjrU40WTTBwOuyKdfdwbnstlcbE9?=
 =?Windows-1252?Q?MXlNYgSC3HgRZ5xC0DGKQKAyuHwTuOm9t4ojc9c8jgs3YoqUDb5lbwNN?=
 =?Windows-1252?Q?wdUvqm2lI+JyJjj9UZJj3RS7pPveXGeNGrsQx1Hkz9zcGdbWqYy87AWk?=
 =?Windows-1252?Q?fEBWLcVV6EvTotrge/jTvjDQfKL2k3ZtrzlNNBZ7k/iDN2XDdXsfsU6O?=
 =?Windows-1252?Q?rL4BTctfCRoIhU3i+RYIReBG9LMFNZuSrehTY9x4KmN5blA+jOIn5S6C?=
 =?Windows-1252?Q?DHPG8fAf5qsQx5zYZVw1bYxVZV5zqjZPB8mdyQMgs6NESNbNg7+i2vOz?=
 =?Windows-1252?Q?PtRDgMoq0VIefHucseIKqjlJgdieb/U93/1mad1zTm6Qw3m6EFj9sf4V?=
 =?Windows-1252?Q?SELM7xLw61otzIJkYUHN7BjV8trFj4P6rKIFYkklHZAmM9uH6FOSq7a0?=
 =?Windows-1252?Q?141Les1+/jI0ii5umBYEzk4wMZcSVopgLZNM0/d7Ed7gWX8aeWNXEWYD?=
 =?Windows-1252?Q?R/T0EsNiWf09JWwbzqt2OL9o1Vuczgj51bC5dGThxKDQ5FIElqkwwikn?=
 =?Windows-1252?Q?wMFBaGowbDUHIhYExO0KmgPitlkcuKQZqzpo1z0fYn/u/ElXXv/EWK1W?=
 =?Windows-1252?Q?taAMu4OIxuVymSYn3X7b5AyxOe2M2nk8KkytxLVJLHrg+5cw/fuCG0nt?=
 =?Windows-1252?Q?qM5V/H3L9JUtAB9DB2iI50xu4+aNp+RRrRk6UHraeP9aKSx9hqBBFBqf?=
 =?Windows-1252?Q?KPuERBzupscpviUyOYWWZuMhFAnl3CPxtfPizqUaNp5ZKMQn8MqFuqxx?=
 =?Windows-1252?Q?M5ItoX+ECPUITlHn0CpROxFjkk41SZ9ZA6tvHmu1imFyiwJoLpm4odn4?=
 =?Windows-1252?Q?sVSJcRLKQaZgbw1w?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: af76bc5d-a2b6-4c12-ee88-08d8995a40ce
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 20:13:38.7434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b1eT4DtmSys2r+XqyVW97p2vgMe3i/WbIxFYY6ysaLL04yk/ac/AvzIzVeaqDBmyRRAdLfEvlvuElP0dQBAUo97b3trtdgaTuJL5QdzhgEM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB1923
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/12/2020 20.03, Vladimir Oltean wrote:
> Hi Rasmus,
> 
> On Sat, Dec 05, 2020 at 03:49:02PM +0100, Rasmus Villemoes wrote:
>> So I'm out of ideas. I also tried booting a 5.3, but that had some
>> horrible UBI/nand failure,
> 
> Test with a ramdisk maybe?
> 
>> and since the mv88e6250 support only landed
>> in 5.3, it's rather difficult to try kernels further back.
>> Does anyone know what might have happened between 4.19 and 5.4 that
>> caused this change in behaviour for Marvell switches?
> 
> I think the most important question is: what commands are you running,
> and how are you determining that "it doesn't work"? What type of traffic
> are you sending, and how are you receiving it?
> 

Ping, ssh, you-name-it. Testing with both IPv4 and IPv6LL.

> I don't own a 6250 switch, but the 6390 and 6190. On my switches, both
> termination and forwarding work fine with VLAN filtering enabled -
> tested just now. This is with the official v5.9 tag:
> 
> commit bbf5c979011a099af5dc76498918ed7df445635b (HEAD, tag: v5.9)
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sun Oct 11 14:15:50 2020 -0700
> 
>     Linux 5.9
> 
> It's interesting that it is you who added VLAN support for the 6250 

Not just VLAN, all of 6250 was added by me around that time.

in
> commit bec8e5725281 ("net: dsa: mv88e6xxx: implement vtu_getnext and
> vtu_loadpurge for mv88e6250") which appeared around the v5.3 timeframe.
> When you tested it then, did you apply the same test as you did now?
>
> It is very confusing that you mention v4.19, since of course, it is the
> v5.3 tag where the 6250 support for VLANs has appeared, just as you said.

We're running with the set of 6250 patches backported to 4.19, and the
testing was/is done on that. I'd love to be able to run Linus' master
branch at any time, and that's actually what I'm currently in the
process of getting closer to (apart from the switch issue, 5.9 seems to
work just fine for us with just about five out-of-tree patches, none
network-related).

> As far as I can gather from your email, the only kernel where your
> testing passes is a kernel that nobody else can test, am I right?

In a sense, yes, but nobody else has the hardware that I have either.

> So it either is a problem specific to the 6250,

That is certainly a possibility.

 or a problem that I did
> not catch with the trivial setup I had below:
> 
> # uname -a
> Linux buildroot 5.9.0-mox #1526 SMP PREEMPT Sat Dec 5 20:53:11 EET 2020 aarch64 GNU/Linux
> # ip link add br0 type bridge vlan_filtering 1 && ip link set br0 up
> # ip link set lan4 master br0
> [   56.393743] br0: port 1(lan4) entered blocking state
> [   56.396614] br0: port 1(lan4) entered disabled state
> [   56.408327] device lan4 entered promiscuous mode
> [   56.410255] device eth1 entered promiscuous mode
> [   57.155280] br0: port 1(lan4) entered blocking state
> [   57.157639] br0: port 1(lan4) entered forwarding state
> #
> # ip addr add 192.168.100.2/24 dev br0
> # ping 192.168.100.1
> [...]
> --- 192.168.100.1 ping statistics ---
> 18 packets transmitted, 18 received, 0% packet loss, time 17034ms
> rtt min/avg/max/mdev = 1.389/1.643/2.578/0.266 ms

Yup, that corresponds pretty much to what I do. Just for good measure, I
tried doing exactly the above (with only a change in IP address), and...
it worked. So, first thought was "perhaps it's because you bring up br0
before adding the ports". But no, bringing it up after still works.
Second thought: "portS - hm, only one port is added here", and indeed,
once I add two or more ports to the bridge, it stops working. Removing
all but the single port that has a cable plugged in makes it work again.
It doesn't seem to matter whether the other ports are up or down.

I should probably mention that wireshark says that ARP (ipv4) and
neighbor solicitation (ipv6ll) packets do reach my laptop when I attempt
the ping. If I start by doing a succesful ping (i.e., no other ports
added), then add another port, then do a ping, the ping packets do reach
the laptop (and of course get answered). So the problem does not appear
to be on egress.

Rasmus
