Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04F057F41B
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiGXI2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGXI2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:28:19 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7D512F
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:28:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1Ftjd9MSYCv2le0CtxMt9ysweEP5GpZZrYGyjWY8cKAyFr8WBPBorAd6Ik0VDoOrKJ825SnareDpC58Td7hM54tEzl3YmhP1T5sERsIxGlwWjAVS0Acge98SAp0cgetXxglIUYnquAwDJZ5fLhKUAzy69wgc/xrPBDlwYRx6ugicpCswav9uZzxTgCJpa77iRKItyQedy1deUQqQhnlpkbjym54Tzpx85v+7oeUhei3jAub/as//nuqsz3vetjjWlkJYkQSyxJGS7lkH5V//AyMLwaVpVYPEuVsxb21u1hNFylE4IzRjuHeEVcqz13jpe4MrAZFEd8UKWIjXIdg8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ct5JuO6y9r3u3TVd7TOFQfiopFVeOZ7l+tOVkl1wI64=;
 b=n20m2tf9V700ZGI19Lb3D6133FN3MfDCfkW/hgqxjzSyo/Xkfg0+5Rl26Z9CSGkkAmViw0u24xzy86xwssGgbNl9NDPaVoHb5aC2zKmOgCSs5r6EJUAZv+Z+nxjcIs6ZVq3Ik7MR5fct9ZzP3a4xs0nETRTBEPqv7v6/03NRgoYJYJvn9IXS1hy90W9K1gUu6UqVLIR89XZYc+d/wmhf1z338h43Wht8anG9uqvBlLYhPKndDfflG1QTDWTXl/C83nOPbklH3AtLjcbk8jyxI4inBGx8jwAWlJYoeFpc1fEQs6vxvTV5oeLiaUCtH/w69MK7pfQHAgKVSgM3Kx7rKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ct5JuO6y9r3u3TVd7TOFQfiopFVeOZ7l+tOVkl1wI64=;
 b=rkbw+lQC+ZTZlvY5HSF68myq99xnYqKTvLis7K+lliF8lRrhsrPnl8fgCQD4OGrTc6GkBv+AVUO1Hwf+QqC87G18PPA0fiu2XoGBF7gGQ2zyXKgTMB5GZ2BJHbLu2IKWqoqf8SxgyDeu7MFUf/qw/ylmnkeLv42VOBoGmSIJ/rL5HdtY0N05KaEAKrpyGz9Dxm6SbOVH2oTz5I4p+S9hBvJnXrUbOZWL2e1/SUZgQ6mptuUn4dTHaKYsQzjpkEDt+wsP+WSqWS1p5U6JxqjpGPQplxENBLNeKKauiiJqtBAXyu8OMYO/pYg2wi2hMak3/UWS453Ms+gtYxyPBHY7aA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 DM4PR12MB5916.namprd12.prod.outlook.com (2603:10b6:8:69::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.21; Sun, 24 Jul 2022 08:28:16 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::548c:fcf:1288:6d3]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::548c:fcf:1288:6d3%9]) with mapi id 15.20.5458.021; Sun, 24 Jul 2022
 08:28:16 +0000
Message-ID: <3bcae34c-5236-17e3-b2f7-e377eff33739@nvidia.com>
Date:   Sun, 24 Jul 2022 11:28:09 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next 03/14] net/mlx5e: Expose rx_oversize_pkts_buffer
 counter
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
References: <20220717213352.89838-1-saeed@kernel.org>
 <20220717213352.89838-4-saeed@kernel.org>
 <20220718202504.3d189f57@kernel.org>
 <24bd2c21-87c2-0ca9-8f57-10dc2ae4774c@nvidia.com>
 <20220719202234.sym2tqtsko5iond2@sx1>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220719202234.sym2tqtsko5iond2@sx1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0020.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::8) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6df9163-9a1c-45a0-5ff0-08da6d4e74dd
X-MS-TrafficTypeDiagnostic: DM4PR12MB5916:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SeHHmX2oiw6sKL+RY1nhPHtrZ2+pADk2dsHId1/43g/bBIjXaIe+ZJ71AHs3Y38a6Fu2jI3tS99NyrSc6qiIH3VJzdRLqoGhW7TPKKlh6XGDEDfRlxZHkApN6AatHc7PPGntltUBKOEwaxn/Nusg6gygXv5q39unY/xhj6t6UEafvtv1oDR8yRvpbj3usSynFZG9NrdpzQ/N9xt2zIlALvjcyibmBnn/WNdtFCo78wNxIPO6NRZedi/8vjeArjoxGUUZMzfO2U1lU66gTdv1DcL5I6raY7LRSun1eqwnKGGXWsiNpsiI9gyHilEi6TY+6+vHCdI3SpfGYGIipiUfz8dwoRJtNxHM7vReb1dqMTtnYHo+hYYnpWn+sFLfd9kLYCU9HXQ0/IGly1XmBfIQrYWZQWzWDP4ygSvQN/+inJMrSfu8MZoVc6CxP055fjUJke157JX8YkwUwSSulHXf7HrGQjQVOR62C/JIwtLveFquKVlWftKfe0kexQnjVVnlgY9cYgeBeQmQtVtlEoSmznRRPaPX+okJ3fGj3jc4GVWoXXnDN8ILWaIasNGABVo3XVj5qaaaaseTV2CrU1m33RINIrj9A6wQgOuijOq0oD8mvRXVxOwO2hNfaJM+miPsqI+TOf05/w9UaXrMoz7X8UH4dDf1QLodR2mdq00sjtcwfDkvddHVNuYFMIcZ9uZFGfINUkLv1uHtCRuIIDxfi1AEiWYvfLC1Licu1AbV2oDYpc/SKkpoZX3wCxoyE5+CAkJFnsL0IjmA2wvjKmwWLkPWyx8XukB0JvQcKbDJxdWTeK7/RQWuDqBOh+YBUB8BR0YnIbCpFv4pXi3oJa6wmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(316002)(6916009)(54906003)(41300700001)(6666004)(26005)(6506007)(6512007)(53546011)(478600001)(6486002)(4326008)(66946007)(66556008)(66476007)(8676002)(2906002)(5660300002)(8936002)(38100700002)(86362001)(31696002)(36756003)(31686004)(107886003)(83380400001)(186003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDFobEJOOGV1cEl0ZEJWbVJySUx4Sjl2dUo5RGFDemxmdis3R3lsSnY5QkI1?=
 =?utf-8?B?Q2tBRUNpaUhZWTljWjR4cTNFcTB5ZGVmaGZnWG9ab1BWYndmMjNDZGJaTERJ?=
 =?utf-8?B?b2hLRTNjNTJxNUtDN3IyQ2g4Q3QydkNBbDg5VzR2N3hnUjBRWXYxZ1YzT2Zs?=
 =?utf-8?B?R1F2WWZPc05OSUpuNWExNU9RWUdaRXlUb2VaNXcvSkF3RUY5RDdKWWpGUU5D?=
 =?utf-8?B?OUsrdjVDSTBsTUVtM1YyMDVweXpxR0RyTlB6cjdPUHl2YlQ2ZG9zZWd3TnNr?=
 =?utf-8?B?aUEzWUpoaE1maFFSVFZsS1NCaFR6UGlLVjhsaVJCZmxQcmtrTEFqbWRWSUI4?=
 =?utf-8?B?YmFjU0hGcmRmdDZobVIvWnJKTTlLRENDZERGcHRxV0V1aHZCak9udTlwVytH?=
 =?utf-8?B?Z1BjS2JKVmE3QkVFM0s2dEtqajVvZHE2VnZqOFgyZFRDU2xnMTVIRVM5SFpG?=
 =?utf-8?B?MEltS2doaXZ6clQxNFlXZ2hheTc2dG1GUG1pNjV0U3grSXdzTmVOWnFaSTdo?=
 =?utf-8?B?MGNUdXVwb1U4UTBCb28wUjJsY1ZQRld0ZmhYZ3kxcVRkV3BsT2E2THVvNHI2?=
 =?utf-8?B?MGRIOTdUekJjcXJiR2xrd2poSW9RVG5jK3dxR2FrdmxZVFBnOEhQUGtUOU5Y?=
 =?utf-8?B?YVRSQkNqYjJrR3YrSEdoY2E1cFU3WGcya0prWVBHK0cvNTY1MW1Hc0JVKy9S?=
 =?utf-8?B?N09Db2R5c0JGeXJwU0NVQTZ2VzFpeWt6dHJubVNSWkdCaGprdWVkcEF6SFo4?=
 =?utf-8?B?Tk56Mk1iODlMMGFKd0EyQ0JSSVV4cE5HdVJ2M0swUGZmTm1Tc0VpY2dKbVVk?=
 =?utf-8?B?ZTBTTzNjU2prWDBFU1docXBVNTBQM2ZuUTgrd1lQNnNDQ3duRUM0SnNkK2R1?=
 =?utf-8?B?TTBOaWZmNTh5OHorQTRiSlFEbkQ1SnFjUUFsWDBBSzBjcEZWcndqQjJmblc2?=
 =?utf-8?B?M0xJek5mN1hFU01SZERFNlEvS1VVWlVOYnlFSkZtcTZNdW9qODVGQzY2OFR3?=
 =?utf-8?B?ZmFlSEpEVENTbU5NRUNKMlg3VXhSVFRadTVzZ0hrWGJqUEJabUpUeHVZTTRM?=
 =?utf-8?B?aXZ4dk8vMVdrS0VyTVJhZGR3dldDS2U1V3BONkExT0ltd2J5VXpzT09RUzl3?=
 =?utf-8?B?Wm8wM0IyaHFQeHp2Z3M3dWljdGpOUWhRY0FlTStNZjhSUW1XQ0JzSk84Ulll?=
 =?utf-8?B?a21vUkZVMnFDUEtmdVFZOVZodHZ0Y3pJb1pnN0owRVVWN1ovTmQwMWRKdmEv?=
 =?utf-8?B?cDZVL21jWWgybStLM1lVTGxzUWE4UGZOellReDZibHowd3J5N1dZaXovc1lC?=
 =?utf-8?B?WkhMWHlSR0FpcUNLMmw2NkNjWTZJOUJYbjhMYWt0dWlDQUMzMHJ6b2s3cTJy?=
 =?utf-8?B?TkxsQzJscWJVeWVvQUZwcmdtV1U2Q0R6bWZzUVk3QXRZMThHVFRYN24vWHZt?=
 =?utf-8?B?akZCSVE1aXMvQXJBdC9ib1V0N2hpM3dZamFLUWFQbThaczU0WkJpSGJYUzUx?=
 =?utf-8?B?R25LdWJHa01pYS9YazBjT3QwNXlVWnJKU3Q1ajdoOGlxaFRZNHFWd0dzc3RI?=
 =?utf-8?B?cFdZYWNSV0ZteU9WU3Q2UEZHN0p5bHNrUlBnQ3J1OUJmZE9aZU82cXgxb2NV?=
 =?utf-8?B?Rk03b1lJSEFpYkpubHJ2anduN3I2bzRBQmlyb1BkK0hMak5SeUlld3RzM0t0?=
 =?utf-8?B?RDY2T2wwYSsxTEFFeVVrTytSbGhLbkduTlZOcjVlaFZ5eEpMbUpyM0ZTU1Jr?=
 =?utf-8?B?d2VaNGY5YUoyUWg3WEJ6NnlOdUJZbklSSlAranB4c1NtWXJYbGVoUlpZcG1a?=
 =?utf-8?B?amRJQlljV2ZUMDhQYndWOVZpYnl3R3VTNkRsdWF3N0RYRXNGY3dJUWhmams5?=
 =?utf-8?B?SS9Zd3F0S0JvNDV2UjFraGZhQ1pJK0JsRis0eGcreVVBbmNteDlyeklwZHg0?=
 =?utf-8?B?T1RCbzhrV05iZmhPMk5qQS9DNG5lNVcxa1h0L3hKSVZNV2xOZHQxa1FmMUZm?=
 =?utf-8?B?WkdwdFVLZHkyVW9mTkliR3VWVS8rcStrMVY3cDhiQ1dFeVZyMXh5YzhXRVlX?=
 =?utf-8?B?SStUbHJmUDJsRkxaWVBlV3BrOGtoaUwySkJhNktIVFVaMS9iT3NxMkh6Ty9I?=
 =?utf-8?Q?E7jBcCwpcYn4YZvRAmuzUR6Lx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6df9163-9a1c-45a0-5ff0-08da6d4e74dd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2022 08:28:16.3439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: psOoQmwNcDI1OyGDuFTPiEn+VLVxo67a7U4VYzeV/wUWyJlBb+c9Oi3+Jp0UkOJT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5916
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/07/2022 23:22, Saeed Mahameed wrote:
> On 19 Jul 14:13, Gal Pressman wrote:
>> On 19/07/2022 06:25, Jakub Kicinski wrote:
>>> On Sun, 17 Jul 2022 14:33:41 -0700 Saeed Mahameed wrote:
>>>> From: Gal Pressman <gal@nvidia.com>
>>>>
>>>> Add the rx_oversize_pkts_buffer counter to ethtool statistics.
>>>> This counter exposes the number of dropped received packets due to
>>>> length which arrived to RQ and exceed software buffer size
>>>> allocated by
>>>> the device for incoming traffic. It might imply that the device MTU is
>>>> larger than the software buffers size.
>>> Is it counted towards any of the existing stats as well? It needs
>>> to end up in struct rtnl_link_stats64::rx_length_errors somehow.
>
> it is already counted in ethtool->rx_wqe_err, but rx wqe err is more
> general purpose and can include other errors too, the idea is to have a
> better resolution for the error reason.

rx_wqe_err counts error completions, this counter counts packets which
are getting dropped by the device and do not necessarily generate a
completion.
