Return-Path: <netdev+bounces-4654-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DDD970DB1E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:04:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BB73280F0F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CBAD4A855;
	Tue, 23 May 2023 11:04:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9D34A840
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 11:04:23 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2108.outbound.protection.outlook.com [40.107.220.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B562F11F;
	Tue, 23 May 2023 04:04:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c6ogsKvHTj+z7HB7MqRkCk3csDAK8Dj1FCtePGpmpq/f0Notp2xreoMK+WJSUg2xY2Ks91e0IfacyzOI/jY2R5aOPaLbZpu90uF01TAojl7YljaSziX9X1gbeWqu1Kp63lEITd5pzeHFIweweECUWBnrhig5ejBCucARWVZNrvFaXqE01lvePFFnuyW9GDl5LVeuK5fReylT6OoewGpAe2GX0exoMUqkaq3EmmMRMtJMNmzCjDtTsun+xu4LuV6NTyjwfI6TL6o7vk8paJiZnusY80kdATMQ1dt/FWfZNqIkb0L6HPqfUf7qdmWlJj0/I2Yz3Cm/wT63boBzmblVkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vt8ofYJRZQDel/FPkhs4YEzF4Cv9/gMM0nJsV3GK9a0=;
 b=fg8gncZP308CtZTCkEtzderKhHPicQ+OQ5wJrpYtywq79VipdNEH61ebDRk6QBgTWOPoBJyw5YJahbGNDagBR/i/wEPnLDkYDvBea7ORCWOKZ2GXtgF7XF35RUg8L9FyFGS4SGa2aAfkRutxWcm4GiyvxQmEzU2KXSekzAfIYCSsvqfpc63iZtXmIXIVmDMzDV6etdaSlFBubI1rR1uNYGKnq64zrM14jPXwEAOltYHyLJr9v2HxabvnAxKg3vV4RLFPhVzLC4OnAxmTbQ60DLFl4ZpyGf+i1+ohhUs34n5bowVA6WY6pw1wLYscBhTIZnE4NnqzDGNJN17PaVfQrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vt8ofYJRZQDel/FPkhs4YEzF4Cv9/gMM0nJsV3GK9a0=;
 b=qA96A2HlVw6RsBLQRq4dPyf7WqBpNgMD0qy07+9rEVnjP00FdF1neOmeatUzCAIj5OzCJy3UJVihHTkyr/k2sjeOwX6E8POIBAhogV0glJGcHoWnkg2bAwTrvIidc3nBzdTcJXa1oi3r/BTY+iFRoYZ3Qcq3Ns0qUz018mburn0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6527.namprd13.prod.outlook.com (2603:10b6:408:1a0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14; Tue, 23 May
 2023 11:04:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Tue, 23 May 2023
 11:04:19 +0000
Date: Tue, 23 May 2023 13:04:12 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Gan Yi Fang <yi.fang.gan@intel.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Looi Hong Aun <hong.aun.looi@intel.com>,
	Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Subject: Re: [PATCH net-next 1/1] net: stmmac: Remove redundant checking for
 rx_coalesce_usecs
Message-ID: <ZGydrKQg6RsL1qHo@corigine.com>
References: <20230523061952.204537-1-yi.fang.gan@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523061952.204537-1-yi.fang.gan@intel.com>
X-ClientProxiedBy: AS4P192CA0036.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:658::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6527:EE_
X-MS-Office365-Filtering-Correlation-Id: f6d0cd89-a673-4810-e062-08db5b7d7526
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jdaXyK2ZXNL830h32kg1pKkOGcpsR7q1uBGndIwXJSnZUAP1+Y79AHywT0cZlPJG40/0YseRZ8bnU/6znjeFk2IkciN9twTY/G8Xb1a6Tnz5QEL9NWtS47bLcSrhcyhAzZzT0XUV8z2vplOtfjGQ9Yf5MfDPBGT2/pzbz5BwuH0V0ICec2mY4nc26MMXg8wJL48mbluK0CguO7sg4Yf4b6OFlAseMnrEfbZSezMfOAeztCxJ7cIVG3m+0ZruZmYQb7ZeqKyi2uZSFrzGnRqQH+BbpzMLNhNREnSDfnP2tSoMOLZnp5xvvzEH21j/STQjF2z5pM9q7+LadeMEbAY2rB6dOzGDFkjI7/tvdQCjVLQNveVMyNCGEPb1zuFtIx1Ykhe7ALvKWOi6pnErJk37ZuNRMYWrECG/AGXqACqWq0A0nsElEuAGgq6mB012/6pKheh+9X0f3oKNf2srf0d+cTMmmOkZ0RmmZJ7NO+BkHjqCOsl/4FX461hSQWmgWtRKlNIbsdRBh9qrUvxGamG3KKo/t+MAetAvulUfvTDsFpFB//YWXHADAen8Z7mPph8V
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39840400004)(396003)(136003)(366004)(346002)(451199021)(36756003)(2906002)(6666004)(6486002)(38100700002)(4744005)(8936002)(66946007)(66476007)(66556008)(7416002)(8676002)(316002)(5660300002)(41300700001)(6916009)(44832011)(54906003)(4326008)(478600001)(2616005)(6512007)(6506007)(86362001)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cqQ/ab07RN0lkISIP1C2cxdaqQI4IrcAf0PQINS0OEG6ue22qZtWzQdEBY6N?=
 =?us-ascii?Q?NlsAzgGZYNXQ+RXmDjod9p2cxiDwklxGNGdzlzHdJC3n0Z/iHFw3GKfVVQTA?=
 =?us-ascii?Q?Iu72iqmNNWRhIqyvsPXZINPKgUZJ634GAixi9I1GUy1TOjlHhZu/KaQyaXxi?=
 =?us-ascii?Q?/968K35nMWVMD8AggGgk93ax+kPSeYQ3rQjzE/zOKn4Udt4slQPafg48VUDj?=
 =?us-ascii?Q?c5YZ3M1+RztZNJZGTLb3Lc7Ma03tNHRYyJefRCrvvK8Ja3by71MXvkqlOj2/?=
 =?us-ascii?Q?A9heB4PjTZ7u0ZZghyx29NzIrRzeKkDxs4NMjghJfXf2uRQjQAWCmP5EgTm7?=
 =?us-ascii?Q?rwszPwvItds+iNx7dh4+SnELbXvrxrLXCueAo2w/ab9FaoruODkXUDJDgptj?=
 =?us-ascii?Q?oMgZ7kXuNAi5VJUwD1dQLPIlDZ1s7cJ+Zv0D4k8Rakbu5Lh5Sh3PTLv7Z/DC?=
 =?us-ascii?Q?PAM9i6bm2MGQzuaWNYuTxHItmkBNcUxssumNgcWrhEQzUXfCFH7wXPj1E852?=
 =?us-ascii?Q?Lqi5Wli0leMG6BUGM+/0cHFRHxNzaVbXnwe4FM9GGSkmp5umFexlVkq4d2IB?=
 =?us-ascii?Q?diIR3kE535W1SKMxXs8V0QKnwic37suKO/Ik5dbsifdlsd6amglXJIgBM0uA?=
 =?us-ascii?Q?mhQbEftZwqbcx1wAWlTNFDO4YXsYp6Hxshge7dEqvxbcx0suJo+9kKZhWLL+?=
 =?us-ascii?Q?l+q+xMF+rEz5c18pYEZMybwNRUbVRGDz4m2P5PLeAoQ2fHePDi3OFX3Y7IU7?=
 =?us-ascii?Q?oEv5W0gRUdMod/3WpY8hyh7JRP3C+IqFHPBw1l5hRcNPPEYqiFC62hUHsQt7?=
 =?us-ascii?Q?p7tPaQwW0/u5yjKRgAODlzgTciSsO1lXAUz+TTCE4JqD1P2qnCH+JXphXSY1?=
 =?us-ascii?Q?1rwELg2/oBYCvNq6dyELCAjLDiLmolzFxEuCVeZhSiDgnn30hSGafclqV7Iy?=
 =?us-ascii?Q?w+B+5s7fqtuy4LvmR9m/qWCvVukIS8Sz8jKwyi/W5iSasL5sI9UyiNH4LQuB?=
 =?us-ascii?Q?e4GgRhfWDIdaIwJBqmllaB0oaos0VwwZBa5UN/F5Vt81dzIzyeVZuvypJ4vP?=
 =?us-ascii?Q?qmbhHcPbfTElmTC2H29jnTWXMN6tgoRCY50WDhevPSIeO+JHN4u8+ISS9d5d?=
 =?us-ascii?Q?qWbQ+dp+d6FZNKI3oWqdW64JQ9o80U5VWLJoUu1hK3gd7hx42P71hLJY6htb?=
 =?us-ascii?Q?eMiojFQuWveowGMny1SI/hB3zM5/OB4dJXgdUFM7iPnJ8JyUAY8epfxFwOTB?=
 =?us-ascii?Q?nYSFPJdBlxjGL5bx4sLKQT64CaVxAMvVXj72jL1sG7TC12eLcgSEnqSwnIku?=
 =?us-ascii?Q?qmoMj6VxpS/kHR6sH0N45CRTmo6CfZ5SgXvrg01Lxj/dP7U2sAcf0by4LlUy?=
 =?us-ascii?Q?IazyXGySKyjuk4mJkcQDzQA3GYFBmIMPP4NlIm/H73uxNRpNINSN/Zd9Lp3+?=
 =?us-ascii?Q?0yliNUQg4WoE4EPMPgqmgvhCUfn36m+nGr41wsErfkHAV/EVb0ubTIEXXBMd?=
 =?us-ascii?Q?jPrChcSwLLG+ywHneBHbwYi7M063TuYw7F6i/TIzgIjt5vux0lrocLlAwzCS?=
 =?us-ascii?Q?hPOr+rsOHzSKGS+vyFLhBtYh+CK1w/pxN36TEw2ZvBVTzkZ6lQ4p+aYH1jSp?=
 =?us-ascii?Q?necOKkW3GRxVj7QVyO0TXgNhN3Pcy0T8ZfOdqriHfmVaIqvJTGVFYOPjMVye?=
 =?us-ascii?Q?wZ0RtQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6d0cd89-a673-4810-e062-08db5b7d7526
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 11:04:19.9208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pzTiGOr7FsorKK5U2FP59cQrLQ2+wpKM84JrSHygZyty5uGiJgAw2nUow/vx6KKPbjxfVaulbG8JO6L2LxXI2RyYp2ltvcaknGgsQgm8kRE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6527
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 02:19:52AM -0400, Gan Yi Fang wrote:
> The datatype of rx_coalesce_usecs is u32, always larger or equal to zero.
> Previous checking does not include value 0, this patch removes the
> checking to handle the value 0.
> 
> Signed-off-by: Gan Yi Fang <yi.fang.gan@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


