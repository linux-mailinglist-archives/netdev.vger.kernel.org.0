Return-Path: <netdev+bounces-1722-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B325D6FEFBC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:14:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D46531C20F29
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD6D11C754;
	Thu, 11 May 2023 10:14:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7711C75F
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:14:12 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2096.outbound.protection.outlook.com [40.107.102.96])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CF9A1
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:14:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hzodpzIlxhupKwD6Nq3lf7XgH07z41cvo+jbwqD8xsFopz6ZKvQxrcQc1pZGT3JRAHMppkXQ0dQtTCsTGl42BdfUD4tBpAP1hKMNvO+KQNzhIr0IxSkxL3eDf7+h36rxqMXG9A0tv5FYA7nFkb/y7fPS7uP7swfp/jqPX6DaxiXBgVPrRBie0oo7dBhDrqcGCuYzpmAgTBGfFrkXXfj4i+dm757lTALsmRqanBUUrwgmuMe/vmXrfX27iYWRYdV4hNBMeGuL8FvBmcj2juf868PS6jpcTn1qDubBfNb3debOhibSVsyhuhteg+a3oQ9M+QiTjyWwjVjf7zaWL59V3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KWc17TpWP5yLeC47SkLaN9rdrOXCs7ZOTS4n7BAoG/U=;
 b=SxxEpEy8trmeo3gWUL91ug5AF/UMiJFoRpOLCv7bneNpG3ofR9jbG3t7PwrhlUSk5GuT1sK6FKBeYQnqjliX5Rma5W/2rEvkLjVDRgXFE4L9IsqJlqmxvp5QDuung4SBdBxvSBC398XA/zx086EHheS3tVP4xyqugGTePJgMceFfmC4YyZn5COZ7pQ/MYdnAiGK1wsLgpdqtxKb4lVB9YrLV7+OF8IV4HN7IENYMzk/ivMoMfBPrrfYw72WHlSyQsstFwxrM6CfIrsr4nox0ySI5u+JghwWZA6xXShYOg4ls5A2VOZSEMVqMFbGfV0LqYW2qD+A1YYUSKLytQ0Hhjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWc17TpWP5yLeC47SkLaN9rdrOXCs7ZOTS4n7BAoG/U=;
 b=hNkDVRTFss7tTklGTmMFF7Pi4uIaxramxtQ/I3DKWUKM+YEmWts6nuEhl7B8FsE7l7bMmcYf/fTOsIHl8trEdb96GgDh7HfRKwFquvvTP+7X0umCEb0fPX/y+G9VoLu3Nf9qLhIcdrv2dqevSJ0kgaW2/uutbLbrIAcm9n70fyQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3848.namprd13.prod.outlook.com (2603:10b6:610:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 10:14:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 10:14:09 +0000
Date: Thu, 11 May 2023 12:14:02 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 5/7] net: sfp: change st_mutex locking
Message-ID: <ZFy/6g4YVgwi4gHT@corigine.com>
References: <ZFt+i+E8aUmUx4zd@shell.armlinux.org.uk>
 <E1pwhuz-001XoU-6e@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pwhuz-001XoU-6e@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM4PR0101CA0077.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::45) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3848:EE_
X-MS-Office365-Filtering-Correlation-Id: d9641a7f-4d58-40e0-8faa-08db520875b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	E2vsNNq52rmZBBR6woLV2uALvDHdERUnsCzPqL0mgbf5JHwJQydXMZEi1pdat2AdwDBVJc0xSPOoSEWH5JR33um0awGtr+QLvK06L4voACVGHqc2uioz90EqLrBFeKEU0Kcd4/q+9Cbm/CKGhjYMAagbSf8aawuUDuuepnN5yVfgEGS5vzG+VCyKhyzhhEjcJMkG4K2ki5IgKWpyoK6nxzixQy1v8kq86NdsvTYlRsPg8hCnuBd66gyqQbxSZ8v+caVk+6lpv7x/HkCG48RWRgaWpVFjgD4Q5+Xq/Gp8wu5rabLocfpJLpr/y4wavItVQ8Opn1e3o154RnAsKCFS9EnuikGqrgZW2kRmeJxUE3zyMFGtVMZkZI8Iy/f9nuWdXn03dshhoGuxCPd7ohCA4hKYr8zpDkqIcleQEnyN7XnEH9OTHlEJUW/NPEbLeQmTDx5GZxJ1VEjgFWiau9ZHng/eliHLfe6kh3eNYWZOBOZTdsSh8F913D4m7O1s6WeXlWRCOwUUUHdhylojQkVhnQTMyDXKNhQGk1Eummb8mPzCLj7mBJc6zVot8+cxFml8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(376002)(136003)(346002)(366004)(451199021)(8676002)(8936002)(54906003)(316002)(6666004)(66946007)(4744005)(4326008)(2616005)(6486002)(44832011)(5660300002)(66556008)(478600001)(66476007)(2906002)(86362001)(186003)(6512007)(6506007)(36756003)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CyQh9FmuMMJee3o83ibb1UA/RgdIpVTWNdryFR9/1sjGs+l0k6nHxPDEwCPy?=
 =?us-ascii?Q?NPdNgUE9Mu5t84jS1v0uNO+TxN/zIo6rfBXQobT5Yr3BnQZhZvJvDHYOtAp9?=
 =?us-ascii?Q?yEeAQEYcDV6oZUa/QE8H608Py+0dWGsOuxHLR66ztk+6/WM4HF92k+OvAbRw?=
 =?us-ascii?Q?sYargU22d2wrzLfr0VvxO5y9jM+xx/XqLXfVLZuSOsj/xcb2ww5XjtBZINv1?=
 =?us-ascii?Q?eMVmG+nuxf0AGEcz2abgSNQNRRFNgfSM99/jJwRSaxGbRUgfhre1zbSVNdT7?=
 =?us-ascii?Q?RrsYHXMRPVLXxMmAT/lmTTFYPL2+s1zoHbTqMYpWW28hsqnm2LNnv2axVqj2?=
 =?us-ascii?Q?Kjlun4LulejIjuR0kQprL4deBJD1I/5b0frCSO+TLLgcQ5jIfIH4VrzDyxTv?=
 =?us-ascii?Q?2qaALnRmu/VejRqwaNSyukDb9zpfAyuPgYjSlXpHJcanWQZF55PDCOkNPIJP?=
 =?us-ascii?Q?BekpL6u3E7u1WTGhg6fOAUDiFlSYLFNFwZUSPO6vmi2eeUHhKbIzt70RzyUf?=
 =?us-ascii?Q?DHVNOl7qvmrP8vyesFfYYUisfxiTkMbNXQAhOcpy9vLG5qATFxeEERBJDeEo?=
 =?us-ascii?Q?fwwdCctUGeSNPGvwLOfEBSlyl/dqKcAA3bq6XGffAzR+oRO3Sz66aPWFo54d?=
 =?us-ascii?Q?acvkflFi9itawhKjWkmFEwr5XynedqfsrsY8CdWJAjYB5ixyWOnhsIWBaM4r?=
 =?us-ascii?Q?v5pCwFek8gmoKyTo8j/4vsdmLSxaTPPFhF+VM5JtttQKsc1P3UilEDPQu2nR?=
 =?us-ascii?Q?t510UkbwFkELjgSSdRZjApwqG+DGnT7Lh3zcjhDTs39iTvTHIW7hiJQmd5lL?=
 =?us-ascii?Q?Na3ShdGA3iA7cqEGi4/WIcBzoEe4OoyeTf4STp6NflA5YpF9zLiF+XmnR2IT?=
 =?us-ascii?Q?+tF+velvainhP6e1xx89Yf5WuopXZjDV72agihE6OOBU+Ktv+w4nq43aBYyM?=
 =?us-ascii?Q?/MDmTqWwS5YHy6b3AEGL9TrcdcZtWs9cxM6msjtK3qV7X6ySefL/dapptcwv?=
 =?us-ascii?Q?ykPBsUz3ZPnfMq1zRWGG61u5qACi6725xRBTpLp2eP+7V20oolrMawOuhoYk?=
 =?us-ascii?Q?h8ehHj6bJBufNfOiZnvWmgprlj6nV+i0hBVj098iMv5tdk+N8bvSlvzzkk3d?=
 =?us-ascii?Q?3TT+xYuf7qNrh9VXUm40RxvmlSZun+csUNhqrzxuuWt+2QVZHVdEItWUqIRK?=
 =?us-ascii?Q?j4aNmZebm0q8EPV7rKMLZtZhxnMlrCHMe92iUMOH8PTS984S8gj62of49Ktb?=
 =?us-ascii?Q?HkYglrNkWsqBMg2fZh/06Nm+R4/C+0TUVeo7c7KyKfnDR051t53qhv2h/oXR?=
 =?us-ascii?Q?vNzDnrLRdS8avnNc1N1GYyBLJ/mmUJid4GXFFQmaeNQU9oYI0dlbrTU71ob2?=
 =?us-ascii?Q?q2phskbzs6xdJriv5d6FaXgY9aRjCDtHrxYqzgGI4yg1gsq+w7wDj7yiYeJ6?=
 =?us-ascii?Q?L2oOL/U0YoJt06JidxzIo4c+RsaU0wkNhwbaGFMm55cBZkdEAEIe7i1srmRC?=
 =?us-ascii?Q?+7acqJavc1czMJHmIovcYaOfeeTCdkh7R+xHMAyHi3VVnTD/fLYd7E+e38pA?=
 =?us-ascii?Q?mUbbnmx0WIRl91SELF0uQzl5z1dWNuDR7kueHlUa1deJapwRjEDo1NuSTrN+?=
 =?us-ascii?Q?4Uea+h3Io526Cgh8LLxNqywd7ESK+wEtvHKtsGDuKwXoGBnUQsgMeGTjQSBr?=
 =?us-ascii?Q?mt3ymA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9641a7f-4d58-40e0-8faa-08db520875b8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 10:14:09.2733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fwcOaMq98cofd0IrbEUP9PM5Q1d4iXSPDeNx8pQQCgW+0rg2fIuyDHai83/hOmcDcuwBptY4nSi+vxQUdppwfaHAazsEZ/08d0ClYrQJJMA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3848
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 12:23:37PM +0100, Russell King (Oracle) wrote:
> Change st_mutex's use within SFP such that it only protects the various
> state members, as it was originally supposed to, and isn't held while
> making various calls outside the driver.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


