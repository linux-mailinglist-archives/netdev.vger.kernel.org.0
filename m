Return-Path: <netdev+bounces-3725-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01D02708755
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 19:52:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08EE4281945
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:52:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AA0727709;
	Thu, 18 May 2023 17:52:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FBA24E86
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 17:52:12 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2094.outbound.protection.outlook.com [40.107.92.94])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB5EED;
	Thu, 18 May 2023 10:52:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXghUk9WRDEX9LZeZ++qyaTePKKFSpUzLblqQWr4eDOxOOtK2jtCzwJLMWxvcRuzuXHp10Q9gVrnQ7BB92y4Ylss6M4P78acp6VvAL1K/Ozzjuh2tFc4OIX8+FSPbCqzNNLZTkL8LIC5vLNmKahmfM7P5qH720GTfGkVyuxWuCTt6u0XHHRhiTVZIY70FUhf3DnD3jmxEX3NY0gx927g1yxvUvpYpNHJCbTuAcSojbZCzmpgro9jR4sN5Fzd14/hDXGhbEHBu31qqxE9vuNdPimYJf17BHy7vjYfcBj1XXqL36asAXJCyUmNItTiTlPoIXQDpFRbxzzUnrzKsKNh5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+S2pU4OqV8nO8czKIlE/qmmpG66UbBTt0nFBZXR2lMY=;
 b=WLj66stZBv+fp101nhsyNldYftUQC0pV16GTeZTuJDitkqmjHQMWIz/EjKt8VfUAPJf4ujuFlWHVdtMmAWbe0QZK6C7dk+KCE+820ph4JpA5OrVClK/S5qnaWPeNWun6WsEbpA9Z3dYYeHlOl4ezldwSNpg+nAdhtcRCLswA/uizoXCcdal7n9dSmaHsPk/IPm94Nk4yIqdAB8IGOTU9sqdLkAsnCFAskNw3jCxF/pw1fHWPZcSnAq1v9g3QFbkXRg9bsfLnLvGDX7oA0MDIUgJWan0Z2p2v8MjO0Z8brhiJZt9q+N+3Dng2XrI70REiGiHF+XsjNARY43ByYuRTow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+S2pU4OqV8nO8czKIlE/qmmpG66UbBTt0nFBZXR2lMY=;
 b=I5YfWrYf07kvJfV04KX6Az0+EV7Pb+jCFk+p1EzzGXyPnJ/SAddNuD/Whxeu8gRjiGTsEwXYT7xQIG/0wLHZtRXbfpXL2pdpbC+8MnPQSFWHGKFRjTctYQCxiO46Rz4tSiEOFe1yHTnro8u5ELkyoC7zYEU6OxQ4DlKmzlLlbuU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4978.namprd13.prod.outlook.com (2603:10b6:a03:36f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Thu, 18 May
 2023 17:52:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 17:52:07 +0000
Date: Thu, 18 May 2023 19:52:01 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] MAINTAINERS: add myself as maintainer for enetc
Message-ID: <ZGZlwT5Paj+vo3cN@corigine.com>
References: <20230518154146.856687-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518154146.856687-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM0PR01CA0176.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::45) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4978:EE_
X-MS-Office365-Filtering-Correlation-Id: ab5b7fe0-9f42-4284-e2ca-08db57c898f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	l8m9oBWSeJlGlFsvQLV7Go7N367z2UaG1Hahsa6tw3763Iu4B+U3R0fG39IyOIFzyEpFDh0vvV4s1EdpnU9XGSWa9II2OKPwF+CnU26z96RLBU/zj5gVzjojWoeYZNwXgge+z8P/99Xldwxch2ne5qiyFocDO1/Vj/Wm4hVW/pYwbnVrupXKrAlBiclk5sPYF94K2k8aI2yvJ+eQsNmfuMiGqYV2Ykx+m0EJHN9jXPplo6JQuNJyhLP5KFFOQ+9SVU6MXcOxiELxd51bzf7oHIG3EfIFUqyw3XYcQHIGKENUfdwafJe/ZBf38BmvEZiuLK0U7DBOtfUBPs/G0TbyHnRkoQzWSzgpo4nfObtd1IHCF+V+jsk8h0wL2H0uAgj6jRSllSvl2VrKGL9VDDvYMBCuKBBOiFvC4LDIRQmHTeJyrYX6p5T4TZkccNOZOSTPE23YrEeK3J1WyKQgEd061SI+TsTkR12Q++H9opOpRlHHE7XsNLZTOaC+hZOa+jj9Oj1UX/1DPZKpVDI7ywPtrEUL4N7N41xQmxc48wKueAqXHVSJkN2xpVygCrqLGn9wknTP4GoRu3qRrHPCaKxLDg0LYQVKllFpaTAvKPECgnk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(136003)(39840400004)(366004)(451199021)(5660300002)(41300700001)(4744005)(2906002)(36756003)(2616005)(86362001)(38100700002)(6512007)(6506007)(8936002)(44832011)(8676002)(186003)(6486002)(66556008)(66946007)(6666004)(66476007)(54906003)(478600001)(4326008)(6916009)(316002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y7FSwSlIZXBvXxZ6cBXzmsaBVdTeuyVIJwNbropi4Mj7Hmr/yJuDYprNdfVm?=
 =?us-ascii?Q?Ngi06jLFBnr2hdlSGeKAc1Y6z+ov9u8rGmR79qpns4N2GXNYHqdpv7Dc4Xnp?=
 =?us-ascii?Q?rcR8NZ3euiu4zQtakGOLaJ2srLq8PaGIeikBatIMr6WxoXGK7l8y3QaN8kb1?=
 =?us-ascii?Q?okIQ0WWxyPvueYD++HOTkvCy/5zN55ifuOQd+7w++bkKu2jTxzn1yCnkT2RA?=
 =?us-ascii?Q?rWm5V0NGUv3wtvdQZTttd2GesCnYb1OeCq3IygIrA7Spk2JBJ/cpV6MCZd+C?=
 =?us-ascii?Q?MEefGA5+KM0quQ3ERdT/zYRHjCNvWdcltdoRbC+LvOv2hetQZFcbAMckoREH?=
 =?us-ascii?Q?5+ybllAFFxC7bQCtoF9Q/wB1Hp6Ll+HU1iuGyXj56BqLWJTKdwmhazHSOpld?=
 =?us-ascii?Q?qsFpbjS22ro1n7SI+hDvLqCdJbemMPA2r1DYlAYPthAWh4DpkpyFd2pPP8RB?=
 =?us-ascii?Q?VEwESMEMiMPy0XvTeL+m6+KNC4YysOgzEvLiihc9iuDVM05h0FxojZP2IclI?=
 =?us-ascii?Q?xDC8Hx4qtbHnjuwWeLOnVDdjjrnTz/8FdbLkf8oS6c88ICksJNWC8EPOg3fJ?=
 =?us-ascii?Q?G+LeBOCmf84XidkQS0c5n/8SeHFzqCx0yLe8affCpAVUgSOK35Nce1p1jZqV?=
 =?us-ascii?Q?oDaYGgO5sf8buk5NSCvatnQ5xq/3h+X1wJvQhqcRWN44LQLJqEqNgh+x6Ues?=
 =?us-ascii?Q?JfF96aHvBVrNpVH2E9aijTNhHoQKRr0qEhcqUMNg38dEVpyV6J7TFGLvRqa4?=
 =?us-ascii?Q?AU94P0lKeSfC7+mtgmzLz18muM+YSWQHdKUtTPMA1dOGe9O0vF0qgdpZcxP0?=
 =?us-ascii?Q?PqHD90G7wTscWKI77f95k0TzrPzX7Z4x9WnJu1H0qsPda3KCNxH+4Cybed8z?=
 =?us-ascii?Q?eLn1R/YVDj8AtWjrQ8RJSwcYYRTtr2uvRi1Wr9C2AP7sS9vHD1m8kxGquiLT?=
 =?us-ascii?Q?GppiEozUhtxVOYgGW/JTQb0xATThMSl5wI2XWJMlfW0+43Zs9X/gXtXSM5YX?=
 =?us-ascii?Q?ALCLWNVR9IgVo9uCZpRsHo5GeTIvFJ7vhnV2Doxu7ysD/vI7FhZNgYB/P2ss?=
 =?us-ascii?Q?wTOJBY3AwohYiXiiKULNERCXd99Fk55UgjRwSG+ZGuP6WiGxPOsC1PemC5DV?=
 =?us-ascii?Q?maRBJNjuNyxGaK6HKLjc58j/Tu4NYagIsyCX7X93JFpK9FZfpEpCya+PLoxT?=
 =?us-ascii?Q?ME6ggqOYK8ihBOtVMuMSUk2228THEztgExcswDHexXyWX3qN/hUhGP+txTCj?=
 =?us-ascii?Q?9cap1whu1ek4HBExPoPBQP3O2VyWrjCczvFSErXvS1cFGKydYHYdiN82pHHl?=
 =?us-ascii?Q?aAliBW9VZvx0tbbhCRa68a4R42AI9aTegsw2U9hexfVnLfAFLqGk5646J214?=
 =?us-ascii?Q?j+McZd7hOCmhpK0CJErqHjIeE+nEXia39LvsfnK7y8lBmD4KGuXpTJbG2GeX?=
 =?us-ascii?Q?srnvahDobUN5cNstFqXCDAER4Z/Fz3Uk/mQJfPZgRsVHWNT+27ZGLrlJbO4/?=
 =?us-ascii?Q?L7T/kGa05ydNh4uaO0LV4y8yaiESQW+jhzNjrdLHOIkrvzOelgW3WSKLQAD3?=
 =?us-ascii?Q?N9EEqRgyiDQBIpDuoXKyVh2KTzAcrwzZxSGc91F2VJk7+UoOB+8gnTC81pLr?=
 =?us-ascii?Q?3QuC+O9Jc8QA7AxfdoWqVL4vtwmRiwZc76Qn3MsGpE45rc2M08zhkH9LIHJu?=
 =?us-ascii?Q?wUoXGg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab5b7fe0-9f42-4284-e2ca-08db57c898f2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 17:52:07.5813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0plRbX/jTkvzT19cL/ak+7TNAX/HGDu2X8VzRFRH0oi+TaIQQ/+3xIm+N6GFEyooOnbJkrRQzgmEoruKZewrWVqtL6N4XHwtXzcdY7TdA64=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4978
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 06:41:46PM +0300, Vladimir Oltean wrote:
> I would like to be copied on new patches submitted on this driver.
> I am relatively familiar with the code, having practically maintained
> it for a while.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

