Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B43458E7CC
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 09:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbiHJHWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 03:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbiHJHVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 03:21:55 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2044.outbound.protection.outlook.com [40.107.95.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3D9B1D7;
        Wed, 10 Aug 2022 00:21:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fi5NHlrflHNMoj+pBSMKz3779g2b7uf41RegPz1+Rc8g0Comck9HK5S2Bscsu5uSy11aRzGhRsyXzKZ/F4jDzuOTCNmpqP6iwDSBFzHm0wzzKpvtQgv40d+17gkBzZyDMX1vgO5NWKF8v7v26rtuFZusT+4EpGM9NvGsIGA29quF0I87VR9UzQDwSpD5KcfvtpxQu1WvYreDW1y8VwJT/R5u8dGPM+wNLnQLi6Tnolig+I+8GSZV3o36yEmOiKOzx6ikzqLeTAQUuqk8NCGoj3RKNl6MhxY7E3uWklzPtJIfle6mYj3WC4dRJnNk3RUX2NdTqbjLbEbP7kNghSEpkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pR1ZoXn+Mt5+8rp8p0AVp1PaxgJ8XEDZT/1qTU0Kq3k=;
 b=aZ8CidNko/gD5DFqGSkBTpGXIb5AWXIAZsXWdoL/2C6qVnKNsejuSOKUdr3KIBjEgrWOlWwzJ/23eEAjyJqKP2BUGKSiSqRZ8GiVNAyOAo2+NxxG47v2SdIZaOsfLEJ/Rtkzi2VNx8HGH84m3shKhUka6xdwl5sAGmYAR1KHRHnKbpqSV2/mfjyzw2aOC4eD1JQfL1K/7ix8hzl4IBNJr9oBYjDK31IWc/iQ/1BngF0ed3K1LsGR2ANb+TJiLYxZ4SqBhSZ8g7btG+1V5rT+iFIPhEVngx35sflQUPUrl+31bxkXd/cs/q/melCTG5w2dLqOihN+35E8qpovQ9klLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pR1ZoXn+Mt5+8rp8p0AVp1PaxgJ8XEDZT/1qTU0Kq3k=;
 b=mVkOBpvjlRKxEDHuypnGrPKcpsfkZYzjPBaW1QEwtCYbFkF9pGmzlN+pMtJcR9t6qntV07YlD0tU1Ifkx+8O7sF1I9g3ZXL1y0/o0v0NVRBAbwA3+oAHuJoExmEYCLiJ8jjJyUh+qLr3bGouOs7ZpVOks3aO9Lky2WX1HhfpVtQEYK70dm86grloI0dPzHM7HMwHpGfPYO9K0wHmN+vITMSLmg/WG+osopnBI6mBXAkFBVU1ZtTeraVnQh9/qCpZruZ18T2ma/I4zhX5fq8eOoGYFKXCUyGKIwUpfjxcSh443adG4tlvyOWIuN2QpeVVEk0c79GEi0fRqhEzB2vSmg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by DM5PR12MB2423.namprd12.prod.outlook.com (2603:10b6:4:b3::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Wed, 10 Aug
 2022 07:21:52 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc%5]) with mapi id 15.20.5504.014; Wed, 10 Aug 2022
 07:21:52 +0000
Date:   Wed, 10 Aug 2022 10:21:46 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@kapio-technology.com
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
Message-ID: <YvNcitNnyFxTw8bs@shredder>
References: <20220708091550.2qcu3tyqkhgiudjg@skbuf>
 <e3ea3c0d72c2417430e601a150c7f0dd@kapio-technology.com>
 <20220708115624.rrjzjtidlhcqczjv@skbuf>
 <723e2995314b41ff323272536ef27341@kapio-technology.com>
 <YsqPWK67U0+Iw2Ru@shredder>
 <d3f674dc6b4f92f2fda3601685c78ced@kapio-technology.com>
 <Ys69DiAwT0Md+6ai@shredder>
 <79683d9cf122e22b66b5da3bbbb0ee1f@kapio-technology.com>
 <YvIm+OvXvxbH6POv@shredder>
 <6c6fe135ce7b5b118289dc370135b0d3@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c6fe135ce7b5b118289dc370135b0d3@kapio-technology.com>
X-ClientProxiedBy: VI1PR0501CA0032.eurprd05.prod.outlook.com
 (2603:10a6:800:60::18) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1b77a14-3ec9-4fe5-ab5d-08da7aa0ff23
X-MS-TrafficTypeDiagnostic: DM5PR12MB2423:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MyeyyE3hSaOYim7Snv/3DRC0yotZ3hLBj0xoTpnmrzB+s9G/YJoH+lCJSbUOUC2srUIsQf2C9B/ZZbuyDyn2v1l7cjXTZVobAj7b11oCrDGQUfR3cVKutYsqSJlYj8Kk+WZcDmF+vO3bBk3gCElVMSFqysctENCriWj3V/Nhm6T2kGLd1XBGH5jsrJJ+FXGAibOOlIoutr3Ck+VBScjZjKxHKHQ6G8zrJXg2BZOnbzWEUIHJUUEGZwIbb+wtRzpMXU2mXkRXm/RQ0h4B7EZoncPolsl5cRGyX9jgtO6vgwjqD5vqgcxgt0HWF0zIqbMOHzALVoN9KKNZN8S4uGFi6WQdf6l+HxVqUgbMXwkhOcXy2VoooKE9tlni6/HXRePD2W+RuA/280bzfJdqZ8dAK4WiJ34oj83Kw2dG2uLFJ0gKdM/j+IHHVbR4y3BprWG1hpGBCkcg85IgFHLLFfrDPbDU07ywL42KpbImqm5LPy3HaKGi4a9lDF46N32xMv0gV68qvq66ZpvQQDkzeS+VHglrhQFPKcAoekyyPwsznrW7oywnSw/H9XzSlBiLvFPG+Pd/k0CR/lxMhhpttTWDdlu0iCNT2klfA5K9awk0IKGThNqz6Li4rzxfepexNqreaWhj5sVdUgzlv4ssIH2wJ16SEsBQsELeat0neuSlH6H+TwAzstP3qpAxr4u7cNaryoaanlD9j4ty9ObdKrj8mhFBZPGzhUKy7+DVBJ5SYHM7f4blpD4RJM57cv+T7heW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(136003)(376002)(39860400002)(396003)(366004)(38100700002)(53546011)(6666004)(6486002)(478600001)(26005)(186003)(6512007)(41300700001)(9686003)(6506007)(33716001)(86362001)(5660300002)(66476007)(6916009)(66556008)(54906003)(8676002)(66946007)(4326008)(316002)(83380400001)(2906002)(8936002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gGCOBlTa7Vn9R1fQ/z1ltF8gyr4gJVoChOsyGhoEigs89pndKvQllYjoyOyX?=
 =?us-ascii?Q?p6EiEtmPe4pe6qrFarhVpybaJSdjZh7IAevjq630kkhkkoovyLTSv+VsH12O?=
 =?us-ascii?Q?6vYSnK6tqm57XkLzZ1MAgqXcJmRXVj9QqYnD5VUfA0f2CkKvw7bEqKAOfzwK?=
 =?us-ascii?Q?I4+cGH8tIYsd6RAm2aKkRCxIPO0feOZqz3p+uFNL/1O2rpycWw4BeabgZeCa?=
 =?us-ascii?Q?YO1sD6cQIb2WRL50kYoHyOsfB9G0hyaZuDj7p5epdGpMhRC7w9XLqCcSCfiO?=
 =?us-ascii?Q?NmcjGXXeq1XfSvLAKOKTGpmuYQiYTE7OW8HCRg9jAuOaV0uhmgV0MqJEHUnf?=
 =?us-ascii?Q?99dB1CGcsbkOuHh5gpRBtLIouxJ+OTKNoQfctuu2hAFHPoM0o0TBKSriECUq?=
 =?us-ascii?Q?+BRRkR/tzi8y2g3hK9YIlK0Q3ha948ZHB4CR0IXenkVpPP/vXhYv7wnflh51?=
 =?us-ascii?Q?ZqoJsvtXY/BPeQZRDiVUjquhCPg5OFc2RZITsIezR6t4E0h3k8LIQC33dzHd?=
 =?us-ascii?Q?xC8f0kDbvphJwnnbbAFACSe9D5Uo54CLhzkCQTqOvFfsOnYxuFnRuCBTwFA1?=
 =?us-ascii?Q?cREdFVnZyY+uc/HHSTPyMNZVRSjJPyBTDIf9NHIPUJW4s1fDjUwmCu/0KLh4?=
 =?us-ascii?Q?XKauXlIHd4qY/LUzoqUyA3+sq1vE4isVouWu9KYRPrTL0WARDQi4eCuRmj0U?=
 =?us-ascii?Q?rsiiCXAqKd0zI4HjVYEO3iRJlf9nRBm0Mz0Zk4nybFuzDaXEn5pHDv7EdrdK?=
 =?us-ascii?Q?ghMDj2KokmyXAYFOuQ5RqQmaV1qh+smJR9+jv3Cjf37osIFQ9wCu9eCCvR5Y?=
 =?us-ascii?Q?ceLSCmZ3WMPAldtHIkF0Qxb2UWf3WKzdb/ydiyQsrEBMS2ffhnbhlgs/15QO?=
 =?us-ascii?Q?FUeNyJK27OFHcQe1ZrRHhbjJdKWU4UKCx87/X8keLFjNZWkVeu5hLqKxuKKs?=
 =?us-ascii?Q?WaAOXfxM4uRvlySMyPxrA6+PIrKiCUfkekJhNd69zmZaBFn6jopE9HcBvSve?=
 =?us-ascii?Q?ZqdmL7SiVvdz/LSwNSnKAUYkNGYZ5pIdy3jXL0+iIPyKiAr6cZZFJn2E3buw?=
 =?us-ascii?Q?Ko+bJ2/P4UHdngHBqdRw4ZUlPY29nmUazlPnh2qx9JUsKyyhnEqCkUa5OTya?=
 =?us-ascii?Q?l1DDPaWa6Uh9Oppo4D3updiO8PPRqwtPPSStBdJiIbk8H/9aabzYneltUPD4?=
 =?us-ascii?Q?mSZMRX7rqSECS6X/vYB5qPt29Qg2dodQ0nmEuJFM9+8uVXZIz+u2Z7dzmPiY?=
 =?us-ascii?Q?tTji3ougQ7lP93tM/qVYXYS26Qs+qRtwPOvj7/DCiyKmwSSXunOFj6spyICo?=
 =?us-ascii?Q?1Th5TQu0UgLm00qeNkPo1SJh2dIk0ULNivo3BLyeLJwZc0KHbXvmDhTRU6DV?=
 =?us-ascii?Q?ftrLvw3+5dvIW2wlyPT07IAI7hApcIaFZl9dUPbi6tnXlX84ZCpyrtMPTkdz?=
 =?us-ascii?Q?RR9ym2z0M3X4QVJNg0mGjCAcyJ21qoIHhfRm05JlmuHtNu/ExIO2eYWq3/gE?=
 =?us-ascii?Q?x7ciK6knN6LlwjlVXmYB/xEP7j64NGCDQOrLnxUIeCPq/dQ0Fb6msGuTy4wj?=
 =?us-ascii?Q?JDXClAMbt3nchgwH3Gk9Wztxqo/Z6+SUiTOok5bK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1b77a14-3ec9-4fe5-ab5d-08da7aa0ff23
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 07:21:52.1636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y+eAx5XQOkEBFd0Cpsjsbrk44I+Vc7JvlE/3+lpI4VTgJs5gSYXb+g5Ddm1/Hqqzm11QqcRAIE1MIrCERcujsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2423
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 09, 2022 at 10:00:49PM +0200, netdev@kapio-technology.com wrote:
> On 2022-08-09 11:20, Ido Schimmel wrote:
> > On Mon, Aug 01, 2022 at 05:33:49PM +0200, netdev@kapio-technology.com
> > wrote:
> > > On 2022-07-13 14:39, Ido Schimmel wrote:
> > > 
> > > >
> > > > What are "Storm Prevention" and "zero-DPV" FDB entries?
> > > >
> > > 
> > > For the zero-DPV entries, I can summarize:
> > > 
> > > Since a CPU can become saturated from constant SA Miss Violations
> > > from a
> > > denied source, source MAC address are masked by loading a zero-DPV
> > > (Destination Port Vector) entry in the ATU. As the address now
> > > appears in
> > > the database it will not cause more Miss Violations. ANY port trying
> > > to send
> > > a frame to this unauthorized address is discarded. Any locked port
> > > trying to
> > > use this unauthorized address has its frames discarded too (as the
> > > ports SA
> > > bit is not set in the ATU entry).
> > 
> > What happens to unlocked ports that have learning enabled and are trying
> > to use this address as SMAC? AFAICT, at least in the bridge driver, the
> > locked entry will roam, but will keep the "locked" flag, which is
> > probably not what we want. Let's see if we can agree on these semantics
> > for a "locked" entry:
> 
> The next version of this will block forwarding to locked entries in the
> bridge, so they will behave like the zero-DPV entries.

I'm talking about roaming, not forwarding. Let's say you have a locked
entry with MAC X pointing to port Y. Now you get a packet with SMAC X
from port Z which is unlocked. Will the FDB entry roam to port Z? I
think it should, but at least in current implementation it seems that
the "locked" flag will not be reset and having locked entries pointing
to an unlocked port looks like a bug.

> 
> > 
> > 1. It discards packets with matching DMAC, regardless of ingress port. I
> > read the document [1] you linked to in a different reply and could not
> > find anything against this approach, so this might be fine or at least
> > not very significant.
> > 
> > Note that this means that "locked" entries need to be notified to device
> > drivers so that they will install a matching entry in the HW FDB.
> 
> Okay, so as V4 does (just without the error noted).
> 
> > 
> > 2. It is not refreshed and has ageing enabled. That is, after initial
> > installation it will be removed by the bridge driver after configured
> > ageing time unless converted to a regular (unlocked) entry.
> > 
> > I assume this allows you to remove the timer implementation from your
> > driver and let the bridge driver notify you about the removal of this
> > entry.
> 
> Okay, but only if the scheme is not so that the driver creates the locked
> entries itself, unless you indicate that the driver notifies the bridge,
> which then notifies back to the driver and installs the zero-DPV entry? If
> not I think the current implementation for the mv88e6xxx is fine.

I don't see a problem in having the driver notifying the bridge about
the installation of this entry and the bridge notifying the driver that
the entry needs to be removed. It removes complexity from device drivers
like mv88e6xxx and doesn't add extra complexity to the bridge driver.

Actually, there is one complication, 'SWITCHDEV_FDB_ADD_TO_BRIDGE' will
add the locked entry as externally learned, which means the bridge will
not age it. Might need something like this:

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index e7f4fccb6adb..5f73d0b44ed9 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -530,7 +530,8 @@ void br_fdb_cleanup(struct work_struct *work)
 		unsigned long this_timer = f->updated + delay;
 
 		if (test_bit(BR_FDB_STATIC, &f->flags) ||
-		    test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &f->flags)) {
+		    (test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &f->flags) &&
+		     !test_bit(BR_FDB_ENTRY_LOCKED, &f->flags))) {
 			if (test_bit(BR_FDB_NOTIFY, &f->flags)) {
 				if (time_after(this_timer, now))
 					work_delay = min(work_delay,

> 
> > 
> > 3. With regards to roaming, the entry cannot roam between locked ports
> > (they need to have learning disabled anyway), but can roam to an
> > unlocked port, in which case it becomes a regular entry that can roam
> > and age.
> > 
> > If we agree on these semantics, then I can try to verify that at least
> > Spectrum can support them (it seems mv88e6xxx can).
> 
> The consensus here is that at least for the mv88e6xxx, learning should be on
> and link local learning should be blocked by the userspace setting you
> pointed to earlier.

Why learning needs to be on in the bridge (not mv88e6xxx) driver?
