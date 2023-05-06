Return-Path: <netdev+bounces-684-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC44C6F9039
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 09:37:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6A7E1C21B1F
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 07:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA1281FA0;
	Sat,  6 May 2023 07:37:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7541C26
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 07:37:19 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2092.outbound.protection.outlook.com [40.107.244.92])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079F911573;
	Sat,  6 May 2023 00:37:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dazp3AHcco/sDyBszucA5O8/KkvacPryYlbdrwlH9Spu02xLfIeoUa1l6kgQX6Se+TOTlKwF+lskNZ12ZW8YigYKZvxca+EZpXPHFQER9fytChJdceChQI0+qTbXzkaBJ1/gQN1fCjwo+r/mqX8loGDpWWShbzXn5mkv9m/CSF5arQolrZkgZxX0MYMC35okhkM58fyKtYwgt21QJqz0iLItd8Of/Wm719DwdbKXY6koQ5q8jAx+b4CbozdFoLDeonu8fiNkq31UnU3oWyfYWs5zKRKj3WYIiaC/mPSGOZ6Boh2TMkKvaXWF1HujjlN9RNrUHff6ZA5ir1RdbuIlXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GzenJu5JbfgLYzBlvmFX8Da3JZpXXDD7NnTExSpazWQ=;
 b=dOGKDt2FOdliUE78oOULFn41g6PEpz/XYQCo4ksaiNI+u044FR+BNaSHxENkOCACi55HXmyftD7rNORbNo3qsrmuWmHVoTGkUpnIqYA18Z7fIMLSHIJR5wDn97RlACoNeoNVtTPftUrJ605N/qxsBokNjtqqGo0l6VWyUKiw2ygKyoVdjQGQ9bPhxzFMsh6LAFxA0WpZbg0R8iiSHyeIZwCWjtQ2sXAO1yX2gRrj1XpMjWziA55usj7B22vD5pHHVoZEauYzke0dar/BcvtgPmleYkZbee7v1rW18jMo24YXSS0O1fAtVKbkRdaHIvu/u8BB59zmF0oduQI1+Xjv4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzenJu5JbfgLYzBlvmFX8Da3JZpXXDD7NnTExSpazWQ=;
 b=eWM9tjMP7QBsFDW8F2bcN7g11YoJRa0O1GufXuV7bSqmuGx43E64AXjeOwPt9AeFfo0q7MUF5eBXarphXZER1va6K+OJKa4x49NZX1uofdM7SjE6DjeP/QbJY8kWMJqKSihXPzAWNrVEphwUTla87vFazmUhqWBA7mYTGKJzOGA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5548.namprd13.prod.outlook.com (2603:10b6:a03:421::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.29; Sat, 6 May
 2023 07:37:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.026; Sat, 6 May 2023
 07:37:04 +0000
Date: Sat, 6 May 2023 09:36:56 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] netfilter: nft_set_pipapo: Use struct_size()
Message-ID: <ZFYDmDNUVBtPdAAU@corigine.com>
References: <687973f7f0f77a456ee2ebabd75cec61cba2eb98.1683321933.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <687973f7f0f77a456ee2ebabd75cec61cba2eb98.1683321933.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: AS4P192CA0016.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5548:EE_
X-MS-Office365-Filtering-Correlation-Id: 32cd736a-c9ba-42d5-b116-08db4e04b000
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7dv4UXLxByyLq2VlWQz2bBnrXelFN5RNxE9vxjpNro2fmk12KRuKEglhqRoecHFcnnNMBB9BoG4zob7TiTuYILn+X1pfM9QSbKXjHwxm6OnnBDoATPoa3oRbIIsrXzYsosMCOYNaEmNZCX/YzBg2phmNZYC2C1RwIqi6KKUxEawJJnV2mto8F1xVPEXY6ChpPxMXUkAigkJmkDicoSRgqxpUwCNV1lDqjlvNrO8udV9nG7kvurHUu4yIT1Xk0ClLEO5KmW0l0Kz6C2kj0PwUNa8G7zX8mEbhvkUrK1HF71D44nP3YyLDdXZFVVl+hQwnPJYumkFrQLYzxhnBjhUwgKb4MoMNnD3we4ePN9UpSzKd3KLWwSiRlYh010aAn6jWMB1cre6ehPHiJ7adVzCSYx++tpp4I7tyDlK/nBx5EJ7dtrhH+u9r4kOUcijA/284cfdHxy2tIQaHB5l62QCOEvaS3JlG9R7bfk7eCaA5Qorn043xBRXSKKTlIQUgqBMVGnLUoXAXJN0SQzIocyceDnXaOKGeCG2up0YfFQrtkMHGlf5hCVekk//n/9CyY/QU
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(136003)(346002)(366004)(376002)(396003)(451199021)(7416002)(86362001)(8676002)(8936002)(6916009)(6486002)(66946007)(66476007)(66556008)(4326008)(5660300002)(36756003)(38100700002)(478600001)(41300700001)(2906002)(54906003)(2616005)(316002)(6512007)(6506007)(558084003)(6666004)(44832011)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cDJCxhkchh2mgCmAIt3Ackx+5tHSORpS1e1jyvmE3qCXPGl5ZbdOn2Xvoq1X?=
 =?us-ascii?Q?FnFTy1cvWb7aI+sapGaEZ6tGepBl5mvyMiqsbWCIrdS2nm2jD1Ac3NG7Yk2P?=
 =?us-ascii?Q?uNreNdL1BjV0dFc90lk+3fmq/48OV/UAJ6D8d1tYeAhIRFd5I2oTjjuG8BiX?=
 =?us-ascii?Q?AoNsC4Q3pfoHIe7RIFJPMkOF70OkmcyVx9Cc7S9HXEdLDSJXWaUqrEbEJARb?=
 =?us-ascii?Q?gEHgeP0PVFm81P1M1htR8tHl9Sw/GupJmuKQbFzB3JbtNBU7tQLtfEzzOVCb?=
 =?us-ascii?Q?GmQP76emgc76BbzC5oolcvsfvMnOFIY0z0B5G6WC3T9BltGaXxHc9cTlGG4d?=
 =?us-ascii?Q?12Go9j07N3egU9/BwnO/oFQyDpF3t9IPgnrhnTSWqD4n20tRYB9MhOAgGIo4?=
 =?us-ascii?Q?VDJI54p5AJLTF46znfz0wQMBuLS2zvOoFz0wy/gIDz343PN7cJ8+iOqO65m7?=
 =?us-ascii?Q?Gg/jvrmGjNWebEWH4EGzJglEZ+WHVrmGxxzoDeOeaacljI6i5sSg+l0Bfnio?=
 =?us-ascii?Q?QYsJfWimgqC+hsxK/etpXpAgozBynHMd0jd72cc7ORCM6hPcKyf7vQPWXBtB?=
 =?us-ascii?Q?aFCC58iy2HHJT00Ej5EW5RW1wZvZucS5y3y4cQxNX0epf95TNl6lrHUQwh/5?=
 =?us-ascii?Q?GlXOvzaaWqXJ7wuV8caL2hJrDFIO/sBaf22VyrKTFbsoEozxAg2Ee2Q32w0P?=
 =?us-ascii?Q?WUPCOIjbkEQ4wjhVfhdo2Ut0OE+V1JPy9sOaxBQicajfzv6okaqqM5UnkguD?=
 =?us-ascii?Q?Ge7YpU6473NfAKad1SYekExyzW29j3Z712gQgjtW+iM9L+a/GSkpWtI3Rwv4?=
 =?us-ascii?Q?GiNySovddn5Pa9Se92WYKdlx51c7VQfxzLzSp9m8o/XA4CsL6yoQZD0fuo03?=
 =?us-ascii?Q?dlhkgy00d0g3bLO7WoT/KzDra1WOaGlxfpDO57q1gpydxHOsiOofTCUtug0A?=
 =?us-ascii?Q?K2GSi0jE2hczhH8mNlyDveHh6NqjqG/13VWQuS3wmmjpUL4CIOBzZYEYBXIP?=
 =?us-ascii?Q?wN/67Gaio0kjBRGNR3nYjRLeRRp+ZSxCxb8ADXMVe0DyatyDVzGuYFEO0H0c?=
 =?us-ascii?Q?vsEsbsG+hCzNF26WxdgTudShKdoSK+5eaGG8L7yEP44EgbdT1CukmIcWsnXs?=
 =?us-ascii?Q?9ieD9P1Rs3y/snLXfo6UjL/jVgeZbJL7uvNcI/QZxIcznPj6IuW7yyO3WQRx?=
 =?us-ascii?Q?cSVPV+gxq3VD3nDIG5fLHzlxiCR8Etflsus+iaRxspZwbpxPNw3gMPIbSulL?=
 =?us-ascii?Q?QKyU5LQ9KU49OGjBRh4onrJ35IEfy63bBRKqiSg/6wWr2aj3pLChxNYqH0k+?=
 =?us-ascii?Q?igujE5jAN7OCfBlrpTJfBQ1xYqRAUXxH8kLCwR3T9t7iGPmVcLo7LF96POmF?=
 =?us-ascii?Q?1/Z1z6lwoZvoMhmxvQEf0Ywn+Yp7mspvuCfLhnLMDgSGj4jlnCvmzHMNg68B?=
 =?us-ascii?Q?Md42d4gQmy3tPwy8xpbAsOXP/y/8E1qqnfzp0MhmGKGBBaU9OKy9Sy1NhVaW?=
 =?us-ascii?Q?O6uf0YzsV8ZOCm+CM1dbbikkdrDuG1L+PUzIjpCWbnQJs1r6cVyN7kstHbrx?=
 =?us-ascii?Q?A9wWq96NpX2S36ANHhGVqgwKg8Cc083sNViXdMx/cA+vXk2MufjPE784yoFt?=
 =?us-ascii?Q?jM9GRCTuih+4IQ8OqCPjeOOkZtTHS8uAcTIIQaHBaAPgc9BEnXodLYtlFoaF?=
 =?us-ascii?Q?Lp/5hw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32cd736a-c9ba-42d5-b116-08db4e04b000
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2023 07:37:04.5109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BIHguXmcE0NllcGCMI8p7L1asL7uew+OFtO22qo6IQ05ZxjtZQ8l2qfp8dAW7y1+fhn17w0dFUbBO1OKpveAp4v/d2WwPLBVtNLixhg2ICo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5548
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 05, 2023 at 11:26:34PM +0200, Christophe JAILLET wrote:
> Use struct_size() instead of hand writing it.
> This is less verbose and more informative.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


