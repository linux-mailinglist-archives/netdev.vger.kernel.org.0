Return-Path: <netdev+bounces-4936-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B4B5670F448
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:35:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5BB12812AE
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 10:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A65E83D63;
	Wed, 24 May 2023 10:35:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929401FB1
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 10:35:20 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351B0A3;
	Wed, 24 May 2023 03:35:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATMByAwUmTYSTxMaGEGe91rkLIs2fuXyJ/1WlIS307j8ICk1I2z/FdEeZi1rVTz7BPC01Byl9vsfsxphwPqjyGjVDleLzwJlfLWxF/JcAA5lgJdX8qUb+MjeuqLi8rtPpnfI5pwukZlWACKKsL6iJWZk8wNMTHrn3F+RdDjpdyyIOVkYZvLRir3A/9RMwNt9blCC9z/WZUEEeW/i0R3GngXd/z56dP3xDxmSh5/xScxE4WBaqBQs17cYzuANNnmPCEtq1JkDpbitvSCzBiqOY4UGStJ5gmINUNqpDIuz0mhnLjINb0apNhHKWq4V8d8Vj9by/2p3Qk1Bxu3yyo24Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mtU5KZnDQZwAS/wpJhWyTeH06dlDNtoAFN7Wz0pgxq0=;
 b=VMLsWytIB5UxBdpEcPrg0UF3SPiCUPofyo2kNDnTx5AkMyHXTeNlQ+suzQIfYgYHsphXcVQ/HFBIDhxRyRBE2HCiOIXHyzspMj56ZmOmd7A1sTTNkW3XJkVKuZmt+vnVyqeIw6sO+54TBEtOSXNO+LouV0QFRRdMK2LbqVmSZqweB0RKZgVhfHoH/1p+9WJrOltSoP1ZdhLLNbgBJB2ss1A4k7Q5mwsi6/OArmchjUb1Cyp//2qlXkFzwrp+GbXDuXugxBYfl7CQfVdBUwZKuRsF0OxUagJX/9ggZIjZ19BDtMy7ygrQUxBs8fPijper5xcjf3B/TqF4RfsceZLuRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtU5KZnDQZwAS/wpJhWyTeH06dlDNtoAFN7Wz0pgxq0=;
 b=fUw5i1gdjm6O45nWNZzOvxotlcmUQPZZ346RENTTX68alpW9zah2QQCEklEg9TE6vWXi6Bnh25rAZsnjm0lkvKZy7qldG3CzSL96/L5m8coS3uESB2KWpeKxDDh8zGDaEQcuCFtbhhuWoAQYwVOC8FPMdxWXCca5/gk0ltlqpkQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5277.namprd13.prod.outlook.com (2603:10b6:806:204::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Wed, 24 May
 2023 10:35:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 10:35:16 +0000
Date: Wed, 24 May 2023 12:34:50 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx4: Use bitmap_weight_and()
Message-ID: <ZG3oSvGumQRklkyO@corigine.com>
References: <a29c2348a062408bec45cee2601b2417310e5ea7.1684865809.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a29c2348a062408bec45cee2601b2417310e5ea7.1684865809.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: AM0PR06CA0097.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5277:EE_
X-MS-Office365-Filtering-Correlation-Id: 12f12473-51bd-47aa-2c36-08db5c42901c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RajsxcRTLInY0Ly7lwKROhGyRBKVfMMSKJxShIHW5pBAgioxjYwfwVbmAQeJ+l7FoGPvT1ekJQ4aQBG/UWZ9vk53lZ+WvYyrSyHoQSSczIR8mTRmRil/l9bhDejWYfijBI9RvOAQ4rOz7sna9AGTA7apqtZ4kRhTmPlrOA1aej9tU05YXa43NUyujiu4DMMsgiF493G7qCCKq8OBnMpc/mzHsALNN5+Wn+hVjyDjueQ1tWu97016gTfx+mOgYe1rtoFt2beoz9a/Un9C2/3w1QobMbYpghrF9IkMPK5+bc3O5rYbC9cPrpLQivwXBekxpFcAlPiNiLSCPvufSNG481IaC1KnoBgbZd8LQxcyTpwKzhipKY+QLsSaFvVfsTCzAAogpdpyBtJDPSy7BbS54N0/YkFrYmgCMvyRXfVcV7kac3J1/851tCj2WIuO1TKaFMYecAaSTgJaF+P7pyT6T06HSLIiR8jNyM9G/w706XRZKBkPw7Ie1wbi5U6l+T52MgbBDGonP2HpLlXOVBc3SUm0z4zPqlDD6MnIpRL91EP/rxBP6ISm2yzQ/x057P3/6JUYtXvvm/0TcqbcZNtDWIYHJMsT0AgTaZ44D+i+CcQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(366004)(39840400004)(396003)(346002)(451199021)(41300700001)(66476007)(66946007)(66556008)(2906002)(4744005)(186003)(44832011)(478600001)(6486002)(6666004)(4326008)(316002)(6916009)(5660300002)(54906003)(6512007)(8936002)(7416002)(8676002)(36756003)(2616005)(6506007)(86362001)(38100700002)(16393002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RxdVprLan9J4ryjBedpYTf6Zqli0FdX5a2qetR/j/MEMxlwKFH/1cHAa/e+w?=
 =?us-ascii?Q?kopbD0vdi8pwg+fX8h/1a3Y/M+98LxdCTayudD2Kc0KoSVmGchOz5Z+cbch1?=
 =?us-ascii?Q?fka7L7sFChN7wgDewbS+1Z+EyMNoC7IGNekZ3xlZvAHmWCd7ZW8OiblZnDHl?=
 =?us-ascii?Q?DUv9ue0lxAquE5mgzMtxJmgYHLgjJ8hAAC5kbKy1hjm+09G103R8s+oAPoVO?=
 =?us-ascii?Q?VysFrWPi44a9XUiplyFrV4oeWtEJf+zdH6QcfwAWeuCz4lQT43kQ9PL2ejuu?=
 =?us-ascii?Q?OaKHUK99MecCzhnrjJwZutUHqqRXCALJNX56OqtB3pQcXXcarm/cDcnG+h0O?=
 =?us-ascii?Q?4QCWqIZIbLzzVsILVHlSO/2UBqsI4zaXkrgXxysdPwd/pUnwJ9yzIzddX7et?=
 =?us-ascii?Q?PboiDo2+Ae9Cnzduay9yCkWpsmzReKscZVlOvtLCJ4iQvSGaJkVbUQ8PLM+9?=
 =?us-ascii?Q?KbqaUprr77W0sTsGr56BCkJAR5atZuGkgtSE/C273O2tYNqYwmBq/XvsXXfY?=
 =?us-ascii?Q?j7FxYd6I+dMbFd+TkZjCP7IYwqLhucBxrQHaWJDMY3qC6QG/fOVg99KBFBvP?=
 =?us-ascii?Q?ZTaOaqWOk1FLgnmSrulp39VvPUQyftXH89dcEwGqkQT/HCtNeY1KcQciUdXp?=
 =?us-ascii?Q?v9ZXiO9QCoUWkQcRCShwHoIzuZdTHxKRfaWW/C4N5xsGxncm2tsrq/g/11OV?=
 =?us-ascii?Q?1Omh2ugcVsBNKCeRW5P7hbGEpV7z4GGrKRuWZOOJAleFuj1Xh/LJg3KuDLqX?=
 =?us-ascii?Q?XVjinnVh6fKlqcq9JZOHP4JblJ6kgkAc7JA3SD+aqKSVUaw5pFlviCiX/QhU?=
 =?us-ascii?Q?6Uy0xYGwnhw8gpczUNwmQsl/VlHIXNNLT4Mb8VEfyDRXiAlMR3/75IVdhimG?=
 =?us-ascii?Q?PU6qwTYQq/syIqtnCg3ueYSr+027lcpZ5YQ+ic+Y2RhUz5BPKIVAgRhQnuiv?=
 =?us-ascii?Q?t7U5u6r24MOgtvKpgT0936MrdX0/BQq+Dtr7gwnGA4rW41ItsE+/3K3Ivh4F?=
 =?us-ascii?Q?JZOZIS3H+arGNcgn7VhfQNGkWHYGw0J6N5T1ZL/gSad3YYdIcP62eZfiiBQ2?=
 =?us-ascii?Q?UUzRCP1WmffhY59HaX/gYDu6do8A7VGEGF+95XpMWP4mE8fQsp0g1lTMy72Z?=
 =?us-ascii?Q?4GfRefbB1HBxsM36LzDkmkGJBbbgs8dhllicrfobBGodNFCeb7AjpGaMfX9B?=
 =?us-ascii?Q?Gk6hArLL78ktQb48ZpLToVPYkgrk6oB04S40GNwiMQfGZjqAyfXJDvB7Gf40?=
 =?us-ascii?Q?PK6lCM7+WacXPQC/adVeeL2G7sTC4Cbad2c4U3C41mmHsGuCexyKn1yaO988?=
 =?us-ascii?Q?yuoWWscU19KKeb1KPzl8Efxpk8sOOwcDcjESYCVmm1WCOlfNunkQiKpwF1F/?=
 =?us-ascii?Q?Xe5X05mpAw7I7q2ZQKKiew7CVV2wsPM4z2V48YaR13GVRTStwiNUWqGZQyXo?=
 =?us-ascii?Q?45vUe4h+Oa0mGgFV1uE+4LC6JVXxJOBNh9v9jAC8CVP8d2NKudWPKX+jGQW3?=
 =?us-ascii?Q?NP6eBtUMWJRxjpIxtTr38w3eAupnxzuQ8mh2Bzj5otf6BovW376VfGHQLPR1?=
 =?us-ascii?Q?hZl5a+PmvaBTT/w3CBSbvEdblqjsHE4u/ioPPOv2KM969oqmweLBIxn7Ib9F?=
 =?us-ascii?Q?O0Xfq6f6wZNLiKUlvk731aUIb55czG24lb9QTYG64zjANsS1yUP8N/kfcxUH?=
 =?us-ascii?Q?4L7cqA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12f12473-51bd-47aa-2c36-08db5c42901c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 10:35:16.0147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L+WGiAyijmdieuxYLTsFZ1eRHgh+RN+vQg68fx4EE2YL8Ux/40AlIs393qfw1uDRkzUo3AoqnNvLM2aRpbrbmJkikFm4jQqq+80Dvme0S8o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5277
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 08:17:52PM +0200, Christophe JAILLET wrote:
> Use bitmap_weight_and() instead of hand writing it.
> 
> This saves a few LoC and is slightly faster, should it mater.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


