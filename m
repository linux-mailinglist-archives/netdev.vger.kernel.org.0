Return-Path: <netdev+bounces-710-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A5FB6F9302
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 18:07:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B060281194
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 16:07:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ADF58BF4;
	Sat,  6 May 2023 16:06:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4C01C13
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 16:06:58 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20721.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::721])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22AE31FE2;
	Sat,  6 May 2023 09:06:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mNklek/mZqBnR85uGswE7+2GAciVxim4VxLvyGWJXI1gxTzJZ59u36FdaVKh3czaeTnD6Ns6nN+J+mpyzoUSIKZu/D6TnSMAr7PJsCbv6UTZYiCIUFGJiPRZvQP/a4YDajJqFXND42mCAByDprSvKrUl6kqhEQ9hywEHf7cqcjsfhtNdd+picqMQ3GKXND3z2SfoLIUEAOCDI2pWYu3YrfPBZq2kyJq4hadStz3SMCdIwdoICjTXKf33BGRjU1ZHGjjcGJ/VLCtGBTdZp29jHmnxsVgTbEOhzmmDGspapEgfP+C8oi968z6lsrEhK3G/mNO2HgEQI3hyKkEc2J7OxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AmCdnQKtmlCvmgIi8T85UQNx1TIZ0RcSdIxnQutjkCQ=;
 b=nzVeILdGekizG8osTCkljW1IHLSe0Axt5mY6isH/dVnXqZTlMCLeIDl/dXzmbV90c+drffl6F4kpJlrimwKvksiwA+BWbH6RJ6xexA32GzSqc2UKaPW8Z92jksChrYaJyel/EKTLEO0ACo0eXEyM3nj0WBJTdKpcYQdim3cOI9CB+36oKAKO054Lb+2iCmkRUHPabQ2pV3AiPCon/iimhV3eY83gtE9SYe1Ti/kFk/q5kod72J1A8dWy7zCNityQKyuVxb6OvjJDH8P05BGmvLUelua+zb4WGb6WTyUjtIFGj3No4r8XRRspMAknDIz52s69/Gkan2345SQtmyV+HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmCdnQKtmlCvmgIi8T85UQNx1TIZ0RcSdIxnQutjkCQ=;
 b=Dk4VGllosibQ+ftonfKBAFX8X2M8Ef2vmmXD9CuoLNXiCy6GNdb9a7vpys1zLg7l0oy7DJD48ccZw6XxMYfojPDgBXRN9FYHsEI6PTPpj7vpKLNRbqD/Un60QJc0j8jyNzqOsb9AWUWu3odZQAO/Ao/KP2Deaq3Qjsw+mm4qcpk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4545.namprd13.prod.outlook.com (2603:10b6:208:17d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Sat, 6 May
 2023 16:06:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.029; Sat, 6 May 2023
 16:06:53 +0000
Date: Sat, 6 May 2023 18:06:42 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
	Ganapathi Bhat <ganapathi017@gmail.com>,
	Sharvari Harisangam <sharvari.harisangam@nxp.com>,
	Xinming Hu <huxinming820@gmail.com>, Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	chunfan chen <jeffc@marvell.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH wireless] mwifiex: Fix the size of a memory allocation in
 mwifiex_ret_802_11_scan()
Message-ID: <ZFZ7Emy9VMYK33za@corigine.com>
References: <7a6074fb056d2181e058a3cc6048d8155c20aec7.1683371982.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a6074fb056d2181e058a3cc6048d8155c20aec7.1683371982.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: AM0PR02CA0196.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4545:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e8fc75c-e7ea-4f46-d50e-08db4e4be81d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4pWdyLRVD/wRDGWpzo2KSTkchC03gOsPh3G+He/KVkTY3Gy57HeMxE2lG65WpMNK76/+A7QI7Tf8LAsI1DRbGZy+q/k3SljQPWa+4S2w/ByIBnMDuB6+q/sUyFe+0k+qnSOeEtVCIaeuge+qyqaFIrWZikFf74ompqdtCufiFOejt5bnUPBQYY0WDRgtergc7OzAwFayF8/ZHV3l+ynPfmxux6QMX+SMr+g4xLtf7mU8yGMKt2fEOyh3BF7lbDAvqqOO1dSeufuQYJozwPUeCiAT23ZXoZ7tCiP6T72ayjcSJoEeuakXxADW+SDg4SqMYECdguSEIOAG+nDB/KMU2NMMvmnH9TzNjr211w9PeaeSTCLQUgh/G9pqzy+GNtUE1M8Qn3FI2/UXuc03OMA28Tw1xxisnqpFjANtRbKBYau9mdqz8XXWSuYIrk65ongXFdeNCXXWywqVhcP+xNK/8phmNr6CIPP3SFvuV6WW2LXmZKb0UeAleQ+LQG9NfkLyKguH0nYtMXEt6+iCqAhElN5QUYLRK1v+eMLpncVEMgVUY8mhk1lEtnWtJNHo6my/hoV0HB1kPCrhMISvNwNKYxjdZQdrFpSu1d6IFovrTxQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(39830400003)(366004)(376002)(451199021)(6506007)(6666004)(5660300002)(186003)(2616005)(86362001)(6512007)(83380400001)(6486002)(41300700001)(54906003)(36756003)(478600001)(8936002)(8676002)(316002)(44832011)(2906002)(4744005)(38100700002)(66946007)(6916009)(66476007)(7416002)(66556008)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r8Bxy6fA0RVsFgE1/cMUxAwVQvjghfv1L/1IZx2FbQ2eUFG5Q6FwQdHSYfVY?=
 =?us-ascii?Q?3RWLDoeEmKDlRZK+QoSFMChpEoJ1RLcQTwTfGXAF1u63tYSX9ztyBA4GL/uM?=
 =?us-ascii?Q?UErlT//yacjOqm9Q0xLpJ0Tpc6OEr6y+vZ5bk+b3PCUL5XVS/rfKuB94b814?=
 =?us-ascii?Q?TOyaa7w0VUgily+aMg4QEjF0mbJ4O1FIHddTe7i9KgFmscON5CzvWAXq/ZxT?=
 =?us-ascii?Q?FS06Da+AytiOC7F9TOy6F65+rWmjC63Shr1RoFzB3pOgpslVzK2B1bqfPxDq?=
 =?us-ascii?Q?VHZZEtWQXnbcPzGLADCgfAxrf/mci+N24VKnMCFiKWPi9j7UozhU2xXv746g?=
 =?us-ascii?Q?4483Cz4n+ymwBSIemkEi6LYZjRjghE1bFXmuPsaUm0Wkxu+fu3HAsOTUY1E4?=
 =?us-ascii?Q?ZyPuoLx/7QZPfEvkX81blNnLUEejFwwgw4zabSfPG2tfLRLNJXhDvUrlztPY?=
 =?us-ascii?Q?l11rDWZVyNbLwW/Y9pSPl1bWJxfwSZ1677TuhbVqnMrwMa3jSuKQkjj/AyKm?=
 =?us-ascii?Q?sADQ5KahoRfXJ4UshtoKQydEAIspnPGdpUuz/qmbFMx/JxNHNKzs5ZpR5rr+?=
 =?us-ascii?Q?ym43qGzKtQuix1H7b5a1gonendmN9YMtm3cIMdReEvQAOjr9kzl8Xq0L2+nO?=
 =?us-ascii?Q?tvWnpX2Y59sHpNAa+5iYblRGDOHFtJjmcIdCe26VmhKw89aRSh72g1os5ZXb?=
 =?us-ascii?Q?Rp9eCbLIB5/pL8oWyjWfNVn440nfQ8fO9meulfX5a9mXLpJDv+xu5iv6rP/y?=
 =?us-ascii?Q?+Ek0YoGCNXFCZp0DP80uuqWA5dk0hOVU9oc617+oWzt5QUMsUAp4lBiLkgcR?=
 =?us-ascii?Q?Jr+A5zFVJ4NSz8d49CFHtdrKrzCKkXMDeoCYZg3KNnUFAJXpvu6N8wtX6rIg?=
 =?us-ascii?Q?2SbAIr1OvtyXnpsB+vR7NkjNp/e62Wc5Sy91cAZAjxOmpZso5h25WmVdhgKa?=
 =?us-ascii?Q?PR6X/6PhA0LJRcOLcDhZk/63DVobMdzgFznGk9BhKp4rlsWv9SX9OACGiSEU?=
 =?us-ascii?Q?RIb27EueBrFgWTxHMOyhLzNoLe99tNa1T33Td7xzKqjgFSxSkcUxneLJe4HX?=
 =?us-ascii?Q?8aOaLAxKfeR1yAd/Sngfk0c7wLqKV0yrRC+jSyG0DIBHLY7/dzGS1/jyzPsO?=
 =?us-ascii?Q?/g7pxfCpOvdi0upNJKm+lfpORaISwvczbJVQwblJGQ6LAWAcczWLJBVFRtAA?=
 =?us-ascii?Q?talPKeRWtiEChgZH/xMtSKme0LjaLvlib6lj5hT8emxUArr3yBzKvQpPd6Cb?=
 =?us-ascii?Q?I1NNr+bo9eD0cSxbhgV8FZbECMYe6f0Oypn5rs3/52CQlc+9GJJ8jYp678vD?=
 =?us-ascii?Q?ctPOLBFU+wvikxVzjKXDMD1HX7ECEjNL3z5hPfMaP0BTs4FeYxXnQVdwW+up?=
 =?us-ascii?Q?w6gYuC29d8WGDCEBf1XQaC5u7Sb7eWOLoAFyys3mWkKKs1qaXf3IEoIOMQK+?=
 =?us-ascii?Q?HzdGkJtuDIb9X8Qm1C47zHgV+rrqixyZzqP3TaT3MhE5lfieX7l/YmJS1RtZ?=
 =?us-ascii?Q?M+nSpl6AVzWpMLlfaCZEYRGWtp86i5m6VgbLOmcqbnBBdAZfDnDwrvO5+DDX?=
 =?us-ascii?Q?vH5PXft7UC9L55BegyH557QFOGIBB43gNG+bRmsB5NT45Yo6snBFqlB/ZdRM?=
 =?us-ascii?Q?hW2RuVzO2PhjR4qckdQuPv3wXs/TCp+Ir4nLxuif6EcSSktq6uXE7GTmOV+/?=
 =?us-ascii?Q?ErKNJw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e8fc75c-e7ea-4f46-d50e-08db4e4be81d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2023 16:06:53.1780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qh5KjGr/5aKwR0bcv5tmkns+x1vS8MUF+FvHA/q426j9CQoy2oWYcfDmEYMQshdTqKOmTyHD7ShxzJkkUaBHExaamXhcnLMxZa+nilzpQ4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4545
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 06, 2023 at 03:53:15PM +0200, Christophe JAILLET wrote:
> The type of "mwifiex_adapter->nd_info" is "struct cfg80211_wowlan_nd_info",
> not "struct cfg80211_wowlan_nd_match".
> 
> Use struct_size() to ease the computation of the needed size.
> 
> The current code over-allocates some memory, so is safe.
> But it wastes 32 bytes.
> 
> Fixes: 7d7f07d8c5d3 ("mwifiex: add wowlan net-detect support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


