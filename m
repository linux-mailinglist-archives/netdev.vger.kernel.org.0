Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022F92A39F9
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgKCBlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:41:15 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23284 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726312AbgKCBlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 20:41:14 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A31dXdv007578;
        Mon, 2 Nov 2020 17:40:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=0saafE4fmYCGnbZMkpL+POmEwWA0qFmFuwReIuYEkVU=;
 b=hnZ4VGr0izvraf8p2RfiQPnIc9xWdB2loaSVzX74ke4FKuFeDoVRgKvaRZv6r5Hh+NQS
 AhrIJt/8CkL+Elj0ZUgmkyuYZWvbn8ZYddb2HR9s3IW1wS5YY+c1U+RtUSvRrSvd26f2
 2wq/DdGYjYuGuDS4+sRBdoJ2bjVZCIGWuEU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34h5rfk8k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Nov 2020 17:40:53 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 2 Nov 2020 17:40:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OlIixUWvIAezg7rzVbHXaRZI5gzBlYG+ith2pT5nTh7S0gZ+mt4Tg5tRd7l4RanaecPTjQ1Rss8t0IS+Vrr7+hHXDeRk+4cr6vHoPwfqVnoXySJSn7gs8BR/sex12qe51nVY2xiMzMgVN+zISUgupkpv5HMiL0WtR6Ka7AqAhr9MuL+cUVDQ3Fr3cs4MohN+ePV66mrFQ+w785goDW+2z6im04w0Kez1KeE2zRMIChb3SnFzXk6rFKHVtoqK9s4LbB5WDRzEIszloZYFtIZDQEjOBLifSH+LDDzNKRXX8JZ4nG+L2y3PiDRmySOOfQKAwn2vK3YX7X2IDQpcdWFnUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0saafE4fmYCGnbZMkpL+POmEwWA0qFmFuwReIuYEkVU=;
 b=FYYBCNfx81z7livoiw4a2uJ37DvKttR5uZHfTBQP6XyTTrlp+Ro1JeBA7P8EF5rNMmSR1WIazq5TjIJxrKS0XQk8RoTmeVsQyEVNZ56t4S/3g3KHMnitX8PSNuhe42kn8UzcNl3mju0C04VybYtjKDsxyQJPD+5vjAtA60HkG3M9BJZIoKwbFKMitn5x97HK+pO9IRyewAOwd14bezlDV0kzddRxLEhMdcAyYjRoRfg3kfORmAGAFJI7+cH7xr4M194C7iLbbbtzupXOEAo4R6IS5OKuj4MDqwKOkyeLdac7wxh+1uepxgio6ponFzyxxU4VllhuDU8H+VEqlLq1mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0saafE4fmYCGnbZMkpL+POmEwWA0qFmFuwReIuYEkVU=;
 b=k+Xmcfr4Bkv8ECNNVl+ZJLwOLk5bjiF0PJr3exQRw0P/GcO+/n1rR/kJdp0IBCA6hHZLFgQ63LN6IWtw8emn9TtzOahiIH9K5IPYc84+DNhbBek/CeyZvdoDjOLEVbiK28bMF1Y1O+yEjHY1apBmC/RxWDAvOxTd20hqi6S1SYI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2246.namprd15.prod.outlook.com (2603:10b6:a02:8d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Tue, 3 Nov
 2020 01:40:51 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 01:40:51 +0000
Date:   Mon, 2 Nov 2020 17:40:44 -0800
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
Subject: Re: [bpf-next PATCH v2 3/5] selftests/bpf: Replace EXPECT_EQ with
 ASSERT_EQ and refactor verify_results
Message-ID: <20201103013727.l24s7cveuxmpjuvb@kafai-mbp.dhcp.thefacebook.com>
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
 <160417034457.2823.10600750891200038944.stgit@localhost.localdomain>
 <20201103004205.qbyabntlc4yl5vwn@kafai-mbp.dhcp.thefacebook.com>
 <CAKgT0Uec9rUxych344UKFF5J1p4aMp3GWfudZ3-mxRq+fqEyNQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Uec9rUxych344UKFF5J1p4aMp3GWfudZ3-mxRq+fqEyNQ@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:8aa6]
X-ClientProxiedBy: CO2PR04CA0135.namprd04.prod.outlook.com (2603:10b6:104::13)
 To BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:8aa6) by CO2PR04CA0135.namprd04.prod.outlook.com (2603:10b6:104::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 3 Nov 2020 01:40:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 948ad8e1-da04-4143-8232-08d87f997f03
X-MS-TrafficTypeDiagnostic: BYAPR15MB2246:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB22464E75BF0500B07BA83D3ED5110@BYAPR15MB2246.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SwiS1cJ5KADM9GsUoHHgUcqGmkb76VkXBq0aOvrHV4J6PUxaEEvjevXR4mfqebDhigGAN9TOYnl5acC6QTw4B+HMId9nqm2Acx+h2eY2MAhoLn1a8DcCZH/062iNEevIT60bIACItv3bEiViYcu5vImnVcELJ/C7zdsb2/ssgPkEdr8WFUBZ25steBdaBSYc/fFBV+BQUNvodIZ0PABlGR7qF5iC4w3BGbIXdok+U8BNp/5cAf3bNnD+KttaPJ0tOra+FeCdFqGANyY4/lwKO17868Mqfzk/G6j9Dj+3CrZgQcuLp1+xhjheuFvWq3/sNY6HsaA03joZzePPDbLZew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(346002)(136003)(376002)(4326008)(55016002)(5660300002)(54906003)(66946007)(66556008)(66476007)(478600001)(2906002)(6666004)(83380400001)(15650500001)(316002)(1076003)(8676002)(16526019)(6916009)(9686003)(6506007)(52116002)(53546011)(8936002)(7696005)(186003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: qtVOEzBMl7yKTOt+2CHhSEJq9F5/ertEdPVzYRfgYb/wWIUOGfNSSVXL6Ak+Wt5H6wzVGe4MqvHh+Sl+EvYcT0jxdNTqXcnKy+78NmZ6RAyPvasZeu254dmcIsKdnvonp5ABD9z62bZxugsk+NVGtcFkYtXnZiQzLMTx72No6z/9dT4jL1a2pQ+2CMPED4BBNv3Hxx8VUdgUuknDQHahsoFelIF0rXcQT+PiP1zp1JyGhL66yuGufOME/tY74RVAmqbyZ97uUKzrdnpCBC3MUfaFsfxu7g2dY2mMDDL6k24TDV/Xq5AvBijkEfVOcKGsSi/TF2MfWXD9EUenfG4gzQRi+EoSZkVivDHCXjaSuwpxreonVKrF/EJPKqfo4Dn3cfLAR57Jl2ef+Swb330XpY/1GT/oBoSD9FvL3vFuYpw/LPuH/ayHyxrw16p7ceIpWvXyX0it8ZmJDjv0c8JcmrwRl38jTwIn05AlFdmntOr719VaKx2YBdje4Z+zTOVvD6XLZAgf5eAkXhCYGIcb14WL7LkP2A8J4xvcj0S9Aohf3h22wBaoacT7MhCI3d2cWwcCQwK3WpfgYsXE6LzytoLLTVguLZW/duBXh8K8SJOjKlpaIIAf0RhI1jF9AkW1ehlTfIKAJUevVxgl8NKX0gJFTASnudf0mvkL+lJsWQtOAJCCmxwZCklxk86Nzrrw
X-MS-Exchange-CrossTenant-Network-Message-Id: 948ad8e1-da04-4143-8232-08d87f997f03
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 01:40:51.2364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: btddXyQQcPfcMLjOOzKt6IgLeo6NGtcJ1n4aEVE1A57Iwma9ScC8JnZj5p9T+iw0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2246
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_16:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 phishscore=0 malwarescore=0 suspectscore=1 bulkscore=0
 spamscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011030008
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 04:56:37PM -0800, Alexander Duyck wrote:
> On Mon, Nov 2, 2020 at 4:42 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Sat, Oct 31, 2020 at 11:52:24AM -0700, Alexander Duyck wrote:
> > > From: Alexander Duyck <alexanderduyck@fb.com>
> > >
> > > There is already logic in test_progs.h for asserting that a value is
> > > expected to be another value. So instead of reinventing it we should just
> > > make use of ASSERT_EQ in tcpbpf_user.c. This will allow for better
> > > debugging and integrates much more closely with the test_progs framework.
> > >
> > > In addition we can refactor the code a bit to merge together the two
> > > verify functions and tie them together into a single function. Doing this
> > > helps to clean the code up a bit and makes it more readable as all the
> > > verification is now done in one function.
> > >
> > > Lastly we can relocate the verification to the end of the run_test since it
> > > is logically part of the test itself. With this we can drop the need for a
> > > return value from run_test since verification becomes the last step of the
> > > call and then immediately following is the tear down of the test setup.
> > >
> > > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> > Acked-by: Martin KaFai Lau <kafai@fb.com>
> 
> Thanks for the review.
> 
> > > ---
> > >  .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |  114 ++++++++------------
> > >  1 file changed, 44 insertions(+), 70 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > > index 17d4299435df..d96f4084d2f5 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > > @@ -10,66 +10,58 @@
> > >
> > >  static __u32 duration;
> > >
> > > -#define EXPECT_EQ(expected, actual, fmt)                     \
> > > -     do {                                                    \
> > > -             if ((expected) != (actual)) {                   \
> > > -                     fprintf(stderr, "  Value of: " #actual "\n"     \
> > > -                            "    Actual: %" fmt "\n"         \
> > > -                            "  Expected: %" fmt "\n",        \
> > > -                            (actual), (expected));           \
> > > -                     ret--;                                  \
> > > -             }                                               \
> > > -     } while (0)
> > > -
> > > -int verify_result(const struct tcpbpf_globals *result)
> > > -{
> > > -     __u32 expected_events;
> > > -     int ret = 0;
> > > -
> > > -     expected_events = ((1 << BPF_SOCK_OPS_TIMEOUT_INIT) |
> > > -                        (1 << BPF_SOCK_OPS_RWND_INIT) |
> > > -                        (1 << BPF_SOCK_OPS_TCP_CONNECT_CB) |
> > > -                        (1 << BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB) |
> > > -                        (1 << BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB) |
> > > -                        (1 << BPF_SOCK_OPS_NEEDS_ECN) |
> > > -                        (1 << BPF_SOCK_OPS_STATE_CB) |
> > > -                        (1 << BPF_SOCK_OPS_TCP_LISTEN_CB));
> > > -
> > > -     EXPECT_EQ(expected_events, result->event_map, "#" PRIx32);
> > > -     EXPECT_EQ(501ULL, result->bytes_received, "llu");
> > > -     EXPECT_EQ(1002ULL, result->bytes_acked, "llu");
> > > -     EXPECT_EQ(1, result->data_segs_in, PRIu32);
> > > -     EXPECT_EQ(1, result->data_segs_out, PRIu32);
> > > -     EXPECT_EQ(0x80, result->bad_cb_test_rv, PRIu32);
> > > -     EXPECT_EQ(0, result->good_cb_test_rv, PRIu32);
> > > -     EXPECT_EQ(1, result->num_listen, PRIu32);
> > > -
> > > -     /* 3 comes from one listening socket + both ends of the connection */
> > > -     EXPECT_EQ(3, result->num_close_events, PRIu32);
> > > -
> > > -     return ret;
> > > -}
> > > -
> > > -int verify_sockopt_result(int sock_map_fd)
> > > +static void verify_result(int map_fd, int sock_map_fd)
> > >  {
> > > +     __u32 expected_events = ((1 << BPF_SOCK_OPS_TIMEOUT_INIT) |
> > > +                              (1 << BPF_SOCK_OPS_RWND_INIT) |
> > > +                              (1 << BPF_SOCK_OPS_TCP_CONNECT_CB) |
> > > +                              (1 << BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB) |
> > > +                              (1 << BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB) |
> > > +                              (1 << BPF_SOCK_OPS_NEEDS_ECN) |
> > > +                              (1 << BPF_SOCK_OPS_STATE_CB) |
> > > +                              (1 << BPF_SOCK_OPS_TCP_LISTEN_CB));
> > > +     struct tcpbpf_globals result = { 0 };
> > nit. init is not needed.
> 
> I had copied/pasted it from the original code that was defining this.
> If a v3 is needed I can drop the initialization.
> 
> > >       __u32 key = 0;
> > > -     int ret = 0;
> > >       int res;
> > >       int rv;
> > >
> > > +     rv = bpf_map_lookup_elem(map_fd, &key, &result);
> > > +     if (CHECK(rv, "bpf_map_lookup_elem(map_fd)", "err:%d errno:%d",
> > > +               rv, errno))
> > > +             return;
> > > +
> > > +     /* check global map */
> > > +     CHECK(expected_events != result.event_map, "event_map",
> > > +           "unexpected event_map: actual %#" PRIx32" != expected %#" PRIx32 "\n",
> > > +           result.event_map, expected_events);
> > > +
> > > +     ASSERT_EQ(result.bytes_received, 501, "bytes_received");
> > > +     ASSERT_EQ(result.bytes_acked, 1002, "bytes_acked");
> > > +     ASSERT_EQ(result.data_segs_in, 1, "data_segs_in");
> > > +     ASSERT_EQ(result.data_segs_out, 1, "data_segs_out");
> > > +     ASSERT_EQ(result.bad_cb_test_rv, 0x80, "bad_cb_test_rv");
> > > +     ASSERT_EQ(result.good_cb_test_rv, 0, "good_cb_test_rv");
> > > +     ASSERT_EQ(result.num_listen, 1, "num_listen");
> > > +
> > > +     /* 3 comes from one listening socket + both ends of the connection */
> > > +     ASSERT_EQ(result.num_close_events, 3, "num_close_events");
> > > +
> > >       /* check setsockopt for SAVE_SYN */
> > > +     key = 0;
> > nit. not needed.
> 
> I assume you mean it is redundant since it was initialized to 0 when
> we declared key in the first place?
Correct.

My eariler comment in this patch can be ignored.  I just noticed that this
will go away in the last patch.

I was nit-picking a little here because people will copy-and-paste codes
from selftests.  just don't want to give a wrong impression that
those are necessary for calling bpf_map_lookup_elem().

> 
> > >       rv = bpf_map_lookup_elem(sock_map_fd, &key, &res);
> > > -     EXPECT_EQ(0, rv, "d");
> > > -     EXPECT_EQ(0, res, "d");
> > > -     key = 1;
> > > +     CHECK(rv, "bpf_map_lookup_elem(sock_map_fd)", "err:%d errno:%d",
> > > +           rv, errno);
> > > +     ASSERT_EQ(res, 0, "bpf_setsockopt(TCP_SAVE_SYN)");
> > > +
> > >       /* check getsockopt for SAVED_SYN */
> > > +     key = 1;
> > >       rv = bpf_map_lookup_elem(sock_map_fd, &key, &res);
> > > -     EXPECT_EQ(0, rv, "d");
> > > -     EXPECT_EQ(1, res, "d");
> > > -     return ret;
> > > +     CHECK(rv, "bpf_map_lookup_elem(sock_map_fd)", "err:%d errno:%d",
> > > +           rv, errno);
> > > +     ASSERT_EQ(res, 1, "bpf_getsockopt(TCP_SAVED_SYN)");
> > >  }
