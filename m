Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FCF569F2D
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 12:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbiGGKMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 06:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235293AbiGGKMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 06:12:34 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D6E4F66B;
        Thu,  7 Jul 2022 03:12:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQ8leRyTD93YZjrlY1kfC9ePsPkDZNN/R0m6VPtHOwAEfKkSO5OautXwc64OCnXmuPWDdG0euZBRxdTIIibNO8I5c1aXchxTiHJ7zxqPwJCbcLrZODUuMEOhywYcFYtKRuymNZ79/OdxrD5ZRUgOe7TzpzmO0wmuLNhkaOn4kindQ16G3W8vsjX39I/jlA3Ysw69mPMuEjH57NOU2eeTyoA23RDDh0m9EXDBBmjiCV5+lzfWf0Pyq2cec4yD5VBeO/75MyyA78+NNrBdC+oZzOQjjZiVFWozBDG4xRPgnKJ/82XYgU4C0uy4cF9WvcQllq6ND4XmXNGz1PRvgIAImw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EdBRVaJ1P4Y5qpiCTjJpHBLLY1ywVLwnNExqMEx+3V4=;
 b=oPGbmDeebVCPD3Qu5KZ8IGBx1/3jwJfaBRVABdZk0yRLbvVllAgAMdQtpBAaElKHopUA11WN8OQZSj/rC/P57Wmke64opItcNimreuSHPnzMzh7+WeJI+4b6BgYWgJc8JYrVqlfkA8YySw9Uk7f5Z1fHugaAVczD+Ck4W3Jt2oNGVaTMO7RIrr89qzKCxFZOEpshBOiNSkS83R6Z+2rXaLp8UBMZv4QTu8QWJL/TRrJw33wuRzk2ZU+P7K7p26S5C5QwWGt6GoP+bir1V+twOtzW8NMMT5SRVh43ZNE3iWMsX7UL1wy4gPyiFRGbosRXZDjs2c4gcc7tOrZt1vCHyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EdBRVaJ1P4Y5qpiCTjJpHBLLY1ywVLwnNExqMEx+3V4=;
 b=Ve2JOuqCYOLZM6gxouz1NB+kkN3ZXtSvk+oDBWPIw7/5i9DV57M9+Z64PoMlpcFL7ZT+LP9h+/u99l/2WViXNkouTPUGq7y4KYRX7e4AIJQD22jGbkCNxz+zfr5uV05kxTBmZEC05Fkyisr4TaLhvGiM6JRK0lAgqaqf/6MCrI9MchuIXA9KWsxLrjKat8mwhsKNTxeddrwVIq7Ps9fBZI3fvy9JsWr0I0Mu5GREoNL2EUVrqc2IyLUkTqY9lATzXe479spOndtGcWotJwsqyd5zpbKZxd1Ccmi9hoAErl9y6AX0TTvyTJrrd+OO2Qj11qmMAT3OKT2sh+Tau+SDEg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 MN2PR12MB4782.namprd12.prod.outlook.com (2603:10b6:208:a3::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.16; Thu, 7 Jul 2022 10:12:32 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::b148:f3bb:5247:a55d]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::b148:f3bb:5247:a55d%2]) with mapi id 15.20.5417.016; Thu, 7 Jul 2022
 10:12:31 +0000
Message-ID: <86a49e1c-6ed3-f8f4-6f83-0bb90dbc99bb@nvidia.com>
Date:   Thu, 7 Jul 2022 11:12:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] net: stmmac: dwc-qos: Disable split header for Tegra194
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
References: <20220706083913.13750-1-jonathanh@nvidia.com>
 <20220706191140.5a0f4337@kernel.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220706191140.5a0f4337@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0485.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::22) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7797a9d6-8553-47b5-73f8-08da60013457
X-MS-TrafficTypeDiagnostic: MN2PR12MB4782:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qzaPAeH9U30gW18SV5mrvdhiLKQdioT9DLGMnCI8FRDMjxAChJas5sd0i7p55Q3hyCkG88zeOz6HI53wpxeUlGxPK3SI/jVK12q0oEGNTlS7loNdiz6EjkeOnSmnltq9BE8R5ylTvyPdSyWOcnAvdw1GOEC7Qh4YlRcI/5FrT4oUZ3U9otVXyRwPYEPqpPFi0ZpDhE8sThANXKLxJCCFhmiVXEhiuX2s1CX+ZepTBE8Rq0FcwNNpfeAZ5gmwgzBg2ZlVcooXPOAC24l1qcK1MmJ2xbm2eNX+GBsjw6N8hYWzVIZHVL3Qyb72n56ujC5xD83dO+FCNVYADKpUbNYhHg84mhWrzejKqHKb5hEBxKKvzOq5CVgY/rbMJQmRyYlxX8qJbt/mUFs10eLpo9kEscETsqBz3T3qkISgFqFVbUdyW6VhFJUzHusgu3m4ofjXkGEQ97V+C1pjODO5TxHh31K5SELVw2DPTNE6H3+IGrlpdxvN/KdOvgykOrQQvE78A188sHKdnO8p+f6xsMNXcHUS4xyzursMVqMiLvo0UtB4Y2mrekIvafIx0BumNbRH0qeWc7tLUJBB1i3q60QYL1I9UDBEEmW4Py9VqeOEAHVwwVo9qJh/uKXZGMFm+XveZ9I18jZGUd5aUJAl2fLLa1wiOQYc7ENEn/9QaQT0FVCVMOnqkVf1tz3uPA/0RyMN3Qs9EbEBqiZdMHXFyvLX3YCgagXGsTRf3g2vSqxuWNwsa7dI1KKk9797O+wa25WJmO6I8lcHrCLD3NUGqbSsrC8BgZ4K8NRIzGjEz+YIxESf9sMZHZRbtlY0GSBtKqXjl7Q1ZV5ns6l4xPOtE+uDfCJtd4r77MGbtOubVjQjR7Zw/Kd/xp8qhHI4sdfiM9lFOwYU4KM4gRw5ukBekFVk8K88+MtGmbF3QxiSnNjy23Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(66946007)(26005)(316002)(66476007)(8676002)(4326008)(66556008)(5660300002)(6512007)(8936002)(31696002)(86362001)(2616005)(6486002)(966005)(6506007)(55236004)(53546011)(38100700002)(478600001)(6916009)(54906003)(41300700001)(6666004)(2906002)(36756003)(31686004)(7416002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VkJ1NHpuYVc3VmFwWm94a0RPY25kMENSWEFOWVNOblVXSHVmYklIVFo2M29l?=
 =?utf-8?B?Q2tzUUlWdkVCQUdtZzhIVm9uZHRpWWxhbDd1dXZlMHFoSEd1VTYrS00zTDBD?=
 =?utf-8?B?Qmk3ZXBtYWV2Vi95QmNFNmpyRlZuQUFQaXpBTElodm9zZ2s4RjBFb0graW9L?=
 =?utf-8?B?MkoxaEMyWkZtMnk5TXNoZ2tPTXR4azFDOXNob2h5RkVsUzk0dHRMR3Z3MytV?=
 =?utf-8?B?YjRlWE82dXlvNi9BSTRLdm03L2dEZHkwL2UzM3VWTjhsUUk5aVBIb1h0b3Mv?=
 =?utf-8?B?VFd1N3BQbU9Pc3lRTmpvUFpBKzRMZWNMZ2ZLYTViN3JOZFU5bjJxUENQQWp0?=
 =?utf-8?B?R2pZR3NoRzExMEVnRmkwaDY3eUlxaG9DZnlDMU0yWHBUSEhqV25xRWNwQVpZ?=
 =?utf-8?B?QzlnTk44MEhYWlEyOXdVNDNCVXNkb3l1SGpWbTNnNmpmR1VnTmhabFVCTjFS?=
 =?utf-8?B?Y0FtdGN6TTRUMFo4TEsydUdwZlNGNE5oOVNVN2RTcHpNOTF6ZHlwL3ZEekg4?=
 =?utf-8?B?aUx4eFI5S3NoSVFUa2hPYXZtUEgxRTJIOFM2b3pOQUFXQVBpWWZvNXYwc2c1?=
 =?utf-8?B?ZkwxUFZLVm9aUWU5VVZROElHUGEydmgwYzdnam5GZmluQUlOQ1hJNlBxRXZL?=
 =?utf-8?B?dHFvMWpaQUVoWjYxSiszMUplVEVwNW51OUtlSzhBUTE0d2l1UDdqS0FzZlpu?=
 =?utf-8?B?RU5CTzJ3NmsxbXFETWJrSzRpa3dDdW9KYitPRDIzUE9XUWNhSXdsdGk4eElq?=
 =?utf-8?B?OFRpOUp4c3lOb2JMV3A0eFI0RHhvVHRKdkZrVmtMSTRwcEcxUmdFeHI2Q2hq?=
 =?utf-8?B?VlpzVGZJNXdrR091Um5OaUlTM0ltZFlCYkcvai8zeHdpZ3pnOFJnZ21Rd01R?=
 =?utf-8?B?WUVxWmxqRHFmcGV6Wi9saDNFRTlGY1lKMjd2L0M4YUtVSFlCK1YzK1ExeW00?=
 =?utf-8?B?dHErY2I2TTRka3ZCcHZVODN0T2o3R1N2bXUrVm9IaERSazVLMnBsOHRoMTNQ?=
 =?utf-8?B?b2xrK2FFY0w2TUZud1VIQXBiRU5iUTBKM25HdFMxY0c2cFNMUDk1eW9WbmpQ?=
 =?utf-8?B?OUZsRm5TZURHRUFLdS9KTVdiTHh4cGt0eGJmeWZRcEtRdHJWM0xKTmNHOXVP?=
 =?utf-8?B?dnR0dHN4bFUvOWJsZXR3bzhwblFzOGZwK2x2dmhhN0t3M0NuajFQSVNhUHVH?=
 =?utf-8?B?Z013d2l0a005QjZDODUvSUpUbGdpbjJQTzR2NTFkMUtLMEhCcGE1aitVZU82?=
 =?utf-8?B?M1NibmxHM3BEcGNRbEtGT2hyaC9rRWUzYm8rQjFCdjR4UzVoSHZxUWV6T3Nq?=
 =?utf-8?B?NTBVUStRN1RLMTJ3K3crK3dCaXhZcDFIcW5CajRSUkVxQUN3akd0dk1oTGZy?=
 =?utf-8?B?VU5NLzE1ZGtQY1V5azFSdkVEWHI3dE42VUk5SFJtMWV3OEU4VEdlZGhCWHRK?=
 =?utf-8?B?WXJ2QVNvV2FBVW9LaE9GYzJUaEU2WGZiNGsxb1BpSzBmdGV5SmYxN0p6dUFZ?=
 =?utf-8?B?N3BBSEtTU1d6UUZuR3paVWdudGtQdFIrdXh2OEE1TTBDMWdheVZiOTZGb0xq?=
 =?utf-8?B?TUJHRU11bXhWa2pVU1duWm9VOFRTSnMrQmp6OE9Ebm9lQktMRk5uc1dWYzA5?=
 =?utf-8?B?N1ZMTkV1T081QmllbVpTazZXZ0hOSVFGalBLL05PeEtUeXpKdWcrbEc4eGRZ?=
 =?utf-8?B?VHpnOGlwYkJWMk5OQXhUM2xtQWRWMEFsWmd3ZlZCcEMxNlpMNXU1TU5UL1h2?=
 =?utf-8?B?MTE4ZC82Yk1iU2xiUGYwdWhuckM4bS9UcXpoOEJsZTJySkNSU2Y1YTZMMHVs?=
 =?utf-8?B?bW4wZ1FhUWdPdDQzN0REVUR6Qkx4U1RZdG5KUlBwWkN0OHJzRUZxN2VaYjU4?=
 =?utf-8?B?emxVaEtJbGlCOGVxandXQ3h4VmFyUjdycHMxdkE3d003SThKQkxydi8rWC9v?=
 =?utf-8?B?cVBsVWFWa1lXcFYzYkEraTROTG9TZ2xsaGNZQWRvdFl3Ukd3ckdncWxzNlFz?=
 =?utf-8?B?cEIrOVB4dnBTS2Q1RHlPN0RCSVVTYVpIQjNwOU1obHU5cC85K1NHa1N2eThE?=
 =?utf-8?B?VEV2RGp1d3ZTSkxjcUlQR0t4Y2hWdEFaU2ZpZWUwZGZlK1c2Nm4vWTYxR3NQ?=
 =?utf-8?B?RVdJbjgyMUQxRGtGYmorSG1TKzVDZlRtMFlpeFpnVHRoekdnVERDVFd3eTZS?=
 =?utf-8?B?TFE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7797a9d6-8553-47b5-73f8-08da60013457
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 10:12:31.8394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S3LkDWTSKsTzYEbQSJmcO2vC2prkXlnfQpcjbxtOxCSPsFvbMnSD0bAiJBXIaG3b8Ln+127ZPRjxVe2nRIO3Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4782
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 07/07/2022 03:11, Jakub Kicinski wrote:
> On Wed, 6 Jul 2022 09:39:13 +0100 Jon Hunter wrote:
>> There is a long-standing issue with the Synopsys DWC Ethernet driver
>> for Tegra194 where random system crashes have been observed [0]. The
>> problem occurs when the split header feature is enabled in the stmmac
>> driver. In the bad case, a larger than expected buffer length is
>> received and causes the calculation of the total buffer length to
>> overflow. This results in a very large buffer length that causes the
>> kernel to crash. Why this larger buffer length is received is not clear,
>> however, the feedback from the NVIDIA design team is that the split
>> header feature is not supported for Tegra194. Therefore, disable split
>> header support for Tegra194 to prevent these random crashes from
>> occurring.
>>
>> [0] https://lore.kernel.org/linux-tegra/b0b17697-f23e-8fa5-3757-604a86f3a095@nvidia.com/
>>
>> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> 
> Fixes: 67afd6d1cfdf ("net: stmmac: Add Split Header support and enable it in XGMAC cores")
> 
> correct?


Yes that is correct. I forgot to add. Let me know if you want me to send 
a V2.

Thanks
Jon

-- 
nvpublic
