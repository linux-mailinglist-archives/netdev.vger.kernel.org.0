Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 227D767DEA9
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 08:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbjA0Hnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 02:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbjA0Hng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 02:43:36 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2077.outbound.protection.outlook.com [40.107.212.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190C139282
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 23:43:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e7SUftivZoywt7aO2kVqtReU7co9NN7O1zT+sTnbKlTyb3j8R/eJcgVEAxzF1TOR4btra51Lxrpuax9Pu/bbix0DnarCGHF44+Szh93QzMrddObV0qzVxM7L4KyNuTHlw4iSYV3iWQWzLKBleECRsPNxjUBktxytlszqZHVhnRnf5cmWzbilBTK5jh+S9xXZAxC0VOOEaYp1ca2MvPNAzL04WBmTuOIEB1/UZh3CIiJnWVVr7B0vlRkZd/F8VLSQt5fzs0BHoEu2HLImVS7HAULowPyUWbAzIymt629yoKA5BnjxfYS1kKFQ6FZque/jO8bb99rsSg+H0pkHdNGeww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3CGaleT/vfsRqN+0Fdg9r8r0RyphcAUgkzA+Avdpr1Q=;
 b=oBIu0E3AMO58JukHPIXbDJtSsdm2UHF84YkOdqyrxYM5s44ajtNkU60BkN2NU+19ae1i5MSPWLYeCNBxSQFfuyv64ETbwzWp4H7k26dNRwef71WZv3CH6Y+7gg3rYQYWtyh/14KvtD473jlWtA5Fc+nBusoIeEV6IYRCAAMBAzG5PkDN4LSOuFr++pqkYNcbs5sAnYul53wB3Szt+K7C6yqcH+iyy5Vubyh7HKhVBsNWAH4Xecho2M5ss1cTp39jdNBy68hoyfL/gChqsxUqjMDsMKpdrl8xukgVRwVAIckYyi2nVDkDDVH3NZe5mJoNwvcsWH2Bzo2iivN5nrXqmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CGaleT/vfsRqN+0Fdg9r8r0RyphcAUgkzA+Avdpr1Q=;
 b=kEVsdcXKVjFtODPW0Qe5E6Scf+CbvrfnvNzAiws46/YReWF1DoA0FaRy5C7bVbdDaAku0gGTQANceouIKpxDRGx6PjmPjzq2Wu+K6RfJCjC0pFEKfH8SSn8noxjrwYi6AnQ71+WsfVUsiEz75dL7K9DS30lbA0Cq3pfoj7Q6wRs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4170.namprd12.prod.outlook.com (2603:10b6:5:219::20)
 by DM6PR12MB4911.namprd12.prod.outlook.com (2603:10b6:5:20e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 07:43:33 +0000
Received: from DM6PR12MB4170.namprd12.prod.outlook.com
 ([fe80::a2d2:21cc:bc90:630c]) by DM6PR12MB4170.namprd12.prod.outlook.com
 ([fe80::a2d2:21cc:bc90:630c%3]) with mapi id 15.20.6043.023; Fri, 27 Jan 2023
 07:43:33 +0000
Message-ID: <f4a2cd5d-7d36-6f4d-6012-7e4e87d44d7c@amd.com>
Date:   Fri, 27 Jan 2023 13:13:21 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 2/2] amd-xgbe: add support for rx-adaptation
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, Shyam-sundar.S-k@amd.com
References: <20230125072529.2222420-1-Raju.Rangoju@amd.com>
 <20230125072529.2222420-3-Raju.Rangoju@amd.com>
 <20230125230410.79342e6a@kernel.org>
From:   Raju Rangoju <Raju.Rangoju@amd.com>
In-Reply-To: <20230125230410.79342e6a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0152.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::16) To DM6PR12MB4170.namprd12.prod.outlook.com
 (2603:10b6:5:219::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4170:EE_|DM6PR12MB4911:EE_
X-MS-Office365-Filtering-Correlation-Id: ac194da9-0d1e-4d10-eb3d-08db003a30ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 83ueVd0aWcTz6ibpSc+VaC/UCFZNdhUZPn0xNBGpMsD/hGOvUBz8v4LMffWpC78/QauUJSH55PDu08IC0D4jZjps6e/9M24dZDYgI3TajhaRl5OYMt+IiB1h3aFvGyfwM1h7nNYHB+6w5nrA7V3BWpWqi5zjnT9O5LluBI1oohXENX019qcc4YyRKT4ZDa7k/5xT8ONX69UvIytn2tSW4SiCEV9QmEcw5vJs6HTQMovtNsoICMBOkF8lChYfjRJX0DHVTbCQMiPzVSGOjjtqdL892WGLfraLvqxzSmUJqWkeNKbbEhmve1uPUZvuo+2+qeSi8pA0J17b/+e2SoZaYQcb3s1QfWNzjSnDZTNCOm5GrfxkOUYZERhtjiuhCKgr+CzA8An/cwjMPj3VomYqLZ/4rz1RES6dweifFb6DwcEPU8I59sYNClhJpdbROe2PUrAlpcUeAIAYm0x3yhaLo1wJ/FypaRIGZVd5vdzFzB1M1rrRrVAJlvmvLpTappRBJ8FUinER4yLkhjqmk0lFLQu3ZxZz33O5P/NAp4Q7IJRAnUn2+sUJ2kVhdD0+ORp9ubxwYOi/Y4sH3pvGCaNmco03slLmfB0QEU9mCQjiNhmV/IvN6+iISTb2/yjh86ZSn9i+86mAZWBH+LWgzO93bH2BoejNgJjpZrqPn1mZrfaBzbFvll2TbwUmDkGXgFcPx9UQSVZEYuHV5EqFygIZ054/FAqkV0OOwYBt+YEarWk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4170.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199018)(316002)(38100700002)(41300700001)(8676002)(66476007)(36756003)(6916009)(31696002)(8936002)(66946007)(5660300002)(66556008)(86362001)(4326008)(2906002)(6506007)(53546011)(26005)(478600001)(6512007)(186003)(31686004)(6486002)(83380400001)(6666004)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0dDeEhyR2Z3cnBXTFNSV0Q0ZGk0Slp5ZU41WmowL1RCQk1ZWkRPU0YwQzlK?=
 =?utf-8?B?MDlDY2daaWZvMGNFT3pXT3F4bHY0YXRVZG1CN0krZGM3d2ZUeGZId2JoQThx?=
 =?utf-8?B?SWgwMkkvakdnUFNQNmE5WjltdG12aFZsMk9GK1RKRkYvWFo1Y3diZ0xDaGho?=
 =?utf-8?B?TkRKOGxiT21EMDFkWkpHNWFrbVVoWk0wb2ZCY05zOFMrUDBVd3Z5ckVKU2dF?=
 =?utf-8?B?Mjh2N2RFZVRmMVdveWxkSC9KQ0pNbGdLS1laeXYwKzd6SkMxaUZ3ODIveUxw?=
 =?utf-8?B?L3pqdXRKZ2djQTFjR1JoNGhLZG1haXJsVUVEcWZxeno3Vzk3TFg1N2N6N2Q3?=
 =?utf-8?B?Y2MwbFNYSFQ5UzRzSXl4OWYxNGdvanFNK1ExbUs3d3FOeGJYeWR4VHhPdHVw?=
 =?utf-8?B?UWZXdlAzZDJRUVA4dEhTOWs5em42ZnV3NE8vWGg0STlyQXlNVVlXdVFxNklT?=
 =?utf-8?B?L2FuU1V6UEMxR3lWQ1o4dVV6ZnF4UEVlNDh3RFZMSjFJTmg3Z2RlZFVYMWd5?=
 =?utf-8?B?ZnNJMVllajJSaWpxTDljZmhxOE1Zbjd6MEpWVGFOTWpKZGZNSDhJTFlXMWFj?=
 =?utf-8?B?d0kydGdISm8wYlBuRUFCb20wSk42Z2c1aUowT1hwcVZMS2lrTU96bGlhVjU1?=
 =?utf-8?B?clNLYlRtRkplTmluOWwwTXlDdDJjZElYRVNoUTBUREFjZk5RTXhyeExhUFRn?=
 =?utf-8?B?N1EvbExqYjFVTXdGcE5JN0p2NDlYakNjbkxac1dMUkNjVnl2V1c2VEpnYkM2?=
 =?utf-8?B?a1ZON0UyRWhCYitkdjg5dm1kd1U0ejFhZHNTMUdjTEo3ZENBanZvd3JNZ2ZU?=
 =?utf-8?B?ZlJ0VDVOQUg5eUhsSVVKUGZQanlIMGVpNmdXdFNMWDRJZitScnRoRGpzUFU3?=
 =?utf-8?B?QUpYSDFuTWtzeHlYTkI2NTM5ckF6Q0cyQVNBNFI4MUpxa3RZcVM3QlpCeWxN?=
 =?utf-8?B?MTZBaVdHM0NQYWkwek9oQkFuUncyRTgwUENwQS9SSlBsRDNVRWpPRFZBZysw?=
 =?utf-8?B?MHRncm53S1RKK2J0VUJ4TVZmRnBFblhZU3ZJcjBYWkdpMFd2UjR0NE9WK2Mz?=
 =?utf-8?B?S0ZDOWVyb2NmTjJsNThFTkVLZGxOaEUzQUUwak82Q3Q0cjV3TG55ZTdVQzBi?=
 =?utf-8?B?bEFLUlg1ZkJUNjlkOTlUemNhMzdCNlI4TXFROWxFT0NMM1EzMEFrMzUyem9q?=
 =?utf-8?B?dERoL3d5TGU0LzlvbW1PWkdCWUNNWllkZjFNeGgyVmFBTHdGQXZnWm1nZGtx?=
 =?utf-8?B?NG9uanhIUDJyVC9hajVLVGdUSm1QVHhLYVlTY0N5djBrd0Y1ZzJkRVhwM0ln?=
 =?utf-8?B?NHJzYzRFTXF5Rng3aStodVNSazUyUmtJZ01MUkJxZ2NSZ2doYWh4Sjkzd2l5?=
 =?utf-8?B?S3JYanVtbGJsbTRwOGF5QVVNSW4ySGhhMGwzMXN4b25IQ2w0Y3hpdkhxNGVi?=
 =?utf-8?B?K0s2TXdydFhWQjlhcXJOalhQeHVzeFNDcVpmaTUrU1ZKcHkvZm84S2p0TVpF?=
 =?utf-8?B?ZFZGME9ybFR5Z1AxR0xBWnVOVkMySGVBblNsa2sxT3R0dm9iU0FtRzBZN3BG?=
 =?utf-8?B?ZDk3TlN1Sm5DdUN4d1NNMERDNVJPait4SXVDUzJoVUpZdGhaQXY1MENFdDJZ?=
 =?utf-8?B?Q2dSdXpPWDZsaGIvbVNLS2RJb2t3ZmhSWjdML215QVBBWUFJNHAxTmQrN21R?=
 =?utf-8?B?UWtZYnh3WXRlbmsrV2FCdzNsN2JrK0pGOHBmZEVSZHZNTzVsQktXTVYwbEcw?=
 =?utf-8?B?SjR4UkEyUW5tMWxYbGtvVkwzUyt2TkRVMjRMNkNGc3N3Z3hFY0hPd3IrZmpN?=
 =?utf-8?B?c1AzUmJvZGdsOTJvVUdaVFRnVm5rcjlYenJWRkRIbjhxMFgzMXFwWFkvMUdY?=
 =?utf-8?B?ZWMvSnluV0owdHJob1I4YkRQcHZhZWE4TFFQQnR5aFFIWGQ4c2x6R0FwN0xl?=
 =?utf-8?B?NGlZMW42UWplanQvbGRTUzlhNVY0ZjZtRlhhejZzdlIzVFhZOGdDVHhTS0NW?=
 =?utf-8?B?RHFVMFR0UTEwUjVvcCtSczZGaVpFeDhOTlVjSjRzRjBtY3JBMWdESC9FNnRQ?=
 =?utf-8?B?ZTd3cHBNUFpqK3ptYkFNV3V1Wk5WN3kwM1ZjL3oyQVNaNWREUVJzajJaNlBD?=
 =?utf-8?Q?GbIVg1eeWDj75ptvKm/U42LHX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac194da9-0d1e-4d10-eb3d-08db003a30ca
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4170.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 07:43:33.3062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7rmhmCew73jFrUY9qMMFTYuxhC6bq92UQ2QNjWUQP7tnku8Dd2cyEkQQ6OiW/Hjurjqs8oO6QjTmlM1tOSiIMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4911
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/26/2023 12:34 PM, Jakub Kicinski wrote:
> On Wed, 25 Jan 2023 12:55:29 +0530 Raju Rangoju wrote:
>> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>> @@ -387,7 +387,13 @@ struct xgbe_phy_data {
>>   /* I2C, MDIO and GPIO lines are muxed, so only one device at a time */
>>   static DEFINE_MUTEX(xgbe_phy_comm_lock);
>>   
>> +static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>> +					unsigned int cmd, unsigned int sub_cmd);
>>   static enum xgbe_an_mode xgbe_phy_an_mode(struct xgbe_prv_data *pdata);
>> +static void xgbe_phy_rrc(struct xgbe_prv_data *pdata);
>> +static void xgbe_phy_set_mode(struct xgbe_prv_data *pdata, enum xgbe_mode mode);
>> +static void xgbe_phy_kr_mode(struct xgbe_prv_data *pdata);
>> +static void xgbe_phy_sfi_mode(struct xgbe_prv_data *pdata);
> 
> Why the forward declarations? It's against the kernel coding style.

Hi Jakub,

Sure, I've re-ordered most of the functions correctly to avoid forward 
declarations. However, there is circular dependency on couple of them. 
Let us know if its fine to have forward declaration for the functions 
that have circular-dependency.

> 
>>   static int xgbe_phy_i2c_xfer(struct xgbe_prv_data *pdata,
>>   			     struct xgbe_i2c_op *i2c_op)
>> @@ -2038,6 +2044,87 @@ static void xgbe_phy_set_redrv_mode(struct xgbe_prv_data *pdata)
>>   	xgbe_phy_put_comm_ownership(pdata);
>>   }
>>   
>> +#define MAX_RX_ADAPT_RETRIES	1
>> +#define XGBE_PMA_RX_VAL_SIG_MASK	(XGBE_PMA_RX_SIG_DET_0_MASK | XGBE_PMA_RX_VALID_0_MASK)
>> +
>> +static inline void xgbe_set_rx_adap_mode(struct xgbe_prv_data *pdata, enum xgbe_mode mode)
> 
> Don't pointlessly use inline, please. The compiler will know when
> to inline, and this is not the datapath.

Sure, I'll take care of this in the next revision.
