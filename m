Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC481261B5
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 13:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfLSMH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 07:07:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29304 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726668AbfLSMH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 07:07:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576757248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Br/cg8Xfu6sMsg27brwJ8qm737WLDYMwR8gi4ySebN4=;
        b=hdFGVUJY9BVMfX2yMe27tTGW4mh9ikeMO2u9hmE8KvaNhX3Rx0OstLNvtjZnvFH6lKiY3P
        JfbCqyDIfrsMZdTT04b7vOni9zIWGAs+fkJDxd5HGRJ7BtdYY3tWQR6uQsCcgpX2j1RCnT
        Y3w/RpfUw8vkXSZ9rkdTUz0kIp2uGgw=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-6T0GvTlfOMilUBslDSDboA-1; Thu, 19 Dec 2019 07:07:27 -0500
X-MC-Unique: 6T0GvTlfOMilUBslDSDboA-1
Received: by mail-lj1-f200.google.com with SMTP id j23so1834262lji.23
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 04:07:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Br/cg8Xfu6sMsg27brwJ8qm737WLDYMwR8gi4ySebN4=;
        b=Z4sdQ7tt8GcA1yytJ500ZPSjRdmgsMvEvY6gfXCukBiW2ZWHawh4Up2MjtS18GH53A
         bYNeIR6aJtNY5YnaYak7I7jzesBM+A0Qq+U6vbKWo458NCgICoynx68fF9GfZ/DC+fhD
         /2A/yFXebOvvl4kPIgondZFr3k7+IasfYiAgKNaplzhI1or+EnMKDhQanOJrWZpKBEZC
         v9lIIqErT63F+NDi2W6CLsRrRS6GGsazlhcZcexZe2Vty1Jy1MK0w2enitfDfHER/fb2
         okS3D0Uw3HmTUkcL7+leMFsveDVGWmCoiDLIP0dzszuyPs+ZCOBqTnYF1isF/kPtPdcP
         jgxg==
X-Gm-Message-State: APjAAAVIjd79/ptXljwGr4lRNgvdGvbd+oXuQFdGVx7m5hfYVqcYUlwU
        eAlBgpFPlXsgEOZjn0d05HoNk1VCgZT7xpEZ7mZ9jqCgsrghgG26dxMqnbG/2K2KeYPc9/N2lmN
        Vux72BYvpdf/1MT6x
X-Received: by 2002:a2e:3609:: with SMTP id d9mr5632726lja.188.1576757245588;
        Thu, 19 Dec 2019 04:07:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqx+DUn8p4tIwpYWIONrSldquMChWpqKujbcbHNpW4ZKGW2L9RPA7P1btsS8OQaY+xN5eRD+fw==
X-Received: by 2002:a2e:3609:: with SMTP id d9mr5632706lja.188.1576757245329;
        Thu, 19 Dec 2019 04:07:25 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id y14sm2754049ljk.46.2019.12.19.04.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 04:07:24 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 47B5B180969; Thu, 19 Dec 2019 13:07:23 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next] libbpf: Add missing newline in opts validation macro
Date:   Thu, 19 Dec 2019 13:07:14 +0100
Message-Id: <20191219120714.928380-1-toke@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error log output in the opts validation macro was missing a newline.

Fixes: 2ce8450ef5a3 ("libbpf: add bpf_object__open_{file, mem} w/ extensible opts")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf_internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 7d71621bb7e8..8c3afbd97747 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -76,7 +76,7 @@ static inline bool libbpf_validate_opts(const char *opts,
 
 		for (i = opts_sz; i < user_sz; i++) {
 			if (opts[i]) {
-				pr_warn("%s has non-zero extra bytes",
+				pr_warn("%s has non-zero extra bytes\n",
 					type_name);
 				return false;
 			}
-- 
2.24.1

