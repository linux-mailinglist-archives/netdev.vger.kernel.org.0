Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4DEB468A20
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 09:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbhLEIcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 03:32:04 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.8]:33274 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229543AbhLEIcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 03:32:04 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05lp2110.outbound.protection.outlook.com [104.47.17.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8BB1B9C0068;
        Sun,  5 Dec 2021 08:28:35 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Emtp+PibWNbvPMB3MrxBmUeeMfXoHDhyQ6rgoa6aFHtk6CPc12a04LMEjI3McgCZXCZwseqIzCpxPIrAoojHTNaPODjkKqE15ibQczk26j6aLoIdwqtV7XjGNF/CPCqDlHSDRsaT7eDyl7I4E7G0pa2sPbd6MVlZdiEaqIiVml9QlobEiet2mRJjJWW9jsByyliLJqimzkm8ilT4+T6gZemDP8SW833V+jseC3ylDIzldTCbrtCnwTmdZcCQhEi/6054WbxmlZUUR95oWxxTAeS1grz9YcPcS7pBZKDg0B0vdtxIkm6aEUDnGOzOdGoL24ksINS2VAC7/IjOCoO2iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XH1zNa15ZiYNzQ9i5WWCtjR99ftSEKmUElyq5/JVtQk=;
 b=a5ZyrmuOMmwVc1ZD7W7P4RgEoxeUcAguEttaEij/xZ+LYh7GCxBfPj+7SdKPhJCdakFESngYhthQTGmypPjzpGsVzzs8jRMMKRMhyMgOM3yVW8Sb2tbmsjB659hx3cW+7eGctoJR5Vy4GmCTMPTuwSY1W77AHWzYJo5s48mS0ae8UKrJbNDme9ezZDFZyMIRloiu3ZBRY9So2T17kbEGGGUqLGte7F/8hJyDhzqjg1qvWnRgBqWwJtqoHiblxwVFvYkAesyWgVSowXMvADm5DR72UV02Z0YoAz5Uku1Qhe1viRfvz3DHLh7gADO0cNkNS710sNOawCuGi4VHZlc/jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XH1zNa15ZiYNzQ9i5WWCtjR99ftSEKmUElyq5/JVtQk=;
 b=qPYEZc6cYFA8P5fUVVvIu9q4NB0ljS0+To+6djFN495f+CJ3DlidlLygp3ft+02W6yRv8ZD2bOzNLuX+/1RLKnn20SE87sPZYwQORpXvdvZXY3fI72I1I/icD0rRsModqqaooz62K03U+mPtPNsdkPK77SnppAQCDanlUQT7UL8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR08MB4046.eurprd08.prod.outlook.com (2603:10a6:803:e4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sun, 5 Dec
 2021 08:28:33 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037%6]) with mapi id 15.20.4755.021; Sun, 5 Dec 2021
 08:28:33 +0000
Date:   Sun, 5 Dec 2021 10:28:27 +0200
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next v4] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20211205082825.dqfty7unqnertwjg@kgollan-pc>
References: <20211202174502.28903-1-lschlesinger@drivenets.com>
 <9b8c306a-eea0-3d77-c4a3-3406e5954eaa@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b8c306a-eea0-3d77-c4a3-3406e5954eaa@nvidia.com>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: LO2P265CA0214.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::34) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
Received: from kgollan-pc (199.203.244.232) by LO2P265CA0214.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:9e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Sun, 5 Dec 2021 08:28:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a8ab522-9e86-4c88-7dc5-08d9b7c93958
X-MS-TrafficTypeDiagnostic: VI1PR08MB4046:
X-Microsoft-Antispam-PRVS: <VI1PR08MB404697F9203A8C460A28CFF6CC6C9@VI1PR08MB4046.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:483;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: meqpFcXnMcN3HgOmW3lqzMtawU/lm0mAwCvz2pdKEq9gZZB9RFhMWkaXd+SjqVOmZhweGB9pk1pKx2VdoPnv1CWCJ26kaSxvbaqO3YD4hKnJU3SCGsASyTDnO40GUJY66s4xXvnc6vEPtp2nqnFGnnk9nTY5SpYQv80tCJZdbuBfYpD0MV/sVZOSZ4ebJUK/qz/fmeAK+a9Xol1KynRDEIdfnXEiWK0NUJG1GjIh/xmq8SnLn8ZirqK8zdoRp0/Gp2N0aLqPidGgewaomMxJ8VtI2Mt/KXZUKAuyTk3buRz247MekrsC7rFqP158Sjw/46tRFSxkZJvShJU381LMI+DyHv1JGEO+ic0Idlv9NDWvp1QEUCfv10684WISjUVW5EYrFFuBYvCkg68YeJGXu34P+OdSUJnQvQJYTa7C5V8UhjrMkoJewf7Z/c9IQ/CNEPCj1MYsXI1m0V/TbYLnHUPsptgJeBRFmIUeJEx1aIhp2+YHasm4LzTCaL9ygUVgaKxaY2mIY2+5B9vuyfzPKELIJ1zz/CqX1yH9ZLth1SSrQUu0qWxxe7UHlrjlWO0zEAsBsI1SrlFB2JL+d4He7Dz5meCOtXYWKbpJoAAb8XFoW/xbBzTYvCt4dgKhJe2h6wRQpTro4v1heJme9cDT26Yw9jO3cUvGLwxRMht1b20QNYalxBmpU6IDeK/e1eyUgjt5XRQwY6mnlwmo7V02Ot8En14ZW4qobwQA6pEOPJI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(8676002)(8936002)(86362001)(4326008)(9686003)(33716001)(508600001)(5660300002)(2906002)(53546011)(26005)(55016003)(52116002)(186003)(66574015)(6496006)(956004)(38100700002)(66946007)(66476007)(38350700002)(66556008)(1076003)(316002)(6916009)(6666004)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rtenrw08ktZRffkalxXsGjfDKq0+kietc6Iwf4Z98PsmqWG6LtucKV5ozPSY?=
 =?us-ascii?Q?Gj7FVCxYu5FCN7YpffzbikmE2KyU8OWCzwEw56ya16TrU39TG+BLp3T+zjgA?=
 =?us-ascii?Q?6WeZIEcTPsShzXVfTLJp7EvV1PDptJtKdfB0YiOBQPrOH6m8R2WG7CZMrz1k?=
 =?us-ascii?Q?x9skMa6+sz8/mr+X8hsYWr9Rqdq8dx6qR5ynBsk0Ht2ZyUSgJoAWJi5USv2u?=
 =?us-ascii?Q?98JVobER6Gj8HPBSktalZ2AwV4RTnCzqHpLxmU/DMzkuSDAtL5FOseTTLYvV?=
 =?us-ascii?Q?eATfaR1T6bMM1daLqG0Vv1kAbQfRbHMHmKrnWtZBiQvI2U3zok//NQCF/I50?=
 =?us-ascii?Q?VCrIRGPND80KkH2KWUMpyql60RUX97MOaKFV54R9qh7jeZXoGuTOmD7KtzKn?=
 =?us-ascii?Q?S6gxYAQe4abjAtLmh3f71Z/edjKKKGlThEgnf17EPE4hccepJidylku10V7v?=
 =?us-ascii?Q?HK7Ib9oedgQN2XjcjAG5U7iS3nnvki6HzQ5Nd32o1tdQTo0D8gHnow3CcRKZ?=
 =?us-ascii?Q?jsPloGJcB0rp8xPvECNOB5X3mr0YeFFGFMqAKw9/BuwbSALDfNyQnEd6fa8v?=
 =?us-ascii?Q?8obGa9SjQS6cvdQykQRzg0gEuvhL41+KJ/M/HgrR8NwSrf+XDfNdT9PnLraP?=
 =?us-ascii?Q?2NIfUXzVi87cFC6bovg8c7fKmKzvB6refxWW6Y8kqYxHN9EG+cRH0MuW1ani?=
 =?us-ascii?Q?W0uFCLBxiLLgsQifj+1V7brxGRqbe2/Br9LuzEBb4CE1AGx7cE4THMmaPRp7?=
 =?us-ascii?Q?/3/GDql47jZAVwZ4Y9I5WwOIB5b0IVFhSoIiBvYLi9Sb0m3BWOjAwlj4Ve0h?=
 =?us-ascii?Q?MKWKITjn9dRtr6DkV4Oe87phKQcX1By+yZ/x9DkgMazGliWU/mf/pVJ0wrc6?=
 =?us-ascii?Q?/2O9OasoxqUUVCIvCwjM8gno7VHIok6mPZcmRH2cudWzrn93QKFT1asF3Xty?=
 =?us-ascii?Q?9VfGqWTRKngqCsDi0jpQFtNUnpW82nPoi4A/RMmYqe5t+dXt3bSpJvn4G2Ru?=
 =?us-ascii?Q?lroT11wx8BFsMXb3G0rAdvxot87euYomjr33GJqt8poQ5h+TXINHwN8aLU90?=
 =?us-ascii?Q?4dBQn1SV/g9fyqZz9NVrJHdnofe6zNKyviSHlnlegFoiXfOzOMneYN9RbTBL?=
 =?us-ascii?Q?V3zZoDKReKd7wpAl+7hFcVzqO08WWZXpALcZVqE8Qb9d5JP0c/oUTWRO7tiT?=
 =?us-ascii?Q?cklOfq3n1R/l83cmlPMUQhYDc6jbfag1la9cts+xZWuZRrkPWo5l3O8i0YCU?=
 =?us-ascii?Q?4gYTpz8yKAR1ohXHAQXBEX2CHdJLs/74/NfrQkjNdpC92s2kr9XXCZMEHZsM?=
 =?us-ascii?Q?zPLfV+zsJb/RnP9rFXCMmtyUTxmARhf6eW+kaKXS95JPT3KqFT/Lv4wmBv0O?=
 =?us-ascii?Q?ZTxqiEAgypQso01d02lPj9bCPXiDBEhHOUZsriAJMgy3GAz2jSJwitmZ3Cfu?=
 =?us-ascii?Q?dEOHHCam1P/X4x5nNTbCp+JXOB6Io2w/oh07rPGsQk9oEwl27apE8vPD8/Me?=
 =?us-ascii?Q?f0ihXLRYjbJDaONxhsa5xzwjf7tUYDNonSJNnSuLjFOyRcoWYTmYz5FeR2nn?=
 =?us-ascii?Q?OoWP9+0tcSDr2Wziui3hPMLoZHncrBgpAyYJX+mYrzFivvQEwRx/pi692w60?=
 =?us-ascii?Q?N020je2V8GlKWskpeWJ6vt21Wp/gFLOWuKfFjolrtbZxDWK2s/3Tab+dbTKu?=
 =?us-ascii?Q?/TIcFQMusE5r413uYwj4IH0I10Q=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a8ab522-9e86-4c88-7dc5-08d9b7c93958
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2021 08:28:32.9735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: shjiHdr68uqhdDGrLWSMfyYngzSxoDmino2sGhq7gICG45EBbb6gUzwaNNnb6XvD6q//psjx9i4O6Dh0E8qEOMbD4/i1r/d+C/3ASwBTNxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4046
X-MDID: 1638692916-mZ0A2ghryNAN
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 04, 2021 at 12:15:19PM +0200, Nikolay Aleksandrov wrote:
> CAUTION: External E-Mail - Use caution with links and attachments
>
>
> On 02/12/2021 19:45, Lahav Schlesinger wrote:
> > Under large scale, some routers are required to support tens of thousands
> > of devices at once, both physical and virtual (e.g. loopbacks, tunnels,
> > vrfs, etc).
> > At times such routers are required to delete massive amounts of devices
> > at once, such as when a factory reset is performed on the router (causing
> > a deletion of all devices), or when a configuration is restored after an
> > upgrade, or as a request from an operator.
> >
> > Currently there are 2 means of deleting devices using Netlink:
> > 1. Deleting a single device (either by ifindex using ifinfomsg::ifi_index,
> > or by name using IFLA_IFNAME)
> > 2. Delete all device that belong to a group (using IFLA_GROUP)
> >
> > Deletion of devices one-by-one has poor performance on large scale of
> > devices compared to "group deletion":
> > After all device are handled, netdev_run_todo() is called which
> > calls rcu_barrier() to finish any outstanding RCU callbacks that were
> > registered during the deletion of the device, then wait until the
> > refcount of all the devices is 0, then perform final cleanups.
> >
> > However, calling rcu_barrier() is a very costly operation, each call
> > taking in the order of 10s of milliseconds.
> >
> > When deleting a large number of device one-by-one, rcu_barrier()
> > will be called for each device being deleted.
> > As an example, following benchmark deletes 10K loopback devices,
> > all of which are UP and with only IPv6 LLA being configured:
> >
> > 1. Deleting one-by-one using 1 thread : 243 seconds
> > 2. Deleting one-by-one using 10 thread: 70 seconds
> > 3. Deleting one-by-one using 50 thread: 54 seconds
> > 4. Deleting all using "group deletion": 30 seconds
> >
> > Note that even though the deletion logic takes place under the rtnl
> > lock, since the call to rcu_barrier() is outside the lock we gain
> > some improvements.
> >
> > But, while "group deletion" is the fastest, it is not suited for
> > deleting large number of arbitrary devices which are unknown a head of
> > time. Furthermore, moving large number of devices to a group is also a
> > costly operation.
> >
> > This patch adds support for passing an arbitrary list of ifindex of
> > devices to delete with a new IFLA_IFINDEX attribute. A single message
> > may contain multiple instances of this attribute).
> > This gives a more fine-grained control over which devices to delete,
> > while still resulting in rcu_barrier() being called only once.
> > Indeed, the timings of using this new API to delete 10K devices is
> > the same as using the existing "group" deletion.
> >
> > Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> > ---
> > v3 -> v4
> >  - Change single IFLA_INDEX_LIST into multiple IFLA_IFINDEX
> >  - Fail if passing both IFLA_GROUP and at least one IFLA_IFNEX
> >
> > v2 -> v3
> >  - Rename 'ifindex_list' to 'ifindices', and pass it as int*
> >  - Clamp 'ops' variable in second loop.
> >
> > v1 -> v2
> >  - Unset 'len' of IFLA_IFINDEX_LIST in policy.
> >  - Use __dev_get_by_index() instead of n^2 loop.
> >  - Return -ENODEV if any ifindex is not present.
> >  - Saved devices in an array.
> >  - Fix formatting.
> >
> >  include/uapi/linux/if_link.h |  1 +
> >  net/core/rtnetlink.c         | 68 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 69 insertions(+)
> >
>
> I like the idea, but what happens if the same device is present twice or more times?
> I mean are you sure it is safe to call dellink method of all device types multiple
> times with the same device?
>
> Cheers,
>  Nik
>

Thanks for catching this. I initially went over a few dellink()
functions and they all seemed to be re-entrant, but evidently I missed
some..
