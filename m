Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90363280A55
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 00:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733088AbgJAWjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 18:39:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52290 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725924AbgJAWjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 18:39:08 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 091MYSh6023302;
        Thu, 1 Oct 2020 15:38:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=0xa8gxklGKb4CZ0e+LA+kksk4edSX2GNsX3phNOMcoY=;
 b=g9Yydj6bNgYqBV/pHLpyEOyycocFH/V6PqoAIMVNKZdNLe7/B/t8M3gvQZaTWqpQeXJJ
 /60AG92kNCgOcxefRkREE8kOq6lMwdbPhUpT4h7NDGHWxKn2/ukMmoil7/dHIN2XpB/R
 RpPzxdAKC7szuw+3A+Wlm3oacC7EwVoeRnw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33wmda979d-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 01 Oct 2020 15:38:51 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 1 Oct 2020 15:38:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NE/Ity9t90/M3P2CgedE5JJSYkz8ks4KhR2ZnQ5XhL2KckTKbAD5iv1qeLq4zx6ZfkJivIlBSQVITXIpKMb1yX5shfP200vRCw/v+I2y2IvIrw/+YHtJInho3qXqTn7NjniFf48kPvzgsj1KJfVREHzF3sVKxqjDvvF1Uo+ruennf5C6munizA8nOFaqiLYKBeCKkROsWgKoQjXr3CyxQ8V2L5aHuV5tuu8UlIIlWQLRMllYUv6y7akCJzsxLhaxVviXwmu+7n432+IHick0IrGP/Rh8SCqHYFBK4PUAaY+1S1N4xBibhaILKTCPr89QHu3/XI8HRFvfvS3RJEDjgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0xa8gxklGKb4CZ0e+LA+kksk4edSX2GNsX3phNOMcoY=;
 b=WJ+1xZhIpPBnM6bjTIJu/oanx7geyiCrdZZRbNyZgBh3Mrm3/1z815qtfeS3caFXFIm0m7Roa4gWovP7x04t9NrhvrnAmo3nvIWOIDBum1iYF7lYjPg6pJkpuIlHSA1pP2ulD1354AVnFIID/PXr0qlBLtcRvZNCka/hs/p/cq1Si4vYZfuacYGjG59KuctkRiJ2OsMGDIBX4sMTkPaVMAXn9ENYyKMrGyBxKknML0dfc5jbDqSjzsfQeiPuOtSTlWXF6TSUS3nFcKFZNSzd+Cumu8KzfDBsUZWJwZuIPX1lSDphDieEkU7H40EYVLF3ktNHFLxsQM+9aoHtcC3qvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0xa8gxklGKb4CZ0e+LA+kksk4edSX2GNsX3phNOMcoY=;
 b=bjTdcqocX0Mk/9oNYYqEFzQJvStzh1Jm5AOmzAGALc9sKSXXQvpYcc8J3v+PQZMq5iBcFtENa1Iyftsj+eOwC4QuDGZL7K8JVXLtBaEughAuU6zV9B3lwL3zaOQsL+SvN8kreLfmAg0QBxJwLyXkpY+w0drCL7SLmbiSbHwnfvY=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2885.namprd15.prod.outlook.com (2603:10b6:a03:f5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37; Thu, 1 Oct
 2020 22:38:49 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3412.029; Thu, 1 Oct 2020
 22:38:49 +0000
Date:   Thu, 1 Oct 2020 15:38:42 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     <sdf@google.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH v5 bpf-next 09/12] bpf: tcp: Allow bpf prog to write and
 parse TCP header option
Message-ID: <20201001223835.kxobte2dci2jwiuz@kafai-mbp.dhcp.thefacebook.com>
References: <20200820190008.2883500-1-kafai@fb.com>
 <20200820190104.2885895-1-kafai@fb.com>
 <20200930152347.GA1856340@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930152347.GA1856340@google.com>
X-Originating-IP: [2620:10d:c090:400::5:f2d3]
X-ClientProxiedBy: MWHPR19CA0006.namprd19.prod.outlook.com
 (2603:10b6:300:d4::16) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:f2d3) by MWHPR19CA0006.namprd19.prod.outlook.com (2603:10b6:300:d4::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Thu, 1 Oct 2020 22:38:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa9c3ae6-9cbb-4e9a-cc56-08d8665ac3b3
X-MS-TrafficTypeDiagnostic: BYAPR15MB2885:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2885CA65B1CA87A72E09EA44D5300@BYAPR15MB2885.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g2c9DnxOOOAPd7yzClKv8lPMCMrOgbl8lQ8Rj+dZVT0yxZn2G/14xLvfYdjhvY5b89DdvcqmyFeJFcGVuZ4w3391aQ5Wyk7J/gDmWhF9an9AfjQjbN+1nsPd/4fKNzyKI8G4h9Z/4OXP0aBJox6gn7IHrnBQi3M7u4adpg7btMhOyW2Jqci1aL8KXlT1hFivdRLc3K4uQv4CEgu8p3jOCKaIrwz17QmA7foBXyHCQSLRZdq8BKlDRYOiLgSZOhdmVb6D195zuFfIZ1YYW3BUO9hQz+vq+Us5YeagYu1W64blL+gjYlnKsJaMXSyRpAzZYlCzkNVWMU4SAuztY0xKvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(39860400002)(366004)(396003)(316002)(478600001)(8676002)(8936002)(6916009)(86362001)(55016002)(9686003)(1076003)(66476007)(4326008)(16526019)(6666004)(186003)(52116002)(6506007)(5660300002)(83380400001)(66556008)(66946007)(54906003)(7696005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: u4W3JUIBOPjcY4R8azmd4NiYkSvhcu30yTK+RRdTbkXGV+k3jy7jyriIi61Z0n2ebURHUUvO5lptfrEEYwo+M4uoVWRlZz+BkANtHOrOf17D5J91JUcFpXePJoyTmqff7Jg7Gx4H5WXft8j4rs06xOx5XIx1sUtUTwys6hpuFezjJC8p16Em3fILm5e9/B7PaNOzUMFEtg7uQnmfRg9Dd31bHwiRboI0AKiUT6Z+rXvUKoTeADG4IJTo8WxVtiFoCeznzA7W15w5m8RY0BwGeELDjHlytoV5XnFarlnShqNTv8ls49g/ueu2KdwsTkZIjHtqw0jPeEhE0rdfBVxhZwg53lU0uzgLDeBN9GzYloIn6OjHbrN7yonq9jVRTghAE/uPI4Gjm/8lQPjQTjjNtBLSYsKnIqgpykaGs2pZD56A5xp7GmxiRVvjRb741sNzfzwW3Dc3rhjdv+jJ8G8ftApYweG1m6IdqkzEbaQ+aRAkcydH5eIW7h2dlNq4bRH5Ej7pb3epLqNTvEEZ2sB7/bj9VJOB0JNPQw453crWYqhaUmt/DMUFz24XdlgoV+DTNu65vN1C+EQBYfgtiHW/TvIdtMHSRireSvJZmhhPPnx0Fd+t85FpbHkTAjYjD5GEIYj1cF8pTdhkGnDLiiWvzN7CzLNon5NQ3GeBcfrA3ovtrRagis2f1By8KedsWV/0
X-MS-Exchange-CrossTenant-Network-Message-Id: fa9c3ae6-9cbb-4e9a-cc56-08d8665ac3b3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2020 22:38:49.2163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tb41HLGCssDv2ED0kQB/8eee1ZIMuuWNbIV5zBsdHrIvl6EYx47kIPQBqHdn8yaG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2885
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_10:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 suspectscore=3 adultscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010010181
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 08:23:47AM -0700, sdf@google.com wrote:
> On 08/20, Martin KaFai Lau wrote:
> > [..]
> > +static inline void bpf_skops_init_child(const struct sock *sk,
> > +					struct sock *child)
> > +{
> > +	tcp_sk(child)->bpf_sock_ops_cb_flags =
> > +		tcp_sk(sk)->bpf_sock_ops_cb_flags &
> > +		(BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG |
> > +		 BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG |
> > +		 BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG);
> > +}
> It looks like it breaks test_tcpbpf_user test in an interesting way, can
> you verify on your side?
> 
> Awhile ago, I've added retries to this test to make it less flaky.
> The test is waiting for 3 BPF_TCP_CLOSE events and now it
> only gets 2 BPF_TCP_CLOSE events.
> 
> IIUC, we used to copy/inherit parent bpf_sock_ops_cb_flags and now
> we are doing only a small subset (bpf tcp header) with the code above.
> 
> I'm still trying to understand whether that's working as intended
> and we need to fix the test or it's a user-visible breakage.
> Thoughts?
Thanks for the report.

Agree.  bpf_skops_init_child() is unnecessary and it will break
existing assumption that the passive established socket
will inherit all cb_flags from the listen socket.  It should just
allow sock_copy() to do its job.

I will post a fix.
