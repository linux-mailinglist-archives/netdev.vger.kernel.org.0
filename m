Return-Path: <netdev+bounces-5565-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5084712279
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:43:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 705AA2816A1
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9B34AD30;
	Fri, 26 May 2023 08:43:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77F8525D
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:43:21 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2126.outbound.protection.outlook.com [40.107.237.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A121A2;
	Fri, 26 May 2023 01:43:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VENo7nGhBjWhLwzksuzWp+2m1BqqnmCHFV0CGyd7ZmV/d6nLIl8ipTqaIzHQ6m9NGiUJhIPraELIcHGT2QZoI2Q4RzDLlVC16RGydAiu2dw8caBSge8zNckfwU9Q8wxX9IylA91PnR0asHjAxUCUeOchrlmDPi0EYDk3UQ8NYlFM3SqGeErQPgV/TqIld66ZchAdb9xhkXdBHBcB0CBIUVb9VPyjYTu+kW+ALboXM+cHcxqmoGXUZaxVZXBojDc3i9yutxio3WlEmazQ0TcDOV0S0u4i/gUn8dJHPFCpo03YroiTtHV8sbjpGFZspW8U8x/7tnAAdvqyttHovo8ZiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KIAhRWsXaijvYtQ3fUhENNOCjvjiOW44FmxQkDjxSbw=;
 b=oY+7RAfJJaOEJpLxTV5JL221pEKqxm+TIfzxhzV4meDMIzF3PmkN4Wp2wmKGZHyCsru0BZztHvRTaNJ1mFqvjTZhJqUZzAEqIr9yB9eSEJXNhBrUAozTsk87tvwpMNWgidigAXlZ6U45mVv2HyzbWJuO3W9E/7/IwT7s8qO8N2kaWwEJ3Aa58xMzT3ib7YdLcB/rOnPqGDMNDj5DGJt71UJPVI7gOgeQWKxkYXoeIk9qATkVXHyL3YdegvLY+fCnRb9e1nIlUUUBWQQke+8cYHi/B/Ugjeq8mE2ewrAnIZEjAnr/gkenx2axY4lYta4FVbDgj3e1BnFhnCvawEmVSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KIAhRWsXaijvYtQ3fUhENNOCjvjiOW44FmxQkDjxSbw=;
 b=AOmUQ+gRTS5EbPl1lEWpeNkPbyVQMUUT/cvkJZxuNHcBEWBNzIUY5oKgO8O76A3wgC9FCN5pUwxPmmlFQuabC7xPjXGXcA1IbPSRMTs0k5SiJnr/d6GJv1A1UmiccO2r8yTd5ODXokq6bONbizGTvIi+0gL0ybhI/ZZhZVO67FA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4947.namprd13.prod.outlook.com (2603:10b6:a03:357::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Fri, 26 May
 2023 08:43:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:43:17 +0000
Date: Fri, 26 May 2023 10:43:11 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: Mark Brown <broonie@kernel.org>, davem@davemloft.net,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	alexis.lothore@bootlin.com, thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH net-next v3 3/4] net: pcs: Drop the TSE PCS driver
Message-ID: <ZHBxH/O/NtssUZTF@corigine.com>
References: <20230526074252.480200-1-maxime.chevallier@bootlin.com>
 <20230526074252.480200-4-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526074252.480200-4-maxime.chevallier@bootlin.com>
X-ClientProxiedBy: AS4PR09CA0030.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4947:EE_
X-MS-Office365-Filtering-Correlation-Id: fa8ec6b1-b4d9-4749-a9e4-08db5dc540a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6AnwnLQJJckqwmYzHKnH1Xn6OB9zTMPmOiuKU047SXev3NuyNO2VGtqqLV6+cR57I1uAtRcGzuwA/gbOi+ByFGaeLntIITP87tnuy6BoZ1DnvYtcKerNjUxOOMERauacQiYfrUysSeuC/v4tEzMd+hiOPquU39gSO+/4yapVw8S0my8UDowF0F6v2imvptUqV0d/vnts70tt8aXV5HTHeYMU6qrLLPHBo+W2ekNI3fJT5sBXDYOGAJ3ySdDPKKnGKRpKjaphEBFbfzOv26WUMS3+XY2Ltf8ea9L3ydpCib17gTT4PLk6Fpq1MJY7Sjzl5pYW02ugchUVKaVbzaZDcYQ/VDnTqtT2PQGqhx+kX4G6msIh0VkbGWk0eyvx+jjiJngkhQCdVmCZ3C2B8co7O9Za+GQFpDIia3waJiG4/UyPMNybI1uCNuCW8FDWYcFyO0BWjMAj7yms9eLaY80zxrY7PY4SptfLvvZcbrUx7L7nXRtAZ4PC7mkxD4TkQ/UJa66/FHSTI1QYQesG5BYL5YxnvxDik3sgK3VMp9UIayLkkmgVPnyzhjCuL429au86MR3wjwPB10sVbtm7FX9VJS7gGc4jnjwQKVETLWGhEzE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(376002)(136003)(396003)(346002)(451199021)(86362001)(41300700001)(6486002)(478600001)(316002)(6916009)(54906003)(66476007)(66946007)(6666004)(4326008)(66556008)(5660300002)(8936002)(8676002)(6512007)(38100700002)(44832011)(7416002)(4744005)(83380400001)(2906002)(2616005)(186003)(6506007)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jH80+6jbhE2o7t1uW2AUjxOiJEdgr81TGgUS2gOmJu9nt7Joyv0kHPUW85tk?=
 =?us-ascii?Q?+2oViPRzD0aC7GqX3RtuD6ShIPKOyPTt5/Mk/dk5xQJJoIu3LCt3WNz5bg+k?=
 =?us-ascii?Q?eISanLyYVbl4H9hC4tAvFiHgKf+xhDDYm+td3WObZqXEtRLzlQAtL+CeUqMX?=
 =?us-ascii?Q?ehgpvE7+ROMTleJoeFkQUmb67uqKRTKkpNe352fAvZZcavpT3e4kem3PoPix?=
 =?us-ascii?Q?Pw/VmNoPDoIZVDzIIW2x6vloqGOfGdX4c9YCGyzc0GnoqRUV7RBkjZLTmS/S?=
 =?us-ascii?Q?90Dy9DF3lKMaTLp4ZjWV0IgPuW/Vcey7jxDd0ThuJe4irVf0ubEKJB4u/2fu?=
 =?us-ascii?Q?KTeTFpsVjXpMgTlcYXMzMrMeeqLaXIpl2dPIUacxjbk36Au3Uc1W4JIIOi3l?=
 =?us-ascii?Q?vtph7TFsvj9E4IA6s+oEH97TrMUzElxEHhXuQ9kJgPEo8flGgNaho6eKewZi?=
 =?us-ascii?Q?Z1pT7h+RZG86zGm7IqJ0+oJTMJhR4a1i46vVDESX/TY4KsTrdtsAKRcykJP+?=
 =?us-ascii?Q?rNq9COFB8v8hiDfO31DJlrJ6768sAKaKLNy3/Sq3El2FOqelscNfjGMEbKQ0?=
 =?us-ascii?Q?fqRN+fdJpm07uQhVnCHOwTl0gubq8cRYGPX5bVYJ67orbyMnK4/tGR+qp6uC?=
 =?us-ascii?Q?AfFZbFNrcZviUt9WCD19Mc9rsQVOh+T7zCFmv/lAM2XAxD13+/EBgfGgBZ0B?=
 =?us-ascii?Q?EDtvthRo8p0dK0b50SvWbjpe5UOB0SRBllqRmJJ7ZtNQYyJDraXpr3XH07qE?=
 =?us-ascii?Q?l7wJk4hz7Uu57uqKKnwL7eNe/Yat4hB6jYMK/OjXXNmH8/XL9iNZZTHG1SmG?=
 =?us-ascii?Q?EM+GO9NAslrFyrDIL7+wnnYN6Lt8LxmEtY6dCzJCcyGC65uPNRv65nIEibw1?=
 =?us-ascii?Q?N5yKB4V8uK24fNPJVXtPyrF/rJHyVAhIUd0/L9/k6lweMkqmRK0ba+qz8eYM?=
 =?us-ascii?Q?nmR3W+EnJcdsMcfYWU1lpmf6J0ngnlIpb/Kq5Km6XnvxJiXipcDwDUrEC7ri?=
 =?us-ascii?Q?5wF5eP2hN2Z7toxmV/CKxD6hZKW7XYoBHtmiHsKXZmrRjwGIpCcO1v3aW0gs?=
 =?us-ascii?Q?dv85YRiROlgWFsKjVE3pgO8MaioweWXga7QOWKlOFlAiTsEo57aEKuPU+DnI?=
 =?us-ascii?Q?t8O/fzU0KZ5UucuV56HDoQITWvpD81jJSGzmHJB2wsBLNtgoURClQeJpDSC9?=
 =?us-ascii?Q?5Fu5WSd81skDWOTeicyQT0hla5aDb5etrcJ9GXVV9Sis/OFaO+lnqYOB0kYr?=
 =?us-ascii?Q?EYoyi0TqQ8rrPNg/Mqw8diCQviBaQahqrjJJriYcb93ZiIgAzt2zNiCKcv0Z?=
 =?us-ascii?Q?tnnG/lLI/tIBi1aixEuyIQJXCz2HHqDo02BJ0zJpeXVOyz2r8Yelvr0b9GcN?=
 =?us-ascii?Q?eEee1s4D5apvAwDup3wbx8ujX6qQBbAuh6RlkPeptxpYjqVQQr/inkmU5kpM?=
 =?us-ascii?Q?loUIHXrix/ez1W98njv0UACP+vu6bV2qlOZkCJDLp41sI+HFvbXY8MjUJfXo?=
 =?us-ascii?Q?6K2VfR0pUQ6D1lmnydZh+x3nT4b62Jt63bV4ntFfiQ2kk23jWwk8iDUYNQV1?=
 =?us-ascii?Q?hWi4jc/PZjBVex7SIN9oxmDCO4Db9blcj1ofcrXiJ2kvSyCX8KRPIR23Bwad?=
 =?us-ascii?Q?3XXeyNu18gxu6Z+5FHCo7/gulky+9aq4K9yrNNNzRE5pCfKvJqAbPgJCAWe9?=
 =?us-ascii?Q?8ArLjw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa8ec6b1-b4d9-4749-a9e4-08db5dc540a7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:43:17.8716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SDZeIiA5FFQMPtFL5NfI2uo5RtAHBxb9ErOwRJCWEo1xSJ3X2pFmvhxdoyclbihx2gWK1Nwp8oA93tuOlKJUGokSRJk/citYCeMstjWRgOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4947
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 09:42:51AM +0200, Maxime Chevallier wrote:
> Now that we can easily create a mdio-device that represents a
> memory-mapped device that exposes an MDIO-like register layout, we don't
> need the Altera TSE PCS anymore, since we can use the Lynx PCS instead.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> V2->V3 : No changes
> V1->V2 : No changes
> 
>  MAINTAINERS                      |   7 --
>  drivers/net/pcs/Kconfig          |   6 --
>  drivers/net/pcs/Makefile         |   1 -
>  drivers/net/pcs/pcs-altera-tse.c | 160 -------------------------------
>  include/linux/pcs-altera-tse.h   |  17 ----
>  5 files changed, 191 deletions(-)

Less is more.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


