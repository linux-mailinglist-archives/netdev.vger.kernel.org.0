Return-Path: <netdev+bounces-5891-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75AF371349D
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 14:07:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 098182817F7
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 12:07:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE80F9E3;
	Sat, 27 May 2023 12:07:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8D9AD4B
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 12:07:41 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2107.outbound.protection.outlook.com [40.107.101.107])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C2DF3
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 05:07:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8z1Ag68nMcPrFuNtX1/Rh+0k/1N+0dP7B0pG9PwqRg/+yjIUyiCjohzRIr9NGNBEYjGTVlR5PSbFWlvup+SqSfCmQL1VYKIYASdEUAMKEr+amBt1QpsPrreXj1N688JNiy3y8+/aX6Q+z9LD2h1+jVYTEwX+aQ2ukQAA6ljyFLWP+Dw+eyvLzdVP6+UCnleaXjIIYmsFkeXUNhB+8lUHHANu0+NZpUcMbaThHZkqTTBMg8Hnqqv10YS+FFfZPhmel3YfV1F9v7aNPL1elvB4P7FHZfrsVp/bHhI2bgHDyhg09ooVoo8ZD1odt0w8+AzTKMVg3uRlcPB+dI/5okzxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GWOgwbkLVdmm0QMCyakXPQuek0neGvxgFbcrtCk1XiY=;
 b=aMxT007gdO2RToqN9/WK8G1ysV7zh4h95d3jefIFwoJw57sqcKrRXI9XDMcvMeuT2wMPdfRT/wuAYune38Su/zZFtQxweKWgJMzzH4MI1J6QgSnvuRt9L4pStQWMHXTV3Harb7nO9eXObO2eXkTcrJIH3qub7lMxuuiiV/ejeYSxOqy5WcY3Q38LsAVJD1gvs4oDWRiH+XxMNrxyotb9wBMNkwOUzl5wMVDUMKO5IjDKGi6oAASl7fiecJWyCgaYItm3PDpvjv9Zhbg9wXS23kjXZIE0Cj5jszosN0JfhPSpbmze9L+aqIByp2oMh6EZuLvYQdQWefQGr2Qnz2Uykw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWOgwbkLVdmm0QMCyakXPQuek0neGvxgFbcrtCk1XiY=;
 b=GgMak0XXwBiBKWG7svu1xjog4/Bt3FOAV1rbBYuQ/KK+EZKFFutJqlcotNAsF5wYVysdpqf6iIntNei/Xipgyt94bIJfhfdaZwxcuphTtTlmKa14qMS+VsWYNNobgLNpjKuIHFKgZ8P6TGx3Bk8PogjxP6MiTEMRvVnQLdQyx9I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5008.namprd13.prod.outlook.com (2603:10b6:806:1ab::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.21; Sat, 27 May
 2023 12:07:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.018; Sat, 27 May 2023
 12:07:37 +0000
Date: Sat, 27 May 2023 14:07:30 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dpaa2-mac: use correct interface to free
 mdiodev
Message-ID: <ZHHygpwwbKCALCc1@corigine.com>
References: <E1q2VsB-008QlZ-El@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q2VsB-008QlZ-El@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AS4PR09CA0028.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5008:EE_
X-MS-Office365-Filtering-Correlation-Id: 11203617-18f7-4a1b-f596-08db5eaaf626
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5y2R8tMniuvxCr9lTLCndwlmOE564ezRDCxr6o7cY6EddGi587LTnoEx4DefAHcaORM7xvhVQcj5eJMIlTVYL8tMieR+uyXVMfPSDWZuAa8ml73hiq3SIlGn31lPVGlSfmouONSpqFJUL1x23JhEaDzYosqAJtXt4iPCs90gsyZtnSDdi3aAvbgxAEl8peg49ZhgJPvvWZiYrSb5EpCCkDtbhF6U3gImOxrnVuYqheHtStShH+l8qqeO7Hors5T32zABtDfHs4ajZRek5hPhj0Tx1ZoSnr/HckT22UjRpfVV4QPAtBo/3iuCwhNoeJFdkoFALNmZCN4W3BIq2RK75yb7rBAUB9Btx7rnj6lbu0+lLg1fZL+xN7TExtxfTn1BE3DAk/XyXiHmDQ8AVv2hcvv7XuYjCX2s3LARZNqMWAlAmKjc4VLTPOH+ndlG1+ylZbnWYNBupqfiIKqrVq0Tlh6N2cA5sRGqy1c0AJxGS57uEa4PtDwGRkdegm+qGFJY4xlY4tDPDpae7cJj1bDvmskj2wOVcoEqBFx/MM+gw3xI0P0qBT5rdqcVOjZ7IJhD
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(396003)(39830400003)(376002)(451199021)(8676002)(8936002)(44832011)(5660300002)(38100700002)(4326008)(41300700001)(2616005)(316002)(4744005)(2906002)(6486002)(66476007)(54906003)(6666004)(86362001)(186003)(36756003)(478600001)(66946007)(66556008)(6506007)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3lq4kQ63hxTYLX3ntinHzna/CXfPY5oah677hrLCo+JOUAfdrYeGPgxyFLUi?=
 =?us-ascii?Q?Z06kbRjGioBASZrvLxEsc1iPTocnzvQRMyWeqUsfYcFGhT66Iy+y6g59/oWJ?=
 =?us-ascii?Q?Byj9StAOFwCpdwVvyQfFWQn8zEQDCx0nr9dQVxD3xp5krPO8JRwsV/1aYwTl?=
 =?us-ascii?Q?6tZS1uXmbVXDsvE2D3Ps58DJ7MLMohN69C8KpcrC2xN8FRMUxF7j6/uzpDNr?=
 =?us-ascii?Q?cPJiLEgrvHVqtBW65zml7i4SM63RgQQPDURM/wGkUvYMRUqqNDY6lf7eN78a?=
 =?us-ascii?Q?p3zZXpeWVY1xDjqtc+jFK+VI8+4Cn0OJtxKOs/tFwtyNpD/SAiUP+Gr9Qesc?=
 =?us-ascii?Q?f/8qzbUINz1Dn65oU6NZh2bWP8Ql7p9l4IU1f1kqaMreOkTaGTIMX11y6hJ9?=
 =?us-ascii?Q?pj78QiH0BHYlcLiR0L+SovK+t49H4OCPAcvvIzFGQh3/xXTcaaYvl2pxQGVk?=
 =?us-ascii?Q?K48nRd7OWgsgBu7fRXkd4uCWg722aknRKZqcaI82kWlzAxyA5tWdzQ7FAgEf?=
 =?us-ascii?Q?P5cX0uYgVwJ3YousaA+SynfCohGMsoEmoC/u+KBFO7pW6BjevEZPCbkxvKwR?=
 =?us-ascii?Q?gQyT5ZIn1UgJ2y/7ycPKinn+LpW60A3GxxnCdf/JtVb9/ounUrBBKTf788Qe?=
 =?us-ascii?Q?RBWZcKA5/7nciWkPVxFkwm0VPYkL00TmpCnnj19SawvQFokVlUI+3SmtTylq?=
 =?us-ascii?Q?y2M/t7QjdZKGJ9iY5sLY6k+H2ggwC0L3Ff8uld4wx5Vk+MpxHJ0aJM2PMLXY?=
 =?us-ascii?Q?7XbqiNyGeW8TRed4b0D3/yPJ+P3r+oSgj9U/XGIWlwmGoq99JubJTat3ravX?=
 =?us-ascii?Q?XLwYwmy6pLEWldL8eoSkt7LqXnnkBEnvUecz17G0el/pgD/+Kowjscc7qyOQ?=
 =?us-ascii?Q?qj++aB+eWsTQ9UAyOC+LCJ05ydwB3uhXcdRj18xulut3G4I09HO+8fVg6+4l?=
 =?us-ascii?Q?dn1DEmqt9EpVajPZs33vmRYcrtshHdFzOEHsplFRip+K0WCn5zRD6AsdkG9L?=
 =?us-ascii?Q?Crsi/gnUiTWKvev6A5IfIo7d3ja49eIQiuuMGrkx3cTxlIuJAp+cFDjs7pr+?=
 =?us-ascii?Q?JBhpOps0uhScUz9aBnq2Eg06oxpLNvROuaGHl1FOGjunKCR9ryRmPvZfCYcV?=
 =?us-ascii?Q?VQa/cnQ5B8uYwmBSqMnnAnmS3t1vUWqGtSQaPFFd7cuQM58b/uSEoV/1qgTl?=
 =?us-ascii?Q?zu1K82GPequsdswg7nPwTUngvC0V4SFlizl6f6Pl3wRIRZr6erjdpWxbEI+Q?=
 =?us-ascii?Q?2A9QMUZkjfQ8YFcdzBNZCzJMJPn1jznoFr87zrhsMar6RnpW0BBbdpzlJaky?=
 =?us-ascii?Q?MfRmg5c93lHxH2UBgHdLSUN4PCOVEpO8IAOMgyuynj6RBXd/0W9yye6Mo50z?=
 =?us-ascii?Q?PkfeFLOS0/7byfRTiMJVVbFHNps2/MLkrGlRS0jRg4zxyOiSnqMDbNcWDy47?=
 =?us-ascii?Q?fQgw54B6OJ6TWXBDAOZ1LWhG1ilFxj5YZsxzDtvd81a21gUzcuFIgE5z3S30?=
 =?us-ascii?Q?YiTziPAVXsz8GsTrjElKwaHq4IGTqkM5fkitlAWZLAbv+qqzoF1wy1S2JCVO?=
 =?us-ascii?Q?m90GeIjTTR22XrCRbq9VIeU6NxPAXV3tdwDZUaBg6aMRHI7Ma+TOQ2aeFtoR?=
 =?us-ascii?Q?O7XcwvH+ZDAbbQlqlYM0yYII6Ur91yPMqTb48Ds5wpW0tiN9ZoWoUGXDH6f0?=
 =?us-ascii?Q?7le1aA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11203617-18f7-4a1b-f596-08db5eaaf626
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2023 12:07:37.1434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qTvbBlqcjHdeSwfLlTE1byUrGnz0wAVoDfGYu9f3Vc9Ne1KVe+9nU/dXl0H2gieleTg4gJIZ6hSwe6cX+p0LN7EcgBlRkuVVnv2PmoEPZn4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5008
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 12:44:43PM +0100, Russell King (Oracle) wrote:
> Rather than using put_device(&mdiodev->dev), use the proper interface
> provided to dispose of the mdiodev - that being mdio_device_free().
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> This change is independent of the series I posted changing the lynx
> PCS - since we're only subsituting an explicit put_device() for the
> right interface in this driver, and this driver is not touched by
> that series.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


