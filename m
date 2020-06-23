Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1462045C2
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 02:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732113AbgFWAhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 20:37:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40652 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731889AbgFWAgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 20:36:45 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05N0aLDG029181
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 17:36:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Yl4n5UzIuuWhr+TSJzNv6mIjW4bQIkqFrdRSkv8DV5M=;
 b=QdHgmFaHkqXGdA8JcZ+0fCaOPEQz1P+WVlzBd/P4oOu1KIMD4opccOiFZNf+ip1gR28T
 2+THMsudu9F4wUy4uYIN6DB+nDu4/GqUcrBuj7ZlAosIeP16HXY8+W8IqTEyih+kPdMr
 OxVrTtkHHmquj8WV7ospNT+fA9Xtrm+vuNo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31sfyku4ba-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 17:36:44 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 22 Jun 2020 17:36:42 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 1C94A3705002; Mon, 22 Jun 2020 17:36:40 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 12/15] tools/libbpf: add more common macros to bpf_tracing_net.h
Date:   Mon, 22 Jun 2020 17:36:40 -0700
Message-ID: <20200623003640.3074800-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200623003626.3072825-1-yhs@fb.com>
References: <20200623003626.3072825-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_16:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=8 adultscore=0 cotscore=-2147483648 impostorscore=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 phishscore=0 mlxlogscore=686 spamscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These newly added macros will be used in subsequent bpf iterator
tcp{4,6} and udp{4,6} programs.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/lib/bpf/bpf_tracing_net.h | 35 +++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/tools/lib/bpf/bpf_tracing_net.h b/tools/lib/bpf/bpf_tracing_=
net.h
index 1f38a1098727..01378911252b 100644
--- a/tools/lib/bpf/bpf_tracing_net.h
+++ b/tools/lib/bpf/bpf_tracing_net.h
@@ -2,15 +2,50 @@
 #ifndef __BPF_TRACING_NET_H__
 #define __BPF_TRACING_NET_H__
=20
+#define AF_INET			2
+#define AF_INET6		10
+
+#define ICSK_TIME_RETRANS	1
+#define ICSK_TIME_PROBE0	3
+#define ICSK_TIME_LOSS_PROBE	5
+#define ICSK_TIME_REO_TIMEOUT	6
+
 #define IFNAMSIZ		16
=20
 #define RTF_GATEWAY		0x0002
=20
+#define TCP_INFINITE_SSTHRESH	0x7fffffff
+#define TCP_PINGPONG_THRESH	3
+
 #define fib_nh_dev		nh_common.nhc_dev
 #define fib_nh_gw_family	nh_common.nhc_gw_family
 #define fib_nh_gw6		nh_common.nhc_gw.ipv6
=20
+#define inet_daddr		sk.__sk_common.skc_daddr
+#define inet_rcv_saddr		sk.__sk_common.skc_rcv_saddr
+#define inet_dport		sk.__sk_common.skc_dport
+
+#define ir_loc_addr		req.__req_common.skc_rcv_saddr
+#define ir_num			req.__req_common.skc_num
+#define ir_rmt_addr		req.__req_common.skc_daddr
+#define ir_rmt_port		req.__req_common.skc_dport
+#define ir_v6_rmt_addr		req.__req_common.skc_v6_daddr
+#define ir_v6_loc_addr		req.__req_common.skc_v6_rcv_saddr
+
+#define sk_family		__sk_common.skc_family
 #define sk_rmem_alloc		sk_backlog.rmem_alloc
 #define sk_refcnt		__sk_common.skc_refcnt
+#define sk_state		__sk_common.skc_state
+#define sk_v6_daddr		__sk_common.skc_v6_daddr
+#define sk_v6_rcv_saddr		__sk_common.skc_v6_rcv_saddr
+
+#define s6_addr32		in6_u.u6_addr32
+
+#define tw_daddr		__tw_common.skc_daddr
+#define tw_rcv_saddr		__tw_common.skc_rcv_saddr
+#define tw_dport		__tw_common.skc_dport
+#define tw_refcnt		__tw_common.skc_refcnt
+#define tw_v6_daddr		__tw_common.skc_v6_daddr
+#define tw_v6_rcv_saddr		__tw_common.skc_v6_rcv_saddr
=20
 #endif
--=20
2.24.1

