Return-Path: <netdev+bounces-1941-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CBD16FFB25
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:17:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5C212818B1
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D8D7A92B;
	Thu, 11 May 2023 20:17:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A628F58
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:17:12 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8692D68;
	Thu, 11 May 2023 13:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683836224; x=1715372224;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/5HZOaXv9aD4qj3/DW3ke1rJacYiWOhExKopfj3YOB0=;
  b=Pq1TviDvQRAwwmcmMO5+T4gkKJc3epg7NOuodKsW1sYta0GlXPq4Jrgm
   NwGjRTmkgPi0IxfVNgGQSOLI7s0zrGwkRX/xL1H1E8psb0wmb8/L27BXC
   NFMP/bDRp9eGRuxq+ZtySmvkjrbhfxqESObCRLBbAoqLCRVEgP6cv4rMy
   hoUr/vSNXaStBRcSmVIk+gFVDgujpvBYjq9Qsw7IIdL0m18jSMy1zisLQ
   rFwo7DboSILR+GfRqmiHKfTJ+fRaxJZ+KDSF7Rqxc8CFCGbLF5zkesNcp
   ZYl8inpOfei0Cmwew489uyFJEL9KM2OZkpOTlnm0J2h954jzhwGtDjMuy
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="352859494"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; 
   d="scan'208";a="352859494"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 13:16:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="693965698"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; 
   d="scan'208";a="693965698"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 11 May 2023 13:16:48 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 13:16:48 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 13:16:47 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 13:16:47 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 13:16:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LIjIdZaiSM+oN5blMr30AT09pjbUMnJyFdZxzhga3bL0t5Qtox2LsrRj8+Qke1HGvRJ/kuc02oNU6HXcyuCuGETgvUygAORqHYdmQCxK+DhHamvnbfd1l7nKeLpTaDjj9W0H2DupeTtd9U1BZr77jsZXZtLm7Z/9UBldoErz4bO+BVfOheKrHId//f5phqy8P/boRJB42R6nBK4QeOOz9Rnuy8zCF1H4fK0e0F1mcLctTcVFfSo++WRoyjuOuUqMkDFFivBUOjXq6S7d8O3KRsfseZOKFLiTXNKWZUfdb0BoAi15zCJ1LEM+Z/3OqhaYSpuOTR3uJyKqWGWVU3elhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OzJbAb74VCb1ao7P9sYUs18PO2yZXqHqmtDGynODmhI=;
 b=Jns+92eYOOc3xKYgNyJiUCgAVBXYOpXINTnk9wOKqERQArkzlQYg9OXd13AUSV0NkCdXzAg5iYFyeccntRj1d66AFTHvBzxbYKnlOEPz7GkDoUbu+z1rUHNIumhW1Fop5Jzk448BXrg74tSvuJa9gC2Oa8giZYegYg3ugNYeEuU2fD+lQDgFFg0ws9inDRpwVRv6x1e9pNnqfSdPRyNFpDZGzs0sC8nrsebOd3NgBrsfw151x0zMMRh0+U2zUvuUO7udc5EUK3TNfPRNoB//ZKH21vxkcHHnfg8w505BpgVxyEsAetc8Cu02ohxLLspUGOw/sHDLv2k3tlezWvTsig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by MW4PR11MB5774.namprd11.prod.outlook.com (2603:10b6:303:182::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 20:16:45 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9%4]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 20:16:45 +0000
Date: Thu, 11 May 2023 22:16:39 +0200
From: Piotr Raczynski <piotr.raczynski@intel.com>
To: Jiawen Wu <jiawenwu@trustnetic.com>
CC: <netdev@vger.kernel.org>, <jarkko.nikula@linux.intel.com>,
	<andriy.shevchenko@linux.intel.com>, <mika.westerberg@linux.intel.com>,
	<jsd@semihalf.com>, <Jose.Abreu@synopsys.com>, <andrew@lunn.ch>,
	<hkallweit1@gmail.com>, <linux@armlinux.org.uk>, <linux-i2c@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>, <mengyuanlou@net-swift.com>
Subject: Re: [PATCH net-next v7 4/9] net: txgbe: Register I2C platform device
Message-ID: <ZF1NJ0qNvP+TdPMf@nimitz>
References: <20230509022734.148970-1-jiawenwu@trustnetic.com>
 <20230509022734.148970-5-jiawenwu@trustnetic.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230509022734.148970-5-jiawenwu@trustnetic.com>
X-ClientProxiedBy: FR2P281CA0005.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::15) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|MW4PR11MB5774:EE_
X-MS-Office365-Filtering-Correlation-Id: de1781a5-064f-4f37-6cd9-08db525ca420
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iqj/7ltb/aWdvZchDZcXvT5ImhOOZq5KRQvG05s0W4B7FGHGFbaUjyUrObkEdZRutzJX5DZz6o9XJ1pdwo4jkH6xaEnvL3wCsx4Uyx8modbZbtJsJ62t+ujcaHqF1bo0AyaRhU4x9Yh789Zs1nTTUDfKrrfjpTcZ6+OwiUKfibESG8TMj6WGPJlZYBJYRsArIOVasJ4CEKOGd8o5f1WzdOK8/yqLiLsdzdWBwNMsLZYvoH0ghsPQs7PLvSEPe+MNi9CSz8/QUbP/VJQQLkc1wq5VwW2bkAAP9uZ19tfuBJNf99YfebVZKiruR0hJir1XnqtN5p+ON3YnzWFgl0zWGHDeu/zd5jyvDwpQ73u9lXnQ42pWQYSSh6Qh590sAp+0FFaxUthoFwVFtx87Qc3xkl6L78uhdn9AhLoGmsWg4IATAfcmZBjdfxyqepiGpsDxUv4TfsUjJwRWgck9IBfGkoAYKArwDXw2TKa/GTtsHliMD2F9uKEhxM5Nx9LEe8/rvg6/4NpxspjXFMRJcN/9Xlx7mHLDCEMjdoqpu+fUcpex9LdolTIIdkvjzQcGdG+KHBfxbdpyAxpMXhZDzC0LtQBYD/Uv5Wx1bZh9Be/JzsA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199021)(478600001)(9686003)(86362001)(6486002)(26005)(6506007)(6512007)(82960400001)(316002)(66556008)(66946007)(4326008)(6916009)(66476007)(186003)(6666004)(8676002)(38100700002)(44832011)(7416002)(41300700001)(8936002)(5660300002)(4744005)(2906002)(33716001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Evclrapmo2437CWrskQ3LbdFQSG4ega/3zPV/+iMgTkVDWJ3xfhOwUAPbt35?=
 =?us-ascii?Q?9zcCcXf+eWsZipS9IZWRga3sJh2EbQO+CneYx1tumbeT75n0lWdBADUK+LNy?=
 =?us-ascii?Q?imeIa2ftBsDUaKErrrBBPQauQNzlwilCH7i1lztA3iA61a1kAJeeMBJ/gNKG?=
 =?us-ascii?Q?Vnrqokn1sOmT27YPJpHSsT1uBf7cam1eqq1qSvpXqu7cjbouNGqPD/u96lyw?=
 =?us-ascii?Q?LATQaBZ4vyuTsR0w3eZVqKcQh8v1WhOStKKCQ+FEr2sQrqxDXVJZ/qqs8LRA?=
 =?us-ascii?Q?lVcUNM59raTk6EPukoMRf2z4HVf10LiAaURM4uJSn5fHdtHgFgDH3UrsYrLf?=
 =?us-ascii?Q?oGUTAhEANNEyxy2BzCeLa4F4Hx5vLWJuabl9gXnyxg/mknkECHHhoXv5wJ8Y?=
 =?us-ascii?Q?0gaaNMs0N3YGkikHglYJt4apIq5kIkDYCjvQXvzmAH794WKiWuwiRfTKzvhL?=
 =?us-ascii?Q?MS8EQvbCYWoQgIe6eDLJxlx8u3scMYXexyou3uDFuwH7qpT4d5dYgVq8D2Ix?=
 =?us-ascii?Q?8QJaGlQ7m73N/ybVCzdgFe8yMMaR/lTBnWct2e21l81QPv079kq6CWXWYgTk?=
 =?us-ascii?Q?SDI1lqqJdQ/a/C8JEt71UrQRmqQArrBlQO1OtyyajNSXH01VZCRO2euArI41?=
 =?us-ascii?Q?WP9ze4VO3hn7gzaYqr+vDNbd7kJ8JCAq56zgI+gkVj2IWemtBtFWoDV+4i/x?=
 =?us-ascii?Q?UtS/PLqFInn79MMtYwumyaSKMTgg/mbWXYCpjs/iWy8KVzfJRnWwo7OPiiZe?=
 =?us-ascii?Q?gnZI/62F1JWbwxCyA3CQnou/7GQotPPzuylKzinrdeJrwTUjJrx30VBlsVuy?=
 =?us-ascii?Q?jWM+C8YSjjKbf+feoIzjxyua5BGlGwqJ4d89DRHZ/c5hgJE1xxjzCrIlJbc5?=
 =?us-ascii?Q?o5+QISU2Hz62GfryTlEn6B3Cwn3j3xYqZEKE8KtVsgeiueBWHIbZynVCJgZp?=
 =?us-ascii?Q?PgNXcn5TiaejoVRqxyyDpiKvXLQcxIatbKf4YDVNOCQSlI3VC8cn87meURz2?=
 =?us-ascii?Q?Xx5XBukKuYq90+P8ZFRm/hRvrMZ+4kM1F5NOp47Xk/9lyxgvGhOCWGfgfe6T?=
 =?us-ascii?Q?feD+r/1Pt9ytIqHAGCCzLtFxxLP117ADNKsQ3VDKvWEIq765qzCn4j78wze7?=
 =?us-ascii?Q?Tt7ZeaLhxLu/Jcc2wN1V0KnIKW+LG2Ll82yGXkXxmj7tOYK0SB0rS4dxuq5F?=
 =?us-ascii?Q?8daFL9C1qX/7cmzfphViCIuApUi9mrEa+fJxUOkahS3LoM1qjSKTKr3FHqBT?=
 =?us-ascii?Q?k4yBfPFR4eb+I6MJno6LGOvMV1P6xaTKOghGtwFPdDhLcpi4yRuO56wS16i8?=
 =?us-ascii?Q?MaIje5pc7/vqtCwgCM4fSLLidvIKt3LTMING2VLvBrwN67Oi7F0FIu9IpFnJ?=
 =?us-ascii?Q?gptrykDWo9qz7gx7Wj6SxgjSZz6OC9n0UMYlDtcjnEUfvxxjdxMHUmx/srB0?=
 =?us-ascii?Q?7Ixl+xYmhqbgyhfj4pPmVORBjD3JPQTuPTZ4joHUrBUE0VoxRCHwzgt0/BT+?=
 =?us-ascii?Q?QC6srBJ6Yj2oy+og1+TRMsISkg1NAFGKAlldKT+G+wRArP4tepgJOEQ+trys?=
 =?us-ascii?Q?+Io+bz6bRAuCdNKU1MnXiHS3Qmi+a36Ikjpje7+P1s0cXt/g1oI7b5pJmwMv?=
 =?us-ascii?Q?yA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: de1781a5-064f-4f37-6cd9-08db525ca420
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 20:16:44.9221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XXNJcBYyY9RL+OpXmEkp/2jY3RqRuNI2ZGeQGvUaaMGjjTenhxqt+QEobaM1n6x9HZQhUXjrLQDmcBa0hIL/9bH8p3bIWxhNjiXMo+q0ESg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5774
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 10:27:29AM +0800, Jiawen Wu wrote:
> Register the platform device to use Designware I2C bus master driver.
> Use regmap to read/write I2C device region from given base offset.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
LGTM, thanks.
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>

