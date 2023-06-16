Return-Path: <netdev+bounces-11329-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DB2B732A16
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:42:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F21BC2815BE
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 061BC9442;
	Fri, 16 Jun 2023 08:42:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28FA1FCB
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 08:42:55 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2117.outbound.protection.outlook.com [40.107.212.117])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370832D77;
	Fri, 16 Jun 2023 01:42:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VclXCGGNPSQ49RizRVxfyq3+PphJa77lKvbgmOpcrbZps8GV2oicJDSs8QEzTTFBJQ91QMZXOICP8gYpizzRnCIHj34Hda+C6FEQNAZwwfhUZBa6cX+V/jAqExpDWDb18rFF17W4AoulXIZkrdw8o1DQOaSokdOubpBGpl0jXpVZzhYzDuejJsmg3QxYB1qo12EHyNWAceyifuTs1P5Wd5A+nOnpZa+VlwSB4jHuYXaFo5dkaE8qokGI+dchO4mVHoY6H0v7+5Bw2uZqiMdiZcbZzAdId975QXPWgir0/bAB+AL5EPruNTYnLc/dPXeurFjdYLGufDS3nRwAw7AtwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PPZ6//E91Og4f+sASDesmwg+hpwOGM39bGqzGnMaMcI=;
 b=Vx93JukA+vvlS4NM7W9YJwtnpzMO14nzQYnzAzDMxl3kPWlGxg6JPmPgWW+1B2OdnPeLQrJRGFGGEFhTZxDA0cEaZmKz+FZWA9LJRWPc2K97mrKgDni5wWD1tedfPF/4w7u0fHsBWe0HefA94yXNK+IEV0Pzc21RfCfSkrJyzUZKPUS/raKrWffrDBytihmSuf/0i6CkhMGdxGTqZAT0hM+Iz6vODEIdaiMXPdX+2uJjerurhoew5tIStlHNlWO3Wfmdxa0o1kp8WPG8VYqXCd1Gba2TWHJX26PIIj9TWfaMk6NkZ4D5DG1F8ELn7DIxBNhD/DToe/z6qjK7OkaBnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PPZ6//E91Og4f+sASDesmwg+hpwOGM39bGqzGnMaMcI=;
 b=XHWgk0EQNno+3zx57a88CCQ1z7mlnjWNcWRnpGexBokUNISvaNtBl+6q9sKJ73s02U8jlsW+tNQz3GMHwWmnka98frExOvEW18NZWozf/8juNxITYpmr/cUjS4OxIQXcw3PeqxQLQJct2pT+v4/kf1CdsjlEioFQf/ACIwxYDAA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB4455.namprd13.prod.outlook.com (2603:10b6:a03:1d4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Fri, 16 Jun
 2023 08:42:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Fri, 16 Jun 2023
 08:42:50 +0000
Date: Fri, 16 Jun 2023 10:42:42 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] wifi: wext-core: Fix -Wstringop-overflow warning
 in ioctl_standard_iw_point()
Message-ID: <ZIwgghjAuMQtc5ll@corigine.com>
References: <ZItSlzvIpjdjNfd8@work>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZItSlzvIpjdjNfd8@work>
X-ClientProxiedBy: AS4P192CA0029.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB4455:EE_
X-MS-Office365-Filtering-Correlation-Id: 63096b78-198c-4f21-0cc2-08db6e45aafc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	EcCBo6FiXeSf+eSR0jdTncAsljPb1huSSeLtTpjKiPUAKY8u4H0XSgqoClxsj3Z/JxTJDj1nJekLWdBs9RbrePrAc3Of/yQRyWw8WXORdrcB0Wn3hhDl07QVEvt8V4xE8nmsXQfaZ0p6GeV1daipo11BLtpyu2KRNSNZzOjyWQ/oQ8i/iumOwdaT3nmL+TuEeYWfurIWKAmzgh9BDPJz9aW9EaqQ+hvs6lcmMMNwEM446FpqK+TgJzeD9yLo7sg3RsbhoIFvJ/b8jv7I9ZX3D/4CJIRdWuQNO+CMmLC+xpAtQ65fqpKKjiLSY2FfiiI9O3Y8oTPTLToinBn4c99ABwuhFowHlb5eI4OtHtDPuZ7jp633BHfeuBq0ZA0127AyEgScmVP77foLs7yu4fDI4ixlLIitCdS8SgjuGtxUWCb7Bz2H6ekBd2tT8S4lmDUEpNxmr8/gl8ghrfD6YnzNhkmge8RvM1H5sFcWlrZkxXMKTZ3/P4vZKJ8KaMaaI+4wE58ExLQTTTkN5tyHmmv2rk8EQKXkgxED3J6Qe6aJzmRI1yn7yVIDHDSq3nwRN2pfwKacbdlD1z7xaBu9rtUWFg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(366004)(346002)(39830400003)(451199021)(7416002)(5660300002)(44832011)(6666004)(54906003)(2906002)(41300700001)(8936002)(8676002)(66556008)(4326008)(6916009)(66946007)(66476007)(316002)(966005)(36756003)(478600001)(6486002)(38100700002)(86362001)(186003)(2616005)(83380400001)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bvNpJGv27WkgG/wQlhEt7VLD/RHMlyAa5rdn7Lpe8Fl8ukkhyn8xgwnGsjZa?=
 =?us-ascii?Q?SOiEAR9S/D1NDmynvp57YPj+VEi9a+DapclaURp1ZzxS5MKBpGEu+7aCUGyy?=
 =?us-ascii?Q?adJjykx+LuMOUbYXbveA2+XckU4COsYr9Lq/aEaB1l4ru72AGYqPhOWofgyt?=
 =?us-ascii?Q?Sd26Q9aAh0517wyonUuauY2xbWLmMMLcsAbve4v0tK0k283UHw2uu7/DcIzW?=
 =?us-ascii?Q?kbHzw5pxKvgWInV2pBakxMsC74uuWdDpAmToIBnqQ86bPaX1HwGD0gYpJnH9?=
 =?us-ascii?Q?PIUMXceX+7Zccknvccd2v1TFRxEKMiq67XDRvlZCiiXWg2/xn4AEU/hqyFV4?=
 =?us-ascii?Q?cqy5rNfqHfldyB9zvzTRcntFQPmD/WujDOjSyjmDZvinwIUcYd6/mLofEekt?=
 =?us-ascii?Q?ztphH+Z3i8jkk3CLtUkGCwJi3dlSLUqh3fFhCVCM+4dNfsY0VarfVOzPOPpn?=
 =?us-ascii?Q?Tg0GwehXDE0ajESLXH8Os4pc9hHYQs/RGmKEuSj+LOSBCPjGxAuItpFqlTdB?=
 =?us-ascii?Q?YBxFxbp2I/WlAad4EjwfM4dvp7QOP/CzLMCCdAx0RQn2ZrYlz0UWiPFZrwGd?=
 =?us-ascii?Q?ja+3XPIJpVHYUNU6NhjH6UkSUmGNk7p/CFfOdezeyclAW3SUkhy1CTDQOdWF?=
 =?us-ascii?Q?Zo2WHvykY9kWSBRSVDr0M4+1JnyPS+xz8+x25zRWR/HeENNNinrmNUg/qKGE?=
 =?us-ascii?Q?g27urKPp7SfWvKNkUlOYHdkNzQOH7JR/FX3dIWt8XFUfGoxVVHF8REGF38iK?=
 =?us-ascii?Q?/C7xhnOdLGvNHKoG3wf+euDzRKyK7ZB5jPnoHmmuawO87ypMbWV+yaDtQLbb?=
 =?us-ascii?Q?P3R01IOdUsrEFiius7CPv8wfCVUKxOp5g5MCLhd4o4r3FgJig/rc+Jbq1vjg?=
 =?us-ascii?Q?2PGas6jKIQ7pMhE9AOgNTaRhLKw1C2H48hRMy57iFLUcx59SuUUwaI8A3VwZ?=
 =?us-ascii?Q?+2nDvO85hS5SshKVNDJ5vcbzXFPEFqGZ8S7bwSUNFbES/1grlenTkE86Ovne?=
 =?us-ascii?Q?siUL+z0yKFKaMqu9Jb1qbTOwl40n0H9+1vxEGMnIungqk7zhlwqJhXCLSf/K?=
 =?us-ascii?Q?4jhaAQ6VgHW6ZIQzhNUVtfRYag9q1VqCGHVTOTjH+hjsWJ8fXHR11Mbj6f8K?=
 =?us-ascii?Q?/uizLS3UN2Ekklakm0jG8gTDzTpp0nMptzAKIbCVPXj1DzjiThfDKB2oHrXY?=
 =?us-ascii?Q?hokqZqsNYcNI8FQvjiE7YnGrr9Qh6lC6EIlsIuozYmNWkWDLgad5YipjmGJW?=
 =?us-ascii?Q?Gbskwcy0O9Y6p9G1enUI09bNgOzQuFabyeE2vVgF6v3w7Reh1hZKDDDAg5k6?=
 =?us-ascii?Q?5QI8nTVUiF3pmlZjnc6qUrv7KHQF9qIivQlB14Vdgkl+AC888Eh1BuR0DKtu?=
 =?us-ascii?Q?GTlw+AWB3OvDQxHqDhGEF7EATz+yB+46BLd24RXtQHcEF9QJxMuO1K0DtdsD?=
 =?us-ascii?Q?nw5GriWT8dGlceAiWIcmJHRqeK1PK5H/g+z3fuNaOtt/50NxVXvAruHEkX98?=
 =?us-ascii?Q?tiLRhBWV6nD2muJUJ0kOtGAkccHn8X2Lm47FtCD95SFeRmA+6HHMZZZZvnLi?=
 =?us-ascii?Q?bVVm+4Xt4YommX3RktjZSFG0qrowy1FXziIORZ7mdxea0ljbX3+SJqao9qIO?=
 =?us-ascii?Q?3e/Rr5gjP0UJfXtwSE20F3kwRPUliaHKm+1KLETVCGve0a8SoyI3A5YLxLM1?=
 =?us-ascii?Q?T9fNkQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63096b78-198c-4f21-0cc2-08db6e45aafc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 08:42:50.8426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hTL4o3YGp5R006AIOyiVLPuD1n4KfYSI/eYqMvO/Gw54CVzKT13eih8IalVhJQotavNuUFLGoYr4bo8sSznlTERFtdNFvhIbd7dYXyaC95Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB4455
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 12:04:07PM -0600, Gustavo A. R. Silva wrote:
> -Wstringop-overflow is legitimately warning us about extra_size
> pontentially being zero at some point, hence potenially ending

nit: checkpatch --codespell suggests: potenially -> potentially

> up _allocating_ zero bytes of memory for extra pointer and then
> trying to access such object in a call to copy_from_user().
> 
> Fix this by adding a sanity check to ensure we never end up
> trying to allocate zero bytes of data for extra pointer, before
> continue executing the rest of the code in the function.
> 
> Address the following -Wstringop-overflow warning seen when built
> m68k architecture with allyesconfig configuration:
>                  from net/wireless/wext-core.c:11:
> In function '_copy_from_user',
>     inlined from 'copy_from_user' at include/linux/uaccess.h:183:7,
>     inlined from 'ioctl_standard_iw_point' at net/wireless/wext-core.c:825:7:
> arch/m68k/include/asm/string.h:48:25: warning: '__builtin_memset' writing 1 or more bytes into a region of size 0 overflows the destination [-Wstringop-overflow=]
>    48 | #define memset(d, c, n) __builtin_memset(d, c, n)
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/uaccess.h:153:17: note: in expansion of macro 'memset'
>   153 |                 memset(to + (n - res), 0, res);
>       |                 ^~~~~~
> In function 'kmalloc',
>     inlined from 'kzalloc' at include/linux/slab.h:694:9,
>     inlined from 'ioctl_standard_iw_point' at net/wireless/wext-core.c:819:10:
> include/linux/slab.h:577:16: note: at offset 1 into destination object of size 0 allocated by '__kmalloc'
>   577 |         return __kmalloc(size, flags);
>       |                ^~~~~~~~~~~~~~~~~~~~~~
> 
> This help with the ongoing efforts to globally enable
> -Wstringop-overflow.
> 
> Link: https://github.com/KSPP/linux/issues/315
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

