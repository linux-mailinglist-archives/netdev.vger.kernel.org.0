Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183E34A028A
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 22:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350096AbiA1VHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 16:07:22 -0500
Received: from mail-eopbgr00066.outbound.protection.outlook.com ([40.107.0.66]:22786
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239231AbiA1VHW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 16:07:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6K6ju2UrPdnXwstQW2y1TDWc1+b7MKdCXAhNXEmM83PNEVMp2TCfs6KCqrTDGW2uKG8ooo06P9YsbhZT59q8b3ATWemu/pXoWKte4Y6SDUGbNrNcgaeJvBYQ4z6LRWXseVQI4qF1hQjBmaUEjVZq0PvA7Efv7RBm8gG9gZOBPTkZZZUoaXlM6iBD4DYi5kMolleROl9JnHqd26CtplxFI56kgivEeDASZd3DaBkSPANwLK4Yvl/GsiSMGyLIndiB2/khDy6uALsNDzJJLQONccDORgZsqzAeE8su4amuE6tDyeZuZwH2yOO6uqEJg5xjwPlpKf/LYWA7sRqhv3ZNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4VF/etLhg+fMGXtA4YdV83FtL8NUf2UV8z9vxCfAxGk=;
 b=SElvXvEarG0Enn5lzYdEVT973Uxu3JB0ptFQQU6q+lXzIE1OI9beaLytvT/3lZX9q5sw/cyIdUyifULfrlaA1kza5stk2XYldrT4LBLMHnMwHlipyyutcg/6XTs+4nr4GmmkR6NV74LR/Kk6aMb4ZRf0m1I4R3ilm8qU3M0+20MRLt+pTRZVrVsYJplxH5EAA5gqXhR19ENhvjKOHMfa18jMJqWbhhalBuhx7YOKLH6GJPfY9vvV3WcAugMeD0XhMjGxTFjkiAytInlFeflPazvjGjIFlLHPiy0mrQuMsJkqSs3J32BGOGxmnt2od5QEvMZyzXvFNYN5bbq5Lq5DHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4VF/etLhg+fMGXtA4YdV83FtL8NUf2UV8z9vxCfAxGk=;
 b=G5lf5V1kZ2tFUjk3YZNUDQhH8I/IKxKIG601cnD3+j8wA0lWHuF7vB0mJpfs5ARTLq3osRwfgiavl+rtCmjtRj1omfZU9Ue7UwNV695CtwDJlhn4kFr+WQT/jXcJUHR/L5jM8aF7SX9ND82ABp5fQBJyRDLQin409KY/EbC/qxVrH36BWiLQb3Sypji0FDdE9ciP6+fnZ2A7H/Ys7QDp1l06nUdtW9rjl4e1YQUtu9XEF20kEjN7dZn1KDUZxf6Zw2vJGlK9ONPhIJH/GSDQxfCkshW52fkrksa670Ny+C9GyRUSvm8yemIgS+3kehhFhJ3ySoF49PZhrjLPEYM5Dg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
Received: from AM0PR10MB3459.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:155::20)
 by AM0PR10MB2658.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:12b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Fri, 28 Jan
 2022 21:07:17 +0000
Received: from AM0PR10MB3459.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::95cb:ffb4:beca:fac0]) by AM0PR10MB3459.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::95cb:ffb4:beca:fac0%3]) with mapi id 15.20.4930.019; Fri, 28 Jan 2022
 21:07:17 +0000
Date:   Fri, 28 Jan 2022 22:07:14 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Aaron Ma <aaron.ma@canonical.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hayeswang@realtek.com" <hayeswang@realtek.com>,
        "tiwai@suse.de" <tiwai@suse.de>
Subject: Re: [PATCH v3] net: usb: r8152: Add MAC passthrough support for
 RTL8153BL
Message-ID: <20220128220714.626f2f79@md1za8fc.ad001.siemens.net>
In-Reply-To: <BL1PR12MB5157796F50C523D32F0F3C5DE2229@BL1PR12MB5157.namprd12.prod.outlook.com>
References: <20220127100109.12979-1-aaron.ma@canonical.com>
        <20220128043207.14599-1-aaron.ma@canonical.com>
        <20220128092103.1fa2a661@md1za8fc.ad001.siemens.net>
        <YfQwpy1Kkz3wheTi@lunn.ch>
        <BL1PR12MB515773B15441F5BC375E452DE2229@BL1PR12MB5157.namprd12.prod.outlook.com>
        <20220128212024.57ef9c59@md1za8fc.ad001.siemens.net>
        <BL1PR12MB5157796F50C523D32F0F3C5DE2229@BL1PR12MB5157.namprd12.prod.outlook.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0090.eurprd04.prod.outlook.com
 (2603:10a6:20b:313::35) To AM0PR10MB3459.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:155::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13377131-21ef-43bd-aa26-08d9e2a22a6f
X-MS-TrafficTypeDiagnostic: AM0PR10MB2658:EE_
X-Microsoft-Antispam-PRVS: <AM0PR10MB2658A92D0CC9FA46C8E0B91085229@AM0PR10MB2658.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5128u9luWlegzNGQCqK+15PJSFqRTcFFND5u4QAGKEaTEIdi2NCuANLZa1XYLNCGewGhAN9Z2UDVBS56wZMtWDB7UeN5KQHpLeSXaUtLTFzC7qR6NVVHpO7BInWxmWYygfcKUMU7WrrhascYmhFXO4b8JvF43FDV0AgFkxm5ZrmiejNpjqwOfxloyh1QBtmIKHvoPnFze09De/d/8cai9+0QZFBT72vf7rKDNiqoLdsgeNGflSj0zm4ZczZLRyU06725ukJXH6E7a/BueR6FsEZ83BkAcMetb0gaXMrjFPGpT5FRG0NMdEW7dsu9rMRLIZke05a3mz6h23gmTum/2Nd7mWPLYSdzSqh14KObLD1lSRyYfTn0GfdlhokBEJW0dR+dAm0PaAYQ7z0ScYVasRsv2evPH2VQwOzud01eoJWcOCIpwfXjPj+Y20mNLLOQZ+fx6jej2KyiBM2kqnGrmb/m9sugzkveo8KpxgFgVP28CiO90p1yFxvL4y/oQBtOAVWhZLiTDOkYNhqhsXtDKeyo1HmlXvnv2mdcbPmmROM++p0EURJZwqwJhxiU9HQ4362n8F+RI9CLmbJK6CTQ+lnZw2R9F+NOGPJKzxJP6BdT1AKfb3rmdIqMb+sFXaoTkNlj6ztLgtnbDYot2jr4Ot0eVamxQngcyMbHpwwllfS3pMUsy1BjiFS/Im77QBpZkIKDNo6Q4TxxL9plTbyP2VMKuH8v6iSuZarSuBblK1o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB3459.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(316002)(83380400001)(66946007)(966005)(508600001)(8676002)(6666004)(8936002)(9686003)(66476007)(66556008)(45080400002)(6512007)(4326008)(186003)(1076003)(44832011)(7416002)(5660300002)(82960400001)(38100700002)(86362001)(54906003)(6916009)(6506007)(2906002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UKKD/TZC3ScNkKkoHIC+NDFjWnnX+SkZJ0wf/RAwERfjNZV6eNLiR3EDmtpx?=
 =?us-ascii?Q?RkznQPiwlmqtq8DpzYVs9R5ofAHPuWXgLA5BE0Cjj/4g6y6sKXrc+OC93v5P?=
 =?us-ascii?Q?7DdE+umYbBOysUGczw0VoxYm2BiqzVjziRJAb7mgR8vfKBH/kYUhvpMcLckr?=
 =?us-ascii?Q?TBWn9xDq2hc34WgVGlfitUJ+azRsOC1EdI5Y7RdnrFachJhC5tAPPew0DJ31?=
 =?us-ascii?Q?MjODRH8HQE3LPUwfhQ3qFVaqnunQeOQXzK3IuVmh3H26465yazbkKrj7v9fV?=
 =?us-ascii?Q?L79ujNU9TwyVRfca+uR0DO5yRKY+DA5FAXmuBl0aMSYzmScnlTvwdudBewyg?=
 =?us-ascii?Q?sTy9ctnmks+fS3sV8o38CCXc9P5aaEQPWeIDmWz7kiOGkhCCG+MAWomX5GG+?=
 =?us-ascii?Q?Gw0YALjICXTga9Z7bFp65xjSYAN3Xpexho963ezTZ5IpVNUQG/lXuI+PYphu?=
 =?us-ascii?Q?UQZ6nDBbHf1/GYeiuuJXEYq2+ci/xN38mSIeiiWKRi2ZEE9CKXfr4hSOYR3Z?=
 =?us-ascii?Q?wzFIxuMrFND3uyoSnveCyXxwixOwyLGvOKRvagh/Fnk1dLYBI/bi3/o39DZD?=
 =?us-ascii?Q?B1ruNie8fCvOYT7zvMhhvu7UDHuDi232r4AQusQbIwNcy/PoWVVU+6e+D9B7?=
 =?us-ascii?Q?b0sJky8a5uLkOV+Cd6QIsDhR47sVMRzX+pOhNJlTkmK3xLhQ7IaL9GtRr14N?=
 =?us-ascii?Q?1S78sgnIxx1QfE8hZbRvWQMVitisaW2YtNqvFP1IBs1not+Pgwr53p+7ZMUY?=
 =?us-ascii?Q?kx9Hy3FFFFg1afZZm59/5HIkbLtUzne8669IKM6GKfm49rwnf/VIOS6UVYQ8?=
 =?us-ascii?Q?QN2AAnkbPZVF/EuMUPkUj8cNuFZx2zCHI7x9hsSVxqDpUnMFCU1gp/h+cRS5?=
 =?us-ascii?Q?4ccvOxv9iEr/Q0x3MYVimPHGOJjH+NisqcijBhwZtj2fHrGGR8qHtUScdAPF?=
 =?us-ascii?Q?67ojLRIEaXhjPu9xAZksO6zwc26YW67E1WoDkedaiD4k/lzsVb0JA2iadX5q?=
 =?us-ascii?Q?/ZNRsU/XveK5ZN+iOMB1vEsis4P/P3Py47pmb0bfBENAf5yFkPqSQzp54024?=
 =?us-ascii?Q?nhI+v4o5LW51mSSa1VO3iv0lSQ9Kb9BAz3K3MQ4J12MylCNu/oJixicFOpK4?=
 =?us-ascii?Q?6bSowbgpOeoSF3yH2GojFVa7GKrvo/va2W7lnmyNw4E5sKTj+9ja34/AVTRX?=
 =?us-ascii?Q?ksW0je+cyYtkm4p8qdaqWV32YlXHFXAstV/iTMvWO2yYBP3H4wYqd9rxwHvQ?=
 =?us-ascii?Q?OmUpIV77lAcYiCq57zgpE9lv/5yVwk2Y4oMrRIOzzxrtJeSAF9me/8rHV7+4?=
 =?us-ascii?Q?iMwLD5ihDG9qqMDjbP36sqY+0y96Mly9y+kuITSUQA/Omzf2mS31ScPiU4ZJ?=
 =?us-ascii?Q?hTWKMGIJru+byzww0s85lh/NO/1lBFJoABA+OqmnYYuuEqtqwbEsyt+B8qaK?=
 =?us-ascii?Q?Kjm2iZebTJ13eb4S2a8PXmge+qUvtupMWayc/1zZrbQyEFCCzxHfaNWwfFxl?=
 =?us-ascii?Q?nvtdAZVJTCDW/4P7QFU9asDyBKiZfJOZUjYgmE1Hgl+i6eAj92hc5CwNb/hV?=
 =?us-ascii?Q?6yV9yldfk6do5A+S7X/XfvhVkzgygzWySKxfWvbUaUjYAsy8/+ndT2XvMFxh?=
 =?us-ascii?Q?WPhWrBt9x213czBQK5JbP+mw2FUKiJX2GxgHYVIyhAx7zgeF0uvRXZ+d/bPa?=
 =?us-ascii?Q?Egd/KYcMB6o71dygrb6LeJ9pyhFCVAVLGeq4cVK6x3XWqbyo3LsAJZ3khLkl?=
 =?us-ascii?Q?2nyQrQOWBQ3IosijR4ccxg7iZz6j3Ko=3D?=
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13377131-21ef-43bd-aa26-08d9e2a22a6f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB3459.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 21:07:17.5895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lKu2PGlXkiU6MAAnNmp9LhkzTPC0COp0y5QgS1H5tLDDBZKJsCx/PEUXDFBAv8rOr+8a7Gk/4aDeZrdu2ZYDj5t/pj1oJZ+D3VKJ4ikMe6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2658
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Fri, 28 Jan 2022 20:29:58 +0000
schrieb "Limonciello, Mario" <Mario.Limonciello@amd.com>:

> [Public]
> 
> > > > I've not yet been convinced by replies that the proposed code
> > > > really does only match the given dock, and not random USB
> > > > dongles.  
> > >
> > > Didn't Realtek confirm this bit is used to identify the Lenovo
> > > devices?  
> > 
> > The question is really why we do all that and that answer really
> > seems missing. Lenovo might have a very different answer than Dell.
> > All i saw was Lenovo docks that suggest PXE. While that could be a
> > good case, bootloaders and OSs should then inherit the MAC of a NIC
> > that is already up. But sure not try and guess what to do and spoof
> > on their own. (based on weird bits and topology guesses) I am
> > willing to bet that grub/pxelinux/uboot/systemd-boot would all fail
> > a PXE run even if the OS to boot would spoof/inherit.
> > 
> > PXE uses spoofed MAC and bootloader will dhcp again and not spoof.
> > dhcp would time out or fall back to somewhere (MAC not known),
> > Linux kernel would not come, PXE boot failed.
> > 
> > In fact i have seen first hand how PXE Windows install failed on a
> > Lenovo dock and the real NIC worked. That was within my company and
> > i sure do not know the BIOS settings or what bootloader was
> > involved and if that Windows installer did active spoofing. But i
> > would say that the PXE story probably does not really "work" for
> > Windows either. In fact i am willing to bet the BIOS setting for
> > spoofing was turned on, because it seems to be the factory default.
> > 
> > And all stories beyond PXE-bootstrap should probably be answered
> > with "a MAC does not identify a machine". So people that care to
> > ident a machine should use something like x509, or allow network
> > access in any other way not relying on a MAC. If "Linux" cares to
> > spoof for the lazy ones, udev is a better place than the kernel.
> >   
> > > > To be
> > > > convinced i would probably like to see code which positively
> > > > identifies the dock, and that the USB device is on the correct
> > > > port of the USB hub within the dock. I doubt you can actually
> > > > do that in a sane way inside an Ethernet driver. As you say, it
> > > > will likely lead to unmaintainable spaghetti-code.
> > > >
> > > > I also don't really think the vendor would be keen on adding
> > > > code which they know will get reverted as soon as it is shown
> > > > to cause a regression.
> > > >
> > > > So i would prefer to NACK this, and push it to udev rules where
> > > > you have a complete picture of the hardware and really can
> > > > identify with 100% certainty it really is the docks NIC.  
> > >
> > > I remember when I did the Dell implementation I tried userspace
> > > first.
> > >
> > > Pushing this out to udev has a few other implications I remember
> > > hitting: 1) You need to also get the value you're supposed to use
> > > from ACPI BIOS exported some way in userland too.  
> > 
> > Sounds like a problem with ACPI in userspace. So the kernel could
> > expose ACPI in a better shape. Or you will simply need to see what
> > systemd thinks about a funny "sed | grep | awk | bc" patch to parse
> > binary. DMI might contain bits, but without clear vendor
> > instructions we would be guessing (like on ACPI?).  
> 
> Yeah I think if this is to be reverted, step 1 is going to be to
> export that data into sysfs from some Dell and Lenovo drivers so
> userspace can get it. No funny sed/grep/awk to parse binary.
> 
> DMI doesn't contain it (at least for Dell).

Would still cause a nasty vendor-lockin where passthrough would only
happen if peripherals match the laptop. In the end users would end up
very confused or Linux would cater for vendors selling their docks.

> >   
> > > 2) You can run into race conditions with other device or MAC
> > > renaming rules. My first try I did it with NM and hit that
> > > continually.  So you would probably need to land this in systemd
> > > or so.  
> > 
> > For sure you would end up in systemd (udev). NM is just one of many
> > options and would be the wrong place. You might quickly find
> > yourself in mdev (busybox) as well because of that PXE case or
> > because of an initrd.
> > 
> > If it was my call i would revert all mac passthough patches and
> > request Lenovo/Dell and others to present their case first hand. (no
> > canonical/amd/suse proxies)
> > The "feature" causes MAC collisions and is not well
> > understood/argued by anyone.  
> 
> Reverting it has the possibility to really mess up machines people
> have in the field that have behavior built around it.  I think a
> clear set of rules for what is allow to use it is the only safe way
> forward.  You need to "clearly identify the device" or something.

Very true, i was kind of hardlining it. But IMHO the clear rule is that
a MAC does not ident a machine. And while that might break already
deployed setups, it will make clear that passthrough is a clear no-go.
If you do not draw that line, many more patches might follow. Claiming
their rightful place next to Dell hacks.

The revert that did already happen actually has potential to "break"
already deployed setups. It was still done because i brought up the
case and people agreed. I can not speak for the Dell patches, they are
in there for much longer and will be more widely deployed. So a revert
will potentially affect for people. But they sure seem equally
questionable and not well explained.

> Just FYI I'm not intentionally acting as a proxy to anyone at Dell on
> behalf of AMD, my only involvement here is because I did the original
> implementation for Dell when I was there and so I can speak the how
> things were and thought processes at that time.

I bet nobody wanted to act as a proxy, it just happened somehow. If
that proxy can explain in detail why and how that is fine.

Since you have been at Dell and started that, do you happen to know the
real story? Like real ... not "i had to solve jira ticket 42"

> If the consensus is to revert this then someone from Dell probably
> does need to speak up.

If you do not cater for Dell any longer, maybe you would be just the
person to revert and tell them to reveal what "jira 42" was about.
Merge windows are wide open and distros will be slow to follow, so
enough time to react after a revert.

regards,
Henning

> > 
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fen.wikip
> > edia.org%2Fwiki%2FMAC_address&amp;data=04%7C01%7CMario.Limonciello%
> > 40amd.com%7C385b6dd02672490749d208d9e29ba192%7C3dd8961fe4884e60
> > 8e11a82d994e183d%7C0%7C0%7C637789980357612909%7CUnknown%7CTWF
> > pbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6
> > Mn0%3D%7C3000&amp;sdata=9vmPi1%2FF%2BxrkqpjoYoLmmupAJ1vBMckLLo
> > 5hDMqTuZA%3D&amp;reserved=0
> >   
> > > A media access control address (MAC address) is a unique
> > > identifier assigned to a network interface controller (NIC) ...  
> > 
> > unique and NIC, as opposed to colliding and machine
> > 
> > Henning
> >   
> > > >
> > > >    Andre  

