Return-Path: <netdev+bounces-7117-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A611071A2E9
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:44:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFDA31C210AA
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 15:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8049822D61;
	Thu,  1 Jun 2023 15:44:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED6023400
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 15:44:33 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2138.outbound.protection.outlook.com [40.107.243.138])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7F7136
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 08:44:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e4H/yYNozS0pHCtWEZeQJphK3/OuqLnXivgYdw5BjOjl7y3oNmalpNMd0qJEZtkUgntVy61ECekJiJ0pRjO8XybXlPUjsaWaSV3MA2djEtsSxQP2YgA903ApjmIr2zt2nS74V2KqsXnt5NrH5c52lS24wYDUi68w95876SJbr6CxTq4XFkTYfvtILbHw7NTCEWl7u7KlDdbX8CDuc5nzgjDASTafcqdRzBjf+F86FseYl8AFw9Z0MQlciGPny5y9b0WNN9RacYSTQtCzec7oxf+THoYtoQaQeNttF7S46D7fGEIvSi8z/DoOrTCItWtbo1Ni+5hQXihOuojBiRCLmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A6ewykYRT7RwxyMpNm70H930JvcsL03HE+IjkMpiRKk=;
 b=mELHela41c4/+b9w3f+Nv5U3c0hwTWMCRjxbO0G52ysLpwvNAzM96zNKHhB4wGQPnB1pQCgq1QDmUhBBZr+HssUhZmC5DXAk8bYV/PIPfJXqmAq5k2jWbixHvcH7HXuv1L+HcgjVBgWpJqUoKZm5uKbvDExcf++7bCQHVi8xoN46cmk0PBpwDf0i0EHD33znBwZ6j9SE5GcxF1ptwDKuD7fXNtC+Y453aej1dv6TkuLd0j0LUtbiUx5oeLzemSfuXv6DjwA7jEaDiQpc8N28J4zV30lQ9Qw9HDc6qPWRh7VnBRGzYz7UQ6VYZa4s/VEEfwQlxCQLtQBHELeIOHhn3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A6ewykYRT7RwxyMpNm70H930JvcsL03HE+IjkMpiRKk=;
 b=C8K6N/gi8V7ZFt5mdpSgAlmOW9lyIreJg8/seNvv/PJ6pXfaF6FlgOv2dxdAzuwAm4ev9wTfePDZXHfduF/q5XXNRWNtXJsmcf56iOhU20f3OVUVTZtmy2Ma2VK6/uE9IVObL1eCMj5NVIOk12kwf6wpXYIGfuz+pPrmbogx++k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4490.namprd13.prod.outlook.com (2603:10b6:610:6a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23; Thu, 1 Jun
 2023 15:44:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Thu, 1 Jun 2023
 15:44:08 +0000
Date: Thu, 1 Jun 2023 17:44:02 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, David Miller <davem@davemloft.net>,
	Realtek linux nic maintainers <nic_swsd@realtek.com>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: use dev_err_probe in all appropriate
 places in rtl_init_one()
Message-ID: <ZHi8worgk2KndZPd@corigine.com>
References: <f0596a19-d517-e301-b649-304f9247b75a@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0596a19-d517-e301-b649-304f9247b75a@gmail.com>
X-ClientProxiedBy: AS4P190CA0007.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4490:EE_
X-MS-Office365-Filtering-Correlation-Id: 598b7e28-c84f-4ed3-be43-08db62b7098c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MGRCNxUYInQvuYsLrBNFXhOq91ymF8hr4EhtxIOVW3WXqLRbsQ0Nh1NlFjSiJT/GnBBZRXmb4zUspX7EZHyuK4X0m/bmV8CHdSk4E5yYDQvxW5GMFGi0PZk3JSpQkfwk3pAbY22uDr7PiBAQDpriVG7ggn1fL3Cnbrkmt6CRC1tju/yRtbXJfAmZrC2vpFwQVOYGTDzhnvdkyeH8Km1B+dVAfmEUw+ZQnIMA4iUpdZkQM2VFuTJ/ZzbPQRVzbj9E6O2vD3mpNHQPnzBdwWdM7qcme+F9763jJPsk8JAzjD6M92IMzjUaDhI7eiaGfG2isJt7jv7IOAdIttBZT53ed0znSoyTnJ9ohme5CDPp0eygapfniTGghFD+UhSB8rmD2fgVX1ydDY1krDwoxjGA5XUE7yumZkV0V2x+ny95AG+dQ9U8OfYWGvmRXuvkjCsBAd9YAOhalAOYYMMefOk2L0x7yESdrJce1jav86Hri4LFp/G9/MwH1SO8lHJ3dX8uhLou99O6H6eG245PhU0X/mvf2OsAT0YkxmpqwQz8PGdeCQQNh+JjKFx0Su4dCTuSvUl5NdLeDiPSboGX6pUTTnUVZGrCWnrNyXdh3q1hFLs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(346002)(136003)(396003)(376002)(451199021)(36756003)(38100700002)(86362001)(8676002)(8936002)(41300700001)(6512007)(5660300002)(26005)(44832011)(6506007)(4744005)(2906002)(186003)(2616005)(83380400001)(6666004)(316002)(66556008)(66946007)(66476007)(6486002)(54906003)(478600001)(4326008)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ja2T4Wi5DMfLSWba+z7ezMQ/enjtfoP14KaruCtx1mL/GV2WXAQifW0Hom6I?=
 =?us-ascii?Q?jDrxd3jzbB2iLli5z8lLvqyw49EyTDdHRxpzCYuWp20TmiEttjXXSbdt2EMa?=
 =?us-ascii?Q?5ntUnVEB4nmHQnvx7Pna7i/L6Vwx8FphCmpahXzMtiIHA2lItj+Wc0SOxvvJ?=
 =?us-ascii?Q?R9HCyaUm/uGhT223cM8L97d3SDCexJolKcxW769xodOTAysUTiwvfoTWE1Dx?=
 =?us-ascii?Q?lUf1WPg5lw8lpeT8s8V+AZJ0W3f/xt5B+GvfshURLSAafYk3AIDrykUMrFq3?=
 =?us-ascii?Q?kQP0exbFyGY/fBli2S3v1DzildAc+RbKXvqOuQUdEVPivXPeqyATLAAaBmO2?=
 =?us-ascii?Q?cFfqpV0MPY6jNvTNPaD/9TZOx2s/PcgSIigWDAShVe1iC88+PMnMUVjNSh2J?=
 =?us-ascii?Q?VXIP5v1vxMoqEYVFiFbBdq3uS0b0nTPqgfJQcuMGTX77eihXNvwwW59U9xlK?=
 =?us-ascii?Q?KQj0b52knCvcZmdhSQ6kL8IInpSxKFnChzmJhCtWMSWGQn/F5jZRBLb+lvXm?=
 =?us-ascii?Q?XPjur5xgyE88swo2qLMLAB8dtm7R5BE88sHXAcYyQuAdlc9O41PEOizT7DM4?=
 =?us-ascii?Q?bjikE9qSgj3gMXAe+vpTlFS3F6mwYG636pLgb8PS992nGqxkSLtdD9870fXe?=
 =?us-ascii?Q?CrT+9Uql2l/TANLTjCmgS8F/YHsmXVZtppE9Cvis++Noe4r18r8Y9EyhExSk?=
 =?us-ascii?Q?UrdPKZ6uK89tTiqIw1TkdR0NTUWXacF++eP59rLLpT7XZUH1q8gFslQMEDkF?=
 =?us-ascii?Q?NFTgGHLGu45OabV+YV9MdBg+SO/ih6tJ45G5/euVkmCkM3uVJUvoxZ5Bbduh?=
 =?us-ascii?Q?q9NNDFtpLv/7/8Uov0fofU6YGAT82Vd8UJqVq53yHpRG0o/STu/q6GFNsyq/?=
 =?us-ascii?Q?+C3bZMyzR5mXnTtAeFGlQf0XAa8kHZd2rld/xIz3VOQvDtQ7mVYyyDY4X9Tb?=
 =?us-ascii?Q?OjzcjxLeqELCwjJr4svqNEEzq/AwYLBaxQ/I/eXESZjYxmyBvRyCItLtizkI?=
 =?us-ascii?Q?/alxfc3Ubf2j+bZlURrO4IaQvvIxhaGrwnbn1/ogc1BtLHs0zbQDB59QOvnu?=
 =?us-ascii?Q?q2j54ce8outQ0qaT2BBNWmfqtPSx5DmA2LpYeTR9jTnZtF4CtH85aHG8zEGT?=
 =?us-ascii?Q?EAS78W79b8NhiqMt35a6KiCzkCQUEil6rX1UyscChr8iaNixiriz5Z2v/iPY?=
 =?us-ascii?Q?/EDqhnd2lQz3E4r4JvwuJORjZMDjZ4mKfk1nSzd9QBvV8SyqvPbt83qHh5Rt?=
 =?us-ascii?Q?9H7jTUDL1J2WD+n8fDQDK4NEIwnT4UjqP7d2j6W5uVw460oh6jJYW666fpJd?=
 =?us-ascii?Q?wh8v5sdgB5mTQm69EfB76ZiCjcG1Zw3QHckI+62icAUNAcFOfD6+3LmNLQFU?=
 =?us-ascii?Q?q8ygK0biFDhKA2oo8jI7eiFiirGzkL8ANz50XIzF/EfwatnSmyJkjuf6QrVB?=
 =?us-ascii?Q?d6Cxfybg2KiK7OWYhiUwFboRICIWnxsvs9VU489HFoAR/5q9oiP2SYYKRprO?=
 =?us-ascii?Q?3BND1nRQVOBixohlLsZrpgL+iyrvmTHdOhWtvlxw1dxYZuKn3X+XRj5OmtL1?=
 =?us-ascii?Q?92A+glqI9NnWWvsuLpvnNwA8TPa/3+QYCNVCgtyDvfG/Gg+7ix24+w9ksY+M?=
 =?us-ascii?Q?6w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 598b7e28-c84f-4ed3-be43-08db62b7098c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 15:44:08.3124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mr8GsrbzoJfSUx9pHCRkRGzsn79+AVsOZtKGJFBBcuoAXtjkLdL132ocXPBsD72l3vPJ4Ig/Fp09TQAR0lT1C5uNPfT5NKTdsTrSossQDWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4490
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 10:41:32PM +0200, Heiner Kallweit wrote:
> In addition to properly handling probe deferrals dev_err_probe()
> conveniently combines printing an error message with returning
> the errno. So let's use it for every error path in rtl_init_one()
> to simplify the code.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


