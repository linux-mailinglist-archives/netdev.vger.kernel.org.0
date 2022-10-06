Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB2F5F6CD7
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 19:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbiJFRYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 13:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbiJFRYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 13:24:22 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C9CFF207
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 10:24:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewQOxz7EfqeCd776y/VVcG0XkH2aKS9HEILMeWpqNc0dUiKxQeX2CseVxfxjFjHrhBNpoNvjiiwu4UNAYyGlFBDe5Hu8g96HpYr0jFLjdiFizqcKaQHnE5ChlxRA47U5IArAq48MOVXxOPOpjVgiV4fDDP16hLdX18u5NKyKJY4KJ10vSNob9n2X8LNCvZfCqn7VLqpKXlLVERDX0AcRGj7nwUXYiK2x3RUMWqEVKKB3DT7IZIPWw1r8XKz3uQCH+HC4niYgU+zWEFVnQUaQMWpb1KX7meC0IhTlXWxW/injQqs3QJEusVXAhzX6JswtMlSFnvnxuf6TM3ZKmISG8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fHqRiPewRw5FITW31W20haCleRlxoZ5JrFOHmSP4l1A=;
 b=fA5uVLPUIlaaPRSnulOTwYJi7EroZglHizy57VOeBtdcmJxWDiiJ7bY6zumURNzdCuz09e7ro9KeQWTHRU/P4w5WQua2M9GhSgRQjw56sEn1iP7G+9hbew/U7QZUe7NBWJxOKFGr+U0tNgy8ZOTNeybh8Zmh4cIG9R5ER/4WuUcvTIOD8OlktBVZWJ/L2nogoNkLM2LWWykzAv6qzFNFutkK3KxSHlrrTxcg4Bvx24UjlngvW3VqzVYRMoewcANBnqu+uKNE3IxLR2TC0wNZ8rFtump9Hd20mTtI7+5eonnEweXjo4VMJ2w3LSjV3Lg/kFU6qnw0GfuigsCLl8vG+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHqRiPewRw5FITW31W20haCleRlxoZ5JrFOHmSP4l1A=;
 b=4fvAwP3pza6bxOXCFueKhC68wk4Um7OoAA444QFBV+p2G9wlljEkjLnwN8FbjDHLfRhVnh8JVpjYIOdpTtfr4b3SmJRJNSUh9wpQPC87nlkvBd1ABPEdZ99zKvxT0zTAHY0jTMJRRhCiVYmbF3OsU0NRDcaHrzEuUJ6M8HghcyU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4170.namprd12.prod.outlook.com (2603:10b6:5:219::20)
 by PH8PR12MB7327.namprd12.prod.outlook.com (2603:10b6:510:215::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Thu, 6 Oct
 2022 17:24:04 +0000
Received: from DM6PR12MB4170.namprd12.prod.outlook.com
 ([fe80::2841:da55:ff5b:30cb]) by DM6PR12MB4170.namprd12.prod.outlook.com
 ([fe80::2841:da55:ff5b:30cb%6]) with mapi id 15.20.5676.036; Thu, 6 Oct 2022
 17:24:04 +0000
Message-ID: <8a7c989d-1541-bb69-89b6-e18398ecaed4@amd.com>
Date:   Thu, 6 Oct 2022 22:53:53 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH net 2/3] amd-xgbe: enable PLL_CTL for fixed PHY modes only
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>, Shyam-sundar.S-k@amd.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, rrangoju@amd.com
References: <20221006135440.3680563-1-Raju.Rangoju@amd.com>
 <20221006135440.3680563-3-Raju.Rangoju@amd.com>
 <88a61eba-a779-96ae-8210-d31e73ed73a1@amd.com>
From:   Raju Rangoju <Raju.Rangoju@amd.com>
In-Reply-To: <88a61eba-a779-96ae-8210-d31e73ed73a1@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0182.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::6) To DM6PR12MB4170.namprd12.prod.outlook.com
 (2603:10b6:5:219::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4170:EE_|PH8PR12MB7327:EE_
X-MS-Office365-Filtering-Correlation-Id: be2c03c5-4f43-470d-200e-08daa7bf9136
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hQDREubazIOKsE2X34afFt/RDb231hhLroM1mROiS3j/ZRTxRnKAkiMpSEzw2o60Bx4uQK9sBUHUYb92M70ToWiFGkLteHeLcn0SwjPUtgiujgHt7Xv2T32ReXWNos7/isNg1LKJqmbQn1xw09eFjqdqgbQS5J4CD1NgPL+/W3h8X/kOXw4hGCnELVBlM5pQ0g2vbl96urPkWDGA96bb20/UQdD+URqJrIan/DayV2V8BYqJXuA4JCZE+Vgq8bGMzW9ECd4WUVItqehgJnKRRNC2HMNZA5nO8//Hfk/fLksNtmfm8I5Ota88tX69QwAibsO3RiIDpG4dcwhr+Lv5cOIsZ+45vs9Bm4OpHYQWov8GaYYNXXJr+Wy8ziqSjzCLrNjkzS6qc68XTpP93a14isQRmfsfmn8hJKjdi7GeWbZzSN0THkfsdluQlQI4qWVY4hDtbihx7wjRwfTEW/YM31uMD5DbyM62GLmL///ORZnxQ7XzPVZ/+OGCnsrhfQXpFejd3TtZ49UezT3KG465CR6kaJTPNwWYyNQFWiDA3B6BTWynaHW5nxAIonxw99Pc9jxjfl103ljlk3HQQdTIjiYTnWj8aOCXfSYHbhNF3zOndslJ3cl8E3QfNUeyTKpPCVWMpNBEt7nhfa84+ragQ9NcQs4daD0vrKsz/QdSAW3How+fv4olHrOioqkWMtqQnP13b82BnfNdL88xoNighxh6xS7GC6ou8E9iJRpLl5s7Y5OUG6TI7ewSu0rygBjlh6Kxff9lkky2PnIjx/9SZgHIGBJcSGvfDxI6+sCCghU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4170.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(366004)(376002)(136003)(451199015)(66556008)(66946007)(8676002)(66476007)(26005)(6666004)(86362001)(6506007)(6512007)(6486002)(31696002)(478600001)(53546011)(4326008)(83380400001)(186003)(2616005)(316002)(36756003)(31686004)(41300700001)(8936002)(5660300002)(38100700002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDNYRHJmTllYREFOUWpaVnk3UVZGTE15Q3BydHhUUzRTWUNpTXJzekxmZWFm?=
 =?utf-8?B?SExqbUZQRlhjRnJjVGVtNTdrOFhNUlBVUEZxQ0ptYmRuQnFiTTN4RDhQUlU1?=
 =?utf-8?B?QVdMQms4aFVBdjNMNFB1OUwyZUhyWHhQWCtFMUdrc3U3R1BvdWJ0SHpFTmJQ?=
 =?utf-8?B?Z2JBQVJ0OXJ3cGdibFV3dnEyUVRtalh4Ly9uWlFmR3dmaVZjR3oySXBzSVBS?=
 =?utf-8?B?ZXREQTE4VEhaNyt5VVcrdmJXeTkzV3Rta0k1QlJ0Yk9NdU1nS2g0TXlYbURH?=
 =?utf-8?B?Z0dVVUVoUzBTOTVCeVZQWUdJUVdtNWMxQ3hDa0VwWENhcVV2RG5ITG8xWFlN?=
 =?utf-8?B?M1prTGFzSTZmSG14WnZYLzBWK2hVRndneVVBVkJHK3Z1TEwzY2I4NG9obyto?=
 =?utf-8?B?K3BYVTdPU3hJZ1lSQXh2VFoxR0VMalZEcHoyZnpmRU5ya0t3K3dmTTFQM01S?=
 =?utf-8?B?UmFBV3IrTFBXZFYwb1dBbVB3NWdjbFRieDFxSnNObHlPYUNBRHdnSC9UMFAw?=
 =?utf-8?B?dWxBQ2w0KzE0QlRCYTRqMG5sNlpKZE52U0VYUjBYZFUya083bndwV1BhTklN?=
 =?utf-8?B?NTU3RVA1aTlVVzlPV3IrZld6WCtZR2p0NjQvWk5KdHdkTmlrb3ZUSFdlZEsv?=
 =?utf-8?B?elQ5RHZQY3pJQ0JCRzJIbzE1NkZoMmNnUnA5OEg5eExoSksvZGxtM2Nmc0xS?=
 =?utf-8?B?U2JEQmVBcTFRZlUwR3VteGhNUHJ5MGZ0RTltZGRaUEN4OC9SbWprNmhFME9L?=
 =?utf-8?B?b3MvVnEveFA4bFNaN0xGKy83T1IwV20vS3lXOTBsQXY2dERta211cEY3b2Zp?=
 =?utf-8?B?cnB2TUZQMGVYRW40L1RnVzllREt2VzYrUDhYbEhMeXc0RmRZWTZ2eGJyMisz?=
 =?utf-8?B?U1FEOWNMZE1CekdwUEtqZFNtblFNUkNEUnZtbFJiMldVNUIyYkhDYzhQZGhj?=
 =?utf-8?B?RWJEWDRPaFVldXl5bTFvTUY3SzBOcEVoTkQ3SjFMNU5rSFJvZEYydmpZQkI5?=
 =?utf-8?B?ODAvWGh0UG9DcG02cmZ4REVtenkwQ3NpWDhYRUovTkdLRWN3WG42dm1nYWNP?=
 =?utf-8?B?VFdnOEVjc0VCb2hjcEtnQ0c0K3Q5Q0liR3hwcFJRbDlvS1VtUXdQd2hjeEVr?=
 =?utf-8?B?NHRKOFBIZ0dwVHRtM3JVdW8zM0ZydkF0NFByV2x5ZFFKa21ZQkRCOWhxTlNl?=
 =?utf-8?B?QURkNW83OVRXSW1VWHpGM0hYOUsrQWt2VUhJbE5vNjlTeGppMFFadllYdFVi?=
 =?utf-8?B?YldwSCtNeW51Q1A4NkEwZXgzU1VGREU0UFh4byt3Y0tBbVpxTzFRb1ZndGMx?=
 =?utf-8?B?RVZmbXo2bTI1YkRCaSthSjhuaWorM09VUnF0SC9KdHp0VnU5bWhqRVhWWE4w?=
 =?utf-8?B?bHFud0FqbklsZ012MU0yUTJVM3k0NzVMU3EzOUcvc1Y4OWZ1MkJvQzBYaFQw?=
 =?utf-8?B?ZHRGa3BidElBTTNhOGZUV0sxQkdtaCt1SWc5ZzhxMCs4emp2VUMyNDJYS0pR?=
 =?utf-8?B?aXUwUGRSSml5MzRXbFZuelA5ekdTVHpHbVpxclF3aStua3NOME1aaUg4OFUv?=
 =?utf-8?B?dUVPU05sRGNYREN0a1ZMTXp3NDFhWm9NMWRBdVJzWWFYMmgvaXpRY2NsYTNF?=
 =?utf-8?B?ZngvRlpQNDRYWHpjbDRVQnp1d0lYUCtMRi83QWhjZDE3Mk91ZWxIVXBQaHVF?=
 =?utf-8?B?YW9YeXhvNk5ZazRSVWgzbEtkYnA1SThnSFNyUk5ZMG1EWW8wcnRFL0pvQjdK?=
 =?utf-8?B?NjJHZUtMd1hTV05KQ2lvdFJJN3lPQkVLMFpnZ2EwRGV3TmM2VFR4bktCREpN?=
 =?utf-8?B?WndIUGNGV2w1SDZMbk16aDBIZkxmSnlFV1dBejhFamdyZW5xT2hab2hhb0ZF?=
 =?utf-8?B?aVMxdnIwY2kvdFY3b2FockZEcE51clkzSVBLM2dzbFUxSkZmT3dhT2xhZGly?=
 =?utf-8?B?RWlYZjlFL1hTUVl5dlcveFdjRWxLQ1lOYXViUGNza29TTUZLVi9YTytnbGVZ?=
 =?utf-8?B?NHdVeG9hT2drdmdHcURwZitoaEt0VUdrRWVlMjUvTGljMnRuWHc4ckc5bGZB?=
 =?utf-8?B?SG1kRmpjazZrbyt0NFQ3Q0JzcGZsRGhzUytuZk9oaXdLTnlqcmpkT1ZDckY0?=
 =?utf-8?Q?s7eMQ33aErZFwl830tUnKkYi8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be2c03c5-4f43-470d-200e-08daa7bf9136
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4170.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 17:24:04.6775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jRvNAWzc5UpLqh1UnQPpdbympYprruSqsrkgK7X4LTCR22e+SH0+nZM98PPnXvLtxmDOIS581z+ryfgeoBWzAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7327
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tom,

On 10/6/2022 8:17 PM, Tom Lendacky wrote:
> On 10/6/22 08:54, Raju Rangoju wrote:
>> PLL control setting(HW RRCM) is needed only in fixed PHY configuration
>> to fix the peer-peer issues. Without the PLL control setting, the link
>> up takes longer time in a fixed phy configuration.
>>
>> Driver implements SW RRCM for Autoneg On configuration, hence PLL
>> control setting (HW RRCM) is not needed for AN On configuration, and
>> can be skipped.
>>
>> Also, PLL re-initialization is not needed for PHY Power Off and RRCM
>> commands. Otherwise, they lead to mailbox errors. Added the changes
>> accordingly.
>>
>> Fixes: daf182d360e5 ("net: amd-xgbe: Toggle PLL settings during rate 
>> change")
>> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
>> ---
>>   drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 21 +++++++++++++--------
>>   drivers/net/ethernet/amd/xgbe/xgbe.h        | 10 ++++++++++
>>   2 files changed, 23 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c 
>> b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>> index 19b943eba560..23fbd89a29df 100644
>> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
>> @@ -1979,13 +1979,16 @@ static void xgbe_phy_rx_reset(struct 
>> xgbe_prv_data *pdata)
>>   static void xgbe_phy_pll_ctrl(struct xgbe_prv_data *pdata, bool enable)
>>   {
>> -    XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_VEND2_PMA_MISC_CTRL0,
>> -             XGBE_PMA_PLL_CTRL_MASK,
>> -             enable ? XGBE_PMA_PLL_CTRL_ENABLE
>> -                : XGBE_PMA_PLL_CTRL_DISABLE);
>> +    /* PLL_CTRL feature needs to be enabled for fixed PHY modes 
>> (Non-Autoneg) only */
>> +    if (pdata->phy.autoneg == AUTONEG_DISABLE) {
>> +        XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, 
>> MDIO_VEND2_PMA_MISC_CTRL0,
>> +                 XGBE_PMA_PLL_CTRL_MASK,
>> +                 enable ? XGBE_PMA_PLL_CTRL_ENABLE
>> +                    : XGBE_PMA_PLL_CTRL_DISABLE);
>> -    /* Wait for command to complete */
>> -    usleep_range(100, 200);
>> +        /* Wait for command to complete */
>> +        usleep_range(100, 200);
>> +    }
> 
> Rather than indent all this, just add an if that returns at the beginning
> of the function, e.g.:
> 
>      /* PLL_CTRL feature needs to be enabled for fixed PHY modes 
> (Non-Autoneg) only */
>      if (pdata->phy.autoneg != AUTONEG_DISABLE)
>          return;

Sure, I'll add the above changes.

> 
> Now a general question... is this going to force Autoneg ON to end up
> always going through the RRC path now where it may not have before? In
> other words, there's now an auto-negotiation delay?

As per the databook, Receiver power state change (HW RRCM) is not 
allowed during the CL73 / CL72. FW is already implementing SW RRCM for 
Autoneg ON, and no additional changes are needed in driver for AN ON 
path. However, HW RRCM(PLL_CTRL) is needed in Fixed PHY configs.

> 
>>   }
>>   static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>> @@ -2029,8 +2032,10 @@ static void xgbe_phy_perform_ratechange(struct 
>> xgbe_prv_data *pdata,
>>       xgbe_phy_rx_reset(pdata);
>>   reenable_pll:
>> -    /* Enable PLL re-initialization */
>> -    xgbe_phy_pll_ctrl(pdata, true);
>> +    /* Enable PLL re-initialization, not needed for PHY Power Off cmd */
> 
> Comment should also include the RRC command...
> 
>> +    if (cmd != XGBE_MAILBOX_CMD_POWER_OFF &&
>> +        cmd != XGBE_MAILBOX_CMD_RRCM)
>> +        xgbe_phy_pll_ctrl(pdata, true);
>>   }
>>   static void xgbe_phy_rrc(struct xgbe_prv_data *pdata)
>> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h 
>> b/drivers/net/ethernet/amd/xgbe/xgbe.h
>> index 49d23abce73d..c7865681790c 100644
>> --- a/drivers/net/ethernet/amd/xgbe/xgbe.h
>> +++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
>> @@ -611,6 +611,16 @@ enum xgbe_mdio_mode {
>>       XGBE_MDIO_MODE_CL45,
>>   };
>> +enum XGBE_MAILBOX_CMD {
>> +    XGBE_MAILBOX_CMD_POWER_OFF    = 0,
>> +    XGBE_MAILBOX_CMD_SET_1G        = 1,
>> +    XGBE_MAILBOX_CMD_SET_2_5G    = 2,
>> +    XGBE_MAILBOX_CMD_SET_10G_SFI    = 3,
>> +    XGBE_MAILBOX_CMD_SET_10G_KR    = 4,
>> +    XGBE_MAILBOX_CMD_RRCM        = 5,
>> +    XGBE_MAILBOX_CMD_UNKNOWN    = 6
>> +};
> 
> If you're going to add an enum for the commands, then you should apply
> them everywhere. Creating this enum and updating all the command locations
> should be a pre-patch to this patch.
> 
> Thanks,
> Tom
> 
>> +
>>   struct xgbe_phy {
>>       struct ethtool_link_ksettings lks;
