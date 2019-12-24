Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0B8129C6B
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 02:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbfLXBcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 20:32:03 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29448 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726995AbfLXBcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 20:32:03 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBO1VZUZ010041;
        Mon, 23 Dec 2019 17:31:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ff811f6cCNWdoMOqg0MYSQiZ5LrtI+lrzuFX9tShtOA=;
 b=Amy/n0ITUnuKD2dF3H4c7JFO0icTHeVvu1862ZWyPdS+D3ByxmftuzmWE8OZzqLtvga9
 mt6ygJAtS6IJSgOObq319+k1EvWMKtHvbWGW8pla3EOm46q77P4mSUW4rAC516nHeq1M
 AeujOw5PLzTbW8jrFUgDSgD+Y5NWU0q0Ckk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2x23tvpv2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 23 Dec 2019 17:31:47 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 23 Dec 2019 17:31:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hBC0AnJHGJ5fi7tTm9k7B0P8+2Rndul7NuTAN0mL+B90rQI7AQlsDWqPCSyH45wtaMd+5jvxQSjIDFg9ppHpMkonpntw2lr5XZZGTjEiAGKYGWIiUVGVkRTuMUcwql9W3LPZIYj3XdelTDceTz7Szp1DhdxN7RiBtdSF6FmNe7O3hxGmwht3Ln4DoPP1QHAMcSpHVfdmD9pQf/KUfIUpug3Qp3ZuaNyB7xBPv1VlZ4COvI6BxnzrntzFpCYJaRWDK8zWHtkHKduxa6e/iHIT7s2l9t33mzXZE3XpqvJ+8j188Pw13a9O/tP6126cNeyXRj1EDgiM8Fwf1jgQmd64Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ff811f6cCNWdoMOqg0MYSQiZ5LrtI+lrzuFX9tShtOA=;
 b=nw0KbDTc3DODQcttqN5ejM69qNFYvx1p/Pu/URAllg2Lesw4Hp5GZUExRLuR1ElCWXZv87HDXSuYGjWRafrV7YjXOAy9Dw2vmkp84/DPIO+Oz/tlsLLo878lk/vBoE/3QR1ND3j5Kz79BgZNJv8noVRvpX3OxwPixahLkBKKDj/JvZZz3tbyDveHs2MMKOLekop6fNl2u56wprpw/uMoXXKPiK8TfFCA8ibQG0j1qXKz/evznovNUXM4s5OxaiINEvgi0q5/CL5A1cLDIHMMOGZR6T1PjjFpjkHvyb5xoQ5OwTd+hLBc3aPByNxC/mTrceiXY0rzwtMo4vuQ5levdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ff811f6cCNWdoMOqg0MYSQiZ5LrtI+lrzuFX9tShtOA=;
 b=M1svhuAvR2Ytd51F0GCvWYykS0tpufJ+OsNf3iSLfn8W+aFNVVMnQZfGo2qhE8oj9Unf2fTlTsPwyvmiMuosl9rRJv/DKutPkz5HhpjzJhpS6cJFy/b0G6AZyzvi6dAoirUDf7m1yIwHM66A9od1tqpGvjBMrJir1BSsBH9eoOM=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2528.namprd15.prod.outlook.com (20.179.146.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.15; Tue, 24 Dec 2019 01:31:45 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2559.017; Tue, 24 Dec 2019
 01:31:45 +0000
Received: from kafai-mbp (2620:10d:c090:180::1b82) by MWHPR14CA0005.namprd14.prod.outlook.com (2603:10b6:300:ae::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.14 via Frontend Transport; Tue, 24 Dec 2019 01:31:43 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 11/11] bpf: Add bpf_dctcp example
Thread-Topic: [PATCH bpf-next v2 11/11] bpf: Add bpf_dctcp example
Thread-Index: AQHVueh9eJgyi9Vd8EqEIu9FcYh4uKfIf/YA
Date:   Tue, 24 Dec 2019 01:31:44 +0000
Message-ID: <20191224013140.ibn33unj77mtbkne@kafai-mbp>
References: <20191221062556.1182261-1-kafai@fb.com>
 <20191221062620.1184118-1-kafai@fb.com>
 <CAEf4BzZX_TNUXJktJUtqmxgMefDzie=Ta18TbBqBhG0-GSLQMg@mail.gmail.com>
In-Reply-To: <CAEf4BzZX_TNUXJktJUtqmxgMefDzie=Ta18TbBqBhG0-GSLQMg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0005.namprd14.prod.outlook.com
 (2603:10b6:300:ae::15) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1b82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2e2c780-d095-4713-b1a3-08d7881108fc
x-ms-traffictypediagnostic: MN2PR15MB2528:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2528BC346C7471C40FE77903D5290@MN2PR15MB2528.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0261CCEEDF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(136003)(346002)(39860400002)(396003)(189003)(199004)(66446008)(1076003)(66946007)(86362001)(2906002)(316002)(4326008)(186003)(55016002)(33716001)(54906003)(66476007)(66556008)(64756008)(16526019)(9686003)(6916009)(6496006)(5660300002)(52116002)(478600001)(81156014)(8676002)(71200400001)(8936002)(81166006)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2528;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6jJYYxz4G3JQ3Kead+TbLhcggo4hJgxVzA3DHWhISzUc1zTW+rWd9Q0LC08XUPoxVBFU8Fihbx2jXhmpJYSFkDv/lUaB/OyyInt8kHTiPLICkcM5rWoH7qKLF77idrHQ6+XPB7rUlFnH90kU6Suc3yueltnAvwAwSJLPWm+B+3iOP2mvBh4o/MmLl1RFtiUaD76kaBcGtb3prnt2pxxTT/LP0xmxOqZKCr93HKfrnzeVbylLy/45dnRmJhXZEDXyxBaHcWZFhwEc8gJpMVpT5OqdhN3YVWLyMVvxM+kqy5GVra/h9gxylqSwWTuuKD4BN645HzoA1FkkB4FhFJTCFZHxpDDJEvk4Ap5pdNOGUCJYeoGnkHoTivfMiQ+02MM7QomPTeeWUH3nWw1hvQpGCgVeLTWK7GkzSAJJzJZ/Q/+07q0Mlk1cUa/FDeudONtY
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FF39A6F816D8E7439776463B24250D37@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f2e2c780-d095-4713-b1a3-08d7881108fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2019 01:31:44.5352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nGd/sKgd6W/8tBNNYGgoaXTezTxXIKLq8oyuxbne4fhiHQqzKo6u4bC0pGmvlfik
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2528
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_10:2019-12-23,2019-12-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 phishscore=0 adultscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912240010
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 03:26:50PM -0800, Andrii Nakryiko wrote:
> On Fri, Dec 20, 2019 at 10:26 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This patch adds a bpf_dctcp example.  It currently does not do
> > no-ECN fallback but the same could be done through the cgrp2-bpf.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  tools/testing/selftests/bpf/bpf_tcp_helpers.h | 228 ++++++++++++++++++
> >  .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 218 +++++++++++++++++
> >  tools/testing/selftests/bpf/progs/bpf_dctcp.c | 210 ++++++++++++++++
> >  3 files changed, 656 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/bpf_tcp_helpers.h
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/bpf_dctcp.c
> >
> > diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/test=
ing/selftests/bpf/bpf_tcp_helpers.h
> > new file mode 100644
> > index 000000000000..7ba8c1b4157a
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > @@ -0,0 +1,228 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef __BPF_TCP_HELPERS_H
> > +#define __BPF_TCP_HELPERS_H
> > +
> > +#include <stdbool.h>
> > +#include <linux/types.h>
> > +#include <bpf_helpers.h>
> > +#include <bpf_core_read.h>
> > +#include "bpf_trace_helpers.h"
> > +
> > +#define BPF_TCP_OPS_0(fname, ret_type, ...) BPF_TRACE_x(0, #fname"_sec=
", fname, ret_type, __VA_ARGS__)
> > +#define BPF_TCP_OPS_1(fname, ret_type, ...) BPF_TRACE_x(1, #fname"_sec=
", fname, ret_type, __VA_ARGS__)
> > +#define BPF_TCP_OPS_2(fname, ret_type, ...) BPF_TRACE_x(2, #fname"_sec=
", fname, ret_type, __VA_ARGS__)
> > +#define BPF_TCP_OPS_3(fname, ret_type, ...) BPF_TRACE_x(3, #fname"_sec=
", fname, ret_type, __VA_ARGS__)
> > +#define BPF_TCP_OPS_4(fname, ret_type, ...) BPF_TRACE_x(4, #fname"_sec=
", fname, ret_type, __VA_ARGS__)
> > +#define BPF_TCP_OPS_5(fname, ret_type, ...) BPF_TRACE_x(5, #fname"_sec=
", fname, ret_type, __VA_ARGS__)
>=20
> Should we try to put those BPF programs into some section that would
> indicate they are used with struct opts? libbpf doesn't use or enforce
> that (even though it could to derive and enforce that they are
> STRUCT_OPS programs). So something like
> SEC("struct_ops/<ideally-operation-name-here>"). I think having this
> convention is very useful for consistency and to do a quick ELF dump
> and see what is where. WDYT?
I did not use it here because I don't want any misperception that it is
a required convention by libbpf.

Sure, I can prefix it here and comment that it is just a
convention but not a libbpf's requirement.

>=20
> > +
> > +struct sock_common {
> > +       unsigned char   skc_state;
> > +} __attribute__((preserve_access_index));
> > +
> > +struct sock {
> > +       struct sock_common      __sk_common;
> > +} __attribute__((preserve_access_index));
> > +
> > +struct inet_sock {
> > +       struct sock             sk;
> > +} __attribute__((preserve_access_index));
> > +
> > +struct inet_connection_sock {
> > +       struct inet_sock          icsk_inet;
> > +       __u8                      icsk_ca_state:6,
> > +                                 icsk_ca_setsockopt:1,
> > +                                 icsk_ca_dst_locked:1;
> > +       struct {
> > +               __u8              pending;
> > +       } icsk_ack;
> > +       __u64                     icsk_ca_priv[104 / sizeof(__u64)];
> > +} __attribute__((preserve_access_index));
> > +
> > +struct tcp_sock {
> > +       struct inet_connection_sock     inet_conn;
> > +
> > +       __u32   rcv_nxt;
> > +       __u32   snd_nxt;
> > +       __u32   snd_una;
> > +       __u8    ecn_flags;
> > +       __u32   delivered;
> > +       __u32   delivered_ce;
> > +       __u32   snd_cwnd;
> > +       __u32   snd_cwnd_cnt;
> > +       __u32   snd_cwnd_clamp;
> > +       __u32   snd_ssthresh;
> > +       __u8    syn_data:1,     /* SYN includes data */
> > +               syn_fastopen:1, /* SYN includes Fast Open option */
> > +               syn_fastopen_exp:1,/* SYN includes Fast Open exp. optio=
n */
> > +               syn_fastopen_ch:1, /* Active TFO re-enabling probe */
> > +               syn_data_acked:1,/* data in SYN is acked by SYN-ACK */
> > +               save_syn:1,     /* Save headers of SYN packet */
> > +               is_cwnd_limited:1,/* forward progress limited by snd_cw=
nd? */
> > +               syn_smc:1;      /* SYN includes SMC */
> > +       __u32   max_packets_out;
> > +       __u32   lsndtime;
> > +       __u32   prior_cwnd;
> > +} __attribute__((preserve_access_index));
> > +
> > +static __always_inline struct inet_connection_sock *inet_csk(const str=
uct sock *sk)
> > +{
> > +       return (struct inet_connection_sock *)sk;
> > +}
> > +
> > +static __always_inline void *inet_csk_ca(const struct sock *sk)
> > +{
> > +       return (void *)inet_csk(sk)->icsk_ca_priv;
> > +}
> > +
> > +static __always_inline struct tcp_sock *tcp_sk(const struct sock *sk)
> > +{
> > +       return (struct tcp_sock *)sk;
> > +}
> > +
> > +static __always_inline bool before(__u32 seq1, __u32 seq2)
> > +{
> > +       return (__s32)(seq1-seq2) < 0;
> > +}
> > +#define after(seq2, seq1)      before(seq1, seq2)
> > +
> > +#define        TCP_ECN_OK              1
> > +#define        TCP_ECN_QUEUE_CWR       2
> > +#define        TCP_ECN_DEMAND_CWR      4
> > +#define        TCP_ECN_SEEN            8
> > +
> > +enum inet_csk_ack_state_t {
> > +       ICSK_ACK_SCHED  =3D 1,
> > +       ICSK_ACK_TIMER  =3D 2,
> > +       ICSK_ACK_PUSHED =3D 4,
> > +       ICSK_ACK_PUSHED2 =3D 8,
> > +       ICSK_ACK_NOW =3D 16       /* Send the next ACK immediately (onc=
e) */
> > +};
> > +
> > +enum tcp_ca_event {
> > +       CA_EVENT_TX_START =3D 0,
> > +       CA_EVENT_CWND_RESTART =3D 1,
> > +       CA_EVENT_COMPLETE_CWR =3D 2,
> > +       CA_EVENT_LOSS =3D 3,
> > +       CA_EVENT_ECN_NO_CE =3D 4,
> > +       CA_EVENT_ECN_IS_CE =3D 5,
> > +};
> > +
> > +enum tcp_ca_state {
> > +       TCP_CA_Open =3D 0,
> > +       TCP_CA_Disorder =3D 1,
> > +       TCP_CA_CWR =3D 2,
> > +       TCP_CA_Recovery =3D 3,
> > +       TCP_CA_Loss =3D 4
> > +};
> > +
> > +struct ack_sample {
> > +       __u32 pkts_acked;
> > +       __s32 rtt_us;
> > +       __u32 in_flight;
> > +} __attribute__((preserve_access_index));
> > +
> > +struct rate_sample {
> > +       __u64  prior_mstamp; /* starting timestamp for interval */
> > +       __u32  prior_delivered; /* tp->delivered at "prior_mstamp" */
> > +       __s32  delivered;               /* number of packets delivered =
over interval */
> > +       long interval_us;       /* time for tp->delivered to incr "deli=
vered" */
> > +       __u32 snd_interval_us;  /* snd interval for delivered packets *=
/
> > +       __u32 rcv_interval_us;  /* rcv interval for delivered packets *=
/
> > +       long rtt_us;            /* RTT of last (S)ACKed packet (or -1) =
*/
> > +       int  losses;            /* number of packets marked lost upon A=
CK */
> > +       __u32  acked_sacked;    /* number of packets newly (S)ACKed upo=
n ACK */
> > +       __u32  prior_in_flight; /* in flight before this ACK */
> > +       bool is_app_limited;    /* is sample from packet with bubble in=
 pipe? */
> > +       bool is_retrans;        /* is sample from retransmission? */
> > +       bool is_ack_delayed;    /* is this (likely) a delayed ACK? */
> > +} __attribute__((preserve_access_index));
> > +
> > +#define TCP_CA_NAME_MAX                16
> > +#define TCP_CONG_NEEDS_ECN     0x2
> > +
> > +struct tcp_congestion_ops {
> > +       __u32 flags;
> > +
> > +       /* initialize private data (optional) */
> > +       void (*init)(struct sock *sk);
> > +       /* cleanup private data  (optional) */
> > +       void (*release)(struct sock *sk);
> > +
> > +       /* return slow start threshold (required) */
> > +       __u32 (*ssthresh)(struct sock *sk);
> > +       /* do new cwnd calculation (required) */
> > +       void (*cong_avoid)(struct sock *sk, __u32 ack, __u32 acked);
> > +       /* call before changing ca_state (optional) */
> > +       void (*set_state)(struct sock *sk, __u8 new_state);
> > +       /* call when cwnd event occurs (optional) */
> > +       void (*cwnd_event)(struct sock *sk, enum tcp_ca_event ev);
> > +       /* call when ack arrives (optional) */
> > +       void (*in_ack_event)(struct sock *sk, __u32 flags);
> > +       /* new value of cwnd after loss (required) */
> > +       __u32  (*undo_cwnd)(struct sock *sk);
> > +       /* hook for packet ack accounting (optional) */
> > +       void (*pkts_acked)(struct sock *sk, const struct ack_sample *sa=
mple);
> > +       /* override sysctl_tcp_min_tso_segs */
> > +       __u32 (*min_tso_segs)(struct sock *sk);
> > +       /* returns the multiplier used in tcp_sndbuf_expand (optional) =
*/
> > +       __u32 (*sndbuf_expand)(struct sock *sk);
> > +       /* call when packets are delivered to update cwnd and pacing ra=
te,
> > +        * after all the ca_state processing. (optional)
> > +        */
> > +       void (*cong_control)(struct sock *sk, const struct rate_sample =
*rs);
> > +
> > +       char            name[TCP_CA_NAME_MAX];
> > +};
>=20
> Can all of these types come from vmlinux.h instead of being duplicated he=
re?
It can but I prefer leaving it as is in bpf_tcp_helpers.h like another
existing test in kfree_skb.c.  Without directly using the same struct in
vmlinux.h,  I think it is a good test for libbpf.
That remind me to shuffle the member ordering a little in tcp_congestion_op=
s
here.

>=20
> > +
> > +#define min(a, b) ((a) < (b) ? (a) : (b))
> > +#define max(a, b) ((a) > (b) ? (a) : (b))
> > +#define min_not_zero(x, y) ({                  \
> > +       typeof(x) __x =3D (x);                    \
> > +       typeof(y) __y =3D (y);                    \
> > +       __x =3D=3D 0 ? __y : ((__y =3D=3D 0) ? __x : min(__x, __y)); })
> > +
>=20
> [...]
>=20
> > +static struct bpf_object *load(const char *filename, const char *map_n=
ame,
> > +                              struct bpf_link **link)
> > +{
> > +       struct bpf_object *obj;
> > +       struct bpf_map *map;
> > +       struct bpf_link *l;
> > +       int err;
> > +
> > +       obj =3D bpf_object__open(filename);
> > +       if (CHECK(IS_ERR(obj), "bpf_obj__open_file", "obj:%ld\n",
> > +                 PTR_ERR(obj)))
> > +               return obj;
> > +
> > +       err =3D bpf_object__load(obj);
> > +       if (CHECK(err, "bpf_object__load", "err:%d\n", err)) {
> > +               bpf_object__close(obj);
> > +               return ERR_PTR(err);
> > +       }
> > +
> > +       map =3D bpf_object__find_map_by_name(obj, map_name);
> > +       if (CHECK(!map, "bpf_object__find_map_by_name", "%s not found\n=
",
> > +                   map_name)) {
> > +               bpf_object__close(obj);
> > +               return ERR_PTR(-ENOENT);
> > +       }
> > +
>=20
> use skeleton instead?
Will give it a spin.

>=20
> > +       l =3D bpf_map__attach_struct_ops(map);
> > +       if (CHECK(IS_ERR(l), "bpf_struct_ops_map__attach", "err:%ld\n",
> > +                 PTR_ERR(l))) {
> > +               bpf_object__close(obj);
> > +               return (void *)l;
> > +       }
> > +
> > +       *link =3D l;
> > +
> > +       return obj;
> > +}
> > +
