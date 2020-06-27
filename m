Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8137420BD69
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 02:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgF0AX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 20:23:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52992 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726028AbgF0AX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 20:23:26 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05R0BvaB030032;
        Fri, 26 Jun 2020 17:23:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=j/QXauqZH3sjd6gN5LrxZ1QZyjK4f2cVajGCcqYhhE0=;
 b=IUeBbPBXl4PLkN/o2BOuDM9hYhsV+M55NQPr3n/eWsULMbxHaE7Vu55sAxI62Olk2hnY
 i9jGuc61eX4y22x5IbkG2qob6iy9waIy8tlwDxyRPhLTiGinaLqLqk9I7houX0d8LVKQ
 Pl9yZBSZ7yqvjHIP3Pf/7nHhYUpQpdZ5C24= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31wh6ktyvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 26 Jun 2020 17:23:07 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 17:23:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4kyflCgD9x055Wv0Ph3MeAk2ryblwNBxs6ojaIEGZPnRvC0rhivRT3T14tA6E4AVOcEnLysacYOuC3WHXmgoPsIkgVgbSc9vANFNeHNIzjBR/E/6bseJJTXBIiG85nOWNK9MArMX7H/+lz2efCj7qBj/lnajs8GEDALll5Cedgf4ws73gZk9yxtsjvE9wdemKMYVdK95lFM5qlidGnp1WuA7+pjJdPpxvjtf/ouIAQADD25q0uvp2qRbuv8lpxItB9cIsaLC/2V7VnnQZDDIaCG5N1PRUGTqg3t2gPdatyoQFrDzd3SaraL/Hah7NWGYZUKmZ8xH/juQFmfm1MU9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/QXauqZH3sjd6gN5LrxZ1QZyjK4f2cVajGCcqYhhE0=;
 b=fyoNueOas//VqP4/O40n5XYjpkLAmSQxnQ4KiHj6L/obpwbBClfjcTKa9+gxyuSFhtjAr4mQmgs6W42d/4GOMthcYnJoT4FtZEUleQPO9eaaDYUuOjDv6vsPY6OkEwDlwzMUgX66SjAGR/83hpdGGdHd87WrQk3pTG+L7bwAwZCGEIGWMccZFSwpGnn72uI/ToRCOuz6WKDlK3kOnSaWkT9wAHKUOw76hg9tdyfAgVWCgUv3M5FtU0Nh86ahw2hL/QAF9ZhbeDeLxT86aVwSUC6cRkhDe0MuqtgsgxjOiInJylIRY08qWqoobrSg5cZluPrwSsClXGriECKAifC3ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/QXauqZH3sjd6gN5LrxZ1QZyjK4f2cVajGCcqYhhE0=;
 b=hrSUb6HmCcVTv159LCGSSIZkfoXDdGLiuTFw7lBPuudJ9stHIHt20v8j1Mknk+SAJePqvuZGs4UPiiChfHnHb/IjTHalKSKED9jLYXOZMW4MYMYso8f3Eej3PZPBlrfVWKdFH3+jUk9R4TdiXmb29xdBG/65NlBYvc4xJvmo+mU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB3580.namprd15.prod.outlook.com (2603:10b6:5:1f9::10)
 by DM6PR15MB2234.namprd15.prod.outlook.com (2603:10b6:5:89::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Sat, 27 Jun
 2020 00:23:05 +0000
Received: from DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::c8f5:16eb:3f57:b3dc]) by DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::c8f5:16eb:3f57:b3dc%5]) with mapi id 15.20.3131.021; Sat, 27 Jun 2020
 00:23:04 +0000
Date:   Fri, 26 Jun 2020 17:23:02 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        Networking <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH bpf-next 07/10] bpf: selftests: Restore netns after each
 test
Message-ID: <20200627002302.3tqklvjxxuetjoxr@kafai-mbp.dhcp.thefacebook.com>
References: <20200626175501.1459961-1-kafai@fb.com>
 <20200626175545.1462191-1-kafai@fb.com>
 <CAEf4BzZ3Jb296zJ7bfsntk7v5fkynrBcKncGQgrSHJ2zqifgsA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ3Jb296zJ7bfsntk7v5fkynrBcKncGQgrSHJ2zqifgsA@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR01CA0002.prod.exchangelabs.com (2603:10b6:a02:80::15)
 To DM6PR15MB3580.namprd15.prod.outlook.com (2603:10b6:5:1f9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:9ad7) by BYAPR01CA0002.prod.exchangelabs.com (2603:10b6:a02:80::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Sat, 27 Jun 2020 00:23:03 +0000
X-Originating-IP: [2620:10d:c090:400::5:9ad7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed29d2a0-42e7-4df2-c12b-08d81a304238
X-MS-TrafficTypeDiagnostic: DM6PR15MB2234:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB2234B92462915C9BB6DDA3B7D5900@DM6PR15MB2234.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0447DB1C71
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tbY03kThD+zXlmJJSqL9kSd+H/NULlaZreypSsXqR2C0loFIS2KPUXFm4xQzzY4S6QNlyNUgDrYceCjTytaLK6ZcoqtShHqclZ3dc9nJWMnONLqNMuC+Mo6vBl17gCSYnllK94N9AH/Wb9puUlFIFe9VyjUymoCaJhUZWfEdqI8FB+cplrbwJMU3iSS5MmUDM7JLaU/lqUCbsI/Vf/xb6f7gSrqUctBjFtRpvYSubOTroD4CdMFRWzWtXwZ66NGa+eEYeM2TtBwrj81olu5TiUdwQVcxhlymOLpvcvvaga+5+VT9kyAyO+9l7qsNMs5TZbh1kKn4J3erwCjEJ2Fxjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3580.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(39860400002)(346002)(396003)(366004)(478600001)(86362001)(9686003)(8936002)(2906002)(1076003)(54906003)(55016002)(7696005)(8676002)(52116002)(66556008)(6506007)(316002)(66476007)(186003)(16526019)(53546011)(66946007)(83380400001)(6916009)(4326008)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 3E9Tl5OJCKwF2IIsQTC890+nJX9Ve0RPiCuxWjIYDrfWlDVh21td9/fLyvyHaIdnc64F3ISZ8loIB8wNu0fRurRjpzXmIuEcYbdWKBvziqS125MXwaCCx6BXv1JrHmPq6ISa8z369+VgbysBqJ/nObRR5h/bVVYSCnz4iKzL2/zy7cLkZljPTYodltMrn2B5zIUeRaLT6M478po5QZaUQWH6Vh2mTEOVeL+qHF7oibmAfDYmXahxShxhQxe9T4nI2oLzoO4B0Tky3Fs6ftojlp5bBxKs2H5bbgE3D2VStgYJeJER2/mWLvU44g/AnzKVaOgS4dF3oJ9v3MA/ifBaxWPMh783bHcPglltECokAXJbGw4AURBgwin6DhSz5J/jGodVS4/p598U02nLLLSRitfHnBzcw0iBA1tyBXFkdbrDPmDrISEu9wWkDQR0FSMb/8lOEUQL0mqA4370cl4xOSXCJD6a4aCc24XP0lB40Ngotxsuctkdux2VAp+yW+pIv2Z0BDJHzgRjbR/+SsYgaA==
X-MS-Exchange-CrossTenant-Network-Message-Id: ed29d2a0-42e7-4df2-c12b-08d81a304238
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB3580.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2020 00:23:04.8241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5RcEb6WkjePNulE3e6rmFmO8NMYpaJYj1uMGaJKE/1wdlOu7+Pk/j7H+qXfiLWNR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2234
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_12:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 cotscore=-2147483648 adultscore=0 mlxlogscore=999 impostorscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 mlxscore=0 clxscore=1015 spamscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006270000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 03:45:04PM -0700, Andrii Nakryiko wrote:
> On Fri, Jun 26, 2020 at 10:56 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > It is common for networking tests creating its netns and making its own
> > setting under this new netns (e.g. changing tcp sysctl).  If the test
> > forgot to restore to the original netns, it would affect the
> > result of other tests.
> >
> > This patch saves the original netns at the beginning and then restores it
> > after every test.  Since the restore "setns()" is not expensive, it does it
> > on all tests without tracking if a test has created a new netns or not.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  tools/testing/selftests/bpf/test_progs.c | 21 +++++++++++++++++++++
> >  tools/testing/selftests/bpf/test_progs.h |  2 ++
> >  2 files changed, 23 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> > index 54fa5fa688ce..b521ce366381 100644
> > --- a/tools/testing/selftests/bpf/test_progs.c
> > +++ b/tools/testing/selftests/bpf/test_progs.c
> > @@ -121,6 +121,24 @@ static void reset_affinity() {
> >         }
> >  }
> >
> > +static void save_netns(void)
> > +{
> > +       env.saved_netns_fd = open("/proc/self/ns/net", O_RDONLY);
> > +       if (env.saved_netns_fd == -1) {
> > +               perror("open(/proc/self/ns/net)");
> > +               exit(-1);
> > +       }
> > +}
> > +
> > +static void restore_netns(void)
> > +{
> > +       if (setns(env.saved_netns_fd, CLONE_NEWNET) == -1) {
> > +               stdio_restore();
> > +               perror("setns(CLONE_NEWNS)");
> > +               exit(-1);
> > +       }
> > +}
> > +
> >  void test__end_subtest()
> >  {
> >         struct prog_test_def *test = env.test;
> > @@ -643,6 +661,7 @@ int main(int argc, char **argv)
> >                 return -1;
> >         }
> >
> > +       save_netns();
> 
> you should probably do this also after each sub-test in test__end_subtest()?
You mean restore_netns()?

It is a tough call.
Some tests may only want to create a netns at the beginning for all the subtests
to use (e.g. sk_assign.c).  restore_netns() after each subtest may catch
tester in surprise that the netns is not in its full control while its
own test is running.

I think an individual test should have managed the netns properly within its
subtests already if it wants a correct test result.  It can unshare at the
beginning of each subtest to get a clean state (e.g. in patch 8).
test_progs.c only ensures a config made by an earlier test does
not affect the following tests.
