Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52076891ED
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbjBCIVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbjBCIVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:21:10 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1845E6D5E5
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 00:19:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aOB5x4K//+3SzHa6qjbO8cxyOzMbo4rzHBHf484bMT36d/5YtbQ8kJNCzblrGbaTr1MYZfdXDA72QP+pe7cvWjlDlfcw+J3TQS/0ULSU3vvWicfpi2U1Tx/M+6wrycyFtTjnSxu6z1joHoSM4QnFONYL8Xdb93+XtvKe9+SlrOf2Iq4A6YA3Tx2Ti8BBHtgIGi+eL4JmIdJV8QEEmClxQ3qkdaTvY9SdG7n7l2gxgHB81zDm1GI/uLSh2obBtIwI1eFDcR9A8Hs+2wwMIQbGplCRBR/x12Mq5+XC0Djq0VffS3jzWz3C9IqSkEKholdIVUJGTeapYXeufXOkPcKHcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ClXbYMTwEWpeAI9+CLYXyEwLE4M8meFvbt0kWAUZmb4=;
 b=cfhmKEVmH7s19AyAEGyioL1mA8OSCtTCRXaHAUQhZX5XVZSC16jnOICrLjq7m8OcRO8Y54n2MPEpp/3gknl03QhR86UWOtexitqbjffwgqmv5QhpnHf8pcYNr2dIkc5vEy+sugwYGdN6prFN61caTbfHJC+zAJU95hLnPNdqCfWIfVw36FTLfKJVB/jEH/Ge3czb8CMj6de75Q+nIeZ7UtKfZW0QkIdXhE23FR9LzeynUnp9FEgU35s0CM2FmZVx/WxuNXBlfrZd7/gs7D8h6U4PAIcvPZv7MUQtGS8PySiuG34O4CY9NTCF7m6vrek3r/Yo9zCBgvjxL6Ohs4+eDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ClXbYMTwEWpeAI9+CLYXyEwLE4M8meFvbt0kWAUZmb4=;
 b=nOeaKNk+j7eJZRp+ZjWbEiQx4KMNXidWw/tuZPbazGHUyOJ2QpTJcfyENkK7B9lvM8GEZr6T8/zCvQfXF4Z23U9sEwPxqK9YhJwfjKKdDhkA6Yujni/GY6LC6L1OTYP0d9W4WegiKa0N4nud29mmm6JW7yiKx1+ibpeLXk2LIyg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4170.namprd12.prod.outlook.com (2603:10b6:5:219::20)
 by PH7PR12MB6420.namprd12.prod.outlook.com (2603:10b6:510:1fc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Fri, 3 Feb
 2023 08:19:12 +0000
Received: from DM6PR12MB4170.namprd12.prod.outlook.com
 ([fe80::a2d2:21cc:bc90:630c]) by DM6PR12MB4170.namprd12.prod.outlook.com
 ([fe80::a2d2:21cc:bc90:630c%3]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 08:19:12 +0000
Message-ID: <325a736b-b6b1-9863-3efd-c61f4ca8ae76@amd.com>
Date:   Fri, 3 Feb 2023 13:49:01 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v2 2/2] amd-xgbe: add support for rx-adaptation
To:     Simon Horman <simon.horman@corigine.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, Shyam-sundar.S-k@amd.com
References: <20230201054932.212700-1-Raju.Rangoju@amd.com>
 <20230201054932.212700-3-Raju.Rangoju@amd.com>
 <Y9qdRsS5txwu3MND@corigine.com>
 <52212a21490af8e45588bd0e17ffc54655d44b87.camel@redhat.com>
 <Y9zBL/3GdBRRRh+i@corigine.com>
Content-Language: en-US
From:   Raju Rangoju <Raju.Rangoju@amd.com>
In-Reply-To: <Y9zBL/3GdBRRRh+i@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0015.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::19) To DM6PR12MB4170.namprd12.prod.outlook.com
 (2603:10b6:5:219::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4170:EE_|PH7PR12MB6420:EE_
X-MS-Office365-Filtering-Correlation-Id: a2a4e091-b14c-4b4e-bfe5-08db05bf5499
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r23JNk/bv3N1T/SAkNBNmFYiAandw1rMP6F/hSXsaFO5n5pwjacSKBNhNDPT9eDoFdvaRJ12QTzgZdQNBJoSOJtxX3itmliwSmi1SHM6p/VUptGlXJjkBpcFAg/694+A0WtmcKaLnfAVYfLXpBCK/Ylz7snDRQddmZxYGARWsegObWOfkHe8yIaAiBdy2pWf5cjNfeTtReziQDYgoMnbj+URyRMUKJ/0A4OabvMortcLREZxdTFomf/dPvUnH15eZfW5sDRyCTj3FFgwBM66ji8LDZvK3IyczEnv7TtOGr66Tv1hp3xvbO/V75FNq/Bthv2oRWmwopf+OoRYGYEwb7OCNO1wWZmnmlU/Vus7J6H3j/AeMqKaM4tz350RPwIJywab0KdSoWJ8YQxW/mGFv9U0792RYXbsG6y9GPVZm6pKKk05cTGr9LzR3WsDz+fhNoEpOPf832uH1OSrAugpf7PXskcz0zx/MYqpbBVwhztGRhNHQtus7qSivDESxAUQmbuYnzYhri6s+eNQ3jljnsMr+EADTT2Is7k4jtFHEnhlTy0Vejgy0pDdJIMO+0PqPpba3b2n6WIVSgwlnGkJBm4Bas7FToXIzoWIii2StvALLkdwjdvKk2GQUytDkpTPYxzXlvFiXK85PnIfnfU5RAl2BC7y6KlQEG73CzBWf5bRUjk/2S3lRSxW9jZJW03QlmknCAlC//4z9cNV1MrDHfDLqnU+kJZZH8nwmGUP5xg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4170.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199018)(31686004)(38100700002)(36756003)(31696002)(86362001)(6512007)(186003)(83380400001)(2616005)(53546011)(6506007)(6666004)(8676002)(2906002)(478600001)(66946007)(66556008)(66476007)(6486002)(8936002)(5660300002)(41300700001)(4326008)(316002)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHVmV3JvWG1adFN3R2FEbzFGRndyZ2RjSmJyZmxEV0JTYUpLdVByT1dPRVZu?=
 =?utf-8?B?d1pSZUNtamhEYkZIVXFiL2RESlhyWkR0WWFFbEtUajJ0RlJ0WHVEY2JlczUr?=
 =?utf-8?B?alpBeUc2TUVENU16dGpsSS9lTWpVZ0ZNUldnaEFYSC9sVkFYajQrdkFjL1By?=
 =?utf-8?B?cDFIZHhhQnY0bmE5ckZRcFRhbnR2M2VyTW5DNC9LSG11ZmgrNGJHd0tlZ2FD?=
 =?utf-8?B?TmMzdjFyTFZ2NU4xUU83RnNrT056TGRHTHFqTUpRNkdFUzNBemw4OUdrajdr?=
 =?utf-8?B?STZobkwrblA3YWpJWVYwSVFYZklsc3RWRW1EVVI0M2JqcVYwWTB6anFmd2cw?=
 =?utf-8?B?bS9OVnVVVndVMjNrdkFsaVhobUR3VDRyc1g0dDJBWGFWdzY2MUlkSTlyc21x?=
 =?utf-8?B?amZ6MmF1TjdZbFhkLzJQcjU3MWV4NDhzZHQvaDBZS0Y3TEdkd2ZTbTFtMG9L?=
 =?utf-8?B?QTFNZ1NJQ1B2UVBoRG11ZlVvOFh1eEczYVRRaE5peFgwbWRUdVRWRjF2ejF5?=
 =?utf-8?B?bi8xdGM4N0F5SFdheFpWSVZSWkFvTk1hTy9KcGtBdG1PMHM2NlltYmhML0sv?=
 =?utf-8?B?UjBjTWwveWVQa3ZweWxMaU1GTllBa3REMUFFTUR4bnpKRGhrVFNYL0VTSXBz?=
 =?utf-8?B?U0ZmTi9KcUErb0JYSFZkclNKdWhUSEUyUkNhZi9jdXZNVzlpdHU2RVYwKy9u?=
 =?utf-8?B?MXEwRFBjTTVaWDdXMmd2VlBLRlNieExxeXpRcThhTzZkWVdtNExEVXlrdVJO?=
 =?utf-8?B?a0J6a1pMZ3ZMK3hRNmgzUy9HRWtLZy9Zb1Q2bjhzWGFtRGxaemZQWnBmUmRs?=
 =?utf-8?B?S3VTS2tFNTg4OWs1ZDdxVFhYWE9mMHo3R3RiYTFxMEdHY2VrcjEyMTVHeWIr?=
 =?utf-8?B?VFEvR2NaeFVBSTEyTmlKcGlKOTJGMjJtM2JxYnB4MEVsY25tNGgrZzA5TDBM?=
 =?utf-8?B?YkNmZTBUNUd5TCtoM3Z0MUwyQjVqeHZLV1ZqMWtuNllVd3FxR2o4NzYrUlc4?=
 =?utf-8?B?UjZPKzcwTDhBdXhVczZzejNNa29HNHd4dWx5VmhiNCt0QWhyUVZzRytrVml0?=
 =?utf-8?B?ejI3S1VhOUZJN3E2SnJydEthZ1BIUDJnQVUxVE1aV2Rmb0dEQWVGREJNekx2?=
 =?utf-8?B?Y1o4eThuRGFyMSsyQk9ESnlQUHVtaEM0dEp3YVY3UlhNcUdVMzV6TGhEL1I2?=
 =?utf-8?B?MDEvdHJoeEJOWHJrSitOSDI4NUNpelVSUCtQSld2bVpsa3diM0F1L0ljQW56?=
 =?utf-8?B?cmc2dDc4M3hzZTkveFJTWEs2SGh1RTlaclNUbkNvYzJzYW1CTlBRSXpkblV6?=
 =?utf-8?B?RlhXaCtGTTdSRjBvS2FLZXJOV3NMRlhxak5XSVNLUjVrWUpkN0U3M2xvMXJ0?=
 =?utf-8?B?ZE9VWmVteGZXN09GS3FFUVhYcjlRY0ZUK3dYcUkyWWtoSzVheFloelRWVUVP?=
 =?utf-8?B?ZmUrOVdXOE9OSFMzZVZhcWRRSWlBbjUvTWVnU3JaR2cvOWRjZDZ1Y0dBVFlB?=
 =?utf-8?B?YWxmeTloZ0tiY284aGFrT1hrek0rd282OHFSdGZGZnd3c2YxaHNYYWtvWm4y?=
 =?utf-8?B?MHZEVVgzZzZQUlNqM0JXd3ZIUkJsQWNWdHYwUVlwc2Jzc2ZDT1B0QVVHVS9K?=
 =?utf-8?B?TVJBN0FReXRTM2dYdlRYaDRvb1lhdXdlUkp6ZjloWnVPaHJLclhDbkhnRWd1?=
 =?utf-8?B?TjUraG81WW10QStwRWVlY3RxbGVkdXNVV0duS2dUY1hBeG9tYnltUjlGS2sv?=
 =?utf-8?B?UE5VN2twQzROWTM5dW9NcGlyTTJzejBCT1ZYT05PY0JHUUZqQ093RWkvSVNO?=
 =?utf-8?B?SFFUaXordjIxQ05DYklGWlRDWlpOQUFsZHJFT2h0dDE2ei96QkZvSzBPQTUx?=
 =?utf-8?B?NjM4RGpkZW9xN3Q4eGtqNzMwSDMzeEhjR1RGMGFaNXIydmthamFIWURBSzAr?=
 =?utf-8?B?bVlFRGtOSlo3Vm9vVkRha3paZGoyOSs4NSt2aCs0QWJCYVFWeVM1VzZDdW8w?=
 =?utf-8?B?M2ZQRm1meDhybnBxemlEa0M5cHFCWVVkSDNjWnpUMnNGQUtsQm9NUVpuVm1r?=
 =?utf-8?B?TVdWRVR0VXlkMGFOenZZUGt1RUNIeVY4bG1iWnE0cmlrUFdPRzc2MHJWRzdV?=
 =?utf-8?B?K3ZLRlErS0YxdU1YR1VyNlQzYkVMMDNJM0pTeGNFZmdtNTk5bWRGOGc4MEx2?=
 =?utf-8?Q?i8znEFaErvOxWH9xXP9I9l5AWZRC23MN8lxJPVfbImxw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2a4e091-b14c-4b4e-bfe5-08db05bf5499
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4170.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 08:19:12.2726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zQ4SYwXN01JvjSlABY4vTpbNG8YmtBPq1fN0d88IU66Lmc59bNOuN32/OoE5Ln50VxVR+21twPPDy5tpc3s8AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6420
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/3/2023 1:39 PM, Simon Horman wrote:
> On Thu, Feb 02, 2023 at 03:16:50PM +0100, Paolo Abeni wrote:
>> On Wed, 2023-02-01 at 18:11 +0100, Simon Horman wrote:
>>> On Wed, Feb 01, 2023 at 11:19:32AM +0530, Raju Rangoju wrote:
>>>> The existing implementation for non-Autonegotiation 10G speed modes does
>>>> not enable RX adaptation in the Driver and FW. The RX Equalization
>>>> settings (AFE settings alone) are manually configured and the existing
>>>> link-up sequence in the driver does not perform rx adaptation process as
>>>> mentioned in the Synopsys databook. There's a customer request for 10G
>>>> backplane mode without Auto-negotiation and for the DAC cables of more
>>>> significant length that follow the non-Autonegotiation mode. These modes
>>>> require PHY to perform RX Adaptation.
>>>>
>>>> The proposed logic adds the necessary changes to Yellow Carp devices to
>>>> ensure seamless RX Adaptation for 10G-SFI (LONG DAC) and 10G-KR without
>>>> AN (CL72 not present). The RX adaptation core algorithm is executed by
>>>> firmware, however, to achieve that a new mailbox sub-command is required
>>>> to be sent by the driver.
>>>>
>>>> Co-developed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
>>>> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
>>>> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
>>>
>>> ...
>>>
>>>> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
>>>> index 16e73df3e9b9..ad136ed493ed 100644
>>>> --- a/drivers/net/ethernet/amd/xgbe/xgbe.h
>>>> +++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
>>>> @@ -625,6 +625,7 @@ enum xgbe_mb_cmd {
>>>>   
>>>>   enum xgbe_mb_subcmd {
>>>>   	XGBE_MB_SUBCMD_NONE = 0,
>>>> +	XGBE_MB_SUBCMD_RX_ADAP,
>>>>   
>>>>   	/* 10GbE SFP subcommands */
>>>>   	XGBE_MB_SUBCMD_ACTIVE = 0,
>>>> @@ -1316,6 +1317,10 @@ struct xgbe_prv_data {
>>>>   
>>>>   	bool debugfs_an_cdr_workaround;
>>>>   	bool debugfs_an_cdr_track_early;
>>>> +	bool en_rx_adap;
>>>
>>> nit: there is a 1 byte hole here (on x86_64)
>>
>> I think even in the current form is ok. The total size of the struct is
>> not going to change, due to alignment, and the fields will sit in the
>> same cacheline in both cases.
>>
>> I guess the layout could be changed later if needed.
> 
> Ok, I did think it was worth mentioning.
> But I agree that it doesn't need to be changed at this time.

Thanks Simon for taking time to review the patch. I'll try to handle it 
at a later point in time.
