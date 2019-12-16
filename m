Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADDCD120248
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 11:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfLPKYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 05:24:19 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36700 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727319AbfLPKYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 05:24:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576491857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=RFU4tPXHiyF5aYxO9pyn8VgUnU9YEjy9VpkSc1zyn5o=;
        b=eD3vwZADaZVySNwvOZY6vbSTSAOyKTAUFt6E5Ijk4DqoaolGqwrLTcJ9K03jGqJZgOcrHf
        TlU4TXgR0eaXSWrGZHeYQndqlMzwLEfgUUl5nYviwBOvvAJ6OWt7dCGP/u1C/4br1JhHmL
        IX60zDIdzT4G6S8YTNF6c9Sqb+0mNlE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-ECRB_yqzOIyY2Lspus-SCw-1; Mon, 16 Dec 2019 05:24:14 -0500
X-MC-Unique: ECRB_yqzOIyY2Lspus-SCw-1
Received: by mail-lf1-f71.google.com with SMTP id v10so475823lfa.14
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 02:24:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RFU4tPXHiyF5aYxO9pyn8VgUnU9YEjy9VpkSc1zyn5o=;
        b=i+gVu1VdKnEW3awodj7SynUSn04tna3J+AkXhOzJoTTXHKZAHoB0USt+I4bpwm0/+o
         tQxfk1C3Ml3XJWgByAZXYIjRLx2iPJVzegoZaexWAi2EcxtUO5+JQ6qIbGqvUDqsSw2G
         8+Tuuy48Pvm2jeBQ4ttxkVpCAMU8e3uLCD9jUW6LxeVaaicjDooTctW2N8xlK3VA07pw
         tX82jeySwQ7mTxJJ2nVvCpYRjIn8lC3tOY1W83Hewjyksun88gkLW3f7n/ykqQzX1kQd
         RaC2Bs5P9lktY3LcWxpoi23qEV51325Nc/mKHesYyv2A3+tdkjFK7k4aFrq7R+XtUvz8
         hVYA==
X-Gm-Message-State: APjAAAWSv8jWN9W4N3EW1XJhbDkzE4wjFlkx02YpoCaRrhavD6VHe86E
        wqg+9ZmJejmC1YfLAQNHv+CBQlRIWGcwklAB7mEUUWVU9yMvWplhVlAp7vIYtEXN57CKx4O1hJF
        13Q0n6VurofY+EPSs
X-Received: by 2002:a05:6512:48c:: with SMTP id v12mr16580115lfq.56.1576491853422;
        Mon, 16 Dec 2019 02:24:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqxyA18z62Rzo+ToA3TXc0ALhkIIhVIByPHlctWEzIt7N3SZiz4XBZPpv3n9nTXEbn8ENAZEVw==
X-Received: by 2002:a05:6512:48c:: with SMTP id v12mr16580110lfq.56.1576491853282;
        Mon, 16 Dec 2019 02:24:13 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id u20sm10203028lju.34.2019.12.16.02.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 02:24:12 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D1C101819EB; Mon, 16 Dec 2019 11:24:11 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next] samples/bpf: Add missing -lz to TPROGS_LDLIBS
Date:   Mon, 16 Dec 2019 11:24:05 +0100
Message-Id: <20191216102405.353834-1-toke@redhat.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since libbpf now links against zlib, this needs to be included in the
linker invocation for the userspace programs in samples/bpf that link
statically against libbpf.

Fixes: 166750bc1dd2 ("libbpf: Support libbpf-provided extern variables")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 samples/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 1fc42ad8ff49..b00651608765 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -196,7 +196,7 @@ endif
 
 TPROGCFLAGS_bpf_load.o += -Wno-unused-variable
 
-TPROGS_LDLIBS			+= $(LIBBPF) -lelf
+TPROGS_LDLIBS			+= $(LIBBPF) -lelf -lz
 TPROGLDLIBS_tracex4		+= -lrt
 TPROGLDLIBS_trace_output	+= -lrt
 TPROGLDLIBS_map_perf_test	+= -lrt
-- 
2.24.0

