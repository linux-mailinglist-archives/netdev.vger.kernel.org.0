Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C205A1BF2
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 00:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244309AbiHYWLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 18:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241973AbiHYWLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 18:11:08 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B1641D2F
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 15:11:04 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id w197so25008722oie.5
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 15:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=aL/AGV/8w/lD0tdUyUfzE8bvL9UFhy5bQRgnqnJx79U=;
        b=A2e2m7ezoKBimHZ8/7VLP9dvWoH+EEf72LSF6b2eTN1goiRhAcaNEsH4aMIAdBMdDV
         Sw/W7FpIPVqOMojVjC6ABvS48bY7IGsqTB01A6M4cCeZegPyYFUg8EvR7s2s2aFc3LfC
         z98HdbmOEF6zR2mb4maMNOTJIQx37xA1hXWqy0Flnmpa2q0qc0mZ4IjJcJjpsZqyBmBD
         rjFiFyzF51Ai9kLcPbBi7LM4LWruE51HRS6Gbc7TLQMhiWeLDnQON4DYd5MxrMEUZmvg
         /tbF2C/V+pKnI850Af/7RerFaYyycqS4Iek09hpd2OxY6oJVEZTGKeKOi62YstibIH/C
         kMRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=aL/AGV/8w/lD0tdUyUfzE8bvL9UFhy5bQRgnqnJx79U=;
        b=C8R2Sappgm9KGKHlvGcUKknRQkKJykqIOmgHatJDbI4W99988PtBmAfdnr8qwSeLkD
         vRANfwImhBVVC/RaktJo3w87ulZKMZ58M2hAn7fbjMMpTvxHLOz511yAueyz7YfpeRl+
         lCasPNsY8DZYochfMeaOE/NfeNDAcouhRISRd9crrWlRdDIj8ul1AN4LWTPcYGTJQbUw
         TzhRW7RbtgD8hta4pqTFgpeBNU4UbWnKo/UCEWIiGrz5GH4756pjMJK2sRTRqqdVTJKc
         +W4YC69vh0emznpVU9dzLPQ7ZZHADc/KCsi1vYDhDo3YvySf32deHT20rtCf9/MECBMv
         loqQ==
X-Gm-Message-State: ACgBeo3Bz7Yd7j+rw/ijxer+spwex5S7AdWRSYRRNoSC3+plsFCrGV58
        WF2xvDwqZOMlfTwPinpwxO0qwulioMfvyleGvB+g
X-Google-Smtp-Source: AA6agR7SFEI7mDvYGEHKi8Bu9KDrgCXC7VjP4nzg+lnkg6FGxIcsxnYfGpmklXE7YULxMoUHaKN27KPpfrqqlTcOa3s=
X-Received: by 2002:aca:b7d5:0:b0:343:c478:91c6 with SMTP id
 h204-20020acab7d5000000b00343c47891c6mr444622oif.136.1661465463480; Thu, 25
 Aug 2022 15:11:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhTuxxRfJg=Ax5z87Jz6tq1oVRcppB444dHM2gP-FZrkTQ@mail.gmail.com>
 <8735dux60p.fsf@email.froward.int.ebiederm.org> <CAHC9VhSHJNLS-KJ-Rz1R12PQbqACSksLYLbymF78d5hMkSGc-g@mail.gmail.com>
 <871qte8wy3.fsf@email.froward.int.ebiederm.org> <CAHC9VhSU_sqMQwdoh0nAFdURqs_cVFbva8=otjcZUo8s+xyC9A@mail.gmail.com>
 <8735du7fnp.fsf@email.froward.int.ebiederm.org> <CAHC9VhQuRNxzgVeNhDy=p5+RHz5+bTH6zFdU=UvvEhyH1e962A@mail.gmail.com>
 <87tu6a4l83.fsf@email.froward.int.ebiederm.org> <20220818140521.GA1000@mail.hallyn.com>
 <CAHC9VhRqBxtV04ARQFPWpMf1aFZo0HP_HiJ+8VpXAT-zXF6UXw@mail.gmail.com>
 <20220819144537.GA16552@mail.hallyn.com> <CAHC9VhSZ0aaa3k3704j8_9DJvSNRy-0jfXpy1ncs2Jmo8H0a7g@mail.gmail.com>
 <875yigp4tp.fsf@email.froward.int.ebiederm.org> <CAHC9VhTN09ZabnQnsmbSjKgb8spx7_hkh4Z+mq5ArQmfPcVqAg@mail.gmail.com>
 <0D14C118-E644-4D7B-84C0-CA7752DC0605@fb.com>
In-Reply-To: <0D14C118-E644-4D7B-84C0-CA7752DC0605@fb.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 25 Aug 2022 18:10:52 -0400
Message-ID: <CAHC9VhS4ROEY6uBwJPaTKX_bLiDRCyFJ9_+_08gFP0VWF_s-bQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] Introduce security_create_user_ns()
To:     Song Liu <songliubraving@fb.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederick Lawler <fred@cloudflare.com>,
        KP Singh <kpsingh@kernel.org>,
        "revest@chromium.org" <revest@chromium.org>,
        "jackmanb@chromium.org" <jackmanb@chromium.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        James Morris <jmorris@namei.org>,
        "stephen.smalley.work@gmail.com" <stephen.smalley.work@gmail.com>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        Shuah Khan <shuah@kernel.org>,
        "brauner@kernel.org" <brauner@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        bpf <bpf@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        "cgzones@googlemail.com" <cgzones@googlemail.com>,
        "karl@bigbadwolfsecurity.com" <karl@bigbadwolfsecurity.com>,
        "tixxdz@gmail.com" <tixxdz@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 5:58 PM Song Liu <songliubraving@fb.com> wrote:
> > On Aug 25, 2022, at 12:19 PM, Paul Moore <paul@paul-moore.com> wrote:
> >
> > On Thu, Aug 25, 2022 at 2:15 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> >> Paul Moore <paul@paul-moore.com> writes:
> >>> On Fri, Aug 19, 2022 at 10:45 AM Serge E. Hallyn <serge@hallyn.com> wrote:
> >>>> I am hoping we can come up with
> >>>> "something better" to address people's needs, make everyone happy, and
> >>>> bring forth world peace.  Which would stack just fine with what's here
> >>>> for defense in depth.
> >>>>
> >>>> You may well not be interested in further work, and that's fine.  I need
> >>>> to set aside a few days to think on this.
> >>>
> >>> I'm happy to continue the discussion as long as it's constructive; I
> >>> think we all are.  My gut feeling is that Frederick's approach falls
> >>> closest to the sweet spot of "workable without being overly offensive"
> >>> (*cough*), but if you've got an additional approach in mind, or an
> >>> alternative approach that solves the same use case problems, I think
> >>> we'd all love to hear about it.
> >>
> >> I would love to actually hear the problems people are trying to solve so
> >> that we can have a sensible conversation about the trade offs.
> >
> > Here are several taken from the previous threads, it's surely not a
> > complete list, but it should give you a good idea:
> >
> > https://lore.kernel.org/linux-security-module/CAHC9VhQnPAsmjmKo-e84XDJ1wmaOFkTKPjjztsOa9Yrq+AeAQA@mail.gmail.com/
> >
> >> As best I can tell without more information people want to use
> >> the creation of a user namespace as a signal that the code is
> >> attempting an exploit.
> >
> > Some use cases are like that, there are several other use cases that
> > go beyond this; see all of our previous discussions on this
> > topic/patchset.  As has been mentioned before, there are use cases
> > that require improved observability, access control, or both.
> >
> >> As such let me propose instead of returning an error code which will let
> >> the exploit continue, have the security hook return a bool.  With true
> >> meaning the code can continue and on false it will trigger using SIGSYS
> >> to terminate the program like seccomp does.
> >
> > Having the kernel forcibly exit the process isn't something that most
> > LSMs would likely want.  I suppose we could modify the hook/caller so
> > that *if* an LSM wanted to return SIGSYS the system would kill the
> > process, but I would want that to be something in addition to
> > returning an error code like LSMs normally do (e.g. EACCES).
>
> I am new to user_namespace and security work, so please pardon me if
> anything below is very wrong.
>
> IIUC, user_namespace is a tool that enables trusted userspace code to
> control the behavior of untrusted (or less trusted) userspace code.
> Failing create_user_ns() doesn't make the system more reliable.
> Specifically, we call create_user_ns() via two paths: fork/clone and
> unshare. For both paths, we need the userspace to use user_namespace,
> and to honor failed create_user_ns().
>
> On the other hand, I would echo that killing the process is not
> practical in some use cases. Specifically, allowing the application to
> run in a less secure environment for a short period of time might be
> much better than killing it and taking down the whole service. Of
> course, there are other cases that security is more important, and
> taking down the whole service is the better choice.
>
> I guess the ultimate solution is a way to enforce using user_namespace
> in the kernel (if it ever makes sense...).

The LSM framework, and the BPF and SELinux LSM implementations in this
patchset, provide a mechanism to do just that: kernel enforced access
controls using flexible security policies which can be tailored by the
distro, solution provider, or end user to meet the specific needs of
their use case.

-- 
paul-moore.com
