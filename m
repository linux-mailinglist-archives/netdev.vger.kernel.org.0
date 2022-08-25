Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789765A13BC
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 16:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242137AbiHYOge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 10:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242081AbiHYOg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 10:36:26 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70079.outbound.protection.outlook.com [40.107.7.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1AEAB047;
        Thu, 25 Aug 2022 07:36:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d16ObxBDhMdJyeMl3oaVum8mXrJBnSWs0GUFkRKuIi1eNpuD6mEbwzzi8UK6KC+FekciEbVXZpkoQVAUUUK5pd0JnMlT2TFhAaCPQfONRdLEl6Fs5h6tiuCKijfp7lGmo1NgGgtU3U9ymCIuzRbnica5MFERls9hlkVbb/PhN0AcKrMFQvsjBWF5DV2hPoVuuMG9+COeaKqM+LxRNEX2ZBkhYCC3V1bULTZKlw4bUNa587Y9POe/AE9+qQA3szj2NN1WIxtHQlXvZXS/4UzKUQMDBFwWo+gowYZP/przrO+OoRJP6/ZqS3C3RU4VqBw97A98SXE8s21S/OFssJiDZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xk6x20gFFxac8vDLJUXa6+QE4HBCpLyVPIBP2iVmhEs=;
 b=ephHp+wbbWQ/o4pBuqXegG+kFXEeKcK9fIZcYDyEIzsLBTqd8wyatCGCju3bhabvB8V9PjUsiBYliJSUf/GtfUTF9M+N9Lb1fatlOSFm+tRQeeFTb09N6DB4JbtpyERPAgvo2CAvkuuRaudTREqbQ5EEJe1JhfgDM3wLOyw3R5nO1iuRQWUNyMnEBjLvWi9DMtr2qCRWQl/9h3wdPKCLmP2d17J1dM4Z+TDCr1IgMQjh10pRmrndLU2jjMawKtl6AfBtOgsHLNVAptmzDEI9/agxsslHsTx8618dXZnd57tHIwVcFqSiZ4lgViIBcQh6l5JhdeCfdsmgzsh0rFlzyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xk6x20gFFxac8vDLJUXa6+QE4HBCpLyVPIBP2iVmhEs=;
 b=M3RgA64gHm8VOCMazkyskeKHe/QnwwwBAOKcRbm+XRTfbDqh70HMJwSfdQufhrJBrtpNW0NKi40Jz2V7Xsf+92HTcGQDUcO9Gs1mx+PHFWFTj0jJSTt3cBwG6iMLEVnxwLKUtRWVWguI9gbbE366qFuf3krZrAWGS3Zc8CAcfFNNHhShtFzcbvjkDAX+UxiOZhvnlXVyifI3hcJBjUvvlXJ/vR06I5MaPnTM5PKrFkxreRGr/U/W8hHZ/Cm7LELzhbMvnf7jrF7MtZfsHjIWaNri4hB35Dy1nJPI7DIKSpn7KN8PjLBfp8fhhL48BDxsOBkm6PGob42n+LI4PjYaoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4907.eurprd03.prod.outlook.com (2603:10a6:10:30::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 25 Aug
 2022 14:36:20 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 25 Aug 2022
 14:36:20 +0000
Subject: Re: [PATCH net-next] net: fman: memac: Uninitialized variable on
 error path
From:   Sean Anderson <sean.anderson@seco.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Madalin Bucur <madalin.bucur@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Camelia Groza <camelia.groza@nxp.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <Ywd2X6gdKmTfYBxD@kili>
 <ab5f4ddc-12d2-0f60-e044-0134c6be97de@seco.com>
Message-ID: <b9c3d76b-62b0-2956-2918-70161868af4c@seco.com>
Date:   Thu, 25 Aug 2022 10:36:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <ab5f4ddc-12d2-0f60-e044-0134c6be97de@seco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0099.namprd03.prod.outlook.com
 (2603:10b6:208:32a::14) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ea06ce2-5c79-42c7-916a-08da86a72d12
X-MS-TrafficTypeDiagnostic: DB7PR03MB4907:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nGQQ+J/qYei5NT2Jq1QqAy+nIdhB4duMOkEGK5k1HNQ1wx3qO7V2b9xV8//Yl3Ib9YvSpGqE07X01SguX23Tgh/Xac3cyX++DvSa6+sGG6wFzZifhGX6ZGf70jmmx4s2J0iyVgTVvXyVt5/9MHMjefXl5cfi5t7QUtasYQ2YHP/t3U/e/tH38SKAWKxjlA8P6aFy2OjyrkT3Aq8JvecnWlp95Luv09zsXfARRKwLcC/MCGM81glS2qv1bUEr+6eOscvkWFWsv4oNqOfJzpJA4JTA8EvFPNN2NUOP8QHgucxVWpDyvMkddzNbxD3S7U0xVVImGFsO1fUYaWssT8uAUgEV8CFNlndGr/7kUUUhKd5zoRvmaLTa/Qbhcy6BUgMU3X2fNLXjWCfxpV6fBf7wJxYBW6iLsGKsAYpOOl2TH5ZU6EMQuTytOFr0b3KDqyqbYvq4fd1GYpbfW4gS5FzliPkvX7SBD/24lpQltSde6+KWmGMZUVILNetOpbPMAOXhImN1eqs9AuMYeLzF3lR5c1qTtOEEPS+TvChcpQvvDp4MnwwjbZ6TisBSjEb8qlkP1PVgL5jeTG8yHNRsczi8IFoLqM1n5v5gMb3YUw1wbGvrXHR2ogizCN+ZXl6y9f0gsU9ACi1apnpyRv6QisDhGiZWTS8/fN2b8MkIo9bhuzpQS/OKkSjDMlsrYjL+gAzD21rLD3ywNKtodjYZsDxHJ4nJ0FbgLJFfqI0A7b4N2Sk4X874iQOh76tYEppGmX2L+N3OffEE7wMFv2dHWtI9cxT6oEo833ZkTpcoD/3gEI2TOw2CsTdKIFGjbidp5hVYumPH1Hd6ZKn6zZy7/hRijTwU1ilKFs936m0mQDYQGwc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39840400004)(136003)(366004)(346002)(376002)(38350700002)(2616005)(38100700002)(31686004)(44832011)(36756003)(8936002)(6486002)(966005)(478600001)(5660300002)(2906002)(316002)(6512007)(4326008)(41300700001)(8676002)(66476007)(66556008)(66946007)(86362001)(110136005)(31696002)(6666004)(54906003)(26005)(186003)(83380400001)(52116002)(53546011)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVpCd00vRGhDbXA2RUdkS2dzc1d2YUlYN3dCeUVvaHpTc3dBZVplWTdsMk1I?=
 =?utf-8?B?b0JkNEZpWUhQelZudTdtMVdPRkZVeFR1V3VlOHdhWlJIR01mQUtlVE00OHJj?=
 =?utf-8?B?cjd1SGhPU2crVS9TSlExRGYvdU9vQlFkNCs4R2ErYWlrWFFhTHM4czE3Uzdv?=
 =?utf-8?B?d0J4NEVUclRYWmRIcWIwb0xUNnRUTGhIVllvZ2JEWndTRDhvdTNwMit0OTZV?=
 =?utf-8?B?aXZEM05OL3paUmtqTUxZelZDSVRHMnAzcVc0azMvQUlyaHlhcDg2QjJKQTZ5?=
 =?utf-8?B?UkZqOGZRM0oxb2NBQ2lOWmN3TDhRZGNkcDd5TVArKy9DOWpNMDRDOTNadHNR?=
 =?utf-8?B?R2Irb21PSVRGZFMzMzlNdS91ZEdWb3FhWjRUVjVleHFDRFBnbzhoVVpRZmhO?=
 =?utf-8?B?dFBsYWprdGVHdG1hOGYrOEJhYlFBTGdwM0Yzd0srUjYwazZweHlIRHNMY0t1?=
 =?utf-8?B?QVJYWmtjTnJqdTdrOHJZMTkvR0Fid214RXZMT3Q0VWE4WVk1ekxKVGt5QkEr?=
 =?utf-8?B?OU9hbVJMZzRpM05CU08vVnpHczNJSjA2RVIzMGpCd1Nidzh2eERLZ1BOb05n?=
 =?utf-8?B?UGlxOUVURlpaSDFrNTY0OHR4amp3UHorU1Bqa3JKNXJkajh2MHBsYTdlK2U2?=
 =?utf-8?B?K25zelFpNHZpYWpFRnBpS1BIWXExcWlXYUFVRDNXc0tEdHQwblNKMGVCY0Na?=
 =?utf-8?B?UEw3T2p4VVVpOTNTUGZZc1o5SWZ2ODkxWHZvY05tY29VeU5Ea3ppTjEzeTN6?=
 =?utf-8?B?RFc5UWNjVGNLVWtLTEFJanc0VSsrZWY1MXZEeURMMEowTWpFRlRjUENVdjdX?=
 =?utf-8?B?RzFqNlFCL2xDblQ2Umd5QjhPR3pyNWtrbVhmdDZ6cFIrbW5QL0Y2NnFaRWxj?=
 =?utf-8?B?cGYxWHFZSVludithQ2x6VTRCT21ZK2V6ZFhHQWFvcHN4NUZEU0Z5Si9ieE1i?=
 =?utf-8?B?WFVsTHVweDUxMmRtbkRNelViR3FRU0lGRnZiTnRUOUFKeEl2R2dGM3hMaTVJ?=
 =?utf-8?B?SC9VQm9tUjVmT3FObHBzaTdIQjZYRkFjYUkxVDcwWEc1Y01FRC9OMXo0K0Q1?=
 =?utf-8?B?Q2dwSmVtaGpYUU51eG9PNmNoU01mWGozT1VvT1NoWFJkUXdock92T0ZGSzNp?=
 =?utf-8?B?WTlNWU14RTRGVWZabk1MOWZFNFU2ZkRVNUhVOERGdWtySm9SMDlrVjZJN0hU?=
 =?utf-8?B?WXRzWTQzVzhkZEZRVTBBdEpySHBlL3cyK2xZbVNENURSQnVyTWt0YitMaUEx?=
 =?utf-8?B?SGswdGVITFdkVkRwZkkzVU9vcWozWXBtbm9qUFMvc2RqdGZaMjAxc1BqMXRy?=
 =?utf-8?B?TlE5TEV0SkxpekpvNUhnMWxJbzdENDNxVnU1Qlc1WWw0Qjl4WEpmeHJBTEJQ?=
 =?utf-8?B?QVZGK3Y5OHhzR3JPVG91eFJudUhvRFRIa0ZaalFrVVpoeWxpQkliUDgwTEJU?=
 =?utf-8?B?YlNrekRmdHlIZ1hUOUxqYmNMS2IyZEY0ckg5Q2txUm5lZmFCVlg2bUZheU1X?=
 =?utf-8?B?OHVqL3ZtWUxUcXFGb0ZtRWZUaG5QakF2WjI2VTVoWjNoZUhJQzluRU45VWYy?=
 =?utf-8?B?WGZwOTYzUHVYdWdOVVFIVWt2SVBhNktwR2lOOVlHelVNRFpTZGVqNkdQTHc5?=
 =?utf-8?B?eVFHNFNydjV6dWtoWmhMYUNZRDZCdlN4NUFLZ0dBbEhkY0M2RUd3cTZUakdo?=
 =?utf-8?B?cWVIZjFjMnNVRTRMY3h4bjVaUmx1ZzdUaVQrcE13aUw1S2JYd3hYdSs2aHM5?=
 =?utf-8?B?UkxhNnhENGdZb2w2MDFzMm42alRSZFlTWDdLWmJpZ1JZRDk0M3hCRlZiUFMx?=
 =?utf-8?B?N05jMDQ4RmZzRGVCaEdmS1hKaUMwUTVCZkloa2dKbnhmTVkzemdGVHpOWjgz?=
 =?utf-8?B?MXAreEcxMUVWVGlvT2llSW5DeWxtejFJVk4vVGRPOWlya2JWM2VBTE9UbldB?=
 =?utf-8?B?dHJlUE9NOStNcUdqemZVWFJoZlcyeDNqQVRiSE5uUk1FNGdjQW5rajNmSmc1?=
 =?utf-8?B?Tkk0czIrTlNRTGN2Q3F5MVJ0ZFNVVnp4ZUd3eUlERStBOTNXNnJwZktvdHA1?=
 =?utf-8?B?dlFCTlU4a25MeVRrMVI0QmphbnR3UzgzUHNRaXNmNGRmNlNkcTZVMmN3Z24z?=
 =?utf-8?B?eUtrN0JSbTk0QVAyRWlWK1FWdnZXcUVzNGxuYWlyMWU1S1lkTTc3anBBOEQv?=
 =?utf-8?B?YXc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ea06ce2-5c79-42c7-916a-08da86a72d12
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 14:36:20.2385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MDetMsvdCeWSfoZxUHfiqgkNRr1R6dKMxjymDlI6V3M8NhVdoVCV3lgDcd0XjdPl+sVEr/1gpY1dvkqPj2r3Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4907
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/25/22 10:32 AM, Sean Anderson wrote:
> 
> 
> On 8/25/22 9:17 AM, Dan Carpenter wrote:
>> The "fixed_link" is only allocated sometimes but it's freed
>> unconditionally in the error handling.  Set it to NULL so we don't free
>> uninitialized data.
>> 
>> Fixes: 9ea4742a55ca ("net: fman: Configure fixed link in memac_initialization")
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>> ---
>>  drivers/net/ethernet/freescale/fman/mac.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
>> index c376b9bf657d..f9a3f85760fb 100644
>> --- a/drivers/net/ethernet/freescale/fman/mac.c
>> +++ b/drivers/net/ethernet/freescale/fman/mac.c
>> @@ -389,7 +389,7 @@ static int memac_initialization(struct mac_device *mac_dev,
>>  {
>>  	int			 err;
>>  	struct fman_mac_params	 params;
>> -	struct fixed_phy_status *fixed_link;
>> +	struct fixed_phy_status *fixed_link = NULL;
>>  
>>  	mac_dev->set_promisc		= memac_set_promiscuous;
>>  	mac_dev->change_addr		= memac_modify_mac_address;
>> 
> 
> This is also fixed by [1]
> 
> --Sean
> 
> [1] https://lore.kernel.org/netdev/20220818161649.2058728-10-sean.anderson@seco.com/
> 

Whoops, I didn't read this correctly.

Reviewed-by: Sean Anderson <sean.anderson@seco.com>
