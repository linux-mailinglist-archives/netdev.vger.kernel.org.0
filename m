Return-Path: <netdev+bounces-5278-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6336A710856
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:09:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 256031C20E4D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB51CD52B;
	Thu, 25 May 2023 09:09:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5932CAB
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:09:05 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2127.outbound.protection.outlook.com [40.107.244.127])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0E41BF;
	Thu, 25 May 2023 02:09:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QpRpEx3b2IhA4oZxsYWvTnJr8tT93TK7sq4CcTHNJQVTmQqAlsneh58gSRF7CJpDFRqdMyUkArPem1iv6clcDuT+VDke3RttiZsVuSpEMWM4xAAmgsnBOR8yXlQQ27SryuTfJFLehbZNus4oFX1xzknHUsgYvbfoggNiIpgafNpQTjPT6wdCdU3ZV2VNrC+RrD7z7q7pZX4EaL6h6T5aVSH2Or7nuMC52Mcc6gZ54Rrhw9wrYzJONx6r1UmIjmR0idPG7lifM9jA/a6JLstak+8743Sb4uSJsF0hGiHZHotFkMJbtQjVDci5NSoucy5Dn2atEkNqJV9ze+QU0XrqiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oc8JL48d8ZYOAU2NjIC5BhLNgu/N2aRtstpHyAK/1Xc=;
 b=D85qhQFOZe05QqoO5ZaLbs+wJTy/4bsVAuKQID+QrqEBWeuN+VelTm/uKBAHCkQ2L4FA2HOoMME/BYsLdiaiy4K2cDSpA5Jdiu/cp86wsQzn2TaCbfutGLUMfURYY+tkYQv7H6BW8i1lEnPtKXAQyD4Gew34Y9m87x8nJZaOI8tt+GzmoJ/hrAuh/Rdsp22ypG2kZdR/6aUExQSWeCLlIVEMDdXgq4SQw3KKAh5bAV6Z57QlIDIab+dfutv66sWg8EzfOmjYYE6Rbuz2JgzNYO6fggRcvQuMOXVcuxVBR/Gt2MGbgJavhDa4yhHZbvcXVh7waXgxqrj4DMBSi1nm1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oc8JL48d8ZYOAU2NjIC5BhLNgu/N2aRtstpHyAK/1Xc=;
 b=ZGE6LfrtJ1V2cPTee/oVGTr3Z7FccTBosizKT1khpb7vyp/sbttmuJe7w1+wxmB4NVXoZq7369lXOWtbihNGtVFui3bX3V3iTES+Iw6Kxig14TEKTwypyQ4LorXRuOUWke9vfUBaBBjKwfTMOW2LnKKS1kxDHZBHQl855yydPek=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by CH0PR13MB5097.namprd13.prod.outlook.com (2603:10b6:610:ec::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14; Thu, 25 May
 2023 09:08:59 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7%7]) with mapi id 15.20.6411.029; Thu, 25 May 2023
 09:08:59 +0000
Date: Thu, 25 May 2023 11:08:52 +0200
From: Simon Horman <simon.horman@corigine.com>
To: wei.fang@nxp.com
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, shenwei.wang@nxp.com, xiaoning.wang@nxp.com,
	netdev@vger.kernel.org, linux-imx@nxp.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: fec: remove last_bdp from
 fec_enet_txq_xmit_frame()
Message-ID: <ZG8lpJvFnZlA3w2q@corigine.com>
References: <20230525083824.526627-1-wei.fang@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525083824.526627-1-wei.fang@nxp.com>
X-ClientProxiedBy: AM0PR03CA0002.eurprd03.prod.outlook.com
 (2603:10a6:208:14::15) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|CH0PR13MB5097:EE_
X-MS-Office365-Filtering-Correlation-Id: 412eda92-8fee-4b40-ae25-08db5cffac8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	N+agc/xs2U/ws+F0ll5r1aQOlkqW29j9e0uSW+RDEr0sIDmkRf2bx6URM3m0BzoBMMtPtFhxg0OOdE4X5WH++VxpdX6Bm/z0BEWFRGTcwA9CR7ifikdABj55HGUnd00TefQuZwMRbPMorH1+Loc+zbfD1J5X4nRsETYwdqYCqC8PwYVmcCdbu6JIBbaMhbYXR5tj7NWVXk5cFr+zvDiCQ3ymBTUIGq5XOaTO0c00z4FIC/6Hfyvy64Bb1m5jOB9pI0AVI6mzQ8ZaBrH9gCIe9k/lpSGzalqzhOqW6B5/Mqib7EMutL+JNPkEJNsGgdHH65FO0Mybr4sBjtbhZSW/HAKf9ZwPHF0KQ10RJwWs/HY5p5fvbgfkuQ+z25NM7qWEbtRP96HH+58ny86HWnAiC91XEHqGmVxC/l1OjrcHTNWprfsKX5Tb8aIVdChwiK09f8M/F7V8i1ARBn+EHsnLCL6h9MBNaf9i1f4E9YSX1lxNgA+BkTydF8shpANLjrOzUbPAISBzGoZy7cGAqgk65guez/qqaocz2keGHJuhjjz3fAsTUq8oORhEu2dSW4JV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(39840400004)(376002)(366004)(451199021)(186003)(4744005)(66556008)(2906002)(6916009)(66476007)(316002)(41300700001)(66946007)(6666004)(478600001)(6486002)(2616005)(4326008)(7416002)(44832011)(5660300002)(6512007)(6506007)(8936002)(8676002)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z+IvTaqmm9sSA8Ibb1+m+uyxRLw+KjJOht8YdbwYViasNp2TG2Qds3QszYua?=
 =?us-ascii?Q?qbNLMWqaG9dfAnhtKhWQu2g/p9QdAV0cQqgUPAFma0xT7yQ2VPgevni9y7Sq?=
 =?us-ascii?Q?tY7MuSK3CrG28LwDYxS+CP4H0bu9Zm+80lbaOtMhvPxqnU6HNroBVcng6d4j?=
 =?us-ascii?Q?yBjZbbYGOcuL+/dd0BA/Uoo7FlotfxORcUrleFJ7lkI6P0rQXae/lfTmOXfb?=
 =?us-ascii?Q?FXb4V/AixeXI+PZ8mTkXe5Pf781zue4AVz4DxR6QZVnGBRw23GFc9fWhbs6J?=
 =?us-ascii?Q?vxUJihLgabIRSsqeOrr9PXnLb4ZjUIe2hmHiYKlN1Kb4U0TKcTHhQcVPbAjf?=
 =?us-ascii?Q?hllPHObPr3Qf+kZ46yR/UvLmDoyfDyXyLvlBlVPHHdDg8mnWjMJsqbO7pVsx?=
 =?us-ascii?Q?Xdv4eLy7Jq48NOpXoeGE1xNyZLQgfPPNoky9dxdayjnfpu1ifjDny6BoODK1?=
 =?us-ascii?Q?rzxetE7l8dCtnAbSIH8nuVpT67i4FuccUjq33Av6sbinK8yLn7iv8b4Wn21s?=
 =?us-ascii?Q?/+pgsqdMUsuNaL8FlkHodYqUVJHtTKlVVb6Cd3ZkCPFPaUEYnW7y2IP7gX0q?=
 =?us-ascii?Q?oqm77AdEMInCdY+sdqFyW81EUnaFkdEAhMdWK5mGNLKu9+ihrOI80JbE9OC4?=
 =?us-ascii?Q?NJ9gXEVuAjPWcipQz4FIK+eV82JUcD/3/0zcGPc+apNgI5c07Lvqzv0xN9V5?=
 =?us-ascii?Q?9RKrorstvPhT/0w1cB9QeFmvYrHk4zr/1CDEKSLHMrxg84gWY9poN6lQ3B79?=
 =?us-ascii?Q?d4S+U8XXuVsf0kfAbi6dBFEy3QqfzdnP7Ve7nInMVA829zfsQMCA+sEywogb?=
 =?us-ascii?Q?5wQnq20wjYRf0I8dG+28Z9/O3nIKayd7pH/HywmqzYfxN4eoJ7ueiV5GHu2B?=
 =?us-ascii?Q?LRyfM3gLFg70oXWoYNOW/oXNrfsFRCOvXv3GabH3XBkZj9ASARozAW3/Q+Ek?=
 =?us-ascii?Q?lpRBl5i2zzoIK7CfNN+69jOv+k43ZrEpzVl/AeSOiEBe1iU2oyEB3+JV5XMO?=
 =?us-ascii?Q?cxwL+NP9cJFGRSRVKgwjB+v4U6J7p3pmJm3VPElsUy62S9akmNsUZC+9MNzW?=
 =?us-ascii?Q?xq4tRr2J9VZ971zOhQRZ+qkn1BmU72I7T6wwSHQqSHTOaQtNwTMATUvlrycj?=
 =?us-ascii?Q?GiEuBRH0RTDmzl7uA2ZozeX5gxa/81+13LAjkqLWykKZguuNrPDlPK+EVmtm?=
 =?us-ascii?Q?SXfDT/jmEXGvgJFIgsyfvXm14ocG375jRtuJop2T7fBSLIj1Mu/9hz7+wnu0?=
 =?us-ascii?Q?TBvw6ItkNqw7OAj+MRIymtdpHVQn3P3WxqK2/7no8MNa+y4/cP+0HZU2zeCn?=
 =?us-ascii?Q?6rYPyEjCE57iloOfBW2dZuT9W/uBcyYpy/li1ysYMMxS2lp0oTf4OWD1lVIh?=
 =?us-ascii?Q?XXugHZ0KKpVkbRgULo5rf8fNeY/iIq4Xov+W5e6w4Pd0DXf4Spm/655FOzq7?=
 =?us-ascii?Q?yjZvtar33Tyeh7h5Sc02X2oFbv0fr3Y4CC58d7sxlyte4scXhj+U19m81TrK?=
 =?us-ascii?Q?LkMW9NZgZ2e8gpAd1U5dOEaaMP+/zo1X56TCgrV7Zj/mKrtekqrO6a8Dg2tV?=
 =?us-ascii?Q?4B2AJRwvuqks7CcN+PUKu5mUlOHWvBPP0/iHk564dFl2TbyXjP0FEXtCOCgH?=
 =?us-ascii?Q?Pi2Zd0fjuH9J7P/nTD6bAKhmDFCuUDH05bnt4X+eOroT2fpl1/2ATasgAqTA?=
 =?us-ascii?Q?B7XOfA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 412eda92-8fee-4b40-ae25-08db5cffac8c
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 09:08:58.7850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pd6/w36dpnejak8MgGs51kpgYpuAe14PJKBDyPnnEApJSn2hyDN0vBNsIBRxwdo/i6opsEn4BibKHa7Jhl7l3rWApaf+Xs2X3PCokgocG5w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5097
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 04:38:24PM +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> Actually, the last_bdp is useless in fec_enet_txq_xmit_frame(),
> so remove it.

I think it would be useful to describe why it is useless.

F.e. because it is set to bdp, which doesn't change,
so bdp can be used directly instead.

> Signed-off-by: Wei Fang <wei.fang@nxp.com>

-- 
pw-bot: cr


