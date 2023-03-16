Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A830E6BDADB
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 22:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjCPVXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 17:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjCPVXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 17:23:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A7D7FD7A;
        Thu, 16 Mar 2023 14:23:18 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GKHiaK013110;
        Thu, 16 Mar 2023 21:22:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=he5J0iRg5FQM4/BFUlIEk8rfm5PkUKxos/03omQltC8=;
 b=HfJcFnT2xcwHFWuPtp7K2iA0OrsBrQqZeGMLVpl5qO44UKJPktzSxpIxgU1tFZwn+Vez
 XulauhENDu2ejcrNjJhK1eo8jYy1MHSALqXMJL7kOsP/MlmuvuRALp2NGt77caBJygpJ
 Ty73hpHE+JPFLeuuSL/JaSP9TPaFo3dstM/L9xURIbgNCQLQK3uoDRhBhokdRtGPypU9
 0VIQ4bogMhPw4dxRqInPb/WnFZNrgZqDYwhgLwPnyhsjGyNaChpU0L1iBkZkSuQxUyA0
 1n6U9xVZjkVBtqQFW89WgmRHXQ9+KOLBlbbgebK0lnmxTAShZVWKyogpSA6U0IDVbomf Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pca191avd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Mar 2023 21:22:33 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32GLEUcA030603;
        Thu, 16 Mar 2023 21:22:32 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pca191auc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Mar 2023 21:22:32 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32GIIYH1024419;
        Thu, 16 Mar 2023 21:22:30 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3pbsmbh14v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Mar 2023 21:22:29 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32GLMRGD18678492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 21:22:27 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E2FA20043;
        Thu, 16 Mar 2023 21:22:27 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B44A92004D;
        Thu, 16 Mar 2023 21:22:26 +0000 (GMT)
Received: from [9.171.2.157] (unknown [9.171.2.157])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 16 Mar 2023 21:22:26 +0000 (GMT)
Message-ID: <8f6bf3e51b5b56ac4cc93dc51456eec221eca559.camel@linux.ibm.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: fix "metadata marker"
 getting overwritten by the netstack
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 16 Mar 2023 22:22:26 +0100
In-Reply-To: <20230316175051.922550-3-aleksander.lobakin@intel.com>
References: <20230316175051.922550-1-aleksander.lobakin@intel.com>
         <20230316175051.922550-3-aleksander.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OWC2jf06NfgwRMtftpX9sfrH8CWE6kRd
X-Proofpoint-ORIG-GUID: 8ml5RAaVrcz0E1wMKOaUZjW7f52h7P2b
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_14,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303160158
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-03-16 at 18:50 +0100, Alexander Lobakin wrote:
> Alexei noticed xdp_do_redirect test on BPF CI started failing on
> BE systems after skb PP recycling was enabled:
>=20
> test_xdp_do_redirect:PASS:prog_run 0 nsec
> test_xdp_do_redirect:PASS:pkt_count_xdp 0 nsec
> test_xdp_do_redirect:PASS:pkt_count_zero 0 nsec
> test_xdp_do_redirect:FAIL:pkt_count_tc unexpected pkt_count_tc:
> actual
> 220 !=3D expected 9998
> test_max_pkt_size:PASS:prog_run_max_size 0 nsec
> test_max_pkt_size:PASS:prog_run_too_big 0 nsec
> close_netns:PASS:setns 0 nsec
> =C2=A0#289 xdp_do_redirect:FAIL
> Summary: 270/1674 PASSED, 30 SKIPPED, 1 FAILED
>=20
> and it doesn't happen on LE systems.
> Ilya then hunted it down to:
>=20
> =C2=A0#0=C2=A0 0x0000000000aaeee6 in neigh_hh_output (hh=3D0x83258df0,
> skb=3D0x88142200) at linux/include/net/neighbour.h:503
> =C2=A0#1=C2=A0 0x0000000000ab2cda in neigh_output (skip_cache=3Dfalse,
> skb=3D0x88142200, n=3D<optimized out>) at
> linux/include/net/neighbour.h:544
> =C2=A0#2=C2=A0 ip6_finish_output2 (net=3Dnet@entry=3D0x88edba00, sk=3Dsk@=
entry=3D0x0,
> skb=3Dskb@entry=3D0x88142200) at linux/net/ipv6/ip6_output.c:134
> =C2=A0#3=C2=A0 0x0000000000ab4cbc in __ip6_finish_output (skb=3D0x8814220=
0,
> sk=3D0x0,
> net=3D0x88edba00) at linux/net/ipv6/ip6_output.c:195
> =C2=A0#4=C2=A0 ip6_finish_output (net=3D0x88edba00, sk=3D0x0, skb=3D0x881=
42200) at
> linux/net/ipv6/ip6_output.c:206
>=20
> xdp_do_redirect test places a u32 marker (0x42) right before the
> Ethernet
> header to check it then in the XDP program and return %XDP_ABORTED if
> it's
> not there. Neigh xmit code likes to round up hard header length to
> speed
> up copying the header, so it overwrites two bytes in front of the Eth
> header. On LE systems, 0x42 is one byte at `data - 4`, while on BE
> it's
> `data - 1`, what explains why it happens only there.
> It didn't happen previously due to that %XDP_PASS meant the page will
> be
> discarded and replaced by a new one, but now it can be recycled as
> well,
> while bpf_test_run code doesn't reinitialize the content of recycled
> pages. This mark is limited to this particular test and its setup
> though,
> so there's no need to predict 1000 different possible cases. Just
> move
> it 4 bytes to the left, still keeping it 32 bit to match on more
> bytes.
>=20
> Fixes: 9c94bbf9a87b ("xdp: recycle Page Pool backed skbs built from
> XDP frames")
> Reported-by: Alexei Starovoitov <ast@kernel.org>
> Link:
> https://lore.kernel.org/bpf/CAADnVQ+B_JOU+EpP=3DDKhbY9yXdN6GiRPnpTTXfEZ9s=
NkUeb-yQ@mail.gmail.com
> Reported-by: Ilya Leoshkevich <iii@linux.ibm.com> # + debugging
> Link:
> https://lore.kernel.org/bpf/8341c1d9f935f410438e79d3bd8a9cc50aefe105.came=
l@linux.ibm.com
> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> ---
> =C2=A0tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c | 7 ++++---
> =C2=A0tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c | 2 +-
> =C2=A02 files changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
> b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
> index 856cbc29e6a1..4eaa3dcaebc8 100644
> --- a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
> @@ -86,12 +86,12 @@ static void test_max_pkt_size(int fd)
> =C2=A0void test_xdp_do_redirect(void)
> =C2=A0{
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int err, xdp_prog_fd, tc_=
prog_fd, ifindex_src, ifindex_dst;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0char data[sizeof(pkt_udp) + si=
zeof(__u32)];
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0char data[sizeof(pkt_udp) + si=
zeof(__u64)];
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct test_xdp_do_redire=
ct *skel =3D NULL;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct nstoken *nstoken =
=3D NULL;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct bpf_link *link;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0LIBBPF_OPTS(bpf_xdp_query=
_opts, query_opts);
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct xdp_md ctx_in =3D { .da=
ta =3D sizeof(__u32),
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct xdp_md ctx_in =3D { .da=
ta =3D sizeof(__u64),
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .data_end =3D sizeof(data) };
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0DECLARE_LIBBPF_OPTS(bpf_t=
est_run_opts, opts,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 .data_in =3D &data,
> @@ -105,8 +105,9 @@ void test_xdp_do_redirect(void)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0DECLARE_LIBBPF_OPTS(bpf_t=
c_hook, tc_hook,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 .attach_point =3D BPF_TC_INGRESS);
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0memcpy(&data[sizeof(__u32)], &=
pkt_udp, sizeof(pkt_udp));
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0memcpy(&data[sizeof(__u64)], &=
pkt_udp, sizeof(pkt_udp));
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*((__u32 *)data) =3D 0x42=
; /* metadata test value */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*((__u32 *)data + 4) =3D 0;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0skel =3D test_xdp_do_redi=
rect__open();
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!ASSERT_OK_PTR(skel, =
"skel"))
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> index cd2d4e3258b8..5baaafed0d2d 100644
> --- a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> @@ -52,7 +52,7 @@ int xdp_redirect(struct xdp_md *xdp)
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*payload =3D MARK_IN;
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (bpf_xdp_adjust_meta(xdp, 4=
))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (bpf_xdp_adjust_meta(xdp, s=
izeof(__u64)))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return XDP_ABORTED;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (retcode > XDP_PASS)

Tested-by: Ilya Leoshkevich <iii@linux.ibm.com>
