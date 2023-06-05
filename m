Return-Path: <netdev+bounces-7893-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4340F721FC0
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:38:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1D28280F25
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F3BB11C83;
	Mon,  5 Jun 2023 07:38:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0181097C
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:38:32 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF0CBD;
	Mon,  5 Jun 2023 00:38:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YkSWEK5pWTb+O1Y8UarAMxLSPuYdPncpBomjI/Qcl4s7pAytEfQNCLqkdVFNuv7rWvKQqDTrmoHL9zxMXQREmL5XO+mTXBh20NjUleWgG5BmxvIocUDLV6vllBcBB7IYU+1a/N/Ggo22ci37457jXKF74na9zl09RQZLVjgZLK1cNZ0JrSoqCCpj2V4o1EVGuytFzp5Ly1YpmXIK1D9W51+fxD5padthG3CRp6M8lXwWS+2IHZCaZf3KQxTtHiYGFUa7UJkCagTayyozY8BYwDQT9MqLgXB+Z9RpYCpbSA5JKnzo+TZ3fO7CgrdF/7fu7sX+3d6XWgrUNAKpxdlC6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3bEqJH+KOLwGoBO2BzSwDUe9I4SXFv5QJHB8b1G3LP0=;
 b=b2ziI/l0x0+mnwU8xYfYhzko7MbKmCHJcVflxOIuy/wSKCQBA5wC9zXenSk6mxDKLEJBtvH7+GIPbj0f39uq0jBN+Fb4WaGbKKGJ6VZtKxIC4O0E1ninNC/JR62X+GwDsLhqG3qeYejXDsrqpxOIw+8S7iLVdtQsJTHVMSW3zIw1pGC09eaRnpTaKQqUC7w6uvZ6MAm9mtji8b7pMvWwNCBFt6JWKQ0ecNYrMsunaV8EWn5YXxvCK8Io84dnV6AImEXEp9Sy9STtHWGyKbJjQcJg7v/+BDOeuz5P6tSGjP3IqAW2Jh314q1ReQVPAD3dJO4oL460J3l26IRhr1/+7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3bEqJH+KOLwGoBO2BzSwDUe9I4SXFv5QJHB8b1G3LP0=;
 b=whQjG4BqHawmcWsnYwF7r/xL+goErQg4RkSaP83rWFUX6EgXpTr3EOk4cVWJ2u1+v6H8KrRJIp/+pfhopCWzevSioF7olfJOlODXtU86qOMjP2Fi7KcKsxckscPCYlY41Z1Vw0daaghsEW8zfnU+RZ60iXTn+UEiIJKdp0m/ntA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV8PR13MB6445.namprd13.prod.outlook.com (2603:10b6:408:185::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Mon, 5 Jun
 2023 07:38:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 07:38:27 +0000
Date: Mon, 5 Jun 2023 09:38:19 +0200
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
Subject: Re: [PATCH net-next v4 4/4] net: stmmac: dwmac-sogfpga: use the lynx
 pcs driver
Message-ID: <ZH2Q6//BSUKl8QbA@corigine.com>
References: <20230601141454.67858-1-maxime.chevallier@bootlin.com>
 <20230601141454.67858-5-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601141454.67858-5-maxime.chevallier@bootlin.com>
X-ClientProxiedBy: AM0PR02CA0110.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV8PR13MB6445:EE_
X-MS-Office365-Filtering-Correlation-Id: f304ee26-6de0-4e90-c9d6-08db6597d9ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QXs4Sp79oj4aG+0TDHqckOEBqSfflhngkwLH75zrpjGvaM6iuv12bjAiZIpApoEHyuaOI+18L9M2RRe6hCOyAyxSlEuXsYvk5j59LZYfP1VCgqAy/Hz4RXdGT8MbkmtbqDG16MItcnEa1/Hz8acZG8El1D1X9G6nu1F6gq8pA5tPu//L0tRSpmG7pccDv0zYs+vj+BUOBZodJ2IK1x4lJ5Wi0WiWjoQYMvvOA0pBbEaI00FRud15dkrKrHQYhsAV1ywztI+RJwV9AcorMn3R6sO+pJk+E8BoJcEqojbluat8EHgNTdR2T2iVoQ/mz2NLwNsHi7KjOSY6NmSh4n213DpdKsBxVN4JZelFRUQvIkJDABKmVtNVkvxUtCkvSrLtGTszRdbeT+RC6nYzNnpgwQffKwxVC5ugwF5gbDI/40ZKiVr6N/aRVsErfDV7cCSp62buQvJV55oZTbZef+Mdx2YyXqcyjeki9yjyshVECIRCJRU4BaQt+WluomG2W4vLfc+KNnDbo6UZ23NSDIjTikdIKnbzOhhaaWOXwn+W8KwQeDX5N8EZnZJqEztbgDFB
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(346002)(376002)(39840400004)(451199021)(6512007)(6506007)(36756003)(83380400001)(86362001)(38100700002)(186003)(2616005)(41300700001)(44832011)(54906003)(2906002)(4744005)(478600001)(66946007)(66476007)(66556008)(6916009)(4326008)(8936002)(8676002)(316002)(5660300002)(7416002)(6486002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ltdSXf4DfZnAM64g0/lWDG0W2AzsYX+4u0Z+N3KvBchtWt6uJAFLpv7t9355?=
 =?us-ascii?Q?KGXmH8kDdKjrN22H4HkAddnWG7ltqZDEvFNdKgkJOo6RJxID4t2FpbF5Q6fT?=
 =?us-ascii?Q?qHgI9C4qc7Oi/DhNIx6yNvcNiWIaNAPokPdgiDLurRl69nN0T8xw5ZnDJo0I?=
 =?us-ascii?Q?9YEBpUHMXtLEV6JDekt/g1H8b+zg25+PB6orJ7g3dY5B0ab5PNxbSuR/Qphb?=
 =?us-ascii?Q?7fQ5u73Mfy6J5NuwRGg74etwqD0l9K8peD23YXGK9sRS3rx7aXEj+AuGzNCA?=
 =?us-ascii?Q?KVrP0fx2D1IJkQosdRQHhxRtSh7UkAdXNiOCWZMglFHeJBLG5jREDZBCX5PV?=
 =?us-ascii?Q?enXhlV5P+TfYvG0MiDgqTmU1KIHIWLsJCf5ams4Edc6K+2m6rK+EAUh015L5?=
 =?us-ascii?Q?6jUa5iXySik/ffrpkGIyJZk7MNgz2r5PqVCOSiaweKVRGkUZAqfBOjN0Ioj7?=
 =?us-ascii?Q?Z/cCv/fBTelw/+Ah4otC/m6Jlw+AhffetXjLD4LYSJZPP7afpjC1feN3nnLz?=
 =?us-ascii?Q?rB2zPzcPrqv/FN2akr7n6ZrBLkcmIuOR/2ogOme1ExZeARJkVq3Qc0AbwfGh?=
 =?us-ascii?Q?wexcqu69qrRCgyn3Tb2F69cNqzcGbjhzi4X2Kco3DmFq9jX9yBdNx8KwBH5C?=
 =?us-ascii?Q?rLO/LGBY0urVHkTEEbg5Y60P1o98Xg5wIAMgFpa+Z1bPtC1jeWOd7lD9FSVK?=
 =?us-ascii?Q?RpprUjHQuTiHXL8r/+bxsNmbW1MYkLvz65o66QmEt4HAIQDGPYjbRy+3cZ4e?=
 =?us-ascii?Q?JKA6OcpGbqleUNEACF99qBRYH2p03lfl3BETytTHrDeg3Vj3lb2dJOXkgU2w?=
 =?us-ascii?Q?dAbY4kMCrJbIV640leny8Pxy407bmqnz5M7jJO12QH0dqJn+6tel1lhcpVa2?=
 =?us-ascii?Q?N63NZjtfF4F0lhdJPNrvMzG+TcBjETll+pAKPBfYW+8NmNQsHrncV6xqCNKp?=
 =?us-ascii?Q?mCKh85U/RqLTdzl1HlStTBQ/wK52yBF1c3anM3HdgYfgwnMkR6DAgsm2Xgxn?=
 =?us-ascii?Q?DKRmExqgw+7Yq3MivK9cXuIMGKvXeMs/SuY46qingtvNK9mzl1HAecRr7erq?=
 =?us-ascii?Q?qwfUuRvg0ayk+v+X3kRQuupB/G9jYxfVtFfU0PVdK1NdciMQckqDnWzL1HFr?=
 =?us-ascii?Q?d7tgTJmR4bEk8LYB550SP5b7Gkwba9/1uNK2fICyHAyD4Ded+3AUjj6YdNbW?=
 =?us-ascii?Q?5lo59P0VWgJgcd3dnrN0P1siz0za5p10itauPuGH2Dks/lVculh1k1nljc+8?=
 =?us-ascii?Q?HFMDC/qiMw47xkbMR8lxLUMR22Wv1JcoJ7OcaU1h+9xx+twuaQv0cyzpA4iO?=
 =?us-ascii?Q?MLpczCWenQIVT9/Eioqedyts/Fuy6SvHP4Y342H2Fa4Bv1edLEGUjxI2czfI?=
 =?us-ascii?Q?lNlb4OIcvHwg6o+5rj/PMa09XRtXF+EWabbDSmyhZ/v7L27wemowQ9tamR/9?=
 =?us-ascii?Q?N7D74zdnAGebXahCM96AERscSj/xbhQPQGXHe93cbkMnDhQrV4rn710L/kIV?=
 =?us-ascii?Q?AkgRXd6cb7tY6j6t9Oq0Tq2tvG/ZmCotvmECxgNFMSk0LiZdOWJSiND5pFtj?=
 =?us-ascii?Q?bNpfF+feMljKe9iBytVOJT42dEQQKACTEq4DW66f4YwGn0HdjFMKNLpzOJac?=
 =?us-ascii?Q?lBEWehfFaNkae7UzQD7b7r+OVTocKZWswaavmzlLy4MjP3wIjKY88lQ0zl6K?=
 =?us-ascii?Q?f6tnxg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f304ee26-6de0-4e90-c9d6-08db6597d9ed
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 07:38:27.6277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8CNKLePl40oP3iqBibp8CIXcceHkz4077+jOUpYitdyL1o/9ceyVpIdA/4FXb6EWpF3uk6ei2PNLj3LEo2ThNQZrqBHrLA26uyVIeUmj0xw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR13MB6445
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 04:14:54PM +0200, Maxime Chevallier wrote:
> dwmac_socfpga re-implements support for the TSE PCS, which is identical
> to the already existing TSE PCS, which in turn is the same as the Lynx
> PCS. Drop the existing TSE re-implemenation and use the Lynx PCS
> instead, relying on the regmap-mdio driver to translate MDIO accesses
> into mmio accesses.
> 
> Add a lynx_pcs reference in the stmmac's internal structure, and use
> .mac_select_pcs() to return the relevant PCS to be used.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


