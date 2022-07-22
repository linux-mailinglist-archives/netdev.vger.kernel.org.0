Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D9D57E4FB
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 19:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbiGVRFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 13:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbiGVRFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 13:05:38 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9ED220FC;
        Fri, 22 Jul 2022 10:05:37 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:39236)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oEw5l-007IFI-NJ; Fri, 22 Jul 2022 11:05:33 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:59484 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oEw5k-00AACQ-Cs; Fri, 22 Jul 2022 11:05:33 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     kpsingh@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        paul@paul-moore.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, shuah@kernel.org, brauner@kernel.org,
        casey@schaufler-ca.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com
References: <20220721172808.585539-1-fred@cloudflare.com>
Date:   Fri, 22 Jul 2022 12:05:07 -0500
In-Reply-To: <20220721172808.585539-1-fred@cloudflare.com> (Frederick Lawler's
        message of "Thu, 21 Jul 2022 12:28:04 -0500")
Message-ID: <877d45kri4.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oEw5k-00AACQ-Cs;;;mid=<877d45kri4.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX18ocw5vbG1LyqBTp8XMLyREW1cVYxPT3iU=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Frederick Lawler <fred@cloudflare.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 776 ms - load_scoreonly_sql: 0.06 (0.0%),
        signal_user_changed: 11 (1.5%), b_tie_ro: 10 (1.3%), parse: 1.15
        (0.1%), extract_message_metadata: 17 (2.2%), get_uri_detail_list: 3.8
        (0.5%), tests_pri_-1000: 32 (4.1%), tests_pri_-950: 1.35 (0.2%),
        tests_pri_-900: 1.06 (0.1%), tests_pri_-90: 196 (25.3%), check_bayes:
        195 (25.1%), b_tokenize: 12 (1.6%), b_tok_get_all: 13 (1.7%),
        b_comp_prob: 3.9 (0.5%), b_tok_touch_all: 162 (20.8%), b_finish: 0.92
        (0.1%), tests_pri_0: 504 (65.0%), check_dkim_signature: 1.41 (0.2%),
        check_dkim_adsp: 3.8 (0.5%), poll_dns_idle: 0.89 (0.1%), tests_pri_10:
        1.80 (0.2%), tests_pri_500: 7 (0.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v3 0/4] Introduce security_create_user_ns()
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frederick Lawler <fred@cloudflare.com> writes:

> While creating a LSM BPF MAC policy to block user namespace creation, we
> used the LSM cred_prepare hook because that is the closest hook to prevent
> a call to create_user_ns().

That description is wrong.  Your goal his is not to limit access to
the user namespace.  Your goal is to reduce the attack surface of the
kernel by not allowing some processes access to a user namespace.

You have already said that you don't have concerns about the
fundamentals of the user namespace, and what it enables only that
it allows access to exploitable code.

Achieving the protection you seek requires talking and thinking clearly
about the goal.




I have a couple of deep and fundamental problems with this approach,
to limiting access to potentially exploitable code.

1) The first is that unless there is a high probability (say 90%) that at
   any time the only exploitable code in the kernel can only be accessed
   by an unprivileged user with the help of user namespaces, attackers
   will just route around this restriction and so it will achieve
   nothing in practice, while at the same time incur an extra
   maintenance burden.

2) The second is that there is a long standing problem with code that
   gets added to the kernel.  Many times new kernel code because it has
   the potential to confuse suid root executables that code has been
   made root only.  Over time that results in more and more code running
   as root to be able to make use of the useful features of the linux
   kernel.

   One of the goals of the user namespace is to avoid more and more code
   migrating to running as root.  To achieve that goal ordinary
   application developers need to be able to assume that typically user
   namespaces will be available on linux.

   An assumption that ordinary applications like chromium make today.

   Your intentions seem to be to place a capability check so that only
   root can use user namespaces or something of the sort.  Thus breaking
   the general availability of user namespaces for ordinary applications
   on your systems.
   

My apologies if this has been addressed somewhere in the conversation
already.  I don't see these issues addressed in the descriptions of your
patches.

Until these issues are firmly addressed and you are not proposing a
patch that can only cause regressions in userspace applications.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

>
> The calls look something like this:
>
>     cred = prepare_creds()
>         security_prepare_creds()
>             call_int_hook(cred_prepare, ...
>     if (cred)
>         create_user_ns(cred)
>
> We noticed that error codes were not propagated from this hook and
> introduced a patch [1] to propagate those errors.
>
> The discussion notes that security_prepare_creds()
> is not appropriate for MAC policies, and instead the hook is
> meant for LSM authors to prepare credentials for mutation. [2]
>
> Ultimately, we concluded that a better course of action is to introduce
> a new security hook for LSM authors. [3]
>
> This patch set first introduces a new security_create_user_ns() function
> and userns_create LSM hook, then marks the hook as sleepable in BPF.
>
> Links:
> 1. https://lore.kernel.org/all/20220608150942.776446-1-fred@cloudflare.com/
> 2. https://lore.kernel.org/all/87y1xzyhub.fsf@email.froward.int.ebiederm.org/
> 3. https://lore.kernel.org/all/9fe9cd9f-1ded-a179-8ded-5fde8960a586@cloudflare.com/
>
> Past discussions:
> V2: https://lore.kernel.org/all/20220707223228.1940249-1-fred@cloudflare.com/
> V1: https://lore.kernel.org/all/20220621233939.993579-1-fred@cloudflare.com/
>
> Changes since v2:
> - Rename create_user_ns hook to userns_create
> - Use user_namespace as an object opposed to a generic namespace object
> - s/domB_t/domA_t in commit message
> Changes since v1:
> - Add selftests/bpf: Add tests verifying bpf lsm create_user_ns hook patch
> - Add selinux: Implement create_user_ns hook patch
> - Change function signature of security_create_user_ns() to only take
>   struct cred
> - Move security_create_user_ns() call after id mapping check in
>   create_user_ns()
> - Update documentation to reflect changes
>
> Frederick Lawler (4):
>   security, lsm: Introduce security_create_user_ns()
>   bpf-lsm: Make bpf_lsm_userns_create() sleepable
>   selftests/bpf: Add tests verifying bpf lsm userns_create hook
>   selinux: Implement userns_create hook
>
>  include/linux/lsm_hook_defs.h                 |  1 +
>  include/linux/lsm_hooks.h                     |  4 +
>  include/linux/security.h                      |  6 ++
>  kernel/bpf/bpf_lsm.c                          |  1 +
>  kernel/user_namespace.c                       |  5 ++
>  security/security.c                           |  5 ++
>  security/selinux/hooks.c                      |  9 ++
>  security/selinux/include/classmap.h           |  2 +
>  .../selftests/bpf/prog_tests/deny_namespace.c | 88 +++++++++++++++++++
>  .../selftests/bpf/progs/test_deny_namespace.c | 39 ++++++++
>  10 files changed, 160 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/deny_namespace.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_deny_namespace.c
>
> --
> 2.30.2

Eric
