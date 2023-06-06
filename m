Return-Path: <netdev+bounces-8461-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75BD972430D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:50:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36237280C8B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FBE237B83;
	Tue,  6 Jun 2023 12:50:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D80437B60
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 12:50:23 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403AD1701;
	Tue,  6 Jun 2023 05:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686055801; x=1717591801;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sn0oHPLVUPQNMV8adkovLgL2+xyrkHyvfizzUaRL3Fo=;
  b=nd9ni/p2Fx7pXaNKj2rMVnheGBITLAR0wDDtV86VUBwGaaxvZIKl1VEp
   Q0MRkZ+TF5sjnwA1xsIWMSjsVkySz6Ulyj1q+lfAKzsuoBDZf/PcDWMix
   Dn09t/J4uFZjAzevJvvqDBUbXN3kJx2G2zV2P4yzGXo5n9+hVEAM3iA6r
   4tN3n4m4/IfhW0LBr88jnvJEuVunTDFjTjJA4m14ZgzxVA2Jcs2IjYFJT
   Tu1gqhxrIobQ5hdFD7zJ7BFs7pgAGFK4KZNA9GjAITqFSQSPS/c7kpcDs
   8YHcUiKbInsUbnG5lQ00ovz/zlYzc+qXx0y7jCFonhWdj5SAtUqffoLu9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="384970877"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="384970877"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 05:49:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="778986489"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="778986489"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 06 Jun 2023 05:49:51 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 05:49:50 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 05:49:49 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 05:49:49 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 05:49:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fI/XF6CJiKg0r0d+RLoIhhZ+SUAwhM9DQSDzK8igIqK77vt5X7/dQSP7GgVGME/L6SDj9KFVuhZ2QGu7IzakynWemwqM0j2gRdo2plPbvm3JdJMq1mwS/6ALQVGdaF8/6ov04uxa/Y7QUtY/XOokxiWEd6tohp3KPKUJWLxrYvyYha8qPCtutaKMAmdyuNLdMP0GwK/j1bsLhBGqQn/S8LiPBC2fyD9HvgQ6+UfDZLgva69qTgEHKhRyAHaiQtVlQIEFyWLKrGrYWAqF+tQ1AnlSnQxHJqLdggyHa4rzZFR9e3E72Vs3rz/ewAcivUVLcl09i8pGtIrSDABHHY7SaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z/0tOYm2uwlDrY9w/hrqoZX14bBttiL91m2VNuO+sOE=;
 b=dqfEnXRRYkEC8S7kLSzL/rx2BhdUJu12yEV+Lq6a0Ci80r3QzQ9l29OdjKjRYb5RcsxSwBRPs/5cAGQ7Cpa/xF0n2upcgFaM+vmhN+2GbtSgYgYj2CiH1Maklbsn7LCFCgFV8mUBoatnCViLZan5Ud7o8zsntP23mFBZOHeRQTVECeL1v4nPFNrDF1nPvT8eCANakd6P60uzzCc81TlTbI7+IlFyB5WoIr4z1C4vVCVkgUVAO8zj4z69oFzC9MAArliR2BzeTNuLmj9Gq5pjFYnZ9Ay8AZjBzOo/4KOW21DTIY4dQSQSS2BES/ogBD2r+inI+nwRLY0TqIeC7ypGjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SN7PR11MB6678.namprd11.prod.outlook.com (2603:10b6:806:26a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 12:49:47 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 12:49:47 +0000
Message-ID: <5aac6822-6fe5-e182-935e-7aa86f1e820d@intel.com>
Date: Tue, 6 Jun 2023 14:47:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 03/12] iavf: optimize Rx
 buffer allocation a bunch
Content-Language: en-US
To: Alexander Duyck <alexander.duyck@gmail.com>
CC: Paul Menzel <pmenzel@molgen.mpg.de>, Jesper Dangaard Brouer
	<hawk@kernel.org>, Larysa Zaremba <larysa.zaremba@intel.com>,
	<netdev@vger.kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	<linux-kernel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Michal Kubiak <michal.kubiak@intel.com>,
	<intel-wired-lan@lists.osuosl.org>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Christoph Hellwig <hch@lst.de>, Magnus Karlsson
	<magnus.karlsson@intel.com>
References: <20230525125746.553874-1-aleksander.lobakin@intel.com>
 <20230525125746.553874-4-aleksander.lobakin@intel.com>
 <8828262f1c238ab28be9ec87a7701acd791af926.camel@gmail.com>
 <cb7d3479-63a5-31b4-355d-b12a7e1b2878@intel.com>
 <CAKgT0Ud204CiJeB-5zcTKdrv7ODrfP09t73CqRhps7g3qhWU5w@mail.gmail.com>
 <d375fef9-43c4-9f2a-41c9-5247fcb3aa1e@intel.com>
 <CAKgT0Uc4UQ=PpVtjUAP=hjTDrWWkc79PeSwp39T6MSpo1ZyOag@mail.gmail.com>
 <cd88ac7e-fe82-fdc0-3410-0decf57d3c43@intel.com>
 <CAKgT0UeEz2Gqb62sn0pP3_yBMc-LpR0Twmv5_HTREvHBLpCsNw@mail.gmail.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <CAKgT0UeEz2Gqb62sn0pP3_yBMc-LpR0Twmv5_HTREvHBLpCsNw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0113.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SN7PR11MB6678:EE_
X-MS-Office365-Filtering-Correlation-Id: 20a86b44-ac24-4419-5fea-08db668c8216
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ckCGM8/lKLiOmECP7EIeFvdONer3ISzsLmAbjP83RWf238FHEECsDwpcG7SzSmWBuZ+GTzMjwKwEothsxguwpOf+mMeB3cmw5y8o9YjLshrabbxG8BU2vtV2MM4cDA9IOnQ/DnTly5VF4FZu5FkwUnltQvqdDe4/0sRb2cxI9cXncT1n3AqBcwdZMJisS9OMGxmda9f5Od17hJkYkz4fkv4Wb7PqNgR6TZJYUk7KTN1HUkfgQhOsgZRx2bonCjaGBq9JaS+FCnUA38tCEzwlh4Mu8qlrMHfafNrjtIjlXj70ZNWVqA0VsZvh27yxGJ51HN9APtURWxGlFoXXOOBUL818BHllYCuGQgMyYCB38ezrCC3Ax/DOkOmipBEb5gaTd9lRIierWrCADknCEFWTXJLo7ZNwHy/2uvI1Lvu7HxPubmgk72A5RgCgdc/DapO59+NXYlo2cUEkRxrjXYNnvKkH4C3BJe6odyFiM07caWYIkolPk/c2tiknQm+hiAikcEkiqMDqH9uCo0WDxTwdbakdUw60WELh9qRbSVqUcmpedqA9QVIJwZ/FcUKSuslwYsTZ0rfYuIMusSVahsJTLP6tsScbZAedCoj3myA9yGTFbnWIGvVEMffDLBswAcR16ABpDZuv87JuitxTEuQhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(396003)(39860400002)(366004)(136003)(451199021)(8676002)(5660300002)(316002)(2906002)(7416002)(6916009)(66946007)(66476007)(4326008)(66556008)(8936002)(41300700001)(6486002)(54906003)(6666004)(6512007)(53546011)(6506007)(26005)(31686004)(186003)(107886003)(36756003)(2616005)(83380400001)(478600001)(82960400001)(38100700002)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGFwUEdLbzhjRVcvM2trbHRSQVA4cEFIMmF3UlZYdUY5Nzc0NU5OZk9qVVBM?=
 =?utf-8?B?d2FuYmRkS2Zuamc1c01ic0FCOGlkbXp3OWhwOU45UVZhaXNJVjUrTlZBRFEr?=
 =?utf-8?B?R24zZlE4a2ZkQmRmTmREMnE5TUpWejI2bTFYcDM0eEpEM09LRUJkTjFnd0Vi?=
 =?utf-8?B?SWN2VXBHcjBVRGR6UmFQWllFMmhIbHJDWERkck10MmQ0RzZKMWtSRjJsUGRx?=
 =?utf-8?B?V1B4QW1QbW9ERno3c0dQV1lCZVc3UndqWXRBanBZdFUvc0tLU2wrdkJDd1My?=
 =?utf-8?B?TFp1dEpsdE1Zei9ZdmxIQ2pMS1Z2NmtGRmJwWkU1anZoS056TFEvcWk3Qi8r?=
 =?utf-8?B?ZVVvRUtpVURpdUtac2VDanRTcmpiSkloMmRkV0FpbFNyS29md2pQbUV4Nysv?=
 =?utf-8?B?amdTY09rWW5iVCtKUWxtZUZUNWNLczR0emR3ZFlEQlNJVzZpNEQ4MklBUHow?=
 =?utf-8?B?ODBVYzV6VUMyTFkxeEI1dTB3OTl3ZGZnS0JFWjJZYTNiM1ZaQ3lWZDRBS0sz?=
 =?utf-8?B?a2R4MlY1ZHhYOUJlTWJoRG1YeWNqaW1BR1lIaGdYSnlUdHZ5Ky9MZy82NDYy?=
 =?utf-8?B?ekdlYmVveGNOOXUrQUx6OElsTUM2aWRFamxlajQ3SU44Uld0a0U5d0lHNnJ2?=
 =?utf-8?B?VGFvZkQzM0MyRXp0Zk9XK1oxb1FqSzdGdjR6NVdwdnVzUWEyL3dycVl2S3la?=
 =?utf-8?B?enJGaFhmYUhES3N1dDZkQTdpRDJlZXkrWDhPdWxQbXRBdFpqUlpZNUJVMXlH?=
 =?utf-8?B?UWpmbmVMZXVBbTVDYXFjTUJyb1U5RUM3dmd2QTFlV084K3kwZ2ZMakJHbThT?=
 =?utf-8?B?Uk5kdWJNck1RMmFCNW9wZUZhaERmNmFacWMwUXBGNURtZzFhcnpVS3krQkRv?=
 =?utf-8?B?TVdGdnZxNEVyVGhZL215clB4eHhONU1EZDllendBUFkzbVZSdVYxMXV1RHdz?=
 =?utf-8?B?KzcwYUQwdDhUNUNrcVgwZUJBdjFmYXdnSTBOT2h3SFZmbGMwZXg3dkE4Mm9s?=
 =?utf-8?B?RDRWdUExdG1IajJ6RGRLa3NvaFZZVURudmNZSVJpN3JUUFFGMUptLy91ZkNO?=
 =?utf-8?B?blEwaGRLR0syVXRNdjVUSzQwT284RHlrcm9qSFM0MGQ4TlZJWUhnMTE1L2Fl?=
 =?utf-8?B?M2djYnREZENzSG5sTkwvMWRtM2czSFFWUWI2QlV6ZUNxYTVMTWpuK1BnMElw?=
 =?utf-8?B?YU1aelFjaGR4Qjlnb2Z0YkxFM3RBWHgzUVUwTWxKeTN3d0c3RlVMZTJpblUv?=
 =?utf-8?B?Zk9NWTVBbG55U0hxYTF3dmNENFVOQjUrSXN4aldKWmo5eHBFWGVFTVpuTmlk?=
 =?utf-8?B?Um10Nkwra3Q0R1dURTdyZk5HaEo3WFlaZjZDOEtJdE50MXE1dWljZGxrZmla?=
 =?utf-8?B?bFlqUjdSUktucFhlSDVvQ3pjMVoxZTlhWDErOW5NQzAzYUJkRC9zUHhEbjlj?=
 =?utf-8?B?TGxMVWFRVTdscFNWMy8zbktraVRPZWcvYkFqSTcxemRURldqNm1qS1NUOE5U?=
 =?utf-8?B?ODRXRGgrK1JJWmpkYnJIOXdTeVBocnRac1BRRG5sbVFrcDlhT2Z2RDl1ZUd1?=
 =?utf-8?B?MGhDYTloaUNCY0s4eGRpTndoRkZLTjdDa3FhckpvaVdaQlRySjZ0WGRna2RN?=
 =?utf-8?B?K2hMejZoNjRVQTEzaWQ3NzBqTEcxZ2dIMmpocWtJakEyb3kxeENDVDVlcnlL?=
 =?utf-8?B?VjVSYTdiRVdTWG1EeUxvWlRQYXdjUTU2SG92QVQxRHBrN2Zwa0hxWW1HYkhE?=
 =?utf-8?B?OW9aKzVlb1dxVlFxNFNXN2dIMG44ZmNrUGJMYTZlTWxSVDVySUJXSTQ4RTZV?=
 =?utf-8?B?MzQ0UTVBRkpPcCs2ZlhLUWdlcHpLWnRIekJ5NTYzUEFPUHdRSFl2OXU5ZXRY?=
 =?utf-8?B?emduSWhPTUVKL2VqQ09aQTZZU1dMNVlaUWM1aWhVOHVSWGN4SzA2QjE2OWdn?=
 =?utf-8?B?LzRLUWxraEVyd3M4OEhPeVpISm9qVWdqSlRpbjVNWG5IVU10L1hONEVFb0RK?=
 =?utf-8?B?djAvS3BEQUFuN2g4NVB4SmI5eVBuSEUwNmt5cWNmRFV5cmhhT3FUZ3ZQVnR5?=
 =?utf-8?B?RUJhTWwwUzM5VVMxZk53eVNzUmR1SmErWWhRMTJsNzdNM2F0WlN1WDFjL1pZ?=
 =?utf-8?B?SWVyZ3VxZTdBZm5XUzA4VnM1ZUJWcWdHNFdHaFo1YkpXck9HQWVxRlduemRZ?=
 =?utf-8?B?c2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 20a86b44-ac24-4419-5fea-08db668c8216
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 12:49:47.1130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mnYUYLElIwXKq5GcUoZja7svRqMIb8Fbln37qvq4G+F01ydEU6opLpBk8HuLmM6YUklTzI7s4uxFxyNCrXCH/11hgh5Yf5l5SAYQdsbKXbc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6678
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Fri, 2 Jun 2023 10:50:02 -0700

Sorry for the silence, had sorta long weekend :p

> On Fri, Jun 2, 2023 at 9:16 AM Alexander Lobakin
> <aleksander.lobakin@intel.com> wrote:

[...]

>> Ok, maybe I phrased it badly.
>> If we don't stop the loop until skb is passed up the stack, how we can
>> go out of the loop with an unfinished skb? Previously, I thought lots of
>> drivers do that, as you may exhaust your budget prior to reaching the
>> last fragment, so you'll get back to the skb on the next poll.
>> But if we count 1 skb as budget unit, not descriptor, how we can end up
>> breaking the loop prior to finishing the skb? I can imagine only one
>> situation: HW gave us some buffers, but still processes the EOP buffer,
>> so we don't have any more descriptors to process, but the skb is still
>> unfinished. But sounds weird TBH, I thought HW processes frames
>> "atomically", i.e. it doesn't give you buffers until they hold the whole
>> frame :D
> 
> The problem is the frames aren't necessarily written back atomically.
> One big issue is descriptor write back. The hardware will try to cache
> line optimize things in order to improve performance. It is possible
> for a single frame to straddle either side of a cache line. As a
> result the first half may be written back, the driver then processes
> that cache line, and finds the next one isn't populated while the
> hardware is collecting enough descriptors to write back the next one.

Ah okay, that's was I was suspecting. So it's not atomic and
skb/xdp_buff is stored on the ring to handle such cases, not budget
exhausting.
Thanks for the detailed explanation. I feel 1 skb = 1 unit more logical
optimal to me now :D

> 
> It is also one of the reasons why I went to so much effort to prevent
> us from writing to the descriptor ring in the cleanup paths. You never
> know when you might be processing an earlier frame and accidently
> wander into a section that is in the process of being written. I think
> that is addressed now mostly through the use of completion queues
> instead of the single ring that used to process both work and
> completions.

Completion rings are neat, you totally avoid writing anything to HW on
Rx polling and vice versa, no descriptor read on refilling. My
preference is to not refill anything on NAPI and do a separate workqueue
for that, esp. given that most NICs nowadays have "refill me please"
interrupt.
Please don't look at the idpf code, IIRC from what I've been told they
do it the "old" way and touch both receive and refill queues on Rx
polling :s :D

>> ice has xdp_buff on the ring for XDP multi-buffer. It's more lightweight
>> than skb, but also carries the frags, since frags is a part of shinfo,
>> not skb.
>> It's totally fine and we'll end up doing the same here, my question was
>> as I explained below.
> 
> Okay. I haven't looked at ice that closely so I wasn't aware of that.

No prob, just FYI. This moves us one step closer to passing something
more lightweight than skb up the stack in non-extreme cases, so that the
stack will take care of it when GROing :)

>>> Yep, now the question is how many drivers can be pulled into using
>>> this library. The issue is going to be all the extra features and
>>> workarounds outside of your basic Tx/Rx will complicate the code since
>>> all the drivers implement them a bit differently. One of the reasons
>>> for not consolidating them was to allow for performance optimizing for
>>> each driver. By combining them you are going to likely need to add a
>>> number of new conditional paths to the fast path.
>>
>> When I was counting the number of spots in the Rx polling function that
>> need to have switch-cases/ifs in order to be able to merge the code
>> (e.g. parsing the descriptors), it was something around 4-5 (per
>> packet). So it can only be figured out during the testing whether adding
>> new branches actually hurts there.
> 
> The other thing is you may want to double check CPU(s) you are
> expected to support as last I knew switch statements were still
> expensive due to all the old spectre/meltdown workarounds.
Wait, are switch-cases also affected? I wasn't aware of that. For sure I
didn't even consider using ops/indirect calls, but switch-cases... I saw
lots o'times people replacing indirections with switch-cases, what's the
point otherwise :D

Thanks,
Olek

