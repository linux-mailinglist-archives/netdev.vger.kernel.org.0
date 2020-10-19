Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29246292E8F
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 21:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731071AbgJSTmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 15:42:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47186 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730021AbgJSTmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 15:42:11 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09JJeeYl006360
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 12:42:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=8zjm7XAzaxYCuw5Fkzj1GkY0vWI4f8xJu08mBtuJ6s4=;
 b=TcHFpPqi0D2hxb7bVs/kRA7RTAWqxLmdjTWDdaJxjtTT9ko2McIl0lFU4sUqqBRgrd8L
 FjuAZUSNi363FvL1fJ0s9RYt11KhmkgpOlhI6NYULCwt2rXp+Am/WBGq1aYMxwrr0yxm
 zxbzyB1VCIFp/A0ODWRiHYTCB/WoQ6y1FGM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 348gsbppb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 12:42:10 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 19 Oct 2020 12:42:09 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id A87DC2946269; Mon, 19 Oct 2020 12:42:06 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hao Luo <haoluo@google.com>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf 0/3] bpf: Enforce NULL check on new _OR_NULL return types
Date:   Mon, 19 Oct 2020 12:42:06 -0700
Message-ID: <20201019194206.1050591-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-19_10:2020-10-16,2020-10-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 impostorscore=0
 suspectscore=13 mlxlogscore=521 adultscore=0 bulkscore=0 mlxscore=0
 spamscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010190132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set enforces NULL check on the new helper return types,
RET_PTR_TO_BTF_ID_OR_NULL and RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL.

Martin KaFai Lau (3):
  bpf: Enforce id generation for all may-be-null register type
  bpf: selftest: Ensure the return value of bpf_skc_to helpers must be
    checked
  bpf: selftest: Ensure the return value of the bpf_per_cpu_ptr() must
    be checked

 kernel/bpf/verifier.c                         | 11 ++--
 .../selftests/bpf/prog_tests/ksyms_btf.c      | 57 +++++++++++++------
 .../bpf/progs/test_ksyms_btf_null_check.c     | 31 ++++++++++
 tools/testing/selftests/bpf/verifier/sock.c   | 25 ++++++++
 4 files changed, 100 insertions(+), 24 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf_null=
_check.c

--=20
2.24.1

