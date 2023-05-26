Return-Path: <netdev+bounces-5592-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BE5A712340
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:19:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EFB1281748
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:19:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D3C10954;
	Fri, 26 May 2023 09:19:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F6710791
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:19:19 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2094.outbound.protection.outlook.com [40.107.220.94])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EED1E47
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 02:19:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jcFdGbrIUhRQxY7h2Ta6MhPbtuCacYZn7C4Elz2p/6JthvQtLLlACDGlFHqi0YYs9P5ZP+fiO6len6qJ2Oa0q4j9rPyN/e79qYsQGPau5fQLona+kx2gDG+topvUsBggc0H6QdbyLDSb0Qqi2GPYX1xctCQwqCVWnO095/yrQylnaTn9fIPSyGCriTBlnbcrzf/o1s6wHVZ+vV0zdGupw/P7N/e+2cWhNZS9Mu78o7ZdLM/mAutdrg/SLfBD0OPSSQoKuvKXIsv/ci+chDTKaX9t7+o56soVMc34tCxKvUiaSsYSCThebdnKq2cUqS34ZDO1Pg1/bAu98NVnXOtWjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OpSr24Ffop7RDOa63+p/vU8m+EzgYfsjsJtuqwA8j3c=;
 b=TRV0oQ3PX9+/4HxDN2gWAS9HbDf/LN88P8WJNmNspLq1B/0gM4P3fuoARW1yFeww+sq1sgKt6jt+AaSGwsgXHJCmAcc1BAxuOMwKSq0qBW9gBnY9cozkhRlGSqa4l3RGc0EY7runMiop+h6NKyKWWwNl6wfVpaDXatYtjVJ63VIuZ1oPmYR+XbkX86HT9h/r7KEzj2X12Kuwuho4CRq/FLOSXpH5F6ormlxUzt/pvQ96v+27YQmdw2xm56i7wl0GrscSp4MLV0WCqJBqfo3CksNi0cydU5wkTkpQ0GHFnlGzHLo7mSsqLL2qqy+DTI23MK2SfQjtR1n0cQHeLeoyvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpSr24Ffop7RDOa63+p/vU8m+EzgYfsjsJtuqwA8j3c=;
 b=mPyTqUtnCukylbqDZPlnMfIjp+aP6SyC7GDN+G9plCW26t7V/kUtJHLqSkwhKloO1/ObTDVsUzk4dtBS/aNMHbTyVuAL+0tKxpThM7COAXiH8s1b17vHtJA377xebWI4C34PuQB/dM0U6P8pOP26jKC9QAhfkJTVWzc3u8UqlK4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4715.namprd13.prod.outlook.com (2603:10b6:610:de::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 09:19:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 09:19:02 +0000
Date: Fri, 26 May 2023 11:18:55 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: move link forcing to
 mac_prepare/mac_finish
Message-ID: <ZHB5fxXzg2nf/Th3@corigine.com>
References: <ZG86ocZm4YmsWIJN@shell.armlinux.org.uk>
 <E1q28Ms-007tpv-2T@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q28Ms-007tpv-2T@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM8P189CA0017.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4715:EE_
X-MS-Office365-Filtering-Correlation-Id: a3fd2157-97e3-4ff1-46f0-08db5dca3ec9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mGAe/tPy6V9mguME+baB0ig1XYe9pIDyqqrk3/XucaaMgTk7Ky26VssYYYmmM24LEOPQFD8VbmnC4DjH5tSEjPg6TPI1yaJ7wQWLnPjpvTqUHMtlXrkF7cc8YxztRLfVoFBHQReztiKD6n6bAGLSKRiiRSKt0JvXYvMC+apHOMINZFnbCr9SCca2d8RL1M5Q5MNfSsX55fxFWCHN5lzGPkVEssgi50AAnc4D5JOKaNGaqZIvHp2FC9t71dc++PrYM2g+VRobUWC6GaRxAmyoUMDP8rHv0M+aZ0MBN9MTF2GVjvhLOiK1ylA9sx5lYGSdPsKOMASQ2BBXIa01jP2QG1LgUgmB4RMMboId56Xm082SLkZkGspWG6/amSzmo9P80XoaC1SOsCQGpb0NTtN6Utw/seN5BOmWzH+V7A4iMMdTahWVMB8tARzp++HQSa125kjg5gekzgROv8eM49XYvrOsjeRgl4+zfdRrgNKlcggzUvA3zPLx1hrRffy4IBHLJFkPpZWurRyK+jDjhp0TTDjvoIBhCPEDm1Bw53JzItxeLiu2dPzvbQRyn8hfrBA3L9fhFf0bbg1bt5smI5SY15MRpkQ1elTWNjh02Q0DAZU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(39840400004)(396003)(376002)(136003)(451199021)(66946007)(66556008)(66476007)(6486002)(478600001)(316002)(54906003)(4326008)(86362001)(36756003)(6506007)(186003)(2616005)(6512007)(83380400001)(41300700001)(8936002)(7416002)(8676002)(44832011)(4744005)(2906002)(6666004)(5660300002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a2vq4zqs9pF/A1ade5NZ7Wh0tu8r1hwBjx1JM+iQMtpeVkGUPIX0cO0BCJ2T?=
 =?us-ascii?Q?aZazcsTW8hvWZ5b2qGiibRY8g3MG8YJvSsXhINbhy/Mu47mSgnLkI+kntXPB?=
 =?us-ascii?Q?ZjgWOeZIcy35B8bkMcA3kpFvFOqWegpNvb+87wzM7LcZ16V/YAWDurtvRITN?=
 =?us-ascii?Q?cIUdCtTgqvSwiWHNxVhB6dvDY/O1WWRXsKivVCNp44ABuiaENETrHN3qrELW?=
 =?us-ascii?Q?abiGo+4PLE7K0ivVPuF/50kV+xOKnwh2XWlIQ3WipDCMMFxqQRCh+ptI3atP?=
 =?us-ascii?Q?Ue4mGa+NIEacSIHGcObgibIfm8ynHilxFQNGLd5BxIB9/jVLjnUHegRpcMcq?=
 =?us-ascii?Q?yYkeaT4BugcwdCRzbxDmBG6D9pPmqLBUDYm/hXggElvDrAiUOwxVGmovF5cN?=
 =?us-ascii?Q?SsQ1IkdcrQdYh1CeJyhPT+72ehgvO85BXFOixbPds8ARdRReA0L658u6sfhe?=
 =?us-ascii?Q?SqrKApZBgq0RI/EJGo5dP1+ZGQECjbegMaoZ2nAjWWaksYfoxqIv6Jx79Z8k?=
 =?us-ascii?Q?gtV6sJfJ+BMZbGf4np0TFwNIOMN3EA72qCieVAB+lKqXMsqjPRj7raRldmP7?=
 =?us-ascii?Q?EPMq2RBslgz9jBBaiWe4ObXHs82E1KsMvcR8wXKrzGttHL+FN/p4kzvwP1ts?=
 =?us-ascii?Q?r8UwGvDN71LLGyJWTg6m0xgGqhEjzjvz/ESFp01Rn33+hrkULd763Lg+1HZ5?=
 =?us-ascii?Q?tRyr5Rc17SZHcxY1UU7rOVg7zNq5ph6Y7OiwKA8h7DMhWxB6uToZnRfihx7Z?=
 =?us-ascii?Q?2W3YcqGDRmE7LaKzaHC42/yVdQbw8CDfwPuift+Jvkea06+A1kFPxAC4gjuQ?=
 =?us-ascii?Q?/xRRDbKkrQ8+ily+7iih+1IPf81uJ4/KkTDo0HhzaeUbEidjmwdf7enK7HN+?=
 =?us-ascii?Q?DS+w9XxHRRsncpRIozU/+Bblt4aKVbHglvFdwJPE5jUmqOgsXNJxKXlTqhvf?=
 =?us-ascii?Q?J+rk4CWncqkoWBE09BQ1gWePSDCcu+YK+HkpyajYklKFip/GcSQuyzLMJLMK?=
 =?us-ascii?Q?C0nO2PTH9AaHCQX+oM33MP4WFB0CVn/LKggjCFneVmbgKCNXU5Vq5qhF56pF?=
 =?us-ascii?Q?BFsIjEvDB8Gbtd17vj6Yqs99BWrrNYeEdVJGgmscptjqL4aYn5gJbCWQq0xB?=
 =?us-ascii?Q?AOYYmx9IvKAPPtdpzLrdYo6fejIf+UIunZ2WBbfRtsa65Xn8oo0X8/+HhDlY?=
 =?us-ascii?Q?/ViJgffBw28ZU1g31h5WRamzRUubssa8Lh3Bj4fjlq8H3WbYkjqTfvnRB/8b?=
 =?us-ascii?Q?upQ85dU4boofhJ7g+rsEgt1lzJ1BxxcDrIPEf+BqWq6rAXJfSPD3IaXmPub5?=
 =?us-ascii?Q?GI5ypDKGliq0QFTo6A+Y6XeSS4OiXkXgyrBRwTRJYhXHGjWnz162tvFiLVDt?=
 =?us-ascii?Q?ZDEPBlpFb+2wJK+PCjfShYgrwpoigvdl3Fja78hbGekn2HES2bUsmdlANu9f?=
 =?us-ascii?Q?7TwwEfywE9snUGkhayuOIK+adIlvjrxuZhYUO6D1ObbR3Kx+RNjKf4iUjMgu?=
 =?us-ascii?Q?QyC/MbA1Q3+yz7XwT0e5oZMVRWshsqpuilLTvfINu3EW3YX9GrARIHxe51t+?=
 =?us-ascii?Q?vcsqQwdIA6y67Sbd+FDsXhOxYQaKNZduE6i9DPrvQCkBx9QfU4NCn3ntGyfB?=
 =?us-ascii?Q?siCn+UXNjKxsae3hd+j+TqCGbtb9vJBPzezebblYr3hxJYPbyRUnRlh8VGoT?=
 =?us-ascii?Q?R90Oyw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3fd2157-97e3-4ff1-46f0-08db5dca3ec9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 09:19:02.2323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1e0a1cdqw1Jg+afJl4JPlnBiX6LmWCjYzIfyYZnPuXUzRRXa4IM/dqxUUmJWyShe2Lj/7BBl/QE9n+AQWN+qkfm8X4P3rbAWkFNZGJ4JIYs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4715
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 11:38:50AM +0100, Russell King (Oracle) wrote:
> Move the link forcing out of mac_config() and into the mac_prepare()
> and mac_finish() methods. This results in no change to the order in
> which these operations are performed, but does mean when we convert
> mv88e6xxx to phylink_pcs support, we will continue to preserve this
> ordering.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


