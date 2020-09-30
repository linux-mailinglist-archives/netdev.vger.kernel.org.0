Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28F227F59B
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 01:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731986AbgI3XAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 19:00:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9622 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731977AbgI3XAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 19:00:07 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08UMvgYM015445;
        Wed, 30 Sep 2020 15:59:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=KLhJ3oyFKy1BuxHT4eKRTiRtkATXA7pfZelMsjc09ts=;
 b=IRLWl9Yr80f+1eYBUF5h3FsFFLpMb6/6D4dAmH51YugddLOjgUHbu0AA/V/v8+sJiJNk
 NWcR/O9AOGnAU/4uc/Wktb8Rf8x67rKUGsytUodcXi1uYjGJIFpg3uwvHsgHxk42Hp1P
 2h2T6PzPQnKb99MEMkkNo++eVSI+l+WOHOo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 33w05n15um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Sep 2020 15:59:51 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Sep 2020 15:59:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYCgHiiMRhP9zdQx+X4DRECB7GOCxeAZrkPJT4o2LN6rjG7ryh+w/m6XDcCZgshgqe1JQBCGpRz5Fn81RxxV5VT86M84BYUKjJCy16lHNSzF5ePIiZa+SJl8qd6D0avSgNOIelnSU3nk9EoLUb4UDdivXAoGSjgQMJjPhRd1W0b9W11NYCf4AkWMIED0kE180DniDLN8WZGHxuVM7yPdD33YKM48aStn2RYIz2mWp8IWbrQZGrWmiPQ7ZIpN9XPB5fh5tIL3qOH02MwgpTSccCPXn4ReBkmfD8B1U3B23s4YZvD4Hk4W3hCUKNWj0Lye6dxnEuCaBMzsqPb2RtKc0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KLhJ3oyFKy1BuxHT4eKRTiRtkATXA7pfZelMsjc09ts=;
 b=CDvThMwByfx3sH9QZYz5Le8SjUtYinxdCCJ5KSQzFei5iwXk8P/Ai6pEXc5LW2RBwsOj99C5okqua/Pbd8eVFIexoj5WggbI70GfGbkygFp0r4V3q3s6Ultqk/04QSafj+KuPoPRLxCSPQGC4473eHHRsU6l0wt9mihzigvV0fRMcUR+aCtYRur5Nob/YVodYvv+EhlqJPO9bTxw49Duo8p3T7cIT0wt+EhtCz8t/oArWkuODz9N/J+dBpjduq4HCZF9AM3i1BfXpUcpgASZ9izGRLDfYurKUQUhgkYZ3UB1zKsAAz9ZCJ/UHIVvQmXF3WutVe3Mvp7rV+6p/oSbzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KLhJ3oyFKy1BuxHT4eKRTiRtkATXA7pfZelMsjc09ts=;
 b=R7Lqh7UYZpT0ZHGFdeIZBFb4b67yY3UVAoetts4QBmbtXlrWuFifYYbnIcKPi1xX26myEgsFYOeyBQ7zKVItW9DGoa0s2H+CHrA0RteeuWx5xX38sDoDnqAnV04wi9d6dHkbHZvCvLxBGdHsehrIQj9Nssa8/3eOd4nCxzrcx3I=
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2728.namprd15.prod.outlook.com (2603:10b6:a03:14c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24; Wed, 30 Sep
 2020 22:59:49 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3412.029; Wed, 30 Sep 2020
 22:59:49 +0000
Date:   Wed, 30 Sep 2020 15:59:41 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH bpf] bpf: fix "unresolved symbol" build error with
 resolve_btfids
Message-ID: <20200930225941.zq2vaxsuphfbga4s@kafai-mbp.dhcp.thefacebook.com>
References: <20200930164109.2922412-1-yhs@fb.com>
 <20200930205847.7pj5pblqe6k6v64q@kafai-mbp.dhcp.thefacebook.com>
 <d5d8091d-e02e-3903-6203-c136b8d70c09@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5d8091d-e02e-3903-6203-c136b8d70c09@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:f2d3]
X-ClientProxiedBy: MWHPR08CA0039.namprd08.prod.outlook.com
 (2603:10b6:300:c0::13) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:f2d3) by MWHPR08CA0039.namprd08.prod.outlook.com (2603:10b6:300:c0::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Wed, 30 Sep 2020 22:59:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 642623d8-0bab-46bf-5b6c-08d865948835
X-MS-TrafficTypeDiagnostic: BYAPR15MB2728:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB27286C34A9D89F0C12F19885D5330@BYAPR15MB2728.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YzMveRxsOWR7wqv3tygzR8ByGqK+edlKEXFbOMrlz3jxUWhxNxHOETaXMNQDXY9dQ4CjgVZo4H7eiGrIfa3tZSI177YoD3dEyrovw3ZkW+sCCDTqDjp0peicxVlLZmKl6M2bCEcq6PSOUX4Rv5sPNXpnL4WfgU5RiSSS4evnGeF+P2d3z4FGuHn0slYlwLv6CmnOIqTxKblxIbMBwpbuN4iVN2nc3E0NGNGoFr8FRWWJYH4J6mVlllcZzq5bvEQ2Uc+A7EiIxzmpQkVM9YMTRhdoRh8VR3xomyCgsN3X0DKN7Z8/+Zrpaf00PTWA9Uvh6qQrcMSMSUQshhCi0iiz78UyD3PdvohtGnuyS4T9PoQY1mfBL1IOmjkxxTZAS8XGxwnfhwm7o6fJgF2lmYej9qGv3axUNdYksf+URdOGsjE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(396003)(366004)(376002)(346002)(66476007)(66556008)(186003)(83380400001)(16526019)(9686003)(316002)(54906003)(6636002)(1076003)(86362001)(5660300002)(6666004)(8936002)(66946007)(478600001)(2906002)(55016002)(52116002)(8676002)(7696005)(6506007)(6862004)(53546011)(4326008)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: nLUS99scdH6Jdbq/m/pAPdqwGmnw3L357GCOK2SH//vUhS3DzhGx2ZndLxbuzCJkCq2s2onui5P6lfaMhBUwTtrjMf0QZ6AjZvsvHQ8cQuywrBMYhRh0tfRITKBKHHluSXBxWofucdgo6Sw4hT8C8tq5qFw/RDbmiWE5B4woVKLCnz3JfCUwmJcBhWIV58nbmYQCqLP1/0uRBxBDiRrwRqnprpxyR6lnF+Lvi4itY+R+0iGg4bt4tEogE9qlZh2gIl0zZeas1hDw8JX8wQvoDqQ6f+W7v/nzV6cJZ9VQlDX0+oJzZFA+SIm22diqRdq0x9/OQJ1EcZGQV7uDGf8O+9I/S1DXCTqzftRKyHU3sYneuFgYUyz2Ix2eyLlv/RRs/KWJos9BGzZKJcoABVK3dRnfK6HNsu3YCMPBplnjI7WgZu6b0gpQ44X36j8OorKAB+QL8cosfLaLpYj8XwK7u7zMA3e+PVaTVsFYYSBe9v2W8TpSlPB7WjV/4mtbaQ+6eghJZj0sWSqbTQM8YhkHPvY8gRY7JuJzcXBYtMcqDGXExhwEuyEnNdk5/Bcu1cbqk4+8vvehiferq9l5pIaj/188Vw2dO725ygw/tLHjg5GRYHd9mQbmojAWcbmB5GzYaPA8qO/9L35rcYsekLJxzRp066Jxq0YgOHLObR6rszhvVX1VLg0Fs7IDfkdRPpEx
X-MS-Exchange-CrossTenant-Network-Message-Id: 642623d8-0bab-46bf-5b6c-08d865948835
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 22:59:49.1556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H1ax7a+n/2X1OF7/D1uFOKsKO/1kDTML8KW75nkeRsFlT93XLgsHPr9mi1aTDD0b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2728
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_13:2020-09-30,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=1
 priorityscore=1501 mlxlogscore=999 impostorscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300185
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 03:50:10PM -0700, Yonghong Song wrote:
> 
> 
> On 9/30/20 1:58 PM, Martin KaFai Lau wrote:
> > On Wed, Sep 30, 2020 at 09:41:09AM -0700, Yonghong Song wrote:
> > > Michal reported a build failure likes below:
> > >     BTFIDS  vmlinux
> > >     FAILED unresolved symbol tcp_timewait_sock
> > >     make[1]: *** [/.../linux-5.9-rc7/Makefile:1176: vmlinux] Error 255
> > > 
> > > This error can be triggered when config has CONFIG_NET enabled
> > > but CONFIG_INET disabled. In this case, there is no user of
> > > structs inet_timewait_sock and tcp_timewait_sock and hence vmlinux BTF
> > > types are not generated for these two structures.
> > > 
> > > To fix the problem, omit the above two types for BTF_SOCK_TYPE_xxx
> > > macro if CONFIG_INET is not defined.
> > > 
> > > Fixes: fce557bcef11 ("bpf: Make btf_sock_ids global")
> > > Reported-by: Michal Kubecek <mkubecek@suse.cz>
> > > Signed-off-by: Yonghong Song <yhs@fb.com>
> > > ---
> > >   include/linux/btf_ids.h | 20 ++++++++++++++++----
> > >   1 file changed, 16 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> > > index 4867d549e3c1..d9a1e18d0921 100644
> > > --- a/include/linux/btf_ids.h
> > > +++ b/include/linux/btf_ids.h
> > > @@ -102,24 +102,36 @@ asm(							\
> > >    * skc_to_*_sock() helpers. All these sockets should have
> > >    * sock_common as the first argument in its memory layout.
> > >    */
> > > -#define BTF_SOCK_TYPE_xxx \
> > > +
> > > +#define __BTF_SOCK_TYPE_xxx \
> > >   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET, inet_sock)			\
> > >   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_CONN, inet_connection_sock)	\
> > >   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_REQ, inet_request_sock)	\
> > > -	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, inet_timewait_sock)	\
> > >   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_REQ, request_sock)			\
> > >   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK, sock)				\
> > >   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK_COMMON, sock_common)		\
> > >   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP, tcp_sock)			\
> > >   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_REQ, tcp_request_sock)		\
> > > -	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)		\
> > >   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)			\
> > >   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)			\
> > >   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)
> > > +#define __BTF_SOCK_TW_TYPE_xxx \
> > > +	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, inet_timewait_sock)	\
> > > +	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)
> > > +
> > > +#ifdef CONFIG_INET
> > > +#define BTF_SOCK_TYPE_xxx						\
> > > +	__BTF_SOCK_TYPE_xxx						\
> > > +	__BTF_SOCK_TW_TYPE_xxx
> > > +#else
> > > +#define BTF_SOCK_TYPE_xxx	__BTF_SOCK_TYPE_xxx
> > BTF_SOCK_TYPE_xxx is used in BTF_ID_LIST_GLOBAL(btf_sock_ids) in filter.c
> > which does not include BTF_SOCK_TYPE_TCP_TW.
> > However, btf_sock_ids[BTF_SOCK_TYPE_TCP_TW] is still used
> > in bpf_skc_to_tcp_timewait_sock_proto.
> > 
> > > +#endif
> > > +
> > >   enum {
> > >   #define BTF_SOCK_TYPE(name, str) name,
> > > -BTF_SOCK_TYPE_xxx
> > > +__BTF_SOCK_TYPE_xxx
> > > +__BTF_SOCK_TW_TYPE_xxx
> > BTF_SOCK_TYPE_TCP_TW is at the end of this enum.
> > 
> > Would btf_sock_ids[BTF_SOCK_TYPE_TCP_TW] always be 0?
> 
> No. If CONFIG_INET is y, the above BTF_SOCK_TYPE_xxx contains
>   __BTF_SOCK_TW_TYPE_xxx
> and
>   btf_sock_ids[BTF_SOCK_TYPE_TCP_TW] will be calculated properly.
> 
> But if CONFIG_INET is n, then BTF_SOCK_TYPE_xxx will not contain
>    __BTF_SOCK_TW_TYPE_xxx
> so btf_sock_ids[BTF_SOCK_TYPE_TCP_TW] will have default value 0
> as btf_sock_ids is a global.
I could be missing something here.
Why btf_sock_ids[BTF_SOCK_TYPE_TCP_TW] must be 0?
How does BTF_ID_LIST_GLOBAL() know there is a
btf_sock_ids[BTF_SOCK_TYPE_TCP_TW]?
I would expect at least BTF_ID_UNUSED is required.
Otherwise, the value will be whatever follow the last
btf_sock_ids[BTF_SOCK_TYPE_UDP6].

> 
> Will send v2 to add some comments to make it easy to understand.
> 
> > 
> > >   #undef BTF_SOCK_TYPE
> > >   MAX_BTF_SOCK_TYPE,
> > >   };
> > > -- 
> > > 2.24.1
> > > 
