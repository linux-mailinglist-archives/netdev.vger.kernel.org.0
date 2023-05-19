Return-Path: <netdev+bounces-3825-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 450B770901C
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 09:02:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37FB91C21214
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 07:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F6807F3;
	Fri, 19 May 2023 07:02:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0CF65F
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 07:02:36 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2125.outbound.protection.outlook.com [40.107.223.125])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C971FE73
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 00:02:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iXaCLnZabrAJxi5qg4OM3He+g6SDKQhDIU4TqfCNGC+XMw6ciCkH1uh+rVV0M7WpNoUTnAfrwT65Xnj5Q32aT3MA8sHS4bvjqHNfckhZKl4dk5PBCA02y1g955uwsQRaPdYQhORFHF6sxJJKK1QC0qETpl4Uo/1Sf9NscGjW12mH7uqL8c8XAZUJv/6n8xqAktalit4XCQLVRqpcSyM8J6w5omvv3NKJ/EULbbDkaGrl1+h4qZ+eGICYa9vPyVHEQYEj2KpgqAqxAkapTajp7+1I4e+RZ4v3Mq45dghfwYkv5ct2ke0W1okOvQPxb7qW00O0awVTHsYNha5NFFPIlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f3oiuajF8iYKDJPPn2H2j3ka+QWIPcKK2GZuxZ7Er8Y=;
 b=C/oDa3nEFNnyhB6wc8pMfdtbhAHIi7SWIJiGB+LwokHQnFnkBepMPm3BYkfhT6SDRAzPnCUypQ7cjrkjyxYz5FwGLe4Q6rEOE3oKOp7d0e0cayVH364LjTYRdzUwczkPx4F+jtpME73GQ9u1P+8Jwu8lqvLfstUj9rJCNOv/8zdzd4ZoIPGAOvUwOVrdH9TqHr+/qzYthwhwYKGHDaYs1vscAL+Qtdnt19f4ujDrfdZ3BuJeWRUSkM8VqgmEGfiezg29XBKahl1QKtdXPadveTxaRSUH5gDWQoDA7MYBojS4FxzfDKm9FQD/vRH/llViK/RvnUGQRTGTGUyENditjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f3oiuajF8iYKDJPPn2H2j3ka+QWIPcKK2GZuxZ7Er8Y=;
 b=QRxuy7cXZ6ap23vVkF2VL+4sB/rsWT9EuCYCCkkZ8QVxdVuKaoJEdGn3L8Kk9VInrhysS1ZrKkxQl5m+5UyTPlJqat32s8gfqa3/vdr3Cx9g5JTEdxluy0cyFRh/L73J3UltXXDkqY3k9x78ityuxKmby+He8LqCEBOgAp3EDRY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3631.namprd13.prod.outlook.com (2603:10b6:208:1ef::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 07:02:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.019; Fri, 19 May 2023
 07:02:31 +0000
Date: Fri, 19 May 2023 09:02:11 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Heiko Stuebner <heiko@sntech.de>, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH net-next] net: arc: Make arc_emac_remove() return void
Message-ID: <ZGce81eHtes6CpZ7@corigine.com>
References: <20230518203049.275805-1-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230518203049.275805-1-u.kleine-koenig@pengutronix.de>
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
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3631:EE_
X-MS-Office365-Filtering-Correlation-Id: da2a8ad4-2141-4208-6159-08db58370368
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wYWi7+RNukYerNE6ecJA2xSDZQ1SqWVshC6E8s4rbdI1ThOg0I/VSvHDKOUFiHLYNftDu12ATkO+jnGqnRiH+YD9KSxkWxGalmpJOoS8cVD2CFF6clxftC+UlqdpL1PVtH8iCve1dNSo/xGjUeB1LA/BLZZ32QXfwcguF0+D0sJUoFdotWGy4xiaTYkmeBHj0nU+8e0YeKirg+480ufhW/TwXx/Zqcdnzr1eucFHe6CZjd58k7TsSeZqOCa3ZVZiLjhoUQvEFAggQIdSlBhwytHhqbijEG8NpKyQmcqAYB8MAeivllb+B3gZY4dKb6/wW9CfjIgrNIlQ2hgKB06LkNsnsQpXV/uw1wtyNeHIekhixbxN/T5k6EAy9iL+6i4boT02U6loW/ky8cov72xjTxzW91kyHKVrRb4En8jZ7EgT/tm9VUI5ORep2dY/Cz5os5VtxLe81bky67ajXMvjsqEEgcJQreeEO6WalE4ZKxNpauRpJuL4z2Y2HvwCz/xaFseAPvZTcUkSh39DU97jb9nfhwTf1GjAdiU/3OeQpn+GzGH3j8JfUe4tUBFqXEaWMlDHBcWIdpAxj5UIwpQvutqufy8yKKfQPr6GZ1BfPZA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(366004)(376002)(136003)(346002)(451199021)(66476007)(66556008)(66946007)(6666004)(54906003)(6486002)(316002)(4326008)(6916009)(478600001)(41300700001)(5660300002)(4744005)(8936002)(6512007)(44832011)(7416002)(8676002)(186003)(6506007)(2616005)(36756003)(2906002)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WDEwTEtqR2ZTMlR5RXVxZkltcmRZb3R3QkU2eXpWYyswM3RlL0t2Q0xEMTc0?=
 =?utf-8?B?ajYzVHVUSGVVTnFEcDFQWWwvZlJwYUZWeEpNeDFCRm0yVFI0TWJtekVZbG5n?=
 =?utf-8?B?enMwTGZLN1gvOHVRWGREaHUySTNRVlQ3OXpRQzZLOVF3d25EMG5kdDBhYzlV?=
 =?utf-8?B?WEx1U3FaUFBpb2szcWtDbXNwVU9uRERoQjE3eFBFRmZjVk8wemJhaHFFSzlZ?=
 =?utf-8?B?Z3RycTdad1hwcGV3Skd3eWlUTWFVejI5UFFNcER4VTVJeEpXaE1CZWVac0VX?=
 =?utf-8?B?M2VOOU1JaFFwYkxMZHpIY2pQbTFQYyt2azVYTmpua3RZZHZOQkx0bjhJdHBQ?=
 =?utf-8?B?U3pRVGo2UXYxdmtXQUxRc1BYb1dJc0Q3WkU2SEdVMUNRbGlYaFpvdEtxd2Qr?=
 =?utf-8?B?NS92TEwxbks5R3R0L0tkZldxVUR2U0YvNjFkSDhoTW1oaXBMNnJtVXRGVXJC?=
 =?utf-8?B?M2NvOGFXMTZpV0RtdHZtVHprNVpvTEcyUWN5VnY1M1ByeXErVkhRbzFPV3k3?=
 =?utf-8?B?MjVQUEhMVVA2c3JRU0I5b3lWWWRxbFBNT2tSNU9zNFJzWWs4bnc2MlMrUFBj?=
 =?utf-8?B?VjBIMHh0UFpsVVpMajBnak53QTZKQWJwSFlFZC9wSWpseU5aQkhrL0cvc1M2?=
 =?utf-8?B?ZjlIdUY2MWhCelZ1MGZ0YzdMYnRuSGUwNng5bXVMRTJhTUplbytEam40UU0v?=
 =?utf-8?B?d2dPZ2huQ2M4VmszQmFwNnVqMEplWFNleGV2UUk5ZTZSMFJDd3J4L3VvL2tR?=
 =?utf-8?B?Qnh6bWQyZnBrRVJiSzhxbmVIVUM5OGVtRXVVZUJGSEdXcDh4S1A3ckptbnhF?=
 =?utf-8?B?Z2FQNWpaSW1RMmtNSzRwaWJzWVR4TlBLcHBIWkMxR2dReGF2WWRqLzNxYjIr?=
 =?utf-8?B?QktNd0QrUC9Ja2NiWG5UMFFlM0JEZ1hPOG90OENTanJSd3haYXpwazQvV29v?=
 =?utf-8?B?eHFFVis0YzlnN3FWSTBOdWNGT3kwY2tUZXJ4RjE0RnVuZGcrNmwyNkVnbDUz?=
 =?utf-8?B?ekRWMzc0dVF6MFdPWXFnNGlhbkpnc1JuRTlyejNrSjI0aXhzU2hhaTh1NHUw?=
 =?utf-8?B?RlVwY2JJWnJ4Si9nRnlPT2tSL29lc2RkQURHT3dBL2p1MFdDa3IvSUFrLzdD?=
 =?utf-8?B?WmFaQ1VQamRoTDFkM1Z1OFRrcDl0MFNzREdLaFFINmw4L2U5Yy9qQ0kwRlY4?=
 =?utf-8?B?MytObk5aaSsrenpHcjY1bkszRG0wNllQYWY0R3FLY2FqRk5JaUdIR0tYOWEw?=
 =?utf-8?B?UE03UzkrbzFBK3R1NHhCR005bEQ4TnBoSzkrL3g5V0p5dStpTFc5T2N3U0s0?=
 =?utf-8?B?c284UklRTkczRDBpL0RMK0trN2ducXU4Mzd6MTRFeCtMUVYvdFh1VWtoQ2hI?=
 =?utf-8?B?Uml3Smk2eG1idDU0ZmRzMUhCR0IyVW9lTkJUaVpJbEsvSHpMVmFlTXhhMjZN?=
 =?utf-8?B?c2xXQ2VkMDVlV0FVTnBSRGpIc3c4YVBPWkpLeVhQbmxKRndwM3B6MXQ1ck1U?=
 =?utf-8?B?YVB3b3hNZVNIMFVPbU8veXh1V1ZKTm51aUFOZllnUVVQN1A4M2tZQ2N5eEx3?=
 =?utf-8?B?TU9vNlpHLzlKWlQxbm1qODFybDlocDNyTmxDbHhjbGRPWGUvY3dxNlVSNUpN?=
 =?utf-8?B?aFlpYmhUdDBmSnJSYzJGMmJnVHpMcDNTQS9raWNtR2kwZHI3YWl0WTBRYVl6?=
 =?utf-8?B?b3pwdVFIbDFaRm5OTHEzOWtmWTd3c3Mvb2dxandIOFlkenZMN2ZmTnozUDU5?=
 =?utf-8?B?azV0RGk1ZGh3cUFXeG5iY2NqTU9rYitjeUFkMzgvbCt2blZ0OVJYaGtCdFhR?=
 =?utf-8?B?ZVZDais5VnJSVUlROHFvRlBicWNLRGFWZGFQVmdtTFIvZzFhUkltRHR4L1pZ?=
 =?utf-8?B?c2lXOUJ4S0d4UGkxLzJuMmZlYUphNTZUZWcwY3A0MzF1dXV0VVhySVFQdkxt?=
 =?utf-8?B?U2UxSC9ZVlZHemM0L3RpdmFiZmNVWlBpUURQYWNsZ3RmeE5pYnZXR2NjaUZT?=
 =?utf-8?B?ckFHbEY5cGE3NDV1K1JWQXZLVStpY0pLYWpIL3dmYjRXMzRUc1NnU2ZadkRP?=
 =?utf-8?B?ckhKZ1Rpc25QYmthR0h0QnNhdGV3MTVXK2ZuNjh1U2tjWDI0Zm9yVWhNcHdW?=
 =?utf-8?B?RDk5djVNdW1DRkg2Wk5TYkR6Z1ZWdjVmdTJ5aXJCTkNhMFVxK0dLQU16b1Vr?=
 =?utf-8?B?dk5NSi9iVHpvMVM3Z0REUFZaK0s1TTN0RzZKamRIK3drY1F4TWpSS2tVTkpK?=
 =?utf-8?B?dDV0cG4raW85N3MvN0lockM4czlRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da2a8ad4-2141-4208-6159-08db58370368
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 07:02:31.0032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: csQdlbG76mrHfQtWQPaDP0006SBNYz8zyha7Z5FrZwgrx8bszvu2LTc8UfJAFNKOFCwzYEDw3+mzD7Thn9qa9cCYj4feTtII7SMUFZHQ5x0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3631
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 10:30:49PM +0200, Uwe Kleine-König wrote:
> The function returns zero unconditionally. Change it to return void instead
> which simplifies its callers as error handing becomes unnecessary.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


