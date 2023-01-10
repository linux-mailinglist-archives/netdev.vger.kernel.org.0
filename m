Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC63466468E
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 17:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238664AbjAJQv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 11:51:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238962AbjAJQvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 11:51:45 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C82140D5;
        Tue, 10 Jan 2023 08:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673369504; x=1704905504;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9/10tpWO4XHgRk/3bVa4GfsOrwejWtMWSVcnxB+f0LI=;
  b=Re/6JDkYXx9s4OIChl9A6Bbh6r7KAMdjK987QbdWb7R1jQfLrA/N6zCb
   /mDIfZiFyy7LkjabWj1nlO86hdmGTrDyQMMp+GWViOa/Mvco+S0/EWdv2
   ByD+t+wiz7+paqZRnCW41h7nn9m7V3i+uC3EiSbL2qJ3ueg8m6w83GPE+
   8rU/gy13BaTceYZMoDFPQO0qhoPMMrb0bYjFgErM7ISVAiOHNYMC5V66p
   nxFRi/SJWSsbpGJdHUyfeSV+gafGEZZ96aVsvQlICQj4dMVjuRpV1xc2A
   Isg6JTsuGLOCCIUmeftwybmIDi/PuWej/BCs3sZG6Jmn03Lku4W3reAhJ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="321898378"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="321898378"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 08:51:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="902435300"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="902435300"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 10 Jan 2023 08:51:40 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 08:51:39 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 08:51:39 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 08:51:39 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 10 Jan 2023 08:51:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sk4deuk1/FjqqTaWGE4HWEfLVGwODv/tgdzx0azxj4rifyJgZsw8eszzCAa4C835G64DImVoSt2U9sl+nq0M08zYfbFTac6e0AbICkqhnzfqEyparmPWKmiZMQYC3qLd7UaCzwL2gfhDmecKhrhzJVCDyU2HnGERKjA+a73HcTurCwCXB5XovOZVP3fEVVjbX2XPheDh6Fzhm7c3sAkWPpztWCoaPCrteI/IJL6Ougxsj5JGb8BUNuQCyZWUKMr4+H+bi0WjrBGZC5e7y1oP3She3pfx7iHAg+fOeHSMMG9+EnxeE542EJ6q8yBwczi6CON1EFKdkaL5vHfzduHtnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bVazBTJwsKYyVVYpaefKUuf2hmc2xCF1wYDvBrro/Hk=;
 b=W6VvdVR+fqwomgLJRmHJpuH1Qm9H/HEZQCI6OkcBtOnrpMG1z2hicPLAhm4J/hPi371X/BquvXfzK1A8wdonV5//A5eB1ChQ6Hfepu6ei2CMMzbfosQRawpTbRt/+JDnPfxcgN4yQr62W86kae8Azv+LxfPQAhylbDDf21qb6PmRED1GfFXX7nYaIZ2lYkMIu13pSEYYz5wAIoE8d1szVKSkOnZaawaa2pNf1nGKcSOUcptWqZHsSg4KutielQVEaMGrlkrBpcFvHNF7A5+LLo3Gdws10k5+cvcU7FpkgDfhfKgy4YOCda7bo3etnrjA6GYeWn1MrX7cIH/LKNgMQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by BN9PR11MB5385.namprd11.prod.outlook.com (2603:10b6:408:11a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 16:51:37 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::c1e:cae6:7636:43b8]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::c1e:cae6:7636:43b8%2]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 16:51:37 +0000
Message-ID: <28077568-075d-b0a5-2be6-b2d7f5e4557c@intel.com>
Date:   Tue, 10 Jan 2023 08:51:34 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 2/7] PCI: Remove PCI IDs used by the Sun Cassini
 driver
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-mips@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>, <sparclinux@vger.kernel.org>,
        "Leon Romanovsky" <leon@kernel.org>
References: <20230110152606.GA1504608@bhelgaas>
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
In-Reply-To: <20230110152606.GA1504608@bhelgaas>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0036.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::49) To MW3PR11MB4764.namprd11.prod.outlook.com
 (2603:10b6:303:5a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4764:EE_|BN9PR11MB5385:EE_
X-MS-Office365-Filtering-Correlation-Id: 720f124e-6eee-42a4-ccf6-08daf32af037
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SznPthfhR9wtkndxHB53pzOGMdkaZcqtweGCrsu2gEB6t7GT0OuRagnlSe/zvHogFquSyNcMapmgTm1eZtmNL1tfY+6Po6gdybw0rY2Km3/365PEy6GfHwOanBqJaJ3Uo5xmSBx6Vx6sJYcx+V1+XtKeb2gGgP2f4i9fJCAVXVnuYYAfzI7q4RnlHleDZBlxRY3USYwA67Mi8MZ+CdjY/1xbr3+6OYXQ0hI5oi7RU7MKYrPLWOQwu9MGd115TEDFLniPZzdOZU28O+kFVbk4e4FpFrq8mr63BHubvUogR7eBKDmJ3tRtE2PlhyuzUigIdVZSb8tVz2R+SJYgZ5lhXPhrk0oV/YlFioh1YfKfts8HPz4cN3h8oLj5+XhOx8kWyTizWEBHrRry5uaZZaJMUdZbibPcrFHFuzaIGpcSYybOY9knIb6Tc9Cwa+jb8Fkc3IVQpSY+l0rQ+fE4B7F3FS6WchGUMgeRb2z2jlo0OVDkwUsCkVcEyXpUWPaQ0STFGQYRF/KCuLWBCgK9Ta9hiDwj0PHeN+tZ+6238IuSgj7wyFkWF8ckZLcFdZgIbfL9G9eyyw0eMztR/VODohuqWqN9CA+Ebk567cG321WW3bO43sRe17tFTbv52bNoKAen11+ZYwN3suWqz/tZv56nfvLzhduWAqEmiz2TYWahVCDrO+9RcscvLZ+8vEF4u2QWD1YzhcPOfDTOJBXTZOA0NF8wWpEDAo/yICP0GV++efQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199015)(8936002)(2906002)(5660300002)(41300700001)(4326008)(316002)(6916009)(8676002)(66556008)(66476007)(66946007)(44832011)(26005)(6512007)(2616005)(38100700002)(31686004)(86362001)(186003)(83380400001)(31696002)(36756003)(53546011)(478600001)(82960400001)(6506007)(6486002)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzA1MWIxS1V4Q3dBVDZqSGpGb0V4WWRvNzVQUWJ3S0JIekNmdnh3OVBIZ2dz?=
 =?utf-8?B?MWtzZW0xdHdKSnJyV2xaUXltbGJ4WWI1cThYb1F1bGpsdzNMVjVHM3ozbXBi?=
 =?utf-8?B?RnVaUWJaSy9sS2FGeEVCOUZmWTU0ZUhULzV4aVNwa3lPMFB6b1MwdEtDdWE1?=
 =?utf-8?B?NjFpWWZrWWdxK3BuTS9Db25oZ0xiYi9pMG5sU3h5ZjBxMHkxaTNjc0J0d283?=
 =?utf-8?B?S0ZZSGhnV3NLR3ZadnZ5dFJNSHcvSHQrTUdXS25hWlZiRkhPd1pUeGxRcW5U?=
 =?utf-8?B?UWJGaTVkclAwQ1ltZ2ZKTVRjRkoxQVpVTFB6MVNFWXRLZzBKR28xWlFUbk15?=
 =?utf-8?B?cXNWKzNrRXI2bDgwUHllc3dQanhtbWNiTjNYUzNxUDN4bjNvWnA4aVJVVk9D?=
 =?utf-8?B?a0xtcEVjZWd0ZzdBMERIR3dvY0Zocm1MSUNkcHZsT1Nxdzd3TGZycDBmWUVn?=
 =?utf-8?B?c3lUejVZeWhBK3ppRGg0YkNtWFlYSE4zb1dtTE94YXFHcnNUSCtKN0dvME5u?=
 =?utf-8?B?aHdtbHJvd0laUnh0RHVQOG5DbEx0b2drUzBmY3prQXg3N2FHRVBYd3BhQkpw?=
 =?utf-8?B?bHlPVG5zZWRKdUhKbVYwZXU3NU9Sb2d2a2tyUG94cElEOVhZdUNjSTJMa3NF?=
 =?utf-8?B?TTdnVno2bmJWVHZZRVZ5ejk0aXpnbmI4ZFFGbUpVOHdVV3ppTWVCNWR3ekNE?=
 =?utf-8?B?cnhxbk42WVNOVFVwYkFRQzk2Q3lJd2lteG5tUWVta1VlOFVkdi8wdzUvaFUr?=
 =?utf-8?B?NE0xQUJYWjNkTG05MS9DK3JTc2I3RjZqbXkvNGgrSnBPYWd3QS9GZ3kxamlp?=
 =?utf-8?B?YlhtV2Q4TnNwUGZiQ3QxOUg5SlcyR0xyWFBaQUJVL3c1bkpPVnRGQlRzUHV4?=
 =?utf-8?B?L0ZkTFU2UTNVMXlNSnkrSldKT0I2NFZuTEVPcktiU0doeU1ub0YrSnJXMW9E?=
 =?utf-8?B?TytuZnczZEx4RXFyVnlVYmJaRnRubXhyR3V0a1pMc0hGOElUM1pINmZFWlMz?=
 =?utf-8?B?OFQwSE9MTXdjcUwrZ3hMUXd6ckxjbVNqRDNOUjI4K3RhQVEzWXhCR0NFZ0xN?=
 =?utf-8?B?ZGFTS2l1d3lrNVBUeGt4d2JHWEdQN2daLzByd0VibWZ2WXJheWNkOCtNNEJV?=
 =?utf-8?B?WW9saWNRWjVQM1M1RGxMYmM2Z3JZYzhqSGUyU09aSTZ1KzBxdEZ3ajRJQTZp?=
 =?utf-8?B?bFJIcXEvNEdhU2xYdmpIa04yWUtaMVZEK3dJeHV5emZ2aU5XcGtvd0lvRU8r?=
 =?utf-8?B?ekEwVUNwMXQzdE1pT0NuaHVvK2RJTk5pSEcxZHhJTFRrWFBNZzBMV2REQUN2?=
 =?utf-8?B?THBFd3Z5RVJvendXMkdqaU1jc1VEZE44bDNTKzM5SEUvZ2Y0ejhlVVk4R2J5?=
 =?utf-8?B?NXRRMXlPMDI1SlhkTVhySk8vWERrQWlPM0I0Ly81MTRNVVU5V0NmSTlxSDdq?=
 =?utf-8?B?R29RZHZJVFBlMFdKVDV5OUsvcVlJRUpZdlNYUEZ5aEtmQ0hCZ1M3a1o3YXYr?=
 =?utf-8?B?dWVnVG82Z2ZwSm85SUVWTHpGR1IyaldhWS9YK0ZGVmQxOE53TzZxcmpLSFlR?=
 =?utf-8?B?ZFNMeFd5Z0dWekIrNTlMb0hFT014M1J6STJMbkwyYTFzODJiM0dDTUM1SEQy?=
 =?utf-8?B?ZnpXdlNmdlVsZHQ5UXAxdE9xZmJNZUhyNCs3cW9TdHIwOW5jbnpXSVFaVVRx?=
 =?utf-8?B?dElSb3FvN2RKMjBjTXlnNTlCSzI4OHRhbkhjQnNOclIrNkhod2p2N0djeXRI?=
 =?utf-8?B?MmFxY2FIeVIzcGZ5ZkM5YnlkcWFzajZkT2JjOFBYVEUrR3pjYUtIK3pMenI3?=
 =?utf-8?B?TVBTNGR0QzZFYWxDQ1Q0OGFRbVVNNjRoVHRPejFXeG1LRDFYeHYxS3NrVVV5?=
 =?utf-8?B?YTVFcHlsaUxEWEgyU3krcVNoVmM2cS9KdjJWNnJpY1diK1dFS2pNb3dsQ0RH?=
 =?utf-8?B?VERDSUNQbndUN2VpUUh6V2E4LzNORmdCRExSZXdqVjBTbk96dzFMNDJRVkty?=
 =?utf-8?B?VS9ZVk02bnZsRnF0bEw0QmUzdWkzWnB4amp0Z2pzL3JJci9aWmg2TlVxbzRx?=
 =?utf-8?B?ZXBobjZmcS81dmg4STk1Qnk4RmlaQi9la2oxUnBlK0RxTm9Na1JnK1pHbE1w?=
 =?utf-8?B?bi9iaGF4TVhrUU1EcE5WWnlrVGQ2YTJWZnJrc3FqSUUxVk5WdytEYmZUYWNt?=
 =?utf-8?Q?Pz+dQarA/eYvweLluwqkfHg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 720f124e-6eee-42a4-ccf6-08daf32af037
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 16:51:37.2273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K4l/kXw2M8r6ywAvsFRdHej14Xr0/hDIrk9Vap3j0nS+/oPe1ijq4BteTQ9R/oBafS3K1eXwrnfup3V6D4rX3dvHZAcxTx5Fe0o1CLRgv8Eao/s46ewBdDscSkNcvehv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5385
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/10/2023 7:26 AM, Bjorn Helgaas wrote:
> On Fri, Jan 06, 2023 at 02:00:15PM -0800, Anirudh Venkataramanan wrote:
>> The previous patch removed the Cassini driver (drivers/net/ethernet/sun).
>> With this, PCI_DEVICE_ID_NS_SATURN and PCI_DEVICE_ID_SUN_CASSINI are
>> unused. Remove them.
>>
>> Cc: Leon Romanovsky <leon@kernel.org>
>> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
>> ---
>>   include/linux/pci_ids.h | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
>> index b362d90..eca2340 100644
>> --- a/include/linux/pci_ids.h
>> +++ b/include/linux/pci_ids.h
>> @@ -433,7 +433,6 @@
>>   #define PCI_DEVICE_ID_NS_CS5535_AUDIO	0x002e
>>   #define PCI_DEVICE_ID_NS_CS5535_USB	0x002f
>>   #define PCI_DEVICE_ID_NS_GX_VIDEO	0x0030
>> -#define PCI_DEVICE_ID_NS_SATURN		0x0035
>>   #define PCI_DEVICE_ID_NS_SCx200_BRIDGE	0x0500
>>   #define PCI_DEVICE_ID_NS_SCx200_SMI	0x0501
>>   #define PCI_DEVICE_ID_NS_SCx200_IDE	0x0502
>> @@ -1047,7 +1046,6 @@
>>   #define PCI_DEVICE_ID_SUN_SABRE		0xa000
>>   #define PCI_DEVICE_ID_SUN_HUMMINGBIRD	0xa001
>>   #define PCI_DEVICE_ID_SUN_TOMATILLO	0xa801
>> -#define PCI_DEVICE_ID_SUN_CASSINI	0xabba
> 
> I don't think there's value in removing these definitions.  I would
> just leave them alone.

This whole series was NACK'd so this patch isn't getting applied.

Ani
