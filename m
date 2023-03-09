Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20CD26B3086
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 23:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjCIWZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 17:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjCIWZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 17:25:52 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2063.outbound.protection.outlook.com [40.107.102.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A706D62855
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 14:25:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVwK0jA2CI30lr73IZpQvWpRYr9RiPsavh3BJmwfKRq/PyQhTJmLW0NxxW651VwsWLoH2sD3BY7lFYXkbnufnXj6o5Q3rZ7vFBptR7z1CcEgU367Styk8oaJUF//Tc/Onk/jVH1HS4VPtKRAS/EVera+V9vYbwqcXVb4s7AaTuf1A8YILqvq302YIYh83DzmNXZFHOUVwC7nT557pJWL7EGXTQyhtD/CPZ6R/cgA8j5GPe7Q0jMcLVqXRaejVZ3HESNqhQXljf17ggPZkK/vmhM4BYh9OL2itfcnnBxU2IDiwEjKWZTAWXyFlDsFVPtM3YZsslTNXlCp+e6NdsFODA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y0HP6XI4ED/F5Cxmj//k6c22P3/XNiL3J7NzurWs38I=;
 b=jtuVzsLSvxYHRLMpbS1GfSW2I/VXa/4JM/QRbpmTYPpmtJpt0tKZeZZ1TCCuQo8SzSf9azqrQwdE6lSAxxn5oL+YK7rZCyb63uu+/xdLdQz7nSwjYwr9F9SUUhdDuHVFwlFjmcoJfIKkokuALpv5EdqSFhNVFhzKrnIpbcsRWkLHoq2VbpNlRANBXltu1HAgUDAvujnhwfRWhQMhI5qUX/LZTlcttvO/gYsMSMxi3muVF8XoZtibgjPsOvDf1peF7KRDx2rmtV1Br4ZkxesYeY4+E29gn1qHhnxVERVb4wOVK3Sq2yCGT7RllIlfuqxYIC5XETQRU6tEWcBeITTdIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y0HP6XI4ED/F5Cxmj//k6c22P3/XNiL3J7NzurWs38I=;
 b=WZEgmC+Iutgp/PpJsM3L2IpYt1Zyql/k/UDv77c6R6Omtk6PR7CLKfHGrbWKmrVaYXs/fFENdldJC2AvMcZm/GylFLJFce16NgnZwMF1vDgoXvqOpPorlie1ZnV7FsOYEqehdjxFPiuZ6Sei9ln9HN9hh2tQGPuaRJdor2kl/hE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH0PR12MB7816.namprd12.prod.outlook.com (2603:10b6:510:28c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 22:25:47 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%9]) with mapi id 15.20.6156.029; Thu, 9 Mar 2023
 22:25:46 +0000
Message-ID: <eaf01c4a-f2e8-714c-81fa-3add0b776d73@amd.com>
Date:   Thu, 9 Mar 2023 14:25:43 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH RFC v4 net-next 02/13] pds_core: add devcmd device
 interfaces
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, leon@kernel.org
References: <20230308051310.12544-1-shannon.nelson@amd.com>
 <20230308051310.12544-3-shannon.nelson@amd.com> <ZAhXZFABVgsVBzfF@nanopsycho>
 <02b934ee-edd9-08f1-3571-5efe7687b546@amd.com> <ZAmm/bUs8FbWn+wp@nanopsycho>
Content-Language: en-US
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <ZAmm/bUs8FbWn+wp@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0015.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::28) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH0PR12MB7816:EE_
X-MS-Office365-Filtering-Correlation-Id: 1374c125-8339-4f39-e262-08db20ed3a95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5/WVs57MNgzBK/7BOLA0QGmwHtLDqhUr8IOE41QldovYMFjiRfHXi63bx/YASpwdGFLYbW9KVTWUYx6oYwzJnQdk9MAy1T/rIUhwKpRk8RkpV2UUSmE4+nMYr8pwHsx4SSQRoQF6sXZ/fGr3sYO+Fn0zQAGlVlTet2uRLF5xXnL8tbJES+87N/5Q7QqmOGhUJLPezVUttsXghZ71ZjzfK2huxoTrePU+9R3CkRWNKBDintImUbYtt47RtCJ09FugdP3lsWZoxad4yp7aGdo71Gqflrus+V9dZymcTT5WBASrVnFtLJDgSk14qJY5XXsBL9dy7YssJFADCc6CtJxPp0CMFKvdPv+X52GXoJASC2Fxhu/Gq+BBmvQggie+R2vmHHFHDsQ83mnvGM+/X6kMT7OkLi+Vm+rK3I/g6TQLqajbfmL0uwzI3E37wrMYI8P2V6TPqubVpPZQ5R8f0NeCD2ksbShyrDkv7JOUef5ISEqNq2KIbNL1fg89oD13T/INNCHzOc1ljIa7a3OhNVfR5wBbxL5uJ+AtRY9ii2fvzbwQtlbQlvRG5PdX+9C2wD5uIyHU6BlBS6nycsh3W0mueYSA8B5rGqpY76eanbceLRvkkGgxl2MXnZH1GU+RCT9UF/k13r6b2oZHcdl4XrfWTP5P4UzDfM9qbrgktDN/q/CTBK7hnZ30ClBvhu9FR1n+rv0vuoUeRY/C7Ix3vl0ecKCFtsS909oPtOdEmwk1VDA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(451199018)(6666004)(36756003)(6486002)(478600001)(5660300002)(316002)(2906002)(44832011)(66556008)(8676002)(66476007)(4326008)(66946007)(41300700001)(6916009)(8936002)(6506007)(26005)(31696002)(86362001)(38100700002)(6512007)(2616005)(186003)(53546011)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YndzQzBJcnBBRDZkOFRKY1g5YUlKWkJ6eTlOb0N6SHpOMTh6UnRzUlBldG5J?=
 =?utf-8?B?ZnJ5QWtnbSszSjEvQm5FUGxPVGlJTXBJeHZWRm9qOGp5ZzVZbzVMSFdEc2ZN?=
 =?utf-8?B?RlFCaWpoTis0dTUxaFlpdWNHVlQzVHJhL1pvUWU5YmgzM015NitIQ0FRQmlz?=
 =?utf-8?B?bUczc1JDUlFCbDEzY09xT0lldnpOa1V3aS9EVDd1dzN2ZHV0cTgxekZGRUpt?=
 =?utf-8?B?czFXckRERHZVY0g0K0FEVThseERubWl3R3o3WHJRMVdPb2ExaklLN0ErbDRB?=
 =?utf-8?B?cFdYN0ZYVWd6cDV1Z1EySFhudm1TZkw3Y0hDTCtjSGFteEFZN05GdFpINnU4?=
 =?utf-8?B?OE1zMlN3ZzEyczhycW82TDNwcEdnTGU5cXRQbU9QTU53VHJ6TUJ6Vi92VDcv?=
 =?utf-8?B?RkVLQjBlaEFocGJFYWE3UDcwUUxzc1NLa21NYmhoemJGSlR6VXlablcwUTVU?=
 =?utf-8?B?QXBQTUFtOWlyVnZiTGJ4cVV6MndtRFl6S1dlQ0V2cGhsOFdFaHVYOWpvUXFo?=
 =?utf-8?B?T3hRazF3NlRDajRaZ09YT3lJQVk4T0pHdEN3aDQxamQxOWxLU0tsOXdPd1lp?=
 =?utf-8?B?QnhpMHJYSDdORUd3R1dPMzh6cVo2Qk84ekNwWlZuaEVWT0dEOUlhNUFjYkVS?=
 =?utf-8?B?ZDZwc3JWWUd6aDFmZ1NWV3l4VExCN0EwU3VLQmpOSHNmNVBYeHErWERiaWls?=
 =?utf-8?B?d1BNSVkrTi9mM1RtSVRXWUhsNWNMcVFSNFJDVnhhYXZBWXRjazBOV1huS2lk?=
 =?utf-8?B?ZkNMZE5BUWwyV0xFeHJyWEoxMXZwckFOQnVwWFRYMGhOZDloaERTVDE5ZldN?=
 =?utf-8?B?R0h3SmRuamplbjlsQXIzS1RmMVFBN1h1NDRmZG4rbXZLZ1J4OWJ6dXhuWjZw?=
 =?utf-8?B?WHlGZFdBNVoxM2IvNUdKeDJGVkFiZ1JyUDFLL3JyODBuV2x2QjN2MnBIT21v?=
 =?utf-8?B?T3VOWXplNkc0b2o0YVJhTDBVVk5GWFNGNzd4cEpxS01LRjE2R3BIeUUxQzIw?=
 =?utf-8?B?RU9iVjQvcFp4ZVpSYkM0YkFuUXl6M2Z6aVRqQjVCOUVPVzdFelc4ZnQ2bVdQ?=
 =?utf-8?B?dEFCaDl1eGl5ajZ2VEc3VGh1K1ROSm50RjRpa2lEM2xzZngwaEJHOG83QVls?=
 =?utf-8?B?c3htM0czbTRSZlIrcGUxemxoQ0lGVkFRMW5pSXZlTk9uNzFVLy9EdkdIdzR2?=
 =?utf-8?B?KytHQnBSYXBpcThFL3ZBOTM0U2FZY0ZwVmViVi9aa0hZTkNoQnFZV0oyR1Qz?=
 =?utf-8?B?NVJaNUVEZ0wwdUoyemFNSnJwRmJ1N3YzZncwYWtHUGUyNG85dTBOb2dJeEox?=
 =?utf-8?B?N2p5ZExTTU9jZ0F6ei9vZVFIQmZCWDNzVzNWeVZvRUJ1VGVjRGZXcmthcGwv?=
 =?utf-8?B?SnNhRkczOE1BZE91cGxMNU9vWXhiRllENXA5UnhTcHA4N1BrbGhacm1wNTNw?=
 =?utf-8?B?c25JZ05BWDh1Vkh6ODNlMThVYmdwWmVqMDVJdHJjcy9oM2I0QklFbThCbXpa?=
 =?utf-8?B?eHpLa2oxODdpREd1V014aURYTEhXZG04L2RUNzV3RmhTZzBkVS9IaXd6VmhV?=
 =?utf-8?B?U0tweE9HRGI2K3FoT1pkY1NjSktIZDJYaFRhajU3QzY1MjlNTWM4THRRemFn?=
 =?utf-8?B?MjVpMyt4cllMb0NNZnNhdkYvR1g0NzN1NjBUTjQ2NjdUTytHZU5rTjMwelJD?=
 =?utf-8?B?YjJtNUZldTJCY2RXRXBSMjkwVzFxK2ZNYXdmWDlTVmRqbnMrRTVwTXJZdk44?=
 =?utf-8?B?SVBMR0Vyb0crOGp2SlhxRTROdEhsT3NjbTFFVmdTaUIwZ2FGeTlFanhidzdu?=
 =?utf-8?B?MEpRWXk3UGYzSHdqQVM5dkFvL1JlSGVwTENGaVdWQ1NqaDU4T2R2bzlxYlRU?=
 =?utf-8?B?TzdYUEU2bG02KzNKOW9DQTNDcFVzQ01zdkE2RzJNODk4WG9IQ1ljOFpFM2ZM?=
 =?utf-8?B?ampITllZenNZNDZUSVdFcFhEcFhjRXJoTTczL1lYcHdROFpBTnZVZ2o5enpZ?=
 =?utf-8?B?dWhUNlFaMGROL25WQVppTDZsRmcya2loZ1N1OURLNVE0VXU0UitPa0ZkYVZW?=
 =?utf-8?B?RGwya2RTZEtHTWhBNE9vMW5YMXV6bXRKQldhVEx0RFord0xHVVBSZUp3aW56?=
 =?utf-8?Q?V3n90RqygyMCGzOqCGueM/sun?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1374c125-8339-4f39-e262-08db20ed3a95
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:25:46.7483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C20jDhEaIWsLNFyKtPQ08nT42cpFOgsMy6IWHfNGcPOl/FC5+7+7NL3lTc9ogBFbIgfL2gZ1rDtg45oxhK9DCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7816
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/23 1:29 AM, Jiri Pirko wrote:
> Thu, Mar 09, 2023 at 03:05:13AM CET, shannon.nelson@amd.com wrote:
>> On 3/8/23 1:37 AM, Jiri Pirko wrote:
>>> Wed, Mar 08, 2023 at 06:12:59AM CET, shannon.nelson@amd.com wrote:
> 
> [..]
> 
> 
>>>> +static int identity_show(struct seq_file *seq, void *v)
>>>> +{
>>>> +      struct pdsc *pdsc = seq->private;
>>>> +      struct pds_core_dev_identity *ident;
>>>> +      int vt;
>>>> +
>>>> +      ident = &pdsc->dev_ident;
>>>> +
>>>> +      seq_printf(seq, "asic_type:        0x%x\n", pdsc->dev_info.asic_type);
>>>> +      seq_printf(seq, "asic_rev:         0x%x\n", pdsc->dev_info.asic_rev);
>>>> +      seq_printf(seq, "serial_num:       %s\n", pdsc->dev_info.serial_num);
>>>> +      seq_printf(seq, "fw_version:       %s\n", pdsc->dev_info.fw_version);
>>>
>>> What is the exact reason of exposing this here and not trought well
>>> defined devlink info interface?
>>
>> These do show up in devlink dev info eventually, but that isn't for another
>> couple of patches.  This gives us info here for debugging the earlier patches
>> if needed.
> 
> Implement it properly from the start and avoid these, please.

Sure, I'll drop these in the next rev.

sln
