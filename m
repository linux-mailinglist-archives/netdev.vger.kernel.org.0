Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C3F68CFD9
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 07:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjBGGyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 01:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBGGyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 01:54:40 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AEA86BE;
        Mon,  6 Feb 2023 22:54:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GZtp3ltRdCF7EvoMJad2dil91r24G8i0wD83imLYF8J1MMRIL00CYmHgOBs1AqRu72ygCJuKgsn/+vdIQyZszOhmj32DhMFRVqTPvReAfLgmE2AdnPm2igciacjPDHk5i5gsy1CFGkCMHBQGamdIahCzO5b+DGnaeXW1GhrIujYiUuUpTwxwU4SStf/49xrHQqJVONLUfYkqhzmah4NWICoSPykFrxnvXG2Enz57KyWxS1/0fxsm7APzB1Mc7qCQIhJwJY+h2jULqso0TsmOlmnW+um4HaO+35PNEp8SedsKIcxujhKHvoEiSRtrdWHz8ZRxOOU9P+pk7lBCUNyLkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ihplP0jTYW+b0kbCUufjc8JY2EnSvz40UXQF3oNbhIY=;
 b=E72O3/OR800Fz2pC7iXalt8lKLzbEsfbRyu3n8F+Ln3Jg44NLQ56I0uRMQdonjTPcSBhzKYOOVi9O8YRh9JI2/sfOG9HZ5O7WCp4URbDrNs/8iJ6CF1Q6qZMRbQu3L9yjMzrssDdVUtsDMZMn0PIUkAAmf1wow/dQIeU09mRH/5qNiqrAjeGMuZqD8n79i6wcWudGJJmDHTZAecvGszsuE6+KQA2GEPoJExg/NB5Y6xUrx4U2hgJV4YRIvZdSBeDU5GDcdvmQjfJlnt8Vx9uOppU89dVAxadrUMZ7VpUVuWQ6mAogYkMQNh5i0E/U+4xWIt0WzdWdf/xZV2e2p8dfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihplP0jTYW+b0kbCUufjc8JY2EnSvz40UXQF3oNbhIY=;
 b=YpbLipvTUDm8U1g8nb9c/mxZLOvtakc1A+oIXvoqLDHeAS1LiWQCVaPk5TNJ4n3PRDl9/wpjemnpCettWuwmtTqQFDDk/6x1R239BxoCUpI6whYlMzdoYNaHy+tHKN6G2eAxr0ugF1mRiBSlmdDnvzDM2CSnSnVqJkrRHaLcaGA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19)
 by IA1PR12MB7496.namprd12.prod.outlook.com (2603:10b6:208:418::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Tue, 7 Feb
 2023 06:54:37 +0000
Received: from BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::e7d8:1e35:79ac:d6e0]) by BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::e7d8:1e35:79ac:d6e0%9]) with mapi id 15.20.6064.036; Tue, 7 Feb 2023
 06:54:37 +0000
Message-ID: <0441fa72-a07a-8c3e-717d-563f03fd2ea1@amd.com>
Date:   Tue, 7 Feb 2023 12:24:23 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH] amd-xgbe: fix mismatched prototype
To:     Jakub Kicinski <kuba@kernel.org>, Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230203121553.2871598-1-arnd@kernel.org>
 <20230206222839.0df937c9@kernel.org>
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
In-Reply-To: <20230206222839.0df937c9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0183.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:be::8) To BL1PR12MB5176.namprd12.prod.outlook.com
 (2603:10b6:208:311::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:EE_|IA1PR12MB7496:EE_
X-MS-Office365-Filtering-Correlation-Id: 67da73b2-7e1c-472f-a152-08db08d82d32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H08dP+4Qw8SJHVjspw+C00YMP9CEdSasWU8GB1QTRosIJe2LsVj1CSn7/DpL0OKM03Wv19aNKZJhfbSzHApo57joRsbFS7GDkeVakksUZXmSCm7YL6FcBWY5SwexflOR4KAlfve1K7rQFhZVDoLhdaQt2h1yjwgw6323y0YZTfZu66bC2lNozYEWylXKSxIjbqI0EsRaMKuDTxO5eU+x0HbE5OInCuYdHRWwuUDNq8PDgBh8u7I44c/5xyGbmkQnxHoN/Xx+5VQrdM2LAbKXiI0vdLa912OOkF6eEombvQWOaOPPRq8abjMT0uyUoYPGmOXAgO1uRIM77Lx5onwB14hdKQxm4nrG6zz6ZOT41Y+LFFDaejD1WcEefEqZ0EyNn0ODpqdUcb26a+lSsNnX30qF94sivW3uPAHYGFHcVpElrQpVOw5DgouYp6nHtVM6+w5kaQlRWoACH0OizZIxj+1wbxEXjAelzNXgt1isKgWQljwfYouMsVrqs1U3k9gAMbRF490he6LGVe642lvWR0Q3KL8eaRth8zMl925Eol/9AtiTQ9p1s5ULEIOx1qp8saDBEJ+jG6MszRWS7fDK7TcIj70vQY5bAU3qwBuCL7/yDc734vAumIDUy+bt4rdcbA5MbgbNnlC9IjvFD+PtFHLfgXtaRSmPE/bzgV5fdrOd73J9eMnMXzL2lIP+8tHLSZVIKBNvZO41chYmptUhjFV7hM/LBawgN3WNLQm+Wvc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(136003)(376002)(39860400002)(346002)(451199018)(6666004)(66556008)(5660300002)(478600001)(86362001)(2616005)(36756003)(186003)(2906002)(6486002)(41300700001)(38100700002)(8676002)(31686004)(31696002)(66946007)(4326008)(66476007)(53546011)(316002)(54906003)(110136005)(6506007)(8936002)(26005)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzBOVkprMERSUWMveEl2b3EvRjh1bkZXVUxXMDJFRjgrTldJQm0vZUYwWDhC?=
 =?utf-8?B?a0Z5akFLNFp5cG1IcHdPOGdRTUF3cmkrNThTUm5yZXZiLzRFQ2lMMjd1bzlq?=
 =?utf-8?B?MFI0L000VGhjNHFFcWRVMDBMbk1OeENxWGhLa2E2N2FvVmFnSHNIS3RwZk9m?=
 =?utf-8?B?Qmt0c3lzT1M0L1VaaXN2R21lREtoSWxXQWxFT3hPUWlONTdvTmFhc016Um5B?=
 =?utf-8?B?V2xNNDJvVFBVRnQ1QklTNDdmZTBzK2kzWWowckNxVGhiY3RFWmZuN2taSFNB?=
 =?utf-8?B?OUhiNUdVY01pYnN0ajB5dWE3U0c5UjFicDZEeW9WVk5vYUE5aVRmcEtKWmM2?=
 =?utf-8?B?Zk1HbUJFN2sxS2FDUUl1V2FDL1dJdEhQUHliZTFvWDloUG5kaFQwd0l3OVV4?=
 =?utf-8?B?ZzllMjNrbWE1QUp4ckN1LzMvK3NYWHkrOGJRRTlqYnNxbEdRc2V2cjRWVXJ0?=
 =?utf-8?B?bFFCTnlNbFJ6M2JvTGpGbUd3N3BkQTE2d1B4SSsrcmdzeFJ2S0Ywek1ING5r?=
 =?utf-8?B?T2VMeU1uZlR4QVVDOGNjQktxNEJwc012ZGFWM0tnWG9qRFVUVThMVCs5Rlpk?=
 =?utf-8?B?aUF4SDZVeVJkUG9tTnlZd1BvT3BtMjlwVXk3M1Q5Zmt3YTlFUm9XMUtmTVVS?=
 =?utf-8?B?Z04vVE13bzlFUE9QdWh0NE56dFZCQ0NiK2RycFg2SU1LT05mTGQ5MkxTYVcx?=
 =?utf-8?B?VURMUnc4bHRidEgyM29vbG5FcVc1aGlLRUFDc1lzN0E2VmN0STliTittMFND?=
 =?utf-8?B?M3lkTnVrVEpSai9pZUxBemd3MHpzMkZKTDF4c0FMcTJvb2x2R0h0NktrYWw5?=
 =?utf-8?B?Nnk4eVlpa0RCYjJvU2E0WkZNckRIVWVVQ1ppT0dlWGpLU2lBeWw4aldxYTk2?=
 =?utf-8?B?UWxyblVhVi92NytKaGZkUEtoY3ZhdGhwOW05S2ZPYitPazdUeit3RWpybHpz?=
 =?utf-8?B?MmFxUzlnTlZwZDZFcmdNRGpsZi9ienhjNUcxVGZFQ05adEVudFk5REZjeDky?=
 =?utf-8?B?bHVUVFNJZTJkRmNCdzdVZlhtYmd2MThRN1pBd0xTS3FwejkrRVZTQXU1TmhH?=
 =?utf-8?B?TmNPSDJuaW5qOHYranlDalB4MkdIbFF4cHlSQmJXRGhkdk4xb2xjNUdMM1VH?=
 =?utf-8?B?Q2tZdXZROFA5MlZ2WE9ZS2V3Y2FZT2dIZkFVc005RG1tL21hOEVRd0UyNzFp?=
 =?utf-8?B?NkJvZ1loczVwVDBTVUdDWElqL0hzSmYzZ1d4VXF0dlhJWDIrYy9XZ1dEZFJw?=
 =?utf-8?B?Rkg0R0wwQjF6ckxoQ2loZXczVDlNUEhiVUlTZ2NSYXFnYVU3Yi8rZFc1TzhC?=
 =?utf-8?B?Q1VhdE4zVnFuMkQyNUQxMGlkeVlZWDVqTkJoQVBtQU9HYndNc0lHVFk4Zzla?=
 =?utf-8?B?VVZPMEx1RHFWeW9iTzRZSUhmSDdXT2NqU2lkMlBsN3F2NHVQcHloTThEUWpQ?=
 =?utf-8?B?dmZ3ZGg1NmNjVlAveXcwUlRPd3JVKzRkMm9TbXBybzdtOUxTU3ZCSEwxR1B3?=
 =?utf-8?B?K1AwZHJWdUl3NitVb3dFZ0dJMjdmSk05eUFLbUh0bHM1TjN5MlBXTjMvWUcw?=
 =?utf-8?B?aDhaM2NobDdBaE5reXY4YVlja0ZyM0ZVUWZvaVl1eVByNmtYbmRrYUlUM2g3?=
 =?utf-8?B?b0hJK1FBSEhONHdnY3o4S3FweFRWWkhTdWxjS1lzemhPSXVxUVpxZGhGODNN?=
 =?utf-8?B?TURPUXBHUlB0dVIvUWZHdG1UQ2JEOG1ZQnZiZngxZ0YxNGNZSUswTExramxo?=
 =?utf-8?B?TVJWVHJQNktEY1JLTWE1OTdXc1BrNCtkeXE3OVczSys4eVE0d28rdjFERDRU?=
 =?utf-8?B?cDloZkRteUp2cy9EMEh1bWpJK0tUNE40bFFRN1hHSWJUUVBJanY5QjBQNmJH?=
 =?utf-8?B?bkl0dTE0YVFLUFJMN0ZQL05MbGgwNERSN3JnSUJKbjMyMUFscWdicW8rcTV4?=
 =?utf-8?B?TzNZaGhxRXp4aXV3MWhqUTJaTkNmbEY2Qy9YTEhNVG9XSVF3cld6ZjE1eGE1?=
 =?utf-8?B?ejI3Qy9GTGFHQ3RwMzFrWk9HWmc2dnFsNTNOZEF6TXNydnI0T1N0dWJ3UFp6?=
 =?utf-8?B?cjZEWUJiS0lQdG03QzYwbzZpYXVVbmZzTW9HL0FjSGpMYVNaNlQ3R3NyNTlP?=
 =?utf-8?Q?1OUbOMh7wwxsLTguxbuXyncfI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67da73b2-7e1c-472f-a152-08db08d82d32
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 06:54:37.0900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /NjSX/33EImAbPhcvhBclAN5pU/jmPfM35MpSIUDJlq++3QEotks2bDTc80sGK81EodePIylB3pY2jDkNEZL4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7496
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/7/2023 11:58 AM, Jakub Kicinski wrote:
> On Fri,  3 Feb 2023 13:15:36 +0100 Arnd Bergmann wrote:
>> The forward declaration was introduced with a prototype that does
>> not match the function definition:
>>
>> drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c:2166:13: error: conflicting types for 'xgbe_phy_perform_ratechange' due to enum/integer mismatch; have 'void(struct xgbe_prv_data *, enum xgbe_mb_cmd,  enum xgbe_mb_subcmd)' [-Werror=enum-int-mismatch]
>>  2166 | static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c:391:13: note: previous declaration of 'xgbe_phy_perform_ratechange' with type 'void(struct xgbe_prv_data *, unsigned int,  unsigned int)'
>>   391 | static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Thanks for the fix. What's the compiler / extra flags you're using?
> Doesn't pop up on our setups..
> 

Yes please. Even this does not pop on our build systems too. Would like
to know those extra compiler flags.

Thanks,
Shyam
