Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351CA1FA310
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 23:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgFOVuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 17:50:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25774 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726275AbgFOVuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 17:50:02 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05FLehla010887
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 14:50:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=fm+NbO4L+q2VNFa4whOmcS49Lv0eIcbwx/82lo9KzMs=;
 b=MFMyHCL03OU5G/fgw84/U64d3+4JeibNlt4oKI8ubh7ub0oyx49M9Zh6bxQWRzDCYh1S
 xecQ3jROXLHGXGdBQR9oL5kV11YyUl14VYZPKoHybqiaH2VXgPXs7g5KtU7QVOvPcOpE
 ISeIqgh3gD9C0bVGhqJxFBGJHevu+p14Cds= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31nen96ty0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 14:50:01 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 15 Jun 2020 14:49:34 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0D2B42EC36F3; Mon, 15 Jun 2020 14:49:28 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf: fix definition of bpf_ringbuf_output() helper in UAPI comments
Date:   Mon, 15 Jun 2020 14:49:26 -0700
Message-ID: <20200615214926.3638836-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-15_11:2020-06-15,2020-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 phishscore=0 adultscore=0 priorityscore=1501
 cotscore=-2147483648 impostorscore=0 mlxlogscore=737 mlxscore=0
 suspectscore=8 bulkscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006150155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix definition of bpf_ringbuf_output() in UAPI header comments, which is =
used
to generate libbpf's bpf_helper_defs.h header. Return value is a number (=
erro
code), not a pointer.

Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support=
 for it")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/uapi/linux/bpf.h       | 2 +-
 tools/include/uapi/linux/bpf.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 19684813faae..974a71342aea 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3168,7 +3168,7 @@ union bpf_attr {
  *	Return
  *		The id is returned or 0 in case the id could not be retrieved.
  *
- * void *bpf_ringbuf_output(void *ringbuf, void *data, u64 size, u64 fla=
gs)
+ * int bpf_ringbuf_output(void *ringbuf, void *data, u64 size, u64 flags=
)
  * 	Description
  * 		Copy *size* bytes from *data* into a ring buffer *ringbuf*.
  * 		If BPF_RB_NO_WAKEUP is specified in *flags*, no notification of
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 19684813faae..974a71342aea 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3168,7 +3168,7 @@ union bpf_attr {
  *	Return
  *		The id is returned or 0 in case the id could not be retrieved.
  *
- * void *bpf_ringbuf_output(void *ringbuf, void *data, u64 size, u64 fla=
gs)
+ * int bpf_ringbuf_output(void *ringbuf, void *data, u64 size, u64 flags=
)
  * 	Description
  * 		Copy *size* bytes from *data* into a ring buffer *ringbuf*.
  * 		If BPF_RB_NO_WAKEUP is specified in *flags*, no notification of
--=20
2.24.1

