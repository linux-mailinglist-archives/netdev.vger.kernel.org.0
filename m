Return-Path: <netdev+bounces-1492-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3B336FDFB0
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:11:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C77F1C20DAE
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:11:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D3D814AA1;
	Wed, 10 May 2023 14:11:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6C68C1B
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:11:23 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E2C10F
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683727881; x=1715263881;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wYF7nZZPI/xrMwkFFAP+vm+DznUQrQdQhWnF1SFGPVU=;
  b=NDth92JPp5vWqi0u43K3y7Ixnar9bAPI/1Xp5E3AlT7pdpUo1Krijoxg
   VdEbiMPqmBjkKQNgLLfndbOEeWIohAunWBpv5Rhdb0hEXUVZlKmZmX+BS
   6VuhpaPkhEZjszvZKL5VQX4ttYr1tYTCTjMOnv5Qv6FI1cuEQzwYZhjTk
   mwRlZJwPtNmRZOwDS+66x9v75sdZd83ka7D+90HnWu2zXJyCIzajkEalc
   xSJoD0/JX0RDSukcnNuDwKMIcbogaudg5mqYqIM1jPJZBym4gK6MuVHaa
   W+9CNDwckUiMaQSMjB7JNc4JIKkJmjHO8fGRZy0aN9VjIibKcnNwNgVLS
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="350255412"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="350255412"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 07:11:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="768927573"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="768927573"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 10 May 2023 07:11:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 07:11:21 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 07:11:20 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 07:11:20 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 07:11:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LRVesvcFg/c7mBPtYEJlOmQknZJzGxhiCDjI9hgWSFinbQ8L47AzZ+6xs5DpKBHo8h8Tj9x0otUx0/A6qNixHx1pdSdzJ8R0+1296Pi3kHs/MFFZwCye6FgB+GmpaoxTS4gydCZy/wg46jvdxLKJlnGNK2tj2X2ybewPZ3rxUiRGBEs5dpiL3dHySPMq4WqA+aoTTKJ45Nd2+CikNcCx1H4I2RpZC2fXredxGNEwYbGqbisKFzLYrG6JthLJVt2/d7iCbhbRncdt9zysGhdxu5wEzhNHmPvAINJVUGitjDILWaWsoufS+6UamJQso/OZMJGHhC05O//2yDXqnkfsWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZoBj1lufxrSgRvRQW/3J8fq/ry37G6iRpieQ+XyTKVI=;
 b=SDEg/Jyf/KiP4L8tbDoH62w7acqJz0aOWZgLD3lh+WMZDH2hZTJKMJ8hiFq25DCw3L9Bd5HNvZdw699XvKyqHehUXoZkzTGM0KYzW5nnGWMZteRWjyVT4uQahLNtnrUGZ76/UYjmugshgOrC6ChKjBPguiIyVUhXdzDkj3Hc7+cbttxhDTCbrP2kOFW+hrW8u9OOfqzuC6oN6buK+/qa2bPF565IG7IUMoUBfSZxpYinqorJg7MLCoiDG2lXIfr+/V9+OeG4YFQ8Q4xC+aXJKykKBcIBm5VqwO9xRvd3xpLX8dqz+aO6VCKLS7KT800yF6jE35jAHljG/QGxHwhf6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3882.namprd11.prod.outlook.com (2603:10b6:5:4::24) by
 SN7PR11MB7418.namprd11.prod.outlook.com (2603:10b6:806:344::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.32; Wed, 10 May 2023 14:11:18 +0000
Received: from DM6PR11MB3882.namprd11.prod.outlook.com
 ([fe80::f99:9d80:fe32:f458]) by DM6PR11MB3882.namprd11.prod.outlook.com
 ([fe80::f99:9d80:fe32:f458%6]) with mapi id 15.20.6363.032; Wed, 10 May 2023
 14:11:18 +0000
Date: Wed, 10 May 2023 15:59:27 +0200
From: Pawel Chmielewski <pawel.chmielewski@intel.com>
To: zhaoshuang <izhaoshuang@163.com>
CC: <netdev@vger.kernel.org>
Subject: Re: [PATCH] ipruote2: optimize code and fix some mem-leak risk
Message-ID: <ZFujP+VtAqV7G+Ql@baltimore>
References: <20230510133616.7717-1-izhaoshuang@163.com>
 <ZFuiNol22xxd9Ig7@baltimore>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZFuiNol22xxd9Ig7@baltimore>
X-ClientProxiedBy: LNXP265CA0079.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::19) To DM6PR11MB3882.namprd11.prod.outlook.com
 (2603:10b6:5:4::24)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3882:EE_|SN7PR11MB7418:EE_
X-MS-Office365-Filtering-Correlation-Id: eda3e1c3-a5e9-4b14-6d15-08db51606ca6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1X+iGafWhPvMqTpRfGQdiiE+w1m1T8XbOSpi15ew83uY1NjnqNTwdZuXFnIXb6YNoya4n+tmbZ7cudumHsh2qf76nJMEbAKK4angqpTVSSaQ5/3s7tLAL51fqYKA8Eu12nIq4e4FUqcb2PKP2l34IPi7Fimle73gRDRx/vbm6NEh9x6pbQ7Yx2AQi6t9ihFUn/EpuzH75bmkvwYrHsPtnyqC1aKt+IUuwdUt0iDi8+QlUilSRM4VFABvN6CFYGedBTLcFAcrd3XFFPpv/JrIu3MwuIjyr9MhAitx/OrdAqMMlVbvxLePVUSXJfLXMcF88rVIpqtZx4ez3pFqRkd78oYehSqCFRZkNVOTlScL++zQoGs/A+hHZRDVpDWh2bpr7XjDlTSMHWUNzkR7TTYo/xVVIKGax7tfISlex8TgRlhe17U4AYS2scwYW3S+KZncIuhWzrBMHwPsr5nYy1lDiyIlSty6DGr6mnDdrRJ98t4Nv4VmqbdklcTvpdGyfdVNyttevQg0fbmWRJ7LlwyPf/544UDXQcn47XX39S3YDIsH8cRkig3oubCGvkFxw8vy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3882.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(376002)(366004)(39860400002)(346002)(396003)(451199021)(86362001)(6916009)(66556008)(6486002)(6666004)(66476007)(66946007)(4326008)(316002)(8936002)(6512007)(26005)(186003)(9686003)(6506007)(5660300002)(44832011)(82960400001)(4744005)(2906002)(8676002)(33716001)(478600001)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3e7k4AdFh19vNLqxHrMusFCOkEfR0IV4ofEFIslgutifMXJSNIvu/YtmqJkc?=
 =?us-ascii?Q?qzChRU+Uo7uxM/rp04gFRnCva4EbCcfEklR5GNtxSjVJeDcK4MzW1jlEvX3J?=
 =?us-ascii?Q?Rm8GKLGPdHsdDTdRsywgy7XOsG1gl7a68SVjmYQEgSXhykn5sdQSONbSCsP6?=
 =?us-ascii?Q?/nwwOnuCl+16DZjIrvbZoepDK/YeJBKjE9pmQhzylwN8kDh8TJWI8fCQpHQj?=
 =?us-ascii?Q?LRr4y0Ty62HgljimHXWV253zoyOhm4nolyvs8OFxJqgc1x3Eypfi31cNsPm7?=
 =?us-ascii?Q?di1e0sfYVnQSntMjhacYsCJSj9NBevYqA/RGj73ScFHB3XGz/fagLJnYFH+m?=
 =?us-ascii?Q?truxVlOt6fZnc9rOrZgTyVJ5b6gkQKKf2a8T7gkrBkfX0MKjW3tN8/lKc+XP?=
 =?us-ascii?Q?r0OK/Z+fz3fieCP3JUNJF29AfmTZ6KBVBSI1XLD7wBF+ysTMmgX6gtouL9gr?=
 =?us-ascii?Q?6nE3aDAwDXZx2hBlbZmGZWcACoz6f+5PKhlutiQSkb+VADGbeKjCt9diXcD6?=
 =?us-ascii?Q?SVb3CZ9vhZaFiEX6xTlXqEPuteuuKl/qsAXnIyJxlcXvAVMTDOnZWqX7uC8X?=
 =?us-ascii?Q?Hxxj3CoCPtU9RWQo5sqvGJVVV6jAnvqtkkZ8a5bys7W1byL/rpNRKOOz3dHz?=
 =?us-ascii?Q?yQ+RLuDZDqESrYsov7yQQspu2qcArM+ilo2cYTlvLjLiy8tQD1/oGkOInZyt?=
 =?us-ascii?Q?KxoDMQ2Z50LIDT6YMR+FnY8LkOjph7PWZn7wsQKvf+uq9XPZw6wk/pgCFJzo?=
 =?us-ascii?Q?bFZO+Yf/mc2vGQDlGZKbYyR/7E3GOOqgsE9WEz89Fu2rMOosLOdFxGwi+avd?=
 =?us-ascii?Q?T/f/++MXIj0Uo+gCRAwm0bnlKFoWRcu+HXQO1H9pZ83wEO3TxldyFiBH1zzP?=
 =?us-ascii?Q?2ypctu2axNh1VHSjg/wHG1lWBXHsGFRAqUubExtnhjGeZtuY9Dsl5d2pLalp?=
 =?us-ascii?Q?XZENXGXcyqdzJkftmQqcl6xDz1jWCjV1u8lA8RXyN1fGH++1m7jVEGVveYdN?=
 =?us-ascii?Q?32ldKKj68r8pfLmSdAnvyv9owZ+xXf5EdKu9TpZeO+CxB2qmSwdOQmQZhN9r?=
 =?us-ascii?Q?+UcskmbeseaUFJvQpc8SCrncLaUhm15iUPDr0aE1eCIHiRRfMPODHbEBq5FN?=
 =?us-ascii?Q?nOsxLxPHPQMk0CdBY6CRWGXUtrzVytabcJxtoPwfyVeHzfd+/nk8qs3n/oY7?=
 =?us-ascii?Q?GGZ2CZAUI/c4tPurNeTNHEVpSs1IuobIq03pS+nVdYxYXbBOTBwobhgcqDGL?=
 =?us-ascii?Q?s+5aIvcua8KEYgaeytNAgjYLoxO1oRZ0n5yEcIkXeCKUdsZIz0Ltr0FgNwtE?=
 =?us-ascii?Q?5SxRmatcZ9sWLHSj8yHSa0OWAjCUkqwdLG6Qp9UfdMhvwGKfA9+TgI5U1F5d?=
 =?us-ascii?Q?x9kNPJquXr/ospSnWeCkTfqcFK5sqFtNZIh6FHYhcTbSjCfEFE157+2NmMY5?=
 =?us-ascii?Q?DRB1HNQxWCSqRabUwiiXhYC5nXx51sWVGE0W4FTmf1QSAbr+z08xRgZw5BLu?=
 =?us-ascii?Q?/T3dzsIZUdq2vWmv7U4B5wqWhiIvxQaMhnfhxodXgKUbuMw9h6tUHz7KnHOK?=
 =?us-ascii?Q?44p0moTKqdcYTMkO5KATZ+7sMpd+WElCewZkw8vSpN6IpegPI3iuBYM26H13?=
 =?us-ascii?Q?xQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eda3e1c3-a5e9-4b14-6d15-08db51606ca6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3882.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 14:11:18.6721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w6K6cyezxfzXGcRDQnIoCt/x/9xOwSpalwMs2MyVlFuvAwxTxLIoicGEmUG5HUrlVOhqY76a7q0l8DHznbQfMjWpYBL5kEUUrs9CqTuacNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7418
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 03:55:02PM +0200, Pawel Chmielewski wrote:
> On Wed, May 10, 2023 at 09:36:16PM +0800, zhaoshuang wrote:
> > From: zhaoshuang <zhaoshuang@uniontech.com>
> > 
> > Signed-off-by: zhaoshuang <zhaoshuang@uniontech.com>
> > Signed-off-by: zhaoshuang <izhaoshuang@163.com>
> > ---
> 
> Looks good to me
> 
> Reviewed-by: Pawel Chmielewski <pawel.chmielewski@intel.com>
> 

I forgot - please change "ipruote2" to "iproute2"

