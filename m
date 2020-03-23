Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE4318EF6D
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 06:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgCWFcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 01:32:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33104 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725930AbgCWFcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 01:32:48 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02N5VvfB013682;
        Sun, 22 Mar 2020 22:32:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ABkLYonluh/vC5BtI/uETa9akND1QvC9IGQQ6vrohPM=;
 b=k9MhAEVoR9klg1ROBIcWpFdCYco5HvCeNgByaayenulH43gqnFclXve+omSWLHIPnri2
 +HQPWd3vSg3VQrSe2zSrDKfcGBWx0vzSV1d19bXQf7TOJg+WnOrfpD0NewWHb6RtEuTk
 ejPLQa97Tl36HH7l2zx9By2o2sfol3SGk8U= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yx2r4kb2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 22 Mar 2020 22:32:32 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 22 Mar 2020 22:32:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XnGxt67UxN9SlXikrOxQkaVbyzyWr2MezLAPC07Wm/OcA/WOEaKikOIgJ8u9b/0UN+36ggor6bqLCvER/asCW8kuou/+ADqJsYCq42i7z7zjWSYgOltU1X0Ac7NClTQc5kGlA/tylCMVhQp5U2SD01bbolXNuW2J24yaKRCt8BVJ5Guv/1+k2ym+VSPFauXQ/Xqy06WNZrBVxt2+nCSIgXqTTXmPqaN/BUZKzIKTHQQ582OjuLJFPo4BCvUPekOtPiT9EHrgl/6aSktwOk7z6uBRautlA/p1+FkahNfXw8G0k+WvoNiIIpl86Hcj5pzmpZo904SJjc1ckZTTRCPkDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ABkLYonluh/vC5BtI/uETa9akND1QvC9IGQQ6vrohPM=;
 b=W8KHM8jz6WcQtjCErXoNhAjJxLILXhHI8Qk2gLTL39Fd3oki8SWUfJTt25kMeit2IDs6eiE492PJeg4+Gx11H1i3//kpvxnqolsGlYr3v+u/NwYBeSHAQ5QCeG1dqxKvaIOAeBpx6r1RATVNysDRTHr8UB3B+/0o67MJ0sWi0iNVidOg6qlmCHdaFSH0ABy1bn56+PfdRPO6UWuFs/VnITVWGUE7uJTLihZYsiFPDKuY2H8nfDkd+BK/5iDP0BiVzNkZm2VHKu+i5lcPLFybUob86cYCqhh5vKov2LLadLCAa6ICBaLRluGB23XprIBYb17whfnijGoESFeftPALYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ABkLYonluh/vC5BtI/uETa9akND1QvC9IGQQ6vrohPM=;
 b=cZIBD8sDfivKnzPUjJ1//CUhZn0XdB3mxTZUqAWaZbkQMHeJfPiwQQJCSmzfSbgsvTpXbk2KzkEGXGIjAS5Gh87Eitu+/jF1ptQrfs0WC3lomVx7Qpa4QfKIzcgO27S9FoGxL3hXkIdJZuo9VHxMD3LWRuqmWlIlvq7iT9YdiKo=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3865.namprd15.prod.outlook.com (2603:10b6:303:42::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19; Mon, 23 Mar
 2020 05:32:16 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 05:32:16 +0000
Subject: Re: [PATCH] bpf: fix build warning - missing prototype
To:     Jean-Philippe Menil <jpmenil@gmail.com>, <netdev@vger.kernel.org>
CC:     <kernel-janitors@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200322140844.4674-1-jpmenil@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b08375c6-81ce-b96d-0b87-299f966f4d84@fb.com>
Date:   Sun, 22 Mar 2020 22:32:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200322140844.4674-1-jpmenil@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:300:16::20) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:76c) by MWHPR13CA0010.namprd13.prod.outlook.com (2603:10b6:300:16::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.12 via Frontend Transport; Mon, 23 Mar 2020 05:32:15 +0000
X-Originating-IP: [2620:10d:c090:400::5:76c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9eeb5646-72b5-4cf2-47c5-08d7ceeb8c51
X-MS-TrafficTypeDiagnostic: MW3PR15MB3865:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3865E253D6A4336221446DA3D3F00@MW3PR15MB3865.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(396003)(136003)(366004)(346002)(39860400002)(199004)(478600001)(81156014)(81166006)(52116002)(66946007)(6506007)(86362001)(66556008)(53546011)(66476007)(31686004)(31696002)(36756003)(8676002)(5660300002)(6486002)(8936002)(6512007)(16526019)(186003)(54906003)(2906002)(316002)(2616005)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3865;H:MW3PR15MB3883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9/Be3lI6qksF7BXpI6U/koq4nZpkYN0qaYyCC6VbeEMNMVinRulWaDcuqikqKik7bFZsxqpsPuRKLvyrfXK4mQCI5x+7+K92x67+DbwdUOGLcpff/iIFZL4n0RZjVT+ePxR/WYc1ilQk7caM2y5NqlIYWWQxc9/m3aus9SX/fsOWEFxrmh81nC+R24dSbI7zmLJa1vRGFiQbKctiH+/yc6VtUJp6pyHDSptbUiNaZ2SJMmA65HHP6/Q686zQLNYlb4sCgpuKsfClhaftfIRNunlEkjqMsh4+2wNAyUQ8tBE/FYY2crlLA9+yNoxAmmwAOda/ODdtpqxhQTSidiwJ6q+H1GNNOsHa4qiHX422H7IYIfDS6utxgP7G0Dd0u01jQ57EelKg6MfgvrQ7VIdRTMd2xAuy1AhU/8sDpD4RpEn71PLMZYt7YJZZkzj0u9zt
X-MS-Exchange-AntiSpam-MessageData: spCL1PZ12FgtzpLRY4TA7oYmC3UMagtEPr87jkiG0eaokSIr+niFqLdG5mjWQEjT4fiGRuTrf6Ln/rSs/yCqPKsKSBN9am/gfziGrGk3cbWIm84sMJNe4SmqU+MTNNfAVb9R9ylVIWyQQJ7RIVE74SVkxqSvM75i4GNJbFQg733RauOz8b9dIcO7FeKrcAKa
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eeb5646-72b5-4cf2-47c5-08d7ceeb8c51
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2020 05:32:16.5865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xqUxRU1HlO1o1CtcEK1VfAbpubLs9oZVFoIkEvSDL2ZsViTyjf/W0Dxe7AV+Wdy8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3865
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_01:2020-03-21,2020-03-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 clxscore=1011 impostorscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003230033
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/22/20 7:08 AM, Jean-Philippe Menil wrote:
> Fix build warning when building net/bpf/test_run.o with W=1 due
> to missing prototype for bpf_fentry_test{1..6}.
> 
> These functions are only used in test_run.c so just make them static.
> Therefore inline keyword should sit between storage class and type.

This won't work. These functions are intentionally global functions
so that their definitions will be in vmlinux BTF and fentry/fexit kernel
selftests can run against them.

See file 
linux/tools/testing/selftests/bpf/progs/{fentry_test.c,fexit_test.c}.

> 
> Signed-off-by: Jean-Philippe Menil <jpmenil@gmail.com>
> ---
>   net/bpf/test_run.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index d555c0d8657d..c0dcd29f682c 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -113,32 +113,32 @@ static int bpf_test_finish(const union bpf_attr *kattr,
>    * architecture dependent calling conventions. 7+ can be supported in the
>    * future.
>    */
> -int noinline bpf_fentry_test1(int a)
> +static noinline int bpf_fentry_test1(int a)
>   {
>   	return a + 1;
>   }
>   
> -int noinline bpf_fentry_test2(int a, u64 b)
> +static noinline int bpf_fentry_test2(int a, u64 b)
>   {
>   	return a + b;
>   }
>   
> -int noinline bpf_fentry_test3(char a, int b, u64 c)
> +static noinline int bpf_fentry_test3(char a, int b, u64 c)
>   {
>   	return a + b + c;
>   }
>   
> -int noinline bpf_fentry_test4(void *a, char b, int c, u64 d)
> +static noinline int bpf_fentry_test4(void *a, char b, int c, u64 d)
>   {
>   	return (long)a + b + c + d;
>   }
>   
> -int noinline bpf_fentry_test5(u64 a, void *b, short c, int d, u64 e)
> +static noinline int bpf_fentry_test5(u64 a, void *b, short c, int d, u64 e)
>   {
>   	return a + (long)b + c + d + e;
>   }
>   
> -int noinline bpf_fentry_test6(u64 a, void *b, short c, int d, void *e, u64 f)
> +static noinline int bpf_fentry_test6(u64 a, void *b, short c, int d, void *e, u64 f)
>   {
>   	return a + (long)b + c + d + (long)e + f;
>   }
> 
