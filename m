Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2BA58DC64
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 18:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244969AbiHIQrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 12:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234359AbiHIQrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 12:47:16 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5604220CD
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 09:47:14 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id s199so8686311oie.3
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 09:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=OQdzvI48V4v1B4ddrzc07g5SpSnYPX/QwedZe0qu4AI=;
        b=Ri2tsj0wADEJ/FqtuFe8VA3SlsAf4KnPGgJj+nvCXLKG6B6UbcwkVSpbOgqTUzJfiT
         QPADWiyW6UkdsfosfSRM21VsttNJKppdOEl3fp32UHIUjR1qD2Qj+PDddciPoTn7PSgy
         2p/I96SGe3fYfgnj3La44AANjPEePv4B8NV3JfXFvZH5vcgTjFT6fVXrrAejRt36omr1
         GV2ifLxF4sMqwvPtr1sVjQrobLRJmbowbjxOzhmAxh3ri0RdahOO9XlTVS0dtmxAEoaW
         WbU6GKuwZ/z4LRxdcL68HvZquRVAfuGOgiix/p4keAnPKg6L68n94sAPxDxu6xuekIFX
         87iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=OQdzvI48V4v1B4ddrzc07g5SpSnYPX/QwedZe0qu4AI=;
        b=14o9wq47nyKyNDs38Lh+79HoiyIFOxYZApHUumkqGrVplaKY0Vde5ZI1fouPJf3Khg
         KveyRp9X5ySUA9R+rg/JERPRpcR2Blu4ugFMj8WzS5pH5Y3k5hb6CVulURK0cUTtkIL3
         2R2M5dVvU860S56cvHgQNQSWI7dtTLpHtekjONSLk3S/MOV8OnlBfD9bnXuivNVD4sHL
         ushua3DfPOUACaGVMNeX54AqxBJmQbe8GspV0s5gFzvXy68EqRag1wCn8byCGrj0KAa7
         s+GPPZ8ZJqBYeyHNDe2rJ+8EzlGnCYG8zQnIYzZMA94BhfVoJkwfY1DkL1nfyoqsuc+9
         JTqg==
X-Gm-Message-State: ACgBeo0Eyt6U/ekhscKbQsHc9+lXrR8/i4DsRUn46vvHA4pKSyTMr9+f
        p9Rz1B231R/qrHTNird+bNA6uUYhgvxjNKMOpeDl
X-Google-Smtp-Source: AA6agR5poU7RDNGoYk+czRRXpPIMJZYZZhpWQ+gyzpZdCLILfBZzRWgLcpcw12THou5UlUCZUmBy3wKQtISqq+09+k0=
X-Received: by 2002:a05:6808:2389:b0:33a:cbdb:f37a with SMTP id
 bp9-20020a056808238900b0033acbdbf37amr10590809oib.136.1660063633970; Tue, 09
 Aug 2022 09:47:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220801180146.1157914-1-fred@cloudflare.com> <87les7cq03.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhRpUxyxkPaTz1scGeRm+i4KviQQA7WismOX2q5agzC+DQ@mail.gmail.com>
 <87wnbia7jh.fsf@email.froward.int.ebiederm.org> <CAHC9VhS3udhEecVYVvHm=tuqiPGh034-xPqXYtFjBk23+p-Szg@mail.gmail.com>
 <877d3ia65v.fsf@email.froward.int.ebiederm.org> <87bksu8qs2.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhTEwD2y9Witj-1z3e2TC-NGjghQ4KT4Dqf3UOLzDcDc3Q@mail.gmail.com> <87czd95rjc.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <87czd95rjc.fsf@email.froward.int.ebiederm.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 9 Aug 2022 12:47:03 -0400
Message-ID: <CAHC9VhQY6H4JxOvSYWk2cpH8E3LYeOkMP_ay+ih+ULKKdeob=Q@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Introduce security_create_user_ns()
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        shuah@kernel.org, brauner@kernel.org, casey@schaufler-ca.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, cgzones@googlemail.com,
        karl@bigbadwolfsecurity.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 9, 2022 at 12:08 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> Paul Moore <paul@paul-moore.com> writes:
> > On Mon, Aug 8, 2022 at 3:43 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> >> "Eric W. Biederman" <ebiederm@xmission.com> writes:
> >> > Paul Moore <paul@paul-moore.com> writes:
> >> >
> >> >>> I did provide constructive feedback.  My feedback to his problem
> >> >>> was to address the real problem of bugs in the kernel.
> >> >>
> >> >> We've heard from several people who have use cases which require
> >> >> adding LSM-level access controls and observability to user namespace
> >> >> creation.  This is the problem we are trying to solve here; if you do
> >> >> not like the approach proposed in this patchset please suggest another
> >> >> implementation that allows LSMs visibility into user namespace
> >> >> creation.
> >> >
> >> > Please stop, ignoring my feedback, not detailing what problem or
> >> > problems you are actually trying to be solved, and threatening to merge
> >> > code into files that I maintain that has the express purpose of breaking
> >> > my users.
> >> >
> >> > You just artificially constrained the problems, so that no other
> >> > solution is acceptable.  On that basis alone I am object to this whole
> >> > approach to steam roll over me and my code.
> >>
> >> If you want an example of what kind of harm it can cause to introduce a
> >> failure where no failure was before I invite you to look at what
> >> happened with sendmail when setuid was modified to fail, when changing
> >> the user of a process would cause RLIMIT_NPROC to be exceeded.
> >
> > I think we are all familiar with the sendmail capabilities bug and the
> > others like it, but using that as an excuse to block additional access
> > controls seems very weak.  The Linux Kernel is very different from
> > when the sendmail bug hit (what was that, ~20 years ago?), with
> > advancements in capabilities and other discretionary controls, as well
> > as mandatory access controls which have enabled Linux to be certified
> > through a number of third party security evaluations.
>
> If you are familiar with scenarios like that then why is there not
> being due diligence performed to ensure that userspace won't break?

What level of due diligence would satisfy you Eric?  This feels very
much like an unbounded ask that can be used to permanently block any
effort to add any form of additional access control around user
namespace creation.  If that isn't the case, and this request is being
made in good faith, please elaborate on what you believe would be
sufficient analysis of this patch?

Personally, the fact that the fork()/clone() variants and the
unshare() syscall all can fail and return error codes to userspace
seems like a reasonable level of safety.  If userspace is currently
ignoring the return values of fork/clone/unshare that is a problem
independent of this patchset.  Even looking at the existing
create_user_ns() function shows several cases where the user namespace
code can forcibly error out due to access controls, memory pressure,
etc.  I also see that additional restrictions were put on user
namespace creation after it was introduced, e.g. the chroot
restriction; I'm assuming that didn't break "your" users?  If you can
describe the analysis you did on that change, perhaps we can do the
same for this patchset and call it sufficient, yes?

> >> I am not arguing that what you are proposing is that bad but unexpected
> >> failures cause real problems, and at a minimum that needs a better
> >> response than: "There is at least one user that wants a failure here".
> >
> > Let me fix that for you: "There are multiple users who want to have
> > better visibility and access control for user namespace creation."
>
> Visibility sure.  Design a proper hook for that.  All the proposed hook
> can do is print an audit message.  It can't allocate or manage any state
> as there is not the corresponding hook when a user namespace is freed.
> So the proposed hook is not appropriate for increasing visibility.

Auditing very much increases visibility.  Look at what the BPF LSM can
do, observability is one of its primary goals.

> Access control.  Not a chance unless it is carefully designed and
> reviewed.

See the above.  The relevant syscalls already have the risk of
failure, if userspace is assuming fork/clone/unshare/etc. will never
fail then that application is broken independent of this discussion.

-- 
paul-moore.com
