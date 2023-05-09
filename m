Return-Path: <netdev+bounces-1082-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A1D86FC1DD
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:43:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F9BF1C20AFB
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 08:43:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F17520F4;
	Tue,  9 May 2023 08:43:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F005C17C2
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 08:43:29 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2136.outbound.protection.outlook.com [40.107.243.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BAB83C5
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 01:43:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQMadoIiK3IqWypz7Z5fmD/1vFtHPFKDIkpLZiOZj2o8lQIxeYbfctvKnvNVyg60zKf0EngtoQnA8X9SxMX6sWMeYCgmDWi5rUJ4gN2jri54kaiVEZgtdhBWS3rNCKZ81psmmpx1i3uaH400oxoB0tu3FLfQVc3v0LspkVVKgeQk0GysQQvdtat1ER09Cz5yv5tSee0Q9fqfYIadz7efyYuBDJrXM3UC27AeT47r6qTqjUYCiiUr/D/jEDB+x0a8yXh9l26CX69h3bk/fMUnXmsWCTsB/u78bfXCz/ATvRXRkwclnkmsn26ZAX2c/OuDyEKcopj/yKgpASKWyWHnEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tGtrkiTrx38jlRftgWaIfdF9lrqOozk3DtWr1HSe3o8=;
 b=GEdkN79RUdnb+KjXuHb26eGEX5RABDtnqfQjwQvdkDOtC3o33XwVfiiPuNd0oT5kQxWwgAJdRB84jmb770Zn+HpB3xwI3pHJni5b2VEaPPZcqPvftjk0B4ru596nH1iZgQuodS/mEHcivhqpuitbxIVYh/pOkEUoxabw+ce8aiRIs9Ui19IfZ9di1uU+0I4EdgRRAPFw0g3exhLOiEHf7CPlh0DnUQgz9sSYFHAYHnfMRSGIfAVPrsA+vSnRo6z3zAcFFazYBinX+am+02WehUVWBtHccEFSsLrwFs81HJVgqx9WIuvjfKiYj/j/8vfqwYDmyBP5fXVecwXKK4WY8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tGtrkiTrx38jlRftgWaIfdF9lrqOozk3DtWr1HSe3o8=;
 b=NVsjjrZ7W+MNRAGBReGaO2+4PrmaKhhIxQy2VA0fGztdKw6phdO2cEipiXQL4hhicdrODike/bAHfGZ4koHmwBrilGkPWthgT+7Gjj4SkvbeRRIhQl48TXkEK8d23Jk8rIEoo/nQsbcrPmvN7GwFpIkalX+3ChBf3Nyw+ms3uG4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4634.namprd13.prod.outlook.com (2603:10b6:610:de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 08:43:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 08:43:25 +0000
Date: Tue, 9 May 2023 10:43:18 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Zhang, Cathy" <cathy.zhang@intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	"edumazet@google.com" <edumazet@google.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	"Srinivas, Suresh" <suresh.srinivas@intel.com>,
	"Chen, Tim C" <tim.c.chen@intel.com>,
	"You, Lizhen" <lizhen.you@intel.com>,
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Message-ID: <ZFoHpoFDkoT77afk@corigine.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
 <20230508020801.10702-2-cathy.zhang@intel.com>
 <20230508190605.11346b2f@kernel.org>
 <CH3PR11MB7345C6C523BDA425215538D8FC769@CH3PR11MB7345.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH3PR11MB7345C6C523BDA425215538D8FC769@CH3PR11MB7345.namprd11.prod.outlook.com>
X-ClientProxiedBy: AM9P250CA0017.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4634:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f594e00-0c32-42c7-f1c2-08db50697401
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	X0mNL+VfQmF27+2qLGL9h6Umi345EYyRPJmfcC+Sk9oBTr0L4cpo5Jq8gcWJKnCG2MStHPLZzkpPlrL1vuMOe3peGMrVjQsn0dOUgks88AwjfLthKMUrDi6NdkFxdh04cB46Uxf9l4cj7X3x1Cs63ycxSEMssnc40Obm+8Fyzc6P4MwcA/2TiTKBiypPUY0HT0Dp4ceAm+kHKA94/466l7xZ/DdTFwiMgOLlLMwBLRfjhyWxnUR3ZIM1pSYsohD7/0X3ba3IP0Sx3OspvyqKbbQxhSD7LOec+fYgGlL/roau+8idUPtXEfdopsXjjYZ5y8w+YZU2tbimfvKr6GSkTKyP8+evu0H0dkmVDMgUnO6lh1nKNNRNPJCUto64oFQMIhD6FiK5Loosv+FoRpVpbrggqBhP3tSYWiNuSM6jPct/Qjd5MO9VflFbf/uJYJe2OSYRZiwYpbJawsKK73Pz2qQ52IFWK8p5AGZoCbeUnis1AXP/66i2ra2eL8vJZRYBZxnD53iRFIUTdW6hC03IdUMRI01lPxZhk+pf/MqpOCU2p/VwMS/Do0X0enH4BMqD
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39840400004)(136003)(376002)(346002)(451199021)(6486002)(53546011)(6506007)(6512007)(83380400001)(36756003)(2616005)(38100700002)(86362001)(186003)(478600001)(44832011)(54906003)(7416002)(8676002)(8936002)(41300700001)(316002)(2906002)(6916009)(66476007)(5660300002)(66946007)(66556008)(4326008)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6NxB22gu41l0X8Zeu8wNl53XjeretfYK5X6h1oN/G8pGQvUiD1BJr7ehzvEq?=
 =?us-ascii?Q?uENnEAkMIdRw6By4z6OY72ST/NEqkO6/0DmrfDvgRRwxcHhpVx2FAa1sCeDq?=
 =?us-ascii?Q?LMu0Sn03D8bgx7ouhprjF1Il8FLz4X5DbSH2RIOs2TfMtMQKyLNuCb0oRd3o?=
 =?us-ascii?Q?KvV6NR4wuB9aNosvbgAaIPK5oBWEnkyY1/6S5XvV4Sh7M85EhhF872Yz35YN?=
 =?us-ascii?Q?8PBIcW5orAQwZV1Py9ARxDotbm3YEzZykaw4Xzb6uKvkTxvaUZj53uEJszOs?=
 =?us-ascii?Q?kSw9LcL1mitFRylCeHnPnM/2MbjX5kjDvHtCKW0L8555uSpqf8uG+49Us2Kn?=
 =?us-ascii?Q?UPpKsmu3DNowkDBSdjjsipmCslaiZValm0T3WrmY3/eg4YvX1YlPJkTtZHX3?=
 =?us-ascii?Q?PF2rxyWXHC++88+/2zSDqR0KfRiuxge8SP/shkXIeOHtcZYvfMLelEtP3ZxU?=
 =?us-ascii?Q?O2f9T1J7rRVAXHIisITcXruWtnzgAXu/hH3al/q9oYBvyrSt9eOPSwZ6Wo3Z?=
 =?us-ascii?Q?6HUbpRdtcgEsCRjM6Gid/N7LyCtht+qMphahkYDb5dAVM6/WA1+YLv1QTRow?=
 =?us-ascii?Q?l2iWVLc8+cEA7oahezGblAnojnriIwYWnixidhNbr+6cOQzqokndKTaaDl2c?=
 =?us-ascii?Q?lv5l5AlI1DfVa1vbXZZ1bGfIIH3pquF3eGCORbbvOvEZGeg2NMuGbEx4A7UG?=
 =?us-ascii?Q?c5ht04mlQwif4x2DmfmJaLbGwMsHAMJNMqIzu4yD3MEz3lttyZ0UZM0CwqvO?=
 =?us-ascii?Q?G98+kcm7zZfb0wFN4KjVuxB//b9c8gxZViL0z8y3msMl8q6M98Iv5jfD9j7I?=
 =?us-ascii?Q?Nb8J3+/ljSDBZ5Wy4qHQlj4FSk4vDiUq5G9qbiZsrDW+jdvPuFp4M/8vvfZT?=
 =?us-ascii?Q?PHLyTvng8SPOkpiOdKmvryXAisabadrxC1E6iAEeJ7Nzn54sj/bES3WBf4OG?=
 =?us-ascii?Q?XI1IaYMfiY5W0sMzk6Uf68nB5nPQPrPrj1vk/cDY9wLdcfs5kkInw1onmjjy?=
 =?us-ascii?Q?6LeBx7GofLSMFDUfPx/iUsSW1tDqScxkBwtxoFewc/zIV1TPdUJBLhG/lLuo?=
 =?us-ascii?Q?Gv66RjcJThkfCKFidlspzsGlmILWPmlGVznoWDxSWtaYpjpgVENWfxLCRGhv?=
 =?us-ascii?Q?6F3QyBD/pP4n2GBVUQfpBM2odCMT1hh8KklHzNG2xuK/PdshMTfCTnVR+8HN?=
 =?us-ascii?Q?hBRrvzso7aUl74nrQ8MNsQmezy3tdms7VEV6Ag6ykKzEJhKkTKumDy8F5vxM?=
 =?us-ascii?Q?DSglfip4Zg8jG7N1u5ceNcLDKm/dvxqYC11VZ+/psInk8KDB97+VZ7UBVmSM?=
 =?us-ascii?Q?nlgS8q+beCtakwc7sP5ZLzjS4kdujI6npJMydQl3KzT+uMK7yl1KfrxfCArk?=
 =?us-ascii?Q?upmNh0sSX9DDxEzuCvRxfuY9FhV+YKflJXERhGofFBOyJPCo6BPdmFMCMsNk?=
 =?us-ascii?Q?OvzPxhpTRvoWmz8Hax8oW1RROZcVJCC5q8vX5swU++gSxjOJje/AwybFPwH3?=
 =?us-ascii?Q?7lgTOiIYBOw5LTQ6RyjuwwKXGCb8ebWKSbCxvK9OOsc41Al6b8+yjV2UQGn1?=
 =?us-ascii?Q?kIBqZYAWRWkwq/CQ1dB3ofT3tOZCjcA8vK0J73Jy36PE5yaez5Io1ERhXg/S?=
 =?us-ascii?Q?tpC+leU6y++AG5FF83IlhYk7NHMStN5PE77EByfOKvOPEYQuiAN8lAcCZ74/?=
 =?us-ascii?Q?TaK6lg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f594e00-0c32-42c7-f1c2-08db50697401
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 08:43:25.2352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KXzWUpnTtpjE3Lx/bJa+2zEX7CV9F1NfKAtb+EhUfjPaENFcANipPHh85DezeADoCJt+yxBK6KdnKS8Ev+rKO1yantUEgk2DmU2EredYHeI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4634
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 06:57:44AM +0000, Zhang, Cathy wrote:
> 
> 
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Tuesday, May 9, 2023 10:06 AM
> > To: Zhang, Cathy <cathy.zhang@intel.com>
> > Cc: edumazet@google.com; davem@davemloft.net; pabeni@redhat.com;
> > Brandeburg, Jesse <jesse.brandeburg@intel.com>; Srinivas, Suresh
> > <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>; You,
> > Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> > netdev@vger.kernel.org
> > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
> > size
> > 
> > On Sun,  7 May 2023 19:08:00 -0700 Cathy Zhang wrote:
> > > Fixes: 4890b686f408 ("net: keep sk->sk_forward_alloc as small as
> > > possible")
> > >
> > 
> > Ah, and for your future patches - no empty lines between trailers / tags,
> > please.
> 
> Sorry, I do not quite get your point here. Do you mean there should be no blanks between 'Fixes' line and 'Signed-off-by' line?

I'm not Jakub.
But, yes, I'm pretty sure that is what he means here.

> > 
> > > Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
> > > Signed-off-by: Lizhen You <lizhen.you@intel.com>
> > > Tested-by: Long Tao <tao.long@intel.com>
> > > Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > > Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> > > Reviewed-by: Suresh Srinivas <suresh.srinivas@intel.com>
> 

