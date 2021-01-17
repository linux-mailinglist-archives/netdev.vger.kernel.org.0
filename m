Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6881C2F95F4
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 23:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729319AbhAQW0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 17:26:10 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33016 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730277AbhAQWXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 17:23:30 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10HMMXWl189253;
        Sun, 17 Jan 2021 22:22:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=g6eUC0AZE2t/y3Z9jca9TL3vndYBoHLh6eAFxSYY+RE=;
 b=D1Z2nUzCOsjRjzmhGUSC9X7Y4hTV0nuSuYwaog2hZtfHNue5fuR5LW/mUWc84gQGWkvw
 mdBE/Pi3ORPKAms6bTkqbKrSkp0ZfcPDGXWeunIEdU4MrGo8N3n56TZb0ZTts8y+rQ7F
 0ombTomkM2hcO+6cayTlNufjm/YaL9wYOFkiODZFGZ8wKnnaQrHPY7X208sSX7NZAoCh
 l/nZyyD293/FQSMe0ksXkT1JTpZmhVPLg5lO0+zQDYKRZHVM5Q3Xb4BRMJBlQG6WsIt1
 parmaH68NMyf2rKqWHYtZ1pDH9OAZ+jsAM9f/bb76iO2Z+7d6dj3wSFwii2BidgV1uMM uA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 363xyhj8g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Jan 2021 22:22:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10HMBJRt092429;
        Sun, 17 Jan 2021 22:20:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 364a2u5ytd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Jan 2021 22:20:32 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10HMKVFb011654;
        Sun, 17 Jan 2021 22:20:31 GMT
Received: from localhost.localdomain (/95.45.14.174)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 17 Jan 2021 14:20:30 -0800
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 1/4] libbpf: add btf_has_size() and btf_int() inlines
Date:   Sun, 17 Jan 2021 22:16:01 +0000
Message-Id: <1610921764-7526-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610921764-7526-1-git-send-email-alan.maguire@oracle.com>
References: <1610921764-7526-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9867 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101170139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9867 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 spamscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101170140
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BTF type data dumping will use them in later patches, and they
are useful generally when handling BTF data.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/btf.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 1237bcd..0c48f2e 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -294,6 +294,20 @@ static inline bool btf_is_datasec(const struct btf_type *t)
 	return btf_kind(t) == BTF_KIND_DATASEC;
 }
 
+static inline bool btf_has_size(const struct btf_type *t)
+{
+	switch (BTF_INFO_KIND(t->info)) {
+	case BTF_KIND_INT:
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+	case BTF_KIND_ENUM:
+	case BTF_KIND_DATASEC:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static inline __u8 btf_int_encoding(const struct btf_type *t)
 {
 	return BTF_INT_ENCODING(*(__u32 *)(t + 1));
@@ -309,6 +323,11 @@ static inline __u8 btf_int_bits(const struct btf_type *t)
 	return BTF_INT_BITS(*(__u32 *)(t + 1));
 }
 
+static inline __u32 btf_int(const struct btf_type *t)
+{
+	return *(__u32 *)(t + 1);
+}
+
 static inline struct btf_array *btf_array(const struct btf_type *t)
 {
 	return (struct btf_array *)(t + 1);
-- 
1.8.3.1

