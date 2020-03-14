Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0D3185323
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 01:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbgCNAFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 20:05:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18580 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726736AbgCNAFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 20:05:30 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02DNsv3o018309;
        Fri, 13 Mar 2020 17:05:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=iVq2h09G6W16tMY0Ob7hmHhIlNagMoaBLL0JH9HKZNk=;
 b=Y8DzHhynmAHFLZ8rkFv/btel3EhDtJ42hZq26E75r+6e0l3AXK81HU33FWUP4WCa4Zs2
 LQLIjL4XYGkHl+wpOEnePLrGUyIY5YzUlp4ZJ6ePAia0gS9iQ05xenBK5pdWxOEgIwzd
 BbzUGfEOSjeAJex0z/z9tZG7uceNlnnu1lA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt80y0yj-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Mar 2020 17:05:17 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 17:05:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcT0DX/p/YzQXE3ZCuVxS7pZQKIEnpVFRFN3cVms+G+uedGtFEoC1g6VRrbVe7IEDbUFvF3e+5yXNJ87SAZSZVsnes+NjglFN7tzOGetGUwc9PSfsQpmd+LoFRHHaV9CmSn472iiEZ4Iowp+usa330SpaDqJt/QMHSZzRW7KVjZ2UorF/dRUQUUNaWl0Cy/QeK6Jpgi+ZtMWmJ9rXSV5SB6lm7TfmsCEaH2itnYUk5rYC91tv2zwLJ4PbZ23L0OozBwWTiv/GLnz13E7mDddE82/lAl44D5sFyMdsKOvOCa4s5AjrSRTozCdzVUJJG0O2/sCX0pI7i08Usl2/ZF4vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iVq2h09G6W16tMY0Ob7hmHhIlNagMoaBLL0JH9HKZNk=;
 b=M+APSQ3epVzDQ4KUKI1MwrsUdqmr3mkl33St9BlSq7QtfRpF1hQi+mGRgrBmqjIQmQvPG62IVF8Z5NXT8PWPBGVy02Ab/8MsjZdlbC//e3x9VJ98GPNdrndv00aPAiz4qyLTqR65fXdYt3gUMS6eALneLQdri+xq+otTbSBQcZDUTOY0vlvRv1Md7z4enjuvo4ZOdnMZ1ymty2PRXE9q2sPNaTVSYbIpAgNgx0RGqICPtb7iYF+gD0CEHf6NWdSCjOLU2IVtdZwF7ru28JPVRrpGl+WJNyrDc4CPu0hH5bz5dmP4inSCvWoly0/KRc2pnx6DXxMW/Atn4woSjAni0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iVq2h09G6W16tMY0Ob7hmHhIlNagMoaBLL0JH9HKZNk=;
 b=YrsSVRnJEq9rJc+I/h0Ae12zj8hrM4dwAJvhge7zIHkUh7VsyvaVUKAPPwm0eaGIPBDqkMrSRAxvPnZE4fUH/+ML8DRizlngvQ1oj1Qi+cHbO35LSpeRtnnIHNFCRE6yL1t2Q/y0ewCRct95EbVH3zH/9BfAxrDx9xSZNzq6V4c=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2951.namprd15.prod.outlook.com (2603:10b6:a03:f7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.19; Sat, 14 Mar
 2020 00:05:14 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 00:05:14 +0000
Date:   Fri, 13 Mar 2020 17:05:10 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next] selftests/bpf: fix nanosleep
 for real this time
Message-ID: <20200314000510.cmsepdhnywtglrcm@kafai-mbp>
References: <20200313233535.3557677-1-andriin@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313233535.3557677-1-andriin@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR10CA0049.namprd10.prod.outlook.com
 (2603:10b6:300:2c::11) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:ad28) by MWHPR10CA0049.namprd10.prod.outlook.com (2603:10b6:300:2c::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17 via Frontend Transport; Sat, 14 Mar 2020 00:05:13 +0000
X-Originating-IP: [2620:10d:c090:400::5:ad28]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fc737e6-2bf3-45e1-46d5-08d7c7ab5eb4
X-MS-TrafficTypeDiagnostic: BYAPR15MB2951:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB295159871B001E46B268A132D5FB0@BYAPR15MB2951.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(199004)(3716004)(498600001)(5660300002)(55016002)(86362001)(66946007)(2906002)(66476007)(66556008)(4326008)(6862004)(81166006)(81156014)(8676002)(9686003)(186003)(16526019)(8936002)(6496006)(1076003)(6636002)(52116002)(33716001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2951;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BxWP3vyQVXRujDK9E7b9EDO0S2pllzWN/LCfeYRRMaPObEmu8lnvSCDleOSsEB9Ktzfv8QAjS0YtzVHseRzj1wwVEu+zr6XBRhMV5g/CaxuEZ74TUBAWSrwyo1XQcz7dPNE8gqu0JwRrijhBWR/e9uXcJvh0gvASQ/r+Fv6vhGEJE/vs/CxQdh3qJjWstNhyrrr3gQIe9l1ZULVOFiORwdjjhF1Ma5izgeQ1B9NYoEMHzlQiO7NZhmhcHm1mqSx24MDM/uOiczvyOWjvsrA/V97gou0mRcbgua+VVMtTgyFaQkCkMW9TPKMGzzP3AFm859+5RYEmnTBV9UJ/sN/XxRv5VpATMo7FkSC7bqPpTMNJ/yrt0RbHteVmFoNTxNeDmFrW5VWWJOC6GnwDuvHbIm+sM7GACqsiuuBEZt0iahtmdI1kMwzL9cjQmLP8Bl7X
X-MS-Exchange-AntiSpam-MessageData: g+WnJ8WI26rBayEWSqwAbFZsapqXSc36Bz0/nsuN6fhElHSpz02AYULRdW/wmU75XTXf9Behuak8ULEpeQkGbhmVuF9+JFU6jlp97UrQyAybitsE6owXL6NURWEvbib+LyMu143xOr65CO5blt5sU+rNc4ZxGsatyKEThF1+jMPUwU4KnRgq0Ui4TUVigTIa
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fc737e6-2bf3-45e1-46d5-08d7c7ab5eb4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 00:05:14.0641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Arz/tdniqG69nOZuxTzhhdAWjfIIQtp7eWVEaYGsiuoW3K5Hf3cI12sKx0jYbhah
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2951
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_12:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 clxscore=1015 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxlogscore=858 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003130106
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 04:35:35PM -0700, Andrii Nakryiko wrote:
> Amazingly, some libc implementations don't call __NR_nanosleep syscall from
> their nanosleep() APIs. Hammer it down with explicit syscall() call and never
> get back to it again. Also simplify code for timespec initialization.
> 
> I verified that nanosleep is called w/ printk and in exactly same Linux image
> that is used in Travis CI. So it should both sleep and call correct syscall.
> 
> Fixes: 4e1fd25d19e8 ("selftests/bpf: Fix usleep() implementation")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/testing/selftests/bpf/test_progs.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> index f85a06512541..6956d722a463 100644
> --- a/tools/testing/selftests/bpf/test_progs.c
> +++ b/tools/testing/selftests/bpf/test_progs.c
> @@ -35,16 +35,12 @@ struct prog_test_def {
>   */
>  int usleep(useconds_t usec)
>  {
> -	struct timespec ts;
> -
> -	if (usec > 999999) {
> -		ts.tv_sec = usec / 1000000;
> -		ts.tv_nsec = usec % 1000000;
> -	} else {
> -		ts.tv_sec = 0;
> -		ts.tv_nsec = usec;
> -	}
> -	return nanosleep(&ts, NULL);
> +	struct timespec ts = {
> +		.tv_sec = usec / 1000000,
> +		.tv_nsec = usec % 1000000,
usec is in micro and tv_nsec is in nano?

> +	};
> +
> +	return syscall(__NR_nanosleep, &ts, NULL);
>  }
> 
