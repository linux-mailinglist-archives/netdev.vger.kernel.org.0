Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78BC34D7CC
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 21:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhC2TJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 15:09:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7530 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231630AbhC2TJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 15:09:20 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12TJ6QYX023211;
        Mon, 29 Mar 2021 12:09:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=rVCNIIrY/5K2rjLa631HhZVS/Vhsbf7MSSSNIFl+DKE=;
 b=LCTcmss5oZSnnwZt+TVOnz0lFGkIKnaeQFAzbv2YqBG0mqoa2U+Xl45DvYx2YByeQWG0
 y51nJJSZKnWxbybCUn9/v3DlQg2Pj9K3C/3ub0lV9xd8KWydsSAarGlg6ko5rY4v8pTb
 2XcqoydCy8ktNjoFhU31azfnTKRC3VFVSAg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37kcfnb1n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Mar 2021 12:09:02 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 12:09:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcpaJIJgp5qyad6vuTezzDZ7dHnReHrhWwY+QPzszsIWVV1lQvTizCuzhAzVIIXQyV7PJwvYE/xTcsEi2iUA8XMY8QueHF1Oq/+QN5JHhkLkj4dNI9wN+9OHgucQt5SEMwVGfeUiDcaHtimG/tRm/03L8nTtkNCraJaAaY1lOahltZgoin1wGamttjcbBt0Bk6Y0QKlQtJzxBjOamf4PyVZO4Ho7FGOykzVTFbVAm2hlA0CNRNVbG3TSgTr1/Qni/gWMFM5V9AAo6p7130mMiXBaEBueE1AO1xsCjp8cHzKf4+WUExUHIlp4ofN7cClkDB+BNqR78akfcj57KHhhew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVCNIIrY/5K2rjLa631HhZVS/Vhsbf7MSSSNIFl+DKE=;
 b=TOPRI4OKY2oVZexiB2o8oRf+JtguVWX2L47cTXlv4tdTsu5lj0tePTyysxkOB223H/LB7G/Oq8FhoPePRkxkiBU4CYv/5hzTlxPc3xKHPwM3mlWaYO8gbdzN8DaFhWSIe0w5619oegwGoATklp+t1bL7/G7ZVfYJzemzRaW9GSu9goGWgKiZkobd2GvNSHqMTXX7E2v7ee7VJ4sEdLK9np54v9YKfjH7lv5tHiKDmrNfIJNtfjN3awTk2Mw4ZqoXNO3VFOZKS/ElJ7O1NOe4JMnMlpTkVJCm7trO0Hn1CqJMzCJX/dTSUWOckAqNuZJyZsufMl7fOg9soOP/y8fXcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2950.namprd15.prod.outlook.com (2603:10b6:a03:f6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.30; Mon, 29 Mar
 2021 19:08:55 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 19:08:55 +0000
Date:   Mon, 29 Mar 2021 12:08:51 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     Cong Wang <xiyou.wangcong@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 00/14] bpf: Support calling kernel function
Message-ID: <20210329190851.2vy4yfrbfgiypxuz@kafai-mbp.dhcp.thefacebook.com>
References: <20210325015124.1543397-1-kafai@fb.com>
 <CAM_iQpWGn000YOmF2x6Cm0FqCOSq0yUjc_+Up+Ek3r6NrBW3mw@mail.gmail.com>
 <CAADnVQKAXsEzsEkxhUG=79V+gAJbv=-Wuh_oJngjs54g1xGW7Q@mail.gmail.com>
 <CAM_iQpU7y+YE9wbqFZK30o4A+Gmm9jMLgqPqOw6SCDP8mHibTQ@mail.gmail.com>
 <CAADnVQJoeEqZK8eWfCi-BkHY4rSzaPuXYVEFvR75Ecdbt+oGgA@mail.gmail.com>
 <CAM_iQpUTFs_60vkS6LTRr5VBt8yTHiSgaHoKrtt4GGDe4tCcew@mail.gmail.com>
 <20210329012437.somtubekt2dqzz3x@kafai-mbp.dhcp.thefacebook.com>
 <CACAyw99gXvpnCwkz4vniABV5OQ29BE2K2iJY0tB898Fd9_8h6Q@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACAyw99gXvpnCwkz4vniABV5OQ29BE2K2iJY0tB898Fd9_8h6Q@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:6b50]
X-ClientProxiedBy: CO2PR04CA0136.namprd04.prod.outlook.com (2603:10b6:104::14)
 To BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:6b50) by CO2PR04CA0136.namprd04.prod.outlook.com (2603:10b6:104::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Mon, 29 Mar 2021 19:08:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 969f2535-4e33-49a1-5898-08d8f2e61937
X-MS-TrafficTypeDiagnostic: BYAPR15MB2950:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2950ED73974A732B2F820EAAD57E9@BYAPR15MB2950.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mVPSveaWrXXRDCYn78Syvmz7H1q5dES5mFc+HIvQl6uqx4Hsdu/fkM4EEN0XghDDdQU7aRWCyDB1ZOpQn0yF/IyYYYQNJYHmctaS3LtGOuUhbXz0Xz7ZogkmSqycMqsvZQN5eRxI44duqXWytHFVspRkWcCwT2AtUcQnx8ERi0mCanbHvTg9pegs0DcaddAi0tsRFLfj+ZCGtwXUK/GUHos/uOQtw/nM/VgrtCd5mbD83b5oCR1hcLicnnQdZQ6/MPDy3g5NECyjbTP+ei083D2ZP842IhBTDQ7Xm5c/9o7x8IAO8hG+tJOQq3JQrgBD7nhe0hd/Ej9VaxRyHBh0ChTFuKEU3iG+xRGR2zde+eB8m6AKMaNHqskcxkIqcrScOkd5JwLBxCxVnos7WDbefvOLvTwJ2aZSLjR3dwFWOaiGuhSoBCUX3MqCCg0jsoQ+R8ObSFXed3U6dgM+/kYksMS/RqnVimxfF6JXUZIDNphd26MdPEvE2M8pR17lRYu0yq/00SuUwkbBEY3OvFkFTvK5apy2KzPu4nYLmzN07uV6U+4R30xf/fjfr1wCnlSsGo7iy4t5tilfSlUcSHrb4m+dRPUYCX9axBEt5MsWJQhwWeov6pyy8QLtlIIQvk8li27/wiQ7COtcl0PJqYo14g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(396003)(136003)(376002)(366004)(7696005)(83380400001)(52116002)(6666004)(5660300002)(66556008)(66946007)(478600001)(1076003)(66476007)(8676002)(186003)(38100700001)(6916009)(2906002)(4326008)(8936002)(316002)(16526019)(54906003)(55016002)(6506007)(86362001)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PX/SlqAKi1ja2genju+6Sd7GaU0DDnf7E6KWHgMLfz0UW/MXW5hZu3p3TWHl?=
 =?us-ascii?Q?B2l7VGSzNCqj/L5VpE82J4w97h8Rf43PnCRTEaXo8CkGIAF0jxEZGMtFO2fG?=
 =?us-ascii?Q?Xc7tNxh4Ilr8R7A1vP8to5Op5Ntz07XFUWnfFTLZMxpeZKOoX1PJDi3JezaD?=
 =?us-ascii?Q?SelYhh0lFpL6IhuM6H76ONqeNbKO7ohJc5TEWuTFOg/CDEZA9imcjJlypZVu?=
 =?us-ascii?Q?MXb6VF53Z/6ZH9FLsZD+oRC9u6wQLqRWzORTMkj0XtQJpdLfKMQyu+IsjZsL?=
 =?us-ascii?Q?IHSEZ2AWLPdJGOC7Dy9oerNLltg5kT3XipdaiEGmgb5/OZ4Ctd7SqdZg458W?=
 =?us-ascii?Q?Sggbp99GT4fxMyIAY75TW5YOLoarg4YZE8iMNRrsQthFli4/5KNP37SP+g1c?=
 =?us-ascii?Q?svXnpqfUesfr3K6SEkMLzJ+fALJnVSX3Qm38piSmx9HhCczON/1PVrQiCkyA?=
 =?us-ascii?Q?vrdtKJz1byP8rc27cspvm+awetKEK71iMdo2nZI+V+O2qW650BvWN6JG42K/?=
 =?us-ascii?Q?pA1+PfakkcDMyUB1+EAkwI/iPKsMJoHSsON2+OOnf5/YYm7B+Y7yoJHT/BaN?=
 =?us-ascii?Q?HNufewK5hbff4NYcgirYjzkLDSKtH5BiQRhpD9yFqUfTYUDXRA/i8OLjdmkD?=
 =?us-ascii?Q?arjpRRsIH4bJpWfWOq8Szdh+uffn0VU710Y4g+AHINBp5EKZeDcsV7IYwQLg?=
 =?us-ascii?Q?wGxuCvmgc3esJDohJQP/StaSTgi2RfLAL4zaRnR6llgJYZM9puqUdMN21sPN?=
 =?us-ascii?Q?aJUWe3jdHiJJS4X6pv2MaH4gQ3XqUl/Nid5jlKSf0TTJ9mW7RFp4nOmX3UZM?=
 =?us-ascii?Q?0s/xJla/0cC8PYvvwed4Ob3T4UGSl8UaoSp0HaOi2VxnmN3pFIXguO4nHJJx?=
 =?us-ascii?Q?Wuht2wC4D4dFdfsUTaOG2k2uDKMB9LE1BmgY6dnpKG8U8/Yl0Tqk9EcIWCka?=
 =?us-ascii?Q?WAx0fjoXSCXUE6x7pTY4ukMKSmLs8acglAUA49xAhu1U3/C8+Enq9etAV+B/?=
 =?us-ascii?Q?jZx816kye/yO2IYL0cp3TSG+gxUXzFXjZrmQbbqjILPqtK1GCiFRFpY4mFL5?=
 =?us-ascii?Q?vbkT3n0KU5QCDGO9VjN7Ep8wGQRxjbuqWILvVJIp2EbT5daBjXnUZvUrbldj?=
 =?us-ascii?Q?Hjx3Teowd3vEe8IaX3jc+lECvM6hj9o01HzrAPmneEVv2B7oJPcCQ2mIIolJ?=
 =?us-ascii?Q?u73Q+Yu7Nwauq+hbv8+AaVmGoMVBK3oQdNXs7FEZHXxDmiYks3JmBoJQRMQR?=
 =?us-ascii?Q?t+RCd9vPLyoRjeNuukzGmXjjPDpjHeuWL+XqXxi9ofulnHBiNni2o+tCLkVr?=
 =?us-ascii?Q?9me7XJQmOp5pgk50KdDccIiFKDKguQWdGr3Nr3XkLmX8NA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 969f2535-4e33-49a1-5898-08d8f2e61937
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 19:08:55.6180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +J12E3AF91kU+WX/OFFBDU/3t7GtHRx76hGxKOdV7UChacm2YUx7bJALO7vSytkl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2950
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: qAf1n9vzHy6J-QZuTGHG96wUDlLpJ1WR
X-Proofpoint-ORIG-GUID: qAf1n9vzHy6J-QZuTGHG96wUDlLpJ1WR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_12:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 clxscore=1011 mlxlogscore=999 impostorscore=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103290140
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 05:06:26PM +0100, Lorenz Bauer wrote:
> On Mon, 29 Mar 2021 at 02:25, Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > > > >
> > > > > # pahole --version
> > > > > v1.17
> > > >
> > > > That is the most likely reason.
> > > > In lib/Kconfig.debug
> > > > we have pahole >= 1.19 requirement for BTF in modules.
> > > > Though your config has CUBIC=y I suspect something odd goes on.
> > > > Could you please try the latest pahole 1.20 ?
> > >
> > > Sure, I will give it a try tomorrow, I am not in control of the CI I ran.
> > Could you also check the CONFIG_DYNAMIC_FTRACE and also try 'y' if it
> > is not set?
> 
> I hit the same problem on newer pahole:
> 
> $ pahole --version
> v1.20
> 
> CONFIG_DYNAMIC_FTRACE=y resolves the issue.
Thanks for checking.

pahole only generates the btf_id for external function
and ftrace-able function.  Some functions in the bpf_tcp_ca_kfunc_ids list
are static (e.g. cubictcp_init), so it fails during resolve_btfids.

I will post a patch to limit the bpf_tcp_ca_kfunc_ids list
to CONFIG_DYNAMIC_FTRACE.  I will address the pahole
generation in a followup and then remove this
CONFIG_DYNAMIC_FTRACE limitation.
