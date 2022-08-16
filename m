Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21C15964F5
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 23:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237790AbiHPVv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 17:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237781AbiHPVvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 17:51:25 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969908E0CC
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 14:51:23 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id bb16so13492539oib.11
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 14:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=cINbdQx9vuTQNR1x1rEsEZ4jjGMUWdf19tZ6cChgAaA=;
        b=CJvwxuwd+0rt/bo4TkCNqYjlT4SJ6Aesn0zM6uXzP6TCT+LreKW44m+4ak4S4QcpN8
         Z3emQFWvCmqT6EmdYqBJBiTKDxs25SPIFHJWRc2lCFCaMDG285aPNFHSJURzJUXrItiL
         Ui0T4+b4CX6rGWwwzQfjXo8/X0Ju4rYSJ9xG3J7ltDjyoURr0U0yWlyr6RXfyYXVOrj/
         dZni714OJ/a9KGzQWNmYg0CEkelbTwf73pNCb8n0Ac9BiqIv1/rm9RuUiqu/Zp2s8EQx
         XozhxC5/9Z05RYEinUrW7q9aA6G43Pjq/Ad7nHIMnr1jM1fRLjCBEg6+JP0Ma1IBiniW
         viLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=cINbdQx9vuTQNR1x1rEsEZ4jjGMUWdf19tZ6cChgAaA=;
        b=TOK+hGSvHm5RdpyAbnLYZ568JZct6NVD5vhCkFVVEP+6kezgoPLJY1MtayjD2ZQ4hb
         oE/Lc3YB/hv9IF+ziGtRWM5x4g4eaq5yngjmfcQCJKtCKY2T5WqIPHiDpBLWdmEf6BPp
         cZceic05OPG8i3alm52GKCZ6SlPwrhuX1/YrqxQS16+Iszfh2j3055Mkc9Y5NM1iNppZ
         R9xMzDdA0OH2mKoqQ5UeTC5P+TE9eWxc5j2JlDN7oUQLJLNeGAmpw/UIrpg9wRJU0RfW
         6QFyAqdwi2eJuXbqSkQeMbC3XO4LHDIZvM8mfndDWYQsAGiF3a/AanAY4DmvdKxvPnGG
         j5Fw==
X-Gm-Message-State: ACgBeo3hvlnwmKMiEvQJbqEu31MTyeLnROBnqBSna2q2mHWIrHy5ZRv/
        XzsfBMMFCykd+yUN25hckzWx3AL2UpKBcjLSM679
X-Google-Smtp-Source: AA6agR4ffEEKYkbE47q7/sRZQjQuSsIQ8phb3aTW9UCETN6ndapbDy186fFAcL9M3UIMnxT1iC01UQw6kwBHZYMTE0o=
X-Received: by 2002:aca:b7d5:0:b0:343:c478:91c6 with SMTP id
 h204-20020acab7d5000000b00343c47891c6mr257896oif.136.1660686682803; Tue, 16
 Aug 2022 14:51:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220815162028.926858-1-fred@cloudflare.com>
In-Reply-To: <20220815162028.926858-1-fred@cloudflare.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 16 Aug 2022 17:51:12 -0400
Message-ID: <CAHC9VhTuxxRfJg=Ax5z87Jz6tq1oVRcppB444dHM2gP-FZrkTQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] Introduce security_create_user_ns()
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     kpsingh@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        shuah@kernel.org, brauner@kernel.org, casey@schaufler-ca.com,
        ebiederm@xmission.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com,
        tixxdz@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 12:20 PM Frederick Lawler <fred@cloudflare.com> wrote:
>
> While user namespaces do not make the kernel more vulnerable, they are however
> used to initiate exploits. Some users do not want to block namespace creation
> for the entirety of the system, which some distributions provide. Instead, we
> needed a way to have some applications be blocked, and others allowed. This is
> not possible with those tools. Managing hierarchies also did not fit our case
> because we're determining which tasks are allowed based on their attributes.
>
> While exploring a solution, we first leveraged the LSM cred_prepare hook
> because that is the closest hook to prevent a call to create_user_ns().
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
> The discussion notes that security_prepare_creds() is not appropriate for
> MAC policies, and instead the hook is meant for LSM authors to prepare
> credentials for mutation. [2]
>
> Additionally, cred_prepare hook is not without problems. Handling the clone3
> case is a bit more tricky due to the user space pointer passed to it. This
> makes checking the syscall subject to a possible TOCTTOU attack.
>
> Ultimately, we concluded that a better course of action is to introduce
> a new security hook for LSM authors. [3]
>
> This patch set first introduces a new security_create_user_ns() function
> and userns_create LSM hook, then marks the hook as sleepable in BPF. The
> following patches after include a BPF test and a patch for an SELinux
> implementation.
>
> We want to encourage use of user namespaces, and also cater the needs
> of users/administrators to observe and/or control access. There is no
> expectation of an impact on user space applications because access control
> is opt-in, and users wishing to observe within a LSM context
>
>
> Links:
> 1. https://lore.kernel.org/all/20220608150942.776446-1-fred@cloudflare.com/
> 2. https://lore.kernel.org/all/87y1xzyhub.fsf@email.froward.int.ebiederm.org/
> 3. https://lore.kernel.org/all/9fe9cd9f-1ded-a179-8ded-5fde8960a586@cloudflare.com/
>
> Past discussions:
> V4: https://lore.kernel.org/all/20220801180146.1157914-1-fred@cloudflare.com/
> V3: https://lore.kernel.org/all/20220721172808.585539-1-fred@cloudflare.com/
> V2: https://lore.kernel.org/all/20220707223228.1940249-1-fred@cloudflare.com/
> V1: https://lore.kernel.org/all/20220621233939.993579-1-fred@cloudflare.com/
>
> Changes since v4:
> - Update commit description
> - Update cover letter
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

I just merged this into the lsm/next tree, thanks for seeing this
through Frederick, and thank you to everyone who took the time to
review the patches and add their tags.

  git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/lsm.git next

-- 
paul-moore.com
