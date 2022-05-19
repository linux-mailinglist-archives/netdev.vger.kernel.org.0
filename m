Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB3552DC16
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 19:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242621AbiESRzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 13:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239100AbiESRyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 13:54:37 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2055.outbound.protection.outlook.com [40.107.212.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8E2EBA8A
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 10:54:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oEunmamI0hpN3PhEkTg/ds54jhi2QBOeIsAVmMWZl1187bF44nV7o/X2wpppqdfIATVflw62uqmWCa0mJ7HrQl4cWubAPFOG+cdPzqN5cLmCP5jpeG7IOv2ekAnpR5O5lPn48HduvecQeweuuE4Nq/K8B5gz7xZ5bWwcZ+qrYTLN8Ev4O5V9EIb8yyQ466KJD7swiS8/Wb4fQ2ucS82x2jDhw9ZeXmbu57Eyc390R0IuxSV3iCK8+hApItPaSKlyYRuOAAnb9k5ggWYEh1i6qG+w4vgWi8wpH4/AAMe23go255uwsFMLkB1XPA2FkPW/cmm+Ie0ya4giatrc6hwiRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wATvHnYtVs1DK4k3kY0KrA8Noqxnk3TDQJmLGN41CS8=;
 b=KIXR89ldftoxon1MHl4dnX+0jXuHJkgkLTeydzoh4cz1c7ZGfzAYUDCGNUkNpHaYqvfqZ1/11y2j6F06GvRWEhBSox+T71nmYAVj8N5QKIarDBAaNkovP1Y3suxiU1mNkK2TPkDlcc/9gB2Wa1KmXAYDiTLaauqYoUkWUqh7iSN5ejfzpzFjz3kZbLhtQDagl7xIYN5xdFfg1rfHzWU1VvcVLFDheoj6pSzt5tI2K22QnCTcoDQ62P8oMnUKf2cnuTCpidJwXC2vZYor/s2HKVQiEsruawpdcMJgWBOfZEvfNmxiEB7ECmU6JbNlCpwZc5DBUUTSEXrNSaiuLANyDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wATvHnYtVs1DK4k3kY0KrA8Noqxnk3TDQJmLGN41CS8=;
 b=O2oe2kNUyUbWR5yrYiOTmYC96M++vwwq2nl4Y6ymxQu3kDEWbIfIajgzyDp5CHlt+4+Diy0XuUFQSXv4KlZp2eO+ySpBKfjiAm0FSM5MrUBn1jC9cwSJjkM1V2+Jyfh+yT1di8FZk25GDAfen6hmNAyRZEjA45sRGWzV8SznHUY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by BN6PR12MB1522.namprd12.prod.outlook.com (2603:10b6:405:11::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Thu, 19 May
 2022 17:54:15 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::db8:5b23:acf0:6f9a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::db8:5b23:acf0:6f9a%4]) with mapi id 15.20.5273.016; Thu, 19 May 2022
 17:54:14 +0000
Message-ID: <d35c10df-8114-8796-f027-8f37ef783a4c@amd.com>
Date:   Thu, 19 May 2022 12:54:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: PROBLEM: XGBE unable to autoneg when advertising only 1GbE KX
 mode
Content-Language: en-US
To:     "Pighin, Anthony (Nokia - CA/Ottawa)" <anthony.pighin@nokia.com>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <BN0PR08MB6951AF51D58150007BA7C46C83D09@BN0PR08MB6951.namprd08.prod.outlook.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <BN0PR08MB6951AF51D58150007BA7C46C83D09@BN0PR08MB6951.namprd08.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR11CA0008.namprd11.prod.outlook.com
 (2603:10b6:208:23b::13) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf65db17-e645-4415-9347-08da39c0964e
X-MS-TrafficTypeDiagnostic: BN6PR12MB1522:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB15220EAACDA62D3A7C754679ECD09@BN6PR12MB1522.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ly53/CEv6QqhnsF0VQg3DOx75iy+cBLFRMxlErwzOL/BV2t5EKyliZE5wXI+sae68cuAvgWTdd34T6VOfAlqS3uAUwQqAN8SKbfBzwVCuIraPTa0+hjqw9byDgxWtvY8/CNyTbqSBB4Q9Vk0wZEW9a0CqdsSlo/h71NJBfvkRs1RsdtIc1faJRhBH41n8Nki4p2H1QCZr/DF9WUXdM2N6GPuki0Yx6mNw4EXCLdkf8IYcFZiLxAjryeLncfMcVZTuph7YT5Epuq/9d3hZZPtwjmdC7QaQF9nsUPWUOmehsgmThmzqF/TCEIyPyUzOYvvvMKAmp1TByErBMHpH+xXfhE516oPyMPzEgYIwQkXydMz81hp+B07TRSLvgRyAgc9io/o31sjz/DTp1Lv7s+QzVmDZHOfAlzTOC8mmVJk19qxuDu0yxF015BLQ4ILmdWAwW3BjwYF6cCq2LGPMSXTkUiNawBtj/L78YPQDJldNNSQAymehIcJ+xlpjqt1i8KilaCNPMG2DiaMr90He6sZijim/7AApqlroiW6iCewtswwsjc6SCWQFLn2SZVOYUHexZ2UnrQSTev2RC0GD9Gehdwt6FPWEr1kaV/kVkTzlvraZgy5BY3NOiFFhl814Fd19IUHbUHCfbm7aPxr0k1MrMYEgGWlbMLW9fGEL9iIehog2YODov0j/i2liuFRRFT/AY7IT4e8dXTj4Rqdqq7m1lVtefw50FM+JYRDlh/Iia8+b23iHODkQNk4u/nYtpYh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(66476007)(26005)(66946007)(6666004)(2906002)(66556008)(6486002)(6512007)(110136005)(6636002)(86362001)(38100700002)(316002)(53546011)(8676002)(6506007)(8936002)(296002)(31686004)(4326008)(2616005)(31696002)(186003)(5660300002)(4744005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUJoanlHK2t5b0ZhZ0g5Y0QrRHFCU0JkdUJMaWkzV3Q4UjZZcEpDMFZNUTR6?=
 =?utf-8?B?Q2svVndIQWV5SVE0amZBZlk0VUZLM1U4VFJUSG1RQ2p1ZnNIalZvOFpCd0tZ?=
 =?utf-8?B?OUxjQmpFZlh4dE1zakdKRFpSeGppU3BQRHpGbm5MVFMzRi9ZYjdTdjU0a1Ru?=
 =?utf-8?B?NG5sNFJ5K1E0Q3FhRk1wSXRRQVhXQ2R5dW00bUc0aEFKM1hnSDVoVUQyL3hy?=
 =?utf-8?B?N2xPQzY3Rk8yT20rWGtFamFhLzNZVUNWMzlEdW9uN0FBNVRpNWtjcFNvbXhs?=
 =?utf-8?B?dDBncVhuUXkwaFIvWUd4QXNWK3M1anNleFkrYjNZQm9tTVZMVFdoTDFFblcw?=
 =?utf-8?B?V0JRRWQvNmF3K2FLVDFGWE03YXRIV3ZPVzVqQXBxTEtBRHg4cW9vbGgxSFVp?=
 =?utf-8?B?NVpjZm1XTDFqMXJMQ09kZndIZkRiTGdJWHNwSDB0UjhqaFd6RnhlYXh0SkRq?=
 =?utf-8?B?cWpTVjN0aXh3aGs1MGNHN3F2VmcxK3JKVUtUV3N1ZklVVzVaUGNBZjdkMVdQ?=
 =?utf-8?B?RUpWNURlUGlCWkJIR3ZOVmFEcDVwWGFKeUZFRXFZL3BOYnFOeEdzNFduRW5v?=
 =?utf-8?B?Mm1CUmpOb3ZoaHJoZUllTHlUbFc3Q3puQjBNeW8rNDVYOHVDRlR5UjN2OXkz?=
 =?utf-8?B?T1NtTStYWnlFdmRJUTFkVnNYREZxbVFteExhZklXeFVlRnVjWVBjUDRHVnBn?=
 =?utf-8?B?WXIrVGtUL0Fvb0xjZENheGMxWnpscXkzQk1tdkY5dU9qRSsyaUJTRlhEZFBO?=
 =?utf-8?B?N25YTXlsSzhLbi8yNzM4MGJteHY3elY1VlQyanhPM3Q3ZnFueFFqUzJEQ0pN?=
 =?utf-8?B?K0twaG9iMndIOUJ2bmYrcGphSm5SbFdPMkI2bDF5OW9vdFBhdzdROTl0cS93?=
 =?utf-8?B?bEg5cmN3eWk0OUFEVnphc0ZHZnIxSFRWT1liaVpOdXV3U2tDMEI2MWNTajJp?=
 =?utf-8?B?Q1Y4Wk1VVGVrUGEydVVwMEFpTUhUUm40Qyt5aU5EdEJHOWZ4YnV0cnlIS0tV?=
 =?utf-8?B?dkZ2Wm1EWGxicVM1Uk0vS0NlK1draWtpTTJEdFNHcXh0ZG1HR0p3RmFXRTQ0?=
 =?utf-8?B?SHhDeUtwbVhpblBGZkhNUkdrNnpBYk9sVUsrdzA0cERud1ZhR3Nyd0kzVDNi?=
 =?utf-8?B?UHUvTndPLzFGcnNkMDU5cmZOcUEyaHgxWUgxZjZWdjF6WFFMTkZ5Nzk0VFhO?=
 =?utf-8?B?bGhLb3EyRkpSYis0b25DQkF1cVRRSlRzN0JnWVlKZDlhNTV4M3paOGRuMUFL?=
 =?utf-8?B?cmVvcEx5R3lmMGtKN0p2UzFUbm9lWU5RTG56ZXA2Mk41OWNkT1l2RkVEbFBi?=
 =?utf-8?B?akltOEgrejJFT2JMS3IyUXlrb0JLbTlqNERMOFVBVGhOVXovYWlLQmlUN3Nx?=
 =?utf-8?B?RDViZjdrTzFJcGhLODZNKzE1SkJKK1pBTytIK0gwcHdJRE5vcDlrU1Nvc2xC?=
 =?utf-8?B?SHA0c1JKZnk1eFoyVXFlanBJb1laMksrMW9aN3Q4SkY0UFJRWFYzMzJsc0FM?=
 =?utf-8?B?NC83ZG9XeEFEU2EvYjJhb01vdFdqM2w2cE9pZ3JrYmt5V1Vlb1VCY0VRZnJJ?=
 =?utf-8?B?amFBWlVjVEhjbklkRlhibUxnUi9iS0JvTXpWdjQwdnpiWTVjL2hMY1A3WVVR?=
 =?utf-8?B?eXlKSUpCZXhFK3VGVEQvMnFlMmFEdmc3SCt1WWt4RllzeVFmRDF5SCtzZmZV?=
 =?utf-8?B?cVhKRDlrbmc2N0piQVUzUHZGc1VnRmljRDdkeGw4R0JmdVpvN0JJUEpxUGdL?=
 =?utf-8?B?bWlleFhrOG9FcFFDbW5mOWFBb0ZJbGxIbnVGdTA5REk3SitZei91MnlTdkJh?=
 =?utf-8?B?SmJvQnhpdmhvSjMyVlBHSzJwVzI1ZkFLMlc2NjdFbVdpNVRnZUNZVXV1bEdX?=
 =?utf-8?B?ak83YWltNE9lem84SWNQMEJXR0svdEVYcGVuMWptOENjenZVMFptcERsQlVk?=
 =?utf-8?B?M0NKZG1ZZHZ6QUNNeTNhR0pMR3ZOVzM3Mi9HdXhpVkZDdk0wbVdqMDZMWklR?=
 =?utf-8?B?TDR2WE9pOGRLOFNTbVFLZXVmQUVSRzZoZW1kWXZnUGliR3JXZHcrNDVFOHZ2?=
 =?utf-8?B?ZlRVOGhyU1pYaVBkTSt5SEdGdmdMYWtYdCswZmM5OFpjaUdxa3NXdVJDbWNi?=
 =?utf-8?B?RG5NNmNnWkxwWHlEYU9wcEdWemN2U1ZjNHBzNnNTcWJYSmdtZjB3QzZKTE1t?=
 =?utf-8?B?OEwyTWtHZVUyK2pzRzZKd2w2L2dCenhJVUh6dXNZaTFSbVZ4cjgvV0UzcnJt?=
 =?utf-8?B?K0xSdXhBMFBWNXFyQ2hqWGJoT3EwTkZoRXhMeUFzaGc1aCtNUDdicVU3OUVJ?=
 =?utf-8?B?ejF1VkxVeTRZNFY3MEZLSkViWml4RUE2TkpEd2Z4bEJiY0lCY1U2Zz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf65db17-e645-4415-9347-08da39c0964e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 17:54:14.8800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oRrDNw0ev+O23WPTaYkZf1fNxnvqVCdLM1dhbILucfz3laMOwPjh09v5NP82C3XjXlHMKBlcToWWASjIf5LxqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1522
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/19/22 09:28, Pighin, Anthony (Nokia - CA/Ottawa) wrote:
> Additional information:

Adding Shyam.

Tom

> 
> I performed an asymmetric test. One side has 'ethtool -s bp3 advertise 0x20000' and the other side of the link has 'ethtool -s bp3 advertise 0xa0000' (ie. one side is advertising 1G only, the other is advertising 1G+10G). If I bring up the 1G-only side first, followed by the 1G+10G side, then the link properly comes up at 1G. However, if I do the reverse, and bring up the 1G+10G side first, followed by the 1G-only side, there is no link up. I need to bounce the 1G+10G side again (ip set link bp3 down/up) to get the link to come up.
> 
