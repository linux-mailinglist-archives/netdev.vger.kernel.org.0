Return-Path: <netdev+bounces-9215-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0F41727F9F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 14:08:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E15A52816D6
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3D73125C8;
	Thu,  8 Jun 2023 12:08:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E387A10960
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 12:08:36 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2097.outbound.protection.outlook.com [40.107.220.97])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A07E184;
	Thu,  8 Jun 2023 05:08:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhtugriglIRun4OgIduYyp+e4QoP4gUJhBMklfDVstLkjuesEsGLwRL7SCIhMGzIHdGnBGGfjQF1dXcf9qQNXSHAqV6EtOee1DLX9CR1/tqpt2MoLSt8xT7JZuFI97C9e4Fa1+HAQ+Gs6SQoBEhbqe8x2LRDSAftACn16yGP3Okk4lH92Jd4YTKzQ8f+9502phF7JuJZeF1becpkAW+d0YYHxsiRDz/z0WjsfP663SvpfGLPKrxUW0Ls38RohsipGrvYjV5TvtJXLFwBd9T7/xtqRJ1HYRXNGzTMkE7FJh/9BXAGQjmnAc2E1dcNo1D+4HRwtl0D0ZKxLI40nESy0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/Uh/pcSqD+/WUUObUXVK8GdCYYTLXJWxXBFVH5GC5U=;
 b=CgUXvGGtOr2yZDSi9gwgnFUSY0UgiCkUVr3CTdta3bTMRxmExh4ru3jaXq9yNfuCAPOzobK1ogTw34VuspdU+rwOlCkGFDa8RAW6gN7wInxS8dnUPZIxlAxe7LzCN+n4Qd+wfr2tOxCzkRBSK33XEo8gUQSXuG0LcyCrbZ78iF1bAE/RpqdhBOkhnzWlT8m0EEPaEI7o8Ay1RMDOd5lpMhtiDj2ykNhnY2Bwn3gJio7fxZQgZxv5iMEW0Qf677khB5XrkjyhnK75SDu/B5vEWGi9JkUe+S4MIRDDq055bEw6VnqzlfkiqcBI7LKbijMtzYxtgHjCVp91uUrXVjDP9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/Uh/pcSqD+/WUUObUXVK8GdCYYTLXJWxXBFVH5GC5U=;
 b=Ytd7DmV5/8kaKi/C7jCRw/EzXdCMbqgYvQk0ovBcxsSM7q2bQ14dqKChZH5hGzh6YNH6vexfEXH0RFgIid7dJdgCkGo3orzXWNnLKQipm7Ghzg/T+hwyl4e4QboshW0g7BjrIAcVef7DjDw/iBZOGfC6DYg8L9NvMj35CCOR1II=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ2PR13MB6428.namprd13.prod.outlook.com (2603:10b6:a03:55a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Thu, 8 Jun
 2023 12:08:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 12:08:31 +0000
Date: Thu, 8 Jun 2023 14:08:26 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: pch_gbe: Allow build on MIPS_GENERIC kernel
Message-ID: <ZIHEutLwlOi1YDfX@corigine.com>
References: <20230607055953.34110-1-jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607055953.34110-1-jiaxun.yang@flygoat.com>
X-ClientProxiedBy: AM4PR0101CA0073.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::41) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ2PR13MB6428:EE_
X-MS-Office365-Filtering-Correlation-Id: e30cc47d-a0e3-4a81-70cb-08db68191360
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	bq3SaE6URziwaD179cW+WN80w9Z9HV5qZtjC/xyYMSDtYbddPuotf6l6jLdmtv3Z4dZ9LZeU7Yldsv5Euq7xXTOdSAf2bydsgfIwiwMQOTSMaSai8URerNjekDVDltIK2bX22sbMn/7+FcBvE3FfJQw2oxO9IMiwuvN2LxC75XOtzUUPClq1sbwzK8QtHIl8sya8A/4lxnqQbXwFpZkBrExSDuY3Hz0NUnKvBkiMd3HB9x1KYARJM/1BW5H0A/P/DF8A8Ek7TArvf8wN1x580CYrlURolkd5GLw66RCjIfcRNpr9aguna4m7ELBdARTYyyqj9sYCMAGFCogvCijyZlgX2f3x/CK1PHeB5zR9XzdaXG/3vGsnK8bxmXbuGW4UDviQYhBIW46Zg2NZnBZMKJKRjCJnHgGeeNImfImjY+LxZ/4GeQ1ewFprYGEejAq9k4sayeU1YxI4tRJZR+zrtfpxz+rXNiGMi8GeEkVlJbn2T/MOzhLS+grbJGiw03CcpQUCpxY2j5IFiZQGCMwLLr2qm6BTxOQ7NEgRgVHr6Q3hwccY4EUS347EIRhL7xiKWaFRHPn9iEBn6U9jspVfXUDvJhxL7YDwalLM9DbwsYs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(396003)(376002)(366004)(346002)(451199021)(6486002)(6666004)(6506007)(6512007)(2616005)(83380400001)(186003)(36756003)(86362001)(44832011)(66946007)(66476007)(316002)(6916009)(5660300002)(4326008)(8936002)(8676002)(66556008)(2906002)(4744005)(41300700001)(38100700002)(478600001)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tuYS9VIZe0qhAQf8LHWY82frZUgi5/Ws1/ywr3CThQuAe9XycoqRGaWPd9zy?=
 =?us-ascii?Q?boP0Z9d82Kv3Pckq4Sma+wlXgq33Ee0W48dMM971xMSJC8+2XPwAcz9Z32EY?=
 =?us-ascii?Q?mjEvluTrWqdKtgsRI9biBWOSdJ/yak5+0/vvo5t/2iZwHCJ1T600iDnN0JHY?=
 =?us-ascii?Q?tIaEBiJI9e8RKwy603xfBtiOw6rInIouEuSIv4v+0Aj9Gs+M8b6X8fc0XtWH?=
 =?us-ascii?Q?b0HJa/AsexrCHdipqzYsFUp70JuacKCf7yXszy2WImTISuXW6mPVtEkHl8SC?=
 =?us-ascii?Q?Vgy8+xPP28FLW3y4XIV4nADIxXOyKGseyua7nto5W2o5M1dGNsjxq8MKsGlz?=
 =?us-ascii?Q?+c11T1LyCl2FwxzVMJdJH6Y0K1iknqsS6SJAD4zjy6SiflWgMPIh0S7MDsAH?=
 =?us-ascii?Q?cZNNIDiF1w1hHM35jYR4GxZ54QPqOUM6w5xUX87xCNJKccbi6HEFqhiqnBb5?=
 =?us-ascii?Q?fal5RZqA44EDoJVDnMmXz8C6EjfTGgtSFDs3w/SI+hSqTNhy5AC0vmbdfN/z?=
 =?us-ascii?Q?QB1xCTmJGR7s9ezLUweRoWzT+Jkv7FglcBp/H/+QhxGMvfyIqwAgIn51hsUX?=
 =?us-ascii?Q?5/bPcHVZwyPT/kAPsLq9yIebiupMofr9Y0wujeAmT5vLaGjiBBg1QkU0W5RE?=
 =?us-ascii?Q?ZgGE6qyIV+N8gjaWaB1kqa7Ya59K5LzGoTi399HwoiPonTh0TYusEvRrsPd9?=
 =?us-ascii?Q?OisfNbtSMGiH40b3+5HEg0QArPVdWdYYXI2YnswqjpIO14tSbaBZV9vVa8S6?=
 =?us-ascii?Q?sFpLTR7M4eFCyU8FE2tH5tcn1LNRT7I3qUH2mhLkU5ZCO4XvO83PvRtCTtQV?=
 =?us-ascii?Q?UXdk74iPfjkD+4372dafVKXCJ4eMhlKe0wesdTiQuYNacAFFwjEahYFa/9Jt?=
 =?us-ascii?Q?NddwgZV1aJZXykjtroxB3xUb1Eo/SPsr+7BjvTx+gZYoQuwDEPnTLolGR+Bd?=
 =?us-ascii?Q?C0lZmOA0RoRQwOnXnjNdotodT7ZExC7aDPxfyoBWd4pUte43HToaNjxlGP8q?=
 =?us-ascii?Q?EuZW6k/ESxq0NuSv6xcYGqgilJRuKAA7SKGUdAvhS2zl6F3NziYoBG0zES4K?=
 =?us-ascii?Q?Q3CGnM0v753xd/BXhgYsOElEvc3m8EmBfEYZaYKcv+Wk42Ifg6+wSrAS3hDJ?=
 =?us-ascii?Q?iEOZbiabOHtZUJPP0FFRM1jx1Ec+35vjJ2Xrudxo+XE55O66uXM01awm8EYy?=
 =?us-ascii?Q?BmDPnpE2vQ0aBBiE81PPnMIMYBwuTBEezqpiNdiCcc+ipFzxcRGm5SUuGmSW?=
 =?us-ascii?Q?yQjDvggbcFRyUys3640A+/6/o1rFg2c5w44C8ke7e1aSzMqLO6tqfpZcL2SX?=
 =?us-ascii?Q?ZhrecVtUVkuBeMHl5Rw0fII6cKpu7pCtQHiaV1COXZzUsb8Y5ga7fNAVIJRT?=
 =?us-ascii?Q?yEm1SNlIxWUuNWx7fcMer2WvjyfjRgruFTXrFxOe1Z2g3IV0dC5vXjkJxN9G?=
 =?us-ascii?Q?06StE1fMKSSYqh9l0LbK1PXrSQyVcdF4Xzn7YlbMQvDv+m0CtQDwhjBVEQCP?=
 =?us-ascii?Q?9d4oNKSBAJdZCI1sBmPvdIWjfkzJrqZCZPB9t5KwCrUCEw6sGDC5Q3KJ0h9A?=
 =?us-ascii?Q?cHPnFKOScWdUkclmR+/i8HHhEwGrM89XfR/XPMMaCvTpjvOfEGzXrO2p0hZh?=
 =?us-ascii?Q?VBa8CHAHhOQ8AH7+rs3Lhfu3IUQJZsfp4aVkh58udpWy7FnvH53ImX1rg4G0?=
 =?us-ascii?Q?jTAsnw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e30cc47d-a0e3-4a81-70cb-08db68191360
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 12:08:31.3006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: obg3S/NX3YlhDhT58pK1t1663iR4WmA1uJxSRRP/ivfmcrdvnIeDhEHtJF5fQh+EOdsHmxqiEFLyyVHG97yOzHBh8K1W5B+34TYUoFQc45E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR13MB6428
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 01:59:53PM +0800, Jiaxun Yang wrote:
> MIPS Boston board, which is using MIPS_GENERIC kernel is using
> EG20T PCH and thus need this driver.
> 
> Dependency of PCH_GBE, PTP_1588_CLOCK_PCH is also fixed for
> MIPS_GENERIC.
> 
> Note that CONFIG_PCH_GBE is selected in arch/mips/configs/generic/
> board-boston.config for a while, some how it's never wired up
> in Kconfig.
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
> v2: Add PTP_1588_CLOCK_PCH dependency.
> 
> Netdev maintainers, is it possible to squeeze this tiny patch into
> fixes tree?

That question aside, this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

