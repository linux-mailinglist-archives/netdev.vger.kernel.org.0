Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA2EB4AC954
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 20:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238746AbiBGTSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 14:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239728AbiBGTPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 14:15:08 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7C1C0401E1;
        Mon,  7 Feb 2022 11:15:07 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 217Id6Ui025595;
        Mon, 7 Feb 2022 11:14:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=mQteG5LjKZh1ljdZ57jfGqILmywPQd6bOarbh8s1VUE=;
 b=KN3wG91bSzSQQPfP9yqDfwKOURNZqES5jfnr8Hai/mZIWssssTGUkwh6llRmt8zQ8wUi
 ofN7dz+zLrziFDikkRrj3RvVVkuxRmGRJSrkODH7sPNS4x2pm9BSh2AsjGu0bBrFUadJ
 IRUgkSIuF/YT3o1CD77UX6M8efWnD+D8YEE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e2xd5vcqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Feb 2022 11:14:53 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Feb 2022 11:14:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WhI10KmHZx6tk40VhXqtq7exl+pqqmPAs6eGHS96bAMjaBMJsE21iM9T5kukyrf2ZzCd4SIv9w6vhQBYnLbu63aNnWqQo0ERB/x0aQQZujrtxJfsNrKS9brPfB8/SsWm0qtpvGYWozfFoDt0DfrMV8D+tHq4vJbm9k9ppJtZP0GzfLjeVMkgfesEBV6Mh9cfrsng/vEc/3btm0jHhtylOUX4KeEs1gFwRi/ofnLCzUYKFM2BdwX0O4z98zOdoFbsrVqSZqBf39IA4aD5ZwxgjfvSU8IAlhfFO7MyWcIuw8olp9XU/DwQ+b39tzZ2/SRdil530TlL8V2xUhu3HQjr2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQteG5LjKZh1ljdZ57jfGqILmywPQd6bOarbh8s1VUE=;
 b=W9WAro7+0Bu7D26mk2YQE2Khs9gIksCdjF8hHo8hh9choktUm2wO6Nc9NSMG94Zc/w+Y8OP9Zpcgm4U1M1JW2R7vnwKtJeQZjNBdmk1VpeLgCQybwJGNXomtTrBCmA7bdR8n5/9LNUNjye+vnUbjkD/GS+/zaSyqH9vx488veW0dLRF1Dqgb8CmFDLQobeNuD0FXDDTNeHebzQ7iBYs9pyJveiYQ8cJiopxsB3mjge3lxZpX5/YlzvrrXVmDAds3NEePTWrzZo2m6SCIFBKSL5hk/0G8ei1hRUI+pjb78q++QAQxDkgz7wEUw0sCJw6kIkwkV5SFoUHRnEkixxgI6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN8PR15MB3025.namprd15.prod.outlook.com (2603:10b6:408:86::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Mon, 7 Feb
 2022 19:14:47 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0%6]) with mapi id 15.20.4951.019; Mon, 7 Feb 2022
 19:14:46 +0000
Message-ID: <c1f82f36-ca30-2de1-7913-e21ba8cb9592@fb.com>
Date:   Mon, 7 Feb 2022 11:14:42 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next 1/2] bpf: Make remote_port field in struct
 bpf_sk_lookup 16-bit wide
Content-Language: en-US
To:     Jakub Sitnicki <jakub@cloudflare.com>, <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        <kernel-team@cloudflare.com>
References: <20220207131459.504292-1-jakub@cloudflare.com>
 <20220207131459.504292-2-jakub@cloudflare.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220207131459.504292-2-jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR07CA0064.namprd07.prod.outlook.com (2603:10b6:100::32)
 To SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6435a75a-0f34-478f-e556-08d9ea6e1ad0
X-MS-TrafficTypeDiagnostic: BN8PR15MB3025:EE_
X-Microsoft-Antispam-PRVS: <BN8PR15MB3025DD3A5711E983208D2B67D32C9@BN8PR15MB3025.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:305;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U4Z5kkeNnqRHAvqKtV78uh4CjKTZPx6CSB0QxId7Ng/7HeOoixUMc/qe/T8beO0lS0sKne0wVkrckGoLnXfhHAFhF1QtaIvYJga0JGM0mTwOl+n6uluMSasRLgwgihdbdU9KUaTdU67yHmtYk25j30q86xfGNT9f5HviHbYqer3BbZKMd7Gbl5VC0jTHziOPNlvcxNuNXHFrHpXDPVFmEmhJ5mU3QsqcfPTLlwXA8Ji6PtJuMwbf1u8T8k3fUCB/hntTooJxFjLsWRjALPzpxTpG3tMSQBS0EXXSgiljpgljpbywkxX2SO5zZLsJZG4ZxDnpd9hvEK9Rmlv63TfBEbiN6ltZxQcuCirfpFp6XKWS5W7wTrBUaB1t7ispK3GUbCXxfACrVrvubKbi7g+IIY2hReqszVdYrj6OZ3KjRl8h/f9vHKyug+hA/W28TPQmMcue1quP/qOnXz4Giq8Sr11ukMzkWIUkZemBxK+lSeSYTLs+PMGdNBMUcOidM7pWSapsZa8NLE6aQU+FBAHaKwYucfgG6gH5+PlI89AJrnlcF5+0Qao/86ZGv+S6gQC7ulqMKkgAZAKoJA4t7Xm0+2BandVSJ7QBgYIigeCwHc+2tgr0WGCNEijuodXnsAYkYiV/vU86OlkahMYTPM+GrRzbxUvzDhAsCtTuY2TQOvNe/3BJpAQHHym9ggMJPgW8Ggyw3/EylW2H1Mb2SV8ZNF53wNHxV/79hrgkkQJ6W9w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(31686004)(83380400001)(66476007)(4744005)(31696002)(66556008)(5660300002)(186003)(2616005)(2906002)(38100700002)(36756003)(6486002)(6666004)(6506007)(6512007)(4326008)(316002)(86362001)(8676002)(8936002)(54906003)(53546011)(52116002)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFNlaDBPaVpSWFlVWXF1cTMzOS9iWVVRL2duSlJacEVxSzBtYVNMdFA2Vy9m?=
 =?utf-8?B?Rkx0NGNqSkdFQ3o4OTQ5L241bERLbENzbjlVMW82Nk1BdGhEMjJNTk5WNXFL?=
 =?utf-8?B?ZWtxdDVucll4WlRDdmJtSlluTTZRejJISVRGSzhUSWFVaHVuTmlMMDEwUXUz?=
 =?utf-8?B?MWpaNGZXdlFPLzUyRm5lNExXaW1ROEp2UWVtUkpLdVdmY3QxMkVkeHArRytQ?=
 =?utf-8?B?RURyVXNyUkt1bTc0b2wrMGRXZjhNQVZpZC8xa3llOXJUcXV5UldJNUtaRlhj?=
 =?utf-8?B?RE0rYWNGTjI4MitNZHhrQ2tVVmw3bUtyZEFFM05yWmFIbnFNeHM3QWdTU2Zr?=
 =?utf-8?B?OGlYK2pLL3NNdThQVnd1MGczTnpyVVhTTVBTUEFqZENHQTFnLzZTaEs0NklE?=
 =?utf-8?B?S01mTmJLeThEaWtzVU41NFY5NTJPdGFUUEZBUktRc2FpdGZncnAxM3V4MnVu?=
 =?utf-8?B?TTZWc2NUTmdjYkJMczBLZUM1SHFxbzY2UXIzMlcyMnRxMmNmZ01mTE9MZzll?=
 =?utf-8?B?WEdvQXR0YktEQUxRdmd1U00vYkxJOWk0V3pFVEVNc1JXd05sV2tjNnM1a2t4?=
 =?utf-8?B?b1ROMlZKY2NSZDdIUDV0QXV3K2xKRDVSRkhPRzg3OTIrWWZ1c2lvYzlnTGY1?=
 =?utf-8?B?WmtZWW5pU2grUiszZ0ZmeThIM01PZk5ROC9zSjZ1VmN2OFVZeUJGUGg4SHh0?=
 =?utf-8?B?WnRpZ1JtVi9NT2tsRUVlbE9HbFhiNkY1QjFXUUVFY1IzRzRPTmlvaDBMcDc2?=
 =?utf-8?B?bmt6YS9sR2VtWndsSVVWWnloNWNvb1VicGt6Zk5peExFRlVZS2E3Ym9ydWEv?=
 =?utf-8?B?ckxQS3g1YzdwaUR3cVlUTndza2tUSE91N09ZbnVybG5UU0J1MUM5UjNFbXlV?=
 =?utf-8?B?R095dGJ4d3FRTjZJT0VxUExaa25ZaFdjZlhhd3VjT25ITExSRHc3bC9sNDJt?=
 =?utf-8?B?NzlDelhoSmJSQXRnbU10cndmUHhmVFVINUxzYWptVElUdTZ3Q0dhUTdpMm1z?=
 =?utf-8?B?RE91YmE2cFBjN0tZc3kzaVQ4RlZBbWJmS2hXSkozVGxleUUxNm5SRkNBbFNs?=
 =?utf-8?B?VSsvaktDMS94N2NlOHJzY251THhhcnJXWUcwcEM4cTR6RnJ6Zm90WTd4MUFs?=
 =?utf-8?B?a3VDd3hVRG04dDVFdW0zOVpyQlZqME1tbkVEbHpYb1UyVCtjZFlKUGFzRFUz?=
 =?utf-8?B?RVhEWk9QQmpLYk5GRXFIczE3YWQ1WW9VWXZqQVkwNmNzd09OWnp1YW1RcVBo?=
 =?utf-8?B?SDRYdWs1MG9hd2Q1OHo0VEQycE5tVzkyaHBSck5JVk9RREdXemlMcHVjdjlR?=
 =?utf-8?B?SW9FMmNuWmVpT2ZnZkl1N3FXUHl2THZuVmZmajBnZ0YzRzFHYXNvUy9PZ2Yy?=
 =?utf-8?B?Z0E3b1R3WGp3bXpvaGdOdUdjVVZZRnZ6dkpLNDhVQzVZRWp5WkZLOWFPZlM0?=
 =?utf-8?B?VXdTZDlzLzBWYnhKQ0pPTWRmeStBaWY3YnZrSW9oeTFQMG5ud0IxVXdFaWRX?=
 =?utf-8?B?b05paFZYUXBJV3RFeUlVRkNlTzZmMkswTlZoT2xpYmZJeHgzN3BqVFJxaVdj?=
 =?utf-8?B?N0FuRC9zK0gyMk9CNTgvWnN2R3l1VWwrM2k5Rm10bEFZWDlBajRZbUxhUStN?=
 =?utf-8?B?SlZGTE5lNEZBcEpkb3JRNGg1RVRxZ2Z1MFA3K3B5eVhpK25vZDgybnJCTU9R?=
 =?utf-8?B?NVREZDNaSEdreUI0bG1zSFlXWSsvZTJhREorcm8rb0NDU0l4Vlp4V1pFaTBY?=
 =?utf-8?B?NUhJRlA3Z0psYXdPbEUydU9UV3c4Y1RuZy9aUkgvZXNoQkZwRTJ2VllyYWZj?=
 =?utf-8?B?L2xPUEFBdFVIWGlIWW5JVjhTblBNelV6NElzMENZWWNMK3M5VkdFaGdKaTRh?=
 =?utf-8?B?YzJqZmJhNUVjK3ExMi8zbUR2OUZvS3JqazdzMWpvaE5JQUdxUDdBNXF5OTRS?=
 =?utf-8?B?aDI0cjN6dFFFNi9wck1jOSsyUjNSVFU1TW1kTlFZSHYyT1ZLWWdqNlhiQlZq?=
 =?utf-8?B?bTZtd254MEQvOHRPU3NJZzR0V205RjlqbVh5WTlBUkxZNlZHR1RTN0w5R2RE?=
 =?utf-8?B?L1I3QzdSNURhczd0Vm9sNUtNejZ4c1A1eU5BcTFTenhSUHdnakQyV210bUZa?=
 =?utf-8?Q?/SEZxBPHBSHl7rdLtc/4muNrh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6435a75a-0f34-478f-e556-08d9ea6e1ad0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 19:14:46.8085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D5+qyfVDNF5iWsCY+Gxwy0rpboBu1iyGiUv8SKx/5ICW6hzBKM0OUMNIZ22fROSg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3025
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: VHS93yq156ZqAj0UkpdbXLbgfjhXAe81
X-Proofpoint-ORIG-GUID: VHS93yq156ZqAj0UkpdbXLbgfjhXAe81
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 phishscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 clxscore=1011 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070116
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/7/22 5:14 AM, Jakub Sitnicki wrote:
> remote_port is another case of a BPF context field documented as a 32-bit
> value in network byte order for which the BPF context access converter
> generates a load of a zero-padded 16-bit integer in network byte order.
> 
> First such case was dst_port in bpf_sock which got addressed in commit
> 4421a582718a ("bpf: Make dst_port field in struct bpf_sock 16-bit wide").
> 
> Loading 4-bytes from the remote_port offset and converting the value with
> bpf_ntohl() leads to surprising results, as the expected value is shifted
> by 16 bits.
> 
> Reduce the confusion by splitting the field in two - a 16-bit field holding
> a big-endian integer, and a 16-bit zero-padding anonymous field that
> follows it.
> 
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

Acked-by: Yonghong Song <yhs@fb.com>

