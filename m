Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB635319838
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 03:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhBLCLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:11:21 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33468 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229547AbhBLCLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 21:11:20 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11C2AdO3029519
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 18:10:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Gd2zBhrgP5R7Bau75kUFbZ/HqxWgLzh6SCeVmHlc+Aw=;
 b=QDiWh+H3BBqWH/1dVDjYvvvyoNSr4uS1aSGpfECKgn6vRwWmAfcEyFQKjuSwWWt/BNaY
 mUEBw+m/wgqMxlOjnozENU2nqNDDx+6HCHhQ2lKVUyBn6bR8zHR06yWsNc4ZXi7jF1Xo
 dFRw3dQgQmZprWDvaJlfKx8vpn71cO3BWuo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36mj9x21gk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 18:10:39 -0800
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 11 Feb 2021 18:10:38 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 39D6E29425C2; Thu, 11 Feb 2021 18:10:37 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH v2 bpf 2/2] bpf: selftests: Add non function pointer test to struct_ops
Date:   Thu, 11 Feb 2021 18:10:37 -0800
Message-ID: <20210212021037.267278-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210212021030.266932-1-kafai@fb.com>
References: <20210212021030.266932-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 spamscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 mlxlogscore=746 adultscore=0
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102120014
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a "void *owner" member.  The existing
bpf_tcp_ca test will ensure the bpf_cubic.o and bpf_dctcp.o
can be loaded.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
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

