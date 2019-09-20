Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 800C6B8CE5
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 10:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408278AbfITIag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 04:30:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39513 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405437AbfITIag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 04:30:36 -0400
Received: from static-dcd-cqq-121001.business.bouyguestelecom.com ([212.194.121.1] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iBEJA-0007Va-Sa; Fri, 20 Sep 2019 08:30:28 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     keescook@chromium.org, luto@amacapital.net
Cc:     jannh@google.com, wad@chromium.org, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH v2 0/3] seccomp: continue syscall from notifier
Date:   Fri, 20 Sep 2019 10:30:04 +0200
Message-Id: <20190920083007.11475-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey everyone,

/* v2 */
This is the patchset coming out of the KSummit session Kees and I gave
in Lisbon last week (cf. [3] which also contains slides with more
details on related things such as deep argument inspection).
The simple idea is to extend the seccomp notifier to allow for the
continuation of a syscall. The rationale for this can be found in the
commit message to [1]. For the curious there is more detail in [2].
This patchset would unblock supervising an extended set of syscalls such
as mount() where a privileged process is supervising the syscalls of a
lesser privileged process and emulates the syscall for the latter in
userspace.
For more comments on security see [1] and the comments in
include/uapi/linux/seccomp.h added by this patchset.

Kees, if you prefer a pr the series can be pulled from:
git@gitolite.kernel.org:pub/scm/linux/kernel/git/brauner/linux tags/seccomp-notify-syscall-continue-v5.5

For anyone who wants to play with this it's sitting in:
https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/log/?h=seccomp_syscall_continue

/* v1 */
Link: https://lore.kernel.org/r/20190919095903.19370-1-christian.brauner@ubuntu.com
- Kees Cook <keescook@chromium.org>:
  - dropped patch because it is already present in linux-next
    [PATCH 2/4] seccomp: add two missing ptrace ifdefines
    Link: https://lore.kernel.org/r/20190918084833.9369-3-christian.brauner@ubuntu.com

/* v0 */
Link: https://lore.kernel.org/r/20190918084833.9369-1-christian.brauner@ubuntu.com

Thanks!
Christian

*** BLURB HERE ***

Christian Brauner (3):
  seccomp: add SECCOMP_USER_NOTIF_FLAG_CONTINUE
  seccomp: avoid overflow in implicit constant conversion
  seccomp: test SECCOMP_USER_NOTIF_FLAG_CONTINUE

 include/uapi/linux/seccomp.h                  |  28 +++++
 kernel/seccomp.c                              |  28 ++++-
 tools/testing/selftests/seccomp/seccomp_bpf.c | 110 +++++++++++++++++-
 3 files changed, 159 insertions(+), 7 deletions(-)

-- 
2.23.0

