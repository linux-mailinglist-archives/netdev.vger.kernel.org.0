Return-Path: <netdev+bounces-2173-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71B397009F9
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 16:08:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3268D1C21262
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 14:08:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ED2D1E53F;
	Fri, 12 May 2023 14:08:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3521D2BC
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 14:08:49 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2091.outbound.protection.outlook.com [40.107.92.91])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F044C0C;
	Fri, 12 May 2023 07:08:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oWvPyHjnONG2YSTc5pC6Hk0HlAbuNdqyq7fiu1W4MkYzL7rUlS3v0yrrhgwTChuBPzB6OXpBLGJSH3Az8mY4rgmQ4WTmtRmyTxjMPGqeAsRB58ucCsyxQ1CVPyfNqT/Fu7sYTCMn+gF2yRO0WpHuCIIn2rp6AJ4ftwXL6zO+nAbCCJW6LP8L1wX9EV21y1tD4wL9hHabgJyeHWAzvz5e2yE8EKu6CkgQM21hfg8UegxX6ZCIATG5XvxS9C8K19teJy3g8auzYkh0ZnKzZeko48A2Alr9nldqSc3S7EvE7/l6qyo+sgZBqfryOT9lyRTBfF1yoAliPGz+yDcUUdMmow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mSG6vBdSMbohx5Bw++s6I0tNK3HDz2DMBrBKlFhPBRI=;
 b=BLe2fmq1MnZbY93SWnBZqMbIhDxF60C5FJXxd9lIhbnzIHUwhYuJJA5qnxkpkgsioPwDrYPT9YxarI6/YVyAAGV7Zqpt+hHgmKqmOZgXbcVZikRm+SofaVpsxdSlSsvBPLSPBbWyKwKfkeCuhG++6N0pUcEFh2MbzRclvsuyo2XLdWVVUDQYkMPT+2ujp3MC0SdUf9MFfPniTFcvEtNJywtBm8BUbSAZ1FlG30p47DZMsd/IsuNleFlDlNprg5fbfAES7qPz6IiYK3+Bsv+29X8MyVsVvJc+5hEWUwwi3uNjpDoovjtfU44Jt5ulFfXv7e97idIGj0JITNZROxe3wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mSG6vBdSMbohx5Bw++s6I0tNK3HDz2DMBrBKlFhPBRI=;
 b=QYEkRFuCey65JC9kBOs++xjfqXXtj89VWSKEdMLkj9a6Z8Ay3pI8Gdm+BwKub65Rmp1kxV0Rcx49YbtlB4FkWdPqvVwUNKfBRhKdXLL/en9dL/MDSK7OHem1idAb30TLKEWZf+M6jkxGOWOTn7qLuhiJge2oMsqFFp6tY6TM/m0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4808.namprd13.prod.outlook.com (2603:10b6:303:d9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.24; Fri, 12 May
 2023 14:08:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.024; Fri, 12 May 2023
 14:08:42 +0000
Date: Fri, 12 May 2023 16:08:36 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Yang Li <yang.lee@linux.alibaba.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] ipvlan: Remove NULL check before dev_{put, hold}
Message-ID: <ZF5IZIlUwncUXBHS@corigine.com>
References: <20230511072119.72536-1-yang.lee@linux.alibaba.com>
 <20230511085453.25ef33fc@hermes.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511085453.25ef33fc@hermes.local>
X-ClientProxiedBy: AS4P195CA0048.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4808:EE_
X-MS-Office365-Filtering-Correlation-Id: f9b952c7-68ef-4853-c606-08db52f2646e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	t+3n9gK+S0SYpL/Htv6UfO5YNmR9ZSSXpRXiXD0MRWSmhmXm7YmqA0gmgTrHUqco5kGuYSS77ymcT3irj322KpFCf9Q7nx9/Y71aseX/RRCnRNv8FduF2WhisQlEY8Y5Z++0WxTVobPLN7YwWkyUyzGlDohYjcupg/up+Og1Gvv3v3mbUzhtpJtak8XT48ZUs8/58zHam1Xl3fH4/hcHOWg7xPcXz7wZMy+sh6zBZScPNPvm+I/pbqgg0TD/kpqtwPp34BsnNcCEehA7P0nZTjN0kVhPvXiN0YeUXsz5htFSkckl//G7PAmDObUtdEizL0b0jPBD+Zw5eWEIKXKm7zGofaT+1T94FlrnaMycJFXYERnfmjdjyXiZOVoK0BY5a1Rb8CJF276x0kEmu+9NJ1MGLU8iTpJo+zqqFhE5S+I+YkQlBbhaYz+RpwlHdnZ8cFdVY1RUCruPh7jDfebQ+Dht+tPHm8qO0t8UdXOh2rt6gexQCgx50AiMAnvaEdXnl8IOSZ8pxmDm5hPOGzUJBhse84IpHwBdMRBAs/lrluO/3ukwLN75Jv5U0+suZ+tTwCVwqa2tSjD8ajLfw8QpdUpfelZGGlvoTkRB0765dXk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(396003)(39840400004)(366004)(451199021)(6486002)(54906003)(316002)(41300700001)(6666004)(4326008)(36756003)(478600001)(86362001)(66476007)(66946007)(66556008)(6916009)(6512007)(6506007)(83380400001)(966005)(2616005)(186003)(38100700002)(5660300002)(8676002)(8936002)(44832011)(4744005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZRUj2p/LSMBENEOOf69qdtn6m0LEiYIOz1K40nIH6h2wRQKSzPDyeLacKP38?=
 =?us-ascii?Q?dHnv89vjYaYUM73lgpkTS0qQxKtc87h3ObmS/Thkgs3jnEQAkCoFZQpH/uS1?=
 =?us-ascii?Q?jZ0xpel/kL987WiC11OwaGtpMV2hUI3ZXZtbBw+WLVNjFnszZK/X0GD0MxtZ?=
 =?us-ascii?Q?uB3sWlp3Ntyaxlf3aZ9BktmM22A/HNKd/mltl8ITEKC/eRCqPoaQWeEk9MsF?=
 =?us-ascii?Q?gOLaKtzxxopLrCWAn+bmnHfxJgGX2e6DXwZe4Ric+NJoHdfD+7NNt+0Hmk5k?=
 =?us-ascii?Q?6ngYKy7TpRts0f1Ax2WcIL1BOLiRX4i3zmiar9kBWPrtjkVR/mH+HCeBv0y+?=
 =?us-ascii?Q?DvexHzme+ghsi6jzPzSgpx1vhnwykoXHmIENW26wZ/VAcKTQMsBra45yPKQr?=
 =?us-ascii?Q?6WKzrAMei1eVlq3T9fAnYUuT8thQvKRioaBBR7nrCh/PznhWehAQ28L+hdjW?=
 =?us-ascii?Q?LLHaig0ouWrCXTwsLn4CEEPemWcvvMDXXa2ri0HKrjPlfnF8yUYlxY673TgP?=
 =?us-ascii?Q?ym7ik3zCmVWGZptEv+Xs7fHWe5ro29+IITmqzKodiMO3p/61lMHoIEq3bn0O?=
 =?us-ascii?Q?5NQ69RsnGD+jWytwSH/GCdKuKtJqa17IcNSJ56clLOdy3YpIPLmADcaSyuZ1?=
 =?us-ascii?Q?Zd/dy9ldSlnSO1aYQDECsaNOR3ynYrXkLpmwrPsbd9vS6teLKuUW7k+qgrDr?=
 =?us-ascii?Q?3RKTwHIGK+gY5WBFvLbVCc3S6wD9FQxyqnh4w0knPFBjj3Y7i2A0eeDpMwIl?=
 =?us-ascii?Q?xYVwO9rE/nZxFFfWAkLkONTOknTBd/+gBZ26DAoYir2F1bIcCUF4jhB3TcBb?=
 =?us-ascii?Q?SoNvHOxd/mOuTV+hCFKQPMvVYpKYvJuwipGzf3q3s81VGDkx1VFG9JOCpnd+?=
 =?us-ascii?Q?8yP1YBFyxe1Q5NjoebUtbWZYlctamYK4GMRiCGR/E2BmKnMYFk9fqXCH35uH?=
 =?us-ascii?Q?XW+Ke8cmKB5fnrTYD66HFNcRK1SJoxFL+jJalXrPpCf31kvTnRxYx84mMa27?=
 =?us-ascii?Q?MARdP3Emp90NFsq/Bvk+GME64+r2KcuZjP15XqQJe1Tt9U/jlCrShtyuZF1Z?=
 =?us-ascii?Q?z2P7oLRMsxhr1jFTLEPA1YP1fNXnSz/oLB9Z5y8hao5QNcSYR9jCy8byBGhP?=
 =?us-ascii?Q?gJT/DF3Twd5ZuWvuVqOjGd+2m/BnFvQ/WKorWCCXOe1AXh2XMNx3AP2K+OHz?=
 =?us-ascii?Q?kiuKffm+Ka2SN98Ut09XmQSkMRJgI/m1jDdTGOjqQYplpbYwO+JwjfPzBaF4?=
 =?us-ascii?Q?OlysVg2CNxko+BuUmaBpeUNojXNOuvghGOWj4MUTN6ycdOg97Csj/JvYZr0I?=
 =?us-ascii?Q?dgPazlsBTkamI2qdehO88l1M786zYEcS4G/vWgNZwqEmlm6HSqlm9JBzF3Q1?=
 =?us-ascii?Q?MuqJArl+s9qGFKw8zREU3ibi/Gq9GVItrZWi2+Z6gd0zMyo1znnT/o+Xm3Ou?=
 =?us-ascii?Q?/J1Xly23t/fAqLRcKyPoPUkH3VR6Mnoyk256pcrTl4gm1RN8Ytkvfn0qRXtY?=
 =?us-ascii?Q?3xnxJOROIwpddEaWC7EHvYD8FoM5Kk++CzRTC7SSvvhAv6Qj8ViPpx4wEh7A?=
 =?us-ascii?Q?WixlVELHHfR3sCJIDg/7msZfjQ1dKEa5l+uJF+GmQ7mzRLv2nh7g93l08I2D?=
 =?us-ascii?Q?LJ9TcQFtK/JjfJyQlAozeroUcgFbklhoHEyUOXt64228HXLIZaOYHH4kYEDe?=
 =?us-ascii?Q?aWBPqA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b952c7-68ef-4853-c606-08db52f2646e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 14:08:42.8089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AJwakeaf2GVdKS8psXRIaG2Ny6ecaV85jHnt28Cw9KPalvw+M+DoE3WfVCdpQa0Kipjq9twW7r48r83W183H5koYvkaqZNqkT0c318hte/Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4808
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 08:54:53AM -0700, Stephen Hemminger wrote:
> On Thu, 11 May 2023 15:21:19 +0800
> Yang Li <yang.lee@linux.alibaba.com> wrote:
> 
> > The call netdev_{put, hold} of dev_{put, hold} will check NULL,
> > so there is no need to check before using dev_{put, hold},
> > remove it to silence the warning:
> > 
> > ./drivers/net/ipvlan/ipvlan_core.c:559:3-11: WARNING: NULL check before dev_{put, hold} functions is not needed.
> > 
> > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> > Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4930
> > Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> 
> Maybe add new coccinelle script for this? scripts/free/dev_hold.cocci?

FWIIW, I observe that Coccinelle flags this problem as per the log above.
But perhaps I am missing your point.

