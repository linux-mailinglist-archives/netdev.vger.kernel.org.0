Return-Path: <netdev+bounces-7892-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 947FA721FBB
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:38:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BDEE281225
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7315811C8A;
	Mon,  5 Jun 2023 07:38:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5092AAD44
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:38:12 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2105.outbound.protection.outlook.com [40.107.93.105])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB247AD;
	Mon,  5 Jun 2023 00:38:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9+y1Za3dTYTTG9xje5hUX2w2wVv4JfgAzAiGzLaWPe19xyWS3QlIHRvpvjldosn51WZw9bSYGlyIEb2YMUoaSMYRA88oUCQaO8snhShJKRz73KA48y0pGgSBcRf6Qhn1LQQR+y+0Bx+Ze0dXBk0AVCT9XUuJmc80Nr6QZGs+L8kufkL7PrVVMv7b9AtmSJkV8Xm3NO3zYkqdQtW6xr/UTBWnaxd+1RXxA2rqzKoaEjuSlW9hGLkWHx+CY+3Ns8l+lLzyjAWf3FGri/phVpKGx5EF2iXALesXdVzzFcqPcTehe4O0dpPuZ94y/LHUeLu1P24yob8zwehnhhBzzJIvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OMK+mzETodHOF/cP+ER3kzhCmvSG/Xl90/bljeKSDoU=;
 b=KjU/obc1TeWBR6oljE5DNaEw2exaqoXBYkM9+l/gLnQItui7UXG0vUu+U3AmiUSOzEqMHjTeqsGVgbFoZ8RTPwxEuR89Pwzli8VdZcWLzRB3SnSqkcNVzWHUEepVQCKYoZ7Dsk96LGkwyubuTI9UQFUKJxfIMb06Pc8z79cgJdPjp1K1BhNPw4b3jalvYKuB6Cx0U9i8AzK59EOYc0EsHCMPhL5FvWv+h9AGBThl6dhVB8C0NL0257zpsoUB3DVuPl3lDDy0rRRzXrPL1b14LvEMLcBYNMLJS1A7z5AnLK9PobIEK6WXC63m6gKB5w/+pduSL1PWNtn6mzXMJAv2/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OMK+mzETodHOF/cP+ER3kzhCmvSG/Xl90/bljeKSDoU=;
 b=L8R0nZhQiusP2mbLWFPJKdfZhbc4yvtbQnZ+TVE7KHy77scDyDNAAdHsvqdZezeKMA9e6ttUyTjdYJ2h/SsLET6QyTf59CFy4hznOe0w9HCQ9mbOAsO0KFh8UljemLCKBf9boPj0e4t7hf/dtAt7Usn2rEAvvn+Btxs1qx/+CRs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4412.namprd13.prod.outlook.com (2603:10b6:610:61::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 07:38:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 07:38:07 +0000
Date: Mon, 5 Jun 2023 09:37:58 +0200
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
Subject: Re: [PATCH net-next v4 2/4] net: ethernet: altera-tse: Convert to
 mdio-regmap and use PCS Lynx
Message-ID: <ZH2Q1jDygRUdeAkJ@corigine.com>
References: <20230601141454.67858-1-maxime.chevallier@bootlin.com>
 <20230601141454.67858-3-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601141454.67858-3-maxime.chevallier@bootlin.com>
X-ClientProxiedBy: AM0PR03CA0080.eurprd03.prod.outlook.com
 (2603:10a6:208:69::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: d899c693-2882-4a64-d579-08db6597cdbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	LzEmECfrA60hxAjgnJ+E0Ju26vChuihJ7e8FhBcxyu2M58sTx0zFwZ+tHwLBKFKHHnrtYN8zOFbl1r76a/dxVdoL/NKbxQQXJDkDW01dsiGXRzSwVX/q8u/OAkty5zSwKexSvS04dwt8rEZnR+cd6Lp17SzgUmnL+xFU3IcfHkXMDGkxXk0VoJkM54z9eXcWzOMyUE8ClL0FbahUkNHCUNtBK9Yl3KOXMdJVzVedJaZgiP3H5IGAn+1SmBTgjZW0C5ZN5sIhSnwZiGoB7G1Pf7nyhc23I0gECGG4ijy0IA5YC1njjhFESL5C7f+QOd7fSC6ZPWDAEH4ygDwtkAg7JN4WUea2MFOmwwqoUEHBLwY/09s830twiPQVpyY1WTFaMMSRoOJ/Rp+TexygTq6JRlMrBJvZuEzvrmnIs9Di5yGKJRjSfgptdJldqVLmFVxI4yXXKZw3NzHWdAZjuhdKBoM+feNU6wzdu+pTPoMvSXZmn4/VXX/LiZzUY/rdzRpx8Y74Tw/YtLVq9zbEyjhrM/IKWTX7QPi7LLD7jIsYsB3P/dO7j98T/V7LVsF+KD7d
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(376002)(39840400004)(346002)(451199021)(6486002)(6666004)(6506007)(6512007)(186003)(36756003)(2616005)(86362001)(38100700002)(44832011)(7416002)(54906003)(5660300002)(316002)(41300700001)(8936002)(8676002)(6916009)(4326008)(66946007)(66556008)(66476007)(478600001)(2906002)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VtFKnQdJcQ9EakjPx0ss+9TzdIjcNcQYcjud7F8vFGT1kLJTMDN5QKHVbvUn?=
 =?us-ascii?Q?BAkUlNGgu/k9r7PsKbqhE/mDXcSJQDg7bQYHqwVebzhJa2BsVcCPinzL2HBY?=
 =?us-ascii?Q?Wc1wV+e1/i1h9jq3h4/hozADX2Is2N/XT+6XYUGYqfhYOF5pVeRwJdQbq00Y?=
 =?us-ascii?Q?nzI4XM3hD+oADSsrQKKST4+j+3H2v41fBCaPLhyPGk+NlHisGaRVTj3q9zoJ?=
 =?us-ascii?Q?aVKlIsCJumD+/Z7+81c5ywGbV7D+4g3if5ff3LpoPJW5Psxz28lJT6P+RPjF?=
 =?us-ascii?Q?DuFnrnLiosjp4CQwUwY1mQunzcVQrrvpbtEfydDtHYRpGoLtks2pKelVEjib?=
 =?us-ascii?Q?UXdH7Bm3GrdxPa2gJL06E+fuEDuLfeTbof2xaf7821maV3R0bnU57ddZAdl7?=
 =?us-ascii?Q?1yRi6PcPPyVxvc5vP5zX8ImfQNv3dU7Wm5lGtMoXAr8yC/9LbpCqdjIw8So6?=
 =?us-ascii?Q?ExRVkIahuZNyRqo1cEjc0hqUC5DkolKppFsytAiYLDtfWDlTqamrBvmILaJS?=
 =?us-ascii?Q?QMGRvmwEhbhnmERGrlnTXeJzzdCBUFsPW5RylKS/GJsccxsN5otpspl14Zz4?=
 =?us-ascii?Q?BfWnnUM/mpGILECvelvtlQC+KmUXFf26w917kc+6Qt+MwVw+Cm9XxsJ0fJfT?=
 =?us-ascii?Q?mAGoXEYZGxxOUVpqbycWm/Q33GYfV+Zqd3Nv8sFNvWNEiFQmOsv2Vzf7NqX2?=
 =?us-ascii?Q?DHSnfeGAwuP8uJOJElFWUB1Vq1mO78YnWN1XaimSzPPSRQzNU5/KL6H9uRSe?=
 =?us-ascii?Q?kfBGha1P4RPeQ8o+DkpmxZfum1GIQGnnALlOOd3MYdCVKVoItG5ivRCnHqBd?=
 =?us-ascii?Q?vF/QoEmBXwjqhXQhess51OKQVKHtefAEK/8X4SpG0eGYW49WBFz8+ZywBNW7?=
 =?us-ascii?Q?MXGSAoxQ/R3S8W00JIkNJnWPS1+U774/lVKnqQAR7dDiuWnDuB5IS2BrvdhX?=
 =?us-ascii?Q?LKTW5qs/Q1sfvaEQQhluXOLapknFK//LyH6tz/Ck43YJrwY36Ok3Fgy1rxUv?=
 =?us-ascii?Q?j/2Rgi40tR+GCMLmTySSz2kx4l1Yq8MOGDI6CMOS9NlPbvi6sCylfaG1MwSu?=
 =?us-ascii?Q?F4OsCv9khqabnPVELEtaS0TlDB1aOCF3CkdDwxeSUlT3uzyUnkO2owSUoDgE?=
 =?us-ascii?Q?nQJ91IlDKczcFk/JUU1OXKro5eBv0BStFVdaKp7ftckTPqXES9AFNaWkM1rz?=
 =?us-ascii?Q?4xzdCQekG07VvmLTx4+o2dh3zFVehwtdFrEoFsKLx+lXdwBOIMCtnvC75Y6V?=
 =?us-ascii?Q?9FtMNmOI7E51KCjEFPi+zmBX1tIoQde13z0Bge08HJC3zeIzRNbyNCc81jdY?=
 =?us-ascii?Q?hp1oS6XOvsxThZWuTfD5ENAhxzTAm4P/ZBBwBmX7vFDIFTfqUy62RgsEg9dB?=
 =?us-ascii?Q?CXjydymJZ2/NYhwqhKbDmlPteK7oMcN7IGJmhedF9rUQ+vlQHqCfWHKrA2/E?=
 =?us-ascii?Q?58fVQ9u2xw5iOJHLawcNC4MbtrkxItlbbltIyRr6uZVoAXjD37I32nOu2ncu?=
 =?us-ascii?Q?rEYL5ebIhrgGHmVUhV7k7YxudiNBFqRfkzgUoUNdPFj49URAta1BclLc+lHW?=
 =?us-ascii?Q?522vna65mTkq3DB2iGuMzAD1z5rmE7xytEW199q2QGcQx296FUeD2MmVz67c?=
 =?us-ascii?Q?SOwG+qKCGeTyQJp4NFw7vIt5rDurYp/OPoVZJNc/2gkBcvVGRv6meDHO7dpv?=
 =?us-ascii?Q?ldWtVA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d899c693-2882-4a64-d579-08db6597cdbf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 07:38:07.0844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1yJ65oxJfDGrUshyd1sGv0aUgaYFh9zXmH5muFsqxxIWjjQ5mYEPnQ7Ej6iSvB40Sv9Tz8/5l9vpaec2RWZdXbtaIhXElFFv7Ma0LpyQf+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4412
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 04:14:52PM +0200, Maxime Chevallier wrote:
> The newly introduced regmap-based MDIO driver allows for an easy mapping
> of an mdiodevice onto the memory-mapped TSE PCS, which is actually a
> Lynx PCS.
> 
> Convert Altera TSE to use this PCS instead of the pcs-altera-tse, which
> is nothing more than a memory-mapped Lynx PCS.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


