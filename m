Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F6A5972C6
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 17:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237154AbiHQPOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 11:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237212AbiHQPOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 11:14:23 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8A031ED6
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 08:14:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1VCqiUpGonf48I32EiNQ5i5Ku89kqkNMBn9Twq7VoMQhaqFUWExGly4nY3wfr6ypo2b62zfilXGbt0KKU8QY5Swc28hf9CDic1P/p1sCa3iIhngyKRD8T0Dc9Y37GPUl69bfFOY8v8jFBaLPsR1ReYbwQKlvx8Khf2rLinRCcDghbEEdT+ZohhUHaR0zq8u+jXY41Zjc+UV5ZoT1axhv/xDvWMmpIwWz5opjGeFRKhrpVTL0SlE4J6UtwugLeXGuF8duOabsRKy75kZ9uVYWcgjT1fMu2ZTAnh9ZchKQJHQKEw2Xq5H2WWUjn9qGv1qF5f1uu8Sc3DkV/4UT2dEWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IiZ8p9ICwmI2efoeBV8oZrjyHyumWbZ/hpM1IhdmUUk=;
 b=lxKSWBpyy6iZG/x6mtRZkdYBhU3VB9OJjqnl1DZGvh+Lb8x6JBvSNAg6KCCKzJGSxB0XzCACXSrj/2ZwfUF8y/UsNlPGecqdt57OZm4NeqRCTXx2Hvt6cmZsDLxcI0wkwhC2Qtssd8nK5gyGQp9HSbCU5RGf9yOjKIyqoXzExVhIqEVFTbgTAbiF6QhKlUcK0AR73GP/aY9mbd9JaKOhqgWV5vnTxKEe8mGeL9jZ4uPvtObDHkgaWX/TiEwrg8gMeTId4N1JYkN0ktcOzop0eaA2f9FnJYCSnSMr1Dou+7bskjkYSOSIdkoy1NVZxcHaasmYuKIJXqUtFCfJs9gpAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IiZ8p9ICwmI2efoeBV8oZrjyHyumWbZ/hpM1IhdmUUk=;
 b=MDLielee3Xc9Odod+ZGnLw0qvt8atRuZyB/r4fTQBmuDt5EstmGIczF4nemWulpvPu5atwYRebZGKGQkX3Dz2Dx7XLbiSU3+Dhx8NzbpLgmy6HA7ElPJuqhjARoSPVrx5yH1OzsQ48/cDQOmg4a4Lbqu4iK0wAoKEOfRlR8Vja0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB5298.namprd10.prod.outlook.com
 (2603:10b6:208:320::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 17 Aug
 2022 15:14:18 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Wed, 17 Aug 2022
 15:14:17 +0000
Date:   Wed, 17 Aug 2022 08:14:09 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: Re: [PATCH net 6/8] net: mscc: ocelot: make struct
 ocelot_stat_layout array indexable
Message-ID: <Yv0FwVuroXgUsWNo@colin-ia-desktop>
References: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
 <20220816135352.1431497-7-vladimir.oltean@nxp.com>
 <YvyO1kjPKPQM0Zw8@euler>
 <20220817110644.bhvzl7fslq2l6g23@skbuf>
 <20220817130531.5zludhgmobkdjc32@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817130531.5zludhgmobkdjc32@skbuf>
X-ClientProxiedBy: SJ0PR03CA0377.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::22) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b46c72ac-4a6b-4c25-ad79-08da80632744
X-MS-TrafficTypeDiagnostic: BLAPR10MB5298:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1i0JpkPzRM09rxND6LtOFzDMMCl1JElRTdU/6VsDCSIhoO9gVxEde6sZDs5f4wA6emU+WU5ZvM7MknQVW92elXewsoa7e7vyScY7iY6wfGb4CiSUi2KkkFKT4XCEZV2vRgmyOjPNUVZhIAoowBT0HfFiM0rMrSjy3c/BllolPD+xapXdid6iFd7v1BuB0TwNYGfjI/tOMEaYc7gQaYHqKKUz51M+sltFpm3xThkTRY/d1hqG23IP/rMQLceqoEVOXLhnvYbeRtw3qq021X4vY0I4ZueEz5jZe7GXldkj3OFEG4RsakEa4DGa7nSmSIybZpcqX4MGyhsondU8U/a0o0OSZK5yMBtPisp8uhw+ScXKG3Kwrh8abtFDFK1UhTZfyGduRE0acRhbWfdGP5PIrCR5hTlzCmiCkanZpkMS4/u/yZFFjec9CFEKL27Cf+bWVC0EP1XttaXCDq2NrBY7uWF5ZVRDkAoAy+OjVmCW+sawDLkqaKnOZiHcQD4MHg3XRMuhu9O006nVhgQuTR3YD2a+xtgmpgfPyHtv/vamRsGCalGJ4fOjpPMk6YWXzWS+p2Jp8Y98kh/+lbc1UvemdBbAJkAHFVFw4QbPf5xMz9C8metwbPd/13pdgMkOeXdBWAGwIlirYz8PNj9l9Jkt7u2Lomj0508kSZyf3K18U32IK3mB10hJ6C55ofenCNlb7sV9Pt91q8UZQRXcxBUZo2/I7Aiqwh6Jide6Fz/ypB/RBsvwQUMbnG8eEfBugGOs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39830400003)(366004)(376002)(346002)(136003)(396003)(83380400001)(316002)(5660300002)(38100700002)(66946007)(66476007)(186003)(66556008)(8676002)(44832011)(6512007)(6916009)(6666004)(2906002)(4326008)(9686003)(26005)(33716001)(54906003)(478600001)(6486002)(7416002)(41300700001)(86362001)(8936002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YnCwgjDJRdMO8TW52qcxIbxKSZOBmdbmRe/sMFg1OMgrhemgbvemWVC1mAH1?=
 =?us-ascii?Q?G0dkOfYFY2PwuY9LQHW9wdio3ftGzoAYD0VDc1aAqJycE+wrOjaA2BO7123E?=
 =?us-ascii?Q?0STRNqk59oe2qlro07eFjqVPPgu3wTjcySLBufUy7gVG3LFr/b0oi13SP9iv?=
 =?us-ascii?Q?GlGkv95QNNCyc5mMeTJCmPA9JhqCiEeXhdgeM6AzA/TOEkM48ydTMVXhJyxF?=
 =?us-ascii?Q?jS2OPz1XGSp2mx9W14EggpbnTApP+GVT2BZUOmd6Mga7dHSA+UooseLpxhdY?=
 =?us-ascii?Q?acZVPMU5iwBBXr8YV8z5QGinuXUVL6kOdO7iyBG4wXUhcu0l/ZvirqmYu581?=
 =?us-ascii?Q?7JFejbhG6Jc+o3UhPgh81K1Ay9Khkzuo471VQkVf0fYiZFDHjX454ukpOM56?=
 =?us-ascii?Q?zv/ewa9+5dG8JerjZF042r5cNarKQOi/AsJGtuNq2ylIL3dpDipgEB7g+PW7?=
 =?us-ascii?Q?2dm6qyVmIgyjV8DhkRUCX9826ViyATTNwQyeTyir0UWU1J+eXKGKa7/yp7J0?=
 =?us-ascii?Q?kRKodL7jG3/IDTuQshoaK9OsrcKUdc0jC6k1i6gYwdEucoSv8o/yFveu6q0l?=
 =?us-ascii?Q?WVLVwMltWiezhJtC7vSrrpRGAP+Rh3LtqOFNjVW2hhpNPZvGrXA4P6TxwAbk?=
 =?us-ascii?Q?oK64iRLGfa8/NopQsjbXslcLAp9ngvLnqwAmNh/B1aJ16sSkPZLY3MeM657y?=
 =?us-ascii?Q?EaISMerCkfxL7WxqgekL6Hfzx0KV3ZkAtP/XDzNOdRMfAJ4KZU/mbWSS9nus?=
 =?us-ascii?Q?9jgCQSP+CtemtkvPmKy0OdsK9j2fZB5pd/54dqLWVJ8uEhc0MXjdTuengff9?=
 =?us-ascii?Q?Jrkf+n2ukL0DBFmrcxf9qgPC6LG8TNBVUROIRqvMiNm34KzIU010o6ugplDJ?=
 =?us-ascii?Q?J5mFFA71RpokUN2s2NC4d3vEr7+fiCM26NXMg8si90b8XaGULKahZIr9GNyX?=
 =?us-ascii?Q?8g8MdS6lpHVQe0eH7zCVMZMblYeWvN9BjSi3f4GzuOiuYyxX5BcxCrGeN9GJ?=
 =?us-ascii?Q?ZejALszsxVEMmqfDYKSCCnN9CdgkzmlmVAecdHiWRHIVkdv4/ussE9Icfnxi?=
 =?us-ascii?Q?dVxhXxLi2AyxAMPVn2gWCj88QLIRH+HM10FB/FJRLhgBPUhsHKjCtE6zMfrg?=
 =?us-ascii?Q?8J3DrQY0SDnwIL3WSFwdGeXkzKfidqLUalWUTExhBbJFSu9cqrZiRI/ZxiQ/?=
 =?us-ascii?Q?G+bvRIzhy5O+3j2gD/fttI6JfFOOFwkuDok4gR30VAtfETQf1ANRt3CQd46u?=
 =?us-ascii?Q?Wn6o5n8okymxK19bFBzjuw3CNdWT5QH6xzr/1VrMW3oMqxrcYi7F9mMNnN+H?=
 =?us-ascii?Q?GN3DgrwcuXezRMgGv6YG9Q1DB1EUagKOyCJgMS2+pNE0Of8jdcuahqtWBpQh?=
 =?us-ascii?Q?nFv3V7ndPHlRI3NBzwlcGwbOpPhBaABrEg3WxwezUVZGVLdBegDiJ0HaldYX?=
 =?us-ascii?Q?JADU8B1jSrccvlqrvivzb2AQqcf6PvD4D9X6C5axj+LyTQNBTL8q/T+mm4li?=
 =?us-ascii?Q?68juhcJaoNSGMvfndr0owEtLcnOtp/M+H+45ElQkqvh7Ep8bzPPejMXabqar?=
 =?us-ascii?Q?mfBZwsLpSgCAHQuAYwIieIsygZMXQJATy2u3ipWkNlStA7Cjzm3vrKON730X?=
 =?us-ascii?Q?oA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b46c72ac-4a6b-4c25-ad79-08da80632744
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 15:14:17.8557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2GZdvPMaj73ombEgbKhja1Le/J0/TA5lS0TbQPTp6t5+q0pLnerTBeCHGzmKR1pSLQ/42DVgVe9c2EDirpYbcNAQLQqXEkIvAjpOXqHCdC8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5298
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 01:05:32PM +0000, Vladimir Oltean wrote:
> On Wed, Aug 17, 2022 at 02:06:44PM +0300, Vladimir Oltean wrote:
> > I think in practice this means that ocelot_prepare_stats_regions() would
> > need to be modified to first sort the ocelot_stat_layout array by "reg"
> > value (to keep bulking efficient), and then, I think I'd have to keep to
> > introduce another array of u32 *ocelot->stat_indices (to keep specific
> > indexing possible). Then I'd have to go through one extra layer of
> > indirection; RX_OCTETS would be available at
> > 
> > ocelot->stats[port * OCELOT_NUM_STATS + ocelot->stat_indices[OCELOT_STAT_RX_OCTETS]].
> > 
> > (I can wrap this behind a helper, of course)
> > 
> > This is a bit complicated, but I'm not aware of something simpler that
> > would do what you want and what I want. What are your thoughts?
> 
> Or simpler, we can keep enum ocelot_stat sorted in ascending order of
> the associated SYS_COUNT_* register addresses. That should be very much
> possible, we just need to add a comment to watch out for that. Between
> switch revisions, the counter relative ordering won't differ. It's just
> that RX and TX counters have a larger space between each other.

That's what I thought was done... enum order == register order. But
that's a subtle, currently undocumented "feature" of my implementation
of the bulk reads. Also, it now relies on the fact that register order
is the same between hardware products - that's the new requirement that
I'm addressing.

I agree it would be nice to not require specific ordering, either in the
display order of `ethtool -S` or the definition order of enum
ocelot_stat. That's telling me that at some point someone (likely me?)
should probably write a sorting routine to guarantee optimized reads,
regardless of how they're defined or if there are common / unique
register sets.

The good thing about the current implementation is that the worst case
scenario is it will just fall back to the original behavior. That was
intentional.



Tangentially related: I'm having a heck of a time getting the QSGMII
connection to the VSC8514 working correctly. I plan to write a tool to
print out human-readable register names. Am I right to assume this is
the job of a userspace application, translating the output of
/sys/kernel/debug/regmap/ reads to their datasheet-friendly names, and
not something that belongs in some sort of sysfs interface? I took a
peek at mv88e6xxx_dump but it didn't seem to be what I was looking for.
