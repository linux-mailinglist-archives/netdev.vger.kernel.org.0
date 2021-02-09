Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9EAF315889
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 22:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbhBIVVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 16:21:08 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64786 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233891AbhBIUrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 15:47:51 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 119JUD7D007759
        for <netdev@vger.kernel.org>; Tue, 9 Feb 2021 11:31:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=19EH864QtlUC4TumHAyoldBDRjNsmFKrSzCnd31qfTg=;
 b=Gy4HRq5Sw3p4NVPM61MVT7eEMJmb2JAzRC388yameKD7sDoCj3ku3OvDiWTGU23HG2RK
 kuqxaAofi7YsnMy6WCMxtYO2iQHHaupsv0lxfydis28G47aHtgS5p7QWTP8CCRK2JW5Y
 wLuuVtvX/iFfaCfjLhUxgBak+75YpEW/IKg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36hsgtqqp1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 11:31:15 -0800
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 9 Feb 2021 11:31:13 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 36E8B29408EB; Tue,  9 Feb 2021 11:31:12 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf 2/2] bpf: selftests: Add non function pointer test to struct_ops
Date:   Tue, 9 Feb 2021 11:31:12 -0800
Message-ID: <20210209193112.1752976-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210209193105.1752743-1-kafai@fb.com>
References: <20210209193105.1752743-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_06:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=741 spamscore=0 mlxscore=0 clxscore=1015
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090094
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a "void *owner" member.  The existing
bpf_tcp_ca test will ensure the bpf_cubic.o and bpf_dctcp.o
can be loaded.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/testing/selftests/bpf/bpf_tcp_helpers.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testin=
g/selftests/bpf/bpf_tcp_helpers.h
index 6a9053162cf2..91f0fac632f4 100644
--- a/tools/testing/selftests/bpf/bpf_tcp_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
@@ -177,6 +177,7 @@ struct tcp_congestion_ops {
 	 * after all the ca_state processing. (optional)
 	 */
 	void (*cong_control)(struct sock *sk, const struct rate_sample *rs);
+	void *owner;
 };
=20
 #define min(a, b) ((a) < (b) ? (a) : (b))
--=20
2.24.1

