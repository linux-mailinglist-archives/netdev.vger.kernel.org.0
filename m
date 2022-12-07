Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFB96461B8
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 20:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiLGTaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 14:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLGTaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 14:30:04 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAD6286E3
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 11:30:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UGU6RqiuxhYumQlh6WlpXD5iZnOnqqrKvSxve34rEPhxh5gu8Weeht7Y4czpWZcUcF38nRn48TECEFDifI4u4JCNG2JiV3gS8ITG2CKu6ONixp4bs5Yv8+kHpSU2R0dhYLr8xBx5jU3HoX9fjcWD2HelHUVHeVHTBvFgQX6VPH2xZktBr0jfzzkMRvGxpNw3tI4BbVf8PmJcNmosG2aXZuaex9MzanNdlDEJZjpsq8TVgFmMc+7xQ8fFCKYKii7bqIVv/cprIYwxzxBlO8RcVFtDVYWxHfUGM1d7F3xXCpP/r9bxsK7jDsgQHJMe0q+sEGFZkBzcdOQFPUhvEl0F7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XEfBy8VlciSk734lUJUarX9egocBgZT+jzRoKLN+aV4=;
 b=lj4GvB9pZj6UlAIi1LJffLmN/gsXVD8JorBoVSF4BIb3MV4/hPNqzzvkDGhHLdc4JSZRzCNe97CczPX1OBKJKzgN63ykh5RcIoj5KuJD48Qej9zQEwR5LOVDF5v8NxRGtB1ZL2TFUcMaCrvfmzUolOa1JyRB4Aru7XPzlTqGDfS7SHFAdcsiQaLB1KamaupFKplw9vw0hlnJ9UKnAnr+cTsqsmLvlAcKn0haiti4IuKJ5A31svLrX1/eClRFNH17fCqISziqXgWkD75JWVXYmQy1t1wsaQsWSyWovM6b/Cr0IL1AYQbcWij+OodtGqCPrKSb8ouR8XwEZtcc0BTukA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEfBy8VlciSk734lUJUarX9egocBgZT+jzRoKLN+aV4=;
 b=KFVGRtF3Is8NbyhhRwuwUNsCTSKmqrYdIhSjt5Q5njP7deK0T6mtin3ksidgi+HzJNrwUWJSnLyhvaLXLpMusa8wW1LNoEUrJ3t36GM54QsxY6nPp9m5hrWdWUVUZ1OoEErpPz05NrMIiSnGFQRJeW51Ij2N5e9IHp9r+9KG+j0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 SJ1PR12MB6196.namprd12.prod.outlook.com (2603:10b6:a03:456::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Wed, 7 Dec 2022 19:30:00 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%7]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 19:30:00 +0000
Message-ID: <7206bdc8-8d45-5e2d-f84d-d741deb6073e@amd.com>
Date:   Wed, 7 Dec 2022 11:29:58 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH net-next 1/2] devlink: add fw bank select parameter
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com
References: <20221205172627.44943-1-shannon.nelson@amd.com>
 <20221205172627.44943-2-shannon.nelson@amd.com>
 <20221206174136.19af0e7e@kernel.org>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20221206174136.19af0e7e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::25) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|SJ1PR12MB6196:EE_
X-MS-Office365-Filtering-Correlation-Id: c0f162eb-cb03-40ff-b82c-08dad8896e8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ezsfkOKdTrv/Pi2u0wMITd+c7+nDxw46Ee2/TDdqx3zjwO1deikyDcn0zDoJ+GztRJqewlJ2eUeemm3FKvp5Vdcf2bbC6xAX/nfJZIaBM734QUWGrGqRwsLXBxR7WGc4L54E5QYgsSOkC90DlWZDF/I5jhctS0/sqNcEPE+QCtQOmvsGcwBEXTddO5py2eeUMdS7EsxlJyZ4vwvhm8WIgl3ewF4v0mWppyUEFXlES6q1+SFoVE4Hu4eaR/LEStlbhI4yP6AbMLUUdQ4asgc8DmtWyi478zny4FvR2HVUgFTA1TJ7zBC6fPaRs4DbBgigKM7RMWl7MjbKtHsrUz1Vd5qsWPZ2BGB308/+afRf3g1B8jfZi9/JCMAIoUD/TmxiwVK3tjs7I0ZdroymNXkkJb8nQp728afPVXLBU2X9t32pUuh8Ds36Ccym4UCrsf4WtNUJGN1dfTYMegt7tLjQuqvjwFityKimf2odT+2QiGWr1/VXV2l6w6puEfT8ih3ivKUsKhOcpBA4HLGo8Pp+QtTYEQoUkmKu5FxHNuTstdB1uWdclS87+HmV2OrslH6cnNQjuCQKuejVEVwariWED2n2nj6KHKDnB6XP8txeg4gfnHRlR/5YlZUjW8rifBqFGySxUrmUE8q07DrlKdCgeH8pfq5YJhfojgi7Grdst1CKvfvkLfDYc8PGkGBqGUgDr4Z+DNBoqxSRiSwHMqhYrC6OHKAPVlel4+j0zdddpLYhXQ1bRsfKseJ0W9hH+mjyo0cbbnVQWzlO05WavBntexaowIhfh5rhiGTqoyildrE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(346002)(366004)(396003)(451199015)(5660300002)(83380400001)(53546011)(15650500001)(44832011)(2906002)(6916009)(6506007)(2616005)(316002)(66946007)(66476007)(66556008)(8676002)(8936002)(4326008)(36756003)(26005)(186003)(45080400002)(86362001)(6512007)(41300700001)(31696002)(478600001)(31686004)(38100700002)(966005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1BDNGxBTFc0enNmclQzOGxKN1NtMGdkYXpiODd2Z0dwNmg5UlhYYzcwNlcy?=
 =?utf-8?B?VFRha202RnRTK1NNdWdDYXFYbUtmMU9IZFBYeVlIMFVGaG9QeGxlTExuY0lC?=
 =?utf-8?B?YXJlM1ROc3JWZU41ZHVReTJvY3RYK1dIclBqNEN3NjFkWllxZmpDR0tiYXJD?=
 =?utf-8?B?TERSTnJXb1g2U1hEakpHcGFRdTN5V0o1WnJ0NWVvTDAzOVNzYjl6OWpSMWRD?=
 =?utf-8?B?N1U4dEZ0R2VIVjl2eWptSVEvNXZkdUlZTDRUSTduaVJaTkkwL2h0NUtoMXdP?=
 =?utf-8?B?N2c4b2RMY1NQOHI0WEQrdWg2a2lZcUZNaFNuWEVGYzUvL3c1Y1JGYngvS3JX?=
 =?utf-8?B?ZUdBOVdXbXBJNFQzYU05S2REQ0xYZklrWTJqdnVwa2dKbWExQ1J1N2NPUkhr?=
 =?utf-8?B?Wk13NUtDYnJCVzlud1U5M2ZZQmJXOE1EOUEvbW9DQ3ljQkhFYnV1WEMvQ252?=
 =?utf-8?B?b2lkR1dDTkxQU3FkTEtVV0ZWdEtYdElXTkg4Yzh1WkN3UWpuVlh0dUU5UzFZ?=
 =?utf-8?B?UmFjc2l5QWs2VzM2NlBaVzIxSjZFa3NPT0EvbGY3NHZ4UVNOSUdJY01XNkFs?=
 =?utf-8?B?QkRXZ0t5YUpLMzk2OVRSN25JVUNvK2xTVXJ2VDhuTFJyRERtaDFuUFp6OVJo?=
 =?utf-8?B?VVlGZVQrdlhiUXpmTUZxL1JDTFlKYXFwdzRpK0dmQXVQcVExS2dpQUtKZS9Z?=
 =?utf-8?B?TEZXZmxMT2o3ZkJZU3FiSnp3TVFKQThDSzllNlErL0pFeUc3aGtTajRyQVVD?=
 =?utf-8?B?SjlmZ2J6SmJoOEJLYkJDalFPeUFEc2lPL0hkdFFDbUU3aW1qSExIalVQajJt?=
 =?utf-8?B?d2s2NVhzcWF5bXdSWUo2Sm55Rkg2cDVYcjF5YnduZDIwREN0cXZ0T1hycDJy?=
 =?utf-8?B?bGtFMWFvWU0vUWJvRWNiRjYvZEFxb2tvTHJjUTlGNkJHMlRBb1ZiRW9LUzht?=
 =?utf-8?B?ZHU0NEU5NFZPZTc0ZmZ5MURZdDN5US8zcGUyWklod1NHblRMWlV2VVZnRUJq?=
 =?utf-8?B?QUZJRVk1SnAyMnV5aGRUUFkzVEt1eUJYWEdLaWU0dlFlcnQ2ZnJZaXBzMkE1?=
 =?utf-8?B?N2xEQUgrVUkwdXlLV0xoM0dUTTlIQzhYYzJHd1pkVFcwTDF5dVBxMXRQQ2pu?=
 =?utf-8?B?Y3JqRkkvamEySWZuTmtIY1BNWDU3VjZybUQ2UVdkc3hOVHhFckJTSjNLT1Fr?=
 =?utf-8?B?L3VtQ0FiT3hUZDBtNmx4UjZ5eTd2cVNYdWhENi94VUQ2NzBXOXZjQUYyMEdV?=
 =?utf-8?B?TzA1SWF6Uld5OHlPbU5BdS93bjZrSERzMlZNemp1VWFOVWNJVzVwV25DeFJB?=
 =?utf-8?B?L2VYME5oYTNzbmw5MmZ1MXBQSG0yZmQ1VFZRNzA5OU54K2FHd1dTQTFxZWlN?=
 =?utf-8?B?ZFZEUjhldTNwYjhQM1ZXczRMbVZPZ0phVWJtSTE3NFlXME1KRXV0ZkJWUi9q?=
 =?utf-8?B?VVJsQVVzSlZabzlVLzRFM0ZrZlJuVkg4ZjNXK3Q2ejNKZHd6MEZaaGpVZ3B4?=
 =?utf-8?B?bXVBUUhqOHlSU1VtWUdzZUdoZnJBVFZzNlE5cjl3SXJjYzJYa2h3ZnVVeGY3?=
 =?utf-8?B?VGU0dzEybWsxSHliTHZMN2tTbmNWa3FoaU83Nm9aWC90bWRhd1RhNXpOYkhZ?=
 =?utf-8?B?dFlSZ0RQT2VnUUJkbzFLQUpoMFRnM0lIU0VXQ09DU2lRc29TSmtQemw2SnM3?=
 =?utf-8?B?ZnZUY05HakcycXIwZjVmR3F1dmNDbUdoemlqaW9Ka0Jqa2h1TFJ2WkdEdHd0?=
 =?utf-8?B?WmtLZjlTQUlxdFBNK3hydjdVYTJoSkdvb1pEMTVkYkxHY1Rib0twczBRNDlZ?=
 =?utf-8?B?d2pRRXNFRlc3bGhkSkZ1blRBM2d2UGpvTjF4Rko5ZEtBcU9OZUVzckdxMUlP?=
 =?utf-8?B?SnQ2TDRCU1VibC80QzhiaW9SanozaEUvUGJBVWc0emV2RmJhY1NnVEt1RDhs?=
 =?utf-8?B?KzB1UUpSZVVXUVl0OFNRL2FrNFBZdHIxNldUYjhKY0xsa0NtMmR0V0w4TDZD?=
 =?utf-8?B?dThiZkJrMXJYejNRWCtxaklaRVZQaGgwUFN2VzZNS282V2c1QldsZTlNeWJp?=
 =?utf-8?B?RGJGajN1VHppWnRCakZSZEF4RW1JVGV3T05ZV0pCOHhGcDFNU3FYeEpZL2NH?=
 =?utf-8?Q?py+EVUQAPtto8OLLlZlDLM+8p?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0f162eb-cb03-40ff-b82c-08dad8896e8f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 19:30:00.4940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uq34GNLeh8zWGc8+wDQguXbN8FqBjAzGHrSTLnhjDmxaalQ3PN4iYmpCcfrXW3k9x7Kd4wD+jxWMLeAYoljDRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6196
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/22 5:41 PM, Jakub Kicinski wrote:
 > On Mon, 5 Dec 2022 09:26:26 -0800 Shannon Nelson wrote:
 >> Some devices have multiple memory banks that can be used to
 >> hold various firmware versions that can be chosen for booting.
 >> This can be used in addition to or along with the FW_LOAD_POLICY
 >> parameter, depending on the capabilities of the particular
 >> device.
 >>
 >> This is a parameter suggested by Jake in
 >> 
https://lore.kernel.org/netdev/CO1PR11MB508942BE965E63893DE9B86AD6129@CO1PR11MB5089.namprd11.prod.outlook.com/
 >
 > Can we make this netlink attributes?
To be sure, you are talking about defining new values in enum 
devlink_attr, right?  Perhaps something like
     DEVLINK_ATTR_INFO_VERSION_BANK   /* u32 */
to go along with _VERSION_NAME and _VERSION_VALUE for each item under 
running and stored?

Does u32 make sense here or should it be a string?

Or do we really need another value here, perhaps we should use the 
existing _VERSION_NAME to display the bank?  This is what is essentially 
happening in the current ionic and this proposed pds_core output, but 
without the concept of bank numbers:
       running:
         fw 1.58.0-6
       stored:
         fw.goldfw 1.51.0-3
         fw.mainfwa 1.58.0-6
         fw.mainfwb 1.56.0-47-24-g651edb94cbe

With (optional?) bank numbers, it might look like
       running:
         1 fw 1.58.0-6
       stored:
         0 fw.goldfw 1.51.0-3
         1 fw.mainfwa 1.58.0-6
         2 fw.mainfwb 1.56.0-47-24-g651edb94cbe

Is this reasonable?

 >
 > What is the flow that you have in mind end to end (user actions)?
 > I think we should document that, by which I mean extend the pseudo
 > code here:
 >
 > 
https://docs.kernel.org/next/networking/devlink/devlink-flash.html#firmware-version-management
 >
 > I expect we need to define the behavior such that the user can ignore
 > the banks by default and get the right behavior.
 >
 > Let's define
 >   - current bank - the bank from which the currently running image has
 >     been loaded
I'm not sure this is any more information than what we already have as 
"running" if we add the bank prefix.

 >   - active bank - the bank selected for next boot
Can there be multiple active banks?  I can imagine a device that has FW 
partitioned into multiple banks, and brings in a small set of them for a 
full runtime.

 >   - next bank - current bank + 1 mod count
Next bank for what?  This seems easy to confuse between next bank to 
boot and next bank to flash.  Is this something that needs to be 
displayed to the user?

 >
 > If we want to keep backward compat - if no bank specified for flashing:
 >   - we flash to "next bank"
 >   - if flashing is successful we switch "active bank" to "next bank"
 > not that multiple flashing operations without activation/reboot will
 > result in overwriting the same "next bank" preventing us from flashing
 > multiple banks without trying if they work..
I think this is a nice guideline, but I'm not sure all physical devices 
will work this way.

 >
 > "stored" versions in devlink info display the versions for "active bank"
 > while running display running (i.e. in RAM, not in the banks!)>
 > In terms of modifications to the algo in documentation:
 >   - the check for "stored" versions check should be changed to an while
 >     loop that iterates over all banks
 >   - flashing can actually depend on the defaults as described above so
 >     no change
 >
 > We can expose the "current" and "active" bank as netlink attrs in dev
 > info.
How about a new info item
     DEVLINK_ATTR_INFO_ACTIVE_BANK
which would need a new api function something like
     devlink_info_active_bank_put()

Again, with the existing "running" attribute, maybe we don't need to add 
a "current"?

sln

