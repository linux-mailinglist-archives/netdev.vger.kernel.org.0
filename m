Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2394724CDCC
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgHUGNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:13:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19600 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725268AbgHUGNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 02:13:48 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07L6Djvm003667;
        Thu, 20 Aug 2020 23:13:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=EOMF53QbM76E9+Nm9LpTTZt60bZljxaaiZuIDjQfwVI=;
 b=Ofbeg9LOUtAtqUahx/tKrJNkkY8YM+/d6cSwRLP1PzYsekBmD/GpC0gkyKLHBmgcCGZ5
 fJPqjljYDuREtPx0dtzYLQyEwsCpy5UQMWCSHCcznX9ZrN3I1A1A20crxhVGgNaM+m3C
 RY9FV7hA2ZEalCAxK86hyghQEKveC4oejH4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304m3ayr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 23:13:45 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 23:13:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JkQcywtnMNRYRTqTW37tUMkgJc0H5rElpfiDXV757HqMgYHIN551ExHrM62aJ5+q605ncr26C1p1vmoB3dS1/Y4Sm/waYf/LXVhmuR3oMsFjOIjVN+xZTG+5AP9U7ozfoQyCPXu7FyTGjkXp+FRdFklbV1gAh+gO4f1psIoU84FgnP0DiZ4b+xpqWsfqTwlkvIjqPusU9cRTVI4aSZRPFt33FCeNfPeZDYzO0nG4C5DtOL+gL5PslrLe7xFTQ0+EqnUXcJh5EcX443QEpF5Sq1axyNhEhyGqQ9OIrbvjk4qAq1PgSlGVsDwb4VHyrRxb0RZl3b3/Ewy4vdAvSYxYaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EOMF53QbM76E9+Nm9LpTTZt60bZljxaaiZuIDjQfwVI=;
 b=cenu1slvhUBVzEiBhtRgJIK/jTQn4cjKyh8btuYTTUetZd3XZI/j/Y0Pm+cejc96qtt56AGnJKkXSVjd8DUAleQKJFliovCd7j+8wadjgLybnWJofQQWkKLSdRxIO44HelXCXCCgJiQOY6r1kqynknRo1bYst0lCTWlVrBBgjGkZTe72GUx64v34lESTnErtO3RoHg+HlB4yQ7jAEsXg7K+817/4ORSQ2RCwO810q9WaLMYzsBf9efCGsHapY8WN/UaatPpW15iOJ2HSXX+9wMxjC5PEzlBzlVXQjfQOJHNdRkAtBACUbMJrXoEMvEboRkmdtq2ajWg8uV/LFumc4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EOMF53QbM76E9+Nm9LpTTZt60bZljxaaiZuIDjQfwVI=;
 b=Xcf3kdZhp32JrUlilOTFpHVgEMuKiUxTS6ombsdA/D2+0pqVFz/pu0lsL9A2Y23Gr1/FWar6u26N3poqEaV45/XbIZdwrmirGaaA33Fwl7HvGr/345onWKog8vJ2xr3ixKswNfM93QlxFa1FXykxjop0o4P6WN7Hns4cI+jqd0Q=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2325.namprd15.prod.outlook.com (2603:10b6:a02:85::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Fri, 21 Aug
 2020 06:13:10 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Fri, 21 Aug 2020
 06:13:10 +0000
Subject: Re: [PATCH v2 bpf 1/2] bpf: verifier: check for packet data access
 based on target prog
To:     Udip Pant <udippant@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200821002804.546826-1-udippant@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <9e829756-e943-e9a8-82f2-1a27a55afeec@fb.com>
Date:   Thu, 20 Aug 2020 23:13:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200821002804.546826-1-udippant@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0016.namprd16.prod.outlook.com
 (2603:10b6:208:134::29) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR16CA0016.namprd16.prod.outlook.com (2603:10b6:208:134::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Fri, 21 Aug 2020 06:13:08 +0000
X-Originating-IP: [2620:10d:c091:480::1:a192]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4163cf6f-7935-4bcb-78de-08d845994758
X-MS-TrafficTypeDiagnostic: BYAPR15MB2325:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB232508CF0AE6A211AE8F5ABBD35B0@BYAPR15MB2325.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M9TZXvatMWWXsNQ2uV7bC0Fsd3AVPVMMrFFkpeF8sguiR7HimW7RrFGxjKQIV1qYeFXyEzLbAtkcC0XxwWXykmgaIP+XdY3HkYKYoQ62BhN6K445u6vybmS5Wk4BsI8aykB/Wbr8lCpERN6vDPnk9BpmH6E6p65MzaK4zXlJpDnB35NjiaXCMsNgtAKqpZoahA1s5MjJlCuwhQdDiRGrfCt1NV3YXt3Kuu+jYQ/0IBtctGYPn5bLWyHNhGwtwDXvQ+ubcIk0pzlUe4qdDnIq/CXCQ6W2dhuFtXprV7RRM8mhdhYJlPMXtZlPCvM9yD31Vlao/XLbVmFUnSU9/VH/JV25Gc+AhVxTJyd5h1gJIyS1wJOwTGh/hg2G0d1X4YJe1Rut2xJN0be2CdVKDuOrZgi9HMIxEghY1GGiGZXLY5g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(136003)(376002)(39860400002)(186003)(316002)(6486002)(6666004)(110136005)(16576012)(110011004)(52116002)(53546011)(83380400001)(86362001)(956004)(66946007)(8676002)(2616005)(36756003)(31686004)(31696002)(4326008)(2906002)(478600001)(66556008)(66476007)(8936002)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: JhMuQROGGnCq3lJ0qvUPZMNuOnex1Pi/ho6RA4BVcrybdjl2ncLS6G61RAh99cAkxFm2CNUXlqlXMIXw7BUo7tHz/hjDPeLiVf6NoHSqCGtxlnz28SfXNp4FTbdcqMIYpBSePXh0qRvWsezrgHTpiZnYtf5jyFwM7OzwLipdanxwNc4+zvffo4rkL5xReJORhx9VTEoyUNXgZtf95uRB2wJXLGi11uQZUMC7bwvpCrk27fTkCPpUmzhYsZKpeWaV8VTu+86vXpknWQuVv+FMhk/r78vCU5uQLR95xp/oU8lekiBRzGw09UHFHDua73TJDNt5sVSjVlrnYLiw66Ps6HQn5QjZ9o77SkQJgDBxNeKzBsLolv0FbN6AaxCdbj+Gq2mIVdzXV3I1Dg582W5FiivD5Uf23pTfcbahrQZZGJQlFm+hck0QyV8JTuBaZmRiKuhlspVZD+8JLpsWjAUPzo2LJBt5QJf6g2fDI6a6759h3xfzAjBU8Hy4fISpEtrMOaz60zG0SS48KXOSXbxCdLPXX7aFEuEqaNTPviYiFhDnu28Em0fnxi/UYM8XOcVI14EfGX1fiG1BMWpqC0TvtXOrkDvnQd8k4AE85AiERncfWRM/kIq7eVMODt/VsbyL6rgoyjH/SNG13tO0izVEkzBH+Q/iAFpGwfwncQFwZUtATJEZRLOi6gXedAIOR9/A
X-MS-Exchange-CrossTenant-Network-Message-Id: 4163cf6f-7935-4bcb-78de-08d845994758
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 06:13:10.5826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PkfPSg889O8arSs7hGZE+62H/YQcCkCn+jQPCfbsiTI7DxiRMtBJIBfKtqro5YSW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2325
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_05:2020-08-19,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210059
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/20/20 5:28 PM, Udip Pant wrote:
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

I checked the verifier code. There are several places where
prog->type is checked and EXT program type will behave differently
from the linked program.

Maybe abstract the the above logic to one static function like

static enum bpf_prog_type resolved_prog_type(struct bpf_prog *prog)
{
	return prog->aux->linked_prog ? prog->aux->linked_prog->type
				      : prog->type;
}

This function can then be used in different places to give the resolved
prog type.

Besides here checking pkt access permission,
another possible places to consider is return value
in function check_return_code(). Currently,
for EXT program, the result value can be anything. This may need to
be enforced. Could you take a look? It could be others as well.
You can take a look at verifier.c by searching "prog->type".

> +
> +	switch (prog_type) {
>   	/* Program types only with direct read access go here! */
>   	case BPF_PROG_TYPE_LWT_IN:
>   	case BPF_PROG_TYPE_LWT_OUT:
> 
