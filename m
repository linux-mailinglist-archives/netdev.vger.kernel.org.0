Return-Path: <netdev+bounces-12134-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40C40736616
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:27:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 191D91C20B5B
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:27:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCA53882E;
	Tue, 20 Jun 2023 08:27:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69CCA92D
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 08:27:26 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E78CC
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 01:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687249645; x=1718785645;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7/ovYnCJBHMElfR0dJAA+8dHAmc1jjLMH79SuybQNOw=;
  b=nXBl6U1bMKdx5Ba6l9ta9KtHh3MNEJaEfKbIh1jH+lKngKQBWAPez4mD
   h7Zn9AA5gf/1om3HW8s4JO1zcqviIJl/r9RwgOjyUE5K2tnSmEjOJeQtK
   CtT0KsG05RRgJyVL0Te6V6LP0gUA8E+iYboPZ5/FdGDi24MhlA39ktG3+
   E+4nWeZ5HbdsyQQ9F3QGAyKp5ciosDTkqKuvA6Oe6djcCPrB2AEZv8Ttq
   ihrYRWKfcLIhxrcCUC/fdZlFbfzXlv5Rt+r2hgmaUppuAHBw+55db4kYh
   xzAjzKHqwrHgVPU2CDWsKgzI66EJCEr0pin1gbbX1z4ppcN2CtOxJMlJF
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="344543499"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="344543499"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 01:27:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="708171201"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="708171201"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 20 Jun 2023 01:27:24 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 20 Jun 2023 01:27:24 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 20 Jun 2023 01:27:24 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 20 Jun 2023 01:27:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QAE16Uo+ibrdfPtzLTjTNuDxV5kss0JxMwNDaEgkl3ns3n1X48wu1X2P+AIdiLaSj0jARat8IhzaUjtmEhiqtI7JFZwSLZdtH0uNiLdGkQ+6zNhBe6rX7IPnbzbbe7uJ89kw/+NDDPy62yajSIuRza4wNVdIQfH5jWBHjKqb0I+80xhcv+NM/lnTNEkdA3UsBcIdoh+sD2LNdbN+3PNuaiTr3DRGqU/83H2f0zOCkg3GA1IAtIdh9PFlIa+40I1pU/dUGR1VIml5gwZoiaTxU0EW2lw+PHqGfuIF1XHb1Qm9TLN213c64bUxddP/1hBflKq5I1t1kaFpz6AzYvAmvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fOF1gZ4GnTLlyaMJ8okMUGTqULwS52nOvyqLCvGQZgs=;
 b=ZhlAt/mbH6cKxwTTfs1Wh5QVeBL6Mzucjo6J4bnLKQt3JaFor9YgmMJmwFbnM39NM+MbRwxmsYIjQD0+Qk9ntUTKWVRUH8i0hRUinpp7heyGEDM/7aP1zV9nSrMj+rsgIwwC7OxHci1LX3nxOtOm+oQj04o5Wv8+flkl4VV3sABYRCkvCl35TddWuK2ow7HZ1LDbDbeTFyFVFcAw0GpmC/dMUPreGD/80vRZ8jYT85mMz3kYkUf8Pw606NNNYT8a0NUnStXaccrm4duxAxohtNGkEcpnj1nJdYwu7Z4p0UKI26iaWLbSeic5Ge1UIjjVjmT7vcKLMinXGeKeTI+31A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3672.namprd11.prod.outlook.com (2603:10b6:a03:fa::30)
 by DS7PR11MB7932.namprd11.prod.outlook.com (2603:10b6:8:e5::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37; Tue, 20 Jun 2023 08:27:21 +0000
Received: from BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::87ad:6b1:f9f4:9299]) by BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::87ad:6b1:f9f4:9299%5]) with mapi id 15.20.6521.020; Tue, 20 Jun 2023
 08:27:20 +0000
Message-ID: <f3dcd43c-0de6-e618-8f71-07f47a6b6071@intel.com>
Date: Tue, 20 Jun 2023 10:27:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH iwl-next v5] iavf: fix err handling for MAC replace
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>, Tony Nguyen
	<anthony.l.nguyen@intel.com>, Ahmed Zaki <ahmed.zaki@intel.com>, "Michal
 Swiatkowski" <michal.swiatkowski@linux.intel.com>, Rafal Romanowski
	<rafal.romanowski@intel.com>, Piotr Gardocki <piotrx.gardocki@intel.com>
References: <20230619080635.49412-1-przemyslaw.kitszel@intel.com>
 <ZJARN5Nj/IpdWNWQ@boxer>
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Content-Language: en-US
In-Reply-To: <ZJARN5Nj/IpdWNWQ@boxer>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0004.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::9) To BYAPR11MB3672.namprd11.prod.outlook.com
 (2603:10b6:a03:fa::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3672:EE_|DS7PR11MB7932:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ec4ba47-43ed-4bbd-13eb-08db71682a6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ukLyNWE+OEESloYLrumhmjQ5j70BZhqOskX72gZJFUiOsGgAsK0P6NptOXhl2n5U0zPtj5dAeCTJSDnqRq8o9bNPqQWgZOMoaVScWiKQyTDZRQ6SRPXQ7bcMs3Mw+3ADGYoTEyTohnPpbdqSbDjRFN6UDZeJxPqvwD4mTZMbFPVkQ7gphFmnnxZ5w5bgJzoyAi69GglxeBMvZgykarTnh08ocS/3psK7yXVnQxGhKHJX7Hg17SgMIdNKUOmkLGzSJyA12i+G7oLuF2fYUVqlMdgGQfsy3Fv5YHgzByxOdzvteDVl8Z7e+p3wY8dioT4RNyK2zCX2f1oD7+xc/Kqz1fzqCDWXUcKYG52mMfEismRj6gSNCPAdPmYBXYBXpO49ekQ27lcW6Qr3HvFMvhTjch0eAWycLECnGjZndvbZOLiNUOw+7OEGtEWMIzyL1GPjI2QA/KxQQeoxqsef4fZeVosjkwmYFXgq4ToF7qZU3Hg1QngGV6L6syXL35sCrCo0+14TMRTOYv+IFMp0Xnxx7nmXLxRjY87OM+iHu1awfylKsr72G97/LO92AyfGt01Za2k9LB12rVqMVkMPh2qraRHKVAWPXdKpLG5a09zbHhpFtyagSrCk91fgiwbxE15DkiNOeVMxs7Wg6lc0aZYOh9floY9RYVin+Wxclh8Zcso=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3672.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(376002)(346002)(39860400002)(366004)(451199021)(966005)(6666004)(6486002)(478600001)(186003)(53546011)(6512007)(6506007)(26005)(36756003)(2616005)(86362001)(31696002)(38100700002)(82960400001)(6636002)(4326008)(66556008)(66946007)(66476007)(316002)(31686004)(8936002)(8676002)(6862004)(5660300002)(41300700001)(2906002)(54906003)(37006003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjFMbGZhVEJvY2NjWEt2STN3ME91eGUvZ0RoZURQTTRwcWpBb3J4VS9JZ3cy?=
 =?utf-8?B?Y29oOCtoQ3IxTitkd0d4N0RTRkF2bDZ5ZGo5TDZvVXRyZTAyMnM3ZGo0OGhl?=
 =?utf-8?B?bHAzQllUbWorRm02R1ZjNmp1citaQTlsNWUreVlrQzJEYVJOdTg2Z0MxbEhj?=
 =?utf-8?B?TUNZVjJFWGdmK1FKdlNLRDlRWGZvRG9rc0d2YnNzbG5ZcXZkWmZMZzgxVmZu?=
 =?utf-8?B?N0RWNHdxeDQ5bS9wWDRObjl4NVNHZGxSbGxJZ0ZpdDFmUWlzQkV6WC9LaEFL?=
 =?utf-8?B?Ri8wK0hxKy9UUTNXbUdQRW9halBvVUExVlRDV05WVm1hcjhmSHQwT1N6SVlB?=
 =?utf-8?B?UEx6bTJpV0VDYTQzeU5TR3RoNHBvenRYU2txNjdJR3A4OThjRmtWYUp4SFIz?=
 =?utf-8?B?Z3JHS2dNT0xTeUd3SmV3K00va283c2VxMEQ1ZGZSamRGVU85QUNSeVlOZ0k4?=
 =?utf-8?B?UHR6d1NIUUpNSGNMbU4rNFFPZUhESE1KUzZDQStaeFd0ZEZzRVZUMmxNc0Fr?=
 =?utf-8?B?UnJyeFZvNHJPU0d3YkkvdkZVT2E4NG9LZTBtcit2L2lTaHpoNS9ySUZxZVRp?=
 =?utf-8?B?aGREa2tONGNMRTF3Y1Q4STA5NnZIMGk0cXAzVmMrakRKbVk4cFN2M2FBd1Mw?=
 =?utf-8?B?ZGpDZE9IQnF2Qm4xZWFpZVBLeWk5aEM5SjVCcGJyUHVMQXF6STdORXlndHEv?=
 =?utf-8?B?djdBMHN0VkUzVEpvQVpQR3U5WS83c1p2N3N6emhlcys4SGw2N1Q5dldGUXM2?=
 =?utf-8?B?WXFlQVM2cjdLZlAralphKy9WUzkwUVEydmFONS9Zbi9kWk40cHp6dFhOREk5?=
 =?utf-8?B?dGRqT2UrMUM4NnBlOS8wK0JScFhta3ZCM0ZlY1BDK2l1Q2R4UWVLREhkS21z?=
 =?utf-8?B?d285TDNMeEZpTHYycWxqdm5CZE5DQ0VoYXZoL3gvS05zNGwyMTFGdzV1Z1ZL?=
 =?utf-8?B?cGNRZ0JXdjV3cHdiRE1La2gvZFNESGFJWCtGVTdUM3BhaFJNbk9ITStwUTZj?=
 =?utf-8?B?VU5YWkJ4cjVQeHNoRlE0dEVNOWhZRWtWMHkvQVVpOUFXd092a1V1d0JhN25M?=
 =?utf-8?B?Y0tKVUE5QnpFaUZpekUzSW54NExRRnlURFE1dk9vT0Q1eHdCVkNyS2xVZHo1?=
 =?utf-8?B?c0FiTGtTdGRBUjQ2S1hWM3dPMnlXbWs0dTYyckNUYW1qSkJKNEZicWd3MTQ0?=
 =?utf-8?B?Q25WWVJxU0dmUTZCR21aMHo1YUxxY05SNW5FQkN5cTRqZDhjZW1vVjNjd0x3?=
 =?utf-8?B?OHVYTkdWT1JnSzNiNlJYZ2dWaFpzVEFyMmljSE9QY3BlN3FYUG9mWHdsMy8w?=
 =?utf-8?B?KzlSakkvekF4aUZrNVFSQjc3Kytlb2p2UkpGUEsrbERsYTBtaURkSlE4NHQz?=
 =?utf-8?B?YWtNbWkvVHJ6aUVnMmlIbk5iaEl5aDJ1YzJQZVJzSjhvRm1HTlp6d0FmcjQz?=
 =?utf-8?B?UnZuK2tMeHVhVVMwSklHMyswK04yMk11RjRRaStuSkJnNEFwZnZVRDNxR0c0?=
 =?utf-8?B?bmJkODcvZXVRK2ZIeU9RTUIyS0VwbG4zbGJ0alVLTndMdnFUcDR0MHRNSzhN?=
 =?utf-8?B?ZlN1aThLRi9XN285dW55M2ZuOEtRa3ZXMGM1eitxUUF5VEZXRVA5YzRhZ3Ru?=
 =?utf-8?B?L2xCd24yQWxTT0lEWk9YdS9DNWdrdzJMQlZySDFoNGM3NGZlVnFDQWJjTmVj?=
 =?utf-8?B?NG9uQ000N09tQkZkYzR5bWR5RXBWcnhCV3F5TXNEQkZVTG83YzdaeDQ2YXFX?=
 =?utf-8?B?Q2ZtN2EzekJodVhpSkFFRzZYdnBvaUZVSTFaSWN0dWFLNmJlM2VCeSs4UkZa?=
 =?utf-8?B?UXV6SS84cTNydHloQ0FsZVljTWxRWVhhS1Y2K1BQcmthSUloOE5qMUtaUHJK?=
 =?utf-8?B?Qi9zaURhU0lPOGUrdnkzUlY3UjdxY0p6VExRbWV2SDJzelFGU1ZEanR2NTJi?=
 =?utf-8?B?UEN3Z3JUZ0I3U3BpY1Zjb2dXK0paR1ByZlpIYVJqZkl5cnh1akg0TThmVi94?=
 =?utf-8?B?MEZzRmlWUGcrUW1DWmoxR0JzWnFIOVM0VmdUbGQzN0UwYXZPMXRVN0JhNjJz?=
 =?utf-8?B?QnhicUVXVmE2cU43Z3ZZdkFyck1xTnBvL29odXVzcFBLN3BUZ2xtaXJBNlRG?=
 =?utf-8?B?QkZEUnZrY3liRzNIeHBFNkwrMUZOdzlHbXcybjdjdlJPUGlHbWZhMnFreGRj?=
 =?utf-8?B?UXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ec4ba47-43ed-4bbd-13eb-08db71682a6f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3672.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 08:27:20.8733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aU4lEiyJi3PJxKJhOomSntJFE6lQHxxh5p5Fw/PZv8E6Jx4NP4Ja0OknahVsO/21WbLq8FqHNNH1Q7f/8AgQ1EfqXHi5YuZzHASNfHqTTzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7932
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/19/23 10:26, Maciej Fijalkowski wrote:
> On Mon, Jun 19, 2023 at 04:06:35AM -0400, Przemek Kitszel wrote:
>> Defer removal of current primary MAC until a replacement is successfully
>> added. Previous implementation would left filter list with no primary MAC.
>> This was found while reading the code.
>>
>> The patch takes advantage of the fact that there can only be a single primary
>> MAC filter at any time ([1] by Piotr)
>>
>> Piotr has also applied some review suggestions during our internal patch
>> submittal process.
>>
>> [1] https://lore.kernel.org/netdev/20230614145302.902301-2-piotrx.gardocki@intel.com/
>>
>> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
>> Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>
>> Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> 
> I was reviewing that:
> https://lore.kernel.org/netdev/ZH8JBgiZAvNdfg4+@boxer/
> 
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Thanks a lot both for insightful review, a remainder, and attitude :)

[...]


