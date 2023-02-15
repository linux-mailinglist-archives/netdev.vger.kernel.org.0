Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0254B6981AA
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 18:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjBORLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 12:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjBORLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 12:11:16 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BB225E2E;
        Wed, 15 Feb 2023 09:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676481075; x=1708017075;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X6vHriIGC1uK4tyUHAWWLnnvZnN12rrgIeXSdtAMiXo=;
  b=JoW3FkGEXuJUwDvsov6R7GHslrP1x1PXvJxCXd3u6f9gnNSCr94SmooH
   O7V0y5BYROszPJAx/iBHurfc7NWmxQYebC/jjW9s+f1TDaOvls/pyB9jV
   X0bCGsetpvNIj7bapNR8IVmvecZyK810nnqqceeMr2jjPAspo3l780q+R
   J1/KreRvI1nX71R6PE5sN9SdQ4DZpr6ijunHioSyzmfKkCSBqdTg/ggOY
   V8KkW5EaYlFct0QstkcSXV6Klw6PFSeCiCYmsab0hYm1EHxOLPZx+ensg
   +3Jezi44nqTJwkIDhaB25QKxrGs3TKQa8tX4oWxeeidgpOSOqdaeS12pt
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="417702573"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="417702573"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 09:08:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="812543959"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="812543959"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 15 Feb 2023 09:08:25 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 09:08:24 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 09:08:24 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 09:08:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dGb+Exny9A4J1HqOx9kkVLtQQziZIwhOLLNEdwjDYJQzhkws6C2JJCJZ3mj3iD9w+xPwe9102qKVsxb7qRqvKsXnzdzP6sigwhB6R89ugMITCO3qPm35BjssZsv4mWiZfxkjtgBjbRnSF3pRQ4DMAMMmOyY8RwAERaF/GUh9vyZnEQ9YdvCx897TibEyeiqsIPk/vMXo5a0dOoVINCxr7Y0ImLKhA51aLYjXNP5yscMXzCKiSxfXcIEXH/hLvyKlQ7rpALMghSL/rlf46FBXXjV2VxZEQLaofQ5on19XnEq/NUw0Z/6LBARisXxgwEJd7Dvyn2yL9pRgkBJF5XXQ1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MsH8DjvR+3UKUSA1jIHQvJLvDSpDNKHTKciXw7qPEPE=;
 b=cDopIeE+07CLNm2m+4Ad71s2x3Xwb6F6r5vF5F93ikcARnXmCMRe/w0D5C/GuqxW+D0gOXsxg6FYc7JD7SmE0OTccXUP0reUxv42EW11JCieyIYgDt3U6GpmRCpjYgslRtaB60PvJ5KR8gp9KQo+o1d6+pLlcMsI+UM8QiRINUnRzUS7/8+5Qd4ecCZvRGOeUJM0w9IPowWr6sXl7p2ZJv8nZh0fy+lwYQMri7BzE9rcUwmur0794pr+YVe0Umk2B1bSR82vPrHNRkLS3gXz1azqoRp8UrBNnqWDKpSmB/0269Qu850Y8dgTi+qZg0WKb9+Yos8QBZge4iYLKM4ybw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DS0PR11MB6325.namprd11.prod.outlook.com (2603:10b6:8:cf::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 17:08:22 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 17:08:22 +0000
Message-ID: <cf18fcc9-d56d-bfe0-d993-128ef27c60e5@intel.com>
Date:   Wed, 15 Feb 2023 18:07:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v7 net-next 2/8] sfc: add devlink info support for ef100
Content-Language: en-US
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
References: <20230213183428.10734-1-alejandro.lucero-palau@amd.com>
 <20230213183428.10734-3-alejandro.lucero-palau@amd.com>
 <Y+s6vrDLkpLRwtx3@unreal> <ef18677a-74d0-87a7-5659-637e63714b15@gmail.com>
 <cac3fa89-50a3-6de0-796c-a215400f3710@intel.com>
 <DM6PR12MB4202CDD780F886E718159A8CC1A39@DM6PR12MB4202.namprd12.prod.outlook.com>
 <Y+zOeGYK0EctinF1@unreal>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <Y+zOeGYK0EctinF1@unreal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0140.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::12) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DS0PR11MB6325:EE_
X-MS-Office365-Filtering-Correlation-Id: bcc51f63-aed3-4db8-b849-08db0f773e06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X6vpe/CiClywPjKFTpBRpdYWfpyLXOAocX0XsxokQVzRwo5Vk+gPW6veGltu8favGbjiOpDJ7J+rtWR6ZyMdT0/qZ2pOTLK57/CJ8ONoQs+qihD9T1JnlyCodVredF5+gZHOdEdO791DbSSrChD69kt/yvXQZYym206BqhfKU9oXWjqGQQOikIUlDtfMboPXHtSc+6NYU8IgjkANeEOXUrIWq5+Bt7eQl00MKYUcnWETE4luEp5w7mk+V09rxbAKasTkDJ0S4HYnK+m4G318ltumxOciOruCpDbCaosOka8OFQVOCoV8bOt/gsBmxdt9OqMXqeZTHQQPEx6ABqf1fYbPkMRM0rXsa51Q9ZarK2mwp1JD44w2ysDnl1lpkPy+AvuP4ay0R2zxR0YMgzp7IX3THALAGVk3QVKY675G0sGCDJaj7cJi2ODVb/apTgebdQbzCI+FOR2nfp2cE7qD+OtmrXiE2wZyABx8HUsE3MhjWLykG/f9V5v9Tz5gckT0zM0oMo8EtlVD9/aCg+xrLVibWPpNpiYPwbjAtyzzcFBJCKyolhW4UJOu7t4xVTJRRJVX/TvESUDdBM/zvZARyN+bZ2ME8yQ67QRJ7MRRcuBYOd+DmiF3f/XXo7A8KIRnHU3DjZcB35Ziz3ZRxb6IM5V1mtu1QXkTEoZ5Aj3itZvDmW0toX7Y0SlR+KKXWcoM14OyiNlvmp8Q5Ox2XASCYVciaAkkHwZ7MWv9Z/+vb5s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199018)(82960400001)(31696002)(2906002)(38100700002)(31686004)(86362001)(53546011)(6486002)(6512007)(6506007)(186003)(26005)(36756003)(54906003)(66556008)(83380400001)(41300700001)(316002)(66946007)(478600001)(6666004)(2616005)(6916009)(8676002)(4326008)(8936002)(66476007)(7416002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXBPYzI0U3J3YUlTVW8rMWc4bnpKS3FIZ3FWc3hwSnF6ZTA3WHFiU01kK3Bj?=
 =?utf-8?B?Zkt2UTFOM3ZTQytiU2xBeHJNeDNPNjd4TVZwWU9QbGRpNW1kQkV2MVQxNHp3?=
 =?utf-8?B?Rk5LMlZmZVFjbHlyK0NJN2VUYjZZMmpKVElKcnpybkJTWWk0dHdxK1AreG4x?=
 =?utf-8?B?N3N5QWxwUEx3QTZuNXBXYU1iMzZFVXludU9Ya1VKRnFkUU15NDMvQkFmMXBM?=
 =?utf-8?B?bTM5SmNLNjh3U2dER2JXMVlVS2xvcTNudlhBdEthN3FJdDA2amdRbkpxTHIv?=
 =?utf-8?B?TVBiYWwrNGJJSk9yVURWZ0p3TnFoYkpYT3ZYcVVjUHNpZWJFd3pFamExRGVv?=
 =?utf-8?B?U216ajdTd1NkbWpxamcwcHpCTFl0WW5GU3JMNE5xcWJPd0pPSTE3cXlGV2FL?=
 =?utf-8?B?aGRhSWh6NFpNRU16blRwbWhMVjEraTlKcTRqOUsySmQ4Ky9kMHVUVWRyNi9w?=
 =?utf-8?B?a3hCUDZhazRkQTZkeCtQWjhIbFN0VzEyZHZweXNWejhKeUpGbzQ1Q24va2Jt?=
 =?utf-8?B?TFpJak5yZUFjVmZmcnVuekNmTmZFT3BPWVdKenYxczl6RTNzdTBuRk5UNzVk?=
 =?utf-8?B?S3IxVlpuaXJyb0RoZlZxMlJkQi9lZkZIZ1ZJTWlIb09MY2UxRktQNFBkMGY1?=
 =?utf-8?B?WkFmWWlhUlJpOTd0WUhWT0c3UEFHOXBpamhvcTAvUGU0dDdIZ0hpaXRIQWJV?=
 =?utf-8?B?WmZUMzQ2YkxqTmZDcklDdzhianpVTy9IZzQrY1hheURXQ3hyQS9oYUhLd0JX?=
 =?utf-8?B?di84U0ZvTXBsK2NCSEZmTTUvdmZVSnRTejZrVExKME5QS2VhTkY4aHR1NVFW?=
 =?utf-8?B?dGhxNkQrWTlDeWtZTzRzS21mUTA0aENNQzVKVWs4SjZPNXl1YzhVOVB5LzFv?=
 =?utf-8?B?cjZrRlZrM09CaHpmK2NGY1BOdXBEUzZGMEVrdlY0RjA4akJVQlFQOFlGOUd6?=
 =?utf-8?B?OVRXNUdUTXRnK1F1VzVOM0JvTEduYjhNM2tDVDB1UkQwUzlZcEhVYUV0NlZ5?=
 =?utf-8?B?d2Nibzgvd1kvOWhpcW80a29DKzVYc0Z3SEJiamNxWkY3dVRQMkh5NDZHa2tU?=
 =?utf-8?B?bzBWMHh1YWhTanNCUE1yMWJ5Y3V3RkZYK0V2d0cvS1g5dVlCZlBVV2hxcVB2?=
 =?utf-8?B?UldyOVlpcWwvZGZKVWlQYVYvL1ZVUDltaGxERnRXcTRsNU9jYU5yN0Y5MWFk?=
 =?utf-8?B?YVBTcFJ4NVRzd3pPaVZDRXNZR1ZSMUVONXVobnk3QmI0ZVkyZkJvdTVkZ3R3?=
 =?utf-8?B?SGpad0Jqclo3ZkpMaDZXdEp4ZzUzOVJab1dVN2JCaGZOZ25BQkxFZ29hajlq?=
 =?utf-8?B?emhWeFBzS1VSUkdWZUxmaEoyTmdTbTJYRHFTbUhZdTkvb0ZNTnlLakRVVmt3?=
 =?utf-8?B?cENtYmFJYWI2N2dyS0VpZktCREZBeTlVT0llWjczZFlsRG02RVNrVkp1MCtQ?=
 =?utf-8?B?ajlybnlVMzRKd1M2dGl5cHVpUkh6dTM5Y2RYVUxLc08ybS9KNWwzVmRBbStw?=
 =?utf-8?B?N3IvZmdJWWNsZFVhdFhwaTVyL0JnbkM5UWJva1dKaEt0WXZGd0NFRTJKdXI3?=
 =?utf-8?B?U1M2WDgwWE1QbjZ0OUNuaVJGNHk1cm1iNWRCQU5CYUQ4WEtOR2VaVi9FM2sx?=
 =?utf-8?B?UGdodFdXemFFNHNUbEVaelpZVy8yNlJkV3B2R0llaGQ3cW4wYkQxK3BRRlRU?=
 =?utf-8?B?UkJJK3pSaDdoMXh1emJ5cXhyYW45Nyt4YTdOcDJIUUhKTTJsWmtKM1RQcWdv?=
 =?utf-8?B?Y0cwZGZydkhIUGh1WVlsVkpiUm1ua1RacmpiSTNBb09PcUpaUytqZEhyS0RY?=
 =?utf-8?B?aXUvQit4eTRVYU1OV0IrUGhOY29UcUJHSTdQWlJVaXNMK0tucjlTVWdkMWtj?=
 =?utf-8?B?VDZPS0k2dVNxeGN0dTlvYnRIaFZNc1ZlZUIwQStmT2lvSmFPRXlyVTJtSzRx?=
 =?utf-8?B?ZGVzU29KTFVvbk5LMHMxZ01CZVJGc2t2MlVKMUZMNlZQWHA5NXRHdlRmaVpI?=
 =?utf-8?B?YTA1WlZhSUZLOC8rL2xsb0ZKY1hOSVNzOGlLRlE3U1N2S0wyWnhiZDhacHVD?=
 =?utf-8?B?cjZLbXBMNXZWMlh2ckJiRnJzSjh2VDlEdEpJNno0ajRubGtBaTFSZTlmdlhE?=
 =?utf-8?B?VVhJaVp1L0Jwa2lkclRIM1YxNXNORk43SDZac2hxeVZRdTIwRlFwOVFlaU40?=
 =?utf-8?Q?VPciwa0Vm71TR8IiSJv4Ozk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bcc51f63-aed3-4db8-b849-08db0f773e06
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 17:08:22.2022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BQvpeeAkm7ufzvcBdUdVKz6VDfluKHtbxivEuwA2owGqwje8/WUnmwEByyWyraGdqfIS2UVqYKHcaycoghzdbzYTbQibEh3tx6bNLEgYRcY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6325
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Wed, 15 Feb 2023 14:22:16 +0200

> On Wed, Feb 15, 2023 at 08:43:21AM +0000, Lucero Palau, Alejandro wrote:
>>
>> On 2/14/23 16:56, Alexander Lobakin wrote:
>>> From: Edward Cree <ecree.xilinx@gmail.com>
>>> Date: Tue, 14 Feb 2023 15:28:24 +0000
>>>
>>>> On 14/02/2023 07:39, Leon Romanovsky wrote:
>>>>> On Mon, Feb 13, 2023 at 06:34:22PM +0000, alejandro.lucero-palau@amd.com wrote:
>>>>>> +#ifdef CONFIG_RTC_LIB
>>>>>> +	u64 tstamp;
>>>>>> +#endif
>>>>> If you are going to resubmit the series.
>>>>>
>>>>> Documentation/process/coding-style.rst
>>>>>    1140 21) Conditional Compilation
>>>>>    1141 ---------------------------
>>>>> ....
>>>>>    1156 If you have a function or variable which may potentially go unused in a
>>>>>    1157 particular configuration, and the compiler would warn about its definition
>>>>>    1158 going unused, mark the definition as __maybe_unused rather than wrapping it in
>>>>>    1159 a preprocessor conditional.  (However, if a function or variable *always* goes
>>>>>    1160 unused, delete it.)
>>>>>
>>>>> Thanks
>>>> FWIW, the existing code in sfc all uses the preprocessor
>>>>   conditional approach; maybe it's better to be consistent
>>>>   within the driver?
>>>>
>>> When it comes to "consistency vs start doing it right" thing, I always
>>> go for the latter. This "we'll fix it all one day" moment often tends to
>>> never happen and it's applicable to any vendor or subsys. Stop doing
>>> things the discouraged way often is a good (and sometimes the only) start.
>>
>>
>> It is not clear to me what you prefer, if fixing this now or leaving it 
>> and fixing it later.
> 
> He asked to fix.

Correct. What I meant is that I always prefer to send stuff already done
right and not continue adding more todo-stuff to the kernel just because
there are tons of similar todo-stuff in the kernel already :D

> 
> Thanks
> 
>>
>> The first sentence in your comment suggest the latter to me. The rest of 
>> the comment suggests the fix it now.
>>
>> Anyway, patchwork says changes requested, so I'll send v8.
>>
>> Thanks
>>
>>> Thanks,
>>> Olek

Thanks,
Olek
