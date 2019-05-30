Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBC8C30165
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfE3SAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:00:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34730 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726171AbfE3SAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:00:49 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4UI01Zv026025;
        Thu, 30 May 2019 11:00:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=umCNuAKl7Rdr1qdgKCXbCMda0/aFUMXbBFb9DPn6J5o=;
 b=CB06PKxO6V7s5POkYNxq/a9darrfpqFkKqAaIMB5XxreW63fDgmYjY58D7Y1FCkxOUSy
 MJAMr5Ayzg5IubfDptLdi+FZUEwxPPqhnmuQEytrIsBGY/ahnCS/QjbrDWHfUK/zfySM
 75n3CHb7AMg/7uztdMBeh0eV8LplotF3Dtg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2stjfc8c9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 30 May 2019 11:00:17 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 30 May 2019 11:00:15 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 30 May 2019 11:00:15 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 30 May 2019 11:00:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=umCNuAKl7Rdr1qdgKCXbCMda0/aFUMXbBFb9DPn6J5o=;
 b=W2bOicYCccFGNdLvXsvZPyDKYdCPcfb9stwvHl7qp3NVZG87WQJYXI1QdYS9FyYsZGETGatp1BSJc5NJOdM1xJ7CNv6UdB/bbIY1tZEnvJykBe7/ivoHvwtoFaERBIks6c+QFUEH698bthxMWr0xvP5iH5KI5eNObYpmnTcf3Xo=
Received: from BN6PR15MB1154.namprd15.prod.outlook.com (10.172.208.137) by
 BN6PR15MB1603.namprd15.prod.outlook.com (10.175.127.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.17; Thu, 30 May 2019 18:00:12 +0000
Received: from BN6PR15MB1154.namprd15.prod.outlook.com
 ([fe80::adc0:9bbf:9292:27bd]) by BN6PR15MB1154.namprd15.prod.outlook.com
 ([fe80::adc0:9bbf:9292:27bd%2]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 18:00:12 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alan Maguire <alan.maguire@oracle.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>, "Martin Lau" <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: Re: [PATCH bpf-next v3] selftests/bpf: measure RTT from xdp using
 xdping
Thread-Topic: [PATCH bpf-next v3] selftests/bpf: measure RTT from xdp using
 xdping
Thread-Index: AQHVFs2AizxgkVJpv0yJ9IF7V8RTC6aD9WsA
Date:   Thu, 30 May 2019 18:00:12 +0000
Message-ID: <161107A7-5B68-4C60-9043-C8CF6E8EC307@fb.com>
References: <1559209964-15885-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1559209964-15885-1-git-send-email-alan.maguire@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:bc80]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e00ee11-333d-47d9-e1c4-08d6e528a97a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR15MB1603;
x-ms-traffictypediagnostic: BN6PR15MB1603:
x-microsoft-antispam-prvs: <BN6PR15MB160336FE91EE4BAB37C873AEB3180@BN6PR15MB1603.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(376002)(366004)(396003)(346002)(199004)(189003)(5660300002)(14454004)(30864003)(446003)(7736002)(6512007)(50226002)(8936002)(68736007)(76176011)(305945005)(14444005)(8676002)(11346002)(4326008)(7416002)(83716004)(81166006)(25786009)(45080400002)(6116002)(6506007)(54906003)(2906002)(73956011)(53946003)(82746002)(71200400001)(53936002)(6246003)(229853002)(53546011)(71190400001)(99286004)(86362001)(478600001)(81156014)(36756003)(64756008)(76116006)(66476007)(486006)(66556008)(66946007)(6486002)(5024004)(186003)(6436002)(33656002)(91956017)(316002)(476003)(2616005)(57306001)(46003)(66446008)(256004)(102836004)(6916009)(579004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR15MB1603;H:BN6PR15MB1154.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 48feO668gnra1PRXZg8tmVhnjmUQd5VpadjYyZ44U3kVV2ZrTycmz7mGFKrJIWhbPnxqVIXPG7pUsyDnpssA0aMzBL3biw9OzZpmEN2XetrW92dRHra+eqS/gi1l0Ni29x+e+8uUxhzw4LZkE9VjzZw8QYUUAKX61VaI3kEPtO+4tc8PBlOioMlrmLl2r1zy4eFO005XDXocshjjefG/dN6U91lX9AKh+WxSe4r/sDmgHH9HZNoa763e/t02Oo75I0opq6VLBGsNSeVa82c5uqYQjSU8dubeRmUNd+tatJ4O/jNmG3P9ufZxAdxGl3fZIgohOH6nHAoublk1FxQuSWJbcIOL7o+G5tvqyMhqKGVq50zUNUtoLTcplzSY33ABvRDRhXLMHQWkhNeqH8qGC88n0FV0Wo4RL92HhWrTBmg=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <94FD9900636DE847A679F781DEB82450@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e00ee11-333d-47d9-e1c4-08d6e528a97a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 18:00:12.1807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1603
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-30_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905300126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 30, 2019, at 2:52 AM, Alan Maguire <alan.maguire@oracle.com> wrote=
:
>=20
> xdping allows us to get latency estimates from XDP.  Output looks
> like this:
>=20
> ./xdping -I eth4 192.168.55.8
> Setting up XDP for eth4, please wait...
> XDP setup disrupts network connectivity, hit Ctrl+C to quit
>=20
> Normal ping RTT data
> [Ignore final RTT; it is distorted by XDP using the reply]
> PING 192.168.55.8 (192.168.55.8) from 192.168.55.7 eth4: 56(84) bytes of =
data.
> 64 bytes from 192.168.55.8: icmp_seq=3D1 ttl=3D64 time=3D0.302 ms
> 64 bytes from 192.168.55.8: icmp_seq=3D2 ttl=3D64 time=3D0.208 ms
> 64 bytes from 192.168.55.8: icmp_seq=3D3 ttl=3D64 time=3D0.163 ms
> 64 bytes from 192.168.55.8: icmp_seq=3D8 ttl=3D64 time=3D0.275 ms
>=20
> 4 packets transmitted, 4 received, 0% packet loss, time 3079ms
> rtt min/avg/max/mdev =3D 0.163/0.237/0.302/0.054 ms
>=20
> XDP RTT data:
> 64 bytes from 192.168.55.8: icmp_seq=3D5 ttl=3D64 time=3D0.02808 ms
> 64 bytes from 192.168.55.8: icmp_seq=3D6 ttl=3D64 time=3D0.02804 ms
> 64 bytes from 192.168.55.8: icmp_seq=3D7 ttl=3D64 time=3D0.02815 ms
> 64 bytes from 192.168.55.8: icmp_seq=3D8 ttl=3D64 time=3D0.02805 ms
>=20
> The xdping program loads the associated xdping_kern.o BPF program
> and attaches it to the specified interface.  If run in client
> mode (the default), it will add a map entry keyed by the
> target IP address; this map will store RTT measurements, current
> sequence number etc.  Finally in client mode the ping command
> is executed, and the xdping BPF program will use the last ICMP
> reply, reformulate it as an ICMP request with the next sequence
> number and XDP_TX it.  After the reply to that request is received
> we can measure RTT and repeat until the desired number of
> measurements is made.  This is why the sequence numbers in the
> normal ping are 1, 2, 3 and 8.  We XDP_TX a modified version
> of ICMP reply 4 and keep doing this until we get the 4 replies
> we need; hence the networking stack only sees reply 8, where
> we have XDP_PASSed it upstream since we are done.
>=20
> In server mode (-s), xdping simply takes ICMP requests and replies
> to them in XDP rather than passing the request up to the networking
> stack.  No map entry is required.
>=20
> xdping can be run in native XDP mode (the default, or specified
> via -N) or in skb mode (-S).
>=20
> A test program test_xdping.sh exercises some of these options.
>=20
> Note that native XDP does not seem to XDP_TX for veths, hence -N
> is not tested.  Looking at the code, it looks like XDP_TX is
> supported so I'm not sure if that's expected.  Running xdping in
> native mode for ixgbe as both client and server works fine.
>=20
> Changes since v2
>=20
> - updated commit message to explain why seq number of last
>  ICMP reply is 8 not 4 (Song Liu)
> - updated types of seq number, raddr and eliminated csum variable
>  in xdpclient/xdpserver functions as it was not needed (Song Liu)
> - added XDPING_DEFAULT_COUNT definition and usage specification of
>  default/max counts (Song Liu)
>=20
> Changes since v1
> - moved from RFC to PATCH
> - removed unused variable in ipv4_csum() (Song Liu)
> - refactored ICMP checks into icmp_check() function called by client
>   and server programs and reworked client and server programs due
>   to lack of shared code (Song Liu)
> - added checks to ensure that SKB and native mode are not requested
>   together (Song Liu)
>=20
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
> tools/testing/selftests/bpf/.gitignore          |   1 +
> tools/testing/selftests/bpf/Makefile            |   5 +-
> tools/testing/selftests/bpf/progs/xdping_kern.c | 184 +++++++++++++++++
> tools/testing/selftests/bpf/test_xdping.sh      |  99 ++++++++++
> tools/testing/selftests/bpf/xdping.c            | 252 +++++++++++++++++++=
+++++
> tools/testing/selftests/bpf/xdping.h            |  13 ++
> 6 files changed, 552 insertions(+), 2 deletions(-)
> create mode 100644 tools/testing/selftests/bpf/progs/xdping_kern.c
> create mode 100755 tools/testing/selftests/bpf/test_xdping.sh
> create mode 100644 tools/testing/selftests/bpf/xdping.c
> create mode 100644 tools/testing/selftests/bpf/xdping.h
>=20
> diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selft=
ests/bpf/.gitignore
> index b2a9902..7470327 100644
> --- a/tools/testing/selftests/bpf/.gitignore
> +++ b/tools/testing/selftests/bpf/.gitignore
> @@ -38,3 +38,4 @@ libbpf.pc
> libbpf.so.*
> test_hashmap
> test_btf_dump
> +xdping
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
> index 9b21391..2b426ae 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -26,7 +26,7 @@ TEST_GEN_PROGS =3D test_verifier test_tag test_maps tes=
t_lru_map test_lpm_map test
> 	test_sock test_btf test_sockmap test_lirc_mode2_user get_cgroup_id_user =
\
> 	test_socket_cookie test_cgroup_storage test_select_reuseport test_sectio=
n_names \
> 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashma=
p \
> -	test_btf_dump test_cgroup_attach
> +	test_btf_dump test_cgroup_attach xdping
>=20
> BPF_OBJ_FILES =3D $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
> TEST_GEN_FILES =3D $(BPF_OBJ_FILES)
> @@ -57,7 +57,8 @@ TEST_PROGS :=3D test_kmod.sh \
> 	test_lwt_ip_encap.sh \
> 	test_tcp_check_syncookie.sh \
> 	test_tc_tunnel.sh \
> -	test_tc_edt.sh
> +	test_tc_edt.sh \
> +	test_xdping.sh
>=20
> TEST_PROGS_EXTENDED :=3D with_addr.sh \
> 	with_tunnels.sh \
> diff --git a/tools/testing/selftests/bpf/progs/xdping_kern.c b/tools/test=
ing/selftests/bpf/progs/xdping_kern.c
> new file mode 100644
> index 0000000..b13c33d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/xdping_kern.c
> @@ -0,0 +1,184 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved=
. */
> +
> +#define KBUILD_MODNAME "foo"
> +#include <stddef.h>
> +#include <string.h>
> +#include <linux/bpf.h>
> +#include <linux/icmp.h>
> +#include <linux/in.h>
> +#include <linux/if_ether.h>
> +#include <linux/if_packet.h>
> +#include <linux/if_vlan.h>
> +#include <linux/ip.h>
> +
> +#include "bpf_helpers.h"
> +#include "bpf_endian.h"
> +
> +#include "xdping.h"
> +
> +struct bpf_map_def SEC("maps") ping_map =3D {
> +	.type =3D BPF_MAP_TYPE_HASH,
> +	.key_size =3D sizeof(__u32),
> +	.value_size =3D sizeof(struct pinginfo),
> +	.max_entries =3D 256,
> +};
> +
> +static __always_inline void swap_src_dst_mac(void *data)
> +{
> +	unsigned short *p =3D data;
> +	unsigned short dst[3];
> +
> +	dst[0] =3D p[0];
> +	dst[1] =3D p[1];
> +	dst[2] =3D p[2];
> +	p[0] =3D p[3];
> +	p[1] =3D p[4];
> +	p[2] =3D p[5];
> +	p[3] =3D dst[0];
> +	p[4] =3D dst[1];
> +	p[5] =3D dst[2];
> +}
> +
> +static __always_inline __u16 csum_fold_helper(__wsum sum)
> +{
> +	sum =3D (sum & 0xffff) + (sum >> 16);
> +	return ~((sum & 0xffff) + (sum >> 16));
> +}
> +
> +static __always_inline __u16 ipv4_csum(void *data_start, int data_size)
> +{
> +	__wsum sum;
> +
> +	sum =3D bpf_csum_diff(0, 0, data_start, data_size, 0);
> +	return csum_fold_helper(sum);
> +}
> +
> +#define ICMP_ECHO_LEN		64
> +
> +static __always_inline int icmp_check(struct xdp_md *ctx, int type)
> +{
> +	void *data_end =3D (void *)(long)ctx->data_end;
> +	void *data =3D (void *)(long)ctx->data;
> +	struct ethhdr *eth =3D data;
> +	struct icmphdr *icmph;
> +	struct iphdr *iph;
> +
> +	if (data + sizeof(*eth) + sizeof(*iph) + ICMP_ECHO_LEN > data_end)
> +		return XDP_PASS;
> +
> +	if (eth->h_proto !=3D bpf_htons(ETH_P_IP))
> +		return XDP_PASS;
> +
> +	iph =3D data + sizeof(*eth);
> +
> +	if (iph->protocol !=3D IPPROTO_ICMP)
> +		return XDP_PASS;
> +
> +	if (bpf_ntohs(iph->tot_len) - sizeof(*iph) !=3D ICMP_ECHO_LEN)
> +		return XDP_PASS;
> +
> +	icmph =3D data + sizeof(*eth) + sizeof(*iph);
> +
> +	if (icmph->type !=3D type)
> +		return XDP_PASS;
> +
> +	return XDP_TX;
> +}
> +
> +SEC("xdpclient")
> +int xdping_client(struct xdp_md *ctx)
> +{
> +	void *data_end =3D (void *)(long)ctx->data_end;
> +	void *data =3D (void *)(long)ctx->data;
> +	struct pinginfo *pinginfo =3D NULL;
> +	struct ethhdr *eth =3D data;
> +	struct icmphdr *icmph;
> +	struct iphdr *iph;
> +	__u64 recvtime;
> +	__be32 raddr;
> +	__u16 seq;
seq should be __be16, right?=20

> +	int ret;
> +	__u8 i;
> +
> +	ret =3D icmp_check(ctx, ICMP_ECHOREPLY);
> +
> +	if (ret !=3D XDP_TX)
> +		return ret;
> +
> +	iph =3D data + sizeof(*eth);
> +	icmph =3D data + sizeof(*eth) + sizeof(*iph);
> +	raddr =3D iph->saddr;
> +
> +	/* Record time reply received. */
> +	recvtime =3D bpf_ktime_get_ns();
> +	pinginfo =3D bpf_map_lookup_elem(&ping_map, &raddr);
> +	if (!pinginfo || pinginfo->seq !=3D icmph->un.echo.sequence)
> +		return XDP_PASS;
> +
> +	if (pinginfo->start) {
> +#pragma clang loop unroll(full)
> +		for (i =3D 0; i < XDPING_MAX_COUNT; i++) {
> +			if (pinginfo->times[i] =3D=3D 0)
> +				break;
> +		}
> +		/* verifier is fussy here... */
> +		if (i < XDPING_MAX_COUNT) {
> +			pinginfo->times[i] =3D recvtime -
> +					     pinginfo->start;
> +			pinginfo->start =3D 0;
> +			i++;
> +		}
> +		/* No more space for values? */
> +		if (i =3D=3D pinginfo->count || i =3D=3D XDPING_MAX_COUNT)
> +			return XDP_PASS;
> +	}
> +
> +	/* Now convert reply back into echo request. */
> +	swap_src_dst_mac(data);
> +	iph->saddr =3D iph->daddr;
> +	iph->daddr =3D raddr;
> +	icmph->type =3D ICMP_ECHO;
> +	seq =3D bpf_htons(bpf_ntohs(icmph->un.echo.sequence) + 1);
> +	icmph->un.echo.sequence =3D seq;
> +	icmph->checksum =3D 0;
> +	icmph->checksum =3D ipv4_csum(icmph, ICMP_ECHO_LEN);
> +
> +	pinginfo->seq =3D seq;
> +	pinginfo->start =3D bpf_ktime_get_ns();
> +
> +	return XDP_TX;
> +}
> +
> +SEC("xdpserver")
> +int xdping_server(struct xdp_md *ctx)
> +{
> +	void *data_end =3D (void *)(long)ctx->data_end;
> +	void *data =3D (void *)(long)ctx->data;
> +	struct ethhdr *eth =3D data;
> +	struct icmphdr *icmph;
> +	struct iphdr *iph;
> +	__be32 raddr;
> +	int ret;
> +
> +	ret =3D icmp_check(ctx, ICMP_ECHO);
> +
> +	if (ret !=3D XDP_TX)
> +		return ret;
> +
> +	iph =3D data + sizeof(*eth);
> +	icmph =3D data + sizeof(*eth) + sizeof(*iph);
> +	raddr =3D iph->saddr;
> +
> +	/* Now convert request into echo reply. */
> +	swap_src_dst_mac(data);
> +	iph->saddr =3D iph->daddr;
> +	iph->daddr =3D raddr;
> +	icmph->type =3D ICMP_ECHOREPLY;
> +	icmph->checksum =3D 0;
> +	icmph->checksum =3D ipv4_csum(icmph, ICMP_ECHO_LEN);
> +
> +	return XDP_TX;
> +}
> +
> +char _license[] SEC("license") =3D "GPL";
> diff --git a/tools/testing/selftests/bpf/test_xdping.sh b/tools/testing/s=
elftests/bpf/test_xdping.sh
> new file mode 100755
> index 0000000..c2f0ddb
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/test_xdping.sh
> @@ -0,0 +1,99 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +# xdping tests
> +#   Here we setup and teardown configuration required to run
> +#   xdping, exercising its options.
> +#
> +#   Setup is similar to test_tunnel tests but without the tunnel.
> +#
> +# Topology:
> +# ---------
> +#     root namespace   |     tc_ns0 namespace
> +#                      |
> +#      ----------      |     ----------
> +#      |  veth1  | --------- |  veth0  |
> +#      ----------    peer    ----------
> +#
> +# Device Configuration
> +# --------------------
> +# Root namespace with BPF
> +# Device names and addresses:
> +#	veth1 IP: 10.1.1.200
> +#	xdp added to veth1, xdpings originate from here.
> +#
> +# Namespace tc_ns0 with BPF
> +# Device names and addresses:
> +#       veth0 IPv4: 10.1.1.100
> +#	For some tests xdping run in server mode here.
> +#
> +
> +readonly TARGET_IP=3D"10.1.1.100"
> +readonly TARGET_NS=3D"xdp_ns0"
> +
> +readonly LOCAL_IP=3D"10.1.1.200"
> +
> +setup()
> +{
> +	ip netns add $TARGET_NS
> +	ip link add veth0 type veth peer name veth1
> +	ip link set veth0 netns $TARGET_NS
> +	ip netns exec $TARGET_NS ip addr add ${TARGET_IP}/24 dev veth0
> +	ip addr add ${LOCAL_IP}/24 dev veth1
> +	ip netns exec $TARGET_NS ip link set veth0 up
> +	ip link set veth1 up
> +}
> +
> +cleanup()
> +{
> +	set +e
> +	ip netns delete $TARGET_NS 2>/dev/null
> +	ip link del veth1 2>/dev/null
> +	if [[ $server_pid -ne 0 ]]; then
> +		kill -TERM $server_pid
> +	fi
> +}
> +
> +test()
> +{
> +	client_args=3D"$1"
> +	server_args=3D"$2"
> +
> +	echo "Test client args '$client_args'; server args '$server_args'"
> +
> +	server_pid=3D0
> +	if [[ -n "$server_args" ]]; then
> +		ip netns exec $TARGET_NS ./xdping $server_args &
> +		server_pid=3D$!
> +		sleep 10
> +	fi
> +	./xdping $client_args $TARGET_IP
> +
> +	if [[ $server_pid -ne 0 ]]; then
> +		kill -TERM $server_pid
> +		server_pid=3D0
> +	fi
> +
> +	echo "Test client args '$client_args'; server args '$server_args': PASS=
"
> +}
> +
> +set -e
> +
> +server_pid=3D0
> +
> +trap cleanup EXIT
> +
> +setup
> +
> +for server_args in "" "-I veth0 -s -S" ; do
> +	# client in skb mode
> +	client_args=3D"-I veth1 -S"
> +	test "$client_args" "$server_args"
> +
> +	# client with count of 10 RTT measurements.
> +	client_args=3D"-I veth1 -S -c 10"
> +	test "$client_args" "$server_args"
> +done
> +
> +echo "OK. All tests passed"
> +exit 0
> diff --git a/tools/testing/selftests/bpf/xdping.c b/tools/testing/selftes=
ts/bpf/xdping.c
> new file mode 100644
> index 0000000..93a5430
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/xdping.c
> @@ -0,0 +1,252 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved=
. */
> +
> +#include <linux/bpf.h>
> +#include <linux/if_link.h>
> +#include <arpa/inet.h>
> +#include <assert.h>
> +#include <errno.h>
> +#include <signal.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <libgen.h>
> +#include <sys/resource.h>
> +#include <net/if.h>
> +#include <sys/types.h>
> +#include <sys/socket.h>
> +#include <netdb.h>
> +
> +#include "bpf/bpf.h"
> +#include "bpf/libbpf.h"
> +
> +#include "xdping.h"
> +
> +static int ifindex;
> +static __u32 xdp_flags =3D XDP_FLAGS_UPDATE_IF_NOEXIST;
> +
> +static void cleanup(int sig)
> +{
> +	bpf_set_link_xdp_fd(ifindex, -1, xdp_flags);
> +	if (sig)
> +		exit(1);
> +}
> +
> +static int get_stats(int fd, __u16 count, __u32 raddr)
> +{
> +	struct pinginfo pinginfo =3D { 0 };
> +	char inaddrbuf[INET_ADDRSTRLEN];
> +	struct in_addr inaddr;
> +	__u16 i;
> +
> +	inaddr.s_addr =3D raddr;
> +
> +	printf("\nXDP RTT data:\n");
> +
> +	if (bpf_map_lookup_elem(fd, &raddr, &pinginfo)) {
> +		perror("bpf_map_lookup elem: ");
> +		return 1;
> +	}
> +
> +	for (i =3D 0; i < count; i++) {
> +		if (pinginfo.times[i] =3D=3D 0)
> +			break;
> +
> +		printf("64 bytes from %s: icmp_seq=3D%d ttl=3D64 time=3D%#.5f ms\n",
> +		       inet_ntop(AF_INET, &inaddr, inaddrbuf,
> +				 sizeof(inaddrbuf)),
> +		       count + i + 1,
> +		       (double)pinginfo.times[i]/1000000);
> +	}
> +
> +	if (i < count) {
> +		fprintf(stderr, "Expected %d samples, got %d.\n", count, i);
> +		return 1;
> +	}
> +
> +	bpf_map_delete_elem(fd, &raddr);
> +
> +	return 0;
> +}
> +
> +static void show_usage(const char *prog)
> +{
> +	fprintf(stderr,
> +		"usage: %s [OPTS] -I interface destination\n\n"
> +		"OPTS:\n"
> +		"    -c count		Stop after sending count requests\n"
> +		"			(default %d, max %d)\n"
> +		"    -I interface	interface name\n"
> +		"    -N			Run in driver mode\n"
> +		"    -s			Server mode\n"
> +		"    -S			Run in skb mode\n",
> +		prog, XDPING_DEFAULT_COUNT, XDPING_MAX_COUNT);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	__u32 mode_flags =3D XDP_FLAGS_DRV_MODE | XDP_FLAGS_SKB_MODE;
> +	struct addrinfo *a, hints =3D { .ai_family =3D AF_INET };
> +	struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
> +	__u16 count =3D XDPING_DEFAULT_COUNT;
> +	struct pinginfo pinginfo =3D { 0 };
> +	const char *optstr =3D "c:I:NsS";
> +	struct bpf_program *main_prog;
> +	struct sockaddr_in rin;
> +	struct bpf_object *obj;
> +	int prog_fd, map_fd;
> +	struct bpf_map *map;
> +	char *ifname =3D NULL;
> +	char filename[256];
> +	__u32 raddr =3D 0;
> +	int server =3D 0;
> +	char cmd[256];
> +	int opt, ret;
> +
> +	while ((opt =3D getopt(argc, argv, optstr)) !=3D -1) {
> +		switch (opt) {
> +		case 'c':
> +			count =3D atoi(optarg);
> +			if (count < 1 || count > XDPING_MAX_COUNT) {
> +				fprintf(stderr,
> +					"min count is 1, max count is %d\n",
> +					XDPING_MAX_COUNT);
> +				return 1;
> +			}
> +			break;
> +		case 'I':
> +			ifname =3D optarg;
> +			ifindex =3D if_nametoindex(ifname);
> +			if (!ifindex) {
> +				fprintf(stderr, "Could not get interface %s\n",
> +					ifname);
> +				return 1;
> +			}
> +			break;
> +		case 'N':
> +			xdp_flags |=3D XDP_FLAGS_DRV_MODE;
> +			break;
> +		case 's':
> +			/* use server program */
> +			server =3D 1;
> +			break;
> +		case 'S':
> +			xdp_flags |=3D XDP_FLAGS_SKB_MODE;
> +			break;
> +		default:
> +			show_usage(basename(argv[0]));
> +			return 1;
> +		}
> +	}
> +
> +	if (!ifname) {
> +		show_usage(basename(argv[0]));
> +		return 1;
> +	}
> +	if (!server && optind =3D=3D argc) {
> +		show_usage(basename(argv[0]));
> +		return 1;
> +	}
> +
> +	if ((xdp_flags & mode_flags) =3D=3D mode_flags) {
> +		fprintf(stderr, "-N or -S can be specified, not both.\n");
> +		show_usage(basename(argv[0]));
> +		return 1;
> +	}
> +
> +	if (!server) {
> +		/* Only supports IPv4; see hints initiailization above. */
> +		if (getaddrinfo(argv[optind], NULL, &hints, &a) || !a) {
> +			fprintf(stderr, "Could not resolve %s\n", argv[optind]);
> +			return 1;
> +		}
> +		memcpy(&rin, a->ai_addr, sizeof(rin));
> +		raddr =3D rin.sin_addr.s_addr;
> +		freeaddrinfo(a);
> +	}
> +
> +	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
> +		perror("setrlimit(RLIMIT_MEMLOCK)");
> +		return 1;
> +	}
> +
> +	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> +
> +	if (bpf_prog_load(filename, BPF_PROG_TYPE_XDP, &obj, &prog_fd)) {
> +		fprintf(stderr, "load of %s failed\n", filename);
> +		return 1;
> +	}
> +
> +	main_prog =3D bpf_object__find_program_by_title(obj,
> +						      server ? "xdpserver" :
> +							       "xdpclient");
> +	if (main_prog)
> +		prog_fd =3D bpf_program__fd(main_prog);
> +	if (!main_prog || !prog_fd) {

This should be=20

	if (!main_prog || prog_fd < 0) {


> +		fprintf(stderr, "could not find xdping program");
> +		return 1;
> +	}
> +
> +	map =3D bpf_map__next(NULL, obj);
> +	if (map)
> +		map_fd =3D bpf_map__fd(map);
> +	if (!main_prog || prog_fd < 0) {

This should be (map, not prog)

	if (!map || map_fd < 0) {

> +		fprintf(stderr, "Could not find ping map");
> +		return 1;
> +	}
> +
> +	signal(SIGINT, cleanup);
> +	signal(SIGTERM, cleanup);
> +
> +	printf("Setting up XDP for %s, please wait...\n", ifname);
> +
> +	printf("XDP setup disrupts network connectivity, hit Ctrl+C to quit\n")=
;
> +
> +	if (bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags) < 0) {
> +		fprintf(stderr, "Link set xdp fd failed for %s\n", ifname);
> +		return 1;
> +	}
> +
> +	if (server) {
> +		printf("Running server on %s; press Ctrl+C to exit...\n",
> +		       ifname);
> +		do { } while (1);
> +	}
> +
> +	/* Start xdping-ing from last regular ping reply, e.g. for a count
> +	 * of 10 ICMP requests, we start xdping-ing using reply with seq number
> +	 * 10.  The reason the last "real" ping RTT is much higher is that
> +	 * the ping program sees the ICMP reply associated with the last
> +	 * XDP-generated packet, so ping doesn't get a reply until XDP is done.
> +	 */
> +	pinginfo.seq =3D htons(count);
> +	pinginfo.count =3D count;
> +
> +	if (bpf_map_update_elem(map_fd, &raddr, &pinginfo, BPF_ANY)) {
> +		fprintf(stderr, "could not communicate with BPF map: %s\n",
> +			strerror(errno));
> +		cleanup(1);
> +	}
> +
> +	/* We need to wait for XDP setup to complete. */
> +	sleep(10);
> +
> +	snprintf(cmd, sizeof(cmd), "ping -c %d -I %s %s",
> +		 count, ifname, argv[optind]);
> +
> +	printf("\nNormal ping RTT data\n");
> +	printf("[Ignore final RTT; it is distorted by XDP using the reply]\n");
> +
> +	ret =3D system(cmd);
> +
> +	if (!ret)
> +		ret =3D get_stats(map_fd, count, raddr);
> +
> +	cleanup(0);
> +
> +	if (ret)
> +		return 1;
> +
> +	return 0;
> +}
> diff --git a/tools/testing/selftests/bpf/xdping.h b/tools/testing/selftes=
ts/bpf/xdping.h
> new file mode 100644
> index 0000000..b1c3666
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/xdping.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved=
. */
> +
> +#define	XDPING_MAX_COUNT	10
> +#define	XDPING_DEFAULT_COUNT	4
> +
> +struct pinginfo {
> +	__u64	start;
> +	__u16	seq;

Also:
	__be16 seq;

> +	__u16	count;
> +	__u32	pad;
> +	__u64	times[XDPING_MAX_COUNT];
> +};
> --=20
> 1.8.3.1
>=20

