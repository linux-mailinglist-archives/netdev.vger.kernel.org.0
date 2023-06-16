Return-Path: <netdev+bounces-11321-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBAAC732993
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:12:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 973A728140F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3A749475;
	Fri, 16 Jun 2023 08:12:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43DA6117
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 08:12:18 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2113.outbound.protection.outlook.com [40.107.93.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264312965;
	Fri, 16 Jun 2023 01:12:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bg+ad2xo0ri/vi40WH70F6pTbTGonC8a035oWYz4wbTllp+laHaPpJntXDhVi6FQed4GWY+ZohPimxtyAyQW1Ov/W8FNNkfaYe0XCluPDLt8hNS0p5NiOE5mqrBlx4qQZHnk47m3paNCGxkrKhduS5m8nJYq0NMZirYonL++ecaszzjsuPs+H1W3FasfrtESiecYv168u2ZIH4S4EI1vPU90+f3FafjC8WIlGE4QpqfrX7EyN1M7/kImNApXNvbdFYhzS6IuBV+8tjrr0LtIizsCCwkp9rLS55ANapqzS0DdLqcHr97aOof7nWEORDSipOH9DiHhU1ul22mqqZ5ymw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r9swZtDOrTDgjTLZp9nfg+3ikj8Jyj8mVV+JadDP9hg=;
 b=n94loMf+OWZa8OypZrrZS6dFzFXN0lbiVpU8YD571VLS3aM4bV0rl0gIhbmT7jbrbA319F9Jd3UgQCuvpHAs2d+epzOPJev62oSj64nSD1xT2yQw9rdax/2ENq9uqA1lDLTXLerbj3QK6NMB3LCZUNyIWxcSnMQD2/0E2Hrj4aJtRaf6nuV42mleZrQ7yWcRAW+PlegTcai0SUhVj0bSc1ebFQIsQf/zTmnKweTGw1h5K+cyi4y4oqFQjfl/MvxgQjO4hZxYNzzytnpAUQ6ScHrom+NKzQ6RPvS2Y2sc9sFQlu/eGMANbcffXFIW2p8fZwPEVzSatTWW8eyU8LO5GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r9swZtDOrTDgjTLZp9nfg+3ikj8Jyj8mVV+JadDP9hg=;
 b=vl77tNPuvc9uEdvVsjZQX5SIVnGNrAOvwkLtkKqIE0kOqdKaX7h5AzcAT+o496CIDrUJ1ccKZGxcI9UerpIJWaOqvq81qnwGFzPTPC90CgS83X93akHNoUCUil2szBlDG/pOtQ2Jx64+oE8ooDQ+0GNkTxQChik1cmaxF7nVYQM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB5026.namprd13.prod.outlook.com (2603:10b6:a03:36f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Fri, 16 Jun
 2023 08:12:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Fri, 16 Jun 2023
 08:12:13 +0000
Date: Fri, 16 Jun 2023 10:12:07 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <ZIwZV9UXCd9PVoVG@corigine.com>
References: <20230613164639.164b2991@canb.auug.org.au>
 <20230616083033.748f2def@canb.auug.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616083033.748f2def@canb.auug.org.au>
X-ClientProxiedBy: AM0PR01CA0151.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB5026:EE_
X-MS-Office365-Filtering-Correlation-Id: 96b43a1a-7f46-4124-e886-08db6e41641a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	s7rTmw4Dzmc+ydhvKb5+h7u01M+c2NHaEzHrtI5TtT9AOfBwEmZzVdNHpialnMsimtZKS375KdyQkTljvRmqzAQCLBHk8O55hSACIlDSjHpPWixzYsS9NpsV/p5VDirzeIQWgIed7gBrVxuSk2ytetPYWDI46VBwxMeR7rc/+AqRNFffp3AMLpo4VMM/WIoCfCS+G8bbbE49RZd8HzbByYPlGWsx/0mOhh5OsVP26XTKEXFd/RbqTxPklN4u9O87Vw81NNg4m2GbGizn8sraA+RcUMGAshYpyLJqDhRCQZbKYcqZgl9LE1mooHm7qpAVAfOdm59ciY6Ti9nRC6MypERJpf9esdWdg2bDNkLzojDzNzIlNSAuHro9hNEdAvpk1tYoqqPrC3s0rJ+VGuoFC6IP45F9DhTqameAsZLhxCc2XKmalxmpOKc1TwLL+XozekSDgNxIIQjI9bMPH1AOxvm/YnkxpXsEPY3HeD7CRx4ZQOr6YLj31/fAEUubifRcgd3g1SRPDYxTHKDEoeQV3uC6DQpL/gex/a5YJR+oLHYgyny5ZxktL6vklP+tgPpZFMaThjmgF2IzAhnitqY6q4Mv8ymt2M7JUlq0rh5cVzg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(39840400004)(136003)(346002)(376002)(451199021)(44832011)(4326008)(86362001)(2906002)(316002)(66476007)(6916009)(66556008)(66946007)(41300700001)(8936002)(5660300002)(8676002)(54906003)(38100700002)(478600001)(6666004)(6486002)(83380400001)(6506007)(53546011)(186003)(36756003)(6512007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S82sTasFEV5CJUsxaOf9gasXbm1awStdMQ333jOrHBKB8x2tIxfmHVV8yLyB?=
 =?us-ascii?Q?/Xu20yzUBQlu2qazNId8BeS/PLomH++2afcl8qABY/RhmxVppXa4U8CIqBC6?=
 =?us-ascii?Q?C8W4VSr1NJUUlN21YhU9cHMYHgVXpegz7jlvh8TdDAgKYBrqMrIP//hYc4Xx?=
 =?us-ascii?Q?n410AQZt2y/+q0cxQ2LxZs6UmYILoYZ1sTDbvaYjSV8Gy7LYNWR1uU2LSDgV?=
 =?us-ascii?Q?DCgx0VmCO1zKq+kp/iReCLwH0JN/XA7EfxTwdslIQkcUxxoONIp04hG87K6m?=
 =?us-ascii?Q?1Sg72srQOMa5wvMZOzM+tKtkUS75qq09WE7pCeLIZIOUHtsDuMYHd03MyHwd?=
 =?us-ascii?Q?/3qB8cZJNiNq/cMUuY8T3shq7C0jedGbe5wWGoqPmrhJ8M16WHnGIPEAdfdG?=
 =?us-ascii?Q?7g5FDdtfBYY8ETV6QBZn/91Dg1Y9L6J9R+vAs9xaYlMpr28A4FyyP7OHllSw?=
 =?us-ascii?Q?AEQdyLcTAd6DQt2ar/dYvdZNM2Uwb2qAau2aSPXeCGnpkLoK2g3E095i/X4h?=
 =?us-ascii?Q?Wzn0ftM2SL+2gLYrbxpjunDl4JiFaP/7EZAtmUNehb0ATzk6OnQNKm+pc/su?=
 =?us-ascii?Q?E6IpLJLd7Qr+J7JsiKzLADG4vp6yLYY65brnar5gcg5PCtwjxVvlTPdGMx2O?=
 =?us-ascii?Q?BtiC89UH0TGAW9+b1oYCSTvJLR0LM+h3tjXxBnEOxvi3EK+ohV9TUWxkFAhR?=
 =?us-ascii?Q?95qyXHcfAAI/zT6YFILRo6s4+P5ZiMBWc16ZASbRMUszpQPqybfvaoPuBcPi?=
 =?us-ascii?Q?C1HpiSfM2Pk+wsPDZR/ST5eXBiluMN6fXT3xHWtNtguY/xF14DMqmKs5gMfc?=
 =?us-ascii?Q?imLG2lfh0JI//tNr2WGG5ovFhPzJQupxszXt15bPDwoE7/5+pcW3ujjtqn8o?=
 =?us-ascii?Q?5ZU1nmGrGn7gRzV4zAFAoXq1hUhpLpyVqY8YUzbN5lR5T+WqbmKQHJc2KVws?=
 =?us-ascii?Q?M2GMloyt6PVCNLc8eV0vU94PNUMJn3PZIww8Oy7j3sjVAPPW3lkUQO3b49Bz?=
 =?us-ascii?Q?lCfsQuKinKRw4v/HV7+x7ZM3Zy8Yy/1SA1j6ypteLxQopSXRDeaGlTsabvTL?=
 =?us-ascii?Q?Pu9jhYsqVYRxgyilRwX1S4oEcyoc948KMVrWn9vAp8xq8FBqowWeONJ0TPQe?=
 =?us-ascii?Q?zLaC1r4oUDNGEhNXIhWp5xjfwRwnqT//YOfkw13+t+SItdfuTXZf3FgiG/+J?=
 =?us-ascii?Q?5Hk/FPXFuZhUp/REAPz4B1xXyNsk0MfZoi0Sn6PmVsG/Iwm5vvUxfDD9wJRa?=
 =?us-ascii?Q?AB+t9eApjUy3PfQ5v4/Al6Hwv7FM2YZdX4Foyqdd5c0yxR8Oo1eB3Bm7oj+f?=
 =?us-ascii?Q?RRDjRXPjwQEErUlDFuEJTwDpRyim/DepyBrs1U1AWtN+TGdyL4vtOSqQk/68?=
 =?us-ascii?Q?BlZ+Gc8ccWQDHBjcL5ZWfgtaz6Cc8bQ+eM/TMA+Lyi4xNGBJgGolXqdO+7yZ?=
 =?us-ascii?Q?l+5YRSI1PSRlDSt3qDlR5HOOgxb1+DX3JUIUR5NlSf4TY1U+WElNJKszAK8g?=
 =?us-ascii?Q?r0yCKAtZs1gsRxKraBg1sJ0sOKTS84oCUwAun52CxRdEqw37skM/Fu4NtFGQ?=
 =?us-ascii?Q?5zvhZN0neDsB0hUWytp1/uoGmB9ScQ6DkFswjQFAHFSdMVgBaJFqmHVrY70K?=
 =?us-ascii?Q?fv4PV/+prqmhQoHd0oPXh1cnl7CWWdSSd/ssy8kK/xTlceXfjaGW5WUFnGCo?=
 =?us-ascii?Q?UXDCIg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96b43a1a-7f46-4124-e886-08db6e41641a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 08:12:13.6828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4qu0DmvshMQziIGDuW3eXZCSbClgczGsM8rbTp+IYMnVieh7AO6VIQgIn8uhsor4rg13GzH1DIOJlmZI8uk5YR6yKCwqIGPdQKx7lDLeM+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB5026
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 08:30:33AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> On Tue, 13 Jun 2023 16:46:39 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the net-next tree, today's linux-next build (sparc64
> > defconfig) failed like this:
> > 
> > drivers/net/ethernet/sun/sunvnet_common.c: In function 'vnet_handle_offloads':
> > drivers/net/ethernet/sun/sunvnet_common.c:1277:16: error: implicit declaration of function 'skb_gso_segment'; did you mean 'skb_gso_reset'? [-Werror=implicit-function-declaration]
> >  1277 |         segs = skb_gso_segment(skb, dev->features & ~NETIF_F_TSO);
> >       |                ^~~~~~~~~~~~~~~
> >       |                skb_gso_reset
> > drivers/net/ethernet/sun/sunvnet_common.c:1277:14: warning: assignment to 'struct sk_buff *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
> >  1277 |         segs = skb_gso_segment(skb, dev->features & ~NETIF_F_TSO);
> >       |              ^
> > 
> > Caused by commit
> > 
> >   d457a0e329b0 ("net: move gso declarations and functions to their own files")
> > 
> > I have applied the following patch for today.
> > 
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Tue, 13 Jun 2023 16:38:10 +1000
> > Subject: [PATCH] Fix a sparc64 use of the gso functions
> > 
> > This was missed when they were moved.
> > 
> > Fixes: d457a0e329b0 ("net: move gso declarations and functions to their own files")
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  drivers/net/ethernet/sun/sunvnet_common.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethernet/sun/sunvnet_common.c
> > index a6211b95ed17..3525d5c0d694 100644
> > --- a/drivers/net/ethernet/sun/sunvnet_common.c
> > +++ b/drivers/net/ethernet/sun/sunvnet_common.c
> > @@ -25,6 +25,7 @@
> >  #endif
> >  
> >  #include <net/ip.h>
> > +#include <net/gso.h>
> >  #include <net/icmp.h>
> >  #include <net/route.h>
> >  
> 
> I am still applying that patch to the net-next tree merge.

Hi Stephen,

I guess it was applied after you pulled net-next.
In any case, for the record, I see it there now as:

  d9ffa069e006 ("sunvnet: fix sparc64 build error after gso code split")



