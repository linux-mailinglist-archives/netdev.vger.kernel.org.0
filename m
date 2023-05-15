Return-Path: <netdev+bounces-2655-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6500A702DBF
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:13:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A0D61C20B30
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:13:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79B7BC8EC;
	Mon, 15 May 2023 13:13:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677BC79D4;
	Mon, 15 May 2023 13:13:54 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AB526A5;
	Mon, 15 May 2023 06:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684156416; x=1715692416;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UBLhmg74QYeQc4R6G5tt1Dk16w+V4NS7BbLW5h0BEKg=;
  b=CIHiqo7YjXTFmWdG3eR0aHuMbYQSjInaw9CqVDdbi0nd+ockQcpyxMbY
   PfAYsBLfsjMIqQBcEJQ633sUxQXh6vBpCWRqm+0HzJwoXrBvBewoHCdL6
   yR2IjQscyhKGuXmt1Xirp7BV1jARTQVVPo+zCLg1OZvHPso6Ay6yBKP6P
   wm1qH5BzvsqJo4mPeRl/yz9WMxWbSDwFQErM477A+T/G2NfUx1e+2MMtu
   kG77g61/skwRg7lEvjIvcMKbVQVgzn09p/+UdrUViqDXENAMvpiEuLA2T
   wWFGT4oaiIVvJj6ltx7yTmg9XiO874W7a9eghocYknKOxjSr8IXPPLWJ5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="351230049"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="351230049"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 06:13:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="790642902"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="790642902"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 15 May 2023 06:13:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 06:13:16 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 06:13:16 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 06:13:16 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 06:13:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ro5U3DeJDejKF07T5rx3UICPKLt75afXL28lmt8KpkJOrkUZpLyeK0tfO+2cZTWqD1ZWm+OhfEeXneZDIlfDsqGuL96+v87OGp+SeAk2elKs9rQiz7e3bCyhIQfumUlX5oafCmBOTJRXuoIGK7K5dzUvuZlgiyTW+yRJb/oHAVQraiG5ZVnthqK8vpcAklLQONZegNwS5yPH41xR4JnRp5FVW//cog1FHgyXG6EswEjFlFRBR9h087XpQcZ26Q38ZceH+L3BdlnCT/gzxeYu8vLfrmVYFYJszuSj50gas0Lo9X9/NK2clLt6jmR7bJZdtdz+h/P8uTgPbPC6tmI4uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4HEOVrUAvZXCicKtt9ZySA/bP+UdE5TIVVFnp8Vj+f4=;
 b=aGyn57QgF4/dVymmtEaG4qnTrQJrEdDXiVsKd/5/GGeAffikH/FYLweFehYQybiX16sIiZ3d4AhViF/xM2/yiAWGlmgDkqIn0FJISYBTfTKiF2Kx5L4UXR0qXNhuZFveYtVWMlLgtts2pgXRElBEuGc88o+PoACZvCnc2JXd8RoP2lzKBmslrF2EW4uKKsImNsgDmXvsrAXCV662XQNbLWib6tEI5xPSHB1L+PKJ8ZOVks31sXVKjVKyLqrB8YDLbCRtdDJCVx5BoVMlky2brJ/mebh+7Lm4YciAFgxKmx98rjNDmoZMSMeUShiZO4Uo9pxBtBqNr01MY0jLpTDREA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH7PR11MB8275.namprd11.prod.outlook.com (2603:10b6:510:1ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 13:13:11 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 13:13:11 +0000
Date: Mon, 15 May 2023 15:13:05 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Piotr Raczynski <piotr.raczynski@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
	<bpf@vger.kernel.org>, <anthony.l.nguyen@intel.com>,
	<magnus.karlsson@intel.com>
Subject: Re: [PATCH iwl-net] ice: recycle/free all of the fragments from
 multi-buffer packet
Message-ID: <ZGIv4WAAV088VdSx@boxer>
References: <20230512132331.125047-1-maciej.fijalkowski@intel.com>
 <ZF5d22ib3IYUMHK9@nimitz>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZF5d22ib3IYUMHK9@nimitz>
X-ClientProxiedBy: FR3P281CA0108.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::11) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH7PR11MB8275:EE_
X-MS-Office365-Filtering-Correlation-Id: c3dff282-2c79-424b-9a61-08db554621e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iueA9/k9OElMvgcBROVwaJ2BBGB3eDMHqXyHES3xuHZ0jclJoDkwOmQk0erLdbzkYirpHkS6L0WkOhk0Dz7Ks176FaSUdPclqnwf2xRKXQmkBkJ83zmI9JAL/ppJA7ora7PYzTgoKYQhWxufP4uCOZNk9vx8ndVOdjvu4n3sBA2jS64QEEdxS4oacdBL6UyY4O3F+y6q2ZTVRSXtPasSy1MVPY7j4eSO5eOHVMQkFnrM3d27/pROmejUYZTywQyRdqyFf6cDauv9sPzXMO0N7er+CWFO3xlxXPmDAnYDGMKw2R2SMm46ARj/aZRVKUOFqkbQm+BiyrfcYOl0K1klLiesOb0Gkt5LkoUIwNKCz5R9YbW+EYGk2jr9+zM3eQS+dH5VcAcPfV7h6dZHGiYvBHqeBo94L2hiIV4d3G4/nd5mZXekqXnwGY6qYNzovknW3H/LBt6tDRa0NJzGEmEQNpnpJyyZES09yFk3Jbc84qsC4PcWDLABuanpzw7M59IpSuqtCx2Y8ZnG879AEw74yvFv9qxUIC7wXx2iVO7atUImdaUzri0BqABGEPb37bHa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199021)(9686003)(478600001)(6512007)(186003)(6506007)(107886003)(26005)(86362001)(6666004)(83380400001)(82960400001)(4326008)(6636002)(66556008)(6486002)(66476007)(66946007)(41300700001)(5660300002)(316002)(8936002)(8676002)(6862004)(4744005)(2906002)(44832011)(38100700002)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wbIWtOwQa3zmukRLeAaa6QhCJ5oiKEBsGb3B4EmhtmaXtsayV7hbPQwvYSEu?=
 =?us-ascii?Q?FZbFXrjvFPC9a5FNNuNw0qe1GOtEHViWiRkQJ3HECCWP7o+ohrFjpHEZdwKI?=
 =?us-ascii?Q?v5YwX4bdrtsLYaKowZqOenXQFsJ2tYcvHTkWiKlJ9Dnf8eRPbhHlQIJlSp3M?=
 =?us-ascii?Q?z1oDD5U3PTlGkJahK0YS304eOixet+HG3RMRRDtvXznTNhPx0QDWP/2yRyqk?=
 =?us-ascii?Q?40Hzfvt39C06wueED+XtxRun8aCczRdAy9R6zjXxAOFFd6rwtF1hiKYdOsdw?=
 =?us-ascii?Q?UcmrVMo/sN7+wQGK3+KD7HhApkLezwUqKy/NyLhMn3G+eCzt8nZGzSG4YDaq?=
 =?us-ascii?Q?4adMlhLyRPQsRPFP5Bi0X2QFqnpE2joTSq6PTQWqP42/ai82tSGkhmM6PCxi?=
 =?us-ascii?Q?LzXYZPxCQMiwe7atX6w5G84Kw05YBk9oRXu7VV5mbFte0kBvsNGCkhcK6eB0?=
 =?us-ascii?Q?uSkzjJFuNG9Lv7xexPJ+7ov3PD9tNYkjUj+tbRgcrvYmsJlYVLGdtNOISBwf?=
 =?us-ascii?Q?WJJqxl/wehyIT3hPgjExp+WMdCPSDKQ8Oty2aLj5GnIffSJ5sDjwO+TUTuLx?=
 =?us-ascii?Q?qbl9KfQ4FfIzy6V42mb9mzuEHuEYs7IpuPuvjn60zfA7PHaEQF1gUM5WU9IY?=
 =?us-ascii?Q?m0qMsCXCHx4N+SkmcrLoj9RpQ3QKWxdBZapSxRtUX8qA+fI3JB5Hs0fDVfHb?=
 =?us-ascii?Q?q9UAe/T8ZE1z8Cuon0NndxkTfZBLF0b8Kc4X+RRMB6wz3h6DJ7TwjXjhSM1f?=
 =?us-ascii?Q?AZ17sQvv/loExMiNe/nsgEEjyPLJ0Bklr8Zus/bWmN1I1Zu8/mZcfnqrqXaH?=
 =?us-ascii?Q?fX0giMtBZxx3A02c1cCo2OHvUEF9VqI7BQ00BxjcO6eS9fijriG+te4MxYu3?=
 =?us-ascii?Q?NnVGJDVIfVhVZBdRPvSNpHiZm5FP3554bbu7ejQEx3PjQWG37o/IoyUiqjZQ?=
 =?us-ascii?Q?gszeErpD24ZYEjt55vP1mH8C3ZcYb356L4U+/MuIHkIDnrTzrI3CDAQ8UjZH?=
 =?us-ascii?Q?Q6olbacucPZ6VdSSYHlxLfqSXBwHC3C7wUuJYzcGO1OhNXsalJmQqVJ2+6SM?=
 =?us-ascii?Q?Rdo+/jZZugkZFe73SZR6BIFvFDs3ePTD1AHq+oxTweVmKr4YEviVYpo+fJs0?=
 =?us-ascii?Q?Wk4BbmNInyf5m9hSm2TKwid13Mb4XSLztxgNl35oXywczPXYtZoraXyhg2Ko?=
 =?us-ascii?Q?eqNIPmCDNRhsl2U0pO59mKI/JicfxQpo0OlmUDSrQ3JilgcA+N20pHV35Xgz?=
 =?us-ascii?Q?kEa4yAKVxVxW6P2KWFY9T0OtdWGSRv1lGeV6Hz5J8oaaaQC5VhoPGpPYL3va?=
 =?us-ascii?Q?zgOEqbP+eby/X9fzTTp08LS9cO9F0G41B7nsxop0zNk7fpu0bcg/g7qvo8wl?=
 =?us-ascii?Q?5XsjwwShBaXBazn4uI9M85Uc85O6h/8JGWjauOhrE+iG6u0vytckqDvLeVXO?=
 =?us-ascii?Q?KhIGZKMGE6BHNzv2rvW/Asu/khoX0utMlAQ9lx5WMjRUYBeksPuPsGRQ9Uv9?=
 =?us-ascii?Q?bxSpPyxlgKpjZEjUEx8m2uUlG4kO+OFA32Z+VI9w4t9R4awsbp4zaUnpT9kh?=
 =?us-ascii?Q?GIRmdntmJiYah/YDAAJ2p/4Cv1n0Tzq4oco9AEuFp6+IHQf7vN47HohGCwGV?=
 =?us-ascii?Q?FQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c3dff282-2c79-424b-9a61-08db554621e9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 13:13:10.9820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JWMqwQYdvb+UwakL6Xjw1+dTPF7uP9kTIoztw703kr1SA22YOXXMhameEVINYlq1nQyo9/sagVwgtUKTpQ6YuashM0Qom/I5tOsQUjLaeMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8275
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 05:40:11PM +0200, Piotr Raczynski wrote:
> > @@ -1162,6 +1162,9 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
> >  	bool failure;
> >  	u32 first;
> >  
> > +	if (ntc != rx_ring->first_desc)
> > +		cached_ntc = rx_ring->first_desc;
> > +
> Would it make sense to apply likely/unlikely here since  we check it per
> packet?

This was done before running Rx processing loop so this was not per
packet, only a single check, but in the end we don't need this, see
Simon's reply.

> 
> Piotr
> >  	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
> >  #if (PAGE_SIZE < 8192)
> 
> > 

