Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD8D49D36F
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 21:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiAZUbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 15:31:06 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24628 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229907AbiAZUbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 15:31:05 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20QJf8km005283;
        Wed, 26 Jan 2022 12:31:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=jj30S6gLGpOAgnqfijPB6WdEZPOAKHl0PS/0/5BwOyw=;
 b=E1I+fltOMMZioFSoHl1w43+zX7+qYUcA6V+/k9ECjNi1dXqFaS/gcXYAXREi1o3yikN6
 uvUAVPbNUxhEq3SphjXStNykwFwfRlUflpvOjYhL4gF/lDjKiNbHXPmT06+SjWLTEWVy
 E8m29Q7k45b7TBCp6tIl80jaUPsckQ9jocE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ducnv0b5k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 26 Jan 2022 12:31:00 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 26 Jan 2022 12:30:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4rjqh7vmG8KsXG/5WDuFUdvVjjaDUi10EbxfXZg/O+zaN3VxNPQV1jKObJnF/diDJRwm3orA5CGBqZfG4261xMkZi0TK8cnEmuVtqgnKZpBs/wA2nGKATCecuNeUzgrEfnQAANRqc2635XZDLaV0a+P6Uz3whgol+r6iCtX5b6TolVqSBxzewuPFCWpFiaG7swKaa+ZY4LZ1iOfO6TH5z5fnhiIq31GbKaTLUDLzdU4hUuuJfdhNfy0BF6i3AB6X3g07UTD3M1pgGbKvdza3XQVLIGR5oHMDmQhA8+fPEv3uKZ3CBIvmpYlNv4UxCSPXfPkPLyIpqtfm/n7e78rCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jj30S6gLGpOAgnqfijPB6WdEZPOAKHl0PS/0/5BwOyw=;
 b=RNhNqOQuhY/X0vZBvsbAJPHnbeWLHt3DwIXGlDPGN5NM7uTgmgSYM5govCmrUFY8VgpjGjvSR/DyPVFcLERXD5S1kmIR6h6NxYCxDt2950J+95wCQbzaQcqKvfspbfZm/dg8VnW3jI+tsNGrPVKhmxJAGXm1VJVo6YZld5kn5Wi0PJiNNvSofrMQLZObI2OaX6Ianms6myrDsis/eJnWZuzQK/9uaTK/2lOyn6KztI8xK0af6CqayaEepfsimn8lp2teOuSQ1DQ4r8wjNsvv0HRxO9uMAdrHmwDyGm1NBX59adV2YOCPR64ma5yy6jf+EU7YbZYo1nCAHcoT//HxHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by BYAPR15MB3013.namprd15.prod.outlook.com (2603:10b6:a03:f8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Wed, 26 Jan
 2022 20:30:57 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437%6]) with mapi id 15.20.4930.017; Wed, 26 Jan 2022
 20:30:57 +0000
Date:   Wed, 26 Jan 2022 12:30:55 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        <linux-kernel@vger.kernel.org>, Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH for-next v4] cgroup/bpf: fast path skb BPF filtering
Message-ID: <20220126203055.3xre2m276g2q2tkx@kafai-mbp.dhcp.thefacebook.com>
References: <94e36de3cc2b579e45f95c189a6f5378bf1480ac.1643156174.git.asml.silence@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <94e36de3cc2b579e45f95c189a6f5378bf1480ac.1643156174.git.asml.silence@gmail.com>
X-ClientProxiedBy: SJ0P220CA0006.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::29) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 512cc3fd-29c4-420b-7606-08d9e10ac253
X-MS-TrafficTypeDiagnostic: BYAPR15MB3013:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB301343F823E349E8C77F78B0D5209@BYAPR15MB3013.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AJHnwHU2ZCiXCz0fjd4yU0RPVrM+bCBjeSXOJYSKXy+WJLw0DOPeZ64SA8lxQB0kFegK1034cuKw6DbsB7DbRfq9VFDscadXw1ucQjfipKzywZvUVyBVdxxIovT9aFdyE8RL0DkFcPatyUQ/4PM5W45bdmGxwPQ55aRuhRfPhR0osVDnFxxYUQRSPtTkMiLDOG7qsH5BcNxhO9MEvv+WuSiKcpsWdRufeUEo1vV3gSeMYjT7Fjw2R3NuqrVJUyf3iburRBfiMzYUpxcomi54mIB1YN4Y5CIEE4Tbh5DnFqNpn8OAgq1Iiq9O9AVVZFRAGfux66JUV38z6BshR3At697y5o+5iq8jxwmNZJNkcX2tJhZyKAxsLIlYlrrn0rpAPsYYVXUK1uKvKa+JquT1R8QHAzl2mjEUjVYy6Eyuz0XcNus8gEFhtrGwhN4WB9OB+313Wj8sO8/guIYfE6Ug1abrpX15n8XDSE9NkMsu8n8zcG2+yfxaoSImKfxnpqiGTIunN4m5H1osRks10S/mLKfrYJvSuvrgDjR2LYxZlQlhVtX1aEtqucelQzqMi/8J5g5xV6W4hmKOf93yVTIcmXiRUf8w0tvL+mRlr9p3YFDGKZ8OV+vy+tOffQ21FFlDrN09pwPF5af8vfbgjxAzsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(4744005)(5660300002)(38100700002)(2906002)(66556008)(8676002)(8936002)(66946007)(316002)(66476007)(6916009)(4326008)(86362001)(508600001)(9686003)(1076003)(52116002)(186003)(6486002)(6512007)(6506007)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vYA58QwL/W6clYeiU8oEgGPQXj7+6JXfK0+8XvtO+tra1nrGxdJelHzzDeNt?=
 =?us-ascii?Q?bkCqGXx0UD1PaDTZa02NFRblfw3qqVhOiQxckqmDbxzGYCWuQh16mr3Tw4o3?=
 =?us-ascii?Q?HiZPrjqTo7iOrJ6QcpA8xB7Ho0GDOw1WH7LRpqiI5xPkUCuRqKVvjCKX64tb?=
 =?us-ascii?Q?lB6Ba3ux0IZDug8p9ViA/u1i9z5uMIR9v2roXzEdLDgwTi1vx/IH+O4RDbhv?=
 =?us-ascii?Q?X6mpFaDkm7fMkYlB4GelVR79QGqKrznJ83jJq7nWj0p89qSa1pDp1x1haxAk?=
 =?us-ascii?Q?gA//DT4Fg5oY9EEA19JbkPzM+PMTezBR0TVlJw9im8f6G4NfwxbAzZD8NtbJ?=
 =?us-ascii?Q?/eW9nB2VG/HkKL5p7vpegX82h5R4ZtMghp6nME27kiwQ6Soko/U4j7Vy/V1u?=
 =?us-ascii?Q?JjxVePb51IfW+L6EONerJ6ao3XOHNNH1wekO39Uw757c8+5x2XvZ1etF076Y?=
 =?us-ascii?Q?TB6+cZTFox5R69sxOS16rG2YaBLC2weOwhegJGpyqHrtvlmwY3UFgg5cetzY?=
 =?us-ascii?Q?y4fxm4mZLk4Ee4HGJtIiFupbS4WLxE78A5gnJZLIx9G379HbYOgw9moDKLTh?=
 =?us-ascii?Q?Jm35mag3DhRnCNC0GAzcEPU6l7kBg5zM9Gp+kT2sXnzJDCAwpZ0IUBcZFgxB?=
 =?us-ascii?Q?U/F1CTwtaBevsCJT+T93MmzMB6P5reiRL9aKAqv1TBN0GCCQ4cmSjgq7bFtg?=
 =?us-ascii?Q?RDb7b6odPKNKWT1xOpZY121ju4TTRXMd7c0vVe2sILXXDY+dFPjdQIdKBtmd?=
 =?us-ascii?Q?PkJCkEMlBbHESd+yH+lop55HpPkNMfVtD7XcdrjSWM+Dab3mj8jLZgb/+JUA?=
 =?us-ascii?Q?mZJsvg+Y6t7W4Sck3RnuQKzEPdPG1g+g/bbKO7E4uoMY5ou+di7XUm4WS7+U?=
 =?us-ascii?Q?ncYeeQDTgtxoIKQLCuhPiRkg5y7FcvtUkWoOr/ZcQ7DBJRYeONpM8paR9chO?=
 =?us-ascii?Q?1S/i3v/5JISN3vx5LLKPt+lHFj4KrNb6XOWJnRd3gbGm6SiKdWIFFfDiEqX/?=
 =?us-ascii?Q?UJmpAHC7jub1CDmTQhimLrLeTX3KlrzN1wLXUrXQKdabF++ggtS+R44649Ei?=
 =?us-ascii?Q?8Grx4ipXImqYxKojm/xlnhYvQni8VS0FZ2+i62nYL5bR2HnRb/E0JBcPxGsV?=
 =?us-ascii?Q?ewYxTzUgBPhVhtAl3/GM6UyN9Jnx7875BAcJfYFO+OMl/kzFO+jL4ijYRixU?=
 =?us-ascii?Q?zUF7A+9qGIPwFyLdOToSfyW7Ar+PcR6beYsumJRq/oWFQOUwzLLCi1FQAB0w?=
 =?us-ascii?Q?Wmg6YDCV3iHG/eGXx4mJ0BloemS5YfluvIpWO86vWY5u4gYVkd4HylXSCGNn?=
 =?us-ascii?Q?TL3TOgkfNErA9P+2zOKFJMym9sAL3N+yWO52ezl0CWFBdYYn1Oa0yR+Vn9v+?=
 =?us-ascii?Q?qx1RBUVjWqr0tIXqc6bJq0fhqbE08irjtIYHNDkPwqzCIpI9iP15y/7LfYtd?=
 =?us-ascii?Q?QNBxRtPBS4xGzI8ze5K48Uv15HvPtHPjzAZ+25Zg0q/55mYR4G4aLF1TX4/4?=
 =?us-ascii?Q?5keRppRU6Bnw4y8/KQfP6A5mNf77+CFolKu416GJp8fM8riRnFq1l0aKVw6s?=
 =?us-ascii?Q?3mrt6oj7l+yUpR1cjbdOFx0hlDgUSzGX65tGMDuy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 512cc3fd-29c4-420b-7606-08d9e10ac253
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 20:30:57.7203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U38anm8q9e7RBdvjN5IDvTonpJXyOOuy8EuFsid01feu4KaTckJZ9Mba2tGcmpuJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3013
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: EemO1T2ny_z3y_TCt_9IuM8Vt5S8vYi5
X-Proofpoint-GUID: EemO1T2ny_z3y_TCt_9IuM8Vt5S8vYi5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-26_07,2022-01-26_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxlogscore=566 bulkscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201260120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 12:22:13AM +0000, Pavel Begunkov wrote:
>  #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk, skb)			      \
>  ({									      \
>  	int __ret = 0;							      \
> -	if (cgroup_bpf_enabled(CGROUP_INET_INGRESS))		      \
> +	if (cgroup_bpf_enabled(CGROUP_INET_INGRESS) && sk &&		      \
From reading sk_filter_trim_cap() where this will be called, sk cannot be NULL.
If yes, the new sk test is not needed.

Others lgtm.

> +	    cgroup_bpf_sock_enabled(sk, CGROUP_INET_INGRESS)) 	      \
>  		__ret = __cgroup_bpf_run_filter_skb(sk, skb,		      \
>  						    CGROUP_INET_INGRESS); \
>  									      \
