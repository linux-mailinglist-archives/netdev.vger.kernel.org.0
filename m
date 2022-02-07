Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D314AB3E8
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 07:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbiBGFrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 00:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiBGDHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 22:07:25 -0500
X-Greylist: delayed 303 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 19:07:22 PST
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02BEC061A73
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 19:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1644203240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V7sQuz28xEf48awlILiasbMh0Piygn0oOTDsBreuWUE=;
        b=IpQ9CSgvjRdnILiELZ8/DOx/hz9mMQOuvmgnZK6Y0CKo+5SmTnoft9FySkR4Xxmh7GFhpo
        8XaclmYDdPlxWbUbrP3zTC1w32syCqa/ZGnUchdECRtEVJKMpeT9zED4K8G2OSYTN9+FGH
        VGZ6rvBNfjhteoPumQdbfOuY/ZId2z4=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2113.outbound.protection.outlook.com [104.47.17.113]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-28-ewFRjV0SM0eM82tSZy_nAA-1; Mon, 07 Feb 2022 04:01:10 +0100
X-MC-Unique: ewFRjV0SM0eM82tSZy_nAA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BpE6BsSOtceL7PL5jDU17RjsDKd9MK68uBvu7AxzdLSDW/mbNnIBAvVepXFnKJ9Lnwesv8zCobeKeqTJpEMobOl1UUDWkdSiPZr1fNRT+5XCwGHBndhQejflTtMlQCkb0bgPdyjXHXFj6+YZnjgMv71LY7KgezdEcR6cGD27dW3bjI4huKJtkwmFrs6HEn4htAT9ElGLw2of+lg/mc8psa0+9cWDI3T2RzeOHD10DfjDjwP2NZ2wvGo8ssuXwKPjgTgEdt9PpAzUvfliURQeE7eF2ClmwQW9Wqr9nXNMSRbumPVEZaffP/B0KUBcqIIvEry4cJtB0gJOdO5k0wsgCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V7sQuz28xEf48awlILiasbMh0Piygn0oOTDsBreuWUE=;
 b=KqjRes6AfULxxoj0PcWAmo0gFguHP3SxiUgxzDW03bOS2qimUuR6uccHys8Conkf76omlqbuxu2N3p3ogpcJJ6fqX3vuRWwCnO8z/072dsCGmIU/qK3M8if+nqc2gO86n4S8XcNUeRQ+c92rWjVWCOv/RA97XXOrHKhSvnNtOCoWBvUFpMQz8yoEAL9mI9WVZgmhBP6nVEov8Puvl0jCugw8hYJB0Q6ho2xD2zSfdM5myy1l2TyTK7Ei/ZMKZwEFwVV4eQWrqkn3HwtakoKM+Jl4BZaoyLImG+vogjXDOpeRZZMYaV5eGNzbaOj3jf4KnhDN4k3H5A99n6itd/F1AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com (2603:10a6:7:83::14)
 by AM8PR04MB7955.eurprd04.prod.outlook.com (2603:10a6:20b:249::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Mon, 7 Feb
 2022 03:01:08 +0000
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::60de:f804:3830:f7c5]) by HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::60de:f804:3830:f7c5%4]) with mapi id 15.20.4951.018; Mon, 7 Feb 2022
 03:01:08 +0000
Date:   Mon, 7 Feb 2022 11:01:34 +0800
From:   Geliang Tang <geliang.tang@suse.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH iproute2-next] mptcp: add the fullmesh flag setting
 support
Message-ID: <20220207030134.GA5614@dhcp-10-157-36-190>
References: <49c0f49f6aabf0f55a16034b79d30fbceb1bc997.1643945076.git.geliang.tang@suse.com>
 <20220204101734.1a560400@hermes.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204101734.1a560400@hermes.local>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: HKAPR04CA0001.apcprd04.prod.outlook.com
 (2603:1096:203:d0::11) To HE1PR0402MB3497.eurprd04.prod.outlook.com
 (2603:10a6:7:83::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c698d3af-11c6-43dd-75cc-08d9e9e61668
X-MS-TrafficTypeDiagnostic: AM8PR04MB7955:EE_
X-Microsoft-Antispam-PRVS: <AM8PR04MB795599E51F836147F0AAF46FF82C9@AM8PR04MB7955.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6I4RmwnHfjbaE7qRTeB6NPEb3SOQmeee75BYg2Eb8geM99cRxzWhCppEQV1NdoSwzXNQhkubTvS2MOqkpJcw+zB3ANqEAk06UHP6OWvtTfjD3rtj78u35JDhSTp6p0qvGGT2W0tcpbl496cRudCwlISmf3GV6AQGPitaakbFVlC/FGtgdkNOvf3s2hTQFrDRlwIU8tZziAGFWhWeDOiHaePv620jVQht2e6scgsQqHcbaYP0IbStPJUvLugfVX0RHCvnbomWuREJCUmGMK7tdIxEPvOaQwmPQrZdq2+iK5zCxEsAY1JKGzVMeDBEGlJ2fYbTbF3gKxjPi02qPboreT7VcicmcMIcgnpTYGFpcL9FDxwds4aR6EAsRpcBOQ48OMOBImDss1faXIYDUGxxraX2E+tU3edCxaP1LaZJjB/lbjdngZCJaQmALj3yejzY9FWfYH7sFYQNMpFF5DzvXRBKDa+Sx5P2VA9JA+LkoKE7l1HF3jx7YS7smpVK+surBKP6povMfPxIZjqJLyU0oYlNSJCqQV9b/cBgG/gqEIfmtJAaBURnSpDAUfZU7woaTohz56ZGlPtAdxdM706mDviyTmEZNanThel24lnLaESku04RJwNHJxWPovOpTi4PaFqyhMxapMHwUamVXR2V5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB3497.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(5660300002)(6512007)(9686003)(44832011)(33716001)(6506007)(38100700002)(55236004)(86362001)(6666004)(54906003)(2906002)(6916009)(186003)(316002)(66946007)(66476007)(66556008)(8936002)(4326008)(83380400001)(26005)(6486002)(1076003)(8676002)(33656002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5vziaiYVUBJAiGisU6Z7fpb9Ct1lQZkYtoiW0VtJ/8LxK5X+Ed/EzwvNY75o?=
 =?us-ascii?Q?7C3NTZ6yOodFEzac7cnWmJ7TA6VGrZZWj2q8J9hfU27ZEYoC6gal2jNk/2bb?=
 =?us-ascii?Q?4SXjsfWnRCQukzl5PlA7t5LlBPbKb7sOQpl2qg1yAOZOPHocIedR9oa3FlqJ?=
 =?us-ascii?Q?MXNhXtzOhyujoPkqgNGnQ4k3RX7yPtzwisLmu+3pT3m/uWv6CB2Em1Hf4FI5?=
 =?us-ascii?Q?Hb7vdqI8sN+bHWOi017LC/jxZuEQDdPqXXl9aWcBLDBrAvHWAisCdunMoaYQ?=
 =?us-ascii?Q?e/qnIzRtwd3TMCgTYQomPgg6o29+xhAgjRn0WYBHG+CylgyzO/GG9hyPrgzg?=
 =?us-ascii?Q?U3nDvYi2zSR5EeGBgkAyARSwJ+c0uPUu8KbQjaE52E0nW1gQszf3eSsSG3Cd?=
 =?us-ascii?Q?qcDCVL81TReN2QGM8bJd1dilgCdZdvF2sLqgtVq4qJmKKHjrMu8PiYMFmQg4?=
 =?us-ascii?Q?jUV+t2KuKOFqJmxo+dyjK4Seuny6zuEa8Wb2x5Qhmm6j0U8VgrHkisguv23T?=
 =?us-ascii?Q?oiDMjKJurLHHpINB2811XurdyRgS92bdW/wVzRf55K8BlfaNAoN9cYnuM583?=
 =?us-ascii?Q?Is90u4Gkkak1Wv2ci1u4dlcB7OLpWyRPWDmPCMYjnLEeOWnCECU9D8IiFDHJ?=
 =?us-ascii?Q?WHaq0kSduspHr2rDB9U62+RFxAa+NxOT96UZT6dEkvhwzX9Qu3BxUHKvmuDT?=
 =?us-ascii?Q?5UNGoiLIcg3liXk7z/psd8fcoz2YnCREKexKNyQJA6CA4j1cRk2weKMl4kQV?=
 =?us-ascii?Q?prVmmQXs2QP/4Fel3/v2sXergP5/kyIxTxUZyaBrL0OZnneXbYH9L+wq8WVp?=
 =?us-ascii?Q?u98ZkBRj8oOxrzqkvWxaJ0reXa2v+HAIx66wbwRO70Z9jFnZ1M1/oOl6VXLu?=
 =?us-ascii?Q?BhfmSfzH1o2M3jIlr4rYCGE71KebYi6DeyxHPA+43VMBZP3utnqdpoE9sAnr?=
 =?us-ascii?Q?XYvTNQX8N4hoNIbjQ1gbuxcRhspkPoX/JcjJv0AeINXIsORwUaITvMmx2T1N?=
 =?us-ascii?Q?F2aANe+WaZBV4zPVQmq13t2bG2raxpvqYcGA12EKUSpjsWKMv+yb82jgliiQ?=
 =?us-ascii?Q?wqCCrERM/WF0rPi1kbDrSD1gyNciJVpkXL+Wt1ZBNcvHj6KHUZD1nG515Zjd?=
 =?us-ascii?Q?c/fRIY0VE9sQA97l7qRtAD3ePTH9ulHPuYLKUwXfnlSsdl1OieakjhnGkPUW?=
 =?us-ascii?Q?4VeZbPWiFwgE8DWMLR2shgw4Y0wdTBY479/4lkA48hKJeFS00gaO+N4Yw9Bv?=
 =?us-ascii?Q?j0dfsAnUMUQdBFVg5Rq1vgySo1GJY5GtjFuvzPLFTq0uPEua96Z0g2kJKt4O?=
 =?us-ascii?Q?ucqh/3KZrKy/V/kcGHg1IedXuouDacDxlMi2qqKJABDtdw5zt6NBSXgQ9ZzL?=
 =?us-ascii?Q?iSdJG1XRhg86VBEm5RC32mubwsvfUnUz20eI/CBjp9wApR7o5vlC/nlbt3Zu?=
 =?us-ascii?Q?JrN5Et08nq/oqQ8myHIMJOTbxFLkN4RPspAufhprDY7ycw+ETKzhpf+6eKxi?=
 =?us-ascii?Q?jzogTZ2OtM7F/kRPx/WCDMWGllMYsKJJqDfx325ac5oxQiYEZF4y+8TZG1E3?=
 =?us-ascii?Q?tbEDUwOKUJHaERtyPaXadToZo0BVvPUHucutKPy28dKLqT3gt2vBHMiBVAWF?=
 =?us-ascii?Q?m2z9HT5rgCMCO2d9h3ExcRY=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c698d3af-11c6-43dd-75cc-08d9e9e61668
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB3497.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 03:01:08.1861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xEMRM9bXD+6/XLJQeS6UNipQsfAdv706p9VVPMliF0yakvLsm2GequOuqhkSR+gKTp7ovm2pwDeWTDoXuDN5RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7955
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 04, 2022 at 10:17:34AM -0800, Stephen Hemminger wrote:
> On Fri,  4 Feb 2022 11:29:03 +0800
> Geliang Tang <geliang.tang@suse.com> wrote:
> 
> > This patch added the fullmesh flag setting support, use it like this:
> > 
> >  ip mptcp endpoint change id 1 fullmesh
> >  ip mptcp endpoint change id 1 nofullmesh
> >  ip mptcp endpoint change id 1 backup fullmesh
> >  ip mptcp endpoint change id 1 nobackup nofullmesh
> > 
> > Add the fullmesh flag check for the adding address, the fullmesh flag
> > can't be used with the signal flag in that case.
> > 
> > Update the port keyword check for the setting flags, allow to use the
> > port keyword with the non-signal flags. Don't allow to use the port
> > keyword with the id number.
> > 
> > Update the usage of 'ip mptcp endpoint change', it can be used in two
> > forms, using the address directly or the id number of the address:
> > 
> >  ip mptcp endpoint change id 1 fullmesh
> >  ip mptcp endpoint change 10.0.2.1 fullmesh
> >  ip mptcp endpoint change 10.0.2.1 port 10100 fullmesh
> > 
> > Acked-by: Paolo Abeni <pabeni@redhat.com>
> > Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> 
> I don't see  any parts in here to show the flag settings?
> 

Hi Stephen,

Thanks for your review.

We use the 'ip mptcp endpoint change flags' command to set the flags of the
given address. It's a little strange because we use 'set flags' in the
kernel space (like MPTCP_PM_CMD_SET_FLAGS, mptcp_nl_cmd_set_flags), but
'change flags' in the user space.

Before applying this patch, we can only set the backup flag:

> sudo ip mptcp endpoint add 10.0.2.1 subflow
> sudo ip mptcp endpoint show
10.0.2.1 id 1 subflow
> sudo ip mptcp endpoint change id 1 backup
> sudo ip mptcp endpoint show
10.0.2.1 id 1 subflow backup 
> sudo ip mptcp endpoint change id 1 nobackup
> sudo ip mptcp endpoint show
10.0.2.1 id 1 subflow

The commit 73c762c1f07d ("mptcp: set fullmesh flag in pm_netlink") is
merged to net-next recently. It added the fullmesh flag setting in the
kernel space.

We need to let the fullmesh flag not be blocked in the user space. So this
patch added this code:

 +                       /* allow changing the 'backup' and 'fullmesh' flags only */
                         if (cmd == MPTCP_PM_CMD_SET_FLAGS &&
 -                           (flags & ~MPTCP_PM_ADDR_FLAG_BACKUP))
 +                           (flags & ~(MPTCP_PM_ADDR_FLAG_BACKUP |
 +                                      MPTCP_PM_ADDR_FLAG_FULLMESH)))
                                 invarg("invalid flags\n", *argv);

Now we can set the fullmesh flag like this:

> sudo ip mptcp endpoint flush
> sudo ip mptcp endpoint add 10.0.2.1 subflow
> sudo ip mptcp endpoint show
10.0.2.1 id 1 subflow 
> sudo ip mptcp endpoint change id 1 fullmesh
> sudo ip mptcp endpoint show
10.0.2.1 id 1 subflow fullmesh 
> sudo ip mptcp endpoint change id 1 nofullmesh
> sudo ip mptcp endpoint show
10.0.2.1 id 1 subflow 

This patch also added the related flags checks and updated the usage.

Thanks,

Geliang
SUSE

