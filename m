Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D0C2A39EA
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbgKCBdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:33:38 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2886 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725932AbgKCBdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 20:33:38 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A31UhI1012123;
        Mon, 2 Nov 2020 17:33:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=WlDb91WcXKR9muEkh14FuRl7n5cw2OeSHsn1PODW274=;
 b=JNzaV8YYGEwfntbLVrgfUgKshNob40DUn4+r8AJKRHaYlLrMezarM+dhvCbQAruH+wpl
 +yfeWChD4NMbf8J/5W7DIwYj71NXP0Tq1HD197OtxG8+zWPwu1relf8090zSgYR6GjxB
 IpZxvxWExXpeZctI1vvJm8GU1DnGZG119ho= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34hqdu8hur-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Nov 2020 17:33:21 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 2 Nov 2020 17:33:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJqdcRVMgKAoAQuXEoO5RvPsVNHYM1btI7KAyMNjNoTMw1coegEDITeXF+DPWKXZdKUcIftR2QOnLZDUUf1/s07XY3NADlThYqwOkLkPjwPjQqOMkBtElsQDooomA7ZZB9USMrIzHr2lr8rSCDvfSWKQk2EfqTn79qAqPgAvYILkNRrLZ4Uckf61gucrgSiDxdxLA3xXxALv4omMI7cL84Pg9qP9N8wGG0Yz4yPKEjjWjOHya+SZCgb81ohxKZ+aoAbrPkvTwIEZwerpjseDGPe674Dzl1vsLh5xNKYaIvEKsoSQZmdC3L6XlAznHovNqxd+UT4u3oh8Y/gNpHz9DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WlDb91WcXKR9muEkh14FuRl7n5cw2OeSHsn1PODW274=;
 b=PLq1ekNF4IoPLcNV34fBCsyVd6zeoMTXMbE5aHXiyHV4MoxyVwyEbE1J+BMWb+I2wltVx0ZwOVWMEXST5EiqOR0voe/GAM8oYIA8mBVSmjGAxriEn8mUQ8DQdbF7Dfdy119DKRDcVj3ySybkukBFTnuGklEn/0GF0reSzLctftwZOwEwpSWXZYik6Hdb6AgbDOrSkOHglxp94IPM+Tx7V5ZIsjiNMeuWhCScvnrw1+lfN8NrJppVBItM/pJMKeFheFHXzK2PON7hz/g7jNGtBgvvAyfS3XIz9283GAecOhcopJHGB40PhFT58PNSb3h8TSM4x1B/qOvEKSWuDnOrLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WlDb91WcXKR9muEkh14FuRl7n5cw2OeSHsn1PODW274=;
 b=a4uT+hLqDXlzUapvr8lxUxVn6mPsegPsD6MgKCXyss+Mv5V+sxofqOMTXxyEa8zNFdw6Cu69tgtL9KgdJbMlPuiN9TSOLF45xSBUlhuvXKArDskSqrip8/m+LTnWs3tjnDEpsRB/2Nd4E5yZIi6VFSlheZawaX8QM0INX+rs//w=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2246.namprd15.prod.outlook.com (2603:10b6:a02:8d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Tue, 3 Nov
 2020 01:33:17 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 01:33:17 +0000
Date:   Mon, 2 Nov 2020 17:33:10 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        <alexanderduyck@fb.com>
Subject: Re: [bpf-next PATCH v2 2/5] selftests/bpf: Drop python client/server
 in favor of threads
Message-ID: <20201103013310.wbs7i3jm5vwnrctn@kafai-mbp.dhcp.thefacebook.com>
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
 <160417033818.2823.4460428938483935516.stgit@localhost.localdomain>
 <20201103003836.2ngjz6yqewhn7aln@kafai-mbp.dhcp.thefacebook.com>
 <CAKgT0UceQhVGXbkZWj_aj0+Ew8oOEJMAgwAUE5GLN5EexqAhkQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UceQhVGXbkZWj_aj0+Ew8oOEJMAgwAUE5GLN5EexqAhkQ@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:8aa6]
X-ClientProxiedBy: MWHPR08CA0058.namprd08.prod.outlook.com
 (2603:10b6:300:c0::32) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:8aa6) by MWHPR08CA0058.namprd08.prod.outlook.com (2603:10b6:300:c0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 3 Nov 2020 01:33:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4e1b0a1-a8b0-4954-59d0-08d87f987075
X-MS-TrafficTypeDiagnostic: BYAPR15MB2246:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2246BD7CCD3B9BC167D72E1AD5110@BYAPR15MB2246.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XeS5whO+44Oxlc1zHtxsCIQzDCXM88MghQvfOfaRvIasY6kyDsYUVVaVzLNcIdIF0ShqvPKZr7xCx+vjjZOq/M3S1Q23DfE3wXYn0b1/BnWCBMs5ZLqXPsvPvH2FuW5CI1bcYC6CzcAVOYM8Lxt5VGl93cPGqs4v+Om8MnST+iDmXjyhnhz1DHshoPcURwMO/jSNfDguUsEurq6aJG+GT/Uu1RahoTO1GBGolKgxaG3Kst6ErcjQlkfaRTKjJaWNzaQSpCgpueq157dIuuvMSBybkHQuUnThR4ImN3i95HjsKvuBnm8bv9TGm1bKUCWdhd8scjxiLre47sIlPvQ57g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(346002)(136003)(376002)(4326008)(55016002)(5660300002)(54906003)(66946007)(66556008)(66476007)(478600001)(2906002)(6666004)(83380400001)(316002)(1076003)(8676002)(16526019)(6916009)(9686003)(6506007)(52116002)(53546011)(8936002)(7696005)(186003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: +X+iJsMFOzv9hwuD7QlFqzfwyywzUZKWHxh40U0D6gClCCbRmibDKgnQTAYD/YlETRCltZcWPYdf1FwAwb1wYU2HNHs3qGRz/4Dl6DXoKdhE97xByOmcDB+JTEbK/6SVnP2/ATgMaUWW9nWsa57sa/Ri3mj5O4SVw1KvUMvG9Iy4XkDPABHa5b7cNMON6LvCHqWAZj2v7hILlNXmMZB0Zhr5uaTkvchlXr1xetRkOsufVMaTpsp1j/pcqisPikD/b0O9JFhXPVLxpOaLyjtaEw7PlMeqn8ejee9N7BLDqBnJdgXhBRFStQuX50Qa+r9Fl6VRMnvgs/560GJP90hfQVJEa+WToXGoS4S00JOi87y4AuH406jzCwWNpsh4OWe0u+v5jyYIKFKfB6N6g/2mQjlDqmHqce14VN5fdOC8lhSim8Fdp58cuGNTRQLaMKI59g434NN/Gr1NCR8k+Yf+V9d6Mu5/kCz+qPYtZ5J3VTKBgDg9GkiWRzcUBYstGwpgRb4oL4Hzz9c0X1SMOqV+EXWYlPjnbaZIxJjyaU6py15Huv8xRUtQyAfnQt5EFWq5xXm+7amde5Imjnh5sOGuRUiQPz2z6+pRB/Vdb7ARg4xz0avnW9IJeaz5gUSU6O8uXKxrMhnYRD25hXwDarT1jwfXSsK0m95SZXNa+21Vh1Vnj7GMigutMGj7VHumrh2u
X-MS-Exchange-CrossTenant-Network-Message-Id: f4e1b0a1-a8b0-4954-59d0-08d87f987075
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 01:33:17.2899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e6Mm14LicdMM9dpe//jtAf2boVG7fBrPO8XGCbOM9FO+1/+QPWpQ6sM6H06B1kx6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2246
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_16:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=2 bulkscore=0 mlxscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030007
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 04:49:42PM -0800, Alexander Duyck wrote:
> On Mon, Nov 2, 2020 at 4:38 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Sat, Oct 31, 2020 at 11:52:18AM -0700, Alexander Duyck wrote:
> > > From: Alexander Duyck <alexanderduyck@fb.com>
> > >
> > > Drop the tcp_client/server.py files in favor of using a client and server
> > > thread within the test case. Specifically we spawn a new thread to play the
> > The thread comment may be outdated in v2.
> >
> > > role of the server, and the main testing thread plays the role of client.
> > >
> > > Add logic to the end of the run_test function to guarantee that the sockets
> > > are closed when we begin verifying results.
> > >
> > > Doing this we are able to reduce overhead since we don't have two python
> > > workers possibly floating around. In addition we don't have to worry about
> > > synchronization issues and as such the retry loop waiting for the threads
> > > to close the sockets can be dropped as we will have already closed the
> > > sockets in the local executable and synchronized the server thread.
> > >
> > > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> > > ---
> > >  .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   96 ++++++++++++++++----
> > >  tools/testing/selftests/bpf/tcp_client.py          |   50 ----------
> > >  tools/testing/selftests/bpf/tcp_server.py          |   80 -----------------
> > >  3 files changed, 78 insertions(+), 148 deletions(-)
> > >  delete mode 100755 tools/testing/selftests/bpf/tcp_client.py
> > >  delete mode 100755 tools/testing/selftests/bpf/tcp_server.py
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > > index 54f1dce97729..17d4299435df 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > > @@ -1,13 +1,14 @@
> > >  // SPDX-License-Identifier: GPL-2.0
> > >  #include <inttypes.h>
> > >  #include <test_progs.h>
> > > +#include <network_helpers.h>
> > >
> > >  #include "test_tcpbpf.h"
> > >
> > > +#define LO_ADDR6 "::1"
> > >  #define CG_NAME "/tcpbpf-user-test"
> > >
> > > -/* 3 comes from one listening socket + both ends of the connection */
> > > -#define EXPECTED_CLOSE_EVENTS                3
> > > +static __u32 duration;
> > >
> > >  #define EXPECT_EQ(expected, actual, fmt)                     \
> > >       do {                                                    \
> > > @@ -42,7 +43,9 @@ int verify_result(const struct tcpbpf_globals *result)
> > >       EXPECT_EQ(0x80, result->bad_cb_test_rv, PRIu32);
> > >       EXPECT_EQ(0, result->good_cb_test_rv, PRIu32);
> > >       EXPECT_EQ(1, result->num_listen, PRIu32);
> > > -     EXPECT_EQ(EXPECTED_CLOSE_EVENTS, result->num_close_events, PRIu32);
> > > +
> > > +     /* 3 comes from one listening socket + both ends of the connection */
> > > +     EXPECT_EQ(3, result->num_close_events, PRIu32);
> > >
> > >       return ret;
> > >  }
> > > @@ -66,6 +69,75 @@ int verify_sockopt_result(int sock_map_fd)
> > >       return ret;
> > >  }
> > >
> > > +static int run_test(void)
> > > +{
> > > +     int listen_fd = -1, cli_fd = -1, accept_fd = -1;
> > > +     char buf[1000];
> > > +     int err = -1;
> > > +     int i;
> > > +
> > > +     listen_fd = start_server(AF_INET6, SOCK_STREAM, LO_ADDR6, 0, 0);
> > > +     if (CHECK(listen_fd == -1, "start_server", "listen_fd:%d errno:%d\n",
> > > +               listen_fd, errno))
> > > +             goto done;
> > > +
> > > +     cli_fd = connect_to_fd(listen_fd, 0);
> > > +     if (CHECK(cli_fd == -1, "connect_to_fd(listen_fd)",
> > > +               "cli_fd:%d errno:%d\n", cli_fd, errno))
> > > +             goto done;
> > > +
> > > +     accept_fd = accept(listen_fd, NULL, NULL);
> > > +     if (CHECK(accept_fd == -1, "accept(listen_fd)",
> > > +               "accept_fd:%d errno:%d\n", accept_fd, errno))
> > > +             goto done;
> > > +
> > > +     /* Send 1000B of '+'s from cli_fd -> accept_fd */
> > > +     for (i = 0; i < 1000; i++)
> > > +             buf[i] = '+';
> > > +
> > > +     err = send(cli_fd, buf, 1000, 0);
> > > +     if (CHECK(err != 1000, "send(cli_fd)", "err:%d errno:%d\n", err, errno))
> > > +             goto done;
> > > +
> > > +     err = recv(accept_fd, buf, 1000, 0);
> > > +     if (CHECK(err != 1000, "recv(accept_fd)", "err:%d errno:%d\n", err, errno))
> > > +             goto done;
> > > +
> > > +     /* Send 500B of '.'s from accept_fd ->cli_fd */
> > > +     for (i = 0; i < 500; i++)
> > > +             buf[i] = '.';
> > > +
> > > +     err = send(accept_fd, buf, 500, 0);
> > > +     if (CHECK(err != 500, "send(accept_fd)", "err:%d errno:%d\n", err, errno))
> > > +             goto done;
> > > +
> > > +     err = recv(cli_fd, buf, 500, 0);
> > Unlikely, but err from the above send()/recv() could be 0.
> 
> Is that an issue? It would still trigger the check below as that is not 500.
Mostly for consistency.  "err" will be returned and tested for non-zero
in test_tcpbpf_user().

> 
> > > +     if (CHECK(err != 500, "recv(cli_fd)", "err:%d errno:%d\n", err, errno))
> > > +             goto done;
> > > +
> > > +     /*
> > > +      * shutdown accept first to guarantee correct ordering for
> > > +      * bytes_received and bytes_acked when we go to verify the results.
> > > +      */
> > > +     shutdown(accept_fd, SHUT_WR);
> > > +     err = recv(cli_fd, buf, 1, 0);
> > > +     if (CHECK(err, "recv(cli_fd) for fin", "err:%d errno:%d\n", err, errno))
> > > +             goto done;
> > > +
> > > +     shutdown(cli_fd, SHUT_WR);
> > > +     err = recv(accept_fd, buf, 1, 0);
> > hmm... I was thinking cli_fd may still be in TCP_LAST_ACK
> > but we can go with this version first and see if CI could
> > really hit this case before resurrecting the idea on testing
> > the TCP_LAST_ACK instead of TCP_CLOSE in test_tcpbpf_kern.c.
> 
> I ran with this for several hours and saw no issues with over 100K
> iterations all of them passing. That is why I opted to just drop the
> TCP_LAST_ACK patch.
Thanks for testing it hard.  It is good enough for me.
