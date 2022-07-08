Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5088D56BBBE
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 16:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237995AbiGHOf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 10:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237974AbiGHOfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 10:35:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387AF22522;
        Fri,  8 Jul 2022 07:35:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63713B8255E;
        Fri,  8 Jul 2022 14:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A1EC341C0;
        Fri,  8 Jul 2022 14:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657290919;
        bh=AwPkpBjvUMzrILQ+qIDIWQS3U2aLgq3UVGKJV7XFLoU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E/wLQrpEgcm63ktpq34MjFig3s5y6zF1aJE63yFFiDpCJF5i9PUWcIlwgp39+KFCc
         2cTPGJ6lzjUKQ4TQSaA14Yri+7ZW7qg3W0XI+ib2qDResYRbMsy/VtwFZDSXo5Wbzq
         X5e1Oa4nCIgjcfmiIq312iod0lPmXO7l3J9mUSd6lHA5E8oeynfrKfJWuePexrznyJ
         PCVbkl9us8mEVVT3kZopTu+CPcWkacE+YjkDzeUsSyFqLGKwugC915soobTOru2QEc
         JQIakRAlTkfh/C6SxvEhEBRbgurOoglJ0K5qPklqGMaHxFLvyccM/e47D9AVWsWUse
         uQ4ZmmwmIlPeg==
Date:   Fri, 8 Jul 2022 16:35:11 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     Christian =?utf-8?B?R8O2dHRzY2hl?= <cgzones@googlemail.com>,
        KP Singh <kpsingh@kernel.org>, revest@chromium.org,
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
        Casey Schaufler <casey@schaufler-ca.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        SElinux list <selinux@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [PATCH v2 0/4] Introduce security_create_user_ns()
Message-ID: <20220708143511.wx4oix4efvy5pmkh@wittgenstein>
References: <20220707223228.1940249-1-fred@cloudflare.com>
 <CAJ2a_DezgSpc28jvJuU_stT7V7et-gD7qjy409oy=ZFaUxJneg@mail.gmail.com>
 <3dbd5b30-f869-b284-1383-309ca6994557@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3dbd5b30-f869-b284-1383-309ca6994557@cloudflare.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 08, 2022 at 09:01:32AM -0500, Frederick Lawler wrote:
> On 7/8/22 7:10 AM, Christian Göttsche wrote:
> > ,On Fri, 8 Jul 2022 at 00:32, Frederick Lawler <fred@cloudflare.com> wrote:
> > > 
> > > While creating a LSM BPF MAC policy to block user namespace creation, we
> > > used the LSM cred_prepare hook because that is the closest hook to prevent
> > > a call to create_user_ns().
> > > 
> > > The calls look something like this:
> > > 
> > >      cred = prepare_creds()
> > >          security_prepare_creds()
> > >              call_int_hook(cred_prepare, ...
> > >      if (cred)
> > >          create_user_ns(cred)
> > > 
> > > We noticed that error codes were not propagated from this hook and
> > > introduced a patch [1] to propagate those errors.
> > > 
> > > The discussion notes that security_prepare_creds()
> > > is not appropriate for MAC policies, and instead the hook is
> > > meant for LSM authors to prepare credentials for mutation. [2]
> > > 
> > > Ultimately, we concluded that a better course of action is to introduce
> > > a new security hook for LSM authors. [3]
> > > 
> > > This patch set first introduces a new security_create_user_ns() function
> > > and create_user_ns LSM hook, then marks the hook as sleepable in BPF.
> > 
> > Some thoughts:
> > 
> > I.
> > 
> > Why not make the hook more generic, e.g. support all other existing
> > and potential future namespaces?
> 
> The main issue with a generic hook is that different namespaces have
> different calling contexts. We decided in a previous discussion to opt-out
> of a generic hook for this reason. [1]

Agreed.

> 
> > Also I think the naming scheme is <object>_<verb>.
> 
> That's a good call out. I was originally hoping to keep the security_*()
> match with the hook name matched with the caller function to keep things all
> aligned. If no one objects to renaming the hook, I can rename the hook for
> v3.
> 
> > 
> >      LSM_HOOK(int, 0, namespace_create, const struct cred *cred,
> > unsigned int flags)
> > 
> > where flags is a bitmap of CLONE flags from include/uapi/linux/sched.h
> > (like CLONE_NEWUSER).
> > 
> > II.
> > 
> > While adding policing for namespaces maybe also add a new hook for setns(2)
> > 
> >      LSM_HOOK(int, 0, namespace_join, const struct cred *subj,  const
> > struct cred *obj, unsigned int flags)
> > 
> 
> IIUC, setns() will create a new namespace for the other namespaces except
> for user namespace. If we add a security hook for the other create_*_ns()

setns() doesn't create new namespaces. It just switches to already
existing ones:

setns(<pidfd>, <flags>)
-> prepare_nsset()
      /* 
       * Notice the 0 passed as flags which means all namespaces will
       * just take a reference.
       */
   -> create_new_namespaces(0, ...)

you're thinking about unshare() and unshare() will be caught in
create_user_ns().

> functions, then we can catch setns() at that point.

If you block the creation of user namespaces by unprivileged users in
create_user_ns() you can only create user namespaces as a privileged
user. Consequently only a privileged users can setns() to a user
namespace. So either the caller has CAP_SYS_ADMIN in the parent userns
or they are located in the parent userns and are the owner of the userns
they are attaching to. So if you lock create_user_ns() to
capable(CAP_SYS_ADMIN) you should be done.
