Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8D234C08D
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 02:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhC2Acz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 20:32:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18258 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229822AbhC2AcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 20:32:24 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 12T0SSBs031047
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 17:32:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=jGSGL3zSTZ+ipxV4hujAeuEq1Gwr2zSHREM8TT6fzZU=;
 b=YC6+EqqnO/IUqd10AMUOE6ix3SK6V+KkcqqSHAOZQQC9qcAhZgFK9HvO1HTocxOID0+X
 +ozPIGlH5iENl3AlBzqRJ+9E1pRKFXP1CwRcIoFVpJUu4Go7SRad2dYDNYRTYjhL01pk
 9pgzFHY7zg/zXx3SLyAg6d6AJZc6C8jge4Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 37j0cpnren-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 17:32:22 -0700
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 28 Mar 2021 17:32:21 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 827902942AB6; Sun, 28 Mar 2021 17:32:13 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next] bpf: tcp: Fix an error in the bpf_tcp_ca_kfunc_ids list
Date:   Sun, 28 Mar 2021 17:32:13 -0700
Message-ID: <20210329003213.2274210-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: cwp74bjaZM7pkJNl6ch-BNpz-gyip_TS
X-Proofpoint-ORIG-GUID: cwp74bjaZM7pkJNl6ch-BNpz-gyip_TS
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-28_14:2021-03-26,2021-03-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 clxscore=1015 mlxscore=0 priorityscore=1501 mlxlogscore=841
 malwarescore=0 spamscore=0 adultscore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103290001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a typo in the bbr function, s/even/event/.
This patch fixes it.

Fixes: e78aea8b2170 ("bpf: tcp: Put some tcp cong functions in allowlist =
for bpf-tcp-cc")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv4/bpf_tcp_ca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 12777d444d0f..6bb7b335ff9f 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -206,7 +206,7 @@ BTF_ID(func, bbr_init)
 BTF_ID(func, bbr_main)
 BTF_ID(func, bbr_sndbuf_expand)
 BTF_ID(func, bbr_undo_cwnd)
-BTF_ID(func, bbr_cwnd_even)
+BTF_ID(func, bbr_cwnd_event)
 BTF_ID(func, bbr_ssthresh)
 BTF_ID(func, bbr_min_tso_segs)
 BTF_ID(func, bbr_set_state)
--=20
2.30.2

