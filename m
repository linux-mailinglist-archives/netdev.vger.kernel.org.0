Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E05B5875B1
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 04:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235722AbiHBC4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 22:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235798AbiHBC4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 22:56:45 -0400
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4BF1D0C0;
        Mon,  1 Aug 2022 19:56:44 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:58770)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oIi5J-005Yj0-0R; Mon, 01 Aug 2022 20:56:41 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:43358 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oIi5G-006Hfs-Eh; Mon, 01 Aug 2022 20:56:40 -0600
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
In-Reply-To: <20220801180146.1157914-1-fred@cloudflare.com> (Frederick
        Lawler's message of "Mon, 1 Aug 2022 13:01:42 -0500")
References: <20220801180146.1157914-1-fred@cloudflare.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
Date:   Mon, 01 Aug 2022 21:56:28 -0500
Message-ID: <87les7cq03.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oIi5G-006Hfs-Eh;;;mid=<87les7cq03.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX19344Ku5G6V0XI6p6QH6VsN2tkU429jDfA=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Frederick Lawler <fred@cloudflare.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1907 ms - load_scoreonly_sql: 0.30 (0.0%),
        signal_user_changed: 16 (0.9%), b_tie_ro: 13 (0.7%), parse: 2.4 (0.1%),
         extract_message_metadata: 29 (1.5%), get_uri_detail_list: 4.2 (0.2%),
        tests_pri_-1000: 47 (2.5%), tests_pri_-950: 1.73 (0.1%),
        tests_pri_-900: 1.37 (0.1%), tests_pri_-90: 85 (4.4%), check_bayes: 82
        (4.3%), b_tokenize: 19 (1.0%), b_tok_get_all: 12 (0.6%), b_comp_prob:
        4.1 (0.2%), b_tok_touch_all: 40 (2.1%), b_finish: 1.35 (0.1%),
        tests_pri_0: 1690 (88.6%), check_dkim_signature: 1.08 (0.1%),
        check_dkim_adsp: 9 (0.5%), poll_dns_idle: 7 (0.3%), tests_pri_10: 4.4
        (0.2%), tests_pri_500: 24 (1.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v4 0/4] Introduce security_create_user_ns()
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frederick Lawler <fred@cloudflare.com> writes:

> While creating a LSM BPF MAC policy to block user namespace creation, we
> used the LSM cred_prepare hook because that is the closest hook to prevent
> a call to create_user_ns().

Re-nack for all of the same reasons.
AKA This can only break the users of the user namespace.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

You aren't fixing what your problem you are papering over it by denying
access to the user namespace.

Nack Nack Nack.

Stop.

Go back to the drawing board.

Do not pass go.

Do not collect $200.


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
> V3: https://lore.kernel.org/all/20220721172808.585539-1-fred@cloudflare.com/
> V2: https://lore.kernel.org/all/20220707223228.1940249-1-fred@cloudflare.com/
> V1: https://lore.kernel.org/all/20220621233939.993579-1-fred@cloudflare.com/
>
> Changes since v3:
> - Explicitly set CAP_SYS_ADMIN to test namespace is created given
>   permission
> - Simplify BPF test to use sleepable hook only
> - Prefer unshare() over clone() for tests
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
>  include/linux/lsm_hook_defs.h                 |   1 +
>  include/linux/lsm_hooks.h                     |   4 +
>  include/linux/security.h                      |   6 ++
>  kernel/bpf/bpf_lsm.c                          |   1 +
>  kernel/user_namespace.c                       |   5 +
>  security/security.c                           |   5 +
>  security/selinux/hooks.c                      |   9 ++
>  security/selinux/include/classmap.h           |   2 +
>  .../selftests/bpf/prog_tests/deny_namespace.c | 102 ++++++++++++++++++
>  .../selftests/bpf/progs/test_deny_namespace.c |  33 ++++++
>  10 files changed, 168 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/deny_namespace.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_deny_namespace.c

Eric
