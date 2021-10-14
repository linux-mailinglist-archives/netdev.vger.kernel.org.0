Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6055A42DA5A
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 15:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhJNN3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 09:29:42 -0400
Received: from mail-eopbgr80050.outbound.protection.outlook.com ([40.107.8.50]:25109
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230205AbhJNN3l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 09:29:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dHfTuewaX7RuzSWZVSwx9PxZO+L6UjbzTPXzMzM4sQ7/9HFKpwcy6BGOW6A6JiaJg2O9egenZGlgHmYAvNt+MZ48NRDfqyR19TNRCWEzSvBTcLzwC3FDS52sEh09fu4g6SObydbdc2IUIwI5YBVJoyf6dU8KKiAMYvak5Sq7G4OxU/aHQEbi7NokKBcUtUkrqZSJ2PGHvQncX/7Oe41P/1vB7tYHqh7A0EfQtSGIF20vW+BcTEs0ILNy/sYbKZ75Gk50zdorMwzaIK9g3ZPyvCHIVHOcH1/O2/ThWutfvIqp1buN8Gl3pANnyTQRQ9IBGrDC0Onw6j4l6WcB2S8wVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SxX3/8Szm+/595jehOyQqDg/FCB0DErjPqqwijcQsXI=;
 b=ecHTJm4hxkkjRDGa+bTPI/ei5DDHaIYoyXqYGZEJlEWbmM25BMb4Vmij7ipvcdgnX2zedmhWtRdXrdiaqDnEmybikJ55XjchmtpxWjRGn/bbfTTztfnwO2dcOm4sTxCGvlu7TqLHGgP7rM0y8KIaN5xdnWx0bPAm2OVM0pzah/Bj2RJnqx43tF97rQuHEFeE5abT20GeeFpvsxMUWRtAzsqBcVxjy5SRy4CWwe2zlX1m1bLDIUaE6WtTYqNR/57Pe0htjlDF6JR9/3Kvpg6jjGmQQdtEGdGf6t4IvkvchiiBJNUMTeoXnIm498WhwJyLrdoh/eoj3TyvPHOGUYucDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SxX3/8Szm+/595jehOyQqDg/FCB0DErjPqqwijcQsXI=;
 b=XfOfAAsZPZn7aK/M2SET3lDW0Oa7/icfweNoD3g6VswzRCIs8q0qOsg+a9fsksVkVmiH+GbZxrLMi3JypXz4ywq+V+KNLxcwTtG8z3rHwc6u+OGcLIsEXiynXh7eDsabgcrufnmqkdh+J1PzYYaVdeT/fPLqp0/x9ghGzavPhUo=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB6018.eurprd04.prod.outlook.com (2603:10a6:208:138::18)
 by AM0PR04MB6020.eurprd04.prod.outlook.com (2603:10a6:208:13d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Thu, 14 Oct
 2021 13:27:34 +0000
Received: from AM0PR04MB6018.eurprd04.prod.outlook.com
 ([fe80::9556:9329:ce6f:7e3e]) by AM0PR04MB6018.eurprd04.prod.outlook.com
 ([fe80::9556:9329:ce6f:7e3e%6]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 13:27:34 +0000
Message-ID: <c361070cc08063f19bbc5756714d677d5c649ed2.camel@oss.nxp.com>
Subject: Re: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
From:   Sebastien Laveze <sebastien.laveze@oss.nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, yannick.vignon@oss.nxp.com,
        rui.sousa@oss.nxp.com
Date:   Thu, 14 Oct 2021 15:27:29 +0200
In-Reply-To: <20211013175405.GB24542@hoboy.vegasvil.org>
References: <20210928133100.GB28632@hoboy.vegasvil.org>
         <0941a4ea73c496ab68b24df929dcdef07637c2cd.camel@oss.nxp.com>
         <20210930143527.GA14158@hoboy.vegasvil.org>
         <fea51ae9423c07e674402047851dd712ff1733bb.camel@oss.nxp.com>
         <20211007201927.GA9326@hoboy.vegasvil.org>
         <768227b1f347cb1573efb1b5f6c642e2654666ba.camel@oss.nxp.com>
         <20211011125815.GC14317@hoboy.vegasvil.org>
         <ca7dd5d4143537cfb2028d96d1c266f326e43b08.camel@oss.nxp.com>
         <20211013131017.GA20400@hoboy.vegasvil.org>
         <646d27a57e72c88bcba7f4f1362d998bbb742315.camel@oss.nxp.com>
         <20211013175405.GB24542@hoboy.vegasvil.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P191CA0018.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::23) To AM0PR04MB6018.eurprd04.prod.outlook.com
 (2603:10a6:208:138::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from soplpuats06.ea.freescale.net (81.1.10.98) by AM8P191CA0018.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Thu, 14 Oct 2021 13:27:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f0803b9-9fec-42ec-0fb1-08d98f166180
X-MS-TrafficTypeDiagnostic: AM0PR04MB6020:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6020FECDC121065C9982AA2BCDB89@AM0PR04MB6020.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ILddaltp2Z7wX5aaai4sbE9y3tin4zyZzAtZucXBsDKd49vHXQbTxN4z25xmAKWloMzSaHD1I4DZPkdFnjZr8mIg3/sde/HWprhJo8sLXXPJtJFtwoKfuFWEjp/DszUvEiGs2jDkgYqnZgtwAQnov8LsS1CISSJqCXJ1L+oo+6VXNGXvKAKFge7g/zui23T9JQiflFYk7iQzDkQ5xgCIDn35+XjnWtU99RrhUooeV24EdTLF1jI7MB2C25aNIxjVGLEKEcUxlrBqCVHGsqmfqisqF1NHsReN04321FWERUWAZGYS0C8w+JTM2mDAIPR0xr0tkmwX83wLJOeP5dY9oJWhKRFFt7JyRqXI77MlDkXqjwhl8eaLac3skNbtfT6N1BUjRKr9pUmp9BexP4XydPrXjqIiaf/MBuGGMemC0QuoGeomLBVnlEh0uz5k+FFEg1THLxsveIOwTChXh5tA7Snjge4FHqFAv6PPq4soAC6mrT0Bv7fLiDp/pSWYjMbkKNjFph1dHSS+d6QVR6RFtkQuxO8YCsOxun3OZc2lQi8pvZSVvMlbV5M3iOU7/n1xiAE2QEYtXJtgvSQpB3nWbQKFG+xZYT3m3T7eKYQ31jixVINVQG64XzQzM/3oaErpYA6NjjGZn3MIy4fwBYRw4UcEe3JO1snBNz1/blPdun5sZ3rN/DY23DtAk/Erpa8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6018.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(26005)(6506007)(38100700002)(38350700002)(6486002)(6666004)(2906002)(44832011)(2616005)(956004)(6512007)(4001150100001)(8676002)(4326008)(66556008)(316002)(66946007)(52116002)(186003)(508600001)(86362001)(83380400001)(5660300002)(66476007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d283cGtmTWtRdWZuVkZ0ejh2TFVXL2xZZVdvcEJMTE94ekRlY05qQnVTS2tq?=
 =?utf-8?B?VXJBZlFOeUEvaHBES3NDQURtQWFQc1pNVkZoN05XdnhzZHRkYXFmTUtseXRh?=
 =?utf-8?B?N1JGVjhySXVmcTJQejFRdW9KQ3lyRTdEeUtWZCtBdUQ4ZU1TN2sxdmpzcURK?=
 =?utf-8?B?dHUrVkhiekFqR2I3WnNqZGl2NXJlKzBSUlpMZnZwN20rOGFwbGhtZGJMZ3pu?=
 =?utf-8?B?U0d0bTdvVkdUQ0RpM0FCVHhVUkdNRFNPeTlaZ0U3MTkvSm11ZVpQODlYNHFr?=
 =?utf-8?B?cnphT1BEZGN0NG5yZDArNXlLM05JYWhkd25oOUVQc1pEQUcvS1V2MXhRdEpt?=
 =?utf-8?B?SnZvZ0ZGV25qb2llSjh6UUJJQmg0cTBmdmtqd3ZJd3dwNlE1YjJaajlTWC9T?=
 =?utf-8?B?QXZPTE10NkhPVmJjdWVWZGpEakF4NWlMKzZuT005ank4UUhoUmZXOWpRTnZI?=
 =?utf-8?B?WGV6VTBPZElpTTFScFUybTQ1TSt2bVkrM09Mc1R2UU9OSDFkNnlSWnRBQldK?=
 =?utf-8?B?OGZOTzZrUHk0UC9ENGNMSkwwNVZiSWttajhQQko4bHFFVmdOVkRZTHRXekMy?=
 =?utf-8?B?VEVqUkhVMHJlekJGanlTT3AwTjFRbjRWNVp4akZoVGlodG5JTitOZlNPMURj?=
 =?utf-8?B?amZYMnNXckNFT29ZVmtOVTdZc2pwNGNWbWtCQk00WW56QWhXK1dhUzltSXA3?=
 =?utf-8?B?U1M4OWQ5ajQyNCtDSGF3ZHBmNlVIL213dnYwZTBYSkFteFR1cmFabFFjdDUz?=
 =?utf-8?B?bktXcjVGS09BMWVhOW1mZHJTUlBWVFZDbXBwSFovbmRBeTJ4d01TWlA0MkhL?=
 =?utf-8?B?VzJCbmZuSWw3RnRkbjUvUm1qTUxIMGhnalY2VGJZM2VMbC8yNThVVFhYVFlG?=
 =?utf-8?B?R3JKcUV2TVB1SWp5WU9aYXI2bjMvTmVydGNFL0hzejFyd0Ewa0NzV2xMR0JD?=
 =?utf-8?B?c3pjNFd0Ny9iNDl2SnlHb3ZMQ1UrL0FrdlIweG5ZcjJkQmxMbEtIQzdsOUhR?=
 =?utf-8?B?REphOHR3TnZzUXBYT2s3c2hwY3lxMUo1bnRHYk5pRkx6Nk1OZnRFN3JLNVBO?=
 =?utf-8?B?SmJ5NHE3dnlkSXF3VnpvRVQ4ZFY1T2VOMTAxS3R2ekJUa0xZWUZqTTlucEt0?=
 =?utf-8?B?MWxBSS9PYlM5cWVVK3MrUWNKL1dVU2RYRFBmSHRUdm9udGhYdWhTZEZ2ZnhF?=
 =?utf-8?B?WHdhVzRqUjgrMURzS1lRTUtJbDJ1SDlyVnE1VzhiOC9SbTk1a1BFYmhPK1BS?=
 =?utf-8?B?Yi8wSGVjZ3kwc3NwL0IwbVZVb3M3N2Jsam1Vd1JiRDFXTGVXdjZWZi94TFo2?=
 =?utf-8?B?M01RZ3J2dVhqSFdsKzB6dFhGNC8zazRKNGF3N3lZNXBxaHVMMlR4Mmg0cjRx?=
 =?utf-8?B?d0cwNjdPYW56Uk4wdkhJbUREbTBZY0V3RGxiK0taS2hvbDVNcWN4RklrWGxy?=
 =?utf-8?B?NlZ3UmVpdGVHNUFHbzN4RGxHbk9uY1dHcFhaaGlPcUUyZWppUm8xdjZoc1VB?=
 =?utf-8?B?ZllZWGp6L3RCcG1LNVJiaVlDZkJJVThrUWFKeWNQZUs2b09HUTVnQXZ4djJC?=
 =?utf-8?B?bU5kQUZaTUZjYUhHbTl4WXFMU0lCVHVxdnJ3SnJqcWNNVmR2enVhQm9uZmtn?=
 =?utf-8?B?Q1dSTjdER0E2RmlrSytsWmFuRkhzMm96VHlxdWNkcDhpajArUzV4NWdNVHBw?=
 =?utf-8?B?Ym92cElSbkIrWCttU1E4RTA0N2p6QnU3OTBJcURXa0dHK2dETzV4c0dTUkpK?=
 =?utf-8?Q?MeqKM2ckYbMSkwd0CBjR9rolCNeD+lEng8QCpKJ?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f0803b9-9fec-42ec-0fb1-08d98f166180
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6018.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 13:27:33.9559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nrXrgPM43crXe1M6yJPo9G5I759gOk8WMw0u2Z9EEGlEw5weHeyNASTQoSH7ihI8Do447ZTwJUxk8c4asYwRZXKx2Og1abwEs55CU+/BVLc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6020
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-10-13 at 10:54 -0700, Richard Cochran wrote:
> On Wed, Oct 13, 2021 at 03:28:12PM +0200, Sebastien Laveze wrote:
> > On Wed, 2021-10-13 at 06:10 -0700, Richard Cochran wrote:
> > > That means no control over the phase of the output signals.  Super.
> > 
> > You have. There's just a small conversion to go from and to the low-
> > level hardware counter. (Which also needs to be done for rx/tx
> > timestamps btw) 
> > When programming an output signal you use this offset to have the right
> > phase.
> 
> I have an i210 with 2 periodic output channels.  How am I supposed to
> generate signals from two different virtual PTP clocks?

Is it something currently supported to generate output signals from
virtual clocks ? (I would say no)

It seems to me that any periodic signal handled in hardware (scheduled
traffic for instance or periodic PPS) the hardware PHC frequency needs
to be adjusted.

For the offset, adjusting the PHC counter is not mandatory but requires
to re-configure any active hardware periodic logic. And here I'm not
saying it comes free. (especially if it would have to be supported by
all devices with PHC)

In this regard, we think that the capability to allow PHC adjustements
with virtual clocks may be on a per driver basis:
-driver exposes if it can make atomic offset adjustment or not
-if yes, allow PHC freq adjustments with a limited range. This range
can be known by userspace using PTP_CLOCK_GETCAPS. This limitation
doesn't have to be drastic but just here to prevent 10^6 ppm.

A limited adjustment remains an improvement vs no adjustment at all.

Thanks,
Sebastien

