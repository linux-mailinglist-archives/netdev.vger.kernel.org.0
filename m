Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D1D352025
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbhDATvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:51:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5870 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234062AbhDATvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 15:51:50 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 131JThIw007982;
        Thu, 1 Apr 2021 12:51:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=KxcJMFF5qdjEM1saz985HoJNgm/CjzKVZpGFlgjEDs4=;
 b=G9SLm7BqxNzYmDFYiENe3USzgAB1wgs6gB0kgn3TQ1oG05zVhd8QkqCr2/IbCZ30N3aw
 lpcp0XpkhsUGhGq3TV4imPFH1otMfJmSWxnsaEizi6K2IJUJ6l5ui2f/wRy0QstLtyur
 vgntbLZbQCiLTMEWD8vtdjfQacZTuIZe69k= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37n28161p7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 01 Apr 2021 12:51:36 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Apr 2021 12:51:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8rpOsjcEygVPLY+AQez6QyHWgB71pbZ//xaJ42vuyeH5Q3Gviod0nMOGrHWoHD8oFZZwaQPZyxmZzsGBO5sASXyhCYPBqJQef79lpEFcXrYkNvts/lFmMwWoA/b9gpllVX1TPKt5hNoNBSXupNuVKHhud0DZJb6ij1lEZOBk6ybXAfCqhExVkHaKFCKESV6otCfrY3f67QLbLEPDuosu8q1YTQqphv8dt9aLnNHX2dWFtXmAclErQhrv/s3UMljwRN3dZUDVLzi+uXn/AYQjE2tCVW51vJoNbJDTex12acvtZpeXdRkMZRViN10DIlDT6QngCOSh1EKhZcaXW+X5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KxcJMFF5qdjEM1saz985HoJNgm/CjzKVZpGFlgjEDs4=;
 b=MHxnOaE4YV0HI5z/zdyGb3gHKXHjsSfErfQNJr1dsy4X2pamBJHI/hfBq0Gl4tT+IKWucU5XRa18lV0LgrbT2VeL1eqBkqy++1tF29h34EW/Ng4LBvkEv3yV8U6FHsvIY4yPPihp7zspdHeiN+f95RaO8zIqqXm9GNg59VKhKDUgSt+HBBrLppqjpHNlOU0y3GbQtUw1dUYy4pJqlXOc68yidFgl1hNrOrMtRlOB7R8JZxpLlZupVR7VMDmwicOclawug5SM0JCZyuzytHDyVlUJ9Q4354Al0Qfen14xToUo40msDBrIDVcKtzb9zrB5piUfBgG8FxjKNm6jQlRpdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2695.namprd15.prod.outlook.com (2603:10b6:a03:150::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 1 Apr
 2021 19:51:30 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.3999.028; Thu, 1 Apr 2021
 19:51:30 +0000
Date:   Thu, 1 Apr 2021 12:51:26 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Lorenz Bauer <lmb@cloudflare.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 00/14] bpf: Support calling kernel function
Message-ID: <20210401195126.uohtumhvd6fxig5c@kafai-mbp.dhcp.thefacebook.com>
References: <20210325015124.1543397-1-kafai@fb.com>
 <CAM_iQpWGn000YOmF2x6Cm0FqCOSq0yUjc_+Up+Ek3r6NrBW3mw@mail.gmail.com>
 <CAADnVQKAXsEzsEkxhUG=79V+gAJbv=-Wuh_oJngjs54g1xGW7Q@mail.gmail.com>
 <CAM_iQpU7y+YE9wbqFZK30o4A+Gmm9jMLgqPqOw6SCDP8mHibTQ@mail.gmail.com>
 <CAADnVQJoeEqZK8eWfCi-BkHY4rSzaPuXYVEFvR75Ecdbt+oGgA@mail.gmail.com>
 <CAM_iQpUTFs_60vkS6LTRr5VBt8yTHiSgaHoKrtt4GGDe4tCcew@mail.gmail.com>
 <20210329012437.somtubekt2dqzz3x@kafai-mbp.dhcp.thefacebook.com>
 <CACAyw99gXvpnCwkz4vniABV5OQ29BE2K2iJY0tB898Fd9_8h6Q@mail.gmail.com>
 <20210329190851.2vy4yfrbfgiypxuz@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzY+6TspHiTH5Y7w5itCeHv9qe4Hg8sB-yBJK6kYXYoonA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEf4BzY+6TspHiTH5Y7w5itCeHv9qe4Hg8sB-yBJK6kYXYoonA@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:1daf]
X-ClientProxiedBy: MW4PR04CA0102.namprd04.prod.outlook.com
 (2603:10b6:303:83::17) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:1daf) by MW4PR04CA0102.namprd04.prod.outlook.com (2603:10b6:303:83::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Thu, 1 Apr 2021 19:51:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 980a792f-ddfc-466e-928b-08d8f5478b47
X-MS-TrafficTypeDiagnostic: BYAPR15MB2695:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2695733A30DF744202A377EDD57B9@BYAPR15MB2695.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aNlbFK2e04ffDD58KjiDiJWROkcprOmQ83XaN7iI8rSzB5l7dUTDugE7O8PTY99ZLDo1LCltyNQd9JcNslpLiiAuAxgaOtC7YaV5Ko1QW2NYQM+U6wgTgclJFceK/eEx4uYpC76RkqynBVKPfhAEkLJY1Zwnq0gCanbfPCOrjxS5TL0DIyuAKS2TkR0qPCd1gjmaojaTeyK63Nbqyj4LKhzIN3Hn6M3AsOQnfambkki4DQwO6Kwp433nogV/FmzFBb7ru+XvSnwSDmMLdl9OOTEhDKcbzF4XzqW19Sgb7SdJ4pf8+iSxSVzCutOexCqMBlQ01XdBW1HEjeF0zx2Ug3mrvQj6EuVGDJVx/TYkeBEdhZkGBQ8e85DapXfdXUkjRZy6IvJL7QzH07tnuBNznxjhP0nocRwfMr7NeHytNrTKw/BGBZXjFOpsHfCL1hXd0qgZYM1BdYQcC8Y+ICcL9wZ4tE8x/RY7A7/rfQtD2IndCwKN+kjRX6VLjq2WwwfA2Gkft2ZCFRwBER1Z9SVuLI8IGU4i6zXXI8/7csdaB4H9ubTaQyzkIgioYmRmfVcnXJHI64Rfd0FbSd0UjSsyXds/Om7JGtxXFQnQhaAtYNOMrP/ZRQXr00br0eaTxof1AjqimhoyfvaTaO+wsIh/0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(366004)(376002)(346002)(4326008)(1076003)(5660300002)(9686003)(38100700001)(7696005)(52116002)(6506007)(2906002)(478600001)(66946007)(8936002)(54906003)(6916009)(6666004)(8676002)(316002)(86362001)(16526019)(83380400001)(186003)(66476007)(53546011)(66556008)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lDW3lp7YX0xnvekaFlbR6xvUOcA91RAK5vvDCLHxHRAWzivRDG1E4QnwJfvB?=
 =?us-ascii?Q?d12KUY+RPkCY/KGL+aZGeZbu1sCIZawY6j9oWzre3lVrPL2YTRkrCCkCpUj0?=
 =?us-ascii?Q?7oX/fGxNW7SnNKuL/pnHfISwR67NoZBg+30FhV+PB8vFiMS1ZgsVWkgXm9wv?=
 =?us-ascii?Q?9bQ4CncTfS7m7ZMNSbO/I6g9ziXpnZcLQgT1tARkZjYh2JF24/FKcHIAAvsY?=
 =?us-ascii?Q?njtpFe4BD+AnQP9feQT/B5EA5iCeKutJGqCUouFwrn2jyR057cyRbeqE7kdS?=
 =?us-ascii?Q?VLfOZunhyB49M8glu/jhXWznX1XxTYrYw5/0sykXat+WRHwQjHp7bMnMuTFO?=
 =?us-ascii?Q?CGHcM0Khc6ZtuKPOai/iDi/uSOF/gSMEDsX8e5M8rCMsbiqvm5fgdbPYfa+0?=
 =?us-ascii?Q?3OYBvRLdYkgmFgmezo5A4SJQ+uNsTMBEs9Q1LDdnNIA7pJRSJxImiuyDcToB?=
 =?us-ascii?Q?WTxA5B5nltNJTJDzKy6gLHGIqZD0izeQGDkrMkmQUNUQmEWzk0bNVR8VMpyu?=
 =?us-ascii?Q?Kt+sxW9mPdFn0Iyw6vIBI1CvAiVst5UmgRhOdoH+cxBG5lJ+3XH+vjZfMCjE?=
 =?us-ascii?Q?aSUlFpa9+bfMoUc4hbsvxqdLKpYXtM0cFoBCEPJXSa1irfx9/TqFwjvnxqU5?=
 =?us-ascii?Q?mk9OdWtkK8ADxt4LXrutBEfifZTgZylQtWU1hsRxj2GjmI99YSicP/h6vzG/?=
 =?us-ascii?Q?WxFMgjQuALermiyoY5cVQVKoR8mZ41nwZuXvSTCVW7vj68CZSh/qDVzKVSfP?=
 =?us-ascii?Q?Vpq7lbAmGuhmxGGGtG4sevhz6PVQst45rDfH5/dK4G0AWM8Q2/rsS2B108zL?=
 =?us-ascii?Q?0iKeInsoX9pPIRgScVVbvbynEHyWOIvAMW3QsnD/Pio+DBAXEbWUhXuHSqoE?=
 =?us-ascii?Q?rWfUWuE/Y8Rc6WDX58AfdtsE8dM5O9ROkfXlgXCRsyPTaeqK49GplHPjw4D8?=
 =?us-ascii?Q?2rzkoMFvNUrrpCNFmG8GtDGS0IYBA0oMwF5SEyP/v82YhMsIF1YvPuY9Tulu?=
 =?us-ascii?Q?z6TDOa8nFcQg6lclSnMAceAP5//G8J4b2UV7J8di0mQbswtXg7KvsDQqbhuG?=
 =?us-ascii?Q?m5vPWDVXJhCmyUyItdx1jsFzhytb1/nGDoyV02xNrhdSYSRXwupfFLvCoIty?=
 =?us-ascii?Q?C6WSrnN0xRHwfIElTTEWiCTOhRWV7ozai6RE115x7Uh9nNk8vbKIFHEj4FdZ?=
 =?us-ascii?Q?bs51YxBBGwE1s4jeMVM0pm+gDWJcHG8/T63y2YLtc6FGd44rJtH1VcGd+roP?=
 =?us-ascii?Q?95x6VDUCDu6QeJhwm+JwsVTsKcUrjbENCL5Q+6qPdxE/SVfvpoP4WYzk9GgO?=
 =?us-ascii?Q?rDyMd+4j8w1tYJQ7g11QaxlcUXFfMD7eqvVk7N/4MAO1Sg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 980a792f-ddfc-466e-928b-08d8f5478b47
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 19:51:30.3590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sh5WRmV9AYcaZNdaebKEJ56pNUoR6RNjqZHClr2KQcXec4YdnlyiaaGXXgFGnKdn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2695
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: PeSMKKYz3gf2CVLgAi2RoTP3HCVy-o5w
X-Proofpoint-ORIG-GUID: PeSMKKYz3gf2CVLgAi2RoTP3HCVy-o5w
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-01_10:2021-04-01,2021-04-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 impostorscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104010126
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 11:44:39PM -0700, Andrii Nakryiko wrote:
> On Mon, Mar 29, 2021 at 12:11 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Mon, Mar 29, 2021 at 05:06:26PM +0100, Lorenz Bauer wrote:
> > > On Mon, 29 Mar 2021 at 02:25, Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > > > >
> > > > > > > # pahole --version
> > > > > > > v1.17
> > > > > >
> > > > > > That is the most likely reason.
> > > > > > In lib/Kconfig.debug
> > > > > > we have pahole >= 1.19 requirement for BTF in modules.
> > > > > > Though your config has CUBIC=y I suspect something odd goes on.
> > > > > > Could you please try the latest pahole 1.20 ?
> > > > >
> > > > > Sure, I will give it a try tomorrow, I am not in control of the CI I ran.
> > > > Could you also check the CONFIG_DYNAMIC_FTRACE and also try 'y' if it
> > > > is not set?
> > >
> > > I hit the same problem on newer pahole:
> > >
> > > $ pahole --version
> > > v1.20
> > >
> > > CONFIG_DYNAMIC_FTRACE=y resolves the issue.
> > Thanks for checking.
> >
> > pahole only generates the btf_id for external function
> > and ftrace-able function.  Some functions in the bpf_tcp_ca_kfunc_ids list
> > are static (e.g. cubictcp_init), so it fails during resolve_btfids.
> >
> > I will post a patch to limit the bpf_tcp_ca_kfunc_ids list
> > to CONFIG_DYNAMIC_FTRACE.  I will address the pahole
> > generation in a followup and then remove this
> > CONFIG_DYNAMIC_FTRACE limitation.
> 
> We should still probably add CONFIG_DYNAMIC_FTRACE=y to selftests/bpf/config?
I thought the tracing tests have been requiring this already.  Together with
the new kfunc call, it may be good to make it explicit in selftests/bpf/config.
I can post a diff.
