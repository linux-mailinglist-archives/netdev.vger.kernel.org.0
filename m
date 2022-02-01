Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A942B4A6734
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 22:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235105AbiBAVnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 16:43:46 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4332 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234840AbiBAVnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 16:43:45 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 211HDh4I013147;
        Tue, 1 Feb 2022 13:43:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 content-transfer-encoding : mime-version; s=facebook;
 bh=cCoyFjhQHc/WsWlc1j2XldBmq5CL1pW+FNil3wXh1y4=;
 b=PkeDM4iGJSwINPxSkRoT5MhF+D/FdNf09To0uzqAOIL+nv+h/MVJooOGb32yZsBiOY8q
 IcM/OJ5EOHBtNRiskkZzkCILtE7Y8Y0YcvKgpTi6N/xBMAwx748qBTgDHiTkFMupwSm8
 lcTATKYE9gWU/6cdPVygVi1lqfTVBN9K/bo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dxm2p961f-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 01 Feb 2022 13:43:26 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 1 Feb 2022 13:43:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HuUbjFwo91jii4odhKCRlcA+2pchsZcuOGKAmkT0cvxbbQ4JN+mBqzPu1OUn7/ZaGL+a+IEB7JSYN64bMqrWxcI37z+84qAeL5GE74CUUcjjO7jS7MbKbsaI7+7/99CHOHzq8l0RblkC7I4xvRkfcx45o9wbvGi7r1DO0k6HNNUeDUuOxDmKcXk/f/TY6FjWet4SqJg5yusHyLVZHfpLyRcoDSLfiEL69vEbO68zNYZo2uIAPmsoZfUDTrHQSKgWYk2MPOMXH+itoCa7blMDBOz2q9IWBLgN111JMTOH4ju8OBfnmdpPaYNVvdi0MHrapZotWeL4SGN4yVXLvxd9ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cCoyFjhQHc/WsWlc1j2XldBmq5CL1pW+FNil3wXh1y4=;
 b=ijQKqSuT8NWN6alnsWeCOHmb2ecgdfcxRFdgaVuAOzKGG0Ndk67JMoWabdGL5uQUhTnVQ2NXdLUMmMXessT2bLjEOqwtOiQteoZUHSYXwFxcInKBcf8qN8oPGFfWWXG0ARagLJPKSSeTzsVIuMFs9dIptQHD6pyeEEcmAI+QqZIoPazkEoXLE8OLn1YrG3knl6CXRtVa+Oxx7hpmP1QK0M+tfkT6Dq1qgPWwZ0mouRZKnIRgReZNhAYnKzAyuy+AVm1fTq8l2F6WMAzcn3Q9LGcW+Jd5q01OkPHfc1H0rzy9DGrbrdiFr51clyvMfniaCddYfb9dvjD6Nxj+GIphTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SJ0PR15MB4392.namprd15.prod.outlook.com (2603:10b6:a03:371::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.22; Tue, 1 Feb
 2022 21:43:21 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437%6]) with mapi id 15.20.4930.021; Tue, 1 Feb 2022
 21:43:21 +0000
Date:   Tue, 1 Feb 2022 13:43:17 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
CC:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Brian Vazquez <brianvv@google.com>, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH bpf-next] RFC: bpf hashmap - improve iteration in the
 presence of concurrent delete operations
Message-ID: <20220201214317.fbqhpgewlhqvegob@kafai-mbp.dhcp.thefacebook.com>
References: <20220201183514.3235495-1-zenczykowski@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220201183514.3235495-1-zenczykowski@gmail.com>
X-ClientProxiedBy: CO1PR15CA0066.namprd15.prod.outlook.com
 (2603:10b6:101:1f::34) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce5c82b2-516b-4318-1b08-08d9e5cbdda3
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4392:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4392C59EC482831D977F5401D5269@SJ0PR15MB4392.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hT+HTxwEFlCq21ezKaOKhWTdDWPybfExNusGH75EtEXRxogWPR+PNCGvucmjFYEIk8w7CP52yQGkzht7WqJ27W1DF8JPGeiku0LWFmNQrLZTCXxGX8UXCQU1lrlUUDQ1aKqTIzXoqCOF+w6voMdWvzAatZWRoSWp40rZTjEkHXFaiWpmUqsR0Xcrh4/p1wI2b9ogRdNfVRupcJkvEhGXGO0VJgleMC5k1QaB2e4PO3pBVKUidnigQTT6AIaHzpHEdhM3zejKOq2iwCS2aotiwXnskBl2ypMnttzHLBjnLIueaJ8w2CvMUuggmxwpNBPxOKcWFCwvK7ThVwdybQ9ZjL9R2adWGbW5yWc6iYe4eIz6VGS7om3rZEsSvhYFhpWr38pugVDRM66zhD3KG+/BEKsGRpCuhijFXRtt95z1zsVmoD9KMkGxAtswyMNLMuFZYDyTXoKK3E+EXkZnoJw/56nASGJinyNqRpc5YUy14cP7+nBBu0eCiw2uJ2NWPhRp+OWJ7eMK4Unq1OHJS/1nyzdRqiCrgO/xQjt8g+OOGQLhsjpSuiVm2TrmL/99+2wIQmAHFNxiYRotgg9tz7DlJ5nZfyFRs039UJlQS/Kd5LT41c1zFs7CH5CmzqbLn4uHMWTamw1oU5+BKI726cyFQL3NEWdGCOgECCf64e+Z23L9F1nqWN+jVFMZvxKaNnnXvDGnPDB/+O7vrv1wVcNwIUxgIItuEaxMsRjqlMk3920=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(9686003)(6506007)(6512007)(52116002)(5660300002)(186003)(1076003)(3716004)(2906002)(966005)(86362001)(316002)(38100700002)(8936002)(6486002)(6916009)(54906003)(508600001)(66946007)(6666004)(4326008)(8676002)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UURmUXhJZUFUUGZtL09MeTRlMXdVUWtiNnVzZ3c2WHNldkN3RTFocjd0R3Fr?=
 =?utf-8?B?SmQzaUtGcmJZMEFSdFZ4TEE3VmpzUG9mT2NGMDFtWXhQNUs4ZWZFNEJ0cVp0?=
 =?utf-8?B?aHlhaVYwS1pKYUZuTXlBazRZNFVtYy9ZSnYzRjY1MUtIVmJYVS9XNHVScm9t?=
 =?utf-8?B?a0xLc0pkVVpuTTdiNEQzcE1zbFBYcjNFQkpXS2oxK1F1c3dIQVFJUnFuK1FK?=
 =?utf-8?B?L293YnBhSThnYzBkeXVBNUhlQ3E0bm5DWVpsZnUzcjFXRHNjdCtvTjhnd25P?=
 =?utf-8?B?RThabk43UnlNUVpDUGhRellTU09KeW5GM2dWNnA0eEdOcXRZUHlHUDFjQU1J?=
 =?utf-8?B?bWs4eGVRR1h1L2ozUmdDZXJvRk5QQkZudURyRkMxMENyVFZVSHl1a0s0RUFD?=
 =?utf-8?B?QUdiMm5VODN6MDdiN25jd2Qwc3pZTHRZKzZIRWYyUmZyamdrd2VBUyttSjFz?=
 =?utf-8?B?VXNialBYT3FwdVlWMWdOK2dOdHVKMk1TeW9FbFY4bExDTG5lelhmTUVHTitN?=
 =?utf-8?B?cko1WndmRHo1dnpQTmJQREl6VmgxaWQvZXZ6dDE1djZEWi9mSmtRaTlRc1U3?=
 =?utf-8?B?dzY5UGc0RGVYNXhyUmNRU05lb1kramtTRkxSVStmYmFJNnBzRitWTkRsd2dY?=
 =?utf-8?B?WUJTckI4QlBTdWtQQ0lMOGU5SUVWQWhEYnlQQm1LSXZlL2s3Z2h6NUR3SGNu?=
 =?utf-8?B?cTNmVE1BNlZIa3pBT3c1K3lJVEd5cVlnbVFQYWFKSzJWZkxBRjRrKzd5c243?=
 =?utf-8?B?VnVyaTBHTkdCYXloSkVFWTR5WEo1T0FTWXVpVkVMc0QweCtmUkk3b2Rod1lz?=
 =?utf-8?B?ZzB3eHBsWlJFSlE4RFJ1Mmgrem1EaWVVMEZYbTZWSGl6Y1RYSGhnZEtHdnBL?=
 =?utf-8?B?VSs2aHRKOVRvQTZ1SDkvTEJoVC8yZXdDN1cvZU4zaGV6T241VUMyZWlGWWlj?=
 =?utf-8?B?NUNDVE1sQVliNFNwZlFtVWVGSHNnZzhvWDVsOXNYdkRZUDJhcHhJV1VGeXVp?=
 =?utf-8?B?eUxoeDl0RXhVNWZaby8vR3gwaUVubXFiYjZMTjdnQ1FTZmxqT3dScms2d3pI?=
 =?utf-8?B?aDBmQjVuR0VpVk11VWE1YnBMYWdRRWl2RGdKQkxJVkl0WE1DNDF0b0hzUHBG?=
 =?utf-8?B?UDdYaUZXN3B4dG13RnJjNENVN01qSDJYNUdKYWVNeGEzZ2VVYjZBcldqK1dh?=
 =?utf-8?B?eUFLc1hqUWJOTHpJR3M2c25iZFJSQlZWRHZOSFE5VVQwSDBKbnh6QzU2L0Jt?=
 =?utf-8?B?aUI1MFhnc1NDcm90M2FiZlFTcm9qazhtaVRVbzNObE9ud0w3K0xkZnY0Zk1k?=
 =?utf-8?B?MGNDdTMvWVkxZXJzc0lwUHEvYlUzYkNmVHB5U3JJVW81cGFnWjYyWUZiMlZ6?=
 =?utf-8?B?VCswNWFBQ1JOV1d0T0NGRUpBUUlSSWEyWFBSY2dpcWxjblRsZVYyTm5JeUI0?=
 =?utf-8?B?MXpXMFJJdER3c25nM3pNODFaaFkyeUtLa1B1b1hjbEpIZU9BejYxOGEwc2Rr?=
 =?utf-8?B?cGQ2bW5NY3pURllMc1BWOXlJbFQrNWxQcFBBckk4enFwS0FzdE1aTE1CazF0?=
 =?utf-8?B?WEtFcXJOeEFKUUhlRXRKeGdMVExKbWF6TzFEbzAwUlA2TjFtYzVZWkpoU2Qr?=
 =?utf-8?B?SnREN3o3WXpsalkwS0VLR3dweXUwMWFnUUQ4dnI4dUx5emtyWXY0L05Fci9D?=
 =?utf-8?B?d2pDMHlQc2ozV0lHRFRwWjVobXRkSDlQeW9tNWFYTE9xM0lHSkVrOG5TK3B2?=
 =?utf-8?B?NjcvSDljaTA4UHRiMHZtOFlPOW1JbzJtYkF4eElLLzJqM3RnbG5aY05ZclVl?=
 =?utf-8?B?QlJUVEVRck5YQkNCSGRvZ21Md0czLy82YTNEZDYxMWRvd2gyQVBZTXpEdUhm?=
 =?utf-8?B?K3RWcEthTXVRa3c4d3p4Ulllb1hVU3ZmTUsxRUoxMVkzWndSemxScHd1WnpC?=
 =?utf-8?B?N0ZNaEhSSldxUEVKeDhTaUxvdWJ2dDNDSkdzQTAwVzlkVVVpaGZnVksyUjBR?=
 =?utf-8?B?S2VCWjRzYTlHanBuR1RYL3YxU2dReklJSGEwZ1RRQ0JRMFRHRnh3NFRmNzVa?=
 =?utf-8?B?S3NLV0FpSTRCbHViUXRhcnc5RklEaHkrYlU5cmdiL1dBR2xTTnlmRUtLSGJD?=
 =?utf-8?Q?rpOkEU5Ti5VblCwdHBcWieurR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ce5c82b2-516b-4318-1b08-08d9e5cbdda3
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 21:43:21.2023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PY9hPQImGlPHRnKCgglIgrK0SSE4XId1T8hWR7bPG9T8PBLyyrRa2MHf/MMuxOJX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4392
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: _Yx5TP5UxOqHzHfv-XVFDxhAtkd8zmQE
X-Proofpoint-ORIG-GUID: _Yx5TP5UxOqHzHfv-XVFDxhAtkd8zmQE
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-01_10,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=1 malwarescore=0
 phishscore=0 impostorscore=0 bulkscore=0 mlxlogscore=194 suspectscore=0
 priorityscore=1501 spamscore=1 adultscore=0 lowpriorityscore=0
 clxscore=1011 mlxscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202010119
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 10:35:14AM -0800, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> by resuming from the bucket the key would be in if it still existed
> 
> Note: AFAICT this an API change that would require some sort of guard...
> 
> bpf map iteration was added all the way back in v3.18-rc4-939-g0f8e4bd8a1fc
> but behaviour of find first key with NULL was only done in v4.11-rc7-2042-g8fe45924387b
> (before that you'd get EFAULT)
> 
> this means previously find first key was done by calling with a non existing key
> (AFAICT this was hoping to get lucky, since if your non existing key actually existed,
> it wouldn't actually iterate right, since you couldn't guarantee your magic value was
> the first one)
> 
> ie. do we need a BPF_MAP_GET_NEXT_KEY2 or a sysctl? some other approach?
BPF_MAP_LOOKUP_BATCH has already been added to lookup in batches of buckets,
so the next bpf_map_lookup_batch will start from the beginning of
the next bucket.  Here is the details:

https://lore.kernel.org/bpf/20200115184308.162644-6-brianvv@google.com/#t
