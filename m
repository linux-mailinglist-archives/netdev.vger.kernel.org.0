Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08CB4ADE4D
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 17:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383164AbiBHQYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 11:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352165AbiBHQYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 11:24:07 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C98CC061576
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 08:24:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nsj5d4UXIeXiA5Xm3sawuy3eQMevApaCC387AXm0LeuEpAyX24ucBLO5mMlMYdwfU8QsLS9Nvpz22HvEMCSV6OiNEVZnxKLitvoCW8LwyYQVIuesCfj1rtJVt3Mb4UOEjl+gXOEowQWTxr1bu1PzH4qDeBJPb4zScxU6v50sDdKHsWv3gdCniWgshE3LoBO4y23ysgpePTEdar0JyqHeBsrxD7nUmXOcDvqkOJpJksI7NLedBv8rSJ9dB5AEYOsqSXPQPiHBzTGU2OnhvlvgnfGAtG7kP+bzAn29fWMgI6xapz8mVJ8jZOgv9mBL7WwBoSgedIcaId8E3wMfPkQlFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=13YZa+6xBESqwJ4pCZbo665ubM3b9KTIKWOIJg8APTQ=;
 b=MKFGiMyf8ldPS2gC8mxxVqFbRpFvAaPUgFXk0gEp4yLhWCJHUAf3Q09AviV64d3BxcBjmZPjTGofOvriFTMlm82CnViB8rsCbIjUdN54eS5FZ1mLEoQfO3aYqDCvpBYjetKGZMV4/5C9X89aZPiTbmdYuvU8XnwF8Trb+DSTa0+vIXlo/vObRtU6Sdsms0FRlT2/FKYQgo4UDQGS05/XlysaZuuOQhUjSi68LlaQ4iqGa5gZbh9eS+/hVI4Pe+r5V1Zh4It9fhycFQTYcZW/ZstvdAnbcPF9IiYxug9YeRN78dn3QyZkzdAM6pY66uY2xSbfZClRZCtOW9doMe9pkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13YZa+6xBESqwJ4pCZbo665ubM3b9KTIKWOIJg8APTQ=;
 b=DvVcVvbRyt/m7mOjit64XXDudsU+jrDR+VkUbxiCZgSp42V1J8Zj2ED1UhgrXSF6QEwRkJFZvc1aRo+a7Cg1rTuOZdS4X9FsUeIOM11XbqsPYNZxAa0QIMMiA7tcKRP3xybPhB3dCDZmsEQAj6nWNrOpFTdqKR9obEQvRgeEA1g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by BY5PR12MB4275.namprd12.prod.outlook.com (2603:10b6:a03:20a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Tue, 8 Feb
 2022 16:24:04 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ccd7:e520:c726:d0b]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ccd7:e520:c726:d0b%7]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 16:24:04 +0000
Message-ID: <14d2dc72-4454-3493-20e7-ab3539854e37@amd.com>
Date:   Tue, 8 Feb 2022 10:24:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: AMD XGBE "phy irq request failed" kernel v5.17-rc2 on V1500B
 based board
Content-Language: en-US
To:     Thomas Kupper <thomas@kupper.org>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     netdev@vger.kernel.org
References: <45b7130e-0f39-cb54-f6a8-3ea2f602d65e@kupper.org>
 <c3e8cbdc-d3f9-d258-fcb6-761a5c6c89ed@amd.com>
 <68185240-9924-a729-7f41-0c2dd22072ce@kupper.org>
 <e1eafc13-4941-dcc8-a2d3-7f35510d0efc@amd.com>
 <06c0ae60-5f84-c749-a485-a52201a1152b@amd.com>
 <603a03f4-2765-c8e7-085c-808f67b42fa9@kupper.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <603a03f4-2765-c8e7-085c-808f67b42fa9@kupper.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0237.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::32) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92915579-0e08-49a6-e703-08d9eb1f6c12
X-MS-TrafficTypeDiagnostic: BY5PR12MB4275:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB42757A4C033C07CADF2EFFB2EC2D9@BY5PR12MB4275.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9+Zj10cH6eAzeyDVQ7mVEoup2KuEwV+uaR8JovxtxnwNKhc4XyhFx2QA87VdhoDhqfpoCmB0mY/EhxFDO+zqB8V1FjOA9nhHS8VHEf+9mnDEiVaIAoQKCo51TgQah7jZi5I8XQ6V3zrRAAkkF6OuLjEdqEOS31wVbTsLur/KKJw/djqlA9oQGGwQgCJCv/1cr/7btF6YyMqSkrcYrmnr9NyXI1Q30eXeUAX3Soqj/rtfsUlEX5fcjPO3Sl9S70NpHv64GsK/XTx91JKjlyHXWETLqCoZkCKhZjsyPh0zrQBv/rdL39O/XDZXLol4nIbvfgKXOmMPwaRl3/BiICkud75oq4BtXrzYigZ8CxTyzGU0cDRTbRMSwa9GWn6iIIKlw8ygab9XIPQfJ3MExwigylL/SLSpWfR5SgLy7rwvBKQUuiiLsWNQXHiHxCFAncOXbqZ46DYjeEHVKKBKA930vyo1qn1LeGbSSDMbuAqAJXcXeH4n14T27DZKCJsi/Gx8JcNGpktJsbaDjzs8T9m2xtP/TrYa273+XZQrEnMVde1KYO013DfqtE6vkxxhgMDwMWNxIA//FPgo7YBCTrHFPMoCTQ4yeW9a93Ad7Ywf5Wx/l0f65p5os5gxzRthyJJTb2hHhJIdAPvN6U11v7h9XpF9Cb6HgKVPpuY7zy9jPUpRNCi7tfDXHC9+aeCNnCo2MpECkymj0MywG6k8terazR/2AhTO6Nl0LMM5a0BSQdmfLlYaGjBiHCTlCoiWdpJV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66946007)(110136005)(508600001)(8936002)(66476007)(6512007)(83380400001)(6636002)(26005)(186003)(6486002)(2906002)(66556008)(8676002)(36756003)(6666004)(31686004)(31696002)(6506007)(2616005)(53546011)(38100700002)(5660300002)(316002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amNtS1JPK3lnU21CRVRmYzBHMU5DdTJqM3VyMG56S1lydHJmWnExeGlzVmdS?=
 =?utf-8?B?Sm9DTm5DMEhFdXRhZU0vVXpvWURid1lBaURFa1R4aW5acFppKzZ6cklIZFdH?=
 =?utf-8?B?MjRpN2s5a3ltSGRXdzYvRkZQWHJuOGZHa0FTRVJGTWJSYm1GU0R1d09XYjJa?=
 =?utf-8?B?Vk0vQ2lVNElVNXpnbGtLalBacnNPODJiTGNSem1WZVhtK2JKaUFXZlFvZUxz?=
 =?utf-8?B?NnhHT0UySkc1cEkrYW84cGVqQ1FwSlRtYlhpNzFxV3RoN0NSNHFKVk9YTGhQ?=
 =?utf-8?B?VG5xOEhPa1QzY2x2QUdRYjFnOExwNlEvUUlQakQ3cDgzWklZdVNmdS91cTcr?=
 =?utf-8?B?WTlHQmpKd2swWmxxS1ZrMlAzNXRBOFBnMzBWdjh5MlFoY0RhT2crUktYOVc3?=
 =?utf-8?B?NUp6cGsrMGlRYTcxUjZGZnR0elJQTkF1ZGVUYzFoK01FWXB1OVhtQVNYVU1v?=
 =?utf-8?B?dExPZzQrVzF0NXFsUktRd0psRUROVlRXS2NXQlRvM2NZWXNicStXNUxvbCtx?=
 =?utf-8?B?VmZuWlcyMmFlUFhxYng1VGFZWTA2OVpkb1RiejlkYSsza1J5N09wU2ZrUzA1?=
 =?utf-8?B?OUVhZlhnN2VzWkpxZTFYZnF1YkJYTkRvWE9JZ0ROOHlJaStIcEoyYU1kb1hI?=
 =?utf-8?B?M2poTHpQMDZjdS9XZ1NCS2FFc2FaMWxkZTBxQlMzaW84MjlFVitrUVNDcGwy?=
 =?utf-8?B?S3k4ZXpsU1VBMURMb3AwdFFGWkEwRTlidUZEZWY0NmpFVk5NNUNRY2IySnNv?=
 =?utf-8?B?U3Y1Z0Y0Wlk1cGdlL1FZRTQ3Rzhncy9aNGIzQWozbzJWS1RFMjJHZFR5OXI0?=
 =?utf-8?B?TEZHTWdMczNPVC9CWTBHODh1WFV0UzAraWErbHJlbFB6M0NuMzNmbVVsVFdS?=
 =?utf-8?B?RUxxMDQxQldaNUtGYXRoSmZBZU91cHNkSVZORmkwc0lnRFVEOHcrVlluSE9J?=
 =?utf-8?B?STZvNGJjbGZTb0kyQXEwY0R1K2R3VmVRTm1jL3VQeDZwSU5WUjZwYjNKSlhH?=
 =?utf-8?B?NXpnTnZSUUVkQi9VM0lxVjBKSWQrYytHNzR4SG1BNlBNRTlLc3c0bEpKRHdv?=
 =?utf-8?B?K0dFK3UrT0cxUlZUVllXbWFCeUcwZUY4VDZoRUFadU9pQlBHNkpXd0dubk5L?=
 =?utf-8?B?MkZ6V2hWZC9hL0VoQjFTSFArWkNjaE0wZ2lWVENrMlBZaWNnMEhrZnF6dmVD?=
 =?utf-8?B?VWoxZ0hibGZSR0hKckNndWpoeUNacFNwY3FqM1E2bzg0d2VUejBjTE5Ja1Zi?=
 =?utf-8?B?WkxTRWxHazZWdmlRek1CZFJnZ3FKQWJ0WVJNZzVTa0l1RS9Nem5Eb1Fvd0g1?=
 =?utf-8?B?SHVIaXhGQ1FRSUJKRkIzR2NONzB5MHppcWZmQTFlNUdPeDhIYmlickVGMFAv?=
 =?utf-8?B?a0t2SmlId0o5TktianFVRGVMUkd3SzV6dk4xTVRxcFA4R1M1Z2NTUndmRmVw?=
 =?utf-8?B?RWxyQ01GK2E0YXFkRDlzQm9tS21pK0JlbzQyMzNUMS94QUw2a0RkUzRsd0t3?=
 =?utf-8?B?VnBBSGlCTjd3RW41N3ozMlpBMXhuLzhwZ1hDZHpYN1dZWUpSOXVNUHlYdWZB?=
 =?utf-8?B?dytobHA5TXlOcWoxbDI1UUVuem4wTFNOdFlmVFRucytjbGt0azQyRDFNd2N2?=
 =?utf-8?B?NlF2eFhLWVVjcHlvM2h1V3RaUnJMa2xRUW5hNTk1V3ZTc2tFRVcxbFUzUDEx?=
 =?utf-8?B?UDNqQzl1UkxMTXhDZWpGTlBsSk1FNldvMVF3UkNiL043c0M3djBvQmlVV1Vu?=
 =?utf-8?B?Z09HVVdSVzBrZUs2Qkh3THU3N3BKczd1NGZYa1diUEZHdDdPa2JhUFdTUUs4?=
 =?utf-8?B?Q2lJbVkxb01GUGJQY1ZHQ1d3aU94M2ljc0pCaW5pK2RSLzZOc1lwYmNxSURB?=
 =?utf-8?B?WGNjL3FTVHZNZVllSnpGTnhHZFVzNFB5THoxZDdxUFpaYWhFQ0hBOTlLQUgv?=
 =?utf-8?B?QUluVkgwRk85NDhrazRPMWxPa2pWYmZlbjJtazcvSms2QloyUFV1WjZ5Y29a?=
 =?utf-8?B?Q25DODQ5dlpWOWpLU0NtMjVOUzdDRTYxQ1BJR3BMNmQvakVIVHBLUktFeDBN?=
 =?utf-8?B?TWJCNHluM1hBdHl0blQvWWxLaDZYNGlMaFQ1NWxtL2hGRGduMzk1NUQvNlpS?=
 =?utf-8?B?Z1dmOVh0YkNCdWxmcGYvRHI3QmUvbnVwUDc5SVpwazVid2dGcURtYWswbHFw?=
 =?utf-8?Q?OBu0r8u9Po/8fq/s6i57U6k=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92915579-0e08-49a6-e703-08d9eb1f6c12
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 16:24:04.4339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m1pyXGHvBwu6Myro+z5SGC04erxyCr0jG1lXHxkg0wcYnlEl1hRYMlnkn5OLxUlZhk0H10WCP+YJeEoGkiCnUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4275
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/22 11:59, Thomas Kupper wrote:
> 
> Am 07.02.22 um 16:19 schrieb Shyam Sundar S K:
>>
>> On 2/7/2022 8:02 PM, Tom Lendacky wrote:
>>> On 2/5/22 12:14, Thomas Kupper wrote:
>>>> Am 05.02.22 um 16:51 schrieb Tom Lendacky:
>>>>> On 2/5/22 04:06, Thomas Kupper wrote:
>>>>> Reloading the module and specify the dyndbg option to get some
>>>>> additional debug output.
>>>>>
>>>>> I'm adding Shyam to the thread, too, as I'm not familiar with the
>>>>> configuration for this chip.
>>>>>
>>>> Right after boot:
>>>>
>>>> [    5.352977] amd-xgbe 0000:06:00.1 eth0: net device enabled
>>>> [    5.354198] amd-xgbe 0000:06:00.2 eth1: net device enabled
>>>> ...
>>>> [    5.382185] amd-xgbe 0000:06:00.1 enp6s0f1: renamed from eth0
>>>> [    5.426931] amd-xgbe 0000:06:00.2 enp6s0f2: renamed from eth1
>>>> ...
>>>> [    9.701637] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
>>>> [    9.701679] amd-xgbe 0000:06:00.2 enp6s0f2: CL73 AN disabled
>>>> [    9.701715] amd-xgbe 0000:06:00.2 enp6s0f2: CL37 AN disabled
>>>> [    9.738191] amd-xgbe 0000:06:00.2 enp6s0f2: starting PHY
>>>> [    9.738219] amd-xgbe 0000:06:00.2 enp6s0f2: starting I2C
>>>> ...
>>>> [   10.742622] amd-xgbe 0000:06:00.2 enp6s0f2: firmware mailbox
>>>> command did not complete
>>>> [   10.742710] amd-xgbe 0000:06:00.2 enp6s0f2: firmware mailbox reset
>>>> performed
>>>> [   10.750813] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
>>>> [   10.768366] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
>>>> [   10.768371] amd-xgbe 0000:06:00.2 enp6s0f2: fixed PHY configuration
>>>>
>>>> Then after 'ifconfig enp6s0f2 up':
>>>>
>>>> [  189.184928] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
>>>> [  189.191828] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
>>>> [  189.191863] amd-xgbe 0000:06:00.2 enp6s0f2: CL73 AN disabled
>>>> [  189.191894] amd-xgbe 0000:06:00.2 enp6s0f2: CL37 AN disabled
>>>> [  189.196338] amd-xgbe 0000:06:00.2 enp6s0f2: starting PHY
>>>> [  189.198792] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
>>>> [  189.212036] genirq: Flags mismatch irq 69. 00000000 (enp6s0f2-pcs)
>>>> vs. 00000000 (enp6s0f2-pcs)
>>>> [  189.221700] amd-xgbe 0000:06:00.2 enp6s0f2: phy irq request failed
>>>> [  189.231051] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
>>>> [  189.231054] amd-xgbe 0000:06:00.2 enp6s0f2: stopping I2C
>>>>
>>> Please ensure that the ethtool msglvl is on for drv and probe. I was
>>> expecting to see some additional debug messages that I don't see here.
>>>
>>> Also, if you can provide the lspci output for the device (using -nn and
>>> -vv) that might be helpful as well.
>>>
>>> Shyam will be the best one to understand what is going on here.
>> On some other platforms, we have seen similar kind of problems getting
>> reported. There is a fix sent for validation.
>>
>> The root cause is that removal of xgbe driver is causing interrupt storm
>> on the MP2 device (Sensor Fusion Hub).
>>
>> Shall submit a fix soon to upstream once the validation is done, you may
>> give it a try with that and see if that helps.
>>
>> Thanks,
>> Shyam
>>
>>> Thanks,
>>> Tom
> 
> Shyam, I will check the git logs for the relevant commit then from time to 
> time.
> Looking at the code diff from OPNsense and the latest Linux kernel I 
> assumed that there would much more to do then fix a irq strom (but I have 
> no idea about the inner working of the kernel).
> 
> Nevermind: Setting the 'msglvl 0x3' with ethtool the following info can be 
> found in dmesg:
> 
> Running : $ ifconfig enp6s0f2 up
> SIOCSIFFLAGS: Invalid argument
> 
> ... and 'dmesg':
> 
> [   55.177447] amd-xgbe 0000:06:00.2 enp6s0f2: channel-0: cpu=0, node=0
> [   55.177456] amd-xgbe 0000:06:00.2 enp6s0f2: channel-0: 
> dma_regs=00000000d11bf3f1, dma_irq=74, tx=00000000dd57b5c4, 
> rx=00000000d73e70f8
> [   55.177464] amd-xgbe 0000:06:00.2 enp6s0f2: channel-1: cpu=1, node=0
> [   55.177467] amd-xgbe 0000:06:00.2 enp6s0f2: channel-1: 
> dma_regs=000000000d972dd7, dma_irq=75, tx=00000000573bcff8, 
> rx=000000003d9a6f65
> [   55.177473] amd-xgbe 0000:06:00.2 enp6s0f2: channel-2: cpu=2, node=0
> [   55.177476] amd-xgbe 0000:06:00.2 enp6s0f2: channel-2: 
> dma_regs=0000000046f71179, dma_irq=76, tx=00000000897116c9, 
> rx=0000000004ba17e7
> [   55.177480] amd-xgbe 0000:06:00.2 enp6s0f2: channel-0 - Tx ring:
> [   55.177502] amd-xgbe 0000:06:00.2 enp6s0f2: rdesc=00000000794657ba, 
> rdesc_dma=0x000000010fad8000, rdata=0000000008ace7d8, node=0
> [   55.177507] amd-xgbe 0000:06:00.2 enp6s0f2: channel-0 - Rx ring:
> [   55.177523] amd-xgbe 0000:06:00.2 enp6s0f2: rdesc=000000009313d9b3, 
> rdesc_dma=0x0000000114538000, rdata=00000000510e3b77, node=0
> [   55.177527] amd-xgbe 0000:06:00.2 enp6s0f2: channel-1 - Tx ring:
> [   55.177543] amd-xgbe 0000:06:00.2 enp6s0f2: rdesc=00000000d26d9194, 
> rdesc_dma=0x000000010a774000, rdata=00000000b9419829, node=0
> [   55.177547] amd-xgbe 0000:06:00.2 enp6s0f2: channel-1 - Rx ring:
> [   55.177564] amd-xgbe 0000:06:00.2 enp6s0f2: rdesc=0000000007bf60dd, 
> rdesc_dma=0x000000010fb84000, rdata=00000000aa48e8c0, node=0
> [   55.177568] amd-xgbe 0000:06:00.2 enp6s0f2: channel-2 - Tx ring:
> [   55.177584] amd-xgbe 0000:06:00.2 enp6s0f2: rdesc=00000000e7e6c52e, 
> rdesc_dma=0x000000010fa2a000, rdata=0000000017b5d85c, node=0
> [   55.177587] amd-xgbe 0000:06:00.2 enp6s0f2: channel-2 - Rx ring:
> [   55.177603] amd-xgbe 0000:06:00.2 enp6s0f2: rdesc=000000000898fbf4, 
> rdesc_dma=0x0000000101f08000, rdata=00000000aded7d4c, node=0
> [   55.182366] amd-xgbe 0000:06:00.2 enp6s0f2: TXq0 mapped to TC0
> [   55.182381] amd-xgbe 0000:06:00.2 enp6s0f2: TXq1 mapped to TC1
> [   55.182388] amd-xgbe 0000:06:00.2 enp6s0f2: TXq2 mapped to TC2
> [   55.182395] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO0 mapped to RXq0
> [   55.182400] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO1 mapped to RXq0
> [   55.182405] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO2 mapped to RXq0
> [   55.182410] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO3 mapped to RXq1
> [   55.182414] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO4 mapped to RXq1
> [   55.182418] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO5 mapped to RXq1
> [   55.182423] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO6 mapped to RXq2
> [   55.182427] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO7 mapped to RXq2
> [   55.182473] amd-xgbe 0000:06:00.2 enp6s0f2: 3 Tx hardware queues, 21760 
> byte fifo per queue
> [   55.182501] amd-xgbe 0000:06:00.2 enp6s0f2: 3 Rx hardware queues, 21760 
> byte fifo per queue
> [   55.182544] amd-xgbe 0000:06:00.2 enp6s0f2: flow control enabled for RXq0
> [   55.182550] amd-xgbe 0000:06:00.2 enp6s0f2: flow control enabled for RXq1
> [   55.182556] amd-xgbe 0000:06:00.2 enp6s0f2: flow control enabled for RXq2
> [   56.178946] amd-xgbe 0000:06:00.2 enp6s0f2: SFP detected:
> [   56.178954] amd-xgbe 0000:06:00.2 enp6s0f2:   vendor: MikroTik
> [   56.178958] amd-xgbe 0000:06:00.2 enp6s0f2:   part number: S+AO0005
> [   56.178961] amd-xgbe 0000:06:00.2 enp6s0f2:   revision level: 1.0
> [   56.178963] amd-xgbe 0000:06:00.2 enp6s0f2:   serial number: 
> STST050B1900001
> 

Ah, it's been a while since I've had to use the debug support. Could you 
also set the module debug parameter to 0x37 (debug=0x37) when loading the 
module. That will capture some of the debug messages that are issued on 
driver load. Sorry about that...

Thanks,
Tom
