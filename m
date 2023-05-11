Return-Path: <netdev+bounces-1716-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C4986FEFAD
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:10:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D605F1C20F1B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:10:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFDA11C768;
	Thu, 11 May 2023 10:10:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0161C741
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:10:44 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2115.outbound.protection.outlook.com [40.107.237.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97007D85;
	Thu, 11 May 2023 03:10:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUzDu9chUygSOWzSVpdPULTEK1WC3tbr7poJc+swVuxsbTLDI+qbq8iAHNlDq6AEg5t5OQCd/Rxg04o/ygpvZtNWqBqiPww5Tdv+KB+EIqlNdcffI8Lyv4mNrbYGKiStQUCVBuh3W92DR10g7FqgmsJN7OfqYwg9XjQ4ujEVU46lhRHqJns3XLGMj3N9O6m7EX/u+y4SEWpztcz9541W2ac2kvxbOx4nItL4OGiL03buvCTSYIly0/CxJG0m5FNETNZ+3SOTfe6u9pkmorSX8bnDKZF7UNt/KiPlQL8uGa5KGOIWkrFraLLUc5QqKK8sqf72jVoB53X6fLtD+5Dl1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z/Fbzcr802BCCnojpa71ob7jY9QE23SemP4a5OQLfRQ=;
 b=OikjK277+dBErTFJ4Q4t2p6Ulc1bTtnc6enWvDe/1rKwtpwOpyHEg2qg3J35wVS7q+n8626ZFOkHG3rfHeffo2IkkrG9YCGTtsUIuS9p7e10tb8f2VbiRMu5gXGIXINZLEXZUjToqy5dyDgS2JZcM6XS7ZgyoddbN7IB90JgKaBL1PKj+rbhA8OPridgg8jXUvRi2nfyBYBh7mcXdtJ5dTENUjl79WLjKQvW+gRsTl8MsRsqA75+xlgRF2wdmd2t96SvZgN8XqT5dehHsu+FGMkDoa1Mf7sFhxZFAPX0LYwtjKnCZ15HDs92DTBkdtEEyqtwFMbtITytZvKOOrjhEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/Fbzcr802BCCnojpa71ob7jY9QE23SemP4a5OQLfRQ=;
 b=qinM7IhiZG66H/BbUj/CvpT5aWkxA6W+nVfJWLiQfr3gfpdeQ/HoM0z8uxvXamaIGITbfLevOHjjM0Mkcq7f7QNCui4w2uz5CQBerU+R+9CyF1Lh7tkXC5IwQpxOkLB/OVzmEdGfSFok4nG+TuzNHOEOAYPWxyhh3wnEgIkZUeI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3848.namprd13.prod.outlook.com (2603:10b6:610:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 10:10:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 10:10:36 +0000
Date: Thu, 11 May 2023 12:10:29 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
	Peter Geis <pgwipeout@gmail.com>, Frank <Frank.Sae@motor-comm.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 3/3] net: bcmgenet: Add support for PHY-based
 Wake-on-LAN
Message-ID: <ZFy/FcV8O2qJxevz@corigine.com>
References: <20230509223403.1852603-1-f.fainelli@gmail.com>
 <20230509223403.1852603-4-f.fainelli@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509223403.1852603-4-f.fainelli@gmail.com>
X-ClientProxiedBy: AM0PR04CA0119.eurprd04.prod.outlook.com
 (2603:10a6:208:55::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3848:EE_
X-MS-Office365-Filtering-Correlation-Id: ee7572df-ae37-46c1-85a6-08db5207f686
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Z5N034aKFexLanPc+6UDjgeSpaSsgnyZJ1NrhAKxIBHu/hDNgaBHBzxBOsjSLzCBBCRDuD/CWawD5H2Nk7vUHKwOkOkjXyqKn8qovhl0aahzBIccdGrH5hBYWJyANcxG62MzwDXIQcXIBOcYMBadsL3CRtM2jk9Glpyxsbn36a8awSWzjt75RbzuobQ3dPZNnItZ9bD9l29dt3E6FHQEjs2OO5McDGfW0F0qViRsWkqeZCGC3j04HsYmP15dSuIXi3D4hMjcTO8r6vefqrn2RLCP2SnRslwWKEUR5mF44OaEnXwjp+T+sm92Kc4ohPldcRJ5nPtq36yrROqOQlORJncsWPqY6bFPMhpl8UYl5eca1HWXaiCgwBkWZI3Q1mHaK4yGSZ931o8aZXDvdtM7FKiZMl7GQZql/fW9E8RXWRRn+gpwGsRcqnxpJp0tls2U8oRqOsQ9EIaIBh4pOfnRuRN8DyZbpUX8wWYgOYGbkRlwle/stqgZnY2oB4oWgmuzj7oNaiiB2ai3aNQG7MOkr3EnkePh/gPZAp09b7zGoEDVhsZPu+8Sh+4YXw2p0Sf5
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(396003)(376002)(136003)(346002)(366004)(451199021)(8676002)(8936002)(54906003)(316002)(6666004)(66946007)(4744005)(4326008)(2616005)(6486002)(6916009)(44832011)(5660300002)(66556008)(7416002)(478600001)(66476007)(2906002)(86362001)(186003)(6512007)(6506007)(36756003)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e2lcO9n5Z2Xc+UU6NzDvRTl5cyL+yOX9nV5RfILzfE35w9mKCcuRdlZ8eax0?=
 =?us-ascii?Q?FFRBi712GULFb9pLGVdyB7X1tRpXbSp5eNyT921iv+i8IyNlhFwHqyqm5ZYx?=
 =?us-ascii?Q?wj91FPKDM08ZusQWthgMC0LLbAYmZ8uJxY+4msg7ZuERSflgDu/2Lr2sS5pf?=
 =?us-ascii?Q?NPBdCW3LJx2UMHooIcQ0LeGVDuwzLGrbruma5ERHK2wxmFBSEL4Znl1PBpJe?=
 =?us-ascii?Q?eXI2s9KcGHh6oTbTXJQ0vOf+Q0rCex9dhiXcQCGe/Qf2sNa3wE2eYYxllhAI?=
 =?us-ascii?Q?psY375IHBAL+oWvPLwzjDDPkG4ffb6/aCInAhnwfFhRUBvy9rZHPdZLSKcOb?=
 =?us-ascii?Q?o5NctQCZDmW0l/ZOP5/Rck4OBVcm6U43G3rTMGJfnVUjiwLLPlhcU8/P2j7n?=
 =?us-ascii?Q?S9c0LCxjIYnmyJArYJUr39MPDFMrQTcV5Wjd6pwxzExuBx1LJTKEO6veTbDg?=
 =?us-ascii?Q?g/HTKXsrwpQAob2VmOhBPqZ3S9uM5E73UfdQlp0qL3aOCBlJWF9m0/qyciGr?=
 =?us-ascii?Q?ySxV+OngAyTjtBh0QB8mX6XGVYUxj8MYhvIHAbK+nuPRUW7A7WdBTtd4+H1q?=
 =?us-ascii?Q?+bvP3QL3bxQ2viW5fWSxNs/GmG1lsKC7Hd5R1bzx4smmcCjAcPMwhGeT39Vi?=
 =?us-ascii?Q?Ojrs9RX1tKtclBXWm7crHPYQ7H2935yG7Fq8JkvUjQcLGrrlTW+0GncOgAP9?=
 =?us-ascii?Q?94xT4TsoOFf4tB6HxIyo8afi5CWsDGTVN1a+sMNRBzlsTcQmoUA9htWun9pt?=
 =?us-ascii?Q?rjYtIWB/Q+++IDMW2EPe0W1RI9hI12Io0oQnlMQKeV+Gy6DWgb46lSGcT6h2?=
 =?us-ascii?Q?shOmVfHHhrzfyRyjyGAgp7lSJt7N0V4RPUCb/xotq6wGLlraYLdwlyTn3mjT?=
 =?us-ascii?Q?Sn8RJbAYvz/rR7a4Zo2kzKemQQnw4vhND+9NKQd+yeuzYGzIytKbXzmCRC+f?=
 =?us-ascii?Q?pOHPSYjz6keqjbuqa4YivYxQJkdNKhjPHFZTTs+fDGbsDgabQN3ap+/51ytp?=
 =?us-ascii?Q?NWgOr35hDeM+PNah0bEjrZs3VSkBI/6IUADzRP1a07OZmZfWqQEBpLk5fS8Z?=
 =?us-ascii?Q?BWAOLhxgW2LyiQvHP3e36JmajT1wxufzpO8Nb1FP/7Hb3beNDOZURlflzlpo?=
 =?us-ascii?Q?buKnmze2OexAkMeBYaooQ0TfFTGapzzkt9BaBZSvVGxUrWkLceZVi06RD4kQ?=
 =?us-ascii?Q?oCPfylUGlwvld5gqQDEX36K43CrTN4m9M3HJFbMB8p8em1I2pP3SxUuFqOvZ?=
 =?us-ascii?Q?K32P4u5yiLkKHskaRlido3HoUQQjV8ZzHx6LKUZc1Pav49Ql40NvU177NFgZ?=
 =?us-ascii?Q?S44rNOiZJSnl3lqRYuY0rqauP97Z/sOyYNiQWeavbnbD+tBe9t+dMZPo6M2h?=
 =?us-ascii?Q?Xxb5SpsyH3ldBg0VSXLpVpWIn0ec29hjWXa/SU0ElA6eq1VzSkjzC4fSQmAj?=
 =?us-ascii?Q?Diic025UO4ayleoZlsX1ndJ3RwCKaxJ/MHs0DAqMW0Dd+07cNL4yJjppiiv+?=
 =?us-ascii?Q?8fBP3zFFlr37ErfYLMfKRlahiW2vdt8Mtmgf4gUaC915cKfgFXereDQfoEVM?=
 =?us-ascii?Q?trlIeSgDg7dApW228lWEu6yktExvYFW2wxlgsuec1JY3/jdqwFCJoB4YgNPg?=
 =?us-ascii?Q?dzG5ueVEDVShq7fsVMJ9jFXIupb0BfFVKcy4cMuA4oKlO7K9FLjj3YOQ28Lv?=
 =?us-ascii?Q?ktFrnQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee7572df-ae37-46c1-85a6-08db5207f686
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 10:10:35.9307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dAI1puNMEHX0MFH7K4kKG4/CfjCFhc9GQPq8XVo1FO4LhrSlfnZ6jGmSgFzBV2dZJ3+zeVcTxi+t0E3HuOuce1R/8aFD/G8pb9kNuJII4Bg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3848
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 03:34:03PM -0700, Florian Fainelli wrote:
> If available, interrogate the PHY to find out whether we can use it for
> Wake-on-LAN. This can be a more power efficient way of implementing
> that feature, especially when the MAC is powered off in low power
> states.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


