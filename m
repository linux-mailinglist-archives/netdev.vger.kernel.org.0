Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3595E55A8B
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfFYWEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:04:13 -0400
Received: from smtp-sh.infomaniak.ch ([128.65.195.4]:38309 "EHLO
        smtp-sh.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfFYWEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 18:04:13 -0400
Received: from smtp5.infomaniak.ch (smtp5.infomaniak.ch [83.166.132.18])
        by smtp-sh.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5PLrSKW019918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 23:53:28 +0200
Received: from localhost (ns3096276.ip-94-23-54.eu [94.23.54.103])
        (authenticated bits=0)
        by smtp5.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5PLrRJX038974;
        Tue, 25 Jun 2019 23:53:27 +0200
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Drysdale <drysdale@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
        John Johansen <john.johansen@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
        Paul Moore <paul@paul-moore.com>,
        Sargun Dhillon <sargun@sargun.me>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
        Will Drewry <wad@chromium.org>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v9 10/10] landlock: Add user and kernel documentation for Landlock
Date:   Tue, 25 Jun 2019 23:52:39 +0200
Message-Id: <20190625215239.11136-11-mic@digikod.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190625215239.11136-1-mic@digikod.net>
References: <20190625215239.11136-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This documentation can be built with the Sphinx framework.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: James Morris <jmorris@namei.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
---

Changes since v8:
* remove documentation related to chaining and tagging according to this
  patch series

Changes since v7:
* update documentation according to the Landlock revamp

Changes since v6:
* add a check for ctx->event
* rename BPF_PROG_TYPE_LANDLOCK to BPF_PROG_TYPE_LANDLOCK_RULE
* rename Landlock version to ABI to better reflect its purpose and add a
  dedicated changelog section
* update tables
* relax no_new_privs recommendations
* remove ABILITY_WRITE related functions
* reword rule "appending" to "prepending" and explain it
* cosmetic fixes

Changes since v5:
* update the rule hierarchy inheritance explanation
* briefly explain ctx->arg2
* add ptrace restrictions
* explain EPERM
* update example (subtype)
* use ":manpage:"
---
 Documentation/security/index.rst           |   1 +
 Documentation/security/landlock/index.rst  |  20 +++
 Documentation/security/landlock/kernel.rst |  99 ++++++++++++++
 Documentation/security/landlock/user.rst   | 148 +++++++++++++++++++++
 4 files changed, 268 insertions(+)
 create mode 100644 Documentation/security/landlock/index.rst
 create mode 100644 Documentation/security/landlock/kernel.rst
 create mode 100644 Documentation/security/landlock/user.rst

diff --git a/Documentation/security/index.rst b/Documentation/security/index.rst
index aad6d92ffe31..32b4c1db2325 100644
--- a/Documentation/security/index.rst
+++ b/Documentation/security/index.rst
@@ -12,3 +12,4 @@ Security Documentation
    SCTP
    self-protection
    tpm/index
+   landlock/index
diff --git a/Documentation/security/landlock/index.rst b/Documentation/security/landlock/index.rst
new file mode 100644
index 000000000000..d0af868d1582
--- /dev/null
+++ b/Documentation/security/landlock/index.rst
@@ -0,0 +1,20 @@
+=========================================
+Landlock LSM: programmatic access control
+=========================================
+
+Landlock is a stackable Linux Security Module (LSM) that makes it possible to
+create security sandboxes, programmable access-controls or safe endpoint
+security agents.  This kind of sandbox is expected to help mitigate the
+security impact of bugs or unexpected/malicious behaviors in user-space
+applications.  The current version allows only a process with the global
+CAP_SYS_ADMIN capability to create such sandboxes but the ultimate goal of
+Landlock is to empower any process, including unprivileged ones, to securely
+restrict themselves.  Landlock is inspired by seccomp-bpf but instead of
+filtering syscalls and their raw arguments, a Landlock rule can inspect the use
+of kernel objects like files and hence make a decision according to the kernel
+semantic.
+
+.. toctree::
+
+    user
+    kernel
diff --git a/Documentation/security/landlock/kernel.rst b/Documentation/security/landlock/kernel.rst
new file mode 100644
index 000000000000..7d1e06d544bf
--- /dev/null
+++ b/Documentation/security/landlock/kernel.rst
@@ -0,0 +1,99 @@
+==============================
+Landlock: kernel documentation
+==============================
+
+eBPF properties
+===============
+
+To get an expressive language while still being safe and small, Landlock is
+based on eBPF. Landlock should be usable by untrusted processes and must
+therefore expose a minimal attack surface. The eBPF bytecode is minimal,
+powerful, widely used and designed to be used by untrusted applications. Thus,
+reusing the eBPF support in the kernel enables a generic approach while
+minimizing new code.
+
+An eBPF program has access to an eBPF context containing some fields used to
+inspect the current object. These arguments can be used directly (e.g. cookie)
+or passed to helper functions according to their types (e.g. inode pointer). It
+is then possible to do complex access checks without race conditions or
+inconsistent evaluation (i.e.  `incorrect mirroring of the OS code and state
+<https://www.ndss-symposium.org/ndss2003/traps-and-pitfalls-practical-problems-system-call-interposition-based-security-tools/>`_).
+
+A Landlock hook describes a particular access type.  For now, there is two
+hooks dedicated to filesystem related operations: LANDLOCK_HOOK_FS_PICK and
+LANDLOCK_HOOK_FS_WALK.  A Landlock program is tied to one hook.  This makes it
+possible to statically check context accesses, potentially performed by such
+program, and hence prevents kernel address leaks and ensure the right use of
+hook arguments with eBPF functions.  Any user can add multiple Landlock
+programs per Landlock hook.  They are stacked and evaluated one after the
+other, starting from the most recent program, as seccomp-bpf does with its
+filters.  Underneath, a hook is an abstraction over a set of LSM hooks.
+
+
+Guiding principles
+==================
+
+Unprivileged use
+----------------
+
+* Landlock helpers and context should be usable by any unprivileged and
+  untrusted program while following the system security policy enforced by
+  other access control mechanisms (e.g. DAC, LSM).
+
+
+Landlock hook and context
+-------------------------
+
+* A Landlock hook shall be focused on access control on kernel objects instead
+  of syscall filtering (i.e. syscall arguments), which is the purpose of
+  seccomp-bpf.
+* A Landlock context provided by a hook shall express the minimal and more
+  generic interface to control an access for a kernel object.
+* A hook shall guaranty that all the BPF function calls from a program are
+  safe.  Thus, the related Landlock context arguments shall always be of the
+  same type for a particular hook.  For example, a network hook could share
+  helpers with a file hook because of UNIX socket.  However, the same helpers
+  may not be compatible for a file system handle and a net handle.
+* Multiple hooks may use the same context interface.
+
+
+Landlock helpers
+----------------
+
+* Landlock helpers shall be as generic as possible while at the same time being
+  as simple as possible and following the syscall creation principles (cf.
+  *Documentation/adding-syscalls.txt*).
+* The only behavior change allowed on a helper is to fix a (logical) bug to
+  match the initial semantic.
+* Helpers shall be reentrant, i.e. only take inputs from arguments (e.g. from
+  the BPF context), to enable a hook to use a cache.  Future program options
+  might change this cache behavior.
+* It is quite easy to add new helpers to extend Landlock.  The main concern
+  should be about the possibility to leak information from the kernel that may
+  not be accessible otherwise (i.e. side-channel attack).
+
+
+Questions and answers
+=====================
+
+Why not create a custom hook for each kind of action?
+-----------------------------------------------------
+
+Landlock programs can handle these checks.  Adding more exceptions to the
+kernel code would lead to more code complexity.  A decision to ignore a kind of
+action can and should be done at the beginning of a Landlock program.
+
+
+Why a program does not return an errno or a kill code?
+------------------------------------------------------
+
+seccomp filters can return multiple kind of code, including an errno value or a
+kill signal, which may be convenient for access control.  Those return codes
+are hardwired in the userland ABI.  Instead, Landlock's approach is to return a
+boolean to allow or deny an action, which is much simpler and more generic.
+Moreover, we do not really have a choice because, unlike to seccomp, Landlock
+programs are not enforced at the syscall entry point but may be executed at any
+point in the kernel (through LSM hooks) where an errno return code may not make
+sense.  However, with this simple ABI and with the ability to call helpers,
+Landlock may gain features similar to seccomp-bpf in the future while being
+compatible with previous programs.
diff --git a/Documentation/security/landlock/user.rst b/Documentation/security/landlock/user.rst
new file mode 100644
index 000000000000..e4bb7dba4aa7
--- /dev/null
+++ b/Documentation/security/landlock/user.rst
@@ -0,0 +1,148 @@
+================================
+Landlock: userland documentation
+================================
+
+Landlock programs
+=================
+
+eBPF programs are used to create security programs.  They are contained and can
+call only a whitelist of dedicated functions. Moreover, they can only loop
+under strict conditions, which protects from denial of service.  More
+information on BPF can be found in *Documentation/networking/filter.txt*.
+
+
+Writing a program
+-----------------
+
+To enforce a security policy, a thread first needs to create a Landlock program.
+The easiest way to write an eBPF program depicting a security program is to write
+it in the C language.  As described in *samples/bpf/README.rst*, LLVM can
+compile such programs.  Files *samples/bpf/landlock1_kern.c* and those in
+*tools/testing/selftests/landlock/* can be used as examples.
+
+Once the eBPF program is created, the next step is to create the metadata
+describing the Landlock program.  This metadata includes a subtype which
+contains the hook type to which the program is tied and some options.
+
+.. code-block:: c
+
+    union bpf_prog_subtype subtype = {
+        .landlock_hook = {
+            .type = LANDLOCK_HOOK_FS_PICK,
+            .triggers = LANDLOCK_TRIGGER_FS_PICK_OPEN,
+        }
+    };
+
+A Landlock hook describes the kind of kernel object for which a program will be
+triggered to allow or deny an action.  For example, the hook
+LANDLOCK_HOOK_FS_PICK can be triggered every time a landlocked thread performs
+a set of action related to the filesystem (e.g. open, read, write, mount...).
+This actions are identified by the `triggers` bitfield.
+
+The next step is to fill a :c:type:`union bpf_attr <bpf_attr>` with
+BPF_PROG_TYPE_LANDLOCK_HOOK, the previously created subtype and other BPF
+program metadata.  This bpf_attr must then be passed to the :manpage:`bpf(2)`
+syscall alongside the BPF_PROG_LOAD command.  If everything is deemed correct
+by the kernel, the thread gets a file descriptor referring to this program.
+
+In the following code, the *insn* variable is an array of BPF instructions
+which can be extracted from an ELF file as is done in bpf_load_file() from
+*samples/bpf/bpf_load.c*.
+
+.. code-block:: c
+
+    union bpf_attr attr = {
+        .prog_type = BPF_PROG_TYPE_LANDLOCK_HOOK,
+        .insn_cnt = sizeof(insn) / sizeof(struct bpf_insn),
+        .insns = (__u64) (unsigned long) insn,
+        .license = (__u64) (unsigned long) "GPL",
+        .prog_subtype = &subtype,
+        .prog_subtype_size = sizeof(subtype),
+    };
+    int fd = bpf(BPF_PROG_LOAD, &attr, sizeof(attr));
+    if (fd == -1)
+        exit(1);
+
+
+Enforcing a program
+-------------------
+
+Once the Landlock program has been created or received (e.g. through a UNIX
+socket), the thread willing to sandbox itself (and its future children) should
+perform the following two steps.
+
+The thread should first request to never be allowed to get new privileges with a
+call to :manpage:`prctl(2)` and the PR_SET_NO_NEW_PRIVS option.  More
+information can be found in *Documentation/prctl/no_new_privs.txt*.
+
+.. code-block:: c
+
+    if (prctl(PR_SET_NO_NEW_PRIVS, 1, NULL, 0, 0))
+        exit(1);
+
+A thread can apply a program to itself by using the :manpage:`seccomp(2)` syscall.
+The operation is SECCOMP_PREPEND_LANDLOCK_PROG, the flags must be empty and the
+*args* argument must point to a valid Landlock program file descriptor.
+
+.. code-block:: c
+
+    if (seccomp(SECCOMP_PREPEND_LANDLOCK_PROG, 0, &fd))
+        exit(1);
+
+If the syscall succeeds, the program is now enforced on the calling thread and
+will be enforced on all its subsequently created children of the thread as
+well.  Once a thread is landlocked, there is no way to remove this security
+policy, only stacking more restrictions is allowed.  The program evaluation is
+performed from the newest to the oldest.
+
+When a syscall ask for an action on a kernel object, if this action is denied,
+then an EACCES errno code is returned through the syscall.
+
+
+.. _inherited_programs:
+
+Inherited programs
+------------------
+
+Every new thread resulting from a :manpage:`clone(2)` inherits Landlock program
+restrictions from its parent.  This is similar to the seccomp inheritance as
+described in *Documentation/prctl/seccomp_filter.txt*.
+
+
+Ptrace restrictions
+-------------------
+
+A landlocked process has less privileges than a non-landlocked process and must
+then be subject to additional restrictions when manipulating another process.
+To be allowed to use :manpage:`ptrace(2)` and related syscalls on a target
+process, a landlocked process must have a subset of the target process programs.
+
+
+Landlock structures and constants
+=================================
+
+Hook types
+----------
+
+.. kernel-doc:: include/uapi/linux/landlock.h
+    :functions: landlock_hook_type
+
+
+Contexts
+--------
+
+.. kernel-doc:: include/uapi/linux/landlock.h
+    :functions: landlock_ctx_fs_pick landlock_ctx_fs_walk landlock_ctx_fs_get
+
+
+Triggers for fs_pick
+--------------------
+
+.. kernel-doc:: include/uapi/linux/landlock.h
+    :functions: landlock_triggers
+
+
+Additional documentation
+========================
+
+See https://landlock.io
-- 
2.20.1

