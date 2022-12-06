Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2F2644BC8
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiLFSdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiLFScg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:32:36 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2086.outbound.protection.outlook.com [40.107.223.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2630A42191
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 10:28:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4CvkQnLkN9AbpRj248nQkVEnro36JdmeFYzqJNQLmVm8i8FEiu54Ok2HRbIiiQGgQG8i7XDQA90KSJ4o6HJ8NWxrSMd6LFojBHprHxOZ6hcn56Rg5l2rJX4bT/xqCFrXwl5LJHkLFo66sftm7tKjpylGUdJykEQEjsVci/aIzcBcSlnMishg9JlWZIDrHzpOiChO85uymcGNrb/aLDn61uoh/vZvQlfzRf2sszIHCJPEz5BuAkAjzUO46yYVFXLA+yxAsC2p510pgec0+yb+C0jmhfoVuodJYLg7gVqoL/MHLmuyUSCqJv95ZTqQjL50StQrW7PGjCDFE5Mh4sOLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ss5s+LAltiyBj1k2ZxZiTvg3J31Ow0VMIElBxp1/qi0=;
 b=SOP4+8wmQF2VTG6O6jXkymqzJx/SR3VpeS4PPqon+s62xbyFbOA8krFBgsvQ4B4VnaERPo00BX2pX9WsbaiRSra/AWlULI6S4sHa+jpNxAn/Hz73R3RjZBL8h4qrc2Ys2vrpeYPyJ3x5c8p/T3D0rIjn0Rnx2vPvjVAc8O906INUBzdVIVIIYEW6hrXj82dxTcTFeiQ1uSvt4Bh2MoZGOUvvqI1GM7mNO/rDa5FMV7Juj1h8WZ50mLO7lb6xf3JUXSsKjHdzbI6aJrvvtbq5qZUHabmxOggzB5fKIM9TnkZVeI4Voy7cR7DEGGHzbcSlNDhxGEpLcF3F158GHoactg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ss5s+LAltiyBj1k2ZxZiTvg3J31Ow0VMIElBxp1/qi0=;
 b=O6UxAlpMzgu4S7DLa4N5t2POzWjLSYHe76fKoHmh8bowmAyCuYBYpG8PW4gA++7PhbX5gZ42IhcNlisWvfUtHN2bRBOP/GUT1JlXD0filzt3aAjuMyBj48O9+6LxF7fibJRJ8EZVeXcmoil4V868JdGIp487Cf5LOW8Q+A+VJMA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH7PR12MB5927.namprd12.prod.outlook.com (2603:10b6:510:1da::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Tue, 6 Dec 2022 18:28:36 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%7]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 18:28:36 +0000
Message-ID: <4bf5baa0-d0c7-7600-7d59-605dc6504fd0@amd.com>
Date:   Tue, 6 Dec 2022 10:28:33 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH net-next 2/2] devlink: add enable_migration parameter
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com
References: <20221205172627.44943-1-shannon.nelson@amd.com>
 <20221205172627.44943-3-shannon.nelson@amd.com> <Y48FrgEvbj21eIMS@nanopsycho>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <Y48FrgEvbj21eIMS@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:a03:217::7) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH7PR12MB5927:EE_
X-MS-Office365-Filtering-Correlation-Id: 653d3263-d9be-4688-c4d5-08dad7b7b04e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cO+8RovLTBYcN18e390IxQWNxm7rBMY4ZMZsi/4bG+DjOVCltWSyziZIT8Jy71A/hNmEYS9xhmHLu8K91a44pzwPPyCN7nmSPewo5KyJ/VtoxOMPCH+xm1ulfC6Wj2Z0JsAyAIa/MWuaWkvmGkattCqQ5FS4vZDr21FtNVub8Kug+gu0ek54/X+Pxo4WoG8le+wiez5uOXaPxZqnzmBDuAjI8wzmpsIkvuHmqtYBUVopBBVKCNT3wWch8esnt4m0+ucJzZlSw69q+gg72RkywZUMz39kDjnktGP8RQYwBBxFIqTSCNeUuqtwLeU12wCgnqFn+fSYI3TEjNh2sIrJHUH11H9M0yP92hXKyN2n4QdKDxyhHbyXfVRx7NgHRiVAwZmx2PDrFcuviTcK4LhjOfKEAmQQ0421A3NtLHq8r8a6T6m8RotAo6sqPlDSgMs8nQFIhYaOQIl3sU6jdBWqZXbzgZyQtbStGiRWFlpzBkMgRkxRkKQNrDPPvSK1wFyuIs419roHX+my3YX0onFgDRqdcPrKeElOVJpIerVkGEdY7LqWXSLZYQMr3hAaJt+Z/ZqTxec1TNd4rYzFqlWmYMBnt62YQFTZ84ibrjrfcCVj2rVRlMamvO7ZX/p5p9rXoup5xgpYlqYJSjJSWtUq5AvfB6MUlwR3FT/RhCPqdQK9rEeVZeVTxheSrqic9ulS/bJhEOu0g2VCFMhGvyRIO9WF9iIStc7oLXNRs05GTQcCzIdTyeFT59bEWZJHURP7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(136003)(346002)(396003)(451199015)(31686004)(66556008)(66476007)(66946007)(478600001)(8676002)(4326008)(38100700002)(6666004)(6486002)(966005)(2906002)(6512007)(186003)(26005)(31696002)(86362001)(6916009)(6506007)(83380400001)(53546011)(8936002)(5660300002)(36756003)(41300700001)(2616005)(316002)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGM2NG1lYmxrb2pTUmVsU2VBRW9TOHcwUG9ZNTU5MTRmdUVPOHpkWXlUalhU?=
 =?utf-8?B?UlcyaUR6bnRpbTF1K2Z2OHA5V3E1c1VXSlViRmRGcVRHb0NQLzQvVytCdHZz?=
 =?utf-8?B?cXduYm5KSW9tQ3hhWkdDS25wc0s4eWp1cE42K0t5YUxJeHd6WWczOGhYWk4w?=
 =?utf-8?B?TjA4SVhyWkp5SjdRa1h0WWJhTnV5Z3R4NlBHQm9mQ2RJS1VtNjBqNzU1TTF2?=
 =?utf-8?B?YkFlS2JwejdZQ1NETWdGL1lhd29ab3IvQUZVUUozR2VENm10VjAxMFBTQTZ0?=
 =?utf-8?B?VXBvYTZKQ29pM0wyckU3cU91ZlNQblp3MERiQ2piTTVOd0g3bm9EY1BpSno1?=
 =?utf-8?B?NXN6K29acXVhdmovcXpCWEk5dW5rRXhHQld1U3R5RkhTV25PUlhlbzNaSE1t?=
 =?utf-8?B?dzZRNlNNVU9LWUlSSEphZ21NSEhvWTBVR3l2Q2ZEeFZXbmdPMkFaQzU4MjEx?=
 =?utf-8?B?b0ZFVHlPY0JCSGNjN040bDFYeDRQL1V5VEZWRXNaaENjdjZWSEs3bFZZaW1H?=
 =?utf-8?B?TUtMWHdnL0R0SjFWRkt1RURuM1U5WHg2djNNTWpMSGNtcTBoN3JCYS9BclNv?=
 =?utf-8?B?dy94MDRTb3Z2UG13S2dNQi9Xa1pISTkxSG1tQ1lvQ1IrRE50RFFhYnB0c0pu?=
 =?utf-8?B?b21rR3hNYUhwTzY0MDVBZ2k2Wk9iekcvSnZSUnRMRUV3WVRiYXhpaGJtVmdR?=
 =?utf-8?B?QUFnbU56MHF4U2NkcWVRNVA5RzZKbXdDNVRIN1orNUJ4SmNVd1YzMnhGMVJn?=
 =?utf-8?B?VThUUWRmQ3pzQVRPcEhGdjJ6cDhta3JXc1JjQnpKYVNMbDdzRHRMS2xYcU02?=
 =?utf-8?B?OGlRN3lXVEt0NjFOL050SHNId1B6KzVnUjZ6MjJEdnVJZWVSVHFoN3dLbUx1?=
 =?utf-8?B?RmJrZUdHTXE0SmtEc0Y2aGFpTDlNeFRLdGQxSlF5UFNONlNXaGNYblladkJC?=
 =?utf-8?B?bVRkdHUzK2NRbjV0VDFkRkJ6N2VnTHVBTWlGWWZLVGZNRGlhQW9RY2d3OGwy?=
 =?utf-8?B?RDJzSEVjU0RFSXdOSXd2ZndzYkJEZ0ljVGlxdVh5QXZ6V25qRmw1WFlKeStP?=
 =?utf-8?B?YUhKOTZuMHBYeENCeFRQTDkvSC9CVlU3c3ZBMzVxRllQOTBvR1FaY2EzWTdr?=
 =?utf-8?B?TDRNQjN5MjhzMGNJUDNzTFNjRlNuVi9xeXdMUlFoa1Z2dkdIdURMN3pIUUl6?=
 =?utf-8?B?Z09TbWFvL0pacWVIazNYYXlaL29WN2pRWHprUGduUE11MFpXc3ZGRnd3LzBi?=
 =?utf-8?B?RWVyY3lSK29lWFo3WHZqZU50eEZUNkJ0Q2sxVTRZeWJKM29LaUpzWTVWNW9U?=
 =?utf-8?B?bGNJYVZBMTF3Z2RMWlNqMlJZNm8yWndjTjhJRlpwbE5FNk5MKzQ1MElhSEM2?=
 =?utf-8?B?Q3dwSjZKYjAzR1BzRk40Y0lpdGdJK2Y4Wmsvd25TaHBOU2J4MFJyY21xOE1Q?=
 =?utf-8?B?YUQrTi9UelJZR0p4aDUzdFZDMXhLQ1R6cFphMlMyYTlpVkgwZmV3OFd4VjhF?=
 =?utf-8?B?by9aaFpJLzgrQlFNT0s0N2VmMDA1ZHhYdmtNMjFPcFhEWk1xY3RqL29KN0xQ?=
 =?utf-8?B?YlZSYVBtanh2RXBlSEpSUlFrNmpTNldoZ28yQWEySEJUQ1JzblVHWG1TZ2tq?=
 =?utf-8?B?V2NmWCtvbFJnYlIrV01NTm5yUjB5dlpLRFBLMGF2OHhnN3Q2YjNmTjlmSnpi?=
 =?utf-8?B?NG1nV2tjSXNMOE80eW5YSTkzOWMvb21uNVk1OU9yZ0NlbVEyaktISlNyVC9v?=
 =?utf-8?B?TXdBL21oV2NycXM1SlBadzlQWEpwVXdIeGJIVnF2a3BGcGFBNzEwd0tlbmV2?=
 =?utf-8?B?QzBYN1Y0NTllNHoreEh6MHFxNVN4WHQyTlNucHVXTE9MaElwS2hySXRZTktp?=
 =?utf-8?B?RGpnS1pGbWJTRUcwWTVRa09DL1IwR3I3ejI4dENZUVJpQ3F1WTRyeUhSSG5r?=
 =?utf-8?B?VjRFeGxtd1ZORHo5RU96MHJGb2hPUkcxdEdleDZXRzVHanAyeHMyMG1jYnVn?=
 =?utf-8?B?cENiWmRTL0xZZGt5eWN6dytWcERrTlRVUFE4ck1SZjluRzU2ZWg4QS96OXdS?=
 =?utf-8?B?ZW12RFdXNzlyRlBqQjRid015Mzh2OG9DRnFDZTIvVXR6ZWloeUkvNXdvaTlw?=
 =?utf-8?Q?70Bx19itCtd271lWpyPKi8AC+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 653d3263-d9be-4688-c4d5-08dad7b7b04e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 18:28:36.4692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ts4lSPKEQLhIS0j3UyuzCuC/71isFooWirG9OdAHAXLj+qhuCJTLCTh3AFrOcma0fnu2N37zfgVvzQjUm6hUWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5927
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/22 1:04 AM, Jiri Pirko wrote:
> Mon, Dec 05, 2022 at 06:26:27PM CET, shannon.nelson@amd.com wrote:
>> To go along with existing enable_eth, enable_roce,
>> enable_vnet, etc., we add an enable_migration parameter.
> 
> In the patch description, you should be alwyas imperative to the
> codebase. Tell it what to do, don't describe what you (plural) do :)

This will be better described when rolled up in the pds_core patchset.

> 
> 
>>
>> This follows from the discussion of this RFC patch
>> https://lore.kernel.org/netdev/20221118225656.48309-11-snelson@pensando.io/
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>> Documentation/networking/devlink/devlink-params.rst | 4 ++++
>> include/net/devlink.h                               | 4 ++++
>> net/core/devlink.c                                  | 5 +++++
>> 3 files changed, 13 insertions(+)
>>
>> diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
>> index ed62c8a92f17..c56caad32a7c 100644
>> --- a/Documentation/networking/devlink/devlink-params.rst
>> +++ b/Documentation/networking/devlink/devlink-params.rst
>> @@ -141,3 +141,7 @@ own name.
>>       - u8
>>       - In a multi-bank flash device, select the FW memory bank to be
>>         loaded from on the next device boot/reset.
>> +   * - ``enable_migration``
>> +     - Boolean
>> +     - When enabled, the device driver will instantiate a live migration
>> +       specific auxiliary device of the devlink device.
> 
> Devlink has not notion of auxdev. Use objects and terms relevant to
> devlink please.
> 
> I don't really understand what is the semantics of this param at all.

Perhaps we need to update the existing descriptions for enable_eth, 
enable_vnet, etc, as well?  Probably none of them should mention the aux 
device, tho' I know they all came in together after a long discussion.

I'll work this to be more generic to the result and not the underlying 
specifics of how.

sln

> 
> 
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index 8a1430196980..1d35056a558d 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -511,6 +511,7 @@ enum devlink_param_generic_id {
>>        DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
>>        DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
>>        DEVLINK_PARAM_GENERIC_ID_FW_BANK,
>> +      DEVLINK_PARAM_GENERIC_ID_ENABLE_MIGRATION,
>>
>>        /* add new param generic ids above here*/
>>        __DEVLINK_PARAM_GENERIC_ID_MAX,
>> @@ -572,6 +573,9 @@ enum devlink_param_generic_id {
>> #define DEVLINK_PARAM_GENERIC_FW_BANK_NAME "fw_bank"
>> #define DEVLINK_PARAM_GENERIC_FW_BANK_TYPE DEVLINK_PARAM_TYPE_U8
>>
>> +#define DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_NAME "enable_migration"
>> +#define DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_TYPE DEVLINK_PARAM_TYPE_BOOL
>> +
>> #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)    \
>> {                                                                     \
>>        .id = DEVLINK_PARAM_GENERIC_ID_##_id,                           \
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 6872d678be5b..0e32a4fe7a66 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -5236,6 +5236,11 @@ static const struct devlink_param devlink_param_generic[] = {
>>                .name = DEVLINK_PARAM_GENERIC_FW_BANK_NAME,
>>                .type = DEVLINK_PARAM_GENERIC_FW_BANK_TYPE,
>>        },
>> +      {
>> +              .id = DEVLINK_PARAM_GENERIC_ID_ENABLE_MIGRATION,
>> +              .name = DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_NAME,
>> +              .type = DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_TYPE,
>> +      },
>> };
>>
>> static int devlink_param_generic_verify(const struct devlink_param *param)
>> --
>> 2.17.1
>>
