Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 577A04B40B1
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 05:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbiBNEX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 23:23:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiBNEXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 23:23:55 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC7B4F449
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 20:23:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JfNYUP5GyCfFE9tWz7Me9VNaU3f6anrXhl2wqrHB5yV6aVvEdZEitEX4I11GDZa4UFdaLFlcB5kyJEHDPpKEFLgqQcg9xFHRtOVZcpa7FOhoZpjIQfJhV0wpdD+/0j9DV1epTRAJnpOkYTbN9d2KVqoMMbLCZK1UFtTqFnPIiCSzfbgNxQEZXtnjgyCVlLmVH/rXo3aJ8DfE5poSYl7j84m4IM2J7q7Kl0gvJ87yPf34NNkOX9hDYEfXrAtvRfXZJbYFQIBody89tehtyW4fwWunOBdX+3ZspJ5CVWJgJ75wHUTAS+Jo2IEwxCbQduOZO02+Pmdg1/w9TR2lvSFdmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tL0A682ps5L+IJPEIu2EVf0W8cJIwYL4MunRAoocvQw=;
 b=ZPeCOn1vIy6kHjDHzHKou4HuUDxneLeC6dH5g/TYE6rc1+cp/LdwVDphftm4mrp7+YA/hZ/16bIEqu+hXZNFexB1zUmTr+yfedI692XGShROrkQb4ycXAgGPTnKD8cNOreS92Z/TxvYsW9EUJViekBpimATrv/OWHv6uXUJw52Dl2GVC2RNDzNiM6ChXF1K4xR/bY9DtH2tgcJu+IKTcfUAlGn8Ff9tkPqez24V488uBPTlo1dxVfy0qpo+gMvkGqmjVwTWM1m+i2AXn1b0zYYUsMPtkTuN4wLMKQMeZ/J0B6MfWw0ZkEqD050Ammr7bKpUqCn6GuNhWWwfCeFe8rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tL0A682ps5L+IJPEIu2EVf0W8cJIwYL4MunRAoocvQw=;
 b=L0DUj/5pV0L22FbkEDW1FJ5nluZEvJXGBrt9vbke2VpUzELUqYGi0WC5LFi5Rf0t+s+p2F3e+FI6rpYL8Q5ZhxbtN1456uSHUJI+9eY60ZekUYp4rbFDWNo57Q3Kb/IHeOkHu7e9jhhAfLY3fNpvsBhNpE+iMqvJeUJhbGCB1SE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19)
 by SN1PR12MB2494.namprd12.prod.outlook.com (2603:10b6:802:29::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 04:23:45 +0000
Received: from BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::45d6:9536:15a0:9cbc]) by BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::45d6:9536:15a0:9cbc%5]) with mapi id 15.20.4975.018; Mon, 14 Feb 2022
 04:23:45 +0000
Message-ID: <0371d81e-6cc7-4841-47dc-d7b50d1a5c9b@amd.com>
Date:   Mon, 14 Feb 2022 09:53:31 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: AMD XGBE "phy irq request failed" kernel v5.17-rc2 on V1500B
 based board
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Kupper <thomas@kupper.org>
Cc:     netdev@vger.kernel.org
References: <45b7130e-0f39-cb54-f6a8-3ea2f602d65e@kupper.org>
 <c3e8cbdc-d3f9-d258-fcb6-761a5c6c89ed@amd.com>
 <68185240-9924-a729-7f41-0c2dd22072ce@kupper.org>
 <e1eafc13-4941-dcc8-a2d3-7f35510d0efc@amd.com>
 <06c0ae60-5f84-c749-a485-a52201a1152b@amd.com>
 <603a03f4-2765-c8e7-085c-808f67b42fa9@kupper.org>
 <14d2dc72-4454-3493-20e7-ab3539854e37@amd.com>
 <26d95ad3-0190-857b-8eb2-a065bf370ddc@kupper.org>
 <cee9f8ff-7611-a09f-a8fe-58bcf7143639@amd.com>
 <57cf8ba6-98a7-5d4a-76d0-4b533da06819@amd.com>
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
In-Reply-To: <57cf8ba6-98a7-5d4a-76d0-4b533da06819@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN1PR0101CA0032.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:c::18) To BL1PR12MB5176.namprd12.prod.outlook.com
 (2603:10b6:208:311::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6e94e13-a6d5-454b-25b4-08d9ef71c9d1
X-MS-TrafficTypeDiagnostic: SN1PR12MB2494:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB2494F062B5998737165084C69A339@SN1PR12MB2494.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ilm+BmrIDdFZl/NZTT9dtc8PBopivhVmDYOCJt7sCMgbWDKEIHHvxFKhDdR7GF3rbudeSWunZKIwyRqhx/jifVAbIJrQiHdaco6jrIfC+CHgKYySuM0HHI/nVDtOB6PIEwfRPEveZ7d53aBEbKJ35J75T6pSh44LQIGmVEq6g4nhYZoC5JboQfVx8f+JAazPlC5jcf+0LOPhpJidpresOsy9/p6uPuLXqxq6rgBUAqr/NHJNkj/9fUxGOZ5zQRdu3YqxO35+QAEKe2kZ98dkHzVGrFHOKlfDwoySwIMDGBvVMvL2AGgn0GhQp4tBilw8sbOsIAEtvu/ddA40EpMiIIDzGNZvIj+MSyekrNwK5/A+RFPY9zXAGDGZN172ZUpji9iQIi8bFE2Trgc1IbRIthz8c7A3yOizD1ZTtDKqsejZe1g0OsH6saQRO/ynZurM6BPFkQ0+RhS0E1RXuc7NCSwyXKKAF8mXMJaDdoK1CLe7Hj7Z8twhOMT8QOTQUl/Ookn27BFNguD5UBolZAGHR58Qv4RIB5LDzQiVTGf0tNYunZE7k70C6t9gCbJ743w8JYDg5RO+SMZCcQbU0GklOQxqWd8FjjHw6UBYpDFYsSMj7ff5sqP0Zct+Ab/rEhxs/eRiopxb0HK7zP7k8Wgjayqi11FC1UQq157lOWZcxCbk5Hv40NozJoLuPP7N1v0HMDn3PjzisE6sM3JlB45n3BE81h3Sl3xjCbYRUwvP/gXISheh5fuCWPojpfg15UsqAjefA3ruyR+K8JTmLzi7zxeqVtSo40SX2l+s9KKoaHb1irCTg1Wa2RG2nWBdGk69
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(26005)(6506007)(8676002)(38100700002)(4326008)(36756003)(186003)(6512007)(31696002)(83380400001)(86362001)(2906002)(8936002)(5660300002)(31686004)(6486002)(966005)(508600001)(316002)(2616005)(66476007)(66946007)(66556008)(6666004)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VnBCUXNjSzZ0bjF3WElxY3JqTGpheG44NTVOcUE2dUJCS2lCaDlTUXhhTGlN?=
 =?utf-8?B?T0xiYStXQlZnSHlUTHhDbUpBUWlqY2xpWUUvamhBdnAwblJuZ3ZidmpkY0Fm?=
 =?utf-8?B?MVZjNWJsak9tVVlxYTNCaXVONjZiTS90cGxRaXIrQXFrTTZKV1NOWHJyTURt?=
 =?utf-8?B?bXlDWmNQVERxcXYySGhBR0lVbUluMlI3Q3hxUXRIai9HaWc5ZDRFdS9FazFX?=
 =?utf-8?B?WHlmWFlRVXhzZitZMUZ6b3prbmJoazFqTEdYVDBZUkxXSkJvOW95STJremtI?=
 =?utf-8?B?bVJCbXhVN1dHbzF4Z2MvSW8xMVdzNlM1aFJ5cnBDSTJhejNZd0dQRm1Wa2lO?=
 =?utf-8?B?bEM3RGJwN0JBZ1hnRVgvQXgrTTZER2JBcFM5NGFCNENZN3lrVFdPTmdZV2d3?=
 =?utf-8?B?YktGT01KNjRPNCtwaXNONmcrc3NZRGxPV1E2RU5xV2g1M3Q2YnJDdEVMYVMx?=
 =?utf-8?B?OEwvT2g4MS84dzB3THl3a2Z1NlZ1TGtZRitOaWUrS2Z5NVpPd3hOSy9JUmx0?=
 =?utf-8?B?bFRNSDBCWkxVaWN1d2NOeGlRV2VIbWEyUEN4TnlXY2hmaWhDSDRhekwvSmVw?=
 =?utf-8?B?T2NiMGtlelo2VnBCR1dNVDNpeFFORU9TVTNpb2puKzExeU1sMU9NL3F2UGd3?=
 =?utf-8?B?ZzFmVWVmV3BudngrN05qT0Vqckd2ZG9ObStTZ0EzSVEwZmRiZmpoZ2VtdE9j?=
 =?utf-8?B?aFkrWVNPN1JHWkZVNGQ0bUVYU1FvdlpkYVZsSytKOWhpaHdYTEJUQTdTTXd0?=
 =?utf-8?B?RnRCR2hUYnJBUVhHbmZtd1JKenJFcFZUNDhLQ3hDYnRSY3U1T25NUGV4TURI?=
 =?utf-8?B?Y3poNzd1TnlNUWRWYWlNaWJYSXpQYmYvT1c4ZTFONTVmaTdheEJjQmpPN1g0?=
 =?utf-8?B?ZE5BSGNUSlovY1orSEFIeDFUc1RWcGlSL3RoaFV3dFFGVFpqSXNrcGx5TkxJ?=
 =?utf-8?B?ajdhQlJSbUJuSzRMZ3UrWnlJUDE2UndxQk1zaU1SWlhDZ1Y4eEt6TjZFMVNv?=
 =?utf-8?B?WWVGYXhKOE9vS0NtUzdoZHZuRVpRWnU3djdXVTdCcDM0U0twNHlOVnVLM1hX?=
 =?utf-8?B?S1k4NDNKSXMwdHdPL0V1SG5ibnUvSEFLSGJ3OHBHTkp1M01wQ05PcEN2OTBp?=
 =?utf-8?B?UXRrQkFqcmQ0S3p4Q1hjZWhZWUNDQ0JmVU4zeExMOXZCUDNlQTE2S1dNWlJH?=
 =?utf-8?B?SjhtYzZuYzlscE5wVTVqYXNsUmlhMmk1VTlnai80czl2N3hpSEprWmZxOEJ3?=
 =?utf-8?B?L1Y2RHVpenpad2F0VUVXY2VYcmFZMTk5Ymx3MWZDUjlaeUkxV3lMdkpqMit1?=
 =?utf-8?B?K2Y4UTlJYmh5eGU5TFRlazBqL0FwVVdZU2tOSGhYMzJtVW4vaDJLMi9hWU1n?=
 =?utf-8?B?S2hIMFdvZ0tKQWlRS1NxVHVveFg4QlpVV1VjSFc1YnpQS0F3dVhtaFJnZERB?=
 =?utf-8?B?L2JFN3grcis5WXRKamlXSjJYVWUwOFFKVlZZWmlDZVJZaWJKWWpvRnFMZUNv?=
 =?utf-8?B?T0RjRUhwajhraTlHdnhzeUFDSS90ZnpOOFl2QXhOVkNzSUhNbUI0LzZkcjl6?=
 =?utf-8?B?alMrT1UvV1RHaWc0azVPdGhhUjhGamlPVzBKUVZpSVRUbFl4cEhmaVFaU3l5?=
 =?utf-8?B?WTBBOHQvQXEyZ01mU0swOTBTdk9mRElGMmVlSnFEVHpscEZNNXl3bjE3eGp4?=
 =?utf-8?B?YStCelZ5U25wRzgvdU5TRzdXYjNQNy9WZ1hlYWJrTU10cFA2cGJ6U1JuWXdQ?=
 =?utf-8?B?NlRFUkNpYnk2YWJxTUE3VGhWVyttcmJ6cE9YNENKVzVsUWZQUm9yM1ppTVQy?=
 =?utf-8?B?TjVFMlA3cWoxYmpPNW1YTU1PSXFTZWI0UXNOeW52RTAyTXZ1ZktIZmo3aldB?=
 =?utf-8?B?NlM4WkJ3amtmNW91aERRQWcydzVGR1RtVkd1ZThvNzJJMnBWREFhQWwzZFJ3?=
 =?utf-8?B?YSt5TUtadUpvRnJoL1RSbGQ0NmxxTk5iS0FtbkJqWHhGOGE4UHYzVjZ5bnll?=
 =?utf-8?B?bVY3Y2lUZnFiSnJOdjhaSWJsVW5PVmI3dFNUZ3o0K1d0K1hpZms5QjZBMitX?=
 =?utf-8?B?UEx5dGJvSkhzWU9ZSXhIRXNSZWt0UEhCaG9KM0doRmg0cXo4MDFoZTRvdkd5?=
 =?utf-8?B?RDFDcGdCakNtbStMOTV2OUY2Rk14azNnQzhPZXJJTXNtWUFidjViMlYxT0Fa?=
 =?utf-8?Q?VMY/HcmLSZjOJuRJc7gVd/k=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6e94e13-a6d5-454b-25b4-08d9ef71c9d1
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 04:23:44.9655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eHnKihSpASoFeoaLf5fviGS7qyUsI6Qj6ALO1QQ8Bji2UUO5fBpc2+mu6LEnLC+wcCoiL6FqzX0krd+gtwSuMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2494
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/11/2022 9:18 PM, Tom Lendacky wrote:
> On 2/11/22 03:49, Shyam Sundar S K wrote:
>> On 2/11/2022 3:03 PM, Thomas Kupper wrote:
>>> Am 08.02.22 um 17:24 schrieb Tom Lendacky:
>>>> On 2/7/22 11:59, Thomas Kupper wrote:
>>>>> Am 07.02.22 um 16:19 schrieb Shyam Sundar S K:
>>>>>> On 2/7/2022 8:02 PM, Tom Lendacky wrote:
>>>>>>> On 2/5/22 12:14, Thomas Kupper wrote:
>>>>>>>> Am 05.02.22 um 16:51 schrieb Tom Lendacky:
>>>>>>>>> On 2/5/22 04:06, Thomas Kupper wrote:
> 
>>>
>>> Thanks Tom, I now got time to update to 5.17-rc3 and add the 'debug'
>>> module parameter. I assume that parameter works with the non-debug
>>> kernel? I don't really see any new messages related to the amd-xgbe
>>> driver:
>>>
>>> dmesg right after boot:
>>>
>>> [    0.000000] Linux version 5.17.0-rc3-tk (jane@m920q-ubu21) (gcc
>>> (Ubuntu 11.2.0-7ubuntu2) 11.2.0, GNU ld (GNU Binutils for Ubuntu) 2.37)
>>> #12 SMP PREEMPT Tue Feb 8 19:52:19 CET 2022
>>> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.17.0-rc3-tk
>>> root=UUID=8e462830-8ba0-4061-8f23-6f29ce751792 ro console=tty0
>>> console=ttyS0,115200n8 amd_xgbe.dyndbg=+p amd_xgbe.debug=0x37
>>> ...
>>> [    5.275730] amd-xgbe 0000:06:00.1 eth0: net device enabled
>>> [    5.277766] amd-xgbe 0000:06:00.2 eth1: net device enabled
>>> [    5.665315] amd-xgbe 0000:06:00.2 enp6s0f2: renamed from eth1
>>> [    5.696665] amd-xgbe 0000:06:00.1 enp6s0f1: renamed from eth0
> 
> Hmmm... that's strange. There should have been some messages issued by the
> xgbe-phy-v2.c file from the xgbe_phy_init() routine.
> 
> Thomas, if you're up for a bit of kernel hacking, can you remove the
> "if (netif_msg_probe(pdata)) {" that wrap the dev_dbg() calls in the
> xgbe-phy-v2.c file? There are 5 locations.
> 
>>>
>>> dmesg right after 'ifconfig enp6s0f2 up'
>>>
>>> [   88.843454] amd_xgbe:xgbe_alloc_channels: amd-xgbe 0000:06:00.2
>>> enp6s0f2: channel-0: cpu=0, node=0
> 
> 
>> Can you add this change and see if it solves the problem?
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=68c2d6af1f1e
>>
> 
> I would imagine that patch has nothing to do with the real issue. Given
> the previous messages of:

Agreed. I guessed the earlier problem manifested after the driver
removal. However, this one still appears like a BIOS misconfiguration.

> 
>> [  648.038655] genirq: Flags mismatch irq 59. 00000000 (enp6s0f2-pcs)
>> vs. 00000000 (enp6s0f2-pcs)
>> [  648.048303] amd-xgbe 0000:06:00.2 enp6s0f2: phy irq request failed
> 
> There should be no reason for not being able to obtain the IRQ.
> 
> I suspect it is something in the BIOS setup that is not correct and thus
> the Linux driver is not working properly because of bad input/setup from
> the BIOS. This was probably worked around by the driver used in the
> OPNsense DEC740 firewall.
> 
> Shyam has worked more closely with the embedded area of this device, I'll
> let him take it from here.

I shall connect Thomas to BIOS folks and take it forward from there.

Thanks,
Shyam
