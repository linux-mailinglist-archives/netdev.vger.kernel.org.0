Return-Path: <netdev+bounces-9445-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC07B729175
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:46:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 585A7281868
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 07:46:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34E3B944F;
	Fri,  9 Jun 2023 07:46:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2761C8F76
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 07:46:41 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2139.outbound.protection.outlook.com [40.107.102.139])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931FA1FEB
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 00:46:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AC5cKrcoMB7h90f8zpviUOsCr5IeKetfLoHCBAinG6n+GvJ/f7YrQPYIQHjG9DRwKrYJrZ5ULdWw2sZjkSHNHVOP7vkRDRfpRCXpSrNHhSVBlUOZD///VLCmtmtIRSLaz6H9RdMtcvma7gROV5Q1ns1iBHRXRiejbOvvBDZOArQvOPkQEydzQ6ZMZCJkwjfy4KlTvQZsLhYMf7iE1cFCVvZ6UpS6AsZiWyvnnfiB3pgRDfR3MwyrKj5xHxMzIyNkrzhN9DwGNe5aNFRkvhYbeveCO11N6o8o3B5vCf0hhQjlYwPuyJEIc2CQmz8VNGoOTQrUKINt5U4Ps8I9H2IPYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xz3Bt76z2BFaAWF7wO3X29NeCX5ZJKqEhYRlP7khi8o=;
 b=B/0YdFJFtAhp6j65fvADIVjkk+x14L4widQZbk7KdoXYtY+OvQyJAvns132EV76CqtYfsemqutR7TvaMsuU1uo1VwW4rRRzwb6SZH3c+jgkde3nS5xGkkeHW3Zf1UmqSMkwst7tNFLRokbRga1HI+eReH1C3jTDwYzdaN0DSbES4PNkQIkhPolIIE9RTH/4IG7rF+h5wqZhchEsCP9M3C3xAMAe7TjJv/eudu/aurW00khdN9APy4E1kZ/i6eqYIZOtjzLKByjN6tv4SQCU5U0AnZjLHNL3XceyqxHNKxOkWFmnLk6+kYP1WtFnfdEBa7kfznLpTJn+NQSJ1uQXohg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xz3Bt76z2BFaAWF7wO3X29NeCX5ZJKqEhYRlP7khi8o=;
 b=aARI/Dt/p8R9Vv8Li6I3vk2UlF15j7J5H+J7OuQjZXYcDE/+7BHj4YmB5hmoizYKjd9INzf+8YXmdtTZNvtwFz36EgHLi6hf5APb6kXLwytwh6nqsQNqFzgfG2Yu5TdSmGLYsXaIcMff0OnmrNq10eNuKyNKVPW8lwjlhEVcWgc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV8PR13MB6551.namprd13.prod.outlook.com (2603:10b6:408:1ed::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.11; Fri, 9 Jun
 2023 07:46:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 07:46:38 +0000
Date: Fri, 9 Jun 2023 09:46:32 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 10/11] tools: ynl: generate code for the devlink
 family
Message-ID: <ZILY2PZnxvE3c8xb@corigine.com>
References: <20230607202403.1089925-1-kuba@kernel.org>
 <20230607202403.1089925-11-kuba@kernel.org>
 <ZIHAIdzVJVMB7jDN@corigine.com>
 <20230608085300.5294f323@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608085300.5294f323@kernel.org>
X-ClientProxiedBy: AM3PR07CA0077.eurprd07.prod.outlook.com
 (2603:10a6:207:6::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV8PR13MB6551:EE_
X-MS-Office365-Filtering-Correlation-Id: 87eb1bca-4b2a-485a-da47-08db68bda7e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	J98Y8OVEQpGohc4sEbR59jSir3mhI/zuRgaFRpqizOAzr0IjlDRCdF9qw669E1ZPzk7/uU0aeI7iYZCB9aSfvwH+NQTuHU1iiSotjN+CboPKYqRpgJo5fx3Ke7AOmhndInt5vW9EJdZV+VGFhW4Vr8eQAPiIcY75GF/6cuQUadTNXi9DiqjBUGeY/wdu5T7eLXoHRmK02vXn+dtLinrPW8E49wsEyZNzHUWNXotnfzJhw/ig4RaH3lwN7tjugVsAWYPU5kwMSNgd05m8LC3X2/aavDNme0iqJyxM33JCj2+zXrvbSDmGz9YzB8wxKjbAG4mGFfceyI9uDiIPh1VAnsOBn0qdzW0XOH767h+7HKy9mf+rhMTrK7nKvsZDdyna1LN1kfZ6xkb42FOCsH3gV+c7UT/C2moIOE4JCP1ag8P0Ozxt0Cg4HmR63UWz/hKqFS4S0+DjQ0t0uH+pYVakuTbORxO6r7m0p0uBAHo+ICApBX+Ekgkp8lqSpTx8o9JR3sigVruU/gz5m5vxaJk5aSq4GPoak0ld0hut/7PT9DDUAGKJw7zkjbU/Jn+U2eJg
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(366004)(396003)(376002)(136003)(451199021)(83380400001)(6512007)(186003)(5660300002)(41300700001)(6506007)(36756003)(44832011)(2616005)(4326008)(6666004)(66476007)(66556008)(66946007)(8676002)(8936002)(478600001)(316002)(2906002)(6916009)(86362001)(38100700002)(6486002)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pFbSX1gQIOHdLSWf0TTHP4jL7NbGylarJa02li44ODSwi01HLHk0XLyaPOZo?=
 =?us-ascii?Q?WnHSdNiFGwzoL7Nl8AfZqzzBp+fgXNPoHxHKdo8JgqSRBTvAcH4zRzovfLbC?=
 =?us-ascii?Q?fax2R3HqQibjK+0LTxnG4YqnFpYGvAgXps375tWQ3r/lXVm6VJJ80H3pViOA?=
 =?us-ascii?Q?v+r3T4dtpT2m6zuypV8qnQOOpn8+JHq7Cne874ANGxRGJtLT3D8nPuAADBiY?=
 =?us-ascii?Q?vQUYOlxTe1D4NmSoAa2KH/OUL/7U0b7TiPTmmXA7pw0AnXXBwHlmOn/SRNN0?=
 =?us-ascii?Q?PaXAmJ3nmhb30PcdpfVIx9x+jvQiu+FcoWtOYKTvbABJoApuuXnk/7VAQeHp?=
 =?us-ascii?Q?CUo9B9AV24kOXkgPKk3StJRXSzkPttpeLGZ/IcJs3WFjG7oKLCraMG75UlLu?=
 =?us-ascii?Q?NBYxPV4cGhZWq97zB5kVfVuuNT3UrWlU/+NWDI1ldLt4Z7w5XYFQYZcXbFN6?=
 =?us-ascii?Q?iuIiZvZKIea0Z+3uWoLRlltnQrXyhPZiA2wsN3XbicB+lEqrm80D3ThLgAKe?=
 =?us-ascii?Q?Vp1ECJ/RsXC3qnm3DIWyCdkArxr+1i/HUAtz9dJNE/R0lHC8iU0CEqpIbGjN?=
 =?us-ascii?Q?31N84YcFaiPixXoQ/F75zFmnUpmxqWNxn6ueRKD+K0nQCh2I0QCyy2q6xx1V?=
 =?us-ascii?Q?7X+Q7uwKSdhAs+J5+fVhXWeIxHf7f0yPlEuLRYNIaLrwlj7fNmiMIHwo3zki?=
 =?us-ascii?Q?If6ldjXnWWUBqBIjZ/cpBuGKjBwG+EPSh0rDIfB6zBIGOESQFUNc6RSEvq1s?=
 =?us-ascii?Q?TFiBJvBPUr3AS4FISGgmqgaaP/18J2SbE7Cj6b0mmlJXuF/O5CLY3Yqih5Z9?=
 =?us-ascii?Q?z6Mb5Vx4/Z6BN0/bLdTu7nGXFYuLcz8ryqv7ox40aTwyXypq9BhunzVlApqw?=
 =?us-ascii?Q?nvzTFp0524Hw7fCbEPpnYA6s8JMQ0fQF04iB1OjtOD0MY1P47Pf26MIcc7V1?=
 =?us-ascii?Q?O/HXI7gnoezZwmI1/EghHn16o2mQCOZ+9lFTCteo961TxBX3v6s5XmLyjDqF?=
 =?us-ascii?Q?7dXvdCmgKXDUbt8QB18X1HUvz8l3PhLZRsVWNkVi8vXOZ1rNocMEX+E2XB/w?=
 =?us-ascii?Q?scaT/NDtZEMGfbjt6FqtxLwigP9mhmayjGbrH9+W3a/RniGMDlQNz//iVqOX?=
 =?us-ascii?Q?h0CVTeoqRORbsMUGOvXbLUyLc6KlBanmg0W67HNALp+edUjb07fhrssE02LG?=
 =?us-ascii?Q?BmML2Dal1i76LE+pfRyJ5SiMORV7K99bHDvKxQ8jPIG7tvxmxyoQhDLz+cx0?=
 =?us-ascii?Q?1qXwU2rWSszigDe5lo0hsnoA8yND/ubMOio4CD9O5IuTTYUcPFVYkORGWHdX?=
 =?us-ascii?Q?20EdZutORMihX1hpo8bYLpN3HCtHF/8UsE04+DRI3ZAF+xX6vmSpHVg/u2hP?=
 =?us-ascii?Q?GR88Yu7VSrVzjK4p/4umKyJi2mqWjbio53xk0KuT8IZw9cx9jNJ1oZTWVwY8?=
 =?us-ascii?Q?Fe93rirc/qvlGN7SG6AfpQD53HW2Airrpwq7T2OXboMowxeInFBni0A9/MCx?=
 =?us-ascii?Q?xQcvjaHf876qENRDBVLBmqx9uslDe9RX9eNiq0PYh9PiGY3a7WpYoq1zxOlC?=
 =?us-ascii?Q?QXUbWP9V90+Ja7rH14QXnGpqrIjmqh8rD88X5L4IFDcVirKaRqSfVTcYfgp2?=
 =?us-ascii?Q?vW74CdUdeJObq0MYrBoy4Y0W4OfxRCKWJCuXFhuaTjyLCkPosO3vCwFdBr8U?=
 =?us-ascii?Q?REI0pg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87eb1bca-4b2a-485a-da47-08db68bda7e7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 07:46:38.2446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yvaQUWC5BGvw2MIdvi6yA6pf9qeLndufi3R+o0LhkrCec+RsoI4VLLeBd2JunJY2RtvpvTuKq3ojDkbvBH1Y0xNlfujBk5ntHwlD65HpcZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR13MB6551
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 08:53:00AM -0700, Jakub Kicinski wrote:
> On Thu, 8 Jun 2023 13:48:49 +0200 Simon Horman wrote:
> > On Wed, Jun 07, 2023 at 01:24:02PM -0700, Jakub Kicinski wrote:
> > > Admittedly the devlink.yaml spec is fairly limitted,  
> > 
> > nit: limitted -> limited
> 
> I'll fix when applying if that's okay (assuming it's the only comment).

Sure, that is fine by me.
I don't think I have any further comments on this series.

