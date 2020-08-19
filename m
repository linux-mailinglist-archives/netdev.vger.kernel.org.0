Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A9924927E
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgHSBmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:42:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18062 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726367AbgHSBmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 21:42:44 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07J1dxxh000685;
        Tue, 18 Aug 2020 18:42:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=gFwBegxSyny+Vhd7AoxTd0Xu5wvaySST6qE9Cf9elkI=;
 b=DSNAfkjlWwsce8SDeUU5g7umbn/ZFrRpeRQrxDMitTMd7qEbcoJYKOYDL44OE6R1GTzv
 jJf4hULxJJ2Cz1xQYNaafYLQEJX0AeIfaRe2JodUqNZ+lKsIre2fVwxJRklwLitKDc1i
 SYyS8+ke1g6x3okqxKPwC1JT2GK6hvCPhdA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304nxp1n6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Aug 2020 18:42:31 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 18:42:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fu1/AzaVfzAxOWsvfLpUYBV/JBgvtsP6gXUBJfAkshrV1j4vW7twa+jKjLgt1zoxDSN5I1rvwFDrf/ZDFUP738ztRpNXg9NEo4SbDRxGSbOHclmI293R7bwRi5IbwwmL/3qF5mWTx4phMTYD1Muru2nhXj60wlUnoiP5SlUNM8mFCcgZpz58nszjAGL5/BsALodWLrBei0nSyButWlFDAWOoCKAWS031lAZMpr3i/JQCCoDOklx7xr4GTHTiUU+meaeKpbOYH0FWqjSax1/GNq0ixtOCMHOUIo/0d+K8OsJqr6nfezOzRea1WozWK6J5UuRi9RVAZbpMULhROJqCEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gFwBegxSyny+Vhd7AoxTd0Xu5wvaySST6qE9Cf9elkI=;
 b=g4xzR6Js1uzYFmWWd6qJzBv10ws/0YV6Zv/TOwK8+cjR076f3QNBhArQB9xv0YLAB/TuTCYWdCRgHl1m4h8QNEVLQIUg7CVaD0LJ29xmA8V7gUy5zy3PO6ACgm2lA8qPFYAOOXBIuDUomCzG96JjNzt9dQSwYoeKMZHMqohBx4sr4T1biHgmfuwFWqNTDX1DNRk6/kx6SjSa/l7QQ16Zdz0WtD3JO1AMyZQEbu3af3BQe5hIFQmDwOXN+7S/JLOf+pd+bCFD5QtfL0F4WIzVw3EzvSzAHlRBJUCe2rh1tqC+cF6Go98APr2MHA1nvvJ79yQjP1cnObSQ6o++mLVkqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gFwBegxSyny+Vhd7AoxTd0Xu5wvaySST6qE9Cf9elkI=;
 b=FQBWdNrySNZfWCcoLi/svkR5WRN+m2i6D2AJntTszqrvJ3IzjUGXXYgvhoi3nTgdA1wtpTKjx2ekC64oO0A5+D/v/QDyTxEx20tnzaXDupj5WHcx0DRyRFq9uUBAT1D3xHIkayJj4QN4xJzmy75yyngaC0STQXhk3WTt6ylkLa8=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3569.namprd15.prod.outlook.com (2603:10b6:a03:1ff::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Wed, 19 Aug
 2020 01:42:27 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 01:42:27 +0000
Subject: Re: [PATCH bpf-next 4/7] libbpf: sanitize BPF program code for
 bpf_probe_read_{kernel,user}[_str]
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200818213356.2629020-1-andriin@fb.com>
 <20200818213356.2629020-5-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e37c5162-3c94-4c73-d598-f2a048b2ff27@fb.com>
Date:   Tue, 18 Aug 2020 18:42:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200818213356.2629020-5-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0034.namprd16.prod.outlook.com
 (2603:10b6:208:134::47) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:a06c) by MN2PR16CA0034.namprd16.prod.outlook.com (2603:10b6:208:134::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 01:42:25 +0000
X-Originating-IP: [2620:10d:c091:480::1:a06c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50cc8eab-d12a-47b0-56c8-08d843e120e8
X-MS-TrafficTypeDiagnostic: BY5PR15MB3569:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3569DA2DE3B5BDCD19FF4D17D35D0@BY5PR15MB3569.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rs3THmk4GoBnDetIP/Ht/EQVh6bUOIITPGUpdP5HGZA9bDNDxeI25wZxx2aviKalwt/Olkjiiojj3Kg6kg9wWbqzgnFnj4oq8QO/MC/DL+EdLUEW/cZV3cXQaTfR6Kf7xd9Ucv4QRY+gjjj0ywvL0yILQ7Mp8mOyuJKoEyTfwnWheMK/Wi3QYm0tkaZRconoBqZFqji6hgTGQrP9N/7s2GgKtvGNQXKCWMW+Tb1F2uNnfyuJjVawhgMSX7br3o6UWSXysJIoPgLonBQQc77zUvR4JFE/uhrQjgKS2kepVrPIuZkgfyY/CYiNtzAZbGmPKdxtckpjsj/q799LE3dePM2VqGmSN4+/3SReHosC088Q/SHSwtDTmWBa/ohhRyLoUFt6EZwQmAnKxckQc91bxj8xD76Dwco93woH5rbPJw0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(346002)(366004)(376002)(186003)(16526019)(8936002)(2616005)(66946007)(316002)(5660300002)(86362001)(2906002)(31696002)(66476007)(66556008)(83380400001)(6486002)(36756003)(478600001)(4326008)(53546011)(8676002)(52116002)(31686004)(6666004)(142933001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: iiQlUIQsKKAzvVRXQFM4wud7Vixjp+AFEMtrYr096p0Ev/mgJK/h5ezT0oqYg2WEPuE9lb7c80lL6u1FOT80TRAgXWsCAiCcyeeAvRTruGP3w9g/9j32DjnbOrHpUAJoZMgyLl8c2V+gFbRT8vZVCtmHJxpAEFgUGsmn7rT6X1UgVhw0mYZvWToYNxz/UO/2axHxQ8iYlr7SIJRPNAN97ouzsmIGjwXmfPMciy68LBtKHEYo3apfCsDnxlp7u2aWMfpc3ClyW28AM79oJ0lQ56alpRJYX3NSiNdFZWToQLlbndoyc8h4Evu+aHdoDKvco1qr50LyQDMVdhtux9H9gXr7lu/o0sBm4KzQ31POHim5tsO0N87vrgofEErgfqpEmnOTxrg2om8VdPpgOKcVl6hhSLFw7n50SiEJSTWMc9iBCwE0r0f8hhH9RjfTZOBj1h/H013c3CMQE/+k52V9mQ8bQ3sZVyyfIO+eSkCbZuiD/MMNqtubZ0Q+sCvkCpKGtrhkZj9HDK2/8xlFNSjkN2zieg/VPmyvPqDelfTq0RXt0HFwDLs9M9MGFr1qPIOQ5ve2k32h74HktEY7rikQtUYFjARM2lPfZ5Fbq/lHfxj7ZMXgXoAkEyOw7YW5qdN5cWGy3uv/RSITLO74IVgKvXXKLIU+En9Yu/7l3voo+kNv8p7yA+pg/IpLK0gaGbhI
X-MS-Exchange-CrossTenant-Network-Message-Id: 50cc8eab-d12a-47b0-56c8-08d843e120e8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 01:42:27.3863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VQZ9L4n3FKAvYJLyAM+kcZ379WiHSrtL7tp30vb9ChOOeA42NOc21Cb4EGg178Nr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3569
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_16:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190014
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/20 2:33 PM, Andrii Nakryiko wrote:
> Add BPF program code sanitization pass, replacing calls to BPF
> bpf_probe_read_{kernel,user}[_str]() helpers with bpf_probe_read[_str](), if
> libbpf detects that kernel doesn't support new variants.

I know this has been merged. The whole patch set looks good to me.
A few nit or questions below.

> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>   tools/lib/bpf/libbpf.c | 80 ++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 80 insertions(+)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ab0c3a409eea..bdc08f89a5c0 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -180,6 +180,8 @@ enum kern_feature_id {
>   	FEAT_ARRAY_MMAP,
>   	/* kernel support for expected_attach_type in BPF_PROG_LOAD */
>   	FEAT_EXP_ATTACH_TYPE,
> +	/* bpf_probe_read_{kernel,user}[_str] helpers */
> +	FEAT_PROBE_READ_KERN,
>   	__FEAT_CNT,
>   };
>   
> @@ -3591,6 +3593,27 @@ static int probe_kern_exp_attach_type(void)
>   	return probe_fd(bpf_load_program_xattr(&attr, NULL, 0));
>   }
>   
[...]
>   
> +static bool insn_is_helper_call(struct bpf_insn *insn, enum bpf_func_id *func_id)
> +{
> +	__u8 class = BPF_CLASS(insn->code);
> +
> +	if ((class == BPF_JMP || class == BPF_JMP32) &&

Do we support BPF_JMP32 + BPF_CALL ... as a helper call?
I am not aware of this.

> +	    BPF_OP(insn->code) == BPF_CALL &&
> +	    BPF_SRC(insn->code) == BPF_K &&
> +	    insn->src_reg == 0 && insn->dst_reg == 0) {
> +		    if (func_id)
> +			    *func_id = insn->imm;

looks like func_id is always non-NULL. Unless this is to support future 
usage where func_id may be NULL, the above condition probably not needed.

> +		    return true;
> +	}
> +	return false;
> +}
> +
[...]
