Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F71A4824A8
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 16:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbhLaPxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 10:53:31 -0500
Received: from mail-mw2nam10on2100.outbound.protection.outlook.com ([40.107.94.100]:32832
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229453AbhLaPxb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Dec 2021 10:53:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Anr6e6bNZmMPGPmBS7nU8m7o5uajkKUjTcs/85fghkjPqap745b7SQ1eA0Yf7E4o+LcGRJQOpK2g/5IaTnEKgcvJeusZ+/y7yPfh279h+Qb1Cisv1TUSgW6KMCNMryU6NJvovQ+Vo5uoKjlk+6f+3bNTKrCnAHKEe43hw26KWFL7Ojomf0Gth7ti+jC/NJukNBI0u1RB0PM8u290tef0JeJ1+KXaPCf/BVXUjaE8SUMt0P1mp8Hux//jmCzaTxgcapcMcPzQCdpW2bjnxA0gCTsTeSVBV+VtZfgVT3/jiE6eprrw5nAWwfhqvHZnQSdGlGZlAxqKIdhxsDjMOFZq9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yko6Y+rIYxKDCzJ15bJ1u93oO5XCAid5a8LwPngWLKY=;
 b=YDKbIKYK/1wyiTU12aIe0/BfBB0cN4vl4BDze1HXlDExK3wePNj74SkjtzgDyN3efupISobaJi+ad71eIOd7MMW/ZZXAvR+vUNMeK2oGMK74CRALBZsPR9Kh6xnzhad6hFrIlEGiay8V5y5idsaa4/ZqiWlwMzBWu+tTCjgGcLDaRxf6UXE2sj5vlN+icsIKamJ7dkQDZIM00rdUJ8TV4M29c/Wbq0un4dJURe346uwwnhTjkTmfTtZfYbdLw2mlc1bEyLxq5giqa9BgcByKnsP1vIrULs27BOBU06gUruvWGebfHJlj02JLUYbQ9cmIdQ8d9G36Vh8VdedIXq+/Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yko6Y+rIYxKDCzJ15bJ1u93oO5XCAid5a8LwPngWLKY=;
 b=ldWRwtBrn6JoowkTrVDW23kkHawLaoGx+du0NIsLh5QKDrU5G8cg175VhSqG6yVCUqXi5wdZg6q+d2JofeZB7x2MR5FfZEOOxA/V88KNvfzKawTAHd0ABhL0MBqULJAh67xTU1voIeTymSD8cdDbsGVUeteprDtwrGusKXBETs8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB5702.namprd10.prod.outlook.com
 (2603:10b6:303:18c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Fri, 31 Dec
 2021 15:53:28 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4844.014; Fri, 31 Dec 2021
 15:53:28 +0000
Date:   Fri, 31 Dec 2021 07:53:25 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: packets trickling out of STP-blocked ports
Message-ID: <20211231155325.GB1657469@euler>
References: <20211230230740.GA1510894@euler>
 <Yc7bBLupVUQC9b3X@piout.net>
 <20211231150651.GA1657469@euler>
 <Yc8fGODCp2BmvszE@piout.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yc8fGODCp2BmvszE@piout.net>
X-ClientProxiedBy: MWHPR19CA0070.namprd19.prod.outlook.com
 (2603:10b6:300:94::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fef20f21-8b88-489e-477e-08d9cc75afac
X-MS-TrafficTypeDiagnostic: MW4PR10MB5702:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB570207451FF081E643FCBE14A4469@MW4PR10MB5702.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JSKsk0pBVKe0oZxJ57/mpoviWLcWbMymucwzSJb7juFhP6bqRgdi2LhcktHdAko91MyZc89yHhsK4x5BqEitrzMzbzRo5IKSnIByzzG9JXmnubxXrIIimQeZSycloBnHnFUuBLMl7OFIYxdhEtGoXj7df5B+pqrqVCj+iRjesQuqxPIpuLPo3GHVj1xSS9CrMTQ3itBD9EwZds9P/y3m1POkUaBHgj6VPwBwIWKxXKYMQYdOTlctywTUo3Wkk+JK14ecUy4o1Esus7p7cjcC0YBAzdIa8Q7XgerUKhx+MOYoeYICPzOgkL4WVVHBImQRVPx9Voj0Jo6Vb3GVFS0P/1RtQb4hn0zTQglJj9d/WMTsA+tfrO8Avs5ymoNEb7xGl9PK1I+Qh7+e+sLfCD8Z67Mi9nK8MMGt0Xj6vRFITDDvrqsDC5+bo+ya70zo59N1k/lLMqmTp2n9Bo1zJkLoDJnSTT0RhSy43VySty4jOoO2qVa6a+B0ZDKDvbEe+bqqZy8LsTlnIjSLuzaD+3GC588OI0LmMgADJKEWOn85xk2oJRreWyIksonpRMFUUm9Fmk7qs58sYVPCLuokKTQFBTyb2t5MAX2EWjs3kc5HQUEkeyjzEsohFBVpCjN8m/600FsXm/hMCOwnzRpxvCYUNQCAtLyojKr8+RXPlpdPd5rQDbTEF/laQPkoKKXoLv8NymlPZxCoLjOPa6cfcidMgNrRezSXGg9OMPmcpmDSqfv4D5UWX/OUrndYEbD9hQcEONtK/bUNYC2r8ziAOcFgU36uNwUdcRLAR+RoUCYV4Uk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(346002)(39830400003)(366004)(396003)(376002)(42606007)(136003)(66574015)(1076003)(66946007)(44832011)(40140700001)(33716001)(6512007)(8676002)(5660300002)(6916009)(52116002)(508600001)(38350700002)(33656002)(966005)(6666004)(316002)(86362001)(26005)(9686003)(8936002)(54906003)(4326008)(2906002)(66556008)(6506007)(66476007)(38100700002)(186003)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6qozRqI1Ubm44pvx4eaqjttFLYQaTi+45jgRR6hCoqh27isg/gwBOywzUq4x?=
 =?us-ascii?Q?X3FJmZvJXXTvCyY3CstpvpakvwT1rARBsNIv93FkUNVHPw39xQrShRGWucIX?=
 =?us-ascii?Q?V1l0elGt8wqzr+M87Ik6mSXB01gJfR2tmUNIE0S35p82f6fTvTejb3Xacjez?=
 =?us-ascii?Q?PES1DQvaoquJWbhqaR+TjDIF3wpf7E7t431giCAJJpeVnEn+GTrXSTW9vy96?=
 =?us-ascii?Q?Ia+3KpMUTVxVacgqiy3ehZlayLPEm2pH0RLlhv26ICY3IoRVTxMUsfshnhEL?=
 =?us-ascii?Q?42DySHLKpu24ie0NFXG942pn0wiqa+GPP1Y2a0Ws4oFmebJ/bNnEaoXaMe7u?=
 =?us-ascii?Q?rdMPZGp1zGU6tdxYrh62pk3RdipzCoubrUgC72yKPLlBELsBNTeHZoCX0ADK?=
 =?us-ascii?Q?K3oMqGhUcgtVdnlikW5DzhQrhFoXwUCdxHAzLC6oLvx4hYY4rIPDZAkHDcI+?=
 =?us-ascii?Q?gEla6mwBCiKXilV4Aw6zrkUNC8E3m7o+I6uQBCqWFv0ivrcvBS3ReREv4qBP?=
 =?us-ascii?Q?mdg6HUQKZEeeuIJ/FUnq89x+chYt3OC6riLawkL9HkFmT4rpF7JX9ZNDoJzs?=
 =?us-ascii?Q?10PN8ZtX0U55rfAfHk6BPzJSMrz2UjqsycgftQ9SN5P1etmEeh8CbpAOTICC?=
 =?us-ascii?Q?XI4pNGdRRGu02mHJNM2vHkOj5S8FFMj88fCu5yTVaS158VRADgZka/71Td+w?=
 =?us-ascii?Q?c9YI+jbTiR/9Z6K1irqcRA9XCL1lKfZPKNQoqJaPiM5Zfp6Y12Pg4ULFw31l?=
 =?us-ascii?Q?H5Yu6rtcUBQZ8VpDtclgbn2iWiJW0wXbYbW+Mh0A93zvqh2eii1Ql+1XUkvb?=
 =?us-ascii?Q?9DmbDQFS+3/luin+NlSRmDSV965CjPY7A3SLLop2INMWIPzqTyoPfqtIED8r?=
 =?us-ascii?Q?GMgq45HcxHkVtfS9MgTtKXjvcdOh3Ks6YHabAXaKbRAjz7Zd0J+emQm4/kfa?=
 =?us-ascii?Q?SADS/RdKRL031ODDTRjk+3ul8j10xWzNfRlJ1VdkZthQGRyuOvLEPr4PBMj2?=
 =?us-ascii?Q?TFgRZAHnqrT5G+57QAktaRAAKEy92G08Yl/bTdv954sMFDmOLv4gNpVi2jMz?=
 =?us-ascii?Q?n2bsCH5pSIrRUdkFtILKW1tpc20mywOdc6IOEpL81pkkZfxZ/LvxRRH/tNBB?=
 =?us-ascii?Q?G5Th6OqLNzIUy/vwjlljpJX+nqNtTqq88nwYy4xvs509dQr57kEDs8KO3aTU?=
 =?us-ascii?Q?Vfiy279Tt1JBV/ive/of6qtsNZ/H7fAiLX2vtWpgiUB1Ox/DY8PX7r+aZufm?=
 =?us-ascii?Q?SN8fjRKFJLpwn17xvdUYof9G+1Fyh1qJUXDQXe7SB3iuKsoDxSjBWAlXGXGt?=
 =?us-ascii?Q?H/OumRWaBDL28CB3DsSRQMdC6Fjrqj7CYsyTA49L/e3hU5YgLQZOVP2bSx+Y?=
 =?us-ascii?Q?vsmnOHbheDqbt+WZ8gRQJ0qYMr+keG2pimNSQlFSoGjVyCqgaW6mGzB0jaW0?=
 =?us-ascii?Q?7iP/khMKpqIV8UhH43omIcBl1bCVnGjwOSnYYaMexRCkQnCBnv+XHM9n0ySJ?=
 =?us-ascii?Q?2M13FZfZXPbPFR3lp/Y+XUbVAL3ZCorGtEOmh0x99UrPdIcFVvxqedAXNj2L?=
 =?us-ascii?Q?LOn3XqkNTiYzg+tpd9e0gvDmYg+kD3TtgzOuQiCfwWQUY0pbKwbKxXxjtHxA?=
 =?us-ascii?Q?OHwEyud8zAvsNMLnocEl1zOqMseAIGkgIzBpqh5WPw85+7fOs4C1H/njNHy0?=
 =?us-ascii?Q?MytmkQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fef20f21-8b88-489e-477e-08d9cc75afac
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2021 15:53:28.2053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sagKC8ylDS58NEPO19jHk1hOIfAJ1Bj7Z67pj9Q/I0Oa0vs37P11hu/bhnYy5sqHh2l0xg3A6yzlHBORm2cpAIxEvRoWl8DaDz4GcvI3oNE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5702
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 31, 2021 at 04:17:44PM +0100, Alexandre Belloni wrote:
> On 31/12/2021 07:06:51-0800, Colin Foster wrote:
> > Hi Alexandre
> > 
> > On Fri, Dec 31, 2021 at 11:27:16AM +0100, Alexandre Belloni wrote:
> > > Hi,
> > > 
> > > On 30/12/2021 15:07:40-0800, Colin Foster wrote:
> > > > Hi all,
> > > > 
> > > > An idea of how frequently this happens - my system has been currently up
> > > > for 3700 seconds. Eight "own address as source address" events have
> > > > happened at 66, 96, 156, 279, 509, 996, 1897, and 3699 seconds. 
> > > > 
> > > 
> > > This is something I solved back in 2017. I can exactly remember how, you
> 
> Sorry, I meant "I can't exactly" ;)
> 
> > > can try:
> > > 
> > > sysctl -w net.ipv6.conf.swp3.autoconf=0
> > 
> > That sounds very promising! Sorry you had to fix my system config, but
> > glad that this all makes perfect sense. 
> > 
> 
> Let me know if this works ;) The bottom line being that you should
> probably disable ipv6 autoconf on individual interfaces and then enable
> it on the bridge.

Just gave it a shot. No luck.

But poking around sysctl there's
net.ipv6.conf.swp3.router_solicitation{s,_delay,_interval,_max_interval}

As Andrew hints at, there might be some unintended consequences. It
seems that writing -1 to net.ipv6.conf.swp3.router_solicitation_delay
"fixed it." I don't know how that'll affect an IPv6 network in
production.

> 
> 
> -- 
> Alexandre Belloni, co-owner and COO, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com
