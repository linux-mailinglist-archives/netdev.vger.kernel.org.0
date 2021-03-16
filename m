Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB9E33CAA6
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 02:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbhCPBO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 21:14:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29848 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234157AbhCPBOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 21:14:19 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G1EJQO027391
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:14:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Y+QwbTsucKa0zwkPFt9Uyw/4mpehcANBs87OzB+0Gls=;
 b=bjVq7vYJ8d0/L/SxMr7vLphePrTEdf5wiqrIdNUPdyM2IS7QA5kZJvxA/VE4S+76kwg3
 AD6ca2dmMNu7WSs2/uXuMv1PI6+g0mTfT0t4nvc1nQVQk3Zxw2SOZFfUV7Xw4UFEf3bw
 Jp95G4tKTrf/Y8OtgQGCI+w/hxQiwnUitHI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37a6brvnd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:14:19 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 15 Mar 2021 18:14:17 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id D58312942B57; Mon, 15 Mar 2021 18:14:13 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 06/15] tcp: Rename bictcp function prefix to cubictcp
Date:   Mon, 15 Mar 2021 18:14:13 -0700
Message-ID: <20210316011413.4177478-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316011336.4173585-1-kafai@fb.com>
References: <20210316011336.4173585-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_15:2021-03-15,2021-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=759
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 clxscore=1015
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103160005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cubic functions in tcp_cubic.c are using the bictcp prefix as
in tcp_bic.c.  This patch gives it the proper name cubictcp
because the later patch will allow the bpf prog to directly
call the cubictcp implementation.  Renaming them will avoid
the name collision when trying to find the intended
one to call during bpf prog load time.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv4/tcp_cubic.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index ffcbe46dacdb..4a30deaa9a37 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -124,7 +124,7 @@ static inline void bictcp_hystart_reset(struct sock *=
sk)
 	ca->sample_cnt =3D 0;
 }
=20
-static void bictcp_init(struct sock *sk)
+static void cubictcp_init(struct sock *sk)
 {
 	struct bictcp *ca =3D inet_csk_ca(sk);
=20
@@ -137,7 +137,7 @@ static void bictcp_init(struct sock *sk)
 		tcp_sk(sk)->snd_ssthresh =3D initial_ssthresh;
 }
=20
-static void bictcp_cwnd_event(struct sock *sk, enum tcp_ca_event event)
+static void cubictcp_cwnd_event(struct sock *sk, enum tcp_ca_event event=
)
 {
 	if (event =3D=3D CA_EVENT_TX_START) {
 		struct bictcp *ca =3D inet_csk_ca(sk);
@@ -319,7 +319,7 @@ static inline void bictcp_update(struct bictcp *ca, u=
32 cwnd, u32 acked)
 	ca->cnt =3D max(ca->cnt, 2U);
 }
=20
-static void bictcp_cong_avoid(struct sock *sk, u32 ack, u32 acked)
+static void cubictcp_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 {
 	struct tcp_sock *tp =3D tcp_sk(sk);
 	struct bictcp *ca =3D inet_csk_ca(sk);
@@ -338,7 +338,7 @@ static void bictcp_cong_avoid(struct sock *sk, u32 ac=
k, u32 acked)
 	tcp_cong_avoid_ai(tp, ca->cnt, acked);
 }
=20
-static u32 bictcp_recalc_ssthresh(struct sock *sk)
+static u32 cubictcp_recalc_ssthresh(struct sock *sk)
 {
 	const struct tcp_sock *tp =3D tcp_sk(sk);
 	struct bictcp *ca =3D inet_csk_ca(sk);
@@ -355,7 +355,7 @@ static u32 bictcp_recalc_ssthresh(struct sock *sk)
 	return max((tp->snd_cwnd * beta) / BICTCP_BETA_SCALE, 2U);
 }
=20
-static void bictcp_state(struct sock *sk, u8 new_state)
+static void cubictcp_state(struct sock *sk, u8 new_state)
 {
 	if (new_state =3D=3D TCP_CA_Loss) {
 		bictcp_reset(inet_csk_ca(sk));
@@ -442,7 +442,7 @@ static void hystart_update(struct sock *sk, u32 delay=
)
 	}
 }
=20
-static void bictcp_acked(struct sock *sk, const struct ack_sample *sampl=
e)
+static void cubictcp_acked(struct sock *sk, const struct ack_sample *sam=
ple)
 {
 	const struct tcp_sock *tp =3D tcp_sk(sk);
 	struct bictcp *ca =3D inet_csk_ca(sk);
@@ -471,13 +471,13 @@ static void bictcp_acked(struct sock *sk, const str=
uct ack_sample *sample)
 }
=20
 static struct tcp_congestion_ops cubictcp __read_mostly =3D {
-	.init		=3D bictcp_init,
-	.ssthresh	=3D bictcp_recalc_ssthresh,
-	.cong_avoid	=3D bictcp_cong_avoid,
-	.set_state	=3D bictcp_state,
+	.init		=3D cubictcp_init,
+	.ssthresh	=3D cubictcp_recalc_ssthresh,
+	.cong_avoid	=3D cubictcp_cong_avoid,
+	.set_state	=3D cubictcp_state,
 	.undo_cwnd	=3D tcp_reno_undo_cwnd,
-	.cwnd_event	=3D bictcp_cwnd_event,
-	.pkts_acked     =3D bictcp_acked,
+	.cwnd_event	=3D cubictcp_cwnd_event,
+	.pkts_acked     =3D cubictcp_acked,
 	.owner		=3D THIS_MODULE,
 	.name		=3D "cubic",
 };
--=20
2.30.2

