Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855E429F3E2
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 19:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgJ2SN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 14:13:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29562 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725747AbgJ2SN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 14:13:27 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 09TI9O49015834;
        Thu, 29 Oct 2020 11:13:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=QMu6yJpCcLo2t8QTwLHAh7ff56Hkbcn5Olyv18963Ug=;
 b=i+kIaNCexeV/St2M3iI4xst/3sQzgF/NpILQ/lKETylilCe7PnA66SgXVFYcJtKgjW7w
 Vz6XAs5rGknFhnpu+L1NOYSaKYkRLOZ55bybaNLCA1cxtzXIueURWgqJoKD15CreEbAo
 1KohshJbtOUg6vJ6bDPASvWDeqadweIY6F0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 34f0jnakab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Oct 2020 11:13:10 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 29 Oct 2020 11:13:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LAz/dbJbOzGjS0q1/wOLY8YTZVZPmAL3JYkZO04B8VFOyzWAKJ3WVRFjV1lfmXIf84LzCVnWN1Q1oquDERmEXwfwKreqjVSSckusCOpzHUrPU62C61RKVBZ3mS29aee9UHp7qTZVHhTH1/n6WV2A+F4D38Anb+cuk/mazfk1kRBiVRGKObn/Pp9bU2Ihr/5ssQciL5hAR+urAWkvPLQTOqn86gsEa2WxdykHdubX67Nd9taaAn/ktPtvepnHQNKaisb82aJL45Im6E2gDdRtKzQUaeoW5g5+GlzNCA/N/kJwyglkZVGJlvexcSGHgnzYd+pa9Jo2go0BuJ1AY7d58g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMu6yJpCcLo2t8QTwLHAh7ff56Hkbcn5Olyv18963Ug=;
 b=JneTjJjIA+gZKEqLV0HtvKH4Vdgex3Pkhfei8vxKYwryOQ/8z1oIsaHOSoq6j+HDEVU5cuLG/2GcwkTLylfNm0R/2MzvAER2zkZNH3i2HcwbEBUkutf1w9m+XhnItoHMqy8vsiE23CdrUC5skmOc8ANPQd6oOqIaDhReb1IkImpsuoFVCf9102xYDVgPhnSjSGefbx3PFZ2yKRhZE75SoO05yTbwpJLLFEpElgm3MMt4jeaEAWm8xhhWDIeYPivK5d+5JryIkTJpp8vsxV4QAXwwcVaarVrweHHR/8CxxjJmizl4Tu/Ct0KaW89Vqnc+MqReL3da7klHEvR1zBxqPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMu6yJpCcLo2t8QTwLHAh7ff56Hkbcn5Olyv18963Ug=;
 b=k5Ult2HxSkxALDvCmQvy8OPVDDFHyizCLNPjC48a90hDVW3+2oCeNCtAtdsmQ7vZst+nxFT5/89pj/5eTWYXx+uVvxx18zAhEYvoIsXkBDOnEHUudO0yE4QbhmMpecBPdZ/52h/XaLm/WpZrS2j1+o1hqTuGhmND0F/FtWhzg4w=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2261.namprd15.prod.outlook.com (2603:10b6:a02:8e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Thu, 29 Oct
 2020 18:13:05 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3499.027; Thu, 29 Oct 2020
 18:13:05 +0000
Date:   Thu, 29 Oct 2020 11:12:58 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, <brakmo@fb.com>,
        <alexanderduyck@fb.com>
Subject: Re: [bpf-next PATCH 2/4] selftests/bpf: Drop python client/server in
 favor of threads
Message-ID: <20201029181258.ezff3vfpar7fxbam@kafai-mbp.dhcp.thefacebook.com>
References: <160384954046.698509.132709669068189999.stgit@localhost.localdomain>
 <160384963313.698509.13129692731727238158.stgit@localhost.localdomain>
 <20201029015115.jotej3wgi3p6yn6u@kafai-mbp>
 <CAKgT0UcpqQaHOdjcOGybF0pWuZS_ZqYOArQ8kLfvheGFE-ur-w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UcpqQaHOdjcOGybF0pWuZS_ZqYOArQ8kLfvheGFE-ur-w@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::4:c696]
X-ClientProxiedBy: MWHPR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:300:4b::17) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::4:c696) by MWHPR02CA0007.namprd02.prod.outlook.com (2603:10b6:300:4b::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Thu, 29 Oct 2020 18:13:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 842cfbe1-4a2a-4bdd-5e0f-08d87c364833
X-MS-TrafficTypeDiagnostic: BYAPR15MB2261:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2261C2E2727F5B0073ED0F45D5140@BYAPR15MB2261.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ElgD9ybiPE4oT2I9mlmrwShEYTk7w4tA45CApUe4s01uQmDFDytrQiVsMlLMDZpYlpF3jUWNOELgW6lzIV/v+BRbf5vEEkxit5eyhw6ARR4AVDWSeug2V99fgBClWJGtd8UocJmsnpQsI4JKrqcbK+tBMR7CiPSf5STpoHcThNVPUR0Uag65hN4ss23TQgGlegnSxZu2ar4s7KQGEYDyp2V3ZftNqta79hsI9+3Qh+MUAIu9MctAMiS5EaKV2xcx8vHBA7S17w5rmOc9qvm9n4rS8yAZyNEuq8xes6nmp8NW4n+BAh0QW/C2d73BXQJcOhLhfOyXgMCST817niJ+fw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(366004)(396003)(346002)(54906003)(6666004)(16526019)(186003)(7696005)(66556008)(6916009)(52116002)(1076003)(66946007)(66476007)(8676002)(30864003)(478600001)(9686003)(86362001)(316002)(4326008)(83380400001)(2906002)(55016002)(5660300002)(8936002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Nq4BGkuruuvUK/pptfCaPcTRTMSGFO02uEX0+dMt3tbhp8a5wGNFryEHYQACfJbtgN4dOWHsgvOaF0qu3bCNT0fBormkbkds1OXk/WnBkvh5Uifr9+X/RWdZW+p5QEUIxoq1cwrEwCYvAYFA1XXKqQ8Gn1BkkoWW35PunYtXbkehTT7VO++Oj4AJDY2e7H9KcyZ6rJ3rHhSHPnD5ON+8RPcZ6oRtcNI811DdaQBagex2y20u2OxP39BPEuXbecENRlMuTGfYaGbitVzc/ggevISN1/dA95mX4WcNojVC0aRQLaK2nlFQL/LX4/TJWAWU14OnVMcErz9bbfxabSBad+m7kSX5/JuzfNYaDSgzjxlWsrU8kYXKurpp/jImwgoAdnULEAUuYbqVigm+NrKA1BL0JPicuCFo4ANTC3MoxKAzm3xAv6E34ICbhLCFdOkmJNlSt1OsMOj93iXp9q6RZqlXz4Zd39+oBOWpHdSlsLRALUWbFPG9+a3WQaVr9wql8q7q3SdgESQp8MMmzktW0TNPAwHay2ilzRjW9EQZLn8Q09c86hpGD2MQ/gRxZ1PoK2s6JLLO3eEM6KSCqFPXxzLKlA9FdS/7qLTNYU3UTyEMMYyCZu9yghzjh23tWOQchf5o+Dz0+XullNl0NqZDVXr1CU3NMoCldmHOZJewl0g=
X-MS-Exchange-CrossTenant-Network-Message-Id: 842cfbe1-4a2a-4bdd-5e0f-08d87c364833
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2020 18:13:05.7397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VuhdZBTOsfgAgdS40mg3wCj5d8cvuvQNNwwadqMOIo/LaCeFqHBQ1TdtfrTQRX6a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2261
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-29_11:2020-10-29,2020-10-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 malwarescore=0
 suspectscore=2 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290127
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 09:58:15AM -0700, Alexander Duyck wrote:
[ ... ]

> > > @@ -43,7 +94,9 @@ int verify_result(const struct tcpbpf_globals *result)
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
> > > @@ -67,6 +120,52 @@ int verify_sockopt_result(int sock_map_fd)
> > >       return ret;
> > >  }
> > >
> > > +static int run_test(void)
> > > +{
> > > +     int server_fd, client_fd;
> > > +     void *server_err;
> > > +     char buf[1000];
> > > +     pthread_t tid;
> > > +     int err = -1;
> > > +     int i;
> > > +
> > > +     server_fd = start_server(AF_INET6, SOCK_STREAM, LO_ADDR6, 0, 0);
> > > +     if (CHECK_FAIL(server_fd < 0))
> > > +             return err;
> > > +
> > > +     pthread_mutex_lock(&server_started_mtx);
> > > +     if (CHECK_FAIL(pthread_create(&tid, NULL, server_thread,
> > > +                                   (void *)&server_fd)))
> > > +             goto close_server_fd;
> > > +
> > > +     pthread_cond_wait(&server_started, &server_started_mtx);
> > > +     pthread_mutex_unlock(&server_started_mtx);
> > > +
> > > +     client_fd = connect_to_fd(server_fd, 0);
> > > +     if (client_fd < 0)
> > > +             goto close_server_fd;
> > > +
> > > +     for (i = 0; i < 1000; i++)
> > > +             buf[i] = '+';
> > > +
> > > +     if (CHECK_FAIL(send(client_fd, buf, 1000, 0) < 1000))
> > > +             goto close_client_fd;
> > > +
> > > +     if (CHECK_FAIL(recv(client_fd, buf, 500, 0) < 500))
> > > +             goto close_client_fd;
> > > +
> > > +     pthread_join(tid, &server_err);
> > I think this can be further simplified without starting thread
> > and do everything in run_test() instead.
> >
> > Something like this (uncompiled code):
> >
> >         accept_fd = accept(server_fd, NULL, 0);
> >         send(client_fd, plus_buf, 1000, 0);
> >         recv(accept_fd, recv_buf, 1000, 0);
> >         send(accept_fd, dot_buf, 500, 0);
> >         recv(client_fd, recv_buf, 500, 0);
> 
> I can take a look at switching it over.
> 
> > > +
> > > +     err = (int)(long)server_err;
> > > +     CHECK_FAIL(err);
> > > +
> > > +close_client_fd:
> > > +     close(client_fd);
> > > +close_server_fd:
> > > +     close(server_fd);
> > > +     return err;
> > > +}
> > > +
> > >  void test_tcpbpf_user(void)
> > >  {
> > >       const char *file = "test_tcpbpf_kern.o";
> > > @@ -74,7 +173,6 @@ void test_tcpbpf_user(void)
> > >       struct tcpbpf_globals g = {0};
> > >       struct bpf_object *obj;
> > >       int cg_fd = -1;
> > > -     int retry = 10;
> > >       __u32 key = 0;
> > >       int rv;
> > >
> > > @@ -94,11 +192,6 @@ void test_tcpbpf_user(void)
> > >               goto err;
> > >       }
> > >
> > > -     if (CHECK_FAIL(system("./tcp_server.py"))) {
> > > -             fprintf(stderr, "FAILED: TCP server\n");
> > > -             goto err;
> > > -     }
> > > -
> > >       map_fd = bpf_find_map(__func__, obj, "global_map");
> > >       if (CHECK_FAIL(map_fd < 0))
> > >               goto err;
> > > @@ -107,21 +200,17 @@ void test_tcpbpf_user(void)
> > >       if (CHECK_FAIL(sock_map_fd < 0))
> > >               goto err;
> > >
> > > -retry_lookup:
> > > +     if (run_test()) {
> > > +             fprintf(stderr, "FAILED: TCP server\n");
> > > +             goto err;
> > > +     }
> > > +
> > >       rv = bpf_map_lookup_elem(map_fd, &key, &g);
> > >       if (CHECK_FAIL(rv != 0)) {
> > CHECK() is a better one here if it needs to output error message.
> > The same goes for similar usages in this patch set.
> >
> > For the start_server() above which has already logged the error message,
> > CHECK_FAIL() is good enough.
> >
> > >               fprintf(stderr, "FAILED: bpf_map_lookup_elem returns %d\n", rv);
> > >               goto err;
> > >       }
> > >
> > > -     if (g.num_close_events != EXPECTED_CLOSE_EVENTS && retry--) {
> > It is good to have a solution to avoid a test depending on some number
> > of retries.
> >
> > After looking at BPF_SOCK_OPS_STATE_CB in test_tcpbpf_kern.c,
> > it is not clear to me removing python alone is enough to avoid the
> > race (so the retry--).  One of the sk might still be in TCP_LAST_ACK
> > instead of TCP_CLOSE.
> >
> 
> After you pointed this out I decided to go back through and do some
> further testing. After testing this for several thousand iterations it
> does look like the issue can still happen, it was just significantly
> less frequent with the threaded approach, but it was still there. So I
> will go back through and add this back and then fold it into the
> verify_results function in the third patch. Although I might reduce
> the wait times as it seems like with the inline approach we only need
> in the 10s of microseconds instead of 100s for the sockets to close
> out.
I think this retry-and-wait can be avoided.  More on this...

> 
> > Also, when looking closer at BPF_SOCK_OPS_STATE_CB in test_tcpbpf_kern.c,
> > it seems the map value "gp" is slapped together across multiple
> > TCP_CLOSE events which may be not easy to understand.
> >
> > How about it checks different states: TCP_CLOSE, TCP_LAST_ACK,
> > and BPF_TCP_FIN_WAIT2.  Each of this state will update its own
> > values under "gp".  Something like this (only compiler tested on
> > top of patch 4):
> >
> > diff --git i/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c w/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > index 7e92c37976ac..65b247b03dfc 100644
> > --- i/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > +++ w/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > @@ -90,15 +90,14 @@ static void verify_result(int map_fd, int sock_map_fd)
> >               result.event_map, expected_events);
> >
> >         ASSERT_EQ(result.bytes_received, 501, "bytes_received");
> > -       ASSERT_EQ(result.bytes_acked, 1002, "bytes_acked");
> > +       ASSERT_EQ(result.bytes_acked, 1001, "bytes_acked");
> >         ASSERT_EQ(result.data_segs_in, 1, "data_segs_in");
> >         ASSERT_EQ(result.data_segs_out, 1, "data_segs_out");
> >         ASSERT_EQ(result.bad_cb_test_rv, 0x80, "bad_cb_test_rv");
> >         ASSERT_EQ(result.good_cb_test_rv, 0, "good_cb_test_rv");
> > -       ASSERT_EQ(result.num_listen, 1, "num_listen");
> > -
> > -       /* 3 comes from one listening socket + both ends of the connection */
> > -       ASSERT_EQ(result.num_close_events, 3, "num_close_events");
> > +       ASSERT_EQ(result.num_listen_close, 1, "num_listen");
> > +       ASSERT_EQ(result.num_last_ack, 1, "num_last_ack");
> > +       ASSERT_EQ(result.num_fin_wait2, 1, "num_fin_wait2");
> >
> >         /* check setsockopt for SAVE_SYN */
> >         key = 0;
> > diff --git i/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c w/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
> > index 3e6912e4df3d..2c5ffb50d6e0 100644
> > --- i/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
> > +++ w/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
> > @@ -55,9 +55,11 @@ int bpf_testcb(struct bpf_sock_ops *skops)
> >  {
> >         char header[sizeof(struct ipv6hdr) + sizeof(struct tcphdr)];
> >         struct bpf_sock_ops *reuse = skops;
> > +       struct tcpbpf_globals *gp;
> >         struct tcphdr *thdr;
> >         int good_call_rv = 0;
> >         int bad_call_rv = 0;
> > +       __u32 key_zero = 0;
> >         int save_syn = 1;
> >         int rv = -1;
> >         int v = 0;
> > @@ -155,26 +157,21 @@ int bpf_testcb(struct bpf_sock_ops *skops)
> >         case BPF_SOCK_OPS_RETRANS_CB:
> >                 break;
> >         case BPF_SOCK_OPS_STATE_CB:
> > -               if (skops->args[1] == BPF_TCP_CLOSE) {
> > -                       __u32 key = 0;
> > -                       struct tcpbpf_globals g, *gp;
> > -
> > -                       gp = bpf_map_lookup_elem(&global_map, &key);
> > -                       if (!gp)
> > -                               break;
> > -                       g = *gp;
> > -                       if (skops->args[0] == BPF_TCP_LISTEN) {
> > -                               g.num_listen++;
> > -                       } else {
> > -                               g.total_retrans = skops->total_retrans;
> > -                               g.data_segs_in = skops->data_segs_in;
> > -                               g.data_segs_out = skops->data_segs_out;
> > -                               g.bytes_received = skops->bytes_received;
> > -                               g.bytes_acked = skops->bytes_acked;
> > -                       }
> > -                       g.num_close_events++;
> > -                       bpf_map_update_elem(&global_map, &key, &g,
> > -                                           BPF_ANY);
> > +               gp = bpf_map_lookup_elem(&global_map, &key_zero);
> > +               if (!gp)
> > +                       break;
> > +               if (skops->args[1] == BPF_TCP_CLOSE &&
> > +                   skops->args[0] == BPF_TCP_LISTEN) {
> > +                       gp->num_listen_close++;
> > +               } else if (skops->args[1] == BPF_TCP_LAST_ACK) {
> > +                       gp->total_retrans = skops->total_retrans;
> > +                       gp->data_segs_in = skops->data_segs_in;
> > +                       gp->data_segs_out = skops->data_segs_out;
> > +                       gp->bytes_received = skops->bytes_received;
> > +                       gp->bytes_acked = skops->bytes_acked;
> > +                       gp->num_last_ack++;
> > +               } else if (skops->args[1] == BPF_TCP_FIN_WAIT2) {
> > +                       gp->num_fin_wait2++;
I meant with the above change in "case BPF_SOCK_OPS_STATE_CB".
The retry-and-wait in tcpbpf_user.c can be avoided.

What may still be needed in tcpbpf_user.c is to use shutdown and
read-zero to ensure the sk has gone through those states before
calling verify_result().  Something like this [ uncompiled code again :) ]:

        /* Always send FIN from accept_fd first to
         * ensure it will go through FIN_WAIT_2.
         */
        shutdown(accept_fd, SHUT_WR);
        /* Ensure client_fd gets the FIN */
        err = read(client_fd, buf, sizeof(buf));
        if (CHECK(err != 0, "read-after-shutdown(client_fd):",
                  "err:%d errno:%d\n", err, errno))
                goto close_accept_fd;

        /* FIN sends from client_fd and it must be in LAST_ACK now */
        shutdown(client_fd, SHUT_WR);
        /* Ensure accept_fd gets the FIN-ACK.
         * accept_fd must have passed the FIN_WAIT2.
         */
        err = read(accept_fd, buf, sizeof(buf));
        if (CHECK(err != 0, "read-after-shutdown(accept_fd):",
                  "err:%d errno:%d\n", err, errno))
                goto close_accept_fd;

	close(server_fd);
	close(accept_fd);
	close(client_fd);

	/* All sk has gone through the states being tested.
	 * check the results now.
	 */
	verify_result(map_fd, sock_map_fd);

> >                 }
> >                 break;
> >         case BPF_SOCK_OPS_TCP_LISTEN_CB:
> > diff --git i/tools/testing/selftests/bpf/test_tcpbpf.h w/tools/testing/selftests/bpf/test_tcpbpf.h
> > index 6220b95cbd02..0dec324ba4a6 100644
> > --- i/tools/testing/selftests/bpf/test_tcpbpf.h
> > +++ w/tools/testing/selftests/bpf/test_tcpbpf.h
> > @@ -12,7 +12,8 @@ struct tcpbpf_globals {
> >         __u32 good_cb_test_rv;
> >         __u64 bytes_received;
> >         __u64 bytes_acked;
> > -       __u32 num_listen;
> > -       __u32 num_close_events;
> > +       __u32 num_listen_close;
> > +       __u32 num_last_ack;
> > +       __u32 num_fin_wait2;
> >  };
> >  #endif
> 
> I can look at pulling this in and including it as a patch 5 if you
> would prefer. If I find any issues I will let you know.
> 
> > I also noticed the bytes_received/acked depends on the order of close(),
> > i.e. always close the accepted fd first.  I think a comment
> > in the tcpbpf_user.c is good enough for now.
> 
> Okay, I can add a comment explaining this.
> 
> > [ It does not have to be in this set and it can be done in another
> >   follow up effort.
> >   Instead of using a bpf map to store the result, using global
> >   variables in test_tcpbpf_kern.c will simplify the code further. ]
> 
> I assume this comment is about the changes to test_tcpbpf_kern.c? Just
> want to clarify as I assume this isn't about adding the comment about
> the socket closing order affecting the bytes_received/acked.
Right, it is unrelated to the "adding the comment about socket closing order".
It is about changing test_tcpbpf_kern.c and tcpbpf_user.c to
use global variables instead of bpf map to store results.
Again, it can be done later.  This can be used as an example:
b18c1f0aa477 ("bpf: selftest: Adapt sock_fields test to use skel and global variables")
