Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71BB92719D
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 23:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729721AbfEVV2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 17:28:32 -0400
Received: from mail-eopbgr810088.outbound.protection.outlook.com ([40.107.81.88]:39647
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728761AbfEVV2c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 17:28:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stackpath.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OD4D3biz7wnYPAi2MCBX/MrJb7+Epkb2H8kSBC8X67A=;
 b=TeKjVeCos7BpD3c2wXGssewI+sThXTRPZyULy1eftPS/5WcedrTib+RG4+ofjNiMZducVG/dvBFiIcHh8+S14EORIZlrnQlNnhJGmcrsNM9XVtMBjwvrRpAGtup0RU/4Rmlq081J3UaS34oGnPRpLjXww0U/+nGkOc2hvFG1sLw=
Received: from BYAPR10MB2680.namprd10.prod.outlook.com (52.135.217.31) by
 BYAPR10MB3061.namprd10.prod.outlook.com (20.177.224.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Wed, 22 May 2019 21:28:28 +0000
Received: from BYAPR10MB2680.namprd10.prod.outlook.com
 ([fe80::ec8c:9c6a:c83f:43db]) by BYAPR10MB2680.namprd10.prod.outlook.com
 ([fe80::ec8c:9c6a:c83f:43db%7]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 21:28:28 +0000
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
Thread-Index: AQHVEC09Nj6ajF14HkezzoiQKGhG0aZ20sYAgACPafeAAEU5bw==
Date:   Wed, 22 May 2019 21:28:27 +0000
Message-ID: <BYAPR10MB26800BD692C1CBDD8CAB950AE3000@BYAPR10MB2680.namprd10.prod.outlook.com>
References: <BYAPR10MB2680B63C684345098E6E7669E3070@BYAPR10MB2680.namprd10.prod.outlook.com>,<73d5b951-2598-0d7f-5b6e-8925cc61989a@iogearbox.net>,<BYAPR10MB268073D6667D2AB0E1699D5DE3000@BYAPR10MB2680.namprd10.prod.outlook.com>
In-Reply-To: <BYAPR10MB268073D6667D2AB0E1699D5DE3000@BYAPR10MB2680.namprd10.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=matthew.cover@stackpath.com; 
x-originating-ip: [24.56.44.135]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04017f2e-f90c-4ad3-c14f-08d6defc6e31
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR10MB3061;
x-ms-traffictypediagnostic: BYAPR10MB3061:
x-microsoft-antispam-prvs: <BYAPR10MB3061181D53F79A4B990EE4ECE3000@BYAPR10MB3061.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(376002)(346002)(39860400002)(136003)(189003)(199004)(3846002)(53936002)(66556008)(5660300002)(64756008)(6246003)(6116002)(66446008)(14454004)(8676002)(81156014)(26005)(2501003)(11346002)(2906002)(9686003)(73956011)(66946007)(76116006)(52536014)(66476007)(55016002)(186003)(256004)(478600001)(74316002)(2201001)(66066001)(86362001)(76176011)(14444005)(5024004)(316002)(486006)(6436002)(44832011)(476003)(7696005)(6506007)(102836004)(53546011)(7416002)(110136005)(71190400001)(71200400001)(99286004)(446003)(25786009)(4326008)(305945005)(8936002)(7736002)(68736007)(33656002)(2940100002)(229853002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR10MB3061;H:BYAPR10MB2680.namprd10.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: stackpath.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /aWWmDC8oRu52J1y04W6s7Qj30xM9gRySX71EBeuIyb/k2wMS8LdwfjTn9DpiylS+rIhSYwCHT4k/awJ2hWA/mt/AWZ2QO//rsYDXIuWP8+wV2UQtkpME/ngCTFxXnqzK9Kx8gwltACSdfzUTtr356zHo3+mYrcygxoWihAzGHdwm5E7HJMS2w7m81bllVOhIs4Ikeb88mkGwbFFhjYHIsI0kGyPqDh6BNUYE1OGws1WsNx/3TJDIU4zMDahoQF4/RcEtWmxYYxHn+AEBIP2RM6jcDKcbOTewQ9xP53vBBHMfaWJpnDfTETTxRscqm8D9WwWP0uIea2wK6OxDz+0+1ljqfftuaFJxLl6jMUms6pmYYBpTvovIhWwyiFCGmbEzG7eAhKITlBzDw82qyIBUafRDQHy/ZjOL7jIPuBuNlw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: stackpath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04017f2e-f90c-4ad3-c14f-08d6defc6e31
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 21:28:28.0173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fd04f7e7-8712-48a5-bd2d-688fe1861f4b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3061
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05/22/2019 01:52 AM, Matthew Cover wrote:
> > > __sk_buff has a member tc_classid which I'm interested in accessing f=
rom the skb bpf context.
> > >=20
> > > A bpf program which accesses skb->tc_classid compiles, but fails veri=
fication; the specific failure is "invalid bpf_context access".
> > >=20
> > > if (skb->tc_classid !=3D 0)
> > >=A0 return 1;
> > > return 0;
> > >=20
> > > Some of the tests in tools/testing/selftests/bpf/verifier/ (those on =
tc_classid) further confirm that this is, in all likelihood, intentional be=
havior.
> > >=20
> > > The very similar bpf program which instead accesses skb->mark works a=
s desired.
> > >=20
> > > if (skb->mark !=3D 0)
> > >=A0 return 1;
> > > return 0;
> >=20
> > You should be able to access skb->tc_classid, perhaps you're using the =
wrong program
> > type? BPF_PROG_TYPE_SCHED_CLS is supposed to work (if not we'd have a r=
egression).
> >=20
>=20
> I am in fact using BPF_PROG_TYPE_SOCKET_FILTER and using the program as P=
ACKET_FANOUT_DATA with PACKET_FANOUT_EBPF.
>=20
> I have been working on a series of utils which leverage PACKET_FANOUT to =
provide various per-socket-fd (per-cpu, per-queue, per-rx-flow-hash-indirec=
tion-table-idx) statistics and pcap files. While playing with PACKET_FANOUT=
_EBPF, I realized that I could use  the bpf program to categorize packets i=
n ways packet-filter(7) does not provide.
>=20
> As a concrete example, I plan to build a util `rxtxmark` which could be p=
assed something like `--mark-list 42,88`. This would be translated to a bpf=
 program where the return code is the ordinality of the mark in the list.
>=20
> if (skb->mark =3D=3D 42)
> =A0return 1;
> if (skb->mark =3D=3D 88)
> =A0return 2;
> return 0;
>=20
> Packets enqueued to fd0 are simply ignored. Packets enqueued to the other=
 fds are processed into pcaps and statistics.
>=20
> While I may build a util for tc_classid which does per-user-requested-cla=
ssid pcaps and statistics like `rxtxmark` does for marks, I'm also interest=
ed in using tc_classid as a simple way to capture tx packets from a long ru=
nning program on the fly.
>=20
> The program under inspection would simply be added to a net_cls cgroup wh=
ich has a unique classid defined. A bpf program would be attached to map pa=
ckets with that classid to fd1. While I can do this already by using iptabl=
es to translate the tc_classid to  a mark, that complicates the implementat=
ion greatly since the firewall has to be touched (which is probably overrea=
ching for a packet capture util and would most likely be left to the user t=
o configure).
>=20

And only now do I discover netsniff-ng; a seriously cool set of utils! Than=
k you for your efforts there Daniel!

I still plan to continue advancing my various PACKET_FANOUT utils and event=
ually seeing how much, if any, of the common code would be of interest to t=
he libpcap maintainers. But very cool that a quick look at the netsniff-ng =
help file shows that rxtxcpu et al could be accomplished with the right num=
ber of concurrent invocations of netsniff-ng.

> > > I built a kernel (v5.1) with 4 instances of the following line remove=
d from net/core/filter.c to test the behavior when the instructions pass ve=
rification.
> > >=20
> > >=A0=A0=A0=A0 switch (off) {
> > > -=A0=A0=A0 case bpf_ctx_range(struct __sk_buff, tc_classid):
> > > ...
> > >=A0=A0=A0=A0=A0=A0=A0=A0 return false;
> > >=20
> > > It appears skb->tc_classid is always zero within my bpf program, even=
 when I verify by other means (e.g. netfilter) that the value is set non-ze=
ro.
> > >=20
> > > I gather that sk_buff proper sometimes (i.e. at some layers) has qdis=
c_skb_cb stored in skb->cb, but not always.
> > >=20
> > > I suspect that the tc_classid is available at l3 (and therefore to ut=
ils like netfilter, ip route, tc), but not at l2 (and not to AF_PACKET).
> >=20
> > From tc/BPF context you can use it; it's been long time, but I think ba=
ck then
> > we mapped it into cb[] so it can be used within the BPF context to pass=
 skb data
> > around e.g. between tail calls, and cls_bpf_classify() when in direct-a=
ction mode
> > which likely everyone is/should-be using then maps that skb->tc_classid=
 u16 cb[]
> > value to res->classid on program return which then in either sch_handle=
_ingress()
> > or sch_handle_egress() is transferred into the skb->tc_index.
> >=20
>=20
> It sounds like just before the start of a BPF_PROG_TYPE_SCHED_CLS bpf pro=
gram tc_classid id placed in skb->cb. The missing plumbing to support my us=
e case is probably the same thing, but for BPF_PROG_TYPE_SOCKET_FILTER.
>=20
> I'll see about familiarizing myself with both as time permits and perhaps=
 I can get tc_classid working for a BPF_PROG_TYPE_SOCKET_FILTER program; it=
 certainly sounds like it's doable.
>=20
> > > Is it impractical to make skb->tc_classid available in this bpf conte=
xt or is there just some plumbing which hasn't been connected yet?
> > >=20
> > > Is my suspicion that skb->cb no longer contains qdisc_skb_cb due to c=
rossing a layer boundary well founded?
> > >=20
> > > I'm willing to look into hooking things together as time permits if i=
t's a feasible task.
> > >=20
> > > It's trivial to have iptables match on tc_classid and set a mark whic=
h is available to bpf at l2, but I'd like to better understand this.
> > >=20
> > > Thanks,
> > > Matt C.
> > >=20

=A0=A0=A0     =
