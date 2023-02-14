Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758CA696821
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 16:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbjBNPcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 10:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjBNPcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 10:32:51 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8829CEC;
        Tue, 14 Feb 2023 07:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676388768; x=1707924768;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QFjIacsLgf6Sj1dKgqRyf7Ms4/XwlP34hzWXwwVPXXg=;
  b=ewEGSlslcYuqnLqZcr/Q4SepqTUvWeQFBaEdOgHtNukkFEZDgME4cOHS
   ivYh1kn2RgSRzU/v0VD5GAj8+2xAKdp/+xhA836H7VskawDvmQ0/Ec3fb
   6Etdnq1YW1IjD2rOv0tkJfpSJ3JL15mIUDPIVbRgKTBlkBRTLHDpSQQa5
   l3EJI3SWafnO+r0aZNBCq/W/QxTHfI3MBK3DGzJwqKlkD3D3GKFedhpFK
   ngJdjtTqKfFGHXcgqr4LRYWL8QlobqLb+H7bYxJll53eROVptjLQQykYE
   B1BX0o8ZOXm023LR5gM2kvQuJpA/QaXE/GlNzwK4pMwa6+jbhKo+VF86N
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="329810600"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="329810600"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 07:32:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="737905686"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="737905686"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 14 Feb 2023 07:32:22 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 07:32:22 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 07:32:22 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 07:32:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AK1F/iu6YfsCstdZFJtIdPvynI/fbYJ3QjJP15CzQ67ZvqySBmtAj3B1gcXvXqBUgHn77MBZ+rShLf+8eNw+zF4uf5q1niZcMXRjrLUuhkFhjYCsWOkvwr1lAVnOkTs1SvxmlN6xnHyFi7aHRWp4vvYsDqwEw4ojLfJBXUmMULCLxDpDSdxENyXYiXv4RZ6ZSe8hjxIR/FLcwRBb2KxMxCviKqG9P03uEJ+3r6SSyd+pVKFzJZ5isGTLcOdnPn2jw/6KnNN2mcT9OUudh7N2FU9rAMYqi8QtTdpfqrg2Ad+wen5U5odtfntdcuo3ILbR5j6C9ISQWX5hrXgJI5O0OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eIaciJXgWXzz9Ogc1yGM9gswiS/n04kUGsaM+wQUdnY=;
 b=ZIJgZTVTR+93XyXEJfckaQ0/3FQCFLpPHuK0zXOLeAhQwWFnrTNEc4HUSfrDhTM6EflmIW9Dg29XeqGMNgUM07TmNax2+2gkLIZJbkUzohxfAqdp+daD+XrmcOLJu8QNE/eCejtbdALQTl0JcRRNA3leMQ4YOQxbdsTKzsWttEr+3kmay9zpCQGUKu1lsRQCVmMqwA0zvqvUHKs0xb5Fl/xuIwZvswgmjTXQmILrHErxpku0t9eaBHUGlZScAhAWO0xZVNfLJrH1/tNoHAJI3geeqGz6Uc+LdJBwcM95/igvkM9J1ubLWSQWT7GHP6N60+JsZVv+jXt/oZxa3KTPjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH7PR11MB6721.namprd11.prod.outlook.com (2603:10b6:510:1ad::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Tue, 14 Feb
 2023 15:32:19 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 15:32:19 +0000
Message-ID: <76178aea-0ab0-1f7a-a426-669eac575f1e@intel.com>
Date:   Tue, 14 Feb 2023 16:31:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] [v2] ethernet: ice: avoid gcc-9 integer overflow warning
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>
CC:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        "Lu Wei" <luwei32@huawei.com>, <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230214152548.826703-1-arnd@kernel.org>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230214152548.826703-1-arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP123CA0002.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::14) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH7PR11MB6721:EE_
X-MS-Office365-Filtering-Correlation-Id: 49bc3936-74b7-4e9f-7449-08db0ea0a8a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gZDHchtL1upI+PbGdiTyR3MaYh0b7Ialoyez5A0InaKvmYtoDQ3PHOdAnyn2zXwwLC4wOETTAGEL012HoewpTgE/VcU3a2wA5c0mKtYpYyAnLOvqFCLU2sqg0VHy11SLBj2lHZMAXH2+ghXsZufzcSl0lzd/2DzZ/Kl2KZtIgkQOatLvnG6HciE9sDqltEQdfobs704v+/0fFg6NWDeDjq9EnUPQwpsbPZqIzDsjkua/fk3voZDKKHc0xPye8nZC0rYHUwj21Ts2skl2qStwkIt4OvA7Yu7nkT2dxMxjxV45gvCldnrI3kOEX457xNqbkEkxwbqRM3xCuXtXNXxlXpJUSpJEVXNgQb1lkkjfdfryG6bhjRtIypeBRNW3GfMUXpOYRgQixPgJtLp+gO1bEDJTyWUwK3MQkNz98f5qL27uCCerj7mmlI2/JCruBZu634gRcuWvU/+RBQ7Vzf/7QJSCZsdN1BSw9WtZkJo1Yn/HKmaG7FACEHfn7ds6TUCak0FkcRSqMPV8lvgdOvenKu356SiMwei5TO/s8Ist4sP4BG5/OCCa7LKWRvG3q5ygCcnEzXpekOvtnIpA7WCC4v/bVSeAbWM5U+aKwhJgwS6cYnIdr9LQUrZZLwJ101zbTY6/k9hpew1iy+kngWFcqAa6u/thnWvpoMUnLx/MfFLKHqqsCdzDi4OKEg/dXvFAFOuTvw+OIgjQllJxEDQHm6c5RkmSD3rj9bTkzYuL5i4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199018)(31686004)(4326008)(82960400001)(66476007)(66556008)(66946007)(8676002)(6916009)(5660300002)(8936002)(41300700001)(38100700002)(36756003)(2616005)(186003)(6512007)(26005)(6506007)(54906003)(478600001)(6666004)(6486002)(31696002)(86362001)(83380400001)(316002)(7416002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2J2bUoxWDJ3RC9iSTBCdmovaW1neWJmU1ZhRGdoQkU3c2loMVVDdUhnenJB?=
 =?utf-8?B?czFKYWZmN1JIV3hjdzY0bnRVTStTY2tvVW52ekU3eGtybGo5VFVBMHZabUhQ?=
 =?utf-8?B?T1BLa24zd2lTWm8vOTk0dm9wUHhWK2hqcGMwS1B0SDJzTFplRmFUQVZ0RkFE?=
 =?utf-8?B?LzdqWnVKSmhIaEJQSGtMTWFoWjBQVkhNN1BWeUVHNE5SZlpZekpKYnMrTTZL?=
 =?utf-8?B?TDkwYldZc0QrQ1pSdVBCZmc2VGxoZ1hDQ1YybzVUSUZMRlhVZENuczFuMEVk?=
 =?utf-8?B?aXoveVd6ZlcwWHpxVXJ1WlVWMTBXL2lBSWwrNzVLcHkvdUQ0dmwwU3JGNXlB?=
 =?utf-8?B?UGE1R1E3RDhHZUxjbTk3Rmo1ZmZYVEF5YTVzdWZvU2phZUI4VUxzMzIydlVk?=
 =?utf-8?B?WkpXR2ZRM2xUbGozcHhRRVcwNkp6TVV5MUUzV0R4dWdMMkdOZTNtUUNSZFFv?=
 =?utf-8?B?Sjcvako1VklHZlJoemYwRmJvTHdqanlqdVpDRFpXcDMrWnF1RGxGaVhWQUNQ?=
 =?utf-8?B?R0lSNWtvWWdWOWdmdlYvQjF5b3JnazVJZkZoWmFlR2JSck45VzBaZmVCajJ5?=
 =?utf-8?B?Tlp4MTdnWFJwcjczWHdxRjJ1YWo5ZzZ3cjc4Tk04Q09LKzF0bzY2WWJrZTBp?=
 =?utf-8?B?ZVN4MG1kWDlXR2VWOEFrdXRaRkZoVXpTMVZ0S0lMbERWSndDUnU4Qm5Mc21a?=
 =?utf-8?B?YmtQaWluYU5pZmd4RGRTZ2xMOE5hMGRjeSs1OFFNaEtuVjJOOXh6ek9vUFZK?=
 =?utf-8?B?dy9HUHAwNDlZT0lCWmRsVjZMaUpjL09lWE4zbHdXdDNJVGh2MCt6cUtxQldR?=
 =?utf-8?B?U24waTZPRWNOWlpmQkZMeUdiV2tERmtYcnczTUVheCs2ekkwNTREK2NicEZV?=
 =?utf-8?B?UGY5U1lzZExBK0FuOWFWRGtEeEpCYzdNRGRZbkoyZ3N5QzlLVWVFd3hSTjB0?=
 =?utf-8?B?S1BWTjd0MXJRRTgway9GbjRHVDJlYWpqRWNDaUNLcG91TXdhSy9KaXVIWWpM?=
 =?utf-8?B?c2tGVmcxa0RKWTVtS25JcGt0RjBEMnVWZ0FScHgzNGZieU1RUFFFNVdXenFF?=
 =?utf-8?B?L2R4cEtLdUR4cFlJaVZrNS80OTdTaW5wRXFoR1M1M0x6WWdPSTlDZzJaNXNo?=
 =?utf-8?B?c2hPNUwraUEvRDZFYTR6NlM3VGRvNjAwcmhvem9zWmRoZEl6UzZoVUNWTDRh?=
 =?utf-8?B?RjNtMVVzZU1USlRlb2pNSk5EbmM1bHE2aUxrMnNpNzZVM1JFTExUQjZ4UWdC?=
 =?utf-8?B?bFh6aWxIdmNFTC9wQUlYUTdFVXd3Zk5takpsWis4YmdmK1RHTjAwQUdrNjNW?=
 =?utf-8?B?V0tmNDRzbmkxV3I2Qm9VWjViQm85VW9WZGNiUFlJU0ZYR21jYlhLRmZEZ3Jv?=
 =?utf-8?B?RmJoUTdTbEM1YUhOT2ppR3dyVGUwWjFJZExPY0dXTWVyamo4M0hnclM1WHdy?=
 =?utf-8?B?S3ZzSVZYbHpUSjY5ZnVEUEN6ck9lSVJtQlBNNmtPeTR5bFhObXNUVnU0SVA2?=
 =?utf-8?B?aCtUVEtmS3pmUFE4b2hNdjFrOEN3WU1ubFVUQW13M21FMmFMQ01tZXlDMEVs?=
 =?utf-8?B?cnp2UXhHRmRwMU1FWitIanRHdVJlS21HZFZlSkZiTU9pQ1FpTjBIem9VWUdm?=
 =?utf-8?B?c3BIaDE4b3JuZ0JrMklNTXNBZ2lzbkxFY3RLb1g3NStrMFBZOWNjdnpwY0xE?=
 =?utf-8?B?aHN5NjYxaVlyNWNoaFF6WTg5V3pFNkVOSEFISm9TL2VDWW92dFdkNWIwRjJ2?=
 =?utf-8?B?KzlRNTRpY0x4SFFzUU1qam1TbHlESHY1OFJzbXZYaktVMUZFNksvUkJTZEFP?=
 =?utf-8?B?aHdkTTFqVHFTUFlCT1B6QVllOWNlWUJ6bGZ5R2xQZi91TXIvOTE1dU9odUJS?=
 =?utf-8?B?QTlNZzF4dit5ZjczVjRqNk5UUVJwMmRvbk01WkdaamtOYlN2SWZramJyNWRI?=
 =?utf-8?B?b1hUaWl1MkhwMVNld1Z2b2VrRUN6RDV6RVowcktSeVNwLzVNZ3BmU3c1Y295?=
 =?utf-8?B?VmFWUkhoYzdvZVI5NVN6U2JvbHhXbURjL0JTWWg2VXFER3FHbXBCZk12UU5H?=
 =?utf-8?B?MG5mTSs0MmR1bFI5TnFGcUFIVWZqT0Y5OEE2Qld0SzFWbVZrR3d2OEZNS2Mz?=
 =?utf-8?B?cFpCUHJrbC9BSTRTTVlyTTJ6V2pTMUdWTThoTGoybVpQT2pJZjU5dnNmdWJ5?=
 =?utf-8?B?VkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 49bc3936-74b7-4e9f-7449-08db0ea0a8a7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 15:32:19.2659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B2hDpINlHNIguvs3R/E2kjrxzOfanXFV0Zej2xRAUUAsCkPCJuXCKwJVk0cgMOh3z7ZUEVqWO+0TlYGRmKzFWzPAj/r7NmiZhTKXffxNpUo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6721
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

From: Arnd Bergmann <arnd@kernel.org>
Date: Tue, 14 Feb 2023 16:25:36 +0100

> From: Arnd Bergmann <arnd@arndb.de>
> 
> With older compilers like gcc-9, the calculation of the vlan
> priority field causes a false-positive warning from the byteswap:
> 
> In file included from drivers/net/ethernet/intel/ice/ice_tc_lib.c:4:
> drivers/net/ethernet/intel/ice/ice_tc_lib.c: In function 'ice_parse_cls_flower':
> include/uapi/linux/swab.h:15:15: error: integer overflow in expression '(int)(short unsigned int)((int)match.key-><U67c8>.<U6698>.vlan_priority << 13) & 57344 & 255' of type 'int' results in '0' [-Werror=overflow]
>    15 |  (((__u16)(x) & (__u16)0x00ffU) << 8) |   \
>       |   ~~~~~~~~~~~~^~~~~~~~~~~~~~~~~
> include/uapi/linux/swab.h:106:2: note: in expansion of macro '___constant_swab16'
>   106 |  ___constant_swab16(x) :   \
>       |  ^~~~~~~~~~~~~~~~~~
> include/uapi/linux/byteorder/little_endian.h:42:43: note: in expansion of macro '__swab16'
>    42 | #define __cpu_to_be16(x) ((__force __be16)__swab16((x)))
>       |                                           ^~~~~~~~
> include/linux/byteorder/generic.h:96:21: note: in expansion of macro '__cpu_to_be16'
>    96 | #define cpu_to_be16 __cpu_to_be16
>       |                     ^~~~~~~~~~~~~
> drivers/net/ethernet/intel/ice/ice_tc_lib.c:1458:5: note: in expansion of macro 'cpu_to_be16'
>  1458 |     cpu_to_be16((match.key->vlan_priority <<
>       |     ^~~~~~~~~~~
> 
> After a change to be16_encode_bits(), the code becomes more
> readable to both people and compilers, which avoids the warning.
> 
> Fixes: 34800178b302 ("ice: Add support for VLAN priority filters in switchdev")
> Suggested-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: use be16_encode_bits() instead of a temporary variable.
> ---
>  drivers/net/ethernet/intel/ice/ice_tc_lib.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> index 6b48cbc049c6..76f29a5bf8d7 100644
> --- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> @@ -1455,8 +1455,8 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
>  		if (match.mask->vlan_priority) {
>  			fltr->flags |= ICE_TC_FLWR_FIELD_VLAN_PRIO;
>  			headers->vlan_hdr.vlan_prio =
> -				cpu_to_be16((match.key->vlan_priority <<
> -					     VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK);
> +				be16_encode_bits(match.key->vlan_priority,
> +						 VLAN_PRIO_MASK);
>  		}
>  
>  		if (match.mask->vlan_tpid)
> @@ -1489,8 +1489,8 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
>  		if (match.mask->vlan_priority) {
>  			fltr->flags |= ICE_TC_FLWR_FIELD_CVLAN_PRIO;
>  			headers->cvlan_hdr.vlan_prio =
> -				cpu_to_be16((match.key->vlan_priority <<
> -					     VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK);
> +				be16_encode_bits(match.key->vlan_priority,
> +						 VLAN_PRIO_MASK);

Oh, the patch looks great! Both fixes the issue and cleans up the code
a little bit.

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>

>  		}
>  	}
>  
Thanks!
Olek
