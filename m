Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB1E2B89C4
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbgKSBuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:50:44 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45212 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725947AbgKSBuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 20:50:44 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ1jGq0012155;
        Wed, 18 Nov 2020 17:50:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=tetmNCQmCE063tAVzm26yRvF+bU1Lk3NrS04rbmN4KA=;
 b=AwCkvqGBmXDqOuFvB9DDWT52wtVnDi+C5eNNRs5U3E2PkbMuUBhYNjpYxyvUDJIIiHpU
 zJ1B8itGFj6XHPLUVBI4SXXWpLkrdypTJ6CYK2XP5fWFlQhB0EDsnLE4c6xKI9MObjDT
 lvMSyBWyFnaWx2aabvdFw5dhJJfxQagRSwU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34vhqjjjk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 18 Nov 2020 17:50:17 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 18 Nov 2020 17:49:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+t2y2MWqCPsWd5isZu1/nB57+ocV9c8lwvItvgsrsPusUJrU2tfvcMPqJjuPzCWCDdZRfNcWRV7H/2w9PhqNfRlKM6Im8RlNNdgaIChbxm9fPa0+hlpmoKe8wS5PYP7E1X3p0x77w+DHsINtTEENIF2F+z94g/VgIYCtPlekaIOHrfrlurRAwn/N8laeSzXYdxNSMptsHZEiiNZlm3Q1Z6g+Fw8oKMQviSgxqhwOebdegTfKIik0mHPvZOaNWbSKqzv9D9BF/u4fIVTEbOGnwoCglHbdN+k2URaoBTmzjSHHS/7XpYNaXkyCDwdbn1y22udHc3OSit849iLeyNW+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tetmNCQmCE063tAVzm26yRvF+bU1Lk3NrS04rbmN4KA=;
 b=SocuA1776mcWE9MhjaZTT7TC6ga7ST/sUZjQg6FluJsGpoCDjyW8E4wzUiueveIjV/wVhQ6GBAGjJfLa5u2VlUMWJWXVFnPCI/7sDrN3q3wr0WbI8uEazbjk+TTTwCIHfR+GxlRFlya2GTGRYBa8o4aLLrgl46UVojQID/5OikPyyZcVDZD1SDSRYpWYEzvuYaI5wYdFCi2i4NILkflysctU/lTKt+B24ub5TvWT6N3NKqP7KVSN/0dBdppIc24YoTFjozM3lG2Q+1RWjMh8Ok3QocD6YPsIjV4yl+UslsKW2xflDYus+2aRaQo+Ajgq7fVxVwdlV+bLwYd6uJdK2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tetmNCQmCE063tAVzm26yRvF+bU1Lk3NrS04rbmN4KA=;
 b=Fn3xtlMx2dUa8rnR2Zfc4Ozg/DGuOtbXqkw+pxtQAwHOatrMI6RxSSxlvrrQD5wal9X+3SfpxQdOLBWXrRpghRt+1KMWYuP0SBm9PITqe0Gr3CuQMDrAkFM/1km4PnNb7oKy5/IrevSLwxxcSdn+x0YZi3YVXL5XGyFLOM6237Q=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2647.namprd15.prod.outlook.com (2603:10b6:a03:153::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Thu, 19 Nov
 2020 01:49:20 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.028; Thu, 19 Nov 2020
 01:49:19 +0000
Date:   Wed, 18 Nov 2020 17:49:13 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 0/8] Socket migration for SO_REUSEPORT.
Message-ID: <20201119014913.syllymkfcohcdt4q@kafai-mbp.dhcp.thefacebook.com>
References: <20201117094023.3685-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117094023.3685-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: MWHPR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:300:117::29) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by MWHPR03CA0019.namprd03.prod.outlook.com (2603:10b6:300:117::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Thu, 19 Nov 2020 01:49:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d52446ef-405b-4a99-54f4-08d88c2d54c4
X-MS-TrafficTypeDiagnostic: BYAPR15MB2647:
X-Microsoft-Antispam-PRVS: <BYAPR15MB26479C8FD553DF7A535C5B94D5E00@BYAPR15MB2647.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6QZsIAauJdhyWSHM/HFPFHCiFTxZdpVLh4mRmZXT8KBavwfHoYIugN1wauiivJicMrB5S7GskBuij5eGYAFbxC5gOUMRWXyk+ZWQpykbjEBA/i3Fdg3Xu9aQVfgTvrG6UGIGlB5mJ2Z3SuQfWurzpz5ejr9PLznmGVllFZeEy6Ordfse9thdidhHGtBQXPeL+WPkkHuZDQuJ0wgMtAA6SrimFtoMHRIK4noKoVN7tyvS/dCkUl22ae+JK4sxDhxOzCaJ/o9b2BinsMgv9DnrfShwbIU8mQlY72btF9PQH8kzuoWp6Pr5LNiELmdsp2/uaTOki/+qUORWruNiOu29NQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(39860400002)(396003)(376002)(4326008)(6916009)(8936002)(1076003)(5660300002)(7696005)(6666004)(52116002)(2906002)(16526019)(8676002)(478600001)(55016002)(83380400001)(9686003)(6506007)(66946007)(86362001)(54906003)(7416002)(186003)(316002)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: chTx+HNRdlkRmbQpieLfJpggyASHcj1iX8syEMnRaIzOORxbR/7hLkBEbxyOYrr2h0Xyi8c+RxSp5ii2uQn305b6YWw0gIeXkg236qhLJQqJSfDYLB1qxYh5XmOuLJ/2PrdQbuUJF1Pbjujxo8J1Af5HtvfJ4tY8Ld6Lq6L3y6xw2e3VUk4tC4cdfwKwV9w4W1dIM/nPtJGgG6aOpQFqHDRQxXmxvkppPX/Bw1lL68xlLv/EntyKX33Hxyesp0SA2pcqZvkB6tgVAHcPuYQqLvuokVNr0x9ByKTwyPu3Zl/k7aMsaitIiduKgVFSfIiTkJH8/PhoE3KIUV/uHVfBw/2YN6QdyWz2cAgEhgTGzqAwzmAwhjdFk1tWtXUb92zdePHsb09iBLZoeQpQAz14MRhddh6WftlyX1aqQRtGyloRFriBtNiV+bFE/gvNuKr297fRUYHn2iS/4GBCf8kZl2YI8DfRa/0FzXTU2cIVyQblPbtwh3DLLgUG3MXAlnffRbdEtC5rvfJqkUF5q5ogs9O8Vh7xu8MLM5wAO5lfiTEdrGd62cLkQE3yxbdhc/L3Q7VOCiAQOBiUKuEF3wXj8vBznibhLFa8nAOZR2KzORFJhaXB4aE0Fa5Cnnk4TiA+MxNUO6bW/9COjXc5TsZ9JBqV59WSf8RxN32EcmNEzIiurbL/CxjoZ9le+ptzC8aKgbbNJWLOfwtOdc9YFSl4HCJtzxzzM1NskVMQl1J8mUV1Z94pWsny91CdCVwgDp7UzM9Vb44aPzYXzniUi2nWPQlAjUMkjfUhQ3B+rcKRcEdGUgCEiHHUuDeWHmKrHv0utILTiwF9h+MjgX9QDQ9dzInJuZG8gcHHwM5zrXkXTbC1OMjr3Qn+c/jxWKxBpVSMGm9bf7rt3ikNKvD7cBsU7l6ipPxrAdJsB6T9UzXghlQ=
X-MS-Exchange-CrossTenant-Network-Message-Id: d52446ef-405b-4a99-54f4-08d88c2d54c4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 01:49:19.8673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lvwfo8Cce/n1PE8KXZXyia9Z6M2MPuKz7hAo6w4G5CFXbyrTt594OOihuFSOKO/p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2647
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_10:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=1
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011190010
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 06:40:15PM +0900, Kuniyuki Iwashima wrote:
> The SO_REUSEPORT option allows sockets to listen on the same port and to
> accept connections evenly. However, there is a defect in the current
> implementation. When a SYN packet is received, the connection is tied to a
> listening socket. Accordingly, when the listener is closed, in-flight
> requests during the three-way handshake and child sockets in the accept
> queue are dropped even if other listeners could accept such connections.
> 
> This situation can happen when various server management tools restart
> server (such as nginx) processes. For instance, when we change nginx
> configurations and restart it, it spins up new workers that respect the new
> configuration and closes all listeners on the old workers, resulting in
> in-flight ACK of 3WHS is responded by RST.
> 
> As a workaround for this issue, we can do connection draining by eBPF:
> 
>   1. Before closing a listener, stop routing SYN packets to it.
>   2. Wait enough time for requests to complete 3WHS.
>   3. Accept connections until EAGAIN, then close the listener.
> 
> Although this approach seems to work well, EAGAIN has nothing to do with
> how many requests are still during 3WHS. Thus, we have to know the number
It sounds like the application can already drain the established socket
by accept()?  To solve the problem that you have,
does it mean migrating req_sk (the in-progress 3WHS) is enough?

Applications can already use the bpf prog to do (1) and divert
the SYN to the newly started process.

If the application cares about service disruption,
it usually needs to drain the fd(s) that it already has and
finishes serving the pending request (e.g. https) on them anyway.
The time taking to finish those could already be longer than it takes
to drain the accept queue or finish off the 3WHS in reasonable time.
or the application that you have does not need to drain the fd(s) 
it already has and it can close them immediately?

> of such requests by counting SYN packets by eBPF to complete connection
> draining.
> 
>   1. Start counting SYN packets and accept syscalls using eBPF map.
>   2. Stop routing SYN packets.
>   3. Accept connections up to the count, then close the listener.
