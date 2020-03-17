Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C598187A7E
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 08:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgCQHbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 03:31:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8660 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725962AbgCQHbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 03:31:06 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 02H6Q7gK008620;
        Mon, 16 Mar 2020 23:30:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Qel05V0QnNs2u7XlibSRX4+nn4Sw7zOS/aHX03YqrV4=;
 b=CgDhNfYVrVxss6bS3eOGttocLFVKWPXIVz3ydClIc4vXiM2UR4tULkiwO8NbNeE/GVf5
 De4/IxRBRXnLVajrB/2ZTmDp8Hvv/ZSdpi7QgcO1IqCypv0rAQPgaOb9GEwYKdt+b6DT
 5vLw27pMGb7UOiuhoKQYQ8qSfmj5sUp2kss= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2yrtrybjs2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Mar 2020 23:30:49 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 16 Mar 2020 23:30:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXM3fFr34ncKIvAaQK634MpiI3KFuIihhiFLbSOpFEFQPcb9Q+zTPEmOtf55QUj6rU5rLlV2DZ+X6sKhl6uzJ1I4PcfzkdthHl9wvzKvwxpHr0b/bAAt+Nw6zp/yuwmOmcpIVuo/t1Uu0uLx3pMKPmz74XYMRwedqgYZYNCdIxCWA38lsLAX9GmP/6Ia6JL7q7lg+JmP/UulZnl1Or45whi07y6x0shyTPaNTbt/k3J9zX8QMXoImzKWoJMq6MSeXAoDX4fUkiw1E0+rHU84phdg4PAWWN0jofoQF6JMt4j9g8cglJfIvwKL7VuDd/TtIKQ/Bz/qSRrDlmeT+CGxRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qel05V0QnNs2u7XlibSRX4+nn4Sw7zOS/aHX03YqrV4=;
 b=NJFp8ja9At7r5q6i2oHPWMQZg3ogXkeDyLyBv6DkQeOvJnG6Kx6hlTGG1ah5kZsYTSL203Ei468n1OXj4+fqxa0Pric7Sjzrvkfi54jxJ3xqyRsPLEGCXbR/XMhA5Oz5U9/eBtN5dB71sitUBBz5wPQHayaUCI6B0z/NcXIE7RWgXjTHl4Tf7oT668cGffoaAhKJYpgKXVpuqHs13/DXSSUN7k09arWg++DSPVhzLG16XP04fqv5wUMm/Aij68p95k+ognNegCpNg9M7hmUTGW0TDkzqPtCeApfIwbgIg3u8z3tQ73wxmY93ziNHzSSG+ul/CG2sDF3xMu6fnZhSSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qel05V0QnNs2u7XlibSRX4+nn4Sw7zOS/aHX03YqrV4=;
 b=bnG5M+AdVzkUaFFQQCy2p0Uvz/mz9Ab7EmdB9FwAULgJsQbiCh+ALkxAXIj2hGtYTJBtJa30frZlKdN4iE+EZirnsrAJiyrLlrTnKRfr7bJizzskMNFHc+hmPOCtRHwnTXke+QrKpYA6KqjcOrZMHnUo+1dWvovUUnExIRXJaj0=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2853.namprd15.prod.outlook.com (2603:10b6:a03:fb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18; Tue, 17 Mar
 2020 06:30:47 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 06:30:47 +0000
Date:   Mon, 16 Mar 2020 23:30:44 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Joe Stringer <joe@wand.net.nz>
CC:     <bpf@vger.kernel.org>, Lorenz Bauer <lmb@cloudflare.com>,
        <netdev@vger.kernel.org>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <eric.dumazet@gmail.com>
Subject: Re: [PATCH bpf-next 5/7] selftests: bpf: add test for sk_assign
Message-ID: <20200317063044.l4csdcag7l74ehut@kafai-mbp>
References: <20200312233648.1767-1-joe@wand.net.nz>
 <20200312233648.1767-6-joe@wand.net.nz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312233648.1767-6-joe@wand.net.nz>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR1601CA0001.namprd16.prod.outlook.com
 (2603:10b6:300:da::11) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:e745) by MWHPR1601CA0001.namprd16.prod.outlook.com (2603:10b6:300:da::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.21 via Frontend Transport; Tue, 17 Mar 2020 06:30:46 +0000
X-Originating-IP: [2620:10d:c090:400::5:e745]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2c0bc04-5865-4548-b085-08d7ca3cba52
X-MS-TrafficTypeDiagnostic: BYAPR15MB2853:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2853FE80366843F69BE8EF6AD5F60@BYAPR15MB2853.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(346002)(136003)(366004)(376002)(199004)(6496006)(1076003)(8936002)(52116002)(81166006)(9686003)(81156014)(55016002)(8676002)(5660300002)(478600001)(16526019)(33716001)(186003)(6916009)(4744005)(86362001)(4326008)(2906002)(66476007)(66946007)(316002)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2853;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EwBWjXKmAlEKx8RdtBB4DPCSSde9UZOvcP2jdbRTdpS7sJi46QIQzsGzKZcYgtoDLbwoWfJfnbtykWhPGOwJaU+1F3wuCzHAXbqXuLEb529slEYMdvlT4lWmNcSRtEvVZhq7nWL9Otcie5aZIeFj/3FQ6t8Hgcu09Q0DLNJ9xBZ/cucnpTfWHtoxqaR1/yCyTEfduEeLH54l+HmflZFCedmq6y3MvOfb2XKSzurETt8isGmeqUbC+yvIYeSOjFGS+3o50uTPdU9SZlumJUJEer6O6mBKFauIqlOpC6JklG2MUpu/d5dPJgGviR9QwvuvNfQlxUZpaf+OmTmh5GVyI1+tj13aqFt1chtZxFOvnAV9XAoreIu9SnelxvoBdZWEi66PDjWxJN3EKVr6XUrYFpD/oaTOGZGQHo9QsnkbrylUbjjRBqHKNLv8o2+G3jnc
X-MS-Exchange-AntiSpam-MessageData: LaNEX22FxjZcdPI3vhcrdGFWQzA4xMX4zOlLihT13SAOofKHMfZQBebzaBrtHIkd6wYafeKDnpBi94DkEP6bP2DTsCntpkvLsz1vrXrdCU4c11eNxvXNTUPCho9z5ZgpvO/DWOuc3bgnq+CZNttUVkHK3Gx7uNM9tMTm7JFtewhiEkSRPQO8nyzkUXVKakje
X-MS-Exchange-CrossTenant-Network-Message-Id: e2c0bc04-5865-4548-b085-08d7ca3cba52
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 06:30:47.2792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vU3Dbi2UWb+6gUXy0dAF8yLVBud1YC1gWIVg21BEE5BRLyhD6GsRP9TPhOgR+mIF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2853
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-17_01:2020-03-12,2020-03-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=0 bulkscore=0 spamscore=0 impostorscore=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003170029
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 04:36:46PM -0700, Joe Stringer wrote:
> From: Lorenz Bauer <lmb@cloudflare.com>
> 
> Attach a tc direct-action classifier to lo in a fresh network
> namespace, and rewrite all connection attempts to localhost:4321
> to localhost:1234.
> 
> Keep in mind that both client to server and server to client traffic
> passes the classifier.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Joe Stringer <joe@wand.net.nz>
> ---
>  tools/testing/selftests/bpf/.gitignore        |   1 +
>  tools/testing/selftests/bpf/Makefile          |   3 +-
>  .../selftests/bpf/progs/test_sk_assign.c      | 127 +++++++++++++
>  tools/testing/selftests/bpf/test_sk_assign.c  | 176 ++++++++++++++++++
Can this test be put under the test_progs.c framework?

>  tools/testing/selftests/bpf/test_sk_assign.sh |  19 ++
