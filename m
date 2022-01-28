Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CF04A01C6
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 21:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240968AbiA1UUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 15:20:32 -0500
Received: from mail-eopbgr50068.outbound.protection.outlook.com ([40.107.5.68]:47013
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230374AbiA1UUa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 15:20:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NvwJwiAi8YNKOyo2RwCpxzXbRHdtVBk7PoqdeyCgRQQSczOoQjFE0bTftsLS5VxzOngAtkX4AM86Ou0/idPLl3v/v1i6d3wfybsJnoMF7Bklpbq9PUQBZLwcK3fbez+Xi3PzXmONxM7FgfGJuPbank3qkVzkbrk1ly7Lo50fXdjzTQMBIOhPDrJVz/T8dd6WMvCGwkByeVRhqMiSgWtfAs5Nbppssf++mAyO/wq6rNW38/Cw3egt8FQ2QbZG3/qkFfvI0UzjaL1tiGIBgCM0O2I+5peWxKVCTb3zWNRFXNkOX4GCRbNmd45j/WCbC4z87YkVU1eyznxSzcX8Jx+VqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BCSFTswjMjguC/SLzR+lUUkHhZb5/RnM0yNPoqKLW68=;
 b=AoK3h6680M3vDlTSgNEhQgYeqXNZIfAubI9L1PA5EDt6QVMzcBCo3oBOZa/VM6l8oEAP/LBOaNGP8/rjR6x65wN0aNIzKsBXkCOOOGVqPKO2lJ4DXepuJZxpwd4nFUDztGNne6YQq9zWNlZI8GbQjqbdSp9tNqygZL7lU6Lv/0d+SBNuHrnr1gqvqtbk1GmvDxp00vI3vtQexa31Mo9qmogapUURQaZF1GOfTJhtE4nvQ2WFqc/uAlrStpT+oL/Yt8T0ZEdycPLKhgureml7YqsbustxsD+n8D8mfp1pk9TVPLKl+oGLc3O90+Hig+95rbUstEAAqO1VOG+P+nTPjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCSFTswjMjguC/SLzR+lUUkHhZb5/RnM0yNPoqKLW68=;
 b=P1mwoI8SiUgM4tRMKCNA0bX4QnFxnFUj9WnWDIOHyQgGKFBFfSvviBQsg/xhXal65nnDIR88e0ngyY2TR6Nib8DhNLokfgu8tdFa4WK19HhKLR06irk1iW2TRcnF0Bjklqo4Bvin53h8Z7z7WtRpFzUzY2l5vDsdgBYrExZlY34tZuznXu2S8h6cbufhiWTJBJ3HZtHm2kG0QoNk91eAYlliWfA3gYxWr3u2FH/wqJZQH7IJ4tomqZzgme0qRShCJOZC/xwnhlIeZkDQ9RrBWr7S9rIATxO+3xxjN8O72zL4syBJk6tuU5vLcOgOlbH6Q220okcRVSSZKul0CJOsLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
Received: from AM0PR10MB3459.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:155::20)
 by DB7PR10MB2153.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:45::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Fri, 28 Jan
 2022 20:20:28 +0000
Received: from AM0PR10MB3459.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::95cb:ffb4:beca:fac0]) by AM0PR10MB3459.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::95cb:ffb4:beca:fac0%3]) with mapi id 15.20.4930.019; Fri, 28 Jan 2022
 20:20:27 +0000
Date:   Fri, 28 Jan 2022 21:20:24 +0100
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
Message-ID: <20220128212024.57ef9c59@md1za8fc.ad001.siemens.net>
In-Reply-To: <BL1PR12MB515773B15441F5BC375E452DE2229@BL1PR12MB5157.namprd12.prod.outlook.com>
References: <20220127100109.12979-1-aaron.ma@canonical.com>
        <20220128043207.14599-1-aaron.ma@canonical.com>
        <20220128092103.1fa2a661@md1za8fc.ad001.siemens.net>
        <YfQwpy1Kkz3wheTi@lunn.ch>
        <BL1PR12MB515773B15441F5BC375E452DE2229@BL1PR12MB5157.namprd12.prod.outlook.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0004.eurprd06.prod.outlook.com
 (2603:10a6:20b:462::20) To AM0PR10MB3459.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:155::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c23e4e28-1e22-44a0-5eda-08d9e29b9fa8
X-MS-TrafficTypeDiagnostic: DB7PR10MB2153:EE_
X-Microsoft-Antispam-PRVS: <DB7PR10MB21533EC169EAE1C3631A389285229@DB7PR10MB2153.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ajET6+eFS+Vx4TYkz1oZF75IFc5pseiocrPA4jtxXZu23/mUWewFA8edn5xYUU4CyJAuCALS7UDJpOm5mxUIvRLueVS9RpDTpotASDIPBkP0YZ2yGr6MJrojVnX9OIjavnsYfJJ12QxY1kYo5WgTsoVNRPWPqZ7vcsdvV3MpNvd+fT4mT2wMSD4+zc9O3AePv/kuFMpNy9D38xr8jINXxh6oQg19V7HlaIROMrfTR1gaGSrRmRxeql+uJaFXe0LxGJNF3E7X3LofDBAb/p/wzrJkpU/kMxzaVjI3vw/G9HLmyMBUelMKK20Qh2Gp2nT3V5RndMRApA3JAd3XExsFDl0hE8Z8m3Vhfk3CkMxsq7gKHBJUOCaZ4LN02vJZdQKv//DUoYgB9V8uwo2nPlURE6PphhMJarmXTCEwAs+NUKcrxK9bsScJutFEJdIW1z7Hxsw6+ckMgENkboPEL5A7fI5yOuXpdbY7wc38kdt/af7ocQ7OjuKJckonT6EGnaEoFviqT+VVqz3T9Bv2jGvvvJSk4Dhax8C4J4dTsJ0KHZJJ5PR9/hxPmLo0bGVQllhZkbxAWtkoQUDdwcbbNiCZcPd1UFSWmgZaOU3Ofv6DZdOfVHODa/i8C+S0fniV4vl4FllXJLigi4t76BJ3h4a74BybSqOjTskDfdwgOJ5Z0Tn8P8YbLvFKIsRGxOpRCWBt2P9JXq/8hxYPEOBZx03C7WMkYCgFR8hnJbw1YZ8t7I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB3459.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(82960400001)(38100700002)(2906002)(83380400001)(1076003)(6486002)(6916009)(316002)(186003)(966005)(7416002)(53546011)(9686003)(6666004)(6506007)(86362001)(508600001)(54906003)(4326008)(8676002)(8936002)(66476007)(66556008)(66946007)(6512007)(5660300002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UQHqjebhayTmF/27n4o3E7lOL5gXDOG7nHagaSWS2hxOJjFpYjJj0bFVbP4t?=
 =?us-ascii?Q?HH2uDWM/EtQxZRMnOjVk7vR6ZwjPcsNIRoJYji107stK74QWfnIxyU+gT3Nq?=
 =?us-ascii?Q?KK91rkHpdfGMf7W40Kt+sVuRSGfryUftMzkWGTsWUNEWhvZaSGH4Z4cWCr0+?=
 =?us-ascii?Q?dqOusiLtguYakJIQTa1PEwbJHvtfv8CHr7NcezJ6+5LJaOmmx04/igG0plo8?=
 =?us-ascii?Q?tKiEAzQMfbNJPDz4xqjVVpvWJu3D/2cNbfin7BDctVlW6K2A19RfPDGxw343?=
 =?us-ascii?Q?cwLEhxmiOop8gnxZM82j4Y7Vw2hP2iu78b/uIC2Id4xvcUyl21ioHYGeXB3I?=
 =?us-ascii?Q?RGBQ/EZ7pse3JG1wWQLuC2btk6lGBddl1HhjjZEZsbECL0A1b0lFyFdsBXwM?=
 =?us-ascii?Q?fxmWfwaxS1erXTRxCu0YUZEiRwXXSco2E1q5LBylkmHgAAvuwSet/+x3zZrf?=
 =?us-ascii?Q?Jx0UlJwPC1GbaLlP6HFtSZeuxbCFTiFEhkzbpInE+fE+gcJZEQruf8sX3+ij?=
 =?us-ascii?Q?Lh968vt5cD0cNfg0mjt83o5Kxsxl8tHkyCv2bGVfvBY4hY/Cqr2Tr36CSLr5?=
 =?us-ascii?Q?Q0OTh1dzL4A2wnWbw8+zwbI5dPiM8I1ljD+jYptyiXz0wipAK7LhWuj7tk22?=
 =?us-ascii?Q?Y/+7SBdfa3qBjkbZ1yRic67A0t2ZTOtB1uehBWtNkznZxmHbHFkbBbfv5lCH?=
 =?us-ascii?Q?4M2TDVAPmmxWLEWEw4j8Hr09wlehrcftFKoSC0SmyWlARwrsqRNrxmAUPe6E?=
 =?us-ascii?Q?yA5iWBFCNYcZ+bCNxdPWhAzi0TyLLO6af8Td2qupbjvjCHn6oYmlj3NF4CDZ?=
 =?us-ascii?Q?9Y1rGiPlR3uOfbD40G7l7x/Vv2mDqtzLJe4woHeaeT2dsOYErw20wJ9QaEio?=
 =?us-ascii?Q?uDhVewDvzACvlxnNug3j7vfGIfUNTGhlz5DUhHZTKrLsic8Mv/iXQf44Qyuq?=
 =?us-ascii?Q?euU8A3dMjJhZtFJjgBuYCxQbN6eLmyMAbchpBaM8oK0jlQioPrItQcFAnYZb?=
 =?us-ascii?Q?hGBNF+tjkT5ObVJy6aSWDynFTfChrpYuxUAsMbZejCFmHvokA/35zZWJWUJO?=
 =?us-ascii?Q?2X+Oa37DlGQfKhgo7BtoA2VVBkHhGJzcsyAL/4PYLYkUYpSe84QUv9cX1xjQ?=
 =?us-ascii?Q?SfKvVDS/liE9p4zlFnIT2p06RzUaRem8A8omN6SR3M1MzfOCpTUIqo6WpB3Q?=
 =?us-ascii?Q?9bNcAIMtq/kn+MPyiHVgokTCWw23ndpb5dnp836TiauHNIgA5b7SkQO8iRAH?=
 =?us-ascii?Q?++J1qo76jmewvfx3b+ISunT4LmSQw+lntDr/Z2hjlK4P2cQ694CbOaWw9nAQ?=
 =?us-ascii?Q?ZnG4pEQx22qAbEvqshWpX4+vh6740NYwmjKLF8yr9MU6e6VjHayhb2nc6c9I?=
 =?us-ascii?Q?/BrINY6xRmG77yngzzt0YtWSBLTT8udyACHMt3WOrWwTfW5ijhjbrCl8HoI+?=
 =?us-ascii?Q?Yuffc2vO9tIMtWKl8TVLXMdTtz2QK1E0jyKVWc5nKdO0pFbqs/alK1jk5pB1?=
 =?us-ascii?Q?nTI6ZHUW7hjWtWf0Vm2UbTG0bteuGWzHgr00Y81JgUfFXz82ghRr5wQIBgey?=
 =?us-ascii?Q?8dFbOQSGOUO2cqalGWm/zjSvDnI0KtgwPrcJPLttEZW3rJNbpZigyg/TNnwE?=
 =?us-ascii?Q?8oY7pK8NnjPwhYCkaYilEnVseWUS8V9uZdh9rBn09csdFAGV52BeXNcX/I84?=
 =?us-ascii?Q?nAla3l75kmgzzzKJIV4NvMVs5Za9Wfd3EN57CiSy1hnoD5jiL6Mjt9v8Vdvr?=
 =?us-ascii?Q?uqHXEY+4mg=3D=3D?=
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c23e4e28-1e22-44a0-5eda-08d9e29b9fa8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB3459.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 20:20:27.8087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mlf5t7DD/Da/l3sWmZOq968doCiDgO02HeTfOJ1rzXBigbjXSMlUrFOsohW0FYpaBJiw+ldPwDuwrZ5OyKlipifYj1Yh3gQI4gX2NBU8KYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR10MB2153
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Fri, 28 Jan 2022 18:41:16 +0000
schrieb "Limonciello, Mario" <Mario.Limonciello@amd.com>:

> [Public]
> 
> 
> 
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Friday, January 28, 2022 12:07
> > To: Henning Schild <henning.schild@siemens.com>
> > Cc: Aaron Ma <aaron.ma@canonical.com>; Limonciello, Mario
> > <Mario.Limonciello@amd.com>; kuba@kernel.org;
> > linux-usb@vger.kernel.org; netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org;
> > davem@davemloft.net; hayeswang@realtek.com; tiwai@suse.de
> > Subject: Re: [PATCH v3] net: usb: r8152: Add MAC passthrough
> > support for RTL8153BL
> > 
> > On Fri, Jan 28, 2022 at 09:21:03AM +0100, Henning Schild wrote:  
> > > I am still very much against any patches in that direction. The
> > > feature as the vendors envision it does not seem to be really
> > > understood or even explained.
> > > Just narrowing down the device matching caters for vendor lock-in
> > > and confusion when that pass through is happening and when not.
> > > And seems to lead to unmaintainable spaghetti-code.
> > > People that use this very dock today will see an unexpected
> > > mac-change once they update to a kernel with this patch applied.  
> > 
> > I've not yet been convinced by replies that the proposed code really
> > does only match the given dock, and not random USB dongles.   
> 
> Didn't Realtek confirm this bit is used to identify the Lenovo
> devices?

The question is really why we do all that and that answer really seems
missing. Lenovo might have a very different answer than Dell. All i saw
was Lenovo docks that suggest PXE. While that could be a good case,
bootloaders and OSs should then inherit the MAC of a NIC that is
already up. But sure not try and guess what to do and spoof on their
own. (based on weird bits and topology guesses) I am willing to bet that
grub/pxelinux/uboot/systemd-boot would all fail a PXE run even if the
OS to boot would spoof/inherit.

PXE uses spoofed MAC and bootloader will dhcp again and not spoof. dhcp
would time out or fall back to somewhere (MAC not known), Linux kernel
would not come, PXE boot failed.

In fact i have seen first hand how PXE Windows install failed on a
Lenovo dock and the real NIC worked. That was within my company and i
sure do not know the BIOS settings or what bootloader was involved and
if that Windows installer did active spoofing. But i would say that the
PXE story probably does not really "work" for Windows either.
In fact i am willing to bet the BIOS setting for spoofing was turned
on, because it seems to be the factory default.

And all stories beyond PXE-bootstrap should probably be answered with
"a MAC does not identify a machine". So people that care to ident a
machine should use something like x509, or allow network access in any
other way not relying on a MAC. If "Linux" cares to spoof for the lazy
ones, udev is a better place than the kernel.

> > To be
> > convinced i would probably like to see code which positively
> > identifies the dock, and that the USB device is on the correct port
> > of the USB hub within the dock. I doubt you can actually do that in
> > a sane way inside an Ethernet driver. As you say, it will likely
> > lead to unmaintainable spaghetti-code.
> > 
> > I also don't really think the vendor would be keen on adding code
> > which they know will get reverted as soon as it is shown to cause a
> > regression.
> > 
> > So i would prefer to NACK this, and push it to udev rules where you
> > have a complete picture of the hardware and really can identify with
> > 100% certainty it really is the docks NIC.  
> 
> I remember when I did the Dell implementation I tried userspace first.
> 
> Pushing this out to udev has a few other implications I remember
> hitting: 1) You need to also get the value you're supposed to use
> from ACPI BIOS exported some way in userland too.

Sounds like a problem with ACPI in userspace. So the kernel could
expose ACPI in a better shape. Or you will simply need to see what
systemd thinks about a funny "sed | grep | awk | bc" patch to parse
binary. DMI might contain bits, but without clear vendor instructions
we would be guessing (like on ACPI?).

> 2) You can run into race conditions with other device or MAC renaming
> rules. My first try I did it with NM and hit that continually.  So
> you would probably need to land this in systemd or so.

For sure you would end up in systemd (udev). NM is just one of many
options and would be the wrong place. You might quickly find yourself
in mdev (busybox) as well because of that PXE case or because of an
initrd.

If it was my call i would revert all mac passthough patches and request
Lenovo/Dell and others to present their case first hand. (no
canonical/amd/suse proxies)
The "feature" causes MAC collisions and is not well understood/argued by
anyone.

https://en.wikipedia.org/wiki/MAC_address

> A media access control address (MAC address) is a unique identifier
> assigned to a network interface controller (NIC) ...

unique and NIC, as opposed to colliding and machine

Henning
 
> > 
> >    Andre  

