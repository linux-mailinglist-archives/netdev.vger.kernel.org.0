Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE9459ECE
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 17:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfF1PZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 11:25:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28132 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726657AbfF1PZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 11:25:49 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5SFOI9A025802
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 08:25:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=oE0GQn5FKc7153IAyhqMOZZ/0EKZASrvP1hY0Di6ZXU=;
 b=Aw3UEkXiS639tBTCyuigpy8ApygbqspetRiLgcU3TcATH5j0QOqeq8Z8677HUK25negw
 hILpVBPKH4CIX4k+Xi1+0HsrlrbX5+vMb724F/YakxxLLJDWkppm6w4qtzv/SMxKVJ1o
 CjlWowICjdMF8D0bfMKFgHpedc2Rs6ieE64= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2td9ka279f-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 08:25:48 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 28 Jun 2019 08:25:46 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 0EEBB861486; Fri, 28 Jun 2019 08:25:45 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 2/4] selftests/bpf: add __int and __type macro for BTF-defined maps
Date:   Fri, 28 Jun 2019 08:25:37 -0700
Message-ID: <20190628152539.3014719-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628152539.3014719-1-andriin@fb.com>
References: <20190628152539.3014719-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=972 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280178
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add simple __int and __type macro that hide details of how type and
integer values are captured in BTF-defined maps.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/bpf_helpers.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 1a5b1accf091..aa5ddf58c088 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -8,6 +8,9 @@
  */
 #define SEC(NAME) __attribute__((section(NAME), used))
 
+#define __int(name, val) int (*name)[val]
+#define __type(name, val) val *name
+
 /* helper macro to print out debug messages */
 #define bpf_printk(fmt, ...)				\
 ({							\
-- 
2.17.1

