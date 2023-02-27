Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780256A4244
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 14:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjB0NIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 08:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjB0NIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 08:08:10 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BBD1EFE8;
        Mon, 27 Feb 2023 05:07:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fgb7ZamT3h3ogdev8qaRm1shxaVrKn/7Po/w8857Se0Oth/aSc0u9glG6w1kHu/fUgqTrGwdi2jfEHbNJ/b67GTl/cuWeMLh4nTaj5grlA7w+sdqRG18fmqAHpd6FC+TE49reeJNK2P3j7EzQOp23lKbe3d+NV1ai354YpkKJWgtUqDGYRAlhIqjaWLGwoilaod7XjlwQzkLB0y5kRj1bsyesWnEkFpAiO1Z87whfHmwDI7zek4Rn3WFD+1bidZ/cQ1VqfRVkMLpvnpEF4Ax5OyeSwHf3z6S6P0TEHJIuG4+ZmaAF0SOVfD3z7JDaHTHM6NsE6T2kVAcfIs7jL63ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QJwZZLlzQTD0K25kQKrcBmefpaUthkpzMeaMK1eSwZ8=;
 b=VHZCdJ2EgZOL6jW1s507Udn1LfGmuOBYln9eyi2p+iyBNPkuE/j99aIoocgW6mjJiOMSpxh/F+tVSrBiNOXwI1ru3MtYaymL3peFEFM88+cGrk3KBPH8zJN8dPy/+rM05rvox7BLG9/cNqEgGYV0C5VQr3mul/8vZw3Nx/gPP5zUoMIhE+ftaz4SFkjkQl9jMHZ2KmRSSWSeRwjTRYTvAjzY05nXq8jOmzFbajCq4E4nLqv33L+/M4TUsYuvCRMA/gvjfLg659ni7ZeD/tczvK3G38e1QaCgc+No7PUhz+Z+1uXKQtiOpmuCnESxSGpAcHXGoBhwRKZ8OFUFVVRHUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJwZZLlzQTD0K25kQKrcBmefpaUthkpzMeaMK1eSwZ8=;
 b=0b4i9thR5ZvhAee5cC5K3lABFpUAZxgq9BKaC+4cXcqo+h5zf/j0HNwgwfY36pWDHvbSAae7xgTgM4qd/bGx9Fh2S/u/SDp2/W4GsKdFfxsgjO18mIF8YNlzlzBm4m4EnJjl7mtBeu9/FdUUfEHljZ8T/ANCZjCaOXuR9IDj4jg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BN9PR12MB5292.namprd12.prod.outlook.com (2603:10b6:408:105::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 13:07:24 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c%6]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 13:07:24 +0000
Message-ID: <980959ea-b72f-4cc0-7662-4dd64932d005@amd.com>
Date:   Mon, 27 Feb 2023 07:07:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] wifi: ath11k: Add a warning for wcn6855 spurious wakeup
 events
To:     Kalle Valo <kvalo@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230220213807.28523-1-mario.limonciello@amd.com>
 <87r0ubqo81.fsf@kernel.org>
Content-Language: en-US
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <87r0ubqo81.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0063.namprd04.prod.outlook.com
 (2603:10b6:806:121::8) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|BN9PR12MB5292:EE_
X-MS-Office365-Filtering-Correlation-Id: 47cc3210-3dc2-4664-00d3-08db18c39133
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aCAHO2UKicu3LAPYNYjR2fqwMAcQgnb++M5Npc4cZNEAxBTra4TmskVIpaBsPNwc1EIBs7/j4HlE6Uz9fUJZF0OGjoDLdfevsAeZICmZvqViJbParDdodgOCTuKkuvXGAQV3KQgH4Hwyr8B6KZNASoRKk7MDascXpwgTMlNEBe+2rwf25KrxEg2kIZCBLicRLbwS0xttKNxgqjQKlZMq2kSV4KHVzgkoHN7DB+pPB1r5h3BUCbwHV0ZyDdwci00pao55y3+B063DqPuiYU34amUdKbdHKIJ8R8ZIfSItxkVuPnIJt98S8g02KuBgdzY5IoZzpaTMvsWvYsBohjR0wyoft0m9hBe7ctonbbBgP/5j3SDr/LZ62QQJGyi2lbPzMyDWjLquTq7CVNN/Oa2KiDo8jmk2L+ktidVoc5l6VA/XKEuT9ZJCkEbMAHW7aBnVx6TMPAIBGGOEcEKwO+dq5VdFX4OnTw0olpTSb5+urzERj6PzFy1AYQUSEyn+9pL7Vx+nl3EtWLTuf2L2MVDAOLP496M+OlrMKrdfzFHd8FJTtHr6NePBTK0cJVN/QSnRe+bQlv4f0+dc/5cViIcgDtKSEsmhPErwGgHWhBocMd3+zCswCZ48/tGynLVDymVDz7pEDPVf5RJu3xLaGHRkzHEX/M7O5G46n9aYAdCFQKwmc31dFYsMFw7Zr0/z4Qr7j8Wvi4xA3ZY9zudERMuyrYtRJJ4fU8SLxEVYXicH7GQbNwryWBXghigj0aG8gGsph+ojwtiQ1GaRjTzAM1qKLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(451199018)(2906002)(31686004)(8936002)(316002)(478600001)(83380400001)(5660300002)(44832011)(36756003)(86362001)(41300700001)(31696002)(8676002)(4326008)(6916009)(66556008)(66946007)(66476007)(54906003)(38100700002)(6666004)(2616005)(53546011)(6512007)(186003)(6506007)(966005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a01VY0dFR3Roc3I4ZkZiUU5GL2Z6SW9wREZPRWViSWZDSjVmMFBXdFhsLzVB?=
 =?utf-8?B?L1BwTHFTNDdoQmYwTU5WT0xSbXRqTXVuSUw2VFF2S3MzT1Z5YlZvOEdUazBk?=
 =?utf-8?B?N2x3N2VkMTcvYzc5akJrSlNxT1R1VFZ6SHp5VWl3bGFZbUNRRGt3ZkpabVVJ?=
 =?utf-8?B?eFZ0U0tMaloyU3FYc1AvNnRtMlB3MzgxOWR0Mm0vbGNaM2ZRWEk4NnZYdUhK?=
 =?utf-8?B?UUYxUk5tSFc2NnpDeU9CVlFZOXJwSG5wM1h2TFJqOXJRd01hdGhjai92UjJm?=
 =?utf-8?B?cHBsczI5STlUdUhoclBSQ01DeVgrekpjOG56aFNrM3Y3NG5mQ3BqWlhsUkhO?=
 =?utf-8?B?VEtTRS8zZExlOXBlN1NScWJYSzdoM1NmLy9zWmQxYnNERGl6UHlDVDJxL0tu?=
 =?utf-8?B?MHRrbVNFTlZsR1ZFWXY5U1VXaVpsamRlSlNKOUZMZ3BZbVIzemVNRVdxaDRy?=
 =?utf-8?B?b3dFRXI0WXBFNFVDTjJSejYwbkdYakliSklxaXBrakJrK1JhaVdGUzBTcHJL?=
 =?utf-8?B?dldYdWxLRndrMFlWbnFKTzFiWDN4ZGpnNFoza3JwS3FCUlZlN1hvOWlKRE16?=
 =?utf-8?B?UlVUZVNyMWcwbktGczdKaFpxYnVjUExZQnVwdHFIL0JiaGVNL1BqNEtZY3lG?=
 =?utf-8?B?OGVvOW1wOUtGbDhLMldCaUFhT05Ia3kxbU4yUkcwc2xHM2JOZmNnbWpZb2Jw?=
 =?utf-8?B?YkdlMk1PUURzajJmakh0S3lGQ0RVMEhta3JJcHpKWENOaGI2ZmEyN0s1bXlQ?=
 =?utf-8?B?UENzMUZzWnhyWDVVMmJud24vSWhpKzhBL1NmSVh6NmxGWWlwRkFnVm1nVm9u?=
 =?utf-8?B?T01BdnF3N3ViVGowNURhYytlTzRxaXhxRUF1dkIrY3F5SW5ZUlgvZTNia01n?=
 =?utf-8?B?VWgzWUJYZkN3MzZLSVpKLzYwYmtVSlM2SnhzNVUyeWRvdkh0SWV5TUtZNXFl?=
 =?utf-8?B?cTZXZm16S3FoLzRPME5HbGdldjBkL3NZV1F6WG14MVdibHNPdDc4SGt3RWlD?=
 =?utf-8?B?UFZWMDhXSzFrVk10TDhyYXB5cE1uMnhvOXBWNzRCamtKZDBzUzlacGV2S01z?=
 =?utf-8?B?VDJUMmY5NDNZZFJkVmhLd0pwUUNBQ0dSQXFJUDNXNnJDakc0Z2VDa0JMV2VG?=
 =?utf-8?B?RUJRVWRxNjBJNUpuclRNS1N0MkRRTG5TMjhaMll1UlhUN3pkOG1NTTNyeFli?=
 =?utf-8?B?MjVld1pRQ1JsQ2MwWlV6V052RU1BeGVSYWZ2ZVRtRmpvOUZhU1RQTVFYL3FY?=
 =?utf-8?B?c0k3NXBsMDU2amplOTVYdkljV0FPOWZ1VmgvYVd1RWd4WWMwdlRJRVAvWlJL?=
 =?utf-8?B?M2RwWWw5UFI0WDZEcCtXQS9IOWpyd1p4ZUxzdU1yOGhGRFdubHkxZ215dVBS?=
 =?utf-8?B?cGJ3OXZiZ2g1MkZjdkN0NWRWbHJnTkd3a0ZOaUtoT2NOa1M2T2FmSE1ZenZO?=
 =?utf-8?B?RTQrdjd2NkVKK2tHSWYvSC91UCtEWmU5R2YybzJjSzlHWXhXQndoQldYd0xm?=
 =?utf-8?B?UElhQ2VJTVV5TkJyYTJ0aEI2eXpsR3ZJS1ZCcnh0NUtlWkpWZlIrUTkyNGs5?=
 =?utf-8?B?d1FEM1ZjUzF2UDRoMjBXbDdteG1DejExNVkzNzdTZjQwNXRyWEdGOS9CcmQx?=
 =?utf-8?B?MmpsQUR3MHBNV0ZpUFliRjBOR2l1ZG9adXJ4OVFGOGJxd0dUbzhEOGdHREFs?=
 =?utf-8?B?TCt4TU51N0FaRHdKQlNFYVNoRG1CcUNaTWtDcnE1b2pWdC84YSszaWl1NHVV?=
 =?utf-8?B?TmdvdW5WVUx0Q1dqZDJXcWcxMWF4eGYxU2YvdWRBUWVoeHFvTm9ZQzlkNVR5?=
 =?utf-8?B?ZC95d1hGRUMwVVpGbmxmZzh1aVF5aEl2N0JYM2d6clNFUzdZS0JvZ2RhQnBq?=
 =?utf-8?B?TkcxRUFZdWJRcEkwNFRDdjcyMkM4MlNNam9QZjJFYUNQNlZjcXIxbmNaZ3cx?=
 =?utf-8?B?MU1PcUx0SlptZW9LOUpUMzBnTUpkblNrOENmQlU2Z010ZzhOdDVmWUtWcWtr?=
 =?utf-8?B?NitTKzFETlZBR1RsdnZTYmlMaS9sZ3B1MWliQ2dSSkM5T2Z5NkdVMGxYVXRa?=
 =?utf-8?B?dE80SFgvL0dreVZqcHRQQ2pINkIwK1R2Um5heFlGeURqTDlZeVVBTFE5dEZr?=
 =?utf-8?B?cjBkOGRkZHFEekdCOVdSemFickp6aUhFcEJtdDlOQzJQR1ZVRkhJUHkreEl3?=
 =?utf-8?Q?ZAbMO+zrpS9GBG33WR5zde4jM0Mie2oykYgL3IwMbClP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47cc3210-3dc2-4664-00d3-08db18c39133
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 13:07:23.8660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vwqoIBR69B3/bE2emcpgXgyPrrvEH9SSF8X4MIVa90vaIWm3YpM01/7ylsFaPvMVqBFv2s7MuH6qC284/YR+yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5292
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/27/23 06:36, Kalle Valo wrote:
> Mario Limonciello <mario.limonciello@amd.com> writes:
> 
>> When WCN6855 firmware versions less than 0x110B196E are used with
>> an AMD APU and the user puts the system into s2idle spurious wakeup
>> events can occur. These are difficult to attribute to the WLAN F/W
>> so add a warning to the kernel driver to give users a hint where
>> to look.
>>
>> This was tested on WCN6855 and a Lenovo Z13 with the following
>> firmware versions:
>> WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.9
>> WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.23
>>
>> Link: http://lists.infradead.org/pipermail/ath11k/2023-February/004024.html
>> Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2377
>> Link: https://bugs.launchpad.net/ubuntu/+source/linux-firmware/+bug/2006458
>> Link: https://lore.kernel.org/linux-gpio/20221012221028.4817-1-mario.limonciello@amd.com/
>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> 
> [...]
> 
>> +static void ath11k_check_s2idle_bug(struct ath11k_base *ab)
>> +{
>> +	struct pci_dev *rdev;
>> +
>> +	if (pm_suspend_target_state != PM_SUSPEND_TO_IDLE)
>> +		return;
>> +
>> +	if (ab->id.device != WCN6855_DEVICE_ID)
>> +		return;
>> +
>> +	if (ab->qmi.target.fw_version >= WCN6855_S2IDLE_VER)
>> +		return;
>> +
>> +	rdev = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
>> +	if (rdev->vendor == PCI_VENDOR_ID_AMD)
>> +		ath11k_warn(ab, "fw_version 0x%x may cause spurious wakeups. Upgrade to 0x%x or later.",
>> +			    ab->qmi.target.fw_version, WCN6855_S2IDLE_VER);
> 
> I understand the reasons for this warning but I don't really trust the
> check 'ab->qmi.target.fw_version >= WCN6855_S2IDLE_VER'. I don't know
> how the firmware team populates the fw_version so I'm worried that if we
> ever switch to a different firmware branch (or similar) this warning
> might all of sudden start triggering for the users.
> 

In that case, maybe would it be better to just have a list of the public 
firmware with issue and ensure it doesn't match one of those?
