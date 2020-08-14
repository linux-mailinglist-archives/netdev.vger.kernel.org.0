Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98971244D30
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 18:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgHNQ4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 12:56:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58362 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726270AbgHNQ4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 12:56:37 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07EGtG9g006585;
        Fri, 14 Aug 2020 09:55:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=fHtmaTXQQVrfo5vyEJPdqxubwM/wAFUF+jRklacXKiE=;
 b=f7O2TJdtaweo2l9doHHOoj+/GTqVZGkCYeFfwvSsxiyE8wflxLXalqq+vcpyn8z0JO47
 50cSV8NPLiovkKkGaglkuCf0ciH2eMKqyOzgpUzkqbmrS66bPKnvW9OMge35uHzDyzWv
 Z42NhYQyYVolIahOcKSmuIqtx8IJ2DHvYfw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32v0kdgbv6-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 14 Aug 2020 09:55:22 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 14 Aug 2020 09:55:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PUZPqJO5miu/bJFPtI7LXzdXKcmqxSoUdvMmj661UPUaFntHnm113gJBMQ7oFkkoACFcwfsiOIkJZ6x/cTkXcy+jksBpMbvPUy7Z5Y5Coo7EHFqNnObTV0LS1pRVpmYBnF2SRyIKlJzRrgV88WjU/55FmTxv0FT+x825lnbz+WTBWNdgNxwUuDLV6H6sY3c/tftaVBDbKsH7VJ8g0GUsYKI7sVcKtKhpi1O8Fgt4Om4H0ECyKxDCa38ViDVXXdKuuy7jAHSOPSSXTbJBnRBB16gEpBUXnOHq/aVLW1UtoErbUHgF+f67GFrfGKgyPQl/i63t8IaC6STuttR3K9FmUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHtmaTXQQVrfo5vyEJPdqxubwM/wAFUF+jRklacXKiE=;
 b=jEpCdTpaoVJX7iAJAXxu+j84PuE8Z+9ErVoMI4azyI26KV0WxWLTPESl2Ws7c4ilKlAPv9XZgGqHEOFrtmOkk1QhtXIC2MKnC5vLyJjsG3CnsCGnDOHF/61H5HE4QuO+sEInomnxL2hrzeipJQ/Oq3Fyh8PPYzENm2zur98T1wbOwtcFyy7Chg+YVL+MnZqxAR/DpCk3BCBUm+omGRcB6bMZgIb3XBYTG6f6608Vsi+GG29EX7n9bwSVym0Z6i1D7yP3MFnmPZNsbPb1X5oxtIBTnfjKOkiImXsRj+7L3KeeRl1P7ehD9GfcDl+l7UOqR6ESKIDTTURfoF3RdmJjTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHtmaTXQQVrfo5vyEJPdqxubwM/wAFUF+jRklacXKiE=;
 b=b0HQShgylaPhESUdJHPNLoPcDi0VsrL7sqEu6ZAEQtfBr+X2vPG6r/D2S9BG2RqY2vrKLyYFjaEUJzSg7AsoSlNeMfLVEEwXsQKBVl42TYEdFFgQQ/tNwvWFcG9ygdiG4BULi45drfn2juabJeUnny1QNzUDT2n4qJOWOOsZTAk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3713.namprd15.prod.outlook.com (2603:10b6:a03:1f8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.22; Fri, 14 Aug
 2020 16:55:13 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.020; Fri, 14 Aug 2020
 16:55:13 +0000
Subject: Re: [PATCH] bpf: Convert to use the preferred fallthrough macro
To:     Miaohe Lin <linmiaohe@huawei.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kafai@fb.com>, <songliubraving@fb.com>,
        <andriin@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <hawk@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200814091615.21821-1-linmiaohe@huawei.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <fd710301-2197-1e8f-740b-049dfa494be2@fb.com>
Date:   Fri, 14 Aug 2020 09:55:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200814091615.21821-1-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::13) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::117a] (2620:10d:c090:400::5:238a) by BY5PR03CA0003.namprd03.prod.outlook.com (2603:10b6:a03:1e0::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Fri, 14 Aug 2020 16:55:13 +0000
X-Originating-IP: [2620:10d:c090:400::5:238a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 461443d5-a7d2-40eb-6db6-08d84072d02e
X-MS-TrafficTypeDiagnostic: BY5PR15MB3713:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3713E8D004DF052D2A4CDBF8D3400@BY5PR15MB3713.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SiqlM6ORDhPdpiV4IC5hhxD4nnJAOy83/fLinsXPZpfV7oFzR2F3DIcrwtV6MmsIPYUjfjwnpkOC7gakDADSuPOVdvIRZPXdQ51R/kkDhnuf8lAELiGwZ9/x4FB7oyra9rAEldENsa9kpQiOqCemv+LNxsJX25516gPCRcRIKG4kxsIq/W5mFRc9lt3qOinan9ba7txlgQRA4+AkY4Adv6FkDiGqOyxSkeeG1CYFP7CjZEXQyuG4X9/aPlamNDhUTl4yYkBYlidxZr94lTIyFTTi+jAcOPkMQolvjlEMsyMO+eFYRhoVSNr3N9fm/PKLshC1LJGHm68EXPA/bomMK4sHcqPS9s7F5iM7eOnkYAIsbu4ZGmbv+ec2t8SmkaqupuM48sZem+mOg4oJUd6W2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(396003)(346002)(136003)(2906002)(66556008)(66476007)(7416002)(5660300002)(66946007)(36756003)(8936002)(6486002)(31696002)(8676002)(4326008)(31686004)(53546011)(83380400001)(2616005)(52116002)(316002)(478600001)(86362001)(16526019)(186003)(921003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: G7asbfqnTvwPfZ9pjSPvQrOKLg8yFj6n0atkxBH0wFJFxJWwMmLLLzgzwNQnRLT8RjBaUuB82u1Og0QGyNkr9hnj4ShvTkMqBp4YCWNbgy53vZUmDOtcLhfgSUx7rs3ttDNa1VBcZK2M8p3gjs2W9U2fca28VOGnOAyOTC2C1WbUOFzoYjN6HI4Or/sehnlNoXo9bVxtdLoBddFSF8sFnskZdYBYE/wBbHUTZv9DgGbzdZHDIlEXRzNB1CviwzUHUXCDcC644TWH0WRPXNCUA9nFVKeyAK/sRSIkruqTP8Y5rOpEvNjTeGXzCXwfb07xrCYmNtEXPt7UAhattNxuzVkvrthRJWB/P15BvS/ZHYNAA7+e7fozPYsuO55Bp8fC8F7udLpMgrVbw+5I43uv5KMcVNmmkWLdoDhlhD34agVAUTTCXH4oFhcry/c77P5W+wMsvnyqwLGrWDKjECA3ZSl/cIRW1E4eDqK9Bw55C6V/d/heKRFge9zDY+utVxCci8seAuoFjTiKS92jYUvKT4hX8Sn0s9Htsx/DehlcxVMJNwjWo32uc/+nFKA5k38j3nvBrvX94gYVMgtQ45tpB2z+ZFRuoqtketb1ygjipc9QVtKxb5Biz1mJwikeBFE5PjL/5w/PziwdjCU+nPddQsjAFDLjysiZETKbUqpOpgQW1HJqE9DuTs+42++vkDXs
X-MS-Exchange-CrossTenant-Network-Message-Id: 461443d5-a7d2-40eb-6db6-08d84072d02e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2020 16:55:13.7127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1TYEu/GuOkN0mU0jqxv15SQ8AAGhAYM7PtEf6ldH1pGJT6IstIM7OrQQDfdpfDXV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3713
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-14_12:2020-08-14,2020-08-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 clxscore=1011 mlxscore=0 adultscore=0 priorityscore=1501 spamscore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008140126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/14/20 2:16 AM, Miaohe Lin wrote:
> Convert the uses of fallthrough comments to fallthrough macro.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

This is not a bug fix but rather an enhancement so not sure whether
this should push to bpf tree or wait until bpf-next.

It may be worthwhile to mention Commit 294f69e662d1 
("compiler_attributes.h: Add 'fallthrough' pseudo keyword for 
switch/case use") so people can understand why this patch is
needed.

With above suggestions,
Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   kernel/bpf/cgroup.c   | 2 +-
>   kernel/bpf/cpumap.c   | 2 +-
>   kernel/bpf/syscall.c  | 2 +-
>   kernel/bpf/verifier.c | 6 +++---
>   4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 83ff127ef7ae..e21de4f1754c 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -1794,7 +1794,7 @@ static bool cg_sockopt_is_valid_access(int off, int size,
>   			return prog->expected_attach_type ==
>   				BPF_CGROUP_GETSOCKOPT;
>   		case offsetof(struct bpf_sockopt, optname):
> -			/* fallthrough */
> +			fallthrough;
>   		case offsetof(struct bpf_sockopt, level):
>   			if (size != size_default)
>   				return false;
> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index f1c46529929b..6386b7bb98f2 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -279,7 +279,7 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
>   			break;
>   		default:
>   			bpf_warn_invalid_xdp_action(act);
> -			/* fallthrough */
> +			fallthrough;
>   		case XDP_DROP:
>   			xdp_return_frame(xdpf);
>   			stats->drop++;
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 86299a292214..1bf960aa615c 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2029,7 +2029,7 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
>   	case BPF_PROG_TYPE_EXT:
>   		if (expected_attach_type)
>   			return -EINVAL;
> -		/* fallthrough */
> +		fallthrough;
>   	default:
>   		return 0;
>   	}
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index ef938f17b944..1e7f34663f86 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -2639,7 +2639,7 @@ static bool may_access_direct_pkt_data(struct bpf_verifier_env *env,
>   	case BPF_PROG_TYPE_CGROUP_SKB:
>   		if (t == BPF_WRITE)
>   			return false;
> -		/* fallthrough */
> +		fallthrough;
>   
>   	/* Program types with direct read + write access go here! */
>   	case BPF_PROG_TYPE_SCHED_CLS:
> @@ -5236,7 +5236,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
>   				off_reg == dst_reg ? dst : src);
>   			return -EACCES;
>   		}
> -		/* fall-through */
> +		fallthrough;
>   	default:
>   		break;
>   	}
> @@ -10988,7 +10988,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
>   	default:
>   		if (!prog_extension)
>   			return -EINVAL;
> -		/* fallthrough */
> +		fallthrough;
>   	case BPF_MODIFY_RETURN:
>   	case BPF_LSM_MAC:
>   	case BPF_TRACE_FENTRY:
> 
