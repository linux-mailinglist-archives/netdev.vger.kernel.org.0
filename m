Return-Path: <netdev+bounces-3683-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E90FC70853B
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:44:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8A151C20FB2
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 153CF21087;
	Thu, 18 May 2023 15:44:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FDF53A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 15:44:33 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2137.outbound.protection.outlook.com [40.107.95.137])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBF7B9
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 08:44:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O30a9CheP8lGoc9jFfzPQ7M2PgqB0ROUEtskuEdsaqlCUn3CnVylH00CbnKPfEhHyJIG0rRu8bCUlqZ6Nsxn+oSxrAjJ00WGUm3KK2OjLB8J3j1gSD+If9HNhA3NFXxolqlmKcekU7gn6H8lfeRbzRSJblLN74wGgQBqC/ea7meO3zQTFnpjEnwVgwRZ21G57Svj5caE2nCbVgXJfHGaHom/nsqPASSDZG4rYXPj5Br3aZ8KuI5zGG+l6ZaCN4ZogsQxxKypfSQs3Bww4KBOMlcDIaJIK2PHbEM3i1V7hEwsZhXFoFqniZpa02OFl7QZ1egZ4io1KkT5aoUTCbLC7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T8u8gbjfdyglC23/sN86msCMC0GzNArqs2SYKkWjd2w=;
 b=Gh/uxsbvy0ssZZ5os4gpXSWPLC+pPFOcX40218zLjXRIzH1D1rA1F+B+wcp7kVnv9/CMUg9FxD41SXhEWL/mYYzYbdrGWPL0WT4lfZM0idqts/lTD5PeAC9uISmqRZjVY7H6h+wAsg5EDWPvDNUH+LtKsVsU6yvnHr5Dl+7t8rscmIJO0KWmcsMpob85k0sTPhvJvb2Jebo0+XYMW2sk2oaYt6dByRK7eO0NXbf5tAcCX+mvBAyLqO6hX7bsQsmvxJvXz2FEkG/CQXGm/u7hDA9m1JBQM2rWrmhYFLdd+YFyzLdXAaIQ0i7Upc5YAiyXCQmIcS+FAOWhiEdNicHVxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T8u8gbjfdyglC23/sN86msCMC0GzNArqs2SYKkWjd2w=;
 b=XHHhWEKIn/6zwsqXEaBkLOrE175h2ch+7C2VjX56iR+ws0Q/4/d8I2Q2BzAEUgbmC+Q5GPw6jeJGwG2vQl4N+h4be9tS4i7G+16kDHTqcO+W5c6GYhVgSxZdMVnq+L/mii7z117cqCAdqf4Jwm6pVAkoMhLS5qIr6zu/NB+dNis=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH3PR13MB6487.namprd13.prod.outlook.com (2603:10b6:610:19d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.6; Thu, 18 May
 2023 15:44:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 15:44:27 +0000
Date: Thu, 18 May 2023 17:44:20 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com,
	tariqt@nvidia.com, Shai Amiram <samiram@nvidia.com>
Subject: Re: [PATCH net 4/7] tls: rx: strp: fix determining record length in
 copy mode
Message-ID: <ZGZH1NayhKiHMZTh@corigine.com>
References: <20230517015042.1243644-1-kuba@kernel.org>
 <20230517015042.1243644-5-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517015042.1243644-5-kuba@kernel.org>
X-ClientProxiedBy: AM4PR0302CA0005.eurprd03.prod.outlook.com
 (2603:10a6:205:2::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH3PR13MB6487:EE_
X-MS-Office365-Filtering-Correlation-Id: 52c0b61c-1f90-4370-7966-08db57b6c2ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tfZZCaqtBTN/yvX9Yt+bfa6UaHDLKib6MX5J+eUhMAIAbrOxlQkX2FAapTas3gCZbUUz8F/aP3oXx6dW621pRuQgebzrL7leGPaGKChvYk32QJP6CGeDuKnOZ4AQ69YDB/Dq9LPUshVBQwKvIOPazloq3vJAErjQrc+3gHba57Jk28Jhm6MwgsMA0oFEZxubi0mfoYfOkhRzetiTfLwaA68QuxdCQsiyIBVvnAhyoo0HLPLYUi5P+KN6zyMLC4ITY7XZ1Kr8vu3TPfsagm0ZlLWMADz88a5BwkTQFrU31HjKDtonx3mJCWKct1gEbC6OR5s6+jP1Qgm3J+kDg1aqH6+rUCRndcEh+sIC0IlvmeMAOY/G8GEM+FJOE5ktPod3UEBP1YDwPzJhf7av4zNZ6x8WysJntwvPEOGHcT40uREPtTQolmjGxHqwIBrdoKvcASEllyq/wj0ZZef2lVfxzg1jTUeotAoXSePKaZatlRFdlnDIvcg9kqaJVg5B67if2km2QJi/FDQN8eGc7FSZrjrlA0Kj4/J95X8KmAWXlvHdr4CEzl7yy79iRoCMCQPK
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39840400004)(366004)(396003)(346002)(451199021)(6486002)(6666004)(6506007)(6512007)(186003)(5660300002)(44832011)(41300700001)(8676002)(8936002)(4326008)(86362001)(6916009)(66476007)(66556008)(38100700002)(66946007)(316002)(2616005)(2906002)(4744005)(36756003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g/j1teM21xYXtgNgeer8rEeF65h94vl+i7wPSID51uIc4g3NdgyBP4MUotSB?=
 =?us-ascii?Q?DouhRx36Wm/kFG7rKPIU51//T9oxXQ31dXRSWuRc27j9Gd62dMov7d7U578/?=
 =?us-ascii?Q?ePUEesGnC431Y3IComHGXcp86WivIbmiXHwnpb+oVn8OojdFyQw1GwdLMM+f?=
 =?us-ascii?Q?8K/ZLOJBKhAlUTR8MGjwR9eYAwXndoNv8ha0X8vZVOiDLotLKSMfYLotOHZj?=
 =?us-ascii?Q?jjHqG5l4Bjo7KOga4QQPw56RLs4X4ujyOnJ4ji3TwBJytZwyvVWzfhEbx2Is?=
 =?us-ascii?Q?zv3uJ/KGtRfjeLKwXGTJB2TsMZYaolUQgy6uF9sF8ffIWv9Mh6bod4Uw7JKM?=
 =?us-ascii?Q?VbwDZSZYIx01PjZMEoQBnUbMgy71ZRewCuuQnfiQi7MUbarQyFdztgZTUj39?=
 =?us-ascii?Q?s/VmulxY609ktyXzaq8TEtFP1TPzWoym3e6ofo3Kc//bCvUWIaCIgQ8QLssf?=
 =?us-ascii?Q?cfWroFBQVozjnhHmvZ+vX5foJRbhWrDDeGEnFK8RpYvfG7+qO5uW1hi9BeQ+?=
 =?us-ascii?Q?Frs089EbqX0PHz74LcLFwUy7OK8VDqz0isGpinzFhQsrmBWr8n+74s0fCUwF?=
 =?us-ascii?Q?PKVCItSrbZkfK+iM7o09tZ0Z290Owkyfo287QI1OqWxC9B2T/wWDRjpw6Ty2?=
 =?us-ascii?Q?tX1w+KiCClV3jzYMgp9Bwj17dflIzcNIIEKsFlJiIVvnlSpHkGTTOZ/xIALY?=
 =?us-ascii?Q?7elH5gRucnMXRPpwrS0nN90iAkd2YuNB4S2nrGlkxiAoovFciG7OW02JPxok?=
 =?us-ascii?Q?kbnjSCyEJd2V67g2s9qVj8daAs7JqJvTjeWZt42Cw36hRuVj5XyPkEpza5wl?=
 =?us-ascii?Q?aSpinMLQ/SY3qTBM1TrEM0zBnSsmIUHf4XBA3dTJKlurxJ3vmfTe+jkpVXPg?=
 =?us-ascii?Q?STCGmhrWHuWpZZUXbmEXAfn4P0nBxaU0uaYb6HmuW7ViCbWbRmL4cfDDSkNy?=
 =?us-ascii?Q?iPk0YMLOHHGXrDOHvWH407TQQfplxAsuzEXFVOSm6DsKX673sqLAzBPynfah?=
 =?us-ascii?Q?tctkpppasKTlv0nYOkrklO2AJUzcR6UkfU7vsNA2fGlHRxNnM3oTe0EX9M/Y?=
 =?us-ascii?Q?lmas6tJXRIYNhT4gOdG7pyc2PgECEHsW4PqeT8RME4tC32xlJpPoVgwrDWvX?=
 =?us-ascii?Q?H9VX2p1GxnFp33MW0xT2T2Q90y5Gub4VGIBwA67+4sOL26wT3nJg9wAU0eve?=
 =?us-ascii?Q?6CBFdmOCKYQIvNW7rVbyx2LGeItPqXzcWM6eV5uvD21ZRoXlocXbzq35m483?=
 =?us-ascii?Q?eIUvOPWK8uWcPvHExbLIiyMaZOrrXJGqNE/Gqc9chkRdl6uh9IrhYE0ClBjP?=
 =?us-ascii?Q?sZFTB7jj1PysDgJLuuV+p7rB4xePDQwQ2uAEo7Mc8X06LpFeHry9ih0m7ei5?=
 =?us-ascii?Q?eqw7IjakvLP64jEYTm8pAJAqiHOGYncNEk9l1mQ4rld6BzslR9tsEq327Jg9?=
 =?us-ascii?Q?Sb1RcJsKnZWeVUi25XxSaVnR0ODrKxGW3/LMAVLCaKJT2KPY7WLZOK0Y3jJk?=
 =?us-ascii?Q?8ivWyukVnkdvbWYOO6MTjZ4OgUaFD37nsb3WVMThzU9uqLOmRRJlHNM4dYFN?=
 =?us-ascii?Q?S6329dJjIUUAW53hQ+sZrCC9PdckNREKHRVrKYetHb7DRt5U7xtQcLdHWzZA?=
 =?us-ascii?Q?JS6Eic6+OEUO3PCKxXZXX46HQN7s2A6o2O+qz/8Y9UY6SretX+xhiE+xuhxl?=
 =?us-ascii?Q?r8uOMQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52c0b61c-1f90-4370-7966-08db57b6c2ec
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 15:44:27.1398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nwW6al6Sehx2R2kAeOUOTJ79H63UrdCaIwNy3+hVnFqeynZABrMlyNZHQ4+QBfhPmwLwQ+sgLXRqehypCWClu4AQixkGDDHCprD4WmH7jZ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR13MB6487
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 06:50:39PM -0700, Jakub Kicinski wrote:
> We call tls_rx_msg_size(skb) before doing skb->len += chunk.
> So the tls_rx_msg_size() code will see old skb->len, most
> likely leading to an over-read.
> 
> Worst case we will over read an entire record, next iteration
> will try to trim the skb but may end up turning frag len negative
> or discarding the subsequent record (since we already told TCP
> we've read it during previous read but now we'll trim it out of
> the skb).
> 
> Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
> Tested-by: Shai Amiram <samiram@nvidia.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


