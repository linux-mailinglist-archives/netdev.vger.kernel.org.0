Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12DAF55C358
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242117AbiF0WNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 18:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242071AbiF0WNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 18:13:19 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3327960E8
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 15:13:17 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id v193-20020a1cacca000000b003a051f41541so100835wme.5
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 15:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S6bwOwkX5Z4SGSfVMm1UXqbEyn0vLvM5TyBgzsUl/Fc=;
        b=WIN/GT25JMWQXYpou5yhbufZOZ52jehFNogFtuMhPrGblHj3rgciMNCiLXwB6buaTn
         PeuLPWBx8Z3cZ1u2Aj7Jvmkt77i0llP2A/+n7Lgw4VWMxoSZetHhy1RPuHxS0qWMHlxs
         VdjP86ZaE0PknIxnbZSM6dqtHVHfZHc9o5qGGj3VwMqvkf/JpVHW6Efnxgb04JSwPH7r
         PLFTqTtQG6Ft9JiFXcInmfitBMZ7kHX84lvwNy43yHqsWqgXRJagzDu5rRnkhwE5LlIh
         In1mPJP1AAK07noCszmXhRFUnacTse7du2Ka9gmKHkMBcFr1UN6ITpzQ+3Rzqh8BsNs1
         kxng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S6bwOwkX5Z4SGSfVMm1UXqbEyn0vLvM5TyBgzsUl/Fc=;
        b=yawXE1Jd+4KDPOaS33LeNv1GsnAVIW/tqdTZDrgQNK1R6lcQdmxUQGc3OJQkhE+0Kc
         Uhic88ngQ0U5X5mT170CQMy/U0s/hZse4LpC2uyLlESITMGPYoMU9ykaYDqVit44F9MY
         /X2J0Aw8iCmXcueh0C8JOeF+JK6dUp53l1CaqAo425DcJXzrQQi5IidgKSrqGz6on+zP
         d9AsxNneBN4MjbBJUbUi4OYCXrfpPBVADZdLLYacTNpd5KgzAsvdwzWfBFnfRrrOZotD
         RllaUDCyanEUASZnyUDFIh9Skru0+RGYbf5w1jKmEY1FbwOtMIDEQFaA65Jxm2eNiHCH
         CbSw==
X-Gm-Message-State: AJIora/GQaP16UUo23HL2LDIPPgLYeSUFi4A1X/FWjHfbLubxyKhYPAF
        jpGZ/4J5EusXVnro3LefFoDeEEq9iFPsw4s1eQEC
X-Google-Smtp-Source: AGRyM1tKXfVOvMGC2IdFJFP01pHIVz3vf1EXnyA6Ayo7/R555UfIdQ3+MDb9Um1+kx/tE/qpCl0+OITpEWAnPwUqQuM=
X-Received: by 2002:a05:600c:2246:b0:3a0:4d14:e9d5 with SMTP id
 a6-20020a05600c224600b003a04d14e9d5mr5318298wmm.70.1656367995692; Mon, 27 Jun
 2022 15:13:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220621233939.993579-1-fred@cloudflare.com> <ce1653b1-feb0-1a99-0e97-8dfb289eeb79@schaufler-ca.com>
 <b72c889a-4a50-3330-baae-3bbf065e7187@cloudflare.com> <CAHC9VhSTkEMT90Tk+=iTyp3npWEm+3imrkFVX2qb=XsOPp9F=A@mail.gmail.com>
 <20220627121137.cnmctlxxtcgzwrws@wittgenstein> <b7c23d54-d196-98d1-8187-605f6d4dca4d@cloudflare.com>
In-Reply-To: <b7c23d54-d196-98d1-8187-605f6d4dca4d@cloudflare.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 27 Jun 2022 18:13:04 -0400
Message-ID: <CAHC9VhRfRq7wYx7mm-9AiepbULtbmih5pbfeunB823zt7_rrLg@mail.gmail.com>
Subject: Re: [PATCH 0/2] Introduce security_create_user_ns()
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@cloudflare.com
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

On Mon, Jun 27, 2022 at 11:51 AM Frederick Lawler <fred@cloudflare.com> wrote:
> On 6/27/22 7:11 AM, Christian Brauner wrote:
> > On Thu, Jun 23, 2022 at 11:21:37PM -0400, Paul Moore wrote:
> >> On Wed, Jun 22, 2022 at 10:24 AM Frederick Lawler <fred@cloudflare.com> wrote:
> >>> On 6/21/22 7:19 PM, Casey Schaufler wrote:
> >>>> On 6/21/2022 4:39 PM, Frederick Lawler wrote:

...

> >>>>> While creating a LSM BPF MAC policy to block user namespace creation, we
> >>>>> used the LSM cred_prepare hook because that is the closest hook to
> >>>>> prevent
> >>>>> a call to create_user_ns().
> >>>>>
> >>>>> The calls look something like this:
> >>>>>
> >>>>>       cred = prepare_creds()
> >>>>>           security_prepare_creds()
> >>>>>               call_int_hook(cred_prepare, ...
> >>>>>       if (cred)
> >>>>>           create_user_ns(cred)
> >>>>>
> >>>>> We noticed that error codes were not propagated from this hook and
> >>>>> introduced a patch [1] to propagate those errors.
> >>>>>
> >>>>> The discussion notes that security_prepare_creds()
> >>>>> is not appropriate for MAC policies, and instead the hook is
> >>>>> meant for LSM authors to prepare credentials for mutation. [2]
> >>>>>
> >>>>> Ultimately, we concluded that a better course of action is to introduce
> >>>>> a new security hook for LSM authors. [3]
> >>>>>
> >>>>> This patch set first introduces a new security_create_user_ns() function
> >>>>> and create_user_ns LSM hook, then marks the hook as sleepable in BPF.
> >>>>
> >>>> Why restrict this hook to user namespaces? It seems that an LSM that
> >>>> chooses to preform controls on user namespaces may want to do so for
> >>>> network namespaces as well.
> >>>
> >>> IIRC, CLONE_NEWUSER is the only namespace flag that does not require
> >>> CAP_SYS_ADMIN. There is a security use case to prevent this namespace
> >>> from being created within an unprivileged environment. I'm not opposed
> >>> to a more generic hook, but I don't currently have a use case to block
> >>> any others. We can also say the same is true for the other namespaces:
> >>> add this generic security function to these too.
> >>>
> >>> I'm curious what others think about this too.
> >>
> >> While user namespaces are obviously one of the more significant
> >> namespaces from a security perspective, I do think it seems reasonable
> >> that the LSMs could benefit from additional namespace creation hooks.
> >> However, I don't think we need to do all of them at once, starting
> >> with a userns hook seems okay to me.
> >>
> >> I also think that using the same LSM hook as an access control point
> >> for all of the different namespaces would be a mistake.  At the very
> >
> > Agreed. >
> >> least we would need to pass a flag or some form of context to the hook
> >> to indicate which new namespace(s) are being requested and I fear that
> >> is a problem waiting to happen.  That isn't to say someone couldn't
> >> mistakenly call the security_create_user_ns(...) from the mount
> >> namespace code, but I suspect that is much easier to identify as wrong
> >> than the equivalent security_create_ns(USER, ...).
> >
> > Yeah, I think that's a pretty unlikely scenario.
> >
> >>
> >> We also should acknowledge that while in most cases the current task's
> >> credentials are probably sufficient to make any LSM access control
> >> decisions around namespace creation, it's possible that for some
> >> namespaces we would need to pass additional, namespace specific info
> >> to the LSM.  With a shared LSM hook this could become rather awkward.
> >
> > Agreed.
> >
> >>
> >>>> Also, the hook seems backwards. You should
> >>>> decide if the creation of the namespace is allowed before you create it.
> >>>> Passing the new namespace to a function that checks to see creating a
> >>>> namespace is allowed doesn't make a lot off sense.
> >>>
> >>> I think having more context to a security hook is a good thing.
> >>
> >> This is one of the reasons why I usually like to see at least one LSM
> >> implementation to go along with every new/modified hook.  The
> >> implementation forces you to think about what information is necessary
> >> to perform a basic access control decision; sometimes it isn't always
> >> obvious until you have to write the access control :)
> >
> > I spoke to Frederick at length during LSS and as I've been given to
> > understand there's a eBPF program that would immediately use this new
> > hook. Now I don't want to get into the whole "Is the eBPF LSM hook
> > infrastructure an LSM" but I think we can let this count as a legitimate
> > first user of this hook/code.
> >
> >>
> >> [aside: If you would like to explore the SELinux implementation let me
> >> know, I'm happy to work with you on this.  I suspect Casey and the
> >> other LSM maintainers would also be willing to do the same for their
> >> LSMs.]
> >>
>
> I can take a shot at making a SELinux implementation, but the question
> becomes: is that for v2 or a later patch? I don't think the
> implementation for SELinux would be too complicated (i.e. make a call to
> avc_has_perm()?) but, testing and revisions might take a bit longer.

Isn't that the truth, writing code is easy(ish); testing it well is
the hard part ;)  Joking aside, I would suggest starting with v2.

As an example, the code below might be a good place to start - we would need to
discuss this on the SELinux list as there are some design decisions
I'm glossing over[1].

  int selinux_userns_create(struct cred *new)
  {
    u32 sid = current_sid();

    return avc_has_perm(&selinux_state, sid, sid,
                        SECCLASS_NAMESPACE,
                        NAMESPACE__USERNS_CREATE);
  }

You would also need to add the "namespace" class and the
"userns_create" permission in security/selinux/include/classmap.h.

  const struct security_class_mapping secclass_map[] = {
    ...
    { "namespace",
      { "userns_create", NULL } },
  }

As I mentioned earlier, if you find yourself getting stuck, or needing
some help, please feel free to send mail.

[1] This code snippet uses a new object class and permission for this
(namespace:userns_create).  I made that choice as object classes are
limited to 32 unique permissions and I expect the number of namespaces
to continue to grow.

-- 
paul-moore.com
