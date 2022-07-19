Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F463579835
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 13:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbiGSLNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 07:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbiGSLNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 07:13:50 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FDE2FFC8
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 04:13:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ko41RnKE1So6KeBt8exK+2dwtgJ7MJPmVgJ+ZBWWPiCaDvKwyUhXvq58ZeysM/T+4dNcNNexrYEqnO7ksrednadbIGkcupEzyT7sLeI43E9GAkQTctXeWcB7tYUGbJQSvkEFunq0cIS9aIBy6bKAPKMyyIFU2ZWijD7JhDnc1apfo4QbXuAIIwt+kKxU57WGcBB7vWNMufNnOvL1vzJnDeNN2qqn6e0r6Kqr9ArJW8hEt32IB3kPO4JOAppdeABb2jNHBxAIh4OKaRPESeEYRkA6AotngVKvls+QgLe+WeYs6CHO6eDJos0PvslWrzgOxs5TY0x16iUtXAXJ6MS+NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EVNP+jNseQZBSeUe33/tx66c1Hi5IozJp3a3cNpW170=;
 b=n3M/n5HHop50B9xTG3uoX8S/oCgHX7+GNCSHhUD9nAIX8YXXbjjD6vRm29GWI7EAANUq05V+JZMyn2494KZhs7U8HkG/c52cMLGSQaqT6pr6mL59ihyPsCB3Ie2cPaTyQaKHwWguOK22lZVhPdqGLTcOB+KBetNztPT09uJzdgjbzyAYYSA483DDPe9rY9Tid5WwANOcRcOvmX8fSDc7VCktpam8Pjq9+asDsD+7CELO3Wuy0QYK3zxnZSPjVYEjMln9mcclNF4jYq1Q/1U2qNFRXaudosRAgFkdbPIoMhPVwVaBUspn85DFFjvScOLv1g3NLSDygg+Q9Ay/MOGENA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EVNP+jNseQZBSeUe33/tx66c1Hi5IozJp3a3cNpW170=;
 b=TgzQu2ZGBcVlizLoGcPvvsG6FVvbtHV2jOwIJcfuMS3muzP5dwwclZwTwuQaWk4qGFJ6qaN1FI+Lq1tMy1g0BlzQ6hVZ9nNcNNIWc26bSgnDXLuWPeWn2qUZGY3JUPUq4x2vdpFrExNa+fNUwWJFNYpcILGdaIqIYTAhPgPpi5YLa5s8x387ZsBGhqQqu5NFYnCsyhu36EuZA9hF0TtqGnzLXLO1Yow5CkIP5toQuTX871j1G+XY8rgqAyCxo5f1eHG3cF2A6LcOZufCzJlDfzxpfJuQo8olCDD+FikAvXkHy6Nw41p2toFUMgGzaHRD/yT8sgunIPXJD3U0gUcgEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 MN2PR12MB3965.namprd12.prod.outlook.com (2603:10b6:208:168::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Tue, 19 Jul
 2022 11:13:47 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::548c:fcf:1288:6d3]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::548c:fcf:1288:6d3%9]) with mapi id 15.20.5438.024; Tue, 19 Jul 2022
 11:13:47 +0000
Message-ID: <24bd2c21-87c2-0ca9-8f57-10dc2ae4774c@nvidia.com>
Date:   Tue, 19 Jul 2022 14:13:39 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [net-next 03/14] net/mlx5e: Expose rx_oversize_pkts_buffer
 counter
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
References: <20220717213352.89838-1-saeed@kernel.org>
 <20220717213352.89838-4-saeed@kernel.org>
 <20220718202504.3d189f57@kernel.org>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220718202504.3d189f57@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0356.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::19) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0da1d534-35cf-4e7b-03db-08da6977c009
X-MS-TrafficTypeDiagnostic: MN2PR12MB3965:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LEU1Mw2ORJBtQWJskK4cMCopvqvCirjBSqDhKM1fdjHoRXErRc7x85ZgdUkBvM5i1CdBvvSPe4AInaLdFeztT+BhkSXlSBptAVG3Plz9yETLpk336Y/xPT1jkr97MIsgv28GmWS4pQ/db26o19l44JO4d8X7VtsiJs202cs6LLmJxGFcPl+h8Fw7AvNeORv3ZusogNiwHBUoBIhqhpITduy0DsHNx3j8P/nvr1ThLAmZ31oAzyjtPeYcuVxLK12/Ed3WBU54XLmBfQ32SMSyMIwz8nzrTCTr2/X7MkHV98QSlBNnBxhMBF3SQ8lAM+/27Ly0Kl/U6YuCZrRhGKso+vzqx9sGK5+lz2zVlJJGZAIyfIjwJLWtbXq7jkfABI4D77y+wmB6mpWf66/QCkM6d57encTdqLF1AqZbA0NfBCzjrN7mjV8xvhPxCgP9yYevRQ3dPjan+yXHDscCmA99y7ZiH0fOfZ2npWYCpId8y/CB8h3irMNNRXvPfCsS/WDcs2Yc2lDvub0K5Zz/2G3J68kM9WyVPC/YMEGM+2ffxhNs4+N0hxXmVr6J6xx9RpPqSrfSQqLuu3X4N4xtLAHJ9XvFtT3wjG/PWlkfBZcMItXIG9gFkdk4BufwKspFrkgoGBRm6TN8GJBB1zRVAePcEuMJpDLGFiEcoSEXlVzsKOMix5Rx8acOHD4VbtQOYRXjWHvDSSHJSGIssBPmYsqPMciVPdcn8X209SkZ8ClHdLffm9evu9hJqQ+uzJkDsaNFa34DfyiEkU6MwPTqy+3JTAivOHpeCOVEQuaQryVLi3MHdvrXBg7NGWIWWqXPC9+YPh/cngJ0LGPeXsxBnXwkpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(8936002)(86362001)(31696002)(66476007)(4326008)(66946007)(8676002)(66556008)(6506007)(38100700002)(110136005)(36756003)(54906003)(316002)(53546011)(31686004)(26005)(41300700001)(6666004)(107886003)(2616005)(186003)(83380400001)(478600001)(6486002)(5660300002)(6512007)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFlpbTlXSUkwTXlwWGhYWC9nV1Q3bkgzN3U1WTNPZTVsbE15bDBaTU9Cd3hH?=
 =?utf-8?B?TlhldDhxS3FiOTRFc2lMd3BDRnhBRU8ya3FiWXVxR2kzMjlhc3NpelJYNmU3?=
 =?utf-8?B?SEl3cnduYVF1bXcxa0MxVmVoNzhjM283VWczUlJrVjYrbHp6REJlTTBJSVI1?=
 =?utf-8?B?RTd2VHZSdzh3dk80VFVGRHVmREZ3TGpjUHJpcDJBUnhrOHFGYmRyUUZWMWNj?=
 =?utf-8?B?c3FGWXRXQit4QXpKVDhlYlJHd0o0bjVjZUZ5UWtLTFB1Y2pDU2FwL29tQlZG?=
 =?utf-8?B?Vm9sSlJRRSswWXU0UU9HL3M2K1FlNU1Wcm92WkNQS0RRaUNDTVo3TmRkalZx?=
 =?utf-8?B?azVKaG5mOGlaQU1VN1VZRDZKbVQyUm1YWUFRTkxDaXVjVkc5VkNNVUI1TjBh?=
 =?utf-8?B?WFVXMmlrK2tpTHZ6NERRUEE3enVObnNURVIvVGM1MVhDLzFxMnh6RVVseHE1?=
 =?utf-8?B?RlFBcGM0bWdRUXFGS0FuaXV2M1U3eml4TjEreUx6cVY4L1NyYkxhU1gxWVZK?=
 =?utf-8?B?T0NlR1RUTWxSUWtuQWRpSHdHbHZpTDg4T0RwU0UzcVJGbkRlajZYaUZUMFNp?=
 =?utf-8?B?V3FOMUttSEpTOEZ6Qm5aNXk5WG5SRnpQSU9PNHRLdVFORW1PVWhyUWlVc2hz?=
 =?utf-8?B?MlIyVVY4cmJyODJnRkxGbnprMUp0VjNFMHFBZElyQkRBZmNwNWRpNnk0QVJp?=
 =?utf-8?B?U1JpS3BMYjVqcC8xN0VmOWMrZ3M3ZFJLWkdXQm1hRUFLWXArN1BOQmFQNmZk?=
 =?utf-8?B?cENIMFl1Y1ZqbTVYUlRLN0M0ZFlZb2ZwS01PZVBtWVUzaEZwSzFGM09vS25S?=
 =?utf-8?B?SnZqa2Uwd0xmaWhEMWRsNXlHOE1oTjQ1YlpjMnVZODJpdEhwdi83enA2Y3Fr?=
 =?utf-8?B?am12dTJBWkU2U0xBalRhOE11Y3M3K21Zc0YrZm5MRDJpdHV3MENCakF4d2ZK?=
 =?utf-8?B?RHRVeHIwOUk2eUw1ckY2ZThuUWFqYngzbDh5eGdZMVEyL3Jza0EwT0NBVTU5?=
 =?utf-8?B?TS9WRkVLYURMZjB5RlBkeVpuM2JkREQyL3VCTWhTOTZYYVdvNGE1UnNJOVRV?=
 =?utf-8?B?RTNGbk50TlhIek91MVJTalJLaDlVMHpYZ0lsOTA3eG83V0RUTVZiNEc5WXY1?=
 =?utf-8?B?Q21mN3RvbGRnV0FuQWw3UEN4Y2dobzZjYTlJOStvUmsvdjVnREJrOVI4MTZm?=
 =?utf-8?B?NXhTcTJjYTRZYU1KZUtzUVR0VlhFNHVGQmF1Qk1ISTNZUmV3eVAzclFjYkg2?=
 =?utf-8?B?dHNYMWkxVFIxL09VZGhkTS9TT0Jvck1Ka0h4TDJCUFhUVjdQQlA4a1lBUGQ3?=
 =?utf-8?B?eFdrQ1ZucUhmOVFLemdmREFVQ252NTBiY2wwNXhKT0wvRGtGdzNFd0FqVFNl?=
 =?utf-8?B?dWJDSytaV3E3K2VCTmVWTWp1VXEzZXN6YzdlOEZ1enhoanl3S2NVaWFGMEV0?=
 =?utf-8?B?RkdobXJxdDUvbFpaSDdQV0c0TXhBWXpsVzhCcmZDM09OZFNUdlJ6Lzc4NkRV?=
 =?utf-8?B?K2oxbUIxaFdVYWRPZDNrYnFMZzkyWEtIZDF6MUZwcDJtYm9TWFU2YjdDYVdj?=
 =?utf-8?B?SkJ3cmNva3lDaS9YMThYNSt4ZjBuOHdWUm1sSURZeHdUY2FrZUx0KzRRem5j?=
 =?utf-8?B?T0RmTDhhckhKVVBCRzhLeVZQK3VaaTU3UFBnSVlKVmpjNkU4bnFDWXVBSkVN?=
 =?utf-8?B?aTE1NVlkTEYzdUNzaHdvZDMxOWRjTW1LOFJNWGlUY1JQUzZKZnZXMmhJTzh4?=
 =?utf-8?B?U1REYWN0WDBUMGJCeE5EbkpaZks4MUZnQllHTzVmMXZnN3dodHpFempuVHRS?=
 =?utf-8?B?S3htQ0s4cFNtTVVZL1ZQcXB6OXZrK1JxZk8xYmxrYmpoUmVhVTRNMGpzTEhF?=
 =?utf-8?B?QlpjSFV6bkhFVkU3RjN4SWZCSEVYU0pHeUljZDNEL2w1V2R2Y2Z3aFhMMjBN?=
 =?utf-8?B?QVAvVXJXS2JSSWVTb2MveUpqTlNPeXVOeXJoSUpud1I0OFRnUDVBUmg3c3Ix?=
 =?utf-8?B?VUhCOVdWaFhyV25WeElINURkRUNPQnBUeVlsdlE4WWdvNFE2d3FkWTd5UUxK?=
 =?utf-8?B?ZDJEVFRIbXpjN2EzeEVZMUo2ZFFuUVJZWm5udmZKdSs0SmZsQWtDY0dFS1ps?=
 =?utf-8?Q?c6UrTKz7GqXlIhnIj5FSKN5ZN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0da1d534-35cf-4e7b-03db-08da6977c009
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 11:13:47.2375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zKZ2lh6dZ/k1P0lhlr8lTe4mYpzTriIkQhYL2zwbqCcVczBdDnRZF6FgGFQN6HlO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3965
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/07/2022 06:25, Jakub Kicinski wrote:
> On Sun, 17 Jul 2022 14:33:41 -0700 Saeed Mahameed wrote:
>> From: Gal Pressman <gal@nvidia.com>
>>
>> Add the rx_oversize_pkts_buffer counter to ethtool statistics.
>> This counter exposes the number of dropped received packets due to
>> length which arrived to RQ and exceed software buffer size allocated by
>> the device for incoming traffic. It might imply that the device MTU is
>> larger than the software buffers size.
> Is it counted towards any of the existing stats as well? It needs 
> to end up in struct rtnl_link_stats64::rx_length_errors somehow.

Probably makes sense to count it in rx_over_errors:
 *   The recommended interpretation for high speed interfaces is -
 *   number of packets dropped because they did not fit into buffers
 *   provided by the host, e.g. packets larger than MTU or next buffer
 *   in the ring was not available for a scatter transfer.

It doesn't fit the rx_length_errors (802.3) as these packets are not
dropped on the MAC.
Will change.

> On ethtool side - are you not counting this towards FrameTooLongErrors
> because it's not dropped in the MAC? Can we count it as RMON's
> oversize_pkts?

 etherStatsOversizePkts OBJECT-TYPE
     SYNTAX     Counter32
     UNITS      "Packets"
     MAX-ACCESS read-only
     STATUS     current
     DESCRIPTION
         "The total number of packets received that were
         longer than 1518 octets (excluding framing bits,
         but including FCS octets) and were otherwise
         well formed."
     ::= { etherStatsEntry 10 }

This counter isn't necessarily tied to 1518 bytes.

Thanks for the review, Jakub.
