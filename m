Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA625184B9B
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 16:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgCMPsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 11:48:25 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:41370 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgCMPsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 11:48:24 -0400
Received: by mail-qv1-f68.google.com with SMTP id a10so4802823qvq.8;
        Fri, 13 Mar 2020 08:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1fjdWYaARiMbD5URtOSuvWLjsUmRZ4Mp3HLmBzQW/kM=;
        b=OlpNUfGOqKNwfcKusKki8o85abd9opIo74cZ9U6Pj+Cgs+oB1tSiLTFQWvOoJlX1Nk
         BZ4izs2ZbVrYjO/5z+8mKjAH26iRUnZ9SNhMAwCGNJELccfJszsB0yQu7sRJKSjp61tY
         QUFeTIZ73BYINgCKrAghFJwexBwjKhTCioFD2bdndCCJS8SIZaq85mUEsNPgqtsdHxX+
         1UBZnjwKhX16cdgtv3c5vqtzI4LCKZgZ9brpoS8PdJnHHq0P5pScRzHixWtzjOLJ9czt
         6W8tGvbjg3Y9pYci+Gb9RSxL/Vn45N1G1YCC1w00LnPtS2kZOPvraznH8vweFB3AbJW8
         ScPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1fjdWYaARiMbD5URtOSuvWLjsUmRZ4Mp3HLmBzQW/kM=;
        b=B6j6j/exKiLDbShkOd5sW7vJJwLNDfi6iONgaK1M7NvMLwp162VltwBHhCP+mKCMYR
         WumQazF/p5fd7WwhvJ+UoTOxrbA3D9MKxaKwo/H0NXyiNajttwVmCMtlZerOF5YMqRQy
         ysdOjngpfdps9J6r6nHucIRtYmsZsI7RrgCK09XIj4Qyxdwt/FaldFLlZtuOHXnTQyz0
         o2WatO2vzzomiBpsrqObylhUI+pnIdVvYoDhKmtXwDBbAAAwTnI6q6dI2jTV3EKIJPJq
         oj+XBR9wvupUjWhmxu6PAt++fdEE8zSX5jZ9HO8u5MINGV3mzYCCc1GAmuDivbkP4Dy3
         YB7A==
X-Gm-Message-State: ANhLgQ2SdbUlK/9Y2bRRQZ4iSMk0sy3HWW1c2F7fJ5lORe194MpFzDOU
        /0BLabSwVRFMGCXkrpKVvsq+ClXF8GyGxKLs
X-Google-Smtp-Source: ADFU+vsQ5fmp9gmkM5tX7JbcggSnBTA5OKGHgShhhU7XIfSe/+4eyeP6F8XxxDpPg+MovX7YB3Z6DA==
X-Received: by 2002:a0c:e450:: with SMTP id d16mr13178869qvm.195.1584114503027;
        Fri, 13 Mar 2020 08:48:23 -0700 (PDT)
Received: from localhost.localdomain (pc-184-104-160-190.cm.vtr.net. [190.160.104.184])
        by smtp.googlemail.com with ESMTPSA id m6sm4600281qkh.33.2020.03.13.08.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 08:48:22 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, quentin@isovalent.com, ebiederm@xmission.com,
        brouer@redhat.com, bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH bpf-next] bpf_helpers_doc.py: Fix warning when compiling bpftool.
Date:   Fri, 13 Mar 2020 12:46:50 -0300
Message-Id: <20200313154650.13366-1-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


When compiling bpftool the following warning is found: 
"declaration of 'struct bpf_pidns_info' will not be visible outside of this function."
This patch adds struct bpf_pidns_info to type_fwds array to fix this.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 scripts/bpf_helpers_doc.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index c1e2b5410faa..f43d193aff3a 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -400,6 +400,7 @@ class PrinterHelpers(Printer):
             'struct bpf_fib_lookup',
             'struct bpf_perf_event_data',
             'struct bpf_perf_event_value',
+            'struct bpf_pidns_info',
             'struct bpf_sock',
             'struct bpf_sock_addr',
             'struct bpf_sock_ops',
-- 
2.20.1

