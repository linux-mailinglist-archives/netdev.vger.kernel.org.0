Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A8A63B4C6
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 23:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiK1WZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 17:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiK1WZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 17:25:54 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCB92F641
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 14:25:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UYqlVOLLnvFZRwx7qbyJ3zHVMuCEs1yIh1F+TKvoqOEjrrZODYjVyCT52SDoUl1S1YhvEC08I0ysDJW+vIJAM48S9qaZOF8c9jiAcC6uoWBpHQZbOzr8/kcPIPv9YL+5oByPWvs2I1SWy9/xkMMzKPmkOvmO7viqRIXUTrJG7k9a6PvsYmrS7DWpKZMHYd6CjygwkeKjYxG1YHKukS5q7B90WvAQPw0V62FxWj128jm05jxRhSVjUI1t4s8j7/kRqaxzFirHlumE+iOfnv9OhYdM8bCRFmE9irsHXf/cQTRV/07Xxjt5w9Iuzh4/W56jQLfrVW2oYEDnxaiLMbgbHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ICnAL5j+EwW9DQhupRRXyaO3BvmrZyqWEaJ33m3dIz4=;
 b=X/7LtMs9uFmPMMZ+wlBQOqIJftOsNrY4SzK1Va9rTZipuE/OtVyRcPBGHDhY9GV37x8BUp4C6UNEjyg0yMq8WUiF0zt6bVxiL8Ktze+R66kZpEDgoSPlTiOBU/l+smLCP3sT2AelRZo+DIIuD9rNZmeHh/KFpKwl56M3ym0bD8Ru2Mkbgslj4iCkXqcVFXiJTqvMds/JdNlrMopmr0E70isa9syDjXbYcX+dU6kCMYU3AaGMxb14XmZ3Crd3CYA9DvoUJngHPPaNN8hd4yjI2oyk3z96PueB1mWn5U7wUtW0TKok68tIfW30eMYPF5NcVBd1yKI3YBvP2IAQ0NaL7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ICnAL5j+EwW9DQhupRRXyaO3BvmrZyqWEaJ33m3dIz4=;
 b=iC2eZfcu2uHmIIOkVm/lmKGqb97HztpxFMdmeUUgTtLQXz1twQ7vS7sUixoMyLq4fW+HILK7nG1bcQqrcqKUwlI8JTZmgE/D6quU27i7ubfY9ulvqqx68x+/ARMBVbNZg/rSy/KtpXIUIDG1l4cba520m/RcFCtJZASMnzsnIF8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CH2PR12MB4924.namprd12.prod.outlook.com (2603:10b6:610:6b::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Mon, 28 Nov 2022 22:25:49 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 22:25:49 +0000
Message-ID: <11905a1a-4559-1e44-59ea-3a02f924419b@amd.com>
Date:   Mon, 28 Nov 2022 14:25:46 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [RFC PATCH net-next 06/19] pds_core: add FW update feature to
 devlink
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        drivers@pensando.io
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-7-snelson@pensando.io>
 <20221128102709.444e3724@kernel.org>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <20221128102709.444e3724@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0031.namprd13.prod.outlook.com
 (2603:10b6:a03:180::44) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CH2PR12MB4924:EE_
X-MS-Office365-Filtering-Correlation-Id: 503fa52a-ad45-4da2-6442-08dad18f8050
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BNKdFmmgDJgqHQQxuLxb6BetzXg61u7fqM4gDvX+lCQbTa6SQbIGNrJ0baKf/JlUX33EzKvhCOpQI5EkwlcUcnn72aGjWuDVVcIUfSBsGjyJrrWYTtD5LZAY7s4H12NhLJRdJ2xjsyfVI3BalF+VrjfxWGrgbMWynJqnq7b+QwNEYppoJRHoOpb6TnBmeDwqns8P9u3J5pSTdT+ZepYlhIQMZHx8nPfjAk6mhqOmY7mrmu3HbKoubzs9wNSE9EH6PIBYYnDqba+/2LBhj6OxL6RRO/GU6FrdNKHd/gdDcCP33BRnZ/7AsPs3fp3e148d3cfUjm+JqYWDWg74k5li7NaYRfO+YtDqcA3YqgHcXnbCZVTzL8+GUX3WLfVPc08xpA98h0uJ2cbWwAN4as6nf+tzub4m6/Q66TZX7inSKMKiR92yqIWmg8deIpTmX9l1SUW0IruGzMOo/DNqfJ94HssmctqRr4srU3AFkDqqQWRcwmm1Glk+4kFYXgdIr2ILTO6jf9SCPifJ/mtjAcoC3UMsZNwD66HGh/d+1zeAWSgd0XQjLyUCs0BTB17z2VoPrZN2ToD5ICzqIyI8UASghztZln/BUrIgQpTGvCoKW0fFbDl7wrz1cy6hE+b773nuU8hlCJbPPtTPbFxcckOMMdK8Ke4Nx8ogVCgCor08uN6Z51ZODYEFwYy4xFuGcHFFapgTTNvfdp7lDUKT3ZH5UG+3RE3Kr9+yczDxk61wpFY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(366004)(376002)(39860400002)(396003)(451199015)(5660300002)(31686004)(66556008)(66476007)(4326008)(8676002)(8936002)(41300700001)(110136005)(66946007)(6486002)(36756003)(2906002)(15650500001)(316002)(478600001)(31696002)(6512007)(53546011)(26005)(6506007)(186003)(2616005)(83380400001)(6666004)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TytzdnRHUjZzOVUyUlVVSFo3SW80L3M2MkRvT05ncGk3STd6aWpwelNTcVRM?=
 =?utf-8?B?OG5BVWJqWGZuQnhjV0RpU0ZmbkhUVWl0Tjc2V1loWlZRSUFmeUpGY2JTcDAy?=
 =?utf-8?B?cmM1NUc1Zm1rL25mZFhNZ2hkZTg1V1g3Q2F0L0krUDBlZ1BFOFNrcDRndHVG?=
 =?utf-8?B?cUpQc00xdTgybFJLU1hjZ1h0UHNWc0p3a0lqUWFYbW01d3RDeFhUay9mYzRR?=
 =?utf-8?B?MjNPNGlkS2cwcFdqVjk1ejBwbVZuYUZkeDZ2aXdXRzNjYnhxcHZhTHNnYjFG?=
 =?utf-8?B?dEE4N1pCL25Od05NWFBkNUZWMXJLT2RJZjA4UFRMbVNvQ055NjhQUStORXd4?=
 =?utf-8?B?bHNoaWswc0VmSnN5NXJYNWkyK3RQN0JJb1J0MnFYUld0L3ROZ1U0TnZRS2cr?=
 =?utf-8?B?N01LSnhURmxKZWlGZ0xYbmYrbU9XYnRZVlFOa0Z6V0ZKYnAvUE13cjhocXQ4?=
 =?utf-8?B?S09nRG1zQWNYN0twRkhldUdiaVMxT3hDZk1SNk9ONEJrVzQrbDhYZlBvc2k0?=
 =?utf-8?B?bkdLZkJqWHlobndkQVRvOE9CTkQrU0RpczVaRnI1UjFzK0ViclkzTmtIWHpZ?=
 =?utf-8?B?anlWNDRBRnlOQ201SWVJMngwa1MrT0hXWkc0UXZOTGQ1bE5nZ0VUdml4MmJo?=
 =?utf-8?B?SjJxQWxoUk5ZZW81RlJTQmRKYVEvZlR2SHNjWEtONkdWRjcxYWtXQnM1ZG1B?=
 =?utf-8?B?bG1SOHFoR2pJMUpHWmFpc3FrbVhaTEM4OXo1VXFiUTIyekU1TDJPOFhjc05j?=
 =?utf-8?B?STlrbDBOY3dQbytVRVdWeE9TOUFzeE13Q0w4cXRISVViNytzUVZzRHVlckJ3?=
 =?utf-8?B?RExoV1U3aFNXS0Iwdm1KWG5ReHhDRnlFNE5nUjA2SWw4MmFYdmE1UGtXVGJo?=
 =?utf-8?B?WHRra0dlNDN3aS8rOVVoZFk0YS9OQ3gyVjlFVVBTZDIvNXVlSXNGTXUvcjJZ?=
 =?utf-8?B?aUp1Q29UZDJZOXBxb3FOQmVVUHZ5bzdHQnZ5d3Z6b2M4T0VrRnNxSjduNDlZ?=
 =?utf-8?B?WjBubzRseWo4N3dQd0xkbnRibXY3Q0gxZERpdVNWUllLNmZnYUV0TGNsalAy?=
 =?utf-8?B?M0pOakR0Tjc3YTBUajFydUNEOHMxTGJnaWlPUFpxY2RTMlh4NHYwRjViMCtW?=
 =?utf-8?B?ei9lK0FkNCtISVhKemUrWTNJWFpyUzJvWU9ERXlJSWNoOFcyWSt0c1EvVTBh?=
 =?utf-8?B?VW5JQWRQRUJoWnpTMlRCb2tXZTA1dVlYeVg4dVp6WmJPdlE3SXFtcnB5eWgy?=
 =?utf-8?B?WG9aem42SFd6WGtsSWNuTXl0bnl3Zk03K0Z2aUtzaVEzMDV3M25vM28yRC9w?=
 =?utf-8?B?MmpKanBTNW91R0o5RG1LWmNrQTJOSnFKdFQ5bmZwWWhKcktPc3A1Zk0zcXN0?=
 =?utf-8?B?dXRlTHlTaFVWMTZjWkJPRG9kUlhEK3d0RmRoZTNuYUw2Vk5FK3BKNkYrSys2?=
 =?utf-8?B?bmsxcmxwSG0zN2Flclc3c251Vm94a0UzY2VDaml0RDh2R2FMVUVKaXVxbUU1?=
 =?utf-8?B?OVFwUkJpOHlEMnZ5Z0NXVlVlWUdYR0xLWlRqWXJDbFh6S2hCcUVkQ0xTSDF2?=
 =?utf-8?B?YStsSTRCendzbUhJN29KM3F4YUNBcytkaFVhbEFRVGpud3laMjFHWlJJNUtx?=
 =?utf-8?B?NjcxRk5BeFFkaXY0dU5QaG5paEhxS1VSNTJNZUdGWUN3NGJoa2lQLzRYbTRz?=
 =?utf-8?B?S01jcUpHSXp5WXNwa0J3OHVTSENPQ2RvYTZUTENWZkFzVnlLNitidGg3WXpI?=
 =?utf-8?B?Y2owUkp0NEZoQ0pvV2RIYTZaR0FJUUhFWmlpMkgxQnR4TllJL1JKUWtMU2F3?=
 =?utf-8?B?Nlpva3J2aVRHWGsxNW9RU0J5bG1qME1FV1lORFNkYXRoUGlrYXlrbnhJOEgw?=
 =?utf-8?B?SzdJZnlHVjVYaGtwZU82QWRiZFJsOGhkTUE1WUU4R3pldGpvNGYwZmFRTDB1?=
 =?utf-8?B?dmF1aWdYZ1pxR3NzNmpmRnByOHYvOTVOd0VJSTVCeWRiVVhDa2s3c28yV0VW?=
 =?utf-8?B?Vm9GMm5OcS9MeFVmUWZFcUdRM29lYmduSDRsMnRuSnN2T3VZSTg0N25tcmd4?=
 =?utf-8?B?OENkN0xIbjNvT0dYViszemY5R3VDUklrUFNmT3hoVnp4eUY0ZUtmZ3NUcVd1?=
 =?utf-8?Q?sGiOV/e3br2MsFXqCxs8cxgHE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 503fa52a-ad45-4da2-6442-08dad18f8050
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 22:25:49.1189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tzyHObT9Ro5NDXS8U6HSGTmy26dKUbxBh5kmOl0kXd8zTwpz3nZ845wYpdpGpKQykgb5zK+gdfpbS0sCsALK4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4924
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/22 10:27 AM, Jakub Kicinski wrote:
> On Fri, 18 Nov 2022 14:56:43 -0800 Shannon Nelson wrote:
>> Add in the support for doing firmware updates, and for selecting
>> the next firmware image to boot on, and tie them into the
>> devlink flash and parameter handling.  The FW flash is the same
>> as in the ionic driver.  However, this device has the ability
>> to report what is in the firmware slots on the device and
>> allows you to select the slot to use on the next device boot.
> 
> This is hardly vendor specific. Intel does a similar thing, IIUC.
> Please work on a common interface.

I don't think Intel selects which FW image to boot, but it looks like 
mlxsw and nfp use the PARAM_GENERIC_FW_LOAD_POLICY to select between 
DRIVER, FLASH, or DISK.  Shall I add a couple of generic SLOT_x items to 
the enum devlink_param_fw_load_policy_value and use this API?  For example:

	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_SLOT_0,
	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_SLOT_1,
	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_SLOT_2,
	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_SLOT_3,

I could then modify the devlink dev info printed to refer to fw_slot_0, 
fw.slot_1, and fw.slot_2 instead of our vendor specific names.

Cheers,
sln
