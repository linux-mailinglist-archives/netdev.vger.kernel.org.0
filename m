Return-Path: <netdev+bounces-10185-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 064BF72CBBD
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 18:43:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA3332811AA
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:43:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2FEE7474;
	Mon, 12 Jun 2023 16:43:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B623C10FB
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 16:43:14 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A011B8
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686588193; x=1718124193;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NcxZmgqaZhdVY2t1Bd5aPO78kCv+FbVZ+DzLg0X9V9Q=;
  b=XBoq+vyc/sIwIOQcyTCPhFS/XdjsxK1v2nrjQ2up5s+aY2OGALeyl1Yi
   4oSrF/n4NQE2lendLKHHNvaAj4ufXdm4TxkilVEQiBuWd9TDuo0vHvJiU
   KLHT1CbwPFIqQMeUigQCO6Tp80Mkw+wtysXs6c8wwJzwYPtTOB2UNYXai
   lfbXYlkBgjjHV0p32X54Kr0dw/wsCEAX+iC5zCXaxKxPv9MpIhzicrUUo
   DMEohuccotvGEdRHFrnrV2nTStovmey1dx/xvLvT1MoZOvv65mYDmwqw4
   mdOhFdOuZ0tx3Fq4eRUq5LFlP7DcVGWzbBzqE7esEUnuW+Th53Dyzb5KC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="421688703"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="421688703"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 09:43:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="711291268"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="711291268"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 12 Jun 2023 09:43:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 09:43:12 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 09:43:12 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 09:43:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R1h8XiTABIHS/e2PRbbWThckvlQdbjw90j/Oa7+neIJ7H0pNU9+9+VJVtPybih104UoD4T/a3TUegSF4jVJWunM6V+wYXsUB6Iyz14JxOfFDQvRQn4E3ulG+tlncRgWGO9jeLIo7tEKlPd+KUZ45tKWUashB4inuRmJOubEcGQMfNcuLcFiaiq2jEqG2y3wn4seP+0rDvmXJykSRGcP65p/ABqxErctYucQurQr1znfl/8LZBYHiWP/ZUjb6DCtLqgCeiwmroI20jB0Ev0R21K9ve7ClYZA4MVGNZaAfIdZ7V8ijvEuhWDcf/qrMr4Vu4pIUbeBvBjd+48V3SE1nmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W6a+VywP/BjFOexpF9gjzGudY+wwGR6IFK7Vacp5170=;
 b=OIiXo1HFQCO2KEhKqzq7JPknu3OQAfjQ204gqq9PLx1pkqto1tFR2Y6j9Si7UZK94mMrB8amXZBXHijMpq+bq/yGVjCTNCLp9E9PJl4dsNcOEuaYwnuV9FmshpIThGKFsIN50303cxG4fY4bonBP+RuznB01wNhewSFGEI9MfO85L5luUebloFBRy/OFCatkNBSYPDTjleED9Cfm4Gwh5659V3cyOAA+EMwN80FYnl3uT36OzB6maXLf3YKFjPts9/DXhcxtKeyh8UFz2HnUma2prUgRtfIR3PaAduf0McY/pX/ydMudI89YVhTJ1vRQUZpz12LligSmCdxU/skiHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB4451.namprd11.prod.outlook.com (2603:10b6:a03:1cb::30)
 by SJ2PR11MB8540.namprd11.prod.outlook.com (2603:10b6:a03:574::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 16:43:09 +0000
Received: from BY5PR11MB4451.namprd11.prod.outlook.com
 ([fe80::c5b8:6699:99fa:fbeb]) by BY5PR11MB4451.namprd11.prod.outlook.com
 ([fe80::c5b8:6699:99fa:fbeb%5]) with mapi id 15.20.6477.028; Mon, 12 Jun 2023
 16:43:09 +0000
Message-ID: <f77b5c89-0f3d-80f9-19f4-f82a2ebf524e@intel.com>
Date: Mon, 12 Jun 2023 18:43:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH net-next] net: add check for current MAC address in
 dev_set_mac_address
Content-Language: en-US
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC: Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
	<przemyslaw.kitszel@intel.com>, <michal.swiatkowski@linux.intel.com>,
	<pmenzel@molgen.mpg.de>, <anthony.l.nguyen@intel.com>,
	<simon.horman@corigine.com>, <aleksander.lobakin@intel.com>
References: <20230609165241.827338-1-piotrx.gardocki@intel.com>
 <20230609234439.3f415cd0@kernel.org>
 <b4242291-3476-03cc-523f-a09307dd0d08@intel.com> <ZIc7y9PdEdyCBb9r@boxer>
From: Piotr Gardocki <piotrx.gardocki@intel.com>
In-Reply-To: <ZIc7y9PdEdyCBb9r@boxer>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0203.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::11) To BY5PR11MB4451.namprd11.prod.outlook.com
 (2603:10b6:a03:1cb::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB4451:EE_|SJ2PR11MB8540:EE_
X-MS-Office365-Filtering-Correlation-Id: 097e9875-ffcd-4214-813b-08db6b641a86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: whiiffHg44e1MSZMXijWiEMK6H4SWTBhDBm3Z4J0K4XLlxm34xKa6U1WUuujAfuRhQDP3d5oBiySl3ahxPFrNL0TC3MjspjBCzo8ZRvOidDEiQrrHNvdOhorwdbEnv2J+2CHmmUTRtGBBQo1Rey/J6dLptCucx5wUyWgpcmRwR9o1xPlfVsAyjYdWeOge8IXW1+uf3PcKLjwBrYyg8PvAk37UF6bbl3Gj2b1UoCRdvZGQicDTkA8hlAL49q5vySW683f7In3J/lNJSNIPdvPpQZDJ24Jfbg/L1f9y+QCgHJrlYWdG40l4oHAMNg4DIXXG8YzBGnBEhzQgK643KzvIWIo9r974uQDqWr0czw/sA8TU4d0KJwvkR9owTNSw5uij4jfasD2/iVZSPfGMdIb18AwHu9fJ7UN+Fl4mT9r/hat3snD3aeZEM0p2JliDDELUG5nibSdDb/RSHldgU/r59L1Y4kFoahtQ5Jg9ahLWeSyeJTqEBM38xxbsGOcda+0Qqwa6KJQrACgIoVwsJ20wn8M/+FR/5SJj/HFrqYFMCdFHbJPetpVXQ5+4/ncSIJZwd8rEDj+HuYa/EgylhBenhNBGGAb71v4mQFX34+thZ3Dgg7F9Gy2dpO/OiZdiuibUo8OIpr60XgI1Qm3lxliJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4451.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(376002)(396003)(366004)(346002)(451199021)(66946007)(66476007)(66556008)(37006003)(478600001)(6862004)(8676002)(5660300002)(8936002)(36756003)(6636002)(6666004)(31686004)(4326008)(41300700001)(6486002)(316002)(38100700002)(82960400001)(186003)(53546011)(6506007)(26005)(2906002)(86362001)(2616005)(31696002)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlBmUUVtTDVNd2JGYTFkdWNiNUNpd0E3T0o3WDhrRVB3UnhJOSsvNXFNaDAz?=
 =?utf-8?B?aFVXWEdGNlZ0ODBSQ3ZuVmQvaFpKUFZYWEhDNTN3d244Z2tVUE5wVFJHOEM3?=
 =?utf-8?B?anVlOXcyK3E0NjNZRjZ5SS85OGNrT2l4cGNZemNkbHdUR3ZXOEJBK3JubDA2?=
 =?utf-8?B?djgvTzZicHBWM3ZKUkFJemZKelJ4VUxEMWtBK2d5VCtDVEdwRWFyNUlOVm9R?=
 =?utf-8?B?cytzUVJobkZvT2JPQnVwNzRhalpNMzRWQzZMTzVoUWoxRGhRcnNRY1ZiNUwx?=
 =?utf-8?B?UUlWNWJDN2phWEsrMHYrYk00TTVKTlIyalVoM2hHRmluaHhMRXlqaFZybFBi?=
 =?utf-8?B?QWUyV0FuVnRGWnE1REIzbnJCZnVuaTBQRk1aNDl5Zm1vY2hzcjFhT2VRakMx?=
 =?utf-8?B?S09vdUNBY3FBQmMxMVdaeEpIZ1VlVjhHUUpLK0wrWjVzVWFaMjBkK0hTWEZk?=
 =?utf-8?B?RDFmZTNPM3NuZGQyOVdrNnFKMXk4Z25SRlFMSXF0K09Hd3NRMDJ6TGorTU9G?=
 =?utf-8?B?dlduREdlalVSZkN6WVVDT1EvU2I0N2dlRTRCTXV2WDJESCszOHVsMWxoSVhV?=
 =?utf-8?B?L3RLUzVFU3pkb3MzSXY3SXBnUU5Nb3piUk9DT25EM085QWJkVTRoc1I0SVcz?=
 =?utf-8?B?M3IzRzJZN0JxT1o5dndHZ0dnNUVUUjh2eXFmeVd1T3VtUTZrSkxMaGh6WnZI?=
 =?utf-8?B?UVBNODZKYzVwbFZLcmIrTDRQcmhteXdvNE9IMDduQ3VNY3JUTVdRaWhteURl?=
 =?utf-8?B?WkFJN3RBY0lzWm9oOUlLZktucGgxeTFoTzROWHVqa2hDd3p3Y2ZjM0FXZlZz?=
 =?utf-8?B?Q0g3NUJkZ0gweHJtVTNBaUxTOURhdGlNemZwZ3lvYjhsS043TnorMG9ILzFV?=
 =?utf-8?B?VE5yYzJydGVyWktBaDFramFiUnFVVEJUR3J4L3QzMkhLWXhwS1FOUHR4UEtF?=
 =?utf-8?B?K3hOd2ZGejdDdTBiOVdHQThjbHd5Slh2YTZtWm1PeHZqUC9nc0NYazB3b0I4?=
 =?utf-8?B?Ym4zM0lmQ2pFZ1hHQzZQcm9xOXJpUXp6WUpTeFR6dDRMbnpQOHB3eTVEcThk?=
 =?utf-8?B?U1lIdVVtQ0JhaFZ3WDFaR3R2bjdrdVpadlh1amVFUURKYlpEL3N3d1Z6VzY5?=
 =?utf-8?B?WjBrTjhvZE1GWU4yd0xqVXhCQlNEUGRSd05xdzF1dTEwcnBpZUNhL3JMM1Fp?=
 =?utf-8?B?V3JCSHhGcDV1dzNIMEFrbEx1ZTcyY3FCSTRTQ3RtTjh3aG5xTTFkck5jdzQ0?=
 =?utf-8?B?TUloUUxyNCtKN3I4SkFSQlZ0aGpicGNvRFo5ckxFQTQ5MjFHbDZwOVN2SHRG?=
 =?utf-8?B?RTFrb3ZLQmkvKzFKaXhKYUJ2dmpxdzNDVWUwUnFySkVxUzQ1UGwrOU1nVkk3?=
 =?utf-8?B?ZnVycVpsY0RQdTNVWFAzSU0vWjdsZEtIc29udjNRckpGNGZ0ZENqSllibXdy?=
 =?utf-8?B?SEd3RFUrbk5nWG1UTjZwUFU4N0RnYUZoS1IwOXJrZndwd1orRy9YQjc0cS9N?=
 =?utf-8?B?RlhPalRQUWluWEwzYWRINGVpcEE4VUVYMU1ZQnJUY1FTYThEemtuNXRxcmFP?=
 =?utf-8?B?TXljOHo5cWF0WEQ1d21PNjJZb29MZzRxSEhjdlZDUlVzTWJIN2hJUDg1Z2hl?=
 =?utf-8?B?WTJSbGZyZkVmY0tDMEpoTzduRi9wUjVjOFhnaUZ2SnFBV3lGTEtOQlVSYWp4?=
 =?utf-8?B?UDZCTGxrUU9ITzJ4d1RPOTFqMGtNdi9QaWpxQklVVitUTFpXLzVMa0JTT294?=
 =?utf-8?B?azlhSjRMaHVVcTBSR25kckdZMzE5cEhzdzlEZ1Q2dnpGdVR4KzNBSjJPRUpI?=
 =?utf-8?B?QklGbjdsZ0I0eEZxcnBvb1hWS1QvZjNCN0pta0tLclh2MkdJcmY4anBRUCtu?=
 =?utf-8?B?VWZReEVVOW9TazJXd3dJVjdTeFZSa0ZORWs0TDJlYkZpdk9xZ1ZNd1BjRGQv?=
 =?utf-8?B?NTFCdzVsOVNsMmdKUDkyWTlRY1dtcEFEb3NMMW14U0lTN2VoSy9GTkUzRUZp?=
 =?utf-8?B?ODg2b08yVVZyamxSUlJ1MW5nb2JHV1kyUFNiYlBoNTd5KzBLWHpWR25ZaFM2?=
 =?utf-8?B?dG5RNWRBWEEwVy9JL2htSlQ2LzhhNW9ES1RXT0UxMzFuZWVwTkJrZTNlNERS?=
 =?utf-8?B?bmVqbUhGa3ZYTnBXOER6MVdWVzdTazRTNWhYY1JDN2tQQno0cFkyTitmSFVN?=
 =?utf-8?B?Q0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 097e9875-ffcd-4214-813b-08db6b641a86
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4451.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 16:43:09.1798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jgLZnckdyZkJEQdZ9WtzqTOliOm3W3Qx2dnpl0QZKQhvLBslqrhz09IDaBqSsxVSkeG1if0s6I3y3bjn06HdFu5GaaKa/aVEZfbLg6CyCZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8540
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 12.06.2023 17:37, Maciej Fijalkowski wrote:
> On Mon, Jun 12, 2023 at 04:49:47PM +0200, Piotr Gardocki wrote:
>> On 10.06.2023 08:44, Jakub Kicinski wrote:
>>> On Fri,  9 Jun 2023 18:52:41 +0200 Piotr Gardocki wrote:
>>>> +	if (ether_addr_equal(dev->dev_addr, sa->sa_data))
>>>> +		return 0;
>>>
>>> not every device is ethernet, you need to use dev->addr_len for
>>> the comparison.
>>
>> Before re-sending I just want to double check.
>> Did you mean checking if sa->sa_family == AF_LOCAL ?
>> There's no length in sockaddr.
>>
>> It would like this:
>> 	if (sa->sa_family == AF_LOCAL &&
>> 	    ether_addr_equal(dev->dev_addr, sa->sa_data))
>> 		return 0;
> 
> I believe Jakub just wanted this:
> 
> 	if (dev->addr_len)
> 		if (ether_addr_equal(dev->dev_addr, sa->sa_data))
> 			return 0;
> 
> so no clue why you want anything from sockaddr?

I understood that dev->type and dev->addr_len can just be different
than AF_LOCAL and 48 bits in this function.
Your version does not convince me, let's wait for Jakub's judgement.

