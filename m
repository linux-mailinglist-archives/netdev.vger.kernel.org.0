Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBA5F9A27A
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403834AbfHVV61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 17:58:27 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44054 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732386AbfHVV61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 17:58:27 -0400
Received: by mail-pl1-f196.google.com with SMTP id t14so4223135plr.11;
        Thu, 22 Aug 2019 14:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=sigJYFk+Q8pR1o6eZ0D86keNFXFBPNuofqZlri3Zfmk=;
        b=MMyLRLW7rKWEn3A5ln1ByMZuj2c1D9cAVkujgr3g9HJK/+goKhOkHiBBAbFXHZyyCL
         qypLXtTaT1HUEKAmyox5mrE+54FqTQL5F1nr4E/7bGZsmnAw1iVxbuDw44Euy6ftXuYg
         ve3X0EkKXzJmeUTVIoQVSQpRT1MuEysJo9slO9brBZThml+dcqCq+5nPw75j8YlSboHV
         jwhVSXxF+7n5G4/WnfxCbv9pBTXgBbJr5rNJ929dgdB1omA2AVpOjffXZZNpR8+I3Ah5
         z6rKEDC86duu91bjUzI2+zwFIvGeXQSZ0hKnLaiLjTAhTGPa2SD42RSbNdqxSBwKVpOI
         JKVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=sigJYFk+Q8pR1o6eZ0D86keNFXFBPNuofqZlri3Zfmk=;
        b=o74IgHzptI7qdRi6HDUJ/WSHz+1bLXXouvmIlciVmdeuHH3DwVw6TE5buVOVF0uOG5
         PCmrw5sqhJct5g1zOPqmO+h9v7ngvvoK5JbtGLIFup1N/hOKC4aLk5kxEDMR3P8gQARe
         ZAOdV6u237PnM2aewzTQcUbZIQFykmgHK9yDh3XYSC7rqbPwbblwgmsXRbtvD6gduY4A
         5pK6w2zhxlYHxY2Ak54LK2d/1kTzxuQMQ8XO/fyez2+EjWre/j0eiKlCA9DX1J0mHFqr
         qSZIXjRQ8mJ0mU/9dAew6cwVwxT5r5l5wZPgfu4bjmkj/1oltIMFXsNy310jQvNgWpf2
         51ZQ==
X-Gm-Message-State: APjAAAV4BYf5YAbkxW4Kwu1KC8I7tUYhyGXFF1y5q8SSB0tJjroGsQLX
        VCDeOHTTQJSObM6uQcFonp8=
X-Google-Smtp-Source: APXvYqw93Ei4FhobENkoQh8QOfxTx3CADzCPuxWcsPQGrncMEjvS9dtshtbkr7lInAVoKuIUOM0QTw==
X-Received: by 2002:a17:902:fe14:: with SMTP id g20mr1022404plj.54.1566511106363;
        Thu, 22 Aug 2019 14:58:26 -0700 (PDT)
Received: from ip-172-31-44-144.us-west-2.compute.internal (ec2-54-213-13-77.us-west-2.compute.amazonaws.com. [54.213.13.77])
        by smtp.gmail.com with ESMTPSA id t23sm387068pfl.154.2019.08.22.14.58.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 22 Aug 2019 14:58:25 -0700 (PDT)
Date:   Thu, 22 Aug 2019 21:58:23 +0000
From:   Alakesh Haloi <alakesh.haloi@gmail.com>
To:     Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] seccomp: fix compilation errors in seccomp-bpf kselftest
Message-ID: <20190822215823.GA11292@ip-172-31-44-144.us-west-2.compute.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without this patch we see following error while building and kselftest
for secccomp_bpf fails.

seccomp_bpf.c:1787:20: error: ‘PTRACE_EVENTMSG_SYSCALL_ENTRY’ undeclared (first use in this function);
seccomp_bpf.c:1788:6: error: ‘PTRACE_EVENTMSG_SYSCALL_EXIT’ undeclared (first use in this function);

Signed-off-by: Alakesh Haloi <alakesh.haloi@gmail.com>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 6ef7f16c4cf5..2e619760fc3e 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -1353,6 +1353,14 @@ TEST_F(precedence, log_is_fifth_in_any_order)
 #define PTRACE_EVENT_SECCOMP 7
 #endif
 
+#ifndef PTRACE_EVENTMSG_SYSCALL_ENTRY
+#define PTRACE_EVENTMSG_SYSCALL_ENTRY 1
+#endif
+
+#ifndef PTRACE_EVENTMSG_SYSCALL_EXIT
+#define PTRACE_EVENTMSG_SYSCALL_EXIT 2
+#endif
+
 #define IS_SECCOMP_EVENT(status) ((status >> 16) == PTRACE_EVENT_SECCOMP)
 bool tracer_running;
 void tracer_stop(int sig)
-- 
2.17.1

