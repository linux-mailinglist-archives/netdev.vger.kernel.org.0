Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18561180BBF
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgCJWjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:39:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60670 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726273AbgCJWjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:39:41 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AMZQDa015520;
        Tue, 10 Mar 2020 15:38:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=42eT40sFP+9KYDh+3vlLMH6rGIDplm/89EAughFcMVA=;
 b=L82H7GjHGpJCnOI268kTXJLkR3CNE74iPQCm+69ckcxQStB3NUQ4Phajn6ocHyhmnaDf
 Ro2IuLRRiT/kvmyLG9vJubm2LHmj+UcX+Ac3RkhbCMpsvckdJ9Ydv64VZMGkT+8eVllt
 1pdYnPxADX03eCJJmLihfuPnNppMNwsQXak= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yp8rdukmy-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Mar 2020 15:38:57 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 10 Mar 2020 15:38:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nv6aHqhprFrXEhfztQbGesNenKcqtwwc0obOBmX0rsJXECF78am/O76pZa7CwrJomp9g1PO7FAq75eyVD7U+xCnIuNwwisLFeke6YmF2VwVHviLtZFRv3QZNCL/ydh2rhfLcVtUj4V2bcIHB0ny1IMkNOlvxSrl++nOLuc7TmB5rRHMTAGdG3Un+q0p5po7Y6alYp2RmpL+fljckcg2A6C2xzD6j/jVioF3HZjqk2FHVPK1HTJ+s3C1S8vDKUsGbkklaeplo2/cfbVIHMNoQGW39mkIzy2KXKGTd32OtlbS7pWbbDETj9xnYWkddgSXGA6eI5ZG2AwUQbjJx8ScUZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=42eT40sFP+9KYDh+3vlLMH6rGIDplm/89EAughFcMVA=;
 b=fBrcq5G1zqidubQySPbL9Z2J4ap3Ngsvgk47f2kTf/l7IOHN+Ympzn6CK1TSx0LynF/blSO6YJ0qDah0iP/NOxdkha0TX64u5ZlkY+KUb8a71TROSbZUQkZkbkN9uGM4aHRRtEKfIZZxWyERc+q3RW/3uKGb6z2HRcT0xirQwWQi/dr2MB2cQe7y4ZRaq55ZVCKF+oGLpOohwa59pI+ITEJNTbjoqt78UDQZQSscFHlSM2MvPgzcHd/TYDYhrjhXF9QhcxNM/Zn/cc0TWiGgm2w7Iqmngomwsrc3M3Ms3BQeMqkFsNH1QZrQ2SC4JhqddLiGx9j0QSKRN92r92zkRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=42eT40sFP+9KYDh+3vlLMH6rGIDplm/89EAughFcMVA=;
 b=c72SQQxyvs++c/j1hyQWztpgf0VyEleupBRvc2UjSD2k/hJ04gwl4VomcvlySCZPT8GRZFBO6NGPnYRLjcdhAgVOU1lCCe8qsj8W89+GZEKpwxR9yj0YHlNNwPP46dWzLnUEo2pZJ0X5tFknmMsiG7+Y/VVRJCB15EdRR9UaETc=
Received: from MWHPR15MB1661.namprd15.prod.outlook.com (2603:10b6:300:124::23)
 by MWHPR15MB1566.namprd15.prod.outlook.com (2603:10b6:300:bc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16; Tue, 10 Mar
 2020 22:38:53 +0000
Received: from MWHPR15MB1661.namprd15.prod.outlook.com
 ([fe80::f930:6bf2:6d2:93ef]) by MWHPR15MB1661.namprd15.prod.outlook.com
 ([fe80::f930:6bf2:6d2:93ef%8]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 22:38:52 +0000
Date:   Tue, 10 Mar 2020 15:38:48 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Shakeel Butt <shakeelb@google.com>
CC:     Eric Dumazet <edumazet@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] net: memcg: late association of sock to memcg
Message-ID: <20200310223848.GC96999@carbon.dhcp.thefacebook.com>
References: <20200310051606.33121-1-shakeelb@google.com>
 <20200310051606.33121-2-shakeelb@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310051606.33121-2-shakeelb@google.com>
X-ClientProxiedBy: MWHPR21CA0048.namprd21.prod.outlook.com
 (2603:10b6:300:129::34) To MWHPR15MB1661.namprd15.prod.outlook.com
 (2603:10b6:300:124::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:9c9e) by MWHPR21CA0048.namprd21.prod.outlook.com (2603:10b6:300:129::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.9 via Frontend Transport; Tue, 10 Mar 2020 22:38:51 +0000
X-Originating-IP: [2620:10d:c090:400::5:9c9e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0f6f206-86cc-4562-40fa-08d7c543cf26
X-MS-TrafficTypeDiagnostic: MWHPR15MB1566:
X-Microsoft-Antispam-PRVS: <MWHPR15MB1566E92A07585E336C99D79BBEFF0@MWHPR15MB1566.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(136003)(376002)(366004)(39860400002)(346002)(199004)(189003)(7416002)(7696005)(8936002)(6916009)(66556008)(66946007)(81156014)(81166006)(66476007)(8676002)(86362001)(52116002)(186003)(16526019)(33656002)(6506007)(55016002)(316002)(5660300002)(2906002)(54906003)(9686003)(4326008)(6666004)(1076003)(478600001)(4744005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1566;H:MWHPR15MB1661.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mIFDXct3aIYWBozDCNcls7dc6Q2RLzWAk/M3v3T7KqTwtrYofb4Y+kf1A60QqVN813TuMgV6ePfFx/dm6Z+oWWP/9qBo1qr5muBeZxrg1WZ7ya2uN8pf+s+WSMWwIPm08t5Za1ecxDnEkk0mszQD3QbDHYgLtjwiGlMglAEPlDz0CW9bgmry44DAMdT4ia7VpU7awQn5FwThqA4zuG9cCudcM/8cNpqq+nfnFV0bV2a0qF7OLkJWPXvgsU1z5XysoUVsTMbDgKQfo4UeWOysvGK7Zv7gnYnLFNDnn0QDGcOoj7mOLjq3uc8cgKTZ9jZP2rRRaDM0P12bwNLO9PJq0J8uu8OGm17hfYfMzco2Q0o2DInGb3+iGs3hYC7nhWV6rqo7jvzIxGjoW3kR9JPSS9KirHaYJ+1lcI87J/Sgnuu8ZSsC2Wo8nx+eFkcDLzls
X-MS-Exchange-AntiSpam-MessageData: Z8Fcm8pu81+Qr6nkJJ8zWoqOTav2BZ1L1+eDmCHVUeYNcUJ6ZxEXQTUytztRZxULI12U9Xi9R6okpI+AEppcWWMkzlzkNodkLJ9ad5lDHIfsYF0wxfIjt2IX2C9pxF+sOYlcvvQz71BrzoIhmIEpWAoGntFroZYos4gRMwUVqPV5dvn0KtFCynVdwHKh+G5C
X-MS-Exchange-CrossTenant-Network-Message-Id: a0f6f206-86cc-4562-40fa-08d7c543cf26
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 22:38:52.7954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ag1QunNnWanVuLruO49RlKExIiP1u1incKgWJPiNvb9gJgx5eeHIneXaJtqM1JLq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1566
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_16:2020-03-10,2020-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 bulkscore=0 suspectscore=1
 clxscore=1015 malwarescore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003100134
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 09, 2020 at 10:16:06PM -0700, Shakeel Butt wrote:
> If a TCP socket is allocated in IRQ context or cloned from unassociated
> (i.e. not associated to a memcg) in IRQ context then it will remain
> unassociated for its whole life. Almost half of the TCPs created on the
> system are created in IRQ context, so, memory used by such sockets will
> not be accounted by the memcg.
> 
> This issue is more widespread in cgroup v1 where network memory
> accounting is opt-in but it can happen in cgroup v2 if the source socket
> for the cloning was created in root memcg.
> 
> To fix the issue, just do the association of the sockets at the accept()
> time in the process context and then force charge the memory buffer
> already used and reserved by the socket.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>

Reviewed-by: Roman Gushchin <guro@fb.com>

Thank you!
