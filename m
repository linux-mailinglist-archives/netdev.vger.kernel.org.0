Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A99237560D
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 19:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403879AbfGYRr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 13:47:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43270 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388955AbfGYRr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 13:47:59 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6PFxhhM000802;
        Thu, 25 Jul 2019 10:15:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=tRFEixkL6vpxN6wIyMJYysJdhW5E1Qr2KtfnEckV2iY=;
 b=ikz4pG5MKq/Id68REvhoVm7xKoaCTVRox9UDD3RZiZjjfKOBH7ZHqXcKM2gFo4zMtqVa
 vJvZRzOFtE76ZhD+8B1fgjxs5xQiCFrc78AJS1RDvU9GTu8DySnF7pInji9yMb6U7UL6
 vA1AwCS/YeuJdaH94vJu6Xiw5dBlDkKd41o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tyfc40bu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Jul 2019 10:15:15 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 25 Jul 2019 10:15:14 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 25 Jul 2019 10:15:14 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 25 Jul 2019 10:15:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTW6pPg3GXDC/q+VBUXybvvK6iSgbqVEaZ1wV1sCIGAAH3q7o4OtbH2HKgSEhHKFH8I+yV0iLP6kktBCY9fmFm+GtoeNLqKyG06OFZlcBpanF+jkpm/a6fWYersDUjUgXKP49JkCltl2yQk+4YbFfoNMPqc8ej3ajm6UndOKVK0WAUtiHU3Yjp8bSOlsB487EfE/tW0wodFCRtq/udI6v5XIOIznGESd4cjUB/IT249cttrNWcbgJPNnFjpbdCIpfQIy+9z14c2d4Ra6mlrkTco9FAKDyzUhrJDUTBc367miWeck8MmHO41ykvSxkVU3ko398KEjQucLOR8dPdgkYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tRFEixkL6vpxN6wIyMJYysJdhW5E1Qr2KtfnEckV2iY=;
 b=BM2mAYbOTXNlxErCtCx/GLeLd6TjIiuyu7kMVKvdqe3QpRNgjT3oGRTuN0Y1K3m8yt8kg2LO7YG0dNUO+c+pSlKBgxlQHsEKVYkGZWlvqPw21pNqx/MXeN7wp4WGtxRrfZF9qMFB4OtRQ4IWIIkfVOEvyWL5DTQ6V11b0SXROMMv510QsfW0Us58tRrXZ5e8aaExlBLCpAI4KwMEG36PTeFAkhPUbhdseM/4zOaAuMfMXVeAI/5rCmahjx5CmnubF5qONe+Scb4c2s3UsjOVEuVBgzFhU6U1Xa+WP8vQuQDT8Uwx2OQqq0/u2bRP/mOoZtApAAvmnxIhV841ut3UaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tRFEixkL6vpxN6wIyMJYysJdhW5E1Qr2KtfnEckV2iY=;
 b=Fxtr6zf3cL3DevCeu5v2GoMPSc4VNzn2K7v1z10cF0MrslRLwKnLZQ3OwvA53bSI2PahwCgpScYogdb6tvq1auOxt03KgvQ2N0NuMB7E+spNH2R8WJWhJHRXYJ5+JX2sXricFG6ZUVKPrEYm+1/iHsHAYWkrEwTE6LB70oe1fSE=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1631.namprd15.prod.outlook.com (10.175.138.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Thu, 25 Jul 2019 17:15:13 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7%7]) with mapi id 15.20.2094.013; Thu, 25 Jul 2019
 17:15:12 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Subject: Re: [PATCH bpf-next v2 5/7] selftests/bpf: support
 FLOW_DISSECTOR_F_PARSE_1ST_FRAG
Thread-Topic: [PATCH bpf-next v2 5/7] selftests/bpf: support
 FLOW_DISSECTOR_F_PARSE_1ST_FRAG
Thread-Index: AQHVQv5qFINLoCyM1kulqh8o05cvq6bbkwuA
Date:   Thu, 25 Jul 2019 17:15:12 +0000
Message-ID: <8160619F-DEDB-44F0-8AB3-EFBD07888822@fb.com>
References: <20190725153342.3571-1-sdf@google.com>
 <20190725153342.3571-6-sdf@google.com>
In-Reply-To: <20190725153342.3571-6-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:63dc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5ea7db0-b836-49c9-813b-08d71123a79c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1631;
x-ms-traffictypediagnostic: MWHPR15MB1631:
x-microsoft-antispam-prvs: <MWHPR15MB163144776EEE40248A25FA4CB3C10@MWHPR15MB1631.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(376002)(346002)(39860400002)(396003)(199004)(189003)(76116006)(33656002)(6436002)(53546011)(66476007)(53936002)(86362001)(2616005)(186003)(478600001)(46003)(66556008)(102836004)(6506007)(229853002)(71200400001)(36756003)(2906002)(99286004)(66446008)(64756008)(6916009)(256004)(66946007)(5660300002)(6116002)(81156014)(6512007)(8676002)(6486002)(57306001)(81166006)(316002)(68736007)(486006)(476003)(54906003)(305945005)(6246003)(14454004)(446003)(71190400001)(11346002)(8936002)(50226002)(25786009)(76176011)(7736002)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1631;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6bUIIGuxcWXPJW1NC94ZfMQAhUcohs0i24LtkYARyD3x70mrC4y0M0DRHwpNQ/m1HqNoGC8wpBlT0zJVIrX/TsyO7kmGMgEs5q3IgPs80i3Tvx65LndMarn2LWffMd5cqTIBGTQtjGAgfEygWBP4BZkobiKDit+e3ElB0L+opX+h+KlL49OGiuW58nS8gd/LtKGne5TAsw2otG8Qz6HzGHIQLL8j4vmtmJbSiz7/R4shUJKyHf/hiy/H2YCvWI1O0CfgRfF1AM6I5iYrv5OX52qIvZ3Z/Km6K5te6uYI/MjGXRetvlwden3RtX9p7Lr1zEdFgv92KYze8KyTiD79YYjNoqKArF0Ejke0KjVnUceziOJm6UlxdA9CmD5r9NsNMG6OrTFpaCvHtpOp8YwUkkm2Eazj15r119YUQ0aodbg=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5AA4E924AA30AB46B599F9CCB9E09BBD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b5ea7db0-b836-49c9-813b-08d71123a79c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 17:15:12.6330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1631
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-25_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907250188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 25, 2019, at 8:33 AM, Stanislav Fomichev <sdf@google.com> wrote:
>=20
> bpf_flow.c: exit early unless FLOW_DISSECTOR_F_PARSE_1ST_FRAG is passed
> in flags. Also, set ip_proto earlier, this makes sure we have correct
> value with fragmented packets.
>=20
> Add selftest cases to test ipv4/ipv6 fragments and skip eth_get_headlen
> tests that don't have FLOW_DISSECTOR_F_PARSE_1ST_FRAG flag.
>=20
> eth_get_headlen calls flow dissector with
> FLOW_DISSECTOR_F_PARSE_1ST_FRAG flag so we can't run tests that
> have different set of input flags against it.
>=20
> v2:
> * sefltests -> selftests (Willem de Bruijn)
> * Reword a comment about eth_get_headlen flags (Song Liu)
>=20
> Acked-by: Willem de Bruijn <willemb@google.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Petar Penkov <ppenkov@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Acked-by: Song Liu <songliubraving@fb.com>


> ---
> .../selftests/bpf/prog_tests/flow_dissector.c | 132 +++++++++++++++++-
> tools/testing/selftests/bpf/progs/bpf_flow.c  |  28 +++-
> 2 files changed, 153 insertions(+), 7 deletions(-)
>=20
> diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/to=
ols/testing/selftests/bpf/prog_tests/flow_dissector.c
> index c938283ac232..f93a115db650 100644
> --- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> +++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> @@ -5,6 +5,10 @@
> #include <linux/if_tun.h>
> #include <sys/uio.h>
>=20
> +#ifndef IP_MF
> +#define IP_MF 0x2000
> +#endif
> +
> #define CHECK_FLOW_KEYS(desc, got, expected)				\
> 	CHECK_ATTR(memcmp(&got, &expected, sizeof(got)) !=3D 0,		\
> 	      desc,							\
> @@ -49,6 +53,18 @@ struct ipv6_pkt {
> 	struct tcphdr tcp;
> } __packed;
>=20
> +struct ipv6_frag_pkt {
> +	struct ethhdr eth;
> +	struct ipv6hdr iph;
> +	struct frag_hdr {
> +		__u8 nexthdr;
> +		__u8 reserved;
> +		__be16 frag_off;
> +		__be32 identification;
> +	} ipf;
> +	struct tcphdr tcp;
> +} __packed;
> +
> struct dvlan_ipv6_pkt {
> 	struct ethhdr eth;
> 	__u16 vlan_tci;
> @@ -65,9 +81,11 @@ struct test {
> 		struct ipv4_pkt ipv4;
> 		struct svlan_ipv4_pkt svlan_ipv4;
> 		struct ipv6_pkt ipv6;
> +		struct ipv6_frag_pkt ipv6_frag;
> 		struct dvlan_ipv6_pkt dvlan_ipv6;
> 	} pkt;
> 	struct bpf_flow_keys keys;
> +	__u32 flags;
> };
>=20
> #define VLAN_HLEN	4
> @@ -143,6 +161,102 @@ struct test tests[] =3D {
> 			.n_proto =3D __bpf_constant_htons(ETH_P_IPV6),
> 		},
> 	},
> +	{
> +		.name =3D "ipv4-frag",
> +		.pkt.ipv4 =3D {
> +			.eth.h_proto =3D __bpf_constant_htons(ETH_P_IP),
> +			.iph.ihl =3D 5,
> +			.iph.protocol =3D IPPROTO_TCP,
> +			.iph.tot_len =3D __bpf_constant_htons(MAGIC_BYTES),
> +			.iph.frag_off =3D __bpf_constant_htons(IP_MF),
> +			.tcp.doff =3D 5,
> +			.tcp.source =3D 80,
> +			.tcp.dest =3D 8080,
> +		},
> +		.keys =3D {
> +			.flags =3D FLOW_DISSECTOR_F_PARSE_1ST_FRAG,
> +			.nhoff =3D ETH_HLEN,
> +			.thoff =3D ETH_HLEN + sizeof(struct iphdr),
> +			.addr_proto =3D ETH_P_IP,
> +			.ip_proto =3D IPPROTO_TCP,
> +			.n_proto =3D __bpf_constant_htons(ETH_P_IP),
> +			.is_frag =3D true,
> +			.is_first_frag =3D true,
> +			.sport =3D 80,
> +			.dport =3D 8080,
> +		},
> +		.flags =3D FLOW_DISSECTOR_F_PARSE_1ST_FRAG,
> +	},
> +	{
> +		.name =3D "ipv4-no-frag",
> +		.pkt.ipv4 =3D {
> +			.eth.h_proto =3D __bpf_constant_htons(ETH_P_IP),
> +			.iph.ihl =3D 5,
> +			.iph.protocol =3D IPPROTO_TCP,
> +			.iph.tot_len =3D __bpf_constant_htons(MAGIC_BYTES),
> +			.iph.frag_off =3D __bpf_constant_htons(IP_MF),
> +			.tcp.doff =3D 5,
> +			.tcp.source =3D 80,
> +			.tcp.dest =3D 8080,
> +		},
> +		.keys =3D {
> +			.nhoff =3D ETH_HLEN,
> +			.thoff =3D ETH_HLEN + sizeof(struct iphdr),
> +			.addr_proto =3D ETH_P_IP,
> +			.ip_proto =3D IPPROTO_TCP,
> +			.n_proto =3D __bpf_constant_htons(ETH_P_IP),
> +			.is_frag =3D true,
> +			.is_first_frag =3D true,
> +		},
> +	},
> +	{
> +		.name =3D "ipv6-frag",
> +		.pkt.ipv6_frag =3D {
> +			.eth.h_proto =3D __bpf_constant_htons(ETH_P_IPV6),
> +			.iph.nexthdr =3D IPPROTO_FRAGMENT,
> +			.iph.payload_len =3D __bpf_constant_htons(MAGIC_BYTES),
> +			.ipf.nexthdr =3D IPPROTO_TCP,
> +			.tcp.doff =3D 5,
> +			.tcp.source =3D 80,
> +			.tcp.dest =3D 8080,
> +		},
> +		.keys =3D {
> +			.flags =3D FLOW_DISSECTOR_F_PARSE_1ST_FRAG,
> +			.nhoff =3D ETH_HLEN,
> +			.thoff =3D ETH_HLEN + sizeof(struct ipv6hdr) +
> +				sizeof(struct frag_hdr),
> +			.addr_proto =3D ETH_P_IPV6,
> +			.ip_proto =3D IPPROTO_TCP,
> +			.n_proto =3D __bpf_constant_htons(ETH_P_IPV6),
> +			.is_frag =3D true,
> +			.is_first_frag =3D true,
> +			.sport =3D 80,
> +			.dport =3D 8080,
> +		},
> +		.flags =3D FLOW_DISSECTOR_F_PARSE_1ST_FRAG,
> +	},
> +	{
> +		.name =3D "ipv6-no-frag",
> +		.pkt.ipv6_frag =3D {
> +			.eth.h_proto =3D __bpf_constant_htons(ETH_P_IPV6),
> +			.iph.nexthdr =3D IPPROTO_FRAGMENT,
> +			.iph.payload_len =3D __bpf_constant_htons(MAGIC_BYTES),
> +			.ipf.nexthdr =3D IPPROTO_TCP,
> +			.tcp.doff =3D 5,
> +			.tcp.source =3D 80,
> +			.tcp.dest =3D 8080,
> +		},
> +		.keys =3D {
> +			.nhoff =3D ETH_HLEN,
> +			.thoff =3D ETH_HLEN + sizeof(struct ipv6hdr) +
> +				sizeof(struct frag_hdr),
> +			.addr_proto =3D ETH_P_IPV6,
> +			.ip_proto =3D IPPROTO_TCP,
> +			.n_proto =3D __bpf_constant_htons(ETH_P_IPV6),
> +			.is_frag =3D true,
> +			.is_first_frag =3D true,
> +		},
> +	},
> };
>=20
> static int create_tap(const char *ifname)
> @@ -225,6 +339,13 @@ void test_flow_dissector(void)
> 			.data_size_in =3D sizeof(tests[i].pkt),
> 			.data_out =3D &flow_keys,
> 		};
> +		static struct bpf_flow_keys ctx =3D {};
> +
> +		if (tests[i].flags) {
> +			tattr.ctx_in =3D &ctx;
> +			tattr.ctx_size_in =3D sizeof(ctx);
> +			ctx.flags =3D tests[i].flags;
> +		}
>=20
> 		err =3D bpf_prog_test_run_xattr(&tattr);
> 		CHECK_ATTR(tattr.data_size_out !=3D sizeof(flow_keys) ||
> @@ -251,10 +372,19 @@ void test_flow_dissector(void)
> 	CHECK(err, "ifup", "err %d errno %d\n", err, errno);
>=20
> 	for (i =3D 0; i < ARRAY_SIZE(tests); i++) {
> -		struct bpf_flow_keys flow_keys =3D {};
> +		/* Keep in sync with 'flags' from eth_get_headlen. */
> +		__u32 eth_get_headlen_flags =3D FLOW_DISSECTOR_F_PARSE_1ST_FRAG;
> 		struct bpf_prog_test_run_attr tattr =3D {};
> +		struct bpf_flow_keys flow_keys =3D {};
> 		__u32 key =3D 0;
>=20
> +		/* For skb-less case we can't pass input flags; run
> +		 * only the tests that have a matching set of flags.
> +		 */
> +
> +		if (tests[i].flags !=3D eth_get_headlen_flags)
> +			continue;
> +
> 		err =3D tx_tap(tap_fd, &tests[i].pkt, sizeof(tests[i].pkt));
> 		CHECK(err < 0, "tx_tap", "err %d errno %d\n", err, errno);
>=20
> diff --git a/tools/testing/selftests/bpf/progs/bpf_flow.c b/tools/testing=
/selftests/bpf/progs/bpf_flow.c
> index 5ae485a6af3f..0eabe5e57944 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_flow.c
> +++ b/tools/testing/selftests/bpf/progs/bpf_flow.c
> @@ -153,7 +153,6 @@ static __always_inline int parse_ip_proto(struct __sk=
_buff *skb, __u8 proto)
> 	struct tcphdr *tcp, _tcp;
> 	struct udphdr *udp, _udp;
>=20
> -	keys->ip_proto =3D proto;
> 	switch (proto) {
> 	case IPPROTO_ICMP:
> 		icmp =3D bpf_flow_dissect_get_header(skb, sizeof(*icmp), &_icmp);
> @@ -231,7 +230,6 @@ static __always_inline int parse_ipv6_proto(struct __=
sk_buff *skb, __u8 nexthdr)
> {
> 	struct bpf_flow_keys *keys =3D skb->flow_keys;
>=20
> -	keys->ip_proto =3D nexthdr;
> 	switch (nexthdr) {
> 	case IPPROTO_HOPOPTS:
> 	case IPPROTO_DSTOPTS:
> @@ -266,6 +264,7 @@ PROG(IP)(struct __sk_buff *skb)
> 	keys->addr_proto =3D ETH_P_IP;
> 	keys->ipv4_src =3D iph->saddr;
> 	keys->ipv4_dst =3D iph->daddr;
> +	keys->ip_proto =3D iph->protocol;
>=20
> 	keys->thoff +=3D iph->ihl << 2;
> 	if (data + keys->thoff > data_end)
> @@ -273,13 +272,19 @@ PROG(IP)(struct __sk_buff *skb)
>=20
> 	if (iph->frag_off & bpf_htons(IP_MF | IP_OFFSET)) {
> 		keys->is_frag =3D true;
> -		if (iph->frag_off & bpf_htons(IP_OFFSET))
> +		if (iph->frag_off & bpf_htons(IP_OFFSET)) {
> 			/* From second fragment on, packets do not have headers
> 			 * we can parse.
> 			 */
> 			done =3D true;
> -		else
> +		} else {
> 			keys->is_first_frag =3D true;
> +			/* No need to parse fragmented packet unless
> +			 * explicitly asked for.
> +			 */
> +			if (!(keys->flags & FLOW_DISSECTOR_F_PARSE_1ST_FRAG))
> +				done =3D true;
> +		}
> 	}
>=20
> 	if (done)
> @@ -301,6 +306,7 @@ PROG(IPV6)(struct __sk_buff *skb)
> 	memcpy(&keys->ipv6_src, &ip6h->saddr, 2*sizeof(ip6h->saddr));
>=20
> 	keys->thoff +=3D sizeof(struct ipv6hdr);
> +	keys->ip_proto =3D ip6h->nexthdr;
>=20
> 	return parse_ipv6_proto(skb, ip6h->nexthdr);
> }
> @@ -317,7 +323,8 @@ PROG(IPV6OP)(struct __sk_buff *skb)
> 	/* hlen is in 8-octets and does not include the first 8 bytes
> 	 * of the header
> 	 */
> -	skb->flow_keys->thoff +=3D (1 + ip6h->hdrlen) << 3;
> +	keys->thoff +=3D (1 + ip6h->hdrlen) << 3;
> +	keys->ip_proto =3D ip6h->nexthdr;
>=20
> 	return parse_ipv6_proto(skb, ip6h->nexthdr);
> }
> @@ -333,9 +340,18 @@ PROG(IPV6FR)(struct __sk_buff *skb)
>=20
> 	keys->thoff +=3D sizeof(*fragh);
> 	keys->is_frag =3D true;
> -	if (!(fragh->frag_off & bpf_htons(IP6_OFFSET)))
> +	keys->ip_proto =3D fragh->nexthdr;
> +
> +	if (!(fragh->frag_off & bpf_htons(IP6_OFFSET))) {
> 		keys->is_first_frag =3D true;
>=20
> +		/* No need to parse fragmented packet unless
> +		 * explicitly asked for.
> +		 */
> +		if (!(keys->flags & FLOW_DISSECTOR_F_PARSE_1ST_FRAG))
> +			return export_flow_keys(keys, BPF_OK);
> +	}
> +
> 	return parse_ipv6_proto(skb, fragh->nexthdr);
> }
>=20
> --=20
> 2.22.0.657.g960e92d24f-goog
>=20

