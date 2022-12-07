Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8E9646321
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 22:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiLGVQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 16:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiLGVQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 16:16:23 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE73F1CFF2;
        Wed,  7 Dec 2022 13:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670447782; x=1701983782;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kXoPStWMiWt8PmPIV84heqMEa+WrvQA9BAA2NE73TLY=;
  b=dyYQhK5EPzH1Q5fNFpiXgOmR4aV9cMFufyWLCObRJ6C1KJh7r8J+/ywb
   T6h05gnelu7j8YkW8BmtIebJfiLjrFHDhMLa0GSVQmKzQlsS7VewbAT5j
   fHHdYnhkNa0KJI4vNkietujEzSlzrw4ULDRfl2G1UZX0ICvjjUcCxp7Wh
   CBQbJUqnL1n6Y0SC1IDvhogDyGemYESa7yxw24z907zop9TK4Co6HzXeN
   RmxbDO7Wm/pFVcZ6Qhoc2/UoCIi8t53kNtpYog9Uf0DlaDnDqqPjhOzEO
   VHVJIWCtIwKeU/2YFrdBc0X5PPFgYoow8wS2UKLzRylYkSvFgZzHPiYTf
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="314653568"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="314653568"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 13:16:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="648884602"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="648884602"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 07 Dec 2022 13:16:21 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 13:16:21 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 7 Dec 2022 13:16:21 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 7 Dec 2022 13:16:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BDd5Klq9lsYYEKmgKFrvqSXQQM+jkejiPjzzaOBvFCK2mnD8HzISN0bq8i5Bzr4yrutspBr3sOMHZ9jVUOBhOn0nOgx3yyVvdLyPsjFOe9C302KwiKdN5a/vdOLNe6F9XXe1myihVJq8B2JPOdRkdh59LmRdKylLG1UnX164U0TFEWmLVFAdxG45ZzDKp+X+0H1n6i8GKCNgdESkWiBIYAL/T6jkUCNtOFmRolM5sqbr4+AJa4iB2IcsxrEvtxfOz5+j9v7euWPv2P3GpMWD28DeCm7NqdrFWjhEs54oR8KYDjjiSL7zppEp+gsVLx8Hou+3INaNGaBpDB4l32cGWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NS8I88rVvMO0/7CfnPttHP0dE7GoIVpwgcONXH5FMxU=;
 b=AOaYl0kxSmREGtxcCNmj37SBXoDXqw0WUW5MeLaODJT1dTIQMyX6xl4WcnvdNkSr5Y86v+C8lNz7N2nwARX5ymSzvb2cs733lHiWx4epVPPWDavNxSkYJNWzfUxHEhrTn58PM140VAfAc609ubhoR6MqgdtoTxGWKD8HgVLUsYhwMPm6cIrwz+IsjnEH5pvmp33tdleopdxzTI1uW09WQycugaibtvON8kYWPpqZ58Oy+DWHd4GOKKW+uB2LVKrzvps0s0L+YU+zSyb1XHlhEo0mQRMYrciTRLM0hSsqeZxedKhDJi0FUxVEDCdmUHWxx2FdtKhe98BgUMcEqhqnow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by PH7PR11MB7004.namprd11.prod.outlook.com (2603:10b6:510:20b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 21:16:18 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5%5]) with mapi id 15.20.5857.023; Wed, 7 Dec 2022
 21:16:18 +0000
Message-ID: <812891ba-d0e9-ce6b-d9e7-b9b27dcf55b5@intel.com>
Date:   Wed, 7 Dec 2022 13:16:14 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net v2 1/1] i40e: Fix the inability to attach XDP program
 on downed interface
To:     Saeed Mahameed <saeed@kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>,
        Bartosz Staszewski <bartoszx.staszewski@intel.com>,
        <netdev@vger.kernel.org>, <bjorn@kernel.org>,
        <maciej.fijalkowski@intel.com>, <magnus.karlsson@intel.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <bpf@vger.kernel.org>,
        "Mateusz Palczewski" <mateusz.palczewski@intel.com>,
        Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
References: <20221207180842.1096243-1-anthony.l.nguyen@intel.com>
 <Y5DaqDKuC4y4icGe@x130>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <Y5DaqDKuC4y4icGe@x130>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:a03:40::42) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|PH7PR11MB7004:EE_
X-MS-Office365-Filtering-Correlation-Id: 9541ae63-fa9d-4d03-bcfe-08dad89847f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pzs8lNL4G6Ad/t+tnfkPGdopQga0gu9gP//nO7WO8PwkSOnFt8nl2cFHsIIeeWnpkTDlUwPFMawsk47yW8gTTjVm3H1TDnoqriDt/UUUUp3TGPjyiwPQrSWAxmpUF0bcOgET30wd6y2T1atKZaSDOi20hpZQG2dsMnDwzZigoM5dOAu5oCwWp7OH4OLnIIiubn7/mfohpACNhkXpNqMKIMmBE72Y6kbwHwy709umelDkCaP7wsQgLZ0wEi0CjkIVlG7bm0GNpN7O9I9ij0J7x0sbFmKDPfqY9z5OJlYITIbYw0x0bSCJsbYJ4imJbnyoV1OmY76Qrw34ChD2FPsxF+wyz6B3+tpxkUm6jKBNZX1rfZNrhB/n6yPi/WsDFEhZFg8CzR75x7HRRP5Jb0RSymvuGbQR9ktU3apGvefu8C8O5VXituz+I2iMYHbaFb5CgsG8HDJTwVntlYD5vXp5KTGNDEVjWoD0Sk6oDWdigQ+x7HZUnipsMXW2yMfrupaylVJFB6PfG9sfymomveyXL4Q7hDMzm7kwzcKnCngAuW19IzWhUbtDT4JEyYKeTjnKHp9Un1CHep3UOfHtoTa1O9cG3146NJMAlpCNEkxChbFq7aeIIyo6wbcQ42gAJ66X1tNKikZXLY9oTdJN/7E8fp44Kabl4bWBwlclEX5XpaBmfggPu3zFAn9bKmKpoPag41gbL0cOlrCnbcOrTDXN/koWs/BB9+Y7exgLPaUqvIM7D2y0TtHkUNyg6Fzc9vmg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(376002)(396003)(366004)(451199015)(86362001)(31696002)(66946007)(4326008)(36756003)(66556008)(66476007)(8676002)(8936002)(41300700001)(83380400001)(966005)(6486002)(6512007)(6506007)(478600001)(107886003)(316002)(6666004)(53546011)(186003)(6916009)(2616005)(5660300002)(38100700002)(54906003)(26005)(2906002)(7416002)(82960400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wkk2endqZlF0MTNJOGRydlhveHBrSXRMd3BUd2l1RjB4eGltVlJoMUJRVSti?=
 =?utf-8?B?ZXF1NFpPeEJwS2ppeXEyTFFPUnRsZ0pxN2tmSlZjbkVZWVZoTFZQa09icTVK?=
 =?utf-8?B?aytXNk9sZGxMeHRpNEVBVk1vckEvb1psRFc0djdyRDBrZjdHUi9hNVlaVTJn?=
 =?utf-8?B?Z3Vodjh6Um8rU3NPa1BYYmtOeDNBYUcrK3lPeTI0V0JLdnhJWmhHbldQZjlk?=
 =?utf-8?B?RFNRbllld1JZKzlYOWU1dDhodk1XMDlVR1I2ZGVYRU50dUgzY1lQRWZFa215?=
 =?utf-8?B?TUQ3VHBwYXBjZlUyR0ROREFiMHlQVDRmeUtkZzhCZGNNbWxiK3pXeVNaSHI5?=
 =?utf-8?B?RHhQdVQ4cE8xNkhJTHJBUGJwUVErSzBZTVlCamxjNURjMm5hM0tzVWJ3MnZy?=
 =?utf-8?B?ODdSOEZaMXpyTVZ2dE15NXpxbEd5Qm5Md1ErOER5bXdFZldNQzdMOVJWVG9X?=
 =?utf-8?B?c203Z0NLSVF6S29ZS2hQTkloSTN3RGZVVWNrekZWSWUyd0dNNTlXcTUzSS93?=
 =?utf-8?B?QXZvTGNRWGYya0hBMUczZlJndjVHRWZGa3lEb2U4QjJOZHVMSlhOUVpXbmx6?=
 =?utf-8?B?WEtLTnVRS2hSNFhtRmxWNFV2enlYbXYwbEtYcjM0dGFJVnYzWFhlMU10amJ1?=
 =?utf-8?B?VGlXQUlhODNJNkJpdHhYKzh6dExWREZ1N0NZWGJadU9vVHkreVdXVXdSd3pU?=
 =?utf-8?B?U1I0ZExyZzZFN1JabWtSb1VFa1lIZjkxZlkvaGlSZHJQbFZUUm4vWkgxbnpu?=
 =?utf-8?B?U0dmMkF2eWJuSGhKSkQyVFlaRGdQOHRENnU5dHRma3lHYW5VR25OSzUwYnNN?=
 =?utf-8?B?MzR5V1B2ZkoyeFdPOEcrbTVjOVJXaE5WZW15TEgyRUNYZXp3d3QxZThNQ0tW?=
 =?utf-8?B?K0U4cm9nQ3ZPakI4MFlPek0vemZoQWFmODZOL3JLNVc5ZVFrWUNMSVNVdjNH?=
 =?utf-8?B?enFIVGQ4K1prZGlqa3hPRlZqamRmazAxUzM4ZFJUa05kcitnclNVa0JJYkxX?=
 =?utf-8?B?WEhCUmpzWjhMMWdseTgwdUhrRWFXTUIyT1VZZWdnRVJrQWNtY2dTamVyMDdx?=
 =?utf-8?B?Y2ZUc0JkVFc0a3JkRDVYbTdhSTFuTmVFWHpjOXFFclBxcG95Y1VsdE5RK045?=
 =?utf-8?B?T2s3SXhjTXpCTUxsS0NxemF2Q3krUjlpd1U4eHdjT2FCQ2YyWXdOc2lpQWsx?=
 =?utf-8?B?bW5xSW9XSURRdXFjQVROeDhSRzdVeENEaTRtV2ppNnIyenJDZi9aNXpRK0Jz?=
 =?utf-8?B?ZW9xOEZzZm94eHlsVDRKcUwvbFhzZjk3ZE9MM2liS3NPcFdoUk5heGlYbk5z?=
 =?utf-8?B?NnpySTBXM2dmY3dhWmRuOWtjaWYvRFRHSWxGS1VqN3NiWmJHd2orek10VzFv?=
 =?utf-8?B?dVJ0TlpXQ0kraWNNTlN3Vk5MRGlRR0dwSHhMeWpUZWFDYjdVRFp2ZzFnZDU4?=
 =?utf-8?B?T2hvdVVGVnlDQjd6UGNIWUErZnhCb1dTL1ljNzIwWUVad1duYkRMSHlpeG9T?=
 =?utf-8?B?K2xzZTQ2WW5XMjIwYVFKQmd5YmluRVRGb2FIZXIwZWF6a1pXejl5bkpvKzZ0?=
 =?utf-8?B?TWcxOC8zNHI2TzgzeXg3dlJUSjFHdFVXNkNEbjNML3hiSWVXdkU3U3dkbUNN?=
 =?utf-8?B?b0hWZUM4cTVFa0IvaWNPSFk3cGY3WVM5RGNtTXo0QlNncktNMkQvMnFGeVNG?=
 =?utf-8?B?VjljcHQzb1NmTWZ4dHg5VmNza0M5TWZsajhtYVhEeFZMRXV5Tm0xR3ZzNzVW?=
 =?utf-8?B?OTZSM3ByN1dGRjR3WTYyRTNYNEV3cVNxdG5RLy9nOE1rVnVMZGUxYmc0QWtl?=
 =?utf-8?B?MStKc1REN1Q2VkpNZEhldk9GSXZzYituZjYxUUFaY1ROL2xXMDAwRGtUZTlY?=
 =?utf-8?B?VUNFOEpLWUZ3VU5KeXozc1VnK3EvMGVZR0dLbURTWlpsSXJwdHRPY0pYdUcz?=
 =?utf-8?B?cTAzc281THlDY1NEZStFYW1kbStsbVlwVjExT2gvSXkwSG5IN3lreWVodGF6?=
 =?utf-8?B?NDdDL21LTWFiWnRxcXYxM0NPckl3NmI3Zjkxdk9BVzM5eHg2Vm0xZXFFNGlR?=
 =?utf-8?B?Tm5lY1NnZ0xBWUlrTG1qZWVwdDQ5b3ovOTVkc2JPRXJsQ0h3d3MvK3lJZlFL?=
 =?utf-8?B?Um9SME8xZ0t5TjJWWk5GLzVDT2NIQW8wM3BvbnJmdU5qbFBpZTJYYXpwT1Ew?=
 =?utf-8?B?SlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9541ae63-fa9d-4d03-bcfe-08dad89847f7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 21:16:18.2893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AI+/ONg/kFZiXHwzLPpQl+jaTPH8EwBFbqzqQe6xnIXlCECb+DpUhtRonb4Wxb/2yU+oOFnt17wpUsZOYlm7eznOioZBo6i1p4JFU932UGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7004
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/2022 10:25 AM, Saeed Mahameed wrote:
> On 07 Dec 10:08, Tony Nguyen wrote:
>> From: Bartosz Staszewski <bartoszx.staszewski@intel.com>
>>
>> Whenever trying to load XDP prog on downed interface, function i40e_xdp
>> was passing vsi->rx_buf_len field to i40e_xdp_setup() which was equal 0.
>> i40e_open() calls i40e_vsi_configure_rx() which configures that field,
>> but that only happens when interface is up. When it is down, i40e_open()
>> is not being called, thus vsi->rx_buf_len is not set.
>>
>> Solution for this is calculate buffer length in newly created
>> function - i40e_calculate_vsi_rx_buf_len() that return actual buffer
>> length. Buffer length is being calculated based on the same rules
>> applied previously in i40e_vsi_configure_rx() function.
>>
>> Fixes: 613142b0bb88 ("i40e: Log error for oversized MTU on device")
>> Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
>> Signed-off-by: Bartosz Staszewski <bartoszx.staszewski@intel.com>
>> Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
>> Tested-by: Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
>> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>> ---
>> v2:
>> - Change title and rework commit message
>> - Dropped, previous, patch 1
>>
>> v1: 
>> https://lore.kernel.org/netdev/20221115000324.3040207-1-anthony.l.nguyen@intel.com/
>>
>> drivers/net/ethernet/intel/i40e/i40e_main.c | 42 +++++++++++++++------
>> 1 file changed, 30 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c 
>> b/drivers/net/ethernet/intel/i40e/i40e_main.c
>> index 6416322d7c18..b8a8098110eb 100644
>> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
>> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
>> @@ -3693,6 +3693,30 @@ static int i40e_vsi_configure_tx(struct 
>> i40e_vsi *vsi)
>>     return err;
>> }
>>
>> +/**
>> + * i40e_calculate_vsi_rx_buf_len - Calculates buffer length
>> + *
>> + * @vsi: VSI to calculate rx_buf_len from
>> + */
>> +static u16 i40e_calculate_vsi_rx_buf_len(struct i40e_vsi *vsi)
>> +{
>> +    u16 ret;
>> +
>> +    if (!vsi->netdev || (vsi->back->flags & I40E_FLAG_LEGACY_RX)) {
>> +        ret = I40E_RXBUFFER_2048;
>> +#if (PAGE_SIZE < 8192)
>> +    } else if (!I40E_2K_TOO_SMALL_WITH_PADDING &&
>> +           (vsi->netdev->mtu <= ETH_DATA_LEN)) {
>> +        ret = I40E_RXBUFFER_1536 - NET_IP_ALIGN;
>> +#endif
>> +    } else {
>> +        ret = (PAGE_SIZE < 8192) ? I40E_RXBUFFER_3072 :
>> +                       I40E_RXBUFFER_2048;
>> +    }
>> +
>> +    return ret;
>> +}
> 
> nit: linux coding style states:
> "Do not unnecessarily use braces where a single statement will do"
> 
> I think this applies here.
> 
> Also you could simplify this function to do early returns and drop the u16
> ret variable and all the else statements.
> 
> if (condition 1)
>      return val1;
> 
> if (condition 2)
>      return val2;
> 
> return val3;
> 
> 
> Other than that LGTM.

Thanks for the review. Will make these adjustments in next version.
