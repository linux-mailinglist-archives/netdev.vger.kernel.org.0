Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9EB185392
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 01:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgCNA5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 20:57:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15554 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726637AbgCNA5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 20:57:49 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 02E0rlxO031928;
        Fri, 13 Mar 2020 17:57:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ZDecTaF3k9dmRFA1XgJwippj6kIVujYLRu3/X44LgmY=;
 b=G7VmO5Qe/7/P370X4GS5nOHLG887CP/9c19iIge3wvHvtJQ3GHzPMaJuy6xWtbMsJ0Lr
 9tvnQxRF9N4RTHwiXpZVvgOlZhID+ohY4nmPHxaXU1kobTwBeamSxZENjplDaanzFjqD
 pXRrTo74oZiSGxixSGyTRBxj4gwP8FroTXI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 2yqt89f7k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Mar 2020 17:57:36 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 17:57:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mlGbSn1s7/SfeBdUGLvPqgvb6rMDlKJHWflZW6gygCwasDAz1stmk2YNsYfOm8WakqS6MKU9L3VvKwiWpvn53cOPlNh/BDfsKagFP/tDXr/vn0gYVVWIx1nYCDG+ziBk4mWUdaoA2cGqlEJiz3n2oa0mqvkD4TmiEJGxgABFeShwUrzv3ZYKf+KIyIuw31VlEYsyKvIADaw6/Ifgw05Ded8n7mBi4uom5502cFP/eiwqISMwePKQAM6oWat9o/vcI8v/s0MU2d6De6K+9THRVieuCvQEv8bOjWBv+PpOMPS29RgX62ig6xG4HoRQcb7zMiSoQWCcYWtu3qjiYjH6Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZDecTaF3k9dmRFA1XgJwippj6kIVujYLRu3/X44LgmY=;
 b=MeXxqvcucQ4O1vP9Zb/KGLjTMXS8/2f/JERYA0REQS4EV3rtl/oj90HbOXENlXl0c3+8BjSGafS2EVRc35/xX0wzHKZjN8lVmy2qUWZZyKe9rgv78Ko1mgX0N3BO6p0oMQXC5KC87WPr/gKYwAmRI/tGKDeJtjMDmJRNHsX9SP9kmfN1GICe90KWq5O8/giPTEB+cPMuiZzwd6hV844NkRo9SDZ2qgtm1ri8PsD4Dc7WZRqr9xECLlX3kdWnzQy1nqMIz7JqfUvjfov9HQH28ON7/FXNRCBzzO9ILa7FTLASpTgkPmyZKBAtj3mjkc+/zdYVn+E86nkaGfBdXcVGlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZDecTaF3k9dmRFA1XgJwippj6kIVujYLRu3/X44LgmY=;
 b=gprkJOxtBjvKLvV2D+ioh9xr5dpXhko3AKcHkDaYhqd+LyBRmpLzcoz98lbDjWAcKkrqZZiij968X1M1uaPvUtjjTbSx4Mtrb8vHjDLvzQQT1oNv4DXd9YJuvq+OTkFKNKuD7OoZowFiwpmAt8QUw5Wiq9x6WvPL/Fo8HTC9UPQ=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2504.namprd15.prod.outlook.com (2603:10b6:a02:8e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Sat, 14 Mar
 2020 00:57:33 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 00:57:33 +0000
Date:   Fri, 13 Mar 2020 17:57:30 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: Re: [Potential Spoof] [PATCH v2 bpf] bpf: Sanitize the
 bpf_struct_ops tcp-cc name
Message-ID: <20200314005730.ezc3eu7umvgcaadc@kafai-mbp>
References: <20200314005140.1079796-1-kafai@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200314005140.1079796-1-kafai@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR14CA0022.namprd14.prod.outlook.com
 (2603:10b6:300:ae::32) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:ad28) by MWHPR14CA0022.namprd14.prod.outlook.com (2603:10b6:300:ae::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14 via Frontend Transport; Sat, 14 Mar 2020 00:57:32 +0000
X-Originating-IP: [2620:10d:c090:400::5:ad28]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4801046e-fa9a-4b68-5fdd-08d7c7b2adc2
X-MS-TrafficTypeDiagnostic: BYAPR15MB2504:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2504AE55A4707FCA3D79039DD5FB0@BYAPR15MB2504.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(136003)(366004)(346002)(39860400002)(376002)(199004)(6916009)(9686003)(55016002)(186003)(5660300002)(478600001)(16526019)(8936002)(81156014)(52116002)(66556008)(66476007)(6496006)(66946007)(8676002)(86362001)(2906002)(33716001)(1076003)(4326008)(316002)(54906003)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2504;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wq3KeqVqWfgx8HfIKd5h82WK1+5HF6aBGdwHycqeIahX7mBbk0rgcMFBMNDFTmoq35w2Nlhds445xfsoT7Qd09LgYGXPw5kGFEXFIvjb0igQF2dGc1PbxV5RKkWyhH3XmqOIQ11GEKQZ4Ozvwjn5N1UwInJ5OhH92zVRyB0HDQhOtaGbqguQz6VVCHWnOKKMIlGmCftAJqvgIPyvV5cfzjaGE/vwXmHUN7c+xrmaYZKnNc/VX0wnM6ctyPOVLzNQwf5xBrw3Tx4JdRjyy26VFYhNUXcMeicxjCfnQ90KE3yWajBiywIPzOznVCUsghKXiJRjKmtGFi43WkCfScCyURfG8U6/y4JbeHt7a9lK0DL77JTeZeTaI6NezmLGJOhEE+Pr4CUG9cp6WFBekIaQnBZH5YwjA0zaBeFCya8/IQYBuBPpCNPLQVWeKjNM1ogN
X-MS-Exchange-AntiSpam-MessageData: CNVZIYmJJxEWLowoskeJ6yI3ERBnixK/nD2/kfdddwUTlPTRe2HxtPDl7KXYaQQT2km0TZ5wV0V+pD9uAZTwDXLsZoda8Hq4tZ9T/qyuxQXl4LgiBl3ak3bETw2cthIcOBK3dxmJiRPx++Bm2tmFHtF9WOwxXxvTEPpKB500qisg+V/LFmLL/dD3xen6225j
X-MS-Exchange-CrossTenant-Network-Message-Id: 4801046e-fa9a-4b68-5fdd-08d7c7b2adc2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 00:57:33.0766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JG3c23aclBj+jLPadFbJB7UzFbu/zKx5YcjFDvJSYLBx1h1soV8NAcPIQQUxpS+Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2504
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_12:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=800
 clxscore=1015 malwarescore=0 bulkscore=0 impostorscore=0 mlxscore=0
 suspectscore=13 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003140002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 05:51:40PM -0700, Martin KaFai Lau wrote:
> The bpf_struct_ops tcp-cc name should be sanitized in order to
> avoid problematic chars (e.g. whitespaces).
> 
> This patch reuses the bpf_obj_name_cpy() for accepting the same set
> of characters in order to keep a consistent bpf programming experience.
> A "size" param is added.  Also, the strlen is returned on success so
> that the caller (like the bpf_tcp_ca here) can error out on empty name.
> The existing callers of the bpf_obj_name_cpy() only need to change the
> testing statement to "if (err < 0)".  For all these existing callers,
> the err will be overwritten later, so no extra change is needed
> for the new strlen return value.
> 
> v2:
> - Save the orig_src to avoid "end - size" (Andrii)
> 
> Fixes: 0baf26b0fcd7 ("bpf: tcp: Support tcp_congestion_ops in bpf")
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/linux/bpf.h   |  1 +
>  kernel/bpf/syscall.c  | 25 ++++++++++++++-----------
>  net/ipv4/bpf_tcp_ca.c |  7 ++-----
>  3 files changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 49b1a70e12c8..212991f6f2a5 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -160,6 +160,7 @@ static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
>  }
>  void copy_map_value_locked(struct bpf_map *map, void *dst, void *src,
>  			   bool lock_src);
> +int bpf_obj_name_cpy(char *dst, const char *src, unsigned int size);
>  
>  struct bpf_offload_dev;
>  struct bpf_offloaded_map;
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 0c7fb0d4836d..11d96a2625f2 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -696,14 +696,15 @@ int bpf_get_file_flag(int flags)
>  		   offsetof(union bpf_attr, CMD##_LAST_FIELD) - \
>  		   sizeof(attr->CMD##_LAST_FIELD)) != NULL
>  
> -/* dst and src must have at least BPF_OBJ_NAME_LEN number of bytes.
> - * Return 0 on success and < 0 on error.
> +/* dst and src must have at least "size" number of bytes.
> + * Return strlen on success and < 0 on error.
>   */
> -static int bpf_obj_name_cpy(char *dst, const char *src)
> +int bpf_obj_name_cpy(char *dst, const char *src, unsigned int size)
>  {
> -	const char *end = src + BPF_OBJ_NAME_LEN;
> +	const char *orig_src = src;
> +	const char *end = src + size;
messed up the xmas style.  fixing in v3.

>  
> -	memset(dst, 0, BPF_OBJ_NAME_LEN);
> +	memset(dst, 0, size);
>  	/* Copy all isalnum(), '_' and '.' chars. */
>  	while (src < end && *src) {
>  		if (!isalnum(*src) &&
