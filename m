Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8907460C9F6
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbiJYKZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiJYKZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:25:15 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2080.outbound.protection.outlook.com [40.107.100.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523A41870A9
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:22:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XNL7YaF/0lj4J1I+wBpUHZo0H8gmSytK6QTI77N0yNfIwM1tfalSXuqqfobkeZpwzeQFJwmvK1h+K2t0Gg+YMbSRGLYq2A2HUqQRPC1VUzqg2Aq1LNLz8anUMPHjmsJMBfk4Rm9+SQyPsRy8v+PN9wreNX5VftgeMLvZ8gDt7XTXYlWQlr4AcF5tXLnbcCpXf2d9z+v9+ZS53FVWfJfuBK0Pr3E765Ho5l9EherD34wxeIYWCgLC9Hx0hkBnis3Uo6ysFqwbdxvQpm1bfO4oj++9r6huCIQNT6Jfgr9ayFKQr3Elmbt4NbEMFxb9ZlX+kXHZGH0u6/6gisVwivSawQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ah6axzN6nqKeQOUuDZ4rwgLS/6HcaqE56UV4r0YMmtQ=;
 b=FScWrsfJVsgPvkOaOLvawR1DyK2R5pBB7/gXIZL8ZM/EPdZ8h8gPuFpT9ZvtZj+mRLEvBUMLxWUcWk20d+tj1jDTeuvboQ9sRm8H2TTaHnvLQuLC45bTHlymMxzB2135hSZiCw5L1hi+6wkImcXvLLVujdmcVXvW/XZFwMnPw7LmSbS8sDYUme+Cpf8fw7qTmWMHa8BobWA9A1t75CS3/NsYZBCOqciFmcd9xi0QnRcZUksWDSiAm4cCnjXRTJkpjRE1ps1Oy8pX04lwSJAoNDHJ0GIU1aOKCUPVNwRcmUTig5QZ3uflT9kyhnDMIsOpD2zxnPKwt65vO6NY3MaQxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ah6axzN6nqKeQOUuDZ4rwgLS/6HcaqE56UV4r0YMmtQ=;
 b=jCmMbVqGDcQAdnFsvdTLt+DbGa4Y9aruoLXzc5EGdxrxuBsusBiYe6fsSj1r5wZdnXrP0DORbWw3OSXY47qEvoIZNSb2byWs3ZFwckV5XWuz3ae9ccRQm6YcNNMJQkYL/HTV8NVsPEO/WhFUvmz++QeSJcyG/AqINSLm1dG0PuUqEncHVWGWH9Kp6Ri1Xg2t6hbZw/xctE86Khmju9w5ffVxvFY8ebmc7+ehE/YAF9QLJBrCe/3V+IO2TPDMmemuKu9PK22mZZvIPMFSd0KpIpmbL7wjhWMHfsJNErP5lSzFBWhPwhqDHXVrBZzdCO8/gesiQxpZWwT6LeNczUOO8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW2PR12MB2489.namprd12.prod.outlook.com (2603:10b6:907:d::25)
 by DM6PR12MB4941.namprd12.prod.outlook.com (2603:10b6:5:1b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 10:22:46 +0000
Received: from MW2PR12MB2489.namprd12.prod.outlook.com
 ([fe80::6858:e771:28fd:9625]) by MW2PR12MB2489.namprd12.prod.outlook.com
 ([fe80::6858:e771:28fd:9625%4]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 10:22:46 +0000
Message-ID: <057132d5-41fb-b966-3dbd-4b7dce59b305@nvidia.com>
Date:   Tue, 25 Oct 2022 13:22:38 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [net-next 05/14] net/mlx5: DR, Allocate ste_arr on stack instead
 of dynamically
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
References: <20221024135734.69673-1-saeed@kernel.org>
 <20221024135734.69673-6-saeed@kernel.org>
 <20221024212419.003b3056@kernel.org>
From:   Yevgeny Kliteynik <kliteyn@nvidia.com>
In-Reply-To: <20221024212419.003b3056@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0044.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::7) To MW2PR12MB2489.namprd12.prod.outlook.com
 (2603:10b6:907:d::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2PR12MB2489:EE_|DM6PR12MB4941:EE_
X-MS-Office365-Filtering-Correlation-Id: 0eb60424-cea1-4400-db1c-08dab672dc21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zZ+fwKtPlJJkofrozAyCyuWFReEcZ8LEQd/YSTmJFfpLvjfAKvRtWOVlzWMu6rhREaeMDdJQgDYkAnzmaTATzZKCUT9aAHp1BWyTw33MidOQE6F95AedBVIqimCNtXR75Vfd+LAZYojiYsfbgFJ598RSRt+XRAsbziLPXUzDDGgRYz2w6j4KcpXNAMZJtZVbkpbxrBLZhmytnpgV2hTCV+mBxZl0O+wI59/n2QJuIYxnit6bEUu40uK/Ib90DE8mck3j8pEA2Bvfrs9hUVY872eY3pqKVOUqwG8CVrci69721yf+vEF//4cit7N5ycevo70BMjuE5ETszb/3RNFGn1q/aQtzr7HejW85hz1FsXXDcpHq6q9R2FNonK3AXrLlZimdzkuxh3koNr2HGoxxu/QeeRGX3MhzP81mzT9o4B8HypUdx+k1fR4yQ5euyv7tC4jkEr5gfmzVUi5sKChEZZCPE8UGGm86ZaQUUW0zq3aZmPqVMK+GoxrX3PDVZAZn1eZxnwZmDC12AFDfxL4sRR3+HKp6eeeaWXOTA5lrOjmTPL025eZbaGngXDIH4+6dTTYEGfCPmzDMd0RNtkrlAJOeM/CBJueRxgRqk7j9HOiMHLbtBTs0T10HnmdY92beS9qenXgdArJzg1diXh92GjZSKPEysQeJxQ3zDxK4u/WeA4wYOAI59h/YwEIxNlbgZPKVHHmZSIHXB965k520P2ukMHNAL9hzpuzWN7jUiDP20vbMuatsdbThXq1+a1OytTpAQJQChVPs6R0xrtML/ZnzfABfudvGKDyH76DOr3c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB2489.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(376002)(366004)(346002)(451199015)(6666004)(41300700001)(107886003)(53546011)(6506007)(110136005)(38100700002)(36756003)(5660300002)(54906003)(316002)(8936002)(31696002)(478600001)(8676002)(66476007)(6486002)(66556008)(4744005)(4326008)(66946007)(86362001)(31686004)(83380400001)(2616005)(6512007)(2906002)(26005)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eEV3MEU1N1l2WWlxbTYwcHZNVXpOeVFodzVEemVBS2gyejh3Y2hON1NVUnRK?=
 =?utf-8?B?QnRNdHR4Y2R3TlQ1Z3p0YXNldzBDVTBoQ3Zmb1NJRTlvTVJpNlNWdGY5MGdy?=
 =?utf-8?B?N0pBcndyenZodVMxUXpOdm5aTm5FWDAzMWVSUXByK3ZvUThWcFBLdlhQc3lF?=
 =?utf-8?B?REI4b3VGNHpTdmpTRy9ybUFzYW9wbEowZUhkL0gwOEk3bGZNK3BtOFV0azJn?=
 =?utf-8?B?OUJCU1Zzd2lwYmFWc2dHVlBnV1NlSCtUemtkZWp2RDRHMk9XSDBoT2lOcEla?=
 =?utf-8?B?NzZSS2RxQ2pIbk1oVTdyalV6TzA4RWZhNEN6bUZMdVczKzMvQzQ4V1crdEh0?=
 =?utf-8?B?NFhWaXVCR091UDIvVzEyUHNzeXUxUmZ1QlBZQk9RZ2ZXT0F2UXlnVFk0TE9q?=
 =?utf-8?B?SllmVjMxUFQyU2RrOFpHbVJyU1JIeDExR0xFM0YrbUgxT3M4RGVxZHlwQkwr?=
 =?utf-8?B?S3pBQmtkeWlkdTZGOXozWFB5aFczYVh3RXR3M285YUozeTRKeGVJdFhWTENz?=
 =?utf-8?B?TTkwNXpjNjE5WkRlRTRNYllZK1M3ZUpWWmNxODlDYmRSeWd4b1ZMUVJDUmU4?=
 =?utf-8?B?M3dVNjF5dmJNeXB1MnFXZUFnS0FEZS9VTHFxbVduRnZFdVpLT0FzMXduanpX?=
 =?utf-8?B?OVVLSUNXQkQxUUdJaGNFL2lUdW5PazJQZWNFeTNjLzFvTHpLZU5FWjBuV29E?=
 =?utf-8?B?NDM0Ym5BZ2RDUUF0K3J5SXpEaXU3amViZHd3anFlUyt1TjB1Sm5wR2gzczZt?=
 =?utf-8?B?Si9EWnRQclhoa0h5Nk9ZUys0VzhnWVpQdFdSTkQzVzg5Mjg1a2ZuZXhoNks3?=
 =?utf-8?B?dEJFZThZSnIzV0gyNVdwS0VYaDNNYTdmMmJhZFBraXdEUWNEUEZzMmJ1TFJs?=
 =?utf-8?B?REt5ejNVaXlySzdvaWFqamtaeng5d3VJWHNURjlRRTBpN0tiZXF0RDZ2MWY5?=
 =?utf-8?B?b3Z1WmJSWGQvdGFoeEV6YmpjUXE5aUdyNHdMMnRxU1ZqS0k0ZVZxQVFTemsx?=
 =?utf-8?B?eGxVcE5QeS82YVVhdC9kdno0NERrcmNCbDltOSs2U3lpMlQyVlJTc0FjOVBz?=
 =?utf-8?B?c2cyWkN6QlhPdVdjK1hiK0FMM21mbWdmNk9ZRjU3VHVrZmp6cHhJcm9oalls?=
 =?utf-8?B?bTF1RXNXSGJRak5WQkJDWHkzTmJjM3ZuZk9RckVxR2NZS3IyY05QUmlKVFVN?=
 =?utf-8?B?UUpJdktscm9sR3R3L0ZMSDVFS25tWVdoSWY1VkV0UzZPWVN0eUNrMGVDYUdJ?=
 =?utf-8?B?d3JOdnlHdTZ4Snc1b1RsMDhzMHhsRlVwR0Z5RzE0VVZ4OHQ0Z003bU45V3Y4?=
 =?utf-8?B?ZXU1T3Zoa3A1clNZaVlUc25Fc3hjUkhLOWxTS1FZb1hVOXQwVVJJWTFQc1RC?=
 =?utf-8?B?QUQvYzBVMEhreDYxWEpPdVM5dWxZWVA3cHJNcFE5RVZFaytGbnYrRG00N2VS?=
 =?utf-8?B?OWtkanZkY1BEV2taUUdJR0pCcVovUVlwYlFFRHlNcStEYTZpRHRQcjhzT2w1?=
 =?utf-8?B?QzlsaytMa2VrdEp0Z3BOa1l6MWcyT3k4bWhBeTZ2N0RmTTlBWG8rdVFMY1A4?=
 =?utf-8?B?YzJmdUVZaGwraTBHdnFWSjBvTTZHRUVUVTI4S2QvSUZjT3JPcFo3UjZjb05t?=
 =?utf-8?B?VTEwZnFWanRrbzRpNHRncmZuSG9pUHJNWVNTaGpSLy9nNGh0dFFpZ3hXbVZB?=
 =?utf-8?B?NnI2VjJ4MFg5a09RWncyckcySXY0ZFZtVGZJdklvcTlTRkljUldTZkRJRnYr?=
 =?utf-8?B?SWNzOTVORHpRSU1vZzkwZkVoTCtYU1kwdHJSRGEySW03Z1dtVFkzN1pZbkFw?=
 =?utf-8?B?TDVtVzlJdHlOSUR5eTFYWWlSb0dwNXZCZ0gyL3ZSSFRQT0E3QjdnSnhXSmx5?=
 =?utf-8?B?NmdnZkU1Qm95N3FON3hxL2hXVjAyajZTeENqNVVUbGhkakxuamJpNWR6WDVt?=
 =?utf-8?B?eW5VVEZ1TDFtRzNjQ2VPVE1wbmwyMkVNd2dRNjIyek91cXo1bm03RUJvcVZF?=
 =?utf-8?B?TDVzU2ZkY1c4UnY1S2trcG1Lb0xGYzBRNld4bFZXL3BTQUIvMW5kRDdUUnhT?=
 =?utf-8?B?YXJpcUh4bzhMRXhvaTZYNmpCbU1tTFVyWmJyUkhlUEdQV3Rua3hrdVhtK3NT?=
 =?utf-8?Q?elqucOvzc9nA/0wolCU1kIFai?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eb60424-cea1-4400-db1c-08dab672dc21
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB2489.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 10:22:46.4892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vCjyd5hGkmEthaC6JPAITxHsV7adlHHpTpWgjUDFFMZSYgHp2f49aAavuGG0CKPvIYnbIcBTI6y6Q8R6wi7nkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4941
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25-Oct-22 07:24, Jakub Kicinski wrote:
> On Mon, 24 Oct 2022 14:57:25 +0100 Saeed Mahameed wrote:
>> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
>>
>> While creting rule, ste_arr is a short array that is allocated in
>> the beginning of the function and freed at the end.
>> To avoid memory allocation "hiccups" that sometimes take up to 10ms,
>> allocate it on stack.
> 
> There's a reason, 32bit x86 does not like this:
> 
> drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c: In function ‘dr_rule_create_rule_nic’:
> drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c:1202:1: warning: the frame size of 1568 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> 1202 | }
>       | ^

Thanks Jakub, indeed...
Working on v2.

-- YK
