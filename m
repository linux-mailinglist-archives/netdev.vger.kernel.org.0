Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428F81D28B8
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 09:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgENH0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 03:26:47 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47898 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725909AbgENH0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 03:26:46 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04E7OOAp024971;
        Thu, 14 May 2020 00:26:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=XQtT+pykVdwQ6KCWf6+oz7KCx9nWZG3jdyAklRFaJ0g=;
 b=Aj7Ze4l/hHeUsYzYkcPk5ttboyS6/7xpmumtWJnYNWv92xq2kTCN9YK4zeb8HI3Jsj+b
 w+wjyWz6erh67tUflKlOn1zvjbka0s1kFtz96m7M3VBJMqIJOVQ3UjAL8CVQllCHEjMx
 lqdJnmA7XtVuYivFTQCH8wQROn92OFtT1hg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3100xh9v6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 14 May 2020 00:26:33 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 14 May 2020 00:26:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNkqH1/uHPYQ5pIC0n6WUVHzcnYCEYjAFkcgj9YF6UPOJ+xRql49vztqVVbqBrirgymrVkxObRFrPWXu8gPu5+v7MLz8SdwsKWomZGJjze+Boa1bJITbTB7X+vZNTKE0owYCi6+pdeZefgM2shQlOUqLCdoIooev4bHaGtq/YuitVGLV3o+RcdkGkLS0LCVfEW9eDA9t2z0b8nbWBly+gnAI70DW09E5C1dNCdFE2JEDGjpnsuvjavMy3F3ocJJ/5re+49q67ioG+SzT3cQiT6/9n8SS3H66D9DwdKZlRpu97cssN0vX3XFE0CO8s/Du/ZhxS9OyyvJRcVAyO2nTog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQtT+pykVdwQ6KCWf6+oz7KCx9nWZG3jdyAklRFaJ0g=;
 b=SwslXgWfM0E7q6fMXVjJCPSSWdt+n1DnvCroe1FkZ4D+VOfIqWOT7ETCaB+MUZeypBnppghIwVaUa2qSKucVcE2NFC5Rm4yNat2j6lHK1AefL2o9pWFFTj+B7tCdYRbpujMLhNdgGUPhmpqoR6o0tSO8Vo5EpWMdjickprqaFpiytgAuup+vHVnHR3832WlUX3kjCsVIyQZ9XImf0+1P0wcFf8wcOIWJnA8+8zqFCyiVpcrO5aUHofRJDRBdPXN4BTh1Xtjmm09fZbcUnG7PgINwJ7VQplY6fVoJ4Sd6pjWXOXIQpwezGmSHkke5haEr0l0DYL3OQZ+lUcO2d6M7jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQtT+pykVdwQ6KCWf6+oz7KCx9nWZG3jdyAklRFaJ0g=;
 b=aN0pxRxvxaja3JmpExc2D7ye77oGuy9bMnyCFqbzXiYx21S9HUDCBBwMjZipIK6tz2xGVKzVDme5acsQuQewNykgEpeWFU5Hwa5E5i+RU2UALIQU301UVJRZOny7PYxc5Dr9EBEuGuzUnp0VCBCv2rs7wOZGNOqQAKG10z3F5hY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2360.namprd15.prod.outlook.com (2603:10b6:a02:81::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Thu, 14 May
 2020 07:26:25 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3000.022; Thu, 14 May 2020
 07:26:25 +0000
Subject: Re: [bpf-next PATCH 3/3] bpf: sk_msg add get socket storage helpers
To:     John Fastabend <john.fastabend@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>
CC:     <lmb@cloudflare.com>, <bpf@vger.kernel.org>,
        <jakub@cloudflare.com>, <netdev@vger.kernel.org>
References: <158939776371.17281.8506900883049313932.stgit@john-Precision-5820-Tower>
 <158939789875.17281.10136938760299538348.stgit@john-Precision-5820-Tower>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <fd2063e0-30d6-ef65-ee7f-73cbd10094b1@fb.com>
Date:   Thu, 14 May 2020 00:26:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <158939789875.17281.10136938760299538348.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::36) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:7dec) by BY5PR03CA0026.namprd03.prod.outlook.com (2603:10b6:a03:1e0::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Thu, 14 May 2020 07:26:24 +0000
X-Originating-IP: [2620:10d:c090:400::5:7dec]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a886137-652a-4c2e-e310-08d7f7d81c16
X-MS-TrafficTypeDiagnostic: BYAPR15MB2360:
X-Microsoft-Antispam-PRVS: <BYAPR15MB236051FCB2353AE17CF81C0AD3BC0@BYAPR15MB2360.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 040359335D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9FKmX3kMH/jT4rg5gv2bnW3Uli9dVigAabjwSJD+oubmDlWr3kNW0vqytdSNEUgEJfzNCU4piSqKzGT0TKpuYgQrlL26b5FqcZnezi9qbWvwrYPsU48YmpzHM2qSuluaVbbjf0O6D8zbbNsnI41xKm/IboBHCp7EAKNhWnMGyggnDV/d/KcXcen32TjeveTMmLO7CpRbB7+WBNS1+qgGzSoudA1WAYfWmUJzrtBTYvSafft476WpXnet885KwUnsIffDO/snfN4rHkHU+h+JxL40CVSQglRc9LH5wOD8k2cI6QM34ndn+duKtZa1Xrm/pQgO+K3HrKGWqm7KUC90jLp2IROljcokqCOu3JHJ5biHSqkZkGSjNLjhpj7cnGhjpdZKDNF7wvofuGPd1Ups3VSF6BxxqWbNEgidY4yFLIFV7SZdLOjuxCd2a/qC7g+QNQyV17X9aTR4Yjy079+j0TSq6Nt96wzGyeXxHrBux1zV7qDC4nCuF5bZ4gLFwvx8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(346002)(39860400002)(136003)(86362001)(66946007)(2906002)(66476007)(478600001)(6512007)(31696002)(8936002)(36756003)(31686004)(66556008)(52116002)(186003)(6486002)(8676002)(4326008)(6506007)(16526019)(2616005)(316002)(53546011)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: +Xdfxm5vZJURZ9oVZHHvila7wW7ikR9fw6je7o/Y+Oq9sVGUbW0KnjhG+8A/Iq0mDrXGxJyGyEi5PoXWi2xgrvi9QEvdogsDUtfxYPfmfUFQVsEmXVYvQYNi2TBl9I/ww6vavntX7/I73xDaoxuKgcER4V2G9Q3og2HJ0AauqGF8zAt36hHsRzPnMc5fapLLzA2BkQWgvDoHwiTK3dslqUv8XeHTvyIFvj0QRUQizuzxmYWzgddckTv+YjUuyKEhqbyUGqy6sEXk18l1V2doodg2W6Nrg+qPN/P2Zmit/52o8EaPmR8xaejQ5Womt4YI8WLmF4j99hnhCr+7i/kpMo215h6IIgksY+b5j+ef5wQUoVdlADcfvDgz7giVEBcnbbubaY1xteMP+x4v9gU1+Y09l407M+XSiUnFUFlRwyBlk5kD4NAntJVeu00pCRe+rTJVwN4zOZ2tuxZkOFjoLdeZTbbazmA3wZmGqYrdN/kMLJpbyFIUqTbqWTa+AhMvLlZMpQ7bEotvSqPJxR1YIg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a886137-652a-4c2e-e310-08d7f7d81c16
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2020 07:26:25.4691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tj1BfngQ/x1k/Inkuc62tmjsIHejxVfCtrvguQt4genTtsvVLCUkX9ccZriX52bL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2360
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_01:2020-05-13,2020-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 cotscore=-2147483648
 mlxscore=0 priorityscore=1501 adultscore=0 impostorscore=0 malwarescore=0
 spamscore=0 clxscore=1015 suspectscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140066
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/20 12:24 PM, John Fastabend wrote:
> Add helpers to use local socket storage.
> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>   include/uapi/linux/bpf.h |    2 ++
>   net/core/filter.c        |   15 +++++++++++++++
>   2 files changed, 17 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index bfb31c1..3ca7cfd 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3607,6 +3607,8 @@ struct sk_msg_md {
>   	__u32 remote_port;	/* Stored in network byte order */
>   	__u32 local_port;	/* stored in host byte order */
>   	__u32 size;		/* Total size of sk_msg */
> +
> +	__bpf_md_ptr(struct bpf_sock *, sk); /* current socket */
>   };

Sync changes to tools/include/uapi/linux/bpf.h?

For this patch and previous patches, it would be good we got some
selftests to exercise some newly-added helpers.

>   
>   struct sk_reuseport_md {
> diff --git a/net/core/filter.c b/net/core/filter.c
> index d1c4739..c42adc8 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6395,6 +6395,10 @@ sk_msg_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   		return &bpf_get_current_uid_gid_proto;
>   	case BPF_FUNC_get_current_pid_tgid:
>   		return &bpf_get_current_pid_tgid_proto;
> +	case BPF_FUNC_sk_storage_get:
> +		return &bpf_sk_storage_get_proto;
> +	case BPF_FUNC_sk_storage_delete:
> +		return &bpf_sk_storage_delete_proto;
>   #ifdef CONFIG_CGROUPS
>   	case BPF_FUNC_get_current_cgroup_id:
>   		return &bpf_get_current_cgroup_id_proto;
> @@ -7243,6 +7247,11 @@ static bool sk_msg_is_valid_access(int off, int size,
>   		if (size != sizeof(__u64))
>   			return false;
>   		break;
> +	case offsetof(struct sk_msg_md, sk):
> +		if (size != sizeof(__u64))
> +			return false;
> +		info->reg_type = PTR_TO_SOCKET;
> +		break;
>   	case bpf_ctx_range(struct sk_msg_md, family):
>   	case bpf_ctx_range(struct sk_msg_md, remote_ip4):
>   	case bpf_ctx_range(struct sk_msg_md, local_ip4):
> @@ -8577,6 +8586,12 @@ static u32 sk_msg_convert_ctx_access(enum bpf_access_type type,
>   				      si->dst_reg, si->src_reg,
>   				      offsetof(struct sk_msg_sg, size));
>   		break;
> +
> +	case offsetof(struct sk_msg_md, sk):
> +		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_msg, sk),
> +				      si->dst_reg, si->src_reg,
> +				      offsetof(struct sk_msg, sk));
> +		break;
>   	}
>   
>   	return insn - insn_buf;
> 
