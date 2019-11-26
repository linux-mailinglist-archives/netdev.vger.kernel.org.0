Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF9F510A1FF
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 17:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfKZQZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 11:25:32 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36397 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfKZQZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 11:25:31 -0500
Received: by mail-pl1-f196.google.com with SMTP id d7so8378070pls.3
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 08:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=1hOraEYfhl1CfHNUuJ9PdJuLSAhfXrel88lp028GyuE=;
        b=ofXBE/7VkptXvyZUZ8nCpnF8LnSUO7HEYT1LoAa9Am/hhjFzn63h+s86Xpuxq0Imbq
         jUQVSTWIj7em0wn8lhMOpFYO0/YgE+PlYLu1zC6sZNJlmQnhCSb5Cm639iotn9wnQsOH
         94e3PBGT1YD16gYa0ACD2djV5jMozSNFZRB8s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=1hOraEYfhl1CfHNUuJ9PdJuLSAhfXrel88lp028GyuE=;
        b=kJDjhiLYkbzaYB9M/GyKBVddrdvR1BHVyiMaZ6rLA3hT3+aleWPSLNR6+sYnFEe/Sd
         8r4CCDIQJpO7VEld7w3Zh4af3XwPFpu87E82/sgr5O531MzBX3a0TGdsfyBRku1POJkV
         amkq0GRMwT28KezzPGH9iquLbOvMhhERrJLR0ybyKNaOqZKcDwyxeCW9yki4XlW7wMgA
         fATHSvigpjSRo4UHqXksL40JR27B6033rUXQwn97Lph3pIgQmpRJjicxqVcuCq11XoOa
         y6gB7YVBybdytlpSkENaCWwGLICl+xNe1Azci/Hh86syvDtOor4t7qyKI+64L9QNkx1A
         0HaA==
X-Gm-Message-State: APjAAAXNiyWKSapOziS1RndRn6Ah88Yp59MXYoN4Q8sfZ38OnNLjOk53
        m8Yf2nRzeQX1ry9hEjXA4QHYHg==
X-Google-Smtp-Source: APXvYqxdb3m8lvitpYcVMwL44atFGySYuA7LVySZPpCySFXgRV4Lv/KUVp10g+KjQW8s8fRGDFE4FQ==
X-Received: by 2002:a17:902:ab82:: with SMTP id f2mr32593783plr.276.1574785530825;
        Tue, 26 Nov 2019 08:25:30 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j4sm3993110pjf.25.2019.11.26.08.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 08:25:29 -0800 (PST)
Date:   Tue, 26 Nov 2019 08:25:28 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        David Abdurachmanov <david.abdurachmanov@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@suse.de>, bpf@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel test robot <rong.a.chen@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-kselftest@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-um@lists.infradead.org,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tycho Andersen <tycho@tycho.ws>,
        Tyler Hicks <tyhicks@canonical.com>,
        Will Drewry <wad@chromium.org>, x86@kernel.org,
        Yonghong Song <yhs@fb.com>
Subject: [GIT PULL] seccomp updates for v5.5-rc1
Message-ID: <201911260818.9C5DC1E@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

Please pull these seccomp updates for v5.5-rc1. Mostly this is
implementing the new flag SECCOMP_USER_NOTIF_FLAG_CONTINUE, but there
are cleanups as well. Most notably, the secure_computing() prototype
has changed (to remove an unused argument), but this has happened at the
same time as riscv adding seccomp support, so the cleanest merge order
would be to merge riscv first, then seccomp with the following patch for
riscv to handle the change from "seccomp: simplify secure_computing()":

diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
index 0f84628b9385..407464201b91 100644
--- a/arch/riscv/kernel/ptrace.c
+++ b/arch/riscv/kernel/ptrace.c
@@ -159,7 +159,7 @@ __visible void do_syscall_trace_enter(struct pt_regs *regs)
 	 * If this fails we might have return value in a0 from seccomp
 	 * (via SECCOMP_RET_ERRNO/TRACE).
 	 */
-	if (secure_computing(NULL) == -1) {
+	if (secure_computing() == -1) {
 		syscall_set_nr(current, regs, -1);
 		return;
 	}

Thanks!

-Kees

The following changes since commit da0c9ea146cbe92b832f1b0f694840ea8eb33cce:

  Linux 5.4-rc2 (2019-10-06 14:27:30 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/seccomp-v5.5-rc1

for you to fetch changes up to 23b2c96fad21886c53f5e1a4ffedd45ddd2e85ba:

  seccomp: rework define for SECCOMP_USER_NOTIF_FLAG_CONTINUE (2019-10-28 12:29:46 -0700)

----------------------------------------------------------------
seccomp updates for v5.5

- implement SECCOMP_USER_NOTIF_FLAG_CONTINUE (Christian Brauner)
- fixes to selftests (Christian Brauner)
- remove secure_computing() argument (Christian Brauner)

----------------------------------------------------------------
Christian Brauner (6):
      seccomp: avoid overflow in implicit constant conversion
      seccomp: add SECCOMP_USER_NOTIF_FLAG_CONTINUE
      seccomp: test SECCOMP_USER_NOTIF_FLAG_CONTINUE
      seccomp: simplify secure_computing()
      seccomp: fix SECCOMP_USER_NOTIF_FLAG_CONTINUE test
      seccomp: rework define for SECCOMP_USER_NOTIF_FLAG_CONTINUE

 arch/arm/kernel/ptrace.c                      |   2 +-
 arch/arm64/kernel/ptrace.c                    |   2 +-
 arch/parisc/kernel/ptrace.c                   |   2 +-
 arch/s390/kernel/ptrace.c                     |   2 +-
 arch/um/kernel/skas/syscall.c                 |   2 +-
 arch/x86/entry/vsyscall/vsyscall_64.c         |   2 +-
 include/linux/seccomp.h                       |   6 +-
 include/uapi/linux/seccomp.h                  |  29 +++++++
 kernel/seccomp.c                              |  28 +++++--
 tools/testing/selftests/seccomp/seccomp_bpf.c | 110 +++++++++++++++++++++++++-
 10 files changed, 169 insertions(+), 16 deletions(-)

-- 
Kees Cook
