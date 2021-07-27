Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C363D7B48
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhG0Qnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:43:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11100 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229441AbhG0Qnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 12:43:42 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16RGYseR004925;
        Tue, 27 Jul 2021 09:43:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=6F3hPol+47Un0QJoBq8SBDB8EqXScSgTc4BXgW+7/rk=;
 b=L+J6M2zMua9ko1NdS+AknfAzRSZkPy1K8Iak6Owk3X0opaSZqaTx60N1nUb02OkqiLxI
 RM/ddAYavMLXoZXwZu3mRJE4VyzFr2swihbnptknZNKEpRtUQwkw9N+aGWgeYEgZXxcl
 h1+qCO32h71i0yXZZOn4GGWMLy4qhs9X60Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a2356e52x-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 27 Jul 2021 09:43:26 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 27 Jul 2021 09:43:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IqGtDe+yYhHyyovumxGikw+BHcfpAFp2v9dd/SaLUa3tgngRz8GEstIBzrrEoOp01Rfta2qh/QIDm+b4jg3GiMkBsGpvobURks6vkO2lCH+JOA8qcitvb4g9CghIE/mEQfiJ00dhZBUqt2AYzcLjCIc4xSo6tfGOmXaGW79xn3WVJXBtbZD7MfFvBf/71fFhjIh1m3Qdee4iQFAJII9+O7PKLrU4brh4/Itvyfy8VmGj0D06l6J0iWIqZP/fTMaS7dzTuu2WYZgcKSkiMWC+CIwdjk95s2a1bOFCWLg9YIPzTCgqNfJ8q/mJAXiBdCL5M6VXy73lvdm2oiFdwDgMbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6F3hPol+47Un0QJoBq8SBDB8EqXScSgTc4BXgW+7/rk=;
 b=lsSUCgk8RevbE3+l5BmdekeoAkGGvDNXwEXG3OemGmWabkGC4edPIRp9K32wqUQ5Q5DHQpdGhn9u7JncQUmj5potGxH6s7lcCJqkyr3BEjxx31124sNNYR5wIRkMlboXiTNbsPKJXJOHs6yRoppw3mojhaKm87XkS3CR9EHLWRF7JH5RtFBDxiEsBDsHmR2vWuqplgyY3xyBuyiKcw8Mc5myXpnp0F+yvLjk3nJA86B9C1U50dNVtgwN+qWBc9VC4cs/13NiIuK/dyDDWMRlKmg62aB1wLi2acmDveZpnzVzd4r/rE9P6OsbVfOHjWQ2LesQJyzG4jfg2Jfn9TS1yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN7PR15MB4240.namprd15.prod.outlook.com (2603:10b6:806:109::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Tue, 27 Jul
 2021 16:43:25 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 16:43:24 +0000
Subject: Re: [PATCH bpf-next 01/17] selftests: xsk: remove color mode
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        <magnus.karlsson@intel.com>, <bjorn@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <maciej.fijalkowski@intel.com>
CC:     <jonathan.lemon@gmail.com>, <ciara.loftus@intel.com>,
        <joamaki@gmail.com>, <bpf@vger.kernel.org>, <andrii@kernel.org>
References: <20210727131753.10924-1-magnus.karlsson@gmail.com>
 <20210727131753.10924-2-magnus.karlsson@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d152389f-815b-34f9-b6f4-a4cb6377ab4f@fb.com>
Date:   Tue, 27 Jul 2021 09:43:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210727131753.10924-2-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0013.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::18) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1398] (2620:10d:c090:400::5:4698) by SJ0PR13CA0013.namprd13.prod.outlook.com (2603:10b6:a03:2c0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 16:43:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 808f9c46-602c-4058-f2f3-08d9511da706
X-MS-TrafficTypeDiagnostic: SN7PR15MB4240:
X-Microsoft-Antispam-PRVS: <SN7PR15MB4240E9C38DC2C029B177EF86D3E99@SN7PR15MB4240.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:83;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hJ1vue1bsz5QvFmB2kXyzOAEmiwKX7KnkVvYtlKHKu+iTDMBc3qyejwB0Bf8JoM7UbcycatKeGwzg+EdcFobRIhJzSsCmAnQlvmVUwInidtNzeVGtyYnLGLEz7B/IYx5HROTBN+aIPJ+aecr5gHCspS/+DQ7UWzfEMRYZRnkWhTHotp0QNUDODwtF/i2GSgvMjX6roGJXTYVI5i2ylRMSLMmVR7Cgx9Fb6T+1d3adI+aZXHotL/TmYWwEoKFu1dqKg5n81CjWp1U55k6REfrsLIuIJxmMOjmXFocAAZj8Qjph8c7M544XfnsQcCrnw3rHqf3yOtQs1fWq9jHnI9fnijzN9Xf0CC96fTaKogqPNKA8yys8jJIls4JvG/dfhjsZeGnIYfvX2KccLuyFVh6snUrV740ETOnTuPa4u4reIckZWJ1yAQCFQW5fPMVNitsDurGh1B3wf9TkW3gtP+3fLOkGtQP3mUBm00NxjaIsslpbKxl7MpcLqKBBnVP25m79KrUB3VHa7Ze6HxfQyqouURSYf6n27GKZJXLeCfrC8Q8TwNsWn0keCcdfVYEljM3eXwQ4HQgYDYby9p6VOFgeMvfqmJBqWMkHJpH3vco/T7+lGi+4wLa62Ne5HIqgk1ewx/NqSo1st2llPlP8jnkB/7Hv/LZ1jcnR/FbdjA5AzgbLolP6nVO4gFunKvPE4+IvnK8Eai7OY6DPAcquZGsc9WzW1IDk8jJtxvgmC0eEu4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(366004)(346002)(136003)(396003)(83380400001)(8936002)(66476007)(2906002)(478600001)(31686004)(66556008)(186003)(6486002)(7416002)(316002)(66946007)(8676002)(2616005)(38100700002)(36756003)(52116002)(31696002)(4326008)(86362001)(53546011)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2tSMzJ2MGx2K0NBbkQwaUNXL1QwS1FCd0VQYURRWitOcFprVWoyVi9TSWVL?=
 =?utf-8?B?K2xabzNxdEJsenJHUll0YjdPb0pHU25KNlA4VzZDRS9wS3pFRUVhQlhhYTFB?=
 =?utf-8?B?UzZwWHZLVHRibm9yRkh0TnpvWDR3d1RMbWpoYWoyS2NMWjAyQThKQTVESEFt?=
 =?utf-8?B?b2N1MTdXRTF6SDRpbDE2cHVpQUNTZ2s0Rk0yemZrUlZ5bjRwYmhJVWFCN2pv?=
 =?utf-8?B?NmZYUXI5RmhwclRJdnpLOWJGUlFtQ0RoaXRMZkVmaENFYm1pSFdLaWQ1VWk3?=
 =?utf-8?B?VEplNFJkaTN2MkZnZEQwUlJjMDZRY2tiM0lNTncwdFZlSWN2OUNRaWJwM0RP?=
 =?utf-8?B?UEpYMUZJREt5bjZGSTF2L2lld2tEbGtzaFdQd3ErRlZiSytTdkZTYUNLZjdG?=
 =?utf-8?B?N3poa2VkNTB2TnA0NEFKVE90blpGMGJ0ME03VSs0VkgzSTgvdERkbk14bnhO?=
 =?utf-8?B?cUVjTEhHMzFpYmZlRE5EVlBSTzNVZ3dIODZ5ZisrTldHQ2lPUElJWXNWOUk2?=
 =?utf-8?B?SisvaEs1bXF3ZXhYeTFRcXZWZERQbGpEZWZBZ2Z5bjRJM0c4ZmFIeEJTUW9v?=
 =?utf-8?B?OUdPRGpWRTgxUDBVaG9GMkdCL0NsNkJNclozTnNYb0NnemJDazI5Mk44ODFa?=
 =?utf-8?B?TE9ia0VGSmlxVDIzNHE3aDF0dXFBb1NyQkx1QzlwSUJ0SUVYcHp4Z3dtakth?=
 =?utf-8?B?NW9VaHdrbFhWVlBwandRYnBNMWZUMHVUS1pTQU80QW85M1pFRDhUak4wM3cy?=
 =?utf-8?B?TkNuWWVrbzY4L3BZNmFvbVUvUlI5bUFhclh1S3VJaFZVVnNOZWJhY1hRaGU2?=
 =?utf-8?B?MVBlTTJaNlNud2Z1TjdkZVQyU1lCUENhSHBXbWhNYkdRR1VuQ2VPOGdMVmEw?=
 =?utf-8?B?V1dXL3ZGVFRreFFwZ2JMaTJubVpienl1eE1KeUdDKytSRkJmTE1ETTZvZTNO?=
 =?utf-8?B?dDllMlc1SzJvK29RTnNkekZudm9HTUpyR1d0WHJFd3Q5cFl0VGZUVmcwYTlL?=
 =?utf-8?B?ZmdlNDNPNGc5U1RidVF1bE5LLzlGckxZOEJwd1luQThTYnZxZEptZzVpdXpn?=
 =?utf-8?B?TElIekVCWTd5RTJiQlkzOFZyYXlrdm0walFlYnlyZ0ZNdEJIQ2s2OFFDdlEy?=
 =?utf-8?B?a2FkazdudnlGS3B2VytiajhSY0ZmWFVVS3V3Si90NTVKdWI3MDc1bGhvRlpB?=
 =?utf-8?B?QnVNaU4zUi9kNlJjd3hXa1hiUDdiMWFiUDJzc2dUMWxBSVBJZUc4YmQ0ck9S?=
 =?utf-8?B?cjFmRXYwV21DZWFja2RPK0xxTHB3M2oraGRJakhHbFJlRXZXOXFyZ3BqTVdY?=
 =?utf-8?B?dHlmaDVZTU42alJLSjRFcml4d1NmOUpBWlFnaXE5L1BoV1VreUxsWU5HZnha?=
 =?utf-8?B?Q08yQmhFTXFkRXNneGtYL0hsMXFHYTFmRzF3ai81NTRvUjhaa3A1R3NNTXFX?=
 =?utf-8?B?d2ovY1ZPY080TDhKL05BZDI3UlFNT0N5S1lRSTYwQ25ZWUJJQ1RjVW1VLzho?=
 =?utf-8?B?U3lXb1VELzR5WU4wRXZPUXF4elJINTN6VHBnbWJUWktBK25pbEpDUEpWV0NW?=
 =?utf-8?B?Q3NBVzZ4MzV4ZEM0TjdHQ3E1SGpDRzJLV0dYc0lKdjN1TXdnbXhGYS90NW95?=
 =?utf-8?B?R29EcHBQcHdabXVGZ0djd0JHa09aZ0hnUFJ6MC9pWnFoMnprNFY4bzJlS3Nn?=
 =?utf-8?B?aVZzdGNhR3NHc3dya1g1TFdsNGwxSTBoV0puN1FrNkRBQzZkYVFUc1RzYkQ4?=
 =?utf-8?B?MVpvcUZDZjV2V3lSM1prUUsxdDhNdmZocXdDcW8wczVBbHMrUmd1RmQ4NS82?=
 =?utf-8?B?bk5oSlRLdFdhYTJuYjdmZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 808f9c46-602c-4058-f2f3-08d9511da706
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 16:43:24.8767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dH01HAHiK11jYdJDEFpcKt+yzcC+PaucjVW7SEkc6wLDdC7Z+yWs3sCNQeXa4aLM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4240
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: dp5pQXRov-yjKYSQ4pWApscBvYEX488C
X-Proofpoint-GUID: dp5pQXRov-yjKYSQ4pWApscBvYEX488C
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-27_10:2021-07-27,2021-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 clxscore=1011 priorityscore=1501 mlxlogscore=999 mlxscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270100
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/21 6:17 AM, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Remove color mode.

Could you add some reasoning in the commit message why
removing color mode is a good idea?

> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>   tools/testing/selftests/bpf/test_xsk.sh    | 10 +++-----
>   tools/testing/selftests/bpf/xsk_prereqs.sh | 27 +++++-----------------
>   2 files changed, 9 insertions(+), 28 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
> index 46633a3bfb0b..cd7bf32e6a17 100755
> --- a/tools/testing/selftests/bpf/test_xsk.sh
> +++ b/tools/testing/selftests/bpf/test_xsk.sh
> @@ -63,14 +63,11 @@
>   # ----------------
>   # Must run with CAP_NET_ADMIN capability.
>   #
> -# Run (full color-coded output):
> -#   sudo ./test_xsk.sh -c
> +# Run:
> +#   sudo ./test_xsk.sh
>   #
>   # If running from kselftests:
> -#   sudo make colorconsole=1 run_tests
> -#
> -# Run (full output without color-coding):
> -#   sudo ./test_xsk.sh
> +#   sudo make run_tests
[...]
