Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716484D2B57
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbiCIJGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiCIJGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:06:23 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85FB16BCD6
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 01:05:18 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2298aRbs006360
        for <netdev@vger.kernel.org>; Wed, 9 Mar 2022 01:05:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=KluOUSeW1+Dgl//S5xxTHGrFjiHGbnuFXcPS51+AlbI=;
 b=N/e5HdWtvb9ikbxldq1bVTBYnRPqDXEoYk4IQ5lpXuQc/UkFGd23ccN4o8o8nJm8eTs9
 I0WtDbbAGkNuDFcJAH0JTNcn1t+UawNrJ8ZiXvMRZ9UFiU5py/s6D052Yrm/X77i7T1Z
 dU3tlb35mMk4czXNzkxCMBnWjGCTyT1So1U= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ep2wh0fek-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 01:05:18 -0800
Received: from twshared33837.14.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 01:05:17 -0800
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id 859F61ADC609; Wed,  9 Mar 2022 01:05:15 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 5/5] bpf: selftests: Update tests after s/delivery_time/tstamp/ change in bpf.h
Date:   Wed, 9 Mar 2022 01:05:15 -0800
Message-ID: <20220309090515.3712742-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220309090444.3710464-1-kafai@fb.com>
References: <20220309090444.3710464-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: UvTQj7rE6tS0hT8eeWUobtAzRLhth9sC
X-Proofpoint-ORIG-GUID: UvTQj7rE6tS0hT8eeWUobtAzRLhth9sC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-09_04,2022-03-04_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous patch made the follow changes:
- s/delivery_time_type/tstamp_type/
- s/bpf_skb_set_delivery_time/bpf_skb_set_tstamp/
- BPF_SKB_DELIVERY_TIME_* to BPF_SKB_TSTAMP_*

This patch is to change the test_tc_dtime.c to reflect the above.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../selftests/bpf/progs/test_tc_dtime.c       | 38 +++++++++----------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_tc_dtime.c b/tools/te=
sting/selftests/bpf/progs/test_tc_dtime.c
index 9d9e8e17b8a0..06f300d06dbd 100644
--- a/tools/testing/selftests/bpf/progs/test_tc_dtime.c
+++ b/tools/testing/selftests/bpf/progs/test_tc_dtime.c
@@ -174,13 +174,13 @@ int egress_host(struct __sk_buff *skb)
 		return TC_ACT_OK;
=20
 	if (skb_proto(skb_type) =3D=3D IPPROTO_TCP) {
-		if (skb->delivery_time_type =3D=3D BPF_SKB_DELIVERY_TIME_MONO &&
+		if (skb->tstamp_type =3D=3D BPF_SKB_TSTAMP_DELIVERY_MONO &&
 		    skb->tstamp)
 			inc_dtimes(EGRESS_ENDHOST);
 		else
 			inc_errs(EGRESS_ENDHOST);
 	} else {
-		if (skb->delivery_time_type =3D=3D BPF_SKB_DELIVERY_TIME_UNSPEC &&
+		if (skb->tstamp_type =3D=3D BPF_SKB_TSTAMP_UNSPEC &&
 		    skb->tstamp)
 			inc_dtimes(EGRESS_ENDHOST);
 		else
@@ -204,7 +204,7 @@ int ingress_host(struct __sk_buff *skb)
 	if (!skb_type)
 		return TC_ACT_OK;
=20
-	if (skb->delivery_time_type =3D=3D BPF_SKB_DELIVERY_TIME_MONO &&
+	if (skb->tstamp_type =3D=3D BPF_SKB_TSTAMP_DELIVERY_MONO &&
 	    skb->tstamp =3D=3D EGRESS_FWDNS_MAGIC)
 		inc_dtimes(INGRESS_ENDHOST);
 	else
@@ -226,7 +226,7 @@ int ingress_fwdns_prio100(struct __sk_buff *skb)
 		return TC_ACT_OK;
=20
 	/* delivery_time is only available to the ingress
-	 * if the tc-bpf checks the skb->delivery_time_type.
+	 * if the tc-bpf checks the skb->tstamp_type.
 	 */
 	if (skb->tstamp =3D=3D EGRESS_ENDHOST_MAGIC)
 		inc_errs(INGRESS_FWDNS_P100);
@@ -250,7 +250,7 @@ int egress_fwdns_prio100(struct __sk_buff *skb)
 		return TC_ACT_OK;
=20
 	/* delivery_time is always available to egress even
-	 * the tc-bpf did not use the delivery_time_type.
+	 * the tc-bpf did not use the tstamp_type.
 	 */
 	if (skb->tstamp =3D=3D INGRESS_FWDNS_MAGIC)
 		inc_dtimes(EGRESS_FWDNS_P100);
@@ -278,9 +278,9 @@ int ingress_fwdns_prio101(struct __sk_buff *skb)
 	if (skb_proto(skb_type) =3D=3D IPPROTO_UDP)
 		expected_dtime =3D 0;
=20
-	if (skb->delivery_time_type) {
+	if (skb->tstamp_type) {
 		if (fwdns_clear_dtime() ||
-		    skb->delivery_time_type !=3D BPF_SKB_DELIVERY_TIME_MONO ||
+		    skb->tstamp_type !=3D BPF_SKB_TSTAMP_DELIVERY_MONO ||
 		    skb->tstamp !=3D expected_dtime)
 			inc_errs(INGRESS_FWDNS_P101);
 		else
@@ -290,14 +290,14 @@ int ingress_fwdns_prio101(struct __sk_buff *skb)
 			inc_errs(INGRESS_FWDNS_P101);
 	}
=20
-	if (skb->delivery_time_type =3D=3D BPF_SKB_DELIVERY_TIME_MONO) {
+	if (skb->tstamp_type =3D=3D BPF_SKB_TSTAMP_DELIVERY_MONO) {
 		skb->tstamp =3D INGRESS_FWDNS_MAGIC;
 	} else {
-		if (bpf_skb_set_delivery_time(skb, INGRESS_FWDNS_MAGIC,
-					      BPF_SKB_DELIVERY_TIME_MONO))
+		if (bpf_skb_set_tstamp(skb, INGRESS_FWDNS_MAGIC,
+				       BPF_SKB_TSTAMP_DELIVERY_MONO))
 			inc_errs(SET_DTIME);
-		if (!bpf_skb_set_delivery_time(skb, INGRESS_FWDNS_MAGIC,
-					       BPF_SKB_DELIVERY_TIME_UNSPEC))
+		if (!bpf_skb_set_tstamp(skb, INGRESS_FWDNS_MAGIC,
+					BPF_SKB_TSTAMP_UNSPEC))
 			inc_errs(SET_DTIME);
 	}
=20
@@ -320,9 +320,9 @@ int egress_fwdns_prio101(struct __sk_buff *skb)
 		/* Should have handled in prio100 */
 		return TC_ACT_SHOT;
=20
-	if (skb->delivery_time_type) {
+	if (skb->tstamp_type) {
 		if (fwdns_clear_dtime() ||
-		    skb->delivery_time_type !=3D BPF_SKB_DELIVERY_TIME_MONO ||
+		    skb->tstamp_type !=3D BPF_SKB_TSTAMP_DELIVERY_MONO ||
 		    skb->tstamp !=3D INGRESS_FWDNS_MAGIC)
 			inc_errs(EGRESS_FWDNS_P101);
 		else
@@ -332,14 +332,14 @@ int egress_fwdns_prio101(struct __sk_buff *skb)
 			inc_errs(EGRESS_FWDNS_P101);
 	}
=20
-	if (skb->delivery_time_type =3D=3D BPF_SKB_DELIVERY_TIME_MONO) {
+	if (skb->tstamp_type =3D=3D BPF_SKB_TSTAMP_DELIVERY_MONO) {
 		skb->tstamp =3D EGRESS_FWDNS_MAGIC;
 	} else {
-		if (bpf_skb_set_delivery_time(skb, EGRESS_FWDNS_MAGIC,
-					      BPF_SKB_DELIVERY_TIME_MONO))
+		if (bpf_skb_set_tstamp(skb, EGRESS_FWDNS_MAGIC,
+				       BPF_SKB_TSTAMP_DELIVERY_MONO))
 			inc_errs(SET_DTIME);
-		if (!bpf_skb_set_delivery_time(skb, EGRESS_FWDNS_MAGIC,
-					       BPF_SKB_DELIVERY_TIME_UNSPEC))
+		if (!bpf_skb_set_tstamp(skb, INGRESS_FWDNS_MAGIC,
+					BPF_SKB_TSTAMP_UNSPEC))
 			inc_errs(SET_DTIME);
 	}
=20
--=20
2.30.2

