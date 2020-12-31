Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F2E2E7E7A
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 07:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgLaGsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 01:48:38 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31370 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726037AbgLaGsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 01:48:37 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BV6cRVx027172;
        Wed, 30 Dec 2020 22:47:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=1HvpFNXqLP37SVVi5hk/s/hXhSGuT7t7waUyClil5Ys=;
 b=eDDni5tEbf+rdHOlWbk3LjvNmFirzmWr5/OTHENym4PwPdK4gBVemC6kDNiONBP2WR2F
 eHm5z5jZOYymGIOoPMqWV8SwwD0p1aZp/FBs+LWHHsplMCyp4fN+lFJU7kzn2jVPBctj
 wOI8osiNR9J3SNwryT18hw1NCkU/XLeT3u0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35qyks05gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Dec 2020 22:47:40 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Dec 2020 22:47:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HQmS4wAApjDnU4JvBi+YfFChHnudiIVBFJJIdGLK3Qcm9C+K9ecFbhReNIm4VxlXVZEqcKtuVSqyNLbTVKDj9Ree63tDaqLX5RGm24JSEKdfP+mk7S9JtAP9lcsCLIIz0nQ2QX7OtoTJlpFCxBxyMUGDlKr1JVs3bUXFFgqOQzoRkwgZn5Fky/oQLiciNY6lBtJolbRugH6BDiD1Ch3u2DCm5fulJXVKN09Y5muFb9HlUI4Dw3NwuwoQvAJqEQbYj/s6p0IXMyMaUNQ8USbc5UVsyphgJSvC6qUckO8wRdUWjCRazfjHsLHKUW1KqQlL2CXrogCyjUxmZLLKJQOc5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1HvpFNXqLP37SVVi5hk/s/hXhSGuT7t7waUyClil5Ys=;
 b=oAYcWEJLfiYXi/C7YsEUCtPWk1fXsK17x49rZm8dxDGi8mNb+xEsx0Dq1Made/ED5Yo7rqMGdy8D6I/+wP5xWXO0J4fmC+Uv5cg7p1yIrFs0RmupShJc6hFwVnCrRcNJgXXDpyJ6is1cECQK6TfiE7UbPVf97Oi467JOu5mlS7NLcoRt4jHNuMfrqN//xieI7cC5TRQhS/zXU5F1sKal5Eabpg5D0K6nNEjHUQjC12t4dfhP4fzE9JksvuEq5clCHH3cD4PihZ3YcdUUvtJSdVwX0zADZ8Q0VM+TOC+A+kab0rVyiOvrvv6EfjMPILnUI+G2fiXg/HMpL5hngqaGqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1HvpFNXqLP37SVVi5hk/s/hXhSGuT7t7waUyClil5Ys=;
 b=Kkh+DYsFacXD/W+9Nasrc1UM6j8R/0eKMT8hP9g7PXV89FA6Pkjhqqz2pSzeUKydGjmuw/1qeCgbS/EMfZwAmn0SFWhkhRyZToXgqBHgla9nDPE5O0rEEOKiTqDOdiNnhgtxD4ZxAFrlPRRha4k48ZzQWj1DXdj29jnEe/oTThE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB4118.namprd15.prod.outlook.com (2603:10b6:a02:bf::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27; Thu, 31 Dec
 2020 06:47:36 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7%7]) with mapi id 15.20.3721.021; Thu, 31 Dec 2020
 06:47:36 +0000
Date:   Wed, 30 Dec 2020 22:47:28 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Song Liu <song@kernel.org>
CC:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/2] bpf: try to avoid kzalloc in
 cgroup/{s,g}etsockopt
Message-ID: <20201231064728.x7vywfzxxn3sqq7e@kafai-mbp.dhcp.thefacebook.com>
References: <20201217172324.2121488-1-sdf@google.com>
 <20201217172324.2121488-2-sdf@google.com>
 <CAPhsuW52eTurJ4pPAgZtv0giw2C+7r6aMacZXx8XkwUxBGARAQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW52eTurJ4pPAgZtv0giw2C+7r6aMacZXx8XkwUxBGARAQ@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:d5ef]
X-ClientProxiedBy: MW4PR03CA0266.namprd03.prod.outlook.com
 (2603:10b6:303:b4::31) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:d5ef) by MW4PR03CA0266.namprd03.prod.outlook.com (2603:10b6:303:b4::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19 via Frontend Transport; Thu, 31 Dec 2020 06:47:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1726e709-25e4-4f1d-c16e-08d8ad57f553
X-MS-TrafficTypeDiagnostic: BYAPR15MB4118:
X-Microsoft-Antispam-PRVS: <BYAPR15MB4118CB12E2BAA1D4CF68AA3AD5D60@BYAPR15MB4118.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YMc8kRSM6M4mtT+Wyi4OZpgYmBrQmIHRm5fzMLFbmiUQvLDaAX/icoXrIFVpg4leridZ+j6QtRKGVbvPNinjqq7fU0Ffgp/IXb9ljMA+iTWvXzpd3SJ8Yms7LgFNsHxiFx7mTwD32X0lPOzqoH/Gt6KsIjoTMYpmTnD74tYrCYMiVyGPbCWJ+uwBleu3QbLad5jhtoD9fW0b8k4A/QaJodkHdCSqwRzb5zmZmXKDfyCjxvW2GGtrXf07gHxyK2DM0XllxLR/B+z1AOe8G+/adMqfIY/kqXel4FGDKXxgKKiD79oWLgAyZs0XQ3l6vs6v1FkbOkEDPBie75GnfiWWT4qDgt9f4EbyZQBlrQmr3teyUH34iODn+NiAq/5pLPpDd1suzy0VlFjX4+VtTOZgyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(346002)(376002)(136003)(4326008)(2906002)(52116002)(6506007)(8676002)(6916009)(86362001)(1076003)(7696005)(5660300002)(478600001)(9686003)(186003)(16526019)(8936002)(6666004)(66556008)(66946007)(54906003)(53546011)(66476007)(55016002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5W/SoqdJD0zCKsgm6M9PjBvwrf72bJBd+udhlNnsTKYxCIJZZq+5NlPR29cn?=
 =?us-ascii?Q?rb+FWGxoF3bwmPt//uqB46MZmETLWyri08QK3GfzautDCbbTxQlnK6giVImJ?=
 =?us-ascii?Q?ZdT6djPePpE1sGYFZDtvZyb3ExPxPiVX1FkZmO1axk1qmIt7YUAxTt6PrIQW?=
 =?us-ascii?Q?nAtaD6NFQ9QdSxf+aVqmP+M1BaUsBtq7CNTM+SnzYunFgJ8jk/1Zn1mtC/1U?=
 =?us-ascii?Q?04661mQUE1HKe4BeuQoJZfhSLM2xZtuHQiM/XsGFmpJcz82YtEPKYu7TN1e+?=
 =?us-ascii?Q?1wq/i3HbvldzfcGJDQ6eEGdXU88o2zQD0LNRXlzWUYjwbag26AaA3n7qE0rz?=
 =?us-ascii?Q?/FVKqLHzupy5ebpu6vuRrOV/vdO7CCQIYYjXTqbto1nYGoY3jA0kcxHPFw0d?=
 =?us-ascii?Q?5DaJmC6e7VpquTHsWbenANGWDK20DSMWbiSnhvbWBowXDYS/P9g1FAsugfxa?=
 =?us-ascii?Q?3qJxM5MB4z/y3hx+YRq8x61Fc5psT3uo4teCepjXUZGcKL/sRkpQ5jyqLxG1?=
 =?us-ascii?Q?b9ulCrZG813sTNX/6sG9629PjuTeAkwoP08gaNunA9QOX6pIQuTE0Uy7f+3n?=
 =?us-ascii?Q?ePB4YSLK5CgjYiNvaxTW4OrrtExxz8qiRN+Bw06GZkPp6n+FQlkZBBcmNd4h?=
 =?us-ascii?Q?hUGm2nU3MXllinlABIUFrrzpsmIuyjBVGyhcoXYO7PMwtyBdiEAV4Kmd3N74?=
 =?us-ascii?Q?NXrCg0LfJMBXTk9sOwGzQNov3YcqWSOzdPOG0eF+qjv4CTDL3UHMBQjTterB?=
 =?us-ascii?Q?M0nRc/EcdU7vK+UI8pDgSA3HL/rGD/MU5RgFBIkY6zKYa1Gw5br2juIoYbJN?=
 =?us-ascii?Q?SPFE730PFEsSmSeNAjq1TjUvopPgiSix8u2Gdns6x7P5he3vcNhpGGWbbBZl?=
 =?us-ascii?Q?BYV8VCsNaRa+Co2d1rdWveQG8cAXduJXRxygJk48BDro1i5bgbtRmXyWN5fi?=
 =?us-ascii?Q?/E1hNtqb+KI89wECvzZE9V353oIB+/8PzWRqrBfhGGIOwlv4qti/EIJnsp6K?=
 =?us-ascii?Q?1+s6BBThx3DDDpNof+iuRV/ExA=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2020 06:47:36.0853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 1726e709-25e4-4f1d-c16e-08d8ad57f553
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hArWWwiVn5PPqtDpodNbc5AhGj50GKjSkYT5PRiirNUbeWjWstAEQADWOJEGjdou
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4118
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-31_01:2020-12-30,2020-12-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 clxscore=1011 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012310036
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 02:22:41PM -0800, Song Liu wrote:
> On Thu, Dec 17, 2020 at 9:24 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > When we attach a bpf program to cgroup/getsockopt any other getsockopt()
> > syscall starts incurring kzalloc/kfree cost. While, in general, it's
> > not an issue, sometimes it is, like in the case of TCP_ZEROCOPY_RECEIVE.
> > TCP_ZEROCOPY_RECEIVE (ab)uses getsockopt system call to implement
> > fastpath for incoming TCP, we don't want to have extra allocations in
> > there.
> >
> > Let add a small buffer on the stack and use it for small (majority)
> > {s,g}etsockopt values. I've started with 128 bytes to cover
> > the options we care about (TCP_ZEROCOPY_RECEIVE which is 32 bytes
> > currently, with some planned extension to 64 + some headroom
> > for the future).
> 
> I don't really know the rule of thumb, but 128 bytes on stack feels too big to
> me. I would like to hear others' opinions on this. Can we solve the problem
> with some other mechanisms, e.g. a mempool?
It seems the do_tcp_getsockopt() is also having "struct tcp_zerocopy_receive"
in the stack.  I think the buf here is also mimicking
"struct tcp_zerocopy_receive", so should not cause any
new problem.

However, "struct tcp_zerocopy_receive" is only 40 bytes now.  I think it
is better to have a smaller buf for now and increase it later when the
the future needs in "struct tcp_zerocopy_receive" is also upstreamed.
