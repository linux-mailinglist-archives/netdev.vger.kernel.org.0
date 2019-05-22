Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC9B02690F
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 19:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729687AbfEVR0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 13:26:08 -0400
Received: from mail-eopbgr770045.outbound.protection.outlook.com ([40.107.77.45]:9974
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727975AbfEVR0I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 13:26:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stackpath.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6s/sJpGBUlhqHyh9gvxTwYUh+sckAB9nGtYxEz44xw=;
 b=T7yfdhu8dtDHbc974DDw51WsXmkC6QzHYtVizu6XBsqCnW4fEyodr+RyZCwReyaUE/+DRG/e54CUo1c4JL4D4x2Gh0dTd4XEYUpSueG+Hc90nYlCh5orKK5krqjTvqnoorKnGwaye8dsHNCFb6IvaK+CcCHqZMHDitBCPagF+Nk=
Received: from BYAPR10MB2680.namprd10.prod.outlook.com (52.135.217.31) by
 BYAPR10MB3733.namprd10.prod.outlook.com (20.179.89.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Wed, 22 May 2019 17:26:01 +0000
Received: from BYAPR10MB2680.namprd10.prod.outlook.com
 ([fe80::ec8c:9c6a:c83f:43db]) by BYAPR10MB2680.namprd10.prod.outlook.com
 ([fe80::ec8c:9c6a:c83f:43db%7]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 17:26:01 +0000
From:   Matthew Cover <matthew.cover@stackpath.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Matthew Cover <werekraken@gmail.com>
Subject: Re: tc_classid access in skb bpf context
Thread-Topic: tc_classid access in skb bpf context
Thread-Index: AQHVEC09Nj6ajF14HkezzoiQKGhG0aZ20sYAgACPafc=
Date:   Wed, 22 May 2019 17:26:01 +0000
Message-ID: <BYAPR10MB268073D6667D2AB0E1699D5DE3000@BYAPR10MB2680.namprd10.prod.outlook.com>
References: <BYAPR10MB2680B63C684345098E6E7669E3070@BYAPR10MB2680.namprd10.prod.outlook.com>,<73d5b951-2598-0d7f-5b6e-8925cc61989a@iogearbox.net>
In-Reply-To: <73d5b951-2598-0d7f-5b6e-8925cc61989a@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=matthew.cover@stackpath.com; 
x-originating-ip: [24.56.44.135]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44b5ec34-9049-47ef-147c-08d6deda8fda
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR10MB3733;
x-ms-traffictypediagnostic: BYAPR10MB3733:
x-microsoft-antispam-prvs: <BYAPR10MB373313D0A8DA2554A9B30D41E3000@BYAPR10MB3733.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(39860400002)(346002)(366004)(396003)(376002)(136003)(199004)(189003)(25786009)(478600001)(256004)(6436002)(14444005)(5024004)(316002)(14454004)(9686003)(33656002)(2501003)(55016002)(305945005)(229853002)(53936002)(4326008)(6246003)(7736002)(66066001)(110136005)(476003)(2906002)(76116006)(73956011)(7696005)(81156014)(81166006)(66946007)(74316002)(66556008)(102836004)(71200400001)(99286004)(6506007)(52536014)(186003)(11346002)(446003)(44832011)(5660300002)(3846002)(2201001)(6116002)(8936002)(86362001)(26005)(76176011)(7416002)(8676002)(53546011)(71190400001)(68736007)(66476007)(66446008)(64756008)(486006)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR10MB3733;H:BYAPR10MB2680.namprd10.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: stackpath.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: R01wNtisO2j2WC1L5dnM+79+Aam+/G/qXD0ecLoeQlSb9C5+qxwDhnOR3oy9Y8mE5cw6rIhEq2V/e/eBLQZpEea+QS11VientiMBKHoj8DvTTE5wTX42BEM0uvt/06kHVSrcNobYFdUdwv9Mw2gApbJ1XDw5H5zsqZos8Xk/4bhJ/iBItJBoocNpcLIBIAY55R9ilf2HNOH51WemdKJnBztVl1GlWC+UHZ302xpReAvmL62bDJov5KkK7HrsObCCWHscGrWevpTFr/Wu6DY1o48yK/0qbpYwlRkl8wCNQ09bvtGN8C5MrXGca1G5u7VFMpFfTBYMXlv/GQzwdPyY+fpYWl7lKFjVQ/sTqgYmgumtVMwWUWe8I+p2UH9NBruKH/1Go9wWDqm8gfTfeYcVjx88NtG64N5LPkQFu49WjO0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: stackpath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44b5ec34-9049-47ef-147c-08d6deda8fda
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 17:26:01.4776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fd04f7e7-8712-48a5-bd2d-688fe1861f4b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3733
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05/22/2019 01:52 AM, Matthew Cover wrote:
> > __sk_buff has a member tc_classid which I'm interested in accessing fro=
m the skb bpf context.
> >=20
> > A bpf program which accesses skb->tc_classid compiles, but fails verifi=
cation; the specific failure is "invalid bpf_context access".
> >=20
> > if (skb->tc_classid !=3D 0)
> >=A0 return 1;
> > return 0;
> >=20
> > Some of the tests in tools/testing/selftests/bpf/verifier/ (those on tc=
_classid) further confirm that this is, in all likelihood, intentional beha=
vior.
> >=20
> > The very similar bpf program which instead accesses skb->mark works as =
desired.
> >=20
> > if (skb->mark !=3D 0)
> >=A0 return 1;
> > return 0;
>=20
> You should be able to access skb->tc_classid, perhaps you're using the wr=
ong program
> type? BPF_PROG_TYPE_SCHED_CLS is supposed to work (if not we'd have a reg=
ression).
>=20

I am in fact using BPF_PROG_TYPE_SOCKET_FILTER and using the program as PAC=
KET_FANOUT_DATA with PACKET_FANOUT_EBPF.

I have been working on a series of utils which leverage PACKET_FANOUT to pr=
ovide various per-socket-fd (per-cpu, per-queue, per-rx-flow-hash-indirecti=
on-table-idx) statistics and pcap files. While playing with PACKET_FANOUT_E=
BPF, I realized that I could use the bpf program to categorize packets in w=
ays packet-filter(7) does not provide.

As a concrete example, I plan to build a util `rxtxmark` which could be pas=
sed something like `--mark-list 42,88`. This would be translated to a bpf p=
rogram where the return code is the ordinality of the mark in the list.

if (skb->mark =3D=3D 42)
 return 1;
if (skb->mark =3D=3D 88)
 return 2;
return 0;

Packets enqueued to fd0 are simply ignored. Packets enqueued to the other f=
ds are processed into pcaps and statistics.

While I may build a util for tc_classid which does per-user-requested-class=
id pcaps and statistics like `rxtxmark` does for marks, I'm also interested=
 in using tc_classid as a simple way to capture tx packets from a long runn=
ing program on the fly.

The program under inspection would simply be added to a net_cls cgroup whic=
h has a unique classid defined. A bpf program would be attached to map pack=
ets with that classid to fd1. While I can do this already by using iptables=
 to translate the tc_classid to a mark, that complicates the implementation=
 greatly since the firewall has to be touched (which is probably overreachi=
ng for a packet capture util and would most likely be left to the user to c=
onfigure).

> > I built a kernel (v5.1) with 4 instances of the following line removed =
from net/core/filter.c to test the behavior when the instructions pass veri=
fication.
> >=20
> >=A0=A0=A0=A0 switch (off) {
> > -=A0=A0=A0 case bpf_ctx_range(struct __sk_buff, tc_classid):
> > ...
> >=A0=A0=A0=A0=A0=A0=A0=A0 return false;
> >=20
> > It appears skb->tc_classid is always zero within my bpf program, even w=
hen I verify by other means (e.g. netfilter) that the value is set non-zero=
.
> >=20
> > I gather that sk_buff proper sometimes (i.e. at some layers) has qdisc_=
skb_cb stored in skb->cb, but not always.
> >=20
> > I suspect that the tc_classid is available at l3 (and therefore to util=
s like netfilter, ip route, tc), but not at l2 (and not to AF_PACKET).
>=20
> From tc/BPF context you can use it; it's been long time, but I think back=
 then
> we mapped it into cb[] so it can be used within the BPF context to pass s=
kb data
> around e.g. between tail calls, and cls_bpf_classify() when in direct-act=
ion mode
> which likely everyone is/should-be using then maps that skb->tc_classid u=
16 cb[]
> value to res->classid on program return which then in either sch_handle_i=
ngress()
> or sch_handle_egress() is transferred into the skb->tc_index.
>=20

It sounds like just before the start of a BPF_PROG_TYPE_SCHED_CLS bpf progr=
am tc_classid id placed in skb->cb. The missing plumbing to support my use =
case is probably the same thing, but for BPF_PROG_TYPE_SOCKET_FILTER.

I'll see about familiarizing myself with both as time permits and perhaps I=
 can get tc_classid working for a BPF_PROG_TYPE_SOCKET_FILTER program; it c=
ertainly sounds like it's doable.

> > Is it impractical to make skb->tc_classid available in this bpf context=
 or is there just some plumbing which hasn't been connected yet?
> >=20
> > Is my suspicion that skb->cb no longer contains qdisc_skb_cb due to cro=
ssing a layer boundary well founded?
> >=20
> > I'm willing to look into hooking things together as time permits if it'=
s a feasible task.
> >=20
> > It's trivial to have iptables match on tc_classid and set a mark which =
is available to bpf at l2, but I'd like to better understand this.
> >=20
> > Thanks,
> > Matt C.
> >=20

    =
