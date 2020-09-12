Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E602677F0
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 06:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgILE7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 00:59:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45156 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725850AbgILE7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 00:59:30 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08C4sig4003594
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 21:59:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=x6FxozHh27/sVb52p3XRqCQC4WI6lR5BG6R/Dw+nvnM=;
 b=oWuggsdNpoBg89jlOTRYX/BwUQKF/vfPbtNLZ3ivgK4a166haXRCdlNTa488VpFE7DYz
 RzI6A07bupjKHWKAV02xdWhFuuz1GZD+dDWSZk9HVINEgln5phFFCmKK9beJOmpa0YBU
 /unQlJQ+pwTEYbaZYqt76rq4hTp1LcHmQU8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33fhxujygu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 21:59:29 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 11 Sep 2020 21:59:28 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id C47352945F51; Fri, 11 Sep 2020 21:59:17 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: [PATCH RFC bpf-next 0/2] bpf: Enable bpf_skc_to_* sock casting helper to networking prog type
Date:   Fri, 11 Sep 2020 21:59:17 -0700
Message-ID: <20200912045917.2992578-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-12_01:2020-09-10,2020-09-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 suspectscore=1 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 adultscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=408 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009120048
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set allows networking prog type to directly read fields from
the in-kernel socket type, e.g. "struct tcp_sock".

Patch 2 has the details on the use case.

It is currently under RFC since it needs proper tests and it builds on
top of Lorenz's patches:=20
   https://lore.kernel.org/bpf/20200910125631.225188-1-lmb@cloudflare.com=
/

Martin KaFai Lau (2):
  bpf: Move the PTR_TO_BTF_ID check to check_reg_type()
  bpf: Enable bpf_skc_to_* sock casting helper to networking prog type

 kernel/bpf/verifier.c | 85 +++++++++++++++++++++++++++----------------
 net/core/filter.c     | 69 +++++++++++++++++++++++++----------
 2 files changed, 103 insertions(+), 51 deletions(-)

--=20
2.24.1

