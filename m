Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F85866B03E
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 11:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjAOKFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 05:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjAOKFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 05:05:11 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8513BC172
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 02:05:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXvX88KJu4N/VqU+nRSVwj7IexhlF+OLLNtnp+KTfEXNIAojWqva41vl8BC4YMUPJOIIxlXgL3ytqYGO+Q5l8SWijkyMzptW9xsS5EuIjsly7FCJFi4N2NApbWR3K99pNSc7g+GccXBF8KFUr25RXLRz93z9lSNOJM/yiNM2guoh1tu5JiDiha9O/mzVFxrk6lapcU1giCxTOfVwwEZuFRZD4t8ZEcK40Wl8WwdYU3TrKSh4V8beRrAub2nx9cbLOniBGSy9IeV7Q8lTOW2ZmL3LzGDq493J8h4zgoaPWI4OYQp0uLjZfrGt5qUhp317TUYyWYcTOXFR/snMKAz9mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QFyu4aXMhWv9rE0S7va8Ti2xmoVyTRSsH5UaawkF16c=;
 b=B5xzpRth3jFaCiBnnOybjhVXQ2zqU/wJu+BVeas1kaO4wn4enlS2b+cuKBIBQIxrUmq/P51hD7UST1N/46a8TUwiK5pgw6U1VWNop5hAKHiDJ9zXJ8+Y4evIkNa7UNv9r2FHZf8/2DETam8n8+lpKjErBh3IBFA92Gi3VTMDn3ZkG4rv1PThQGNPSls4ZW1wx8bQ+8J4q7NPPRb3SzFhD0r2I0aG+hoORQ1I6b2PKdGlVh8cHEHQPw3SmWXx3N7GaCdsApGBv7NHs8whT+qcwHq0iQnzHJ/ky5mJM7JMF0uIAioGiCA+mAbD+hdXLS5LwHrrhqtKbVVi4yxOrEgkNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFyu4aXMhWv9rE0S7va8Ti2xmoVyTRSsH5UaawkF16c=;
 b=GhN3rYLTiIE+oswUo2wVWTnS3PeS91ngCQnTjq2ryS7oMpTMuSjaLGaQzw1mPzBKAOpECr1JwSs/whAPnbcCr8aouAqawZxuigRtTeLfRgNXSAoUtgWbNEAXfucD0OGRKLeRisx5cOvCKTjEWg3TWM9bsaPVnrM89/jxrPKzz7NkrMhgDcfrl9MJNvq0r5w25aZeQSiBSuZw7zIRn5BGc95WFXGMxvA7Ljk+cwRk6pM3ChIC+Mj8/6pLhSVRVEMIQ3FzZwSVoGibFWihYUBc1i4BEUJSXvPuaVk57bHLHGit6GpgwFfphs9Uu26TMJrd2RTplVSfXAdDoxLYbEFyBQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 PH7PR12MB7020.namprd12.prod.outlook.com (2603:10b6:510:1ba::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Sun, 15 Jan
 2023 10:05:06 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9%3]) with mapi id 15.20.6002.013; Sun, 15 Jan 2023
 10:05:06 +0000
Message-ID: <ac5bf8cd-c30a-0c36-a6ca-a95a8ed0d152@nvidia.com>
Date:   Sun, 15 Jan 2023 12:04:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 08/15] net/mlx5e: Add hairpin debugfs files
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230111053045.413133-1-saeed@kernel.org>
 <20230111053045.413133-9-saeed@kernel.org>
 <20230111103422.102265b3@kernel.org> <Y78gEBXP9BuMq09O@x130>
 <20230111130342.6cef77d7@kernel.org> <Y78/y0cBQ9rmk8ge@x130>
 <20230111194608.7f15b9a1@kernel.org>
 <f10e0fa9-4168-87e5-ddf7-e05318da6780@nvidia.com>
 <20230112142049.211d897b@kernel.org>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20230112142049.211d897b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0013.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::18) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|PH7PR12MB7020:EE_
X-MS-Office365-Filtering-Correlation-Id: ccd29c20-16e6-4bf5-917d-08daf6dff9ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hgKn1tVnG2heucXASl+q4qnCSJoiiI6gfdjV4v9O8Vx7Epm9cpTGDGgug+FBhp9Pg10tbpqHFiLDEOrPHJFez6Wn8qTtzjX77GKJzOZapvhrj4+7Uyy4umqQx87KtTOQL9ISqy7F3FbiIgHaNl22sYTd5Cimlr8aktwKUGCGsGGZ1ScjnO/AQWotq5kxGJUqHqC5BLORPufB89pVErE11XmvWJtsZ/CLFVwcaU8DOqCHaUmKsbfIBWGlwqUdr4CwgWD3kYbb2ljstsyOwKcvzaa/3Y1aGlfY1Jo+Ewit0taKzzUusntnQMC5O4McPfHVE5xiZzRaJ9FfwULmJbkoemoQW74v24vjTs7nH/v9MEyplRdTeVAC++42iE1uGqMz0ldC1BnFk4cdB0/iz55AvLEUDnJ1FoNi1gZpISASp2AgDvrSL4XnT9ICPrYGlDtFjzk50ew+WXOSRcaQFbn1SkykEnaWvTpLT2yBW5b8Etk1SfoH8Rv3fI3GA9ylzyjaWmZg7Rq3Avc9TlJbWrUJOikQcePF0zmtIem70ff/Mw1+Mc7iyMgn5xbVM9WaKXT8Bsa+Pr4G/2Wm4KgwIpfqiaZjO+i/D/E+MMLRJeOTlDF4hwolodziqxlGxiaQt/OS/BazC5DxrHmF1jp9cslE8vWDuXOBlnu2md1VlxQTgdTXNabJBh8psgX5OTsiLGkfZ90Lv9b0cEMU/AgztojMQGUWfPbMzTJeAfkfuMWQr3Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199015)(53546011)(26005)(6666004)(6916009)(36756003)(8936002)(107886003)(31686004)(6506007)(6512007)(2616005)(6486002)(316002)(478600001)(66476007)(66556008)(66946007)(5660300002)(186003)(4326008)(31696002)(41300700001)(38100700002)(8676002)(86362001)(54906003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3FteE4xVFg1akRuU0ZZY2xQLzQwWE5YYVgrNzkwYjUzVjBqV3RZZXR6Z3Q5?=
 =?utf-8?B?c3kwUnViUWNIRnhIbTBPMmJZSUhxMmx2SW5BMVBFTDZHTWtWZnp0ZTM2dnlP?=
 =?utf-8?B?WUxjRm4yVkVuOHZ5cU5CaThvSy9NUTZ1QVJTaWQ0aGJpeE9CSGhhbUx5My9n?=
 =?utf-8?B?MHQrcW5GOVBtWk9aUVBvNlFONTA3WGdDdGdFQWl2T0lKVldEekpaQ1ErUDRL?=
 =?utf-8?B?eVhrOFY2TzVJbVJFUVVUTU44UlcrQTE3S1RDMzVHY3NwOURVZ01hYWh3eUE0?=
 =?utf-8?B?ZzBsR2Y4S01ybmF2aFozOTJOSS9wNnlJVEg5eFJvVkNBQmlVR2U4UVJPZ1RX?=
 =?utf-8?B?QzgyT1VIUEFrZ2pHaWtYMnBuYXJmdkpkRXgzQjVIZVdSOFRsSEVHYlU5SW5F?=
 =?utf-8?B?RWtEL3IrWkFUaDh5S3JxMzlCR0ZjT2E3SkJtU1Q4SytFNGRWa2xmdC9VaFBn?=
 =?utf-8?B?S2t0amZ5NUNTdGUzVi9hWVZ4Z1pMeDNiMlNPNWEzVGdKN05QR3ZHMkNIMXpS?=
 =?utf-8?B?R0ZjQ01CZm5yVTllWFd2WjlqRDZoanhDaElCcGpLME1iRWNUQ1hDOENDM0FZ?=
 =?utf-8?B?ZUt4Mmh0UUdIRUZkdE5sOFZrMFFXTnRxQlhtb0Rva2F1Y0tyTm8reXgyKzQy?=
 =?utf-8?B?RHAxT1BySnhUQ0R0ZUgzWk9WTFV6TmlOeUZVcEhsV2ZGamh2T0RMNEg1cWJj?=
 =?utf-8?B?NHRBcEVDcTRSTnpFWlZkbnNkSEVaWER3QUplNW9KeDA1TzhXSkJSUkwySUJo?=
 =?utf-8?B?WEs3Snp2L3B1NTVNMlZ5bk5MR011WkwwbVBSNkNwN1pjV0lscytOdHJVVHp5?=
 =?utf-8?B?RU9ZUjBmV29LenRhcnN6TGNKTTFVMVpGSUFLL3g4Ni9nMVFNdGp2cGZ3dmdm?=
 =?utf-8?B?Z0xFdUdXcGkrRmlLVXorVURxYUZHNVhEbGVYWWI3R3R5eWw0a0VJTll4ZUQ0?=
 =?utf-8?B?Rmt5ZnN1Slh4WmYvNGhWcTFjb2FLb1A5eEVUYkY4MU80ZytEbzJLcmFZVVpJ?=
 =?utf-8?B?OEVLK05VR0RGOEdiYXhzTlNrM3NrbUVNQkJ2ZWVlRVFjUjk5YTBUSVZMb3M4?=
 =?utf-8?B?aDZuNjNFa08vYVo1N2VhYkNaVHRveTg4Q25hc2lkNG02ZjRkMm02eGtaaXlR?=
 =?utf-8?B?dDNrdWV0YmlzWUNZZy80K0FYRkRMc011Rzc1dk9PVzRMaHBKTisvRjBJQy9L?=
 =?utf-8?B?L010TXU1dnNTRTVGbE5GbFhVbzZGblB5Z3k2MG01dC9ZS0tDblRTVFNrRnRV?=
 =?utf-8?B?T1BQSUJSc2NNMUlOeFFGN1d1VGVlMzBQd05rT3lhWENZdDEzQ0tqUVh6RUVj?=
 =?utf-8?B?YjVEbEg3WlBCNTF5THNvWXY3L1FCL1g4czByaHUxL2JpUkxoNThJSzNPZnBj?=
 =?utf-8?B?SUxoWTZTY1p4TEtJa0FjaWVGelZ0MzJlVmFKZ09hMEJhUXE2RzB0OUExbHh2?=
 =?utf-8?B?aE1UQUloWFErKzJNakt5WTBYRzFYOEw3ZitreEdhSWJaNkdOMDFzL2NWSnBZ?=
 =?utf-8?B?RVFROGtJRHhkUjFPSVZLd20vWjZ2cVFxK2VhVE1UbFZMYjJEUEs2dDZoVk9K?=
 =?utf-8?B?S0pMWmZiSUFETlFHekw0dGVFeUZ2d0RyaGtLRnpDS0ltbDVseWk0UUNSc0Zj?=
 =?utf-8?B?QlhvN2w4OGd1b1YrRnhFOWwwcENLRDA5dmZoSDIxR3FvQ3ZtNE5wL1Q1Sm5J?=
 =?utf-8?B?b2pxb2VrRHpCUUxTRExVcVhGVXA4STZrK0dQS1BHZTIvS3hIU29iOU9FejUr?=
 =?utf-8?B?UG5qWGR2d1RtSEVBM1Y1SUdNMm81d0xjUm5oZHkxa0IrNjFSZm9aZ3ZaVUVI?=
 =?utf-8?B?Qk1ONW8ySURoMkc3RStEcS9qWGE0VDJFa3lPaXM1ZG91WmtGclA4cFZJdUI5?=
 =?utf-8?B?RmFESGFWdVBYS2c5QU9qUG5XbDNEM25FWVpYWjVkTDd0ZTg0dnpieEttSTg5?=
 =?utf-8?B?ZWk3YXJxSlU5TEpVYTh2Y2JydCtTdnBVMmtSS2MwR2VibnRIZ1RwSUtuU0VX?=
 =?utf-8?B?bXhkMkNkRzkyOGFFbjJUaWVHZXorZEJDUCt6cHRBS0FEbi9XdDA3STIzUEZ4?=
 =?utf-8?B?NGttalBvL0pUZ3pNb2xzSHNiM2xiWXpzWGo5WVdHaDQxVGg4T0ZNMXZNSkxZ?=
 =?utf-8?Q?ASgU9FcLz8ls3W3uASS1yWBWl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccd29c20-16e6-4bf5-917d-08daf6dff9ee
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2023 10:05:05.9848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EhfEQcTXEpznzChJ6nNlaWmMedvmNaF2cNnnf7TiNQiRPzYq+XnX76KNRq/aUod+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7020
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/01/2023 0:20, Jakub Kicinski wrote:
> On Thu, 12 Jan 2023 11:17:07 +0200 Gal Pressman wrote:
>> As Saeed said, we discussed different APIs for this, debugfs seemed like
>> the best fit as we don't want users to change the queues parameters for
>> production purposes. Debugfs makes it clear that these params aren't for
>> your ordinary use, and allows us to be more flexible over time if needed
>> (we don't necessarily have to keep these files there forever, if our
>> hardware implementation changes for example).
> 
> You cut off the original question in your reply, it was:
> 
>   Can you expand on the use of this params when debugging?
> 
> IOW why do you need to change this configuration during debug.

The hairpin queues are different than other queues in the driver as they
are controlled by the device (refill, completion handling, etc.).
Hardware configuration can make a difference in performance when working
with hairpin, things that wouldn't necessarily affect regular queues the
driver uses. The debugging process is also more difficult as the driver
has little control/visibility over these.

At the end of the day, the debug process *is* going to be playing with
the queue size/number, this allows us to potentially find a number that
releases the bottleneck and see how it affects other stages in the pipe.
Since these cases are unlikely to happen, and changing of these
parameters can affect the device in other ways, we don't want people to
just increase them when they encounter performance issues, especially
not in production environments.

Does that make sense?
