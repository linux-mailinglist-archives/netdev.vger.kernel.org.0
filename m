Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEA73175DA3
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 15:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgCBOyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 09:54:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23575 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727121AbgCBOyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 09:54:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583160850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZTkROsrUTdzNCh0BfP2A3pspJU0Gn3G6vf5gKcgh6ic=;
        b=FVtLTPPfgTMuNQnGXgRM4aIqiCCxSAsrua7z+g8BqGRVLb98L9y+qbgHtkdCR0qn17AOBH
        ctwO7WpvMeFe2kDAvKGrtDxlG/NFae0y054V2diJJUqEREldxtUzyCwPPHfz7/vtAF80Gn
        sxqqPERE7H9QxjO/U6UMlUuH2dD+sG8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-2ECmSnU7Oc-IGQ03IMCBtw-1; Mon, 02 Mar 2020 09:54:09 -0500
X-MC-Unique: 2ECmSnU7Oc-IGQ03IMCBtw-1
Received: by mail-wm1-f72.google.com with SMTP id c5so2980047wmd.8
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 06:54:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZTkROsrUTdzNCh0BfP2A3pspJU0Gn3G6vf5gKcgh6ic=;
        b=XXO2/0oDRxjjmg5OEYEbI5nPpiuYlRfFkL+0LB0Rn0gIdmwPO3io/+GLridkE3qlx1
         mya7tZiuhII3tI49GaWHBVv5ITI6Ikj+4JlAxlh4GBc9oOvcwhT0X8891hXt/ta3R/Ip
         FYwUpFerhzGvXOYXxy/xszioCuLzuW1fhhir0DmHjt7Idg1z5GuiY/874rIZCOieMijc
         7lfIiRHEs0RnlyrnBCHI/mV41ZyEWrS6S4aYcl0nV3yMxGzEpnlPlTX4vjdjzL16uj66
         5yjJ+9leYeCffPYileaOgaYFofRPa0ZwfTi8GpQ0ly3oEjyxW6/sUF0ZtmQof6Qpt1EL
         TYnQ==
X-Gm-Message-State: ANhLgQ10ZHWQU3rJ4AU/4lG2PP1h4NbAtKfaWUcSCXz+qUN/g/0PuXuu
        hdYqI7M+6nD164Jjgc/2PxS5iUmw6WkP4dirmy5bbRfQGhcSZPpLUt5nvnTfGTxPs0CWAHDVlar
        GSny1U6dOXnjLfMGu
X-Received: by 2002:adf:e5d1:: with SMTP id a17mr2558wrn.412.1583160848132;
        Mon, 02 Mar 2020 06:54:08 -0800 (PST)
X-Google-Smtp-Source: ADFU+vvf8Xk8oDca8+rjR4ZesAQxWjFtwuxOEnlT6X1h5GQF5BXAG+hD6IlWC37uYrSFSYkWOZpfXw==
X-Received: by 2002:adf:e5d1:: with SMTP id a17mr2536wrn.412.1583160847943;
        Mon, 02 Mar 2020 06:54:07 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id u185sm16632096wmg.6.2020.03.02.06.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 06:54:07 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7B1B7180362; Mon,  2 Mar 2020 15:54:05 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrey Ignatov <rdna@fb.com>
Subject: [PATCH bpf] selftests/bpf: Declare bpf_log_buf variables as static
Date:   Mon,  2 Mar 2020 15:53:48 +0100
Message-Id: <20200302145348.559177-1-toke@redhat.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cgroup selftests did not declare the bpf_log_buf variable as static, leading
to a linker error with GCC 10 (which defaults to -fno-common). Fix this by
adding the missing static declarations.

Fixes: 257c88559f36 ("selftests/bpf: Convert test_cgroup_attach to prog_tests")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../testing/selftests/bpf/prog_tests/cgroup_attach_autodetach.c | 2 +-
 tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c    | 2 +-
 tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_autodetach.c b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_autodetach.c
index 5b13f2c6c402..70e94e783070 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_autodetach.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_autodetach.c
@@ -6,7 +6,7 @@
 
 #define PING_CMD	"ping -q -c1 -w1 127.0.0.1 > /dev/null"
 
-char bpf_log_buf[BPF_LOG_BUF_SIZE];
+static char bpf_log_buf[BPF_LOG_BUF_SIZE];
 
 static int prog_load(void)
 {
diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c
index 2ff21dbce179..139f8e82c7c6 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c
@@ -6,7 +6,7 @@
 
 #define PING_CMD	"ping -q -c1 -w1 127.0.0.1 > /dev/null"
 
-char bpf_log_buf[BPF_LOG_BUF_SIZE];
+static char bpf_log_buf[BPF_LOG_BUF_SIZE];
 
 static int map_fd = -1;
 
diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c
index 9d8cb48b99de..9e96f8d87fea 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c
@@ -8,7 +8,7 @@
 #define BAR		"/foo/bar/"
 #define PING_CMD	"ping -q -c1 -w1 127.0.0.1 > /dev/null"
 
-char bpf_log_buf[BPF_LOG_BUF_SIZE];
+static char bpf_log_buf[BPF_LOG_BUF_SIZE];
 
 static int prog_load(int verdict)
 {
-- 
2.25.1

