Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D74F580557
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236892AbiGYURD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237036AbiGYUQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:16:48 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2044.outbound.protection.outlook.com [40.107.22.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7187D222BB;
        Mon, 25 Jul 2022 13:15:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQTEsF1f0VYLPLooL/wSTqM9V20QyVGhUoYgZWd/vXLodPxUYLQVe0Xt0hFXV6jcyJ8z4Re0sCajlmpGXAI8/DKoe3RwnYkIU772YK9GI4OlI1CsyEZPaSvPGMI3NiXyO+6NG/+Ik8fomOwNk2yjpoZ9xHTb4QjqGIdtgjsAmJB3/JKGTJXaDxC1jkub9FD9Nm2hur1RyCOJwfRtb4tXaAdvyZX4UoTBAJ35JdbcXOkYse7wJdAjZDJYJBUyq1QSrVXOZgH2asQhueTV75AiKL5ADL7tMERI9fWnTnpWhyCBcHp8ChkDc5oiqKVg4k6S9a75TIPHiWrzocLk1FNvMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vxP2Co4TQgWnOarFjZ94tBrwLhVSwb1P2jlN/JETN50=;
 b=Qz49DuloJa9chxDRKb0KEXguFFFyKzkyEhvF0bV4VssXPym+yASDEG6UZPvWd6FT6umyYTXNbjpq7Yu6rfNPvNVruZIKCaZUddy/n49KJJerLe3p+GRf09wIdKMmI8p150IBs8abS1NQkWA8/iks19J04kYj/SB77BRb/4PFHC7l7c+Bor6/A4FnrhOgWGTYq4MsmNOsjOyydVsMyePw4mK1hst7KLtE+CFYffiTwN6zAinClVtiOjnVm+xGfdwlaeQ4AYQfgNERkHUuQXt/YHiIW+bFyAosNtIssD3vrZTK155dsdWLa+O0MHcBABI31dDQdXb07U+RqN0UhNMvIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vxP2Co4TQgWnOarFjZ94tBrwLhVSwb1P2jlN/JETN50=;
 b=OpUtGJdjgdskQ8k/bfoqqqoVx/QwrG+QGh//Hkb/IntEuJlkUxolVhxbhZ2G0okevES+Vrz0holtvgv0J+87IK0ttYOTj16w7T/wjbGCyHKFxXfNr2X9A00ogd9iERD5TtGpgsu20RrxJ2WfAJOly/F+PeWMhKSD9YQYfuIvbchXYRmgl0VRqSNcHCmiCkxdDApYYS+F1l/SaPIyUcYwDJ81mhTX5lntG2UdzaAD/WYM8SrecNuY62Yeq/y2KsxHN08+Hw31yS9fBeQJvY40uZKBmeXuoGTqvHQXM44lW1Jti8rh+bsDCCQQiVU3fnCkpGXO072hlvCrWLSRg3YwLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB6PR0302MB2807.eurprd03.prod.outlook.com (2603:10a6:4:aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 20:15:53 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 20:15:53 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v4 00/25] net: dpaa: Cleanups in preparation for phylink
 conversion
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Camelia Groza <camelia.groza@nxp.com>,
        open list <linux-kernel@vger.kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org
References: <20220725151039.2581576-1-sean.anderson@seco.com>
 <20220725130952.657626d4@kernel.org>
Message-ID: <51c26e19-e4ea-7596-1147-7d95eec9e6a9@seco.com>
Date:   Mon, 25 Jul 2022 16:15:48 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220725130952.657626d4@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR22CA0022.namprd22.prod.outlook.com
 (2603:10b6:208:238::27) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 979182b3-37d3-463b-7f0c-08da6e7a798d
X-MS-TrafficTypeDiagnostic: DB6PR0302MB2807:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IkLt9htR44pcPmLfTKVtFdGcM9vVCIAF9n6MDuCBn8AzNE2bsk5Eb2/4bH1v+sR4felv4R50CfJAbZYmbfQUhvZ4rFjAd64C8tnDJGa9XNmx4HNT6gj0qlpUazdwRECoBLQwWN4bSlO7khTT393ScBFQlhZb+YOzRZ9iMHCai19sj2RUchevB7IRCVo8aLl8GLj0Sp3rjDmgBo/H7Bv5U+4tPgN/RZKNL6o+I8PAi8GPS3rURMnft/Cz6s8Q3ZNZtvWFE3iU1lKYhoQrG5DuSyTajzpkI+6IdbEVBfkLKI5M6yvGXVl5i1z+2x+CBql8nG8FeYT3AXAOY2Rvy1HoXCoIxJLZsHGhyaHhAQDPchNcVIKbre0KtXCd4iGlxvwQO6ASttqgCeQNPbrRkZ7Y6jiBM8LOqt+3Fuwqhqog4gDb90xHC0bdsYave2MOFg2e5WnvpKx228KerNucg2WSN3MKM+vi7nQbs3wamvFU8syzPelkv9K+PnoHZjEc97P92Gs8tnQ87Wd9wk/zg3wv8RCCdmJUEvk3JqRMEqKvqoaY/nTxO40GK1DMBJe1vS3GWnY3tzzSaGbwJLW461bQgCauhAuN3s/sdKcVlZgou0muLMIWHQC664eXd5YP++72mQTZZ/vB+VVZ1StyD96atE/RGHrPCBgOufZI5925rH+QEvnagEqeff+hHUli9qV3hMfq5QZLl6sjCTYu07PMCZi9CbJ2NIx/Ww9TM36a5g4CJ6BnGXOfXOc4lU2tRg206OHYzvCSHgmirV6kLTS+KflMVTgn0/CGgY53N+mjjyy2nVQZMrCp+u0ScoZo8efBHQeak+zFz2yrZo1bDo+T3wK1N8azMX2cZp9nW4Qbtp76PvF0EXxG9wknSddlotQILLVWXkzmDMGgjTy+CoKbIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(396003)(376002)(346002)(39850400004)(83380400001)(7416002)(44832011)(4744005)(8936002)(5660300002)(38350700002)(38100700002)(26005)(6916009)(54906003)(2906002)(6486002)(478600001)(966005)(8676002)(66946007)(66476007)(36756003)(2616005)(6666004)(186003)(41300700001)(316002)(6506007)(6512007)(53546011)(52116002)(31686004)(86362001)(66556008)(4326008)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3dUYndSTWlLTTBhTmZqQ2pUNE9Bc3ArcUtkTWI5Zllwanc4YVlsdFFtU2Vp?=
 =?utf-8?B?ZWk1S3djQ1VaQ0pPcUx3NGdoK2k4RU9BV1FvZ0FZTXQ0OHNWa1NZTmduUUdP?=
 =?utf-8?B?aW1KQUR6dE9JdDFieUxlZ1FhQktrM1ZvQmIrZ0dRc3hkS0krNjJEbTJYL3N3?=
 =?utf-8?B?Yi9NVDZxUXVNUG1CekhMKzdEWWZXNzVERnpUNmdoaWtnSnRaNGo0cmZscGVv?=
 =?utf-8?B?cGlEc3V2dFdNd0hBQ1VjWTR6bGJqaHhkYlpGQXA0ZXFmZ0tReWpYMkRTdmxU?=
 =?utf-8?B?WjNpS3psM0xJZzE3U3JvNFFnNzl6aXlyeTRXUGpONE15Ly9KeklEY1MrZDM5?=
 =?utf-8?B?alFRQUNwcVJNdmllTEFTNnMySGFtQkVXSkphM2JUUWcwNEVIbEJPQ1l2VytL?=
 =?utf-8?B?SHVsc0IyOEtiTHVEYk5naGdnODNTQUhITkxMV2owTWFScEhYb0RVd2psTG9E?=
 =?utf-8?B?Njd3cFY3L0xSNFA2QTRDWTY4NWRhWHZJTU9kMjEvZUJXSjc1Qm1id2E0azdi?=
 =?utf-8?B?YVhwZzNRMWEvbGIybzVkcUNUMzV1a3dFc2JrUnFQMDB1WUdQZFdjNkpQV2ts?=
 =?utf-8?B?bHB4R0tzZktiRGp0cjVYZ3VPME5YWnkvdWYxWTg4aW9BdFlnbXBrVzV0empK?=
 =?utf-8?B?YW9DS1pRcWVsQ0lEeVRsNzR3c3VCWEJEeFlnSFRVNGJSclhsS2Vlbk1vcDJB?=
 =?utf-8?B?NnIvaXJ2SHg2TU1ycHNESjQ0OTNkMi9HTlkrNW9UMXVLQVBvZUkzNWRUQ3R3?=
 =?utf-8?B?elcrUklFSVpBOGpxbFlxSTI2MEJ4bnB1Z1RwN1k2ZTBMMU5haklLc1BMbUsz?=
 =?utf-8?B?bDR4K2Qyd0hCaDhiYnhMMnVlQTNLZWlINXo1dmFUaEc5cnE4cnNXbVdmUlU3?=
 =?utf-8?B?REJ3UDhtSzc2NGZtNDFncWE2ZVVFN0s2REQ5aytKTWdvVGx3WllkOXlsVHUw?=
 =?utf-8?B?V0ZQVjJMckVoUnVyYVIwU3c1bU1mWXFZMDNYK0tUZ281Q2NvRmpnL0dKRmc4?=
 =?utf-8?B?Qk5Yc20yVFlYTHdjSjFtajRWZE4zaGpqZW1Bb3JoKzdjZzdyMGsrSVQzTmgy?=
 =?utf-8?B?TzhoRHk2bTAvcmVwTlFvRTlQNUloUGNiT1hmVkJDYkRVZVRwMnVQclJIaDNk?=
 =?utf-8?B?L1lnY2pnME9EdjdqWVV5RHRRRHBQeDZMMEFoUDg3ajhGMHVkTk1vZmozZWQ3?=
 =?utf-8?B?dEEwanVzQWw2WEE2a2F0ZkMxWDVrbUJrSnpoVWRIUERTQ1dvb1RzeVRpVUZw?=
 =?utf-8?B?SmIyTGd5bGtNZHJSd2U2SktHcDVscjZDcjQ1M3pnbVRINVJzUFlBSGZ2eTJq?=
 =?utf-8?B?aDhXdmcvMi9FNEZMM1IrcElxZ2I3ZFRoMDUzMlFvd3hsL3R5d2M3Nkova0xx?=
 =?utf-8?B?aHJhYTNTeDZjakFOclRFbzJ1RzR1QkJGZTZhNFcrT2VZMHNlSFhvV3lRUDZY?=
 =?utf-8?B?WWFrMFZlRmxIUGZmWEtjRjJrVE8xdElscEpSWVkvdEE0YzZKLzZ1VHFXOUhI?=
 =?utf-8?B?NnlTNzVNeDkxOE1TcTY1WnNQVjFkckZiUmx5dUsxKzBBdzE1eEdGNmZXa2FO?=
 =?utf-8?B?a3o2a3Flb1hHTFpwUHl3UmRXbE8zQ0ViMUVDUUQ5WE9BR3BCdlBFUTc2L1Vq?=
 =?utf-8?B?UHJaWlQ2c2RwM0hLTmtOSjN0LzZMd0hEOElMVUEydTRMZE4xYTVHNnNlSGRh?=
 =?utf-8?B?RUhkY0hxd084eHdObFVQSUF5eks3ZFdSSCtGQS9pVHlBdXVXZzRHN3Foak1s?=
 =?utf-8?B?cTVIWHVzVy9OZndGZHNmdjhSYStSVnA0ZkdzNDlDZ09Xa2NHR2N5dFlVVUpB?=
 =?utf-8?B?YW1vejJpb0lJalFDWS90bzZpSzIycU5BekQ3eCtPWjB2cGhEdjczVFdMRkQy?=
 =?utf-8?B?S3grVjZuRmdiL2VSOUtsTDVsdGZ5Q283ZFBua0lSTlJUcDRaa3EyeEVpbWF2?=
 =?utf-8?B?dVRqeFU1Rkkwcy9vd1pkUFNCZGZ4VkRLZmFIQnJXOWtrMGo4cXUyWk5Nc2p0?=
 =?utf-8?B?ZE5Pek5lNHZUcmJyYzRMWnd1ZWV6ZWkrWmtsZ1VhK0V2K3NZb3NHS3dVaFJ1?=
 =?utf-8?B?MW9sUWlGVk1zSUlnbkd6bzRCOTF6MndFQzc5QnVLWU1tdGJMU2FwKzlLV0Zi?=
 =?utf-8?B?V2hYTlBNWG1TWEhMRlB0TC9SMFNNVGZOdkxCbnhzbXphS3VIVG10eE4yeG8v?=
 =?utf-8?B?Qnc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 979182b3-37d3-463b-7f0c-08da6e7a798d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 20:15:53.2603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YZ0M4EwMKcas21IVljl3GR4Ud7CN66EpIS/zPj9fb5pnfXq2x8zraqzLVnRV/bXQVONUTq9x0Vpcq2dOG4Cmlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0302MB2807
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 7/25/22 4:09 PM, Jakub Kicinski wrote:
> On Mon, 25 Jul 2022 11:10:14 -0400 Sean Anderson wrote:
>> This series contains several cleanup patches for dpaa/fman. While they
>> are intended to prepare for a phylink conversion, they stand on their
>> own. This series was originally submitted as part of [1].
> 
> https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#tl-dr

> designate your patch to a tree - [PATCH net] or [PATCH net-next]

This should be applied to net-next. Sorry, I forgot to add this when
splitting off the series. It will be added for the next revision.

> don’t post large series (> 15 patches), break them up

These are all fairly small, incremental changes. There's no natural
breaking point, but I suppose it could be arbitrarily limited.

(there are some other notes there, but I think this series is in good
order wrt. them)

--Sean
