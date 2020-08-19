Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDD72494D0
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 08:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgHSGD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 02:03:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21290 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbgHSGD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 02:03:58 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07J601vG014351;
        Tue, 18 Aug 2020 23:03:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=NVJsmiKn5/9d3NYKqPclkm/spQAP2nPm7MLboLy4myA=;
 b=GrMWY0DR0itNSuMZrLmuvaTFvXcvlnGaAwG+wM24O/5cilk9m+Lv1Ug2kA+M2uyaywFi
 9swIiItuE/8jcc95LrsDhc/dbalvS8Ejd9OHwls59UmqW7PkuzlfWHQ5p7yFaT4l+Ihm
 A5zWDJhZxNzNRBE5kzL9JJ44anRrPRg9bzI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304nxptrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Aug 2020 23:03:53 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 23:03:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ApopTe7h3vGF6W5wYJm3blbFERmO4dY5RidfJt9vCOB80Ut71Q+nbiH3TOCgMMMuX4wqidlJ79gDueizV21IrZq9yzogkAbVAcPSU9FXbL6FEi2dNNHtCvtZHtkXkZj2gSI7uDDtjT9cpjefw4Nki5iLO0UTQVTLFY+GfqJNruCY6Rt9O87JGx+tWZAhbo5GfiBKS/VbTwnqyazpOUuk1XyC8vxjZOXZdhVLUO/McVR1hc2VmSwF2W8PVpoP87vSKNleygS9y6nmgipGul8k/eGZYUU2rJZBcmqlvlUzZlQzwOcNc3FH98fXmkUbxeEFDk4WbU2zYXRQq0/XX6zmZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NVJsmiKn5/9d3NYKqPclkm/spQAP2nPm7MLboLy4myA=;
 b=hVIjri4xGJheuhrz8Tr34Rgh/ApD3pW9Aix+vbc9D0Dy+yu1MAU1Aehr4D8QCmnqAjhd620IuKPQu8SGDsIUyzwwG7OwoZL1RkM2rZdlnKp3jgZqB6QELAm2VEOlo0ErP0vz6LZrXRFj2jkOTQ+EuVhpCW1sCwdtg8kzAW9NSqv/p3Bg9XM+bCuTL4Ir6R5zy+/laN3ue+qiDFmh8SsH+GXeKEtFxybgM3dZ+eC6Xvvs47jMqf3+n7mLfzXyT8c3SY5x7VX6JdvfnQPkuQpC63iwcQbs96+9q9+/ecRfCfVd7EJaSeAWBPai/KemNp+fMC1Is6Xlq5b50ifW10PHBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NVJsmiKn5/9d3NYKqPclkm/spQAP2nPm7MLboLy4myA=;
 b=XMDmD3STxyfqaYZtYEEmDzYwzklgLg+5iSMz+yjBeHDMBWhIzoYY1nXyKCf4wpSb9DC4hQD4XMSIFeoYRSwvcv1j/7ceeMz9mqBcZkJHl/MbY034ikVBOdsHQDaQrDX8i7guABZSjuiY8jhk9tuFwISDs7Jjy6V2apYtLCCWjN4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2583.namprd15.prod.outlook.com (2603:10b6:a03:156::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15; Wed, 19 Aug
 2020 06:03:50 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 06:03:50 +0000
Subject: Re: [PATCH bpf] bpf: verifier: check for packet data access based on
 target prog
To:     Udip Pant <udippant@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200819011244.2027725-1-udippant@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <fce8d46c-ff72-f885-b8a4-06813f832375@fb.com>
Date:   Tue, 18 Aug 2020 23:03:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819011244.2027725-1-udippant@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR11CA0005.namprd11.prod.outlook.com
 (2603:10b6:208:23b::10) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:374f) by MN2PR11CA0005.namprd11.prod.outlook.com (2603:10b6:208:23b::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 06:03:48 +0000
X-Originating-IP: [2620:10d:c091:480::1:374f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4ce6b35-374b-4e7e-1f88-08d84405a505
X-MS-TrafficTypeDiagnostic: BYAPR15MB2583:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2583EDE6AE428E2C8C0FA28BD35D0@BYAPR15MB2583.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ub5BJlenDCcEAz2U93iMQCaZK5CkWZ+JjN7AO7WC/2LOXDwUmfTDNao2/s16IUeNZ+yAJE+onbrS89rSdZlUUdrcfdLLjtDrSB+kJ6tSS9BeAXMG5OGl8OEPJCIkp0fIT5r887e3wnPF6PoOqLai3B9Ab8k4EWIpbpmqiFAaktm/ladTwE/f5B0XaCqjzULZ1ZbE4VRwcRdmVICu6oglevT1zmSi5BXNWVr5ItZ5n6bOa2SNiV7v5ZoxMC0zfnfhtZB0bgRDs73rvM6N6vFWBZ2LANi0qhsgww4FPFfc6MzN76B2AumPwKVfKr7sAjZAVfdg6OOqnZiWLY8FQWdngb4m0peAMHqpflKKPefVAwTcukY8UdWzYUprQz1RyL07
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(366004)(396003)(39860400002)(6486002)(478600001)(36756003)(8676002)(83380400001)(186003)(31696002)(31686004)(5660300002)(4326008)(2906002)(52116002)(16526019)(86362001)(66946007)(66476007)(6666004)(53546011)(66556008)(8936002)(316002)(2616005)(110136005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: wvXXA2TRgYnoeqYuwuxIRAwEqstWc+bQaJjlTtKfUnR4DvOAZDv56UAmh2WSy6M+63j+gdpCIH1OUd1sBDwTf286XDpx0hc9fcZTOYbHURd1z3hRhX4BImIhzsfCNC8dM8C/vv+KyuWZOTgcLPLkGd50/AccHPOMkkDO3R71hPPlJe2gsJgshDXaV92Jb14hwI0uIbxyEZwX9Jqb2t07Z7qSnqBV8ZMhBvN6n8rZRtKJ5FD0U2yXNefjqrsZYOD8Sk8v9ikuRwxnNFsYXwLoJi1pK0levFIy10py0UuXDVADPr4Y4eM7rv40eQAIiV2DB55GrKwcnD3XIQ/DBQh9PjTBjgm32EHHTEOI3qhbSNpvxpzEFkpmlKQeUi9EB9i3Fm2h1x/iCq2n8cVxQujjg/k+1DUup59dZPzwvaVsBuzK8ryCzOoMINJ8zw4vmTy18Tl5L7TqPIJmkS55W0LkJmGi3fF9TBMHxw3x0vGBJD0W9u810Dl6B7damhcH8QtLx5U8IL0jV2TZIY1Xc5dviMggtyH+u8YdTDCc30t+eBflwBlbQR9uxgziUClKcWthdgifDOnkqby52x8F+gF1Zn54ev4AzAh//bkcikaFyJANx12RzVr6wc9iccIZE4vaCaUNLuKz/dBzloDwF9YMWL+02/7P2JFXaSXiBNeJ2Mi7wf6LWZfc0YxNZw9Suedv
X-MS-Exchange-CrossTenant-Network-Message-Id: b4ce6b35-374b-4e7e-1f88-08d84405a505
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 06:03:50.8845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1kf8e6AiWH4UCsmh7BTSfLv//iVFtPzqYhL9s7+ymTWaCKv92D7tbZNv0fp+2XYu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2583
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_04:2020-08-18,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190051
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/20 6:12 PM, Udip Pant wrote:
> While using dynamic program extension (of type BPF_PROG_TYPE_EXT), we
> need to check the program type of the target program to grant the read /
> write access to the packet data.
> 
> The BPF_PROG_TYPE_EXT type can be used to extend types such as XDP, SKB
> and others. Since the BPF_PROG_TYPE_EXT program type on itself is just a
> placeholder for those, we need this extended check for those target
> programs to actually work while using this option.
> 
> Tested this with a freplace xdp program. Without this patch, the
> verifier fails with error 'cannot write into packet'.

Could you add a selftest for this? FYI, current selftests/bpf have
4 freplace programs:
   fexit_bpf2bpf.c:SEC("freplace/get_skb_len")
   fexit_bpf2bpf.c:SEC("freplace/get_skb_ifindex")
   fexit_bpf2bpf.c:SEC("freplace/get_constant")
   freplace_connect4.c:SEC("freplace/do_bind")


> 
> Signed-off-by: Udip Pant <udippant@fb.com>
> ---
>   kernel/bpf/verifier.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index ef938f17b944..4d7604430994 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -2629,7 +2629,11 @@ static bool may_access_direct_pkt_data(struct bpf_verifier_env *env,
>   				       const struct bpf_call_arg_meta *meta,
>   				       enum bpf_access_type t)
>   {
> -	switch (env->prog->type) {
> +	struct bpf_prog *prog = env->prog;
> +	enum bpf_prog_type prog_type = prog->aux->linked_prog ?
> +	      prog->aux->linked_prog->type : prog->type;
> +
> +	switch (prog_type) {
>   	/* Program types only with direct read access go here! */
>   	case BPF_PROG_TYPE_LWT_IN:
>   	case BPF_PROG_TYPE_LWT_OUT:
> 
