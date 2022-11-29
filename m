Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DED63CB8C
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 00:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbiK2XDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 18:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234423AbiK2XDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 18:03:04 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2057.outbound.protection.outlook.com [40.107.101.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC91286F3
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 15:03:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R4J2xfYRjjac5SVwy7MgraK6TavOohuIbZHBhW5mjX1ydX0bPsG1Ip+j7b7/8UVwvAQpjRXCzJBvTzDU1Jz3U1suVNUoGOlORx7B/+9uDRf3pOT/y27OP90w3ktb0x/sUVA8YHF5CIJyauLCF1yvw22EnujYnu6vePinPtqbJ+VmJABwbdymX87Gg9mP6/IKYGeHSEiu9F77APwxOMG+Z/C3H0m9dE4iiM6XB/PV3n7qpBMe2Lvm6PugUkiDpUV96LSPpFK1fLG5adWyTTZ4BxQp8v5A62NsUtG/u//wdGUdHVuGdoSv14RvMCT/lMUThjXg7c/cwb9EHLyvpbULpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QQabAZ5oBjGbUfMqyWETH/2q2KJ96kX+GbJKKb6FAbM=;
 b=M98o76k5M3JKyCs6kFAPbEwV/vvDF2WWx3Pu8a7xyzjGN+vb7WC2yFkXHcMxGGWXp9BbuZv+h0YZe64aY4WuiAJ5YNVrJZygxxs2ns4d0ROUDW7CaP1t/oRujFq2Ny2KOCV5PnIObdByygSNQBdzuOQROLKu0R1p/q7uKLrCnZuVCABBmaTtp574TdMOo9qYBQo6NCUaqW50qGSZhAiZVqs7U3mg7SnY7l+rdXGYkEiUu+kZmL9BLp79wxReJfMVSGVLRQvuVNAhFcokzkqxQs8FrMqA4wpaGk4RgHzBuR8Vgr73s6eJrdBfmTdLEMCWZOPELRguwrp8lOLTMRpniA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQabAZ5oBjGbUfMqyWETH/2q2KJ96kX+GbJKKb6FAbM=;
 b=cx6vTWtqZg2AtzocKHjAe/q2GI6MDM6iKMFs8jhnL4WEYO/1wWvXmuDFo1WlFJXayF4Z/HPFXzcIqWIQ+tfWl4ER3jSVrgSr28KNveo2gnmGDHFZ6WXA6LWUXxlU0R2L22CCjp3jwfUz5+wTFlox0L7L+Wfq4yNsYp19mXo4BOQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 MN0PR12MB6366.namprd12.prod.outlook.com (2603:10b6:208:3c1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 23:03:00 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%6]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 23:03:00 +0000
Message-ID: <b8d4d9a3-16bf-699e-d09e-1d1deedfc8d5@amd.com>
Date:   Tue, 29 Nov 2022 15:02:56 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [RFC PATCH net-next 15/19] pds_vdpa: virtio bar setup for vdpa
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>,
        Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-16-snelson@pensando.io>
 <bf06e7f0-48a1-37f7-0793-f68be31958e1@redhat.com>
 <CACGkMEu2A5Yt+hrmdQdAnVBCqcBn_-gXx3cF-SYjb2HsRUtF_g@mail.gmail.com>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <CACGkMEu2A5Yt+hrmdQdAnVBCqcBn_-gXx3cF-SYjb2HsRUtF_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::16) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|MN0PR12MB6366:EE_
X-MS-Office365-Filtering-Correlation-Id: a7c24bbf-f451-4856-9504-08dad25ddc72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HWij9ewBXBqvTySGNMzhn32Y6T3njwudnep5XvPiX7cj9qRAs7NXkETovCrx5D/lkIlQ1zkE8NnuyjPNCuaYACB6qnTUPzExSaHwMWv6kMvAkWNT+6u7a9LuHoRAhmxKiwJdrzUho9vtgO2Lg2OFprsUYfdZ6O/bwE8IrNG/Ga/8xewRNllOjU1kCxBcGXAwLIn5sbIlOkpgZAFJ+SnY4jXQ8348auO6RdKSM2WUkoABd/H4puEvZDLFywNToQeq4tfhCrUpN39NsrQS/lwZwVYwafIRIY5IjpBf9ax/PpSsjb10P1Xyw/xYjDsmwJfu282aZPfvwUMuj3B8KNo/iIsEy1yzVTZi5jwwFME1I7JJVyRa2VmGUstv/0Z/LficazzqzbqmiHdM5grpP5jyGLSajmyjEEmCA/o59XmMbC3ITvwIydHleglIpGXwpwNpvMKLs6GQwNSm2KMH+SPwAmTLprboyMW4e5ZrIbMWVhuXtxuxqn6b5y7HtcXvJA8Gwd7mMwmcLhGA/vD/L49TBZA5tExMz4eVmQjmLv7F3xHIbuSL6n+SkhEwC6EgZEOL9AJAGhXMKzDuhcmVayBiCqf6JSvj8Lh9X3xylNf8MR4iOL0qdUAGKYwWsm/ihpFen9mWzFWyNDAxkT56jgUsHwn+S00hUO3kr5DdWb/kYMSlXXP18YbGdbMwfNQd87S4vs8CU6IhbFoCMolVgsbMDDU0Kn1u7a9OJsLgJMhuPO8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(66556008)(36756003)(66946007)(66476007)(8676002)(5660300002)(41300700001)(8936002)(31696002)(53546011)(83380400001)(6666004)(26005)(6506007)(6512007)(186003)(2616005)(6486002)(110136005)(316002)(478600001)(4326008)(38100700002)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0ZReE10MW1rcERaYkNvcU1udHp1T2RJSDdzWCtLckoxYXJBamVYMjVkbTlV?=
 =?utf-8?B?ZUdUNTEvcFRXZjVoSUZINENxaUxXWG5XTEdDa0YwRGJtL3BkajN3dGZaa3ND?=
 =?utf-8?B?c0FxMjEzdXJTRCtxalQzcjlTb0Z6QVMzVUVOQ25GMkZqTmJSK2JYdzl1U0hQ?=
 =?utf-8?B?d1RURkYzemsvU3ViTzQrdUF4UkoxR0g3OWNKWXZZcU9VUVcxWXdET1dlTk1G?=
 =?utf-8?B?YXE2V2tubWtnTDNCVnI0WHFBTDV0YjdCaHh4aStQZElMOHQ5dGhlaDlDbjkr?=
 =?utf-8?B?ZndyNnpvaVB4ZXZuTzRNRnJ2c25hdk9hMzNOalhycW1KVXVJTzRyKzJmZzVN?=
 =?utf-8?B?RmVHSGxZVk5pV3lwRWdOayswL3BGR0dzOXkxZjZRV0lWVHcrQWxwNEN5NG5S?=
 =?utf-8?B?dTZFWFFCVXZlTEtVeGJMZi91WExQUDNtWjQxaEhpKzlDcFNlSDNXQ095M3Jz?=
 =?utf-8?B?WkhNL3RyMEp1ZXdMZDFZbDRST0RvazlER1BVV0w3NloxZGlNYUk1TkhOck9m?=
 =?utf-8?B?S0p5S2JYYUxjTTZnSjNtTHY5azhhVXU1ZlhsY2FsdHc5NGQyTEtoSHJlTGxW?=
 =?utf-8?B?M3FjQmtoVEZ4b0tvOWhoOUFxUy9kSW8rL1VZVk5tRWM3bStZbmhTUUtkVmoy?=
 =?utf-8?B?d0VVUGFLdlEza2k2dnEvVHd1SVhwc3JoZHFpSkJLcFI5dmNHRG1aR0Y4LzZv?=
 =?utf-8?B?OFRPVUVxdGVMd2k1VEQzK1JUYzJCclVRRjV2Vm9UN3lBMzRRRzhkaEVrR2Vv?=
 =?utf-8?B?UFYxVTZ4THZMWTV5MEhQT1lpeUVFRFhHOUZCVi9qSEI0Z2pCaWhFMkNvK0pR?=
 =?utf-8?B?a0Y4L3hJT2wzZi9OMkdoZEk2Y25iOS9BRFBNdS9OOEVDMHlNOUczSEVrald0?=
 =?utf-8?B?RXlwNCs4MEtyaVRFSVdIU1NJTnhTU1JUM1V1d2R4S3RnNU9sZ1ZrYWdtNXdj?=
 =?utf-8?B?dENxYmZNYkUzUGpGZUdlbFB3SVRNRDNIVHBveTlKbnowU1owUXpJbUx1UVJs?=
 =?utf-8?B?YXc3M1pGY0RZK0hBU3J3KzdhaTlTY3pLZGo3Vk1pczBJdXpxU3RxVGpJRGt1?=
 =?utf-8?B?RzNzSHhVNzkzVzV3bXVUUWRWcFU4aHpyRllIZDFYd002WC9iODNOSnFiY3FB?=
 =?utf-8?B?anM3YkFrSUszKzUwdWFQNGRBRGRLMm5LVFpUTjJBL1U3MUd4NTNIWWdJQUZI?=
 =?utf-8?B?MWJjK0JXWCtySmZSYVMzNWZ4N29PWWhVRUJVaWxmNjQrWEI3Y2JWUmdSWFMx?=
 =?utf-8?B?TUI2THJSTjVldVpVRWQ0cE01S2dGYjdWWjduTXExUzlNdmVDcm9HRTcrSzJp?=
 =?utf-8?B?cnA0aWc3blpmY2xDRDJ6QkJFMnNsVy8zalZPSEdXWDRIZjVpRkhXTDdvTU5k?=
 =?utf-8?B?M1J3ZHpYTWg4K2JNQUpDb05yK2duODQ0dGxIOHU4V0RXZ2ZSbmoyZGxyTHcy?=
 =?utf-8?B?eUFrTGVkWitXcEcwV1JjMVdjOFZNelZsTnV0aHZ5MnFsTFU4d0hhcnJPVE5K?=
 =?utf-8?B?MVMvOXVCanJZUUdzc1lXNVB5R01hRWd4YW5KajNjM0hCSC80cFZFK2NVRDdt?=
 =?utf-8?B?MHJPUU5PSnprSDBvYy9wTjFEKzBXcXROYlRZcWRXMnJyN0VVYzJCVVZ6bUky?=
 =?utf-8?B?dXB0dC9OUUdIL1Y3aVE3SExPR1FzbkNsZ0hycmRCNSs0eW9xVmo1R0g1U2x2?=
 =?utf-8?B?di9SYmxCV2RETUNybUh4MC9SRTBSVm4xd05kbjl4cjRPMmplU2FIMjRpM2Rt?=
 =?utf-8?B?b0E1MTlHVytoVjFvUjFWbWRhWGhUc0R4YmFvanFpWml4aHNiTjMzaTB5T0dt?=
 =?utf-8?B?S3RNbTM4aXJyODBDQnlUelEyV2NoYzd5c2tOMTRUT3BZajlEdFcyd1ZmRlpW?=
 =?utf-8?B?K0pjYlEyenN6M0NsYjlVRGt1U1BWTDRTMXdJV0tFNmtoaC9tODBHOFE1T1kw?=
 =?utf-8?B?clpNaGsvRDVQS1JkVWFtQ1BQL0JwZGJDRGJOU0NCenF1aTczMzRPZzYzSjZO?=
 =?utf-8?B?OVhIdmpDT25vWXYxRjBWSTZTdXU1SmR5WTkwMFdDejJzV29QS1g3cTdFSGhh?=
 =?utf-8?B?VkE2WnZ6TTV4aGNpWDFTSDdycWlyWGdWZWFBYlZNSTRWRFdXKzBZdCt1bFE3?=
 =?utf-8?Q?pljmQb82fGD+N/uf785/t7E1A?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7c24bbf-f451-4856-9504-08dad25ddc72
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 23:03:00.0040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BgeRM5urIWJrA74YAgoToFNRy9HecIjYMZcP+QqqEI2GV1eX5SmR2Hoysz6Mc3YI59gmKepF7ArLVUPKjKLNZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6366
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/22 10:36 PM, Jason Wang wrote:
> On Tue, Nov 22, 2022 at 11:32 AM Jason Wang <jasowang@redhat.com> wrote:
>> 在 2022/11/19 06:56, Shannon Nelson 写道:
>>> The PDS vDPA device has a virtio BAR for describing itself, and
>>> the pds_vdpa driver needs to access it.  Here we copy liberally
>>> from the existing drivers/virtio/virtio_pci_modern_dev.c as it
>>> has what we need, but we need to modify it so that it can work
>>> with our device id and so we can use our own DMA mask.
>>>
>>> We suspect there is room for discussion here about making the
>>> existing code a little more flexible, but we thought we'd at
>>> least start the discussion here.
>>
>>
>> Exactly, since the virtio_pci_modern_dev.c is a library, we could tweak
>> it to allow the caller to pass the device_id with the DMA mask. Then we
>> can avoid code/bug duplication here.

I'll look into possible mods for it, although I'm not sure how quickly I 
can get to that... maybe a v+1 along the way.

> 
> Btw, I found only isr/notification were used but not the others? If
> this is true, we can avoid mapping those capabilities.

I'll keep this in mind.

sln
