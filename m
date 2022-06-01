Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B90F53A0DD
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 11:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351322AbiFAJlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 05:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351283AbiFAJky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 05:40:54 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2078.outbound.protection.outlook.com [40.107.101.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACEB4A909
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 02:40:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRduZC1HkU5TuusxXFGuJRwTx8tytwqupjIV8gcQZ1AlMvXkS8QDTmR66hYLS39/OWA4uch4LnSV5oG0F+jtvdeDzXUFQKWMO43+ecJKN8XRZYdE94CrS41iuYZfKavgococM1Xx8RzhBLA77Icp8WoDHF7wjvncjNFOHLYLTbFhuI/7O48FMcNPDNWMrl8eit3YHbWEeGKefWYgS8jid3vUWdNrj0xsdUPvk2exC/lyiq+47DCq9LRC8R+WUN2ht73zu6JLJtj1Szm80+Sa/4YzJuPUn9sPfhheallHvnwWCCJllMKQ3YMWSuZLXfV3cgDwJ9Pf29qc6qtkll219A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BA7G/+rRJ0r0nehPgh9x9BjUBmFVT2s2NGyonARyBco=;
 b=bqmFzew60UK8LR3QRJwyHSVQTHLslx2WHYtzfy32frb+F7Q0cClYqpqZo/kuGT2KAuLOiuPqixtUkby63yHJwZtRrhplo+a9UKCk5zAFlotMM5uncMajFGMs8E5NoWQl55F7WLP340nrHVuOXuvHyR0bygVwW9ZHW8juHOjmIpaOOvAWiqTIe74vCp7b1V6XH3Lw1ym1/1khHDe8sRCZMcjekIkE+Zv3KMkMHHJy3BBSrN/r4E9EH3m9/JdWwJkXXj/5bBoOM4vtBNlxjzBGBF3ClwuHJDProwRBm0Tkos2WyQKb2EbgbzUy6MzTyCU0sXWD0Vooim9Th/TkQWQ6Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BA7G/+rRJ0r0nehPgh9x9BjUBmFVT2s2NGyonARyBco=;
 b=lnecbsIY5Vqx8eEt8fqMKpCB3AbxMCHynn7DA7lOyLVDfPHdUv+J+hk1JDYqZih3qIHp70BYiMCn24HWqQ24khS8XoJBwEsYeuKR7OB2gwHYWRUl4SJTfavNeWfXYL3DsCebFEP7U1YJeb+Ta6G6UZWb8MnUPK88ToZ2fKNZx4/YNbNuJOCkvvT9NIgU3t4OawTFcV8/EFcN99Hlc3AJiQg+FApwmx2KzZnT4SvK32z37JXdl76neaTWA+c7jPiRtRIpwDjfupVQcVoswnCkYgqjlio2sJB+AHMC9JDucCkUo2Wc+dH9DRO3Bv+VQPL7eZt1gRgecyU6uxlZ8qy2HQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR1201MB2490.namprd12.prod.outlook.com (2603:10b6:3:e3::20)
 by MN2PR12MB3088.namprd12.prod.outlook.com (2603:10b6:208:c4::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Wed, 1 Jun
 2022 09:40:50 +0000
Received: from DM5PR1201MB2490.namprd12.prod.outlook.com
 ([fe80::3994:e58d:3909:657]) by DM5PR1201MB2490.namprd12.prod.outlook.com
 ([fe80::3994:e58d:3909:657%5]) with mapi id 15.20.5314.013; Wed, 1 Jun 2022
 09:40:50 +0000
Message-ID: <77a41c44-9b10-3aa7-8899-9c251865de94@nvidia.com>
Date:   Wed, 1 Jun 2022 12:40:42 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net V3] net: ping6: Fix ping -6 with interface name
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20220531084544.15126-1-tariqt@nvidia.com>
 <461d1b36-70d3-31fb-6e03-edad2d39b04c@kernel.org>
From:   Aya Levin <ayal@nvidia.com>
In-Reply-To: <461d1b36-70d3-31fb-6e03-edad2d39b04c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0053.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::17) To DM5PR1201MB2490.namprd12.prod.outlook.com
 (2603:10b6:3:e3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5e4a47d-6d6c-4984-7976-08da43b2d027
X-MS-TrafficTypeDiagnostic: MN2PR12MB3088:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB30882F915E483323E74F8442BDDF9@MN2PR12MB3088.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yWumeyhMfU0HfyhCyq3RdS9qEElBU03tuk1a1uLqjVNYT56YtmoC2fkHmcc5I0Gdk1clqpcI2dXyn++lc25ubiLZuAXAxldlkAUCnGTNmMRJLqzb5mDl52rGV1eNUZ/20qiIO7c78ia4Utg/0vWiJQkNGBz8t9NTnD2UbAhzKEL2w6J7twpDUMYyoCsMK38PZz+fPRZji3hvyJw7LN5KM+rWeuHZXSFMJ+cNPoyY9dZotDkVObxQsgTMkiMcXaiEWQGGRpFAn0d42A9JHyYN2q1RY35jqD/LjaPr0n8x1iX9JZRIr0ZE/muGHrc/vzwfGNJLUqguXEcIFiMPzr24EJFxLBkKjRzCFI0wEO62M7jkhz+GxEKaUpQ+tAxMeviw40CwGcmlnUOge+MgkKf9C8CpBzAqe2oEYVooSSmuEfADny9u5/sCsYYZoH+TD4HifLa5UUv+NvJGnlLcYtWc/S/NJySRJ14Yl8hO+gZLCkRIbp1ML3Y8SGfs1EsrECpKV9GBFl3XWRUWOZdeASI9/aN1jv9jK1lyayQFUiWA3OtNIptc9GtDDbthtsDEhopOvbhvnERqWATm2VMzwbMAbNS2zA+TsfSyo2JhapJ+Ti7zRxcScHsR39NniQuGEAfspmUR87YB0htpwLkXSlCJ9OJq0+D5LxdZrCWYw3RG9hml5extIOn6djjUG1MEQ+Oaeqf7Hn+QKm0YjsvhS4ytFagG4jy3NN49yoyCiHLc5fo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB2490.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(8676002)(186003)(66476007)(6512007)(66556008)(31686004)(5660300002)(83380400001)(2616005)(66946007)(107886003)(26005)(110136005)(53546011)(54906003)(6506007)(4326008)(8936002)(6486002)(6666004)(36756003)(86362001)(508600001)(31696002)(2906002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkxWcDZUS1pOaVpPclkyVWEwSEZtZkROODhCOVoxWEU3dXQrVlBwU2pSdk1z?=
 =?utf-8?B?YTM1TkR1Sm4xbjhja1dHN0xDN0dURWNJb3d3eURLY1JnbFg2TFlTMVpwVzlS?=
 =?utf-8?B?ZEtTZlZlNUlPbWRKY2thNkVWd0ZvOVB3SFRDSWFWQUFlMzZpaG5idmxzRWV4?=
 =?utf-8?B?WjVxSFVJV2lEeVRVbXRyZDZzMTdiKzBQYkp2UjExMjN4blVTRjh3ZnY1SjZa?=
 =?utf-8?B?MzFHazcvWHlxQW9mSHNiaEl1eW5iamFrR3ViMnA5QUFkMTFrc0Z3djVRdCtN?=
 =?utf-8?B?N0VJTzkvWng3QkFwMGJoZHUxZjUyT1RNeE1lL3pmdHcxeHNaSWdDRUg4cDB4?=
 =?utf-8?B?OHE3OVp2SmF0ZkdoNXBIaWNWeUtjRlhCeCtrSDYrdmZjNWZDOTN5V09CWlJ1?=
 =?utf-8?B?dFM4VWFVUlFQcndhQTMvVzljR3A1K0R0eGhRSEgra281ZUlWZHl6bE0wYmNG?=
 =?utf-8?B?SEdzdUU4RU5LdTFvVlA0VWdySHFuZnpSV3FzdHVMQUR1eXJRdjc0MGtnang3?=
 =?utf-8?B?cWNFYkt1cDRsZThJTnVyQkMwd2pHR3JCbkVXT1pMN01QYnNwSzA2T0UyVGF0?=
 =?utf-8?B?am42cDVzWUFUZlp5dUppUnIvSjQ3eXBnOUZaR1NwbzRKUGUzeERSK3FpZ3N5?=
 =?utf-8?B?eUFBVXEvVDNHNEQvSUFUSTA2K1BCS1pBbUVVS05hNGR2TSt2WmVHQkE5NE1J?=
 =?utf-8?B?U3lyUUFXamNRWjIzOUlNak40LzVQSEJoUzQ1bmZ6U3dCRlM3blk4RmRWMG9x?=
 =?utf-8?B?VlVZYktDQzNZUWlTZ1lIdmhsZ3NrT3EvblZmYmR5RHZjMzM5ZVhreDZ2V0ta?=
 =?utf-8?B?NmQ0dml3OHNwVEtPRmVuMXRqbGsvZ0pTR1ZQTHM3amZjY0dHa01USWVQclVh?=
 =?utf-8?B?Uy92Z3RVL0lOSGk0NHVKWGU2NHB3QXMwdEJXQnBtWVVVNVRWeWQ1UTBFa1c3?=
 =?utf-8?B?U3E5ZElEOCtPNEJtVFFvT0NMSW9GOEJUUndZOGpwUlBIZnpJU21BSWdKZC9R?=
 =?utf-8?B?b2JNRjNkbExFZm4xeFZHc21aSTR1RlJuSVJjbE05d3NhZ1R4Y3B2bmpkL2lU?=
 =?utf-8?B?cWhtK2VnaEx1YlEwQ2ErekZPZ2pPNlBXeWNuTzJsSUZ4bnVnUU9NdnF5cVQx?=
 =?utf-8?B?TmNKQ0tuN044bm1lVHdzRDY5cmR3YWU3VGdBNTY5ak5oT28xVXNKa1MxSVFm?=
 =?utf-8?B?Q05ld1lPTDl1YytubVF2blZtNTlzVnVOSTA5RllOeUlacmM3UzZrcG5naVVr?=
 =?utf-8?B?SDQ5Mk1YaDNMOEFNcmc3ODRCcFFXbHF0VGhvdzFZU2w4U3V2Nk5KUmtLY3U4?=
 =?utf-8?B?L2gvYzNucGk5Z29RcWVxZlp3eC9mOUlmczJKcHZXSjgxV1JPMEszWlVjcTI5?=
 =?utf-8?B?VGpUenZBMXVUYWRxUHVpL0JOWUdMVkhuTWNsbkN6NkpSWnU3cnlwL0pGYW04?=
 =?utf-8?B?TlpZZ2xYNVYwWExHT0U2S3FUSkhVOVYrRmdXQzErcGlWM3pOb3lCakJyVGJS?=
 =?utf-8?B?UzNvVHArOXR0SFJhRzdCYXg5ZHVleWE2OFQwQkc0QUV0TGY1dk5iTzRhZ1h1?=
 =?utf-8?B?M25pcitBY21yTWhZYjE1aW9hcyswaTVSWGtZOHFFVll4TjArbTJsdmZZVG1n?=
 =?utf-8?B?a1prWVpmdWcvUnRlbUdxK2VGRTVkNEhlTnhMNE5iYnVGemp0Zm5qOS90aXhx?=
 =?utf-8?B?K3N1RS9rWWs1cnJQZ3d1NXhWSU9YbG5LTWQ0U05HVEJRTHZ0VGw2b09uSUdP?=
 =?utf-8?B?QThWSVkvbEh6MmZXSzFTd2N6QjdvZFVwaXloRUYyTk9CSURPVFpCcjBZUERj?=
 =?utf-8?B?eGFESEdWbWY0NzhDblhrL2F2QlFlY1ZOQTdtbEpSdGM2czFzZ3hhaWVUQkRh?=
 =?utf-8?B?Syt2cDlLbHZiRjVsdDZoZVhSZGg3dnVJT3Z0UlM2elZud2tUMTJ3bENHbnly?=
 =?utf-8?B?M0pFbUVxNUQ2WGdESEJLNXdZTDM0eEpGSmdWWm5QZFUzYVdaYU9yK0RhRmdS?=
 =?utf-8?B?K0Y3Zk9ITWJsSUxHS3VoYUN0blRRRjBGbndrem9jQzdpd0hTSkE0L2tiMHUw?=
 =?utf-8?B?SEpvdTBWbDByNU9Zd3M2SVpDNFhnRDRsZDExa2xMU3IzblF5eDMvdlozcFVl?=
 =?utf-8?B?dzNHMUNWVUtRbmZjM1Evb1EyVnBJWUdGRmhQOUFEdWE3MmpIazBLbnJ0MmtU?=
 =?utf-8?B?T3dNNGQ5MjNSU3VHSXl5MjFIR09HanhHcG9OSllPcGZ2SGJDZXZISHVZOFA0?=
 =?utf-8?B?TldFbVB1c2cvOGRUYVlqdUtqVXJiZFd5eGNJVXBPaEpEV2VXWXJsTjBOYlBR?=
 =?utf-8?B?d25TbG9WWHd3dVhQVlp6R0VPaVM0ZGQ1VndFV3RBZWtHQm1uKzhKdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5e4a47d-6d6c-4984-7976-08da43b2d027
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB2490.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 09:40:50.4177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q3pYfDn/uEyFCJrk/2RUJG3oipqgXdQhylhnQabD55YSslmE+5igdNoEJYAvGgAF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3088
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/31/2022 5:31 PM, David Ahern wrote:
> On 5/31/22 2:45 AM, Tariq Toukan wrote:
>> From: Aya Levin <ayal@nvidia.com>
>>
>> When passing interface parameter to ping -6:
>> $ ping -6 ::11:141:84:9 -I eth2
>> Results in:
>> PING ::11:141:84:10(::11:141:84:10) from ::11:141:84:9 eth2: 56 data bytes
>> ping: sendmsg: Invalid argument
>> ping: sendmsg: Invalid argument
>>
>> Initialize the fl6's outgoing interface (OIF) before triggering
>> ip6_datagram_send_ctl. Don't wipe fl6 after ip6_datagram_send_ctl() as
>> changes in fl6 that may happen in the function are overwritten explicitly.
>> Update comment accordingly.
>>
>> Fixes: 13651224c00b ("net: ping6: support setting basic SOL_IPV6 options via cmsg")
>> Signed-off-by: Aya Levin <ayal@nvidia.com>
>> Reviewed-by: Gal Pressman <gal@nvidia.com>
>> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
>> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
>> ---
>>   net/ipv6/ping.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> V3:
>> Per David Ahern's comment, moved fl6.flowi6_oif init to the
>> shared flow right after the memset.
>>
>> V2:
>> Per David Ahern's comment, moved memset before if (msg->msg_controllen),
>> and updated the code comment accordingly.
>>
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>
Thanks for the review.
> 
> The patch set with the Fixes tag added selftests using cmsg_sender.c.
> You can extend it to support IPV6_PKTINFO and submit a selftest for this
> case to -next when it opens.
I'll submit the selftest extension in the coming window
Aya
