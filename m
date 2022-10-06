Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8B05F6DD1
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 21:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiJFTEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 15:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbiJFTEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 15:04:16 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2A65F48
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 12:04:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T33CWPKIuZh1D7HCKpg4cSVBXWoJpZhMkj2TOXDp7i541gz3QdUR0iv4FPLu/wIY+KbE4f/0nYs8Kc6opOH9nPduf+Gun4JVUY3lQiiw0a/rRgRi+BrORHdtxsuNjceCfXUeS4Cd5tGFKCWpiqSCfi7o2yUP5Ltb09BR2867dRA3wy1WhfZNl3IuJECUolQbCq9bNWbqwVsS5+zNLBPBgWbTQ8ACO/wVjygnYW6xty5za4nF9bLzs5T8byhikMJXVvsTinxDv+aRTYj1RVVosPY7GO690a5Qhsne6+BWFO5njIy9v97/vYtx2j9PV+YJW4MIynclyGLgNAr4oucG1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=StEHNm941uIBSFxZFi1KjeVW2sqUCTohwNsjfTJI3IY=;
 b=V/lJ3jxqxPR4TdTRGALGlNIpEepPS3qOn8xr3bKmj0oXCz96gG1mZBFSufLLN47Lvu2BLfrpmYKcv9Nn2A9I+r/uOtDpSwY/qhq9JtCEPC5upM9zViHj/sghtlQeLpA8RTFan75O1LIRBbs5oKsbtaZqa+nugSrcvI+WJmqwVL31qLQ0LSBHWdkEPKtQ9rafe02Do8q4ny3W648QgHRvUoWbChp150pLcJnRV1DUeAPldxhfOJXml+v9woBv8eV7HDLwPCNgmf52kSQ6vbnqYaFqXZshMmRzJJLszDnbG76yFGAciS8qQUr6v7s7dejFebpDv3dCCbvY3+36QzAGAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=StEHNm941uIBSFxZFi1KjeVW2sqUCTohwNsjfTJI3IY=;
 b=g0D8IouF67noWHQCjzKqqywcxU/WUVSjLD9soLBO9AFnTERf6IAvyBlXu0g4CWClAWY3V5zohEil/3+AEFTAE9Y9X4Fi4UgOckzmcuYZbcad1SJlbSb2Jk63ij5GBuudP2riffp+N/FrzDuzPlZM5lQvONLnNs7TOUY/HMg5qD4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MW5PR12MB5682.namprd12.prod.outlook.com (2603:10b6:303:19f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Thu, 6 Oct
 2022 19:04:13 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::c175:4c:c0d:1396]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::c175:4c:c0d:1396%4]) with mapi id 15.20.5676.036; Thu, 6 Oct 2022
 19:04:13 +0000
Message-ID: <40b3f874-e7fc-4049-65e2-3ed449b956f8@amd.com>
Date:   Thu, 6 Oct 2022 14:04:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net 3/3] amd-xgbe: fix the SFP compliance codes check for
 DAC cables
Content-Language: en-US
To:     Raju Rangoju <Raju.Rangoju@amd.com>, Shyam-sundar.S-k@amd.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, rrangoju@amd.com
References: <20221006135440.3680563-1-Raju.Rangoju@amd.com>
 <20221006135440.3680563-4-Raju.Rangoju@amd.com>
 <d377d924-d205-cd25-e3d0-7521ed8a3ca1@amd.com>
 <9a8552c2-0a23-ea1d-9d1c-56b7a6c75487@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <9a8552c2-0a23-ea1d-9d1c-56b7a6c75487@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR06CA0026.namprd06.prod.outlook.com
 (2603:10b6:208:23d::31) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|MW5PR12MB5682:EE_
X-MS-Office365-Filtering-Correlation-Id: cd17f55a-1db3-47af-1b37-08daa7cd8ec1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PpjI7a7QqbT/y6mLQEVrg1M0n5iYs9v+KGQRsbwYoR/XyUczGo+BlkubgSW56m6VCIa6CG+sWcntPhzuzC4I+sfdG+xDasS83VUfo3FFI3MYdrUEGTQUWEWVphwZv7k3+xwFuVhwohl3KKls5/YSicwY+wgf6sUQiv/vvONmCSjFaPEHy1MI8EQC5RHfS4M9DN+GS+0no/pvNRVfmRcuxDO7XLcvXtz+bH9jcN1EvAnalOllmpAOsvCfgreyopFr0/k3ZvBWXqP0w0Ar9beeTRryxQpq0GQQ/nW4Lb8x8K28+30Vjz791ec7q0ATongUNUXgkPdOUwneRzw7cabaykGmVobrRHXRqnuyxUfxqYBU0LII3qLPs+9PilL1fCMZxAsETC6ZAVUF0jGgBWslj7PVevMYntq+CVVX8jALGfMTvq8KvWc+56HjMt+ri14a1Uzbz1PFhW4cQ84ygJfG6R86S0LNkl9M2dT79yFa9uU7c7NCqX7KRU/a4fUyBivmBmFEDm1Dq0deg8QCbp1DKsIJK5gIDXEKaUDJ3HAjfvBRnrAZAkbEVJ/qdGtJcOjRCT6g9B1+f2+kGhxiZL2hYoAAjR6uGURusV0GjGrxzteE93TI/Vpk42dgn6RB3tjEv4peLTZF2PIfzL2+PON/5z/CZcc9PppPa6Npar+CKT4fxbM76yhgH9bDIHda9dVTB/Vq34Y48zlRmt6I6+0a6eOpFRNA8c5W54YRrflh1yTOIndSNThSlLpTA9PpUdGVUDlyjhPDF5pPjr4pFWBYKVDzqZqG6jXjVM1HUTkog7I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(451199015)(8676002)(38100700002)(41300700001)(2616005)(26005)(83380400001)(5660300002)(8936002)(6506007)(2906002)(478600001)(6512007)(66556008)(4326008)(66946007)(66476007)(53546011)(6486002)(186003)(316002)(36756003)(31686004)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S2Jmdk9RY1ZFQ0VJV0xHTTNMenora0I0d1RNdytoZGZHQ3dOT0xvWlZKdjR3?=
 =?utf-8?B?WFViN2hMMVZHd2pUbE1rRTFJZ3ZmWGhjOVRzNjlIQ0RnczZzMFNVN05VSzds?=
 =?utf-8?B?bHFHRVdLMHM0VFc0Q3lGYlRoT1ZMZEMwRC9ienlWQ1VxcHhFUGIrUERJOVVS?=
 =?utf-8?B?NGIyWDd0UWlPOHdSMTExNHAzSlB6Z3F2SVF5VzNLRUI4Y0xlNVdodmNpbGFI?=
 =?utf-8?B?b0ZRa2Z4K0g5TU5oRDFXMGlxUmdZSFNpNHJDTHA5dVpxQ2gxSmRKcFMybHQ1?=
 =?utf-8?B?My9jYkxCbVJER3gvcU5qMWpzWVNPTDZpckZSMzk0enU3aXFXWWVNZGVvOXlP?=
 =?utf-8?B?aDEwZDk3cXR5U3dXek51cUtieGE3elpxYkc4ZkQrdjVIRVR1a3BWREhTQW9q?=
 =?utf-8?B?NGFVeU5hRktoYnZjSGs1QlY0M0twZnI5WTZFdTZSRmR0NFo0UUd2RXFTdm5N?=
 =?utf-8?B?NGNvVVZmWHpob2xOanJuTHROZlZyTXk1WUtldE44dzdWRzJsSHFZdjNqNDcr?=
 =?utf-8?B?MUpWdXJpWHJaOS9lM0VWVVE0ZGh0dlUveXBNUlQ1YWszK0RtRmNqSWhhMkgx?=
 =?utf-8?B?UGs3SjdXSGx4Yk85QVJVYk03U20zY0JlWHlaYnFTajVrQ0dDYVlQaEg3aGFy?=
 =?utf-8?B?aEdmemxxTTJSQlY2UzhIRzVTaUh1RWE2aG5ab3ZlY0dzQkJteHJodkZSeHow?=
 =?utf-8?B?RlplVmJyYWZTQWtYYm9KVkNqa0cxR0xmOXk5djhNTVA4c1dtb2luZENubFNI?=
 =?utf-8?B?YXNaTllBZjJVQm5BNTZ6eFY1MG5NUGU5K0RORFdKK3BWUk80SFFCWVdoeERl?=
 =?utf-8?B?VzZ1UmlpblFZdU90MmxKWEtDbThtaHF1VnM5amMxOThkYTdOdkpiU1NhZHNZ?=
 =?utf-8?B?WkxVWmE5MWFnT1ZFWFZMR3RCb21jS3U4MXBNQS9yVFM0ZUVHNVZiTy9vbHhG?=
 =?utf-8?B?WUpXcE5WaHE5YVVxRklZd0R1MTFvQ003Q1luWjc2TndmYzlSalRNaTlkUWhP?=
 =?utf-8?B?LzZtTkJLT0RGS3I5cHFoclVMdGp5Nk14VXl4all5U2p1OXRHWHQ0a2FoVVdk?=
 =?utf-8?B?eXdxQ1hocEg0S3cxZnBsays5bldtYmEvTmRUaTl5c0U3Z2NGNzhKbm9oMVhZ?=
 =?utf-8?B?TkI5UGtLZ01aSTVMRmtxaTVDV2dFZ2crN2E4UC9WbDg5czQwdzh3NW8wM1J0?=
 =?utf-8?B?MjRTT3NEMk5tdTBmR0k0blMxSTcxdjZoS3hianN5YW9CYTFMOHdkMUZUdEVI?=
 =?utf-8?B?cUZRNkExWk9DcnRLd0Y0N3FYdVNIWXRNQ2VnVFhpQkl0SkwwVE91bVdGbW56?=
 =?utf-8?B?NkF6cU53aTBPNEd2SHVnZXEwV2NycnpLWEk2YlVaZUh3eFlVMU9QMVcrTjBq?=
 =?utf-8?B?dGZ0ampaQnBJY3c1QWJOWFlnRVNVTXZIbnFUa01YcFFLdkorU29jaG9ZdU1O?=
 =?utf-8?B?S3V6cUV2TThRTXBRb2FsZXpiTkNXbXJpeExkZW9Idkt5QmhxL2xhT1J5aURK?=
 =?utf-8?B?YllkdXJZV2lHZ1dlTmt0K01FWTVzN09FbTZwV1dwQVJYWHpyM0ZtUHdOWENX?=
 =?utf-8?B?M0xuYnFVdHp2bmxGNmVCajZmOUt1U0MyNTNGUndLOGl4aFpkRHVhNmhtWG1x?=
 =?utf-8?B?YzFpOSsrdmR3Ti9ZbklkOWpXNjhyRlVzR1ZFQ1kwNmhNNjVvYTJnYlZ4dFow?=
 =?utf-8?B?QThGZmRBU25UUnpHY2t1TmhGRVN6USsvZEJvQm5reE1CUmd6c1ZCc0Q2Ykt0?=
 =?utf-8?B?bWJSVlFZTHhQcUdRbVVja0FmMi9ra3ZhOXhESTc5em0xMFhNZzhpUEJjYjRh?=
 =?utf-8?B?VVZPams2bWo2RXFPNlhCNVFwMUNzYWV2aU1TVUM2eTFXVE04L2pjUE9YNnRL?=
 =?utf-8?B?b0FHK29jWjdsWDJ5b1ZWYUpHQnkvVHd1NTBJN0srRlhHMlFvM3NlVHc2V1Iy?=
 =?utf-8?B?RDJEUHBhN1NPVGhIdDVFZDF4bC9oREFHY0czS1F3OVZObmhyWFJOWEJNK3Fu?=
 =?utf-8?B?MW1nQzZORFhud2lFWnFaUHJUM3VpbUZxSXhHYU5jbmZpZjZtV2ZDeUl3b0N6?=
 =?utf-8?B?OTBkM2JGQkxZcTloWGkyQzU4d3JuMS9yd3VXSENseVZMY0NyWk1uR2NwMUZT?=
 =?utf-8?Q?YLYLQc6nQbRna00sLizOp6EMt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd17f55a-1db3-47af-1b37-08daa7cd8ec1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 19:04:13.3687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E5JxX2UM5CgRwY+Oepj4u0XCnc+XaxH9UkeCYieRgSg6kJDN0nMfItcma5+ksIQv8roHFD0Yd8StOXlVavsu7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5682
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/22 12:37, Raju Rangoju wrote:
> On 10/6/2022 8:30 PM, Tom Lendacky wrote:
>> On 10/6/22 08:54, Raju Rangoju wrote:
>>> The current XGBE code assumes that offset 3 and 6 of EEPROM SFP DAC
>>> (passive) cables are NULL. It also assumes the offset 12 is in the
>>> range 0x64 to 0x68. However, some of the cables (the 5 meter and 7 meter
>>> molex passive cables have non-zero data at offset 3 and 6, also a value
>>> 0x78 at offset 12. So, fix the sfp compliance codes check to ignore
>>> those offsets. Also extend the macro XGBE_SFP_BASE_BR_10GBE range to 0x78.
>>
>> So are these cables going against the specification? Should they be 
>> quirks instead of changing the way code is currently operating? How many 
>> different cables have you found that do this?
>>
>> Why would a passive cable be setting any bit other than passive in byte 
>> 3? Why would byte 6 also have a non-zero value?
>>
>> As for the range, 0x78 puts the cable at 12gbps which kind of seems 
>> outside the normal range of what a 10gbps cable should be reporting.
>>
> 
> For the passive cables, the current SFP checks in driver are not expecting 
> any data at offset 3 and 6. Also, the offset 12 is expected to be in the 
> range 0x64 - 0x68. This was holding good for Fiber store cables so far. 
> However, the 5 and 7 meter Molex passive cables have non-zero data at 
> offset 3 and 6, and also a value 0x78 at offset 12.

The 0x64 - 0x68 BR range was holding well for the various passive cables 
that I tested with. What is the BR value for their other length cables?

> 
> Here is the feedback from cable Vendor when asked about the SFP standard 
> for passive cables:
> 
> "For DAC cables –The Ethernet code compliance code standard for passive 
> cabling, Offset 3 is “0x0” other offsets  4 and 5 - none of the standards 
> are applicable .

Ok, so it's not offset 3 that is the issue as none of the bits are set and 
won't trigger on the 10G Ethernet Compliance Codes.

> Offset 6 – refers to 1000base-cx which is supported .

Ok, that makes sense and argues for moving the passive check first, 
although the code doesn't support being able to switch to 1000Base-CX.


> For passive cable , there is no separate bit to define the compliance code 
> for 10G as per the SFF standard. Please modify your SW accordingly.
> "

This doesn't answer the question about the BR range. 0x78 seems excessive 
to me (12,000 mbps) and so I'm not sure what effect increasing the range 
will have in general vs restricting the change to just the vendor/part 
having the issue.

Thanks,
Tom

> 
>> I guess I'm not opposed to the ordering of the SFP checks (moving the 
>> passive check up as the first check), but the reasons seem odd, hence my 
>> question of whether this should be a quirk.
>>
>> Thanks,
>> Tom
>>
>>>
>>> Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
>>> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
>>> ---
>>>   drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 10 +++++-----
>>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c 
>>> b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>>> index 23fbd89a29df..0387e691be68 100644
>>> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>>> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>>> @@ -238,7 +238,7 @@ enum xgbe_sfp_speed {
>>>   #define XGBE_SFP_BASE_BR_1GBE_MIN        0x0a
>>>   #define XGBE_SFP_BASE_BR_1GBE_MAX        0x0d
>>>   #define XGBE_SFP_BASE_BR_10GBE_MIN        0x64
>>> -#define XGBE_SFP_BASE_BR_10GBE_MAX        0x68
>>> +#define XGBE_SFP_BASE_BR_10GBE_MAX        0x78
>>>   #define XGBE_SFP_BASE_CU_CABLE_LEN        18
>>> @@ -1151,7 +1151,10 @@ static void xgbe_phy_sfp_parse_eeprom(struct 
>>> xgbe_prv_data *pdata)
>>>       }
>>>       /* Determine the type of SFP */
>>> -    if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
>>> +    if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
>>> +        xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
>>> +        phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
>>> +    else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & 
>>> XGBE_SFP_BASE_10GBE_CC_SR)
>>>           phy_data->sfp_base = XGBE_SFP_BASE_10000_SR;
>>>       else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & 
>>> XGBE_SFP_BASE_10GBE_CC_LR)
>>>           phy_data->sfp_base = XGBE_SFP_BASE_10000_LR;
>>> @@ -1167,9 +1170,6 @@ static void xgbe_phy_sfp_parse_eeprom(struct 
>>> xgbe_prv_data *pdata)
>>>           phy_data->sfp_base = XGBE_SFP_BASE_1000_CX;
>>>       else if (sfp_base[XGBE_SFP_BASE_1GBE_CC] & XGBE_SFP_BASE_1GBE_CC_T)
>>>           phy_data->sfp_base = XGBE_SFP_BASE_1000_T;
>>> -    else if ((phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE) &&
>>> -         xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
>>> -        phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
>>>       switch (phy_data->sfp_base) {
>>>       case XGBE_SFP_BASE_1000_T:
