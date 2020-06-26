Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CCA20BBCE
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 23:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgFZVpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 17:45:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14910 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725780AbgFZVpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 17:45:13 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QLh9hO000320;
        Fri, 26 Jun 2020 14:44:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=nlbWCt8bgZSK0zPS7jYuo6G0Rz9l7Stf4ypTxCstRlw=;
 b=YaiUFSsci0NVmV/3iUV4DA1Blp5/pyZxa6emnliomkrqRVVVJ2g/ujSKyloUa7Adl2o8
 UTEgOd72kihC89Za2RSy9GvutGAqxsDbYw0qPqoKFp8Fnwx9E+1RLdwyJgqJdrfLjn6m
 OeqfOMF69p9qrs5lHamyoNd7ig/yFETsj7E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux0m7nth-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 26 Jun 2020 14:44:56 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 14:44:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFrJfknV2rmaggylRTNPbPfkJfuwfy8vLpF/z9AVPF7/jHqPHSRV+S+EzckIBgxxeTGPMvzxombdxfB8QIMebRW9/cQbFcjWct275sJG15rmM4vU44aL8wq3fw5wLSI6nEdwWi8JkSpo+4cSy3yPN5tJB+N03wchlMp7CrPtAY2Y0/+rEPxcFyvxLW+Lx/B99Y2Z9CvOrYP7ltIM2xKyYkmkuVHuE1BS+dASITX83f+0KA3i1EYL3J77kSKXsYVi+ntxqno69n8QpAV9l0oSPUgSTz+9OHDi+qeEEVpgMl7BrOTtPVKN+kUjF4xT9/D6ATewApJwoh9gSds3L2Q+1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nlbWCt8bgZSK0zPS7jYuo6G0Rz9l7Stf4ypTxCstRlw=;
 b=BucxZsV3qH8PkQxwAmGkGjWc47Bli6SpIPa+hPNo0MHV5BRMOpyK4+Xk5rWd2eHR6Qb5kUGa8ZSxDjblINx3Ta0qty+d9/XZPMn9WcB41lSxsgG/HCPMDttKsGEsaWw5zYgwzJ1bmAmb2GtVxKKoZ5nK8rSAGtm1DDJy5N7FvIpsq/D3At3V1b/yer/DJz7z4F3bUBPX8AOyWo19eys7YQoFRG53l0HI01wbV2iW/83vv1JFoGaJBvuO9CZ2xJNFXFuT4Jgyt0HVQMX3KgPaAG+32r8AgZPyJLEBHc4nejY/kGJBxwjdqwzU2WamxGNyMUqbe8GS5hTf/cO1Yl2h2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nlbWCt8bgZSK0zPS7jYuo6G0Rz9l7Stf4ypTxCstRlw=;
 b=gbN/bqdpNxQqPugg/CeNcF6J544Jz6bGjavICYUeoD/YYe7YkKSMN3D8rclfs6XPer/kXgw/yLLloRZvLsWBAKFmGm2OxSZY4fneM4Se9H4Ad2b7MDn3JXY6KQ2asBa26U6gGQ3pEcVoNbHNVo+QmfAkzzjpwme+JrFIu1Xs4xQ=
Authentication-Results: zeniv.linux.org.uk; dkim=none (message not signed)
 header.d=none;zeniv.linux.org.uk; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2725.namprd15.prod.outlook.com (2603:10b6:a03:158::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Fri, 26 Jun
 2020 21:44:41 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.033; Fri, 26 Jun 2020
 21:44:41 +0000
Subject: Re: [PATCH v4 bpf-next 06/14] bpf: Use BTF_ID to resolve
 bpf_ctx_convert struct
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20200625221304.2817194-1-jolsa@kernel.org>
 <20200625221304.2817194-7-jolsa@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2de85be7-0910-3129-b881-edbc2854d38e@fb.com>
Date:   Fri, 26 Jun 2020 14:44:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200625221304.2817194-7-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0099.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::40) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [100.108.114.114] (163.114.132.4) by BYAPR05CA0099.namprd05.prod.outlook.com (2603:10b6:a03:e0::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.12 via Frontend Transport; Fri, 26 Jun 2020 21:44:40 +0000
X-Originating-IP: [163.114.132.4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5f3ce3c-a91f-4cb0-01b5-08d81a1a21ff
X-MS-TrafficTypeDiagnostic: BYAPR15MB2725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB272526F40DE0C290B0F9E412D3930@BYAPR15MB2725.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zKTToenkYPdDRW1hqKnqEzCpLYE5N0CJC9MhOlonhFb4ZgUGvGTXO6AfJeUQf2utSmr7I4237bzyDolDkXU1YYhIvylGiu/DFC0BD0ViYQ2Q/2qfaCTW3Nsx1r/+iHvPE9/3luBakLGqxj+CndejhWmxMCVtGb+WpTRRP/IgQUCs5Z7qgV2+yEfNgqQflYXrLOerNfbjdtEEnFQGblGC07b3wYiiv4nh9GBAiphkr8YL0v75wxN3wBPOsj/2qJArsIDu+AmVQBTU4eo6H4gmtZ5p3sqA3Ukx4XCxxD6x40N4DCBBZ9DkGG6o3YzfcXgrj9Ek6GvAtjcbRANOPuVvCmpVB3IvwkUQu6Gi6PN4c19fU3Hhx+AfSxbvjL/6JQkccBkgE7shkijbeiLv46MmaZuxGGA+gnbVG2Tz5Q6nWKmV+K8GEgj7U9VLbIWR5YCL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(346002)(136003)(39860400002)(376002)(366004)(186003)(66556008)(66476007)(7416002)(2906002)(4326008)(6706004)(2616005)(16526019)(52116002)(53546011)(36756003)(83380400001)(26005)(316002)(5660300002)(54906003)(16576012)(956004)(110136005)(478600001)(8676002)(6486002)(31696002)(31686004)(8936002)(66946007)(86362001)(78286006)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: rSTlhiEOGXI4jVtE/UFpf0rmtPfiYLod4X4symW1UNkouhA6tTjfndDLri2giaF5rALFnh7nYsdJqqzDGvuEjcrFsrdhmF5Itg887o9xhc0WWzUC8PORXh2lZexivpiE8NUZWJkJ341iDaX7kb1fzdA5A/7zIiFr9XH38f4UUa2JKx+vISA2OmzMWTKJM6OjOVpeRFzJSYhEAmbdo01MDJ4Lrb3k1HwYBzXD8TSJPr+h4CuXgvmaInmCUou0IgdwiXVgQNvp/uhVkMMhoSlb90YPNMpUMqlZvOg2fVZ7Z0JPZTrSUH40fHFq3TfVk0IiLMa03rWR/8wCGkWOuluyQdULDNKxt5Y5DFCtX5Z3PU7lJV0Zm3/sghvkOSqp4cLiN8pgOsPNV4Cc9V1Rcr9rFQxwHlMT+K7V6YdDh4OtA1J9cv25/O48uT0SVzsyBobbFLf2dNLALHVtzJUGZZcwKBaSo8+kNpiWb/YXmgq+mcI=
X-MS-Exchange-CrossTenant-Network-Message-Id: a5f3ce3c-a91f-4cb0-01b5-08d81a1a21ff
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 21:44:41.5626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wRrRTzJL8wGhDRkK6z1fKtXMKgwtBiXxGvStmEdWbKalSLRwMXyDU9sLIpkyF9SP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2725
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_12:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 mlxscore=0 cotscore=-2147483648
 malwarescore=0 spamscore=0 impostorscore=0 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/20 3:12 PM, Jiri Olsa wrote:
> This way the ID is resolved during compile time,
> and we can remove the runtime name search.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   kernel/bpf/btf.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 4da6b0770ff9..701a2cb5dfb2 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -18,6 +18,7 @@
>   #include <linux/sort.h>
>   #include <linux/bpf_verifier.h>
>   #include <linux/btf.h>
> +#include <linux/btf_ids.h>
>   #include <linux/skmsg.h>
>   #include <linux/perf_event.h>
>   #include <net/sock.h>
> @@ -3621,6 +3622,9 @@ static int btf_translate_to_vmlinux(struct bpf_verifier_log *log,
>   	return kern_ctx_type->type;
>   }
>   
> +BTF_ID_LIST(bpf_ctx_convert_btf_id)
> +BTF_ID(struct, bpf_ctx_convert)
> +
>   struct btf *btf_parse_vmlinux(void)
>   {
>   	struct btf_verifier_env *env = NULL;
> @@ -3659,10 +3663,10 @@ struct btf *btf_parse_vmlinux(void)
>   	if (err)
>   		goto errout;
>   
> -	/* find struct bpf_ctx_convert for type checking later */
> -	btf_id = btf_find_by_name_kind(btf, "bpf_ctx_convert", BTF_KIND_STRUCT);
> -	if (btf_id < 0) {
> -		err = btf_id;
> +	/* struct bpf_ctx_convert for type checking later */
> +	btf_id = bpf_ctx_convert_btf_id[0];
> +	if (btf_id <= 0) {

Just want to double check. Is it possible btf_id < 0 since previous 
patch did not check < 0?

> +		err = -EINVAL;
>   		goto errout;
>   	}
>   	/* btf_parse_vmlinux() runs under bpf_verifier_lock */
> 
