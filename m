Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595B640976E
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 17:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244937AbhIMPga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 11:36:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44280 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235347AbhIMPfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 11:35:53 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18DF7CZ2026680;
        Mon, 13 Sep 2021 08:33:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=UxMaJbZdLdOjea8LgFZRqICBPpo7hwVcAyafOhAkykA=;
 b=fhdTFgUoTKivocSiMtM95jLeR1w+VfjTcGs851XHmtIKkjxjzObqVB2RyZRr6GU1UmBz
 FqMW+YFiarnTTrLQnZ45H5XQep0yKa0qp/GV8z173UnY+bdHwaBJPWcT9TandI7qy/hZ
 zWxSIS5HioxNuIiKlQeqIFsjKLE2fCwre2E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3b1k9rnfuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 13 Sep 2021 08:33:56 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 13 Sep 2021 08:33:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B5MtAPZ3P5NNjKSvdmW89Q5JhjlfZ9dc3o3QGx+pckL0Oz2x6AH55U6PpeUi0Wiecia4fVyXkT/50s4vTeZMLJNwXmjJiHx7pwqlnGfo/L0DwtqJi2yHRU1y1NM1wbrd3rBrj88lA8gK37tBtl8zob311K9GWPw3vWnN7kyqSL+N8+Rsu2xnT4SpLb5Jnpkl6JNXHUkr77Gdhg8LuHiZe3JD8Od7JtVH5ylXkA3h00bXkywQnlSCEkCepNW/B0gUcJsjgUhY70c5iG4WRJkEayW3r47sGshURVJSrmITym+3hnHOgBCFNkIQMgDLdZVYfDUeI35Dh0ojzczsk3/M3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=UxMaJbZdLdOjea8LgFZRqICBPpo7hwVcAyafOhAkykA=;
 b=YvD4qtIOyIJ6g+OX5Kdu3/7FUtu+iuz+kYgilBBP+fGosb9WedZRbigxPori2f6qNqPgHEZ0iKvvIZQVDzyHnTMNAHfu219tQCHTvgJuWNWr8+JbFqe5hagNIEeLD6cFem41ZlMmf0eFIQQAx5ST7gu1mAqOvDqgMgoqnXvxoTMeI9zBdQKbcfzJl2gV7G+96qI8TLY/OQO6Axdi6jCyIxGdZSmxOEDriHseL8eUmJ+ourPkl+PJtJdRzgKCPnDsYZFNTcb6JAx3bmi90KAt5AZ9gmVu4NrVBtw9T7kFV9YjK+q70Y3i+g19L9RJTiMZK+Ca10+2a4za65aypRj/xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3790.namprd15.prod.outlook.com (2603:10b6:806:86::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Mon, 13 Sep
 2021 15:33:54 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 15:33:54 +0000
Subject: Re: [PATCH] bpf: fix kmalloc bug in bpf_check
To:     Dongliang Mu <mudongliangabcd@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Willy Tarreau <w@1wt.eu>
CC:     <syzbot+f3e749d4c662818ae439@syzkaller.appspotmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20210913110246.2955737-1-mudongliangabcd@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <4f260295-b7a2-92ad-3bb0-06074288dd23@fb.com>
Date:   Mon, 13 Sep 2021 08:33:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20210913110246.2955737-1-mudongliangabcd@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-ClientProxiedBy: BY5PR16CA0030.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::43) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Received: from [IPv6:2620:10d:c085:21e8::132d] (2620:10d:c090:400::5:a3) by BY5PR16CA0030.namprd16.prod.outlook.com (2603:10b6:a03:1a0::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 15:33:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5548c946-dc59-4797-f158-08d976cbe530
X-MS-TrafficTypeDiagnostic: SA0PR15MB3790:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB37904F24133643F93DF3011AD3D99@SA0PR15MB3790.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +eQH3sCZJa81UqSttYfFknqorvJLfqXJdwfS8f4/0AFNgDBblMla7Fe+s9mgl56j3q+UtWtwFI3OL9S5WJ2SvGS9oN7v2IPBTYtp7NJPg3Vp0ZLPgLw7r0ea59/7gkVnKIwUZHBXZr/Lc8sWIQp0CEM49vPDhf7WpxSne/5tenAa9wsSDkuUZZd2l+kyzc2T2Y1xMlR/Pk9KS4In1KFM78uG1ycboJ/ifNo6GlZ5lCuXXP466vVZbVz/aPbbGMUgaDmoB2QQASv/PyywKYKauH12vbx91Xd20wq6YHu50eeM+mzIZHhyVjCJlH3P4hNuwkZLRa/E7BdyQ7buxhNqmGTyGol6X140QDEELuixfbCTqum7vpo5WpDYoRVbhkcl9SghJ99sb3w28CO6G2n1L2pPEa6Q8vdhd1q7TF/nFJU5zwsJdMrjgA0Sk83GOnGvlQ97IKrkdYh08x9uQK1epQOYE2u2LDfps3vZ77iB2iJCqlhnQXkq1Z0d4AkQDlO1bTnsXYq/NZnfFu/rOmVxPM2PjTYu8y11dEz15x+gbYnzGS7N1PSY4A/b9TpBCp1zSbB38j/EP+BamNQ9jFrk1fZp13TgWmL42wDI+w4R0p674NTa0xrKIvHE3G4zNNqpTM/vQwnlt1o/Zic993Y3gsf9bTq5wdvgRv/aeTOVNgblfMd+IKfxDENY3wtyZEmucexMGeLTukIlRU/oNIuFdxEVzZUDzwXWZnlaz+32LOqOx/Dbjve+wc4xLRppvIywm3SI6xGQoUpnFJC26aNgGD4kmTfuY4o7wvmZ/YXzNTiTFYOQR1cPVCcCQQs/R0TyNIgKJstm8nyWMNkc4aF/Kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(52116002)(5660300002)(478600001)(110136005)(53546011)(966005)(2906002)(186003)(31696002)(316002)(2616005)(8936002)(4326008)(83380400001)(8676002)(66556008)(66476007)(38100700002)(86362001)(66946007)(7416002)(31686004)(6486002)(36756003)(781001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVpQMHBLWDBqNmtXNjk1S3NYczlZN1UrRlloVDVDeTRoalN1WjBhdkpPdDI4?=
 =?utf-8?B?OEVHUlhYejZJRytsbGdONXFkbzAvZGJZbHk1a3FHempSbktKbFlzUjNPWHJQ?=
 =?utf-8?B?cTZhQllsQkV4YVcyTDR2dHFkWkp1V2RaSHdmZS90ZTNmVjdJVmRqQ3RNU3Aw?=
 =?utf-8?B?Y1puaXZodnhSdmpOTTRFenlndkdaRlFLOHhISlhMY3hZcVNlcWdiWkRvQWM2?=
 =?utf-8?B?NGhQdjJYZHEzZXQwUUF2dWtKTHZqeHo2dER0SGVmY3JOZXFzVHExYjA3emQx?=
 =?utf-8?B?MTYwM08zM3JicC9XZUZVaXZkbDdBSDA4SHV3UjYvRk9FeW82dGhGdlhZMWJV?=
 =?utf-8?B?NmZUVThpQTJERkVvT2lTd09RQmZXNHdJS3JUckQ3MHU3MjdhVm40dUdPWTVY?=
 =?utf-8?B?QVVJLzM3QjQzSDFjMkNvV2xNVE9oYU55b0RDenF4K2o4dFZtMnVwRVRwVzhF?=
 =?utf-8?B?VVhLNnh0Ymhxb3VyeTNYcFptTFNvUnFvT3FhM3FCM3kyK1YyNlFrQkVMMVUw?=
 =?utf-8?B?ZERLV1IyNldrVEFncVcxNlIrRlVMbER5RlBhQXNTWDhmSWRUdko1TnNQNnpy?=
 =?utf-8?B?S3VRMFJscktnRHlLMDR6bVZrL0NaV25LQ0phS0tjdmJQZVhzYmsvQ093WDRv?=
 =?utf-8?B?NmNCcTJGRXZ4SENVeUErYmdpR0owZmVSdHkxRWtGS2hrUTRONndSSVV1b2tq?=
 =?utf-8?B?cTN1WDNqVlVvakJZWWlTZGRSMEZ2dklzVVlFMkFCMTEzUVliTURzUWNKNjNt?=
 =?utf-8?B?cHRpRy9VOXNqTk9jTFRpZFVtMkg4WnpBL2taM0NVUWVyQllTNmFiUEg4ODBi?=
 =?utf-8?B?VHZPK0VueUwxbFlSQ0RxZFhKODFwVW5NL3BFbFl2S3lWcVY4VCtTK29qT3BJ?=
 =?utf-8?B?OFVuWm1NY3dNSStpaHJEWEZiRUtYNXp1R1o2QVYyanRtV2l6K1Z0SFJkYk10?=
 =?utf-8?B?YVVJSkNxdnFSRlF6RVUrWXY4dU14ME9pTEdSMnVmMzBZeWlmN0gvdkZEOCtC?=
 =?utf-8?B?RVB4SDd3Z2pKQVJTazg5VExHNUF0Skt1R1RENkd5ZnY5ZEMzVTlqYXZHdEFD?=
 =?utf-8?B?NTRSMDdZOGljQ1FkY243RmlKSVcxZWtBNEhic3k1T3JIdmx2SWE4ZlUvbzBj?=
 =?utf-8?B?b0dwRC8zZmdGZVJsY2hreFZHdC9jRGZ1bnZYUjZSNFhKaWV3bndWaUVwVVRF?=
 =?utf-8?B?dTJQa3ZrMGtqeVZMQTR1cWswelNXdW0xQ0JyTFVIVkpBbS8xRmFITGpjUjJz?=
 =?utf-8?B?L1JXZENxZGhqWGQxLzRUaUhqK09LT2NQaTJEWGZsZjhiOTh1MUs5aTZyMHlL?=
 =?utf-8?B?azJHVm91WmxVeUhZVHUvcUZnMXJ3L05jeGRxcGExcjluT0NxRFNUeUpXNnhI?=
 =?utf-8?B?WjA5RWpSUUNudVpuKzAwYXVMWFVrRzNndVd3cCtIMFZmQ1FxbHVJNkZEcGkv?=
 =?utf-8?B?dEhxOVhaVDRFb3hBRXZMcytXa0hWVmtLYnJ3U2VUY2Z3ZmlIQmhtZmlHSkMv?=
 =?utf-8?B?Y3JGZzMvSkZRd05TczJ6VW1nenJtYUJZOWR4UTVWcXg0Sm9yTFhpQmZRTHRZ?=
 =?utf-8?B?TDBDMmUvY1BjTzRTUEFqYnRmVURqeTVpUmIwdjlSbDErb3N1M0hQVGFiMTdP?=
 =?utf-8?B?K203ZHEzQlRhUWVwMmVCWUI3dGZjZG9QcVUrRzJBNUZpUFI5OE1ScmlUcDdV?=
 =?utf-8?B?L3JGd3lzWmcwc1FXeTFYRTlHczVUeGJaZG9wY3k2ckdpY2NCMHhMQWp2U1Jn?=
 =?utf-8?B?V3RnaTdqS2xTVW1KdldtVFV4QTdBbm9ac2ljSU41dG1KYnNKV1Azc09iZDlU?=
 =?utf-8?B?bkl3eTN6MDl6U2lPUUtXZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5548c946-dc59-4797-f158-08d976cbe530
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 15:33:54.7093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wxJ+FWDumLR07O5oXWoxpWaIYOE3aQCqEoYEIom5Socsi9UCrkogubatLORFoCXw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3790
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Si5HtcKs9-eGH7JRocPIHAMSpb_EBsRP
X-Proofpoint-ORIG-GUID: Si5HtcKs9-eGH7JRocPIHAMSpb_EBsRP
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_07,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 clxscore=1011
 priorityscore=1501 phishscore=0 impostorscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130103
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/13/21 4:02 AM, Dongliang Mu wrote:
> Since 7661809d493b ("mm: don't allow oversized kvmalloc() calls
> ") does not allow oversized kvmalloc, it triggers a kmalloc bug warning
> at bpf_check.
> 
> Fix it by adding a sanity check in th check_btf_line.
> 
> Reported-by: syzbot+f3e749d4c662818ae439@syzkaller.appspotmail.com
> Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>

Thanks for the fix. A similar patch has been proposed here:
https://lore.kernel.org/bpf/20210911005557.45518-1-cuibixuan@huawei.com/

> ---
>   kernel/bpf/verifier.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 047ac4b4703b..3c5a79f78bc5 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -9913,6 +9913,9 @@ static int check_btf_line(struct bpf_verifier_env *env,
>   	if (!nr_linfo)
>   		return 0;
>   
> +	if (nr_linfo > INT_MAX/sizeof(struct bpf_line_info))
> +		return -EINVAL;
> +
>   	rec_size = attr->line_info_rec_size;
>   	if (rec_size < MIN_BPF_LINEINFO_SIZE ||
>   	    rec_size > MAX_LINEINFO_REC_SIZE ||
> 
