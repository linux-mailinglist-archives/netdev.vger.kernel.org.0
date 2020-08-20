Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0704624C492
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 19:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730613AbgHTRbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 13:31:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54724 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730589AbgHTRbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 13:31:23 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KHQE3a021191;
        Thu, 20 Aug 2020 10:30:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=qDwBvVqKcoSvaTIhCpbnVjxNbOMVrOb+ZHZPF41UqPY=;
 b=h/RcPGSzHmjxluPcF+m9mj1+N0r9/l+PxXfbnxWPR25Rz4Oy+af5rdzbajqiGbeRHseR
 Shbi8XkySFwTvAefGSUXbiy7T58RikyQE1rJns+G2NeU9GBacs1tOq4pxI75QgrmE50k
 2g/lM9PpKUe9noP2SzXb0YPMAHn+Kf6/Tng= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304nxyfpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 10:30:46 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 10:30:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEyife0RMLwpXzbfFHA+Nek13X21wv9eau7g7QrN2vv4dCjy882sh9J52QDG0j86hTNIdeqclVHziOAM6mrCgSDWrHFa77Cvpq/K5GtbDzmYy27jX89DPe9grNT+l3mZ2KkuTp6mUTl4Cw7dDBq1tgXMTswmh3UThNMWpiFnN1T6XB/Um7cx/y16fuX7ja9mZLW0yjvB+pF3siZA2VXBKcxhrAn2sGSZG7PUurMHR5IpBFlMPNXivMFq3f9ZMOYckuS0cZsHsleXg7zO/L3OoKyM7lU/KXXlQ+MgxVtpGj76dhgNU1ahu0MRlLG7WM7EUbL507y0AowcaOqrbGb4kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDwBvVqKcoSvaTIhCpbnVjxNbOMVrOb+ZHZPF41UqPY=;
 b=VDRKluZItVAh9FHRctTo9oHraZV5VdHXt4pkaB1RtpsB91z/CwzO1U3DCv7KVOvXAzsrpAWxbNPHC+Y+aKOIZ98c1aMb1TiSCE4gdDJGIrOUpTDH+DFFIfeXN09f8xWtZlW2oeQF6At92C+9sDf6tQWdq777mGwZgglCEFcNEOp1V6aQPE9nzXOLABEpqSpC/1xsazvK79hLNYjgiNBnmkFzKR5zksccFVlddCdcri9y0MIdniycD4jQmTNLCHnkY/KAezJ7Scf4g4O8r4Wt5OEurS2PRc6zTN9GIKX2uU5Fo0DzJYVuh7FmlftB+1VbULud8B6ZRwFbc+nq9bgWEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDwBvVqKcoSvaTIhCpbnVjxNbOMVrOb+ZHZPF41UqPY=;
 b=kkc/M1YPt5OLB1HDlCQnvsFMbMt4eI9EEfURB0+Ts5WuLjeoeDR9mUpdY330V9YfY2g2ZyNeBlkCe5x9+wMmi76pOuRT81qTg+j+9ruH8nIvJJh9PvWtuRP/ndJsldp9FKjHFWNSNS++JDNwqAVmXETURefLi2danvCuzQVpixU=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4085.namprd15.prod.outlook.com (2603:10b6:a02:bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Thu, 20 Aug
 2020 17:30:42 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 17:30:42 +0000
Subject: Re: [PATCH bpf-next v1 7/8] bpf: Propagate bpf_per_cpu_ptr() to
 /tools
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
 <20200819224030.1615203-8-haoluo@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f9df603c-f909-a90e-6d92-a661cd1248d7@fb.com>
Date:   Thu, 20 Aug 2020 10:30:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819224030.1615203-8-haoluo@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:208:c0::14) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR05CA0001.namprd05.prod.outlook.com (2603:10b6:208:c0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.10 via Frontend Transport; Thu, 20 Aug 2020 17:30:39 +0000
X-Originating-IP: [2620:10d:c091:480::1:7ec1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b0b66c5-6bda-46ea-1e26-08d8452ec374
X-MS-TrafficTypeDiagnostic: BYAPR15MB4085:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB40853252B630E3068BE3D8B0D35A0@BYAPR15MB4085.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XHfGckv/KlGyjjj+WZjrZea7HgZaq+qCzjz6H/gZR5YTxCSeu0epKfuDLWSQZhfVeD5rQw7pJpl/qV/OIiIVbBccNWwc4GnGtfS4O6Cz+yzBx1honQr6RmYJiCDm+C1wg/rmjpXsjnPW6XS6S82oLfs5MmYvHrimvUoUS6swI2ZrZXsxPxccKcddFATbIHkdDaG/fUQ29e3cpaZ7j95J3MDWZLuTml6ZIN9K8UK9DgH8WAnFnInEi2wjkK/wFBRMLuVsJ4h5uNC3CMqvGvq3dcrU+8eEVfYyJJTm4LJrjjrT3E8WlX4m5LbFBdYeUQytpowB1/W0oWRtjmuNmKlF9MpfhEHouF8KtN6HvagWWF1s59gOgh9NhYcBwl1VlQFbL7WfSTcwFlWzesSlRpp3CKMiIVr7Yyj/TCMz3qvg3Ag=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(346002)(396003)(376002)(8676002)(110011004)(31696002)(186003)(8936002)(16576012)(316002)(83380400001)(54906003)(2906002)(478600001)(2616005)(5660300002)(956004)(31686004)(36756003)(7416002)(53546011)(4326008)(66476007)(66556008)(66946007)(6486002)(52116002)(86362001)(6666004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: dNqBPvhtQXIckLQd5GK3KKTMyTLZSrQVrhn7Kpc2RiUrSbERr3JhaH6YfHdpnRx7p7+/EdP+ONvcs2NgndaG9epgyqtFj8VHmuTpr+T8MX5T6qk/81FUd/ZJQXjMCtO6MhF/dYThqFQTpITx44e83lVrxATYlo1wfT4Uk5A+N7s8SFnUH+jclIoe2hoSkibDMpk55ENJOGFQCTroiZjZFSybm+kmPb9narLmEWe+lBWKdUiig10Xe1Mca84816vDRbHDxlqfdNSwWI6UyaP9WbOLsV/F8Z2TNxJMaKQ5vnuc24Zdx4YrV9GEaZ+hOoJd7kV7AD6qp9TcdAbZpMx/CQapuklMYTutQ7r2AITxYzKKapPJSVhFV6lvF5JcoXN0Tf2SMulbP9FsLay4yzWiJkphURgMfk1V3yXACaWU/pBYxzKgNdBg+sEWnkr/i6B1HovliZlLB2iRr2kIOaB75IfLOwU3Xqd5HbG6HGzmBC7S6SeK7TkySdqmp/qGgAZcqdk4d6rHMIsuol9kTtvlhQuTngV4C3Djl1DAKVhOmXdiZAuCKcwGYbqT0eFl+60cIe9xMIuUQgiALlEhklPiEuCZeUrw8h8R+8JSHoyqu/czNeMk6Oc80aZwVFji3hAVtJW4oTjVcqRxIsj0GRu5eVdqg89xoWx/EiQNvUhav+4=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b0b66c5-6bda-46ea-1e26-08d8452ec374
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 17:30:42.5093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VWFIVMST4+Rnb2UQju/0D8i49AHqPXscjSJft7DPxywEriPA/89BxEIPDelh7Nr5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4085
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200141
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 3:40 PM, Hao Luo wrote:
> Sync tools/include/linux/uapi/bpf.h with include/linux/uapi/bpf.h

This can be folded into the previous patch.

> 
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>   tools/include/uapi/linux/bpf.h | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 468376f2910b..7e3dfb2bbb86 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -3415,6 +3415,20 @@ union bpf_attr {
>    *		A non-negative value equal to or less than *size* on success,
>    *		or a negative error in case of failure.
>    *
> + * void *bpf_per_cpu_ptr(const void *ptr, u32 cpu)
> + *	Description
> + *		Take the address of a percpu ksym and return a pointer pointing
> + *		to the variable on *cpu*. A ksym is an extern variable decorated
> + *		with '__ksym'. A ksym is percpu if there is a global percpu var
> + *		(either static or global) defined of the same name in the kernel.
> + *
> + *		bpf_per_cpu_ptr() has the same semantic as per_cpu_ptr() in the
> + *		kernel, except that bpf_per_cpu_ptr() may return NULL. This
> + *		happens if *cpu* is larger than nr_cpu_ids. The caller of
> + *		bpf_per_cpu_ptr() must check the returned value.
> + *	Return
> + *		A generic pointer pointing to the variable on *cpu*.
> + *
>    */
>   #define __BPF_FUNC_MAPPER(FN)		\
>   	FN(unspec),			\
> @@ -3559,6 +3573,7 @@ union bpf_attr {
>   	FN(skc_to_tcp_request_sock),	\
>   	FN(skc_to_udp6_sock),		\
>   	FN(get_task_stack),		\
> +	FN(bpf_per_cpu_ptr),		\
>   	/* */
>   
>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> 
