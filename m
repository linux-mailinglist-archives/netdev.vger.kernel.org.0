Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3061E6F1C9C
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 18:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346192AbjD1QbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 12:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjD1QbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 12:31:22 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E932D61
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 09:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682699480; x=1714235480;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gHXabmaDCBb3lEWSHAZsZ9fORiHyRfRsz2FAZ80OCqY=;
  b=ItN7yR9CGjrDqCzIzXEXOA0p90QFdiUrMLFRzHZtyyE2s6ygjVbeFbFB
   EmAtZRpuxamK4Tua3uSrYYJspxv76TR4c5Gxn2G4fjHmpOvWozplrHX0Y
   N2DCfWNZ0p9+SKCylPZwnGy1JMEgpFFQWRr5KjZ0Lw74ARKg4QmMJ8ygx
   +2DsO80IPu98sJo6DsRzb9B26OwG9lDKshzspI853uk5xhUPK56NITjsd
   nSkUw5t+Ucb2abe0uuJPHeGl3DgP4EQH0vr/FLFnN25nykSsAv8O7pQEi
   VZRTnG9NwE6ih4kCV3THRjhD/PVxHNH32nsLHSygo9h21PHv5OiS/MONN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="336865757"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="336865757"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 09:31:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="838897440"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="838897440"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 28 Apr 2023 09:31:16 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 09:31:15 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 09:31:15 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 28 Apr 2023 09:31:15 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 28 Apr 2023 09:31:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ed+U6YBAzDu1LXaUatvbdVUklgwPYggOiGA2Dr8OCwhTLQDH3Rme3VfEfFemNYS6Ulo08LVafowN+TQajLpj9u02/t7SaTxsMFLAEE5iZjVYKzO3IwZnHa5+zNpmTzftYjUSSbjkAzrZx22CCMcOBqWB4ezVstfkWImhq1cC/HfOBvVKldVDGwHzX/5UCi61b7eX8V3PYLrVpUtHexQkx3s7Z+OyEl5gTCrYZYmcZADPNpn7WWtvvSDVEKL2I4WqrBcBiR2FHFhQfUfP5td5VTKmRXAkTSXYokCTrw4xbfaUPhlklSPBb7DT3DpZIlnyr8a9ibU1C9RxSjJXeebITg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0S2UYsU7DFIWlYJJnEuwH/BgtkDVLHZ0F69B9bvd5Ug=;
 b=NFz7OTVJW7SpZJKqYQ/5oOw/jq3GMLrDBdWJTGkNPn9KxroPGdwdShXts9TYtASEGKn1GovmpsmPDrspbyDx5fsXm9PwR6L7oJDuRGu+TllTXyBtV7Sr2Smf3FM3UBmBkyVOTYq0QvRWmsJN+Ppri6Wfy8tpbDHa7j2+OXLya3PdaGRmX6bsJkjSnbAEYZZOR3vjoOPaBevK+2u+33pmZnDWcT8noDiUBegYAQMVun4Nl6I25/42Vz1x8fjWYABHfdZSs9OzFvfjVWEf4JH/iJVTtFlBqIRVuENbcail2i42zblC/t9Qd//196D1KJOO8D3W7N698lUyIWgowr+2eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by DS0PR11MB8020.namprd11.prod.outlook.com (2603:10b6:8:114::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 16:31:13 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4b81:e2b0:d5fa:ad47]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4b81:e2b0:d5fa:ad47%6]) with mapi id 15.20.6319.034; Fri, 28 Apr 2023
 16:31:13 +0000
Message-ID: <024700ef-f0a8-aa1e-c950-213767cd80cd@intel.com>
Date:   Fri, 28 Apr 2023 09:31:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net 1/1] i40e: fix PTP pins verification
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <netdev@vger.kernel.org>,
        Andrii Staikov <andrii.staikov@intel.com>,
        "Sunitha Mekala" <sunithax.d.mekala@intel.com>
References: <20230425170406.2522523-1-anthony.l.nguyen@intel.com>
 <20230426071812.GK27649@unreal> <ZEksrgKGRAS0zbgO@hoboy.vegasvil.org>
 <f525d5b887888f6c00633d4187836da0fb31f2cf.camel@redhat.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <f525d5b887888f6c00633d4187836da0fb31f2cf.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0055.namprd17.prod.outlook.com
 (2603:10b6:a03:167::32) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|DS0PR11MB8020:EE_
X-MS-Office365-Filtering-Correlation-Id: bf8e1604-6f63-457e-3960-08db4805fb41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wnmjWu/Mt6xkjfhcQQOqarX50piEbYgj2E24rKeGP2rMh9YDNmCjkIxEFI1HV2AkyPGyd4knECMShabM+bfQ2iIDiIjBzDxwP2UHakdslWK6cMojc1bdjXs3Y6A+gYmEjSXN1Q9a2zXiz86rjIks4/c4b4VarQGg/h73Bdho4bCyDsaA1uOwxSxnUurAaYcJSOBrZKit4vVegKwUED7UZKCo3Ef3Oo62U14hBMnn+YbtxMIBNAdCc4OarswiV/rq1gOqXgFM2fXYgfSbvqU+loSmZsjcNFEPfQNu86kONEIXvG9w8ghSDL6hvT1Xy5AgYRzu4GevjeoeQvcekixHPjsoFtftYAwCMta/HyRUeGx+O74KlW+3IcGVgaBuvcAVZq+y4HeVkMKdzyG2rQ0TBTYHmEPGCAWvQIixhQH4UnAcfgPJyZu3tjWOK1C6w+eMH9aqkZ9MOAEgEw5sM1XExwaert/G/d0eCk7XUdWoufTz0RNIQ0fbayRnonFzyKHEs+aOVy7coSMdwlTz/TKF2Di79aOgC8T54KLraIDO6EaFYBzOvrXyKGHSVBJKnOBnR9+g2e83x8lKrgS9l08bKRxw8q1gdGcTo0LSfs+AwxKIjcB/xPgveCHMwC+EVsacAyPpM+EgyfUTDmJWoHFOxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(396003)(346002)(39860400002)(376002)(451199021)(2616005)(83380400001)(186003)(54906003)(6486002)(6506007)(478600001)(26005)(53546011)(6512007)(31696002)(107886003)(36756003)(86362001)(110136005)(82960400001)(41300700001)(316002)(8936002)(8676002)(31686004)(5660300002)(66556008)(66946007)(4326008)(66476007)(2906002)(15650500001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzZ4a21CczM5Q1h6UXl1cHNML01xbVBoUGNjL2NTN00vYzRsMkN1RzhwU3pq?=
 =?utf-8?B?N0N5cW1ueHYxVnJwY1pVRFJwZldheW9NVGpJSXRDMzh5eWlHMnhNbTArRUVE?=
 =?utf-8?B?NTAvUEFtS3RUQ2lGL0NKOUpyVEJDNHo1bmdFaEFWSnNJdk5ndUJxZlRKQ0Fl?=
 =?utf-8?B?NVJFaVJIY1RPR29laU5JUTVNTDdJUXpJN3VVdUdtM3JoMVVxRXl3QXdsR0o1?=
 =?utf-8?B?M1l5emNkYmNMQytuei9TN2JIdU13dzRXN21pUHlkZkZsQnhiL0gxaHBQTTFh?=
 =?utf-8?B?QlZneHRxSEJjVksvYXNIWUlwaFFoMEwzbFY3Y3lYK1MrNDBFVCtRSG1PNDkx?=
 =?utf-8?B?UXJRUmdVZSt5MVFlODBwVWx4U3BBQTFsVnpxYWFkM0trUFZ4WWx5dzNHTU85?=
 =?utf-8?B?WmZDT0UzWDQyMkN5TXZWekNsQy9UUUNjMHUrcHhIb3UwTFR5Sk1UNEc2dWln?=
 =?utf-8?B?SXZheVVzRXFRSml3UnEwcmFXVUR0QzZGVXdHaUdNR3VNVHE5ZUF0SUFodGF1?=
 =?utf-8?B?djB3S205STBSbDhHNDVaQXZXZ05zOUJWQXowT25ZQUUwanlhaE42NjlaMzU5?=
 =?utf-8?B?NDhJbktrS2F4N2lRRG5TNHoxYytUN0dOQ0t6MExCcmdZWjlPNEp1RmN6Nkg5?=
 =?utf-8?B?S1ZXeXN6bFIwOWNKK25XUDd1ajB1U1l4M3E1YXFxVGFjcGdxam0wc1RaMUl2?=
 =?utf-8?B?YngwTE1Xd1IxM0oxWUhPRFczbkMxTk9nZmg0WVdMWStHeDBMckF5bWJ1Ulpy?=
 =?utf-8?B?dkRjY3pXOURGVnRrYVEyT0E0WExzQXJqM2paWVA2eTlHZSs0Z1JUbFMzVUJt?=
 =?utf-8?B?cHNHTEIvdWgrMHZxOXdqKy9XSWVXVWdmUFFMWW5jUk1VemNaYmlmeVlvU012?=
 =?utf-8?B?V3RrUFVDampraE81S2RKT3hsSEl1S3Jtb3QwTWJDa0w1bVdKdWRhOVpuNHVz?=
 =?utf-8?B?MnZYVnlYYWJ1K0loRSt6SFJ2N3h3dlQ0RzJSR3c2OGNsUE5pOUxzR2xqcWpJ?=
 =?utf-8?B?d3VJUGQ2TmlrLzJBSDNlOXo2SGFRSVZicmdENm85RVo1eGNtTGZEVmdDQWU3?=
 =?utf-8?B?Qzd2RjJyNmxLMmRqVjFrQlhSTUpONG5COVhIVmdVMzdURWp4djBvTDBwWnFD?=
 =?utf-8?B?MFhCa1FoVHdGRHI3ZU05TWNSY0puUjdRYThNM0F6SHNsQXBJekhXZjNuMnR6?=
 =?utf-8?B?akZQYTJzcW9rUGtPb1h4aGlqQXlCVG5xSHNDb0lGRklFajkrY0pPdkt4c0NJ?=
 =?utf-8?B?dkxvQ3had1UyOTN2dmpmaGxTZXJsVlhIeUZ1QWRIb1M1YzZPaEs0eGRDU2d1?=
 =?utf-8?B?QjJXZXpXTnNCa1Y1ZlpJaW5iN2hIRzhwQ01Xc3BsTkNzVExrZEx4TWVNWmVI?=
 =?utf-8?B?RlZLKzIwcFFoRXNoL0tpMHJFamZTQmdhZmFLbkFCWmg3Y0o4MTRaVEsxSDN0?=
 =?utf-8?B?b2tndVpqRjFlRTJ5UFpPU2FtMXd0N3NWU3RKSnhhc00yNytRd3JPbk50UzFn?=
 =?utf-8?B?Wm5sUU9pVjF2cm1ZY3gveTJqM1U3SExKQzB1LzdUNm1YUndITE50cllmQmFi?=
 =?utf-8?B?N0lURjlRSDNPcHpuRk5TMit0cUIxejNuWFpqRWljMXNYSmRpQmROaFNZbnd4?=
 =?utf-8?B?cGtxYytMODdBcWMvc0VNb09hTFd6VUI3a3I5SGVyYmpEZ2FuTWIvWlZydU9L?=
 =?utf-8?B?aW1jMDBvMVdRM1AzcUFMZmhJNEJDSEJ6bGRHbWhoaVFSSC9aMFJaUytBdFVj?=
 =?utf-8?B?TjFZZWVtZmxkL29mdWJqQkp1ZnlNcUhyZHp1SDBqdGFDNzhBc1hXOUwvSzVx?=
 =?utf-8?B?dDJSUGRUZUJUZGl4YlJRUzV4R2djMHhYSEpwbjRJeW50KzVEZ1Vob20vWVMw?=
 =?utf-8?B?Wngwdzk3NGp3TWFGT0pnV2M1ODNDT2RPcTJzanlyZDVsTC92MjRjZGhiWm5E?=
 =?utf-8?B?U29Mck9xWkNFeXBBQmorNG1JZzY2UXpFOU83elFwelpMdUdEOERwdkdVdUdS?=
 =?utf-8?B?NE9BUW53RE1ONUt6TTN6NUpmOUlzcWU2WFREYW9SQzFpaXdYQmtuREVFSG84?=
 =?utf-8?B?ZXBnUGRQNEpRcDd3dkk0OHhDdjhYZW11amYwaDFwQVJXRXQydTBBZnY3UnJy?=
 =?utf-8?B?eGpqQlcyZUJEVkl3dEFxbXVadEgrVzcrcHZhMWVvb2xmYUxUSUxaUHpuZ3R0?=
 =?utf-8?B?c0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf8e1604-6f63-457e-3960-08db4805fb41
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 16:31:13.2937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X79qqPEEdaQEwYynBx+IYPvi2fQEpccug0wMuvIgPRI1FjZIjWpUglM4D43+5DqnwjXK2mZFThGVtPzLkZgC1PiSMynlAdgN0Rvf3weh8LQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8020
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/27/2023 3:24 AM, Paolo Abeni wrote:
> On Wed, 2023-04-26 at 06:52 -0700, Richard Cochran wrote:
>> On Wed, Apr 26, 2023 at 10:18:12AM +0300, Leon Romanovsky wrote:
>>> On Tue, Apr 25, 2023 at 10:04:06AM -0700, Tony Nguyen wrote:
>>>> From: Andrii Staikov <andrii.staikov@intel.com>
>>>>
>>>> Fix PTP pins verification not to contain tainted arguments. As a new PTP
>>>> pins configuration is provided by a user, it may contain tainted
>>>> arguments that are out of bounds for the list of possible values that can
>>>> lead to a potential security threat. Change pin's state name from 'invalid'
>>>> to 'empty' for more clarification.
>>>
>>> And why isn't this handled in upper layer which responsible to get
>>> user input?
>>
>> It is.
>>
>> long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>> {
>> 	...
>>
>> 	switch (cmd) {
>>
>> 	case PTP_PIN_SETFUNC:
>> 	case PTP_PIN_SETFUNC2:
>> 		if (copy_from_user(&pd, (void __user *)arg, sizeof(pd))) {
>> 			err = -EFAULT;
>> 			break;
>> 		}
>> 		...
>>
>> 		pin_index = pd.index;
>> 		if (pin_index >= ops->n_pins) {
>> 			err = -EINVAL;
>> 			break;
>> 		}
>>
>> 		...
>> 	}
>> 	...
>> }
> 
> Given the above, I don't see why/how this patch is necessary? @Tony,
> @Andrii: could you please give a better/longer description of the issue
> addressed here?

I'm not sure about the issue details; Andrii please chime in.

Thanks,
Tony
