Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5FCA60511B
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 22:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiJSUOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 16:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbiJSUOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 16:14:04 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939AF2BE01
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 13:14:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SSc8VoScH8JCs8iGW9iXIj1JgAZYvjGJNTZkFY6iUb85xGJdut/TE/OtduS8Q9icJFgTPEWToh0gbHsjWecjPjK2EJisPIJVE9MdJsRxtRFQlnNIX0SHbB5k3o7uXmu+Y+q+AvAuuvaIIleBD4gM5TI1g2ONOWx8zkwmLqaCnoO+IlTZTj1lZ+xWXITUmdCdNnlUALg8kqeMgD7jfH6JBXFjnmdjVbSpLVKI+JlH0BvNyS9eSEmW7F8uJxZSs36FHyOx70XPbPoD7uw0041H9Wn47rnPQvrIdc/SLNDHErMBc3oW26s164RGgA2ATthAHz2/6y/LgZyExVYnySYTnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yuvr0XUEHRpFpx6sHtirmnBeGKrSdatKmXf4/zOIqPM=;
 b=YtXgQrk5tF7nSIrEnpV7mXEEbC6yk5j1Q5CSm4XxL8hwfQU9dq5NF55LWWO7WN7d0doc+ITcvQxDWGycOMcd4Tvi4opwKtNCj+cZqQKyPo2IKCEiZW6boLRQQyQQw5g+Ftq+GJYHMvImF8HODR51+M6hoPu+Wz0lxayXVvlYFt35uPzxuMNqek1ALw8qXuL6LkI2eS4XAYGeG4ml8whsGEl/EcVcfPYibKhdU5Q1uZiMxLMzicxHweJoqTMhrn8XASS9Ld89Idvj/eg54dph6J5ZyBGfZZYS/wklufQIfciUm3WS3/cO+R045NMZja/yEqvyDRWFpzuo7kUisxrmEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yuvr0XUEHRpFpx6sHtirmnBeGKrSdatKmXf4/zOIqPM=;
 b=yAwk6IiuO2WdejlwOxEE7/AlK1MOlr8NyOyHHZu5mjuJBXAYW8d71GtVrf4Om0Pj+i22T56PiScfHjY/INigXpZt4mN0OTfKYUKiwXgWa0Y1g6+APqUvrx3DLYCed/QYs5BiOlV8fs2YFtaghQylIxw6cSvnZ36eXASPyjm5qRg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DS7PR12MB6072.namprd12.prod.outlook.com (2603:10b6:8:9c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Wed, 19 Oct
 2022 20:14:00 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 20:14:00 +0000
Message-ID: <ba8bba53-70ac-78f9-5c8b-a3b382d84edd@amd.com>
Date:   Wed, 19 Oct 2022 15:13:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 net 3/5] amd-xgbe: enable PLL_CTL for fixed PHY modes
 only
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Raju Rangoju <Raju.Rangoju@amd.com>, davem@davemloft.net,
        kuba@kernel.org, Shyam-sundar.S-k@amd.com
Cc:     netdev@vger.kernel.org, rajesh1.kumar@amd.com
References: <20221019182021.2334783-1-Raju.Rangoju@amd.com>
 <20221019182021.2334783-4-Raju.Rangoju@amd.com>
 <8f2e65d0-61b3-f6a9-084b-4c5c0ab1ccd1@amd.com>
In-Reply-To: <8f2e65d0-61b3-f6a9-084b-4c5c0ab1ccd1@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR22CA0019.namprd22.prod.outlook.com
 (2603:10b6:208:238::24) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DS7PR12MB6072:EE_
X-MS-Office365-Filtering-Correlation-Id: 90e79132-b6a7-4832-9fa2-08dab20e75ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sWQW2GjKnjRE+G65rhtsC0R7JNDn26a6KAwLHFPvUg93w5cgNH7K7GNj5BfW2dJ7YA1aUZxzeHxZtAYtpuaBmHcLCuTuA01gFHFgo0J5+oSo/hU3K9lEtmt56Su6+ucS8Dc62kdSjYiKXav3PEv0Zfqj3vJ/AqeeNt7dSjsiUHLsiJLw9Ck7Ci1xOzBjm/aKwPb9JAtXjOPsnk0atZAs342Nu6EZ7NFw7XrVNeBREf6p2n/RE4DGGBYJw1y0TX2ZGr5p8AMKRi+OrKzc0NLmoI9DT4nX/Q8qtXRttmeqLgbf9/HzW1hXf8PA/tB6ClVIVukHQFsshsoSWpVnXA4JQanEH38RQQHjl23jRqdswDjhwOrttie3F3sYLwJAoio1JetVNzd8J/EfIGFKLyWMds79PB/DW97/LGHnsj4GS2+bmeqOKhNaKZCMO71YrtRgqYouZ7zBUG+MVhsXQ0THrRBQcBg9fikSgZzScfqH3HwvFzhttrS9FDZ/kSwXbSOs/akk9LPdT+On3svZ9eWAE1zXl3bus5TXEqkj2niNglQ64/DIYKq9cvc26nnCxipEywJ7sBBXxbLDI7Yv/5oiPutLlG63enNVs/0fV4tsdPCRct1Q5HAnIOdcLxNY2GZTIhDu3l01aVj3zoXtMONAYVtOFGJwRLPsOP638eUKmardYQi6eSO2mNqvLK262AdwONbS/Ogq08sAB7gewsBBpRcdmlePEE3DMJq4JTuPG8Y/ApPatvDIWaVquY6f+MGEFR6aAsqswiM5oZIBSy9dBXuA5aCDtssxWQ8n5OmSuTM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199015)(36756003)(31696002)(86362001)(38100700002)(2906002)(5660300002)(8936002)(6486002)(186003)(2616005)(6636002)(83380400001)(478600001)(6506007)(53546011)(4326008)(26005)(6666004)(31686004)(66946007)(66556008)(66476007)(316002)(6512007)(8676002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RG8vZTFZMTBIVllwV1FETXN0VEcvaHI2RnhUYjNndFZSd1NaRm01VVc1c050?=
 =?utf-8?B?ZitKamhxOGJ4aU80Mk85YkRiaDJDMGdRS0ZLWXBIOGZNTytwVERpbkZhamp3?=
 =?utf-8?B?UlNwaUUwcnZQbGY5NHZkOGUrZVFjN25zZi9aWGoyeTVwbWk3TFdyVjV4R2Zq?=
 =?utf-8?B?cFpWWjdhd3dHZHBlaTZkT2ROOUYrV1JEUC9HZE5PR0o0b2Nzd201SWY5M0NU?=
 =?utf-8?B?OUswblM3YXZjazVOa3p2bDhoblJWTUVETU13YkpHUW9SYWQ1Kys5eU9uaGhT?=
 =?utf-8?B?M0VXV1JSKzVFQXRFRkMzS2RlNkFOTmk1Q2krQUg3NjA3WUFqSlN6Nm0xcU8w?=
 =?utf-8?B?dUd5L0xoeGUzMmxIU21COUc4WmVrWHNGK2xYTExOcGVWaFZHK0s0cUdLdlRx?=
 =?utf-8?B?NElteUlvK3d6S0U0K2hWeDdUMHR5cXJzUGZJdndKbGdYOXpRbkFQaERBeUts?=
 =?utf-8?B?a0F1OUUrWEN2cS9rc2c0d2Zvd0wwaFhBbDFiSXp4NnRwSTFEWGNMczFUejNn?=
 =?utf-8?B?THc2cFpCcVlYUmhET1prajZONzk5NEFjZVM2VlBGWHk0cUpwUDJ5cTNHRXZu?=
 =?utf-8?B?RGNRZGo4TUEyalNkYWpVSjZHbjdCSE1JQUZhVjkvdGtiQmY5Y0M2MnBOR05E?=
 =?utf-8?B?aS9xQ0tJajlaZ2M0dVg0RWk3VGFZUmlYK3Evdm1tQVpsbVkzRjNPZFpoM3gz?=
 =?utf-8?B?dEZxbDB2Tm5LV2xrSGdMemxCTnZYQm5SaUU4NEFqRDlQTksrc1duSTdlUjIz?=
 =?utf-8?B?THVsSW0wL0dPUEQ1c0g5TDkvWGRIdFdlU2k2VEtaYnV4YnVmekxseG5YTW1J?=
 =?utf-8?B?a0QxbVJBY0UyZjJoOHA5djVKand0UUNEZUJzRlpQUmphMlhYRWU3YWJrUEZT?=
 =?utf-8?B?TW9ZR2dpQ3A2aFZKY2JLMzZQVVMwbHJEeHAwZHRXYXY5RDY1Mm9EMXRRcWNS?=
 =?utf-8?B?TDJOaElLSVhtY3crTUN2S01uU1JBblVFNUJZbnBLL0k4c21mM0ZPRjBvZ2p0?=
 =?utf-8?B?K3hpallrekw0cEd2dVczTXQ3eHhyMUd3ZVlPN1FrclJIdHpWd2xzK0hNOWdl?=
 =?utf-8?B?Ylg1N2dTOUhiSExEVmY0SXgrZTNXN1ZZNzBzOFZYK1p5R2V5bGZRVlRPalRs?=
 =?utf-8?B?bGE4YzA4Y05vU3BabkJneThaZkF4bVoybjFnbWdodGhPNm5ZVnhkTHozU0Zm?=
 =?utf-8?B?QlpOV1ViUXVmNklnNTFXeUx5NXZoNVU1bTJLM0pML1lISDBYZEJXKzlQMERz?=
 =?utf-8?B?eDJmNWNaOHV6RG5jeG1KaEQ2enNJczZBcGk1dkNBUktyUDhZS0k5YTkyNk4r?=
 =?utf-8?B?cEJSWitQdGxzanlpdUVic3JuVWZRMUtkaXcyWExPQlVFbzNzYWFCbVhRT1F5?=
 =?utf-8?B?MHEzUlpsTFdJdmpDRTdiS2trVVMyZnNvbERRU2d5bzRqVmtNTFIrR29EUzJo?=
 =?utf-8?B?VnQwb09nbGw2OVo4eThqRU1aQWl2K29zWUlyTFdhTXQzdy83U2ttbVBRQUR2?=
 =?utf-8?B?YWR5SWF0RW1MV2s1dzVHVVoyeWFHbVo3b2ExTFIwSjZ1L3hWUVlrWCs2YjdV?=
 =?utf-8?B?c1dNUitMc3VhNXRhSEtZWm81Q3Fob09EaE83aWNYOGt5M2NXRTBFeFd1VVlB?=
 =?utf-8?B?MWVxL2syaTVlZWYrR240QkErNUN1N0czQUVDRnFyS2YyOEt6NDAzTml1V1Iz?=
 =?utf-8?B?L2pZTk8yWUVTSW9DWG1TY2tiV2RtYnI3YjhaV1lRd3Y1V3dPV3FUUkhiOGpY?=
 =?utf-8?B?U0JWZzVKWHFKQmp3ZkpyZ2l1SWRBQ0RZbm8vajhPb0pxcVFWSmJBSGFONEFO?=
 =?utf-8?B?ZEZ1THV6R0FEdmM5QUttMm15YVZhQTg3NEh4QjllNmpBb0VzWU00M1Fydm5W?=
 =?utf-8?B?YUR5REpvU3NFTENEdVgrOVhoc1o4V0JzOXJSbVAySy9lUVVJVWxXdjBwZTRi?=
 =?utf-8?B?Y3R0dlR1Y01kLzc5Z2k5bmx4YVRoenJjZWkyUjgrVVNIeWlOc0cwZDNIdDNp?=
 =?utf-8?B?MURXZEhoNVRFZmtHWXpzVEthODkwS0UvSE9yazNKOE81c3VTb2ZORkhMbEdB?=
 =?utf-8?B?MERLdjNvc0FlQXFlTUNGM05UekxrYm1HeXErcTFoRXA5T1BLMGNhczZRWnNy?=
 =?utf-8?Q?B0DKba9qFWk23vZVZa5atsLJb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90e79132-b6a7-4832-9fa2-08dab20e75ab
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 20:14:00.1064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BtlAiBxVmvlQmOea+i954h7Yi89Ld65dENKJDU6J3qzXH0nVwSgcphNOyGLyvNDtxQSwXpHemyqnZtFwxDteGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6072
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/22 14:01, Tom Lendacky wrote:
> On 10/19/22 13:20, Raju Rangoju wrote:
>> PLL control setting(RRC) is needed only in fixed PHY configuration to
>> fix the peer-peer issues. Without the PLL control setting, the link up
>> takes longer time in a fixed phy configuration.
>>
>> Driver implements SW RRC for Autoneg On configuration, hence PLL control
>> setting (RRC) is not needed for AN On configuration, and can be skipped.
>>
>> Also, PLL re-initialization is not needed for PHY Power Off and RRCM
> 
> s/RRCM/RRC/
> 
>> commands. Otherwise, they lead to mailbox errors. Added the changes
>> accordingly.
>>
>> Fixes: daf182d360e5 ("net: amd-xgbe: Toggle PLL settings during rate 
>> change")
>> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
>> ---
>> Changes since v1:
>> - used enums for all mailxbox command and subcommands, pre-patch to this
>> contains the enum updates
>> - updated the comment section to include RRC command
>> - updated the commit message to use RRC instead of RRCM
>>
>>   drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c 
>> b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>> index 8cf5d81fca36..b9c65322248a 100644
>> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>> @@ -1979,6 +1979,10 @@ static void xgbe_phy_rx_reset(struct 
>> xgbe_prv_data *pdata)
>>   static void xgbe_phy_pll_ctrl(struct xgbe_prv_data *pdata, bool enable)
>>   {
>> +    /* PLL_CTRL feature needs to be enabled for fixed PHY modes 
>> (Non-Autoneg) only */
>> +    if (pdata->phy.autoneg != AUTONEG_DISABLE)
>> +        return;
>> +
>>       XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_VEND2_PMA_MISC_CTRL0,
>>                XGBE_PMA_PLL_CTRL_MASK,
>>                enable ? XGBE_PMA_PLL_CTRL_ENABLE
>> @@ -2029,8 +2033,10 @@ static void xgbe_phy_perform_ratechange(struct 
>> xgbe_prv_data *pdata,
>>       xgbe_phy_rx_reset(pdata);
>>   reenable_pll:
>> -    /* Enable PLL re-initialization */
>> -    xgbe_phy_pll_ctrl(pdata, true);
>> +    /* Enable PLL re-initialization, not needed for PHY Power Off and 
>> RRC cmds */
>> +    if (cmd != XGBE_MAILBOX_CMD_POWER_OFF &&

Also, XGBE_MAILBOX_CMD_POWER_OFF isn't defined.

Thanks,
Tom

>> +        cmd != XGBE_MAILBOX_CMD_RRCM)
> 
> XGBE_MAILBOX_CMD_RRCM isn't defined, so this patch won't build.
> 
> Thanks,
> Tom
> 
>> +        xgbe_phy_pll_ctrl(pdata, true);
>>   }
>>   static void xgbe_phy_rrc(struct xgbe_prv_data *pdata)
