Return-Path: <netdev+bounces-2533-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DAE8A702642
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:43:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7A7B1C20A97
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A9DD8473;
	Mon, 15 May 2023 07:43:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057CF846F
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 07:43:31 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930331710;
	Mon, 15 May 2023 00:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684136610; x=1715672610;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=L+BvXHMBzB/m4sJlpclvE+pxbAihpZPf7tlW9+wJygE=;
  b=UEkUx2jr5Ac/NlB9ioNlJNPvn0SmKDffUJFXbWpKUmSzktSbtYwDKNBv
   HwOsqIOp+D4vQrMZqef+uf/sThoCmR5s//WokXdGDYm9wZaPLYr6K4apk
   p0UfJ98Yl+Q1+o3N3G1pjmerJGbqb4SqeFyPLeCYjTyypoai8+51gyfvu
   qKGQ610eIzLj11Wja6T6sTEla+p8HiMuXYJpZH0nOcHJmyyb8T/d2rgUc
   XErdq6N3i2EMOH2zGnpbMHKdfvcYdCnXVWbbdqw5goIyx8Yx3/LDPH/vy
   wetzwWZJU+hMuR20eesv4mz1qhXsw0jjqj4SXtMmOF1jAoff08kvuz23n
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="354293020"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="354293020"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 00:43:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="825079849"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="825079849"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 15 May 2023 00:43:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 00:43:15 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 00:43:15 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 00:43:15 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 00:43:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=da0lNhcyNWo8arGTArNWoXeULmqq3F4SNhSIV+4HtB1l89b/W7I/Mx4ZJzBsCFmrQYkNRCoytirU3/0GkeVbDyDOgn8nv3fZtKJc7lSgBT+5IhVCsKSU8yhDr6rcVvqw3JLbGKRUn+L0dhGok+yKjhPRKUc7I3U05zl8CfYXRm//htAQYQoxRDSie9ai8ckoEpydA5nC7Ni4wnpVCX6KzYEH33CQAaKp+I9fQ3C6ns7i78+uqmsIfo9gKT758BwGAtVAIficNN/My03dWLtfd7e5f8r/Tzlod0Wev6AVqo6ZYVRXIakM6MshPJfbGyCUvyJxcFlBXXSREolKO6bBqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+34J8t0z9I54nAamngx5Qt5Mn3nyOtl2lcyXW3wtMQ4=;
 b=GxtFDrTFMiEwpjS7E2V7S4jdhBGaflnfOASRTkNjN1+gwG1O/09CHav4OeVr1WUhzfn6Hs8NkiyeK9YRuf0Aj18K1NZBh6dK6oTs2BYf7QZIQVMcRQNDAGSK8Lj3csP0pue2AC19ZIYl5ZMjdmMq+v1VoolDbuokQM4VGSlJ/hlsOof2M5mEFKTxcGDVa2PyPn21Cz/vTZjj0h0HdGA7VV1mphym3xhuW/0Y1Z9eKqYhCBLl3O8Dt0hf5JciijX20yZHdbRFn2karw61wdECsv9gF/h+cVcLtxtlio4oDF/NQia+eHpus2MSOU3GFwVJKAGDK+YNhphxDyduvZd5OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by PH7PR11MB8479.namprd11.prod.outlook.com (2603:10b6:510:30c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 07:43:13 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9%4]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 07:43:13 +0000
Date: Mon, 15 May 2023 09:43:05 +0200
From: Piotr Raczynski <piotr.raczynski@intel.com>
To: Horatiu Vultur <horatiu.vultur@microchip.com>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 1/7] net: lan966x: Add registers to configure
 PCP, DEI, DSCP
Message-ID: <ZGHiibS3VlsL8QdE@nimitz>
References: <20230514201029.1867738-1-horatiu.vultur@microchip.com>
 <20230514201029.1867738-2-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230514201029.1867738-2-horatiu.vultur@microchip.com>
X-ClientProxiedBy: LO2P123CA0066.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::30) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|PH7PR11MB8479:EE_
X-MS-Office365-Filtering-Correlation-Id: 048d76c7-5ea2-4512-a18a-08db551809c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TVpSeY0kglLA+Ksw/Fz7P7xLpeoVeoBHDgWy8n/Zae6feRyVKUFr9FDYoy/TYU96NdijN4/ESo2TpFRQD5Uj63qDeagO3EqqwZa0bgW/hJ9vV972luTPOJMW8KAsUChGsAhnlO+ulfnZlGFbZ4OQpdRIb3woWWf9vbWn/WAEPLsQle4cnRrBcILm8WehamayIU2fJOEjWoc6+f7JeixjT7hFPF39cOJLzqkhQKq1du/3Vj4vkdjYVfLnp8gjB/qWuDtNBahZVGOwXKX4qXiwrGwxZyaW2jQpPhuazDm77p0Jda1jmzzh8tt5AGktmu0IJ54Pe+uEwu4UqImVNRmPltIAlchSiTLX89dBPdWluQ13fMF/wKDW/GWGHLgpSpTZYOLnUupGnBNIBNcl2RAe43fBBOjs4Y0bUUrB/hgY34cUDQTcdijsjScqAHuxE/vgVEnztdbPvIHFSLEhkMCrxOsriLujJoN/INSvWBAVTUJXrAHlghop2Vvmm3BKAPB48MNgqwXHha4q1dIddcTnGbNGOV94R8yfa3KjFj6NV6vhn7mkYbFpm6/HdwJnyVyo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199021)(86362001)(316002)(66556008)(6916009)(66946007)(66476007)(4326008)(6486002)(478600001)(33716001)(4744005)(8936002)(8676002)(5660300002)(41300700001)(6666004)(2906002)(44832011)(38100700002)(82960400001)(26005)(186003)(6512007)(9686003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VRTBF6LQlH/JSPIjWz1EyjpVuiZjt1qBAQrztbN7R3UFE34BIFldoY9r+/CR?=
 =?us-ascii?Q?1BDo8M8kzW96m+Fhis2QmOQkFhs0sQcvIzjqKhfaAF3QmCJMEkZK8C22aWIJ?=
 =?us-ascii?Q?eG69MGswXelBhMMerTRxiVEz444bFX28QCng6sgUmyYnY9ZCKGeDpFQ5yhkZ?=
 =?us-ascii?Q?ksiDGFe19TF4MFFIfiAr58gBI0rT14G+13n1jkRZssj3J9+wG63cm/qSgysz?=
 =?us-ascii?Q?/gXbds8rhoe9WMgtqo8Qt9ShuxFnK9A1aIgvJ2mvEX964aCuYiRhBe1yWbBZ?=
 =?us-ascii?Q?gFAw5sn+2RFK4b2mlOkhCZxHIHQaAssxGXb9e0po3QUz//rgFBWmh5x992C5?=
 =?us-ascii?Q?R9omSGLAbrY+b3zGhIYMXcZvivtbn+DwiwgyHyLosn2e+Dt1hXI1iAAErT+k?=
 =?us-ascii?Q?hokCWLfPfO+8CqAcbcmAsMm17FXlbHUml1KJceLWkpyjrhAcP8692jIdNZT3?=
 =?us-ascii?Q?ifKJ/JzSztwt9clcayGxBbJ0erBuqzOacgTasJ6GwiDWhTnuQmbN2ggMDfN+?=
 =?us-ascii?Q?Hpt/lbzpbsPcT39y+bvZGTWqOcF8rTQtVNs/njbewOmU1/4iq7O1TE3crzam?=
 =?us-ascii?Q?5cTsYj3OKtxbs39DWeT4pgjBJLdSTzYEPrl7hNwqAInl1UBOUuVKOiUgJTBF?=
 =?us-ascii?Q?D+JwwFtwzKxovSB0oD5q4LuFbwQxPO0H+4H2TStn1JVV+vEVFj5WtWkcDriB?=
 =?us-ascii?Q?1t3k6SLuV4FMLakTWk+q0Y6sqNPRegTL1AU6FRnIr/468yGJSDpPIZAl5ktx?=
 =?us-ascii?Q?AVyinWGKjI720CjHbq8R1dh4OPAeausrf4ihgnC8KEhUTLkDYg8JS0Hkgl3d?=
 =?us-ascii?Q?W6cWo+PrGX/uPwAAMKPC4m24paW3wmssH0xJsJMBOsGPX+BMCyiI4jlj/+y/?=
 =?us-ascii?Q?8p2fpJLxeRa3HwhLX1SwB1tqTFSnC5mZc/R/RaPzW1SLOer0pBy17PPDXjDM?=
 =?us-ascii?Q?M1e2SdPGzxBqclogHTsY6VoJPJunvjPBrWEclcveps0TDhKZbMkq7rzrZMsI?=
 =?us-ascii?Q?dYKy43TK6j7mb5QLb7BmfYlLIPPaaed+Y/zSDHyRsxmXaFH/VAa6rZIFhmuY?=
 =?us-ascii?Q?Kcht5lAFU6dcq3er1QcDLi92ZoxPgWfEtbCAaU0EiHFzpFixLetAsalVn4FR?=
 =?us-ascii?Q?Szfv9ot0BA1IRG+MhhxR5b4CC3kQXjwEF+3GiNzXgPWJAY8YVdVRK12GS5Wv?=
 =?us-ascii?Q?Tt+vVNaSXcrSxDqQddaozr665rz6/9//Y/5nzZGPwl8wAKfK8JlUIBKJch0n?=
 =?us-ascii?Q?5Mb21gprENsq/Li1DmKWS73+LlQDFQ1n74J00d2pbAhE48ev40Q+UZHynuXq?=
 =?us-ascii?Q?sgy3YGEmchHbdaB4BcRLI2AFM/iFvGDjXYLLjVqzEp2BQsM+hMY+kwNZtUGL?=
 =?us-ascii?Q?oqwUV+Ehot6+5BjtS0j0pc/3EHJOFmHg17XYFWkuVuQkoq0jkCbanvAx4rsq?=
 =?us-ascii?Q?XPXvIwX460TPfjrxy+BLQzwPObiahQGSpyizap3jjxk2BktgJ0pG1CrfGB/x?=
 =?us-ascii?Q?hzGN8FSRKY7uxKallP8hmTYZnyHgg1Vd9JeQGxNGf01KjGq7E+JBfgF5rvla?=
 =?us-ascii?Q?xX1fc7hs2MBCCqcVQpGupNOWJLiw5MjCIQZQCzp6mZGXe7uPJqwCoRPVa8Y3?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 048d76c7-5ea2-4512-a18a-08db551809c2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 07:43:13.6618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ij+/5CGsf/pF22SpZsFNe10VHWFFfD5affCHyi4E4RM654hfowL1+TWbwK1cY5BA1ZvquRVtLh6tT0xvu/kKPtcN2GNZi484pyQ6wsatm9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8479
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 14, 2023 at 10:10:23PM +0200, Horatiu Vultur wrote:
> Add the registers that are needed to configure the PCP, DEI and DSCP
> of the switch both at ingress and also at egress.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>

