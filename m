Return-Path: <netdev+bounces-1943-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF2746FFB2B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:18:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06EC31C21043
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA993A92C;
	Thu, 11 May 2023 20:18:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D768D206B0
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:18:30 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A0D172D;
	Thu, 11 May 2023 13:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683836309; x=1715372309;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=G2oeDKbGCN/9JMKzZf4q6l4oyIMEjnS6jHXLH3pddK8=;
  b=QIaB5FZBcc6Gktid53VEyXVVOySImgWhU91UauV14hRjWFgIT/3xYc3m
   qF55VkaMjvPCc3QZLjhQXO8sEEF7fUAxw9LvN8dFgMnOfiSrKcCHZ1OS6
   zeGzLBHH1QMiAnhUNbVJgGrSrG/neBUu+1NY2eikWrlG6VvyveNg+GRAj
   bprOC1YGE2FIz7yUz/Kpqiehbrrn4kw5O7AXeV3uQ/AMQl1cJkjpqr8ND
   +4HCYoKQx9Hs1IcSKSYy4aauJ22UYduSlXj14L3y8Uyo9YjQqENPkbGYq
   /wYxAYExFz0p9/l7cmQOkcwSHdCfoEo4iXuwllBEpUz/kvhWGlxz7wYON
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="436955038"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; 
   d="scan'208";a="436955038"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 13:18:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="702876639"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; 
   d="scan'208";a="702876639"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 11 May 2023 13:18:29 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 13:18:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 13:18:28 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 13:18:28 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 13:18:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBJ6aOUPWun9kbfk1FNfzl8Bxkx3VRDbu2RJ1nN6PS5wayXA+mTDKOr6ABJCVu7c1kI4CHYY8KLzhDv+/aWoFrbl+3RjwdUIVeVbboXi9H8W5uPw3QBLIDgXmWopvLAj1Y2Lg7HbOOwB0kEzfxLf8mIiaWHeADrXu52R24wA/XGi00A/sZxvFAgktMUFqlmS8NkZSrDTUAI8oejqfWzADn5K2TFpYAJZmLwSN8TZr4DgZB7GLEp7fP6XxCzT/SvTTyxYGDmiQ4cFhPzrJDXE2imGWLMFqdeXykW6hzGIxPY1E6G9Yc9EqqiPsFhbqrxnM3aIU+1J1hRSQcDnkcppJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jOb7YlOSM0M06ffKWMqXt4SemWmfV6EhTLCGvx2oFm8=;
 b=hCph6vkOoEzAJeouxe8sl+UuNLmufz1Va5fPthyyvA2uh+5aef2bgV8y5zemvntqbStVnCUaVOeXYi+jIry8ajC5sBEhSqDo8Ktjmrbnub7mnHlr+3jCzXTeig5QiAnUS1nmeYxhHHBxfMlfkpFF+48Ib4Mae1sKWzXnugpMf0c+dt1xYx5msEhCYvtwt5qp38UDqtTLN25mPfNAaEzWR+2EZIxcX6EI+eng/MqSnPVRi8DQMippJSujKJubbSH5ClD5PS7t8PSNySgIe1hnWAOo/S3z4rEzWaIXfxD8sjWl0VeAJfIVM2IVL2ORqpkpCWjzlV/YkFQuRoaAVdDTXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by SJ0PR11MB5119.namprd11.prod.outlook.com (2603:10b6:a03:2d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Thu, 11 May
 2023 20:18:26 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9%4]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 20:18:26 +0000
Date: Thu, 11 May 2023 22:18:20 +0200
From: Piotr Raczynski <piotr.raczynski@intel.com>
To: Jiawen Wu <jiawenwu@trustnetic.com>
CC: <netdev@vger.kernel.org>, <jarkko.nikula@linux.intel.com>,
	<andriy.shevchenko@linux.intel.com>, <mika.westerberg@linux.intel.com>,
	<jsd@semihalf.com>, <Jose.Abreu@synopsys.com>, <andrew@lunn.ch>,
	<hkallweit1@gmail.com>, <linux@armlinux.org.uk>, <linux-i2c@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>, <mengyuanlou@net-swift.com>
Subject: Re: [PATCH net-next v7 5/9] net: txgbe: Add SFP module identify
Message-ID: <ZF1NjAf5Yeb3z/rf@nimitz>
References: <20230509022734.148970-1-jiawenwu@trustnetic.com>
 <20230509022734.148970-6-jiawenwu@trustnetic.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230509022734.148970-6-jiawenwu@trustnetic.com>
X-ClientProxiedBy: FR0P281CA0015.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::20) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|SJ0PR11MB5119:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d5e37d0-78ec-445f-892f-08db525ce079
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t0AVhPzPOZVxNFD3fF609RTlxM+ob4EzHHlWUXgZM2K89zXFMIoKBVU7f0dzBbhRxtQDUrHrORyiLYDuVYBYwTK+Yt3CRtH83OtNa7Jm/PnctR26qn122M78OsrVPd5rhJyqUZikX+6fqsfvYXCzIL1HmPsVnccqYuvslY6YJNvUrqnFailMIgT8MTx9XvizPNbHDet0IoddDnb+aNnsW/TwJVaFcJUvdNzV2aYekwuMW4l8ihuJEyMj0IYq9LS/G4NX19+++4+b9mOkM3pqgJoZgzfw5FG0UiUwHbsyfCVLBRXJhDZArjK0jCuaJUk0iFva+Pe6u+avIFXGmIWzAxTJo7p41H/kUDgR0U00je8scOU8DMWTu8O4N7RKrzgopwr3to4fitmsZK8X+g7DM4YFs1XYcfIKYmkpVGUHdWt1WncoYUK3i2ZjRdpsNIs8es30UshtY0eU7rU6EvaEX20cJTTQVa8us5LDdpWK2Vzo+4S5WzJT8SPxvG2cU46zqE65xGwJ7ZtA7Js0KB7vUEC72LcgF45OFe1V1taRikbM2PYJ/V04s9BPewvUgai6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199021)(6666004)(6486002)(66476007)(4326008)(66946007)(66556008)(478600001)(6916009)(316002)(41300700001)(86362001)(558084003)(6506007)(186003)(9686003)(26005)(6512007)(33716001)(8936002)(5660300002)(8676002)(44832011)(82960400001)(38100700002)(2906002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x9PxAMemsP6znBsrYCzqJLcsC6PK42t5clT0LzVVVfJdiQkaetfI9j2F8SsU?=
 =?us-ascii?Q?6Voake2ejnvkaFW4W7HokA8sh+GPO7Q5MuF1sSEDYKzUEY98BM3H9XTePRze?=
 =?us-ascii?Q?8AHxCxzyX21gOSV+IbXAVMvW6vmUHU2QxKZtOZKcU0ytOd0oLxdaoaU/cHtQ?=
 =?us-ascii?Q?qKiyTATEM0Q/NIIolTwQ8LEPlIQm8+MHTggJ50yOVtFLEO9gG8hpSRVJpTYW?=
 =?us-ascii?Q?JUEBb8Pm36tGd8Hhon3DavoBbOl83dGeVRG0j7zCq9LEOihEPt5kpnk7EBo3?=
 =?us-ascii?Q?lpyxPxXnRkuHRtOC/teIVE4wmmmk3Vac9BEk9AcawL+bBKJeqkEE1AKVPGIV?=
 =?us-ascii?Q?TcIoFiwuYKrYZNOOvqzBFf9M1VPZ9NIoiGNx0ySua3mYaLsX1InbWA8xqPeB?=
 =?us-ascii?Q?9esmBxucnCow4JqCoDhYABvfCyB2zej3CMpI2eKlUTACHlMbnDQKzTnVGhdW?=
 =?us-ascii?Q?4FZbMZ84tTkYEqqYdzzcZ1i1CilPiXdAhIUtEUSec9h/XoEBm4iBe+Siylnv?=
 =?us-ascii?Q?qYaCp2NAyRE1jUdKHPEehxm6R1P5UWRbTXOoc7GuwostsgXWFR7OBHo8K9YE?=
 =?us-ascii?Q?MaExqPsK/XMiE1OJDEx2ZhHHKQcNG5SsiCEougI87Bsmd9/b4yQYwLdRtcyb?=
 =?us-ascii?Q?jPgJXlv9ScW92gFtJHaIsJxxsQGY5xryt5Tu/lUgIIY74/zaZp54Vg2929l7?=
 =?us-ascii?Q?tfoiCZCdvk/ZLQlNysbXGhsC84zf1R+YqaxCVVus3tmEhNKjq5tBWxiy8dQX?=
 =?us-ascii?Q?gkQnKi8M0hZ0XnYwrD4dmjpIb6VwZDE6Xu3yr64vYZ5+gUMhP0jHFXNhlEmu?=
 =?us-ascii?Q?zbM6F+EArKH5a6qRcf7mJJqod2XGQEge1s+jc635lRKwcRpZjXamE2ZBEs1i?=
 =?us-ascii?Q?MSWuPq36zyXESaFJTZWmXQNUXyqO1RArcGinvKKg5BM+AAJgrSDxFnZYDflW?=
 =?us-ascii?Q?TjXfsCMfcjHB/0P9LuZUIvr/9lLGdEL3a2CVExuV3bJy63yb4SvT0laQNcsf?=
 =?us-ascii?Q?xbsBNPlhy3tGlSwTGKE2BGDrndqmlG2Z7Skh9y/m+PCWhsgDtkb2enzD3Smw?=
 =?us-ascii?Q?C0jtdx3qr0QRt+rW/Q5Fr/Ldw74ea7mSCaSl+SsOLTtvEIm3r/Rr/VY+5NEr?=
 =?us-ascii?Q?j6MU3NpkBs/7ipa9Cj7S6TJoCmKl7rIFq4wVuFSWZPdTgIMIA3lyYHnIpD0K?=
 =?us-ascii?Q?iLpzg16acuo4hw7ZxNtuifEayd7LWyAKoXERcDdNooN43hPWbuwWAta7Dyy4?=
 =?us-ascii?Q?qYgFhncCCAFRYUspMjPyARcWz5bqfdKJSysJO5sUJLXX4LRmZDbHNTLV69mK?=
 =?us-ascii?Q?RbVZRITHiuWhU5z0qumOT6oAshWJDoBzyTo3ddJU8mouxz7HIODxXY/ADkql?=
 =?us-ascii?Q?foYyZKnRkyZiOuzluj3zMfCeUjcVV4tmh23bfupMTPri1eToeKcUtApoGNtb?=
 =?us-ascii?Q?niKhik6sEtRXC1h1lSyGjBed9w5DgRQneE6HfBbm38Spzg5nZbkHnMMZq4Pj?=
 =?us-ascii?Q?YrPe83Lq/IGkJSf90au63wDhC6znAUhs3gnF3KubSiRtakjdsw7mu4qW8NR/?=
 =?us-ascii?Q?W6dKpQU4OChdVmO92hxlaAiqJIEvhRRB8voJy4Inw0PDKVV9vMEJNNi03RDw?=
 =?us-ascii?Q?BA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d5e37d0-78ec-445f-892f-08db525ce079
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 20:18:26.2284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZUmYTuqZ16E47Ch9fPdnSIdPTcYFBarnDf9icxxWIn1Co6H/Bs42y5z/PEDdTiur6D9RjE+nuXh9f1Ul4JBbRUCwZ1xZRkImrMZKnHoWIg0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5119
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 10:27:30AM +0800, Jiawen Wu wrote:
> Register SFP platform device to get modules information.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Looks fine, thanks.
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>

