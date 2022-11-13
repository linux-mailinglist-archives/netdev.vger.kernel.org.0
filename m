Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D27626ECB
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 10:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbiKMJsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 04:48:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiKMJst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 04:48:49 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDC1272D
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 01:48:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NlBmfabjNdnNY/l8jIwnWGXKBDRO1oyOnaM/E82GWjbJGGqyjDJ76rAcKtIXNh0UGLB+yNFA8b5lv2V6Wcmq8kqp8TiKD13Hne9UU/+1Xi/bveJdI0SwndkYoeVmQkGpE4GD/yRrV6kYPQPIS8b3dAEJsiUVHfCigwu1YlGsDn3Y1CmKsDyLaqYQ7t2DXlNoXfaqwatwKwtYaCJmLb99b2O/r6dZp14Sy6LZUGuXO0UWe3myasCaLaFrUul+YxZFoDEZUacmnJrcLEEaQrlGyZoW6hHF8jug0FyE8PY1xabLE9gELzbWtVoFuxrdRlgypXxoHNQ8ZgC5AuNNxsiz0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/lbwLheF1ARRSRFZBYBeVA3qWECXX5j8D+dzLHZesS8=;
 b=RjLhrw2F7DHO6SIRKS31e+d5vY5rBMIXXXIUmtPJSyh6HDlSKHcO1u+C4r3hJCFgc9B0/8RlmHjzEBOZfzTOLdhBb5q5rFiPDJcZTJ6BdkJ/qAk3EkrAHHNJ0UXCyMJivz78TdLTo4d1Ja+2+GXJguf2/XTIMrb2ZV0Xtg9VCL2rKMchUQE5qv2dfz0XQVlTdq6xT3znGmJ4ViN1JZ7NPjnN6A4cYN0lNgYQwownnVhj7/slkB2oeaZ/xeM99jmJdSxQHFDmRFeyNsMQoV/FUjWXUJzkOMnvhnypVfUFOachKNQi8aXCw2YuXHjj2an/bhAhDS4RzdxVwuhsu8NYSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lbwLheF1ARRSRFZBYBeVA3qWECXX5j8D+dzLHZesS8=;
 b=fvglSaYWUkQH9WB432AV8RY+ZISSiCfciouk5mzMXqyCFvUIKhtN+g21lzk+wJZeV5GvPUUiUGvs35Hq684T3xg1dOkDEVyBPd/Yu1Co+fAxP96mDDcLpKJyBdSeljGxohpDa2z1mNM4ofhqltgnGOxyZNyFEMAtr5jf6t9XmQznS+VJTnuSr7/NxN+G4baQzUMmVieNkAv6dhJqhmYKiS5n6mm19nl4AnYulTD7ayJiI0+9mKozLRn1hezXv3En9cQyn26o0Qk5iycRXzZfd/r8KP7kCWIp0TgBkEiUTx7w4dk2j0RFOdkNbrcDp3+G4jYnHNMNeG1Xm+5sovbHcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 DM6PR12MB4090.namprd12.prod.outlook.com (2603:10b6:5:217::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.16; Sun, 13 Nov 2022 09:48:46 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::fe97:fe7a:9ed0:137c]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::fe97:fe7a:9ed0:137c%3]) with mapi id 15.20.5813.016; Sun, 13 Nov 2022
 09:48:45 +0000
Message-ID: <8b0aba42-627a-f5f5-a9ec-237b69b3b03f@nvidia.com>
Date:   Sun, 13 Nov 2022 11:48:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net-next 1/3] ethtool: add tx aggregation parameters
To:     Jakub Kicinski <kuba@kernel.org>, Daniele Palmas <dnlplm@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
References: <20221109180249.4721-1-dnlplm@gmail.com>
 <20221109180249.4721-2-dnlplm@gmail.com> <20221111090720.278326d1@kernel.org>
Content-Language: en-US
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20221111090720.278326d1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0238.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::9) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|DM6PR12MB4090:EE_
X-MS-Office365-Filtering-Correlation-Id: 7536eb66-4a4c-4efe-1246-08dac55c41ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dNIjjqlPXLeDpVe6C0e/qsj6a3fGvZ/7f7plKtQjYVqxUVAptc9SEqzD06iJEl4v2lxF9t8QVWZjtDm+nvsoA14vjAjV9w5AZsDAB0y8u6S68PiUgvn7c0/+8kGVUH+VUbfrbVOfm0dvZa04iazNWhRYmJ8ajYVmwqTBJMdV2RXjlJDtmyD1DMOrQij9Wl0ruRVn69IYKT8+qRNsY3b4ssiKMfeMZcpaFro7u8F+8+xjK+m5m5BpiWNJ28hAhC6gZaJCkRN7HwtpGJDi8ou6vJACk0DfO6ADji0kMfu/EmtAb8hIQUYFd0JauvgeZMiCLhRdbdJhqqSdA3rtCUwut+Xut4X8o6P8ED4IzlS4zuYF8yVS1bemUxSE6OAi6DmrAh2GxnUfYlXPdFXUYCTTIaJeESDLePJFA3qor6W3CPMmWlrrwCE5jMsNaSuLgBr+IjyWERzYZreXOyz1ELHiodZwUFnpfhJ8ODUoGf59O0WnFihU8lyoPD5jiBoKiE5XOz/KcaociXnD2MPzPtgHQ0cs8OHCtGMFPCcNmBPfLnvZJVh2ODc9N4HyOhh4tbwph/yAZiYpbtaeOiZYSlqTlemx2mMgnaoYdoarNGYNvmba/iO4g+gLAQgSzGg7UfR0lWCkv5P9d9y3Ks1K2HQ1j2hhKjrVlcVwjtHg84Wc+CbX1mMtALvIRKyuCxBQ9UpZH2gI1RZP+m0e9zy7qiIDsuIY00AnEcmFmEXaJ8ynN07Qy3KoFXlF34RpJSsyy/r3Ej4TgUwTbA1NjRJ1k1AZy8qBMz9CbNsKpjUyyus40jw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199015)(38100700002)(31686004)(478600001)(110136005)(316002)(6486002)(54906003)(31696002)(8676002)(53546011)(6512007)(86362001)(66476007)(66556008)(66946007)(41300700001)(7416002)(2616005)(186003)(8936002)(83380400001)(36756003)(6506007)(2906002)(6666004)(5660300002)(4326008)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzBtZDQxdFNQRkszcFJsa1NvU21vNjZTVWtPODRFZlZSSnhDN2M3RXlpOHFV?=
 =?utf-8?B?dDVBcDVZRUFaL2xJa1Y1c3FVZjBEdnBRQnV6akNxcnFRNlhPWEZRaW12L296?=
 =?utf-8?B?d2puNERqQ204czF3dGk2bUZTOXNjTHRHazJpVnpLeStWS3Jzbkw2UlRGTXBx?=
 =?utf-8?B?Tkp1NExrV3RhNWVhb09wQUdGVXozK1cybUhKeHplOUlIZ3c5eXNIWU8vNUU4?=
 =?utf-8?B?cHpFR1pheFpDYWVnd0lUaGF6a2dFRDg5Q1hxdU9pMk1seHZ1R0hWRjZieEFr?=
 =?utf-8?B?ZGVCanAyWDVKbTVvcDVHeU9vbmd5a0UvM2YrbDBJdWM5aS9uMWFXN3hsZG84?=
 =?utf-8?B?Z1ZBMzdEY3pyM0w3OUpoSHdvaHlyYVpsbVhIWVB6RFgySFl5NDJlVlFQVUF2?=
 =?utf-8?B?K29JWDJzeHF6UXNadHZ5QUt3UHJPb29RZEVqZnE1ZmdOa2szYkhaTzBSTURB?=
 =?utf-8?B?elBQZDFEMm53OVVsS1g2U3NSdzEzM0h4QTNxNVVOR1ZkL1lvbFJBQzZHYU96?=
 =?utf-8?B?MUp5LzhQdlpKVjlMMlExYWpUTjNJMEtxSTdFS2VpRHBURnJobTA1bkFSYWNM?=
 =?utf-8?B?amlsdysxUzZLRVNGQWJDa1VrTlNJSFBreVkvdTM4V2diQTZkUTJvRkxzMUVU?=
 =?utf-8?B?NmxzUmVCZWhtdGxEcUZKK3RVYTk1bHgvUjNKNXhNVUZZS1A4ZUxXWXdCNlZC?=
 =?utf-8?B?blRuQXREQy8zUnFZNGI1dUpkRC9QQXpBeWdjSmVJRHlBUlk5RTZkQ050K3I3?=
 =?utf-8?B?S1lXRlFrZnh1UkNBc1dIYVRYWmNtT3U5M0xBaktOcEU3Q2JpaHJvbS9CRzlX?=
 =?utf-8?B?U0piQ0Q2Wm0wNW9tdnBCckpMSVo4NjJLR3dYdGx2NlU2ZkRtUnMvRGxZVFMv?=
 =?utf-8?B?TnFwelRHa2k0ekpzMWt5KzdvajZBK25EMjZqOTVicndXTVRWdjlFakVubDdP?=
 =?utf-8?B?TkZFSWtvdk1Xc3JJSjBwSzBnUVRQeXYxRit4V1NHZ2FHWUpYRzlzbGU1dzk4?=
 =?utf-8?B?b2RaU2pxUEdJV3pUaktsQWlwWUVrbXlyT1JmSEZOL2NRaGFjTmI1UGd0bzd3?=
 =?utf-8?B?dTl6VWFOVlRnSzd4ajFFZ0JCK2tqYmFtTHBKVDRCVHViUGdGOE9WZ1JhaDFk?=
 =?utf-8?B?dWY5a2JGOUVhdEF3b2FiQUlEWG5HNnhZSERJeUpEL2Jkc3RUU3pXUnBreVIx?=
 =?utf-8?B?K201Q2Q5RGlnVU5hYW45R1B0NWE0UkFPM3VtMmtRaHltdktVeU8yTU5CNGdL?=
 =?utf-8?B?aWxENEJLNVBmV1o2LzhUcVltTDRHcHhrb216b2Jqc2JGcFpwOXNsbU42eERs?=
 =?utf-8?B?T0NvU1VVNlRPQkZvUWNZNTBHUW1VR3QvdzRIL1JPRUdvbTRLZDlEVU5abHZl?=
 =?utf-8?B?SWlIbUxXS0hHaktGaW9zWXdjcXBXeDkwclUzSDdnNmdEKzFkalZRKy9IRThN?=
 =?utf-8?B?SGJreVdNL1N2TFEybDRHUmNITkljMkxEbWhKTTBTTGpsSXJaUUVCYWFwNmdQ?=
 =?utf-8?B?RlFLTHh1MG1aaUJnVy9HRzNONmJXVzNVd1h4eTVJRFkvdWwyK2FQa0lhTVpR?=
 =?utf-8?B?ZEQ1TVh3VUxrQzUwYjk3Z3RsV3F5cHhudHpFakp2OUNrQlQ1QTRPdVk4WnBO?=
 =?utf-8?B?OXRnaWt6VkFGVXJES1BwRmtLQVdNYnlLRHVLMkwzWVFiRy9LMklWK0NqV0Ji?=
 =?utf-8?B?dzU2YTE0bzBQaHdxMDVERDFCRjhFSC8vUmN1eUlDemR2bi9adSsvSE02bk4v?=
 =?utf-8?B?WUNsdS8ydXRabEpPQldQU1BSejFIZUR4aTVUYlhiOFY2clVKTzB5enRCNWhv?=
 =?utf-8?B?a3I2WTUvc3dPcis4ODFxM21hdW5kZXZLNHBTcktZVkpXSXYzcmI2eU1tdEpS?=
 =?utf-8?B?RjY4M2NzV2JGOXU3aUxEQlM1RkVUWEF6MWhZR2dISi9NSjdzVEJ0VWtjWWVr?=
 =?utf-8?B?cCtZUjNrZzBGbGd1TmtnQVNXM0xqZFNXeTBTU05zWTBJUmZvNTVQOHF6d2pK?=
 =?utf-8?B?Sk81Kzk4WldmRFp6cEJ3OEt6ZHhZRXljUDBlOUJranhpQWF4Q3N4dXpFSHRH?=
 =?utf-8?B?QzA3RC9NS2lBMmNTa05BemhIek1UOHAzYnJTcVRrdVhvOFpiU3QvUHhVN3g3?=
 =?utf-8?Q?ZQchNMohwJr4yohmhj7yguTmp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7536eb66-4a4c-4efe-1246-08dac55c41ab
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2022 09:48:45.8239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9bNB6POmkllpW7QNcevUOLUD6J1dNJwFujgeDDRPkofA1wsAdOsMT+h3xxltzOAV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4090
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/2022 19:07, Jakub Kicinski wrote:
> On Wed,  9 Nov 2022 19:02:47 +0100 Daniele Palmas wrote:
>> Add the following ethtool tx aggregation parameters:
>>
>> ETHTOOL_A_COALESCE_TX_MAX_AGGR_SIZE
>> Maximum size of an aggregated block of frames in tx.
> perhaps s/size/bytes/ ? Or just mention bytes in the doc? I think it's
> the first argument in coalescing expressed in bytes, so to avoid
> confusion we should state that clearly.
>
>> ETHTOOL_A_COALESCE_TX_MAX_AGGR_FRAMES
>> Maximum number of frames that can be aggregated into a block.
>>
>> ETHTOOL_A_COALESCE_TX_USECS_AGGR_TIME
>> Time in usecs after the first packet arrival in an aggregated
>> block for the block to be sent.
> Can we add this info to the ethtool-netlink.rst doc?
>
> Can we also add a couple of sentences describing what aggregation is?
> Something about copying the packets into a contiguous buffer to submit
> as one large IO operation, usually found on USB adapters?
>
> People with very different device needs will read this and may pattern
> match the parameters to something completely different like just
> delaying ringing the doorbell. So even if things seem obvious they are
> worth documenting.

Seems like I am these people, I was under the impression this is kind of
a threshold for xmit more or something?
What is this contiguous buffer? Isn't this the same as TX copybreak? TX
copybreak for multiple packets?
