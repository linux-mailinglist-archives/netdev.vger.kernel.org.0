Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E98820D20F
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 20:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbgF2SqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:46:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32228 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727972AbgF2SqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:46:08 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05THteKF004317;
        Mon, 29 Jun 2020 11:00:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=rO/841CCW4viLJ1vwuWK+ySgIDLVZDlP4s8QDJjUd+g=;
 b=NPkMmLbSQKPYs53RAWX4ApwNKGAQo1+HmyDvxk0NRslz75VKKX8z/N3yTpmUmRSVUx5X
 a0pkXpC6m11VFNzmIjBehgkmo6dF+B7359l75Il8WpppN1DToVwK7YkfxLLSmMtpZFgL
 SYG1XYyZd2yNE3QgCffGtJMU3byfBaGoa8w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 31yd4p29yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Jun 2020 11:00:43 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 11:00:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ax3gEA1216XIKposoGFL9IRReMLdyKSl/tCNOZFuWHindT7IPBmKRw56RujkvzzSBvIgrKkxO3bik8T6c7bFf2Um2bBtqXpuTTtsMSsVDPnUB3+IJ9ioscHye/IW3uHI8mLl0Lrt9mQ4Ond+RUr7/Wm/SL6Jj5ho6T8KK0lSdGG5/XDzBxc7KjXuwDtZaOSPmJIZIR5sm4C6Bi6g7mrZ2VVft8kYO0bfsuECnrTUCNIM+1g2ELs3dQ+0XwZkC+21JIpmAI/fffvk0i82VSWRDcHGTll6PJzPeJrbyk1k+DQPm5NU4J2krFohBjK9O0s//u75IwGZo7YPde7i8pfKAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rO/841CCW4viLJ1vwuWK+ySgIDLVZDlP4s8QDJjUd+g=;
 b=iZ86o9DYQMO8VQBY0zLC+qqVgB+QxjrFvd+ltuylxlaXKIZlrMDp3s/dNgpNZqXR/B6l/OdX12eJdQ4InR4TCQPkHl1bfrscX2kIlvoojnxPQ0S7LpdwjOQ71rgwZrrEAGEPVnqsFEZ01DMdtPavZza0iuErVr7Xakye1ez+2eQoctqb3coH0fvR9jWc+OZ3M0Mu6KC1Y/E2I8CdiGWQZhBvX7pAvJSCogrsrbW/l/CMcgNrLOlOkT23hmG5UnWADYgV5YedFBGTS2jkNA7iG7f1Zf97jq3DIZIpO+jqVHm8E9/jEqpgM2ugn3+4pQL0epihAYMqAKLUp3F7kbpxQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rO/841CCW4viLJ1vwuWK+ySgIDLVZDlP4s8QDJjUd+g=;
 b=XwjZKVcP+GhhtRSE/nO8KwlnxSx/Wbf9C7gkzD6FluS3kYmFmiLNnGw2eP8QCh6Puz7l7QtWXaRtZqHhNVyVQY40pZXS+LGbp25+pSsbtYJ5K7cf5JpMQVPyv+KjPi+QznZ9jU873NbRHf+DKwPgLBtWI3FOhHAa/mc72FaCS2U=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3640.namprd15.prod.outlook.com (2603:10b6:610:7::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Mon, 29 Jun
 2020 18:00:38 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107%5]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 18:00:38 +0000
Date:   Mon, 29 Jun 2020 11:00:35 -0700
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
Message-ID: <20200629180035.huq42fif7wktfbja@kafai-mbp.dhcp.thefacebook.com>
References: <20200626175501.1459961-1-kafai@fb.com>
 <20200626175545.1462191-1-kafai@fb.com>
 <CAEf4BzZ3Jb296zJ7bfsntk7v5fkynrBcKncGQgrSHJ2zqifgsA@mail.gmail.com>
 <20200627002302.3tqklvjxxuetjoxr@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZevDLp8Hzax3T8XzHLsMm85upCONULVVOEOyAxVGe4dA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZevDLp8Hzax3T8XzHLsMm85upCONULVVOEOyAxVGe4dA@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::15) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:875e) by BYAPR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:e0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.10 via Frontend Transport; Mon, 29 Jun 2020 18:00:37 +0000
X-Originating-IP: [2620:10d:c090:400::5:875e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 476be970-8054-4500-e9db-08d81c56548c
X-MS-TrafficTypeDiagnostic: CH2PR15MB3640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR15MB3640DFA6E1EC9938D1248323D56E0@CH2PR15MB3640.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 044968D9E1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0FXyZunM1QGcmP0VBEOmcUvgRrvu0/SEBi+HiWeEjgcGWbUyy2TobTqLowNDOUNpHZSCd/+Z4fxdsUwada1cfDJUsLIhWXYWVSIlMFNH1/MBqLjbp/3W0sD1Fa9eSl2HvZl/dCk/i6jFlCo0/fYfKmB9lKfSxSYr+O4QlNz4BI4t62h22nV1bz49Fxuy19mf1IvS4/p5aU6vd5col26/cUD2077RaI7RYTVQzZDVV2qKnKbTm62wHAP5bci425JGUCdvelxYb9fBiU8rcRw8xsQF3VdVTipo6r5x+kX5YZxGGXRjCYyi9wXh0ZwvT3oEUXfQaOdU8h7I8KEJNiL2rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(366004)(346002)(376002)(396003)(39860400002)(186003)(16526019)(83380400001)(86362001)(7696005)(52116002)(478600001)(2906002)(6916009)(8676002)(4326008)(66476007)(66946007)(8936002)(53546011)(6506007)(316002)(66556008)(54906003)(9686003)(1076003)(5660300002)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: kq5p1AkrKLnDjIpCYgriF2IFePFwW81svaQwq1EVIU+YWMSr8LbR/DbnJPxPSCj62GlY5djtyWpra3Yf6axGaxiSzcx1SUsrRkYxIpBLVESMwQzTVi/40pKKUtKHDDrp/mKYj9S+S7w6LsFGLN27ovSJmk/mt8An9BeQ1GQn4KUf63DZ2C13okZC/PyEqHOF4s7Bf5iOXZAjlenU68kEPbuggbvIOQz3k+rMkJDP8gSvIEimCpycjyvQ80Xq7s6APUXocgqLLk1R2DXEhGvJ6+BlUszAb8LEme+wxvHwxTz3ZJr6SkosMWDrf5K9DgF4NhqH661fl3jaXHhBjspoBgk4fzKn0n8Qbt1mPUdu/Wk8bt7Zhw33JRJndtag4Bf432VH8/CRfIPxSBiQl4lcyqEvs+G+EjYUU8bpTGRC2ZgMk7nZgeKtPySPCtpFlii/vvUxKMPq/6Yu4Q569uMoXe0dzhz519/A4e0VbLj1XdnmS6t1p5YQtwlUJuKac6G0ZVjmHWBAbCZjILeBWHyMag==
X-MS-Exchange-CrossTenant-Network-Message-Id: 476be970-8054-4500-e9db-08d81c56548c
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2020 18:00:38.6809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LvcTXo0Be5CyZETfr7Xxyd+bpOXtBs8V1p8Sn6s0q5302WXoawTMTErprsA33ZBW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3640
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-29_21:2020-06-29,2020-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 impostorscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 cotscore=-2147483648 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006290113
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 27, 2020 at 01:31:42PM -0700, Andrii Nakryiko wrote:
> On Fri, Jun 26, 2020 at 5:23 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Fri, Jun 26, 2020 at 03:45:04PM -0700, Andrii Nakryiko wrote:
> > > On Fri, Jun 26, 2020 at 10:56 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > It is common for networking tests creating its netns and making its own
> > > > setting under this new netns (e.g. changing tcp sysctl).  If the test
> > > > forgot to restore to the original netns, it would affect the
> > > > result of other tests.
> > > >
> > > > This patch saves the original netns at the beginning and then restores it
> > > > after every test.  Since the restore "setns()" is not expensive, it does it
> > > > on all tests without tracking if a test has created a new netns or not.
> > > >
> > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > ---
> > > >  tools/testing/selftests/bpf/test_progs.c | 21 +++++++++++++++++++++
> > > >  tools/testing/selftests/bpf/test_progs.h |  2 ++
> > > >  2 files changed, 23 insertions(+)
> > > >
> > > > diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> > > > index 54fa5fa688ce..b521ce366381 100644
> > > > --- a/tools/testing/selftests/bpf/test_progs.c
> > > > +++ b/tools/testing/selftests/bpf/test_progs.c
> > > > @@ -121,6 +121,24 @@ static void reset_affinity() {
> > > >         }
> > > >  }
> > > >
> > > > +static void save_netns(void)
> > > > +{
> > > > +       env.saved_netns_fd = open("/proc/self/ns/net", O_RDONLY);
> > > > +       if (env.saved_netns_fd == -1) {
> > > > +               perror("open(/proc/self/ns/net)");
> > > > +               exit(-1);
> > > > +       }
> > > > +}
> > > > +
> > > > +static void restore_netns(void)
> > > > +{
> > > > +       if (setns(env.saved_netns_fd, CLONE_NEWNET) == -1) {
> > > > +               stdio_restore();
> > > > +               perror("setns(CLONE_NEWNS)");
> > > > +               exit(-1);
> > > > +       }
> > > > +}
> > > > +
> > > >  void test__end_subtest()
> > > >  {
> > > >         struct prog_test_def *test = env.test;
> > > > @@ -643,6 +661,7 @@ int main(int argc, char **argv)
> > > >                 return -1;
> > > >         }
> > > >
> > > > +       save_netns();
> > >
> > > you should probably do this also after each sub-test in test__end_subtest()?
> > You mean restore_netns()?
> 
> oops, yeah :)
> 
> >
> > It is a tough call.
> > Some tests may only want to create a netns at the beginning for all the subtests
> > to use (e.g. sk_assign.c).  restore_netns() after each subtest may catch
> > tester in surprise that the netns is not in its full control while its
> > own test is running.
> 
> Wouldn't it be better to update such self-tests to setns on each
> sub-test properly? It should be a simple code re-use exercise, unless
> I'm missing some other implications of having to do it before each
> sub-test?
It should be simple, I think.  Haven't looked into details of each test.
However, I won't count re-running the same piece of code in a for-loop
as a re-use exercise ;)

In my vm, a quick try in forcing sk_assign.c to reconfigure netns in each
subtest in the for loop increased the runtime from 1s to 8s.
I guess it is not a big deal for test_progs.

> 
> The idea behind sub-test is (at least it was so far) that it's
> independent from other sub-tests and tests, and it's only co-located
> with other sub-tests for the purpose of code reuse and logical
> grouping. Which is why we reset CPU affinity, for instance.
> 
> >
> > I think an individual test should have managed the netns properly within its
> > subtests already if it wants a correct test result.  It can unshare at the
> > beginning of each subtest to get a clean state (e.g. in patch 8).
> > test_progs.c only ensures a config made by an earlier test does
> > not affect the following tests.
> 
> It's true that it gives more flexibility for test setup, but if we go
> that way, we should do it consistently for CPU affinity resetting and
> whatever else we do per-subtest. I wonder what your answers would be
> for the above questions. We can go either way, just let's be
> consistent.
Right, I also don't feel strongly about which way to go for netns.
I noticed reset_affinity().  cgroup cleanup is also per test though.
I think netns is more close to cgroup in terms of bpf prog is running under it,
so this patch picked the current way.

If it is decided to stay with reset_affinity's way,  I can make netns change
to other tests (there are two if i grep properly).

It seems there is no existing subtest requires to reset_affinity.
