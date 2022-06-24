Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689BC558F0A
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 05:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiFXDVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 23:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiFXDVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 23:21:52 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1382560F38
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 20:21:50 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id e7so1289994wrc.13
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 20:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nkA12o8J/G8WC/x2ZjqUQFWdUod71jTMrhuVlQ+gIfc=;
        b=cB+o0n9FydEJuF7kdgUBwLms6sg/mL07v5Fm4wCK5oaeo52McxaVgaMqRXxn82FBYl
         YxRmxsrCOhxOyr1v5satohMH1/s+X6ZRb+NJZsgIthjEXz6y1+tTqFm9WOGZz6rr3SU/
         zxWAbi5cozSEypGIO33gbc+ffLdv5Sp3E+DAETn5U87nrlBRouptfEhknKi4Q0S6RWgc
         cpkb+qF9DXJ54Hj4sYi+NOHN1ZYPWYZfkUTQBbwufaxWiz9mBlye7YYbqmcYiM9KFWbU
         aakhigOid5o+64hSNKle7XLMwbisINZEz+pZtDge+dsqY4Z+lGnJ08gdtXl5Xz5lLx1D
         U6dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nkA12o8J/G8WC/x2ZjqUQFWdUod71jTMrhuVlQ+gIfc=;
        b=JvKW25DQwVXIy8JxX75YKUkNWhQSaTqQiUG49/T7g8hsCr4vebXbgt1D9l2xn2LI3I
         A4h9Q4gFXghIwk+uR1Rk05FnI5+cAyRxr+zkF95aw/iY8oBZS4pGnq06V8yb1ba101Hd
         Qsew8mwcWa1pLBrKfpnBMselZENjYTcnT6QxUOx0TGT+gaHW0xyUdPiDgz1/TufVocmc
         kd7UzWn3GuTPo0V5vzKv23Dz+f6FoBhYe1CWxQx3Uc2Xz3q97InEg6tsuLlStxsMQiBu
         HqhRsjipgudvsUGrG8jymGHH4eE0h2wAFk4ogIO35mgkehxTWFU6zHSoyod70fDpfJ+X
         FVYw==
X-Gm-Message-State: AJIora/3YA57A/MNKaBMfn82HvOoHicUhUP40JZ1Nl7tNeuztF543Vh7
        xP9ir34I1xXrAstUUhMWTnHJlgU9GNWNl1TLGIKe
X-Google-Smtp-Source: AGRyM1vzEq1PW3uWevmMOO7hQB/5IqqeX5H+D3AuL1YvM7TVvsF3TSr0F7DNVOKp8u3V2fk0wOc1mjVvEQuIplvXnCM=
X-Received: by 2002:a5d:4848:0:b0:21b:8cda:5747 with SMTP id
 n8-20020a5d4848000000b0021b8cda5747mr11337757wrs.483.1656040908556; Thu, 23
 Jun 2022 20:21:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220621233939.993579-1-fred@cloudflare.com> <ce1653b1-feb0-1a99-0e97-8dfb289eeb79@schaufler-ca.com>
 <b72c889a-4a50-3330-baae-3bbf065e7187@cloudflare.com>
In-Reply-To: <b72c889a-4a50-3330-baae-3bbf065e7187@cloudflare.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 23 Jun 2022 23:21:37 -0400
Message-ID: <CAHC9VhSTkEMT90Tk+=iTyp3npWEm+3imrkFVX2qb=XsOPp9F=A@mail.gmail.com>
Subject: Re: [PATCH 0/2] Introduce security_create_user_ns()
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     Casey Schaufler <casey@schaufler-ca.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, brauner@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@cloudflare.com
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

On Wed, Jun 22, 2022 at 10:24 AM Frederick Lawler <fred@cloudflare.com> wrote:
> On 6/21/22 7:19 PM, Casey Schaufler wrote:
> > On 6/21/2022 4:39 PM, Frederick Lawler wrote:
> >> While creating a LSM BPF MAC policy to block user namespace creation, we
> >> used the LSM cred_prepare hook because that is the closest hook to
> >> prevent
> >> a call to create_user_ns().
> >>
> >> The calls look something like this:
> >>
> >>      cred = prepare_creds()
> >>          security_prepare_creds()
> >>              call_int_hook(cred_prepare, ...
> >>      if (cred)
> >>          create_user_ns(cred)
> >>
> >> We noticed that error codes were not propagated from this hook and
> >> introduced a patch [1] to propagate those errors.
> >>
> >> The discussion notes that security_prepare_creds()
> >> is not appropriate for MAC policies, and instead the hook is
> >> meant for LSM authors to prepare credentials for mutation. [2]
> >>
> >> Ultimately, we concluded that a better course of action is to introduce
> >> a new security hook for LSM authors. [3]
> >>
> >> This patch set first introduces a new security_create_user_ns() function
> >> and create_user_ns LSM hook, then marks the hook as sleepable in BPF.
> >
> > Why restrict this hook to user namespaces? It seems that an LSM that
> > chooses to preform controls on user namespaces may want to do so for
> > network namespaces as well.
>
> IIRC, CLONE_NEWUSER is the only namespace flag that does not require
> CAP_SYS_ADMIN. There is a security use case to prevent this namespace
> from being created within an unprivileged environment. I'm not opposed
> to a more generic hook, but I don't currently have a use case to block
> any others. We can also say the same is true for the other namespaces:
> add this generic security function to these too.
>
> I'm curious what others think about this too.

While user namespaces are obviously one of the more significant
namespaces from a security perspective, I do think it seems reasonable
that the LSMs could benefit from additional namespace creation hooks.
However, I don't think we need to do all of them at once, starting
with a userns hook seems okay to me.

I also think that using the same LSM hook as an access control point
for all of the different namespaces would be a mistake.  At the very
least we would need to pass a flag or some form of context to the hook
to indicate which new namespace(s) are being requested and I fear that
is a problem waiting to happen.  That isn't to say someone couldn't
mistakenly call the security_create_user_ns(...) from the mount
namespace code, but I suspect that is much easier to identify as wrong
than the equivalent security_create_ns(USER, ...).

We also should acknowledge that while in most cases the current task's
credentials are probably sufficient to make any LSM access control
decisions around namespace creation, it's possible that for some
namespaces we would need to pass additional, namespace specific info
to the LSM.  With a shared LSM hook this could become rather awkward.

> > Also, the hook seems backwards. You should
> > decide if the creation of the namespace is allowed before you create it.
> > Passing the new namespace to a function that checks to see creating a
> > namespace is allowed doesn't make a lot off sense.
>
> I think having more context to a security hook is a good thing.

This is one of the reasons why I usually like to see at least one LSM
implementation to go along with every new/modified hook.  The
implementation forces you to think about what information is necessary
to perform a basic access control decision; sometimes it isn't always
obvious until you have to write the access control :)

[aside: If you would like to explore the SELinux implementation let me
know, I'm happy to work with you on this.  I suspect Casey and the
other LSM maintainers would also be willing to do the same for their
LSMs.]

In this particular case I think the calling task's credentials are
generally all that is needed.  You mention that the newly created
namespace would be helpful, so I'll ask: what info in the new ns do
you believe would be helpful in making an access decision about its
creation?

Once we've sorted that we can make a better decision about the hook
placement, but right now my gut feeling is that we only need to pass
the task's creds, and I think placing the hook right after the UID/GID
mapping check (before the new ns allocation) would be the best spot.

-- 
paul-moore.com
