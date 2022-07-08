Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E5656B964
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 14:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238030AbiGHMKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 08:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237495AbiGHMKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 08:10:17 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369519CE06;
        Fri,  8 Jul 2022 05:10:16 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id t26-20020a9d775a000000b006168f7563daso16069252otl.2;
        Fri, 08 Jul 2022 05:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GpQvth/YlRPRLXM2wq2zvzgjKdxbpn6/Zk9RhPLEGYg=;
        b=IoqP8q5VZ5pk4QJgOwAfmFwAW9TPNsIiOuFdanrxu2zmQQ3sb9r90FuhkeI7RBwfrE
         DCR2kpud+3/E6fCStcfxQA0W/IteFr5fRIshCU8SNzfXl0MOjqJA23rMCJd23Vr6wSY2
         LN6VcrVOKc075R1TU3Rjxv5rBkt+Gser9VlxPSdxLIBXseawhiWFtV2mSWlYgaCPArq2
         gTpxQAAyygaAtMP5Uj7YO++qpBQsoDQx+wVhRuDO6KXcxDFq2GrJUC1qXF7Zs0Ll1C0G
         I3uuejIpb7F9yWK03KH4HrcgZdaZBfAFW6Ldi8sHeUBZ/ExGyc/xzgbg4WQ9m2yxFJaV
         W7Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GpQvth/YlRPRLXM2wq2zvzgjKdxbpn6/Zk9RhPLEGYg=;
        b=yf0pnKLk4v9GmKCsYECHnLsUCMHthzKJW4x05ja/PBzf1xkAH4qXTdzWmdZz48glZ+
         eQM+G0dKF2IsjRRDW7wLmB4OiYIx6Aa0vQcnwiC7Sg1J7lYPsGtLihKz97kd7TNs6zfL
         6WQpasDq4fOW4RlZXMuPaBJFYs/N2W6QzwF11xwkP08CZyt5dX0mjbAQFUTSSlsgwFFb
         XhvRO6/q8yP62vIOUWYYdgkbiBkMlcC2Oy45v0bhxTAgyX59/jqKS+W79+1TZVnzXUJb
         4t1g5eiTQ2cUOImdHUuIdR0CXDxOyAk0pnUENsn3PTpp0G+rgYqtklFNE0prAlrUeGLD
         Vuvg==
X-Gm-Message-State: AJIora9Flmg0l55S5e09D5XOS0/wLiuUP6tRRlNR9jWPjH7aeW6hItc5
        ONeVvx5XOyl4d6hff4SIQzA7r0arZ1Q47hDHW0rm5bvifpagyoIq
X-Google-Smtp-Source: AGRyM1tHWy4Tlx5fwGEXEdMD+rUEyIqRPxAEtDWj9qSQGdS2+QKidSUUGKaTp9bjOEoECFbtvsRIe31ma8aVvJAOfFk=
X-Received: by 2002:a9d:630b:0:b0:619:1204:d36f with SMTP id
 q11-20020a9d630b000000b006191204d36fmr1367344otk.56.1657282215497; Fri, 08
 Jul 2022 05:10:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220707223228.1940249-1-fred@cloudflare.com>
In-Reply-To: <20220707223228.1940249-1-fred@cloudflare.com>
From:   =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>
Date:   Fri, 8 Jul 2022 14:10:04 +0200
Message-ID: <CAJ2a_DezgSpc28jvJuU_stT7V7et-gD7qjy409oy=ZFaUxJneg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Introduce security_create_user_ns()
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     KP Singh <kpsingh@kernel.org>, revest@chromium.org,
        jackmanb@chromium.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, shuah@kernel.org,
        Christian Brauner <brauner@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        SElinux list <selinux@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

,On Fri, 8 Jul 2022 at 00:32, Frederick Lawler <fred@cloudflare.com> wrote:
>
> While creating a LSM BPF MAC policy to block user namespace creation, we
> used the LSM cred_prepare hook because that is the closest hook to prevent
> a call to create_user_ns().
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
> and create_user_ns LSM hook, then marks the hook as sleepable in BPF.

Some thoughts:

I.

Why not make the hook more generic, e.g. support all other existing
and potential future namespaces?
Also I think the naming scheme is <object>_<verb>.

    LSM_HOOK(int, 0, namespace_create, const struct cred *cred,
unsigned int flags)

where flags is a bitmap of CLONE flags from include/uapi/linux/sched.h
(like CLONE_NEWUSER).

II.

While adding policing for namespaces maybe also add a new hook for setns(2)

    LSM_HOOK(int, 0, namespace_join, const struct cred *subj,  const
struct cred *obj, unsigned int flags)

III.

Maybe even attach a security context to namespaces so they can be
further governed?
SELinux example:

    type domainA_userns_t;
    type_transition domainA_t domainA_t : namespace domainA_userns_t "user";
    allow domainA_t domainA_userns_t:namespace create;

    # domainB calling setns(2) with domainA as target
    allow domainB_t domainA_userns_t:namespace join;

>
> Links:
> 1. https://lore.kernel.org/all/20220608150942.776446-1-fred@cloudflare.com/
> 2. https://lore.kernel.org/all/87y1xzyhub.fsf@email.froward.int.ebiederm.org/
> 3. https://lore.kernel.org/all/9fe9cd9f-1ded-a179-8ded-5fde8960a586@cloudflare.com/
>
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
>   bpf-lsm: Make bpf_lsm_create_user_ns() sleepable
>   selftests/bpf: Add tests verifying bpf lsm create_user_ns hook
>   selinux: Implement create_user_ns hook
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
>
