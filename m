Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C847018527F
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 00:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbgCMXx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 19:53:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51888 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726397AbgCMXx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 19:53:27 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 02DNm0Xv006337;
        Fri, 13 Mar 2020 16:53:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ML3QaVATkvIS0VGABYkk9PGrQ7bV9aCpUzSm1QOa4mk=;
 b=D0IzVtFjlx6mQUNzaoirVSXi5idDSUSgXpyteKytXMhAKvmxpIdMfVDJYsyBacbJPLMZ
 H8Sk2E8hfjKthBu+cnCJ1sI5jpt5dK1rzl1nB+wZwTDQ/ktW374ZmBUBzepNN4TsdlNS
 gfHCJW4NvtRSgiE+1TUnokk/A8NmCDpHYXY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 2yqt89f13y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Mar 2020 16:53:15 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 16:53:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDnmi0M0hjUQAWqqWvboQQ4lnweqxnb2B50ihJEBCBf2KI96/iIF3Ee0LyKlfCfLOghRfELpHCP9nnNMU9JXmSM4b+b3zjTmNBEYHUUTCAII0ds5n/Nknz8XyBIvyUT9cpTyVNnyb4j0slcnvQCx8KTXjeOiaQ368UfpwHSAHe0wshCZfaPsFbmYTwpSwyTiGwOap5nrlR8zAjUoq/9O8iAYiwwgtAOKu4ANNBVBml0xDRlUTXTZ8TvKqKxkjWmugvYumNvCKcFvuQFvJk8RZHSOXqtb8MDMQi1GOWo9xlsj7hdZ2oms6WWi2+fXfZd4cPW/mNC5/vT8nmUChTtCgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ML3QaVATkvIS0VGABYkk9PGrQ7bV9aCpUzSm1QOa4mk=;
 b=LbzduLEaqkKBe1KQoRUr084+osvmDpHJmDxeJ3Ib7J/c1gt6x14r+2NDmnuM79u/5TR7QKUVFDU+r7u6ZC9ILr+jg/xyPq9i3WZYMmewlPFau6li5pwTL703FxaL4BancAfOH+G5sEqpQo6H3NTgtuM06X+jeW23jkmMWrvHbS7cu7MpE10twWp3hCVjKtEvX/+1HQWrrESEW/Dd8qwoz+72gw9Wb7WPsu+hTyWVSWGDebFHzdmJL56u+FD/TtRYFl9WKz7ARdVpLgXce66/gZcIwyoFRQ9kj4RIyNAX76GTpSzG8qLaFJFrKDFMIjwqrgCOqDqUgIwX2lSDHPYJIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ML3QaVATkvIS0VGABYkk9PGrQ7bV9aCpUzSm1QOa4mk=;
 b=W/cddvzepqff2nzKvTE1oLZp0v/8wH2Y/InfIgtiliHfJbwDnkgql2V9WMmDzOH/8zfu/s8Mn2/BryvjjC3MnN/aP21UH6lRU2+pF6ub4zv92ovAGt5625143NeNyyASg3P7R63pznvbeh7susvMpx3eQR/ZZp1jHS7D3jFfd1o=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2792.namprd15.prod.outlook.com (2603:10b6:a03:15c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Fri, 13 Mar
 2020 23:53:13 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2793.018; Fri, 13 Mar 2020
 23:53:13 +0000
Date:   Fri, 13 Mar 2020 16:53:09 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next] selftest/bpf: fix compilation
 warning in sockmap_parse_prog.c
Message-ID: <20200313235309.34matqh7iaahawkf@kafai-mbp>
References: <20200313230715.3287973-1-andriin@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313230715.3287973-1-andriin@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR11CA0025.namprd11.prod.outlook.com
 (2603:10b6:300:115::11) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:ad28) by MWHPR11CA0025.namprd11.prod.outlook.com (2603:10b6:300:115::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Fri, 13 Mar 2020 23:53:12 +0000
X-Originating-IP: [2620:10d:c090:400::5:ad28]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2aa004af-4cce-4a43-9bcc-08d7c7a9b0d8
X-MS-TrafficTypeDiagnostic: BYAPR15MB2792:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2792DF372D67C3F2780C5FF0D5FA0@BYAPR15MB2792.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(136003)(366004)(346002)(396003)(199004)(6636002)(6666004)(81156014)(81166006)(8676002)(6862004)(66476007)(66556008)(33716001)(5660300002)(86362001)(66946007)(2906002)(55016002)(6496006)(186003)(16526019)(9686003)(316002)(52116002)(1076003)(4744005)(478600001)(4326008)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2792;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XziMyJ+D8fUJC1WFY3TceSx1WO1yKHvVljBnDoNjd7dgKSUeyRxKbQVcJbWocQtPr/VnG++0tTGHCqd2ZpFdxsF7itfmw4aMV2JBbnNyww8UNHZCn3vZ2AuUeb6xSq3SXSKzVj8VHKaH1QbP2xZgp1w2IZhd6hWz4CITekD7m5ychGqjIXKTOJgL46LQbAQneEYYvzkBSaKxJOvHmXOtEsTfCu9l6M47qm/B9Fu3/wR34yNN40Jfr12iXyF98/SG5sDklxOMRWLQqwLqFhnNPTlO1vjAzgxfzicvfpGBQlP7Z9e5AESRLbTYFHichoPQfFNn/bvEcsRsI0oyi56mf5d10WWkw39zZg1RGuBRz/YCliedchIqLHkA0OkUFB+ymeB3Mz+0I/JZjti8bpLkfm64Invqv31TnFrBTz1rgnKWJYliD9Jlccj6YDE6OfBT
X-MS-Exchange-AntiSpam-MessageData: 8gqhq7z8DCI0IpaeZXtzWFKJ76u4M1Jc+FH33cmOw74b43R/9T5TfUyhhzAtWsF4qCkkDC+AE2ojNGuHaEy73bcFeyzm0qGTZU3cEUfAt/pU9WuKAb3nnSunYUbsHcnNOqsHHSrGq1QCXbWDLVRYbpolNzFQaRBfjCgkiWq3xOinjKpEicw6s0WpdNHwpgqz
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aa004af-4cce-4a43-9bcc-08d7c7a9b0d8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 23:53:13.0718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gWtnekDdva6Ns9Yl6jQ6Af3feyf/t0ZfITBydj97IMHMsMP74JwoVEn92ySgsDQH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2792
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_12:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003130105
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 04:07:15PM -0700, Andrii Nakryiko wrote:
> Cast void * to long before casting to 32-bit __u32 to avoid compilation
> warning.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/testing/selftests/bpf/progs/sockmap_parse_prog.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c b/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
> index a5c6d5903b22..a9c2bdbd841e 100644
> --- a/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
> +++ b/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
> @@ -12,7 +12,7 @@ int bpf_prog1(struct __sk_buff *skb)
>  	__u32 lport = skb->local_port;
>  	__u32 rport = skb->remote_port;
>  	__u8 *d = data;
> -	__u32 len = (__u32) data_end - (__u32) data;
I think this line can be removed.  "len" is not used.

> +	__u32 len = (__u32)(long)data_end - (__u32)(long)data;

>  	int err;
>  
>  	if (data + 10 > data_end) {
> -- 
> 2.17.1
> 
