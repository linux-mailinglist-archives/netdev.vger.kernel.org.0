Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D156D62546B
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 08:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbiKKHal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 02:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiKKHak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 02:30:40 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4023F5B598;
        Thu, 10 Nov 2022 23:30:38 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB25usS022459;
        Thu, 10 Nov 2022 23:30:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=xIop+/tJ1aUvuJOPYH/3vx+Ci0xJ7+NK08Gw5F1yFHI=;
 b=SvhSK7qDxQosU8CAXfTfn2R4FfTDwU0RApStt68MHzuNVlEkDE8Lk+qplFNXVwVnTFjK
 z4DPgMWBAy4EKWlE4pvswfMrYeDXnIWH6+ZY0K3FPAzPZazRgBRTJ4P8wDKrY5nzuM+T
 5MMZOauWPFiNZefN5eq9M/ukk5a2EAmwyLBzpMeXi4YoosLF6i0aHlKT2bkB+evZvLVx
 dva3/b6RFokKXrlgJMuGo956DDxNkmGXNbwN7NPWoVmnUdIDWBBYdqOsJMAUPin9EcRh
 y2lrma/W+vq4Dh7ZVtV9zC2oahf4Y4c3dKokAfpoxuRRvTpsS0aF+yoRt4EPm7m2gePi QQ== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ksda8sjmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 23:30:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oa6tV7DU80BzK9HuAATU/t4PDFzN0KlbgMRxIXoVB15PMbU9BIlTHwYn6wcrMD1T4MyReky5fkV639E6I/SCpt0VNgHsxbsSLcPr3oeSmFtedWz23EiHWi/TCFLMf72Mqsdjrm7FJxGlf6Ygth8R1qmZk2TfCcfYy2ZTVr4c1j7bWTzBczSN8D8WWW8eNkR1QTjcqNYREalUczflMQixxF8OK98zpfBDmaBFAfa6iZSsMlI4c1WKTEHdeQYtXQFT4Gzz8zwji62TN3R0KjY0iZWIwOGpu/GLB3k3VV4iKd8/pj0YZXh+/KKRHOnnWFPOxKZsKrMzHmeuSdYWSzRqww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xIop+/tJ1aUvuJOPYH/3vx+Ci0xJ7+NK08Gw5F1yFHI=;
 b=Sz2ELo+5wqFFIgj/nJMgZIjXGraqrLfKLpQrvuCH+UHY25JqHmbs1dOEdMahesLlYCBDCv69D69nXgfMXI+ETg+sfX1I5AIK9TZcGSxfVmCDx08dzThu/hR0LWRykHtNWVQpHHNNWg27Fj7p+SlXqtp4uHfx2tt+W5+QOImSWmeVSxJDkoWf2BenjCthLyKxwZQ3aZESI9KUu1xBGGiE6QT5N/QlXP92REFWMN84H+thZNzpwbPMTaFmfkC2LQxWZ2CSUlBU5G+3CNqdFsj5t0WIuOSLXmQdIipMYOiKqhjK0AtuNOMQV0q+7zXXf34YwDtFBHTKt08ILVjQy0F5OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM5PR15MB1913.namprd15.prod.outlook.com (2603:10b6:4:52::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 07:29:59 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::ac66:fb37:a598:8519]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::ac66:fb37:a598:8519%7]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 07:29:59 +0000
Message-ID: <83637fd7-5daf-bce9-80e4-85383fafd4c9@meta.com>
Date:   Thu, 10 Nov 2022 23:29:55 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH bpf v2] selftests/bpf: Fix xdp_synproxy compilation
 failure in 32-bit arch
Content-Language: en-US
To:     Yang Jihong <yangjihong1@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, mykolal@fb.com, shuah@kernel.org,
        tariqt@nvidia.com, maximmi@nvidia.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221111030836.37632-1-yangjihong1@huawei.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <20221111030836.37632-1-yangjihong1@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0179.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::34) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|DM5PR15MB1913:EE_
X-MS-Office365-Filtering-Correlation-Id: 10771cdd-0717-4c44-ab81-08dac3b689aa
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YGJ7cs8luUdHDhlWBVf+uBMbuo9dKnGgcsh0K07QAkwRnbfiaUSv6prhvm3uePYgMOqI4EK8WYUBSFQVifixix4miNtG/JfcVigMeFEzSaVI3d2B+48pgpWNSbnVvbjOSsX367Mzr+Aqyg57G6M76mA7GKTOQcOvSIi1Mhtor7ynC6JGhn0dQBYgaBPvI4CqSuY44LSQmKq3mv9TDZpxebe0R9D9Y1V/i1ULl2jbD1c1UKO5vZlX7kevu0hwzx+8c7OsDgzgGCixhBrF4EdtM/bgPVHJ8M4PLB5+1OVr+oLEI54lachIsB/lQIA7d1Hi+dyJRIK5k7AVpLhw4A23Wore9AjcdOFpcURHlW/4LSrwaRvRPBwDU0utocEe6An9rHqMgQCZ4CIZ01stVcatbJ97cxvwSR4xZ71sPXwagZ5xIxZrO79hg82tBloH5S92LEx9buKC4sDqE36rBk3cShxjMvttpXzWhF0/46i5ODB7mQwTm6+guHzhqDUfCK7gKUa9xfPngbMPGa+b0lcce8J2qxqY0iuBOau8l+dylGeDwv0RSktk+1m4ePmyRC7HHenkR7357CfupC5jBd6FX8WMmhgBQ7xqjOGJHbTlg9MoTFhpTfPO8256H4DE1eVtT/cWwYX0y5U0e/M4jbaurU3yC/cJAZ/TLScsZ3+azHuhUXCNzsnyRAjZ72bdDgQcfVgUxHhVcThjmpEu/Mphki4EVAagY8pbXFlPg1Pl0HekaBx+INGDBfS1x9QyzUaXn14V8U6FHpmcMucVysKynmx1SO/vr7GaXnbnATN8qYB8sHvNbN9UU5UxZTiu+WJd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199015)(38100700002)(4744005)(316002)(2906002)(86362001)(31696002)(921005)(6666004)(6506007)(2616005)(53546011)(66946007)(66556008)(6512007)(478600001)(6486002)(8676002)(66476007)(36756003)(5660300002)(7416002)(186003)(8936002)(41300700001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2pYa1JjT2lsdGs3YnVMbHp4NEovU3MvSGFXL043OXg1WFFBajJrZ1h5c2Fo?=
 =?utf-8?B?OGlUUDh3QjVjM1Jlc0NOc0luZVA1dEFhNTEvNlRlekl3Q2ZZcmdSamJTT1po?=
 =?utf-8?B?aXJHTnNCSmVyNVBLM1hEWUdWN0xjV0h1SVhwMHJRUmU3RC9EdnRlUnNoRjM4?=
 =?utf-8?B?THBmUkFVenZxb0pkb0MwL0hobUxCanJ0UXdXVmxxNWNRRGczR1dMMEU5NXFZ?=
 =?utf-8?B?OFAwSFRRL0ZvUHFGT2NjZUgvRjc3SG9ONVI1TlpIMjB4V0h4WjcxU0VndDhp?=
 =?utf-8?B?SmdyVmsreTZUTFZFdzdzWEdycTlaOFFrb1lZTXlpUzk4dUh1WWE1amNkUTlL?=
 =?utf-8?B?U01HcTNoZEJVZi9adlJtbzV0WVducFVGNlRod2dwcGtJRDAwT29OS2g5cUNG?=
 =?utf-8?B?UGh3ckFVTU9KNkd0RHY1cEtIOExPek9yRmNEM0JmRWlFQ210N3ZUYWZwbkVI?=
 =?utf-8?B?amJ4ZGFpRXBwUExhemtIbUUzaVZyUUZNdlV0b1R5dS9FNFNaWkxvTjV3T1c1?=
 =?utf-8?B?L1RYWGQxcCt1bTI4TWNCVUdEY250VzN4V3BOMUtXTWNacGQzQmJyL3JmU1BW?=
 =?utf-8?B?enBjSStEemxlNlBIMzFLeW9HSGc2bGFJTDdaM01wbi9jaWlLVElEcnpWSTU4?=
 =?utf-8?B?QTIvYm02K056c3FGaU9sbWRGeW1KM1V1cEFLOXpYYjBVZk5PODdCOTY3UmVG?=
 =?utf-8?B?cVBGaWp0MkFFdnYyREZGMnVkQzR2VjQ2YlliTi9XZ0VFMXdwUUp4SWpYYi9r?=
 =?utf-8?B?WmZxOXhiQWdmanFONHF6QTUzbll3cTBSeUg5STdzUlZFNURTUVFac2QzWlRo?=
 =?utf-8?B?OEJZajBCejJ1VjlhNG9ST3NVRmlUd2lYa013bzF0ZWFuUXBKWVFQRjVzWWw5?=
 =?utf-8?B?QTJXaFBaNE9kL01SWllsSzN4UTBVN2NEci9RUEVkZWt0cVpFQWplK3Y5RS8y?=
 =?utf-8?B?QlEzODAyZTZhTm1wek1QK2FNanJ5dlQ3UWMybVBQcHZSY1dkY1FFTGtyMTMy?=
 =?utf-8?B?cmdkS0lqM2RuRW1qMnVXTVVjci9SUXJNSVBaR1A5eWtMMzcwOEN5bDBvK1lh?=
 =?utf-8?B?SEZ4cll3bmhuK3hmMFgvZE5CODBZTGhzL1lGdmN4cFc5dHczQUZoTnpNbXVT?=
 =?utf-8?B?TlN1K1ZHT2VEZjBkbW1GNFdpTk1xbFNUby84SEQ0WndWMXdnMXlyS3AxOHpQ?=
 =?utf-8?B?U21makN2OFZsU2MvMTRaNGFVYmV5ZEs3ak42RHEvOGVYRjNjN1hvL0xLQTVn?=
 =?utf-8?B?Z0JrVUhpUEZIcThGVm8zREVqR0FWdW9Ea0xqamkxajlGK2UrbThrZGNQNERr?=
 =?utf-8?B?eTYzNmNLRWgvbE5aV1JuZTF4djlTZEd2SUFLaEJFcHo1U2VBUzJpL3Z5U1VQ?=
 =?utf-8?B?MFA0Uno2emoxVUFtdWowVTE0NXI5UEJldHovNWpBRlhzQndtWkxJa1IzUUp0?=
 =?utf-8?B?eExXb0U3ZzNwNGYreEYvV3JIbXNJdVVTOVVDWnpMekQzeDhxa2dZMzB2cHVv?=
 =?utf-8?B?eEYyVTRIYlY5TjVXdjF4M01SWHZndlFIRGZYYVhQbkJJMy8rdXB3RmVnMkVu?=
 =?utf-8?B?OFcwSWN6WE5YODRyK2pwN1pvbTlSOUhocWRtbG42OWd2dnl4TU9hMjZVV210?=
 =?utf-8?B?cnBOaHBjV1FpL3A0dUZsMVM3Z3ByaUY3NExNUzNUaWtkWXBjMEFncExmeU9P?=
 =?utf-8?B?OFU5RkZ6TndIVHJ6SVhVZnRuWmpmSWZIcWNLSGF2cFNEalNuOGVNTG1LUEpj?=
 =?utf-8?B?eGp3NmdNQ1hzQ2IzNVh6N1JqZG11ZDRpd2xsMDNEUWZlcHoxV3o3QWJmY3JC?=
 =?utf-8?B?U3ZIQTBjNzQyU1QvTHNCS2lMZGVZcUZaN3lVdU9sSmRMbndoTWtyOStaYTlz?=
 =?utf-8?B?cCtvWTEzeUh6aFZBeHAyeEt6QTNadkZQcWJudnNqVHlUWndxL3RPU0MzNWgx?=
 =?utf-8?B?d0N1VHBHNXN2TDFvVW40RHFzWDFISU9sM0wzN3RyZ3dxK3VsOFR6ck1nVUcv?=
 =?utf-8?B?eVVjVlRodFpFcFk0dUkvZzcwOW16VDdIVENxRk9VVzliRXFSTG83MnJnTVR3?=
 =?utf-8?B?cUxFZ1gvaW1IUW0zMUdNZ3ZLYzk0SWxWZ3BRc2xyTHlzbHA5K0VkQ1k1c004?=
 =?utf-8?B?Rk11YmwxRytTaHduYWMzd0hlR3IxMVJ5dTgzemt3RDd3U0lqV1loOS9hOEYw?=
 =?utf-8?B?UFE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10771cdd-0717-4c44-ab81-08dac3b689aa
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 07:29:58.9974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jok0H6KV8r3OSir/GOBAMG8mI2rRG/lFENfrPNZ0PKrbRN0JecFqLPyM4kIIZcp+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1913
X-Proofpoint-ORIG-GUID: E82RzcIbQQpO6KemDaAee3TVk0aLTqll
X-Proofpoint-GUID: E82RzcIbQQpO6KemDaAee3TVk0aLTqll
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_04,2022-11-09_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/10/22 7:08 PM, Yang Jihong wrote:
> xdp_synproxy fails to be compiled in the 32-bit arch, log is as follows:
> 
>    xdp_synproxy.c: In function 'parse_options':
>    xdp_synproxy.c:175:36: error: left shift count >= width of type [-Werror=shift-count-overflow]
>      175 |                 *tcpipopts = (mss6 << 32) | (ttl << 24) | (wscale << 16) | mss4;
>          |                                    ^~
>    xdp_synproxy.c: In function 'syncookie_open_bpf_maps':
>    xdp_synproxy.c:289:28: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
>      289 |                 .map_ids = (__u64)map_ids,
>          |                            ^
> 
> Fix it.
> 
> Fixes: fb5cd0ce70d4 ("selftests/bpf: Add selftests for raw syncookie helpers")
> Signed-off-by: Yang Jihong <yangjihong1@huawei.com>

Acked-by: Yonghong Song <yhs@fb.com>
