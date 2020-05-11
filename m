Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587891CD893
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 13:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgEKLdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 07:33:21 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30354 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729441AbgEKLcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 07:32:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589196760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hQUkEydOpp6BWEZjpv9SKHKYKamnTJBvfR8HfV65p3I=;
        b=EDO5PDlEgc1bPLhwB19nvgl8ml0KnuapWx2+XqyDYhtZ/6w0Vc+NdWD1gK1cVpm7lTYamY
        tiXvWy5oTfSJayUs3Gcw4M4wNCZnOHdVa87x4eWfavqoy/aVXTToxogobP+jtxHumOwqYT
        MOeL5XHkoB/gPYgS8S2W6Cj+57QkJtk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-CBg9YuoCPhuBo7lN4SbIMw-1; Mon, 11 May 2020 07:32:38 -0400
X-MC-Unique: CBg9YuoCPhuBo7lN4SbIMw-1
Received: by mail-wr1-f72.google.com with SMTP id x8so5104514wrl.16
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 04:32:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hQUkEydOpp6BWEZjpv9SKHKYKamnTJBvfR8HfV65p3I=;
        b=bB4zTcco8KSOZeRBdebp7jjRK2gbCf+F8yrtd/2/UUCUKkfZtCBMl445ySN0dcyGN5
         +MiSEXdMX92TgCr8xBe4GwoUqkyJVWP13J9mdgTpECFUp4t1UET3DdCVbG/+Qzu3ICbU
         O7KYiqwBJE2ztPlsKqnjTI6TH+w5nfx/HZG1KMp+gDsPs2Ml+EuTIFX1EudccONrAwUy
         COvhSu+uVv+PBKq7unILRcpeGhfkPjzeL2eL1NSXnUDQ0U8RVlSEJMVEj/Bk/92VVPv6
         2yQ/GcJUG8JocScZ5KEkyD0vM+QV6Q5r5/B3ssQJKT33kMDdv58TfSse8V8Zz9j98kgT
         eV7Q==
X-Gm-Message-State: AGi0Pualj0Y0MHK+Xa3VFQqwv458AdQpp6qZ2NtGX6ugkmlj/K8tULpP
        9Dtw1hiWcTxkKTkPM5aN3aTHpI3PVjyFezWvcnQ4m1kAkLaevBMT48g91iEcUaEz+QQ0uFAj4FS
        HpR5HhC2iYx6MoiAf
X-Received: by 2002:adf:f6c4:: with SMTP id y4mr19901706wrp.81.1589196757832;
        Mon, 11 May 2020 04:32:37 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ3X2Ouavx+PztaCv6hUD+xToftSDRS9MEcEfVLu6LTOlsm3dxf6NwZdhPy6/02ob/g675gpA==
X-Received: by 2002:adf:f6c4:: with SMTP id y4mr19901675wrp.81.1589196757643;
        Mon, 11 May 2020 04:32:37 -0700 (PDT)
Received: from raver.teknoraver.net (net-2-44-90-75.cust.vodafonedsl.it. [2.44.90.75])
        by smtp.gmail.com with ESMTPSA id e22sm1835043wrc.41.2020.05.11.04.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 04:32:36 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Joe Stringer <joe@ovn.org>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf] samples: bpf: fix build error
Date:   Mon, 11 May 2020 13:32:34 +0200
Message-Id: <20200511113234.80722-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC 10 is very strict about symbol clash, and lwt_len_hist_user contains
a symbol which clashes with libbpf:

/usr/bin/ld: samples/bpf/lwt_len_hist_user.o:(.bss+0x0): multiple definition of `bpf_log_buf'; samples/bpf/bpf_load.o:(.bss+0x8c0): first defined here
collect2: error: ld returned 1 exit status

bpf_log_buf here seems to be a leftover, so removing it.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 samples/bpf/lwt_len_hist_user.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/samples/bpf/lwt_len_hist_user.c b/samples/bpf/lwt_len_hist_user.c
index 587b68b1f8dd..430a4b7e353e 100644
--- a/samples/bpf/lwt_len_hist_user.c
+++ b/samples/bpf/lwt_len_hist_user.c
@@ -15,8 +15,6 @@
 #define MAX_INDEX 64
 #define MAX_STARS 38
 
-char bpf_log_buf[BPF_LOG_BUF_SIZE];
-
 static void stars(char *str, long val, long max, int width)
 {
 	int i;
-- 
2.26.2

