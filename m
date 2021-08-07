Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975C23E3662
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 19:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhHGRAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 13:00:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21450 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229614AbhHGQ6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 12:58:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628355495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+Wk6KKmfIbCVhzm5mHVZmh4o4+U4BbsQ7OXtpgEsF1k=;
        b=NgTBAFJa7TCpzuk/FcM6QWqphGvd7ual9Z5I5ikh6bwF/xEFWmFomca7WVdZdG0Z8unxsy
        s6TKdoailbMsW5S4YaLV5QiKlqbzPp0/ZKcJ6fONj8moUWoJuMhzs0fjyUBf79ThXC2n9e
        IK5rr+9RcD1xu1XskND4aL/bUrn/8S4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-SvDRvHNtMcewAJkSc0kAhw-1; Sat, 07 Aug 2021 12:58:14 -0400
X-MC-Unique: SvDRvHNtMcewAJkSc0kAhw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19979760C0;
        Sat,  7 Aug 2021 16:58:13 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 167735B826;
        Sat,  7 Aug 2021 16:58:09 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, haliu@redhat.com
Subject: [PATCH iproute2] lib: bpf_glue: remove useless assignment
Date:   Sat,  7 Aug 2021 18:58:02 +0200
Message-Id: <25ea92f064e11ba30ae696b176df9d6b0aaaa66a.1628352013.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value of s used inside the cycle is the result of strstr(), so this
assignment is useless.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 lib/bpf_glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/bpf_glue.c b/lib/bpf_glue.c
index eaa9504f..70d00184 100644
--- a/lib/bpf_glue.c
+++ b/lib/bpf_glue.c
@@ -63,7 +63,7 @@ const char *get_libbpf_version(void)
 	if (fp == NULL)
 		goto out;
 
-	while ((s = fgets(buf, sizeof(buf), fp)) != NULL) {
+	while (fgets(buf, sizeof(buf), fp) != NULL) {
 		if ((s = strstr(buf, "libbpf.so.")) != NULL) {
 			strncpy(_libbpf_version, s+10, sizeof(_libbpf_version)-1);
 			strtok(_libbpf_version, "\n");
-- 
2.31.1

