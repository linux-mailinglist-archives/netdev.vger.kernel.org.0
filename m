Return-Path: <netdev+bounces-10702-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EDB8172FDEA
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:10:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AEAF1C20CAF
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D43E18F4D;
	Wed, 14 Jun 2023 12:10:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49438F46
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:10:19 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2110.outbound.protection.outlook.com [40.107.244.110])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC652110;
	Wed, 14 Jun 2023 05:09:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8qS6mwgfyvThpZuxXx9Ah5PBUcvi46Un1IIyBsnDoXY/y44gTBxuFRe3iQVIfC4ytbVnr456kD0lRd54T0JcmUXdPna0ADIvhaVHt27CP/IVnNiOx4+ugQKG6gT3TBbEEPRfTKvp2uWKM8WwxNFOn/JK/bm2z1Rbkt2wmbYbVmjlqKlWceWv5ddJ31x3igUl8zVMTd039NA9kiOY0Ml+O4VJJ5K6caaw53EXMh23vgyPY4mSS+RKSI9Q2L9ocNs5FWgs4c6ylqePLqrX/KAKYMFt0xM9mM7P1Y745bCusk1DgVYRKm9RJtm6szZPnYQWh7th35pHnpwhazyLR5ytg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NUDYNzgQrcA+TWXv0cGwXi9taxjvfMOBlxM/cc+1lJY=;
 b=MTDGx+MQHtIbzPnu4aZWFcHznapmo2RpumkizXDhLaUleZ8eXwXSRVtpnJ/LaLs/oAxYaAGDSR1X98PXrMwTrDV9+m0+xsuaXiLB6TXK/2TBN/mewmz1lTp3hum/LjxSowB7No8leF+R8sTluEARgg4rYyh8cM/Mso749QSMBnB9qNFw3re5fjHlSUyOHy1XAiwU8mfMX+JFBBm65yMVHPUDN1RnIcxqVNLz509HCID7Aje23ZobV/9kXmMnPtVSjUfcdhy6tkO9d4sYeq5bpWbLploYqQFHoRKhWIRzmM8ToXXBazUjzywXCUMo4hk1Vehn+1Pbqv1obRm3xiTO+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUDYNzgQrcA+TWXv0cGwXi9taxjvfMOBlxM/cc+1lJY=;
 b=iG0qTjMZg4IT6AjovrqIaX2DOeq9Us6hiAwFjazfihZ34xduG5IdBSUuX8iWYbOOacQgZtxCMeibDrzbvU4YIsisqd3V7B1WQecIRFv6JyNQoBJ39O2MYhXMrgMX8egKH1YL+fm2Tb5JfJM1AIsC5ZdvrMBmgKy6vQVSZ0YZlSg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4043.namprd13.prod.outlook.com (2603:10b6:303:2d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 12:09:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 12:09:53 +0000
Date: Wed, 14 Jun 2023 14:09:46 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Azeem Shaikh <azeemshaikh38@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-hardening@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH] mac80211: Replace strlcpy with strscpy
Message-ID: <ZImuCnPBF8jkUZ1w@corigine.com>
References: <20230613003404.3538524-1-azeemshaikh38@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613003404.3538524-1-azeemshaikh38@gmail.com>
X-ClientProxiedBy: AM8P190CA0029.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4043:EE_
X-MS-Office365-Filtering-Correlation-Id: 1763f5e2-ac02-4615-4ed1-08db6cd04314
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AylcARfmR/yVsQGtihn1b1SJ1SWXhL8huHW7d/B8lT2UU4qMqvZSKeAr49lDOXF5e7nO24xtsIOzb29fZJx02ZvpPT86f0UCkF6Rpzemqlqe1YnXgb4kc1toetTac+0Ok5CMm1I0sqvwN9ag4s+sr8kb9LqfUUrmg2jK4pOy5oA1ZehHhhcy0PtybtsYLdPJzo6z610ZGtC5sEZHWMmgjZ7VR08Qg1L5eogmYMqCT7H2pJNMkzyQl9Sv3hmuys7UBRfkfiulysSvnuuL78ApmY6S+NzQeXeHc0wdeivhFpFgSMvuVSvNz9gGw2KIM1FKPlInaakFDAwmb5L+5epMQua5paGnOKydoE7FiRGvHatJHq7T1f9vNdCgm74Hn3p/qjhnwTCU3xpIvUt3YwDnpt2M5XPIS6akJ3KyiVWRO3LQD/zQxckfq+lMIbvXzi6mTPWZUlHWAG7cbDs+b9xvrjK6JeFUw7r7Md4+3PB2XsN1yQBo7qhvBN1K2NqHXJqdkJP65VjWtYIQOWYNR3hPq5WKaXre49sruhEjnzTI/7L/gdQGSU5HA6AzMn+5mVwg1H+yPrSCeYVyudNTZPBLJslXvOzdcPnNs4KdxJgBBEBwIk2eIMsFosU0+OAJeVrJUvAWDu95ch9BybmxvqX5Tw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39840400004)(366004)(346002)(136003)(451199021)(5660300002)(4744005)(2906002)(7416002)(8676002)(8936002)(66476007)(66556008)(66946007)(54906003)(44832011)(6666004)(966005)(6486002)(4326008)(6506007)(6512007)(316002)(6916009)(41300700001)(186003)(478600001)(36756003)(83380400001)(2616005)(38100700002)(86362001)(156123004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O8cv1jGc37vAuoAz/DjGyDKz2Cu9fW/8E3ja4a7wS6a4yL1koVqCp7TchWxM?=
 =?us-ascii?Q?+WxmEsEiZ1FAjV9qso4JOb3aebBRSW/epL94axmRgkCpO0vbRKAWzuqYqhgn?=
 =?us-ascii?Q?wrdoJRdLKFkEQ0ETelodrxDi73UUnEOO7B6R6DpUgTPtc6CnFpYVv2KSksSy?=
 =?us-ascii?Q?T+gkzVes61UIFVSaTkqoRRIfXwpVHQxQmc6jnM+8BY/PxCPcnDRrx+ugjHAa?=
 =?us-ascii?Q?03dx1I2Lv9a/IhUZIUMD8KRADmulBgNnGuyu5Lxrb/8PLZJS1vFWYPDeKTM4?=
 =?us-ascii?Q?icsmf5lDLc9Yf7kkF1BEiMlfuOCI+DbFbVzlyCQLl7n5KjKxgpdMB+qrhmw/?=
 =?us-ascii?Q?+vqVZBsWCYEKSLbLsbShmaeNRrD0FEduL48W1QeaPqvCntzLDi5PKv/DQaH/?=
 =?us-ascii?Q?c9e+lp18zcYM5I6BdEYNAa4aPHQbvjFJ9wKR0ND8GfC41U2EgDboY45wlpRS?=
 =?us-ascii?Q?gh8OIHFlKk11ft/6mXaR5QsTKwmOA6amL1KC59jJCv7/rEPL7dpmRbxGRi4M?=
 =?us-ascii?Q?7V2JBPQWscfNXJwHQfR5G3fbtSRy8pyI0rBg7I6h3E/cWC72SblwbpLPbi13?=
 =?us-ascii?Q?aMzCjkfYrvY0JZ7S+Qt+Qq0k8SYUjwprMO3mI0svvRsiPHHVYXwOtQhIrci9?=
 =?us-ascii?Q?tTNIfOQrbO+WkGSB7M4JtRpS/1bVWncGiAWvk5PkvvxIoGL9QbNeufY4fvck?=
 =?us-ascii?Q?MDb6gbAbH28MzR2S7KGh4YycfIwjGiBQq4knJRDs8YvtnRUrNS2e8qp5X8o7?=
 =?us-ascii?Q?WCUR3cabHGjJKkKceY2njGvVadKegU3dn1p9ZOn2+ZIpIrxWTXEF5xv2MYgY?=
 =?us-ascii?Q?EUODA/zOLYu4lxlsEcmLa6W1X42iKorfEzAOWUd/39n5FkTUfvwbuSYLd7ep?=
 =?us-ascii?Q?AzMCBM/rIJ3Z0DgMUb29e2loG5YLhJYss1V515PqZZ3Puq9Y7vBZTFhLIR04?=
 =?us-ascii?Q?vOcKTNSYlkoeID4+PIboGsJnvEDMzTyRoAPsFsJTHSLDlWPvqk/jhp/y+N5a?=
 =?us-ascii?Q?Lj3aHI7g6A6euqUf8JFEQgAqtUWvtb792GWT9pW/49WfmmqyaLd+xcwDq0bE?=
 =?us-ascii?Q?+2Iaps94OPFhuqgC4C1UlMknvA7rNLxwzbMAGhrqQB+p413afiHlMqR/pQig?=
 =?us-ascii?Q?uSQv8wFI8jYblDVCTQmPZc0NJid0jihhDMWKXEYHU5og5qhO8rhAsGAGdOoC?=
 =?us-ascii?Q?n5/XonflDMDmft2fJ7RePNcEhJ+TJvck0Vc6j5VQoshvGRnWH81o3alwJhqS?=
 =?us-ascii?Q?TBWlodqsU4X7qBmayjehWWz77OhzgJQ+uGM+qhJakDyN1bA6q8ugPlkibuAD?=
 =?us-ascii?Q?jj0emlgdgWwWAqc18KJTXPGudEIpEoOtTEkBT7GMc1fmlcpSQge9OE4g66xY?=
 =?us-ascii?Q?y0bk1swZUz5KP+o/Ftqg53MY2LLk6cT2juiqThlhAXwvZ7ypLxDA0FCdT/LX?=
 =?us-ascii?Q?p6SY1NNK3D1z4iKxfAI5ZdzFMLPIWEriHCIHYonHv+YTkWcgvHc4F7JCFwkw?=
 =?us-ascii?Q?kXrrxn0Uw4zwMt85A2voX+AYXefAePLo3LCpI+2ywgt+sQ8ltDEuxn/GS93Z?=
 =?us-ascii?Q?k9Qnangqa/CyxSfFBjkXY2VmWjn6FCrK7wOEDTwUqOkT4K4y80yMQGL9r+Ex?=
 =?us-ascii?Q?ZtfOIyvhrGY/cnLNPjbO2OONo0A/65DXhIE2Xhi6qJC6grx2xJ9UtQZFjNP0?=
 =?us-ascii?Q?YoyVXw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1763f5e2-ac02-4615-4ed1-08db6cd04314
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 12:09:53.8859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6mczICNYRbkbYajC3rK67FWucG7uP1Qd2uIurACaIhEuEuVHishrCM2PhOdMmMXJH8bfC7m5qhzFpjbfRGvlWkdFKJ4IzgY3EpMbgZlmmnw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4043
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 12:34:04AM +0000, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
> 
> Direct replacement is safe here since LOCAL_ASSIGN is only used by
> TRACE macros and the return values are ignored.
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


