Return-Path: <netdev+bounces-10443-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FF4872E852
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:23:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FB95281078
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:23:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8387E3C0AD;
	Tue, 13 Jun 2023 16:23:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756A523DB
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 16:23:35 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E164E1;
	Tue, 13 Jun 2023 09:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686673414; x=1718209414;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NDcHGxw1CNdPlvSvShic0BGGrA96azAguka/zb9SDF4=;
  b=lO3mjMMSc0RU31bGqePYKhYT+yGXGdYFs8Vcw4Pbx/PxQlqf3D4gpBJR
   NaNkozS50Tvd6xb2HwRdtyuwQYVcofBg9IpZgjacD0e0LdM1LRy0WYZJb
   /8kVmmIsdemBJbVUB39vg99G4bMKYDJ2LDyIBYMW1ZUg1BnxNQBYrGee1
   9375fBhVMAcvBaOp0gMTW4kE+dN0DSvbCxoEzJKieQR3eouZSWhjnllpV
   rk5bn8wKvEMdqMlkTVsP2LMvn97+y1beeofTWKy4PiWfIjtP04IzTSaLK
   swdde9IE5R/xEk+3/XkTfSfjTnph2DOOWPYZ6GQ/9P131zvQGRKfna0VY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="444757199"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="444757199"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 09:23:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="824470475"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="824470475"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 13 Jun 2023 09:23:32 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 09:23:31 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 09:23:31 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 09:23:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i3AnE1SzozW/OM2KqBlRo44DWnrpNi++ZAW32ipTWR7EKql6G3YDkIFPDmMPvtmvQatcXRnR4lCc7fyeYA3fpXdEz5v7YMdme26gg7MDf8ncTh6viYHc1gv8ShgpeDMCcTraEVmd1jjCxcp5733a/+TMeAF6ybakH52ZWVVwfZ5hJzSMMSLxWDNGY4JWNX3vGibrO5YBh0cVmKpTV3jj0dvNrzKgqgmp6JuKiKk8j4uRzMnYc+iRMCi1lPhbTmWbWnA3tsoOd26pD/5HD74i0x6avNWwS0YF9q9od8Lsd8iY1MLsLoVjDEWIdFmBpoFpHKgtKRqy9U+7pq+/+lIN8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uMmOEG3MOE2kbgZ08lzt2E/D4WX2FDxHNJkBl3Eccj8=;
 b=n0MjOFWrsgefDXYmYNzjPbVJzhCuR8X1kwSJJJ5Lt00s2ucDwvUmt+2fP6ueZRGgwqTuuYkQzb3yBfIsgqOF/fDwWlEsFhwblFgEd91EEH8DCX0YWhBqVa/mZk3vvBSQvr/CvaYkZvp09SL8ghgMLMSIRWjVr7k1L/rKqnmBEzPzXffd9BiUvJFUWGmqcRWDvPP6VRlxJAwrB5bm3iPB8RTQYRqj0VHNbEoLEZeLa2ASDvsmI+x8IMqqGs8KHf5hsaYHG5diPTKBqdQUZDAvcASSZkAjBGVhAscRySOud/2ao/c5szxciAuz4gFaafQnlVc1In0bGk4SQOuvHPCZJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by MW3PR11MB4698.namprd11.prod.outlook.com (2603:10b6:303:5a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 16:23:23 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84%7]) with mapi id 15.20.6455.039; Tue, 13 Jun 2023
 16:23:22 +0000
Message-ID: <d9fd12f1-a858-c67e-b17f-2299bba9b17c@intel.com>
Date: Tue, 13 Jun 2023 09:23:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [Intel-wired-lan] [PATCH iwl-next v7 00/15] Introduce Intel IDPF
 driver
To: Alexander Lobakin <aleksander.lobakin@intel.com>, Pavan Kumar Linga
	<pavan.kumar.linga@intel.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Eric Dumazet
	<edumazet@google.com>, <intel-wired-lan@lists.osuosl.org>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S. Miller"
	<davem@davemloft.net>
References: <20230612231021.39409-1-pavan.kumar.linga@intel.com>
 <293a81d3-f0b4-904c-a5f9-64ce091f1ecd@intel.com>
Content-Language: en-US
From: Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <293a81d3-f0b4-904c-a5f9-64ce091f1ecd@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0214.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::9) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|MW3PR11MB4698:EE_
X-MS-Office365-Filtering-Correlation-Id: 185e6bb7-7948-4f9b-7ec5-08db6c2a81ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sddvEdM6z21t86laNUeEZcx12AxEHgr05HiMQDoskrB1v4zykcKgmgs8CW+wmwm+JDuNF61QdPfDOpQE/Sgcn1FLU6Wna4TW7E5gClp/SRQDvoknnHybQgayQuL0JuWluDBVqrssrv/9nWnaTuzUS2l8m5YaadEPPOXNOmEwTMZOzYWTKcb9XTYroDDwfF3YYRJqUh08DjpvkWhktyOo73BajGGEqO8LHrQfNxtc/p1giUr5o9kvGMNyPXU8JJXUzUDBtB08Rd8ZdZcJMinsagzd1gXYZ8TokJCVSSIljAdlI+3iQYQeDG6nWdON6RxpYB1iJPsIDvkIXo6/NBG5DO1Et+i2T1dRdM8+rlMrp7D4LqUn0CMKCBlLMDjRSByIZeLFo4sH2MZSEPTPZx+H1SHeOBpv6dnhf8kiP1H6qSGPR/sF/85U1lOPDFiP7YKVpx5zj5mle1hH6eUhZJLLGqphAJ+dlb4J4uM/UBWJ/PZxChj2x22XZUqt1HLtXhRhg8AOvZiR6I/BO+KnrszEtzZFUexjF7HCWIZlJxJk/b2j+Hn3ez/qJZjz6a/LGETrUoapuAi+djepYW5BM7UMaZs+OTVNIXuRN/BiaV79ffpqXT2dwAxWAkJxXz6pUpphtYdz7L6tj7c6FjdzgxFIMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(136003)(346002)(376002)(451199021)(31686004)(66946007)(4326008)(66556008)(36756003)(186003)(54906003)(6636002)(478600001)(110136005)(2616005)(2906002)(4744005)(66476007)(8676002)(316002)(41300700001)(31696002)(86362001)(6486002)(6666004)(6506007)(53546011)(8936002)(82960400001)(26005)(5660300002)(38100700002)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlY4b0ozSkoyUlMwSWxrTzNnWWRoQmxJdlZBcEgvU2pCWGp5d3dvT0svSW0x?=
 =?utf-8?B?R1NHaWFPMnE0cWkvalpleGtrVjJOdFpQaExuMnZLWHIzaGdYZUxIZDNPTFhK?=
 =?utf-8?B?eVd4RW11UUtQdWdvc2FUTXB4QzYxQWhWYWRyN0pGYWQvejFZYlFZRGYzMVg4?=
 =?utf-8?B?ZkxyNFVOUHNuVGlrT2FPbnl0YlFGQnM1ODJUNGxNRlI5QUZOUFViRUVORjBl?=
 =?utf-8?B?M2ZuSzBPUldabC8ydUdFNTMwUDlkeWdxQ3lNalpVeHRlWklvOFRkWDhDcnlS?=
 =?utf-8?B?L2hJdy9yUEk5eE5Nakkvb0hISnk3UzQ0dkhnWitQdGh4NFExRjQzTFQvZ0dG?=
 =?utf-8?B?TWtXcUZ5ZmR6cEx5NERaaS94Z1h0ejVRZWlJaUVnL3JvTGhkYzVKUzJmeWNI?=
 =?utf-8?B?Q0pSbjdYZG92MlBxVzd6akdnREl1SzZqU0lJNW4xS3psem9rSjB2VXBiV0xL?=
 =?utf-8?B?aXZLaGRJWExuZVNpRWRIY0VRMFJ1b0hQNW5kb0N6bUVSVWo5YWlVMGVmeTVB?=
 =?utf-8?B?Z0VKS1FWZStDTUR5cFhGSndXdmVwcTlBaEpnaVVuMGVLNGNvQUpsLzVOTXJx?=
 =?utf-8?B?MTNVblU0U0t1Z1RjTkxtZkhyWjk3d1A2TjJydzZHUmtnQWFRaGZaWlh2ankw?=
 =?utf-8?B?ajBFcnZ2ZUx3SndmeDFnWnNoRitldFFKbjBqb2dLc0RPMmVQTm40YVBaanV5?=
 =?utf-8?B?UEdrRlFSeUYzTlVFMUxUNHo3RWpFZHIrbWEvSFFLZlhpdHl3V01xZjdxM3Bo?=
 =?utf-8?B?MURNZm5qVEtvUmpIY3oxTGU5VzVuQ1FnZjZGUzc0dEdwRy8xWWZLYkt1Wk9S?=
 =?utf-8?B?ZnV3TGZqZURQelZsd3hmeVVwMG1ReTN6MHRTeTNrQlA4UkZTKzJ1QlhwUmxw?=
 =?utf-8?B?TXYyVEZpSmFsMTRwOW5RdVpiY0poOXI5eWs1Tk1KM2Z2bm94YjcwZnZRRWlC?=
 =?utf-8?B?NUZEUVprdlk2VVozcWUwaVZoQy92NDNTMXJobTR3Y2lEbGxPbkVaQ1N3TGRz?=
 =?utf-8?B?eHpvOGxUUXd1Z3ZoU0ZmL1Vjb0U1R2JlRThpYTc4bEhGRm9RQVZQNnhva3FF?=
 =?utf-8?B?UUdoRzhzWkl0OXRERG1oSGRMOEcxNXluYmtSMjhmUnFBTG10OHJ3VllienZy?=
 =?utf-8?B?cHRoTDE4eUFkdVBYVnBNZVYyK3ZoVHlBdWg2SENxanJXaTlFc0h1NWVFbWVU?=
 =?utf-8?B?OW1jV1ZoU21USUN4dGpUeFJGN1dlTXZqOUd5bjZrazFBMnRwRGNwUXo3OHZW?=
 =?utf-8?B?TlIrUjlGZXVGVFdmL2l1cDZyaHNTNkVrQ2dSTEN1OVFKTW5MZ3p2YjcyVEpr?=
 =?utf-8?B?MWcyeEs2M1Y2Wmk4UmE4UHplYWt5djFZNVdlN1dLb3VqY2xrV2hDdUJKVi9U?=
 =?utf-8?B?Skd5S1JNTFp3Z2F6a1crb1pvUEZ3VU9HejBkYmJmaDVZYWYzMnNGK2Z6SkJY?=
 =?utf-8?B?R0dPVkhNblhtVEU2emxuU2x4TWdZSW1LbDBSdXFSVk1ManAwM1pHMnFDY0xu?=
 =?utf-8?B?QWlUckxsb1YzVCt1UytwZ0tTSGF5YXJyNlBwbldRdTh5c0NXVUFwa0JFays1?=
 =?utf-8?B?ei8vejQ3Y1VNSnBqVDAydXlmb2gxcThKNHhhYnhyWUw3NzRhOHZhdmFjck1a?=
 =?utf-8?B?aTBmb2dkVkVGMjIyOUFrWHBSUlFZYlorQXNZa3NTMWk1ZTNmeW9PMDlCNFRp?=
 =?utf-8?B?VzgrZGFNYm9oV0NFSUhOZVVLNGRjMzA1bHJVVktoTUxMeENQaE5sR2k0VkM1?=
 =?utf-8?B?VE96by9QdlN2WEVrOXlsOEwxQnRLMGplcVpHbllKbm5YSUdyVGtJMFBMaml1?=
 =?utf-8?B?b0h4NEdCazBPY1pVN3VGbURtNTJjWXRxK2hYUmF6MzgvR0lvVEhmYzRDZG5p?=
 =?utf-8?B?S1VhVkJQVUZveXRxRk1yRDR4Q3pTRCtLUi9mQkMxNnp3Ym44a0QvK3dKdTJU?=
 =?utf-8?B?bTZ6T3FvUmEyTTVSeFd1Ym0xa1ljMFFIRG5WZ1Q1bjkvZk9iRFh3WmR5UVEy?=
 =?utf-8?B?VmVZUkVLS1VSeUViNk9CdHBNY2FzZ0VKTjc4c3FLT3JYcnpNMEdDN3VxSDNw?=
 =?utf-8?B?R0ZLQkpVcFdQOUxMNzhlS1p1OGFpT1pjT3RPM05LMGQ5WEJudlhhQjhCSFBO?=
 =?utf-8?B?anEyQ01TZ3FLbklhaHpvZ2pxYjNpUDZjZm5Xdi9uMktHaHR2bUhha2NLS1or?=
 =?utf-8?B?Qnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 185e6bb7-7948-4f9b-7ec5-08db6c2a81ca
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 16:23:22.7147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iRNqnPCu2gfurViuQOxaRqOvtHCE76dOTxl5TDnmg66aNyCgttDIM9GJGHSv9kdmzM6DI4Yg60h7qzjkzB2ey4aBgxARsmGRXmOS9tTLh8E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4698
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/13/2023 4:47 AM, Alexander Lobakin wrote:
> From: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Date: Mon, 12 Jun 2023 16:10:06 -0700
> 
>> This patch series introduces the Intel(R) Infrastructure Data Path Function
>> (IDPF) driver. It is used for both physical and virtual functions. Except
> 
> No netdev maintainers and generic MLs, not speaking that the previous
> versions already were there? What?

This was something I told Pavan he could do as this likely will be 
turned around as the v2 PR. I was trying to save some extra thrash of, 
nearly identical, iwl-next v7 and net-next v2 being sent in a short 
timespan.

Thanks,
Tony

