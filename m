Return-Path: <netdev+bounces-942-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 773926FB6CC
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 21:38:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 610E51C209D5
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BCFE1119F;
	Mon,  8 May 2023 19:38:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E092101
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 19:38:52 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2123.outbound.protection.outlook.com [40.107.243.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D1C59E7;
	Mon,  8 May 2023 12:38:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MeSN7wdWA8GSlsyHAnB0Z/H6HNPYnrWpWiqRqT3Dba0u/fP45HwzJmZG4U3BP49HF+ywU130wAL9+6ftZVlp5ci2l2slbCy81AdabaqUyn8eQerKTyZGIgrB0rMTYL7TQs719IYqv9Vw9SW8kN+kaWS1auCGUHu0BdWhdLiw2WNletp+DMc9QhnqPbiboVQ5SQIE3owg6tQlUUeZWOJT3vDI/6woqovtp6++bieXolN5sYaKD4OctYsk+43mZuK+H9y99SUbcyHRk8r/k0mLFvZJN50zXa6/I+/zkQwGADMvOYrmExfOoRPCx4EPSOMcgxq9eLAz4PAgvXuZ0nmHLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XCj105DBMZJMcHWuI8klk8gQgMO6WYsLNnsGMx2SBCQ=;
 b=BBwoOq6q+RcqLAqWYqos2/Qlc5cs3mQFsRoU0eeKR7L4U+GmXnR2isiK7riwFr/gT3oKmUv8FuoiAiqMnL/VbqKgFjW/R2ojhRFRLfDSiNxa1P/hLDu4bnINDNrict9yfPoUTbAAzBIjYGaWwRAI28/KkMzHk50AKGhrtES6jRWAGMS41c4d8FKugwQTxIagVNEoJz9du16L16hN6P3oQ4/OqmbbkjIeCauewPPUfvcODZWVJR/dpD4a+1pCKyYMuygtvnMi1x42QH4iJjjhu95iEDpkJbXBdA9nvN7vtavHz9/S1KeCpjRz3ZzKxuovlu3TJscqk8e+1iqbTyn5Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCj105DBMZJMcHWuI8klk8gQgMO6WYsLNnsGMx2SBCQ=;
 b=Iy0Bl2VpLRCcqRPcqLspXLTCdT7d3yUYqbFZtOD9gK6rqa9AdF48M6qZJx/z3EjwUWsctuax/kivdFl+EiHEqX9fgEoX5zg9qaXYST/XsRdBsrsoH9z8tDbvAcEMQ51jSfJkrBu9l+GszJvcw9eXaes/fsF5ObcK3Z4EDNAf58E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by SA0PR13MB4046.namprd13.prod.outlook.com (2603:10b6:806:95::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 19:38:49 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7%7]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 19:38:49 +0000
Date: Mon, 8 May 2023 21:38:41 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Teoh Ji Sheng <ji.sheng.teoh@intel.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: stmmac: xgmac: add ethtool per-queue
 irq statistic support
Message-ID: <ZFlPwdx3lDwe6O2r@corigine.com>
References: <20230508144339.3014402-1-ji.sheng.teoh@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508144339.3014402-1-ji.sheng.teoh@intel.com>
X-ClientProxiedBy: AS4P251CA0026.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::15) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|SA0PR13MB4046:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fc19f63-dcdb-4d37-149c-08db4ffbd860
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	erjB13s5ZRdGeV/akX418EVLnJxnXhOEhGtuOfSsFj1ppqFFkmkcyYqBpfUQKj8AIDbV8RbldqkiqknZacnVIXe+K56CGvUtjhWnEsjTWvoewp4NIIRt8ahfuLu5aoBgkKapPCAtkupRjd9wTHJOE+eTbb2gwIxW9Wpky0aASWsTMulvBc8KeEOTl112qQt10TzfyL1GJdrYkbpktePTmLXiZyu5xrTuHqVOj2OikAbPHKONxWUsoj7b9FArMsmmzW8zpjWGS6EKeMmczAup/tOoVjMU4SJM7/LlG427hJjlwFIajIm8ZBZFxCfMXxraPi6jsDHG5xlG2wnbg2K08Ap6xS9j1Qnnkh+uzReq9fxo5C5DNE0btoGL9ZrnRZDf2UjFi/RW7KOulocDSqRShUWOvSdfgED6iMner8aavsenVGtTavBMs7UwO7S7yPPxtI+BmBfTOBIBClwGZxiuBymv/hfucbILbqktlL2KTOVF/iptHj404J5MQ4wj5PHetsDnmWdu+qJVxZiaWvY4hI9gkNxRYoZGAvpKVotZri69pxxQ3URhsx1Pn0SpfQEq
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(136003)(376002)(346002)(396003)(451199021)(4744005)(54906003)(2906002)(4326008)(8936002)(316002)(478600001)(66476007)(6916009)(5660300002)(66556008)(8676002)(41300700001)(6666004)(7416002)(44832011)(66946007)(6486002)(6512007)(6506007)(186003)(2616005)(36756003)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ShX4wom+HtamfeKuud1xeT8ZNRhEdbKI2LUjhnTnoty0asiVisXEvuMxGAl7?=
 =?us-ascii?Q?Y6ujQMr81vJbF7TwJNJvqWLzBwclbWggmxvWIlhE6tchiGkxPe8LVXuskgKw?=
 =?us-ascii?Q?SiEnxi49wTRWv7qT+EfQC3xFtMw+OYogcU859Qnxi30dUZDua+BFtskWpgU6?=
 =?us-ascii?Q?+8N6rmW2FssaPc3xv9pE+H5XJePSLALXAVkQzU+gE71bln1TojLFLXLxeX2r?=
 =?us-ascii?Q?9wexy3bjQKX/XRY0a0xsS5Gga0fNxzpdPam/tlhgVWztnPaFswg6n2fqs2/t?=
 =?us-ascii?Q?09omPdvXmOnp9fNJZGOm6v483zLtCGLGbGJSXA85HICUBdRmCCqUJ4xYv7v6?=
 =?us-ascii?Q?hpTrrlLpKhOcyvObYzsjfD8Vw+Hif099Ui/fWptjb3SOjmUbwe+3inRgmib7?=
 =?us-ascii?Q?S7uKf2ivwwfYkzTtBAjN++1NpdOFs89430pDbRttWUWL+pS4zlL+RYjuoyJp?=
 =?us-ascii?Q?XVBscyn2Sb/Ed/2Ze1aFL80q6oMqD3DvZMn5poEzbDYZksDyKLxIA9+sRaIX?=
 =?us-ascii?Q?uGteDVLa95A3fsnyzG8+n25hLDAqF9Diwo77sjzv3wtfjhJkMaRZOPB0sopu?=
 =?us-ascii?Q?JNKDSfnePY4bDqmYPXEP5EnTbSBbepKLQy90W5qKVFkw5SkEIkhcjDx4XNrh?=
 =?us-ascii?Q?L30ZxtZvWlj+NarC4G+gQ0YUsCcrhLWZWu+ycYscEsfsXIKBq7s0ecemmnmW?=
 =?us-ascii?Q?x1cQ6RGjTQbRqqzloLn+pomIHVXvEOQrqNiDU/CufE+C02n57PXH6eljlP+d?=
 =?us-ascii?Q?7OJTgnCHGgxUkGOmk7C57yTGZrJ5Dfbe8ZdSif0jXT5/H6XQYfqimQj1JJcB?=
 =?us-ascii?Q?iaK2ITCzFtJ0kDYAoCPnyGeoiYyjW9RNwtQlzN2es1J4meIw+V0rvjnvhNAF?=
 =?us-ascii?Q?ht79Nt0hnpZtG0Z3J11s0HzmJAvYlhkFgg4orWD82ncOL8/fYtu6XQLSz/M0?=
 =?us-ascii?Q?+VTIWiU3BEIp4OzIccQ+X5vPhdcQN2akPrUe08qfZ2mm/ABc0n8mfRhowXQp?=
 =?us-ascii?Q?w7WJon73qanrfcu7+yedcJ34oajRkSkhaqdgB/9gRKj5wAdS/kG6YSuzB2eU?=
 =?us-ascii?Q?hZax7wOXbeGmpFA+9C8NPJzps5vk8yxsSg0phcALNib60esnIZhhjUPLVc/6?=
 =?us-ascii?Q?cVKrwwA7PEZuBx3vtSSUow/Vz2qTRdSxkdurCAmWo5iDCg2mGfoIEIU+V/eo?=
 =?us-ascii?Q?uGYQiFnoG5uUFXnbxuztMZcN1UyxvSoz42JST59CLAPBne1wUKDuopDsDeZn?=
 =?us-ascii?Q?H6t8wlOcMaqTmrs3E50Ld0nYnqxwDtV6QP22RSXY2eYYK0/xTzHBLPbYeBAm?=
 =?us-ascii?Q?mrPxS4ANcWfoiTJE/F2Nh1ALmk8h0rg0/jkPd7G02CM2seNhjhR1+yDjHVNI?=
 =?us-ascii?Q?AgaNpMpkQTR1Azo+P666lROx7bY7qJIMFzP67cEpBWmFlq8Ud6V3/pmUMAQW?=
 =?us-ascii?Q?JvEYnRrtob4Hdv1VgTAcQH6m1lxBDYxewUeYxZbq4NkvU3eBStDn3Yeq/5YJ?=
 =?us-ascii?Q?26+X+dv7NRSF4P+EPYlM3A5+gjnZN2QwE8rxr7T8g7vYqXsEu9YDxcavaIeH?=
 =?us-ascii?Q?7cR3bPvDS02Ww/u0Z/s1VAiry3SSAuW7aJLFreYjhrJJdlHRGA3Jyf3WUTit?=
 =?us-ascii?Q?+DkGo/wQGXFEz9NFHSaHFTsunMvbOClDv36KioU35j49khlJIGbO2fBkugxH?=
 =?us-ascii?Q?vZENsQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fc19f63-dcdb-4d37-149c-08db4ffbd860
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 19:38:49.0621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9lzLTxVpcxZbSMG3dagJV0I+KBSA91vydwqJU8ha7gcfO5PHSktj7qbYvuzCvvaWwQWMnXKXOxgO0fuZUCTeSiMMVj8otYN+O6f7Tj4Z57k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4046
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 10:43:40PM +0800, Teoh Ji Sheng wrote:
> Commit af9bf70154eb ("net: stmmac: add ethtool per-queue irq statistic
> support") introduced ethtool per-queue statistics support to display
> number of interrupts generated by DMA tx and DMA rx for DWMAC4 core.
> This patch extend the support to XGMAC core.
> 
> Signed-off-by: Teoh Ji Sheng <ji.sheng.teoh@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


