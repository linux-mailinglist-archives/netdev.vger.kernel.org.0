Return-Path: <netdev+bounces-8883-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6A697262ED
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:37:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2DC21C20D73
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5048014A97;
	Wed,  7 Jun 2023 14:37:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4470A8C1D
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:37:14 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EF51AE
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:37:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjNYfoAqO3owg3mKR90sk6Oeehz4OL2nTx5TEEUNdgckjlYHzQLH0f8rO+KCWoVm2jZUet6TjySH7GLajqLBc24te04HWF/5wXNpBBZyS4q5e+UQZowQg9tmwOYZJOSgW9Q5pEuHuEG9d13QPWMLx2pjp8MzO05/8jmzCgNoSY8hsf8k64vuXdv/qUTBv6p+cylcSc+zY/KczIWCrkgfwRULmefo8f5qb1yQAzQ/QKGXfHz9nlH/DrgEi4eAaDTQ4eW284+8kjftMeznUYaokT5RiwajNIGvhc439SWwGevkIlSNakQA81BUTDBGjCAbWi87W2h8pUC6nM5wQQBXTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vx5fbKEK+IkX+Hu0stoUG5A0gywDOYCAphQp8zn2ITM=;
 b=RbRKZJFnY5x6vC7SZfRt5efB5yhH8Glo4BHGoAeHr4jtGx2RlzBtexTKkbljpaNThxopHD9kp4FtNhl/P3qNEXi/OGoUl3E1KuD7r6sc0l5a7R5Zx27Yy+aj17spFB23Gjljd/h5UFjpwy1aNkBtGWVHjiPAeHarZQZLnbifjisj3v2VF5wh9bE9TcAkMVtX4zu4CcokNpUxGTeJfdsM00Aevb7dcZyOxWE0F27mWP7FfwBj4OSrM4uB2FTaGZZEY76RBa4c11RVsPRWH/Rzk7+3q6ol/uFHVdojIV0gKi7jN8nM8b+0VAxiM5ZdPNQuehviGJhxYBhS0+VcHLRUew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vx5fbKEK+IkX+Hu0stoUG5A0gywDOYCAphQp8zn2ITM=;
 b=eTIOHs8B+u/feJj37MsRr/yjqf5W/80MW9T79mDcPnkqEDl4PLGNcaE25XmA9Q9g463+3LgaK5zQ5LchPRQUcQ/mJzpAgkfPQcYFh17jOFpPPz7PLigX6fUq1sbDcqoun/eaUrPyFsK1PKAXvKbhFHTyryXtO0NFNH/PbBY0xDM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by PH0PR13MB5330.namprd13.prod.outlook.com (2603:10b6:510:f9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 14:37:09 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e%7]) with mapi id 15.20.6455.037; Wed, 7 Jun 2023
 14:37:09 +0000
Date: Wed, 7 Jun 2023 16:36:59 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Li Yang <leoyang.li@nxp.com>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kernel@pengutronix.de, Michal Kubiak <michal.kubiak@intel.com>
Subject: Re: [PATCH net-next v2 8/8] net: ucc_geth: Convert to platform
 remove callback returning void
Message-ID: <ZICWC3Wy6/0/C413@corigine.com>
References: <20230606162829.166226-1-u.kleine-koenig@pengutronix.de>
 <20230606162829.166226-9-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230606162829.166226-9-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: AM9P250CA0030.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::35) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|PH0PR13MB5330:EE_
X-MS-Office365-Filtering-Correlation-Id: 818d6882-c4e0-48ac-8ec6-08db6764ab91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RKbn6IcD4aT6A4v68R7th06/XDp4SMjv/vq60CM5e8sgUx6+afoVXb8CfQQFP7eTF6NYyknSc5fhhgzw13e+p101ppKC1IkBd5O1mZGEuMbB/p/O9n1C4xUkYjwIoxUv4m/WOiUrbI39Y/XrUyqWmRGsTEE3hW9ZKNYw+8vmyYuJpYWOJmUe+P49YjQDhJ8c57seEBoWjRDX9V7/vf/mizZL8y/YHXlQjDEI2SC/eWdnbfpLIFnWcfof75NeOYcjfBiDs3ItZ9Hm0XZtdy8ixWhiN/29x36ZvPcCafwT9FiQY6G/0+Snl1cpdoTnBcz7ZXN9Kf0hRqw8MAo/1j96KiG8iEoI+EmHaykRn0wC1Y1X/y6zaichEyaECB8Ovw0VX8dF4+CJ/dkK+buG8OpwcQiFFcZHtddKF18vtHLZqRxP9lBpYOco/b/2f/ncmvGsDr3bABoLZQdM4xfHMFCmLM5iBc2HdMJ6660G0bIX4tGSIR2sh428Mhhmb79naodhDA84zriD7wD5rGoDlL0eA2hYyHsihEq51alzWw92Y0KK36/C5Ut+dixTZrS6x+nr+PaWGLVrMKPe+cYVCLsoQs87Ut6TllnSbD+6/EB2/0E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(376002)(39840400004)(346002)(396003)(451199021)(38100700002)(6512007)(6506007)(36756003)(86362001)(2616005)(186003)(54906003)(5660300002)(7416002)(44832011)(2906002)(4744005)(316002)(478600001)(41300700001)(8936002)(66946007)(6916009)(66476007)(66556008)(8676002)(4326008)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L0I5QnRwVE9hVEk4UUxxdmNLbjBNQlhNcTE3cDIvK1lBdkQwK2hPN01kaWll?=
 =?utf-8?B?QnYwZmNUN3N4ZzVEdnBRTnowaXFBZTVwdmRtT3NRMTNSamR6Tk5vN2lMdFkr?=
 =?utf-8?B?KzRjQ2RmbDlqcFVlckhWK0dVQUI2S29FWXBlZlM1N051Rkp4QWlOT0RiaHFh?=
 =?utf-8?B?aXM1QzJEZG04K2tuWXY5U0JNUXVuc29Rb3RwZ1I0dFdETXhoVlM4b2xFYVRR?=
 =?utf-8?B?emd5bldSaXoyV1ZENXhhLzArR2JYalFUUHdhSHo0RjlTcnR6YVl0U0hYaUEx?=
 =?utf-8?B?M1hZZmgvRlNMZ255WnlVYUZ1c3N1Y0I3ZFBKZU9kMnNZU2o2ZWtRZlkwbnF0?=
 =?utf-8?B?aCs0aDdYanljblc1eDlZSjhMbzBKajkyenBGU2VGOEhYWHVLd1E2NVZZNEVL?=
 =?utf-8?B?dHhpRkw3TmhmbkRGT2FpWFBsc1YrdjNyYlptbTBnbTlCeDF5VTUrdE1tOXF5?=
 =?utf-8?B?bGJrRnprZEtjU3ZsaTAxOTZBd2xTMGdKWTdOTllLeXNlTTZhU1A3UWlOekFi?=
 =?utf-8?B?eVdxZTdNYUVsdVRBRm9RRU04VWZMSU5lV0tjendGQ2VHN1BlMkJsT3hDVlk4?=
 =?utf-8?B?MUV0aVBmanhMSW1CV2xzNVJQS0dhTWJDbFdMWXRQbXFla1pJdjFQcXdDK2J2?=
 =?utf-8?B?d2hJV2tPeTdaRE1XZFExSFRoQ21lRzdmS1c0MjJCOXBkMTJpSE5hWEpxU1RM?=
 =?utf-8?B?VjRUUGJ0aytSQjFxNE9ITVh4L2lya3g1b3lMWTFsLzE1amUvSWhWaDdybkpp?=
 =?utf-8?B?c09BR2FlcU56ei9pZWNaeXNYODlpcGpPSHFVMk5TYllqMU1mcnVIWk1STEM4?=
 =?utf-8?B?WFdLOU40cUZNYUp6OUxDajF6K3RFU01Nd3dVL3hLQS9uOFNPSlJDejE3M1NP?=
 =?utf-8?B?blYxWXd1MjJFb1lpa0QxWElOM1ZDclVacUg4SUdrbUZUOUlhOWRNTUd5ekta?=
 =?utf-8?B?cDV0Mk9HZ2NkQVgrZnp5ZVBXOFNONmNFc3g2MS9iaFY1cWNKVlJCQklDeC9u?=
 =?utf-8?B?R3pRSjhGblhUVzRRYlFqYW01Yi83d3JUQlgza2tJaXRIWFMrVzl2eDZjd3BL?=
 =?utf-8?B?ZnNjM2YyV2pzbVlDZy9aSDZ6RmNvUlBlZCtGT3hmejVpQjl4V2pMY25UQS9q?=
 =?utf-8?B?bDhZaUY5NWZzbzlZRXpqK09nUUduR0EzN1U2aDJlVFRIZUg2WStNa000bldT?=
 =?utf-8?B?ZHJ4WU1nSGU1VE1hM3pvc2ZoL2RPY0Vac0FDRnR3WnZNdGVtTU03emFOR1pC?=
 =?utf-8?B?OHVKRGllWGFiY1VxR1hqTVRFYlNlSkFkbEs3Vm1yZzRuRGt4cmRkVDlkSVVZ?=
 =?utf-8?B?TGN0dnZDc2huWFF5R080YjEwcGVwT1o1ak1wWWtheWpZcHJOVFh3SWl6YXFB?=
 =?utf-8?B?MGVJbTlmYllwbE42Sjc0SWZnUXRlc3l6TmlIMlVqa3lUd1BVYXY1Z3IvVHdi?=
 =?utf-8?B?Ly9JbzgvaVhnbUVKYkdZS0gzK0N6b0kyK0pBc3FwanU2Z3B0d0NGemdjeVhJ?=
 =?utf-8?B?aXN5R1o1c3NaMDRmWXU1dFoxWHBnaS9iTWVzcVhCVSt2emJNSTNsU25Qc2ND?=
 =?utf-8?B?dGZldWNaTnNJb3pMOW1PV2JxZHpLc0c0MjlTSGRmRVc3aDFDZ2VPd3FVYlpv?=
 =?utf-8?B?bE8vb1VWRjFYVHgrR3IvVURsMk5FZENvRytkdGdBN0JmbTNPOXByREtSZ3Qy?=
 =?utf-8?B?K1BhN015NElPZW9iQ3BRdk5pblRaQVhsTVUxQ0NWS2l2T0JjdEJMRlZMaXpL?=
 =?utf-8?B?Y0d1ZjFXSFBBUDZqdFphOEp1NWovS3l1a1lJZk8rV1Q0RzhsdWkvY1F3MS9R?=
 =?utf-8?B?c1RyTW9IV09Ld1REVm1RODlNQXhnTU4zenZzdWJiMVVQYzZYM2g4NUhNQWhl?=
 =?utf-8?B?cmpueThzczZobVZwRzkrU0VHMElQbk9XUDEwd1VGanVBL3RNTGpDdkgwS2Fu?=
 =?utf-8?B?RVk3eGY2clNBbmtrV1dOaktlTzlSL0k5ZldocjFidkVTVGlsMWhXMlA1TGM5?=
 =?utf-8?B?U1RmR2FsMWQ3ZE5Eamw4TS9zb3JZYWdubW11WEw1YkRXTnAxNnc2akxrbWhs?=
 =?utf-8?B?UEdqL2FtSU5TaDBCcVpGbzIvcGkvNVNtMUxDOTFaM3ZjV09OWm8wR2JNZWNn?=
 =?utf-8?B?UFlnd3NBemUrTC9QRFVDa2xpY1hWb01PdDd5dHhjVFU0VnROZ21qeCtBejVG?=
 =?utf-8?B?U0tCRkJvQ012RGROUW4xOVZNbnI0TzVET0ZBZ1J1dlh2aVdHQ0VFc1VrMGNk?=
 =?utf-8?B?eFpXWHVRajdVZ2E0RFp4U3NZNWVnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 818d6882-c4e0-48ac-8ec6-08db6764ab91
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 14:37:08.8286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v5mbkaDpN+ygTwqzZ4oCgW0vDR7MoFCr87dwTvMqnq3ag5aZo5nbMbEkiELJK1U5SXMKfOz9SlVtkZmKqG9H3CQ4Spy6V9IPy83uXGtjSbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5330
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 06:28:29PM +0200, Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is (mostly) ignored
> and this typically results in resource leaks. To improve here there is a
> quest to make the remove callback return void. In the first step of this
> quest all drivers are converted to .remove_new() which already returns
> void.
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


