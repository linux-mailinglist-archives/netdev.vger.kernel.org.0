Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63A086BC664
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 07:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjCPG5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 02:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjCPG5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 02:57:44 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C3DA5697;
        Wed, 15 Mar 2023 23:57:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3DCwYU/45sOefQKsmOq/7Hs3ragFNg9JnXRv+WqV9MqSxykFJUpxfuNuN3j3OqJTtmEphrHI/7OiGOZGpR/Hg//AhBvsNf95rnkZNYD3XGlveNZtsDABe+rh9/fClKCeXyJ+jm1P/spRlp/eaYgkvhbxhV3h0UnVw096wv1faIb9po7klzSHxMRmMJxJhhFV56H7p/XxIAOW13D3CJblD5sgI9DGk6oDOV85t1oSnrgB/6HkggKokBo8Sis3JMx6iYhDub2Pt8zVglXtHkGa1beCFh44hwakEwsyq1ulGKJeQQRVrmdQwTLoQemAdLQpNP8giFjNmnuXLUbEZGTbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XRpvFC7R383CYtgpbYWWGET4NWQGH1tdoije+HFkujg=;
 b=Yq+HxKt0klhg/MvX1KVqMNckKJKX5csBHzFSdEYIjaF1Eq145xmBjbkzqWNeaMb4HY91FXYMubxNcdbro595vzIpaDGrC2CrKfMy09kpZmSiCBdefwm2ANVyNEKgGg64uu7RlXOXPIiha2PrkdW2xVcxQdOoHP+m8fdccCcFJHJMGICgx0lBwkibwARTPNVk4BPj1NoEHkJiM1PFDifc+CjjM3WvIiF5SMbULE+PhnVotSILEwG0g+fd3BPrW76fFkwS1/Vy/L2DMyEVWkKI+dN3TJCTW8VFr3CxCBj5F0U+YbXyEuw3mpv98H5kHbfEykUoUA10l2VxjV4yPEgk7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRpvFC7R383CYtgpbYWWGET4NWQGH1tdoije+HFkujg=;
 b=MHqCIlMDt0V/4CsUvm5Ji9dMw1gM+f2gSl9Xim1ZxMUedY301d7+XGqaq38/P2tfLVqjMu6N84kb50KxeCqpaae1UP6AdaLxiohJWjxxnK78kDUXTru2XZlmFiMfDZP+uKqNlM13bk2BZBRYZm2pUrlpXrCVlUkbNAVbONobMVGjhfKn7GyrjdDYzSZ9LnMSXP/jKzd/2thmSFQ6rvNdlmIysH4xGlgsgoQ+dlQSQPWIolB4QCM2gzpBaVaDyPmFsQSqR+lmhJ2V86CNyDDnw7BCJtRBthDB/qs9TEh198LotJCH2iUjOKhMY9OFZymbQDu4cT+klBETf5ikWQN1yQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by IA1PR12MB7493.namprd12.prod.outlook.com (2603:10b6:208:41b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 06:57:40 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::8fe9:8ea2:52f4:9978]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::8fe9:8ea2:52f4:9978%7]) with mapi id 15.20.6178.026; Thu, 16 Mar 2023
 06:57:40 +0000
Message-ID: <b68c6baa-62ec-901a-76f9-0baef7daa3f5@nvidia.com>
Date:   Thu, 16 Mar 2023 14:57:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v7 5/5] net/mlx5e: TC, Add support for VxLAN GBP
 encap/decap flows offload
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        roopa@nvidia.com, eng.alaamohamedsoliman.am@gmail.com,
        bigeasy@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gavi@nvidia.com, roid@nvidia.com,
        maord@nvidia.com, saeedm@nvidia.com
References: <20230313075107.376898-1-gavinl@nvidia.com>
 <20230313075107.376898-6-gavinl@nvidia.com>
 <20230315003244.52bb841d@kernel.org>
Content-Language: en-US
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <20230315003244.52bb841d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:4:196::20) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3835:EE_|IA1PR12MB7493:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f65a28c-1e6f-4e2a-5abc-08db25ebbb61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GiTvEc/SL/I0POZVZCd/mbv8JgwuTrVceEy5YaxGUwfXT6iEPrBHGu7O1V2ZOBLG5LmopIOirf6DTcpGirsLHzcks+dDI2ihKTTPFXyIMvTfuXiNAFTl11c/pVmEkzj3YYtfMVxrV/6DYQSy5NMgvNW++X8QOOYvuIB0+E9P2O/0jx3LdxeqCJq2nsWeDCHTtaoBG2qlGiMekx51mf8P5IW94p/jGhZmNSIzgm/pB6rDY6s6nVtuz4/WnXUEKL5cxyZSHR/EuQ6j8j9bvFJDn3URyIf583YBFH2d1uD1KJqmRc11UkyD5iqIpSSmPl0sq/m4UpaJICiHn1+D3gd0fMjbMYAaDT4VzREVjXu6iJI9lLAjzzSDy/QswUd3A6q06cRkDykVSojATM4Y6/ocN3Eww2pHHI1FY6YYINlA9Y84ReX8RLwZKUdUUzTH0qeuWfzVM2aWdGeRBY/DMgkYXppNQHIpVJ0ePxbaxNjY5xxYYwmes7oWRClXn5A4vlVMiz/U96oKihkVzZ0U+4vh/Jp//p7q6Xyg0iB9Gvz5rTxGD0iIfsnZw1xKk9xFEh/1k6t5GM4M4Ft5iLiJ3jIcS62wbO4cGqgl6lEY2ba2E1swsiUjhUEc3K/Mh0uta0PO1sBQRm9HeVN4xlmmxelIOCG1xvsWeEkjat/ARBX1oY9oAr39abytAd3YJEIr7Q4AZzt+eXTC8NzXu/It31AQWOsECBnXNu3sI1/XD0KTQsM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(396003)(39860400002)(376002)(366004)(451199018)(31686004)(36756003)(41300700001)(5660300002)(8936002)(2906002)(31696002)(38100700002)(86362001)(478600001)(6486002)(66556008)(66476007)(6916009)(8676002)(66946007)(4326008)(6666004)(107886003)(2616005)(316002)(186003)(6512007)(6506007)(26005)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SldiOUk5ODZ5Ukd2VlpPSVVaZEFaWGpXS09qYlVBZ0Fzem8xSTVhL3RVODFU?=
 =?utf-8?B?WERTQnJObnRkeDNRaE4yQjFnV3YwV3dnVlBPcERUdDBXNGNXd1lOd2k4UWx5?=
 =?utf-8?B?bXJoRUFmMDI3RC9LRG1tR01nejBtNS9TWGZzNlRvRENWWHIyMGVpTDZNUXc5?=
 =?utf-8?B?YXIwMjd2TjJhUC9McUl0VmxsNjQ5UEkxQkIvQXRQYjVualdKYW1XNVFIbExD?=
 =?utf-8?B?aVYrSytqM0V5cmJBZlVrMEgrbXNaZmI5eDBWMEZXaSsrK2toS3pXU3JFR0tv?=
 =?utf-8?B?a1I1TXB3U1hMVC81YlVHSXErSFg5UGd3SzRVRVJsR1NhWjNHakZ1TDJrTDYv?=
 =?utf-8?B?TDE4V1czdytBa0tjNnB6amYwbkZqMWZxL2RmRVdjWGpmVWRYaEx4aU5hOGNY?=
 =?utf-8?B?YVZqdkdwTFFTSGIrem0yWW9Vc2ovR0JIZEh6Wmt5czFGbkEwbnRMOStkM1F6?=
 =?utf-8?B?RGF3ZG5VU2lBeDNXTGwvWVhGdzJDT3E4a3BqRUpIMGVqa0tuUWhWV3FqcVN5?=
 =?utf-8?B?TlhnR09rclBaR1BqSW11Qk1LZklYWEcreTJ5eGdGdU1KakhwUUtLMHB2UnZT?=
 =?utf-8?B?dEMwbzJCcG5kMEZXNTVhdHVCUlduOUVOOFNsUWlDQWtFc3RFREtDcVFTQ1ZX?=
 =?utf-8?B?bmlrSDh4RXFNRTgwTkJSZnBOSjgxOW9FWmVQQ1hHSXhXenM2YmJMMHNIUm9l?=
 =?utf-8?B?MlFZZ2kyTFJsKzVnTytGQklBRmczQmpBbU9wU25rRlVIM2trbUZ6ejlTOTdJ?=
 =?utf-8?B?RCtKbDJpRVFaUytoelo0ZWE0cFBGRWFraHFHR0dmVVhGTXJ1cnBZeHAwQlM4?=
 =?utf-8?B?NXVoMnBrSzRyYjZyMURyNUxYK1ZUZHFYeGc5bmtqNXpBNzVvN3lST2ltS1VO?=
 =?utf-8?B?TzJkd204elRXcGpaRHZNU2FsbFZud0JrOXR6Mko4QTR1NzhwZGdXc0Q3dE9E?=
 =?utf-8?B?dHNrUkZpYWdUYTl5dVdBd3JpUWpZOFdaTkkzYTFHaTZxYis5V21FN1dva1h4?=
 =?utf-8?B?SEJmRmVWNFZ2aUNyanpCRTU5Y2lucHYyQ3Z3RDA4U3lCS2VKN2U0VVJHZlRS?=
 =?utf-8?B?eGU3WDJrZjE4bFNyOWNZLzhNZC9aWVAwTzZrd2JlUUVyY0hvUDZIaGFRcnBk?=
 =?utf-8?B?dW8zYWZkUkU2cjFJdU9CVVI4dmp3ZzFlYldZbGZERWw5N3JVcWxwZ2lQT3hR?=
 =?utf-8?B?aklGWCswWnRVZHlzV3lnZlkvc3BGd3Zvbnd2TWdrUFh1bU04RFloNGxubER4?=
 =?utf-8?B?Qit6K2YwZkQyZEErbjRwL3Yrc0RTM2lvSVJ1L0JkenZaTm9OODhzYmJUSlZU?=
 =?utf-8?B?OWd0Y2E3RjIxNitZZnBOdVYwaElEa1BYOXYvODNpVVBqSEU3bExYQ0VHNjAr?=
 =?utf-8?B?dzZOV0tCUXVQb2FISTBFUmtjSE0wZjNRSHN1Nm8vUlRlaUxBaEliS0VmU1RL?=
 =?utf-8?B?UTNuYk4vMkdOYi94Smcvdi9ZVDhDc1BNZ1lNRmhoVXJLOWhsbVVkZFFsRzBt?=
 =?utf-8?B?ajk4V1l4aWtDV2hHazRSU2s1WDJiUlBIc3dqdW93eUNzOWs2cVo3aCsvVDN4?=
 =?utf-8?B?Y3dZTm03YmUzWTVNZW41cEQ2Z01SWGpWK0dDVUEwcEU0cGFVTTRTSFBINXgz?=
 =?utf-8?B?U2VET3lwRHU4N01uQ3BkMlNyMzUwanBOZFBIRldCSWxIUXRFdE9PSEJrUEtZ?=
 =?utf-8?B?OEt1UDVud2s0OHRyYUJuNDNWZkwrTjFhckZSOXgwVDhtTG5xenNSRG5JNmZU?=
 =?utf-8?B?N2JUSGN6TVRHeGxYMkxIYW9Eb1ZNOHZ3NlF2cEh5czJFNEJVdGZabHRpcW1a?=
 =?utf-8?B?OE1ORWpYT3dENFVROGs1MW5BMjNCcVJMNUlQUE9HYWhwMHEvc2lXaUUzZ1Av?=
 =?utf-8?B?aWRiR01BejhwZjgwWDYvTkVHVXBhTU1abGEzTDlhalZxREphWXRiWGU3QVhz?=
 =?utf-8?B?RHltNXZyU094KzQxNklnV003WERYU0VoUHc5VnhrQTJkSSt6d2x4aWJ4QTVh?=
 =?utf-8?B?RFBRVmJSOHVhRjY5MTVFU1BmbGpFVit0Yzh3REtnTDBLUytVRFRVckViOHlO?=
 =?utf-8?B?cC84UjBxdmw3a3BsQ2RFbXRkckVOaHdtM3RaZUJ2MVdwY3J3R2UvZllEMjE5?=
 =?utf-8?Q?ZA+p721CyX+BdpkvOTa/gSySb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f65a28c-1e6f-4e2a-5abc-08db25ebbb61
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 06:57:39.8537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ec7Q6Zu73pfZzpD6anIAH8PFsKyl3o2bQy/RZpEvFAJ95jS+Nwo+z6vghiwcEUNnUAiEfnlE+2A1ZhQRtSJBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7493
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/15/2023 3:32 PM, Jakub Kicinski wrote:
> External email: Use caution opening links or attachments
>
>
> On Mon, 13 Mar 2023 09:51:07 +0200 Gavin Li wrote:
>> +     if (memchr_inv(&enc_opts.mask->data, 0, sizeof(enc_opts.mask->data)) &&
>> +         !MLX5_CAP_ESW_FT_FIELD_SUPPORT_2(priv->mdev, tunnel_header_0_1)) {
>> +             NL_SET_ERR_MSG_MOD(extack, "Matching on VxLAN GBP is not supported");
>> +             netdev_warn(priv->netdev, "Matching on VxLAN GBP is not supported\n");
>> +             return -EOPNOTSUPP;
>> +     }
>> +
>> +     if (enc_opts.key->dst_opt_type != TUNNEL_VXLAN_OPT) {
>> +             NL_SET_ERR_MSG_MOD(extack, "Wrong VxLAN option type: not GBP");
>> +             netdev_warn(priv->netdev, "Wrong VxLAN option type: not GBP\n");
>> +             return -EOPNOTSUPP;
>> +     }
>> +
>> +     if (enc_opts.key->len != sizeof(*gbp) ||
>> +         enc_opts.mask->len != sizeof(*gbp_mask)) {
>> +             NL_SET_ERR_MSG_MOD(extack, "VxLAN GBP option/mask len is not 32 bits");
>> +             netdev_warn(priv->netdev, "VxLAN GBP option/mask len is not 32 bits\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     gbp = (u32 *)&enc_opts.key->data[0];
>> +     gbp_mask = (u32 *)&enc_opts.mask->data[0];
>> +
>> +     if (*gbp_mask & ~VXLAN_GBP_MASK) {
>> +             NL_SET_ERR_MSG_FMT_MOD(extack, "Wrong VxLAN GBP mask(0x%08X)\n", *gbp_mask);
>> +             netdev_warn(priv->netdev, "Wrong VxLAN GBP mask(0x%08X)\n", *gbp_mask);
>> +             return -EINVAL;
> extack only please, there's no excuse to be using both any more
ACK
