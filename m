Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117D72CE7E0
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 06:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgLDF6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 00:58:05 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50748 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725550AbgLDF6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 00:58:05 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B45oVnr005680;
        Thu, 3 Dec 2020 21:57:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=k1Q9BtrYz+V+t4BIH7AIHf0VSJRVSWOZE1vcxFn15rs=;
 b=MDqFUeKf9zoVyUZwn1037bM7dl2liOy8Ky9OVhOanyOFodfQmWtA1EXIhrAKwi4e2a5j
 BRK8wkYjawyWAQyP9P22IRuaXkvTN7Y/hbdW3WeJFqUStO9JxVtQfh6JtUlItCGAAD9/
 U58ui7//LEfoxECJa/NgLxoJxQeFhrsmWVA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 357159x4pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 03 Dec 2020 21:57:03 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 21:57:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PsnfOQGH9sWzBsKAwgFzHSDlO7PpowUar7TlLEZnUazwOOU4ba/iZJL6sWK3bZGqfJm9lHTjhhvag3VDXMylWTHb76OF4nAqA+DDJpHH1YgYHhqBeYe554m1d2mgd+la5PYYueU4vwMB8QYIs26H7ZQo+z/IbKwxan33uJWNkINuwpnG3Erqx2uqMjnBW8Aw7I9quAtYv8EPnRHIn6HoEEEQWSWSLlkHfnP+hrzkrJa40/LjpjvmbbMT88UbVutxvT20+FLkILAvHDEOe2Ez1jTxFx9Ln537dOHgzJmZnQ7/AxaFT3H93XeCHPfdPlXTjfHrQPUN6iUPCPisvZRF6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1Q9BtrYz+V+t4BIH7AIHf0VSJRVSWOZE1vcxFn15rs=;
 b=U6DYAZlOX5L0flofQTDVVnG6dVGqbiV+nWm29Gn9DvNyOZFT7FeviAcqJMF8qfcSM8vEMt8dsu7mwK395kojZpp9D/SBR0qv50+687cJtVBtWV9xDOsIHnIbghHWTtdB4d+umFDmzq11DcxRwJrlGe9/7sF0yOG3IybCByl7ZAGGi4BEfC5m4SDBZiI6bH5SEnL4qWrdfsm1RnHzS0f/eJerb8CX84qvi2Jic7+BY7IfEzq+fLXsHE0QHTk0nc/ZUQw3ZlshTXEl3DEn8XoX+XrDzzOAH5kdlFPSRD4KsV7EISUfKCqlPnd5nS9SR6e07od4kQ1vLT/YNAzoBLkXBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1Q9BtrYz+V+t4BIH7AIHf0VSJRVSWOZE1vcxFn15rs=;
 b=JmFretGUPXz7j+nHC+j4GEq4z2qE2rAYssxdbd88nRecWV1hUHgVjFtdu+NOwO4n3BDPo29Y/IvPnB9WlOTmd0a6kkRBB8MrdA8l4kMLgIySumetr4c0hmARVvb6J9E7KY/AzIFbTGsSXN+6yrnmPBTKnt1Px/qfFFgsn1AsIOA=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3367.namprd15.prod.outlook.com (2603:10b6:a03:105::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.31; Fri, 4 Dec
 2020 05:57:01 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b%7]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 05:57:01 +0000
Date:   Thu, 3 Dec 2020 21:56:53 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <andrii.nakryiko@gmail.com>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 06/11] bpf: Introduce two attach types for
 BPF_PROG_TYPE_SK_REUSEPORT.
Message-ID: <20201204055226.c6abex2dmperhgx5@kafai-mbp.dhcp.thefacebook.com>
References: <20201203042402.6cskdlit5f3mw4ru@kafai-mbp.dhcp.thefacebook.com>
 <20201203141608.53206-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203141608.53206-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:fef]
X-ClientProxiedBy: MWHPR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:300:117::21) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:fef) by MWHPR03CA0011.namprd03.prod.outlook.com (2603:10b6:300:117::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18 via Frontend Transport; Fri, 4 Dec 2020 05:56:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84aab176-607c-443c-4425-08d898196adf
X-MS-TrafficTypeDiagnostic: BYAPR15MB3367:
X-Microsoft-Antispam-PRVS: <BYAPR15MB336737B29C981AECF39A81B0D5F10@BYAPR15MB3367.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rMdFI0yALVjAhMhSrljgw0TzyDB560fQOJtF5xUZsZrNwMX6T1EZL+sWIIwoQOpMu3PMeZE1T2/1bvdor5r1qADJYAQIhGHjlXJieC0ctcjMBe8IYUz6/GE92t1M3kv2MAOrmFm0Wio0cZQgfWYjTuH8sao0aB5s04AxSPzvwjjQiuLeV6ykXBSO7rh4qKEef9nQWynkK70hm53glxMBbMY7L2TaNarGMBn0HP7NaaK+WpNr/8awvTwgQIZae3jLlW7l2fAwXxoz4ZcJypSl+UXzAcJwLAXvl+WYfJUiEu9H6rUKiJUJu1oObteSHYLBZGIps7kUJT5sD9DsuPqAbxgvk5BNDH1vG9i+kZ0WTsuutEz5tX/PehVGm83fLo1A6Mx8STxweG2/Ug0jvSYJxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(136003)(366004)(396003)(8936002)(53546011)(6506007)(6916009)(66476007)(1076003)(66556008)(2906002)(478600001)(66946007)(316002)(7416002)(83380400001)(55016002)(86362001)(4326008)(8676002)(6666004)(16526019)(52116002)(186003)(966005)(5660300002)(7696005)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?O6iQusSAtolJ8X4UljHYUvVGMj+aS4BD6nE/41gacpK5+08QR2JzZSi+p7f7?=
 =?us-ascii?Q?1zS2oYzO+KPG5T3RzYIun69aLGgrwU/j+ZPoB/7+C0Sf/55ux/SQAItnAM8i?=
 =?us-ascii?Q?NNPgcpMvPIj6jQ7kEbSTGQxS3migJBme4uzsFLd91FIF5nH+vOG0Nl7k20XM?=
 =?us-ascii?Q?Qu2HQUAtQq5ee37EufhOK1WNzQbcG4dtfFMQ20kskbyjxG1IfYTeN6T2iB0r?=
 =?us-ascii?Q?VQXTynbLfrBPnx4ByhGQMVVPhbU25C5rnHqvzGvhENJNvRQus7I3bkUrwMkF?=
 =?us-ascii?Q?YKlcYN+dUqxkQuaoVjPRbr/tQlQYANx+iwiIM/JFlR3D9llh0BLsIs2OGLqP?=
 =?us-ascii?Q?MRwujPku4EmDBYJC4wt6e8WuCiNN4bBH6LxpmwQksm3cASHkBF/vexNu1A9p?=
 =?us-ascii?Q?LVDX5kGM/9b/Z7/mZcFd0hadudY5AAUOcffNXj77W/lflewSIkPcbP+UpJdt?=
 =?us-ascii?Q?uT7UK1S6qjZ8b6cPbBJ0JPqccn9f8rm2mWMM9AjyUkohapx0Y6Fu2kWoORON?=
 =?us-ascii?Q?zqhQGsj1b+f5uJor1OVWosbCFi5XUESSEMN4egxCPA+M1UGLfTisqA/PNmUT?=
 =?us-ascii?Q?V9HKF+gZVB/FU9qKCoiT+0mKsIIbuwfIVZ61agAY5xLcZqvRJYsXWqBhiKAM?=
 =?us-ascii?Q?5TTC2lkKS6Oo0Tw0NrfJeiBR3RlQixv3wNk6o5buSFx6GemZ9m63AM/a8AWS?=
 =?us-ascii?Q?j/9ja6tPOswpmwJSqsX1kn2dboWC6Y6gTlofUTI/ymKJhcDKhPhiRCWAU0Ly?=
 =?us-ascii?Q?tmcoi+UDcMNFRQ1YYhY2uG77VooOtwA9JpKdQ6WfTReFEcF1TXvsDQu5DtqK?=
 =?us-ascii?Q?THQ42FUny3XheiV9i94rFasqOSN8oTHs0sN2Y7jiVChdGoeDwLYR5fJHEzAZ?=
 =?us-ascii?Q?+6GsLHio3hrPZmoylABrcKZOrqvPRNQzzDhvMgYJu3N1HJ+jGH13eLD6PAi+?=
 =?us-ascii?Q?eXs4DBVcQW0r7r75AYx2IeQdR4y+8d33ABmyJqMFOQ10W+cqmDQ46a9SrWT+?=
 =?us-ascii?Q?qdki5+4MSUXNKg6QjmJuwFNvGw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 84aab176-607c-443c-4425-08d898196adf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 05:57:01.0434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Piw40zLXBdSa3wTb/UDZDQJJ90Lg7wylTeiCzrBtP55NreSvEf7OzsXKe4qg+bKA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3367
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_01:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 suspectscore=0
 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012040033
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 11:16:08PM +0900, Kuniyuki Iwashima wrote:
> From:   Martin KaFai Lau <kafai@fb.com>
> Date:   Wed, 2 Dec 2020 20:24:02 -0800
> > On Wed, Dec 02, 2020 at 11:19:02AM -0800, Martin KaFai Lau wrote:
> > > On Tue, Dec 01, 2020 at 06:04:50PM -0800, Andrii Nakryiko wrote:
> > > > On Tue, Dec 1, 2020 at 6:49 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > > > >
> > > > > This commit adds new bpf_attach_type for BPF_PROG_TYPE_SK_REUSEPORT to
> > > > > check if the attached eBPF program is capable of migrating sockets.
> > > > >
> > > > > When the eBPF program is attached, the kernel runs it for socket migration
> > > > > only if the expected_attach_type is BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
> > > > > The kernel will change the behaviour depending on the returned value:
> > > > >
> > > > >   - SK_PASS with selected_sk, select it as a new listener
> > > > >   - SK_PASS with selected_sk NULL, fall back to the random selection
> > > > >   - SK_DROP, cancel the migration
> > > > >
> > > > > Link: https://lore.kernel.org/netdev/20201123003828.xjpjdtk4ygl6tg6h@kafai-mbp.dhcp.thefacebook.com/
> > > > > Suggested-by: Martin KaFai Lau <kafai@fb.com>
> > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > > > ---
> > > > >  include/uapi/linux/bpf.h       | 2 ++
> > > > >  kernel/bpf/syscall.c           | 8 ++++++++
> > > > >  tools/include/uapi/linux/bpf.h | 2 ++
> > > > >  3 files changed, 12 insertions(+)
> > > > >
> > > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > > index 85278deff439..cfc207ae7782 100644
> > > > > --- a/include/uapi/linux/bpf.h
> > > > > +++ b/include/uapi/linux/bpf.h
> > > > > @@ -241,6 +241,8 @@ enum bpf_attach_type {
> > > > >         BPF_XDP_CPUMAP,
> > > > >         BPF_SK_LOOKUP,
> > > > >         BPF_XDP,
> > > > > +       BPF_SK_REUSEPORT_SELECT,
> > > > > +       BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
> > > > >         __MAX_BPF_ATTACH_TYPE
> > > > >  };
> > > > >
> > > > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > > > index f3fe9f53f93c..a0796a8de5ea 100644
> > > > > --- a/kernel/bpf/syscall.c
> > > > > +++ b/kernel/bpf/syscall.c
> > > > > @@ -2036,6 +2036,14 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
> > > > >                 if (expected_attach_type == BPF_SK_LOOKUP)
> > > > >                         return 0;
> > > > >                 return -EINVAL;
> > > > > +       case BPF_PROG_TYPE_SK_REUSEPORT:
> > > > > +               switch (expected_attach_type) {
> > > > > +               case BPF_SK_REUSEPORT_SELECT:
> > > > > +               case BPF_SK_REUSEPORT_SELECT_OR_MIGRATE:
> > > > > +                       return 0;
> > > > > +               default:
> > > > > +                       return -EINVAL;
> > > > > +               }
> > > > 
> > > > this is a kernel regression, previously expected_attach_type wasn't
> > > > enforced, so user-space could have provided any number without an
> > > > error.
> > > I also think this change alone will break things like when the usual
> > > attr->expected_attach_type == 0 case.  At least changes is needed in
> > > bpf_prog_load_fixup_attach_type() which is also handling a
> > > similar situation for BPF_PROG_TYPE_CGROUP_SOCK.
> > > 
> > > I now think there is no need to expose new bpf_attach_type to the UAPI.
> > > Since the prog->expected_attach_type is not used, it can be cleared at load time
> > > and then only set to BPF_SK_REUSEPORT_SELECT_OR_MIGRATE (probably defined
> > > internally at filter.[c|h]) in the is_valid_access() when "migration"
> > > is accessed.  When "migration" is accessed, the bpf prog can handle
> > > migration (and the original not-migration) case.
> > Scrap this internal only BPF_SK_REUSEPORT_SELECT_OR_MIGRATE idea.
> > I think there will be cases that bpf prog wants to do both
> > without accessing any field from sk_reuseport_md.
> > 
> > Lets go back to the discussion on using a similar
> > idea as BPF_PROG_TYPE_CGROUP_SOCK in bpf_prog_load_fixup_attach_type().
> > I am not aware there is loader setting a random number
> > in expected_attach_type, so the chance of breaking
> > is very low.  There was a similar discussion earlier [0].
> > 
> > [0]: https://lore.kernel.org/netdev/20200126045443.f47dzxdglazzchfm@ast-mbp/
> 
> Thank you for the idea and reference.
> 
> I will remove the change in bpf_prog_load_check_attach() and set the
> default value (BPF_SK_REUSEPORT_SELECT) in bpf_prog_load_fixup_attach_type()
> for backward compatibility if expected_attach_type is 0.
check_attach_type() can be kept.  You can refer to
commit aac3fc320d94 for a similar situation.
