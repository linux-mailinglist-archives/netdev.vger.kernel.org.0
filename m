Return-Path: <netdev+bounces-8884-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEB517262EE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:38:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88C432813D4
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C146614AA5;
	Wed,  7 Jun 2023 14:38:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF71B14296
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:38:06 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2096.outbound.protection.outlook.com [40.107.237.96])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBC919BA
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:38:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRYK1poEDwWUDalPLg0RpgTtEtHeArwjSRR1kbmHYQH0YAKo3DDf2CanUwiI7889iTKaapjsyD1n6/ntFTg2ZIGj1TxUSwPKPry6qhr9lBttScet4XzVcuNI5OpwWMNMU2qByp+UHDeqJbcH0AcFUJMTJO1DNAsVeV14PPreURFPAd36H8R/pBqvHQ6fwOZkv1UAH+eHxOhK93+6KA/hmKtLdG/wrZmkUW5Ylv0r1b/0MRzelHcI169wRgusbOt5mrZUiDZiWVBPZyX03V3IW6qx154gWNs2KGlh9DPyAiRs7ObqS3AoM9KoIEceQ6g5Cv4aJV1BsjXOLZY0mk3gRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3EK53O5427FBl5MBxEByjPtBzE+xr5mt1C633nNgomk=;
 b=bYA5U94CoYEi3dOV3SHf0Vf9Xp6IPgDyw9jVTS7mRt8ULqxceRtFvZYt47R4i5HZa04eCvA/Asw4/C9RB8fHkE0fLC/SbdVmDfR6hdPbYOfbVouKN9HbtrlNNUXpfNvAKJc7bpoulvCK8+JJIgRbd3VYoHZg2L6X/K4iNzopjSdQmQD93fsqjrL/EFvSj9sA1JSxHtcF8U+53RJz05OLISTeCMivDZZnnTfYsKEJMjWwjhfjHMcHY/PCSximQPZA3LEU3bVoqaIVkuIpi2k284JetqPyo/9l9F2v33KwOj/kjaDQbnHePLdj5zgQbl9DeSyyyLBQ30lhtFaDdD9xxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3EK53O5427FBl5MBxEByjPtBzE+xr5mt1C633nNgomk=;
 b=d36i4vA/tNDuVm9VL2diCqctZWs5ir/0kDIGSMs7dEn0fGnwHHF8wot+NHgid+wR122+QKqemG0MVRa9ryCOGt0XZbWghtoK6suP7qP67VClibe/z7S/Ni7FruZkeKHC6urGmM7teXCReT+6xKCml5G+U0T+poQDRyPFMyQyzqg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by MN2PR13MB4069.namprd13.prod.outlook.com (2603:10b6:208:269::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 14:38:02 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e%7]) with mapi id 15.20.6455.037; Wed, 7 Jun 2023
 14:38:02 +0000
Date: Wed, 7 Jun 2023 16:37:56 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Madalin Bucur <madalin.bucur@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, kernel@pengutronix.de,
	Madalin Bucur <madalin.bucur@oss.nxp.com>,
	Michal Kubiak <michal.kubiak@intel.com>
Subject: Re: [PATCH net-next v2 2/8] net: dpaa: Convert to platform remove
 callback returning void
Message-ID: <ZICWRCDDjI3oc5KL@corigine.com>
References: <20230606162829.166226-1-u.kleine-koenig@pengutronix.de>
 <20230606162829.166226-3-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230606162829.166226-3-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: AS4P250CA0022.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::12) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|MN2PR13MB4069:EE_
X-MS-Office365-Filtering-Correlation-Id: b429ff3a-d1d7-44a7-fd6b-08db6764cc36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qYDEM4nI0QaYfA15e2XgxyMOV4sYgJRdwXfhubKXF+TDimiwkfiEQ9BK5sTD5WCnchi3SFELWo+s9NUOnA6u/PI7XPwgAXG7hVvi74nEVR6q31C468NGQtA901n+7K9ajCx8rtxIo7AZfOZVVbN9+Vq6UlbgGVldHWYc1UO4Fy87Hkpwy9ykdFRcqsskVVfweNJdEHWEyWDyVh0CHj3qzox+clvcXXC+vRZ+O00xUkioLcQkZ8bFNLbC6wiGaLAtHciVbEfh6EPVWhT50qA+9pvLaknp0pWTTgkC8x01b5ALhdFoMFU290AHehKEMNYLljuq1d+9hu+Yx5Q9GWfkLLY8B7IXydjU1t1u0XSQ2FotSj+bEzyoKIl0hbDv5okrSPa+Fn9dFONBtD6lg1D1eeYi8KHdV74kxRqGSY+6/oIUh7Oao8BKOlYXRWFFpaX2/L/YD+USTvZDUP76+IKezzxP77uKDxtM2rvsUVKPumQRux3WSVsoKrbN9ye+Ptm2s8kcPNf9ZUZciWY1S8aFILH2NfROmQ2QUrcVGOeKkbx+Xt610rEwp54YpH/+qg6A
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(136003)(396003)(366004)(376002)(451199021)(6506007)(186003)(6512007)(2616005)(7416002)(36756003)(6486002)(2906002)(44832011)(4744005)(8936002)(8676002)(54906003)(6666004)(478600001)(38100700002)(86362001)(5660300002)(6916009)(66476007)(41300700001)(66556008)(316002)(66946007)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NG5QV1dJY2dWc0tMcXVmZ0IxYVo0RWJYbWxqd0kwVmE1MTBsSjVjRTBxTzlk?=
 =?utf-8?B?YzZqTGdPK1Y4RzBqS3NEWHVwNmthOURja2dReGE5T2s0ZzdmZGhDdEVyWmJ0?=
 =?utf-8?B?WDMrRmxoeDJTdU9IaVdNbmtheWdmTHpwSjJjYXdyK1huV3pvL3RRNGowc08z?=
 =?utf-8?B?Tk9lbHdPSFkwZGNtc1d0UE5LTGozN1N3UE4zcFkyd21scVYwaHhTb09mczla?=
 =?utf-8?B?bjlhQlFPWjk4M01IcVdXV3lTbU02R1JSWXlFM2MraUFDU2dYYjNiTGZ0M1Np?=
 =?utf-8?B?MndLemUrcmQwVmRUMDVlOVp0OE1PbG5UaVREVkV5WlZOOGlyS2ZqZFc3SFFI?=
 =?utf-8?B?S0FZM0FDcmZraUFhSkVKL1ZsN2tpWkFiKzEwOHppUU12a05LaWN1QjkwRGtY?=
 =?utf-8?B?dzNSZzgwRmNVa3g0QkYrVkZkcks5djZRU2V6TVBETlp0dHpHN1JQNUJ5T0Rs?=
 =?utf-8?B?OHJzNW02MGtKR2NFUWFoaXZrbUN3M2lNdU9aMmltZkc2V1VSS2FUS0NydFhr?=
 =?utf-8?B?TWtwWG5jbFhBWnU3WklGY2FmYjNnYVREbTF2RFlvVk5uQmRvTzg2N2ltTlNJ?=
 =?utf-8?B?S2UzOEdreHFlcWNhL3pTL0xBUXFFOXZmZ1RRRzhkVWtaRjBsRHVOUXpOVzJ4?=
 =?utf-8?B?ODZWa1JLNDg4Zkl0NGhKbzY3RmowQTdGVDhkdGI0QmxkVWYzajFPbjNxS2Rz?=
 =?utf-8?B?MG5Qb2puRUNaS0l4NjRmVC9vcG1jTmU4d0F6UExlaVczZFFvMUFldkY4b3Jp?=
 =?utf-8?B?VHgzbjhSaFhEaEx0MnVEcFM1RXUyR0I5NVN4RDg0YnRKc1h3a2pVUnhTVEgr?=
 =?utf-8?B?MU8zVkdqeFhxNkloVVJPV3U1YnVPMlQ4SDVVSGJTKy9VWUF2cWZCejNmQUpi?=
 =?utf-8?B?cEVMaDA1UTM0UGtMZ01RbWNuTnZEVCtrSlljL3RWNStKM0lTV1R2K0pKaWdB?=
 =?utf-8?B?ZHRpN296S0pwNklhemlKOE5HdW5MNVNGN0RMVVd6Z0V6c2NiRm11b1ZtSUMr?=
 =?utf-8?B?OGVCa21HWUVRMWw4ZW5vY2hYKzRtUEJESk04cGZCNWNvM3JTTkY3bGV5UjU5?=
 =?utf-8?B?c0xSdFFoMXVxSXlobXNQMTlERitqWVZSMU9uS2JBenhJeTcyTXErYjU1T0w3?=
 =?utf-8?B?V3NMSFd3L0dEMnJWTmFnOHZTSkJLaEJQSElLbVQwUUp6R3VYYlBBekFQM0hX?=
 =?utf-8?B?ZHJaSDBwb3BXN0NDcnV5T1dJRzA3VlpncWxMZHFGSmpxdzJMdi8xbjR4S1pY?=
 =?utf-8?B?aXJBS3A5cXR4WXhuT0V1MjNZZTRVZSsrNW8vd2kvY016dHZBZUU3dmVyWi8z?=
 =?utf-8?B?dXRLcXRTd25Lc01uSm5hUXBhL1Q4eFBlQXlEd0xTZVNFb3ZwMHBld0hGN0V1?=
 =?utf-8?B?cVlxV1BlWk9IU2xEVndEc0RCRHNDYzF3Qno3QmpBUlJERFYwWERtMkJINmVJ?=
 =?utf-8?B?SThITHlNUlc0VDVQWmlTM3lPUXAydEllZjJ5bm1ZNjFBd2JsMTRlZXowZlRP?=
 =?utf-8?B?YUJHR21qc0xpempTWWg2dzU4NzRrZk9aL3QrMjNweWRaUVJLY1R4cVRnV1My?=
 =?utf-8?B?K1E3Qlp6cXROZXNOUHY4RktvbWxBcTBhTDNIdGRnZGhuMzVqV1Axa3FvN2JN?=
 =?utf-8?B?eUxIckZTSGNZWkxqVEFrWjJhMmpaVUV2QTVBRnozaGVYU0lzVW5zQTFCUlZw?=
 =?utf-8?B?Z2RpK0dVYzdkQnZjOC9sSlc5clNicHhtYjFRNzE4T3dWVzBVdGR3ZkJQNnFV?=
 =?utf-8?B?U2JnK0NuSk1qTllubFNOa2tMbGZ3by9IY3NyMVhIU1N0QW80Z1ZUVEZPT3ZV?=
 =?utf-8?B?ZTJyd080cytzQXZleWhOT0lMZyttei81MnBlaGZjcG1iZGt5UTg0K1h0eDN5?=
 =?utf-8?B?aksvVHlwQ3FHdzRLWnhUb0kzaEVZL1lLVWJuS2NqMTNXcDZLUE13eUZkdTJa?=
 =?utf-8?B?QmlCTUF1d2V1aXNCRm9JcHp0N004QW1BN2VFL2dkUk1DZ0NOSTR6RzFCRmow?=
 =?utf-8?B?aGZ5M1hRbnRUdWZGQUl4Szc0eENLckVRRUVzWTM2b2tldjB0YzRNYlU1c2Jw?=
 =?utf-8?B?ek0rYlBQR0lIcWpRdEF3aXBtcmdKcDRFK09TNDVCc0RRdTd2UjJ3K05IdGhj?=
 =?utf-8?B?TlJIeGFHQ0NvVW93d1NQcUZSUTYwU3JxYXVQNHJXRW44SkZmSVU2aUgrMmdI?=
 =?utf-8?B?NFNCS01zQ2FxNlVCYmFwTkQzelJoRmEvTnp3eUNZYVVma2RSUStFcXhXOU9n?=
 =?utf-8?B?bXhIc21mdkgyYVNNOXNQSnBkY1pnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b429ff3a-d1d7-44a7-fd6b-08db6764cc36
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 14:38:02.5506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Xa7znoWvxSsi5BJ1o35mA4nn61YoPGxkMoMKaju/L/ThDQXWuCokpDc6qL+zx5IxVXyc2X6nHQWsliGAwaoptoMc0hCyNujcsnQVbJxPFA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4069
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 06:28:23PM +0200, Uwe Kleine-König wrote:
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
> Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


