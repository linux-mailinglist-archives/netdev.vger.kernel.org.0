Return-Path: <netdev+bounces-5249-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC8C8710694
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:44:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91B3D2810BC
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 07:44:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58437BE66;
	Thu, 25 May 2023 07:44:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45824BE51
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 07:44:41 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D1310C3
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 00:44:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RtI0bPLAamMPaWKzYQpoobW+o2teGvL9qyERiKltaMeQvGULgdVfOZ34btNHTvPKcr7QZ5//WFiWrPDWVmLgmjTEhhVXwMnLFYFOP9rJBWUWPFSPmNuXNYpq2a3glpLnNmBQLIaXzEjoEF4Y258hQQWCKjion6MAQfgf+oQKaZ8AGpojWz6xVgNbSB0CjyufAfk4CZbJhkpbyeJlDIQBOg9vj+jJfp9+ZMzK9BmrPtirHAbm4ZKbcvvwFjNedd7notebFUBLMcPRIJkz2Vyp54aOqlkfcgW0vDl2a0g6F/+u9M3V4kjPN7haOQkByOBhaPRWdd33JJFiwUBskzqwtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Qj1Gt9vrVAYmHQ/ly94ZDR3v3XsvJtu+125xzAjMQo=;
 b=gYyn4wGcADsgWU23ZncehPmjH2y082vI2N8CRrNV1kglHlV7HRUJ0Qh8s/PV4CzjmdCypbtZjjgYHONkXw3EJUTfO6uX2HCfcXQmHuICe2zDvYJoPIRPpalvCHWBhOSZqGcxzcEwKqQlthax3n+FHTuVlWlm7WYhrs3LR3dd95HkfhCbZB5z5EswSiace/yRsMqElGRdjl7XLApkgHfTKQYfmiHbZNyY/nDWPFLpYMPuvAiSi/Wp9G7EoUd5xjaYPUilDE4uy+O595riCaIOJ4HsJkKezuWV9R0rOMF0YIr/vezDehiKXeCaV80S49041Ggpppb/wxjMx1c+OY5ESQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Qj1Gt9vrVAYmHQ/ly94ZDR3v3XsvJtu+125xzAjMQo=;
 b=vTWENvl5sygNorbKaoMB7kRvgYeWUKWuit2Lg5wdFbbRZsTkDpgB+3uiudIvNFcsUKvnw6y2qesjHs3wxYiYW+PgEM1pMXE4qjXucJcJ/BgduqvDVynUmtepjntnBKWxDPBQwaHD0LiE2C/foA2Il9ZyOmtqpQiZBYur+wLQvb0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3818.namprd13.prod.outlook.com (2603:10b6:5:243::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14; Thu, 25 May
 2023 07:44:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Thu, 25 May 2023
 07:44:36 +0000
Date: Thu, 25 May 2023 09:44:30 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, eric.dumazet@gmail.com,
	Simon Kapadia <szymon@kapadia.pl>
Subject: Re: [PATCH net] netrom: fix info-leak in nr_write_internal()
Message-ID: <ZG8R3uaruTpe38pZ@corigine.com>
References: <20230524141456.1045467-1-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524141456.1045467-1-edumazet@google.com>
X-ClientProxiedBy: AM0PR05CA0083.eurprd05.prod.outlook.com
 (2603:10a6:208:136::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3818:EE_
X-MS-Office365-Filtering-Correlation-Id: aa6603a6-9297-4447-b9cc-08db5cf3e30b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	B9vVmU0vBg2cufwf6cI7/ulljNc30owijpilmMlgQ5SKKU7thlcpI2V4exEdo6tt2z35A5PbUnbwvbgQOPQT1VYfV6nAHURaIkVvK1c80+BeUHkO68PTv9lfiSuhS2TwzoBZxcdsZY/bHptvvm9HG3BOdiwdBIh3mx2Dqx1J6BGTuzyK18VeQxqQdHfkepIDG0ko5BVujnRt9jLLPK1JekIx1cY2AIbx8MpZmjAQCRFIwjggWxGWXE4VzI5sxgExH/691BeMfsDYouWkIgQYLVO0HJFZos2750j5Yt6oKv5N0oFa/yUMrnM+qPLYXmpJKTabG8e3a/j3bE9Bj/B6sZjqxPVryjeMeTdAyYK3ptRg8uZB80oxXd8aFtKxBypQVKSjjGm3iCU5SNkeFUYfqTWPtE/gTxVnd29hS1bdE6e/1CAxA1P6GSg4PT7dKh6AGwaz+4Ks0QysFXH2lX6nbLryDSmSvv6vmSxnSCJnZAoZ560D+H/D79cjJDH7DXPzPsfR5/BT83Es6dCP8QwsLWwVk9TDomAQiBon3+tJDTkGkFEEfgSAkqTg0SPy3CxW
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(346002)(136003)(39840400004)(451199021)(83380400001)(2616005)(6512007)(6506007)(86362001)(186003)(2906002)(5660300002)(38100700002)(8676002)(8936002)(36756003)(44832011)(478600001)(6486002)(41300700001)(54906003)(66946007)(6916009)(4326008)(6666004)(66556008)(66476007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YuTVobEAynKkZ4zyL9a2Zo8GMaH4hA3zQi8hEx8U1ihy1Sbp/yFCBVXLKc6L?=
 =?us-ascii?Q?oHBcodN6/CnPIPw8IYle5mciJKpLxj73YGYIMQrPGY3hq9+iSXRkhd9ukcQW?=
 =?us-ascii?Q?VLaVL2QXUaVrTmcKyqboUXJlnePed+noRe3QuEGMJQ45OSlHBEI/gTA4uVPA?=
 =?us-ascii?Q?zYlB4Lx/MuxYgdYEJuIpoeBLJT2QdUU7ChvJYiSeOeXRBi2ln5BAqev31K0c?=
 =?us-ascii?Q?QHR+Lx7JmYV9vXGUvw2gOg7HWZgVZM4r7+vwEF0ns3GMZrFiVxKrW07dVSCK?=
 =?us-ascii?Q?L3nLwewnd82lWFHScSR/TtVJGdzuXbiObpl/HZPnqBU7LDUTMOr6O2mQkjHI?=
 =?us-ascii?Q?qmNgyCUvXzYm19VEaFLJ+z11jW+qIqbiWnFGV9cMsFr0jjXMS7lyY+zJ7194?=
 =?us-ascii?Q?KhwVsZgaEeTK85S4P6zDXUMOpIeeDe4b8io0B17237EdulBnict2STH80AYD?=
 =?us-ascii?Q?Q0RpHefQvZPSonzqQke37IqpdX6e5LkZ5WdBY9VPDE2nmXIE3eCeluL7rsF7?=
 =?us-ascii?Q?iGiShUz15B4ZNB8Ff//u9NYeprPJyRTi2fYxp/26JaPzhmMkv9FX2jjpSvE4?=
 =?us-ascii?Q?VLYHJu93cfJn/pLwY+036RQYGEfOng06I6Xr8dIhVZE5L230/2mhTXqWdz+0?=
 =?us-ascii?Q?BoIjDrL84HtGYzYxx8qgJv8wfKgXgkrEvRVbkrX9Cw3IBT2zocA33oGOqcB8?=
 =?us-ascii?Q?YOCH7ew2+BStSYECRHjfY2WnAgJuCk9cy11auG4mk7CB3NnOxQUmSLAnxO2R?=
 =?us-ascii?Q?J9176IoATfscoMxVGKK7rX1I2x0L2C+jCrqLAEN7R+++o9nHIxGh50ATGACr?=
 =?us-ascii?Q?+xgmkLMcNNuxjuY5oLMpYVSVP0TKvlZOnVEkRfdGgPlZanFKKReJkIiujusc?=
 =?us-ascii?Q?oI/+j3OPw9IRVkCauKR88eYnHXziUAj5dyvcvbXGXDi9n4QdrArk6Mm4kEr9?=
 =?us-ascii?Q?9iX+gHp6LTa0zXVKn/CedprP5koUxfplqrOMqPIhQ26leTFvQC5D2aJwMHDl?=
 =?us-ascii?Q?nZ6qw5ivMXzGbWuWFX8eDD3KCq1fFXoGuA0rpNTjWKftb2ih9sUxms1EUEQR?=
 =?us-ascii?Q?4S8Bs9nM45lHzn8jETu5NFzYlHKqwqTTVHJ6cLf3mE9YzacSHEYaXaHTNAvW?=
 =?us-ascii?Q?8mwL6OxtESbMS9+CHy5vHv2s1ijxee6Za2dGXs9U2FvrlrFwRHXOD4rzTDXm?=
 =?us-ascii?Q?C1QhHrDd6fIcIy3IcTGWLnA4VWcTr5mJTt8IqDR6BNpRlsawerlBVqltD6fu?=
 =?us-ascii?Q?lAiq6X7Rryj98o14SCkt7SvOCGRnFtg6PrVV7FmpPaLAN5KMy8kRcq/A7RIJ?=
 =?us-ascii?Q?iOKBt0yfYr2etHOtxvvGI46hwIL86V6Fz0BuVqBZ7xOgaB5jl7aZFlqkbAtm?=
 =?us-ascii?Q?Uk1iWVaJAxz1ZiSheVYQnYZkCMKPn6pfYMoj2mSadH4A6pJcvlpKNHY9sNA9?=
 =?us-ascii?Q?V8OjAsMxwJPXP++agupCeF/bDyuI0H4IWTpOwidhCQs+aJMxoSGtYrirw1D9?=
 =?us-ascii?Q?kLixF0G21DN136Z8ZYH5mDVGu2V7SdTeayFRSrrd+u/y1CZCBl656aD3uZ4M?=
 =?us-ascii?Q?V+Rxjn4R+r4kLXZdT63NVw5jKN3GjqyaDGkuFZJS7xr6Iv+i4/DXS1CF5RaO?=
 =?us-ascii?Q?A1HImekjOjWib/WvbFvRuyFTh/WvNs0S/1FFvgaH8/+rUEcJnyz/flBKdQnX?=
 =?us-ascii?Q?hEZYyA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa6603a6-9297-4447-b9cc-08db5cf3e30b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 07:44:36.1532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S5+VhumoovBbt8iVDne9Cwss3rjrjy1avCVqbp90FqK/Ow9QAUS4gxM4bKtL1K30z7lIL0BUeKss87sLITawxQprASs8xad0WI3wwgjKQBo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3818
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 02:14:56PM +0000, Eric Dumazet wrote:
> Simon Kapadia reported the following issue:
> 
> <quote>
> 
> The Online Amateur Radio Community (OARC) has recently been experimenting
> with building a nationwide packet network in the UK.
> As part of our experimentation, we have been testing out packet on 300bps HF,
> and playing with net/rom.  For HF packet at this baud rate you really need
> to make sure that your MTU is relatively low; AX.25 suggests a PACLEN of 60,
> and a net/rom PACLEN of 40 to go with that.
> However the Linux net/rom support didn't work with a low PACLEN;
> the mkiss module would truncate packets if you set the PACLEN below about 200 or so, e.g.:
> 
> Apr 19 14:00:51 radio kernel: [12985.747310] mkiss: ax1: truncating oversized transmit packet!
> 
> This didn't make any sense to me (if the packets are smaller why would they
> be truncated?) so I started investigating.
> I looked at the packets using ethereal, and found that many were just huge
> compared to what I would expect.
> A simple net/rom connection request packet had the request and then a bunch
> of what appeared to be random data following it:
> 
> </quote>
> 
> Simon provided a patch that I slightly revised:
> Not only we must not use skb_tailroom(), we also do
> not want to count NR_NETWORK_LEN twice.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Co-Developed-by: Simon Kapadia <szymon@kapadia.pl>
> Signed-off-by: Simon Kapadia <szymon@kapadia.pl>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Tested-by: Simon Kapadia <szymon@kapadia.pl>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


