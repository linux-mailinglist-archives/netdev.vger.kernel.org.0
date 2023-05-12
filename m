Return-Path: <netdev+bounces-2064-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09FE970025B
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:15:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15D211C2113F
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C61FF944D;
	Fri, 12 May 2023 08:15:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1880A56
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 08:15:22 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2096.outbound.protection.outlook.com [40.107.212.96])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB2590;
	Fri, 12 May 2023 01:15:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmO6OnPYSeAoB/URQ/DZNrlTwZW8j+78/4Hy3QTGRm4VPa5SFxURJBf3jJITGuAfluwNoMZIjIHoOsZluqLN83mq/ztFBz5rJflUVb+tOWAj8jOCnhNx2+SCjYdsGKK4JdCnsZns0/64JCj9aUzqxPC4inpJL/gwYcy2PH27BbVX0gWTj82eBEyguo/8K6M1VzCEvBOx2+cQXtJ/CsGruRp5N9fv0uBie4BVeyQICDKRy2dLZEJNykYBd6miq0COnJwfP1v2DhS2zIpvh6VtfFUr8cEAAFuZ1u2tCtTmKAeblSVnMn27dpiUAHWVbzTxw4ujCIX8byks+EinqWI4sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CgeVkZPZlgqkGXAo9xhdU480c+cwULsBbinZmJWYnIM=;
 b=Bln35hR3tW+UM8MGdmjqnJi5Xlw45PM+5FVHsz6O1gMVooEBWp2UtO0onY17nZK3aHMKJH5zH1sIrasZfGfkSYUqUcvvrK/f6kK579L6LkzJw04XVma4gz40g6yX9f6+3B6qHFBFsp8GVjGTkc7zLuhPMZMbQWtppbyraTeUhA0/TPHoTa4jOV8NCl6ZKZKaGeamB2fToiOZgkTrAFh2tSvYWJDMAn/aGiXB/+TkZioTdii5XG3NasRlIONvjcUgGDFcyk8VLmrnAaZUMs/bTK/woo7Vml4HLPxhQ2kPsTZ9cPHSh1YgQjkxFA1hwrGv+VpIVfJz3sWK4xbPfhjL0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CgeVkZPZlgqkGXAo9xhdU480c+cwULsBbinZmJWYnIM=;
 b=lLprkHy0I9SOwAIApQ3tTTtE+LWrWLTCvysPdoOoZC/QfOIDANNvdTGKQJnl1ooqa4bRTlanM7JOJDqZENv9DrUDrCVOD2ic0/DcSDIhV5XvHGDIZIfwFHwKaYdeqq8bbPsFluQNi+fpO1Wh7UpGtL4v84+WQUWsjZF1dqHQGO4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY1PR13MB6214.namprd13.prod.outlook.com (2603:10b6:a03:530::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Fri, 12 May
 2023 08:15:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.024; Fri, 12 May 2023
 08:15:17 +0000
Date: Fri, 12 May 2023 10:15:12 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Bilal Khan <bilalkhanrecovered@gmail.com>, majordomo@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] Fix grammar in ip-rule(8) man page
Message-ID: <ZF31kDnecf0t19HT@corigine.com>
References: <CA++M5eLYdY=UO2QBz17YLLw8OyG6cDYHm1dvs=mc8zQ7nPvYVA@mail.gmail.com>
 <ZFyyK4Cvcn//yZdV@corigine.com>
 <20230511085009.72b9da9e@hermes.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511085009.72b9da9e@hermes.local>
X-ClientProxiedBy: AM0PR02CA0219.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY1PR13MB6214:EE_
X-MS-Office365-Filtering-Correlation-Id: 99718443-e57d-443d-6130-08db52c104ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	oJ3+Qcq8w8Fpx3ja6i/NztG4Zlc8W81ggc9VwdAHIv0DfeevUbmFSz+Yx/lvurAuYwmVU807svB5WCCioYGlPfTbMeaTtgmvI6//Agxyhhy7f7B9TDaskLk3mqcAVBqIwleayKQSeB257LFpmIRpvJ/iHSBnDQRUHpmPHtPysRvp9cuj065D+WYOCCj89PIeWj+h9je/tHCHRkf9hhche5UJfcXhouRyt1Vuq4LMIaIbb0FxR00RJmfPv4mzzNb3zgW+e4pzO0LNYq/cOOXYD7gJbCOEg1Km8k+2HOagDw+CcFWfAvanKuPUBaHn5dZ8XW45zYjvL2RcvndMbVTd+q+PdI+OnAAN6GA+6ONisnGeY/Y2hGZHUjQoqoxure+rUAo4eSf0V7GuJdKL/tr9KaHCZJAEtwKp94Np9GGzMm/VagTmaB15uTPq8Bu0TAVKqfP7VY1gwA3QHECNi8tSwm92sbm4o9x4xIIWKhcBvZGp+frG+Nf/sgg0yz6vcR+yrt7AS0ql4ZJkPGJpGIQMsaMBkKJQkCoioeCDx7WTom9W5+YWBgQ3lvbcoUUwH+G/
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(366004)(376002)(396003)(39850400004)(451199021)(6666004)(2616005)(83380400001)(36756003)(6506007)(186003)(6512007)(6486002)(4326008)(66946007)(316002)(2906002)(66476007)(44832011)(5660300002)(86362001)(6916009)(8936002)(8676002)(41300700001)(66556008)(478600001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1k1za2W6i1BaWIT0o921sMLYK1dFLoRawM7BXLr8I0Uqg7ZYf+qdozD/ybVm?=
 =?us-ascii?Q?6oTItmf4hdZ+++snd+0oNUIIt5D5tt+wcZ7BI61Nt22UR4kpPQhgN+/7yNT4?=
 =?us-ascii?Q?S78aGrwKgFizUMv7tA5mznRy89Wo6z74fOORpKk+C26pM9YEhumbCTkLXF8m?=
 =?us-ascii?Q?YpFZAM8zIIJzfu94qFKW5XVoNgVeymCNkJcPxUurpiWgpaQKU4JrD0/X41Jo?=
 =?us-ascii?Q?LjdUFrDYhS0YIyGoE7F2r0Vj2+ydxWpSCGHPKXxJcmGFRP32cYOMaiuvu5+Y?=
 =?us-ascii?Q?QFzRb3K2E3nulrubgArHUDVdblWT6eNcjomN8n4O8GaUT0tMN+jxOC0OxZsH?=
 =?us-ascii?Q?at8+F/7J7fx4ICKNNQKDVmFHzP2zUtA1l1he22N92Xtepy8vCynW5/msOjWO?=
 =?us-ascii?Q?BPAbm1IJExrR1PI3DnaLmQv5F5c3s11eHMMD+Pp6PZinpl5gCtcQTeC945ez?=
 =?us-ascii?Q?yCqrKAdQQ/R+jnIrwmgArqgVzdO6R4sp1VyGRoYsVESHvDBD2AuEs79mNXX1?=
 =?us-ascii?Q?3PJhccx8rStRK70RreY0dEL8IRJurEtJ2NYjIdpWkMlk9BTniXyzfgLJqGwa?=
 =?us-ascii?Q?rodxX9ehWOe+Q795idgAN8ZpuFT5sLbabPbsktXD8DnwHxyP4t2inqof2NIF?=
 =?us-ascii?Q?+KtP2EeQ4nDWsPe3KLJJ0lPeNnIGUIpa2rZ1FpcpZybTCyGyHK9umMTawQBQ?=
 =?us-ascii?Q?mYnygoeq5dHZ5V/FDIVRjbC4i8yMe3lcgoQfw8oIXb87FyHiCaQxoj3OmWIa?=
 =?us-ascii?Q?uqkaOvCuj0nwuN/8B4XX9fsMsB7M2kGqV+1bMstqL9uJHPJ3Ps30uFFXrYKt?=
 =?us-ascii?Q?5dcgIa5S2/GKuTTEXn3shmp37eoP6J8zgfZ2PquG/fDk7NiFdrqsHm9Rvh+4?=
 =?us-ascii?Q?gLejspSRwfm+agYwsCAxIlxrbza23wVl9E7Zlijrv2Mm8to5v7KTTeJ2Gnto?=
 =?us-ascii?Q?/oF/Q/3AX/vnSyDWZxdbvTUKJVR6LBLqIi8u51KWbkMxOSygUKTXp31Q1orE?=
 =?us-ascii?Q?PhMbk+3H8r3M/WrqtGknIxFDUnOg+kkJFMb/KS08e5TjpT4qMBTrOeo+9i5B?=
 =?us-ascii?Q?UyTCpER/j6XCKDCF9hi4yHeyfARn1MMB1RoK8Ov/PyPQK3rw6F0eirjmBpbN?=
 =?us-ascii?Q?0SklXoHJoqS5OiTBDTmffxyZ0YHZkcdpNceSSKJrMyHT8N4X0nJ0zvDZO/v3?=
 =?us-ascii?Q?jRg+UKAdqJwoTX/5qoNb0jp0qal+o6xTiuByx5B3mKOpxqBEVT+L+/+GwcXC?=
 =?us-ascii?Q?uJnY9N3/BJ9jC2HA70iqFNz51BX6ufDoHo8ubT95za8UMnq2eS/MCHkh+oml?=
 =?us-ascii?Q?IZ0C2ctkGDtwerXPMzskz5lJbpZ9xNPDIk7sDS1mqzsF5bhuSsosR7s/HiXi?=
 =?us-ascii?Q?H4hYzu6IEpLyscQkx2IQEpitdjIpDrBnFizQCDlBLnCJmWvyAQQrxkrCMf/W?=
 =?us-ascii?Q?QlU3FU2grTL6cAGbgtsN04nH4RB7wyjRTwK/DRsOQ9bMY3Bdt7z3jqYryWJl?=
 =?us-ascii?Q?9JFPNyE5HFIvSzpt37VH1JYE8hK+dQIMtW1xJ6QCW8gxmIQVHTK4+lyBOKPZ?=
 =?us-ascii?Q?j4ghSowTNof6Gsgpc5oUHv12CHRL5blVD7VODus39BWqzwir/QAC3XCTb1i3?=
 =?us-ascii?Q?QObz4JsYy1dM/p/xxeNqNuc11gCrzhG68HDd26Giy9Czz0F28gqkyZEYZ6bp?=
 =?us-ascii?Q?4XG11Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99718443-e57d-443d-6130-08db52c104ee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 08:15:16.9448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TSXyWsxPJjLqZx/cswA9P3/W4VQAxoCLX185MrM4lGrwiK5jNkwpKGTA/PJ2UvHwrsidV3p5sCi0NVlhpBj1zl2Bym/e1lkJh2NrLHXdwOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR13MB6214
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 08:50:09AM -0700, Stephen Hemminger wrote:
> On Thu, 11 May 2023 11:15:23 +0200
> Simon Horman <simon.horman@corigine.com> wrote:
> 
> > On Mon, May 08, 2023 at 01:05:02PM +0500, Bilal Khan wrote:
> > > Hey there,
> > > 
> > > I have identified a small grammatical error in the ip-rule(8) man
> > > page, and have created a patch to fix it. The current first line of
> > > the DESCRIPTION section reads:
> > >   
> > > > ip rule manipulates rules in the routing policy database control the route selection algorithm.  
> > > 
> > > This sentence contains a grammatical error, as "control" should either
> > > be changed to "that controls" (to apply to "database") or "to control"
> > > (to apply to "manipulates"). I have updated the sentence to read:
> > >   
> > > > ip rule manipulates rules in the routing policy database that controls the route selection algorithm.  
> > > 
> > > This change improves the readability and clarity of the ip-rule(8) man
> > > page and makes it easier for users to understand how to use the IP
> > > rule command.
> > > 
> > > I have attached the patch file by the name
> > > "0001-fixed-the-grammar-in-ip-rule-8-man-page.patch" to this email and
> > > would appreciate any feedback or suggestions for improvement.
> > > 
> > > Thank you!  
> > 
> > FWIIW, I'm not sure that an attachment is the right way to submit patches.
> > It's more usual to use something like git send-email or b4 to send
> > basically what is in your attachment.
> > 
> > I'm sure Stephen will provide guidance if he'd like things done a different
> > way.
> 
> Applied and did small fixups. Novices get more leeway in initial patch submissions.
> The main requirements are that it correct, applies clean, and has required DCO.

Yes, of course. Thanks Stephen.

