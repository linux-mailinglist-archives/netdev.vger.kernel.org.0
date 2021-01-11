Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461522F0BAB
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 05:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbhAKEEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 23:04:33 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36154 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725824AbhAKEEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 23:04:31 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10B3tNr0000994;
        Sun, 10 Jan 2021 20:03:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=zmRXvk6xaCNTmmFRvJp9fK1xVSrcj0ApgJLz0WghpCg=;
 b=QMkQr9ZYjo3x8qUUN8uj1WKZfW8UO23Y+q5HeglWwpUpodXJuACIlhTlDQswE8lnR5lg
 wdc+fFBmdXBPjoBilNFrxgB8c/Afl2JrHtknH5P+S+XBRD8fkqkra6NQDVLsF0LY2V/C
 U4kLtOJI8N7tz+m7OxblJiQpZ8vi0pfImts= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35yw1pasrx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 10 Jan 2021 20:03:33 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 10 Jan 2021 20:03:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OX8Z81kf97Ab79cdNEnYAhobpGzB2dgezMhPpaZY49KAzIoCalgxmcyAc4lx89wVvEuoL2keZAYmDCd+aPTfCoFvHlWJE8/s+kvCJJREkkdIgMhWKQ2yaI4WA8asGSe1q4o/C1mutkk7Fv/y8wbtNmeF1TBFn89S90s6FG/iC4GuZXqN3gQgAgvNJMhNKo+zreTADpFBMuLYDdYId3/Re7Qj0xB7ylJblvRbikTiHjwVA3Pp3ZmU+rKmUPt4CTIQFF/mtrqpJUOEGaLnurXiFAFkpXzaazm27dtup2/UrAN2xAxH0T9SfI4JXzInGxSNAZypO6PIjuq/x1KL2rr5zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zmRXvk6xaCNTmmFRvJp9fK1xVSrcj0ApgJLz0WghpCg=;
 b=VbipJ9qBhp8D3bbNKc50xTQqf96koKea8KI30SPdvcGCyr7i6ma2ndYstLEnTEEVP52WS7iFfUtMMCUSCOZBQrFX0OaUd0j7CtHWMXefTzGLnV6F+NEQTYa0zcKwrQqWKTAgpWrlbKZLmmxEJS25JZBDu4o0Vqwtu7Tw/U8DES4Xmq5KE/Ph7yLtnka8etwb1B1Vn2/FUQCU+kWb+t9w1hwJTxD2xuyq6pGQlUsOQIscDzWR8Pqxgy4GsmRHugc41F+un4OvZNDWEsNGsmsbfulWxK1C1oWSub8w0FWwuprbSvVB5gI+DUFppV6AeJuz/edmZGe+deh7EfQAop4puQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zmRXvk6xaCNTmmFRvJp9fK1xVSrcj0ApgJLz0WghpCg=;
 b=eR1BqTjuePNIxDb0lLS38TdPIsjyOm4ViaCttyqxOw8URCgCopDQ3crqbOA3EUtHG2Ln2UU5+lYsAuJspj1b+1oUUUyclSOySuiAUkn9r5PduDZpTm1lpHRVWBSUDIIRRMmc/clsP/Ys8kpGISWjktm1jUVPz5wmmXUwFFokmh4=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2773.namprd15.prod.outlook.com (2603:10b6:a03:150::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.9; Mon, 11 Jan
 2021 04:03:28 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 04:03:28 +0000
Subject: Re: [PATCH v2 bpf-next 2/7] bpf: avoid warning when re-casting
 __bpf_call_base into __bpf_call_base_args
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        kernel test robot <lkp@intel.com>
References: <20210108220930.482456-1-andrii@kernel.org>
 <20210108220930.482456-3-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e7c87b51-0fef-d0a8-a024-2f4c539f9d4e@fb.com>
Date:   Sun, 10 Jan 2021 20:03:26 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <20210108220930.482456-3-andrii@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:b212]
X-ClientProxiedBy: MWHPR2201CA0052.namprd22.prod.outlook.com
 (2603:10b6:301:16::26) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1158] (2620:10d:c090:400::5:b212) by MWHPR2201CA0052.namprd22.prod.outlook.com (2603:10b6:301:16::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 04:03:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18e66331-4827-452a-280b-08d8b5e5da5e
X-MS-TrafficTypeDiagnostic: BYAPR15MB2773:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2773811E47FCA6165E9D1546D3AB0@BYAPR15MB2773.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ILtaheJqoS1pDDF9rrJBr1PtLp68qp6XqSpPCtAy+M+PsWdvXIGuNRl33Qxu7B4agj+utvpPfPZTr3aUR5hi5+9Jh4i5dzd4wlq4kb0Q99TPlpLWpklyA2UuBLiNJyAFrTLM0d77tZQwX6Gje4enn61/sA4MoRkGL8zVrH+hv9v0slr6fSjrqmylaanDWQiokfGh/ulCGHo+IZyVfGHKLWqbxEiaRza81FdcVyASTyYCtSvf4HXqTMIB1HREM+toUsEAQ2tgkPznCErLlwz3izLoyIIFG69GcUlaohfkIBZp3BSG+rAU14YJLpzmo9CJeH7mQulUxrCrHbGXSbyagi/b3sY8rHOWnom3JrFiw1p9AvfSnL11uk0titTf3zgIhNf3E46YuTwg640lMK1ABQmL36uqQnECr7XJ/LgXl/MTFRCyl7EjiC0bs5dC49SML19SIf9kfc99/B/601k4L5bVc4vjuDP0NJi5oabj4gs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(39860400002)(136003)(396003)(478600001)(6486002)(2906002)(8676002)(5660300002)(16526019)(53546011)(83380400001)(31696002)(2616005)(8936002)(4744005)(66946007)(66556008)(54906003)(66476007)(186003)(52116002)(4326008)(31686004)(316002)(36756003)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?alVjd0RvcnZWVml3ekxkZ0RzYWJkbGFrdkFCYldxdlIrL2ZqUVpzQ0lxbmIx?=
 =?utf-8?B?cTlkV0NDK2RCSzczckcvaXRManVUcVdZdE1DdW11czhpVXpacVBtYy81c2xN?=
 =?utf-8?B?UFBMVTlzZXpHbTlsZXBjMjBFLy9qMHVKaFlRVWR2N01tRHRpc25zSk8zaHVa?=
 =?utf-8?B?ZjgvaGhQSmFqK2h3S1I4OFdzRi8yZ1JndEx2dFFlZWhjd3AzU1RwVjk2RG5C?=
 =?utf-8?B?a2RSZ0p4ckR5QThWb1hrek5sL3hiRXdoRkRSNnAyZXJiM0lSODZsSm5kZllV?=
 =?utf-8?B?M0VzWURGNzZVeEo5N0pNbmN5bWszcDlGN2d5MnBsT0UrY3duRS81bnovdzhD?=
 =?utf-8?B?Tm9wVW52ei9zN1MyYzc1VC9NZmVYcWkzbEx6SlllQ3N3NHhHcVlhd0N3eFly?=
 =?utf-8?B?b0NyRi9jZ0dnY0hhLzdSeEI2YWpncURJYi9FanJ3U01zQ1hYMWJLNzArZXhN?=
 =?utf-8?B?Y0ZrNGp2T09LMFpDU1FFdC9VTjNXclRwdklYQzBDU3cxSENxQTdNZlJoUzRL?=
 =?utf-8?B?VUlNcTBaV2ljazRrcDBZWWVwWTZrM09kbW15ZlNSM3dMZDJCY2JMSmQ0dnZj?=
 =?utf-8?B?cUZkNVc5NktlVHVmb1RWdy9XU3l3b0NtNmt6eUlMR0pkSlVJR08ySGxqN1pn?=
 =?utf-8?B?Wk9RWURGZklLWWJ3QSsweElpOCtLTFFUN1FLcXh5OWFZRE9LenZnTXBzZmk0?=
 =?utf-8?B?cFJMaVBqVHFDSUNMSXVVbGxtZkFjNGVoRVhVcDQvMG9sb2xmcnd5M1NNNGsr?=
 =?utf-8?B?aU9wc0xMdkZUcXlqN2EzN3o3OFo5aWtJVFRiN1k2bHo1VWc5bUpqV1R6WkVD?=
 =?utf-8?B?TS9sOGhTeWVqL1RLREM0K1pobHY3MTQxM0pxdXprK0o4enlabFloYlJHaDBM?=
 =?utf-8?B?YTdHQlp2dzJWZkJGRnZvSkNwOU95bVVHMHZad0k1R2EwL0J0U0wxVUV3MHhM?=
 =?utf-8?B?RnVIV3E5eUFlUm10N2hib0xHQUsrajdZMzlJSSt2bStDMlZ2L0RDZjRqNFow?=
 =?utf-8?B?ZFRCb3l6cHYvVG54UjBSSEdxLzdmZXYxZDA4QjJaVUE3b2gyYmRlOVUxNFQ4?=
 =?utf-8?B?RVRtOWxFNzI5Y29VSWxWbUJjSk55Yi9ObStKMVhmYjhGR2dWUFBjRU1Zek5v?=
 =?utf-8?B?d3lNYmRSUllsSGhOSk9TazJ6OE1NU1huYnA3Qm92b092dnJKT2hMaXRKL0h2?=
 =?utf-8?B?cmRBWmREVXBWYzQxRXllK2xlekZ4MWc0ajhPRTZLcmlvVGs5MHM2NjBENHBI?=
 =?utf-8?B?S1BWK05SRjErSmNsRnc4VEtjdVRwMnQ5bFlETi9PZEdPRm5OeGRmM2pyMlN2?=
 =?utf-8?B?OEFIZVBucEVDRDdvd2pXM3NJa2F1RTNWcFBNUDR3ZHV3TEVTQmllS1dpclcv?=
 =?utf-8?B?RjRBQ1FRVEtORVE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 04:03:28.8197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e66331-4827-452a-280b-08d8b5e5da5e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 25TmaSHbuPSf3Pdr5gk4c3WIgU18Dcw1ct9eUAaf0gkE6qp1yP3R2kpT/XBanATE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2773
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 mlxlogscore=815 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110022
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/21 2:09 PM, Andrii Nakryiko wrote:
> BPF interpreter uses extra input argument, so re-casts __bpf_call_base into
> __bpf_call_base_args. Avoid compiler warning about incompatible function
> prototypes by casting to void * first.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 1ea47e01ad6e ("bpf: add support for bpf_call to interpreter")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
