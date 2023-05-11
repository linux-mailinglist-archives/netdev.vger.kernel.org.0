Return-Path: <netdev+bounces-1721-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78AFD6FEFB9
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:13:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FD6E280FF0
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E4FC1C76F;
	Thu, 11 May 2023 10:13:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C71E1C740
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:13:51 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2110.outbound.protection.outlook.com [40.107.237.110])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D9176BC
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:13:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=huVbDekVOqzOfT6PLkmhJoEfPEy1Xwr5PUr8WIYKeWhRwVZ7LUZaC1y260upgiQUhWq4yZQXHsVJm6vkPLNT6HWagQY8RTCwfwOrp5K98rwqW6dip1JRg8RWqIskdvRFUVvFO3L7ZTo6Wl2/QbYe+chNxvqQYHiuMBiSji2ml9VJsWEDOPn/dlQRfYfHKHgo5+b4CKlwwR5ZuAJ08s12vmtYsxrhxLpOdPR74766b3icCCBEDGdFOtdMOYwr49qsSaZNdwlzbJ3u5gqypdsn/S+UCRHYO+S9Fi9A0upSRwoZtUOaYXWa2N2/mL8bDSFXNj61QH87/0kNjTj5ehnkXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kwoC7WLEZz/SkyGnDb5Fp5BYDNz0fhRBYUlficA+xpg=;
 b=TzX0lgh0oo7j9fJxtDxYCnzfKsnyQCskncCAlkEu1IbbbwvVLuu/TEWVmVdvwgQJMH5P8f6PXjNoDsOcYGtPlAle30xGhnirHA/rZ+yPlE0zs/bn67fK/Z+LNGY9uw7+p3IVYyeLR2yPfv5elWavGYTw5D9qfd82KYA2JxEKIH3c9rJSHoN79tt7lLjXjEW6IZLJWRrZ3vv/xoy5NRASxsBVxsSxh1nTtm8GcFyOkmHiDJZr9hRnUstGpiAKBnCWj/s02je/0NoZGUq8FpLJtHkNATEJASJ0Ew1pxNPuERe5bMOGbxhLyrRa8uFCWHt7t1d8SIjTb7ysCLnszLL/1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwoC7WLEZz/SkyGnDb5Fp5BYDNz0fhRBYUlficA+xpg=;
 b=XB/KF1LOd++KhNJjpa3ulRgMS6Yn1Qp9uU1/ZNalvhtChZ6OhP2wsmiVH6wMYupU6BPrfTBctG3R/8705esWtZ6yNyYA/S+Ct06di5FxrSamzpIluWi79FciFvfTTRCwCpi3c2MOX8crO3KnC7mlJpkmLfShxU7XVZ4c9CXTu+o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3848.namprd13.prod.outlook.com (2603:10b6:610:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 10:13:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 10:13:48 +0000
Date: Thu, 11 May 2023 12:13:40 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 4/7] net: sfp: move sm_mutex into
 sfp_check_state()
Message-ID: <ZFy/1FmRZomVCvaZ@corigine.com>
References: <ZFt+i+E8aUmUx4zd@shell.armlinux.org.uk>
 <E1pwhuu-001XoO-1r@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pwhuu-001XoO-1r@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AS4P190CA0018.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3848:EE_
X-MS-Office365-Filtering-Correlation-Id: 62214542-7a19-4dfd-be39-08db52086902
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Rgzhni6aZB7YO349hTtYDmZ4GO3TfAhGolXhDECry8WPat3xP8k5/LDm74Ogz5w3WzxWkNChbUS5JtIgyULU2hqomukUeLnFCDO4eXHvTTFck2yyj7pLzhTqcbhZILurCeKHFAnP7lRFfrzlHqJiMuuWiKvoh7TSBaDFYNL3usUN1HWtFHMPVEI5BpWfxv9LMuT+c5dD11h7pRfn9v/T37dxfKEKcoNPmaaZVi/qPfdU+KCzRbzUdWXg3FCeJTWJ1NJccsQj1awPfNnRkQ7furuB+0V0IK5PiShdU6k5Tc75I8jXudraQ1P7FuybbCSHMq3OuQ4cxEBAMvR/5KEAlKckR2lUllBDnw2vDgQa3ikXC+YfHuh8qBIz21MD5YJB4QihF8QLgBaGg1gST6Emhl4FAbOHqeyhNrsumEJTvf6SB2aoDcYEODw63k3+BETyukl2HW2ydKtesjUwpgnmcwxX+pTvyBSZBYFE5O3sumFsGWZSXGR4Fu7KnP9BTdVWafM9H23tPSUQTdqSW8x0jyYpir9WhTiGL9alAqDi1cpdY4kymwTqA/r+Vs0KZ1fr
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(376002)(136003)(346002)(366004)(451199021)(83380400001)(8676002)(8936002)(54906003)(316002)(6666004)(66946007)(4744005)(4326008)(2616005)(6486002)(44832011)(5660300002)(66556008)(478600001)(66476007)(2906002)(86362001)(186003)(6512007)(6506007)(36756003)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cNEapAocMKV0QehPjaNHCyvvqhtGQfax6VXM1yNWbZYPKbrWp1EORuZ+3Z7r?=
 =?us-ascii?Q?rSagoUYOav3jkjZPtp+LPYL2gIzzfxjQxeJpELoV9PO4gtGm6sLXT8DargwH?=
 =?us-ascii?Q?apXNS1fzQFmhhtX1lYGXVTteooC9rMUIUxvqYiidPhjCYUzMB67IOf+YXl/k?=
 =?us-ascii?Q?pAqxADbQfZZuVNUA1iNjLRQ5CmSIKSJIjPV1ej0zaKcqBZ191cp7zz7pQd8Y?=
 =?us-ascii?Q?pdzzlV1Y6XvU+X5jWeRz6jcRL0h5rgjgJO4eH2CEtOweAxUY1tOAFyxZbqL+?=
 =?us-ascii?Q?JmU5SncllttgCeVSxkrI/1j8a/Y97Yj5cwqo7az4n3xFO0lNl8ix9qFUl62n?=
 =?us-ascii?Q?1P99jQ0vYe495BNDETquV6H2n5BEgCCr13fqVTTlMlpKMyRRm1H+aF7W2HTV?=
 =?us-ascii?Q?yspY6WGyS/qtM/8VufatQeTwMkKAOCTtCBwjCsE0m4J84TzD/f1XYwqMZhKW?=
 =?us-ascii?Q?ieDSK5UISFJm4GhBT1SmSF2EFoNfWaJ8vpDqzSzTJqycrkSSmmqGPAnrwJ6v?=
 =?us-ascii?Q?25WLGHVk83q/TTSMnCu8ye3EMw3HwsnGstsGyFB3mm4BB5X74DL1qYRjqfBS?=
 =?us-ascii?Q?egyGOMluYQaY9enGBzgHUjy4G2SPAY1OV20cWtZ0nz6Ah3CRgVPqB6LIvumb?=
 =?us-ascii?Q?ttNuS05Sbv11AdgW5nX4iWF79zT+7ASuu03aNfaLdcHIdCGHCkCOWcyteXAK?=
 =?us-ascii?Q?fwZS8BpxRfPxRecMfQz+XJZRWTde88PhSGVKZp1OEmDZqsxYizy4lGAVGmJt?=
 =?us-ascii?Q?RsKI0i/MpUaUBdtAn60q25xvXQf4UQ783jDsipze2mjwQaFZcDrxP1y3XVnd?=
 =?us-ascii?Q?OQKgHe+fFe/t4lC231Xgj1tcQfrvNV70BSk4rUNDF8mBEw3V4Sq5whmnIT3I?=
 =?us-ascii?Q?ilY6fac4WO6xJ2pmr8OKAvs+wT6ov7lreE2IXfwD+Sl12pL6kM+vXwjZiyfF?=
 =?us-ascii?Q?+5ttx7A+dM561Di0posO2b2zJbx0fuefvxBGjnkvanbu4TLgSsw2A4osPAeI?=
 =?us-ascii?Q?K7hUYJ85dY0CMfWSVGqurYIzYJwE/rECU7tcO0RWWNdrHgP9SzdBvMXcxeSa?=
 =?us-ascii?Q?vKMyqIcryMwhx8HNp0uHLuJGApra9YbEBu4XfABqhh2omKVDDZCFngtE1uRq?=
 =?us-ascii?Q?tnz7eEbM6E6fcBht/q7ZgIyJ+UKwPZX8idwDma3T5zlpb1Ul+lfJM46FzQK4?=
 =?us-ascii?Q?apo1OEgMB/Ebdl7OifG0yTrg97bg6oZ43eBzbV99YuWGGroLRb4uJgrYcPSp?=
 =?us-ascii?Q?5Cj8qXXXguZGlHhqybWuvGcXyQ2SmPJ/o9/U51PGNW2SlOYAUn2gR1qrPbpO?=
 =?us-ascii?Q?5f0OKEy9RbjSHxDeqU14ZK/cZ/FC35gTG4JRrAxfHF2XsqPiK+pdzZHt9JK5?=
 =?us-ascii?Q?WmozNlCemsAH+ucFVKXVWyXwmyGd6JhDPMChLb18Q5st9zV6w6aOQtPAfu1h?=
 =?us-ascii?Q?KpLFR4y0zoEJns1+f8GHEYiBOImkNvVPtKKYajxC8w87pF0vfXwetcjXgvS4?=
 =?us-ascii?Q?4Ks9NecQ8o92hs+0IU423XDdCsjW6N1D+PBfCRW2At1sC5vf2n/EToU4v3TL?=
 =?us-ascii?Q?fR3onQekIE1ryKo2AC++b2f5/++8Kz8rpdE6L/YTNC2CUh+EMbFbimc/mnCP?=
 =?us-ascii?Q?PIaqEZbEDlm0yO2BThafCCJov9+pcvFqqPFkBShrFfLGUNWeulbC3Z2w4eKc?=
 =?us-ascii?Q?PboSTA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62214542-7a19-4dfd-be39-08db52086902
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 10:13:47.9861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xCe/l4Mjm5suI8EvF4gg9TkTr38jrRMl431eRVLsnrxeH+kFSQCsUOGo+g0FSSCowqULEbXgu0Oj87QT3Bz6HE2wKaXpn/ilsjmD7K64I5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3848
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 12:23:32PM +0100, Russell King (Oracle) wrote:
> Provide an unlocked version of sfp_sm_event() which can be used by
> sfp_check_state() to avoid having to keep re-taking the lock if
> several signals have changed state.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


