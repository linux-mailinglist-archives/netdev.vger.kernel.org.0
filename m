Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFC424C385
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 18:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbgHTQqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 12:46:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14962 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729092AbgHTQpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 12:45:47 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KGe6DR032593;
        Thu, 20 Aug 2020 09:44:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=WOAlzMLyPI0jU2aiSfjuD9ccDqQ4AICjRtcrX3AY7C4=;
 b=dOQcIU/6iT1ANkfOV4Okmhjwpduw72Q9xDyOUgFVEVPaipKYCtesOEMoh9+AikYlwap7
 XXJE8rHCJbsUvHq1ihJgDhR0BK/3xZBEorKOMPTTjDL5u7HLZEJoHFPXi6Mvnq8JfGm4
 QJ2md25RCfDIKM8z2Ijc9WEuLyLQFRg/q4s= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3318g0nhj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 09:44:58 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 09:44:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VcA+itMrsp4h9CIek4t8X4te7nBuCa78c6UQQ8f4J53wjGqi9ztxvOIIfjmCABjStJcYJRjzeJmV7/VNa9y99ssdp762i6hq22qw2+zZhFyWpujSlj50iWQ8noV645TaP0Qpa7nn/hLEU62b54RTJcaPValnuTUWgiElDrm/Q1t+54txajR9xtSs+HIcXfIXC0xMllFRU6ZFb7je32hxSrgWAIxT3sDS0ituiuEe1059auMWZpx3LG7tgNYnslq5hdGmAz2iRJijvHSr68pjYuISIn4iClwNtHFL8M7GQOK4ftv7YkBWqYdRdWJwvdKU5nc8nmVCKqs5tCQFR7esWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOAlzMLyPI0jU2aiSfjuD9ccDqQ4AICjRtcrX3AY7C4=;
 b=FDAAv8LJI+c1uU4UUvHEu8vkmIzqI7VPkjUXtz/U2eiOGNmqi0dp3ZEuZimZqV3BBoDE6XUBkmWNnIOxR2t1w+O+UHVaycW4iYCJou0wsM0zyFbdlHZ2brnrTE5Y0hePCvi86hbAuNJqqKA3glzaP3LXpwuiaaYVBP/XRoXNE8y4l0nsZUviCIcLHzHg3w9n6F/M9lYgEAwLtTMfe1JYlxYFERMSHuoaFNoYvjaJwnKISVOukL8smuw2UNK9Aa/AKRst9dBvoZNoJ6+ITkLEsVgn2WPFvIusdxs1IcV/Z3yrNLwqz0gsRMkgCR5KPp24nFHNat0Nxqi34/3gDejQRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOAlzMLyPI0jU2aiSfjuD9ccDqQ4AICjRtcrX3AY7C4=;
 b=lGK/0ZqYL4SkLDTKxTDGkRP0J8mMLt59uwMn6gMJ9qwSlJYFlGvaCBF/1nw4kyxc3Ee81BfiTr6xCu9YJy3xBuaNOw3qJvdoOGN+zT2yPEE3nPNcgf9G9f0EUIxFV1LjRg6IElcfJ9eeSLRwD3VAfe0g91N6JsGoXF4R+lSniDw=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2821.namprd15.prod.outlook.com (2603:10b6:a03:15d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Thu, 20 Aug
 2020 16:44:56 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 16:44:56 +0000
Subject: Re: [PATCH bpf-next v1 2/8] bpf: Propagate BPF_PSEUDO_BTF_ID to uapi
 headers in /tools
To:     Hao Luo <haoluo@google.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
CC:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
References: <20200819224030.1615203-1-haoluo@google.com>
 <20200819224030.1615203-3-haoluo@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <496a2a25-ad43-2f87-033b-3b462011ad08@fb.com>
Date:   Thu, 20 Aug 2020 09:44:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819224030.1615203-3-haoluo@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR01CA0009.prod.exchangelabs.com (2603:10b6:208:10c::22)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR01CA0009.prod.exchangelabs.com (2603:10b6:208:10c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 16:44:52 +0000
X-Originating-IP: [2620:10d:c091:480::1:7ec1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf96662a-5275-4230-b654-08d845285e7b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2821:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2821EB04F7841C0B2BACBB83D35A0@BYAPR15MB2821.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9gk4uA2qSLkl0gaX2THG21V5BK3Rgrq9lhBJ8aY0fks2Ch2/5PmZCC9hHdtzSOmFGzhws2zwEGWtaAaf5Kh0M87HH8pcECkPyxnRRO49Wn9NKHjjiyqUPUyFbTq60Braf+3xeFnHE9kKwdloiBwQry+Xbv2yHcnhI3iiJZHJbGawEDien8Ugp5ymE6pmRTIMIoqSo+84o/PS7ppcOb/OgWJfYmEsENC/SEZapBCrXrBrpO+qqp5/v2y7A2luXW0E4fK0uqiLOnEiPnFInyBImbYnH01pTRihss2ViKbmsnGr2YjbMisKZ5oUAgg09DeOo9j+zoSmcWTPcpW09l6h46znBF+bX/Nze+SQCPIYAQrroWKc158ewZWP6/Cd80Jka6EQQOO5sVBjeQBDUiPy7wyi/iXuQHOtfv0XXtV99W0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(366004)(136003)(396003)(110011004)(31696002)(316002)(478600001)(54906003)(53546011)(52116002)(86362001)(16576012)(31686004)(186003)(2616005)(7416002)(956004)(36756003)(2906002)(8936002)(83380400001)(66946007)(4326008)(6486002)(66476007)(66556008)(8676002)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: PcKNFPpxzVAJe65guVrDO4LKZ8Jqo44GV4GyJl5CaOGwq4xcpdI/tgQY9iQfwuP9qZjGs8581u6A8RIcffTjrtqsN/mtoaT9QdLi4NJBtWFjyqcyUY40uaq+2bEgqRIk+qUy/8bjbTEf/x2odnWrq7SRiXZ+N05Ez9IdVBHUcdjGTAt0wDea+5yAwk6o9pHjUcYUK0RsUHIrp1t1QCWY/FPweygj1B6TnuHcElCIOyjquu2C/XgjwT7iRxgai2Kc68B4YVPDvjKINM4RrJidYbeEu0ccNnqNut22JxRNg8egp8EkBxEJCWU1XazB9SZU/+sHn3ogTqlGGJ3l+n4UsjdN7ER9Av909ZlCoY0OxX9nxyVhiyLfBdxGVs4rLo3WZmsEzR8JKvkYC1HcptyKySigLCE1x4nZjIXUp/SnLoPBoTq4VzmlCjWZ6HY+1rLM7p68UmYELAohyN7WybsELeLwMkQbBsNElWFw0SaQBN5Z3vlTCsiKFYiwNmOopKa9hb++g5lL5Q2/I7LPTdrVu00SfnJBQzyfZHjfeozEiDyXphcqinztuQh8Ryr0OqPWv7xEEJ34OpbmUu5yOjb8LpZ7QAwDrMSUFxCN+D+p0ijkcjcJxmWTCxEUcVVa2dEB/X/VpU3vD8ER1ykcTD0+8cQ/ZhU5i0x0owgBrBSXVOw=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf96662a-5275-4230-b654-08d845285e7b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 16:44:56.1008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W/vKuPm0wrN/bA/ElCSt/f5VJZ31lu2bZhRjhcjCyzYGLXx1m+UKVCAH5BcDKJiD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2821
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 mlxscore=0 adultscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 3:40 PM, Hao Luo wrote:
> Propagate BPF_PSEUDO_BTF_ID from include/linux/uapi/bpf.h to
> tools/include/linux/uapi/bpf.h.

This can be folded into the previous patch.

> 
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>   tools/include/uapi/linux/bpf.h | 38 ++++++++++++++++++++++++++--------
>   1 file changed, 29 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 0480f893facd..468376f2910b 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -346,18 +346,38 @@ enum bpf_link_type {
>   #define BPF_F_TEST_STATE_FREQ	(1U << 3)
>   
>   /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
> - * two extensions:
> - *
> - * insn[0].src_reg:  BPF_PSEUDO_MAP_FD   BPF_PSEUDO_MAP_VALUE
> - * insn[0].imm:      map fd              map fd
> - * insn[1].imm:      0                   offset into value
> - * insn[0].off:      0                   0
> - * insn[1].off:      0                   0
> - * ldimm64 rewrite:  address of map      address of map[0]+offset
> - * verifier type:    CONST_PTR_TO_MAP    PTR_TO_MAP_VALUE
> + * the following extensions:
> + *
> + * insn[0].src_reg:  BPF_PSEUDO_MAP_FD
> + * insn[0].imm:      map fd
> + * insn[1].imm:      0
> + * insn[0].off:      0
> + * insn[1].off:      0
> + * ldimm64 rewrite:  address of map
> + * verifier type:    CONST_PTR_TO_MAP
>    */
>   #define BPF_PSEUDO_MAP_FD	1
> +/*
> + * insn[0].src_reg:  BPF_PSEUDO_MAP_VALUE
> + * insn[0].imm:      map fd
> + * insn[1].imm:      offset into value
> + * insn[0].off:      0
> + * insn[1].off:      0
> + * ldimm64 rewrite:  address of map[0]+offset
> + * verifier type:    PTR_TO_MAP_VALUE
> + */
>   #define BPF_PSEUDO_MAP_VALUE	2
> +/*
> + * insn[0].src_reg:  BPF_PSEUDO_BTF_ID
> + * insn[0].imm:      kernel btd id of VAR
> + * insn[1].imm:      0
> + * insn[0].off:      0
> + * insn[1].off:      0
> + * ldimm64 rewrite:  address of the kernel variable
> + * verifier type:    PTR_TO_BTF_ID or PTR_TO_MEM, depending on whether the var
> + *                   is struct/union.
> + */
> +#define BPF_PSEUDO_BTF_ID	3
>   
>   /* when bpf_call->src_reg == BPF_PSEUDO_CALL, bpf_call->imm == pc-relative
>    * offset to another bpf function
> 
