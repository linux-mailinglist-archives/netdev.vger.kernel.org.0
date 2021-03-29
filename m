Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A3634C114
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhC2BZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:25:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16392 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230525AbhC2BY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 21:24:57 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12T1LH1O021916;
        Sun, 28 Mar 2021 18:24:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=YzCtrrFbEvzSXRdke3PxYi0NkUm9LER9F5xpa4lQ6pg=;
 b=mE/jecB/ukthxiYo/6Yoy5W5TFCaGgHTKa8cpcpU71tmsk3j/KNx2P6WMDDj0XdmGWYT
 zajMQA87eNaDrxBYZxyby4Rbjihq1E4hemnGD8Py59x3JWc/+DWBuX/sjIL+DkBlACAj
 0aRemMNxT8rBvTpgeHISgg16KXT6ZXqngv8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37jmsqtgeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 28 Mar 2021 18:24:43 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 28 Mar 2021 18:24:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dtxj5rTFZg/NMPu0eWk3VfHmHAzEXsFAKsb1MqeAIZRTczt27rNTFqmOED/5FM+o1id58LL9L3yXUe6FWJxt5kHlY2j1jdjzIg1zr+UWZz8pjkmyEgQzBRQtQpnv3K/eZlFUjf03DyphkGIglDEu9oJVlUpeELNt2DQMHcSIsr1nDTrLD3Y6Sd430GecNUA8pn0xvdXEX2WZKqRuuL42rAtf7abAdTMJG7hP8fXT1Ete0UhyHJrj/LzZvVs5KifxpzawLCD4zQoh64SRfaIsx4pM26QsVY/EUoaeDH93vfkPvdXYq0QUu2fGRomCcCjTl6FpCSdbvZs4Pn6NbMyqpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YzCtrrFbEvzSXRdke3PxYi0NkUm9LER9F5xpa4lQ6pg=;
 b=kHtVxBdPKMfga0c/BMGaEUVfA3YiZeMhAV5CQzShkK4FOqvsQu79JBk7rdX5qsKI0SPiFxP0gpUKVbrUwTCJdcvlX6xvgKGWGhASbNFOi350oQjTnp16hndjTvkN37LoIDqany3CDRQBI97ANWmcYOvYyHQlA7Y2eGj1+jb1Xslel5dPPTb1hPqeobEcB0NVSusxaR1+2f2wa33ABvsS95M8s8m/rNUS0x68Cv/0vIUtmvN68uvVtz6r5eKMaV7DZ+leqe0ZkYx3FmCsVWz1Il0NYQPJx/4Yu0iEfLRODXdG/gFLZao0HJb9fOjtrRr1glz2mzIg8b+yYL++8xUwig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2823.namprd15.prod.outlook.com (2603:10b6:a03:15a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.32; Mon, 29 Mar
 2021 01:24:41 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 01:24:41 +0000
Date:   Sun, 28 Mar 2021 18:24:37 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 00/14] bpf: Support calling kernel function
Message-ID: <20210329012437.somtubekt2dqzz3x@kafai-mbp.dhcp.thefacebook.com>
References: <20210325015124.1543397-1-kafai@fb.com>
 <CAM_iQpWGn000YOmF2x6Cm0FqCOSq0yUjc_+Up+Ek3r6NrBW3mw@mail.gmail.com>
 <CAADnVQKAXsEzsEkxhUG=79V+gAJbv=-Wuh_oJngjs54g1xGW7Q@mail.gmail.com>
 <CAM_iQpU7y+YE9wbqFZK30o4A+Gmm9jMLgqPqOw6SCDP8mHibTQ@mail.gmail.com>
 <CAADnVQJoeEqZK8eWfCi-BkHY4rSzaPuXYVEFvR75Ecdbt+oGgA@mail.gmail.com>
 <CAM_iQpUTFs_60vkS6LTRr5VBt8yTHiSgaHoKrtt4GGDe4tCcew@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAM_iQpUTFs_60vkS6LTRr5VBt8yTHiSgaHoKrtt4GGDe4tCcew@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:c3ea]
X-ClientProxiedBy: CO2PR04CA0156.namprd04.prod.outlook.com (2603:10b6:104::34)
 To BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:c3ea) by CO2PR04CA0156.namprd04.prod.outlook.com (2603:10b6:104::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Mon, 29 Mar 2021 01:24:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b480e45-bcbb-4536-4905-08d8f2516cf4
X-MS-TrafficTypeDiagnostic: BYAPR15MB2823:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB28235FE9CD8F838174451363D57E9@BYAPR15MB2823.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /JphC4D9UeQ8NsqNXtzL0SfD2UFqT7aLRCDYAkWn3d/MhjmbYsPXXxgoHAIudHtFz/6IjoV+9JpWhMrIv4kz8V/d/bQhq67f3+6v5BnJpoTPTaoAihZkrjV1Q6mDznq6Gp9RbBHCk/0ut26F7tQsBcEPYd8TrtoiSLPVvIONC0A4Ia0q4YJGtgYEJmEslb0SnT709jYxrWsk2p0I9G1V4+SC6XJ4Cc1+VD4mybghC3REzKkhJukuZ2BR8li7J1cO7wWQE2FCdMrQ+wGC2nrbdzU4FwkgkJ0XgwTEFUHwPNEMTh0AmyNKwPlaSGxKcWO+KVdpqiIpl9YgDTWar4nyatw7eQzPlRxBK+hduh/GjoQnHlBwuettjbutaPSYqaiqWKjgr3Gjv4hLNRhAd/OrnsWjFsJGdHqlCivHhK0l0yNcesnyeWbS8wu4/E3ij/RiVaN4+kdjqYOYX5Ti1nJ0VepqDifZnqWoJaN6X5Kr5roY1QLq1lJE50nZxs0CoV6AQ7RhKbywbD7LaZnyMcePr7wUI0Og4VhkBFUr0Z4dNRM4uIvpBaqSutnpSPpbvZjfjRJCf61+U8sx0ZzNagBBdlBiDIbY4uSDOGxdBpzyetawMperh3FrOVLhFsC/at3lkw41+9uPZg7v7nFhjDAI4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(346002)(376002)(366004)(8676002)(8936002)(2906002)(6506007)(316002)(66946007)(54906003)(52116002)(9686003)(66556008)(55016002)(7696005)(38100700001)(66476007)(53546011)(4326008)(1076003)(478600001)(6916009)(6666004)(5660300002)(186003)(16526019)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6fLRkcon62f/ealKeOzPfhXCLhfswfLmBo90S3p52jAQzkdCYpzBmMR3Y/xH?=
 =?us-ascii?Q?XOywsz4rfjoDCNCqUwnCghBaqro3taEePRe3aYn9BtmubalB1hNQfs5oNvRY?=
 =?us-ascii?Q?cbT6HbiahF0XskBGZ+3szo+H4BqJx1gNwhhf3rbMuYfg0R7LCjH86/Vf724B?=
 =?us-ascii?Q?gi59utuwjcdXPqKtzsxlGqShp9O719vWhaK6Sp2MLhjjT5otYoYimzhN2OIe?=
 =?us-ascii?Q?Qf+iZJyMqDPvpZhWp0reyDJEel9SSew6X6X0kA1bcr52h+czbzKmJx3/Y2hQ?=
 =?us-ascii?Q?WBysx55rjjF6ssInrrwvTu3mNBlmEFTQqRJRcxaMGQXa+C70qh9dg2FL439M?=
 =?us-ascii?Q?LBHxbuiPsE5AF+zfWrmdGJ15TYKSck6eSgJIVf5s1pypa8cCfJafm120PKqE?=
 =?us-ascii?Q?aV4Jzz2YAGzaS4aMWxl2c9ZUsuh9FNktoIFdIbz31KV7tnZF259VBSQD/k7t?=
 =?us-ascii?Q?pLWlouJt2namcsLf5UkyYWV9t0aF3ZMUypsSv3BW7GxVRNmVyqmYkZIj+q+n?=
 =?us-ascii?Q?mUCvDJfjQykXNQVsYBgBHU+HggJEEzo3Z0246etEERqXwMrjzAHYLyi76i4M?=
 =?us-ascii?Q?SU0u3+9dMouZ3YyAhAlDOoGa2JlA6LkvUBwoVFafDYgZWbauLR7+EvBkWK+5?=
 =?us-ascii?Q?XZzCm0INXbHdsY1eyJqZea9pSIhQ6B19uMR76L8LxGk6P2E606R7wyBVUi/C?=
 =?us-ascii?Q?dKuIFK65q44awRPTF80AqMv8eAzBu1JdH6XajRxTIkcfhgl/oZaRLChIdkpO?=
 =?us-ascii?Q?9Q4TG17zLcXZ3qb0givmdNBuAu13XyBkhf3eQQWVsJhCk2m1GGdLDaw34JHA?=
 =?us-ascii?Q?j7n4r8NWWbB9pE6osS2YwE/8i1fCoikHWJPSKIyTBfTAn+6xIeN7JlfFv+24?=
 =?us-ascii?Q?ObSLUuLxizRLasNk6YXdOXc+cBf9U+7Ji0ZR6+B59C4RxxS4aR1qGXWqfWIC?=
 =?us-ascii?Q?Ox6eN2ynOmIGgfr3g8uSD+iqHpJRSBEYWVheVckSJcfYL1CO+ULxhBbMwULK?=
 =?us-ascii?Q?POQ8lRXC6XtXjOWxB8++9/aMh7Q4+Fbru5VmEmB0nxKQU+MAseHpBeJwwfbh?=
 =?us-ascii?Q?tUk07xyATJQh31sjktGC6EwqXwjoa0RYFRP6ZkKZDwWnQpWD45pFF5H7AWlh?=
 =?us-ascii?Q?hJvEIr1r3B0qbj5Qtk59CjPBylUGjAS49WrD1xbkZ+bC+Rk8n6Nl9vFxsNn7?=
 =?us-ascii?Q?9UoB8rUDFN9pE83HTtRAFHN88ROFQV0+Lv6UadNUGiN08TReX9noksqZDIpc?=
 =?us-ascii?Q?9Tp8lhBFxtyG2MPz1CDTZ2diBardvIOtUGA9W1clPCnDnJ2ZpSwkpngDRpp3?=
 =?us-ascii?Q?zP3OjE9o1fgJIvJZlErTlDlBjtQ3E20hUbemxy3OIOB/lw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b480e45-bcbb-4536-4905-08d8f2516cf4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 01:24:40.9355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +fBszAToKrO8pDRPYeelzTo6gjZ2YOgUYBwnVFESFqgLKrjApSfgja/JY2n8cTb2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2823
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Awl6KXZ6yF26KPdn6U4LciMngwgjSuJL
X-Proofpoint-GUID: Awl6KXZ6yF26KPdn6U4LciMngwgjSuJL
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-28_14:2021-03-26,2021-03-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 phishscore=0 malwarescore=0 spamscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103290007
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 01:13:35PM -0700, Cong Wang wrote:
> On Sat, Mar 27, 2021 at 3:54 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Sat, Mar 27, 2021 at 3:08 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >   BTFIDS  vmlinux
> > > FAILED unresolved symbol cubictcp_state
> > > make: *** [Makefile:1199: vmlinux] Error 255
> > >
> > > I suspect it is related to the kernel config or linker version.
> > >
> > > # grep TCP_CONG .config
> > > CONFIG_TCP_CONG_ADVANCED=y
> > > CONFIG_TCP_CONG_BIC=m
> > > CONFIG_TCP_CONG_CUBIC=y
> > ..
> > >
> > > # pahole --version
> > > v1.17
> >
> > That is the most likely reason.
> > In lib/Kconfig.debug
> > we have pahole >= 1.19 requirement for BTF in modules.
> > Though your config has CUBIC=y I suspect something odd goes on.
> > Could you please try the latest pahole 1.20 ?
> 
> Sure, I will give it a try tomorrow, I am not in control of the CI I ran.
Could you also check the CONFIG_DYNAMIC_FTRACE and also try 'y' if it
is not set?
