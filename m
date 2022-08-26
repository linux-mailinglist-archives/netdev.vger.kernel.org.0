Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C108B5A2A41
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 17:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239559AbiHZPCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 11:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237173AbiHZPCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 11:02:18 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6E1D9D7B
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 08:02:15 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id h20-20020a056830165400b00638ac7ddba5so1176528otr.4
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 08:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=tRhd/2/uHL0VX0F4GeRi6SnOKLBFJo3Q7T6F3F0TR3s=;
        b=orhQFJnsjMOMEl1XYB+lStIgrX4ra7SL0ABeZSgcWzIJcW65G6IzHoIBENxN8sseM4
         CoAsY/870bHVS0FlrCS9ipyA4VCGdNf5nQmNvDdLVx/azkoX2x2btuKOCv48mV3Y+ylC
         hjOEY0WAesEQlmTkAi55NKTX05lKq3t4syAEoUszo9ZiAbZqfxhsJM1fiF+/x+BAX6xJ
         OhogR1k6QWDtXqvaxG0/7agNJPwoah7vt6vcOG6dsUJJ8o8LNiRCMkdEVCa8OF1yY7jg
         gaR+VqCefuGhBiOdD9DAtM6o+3mqXrjCWTrlKKX3Ss8zz4QhR0+UGbOcoaRVxTModdNe
         kJBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=tRhd/2/uHL0VX0F4GeRi6SnOKLBFJo3Q7T6F3F0TR3s=;
        b=GREfy7ZOI7rnTp+HT3nkzxRaRwyzFbIrglCAlmNWuTeOtPhs+uLpTp+k6MchpRVzk2
         qtlbTiLngjv28ZTlj4MBMdWLlit6gDoQlKSJsnHElaUuvhNQyV3iaSp6jbVOZ5EuosmZ
         mwvswA/XZ3RXx3ewtxHUsYaOdgGFs4GisagJh87h7Ip1ATschfNfWspyUlDafCg9RZ7r
         9TbdhQyIR7i2H/ffLCuuVSXS3WtkCDLWujNto3v8u5z2xqq6W82oEJDHBFgEMvONDORu
         igqYBBg8MfUzOKdti6BT0vT65a/0RlW3rsTWbLfUVEKdAKAtbPcvH5y5nH6YMb0Dtcf2
         lKXw==
X-Gm-Message-State: ACgBeo1dkdpTVP1XPNm+mVTB7g87M2ihWZjqtVpAa3JvA07JaTD4L7NN
        7qCw/mhASbaMWyED7Vr9osoT9R3GGFIt1NPEqvmp
X-Google-Smtp-Source: AA6agR56pOHGSBiz/+WZK6L4lhfNAe2FeRxCZVmxSMGb8hKzyXQdARkr25+BXbcIUJSAKIdw0+UELoCxFiaeDXQtsyg=
X-Received: by 2002:a9d:2de3:0:b0:638:e210:c9da with SMTP id
 g90-20020a9d2de3000000b00638e210c9damr1506204otb.69.1661526134578; Fri, 26
 Aug 2022 08:02:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhTuxxRfJg=Ax5z87Jz6tq1oVRcppB444dHM2gP-FZrkTQ@mail.gmail.com>
 <8735dux60p.fsf@email.froward.int.ebiederm.org> <CAHC9VhSHJNLS-KJ-Rz1R12PQbqACSksLYLbymF78d5hMkSGc-g@mail.gmail.com>
 <871qte8wy3.fsf@email.froward.int.ebiederm.org> <CAHC9VhSU_sqMQwdoh0nAFdURqs_cVFbva8=otjcZUo8s+xyC9A@mail.gmail.com>
 <8735du7fnp.fsf@email.froward.int.ebiederm.org> <CAHC9VhQuRNxzgVeNhDy=p5+RHz5+bTH6zFdU=UvvEhyH1e962A@mail.gmail.com>
 <87tu6a4l83.fsf@email.froward.int.ebiederm.org> <20220818140521.GA1000@mail.hallyn.com>
 <CAHC9VhRqBxtV04ARQFPWpMf1aFZo0HP_HiJ+8VpXAT-zXF6UXw@mail.gmail.com>
 <20220819144537.GA16552@mail.hallyn.com> <CAHC9VhSZ0aaa3k3704j8_9DJvSNRy-0jfXpy1ncs2Jmo8H0a7g@mail.gmail.com>
 <875yigp4tp.fsf@email.froward.int.ebiederm.org> <CAHC9VhTN09ZabnQnsmbSjKgb8spx7_hkh4Z+mq5ArQmfPcVqAg@mail.gmail.com>
 <0D14C118-E644-4D7B-84C0-CA7752DC0605@fb.com> <CAHC9VhS4ROEY6uBwJPaTKX_bLiDRCyFJ9_+_08gFP0VWF_s-bQ@mail.gmail.com>
 <ABA58A31-E4BE-445A-B98C-F462D2ED7679@fb.com>
In-Reply-To: <ABA58A31-E4BE-445A-B98C-F462D2ED7679@fb.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 26 Aug 2022 11:02:03 -0400
Message-ID: <CAHC9VhRU-b8LC3722tBHAzd6atrgiSAaGm16sRf_M7hywWFOOA@mail.gmail.com>
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
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 6:42 PM Song Liu <songliubraving@fb.com> wrote:
> > On Aug 25, 2022, at 3:10 PM, Paul Moore <paul@paul-moore.com> wrote:
> > On Thu, Aug 25, 2022 at 5:58 PM Song Liu <songliubraving@fb.com> wrote:

...

> >> I am new to user_namespace and security work, so please pardon me if
> >> anything below is very wrong.
> >>
> >> IIUC, user_namespace is a tool that enables trusted userspace code to
> >> control the behavior of untrusted (or less trusted) userspace code.
> >> Failing create_user_ns() doesn't make the system more reliable.
> >> Specifically, we call create_user_ns() via two paths: fork/clone and
> >> unshare. For both paths, we need the userspace to use user_namespace,
> >> and to honor failed create_user_ns().
> >>
> >> On the other hand, I would echo that killing the process is not
> >> practical in some use cases. Specifically, allowing the application to
> >> run in a less secure environment for a short period of time might be
> >> much better than killing it and taking down the whole service. Of
> >> course, there are other cases that security is more important, and
> >> taking down the whole service is the better choice.
> >>
> >> I guess the ultimate solution is a way to enforce using user_namespace
> >> in the kernel (if it ever makes sense...).
> >
> > The LSM framework, and the BPF and SELinux LSM implementations in this
> > patchset, provide a mechanism to do just that: kernel enforced access
> > controls using flexible security policies which can be tailored by the
> > distro, solution provider, or end user to meet the specific needs of
> > their use case.
>
> In this case, I wouldn't call the kernel is enforcing access control.
> (I might be wrong). There are 3 components here: kernel, LSM, and
> trusted userspace (whoever calls unshare).

The LSM layer, and the LSMs themselves are part of the kernel; look at
the changes in this patchset to see the LSM, BPF LSM, and SELinux
kernel changes.  Explaining how the different LSMs work is quite a bit
beyond the scope of this discussion, but there is plenty of
information available online that should be able to serve as an
introduction, not to mention the kernel source itself.  However, in
very broad terms you can think of the individual LSMs as somewhat
analogous to filesystem drivers, e.g. ext4, and the LSM itself as the
VFS layer.

> AFAICT, kernel simply passes
> the decision made by LSM (BPF or SELinux) to the trusted userspace. It
> is up to the trusted userspace to honor the return value of unshare().

With a LSM enabled and enforcing a security policy on user namespace
creation, which appears to be the case of most concern, the kernel
would make a decision on the namespace creation based on various
factors (e.g. for SELinux this would be the calling process' security
domain and the domain's permission set as determined by the configured
security policy) and if the operation was rejected an error code would
be returned to userspace and the operation rejected.  It is the exact
same thing as what would happen if the calling process is chrooted or
doesn't have a proper UID/GID mapping.  Don't forget that the
create_user_ns() function already enforces a security policy and
returns errors to userspace; this patchset doesn't add anything new in
that regard, it just allows for a richer and more flexible security
policy to be built on top of the existing constraints.

> If the userspace simply ignores unshare failures, or does not call
> unshare(CLONE_NEWUSER), kernel and LSM cannot do much about it, right?

The process is still subject to any security policies that are active
and being enforced by the kernel.  A malicious or misconfigured
application can still be constrained by the kernel using both the
kernel's legacy Discretionary Access Controls (DAC) as well as the
more comprehensive Mandatory Access Controls (MAC) provided by many of
the LSMs.

-- 
paul-moore.com
