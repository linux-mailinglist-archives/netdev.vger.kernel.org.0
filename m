Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D799D6829BA
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 10:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbjAaJ43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 04:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbjAaJ41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 04:56:27 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB27474D0
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:56:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ojm18sMQEaAsqeHeOrzZVMN+YzKGpc1cfkf+sdBSEXpaB6K+qIZRYNIMjZTOZOwDrQpg6X7g53QNDvPGN65FShhuxj/cLc9MrHXIorDMGK9FjIwv6k4lKFONB4lDxuYmMFKeOrkbBJmoQILuapPI6pHLhll5YxKoUdtLAwYeqyZC4xpFUb9VQUtc4CWk43zye4pA8ARB44KGFWgkpaGPjcNdt7qUgidNVuXzhz9Wi+94X5N+p54O3CVFcJlB3zMi/B/EfkksPGr9kqlZ+SQPbeRavQxL5h95MRsoDFhyoVeIJ7nIvki7/9yVaf/coDC7tOEr1i0z4AOCPlm6WXddVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zqcPR76S+Zm9O+J7X+BApGA1c1IraN67Z0hYyeTK2Ak=;
 b=bpE37bXS1qOfov2KuHDwQkcQI4UbKOOb78kZfX77Rlds/PPZxJQDobO3EJa1vxI6lFYkC4L+zPcihoDha4UJcF2vMYvAG8iRl8k2f2NatUxKTBx3vo6QS6rFgpVs1P4qkGgWzwmw9znzerGCIj0SO9W1AbeYYbC3FEZByP73lCa/TWDIhoLEv/BDeRdhna9RPb1ZEyu/phS97DG67LZvsYakmBExJSbd7tyR/q8jTIDFyagv0BZK9pOH+k5GCiUA3GbZEkW/UAvwxo4MWkM/kv2OWdGT6+b582d2i1Tgo5sdJUXRJrB3NcMiR6anMs/MvVIjB9McRog/9tHeUTajfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqcPR76S+Zm9O+J7X+BApGA1c1IraN67Z0hYyeTK2Ak=;
 b=OaAfWvsJpKnRbbyTXDuq0TlQ9kOto7fMcuNLsjmbU70pwHUZuP8ZCa/8j1CtHQlWgqnoQesVy9y/ERXXA2Md+X4CXleanEanshSlIz7+7S48YqAWNCE2f0Dm0SSiRaXHMrixJtM5vrMT3X5NpT3i6ii0k2I3092YKGK6T/js/cI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4170.namprd12.prod.outlook.com (2603:10b6:5:219::20)
 by SN7PR12MB8028.namprd12.prod.outlook.com (2603:10b6:806:341::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 09:56:24 +0000
Received: from DM6PR12MB4170.namprd12.prod.outlook.com
 ([fe80::a2d2:21cc:bc90:630c]) by DM6PR12MB4170.namprd12.prod.outlook.com
 ([fe80::a2d2:21cc:bc90:630c%3]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 09:56:24 +0000
Message-ID: <c1ddd073-2494-9c8a-0f61-8330d7d6bb0c@amd.com>
Date:   Tue, 31 Jan 2023 15:26:14 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 2/2] amd-xgbe: add support for rx-adaptation
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, Shyam-sundar.S-k@amd.com
References: <20230125072529.2222420-1-Raju.Rangoju@amd.com>
 <20230125072529.2222420-3-Raju.Rangoju@amd.com>
 <20230125230410.79342e6a@kernel.org>
 <f4a2cd5d-7d36-6f4d-6012-7e4e87d44d7c@amd.com>
Content-Language: en-US
In-Reply-To: <f4a2cd5d-7d36-6f4d-6012-7e4e87d44d7c@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN0PR01CA0013.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4f::18) To DM6PR12MB4170.namprd12.prod.outlook.com
 (2603:10b6:5:219::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4170:EE_|SN7PR12MB8028:EE_
X-MS-Office365-Filtering-Correlation-Id: c84ae9b3-4f77-4842-2002-08db03716965
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d5gDsMfL+TNrPHIYy3Skdr2IQQNjxpiIf++jnuAMB0SQrPigp0ESKrYaXMqr1nyDeN/b7JFiB5avjw7FFrVrDzTcxdnfdSHYfHfVLHdiE1Ywhb0EXzzq/7/sIYmZPRHNT4A9Nn4pC38lvR3bj6fqaDI/JFwPvYKhAIjVtCaa6cQDkuxuBD/W7fMjI8i4qoVip32pcXLUlZ3A9wqZmxWeY5BLRbwkN21jJUtS94Fg8MfqqulBLsMUQLPidBIR/V+iWqnAsemDU0AwbyFMQbMkDV2F/vG4qDHXvkFGAUAU+e8eTOtHAyTIDM1+BVm3Liqkvq5Xc2yCJ3NEs4G7pm3mNUStMPEMgwJOOyJji8Nem4d6IyUPOnRVqsNq2FJu0zKuI1L1DZAvvfDi2ov3+7rneps9xHIkpA1L3hgYlEFXObrTHaj+FOjnXIfYpm/0S5YI2t/VOMaEpxbWKPQx0CKDmk6rdObQeWXtLe4wN0KbC8u/EBysesVn4qxNVLgeRayLoEJ8pQaortqUVkUq4EXMiLz8LSd7kLzdNc6tNIY5sywoHUNTG+eFbhvDajtjYKrCz4gFFoNHvx17iK6JDvH/SjkDBRNMakcV8qxIpjSKxqiXtLFyN86WOkFseyIsks9c27bH3gdDWejzEzxlyk05USh2BySD5G92h0qqNuJP6eC4OvUF3dpqd/NpZVQv9O+pT6Bffz2csRVLYrqa/k2rFA7xmAz99ECT6TjZ5XxU1AE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4170.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(396003)(366004)(136003)(451199018)(31696002)(31686004)(8676002)(66476007)(66556008)(6916009)(4326008)(41300700001)(8936002)(66946007)(83380400001)(478600001)(86362001)(316002)(2906002)(38100700002)(6666004)(6506007)(6486002)(26005)(53546011)(5660300002)(186003)(6512007)(36756003)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REJBeHJnbWtWRGpVZE1yTGYzMDVBMW81WVlVU3NZc1dDSjdGNGNndFdzMUZi?=
 =?utf-8?B?ZmlMdHVpZWpyNnRUKzNjS0dpVkxqalRTQTNmNFJieUR4djdpdHoraFNEVXNN?=
 =?utf-8?B?eTM2VVVJL3YxRFdvcEdMdFpmN21jUWR0SWRSaEFxcVVQQWFTUzZvSXBnWFlu?=
 =?utf-8?B?bk41VW5EUkZ5WjdXcWN0andHKzE2OHpmYnpOK1ByV1BJUGluTVVBdmlxQVNk?=
 =?utf-8?B?OGZ1K0ZHM25FSkNiTnNNazFVRWwvc3JYSjFVcEVCUndEdWhrRklreklUbEsx?=
 =?utf-8?B?Tm5JL1NWOXo5VEN1c2JKTWN6VDJFSktUdjFoM0g5QmRIMmtNczMvUk9aSlVl?=
 =?utf-8?B?amxvMmhLUnd4MVlwSTMvQnZFSVZnelpYUzUvTGRMaDBpME9xTEU3WGMrTkdB?=
 =?utf-8?B?K1lXdGQ1N3VPODQva0hkaEttL2hGR3JQNU1wQjBCNEREY0NXbWpUeENya3hY?=
 =?utf-8?B?Y2Z2aXdSNVhBaGdqci9YZlRrVk1FVVFZL0FvQkVZcmg0bEZCLzgwcGRyVmU1?=
 =?utf-8?B?VWs0dTNYYVlaTk9BKzRmTWtrV2MySGl5L0pNZDliRDlGWmZNWlZlYmxTTTV4?=
 =?utf-8?B?cXlFd3NqdDd0cGhsZkVub0szam12QVhaNndRZ0g1NFIxckkyRzljL2tBNHZp?=
 =?utf-8?B?M3JDbXJqU2VLMHdqREdVblVGc2ZKOFpTTlA5bm5rY2VicWZrS1Q1Z2NOd1hy?=
 =?utf-8?B?NHhiT2JoWSt3Z2lPNjdCQWNpeHpVcDBOa0xCMTZVdFZJWjNpTTdwcmoyR3ZB?=
 =?utf-8?B?UFJQYW52N2QrT05BT3BWMDBsclNvaWJYY05CcnFZWTU2enNsTGlpNjZPazdP?=
 =?utf-8?B?YVdJalVrQ0tZRDgyWm1pYjBldFhVWjErN2tLQVY2T09BQVN5aE5lSFpyanI3?=
 =?utf-8?B?anVWeGU5ZVVSa0w3NGpBekFCSzltZXVnb3BYU0l3MG1sbVBZeW4xclp2S0ww?=
 =?utf-8?B?R09nZ3FQelYzUHRDK042a0hOcTJMV3hzNGt0WEhldEc1Ni9MM2cxdTJ5SU9L?=
 =?utf-8?B?YjRGWWJtUmk4aUxLSndxc0pqWk5INU9IdmpIdzdRUlBoaE9iT0JrdmxDNGY3?=
 =?utf-8?B?R3pad05GTXJhN0J2amcxTWx5anp6SE1rd1lobVNXOFpXTjVteVNzSEFyTkNW?=
 =?utf-8?B?N1VQRmpsT2JTdytRb2oyRnlXQ3UvbnZXNVQ2SVVjc0hROTllV05HUzdYR1R1?=
 =?utf-8?B?eXg3ZWlHb0RTbitmdGRBdEpqSmpwa1gwKzhnejF5NTFNRUEvV1I4S0NudVBj?=
 =?utf-8?B?MlBMUkFPQW9sYlUwc01xcXpaTUVVMWp1cUQzVExEbWRQa0xNMjNXQmFQdSt4?=
 =?utf-8?B?VnpkNnBiL0ZEY015ZVJsekFDeUlkSlY1cWZ4S3ZSR244TzZ0V3lqSkxVY3dM?=
 =?utf-8?B?WVZrcHViZFhZd1p5WXMwS0dFcnA2N2w1a016NUdiSjZxbldQSjkzSVNoRENH?=
 =?utf-8?B?NGkySVM1S3NRbHNxU0JDd1BNaHA5a2xFaWNQdXRyakhtUTB2SGx1akxhSFZZ?=
 =?utf-8?B?ZDV1cDMxMExiTkNpd3JXVklBWEpiRWFKY29MVXVKTFZSenpRR0c5ME83dEht?=
 =?utf-8?B?eEdPckgvQk90bCtmNVFBMG9YanhkWFJweDFIc0pMQjYxY2pwS3kycmRuWG92?=
 =?utf-8?B?dGpNZTkweUFQWCtVZ1hkZ1RIbDNtdE4zK3Q4M0RBME5lV1FPNzB4YVNpNUw2?=
 =?utf-8?B?THhrN09SRi9oemc0THRqaHJPbmtESW1GeTdnbnlJNlNtY3dzSXlhaU9mVE1t?=
 =?utf-8?B?a1pGWm9ONTRocUtYU01TelNPUFNaSE8rbHNNSTdWZXFvdXNiR2JTS1dxdGJE?=
 =?utf-8?B?ZmlWbjVIbmRVSGRyVjk2R3h0bVZ4cnBrcEZ4RzFYNFBGV2V2RG1MZW1qMTM5?=
 =?utf-8?B?RVdGSDVnb0pFVGhnMU1JdS9ub2VsMTdMdFFUZDBQOGVsR2VuOUx5Q2pNQmV1?=
 =?utf-8?B?SzBjdGYzMVJkeEJ6YTVBNGxYVXBnZDdYa001cFZuWUtadmxCTDdWWlBRMFND?=
 =?utf-8?B?cGh2YTBYc3Z6VVZrNXZTbmZHT1N1S2JVcjkvRzZDcjg0eGlneE5BSC9vanlR?=
 =?utf-8?B?VnhKUERFeXZBQ285NGhvSWFRenNPZ25PVmp0OUNLRmVDRXlQOHFmWHpaTkRW?=
 =?utf-8?Q?l6QwmjTaQ4BZNjtg8nvloWubg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c84ae9b3-4f77-4842-2002-08db03716965
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4170.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 09:56:24.1073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bv/pybirzaqBOxmSrcfcFIbo6BoS64XU9zAgUe+Dd36NeH2C1P3pTvs7EXfWKy4b7CP4LK4Ysqmpss1jwuj0Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8028
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/2023 1:13 PM, Raju Rangoju wrote:
> 
> On 1/26/2023 12:34 PM, Jakub Kicinski wrote:
>> On Wed, 25 Jan 2023 12:55:29 +0530 Raju Rangoju wrote:
>>> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>>> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>>> @@ -387,7 +387,13 @@ struct xgbe_phy_data {
>>>   /* I2C, MDIO and GPIO lines are muxed, so only one device at a time */
>>>   static DEFINE_MUTEX(xgbe_phy_comm_lock);
>>> +static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>>> +                    unsigned int cmd, unsigned int sub_cmd);
>>>   static enum xgbe_an_mode xgbe_phy_an_mode(struct xgbe_prv_data 
>>> *pdata);
>>> +static void xgbe_phy_rrc(struct xgbe_prv_data *pdata);
>>> +static void xgbe_phy_set_mode(struct xgbe_prv_data *pdata, enum 
>>> xgbe_mode mode);
>>> +static void xgbe_phy_kr_mode(struct xgbe_prv_data *pdata);
>>> +static void xgbe_phy_sfi_mode(struct xgbe_prv_data *pdata);
>>
>> Why the forward declarations? It's against the kernel coding style.
> 
> Hi Jakub,
> 
> Sure, I've re-ordered most of the functions correctly to avoid forward 
> declarations. However, there is circular dependency on couple of them. 
> Let us know if its fine to have forward declaration for the functions 
> that have circular-dependency.

Hi Jakub,

Gentle reminder!

Let us know if it is okay to have forward declarations for functions 
that have circular dependency.

Thanks,
Raju

> 
>>
>>>   static int xgbe_phy_i2c_xfer(struct xgbe_prv_data *pdata,
>>>                    struct xgbe_i2c_op *i2c_op)
>>> @@ -2038,6 +2044,87 @@ static void xgbe_phy_set_redrv_mode(struct 
>>> xgbe_prv_data *pdata)
>>>       xgbe_phy_put_comm_ownership(pdata);
>>>   }
>>> +#define MAX_RX_ADAPT_RETRIES    1
>>> +#define XGBE_PMA_RX_VAL_SIG_MASK    (XGBE_PMA_RX_SIG_DET_0_MASK | 
>>> XGBE_PMA_RX_VALID_0_MASK)
>>> +
>>> +static inline void xgbe_set_rx_adap_mode(struct xgbe_prv_data 
>>> *pdata, enum xgbe_mode mode)
>>
>> Don't pointlessly use inline, please. The compiler will know when
>> to inline, and this is not the datapath.
> 
> Sure, I'll take care of this in the next revision.
