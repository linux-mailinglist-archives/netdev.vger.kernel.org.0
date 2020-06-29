Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0953520D41B
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbgF2TFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:05:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14018 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730202AbgF2TFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:05:04 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05TIDaMw016105;
        Mon, 29 Jun 2020 11:24:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=0YPyaq3Ct1YDSDvu1DP3vFrUjmnq3qH0P5QjysSJqZs=;
 b=X+yXXEOD3JmDbYJkSCtP7Vz7OXzKvmUO1hrgsM8Cw5FjZXVbWCzB9R2wq1sC329dxtUR
 ysnKjRuln5+dhNWwimzkP7WV0xpUMJVhFGh/hVrWInwYuIXvo8RJcSpNKO64Tpa1dbLj
 heytb1k5C/PTn6aQOHSOQjxXtI+4wLfWuRI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31xp3rdtrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Jun 2020 11:24:52 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 11:24:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IdE4sv12OclZiNLvsmgtkNmzmn1Rt0ePNCx67dBE9sbfXZFEkv7JGv3UNJDxIcMVHcnjOPR34aP+bcq2AgZqgGSUaC82yM4abqUCM1AhHuDSTlr/3R7iq0s1Pf0B0ELUTtEm2Ju2WJfUL3sUl8EuHBwPRDvdnmNty/ipa4R1DG3yYI62IZO2hFJ9J+L0WqAuE+Ci4cLUxNPQSmF++1x9iRi3/JvAiL1iQrT1QI8gdBVNFvY/4K/AccHu/j7TuB6OWf9qvQ/pUsf57cen0s3zISuKP/WwOd8Pucm5ZnV79NkBqvZbm6L/JHD94S59Ke4m5/0kC1bb8jGSx7yoC4sZMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0YPyaq3Ct1YDSDvu1DP3vFrUjmnq3qH0P5QjysSJqZs=;
 b=A8PTw4h9CfXf8GN+rHjPl2k6nEen3jArrjpDUgh4zOPggwhdkGkIJR2OzzPez+0XSzSxSSpm1ibo8PJXHZGzLL8mQIjK7ljxH1XOqLEzW2LqV0gmg98dBAULmUEUIHitbAkvQ6x/1FH5BzxIzZv54dmVZ4LfosazKeRgHVnoGcHjcthViFZ7+8Fme4QAUTuKhRfAKX9fDwUQAOPpuxyU+bdPnv2/dhE6OiXgowrg2UjeF8xZWRUlDA0nBjRsCTaXeuAoYkzGTdgBTefpumva7APHhq665dtEvOqQlkcp9WT9XNGtTlaT6UbOKwBy2L4PKo5Dms6xIvwx07TlGl+dPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0YPyaq3Ct1YDSDvu1DP3vFrUjmnq3qH0P5QjysSJqZs=;
 b=RRKmKT/6xJZdAXowbL9NDTBR12w2lzmizGreDoDyt+SKXV/ghH4GQUHXjkyDZmpP7mOBdHU+mLFpSWD8cg6dSSaqt3lOmKAOEjwpxtJMYylQ77pVJGK7XPtxIZ9hhMh9W+u9Zq30zzDSGk6qpeU2pWvAEPUttmE8lcLZJL04Wqs=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3575.namprd15.prod.outlook.com (2603:10b6:610:2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.26; Mon, 29 Jun
 2020 18:24:49 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107%5]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 18:24:49 +0000
Date:   Mon, 29 Jun 2020 11:24:46 -0700
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
Message-ID: <20200629182446.ij4a7ngat33b2omm@kafai-mbp.dhcp.thefacebook.com>
References: <20200626175501.1459961-1-kafai@fb.com>
 <20200626175545.1462191-1-kafai@fb.com>
 <CAEf4BzZ3Jb296zJ7bfsntk7v5fkynrBcKncGQgrSHJ2zqifgsA@mail.gmail.com>
 <20200627002302.3tqklvjxxuetjoxr@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZevDLp8Hzax3T8XzHLsMm85upCONULVVOEOyAxVGe4dA@mail.gmail.com>
 <20200629180035.huq42fif7wktfbja@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4Bzbke6B9Pf21xD0XXz_NGmuZMZcaWxbfgjdxBaNHc=zf1w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzbke6B9Pf21xD0XXz_NGmuZMZcaWxbfgjdxBaNHc=zf1w@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR06CA0033.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::46) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:875e) by BYAPR06CA0033.namprd06.prod.outlook.com (2603:10b6:a03:d4::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23 via Frontend Transport; Mon, 29 Jun 2020 18:24:47 +0000
X-Originating-IP: [2620:10d:c090:400::5:875e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e535d204-95f3-4917-fb4d-08d81c59b4f4
X-MS-TrafficTypeDiagnostic: CH2PR15MB3575:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR15MB3575912C80A8F16A481CF52AD56E0@CH2PR15MB3575.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 044968D9E1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qguIUW3ce/Ktut1WRY1EUEiUvk/Lly0o3yCoTfGSJ4lZr0JpoLu/NN+Xi48YwDBnEn8FuHPY1uzTwA+Im4JGmDtQAzEcrB8R0UrcXgj21dVQPeCRu9AX0Kn0muHo2FQZuiB6Wq+Fq3sd4rb2b4DFMEWjGx87W7tC4Mv6azawCqzlUIdHYI/v1tjVtuFPqVV7cRhXSlSRCFsS2L/R6CWgIbxIBvnfc/cvMzzDyUGbsFmMEY3jzytJg7GRJ1dy7FClT2rxKtl4iy5WcFDEyi3CRJ/83ZPCL3sez5Fw3henMzBgRhKrv7bJIlFlNhb3280n7V/DvtlLIL42zxSq8x6D9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(39860400002)(366004)(396003)(136003)(186003)(16526019)(86362001)(6506007)(53546011)(66556008)(66946007)(66476007)(1076003)(316002)(54906003)(9686003)(83380400001)(55016002)(5660300002)(8936002)(6916009)(478600001)(4326008)(2906002)(8676002)(7696005)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: F6rLD8QzUMlOFz6z6CdgVrKEBFid2JLAKu3VuX+kDzdauzRJvVA4aVHw4TGkWPEUH3TP6FOl8bbVlQx2wyMpnqDe6xLZIL44+D/KF6cjwT4a8VgpsxAo6N2881jYvPrzRv75mQ0wPz2KkA2WF6bFJam06FFQw7D2vruMw9Ns45YmRuuYoQsdGTWIt5POTdj65xIgtmiNfk3HzAQUqrThilLxBCrHfjvlJCVblKBZe3FRWAS7bVAdPZj4BE4YWDTpx4TRWFluw0juGPNA1tsqWXZ53SgaUBG0I3okvU8eV+z3OwkJCJOekY8xcoLorRmQB0HKgnxkLe307cDrtK++l873wPJzRrk1BJD+J0ed3N7btjnv6iO2iqZRneSHdLVqF8PIgaLiKaviTkAucBnG4vidB+XjBOqTUyMRvohQn/89GAUHUYyOSi0eB5VAmYmahMM6kjny6UBEM4MXgH8h9LGwUEaUmO81cAop5oTW5iAs2q2/MPhvV2tHJ0V9LNDLcTuEai2v11ZVEASsWKFh9g==
X-MS-Exchange-CrossTenant-Network-Message-Id: e535d204-95f3-4917-fb4d-08d81c59b4f4
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2020 18:24:48.9374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YfNeIVzq8316EQk7BbE6NIH9ErtJ9T1w/8t/eytMfL8+fS/ssMUalxUtAy5eLNEQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3575
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-29_21:2020-06-29,2020-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 adultscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 cotscore=-2147483648 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006290115
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 11:13:07AM -0700, Andrii Nakryiko wrote:
> On Mon, Jun 29, 2020 at 11:00 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Sat, Jun 27, 2020 at 01:31:42PM -0700, Andrii Nakryiko wrote:
> > > On Fri, Jun 26, 2020 at 5:23 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > On Fri, Jun 26, 2020 at 03:45:04PM -0700, Andrii Nakryiko wrote:
> > > > > On Fri, Jun 26, 2020 at 10:56 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > >
> > > > > > It is common for networking tests creating its netns and making its own
> > > > > > setting under this new netns (e.g. changing tcp sysctl).  If the test
> > > > > > forgot to restore to the original netns, it would affect the
> > > > > > result of other tests.
> > > > > >
> > > > > > This patch saves the original netns at the beginning and then restores it
> > > > > > after every test.  Since the restore "setns()" is not expensive, it does it
> > > > > > on all tests without tracking if a test has created a new netns or not.
> > > > > >
> > > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > > ---
> > > > > >  tools/testing/selftests/bpf/test_progs.c | 21 +++++++++++++++++++++
> > > > > >  tools/testing/selftests/bpf/test_progs.h |  2 ++
> > > > > >  2 files changed, 23 insertions(+)
> > > > > >
> > > > > > diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> > > > > > index 54fa5fa688ce..b521ce366381 100644
> > > > > > --- a/tools/testing/selftests/bpf/test_progs.c
> > > > > > +++ b/tools/testing/selftests/bpf/test_progs.c
> > > > > > @@ -121,6 +121,24 @@ static void reset_affinity() {
> > > > > >         }
> > > > > >  }
> > > > > >
> > > > > > +static void save_netns(void)
> > > > > > +{
> > > > > > +       env.saved_netns_fd = open("/proc/self/ns/net", O_RDONLY);
> > > > > > +       if (env.saved_netns_fd == -1) {
> > > > > > +               perror("open(/proc/self/ns/net)");
> > > > > > +               exit(-1);
> > > > > > +       }
> > > > > > +}
> > > > > > +
> > > > > > +static void restore_netns(void)
> > > > > > +{
> > > > > > +       if (setns(env.saved_netns_fd, CLONE_NEWNET) == -1) {
> > > > > > +               stdio_restore();
> > > > > > +               perror("setns(CLONE_NEWNS)");
> > > > > > +               exit(-1);
> > > > > > +       }
> > > > > > +}
> > > > > > +
> > > > > >  void test__end_subtest()
> > > > > >  {
> > > > > >         struct prog_test_def *test = env.test;
> > > > > > @@ -643,6 +661,7 @@ int main(int argc, char **argv)
> > > > > >                 return -1;
> > > > > >         }
> > > > > >
> > > > > > +       save_netns();
> > > > >
> > > > > you should probably do this also after each sub-test in test__end_subtest()?
> > > > You mean restore_netns()?
> > >
> > > oops, yeah :)
> > >
> > > >
> > > > It is a tough call.
> > > > Some tests may only want to create a netns at the beginning for all the subtests
> > > > to use (e.g. sk_assign.c).  restore_netns() after each subtest may catch
> > > > tester in surprise that the netns is not in its full control while its
> > > > own test is running.
> > >
> > > Wouldn't it be better to update such self-tests to setns on each
> > > sub-test properly? It should be a simple code re-use exercise, unless
> > > I'm missing some other implications of having to do it before each
> > > sub-test?
> > It should be simple, I think.  Haven't looked into details of each test.
> > However, I won't count re-running the same piece of code in a for-loop
> > as a re-use exercise ;)
> >
> > In my vm, a quick try in forcing sk_assign.c to reconfigure netns in each
> > subtest in the for loop increased the runtime from 1s to 8s.
> > I guess it is not a big deal for test_progs.
> 
> Oh, no, thank you very much, no one needs extra 7 seconds of
> test_progs run. Can you please remove reset_affinity() from sub-test
> clean up then, and consistently do clean ups only between tests?
Sure.

reset_affinity() has already been called after each test, so should be
fine as is.
