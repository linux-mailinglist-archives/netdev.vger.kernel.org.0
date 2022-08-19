Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D3E59A76E
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 23:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352256AbiHSVKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 17:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352234AbiHSVKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 17:10:43 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B51E095B
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 14:10:41 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-11cc7698a18so3521271fac.4
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 14:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=zmFxI4fcqG+VM79kjsw3Dz4TIlHari2uDbTRTdPXcuI=;
        b=udeHnstv36JubtLuTYAHvkRsCYyIXRbm68kCEPPrsUYo2bOebLxId89dOQzU1S4+yC
         XpvNE7bTxDppbvh1Z5i+8BYlB8NX6HNZYEJvnfvvYXkiekcmDZWw6abvSa/FsLIZd6rV
         KWgXxB+7ZGLahThNN7JXqvYZvRw5WhE1dSDZ08Y+fjG8BT3axeRWbJhWMDnOo5KZX4Es
         fbFNNM4tvzaBo1fSWTt2NMrB3RsRmi3l0+dnpt7huBR1sA4uPXywbPov39c0ADkwhkZV
         +xH634tLJSLX2zUecJGjSIeKFE9d8es5JUd39EZksIMYU+tQXh/x5L/cYTEkw71aiPB5
         3/xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=zmFxI4fcqG+VM79kjsw3Dz4TIlHari2uDbTRTdPXcuI=;
        b=pL1wWB8/oDCG3shXUBcyephf8/zAguaGpIrs1I3qcStBAjgGoIxwYeavr3OSrXDNJ2
         zChWUHWDR4AzbLHik/u2m3T+YlzRTUicKifJOZeJCaVu9KXxjsOaaBHFG2waxYc05iVm
         JDyh+DpSh5ZUPGcQyw7IISTfBpweK+mU0gAJCDR0yh4ogCeMkp5VG6JelBUiu5APEzt4
         wPZmkKUMnrg8K6qptbzjrEPjKZJxoMyu21z6dtHQ2IrYEo+jRzLUtgzlrcBOwRE/D53d
         Sr+tLHh5n2hAVwSjGW4e0NedhDmJHeRSRltqc49XknQdvoc/zlFVLEkjgFBaHdQf2XR+
         7GUQ==
X-Gm-Message-State: ACgBeo3kw/xleEvjzyV9saaVqWoeYeT6CsA/HRWBpnFgDDfFBZdd6L7v
        E8btaFe6YPskEfeJeaI06Y1gvpHdJOabppFhe2f1
X-Google-Smtp-Source: AA6agR4yeIHW1ffPuIU0gnJHMWqUhUxYplMRWQFExgwSU8cLoP2mDo+70sMA6OpN/Lhm/rmY1PbO9kzIe7AIXsog2nY=
X-Received: by 2002:a05:6870:a78d:b0:11c:437b:ec70 with SMTP id
 x13-20020a056870a78d00b0011c437bec70mr4812540oao.136.1660943440240; Fri, 19
 Aug 2022 14:10:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhTuxxRfJg=Ax5z87Jz6tq1oVRcppB444dHM2gP-FZrkTQ@mail.gmail.com>
 <8735dux60p.fsf@email.froward.int.ebiederm.org> <CAHC9VhSHJNLS-KJ-Rz1R12PQbqACSksLYLbymF78d5hMkSGc-g@mail.gmail.com>
 <871qte8wy3.fsf@email.froward.int.ebiederm.org> <CAHC9VhSU_sqMQwdoh0nAFdURqs_cVFbva8=otjcZUo8s+xyC9A@mail.gmail.com>
 <8735du7fnp.fsf@email.froward.int.ebiederm.org> <CAHC9VhQuRNxzgVeNhDy=p5+RHz5+bTH6zFdU=UvvEhyH1e962A@mail.gmail.com>
 <87tu6a4l83.fsf@email.froward.int.ebiederm.org> <20220818140521.GA1000@mail.hallyn.com>
 <CAHC9VhRqBxtV04ARQFPWpMf1aFZo0HP_HiJ+8VpXAT-zXF6UXw@mail.gmail.com> <20220819144537.GA16552@mail.hallyn.com>
In-Reply-To: <20220819144537.GA16552@mail.hallyn.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 19 Aug 2022 17:10:29 -0400
Message-ID: <CAHC9VhSZ0aaa3k3704j8_9DJvSNRy-0jfXpy1ncs2Jmo8H0a7g@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] Introduce security_create_user_ns()
To:     "Serge E. Hallyn" <serge@hallyn.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, shuah@kernel.org, brauner@kernel.org,
        casey@schaufler-ca.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com,
        tixxdz@gmail.com
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

On Fri, Aug 19, 2022 at 10:45 AM Serge E. Hallyn <serge@hallyn.com> wrote:
> On Thu, Aug 18, 2022 at 11:11:06AM -0400, Paul Moore wrote:
> > On Thu, Aug 18, 2022 at 10:05 AM Serge E. Hallyn <serge@hallyn.com> wrote:

...

> > > I do strongly sympathize with Eric's points.  It will be very easy, once
> > > user namespace creation has been further restricted in some distros, to
> > > say "well see this stuff is silly" and go back to simply requiring root
> > > to create all containers and namespaces, which is generally quite a bit
> > > easier anywway.  And then, of course, give everyone root so they can
> > > start containers.
> >
> > That's assuming a lot.  Many years have passed since namespaces were
> > first introduced, and awareness of good security practices has
> > improved, perhaps not as much as any of us would like, but to say that
> > distros, system builders, and even users are the same as they were so
> > many years ago is a bit of a stretch in my opinion.
>
> Maybe.  But I do get a bit worried based on some of what I've been
> reading in mailing lists lately.  Kernel dev definitely moves like
> fashion - remember when every api should have its own filesystem?
> That was not a different group of people.

I'm not going to argue against the idea that kernel development is
subject to fads, I just don't agree that adding a LSM control point
for user namespace creation is going to be the end of user namespaces.

> > However, even ignoring that for a moment, do we really want to go to a
> > place where we dictate how users compose and secure their systems?
> > Linux "took over the world" because it offered a level of flexibility
> > that wasn't really possible before, and it has flourished because it
> > has kept that mentality.  The Linux Kernel can be shoehorned onto most
> > hardware that you can get your hands on these days, with driver
> > support for most anything you can think to plug into the system.  Do
> > you want a single-user environment with no per-user separation?  We
> > can do that.  Do you want a traditional DAC based system that leans
> > heavy on ACLs and capabilities?  We can do that.  Do you want a
> > container host that allows you to carve up the system with a high
> > degree of granularity thanks to the different namespaces?  We can do
> > that.  How about a system that leverages the LSM to enforce a least
> > privilege ideal, even on the most privileged root user?  We can do
> > that too.  This patchset is about giving distro, system builders, and
> > users another choice in how they build their system.  We've seen both
>
> Oh, you misunderstand.  Whereas I do feel there are important concerns in
> Eric's objections, and whereas I don't feel this set sufficiently
> addresses the problems that I see and outlined above, I do see value in
> this set, and was not aiming to deter it.  We need better ways to
> mitigate a certain clas sof 0-days without completely disallowing use of
> user namespaces, and this may help.

Ah, thanks for the explanation, I missed that (obviously) in your
previous email.  If I'm perfectly honest, I suppose the protracted
debate with Eric has also left me a little overly sensitive to any
perceived arguments against this patchset.

> > in this patchset and in previously failed attempts that there is a
> > definite want from a user perspective for functionality such as this,
> > and I think it's time we deliver it in the upstream kernel so they
> > don't have to keep patching their own systems with out-of-tree
> > patches.
> >
> > > Eric and Paul, I wonder, will you - or some people you'd like to represent
> > > you - be at plumbers in September?  Should there be a BOF session there?  (I
> > > won't be there, but could join over video)  I think a brainstorming session
> > > for solutions to the above problems would be good.
> >
> > Regardless of if Eric or I will be at LPC, it is doubtful that all of
> > the people who have participated in this discussion will be able to
> > attend, and I think it's important that the users who are asking for
> > this patchset have a chance to be heard in each forum where this is
> > discussed.  While conferences are definitely nice - I definitely
> > missed them over the past couple of years - we can't use them as a
> > crutch to help us reach a conclusion on this issue; we've debated much
>
> No I wasn't thinking we would use LPC to decide on this patchset.  As far
> as I can see, the patchset is merged.

While I maintain that Frederick's patches are a good thing, I'm not
going to consider them "merged" until I see them in Linus' tree or
Linus decided to voice his support on the lists.  These patches do
have Eric's NACK, and a maintainer's NACK isn't something to take
lightly.  I certainly don't.

>  I am hoping we can come up with
> "something better" to address people's needs, make everyone happy, and
> bring forth world peace.  Which would stack just fine with what's here
> for defense in depth.
>
> You may well not be interested in further work, and that's fine.  I need
> to set aside a few days to think on this.

I'm happy to continue the discussion as long as it's constructive; I
think we all are.  My gut feeling is that Frederick's approach falls
closest to the sweet spot of "workable without being overly offensive"
(*cough*), but if you've got an additional approach in mind, or an
alternative approach that solves the same use case problems, I think
we'd all love to hear about it.

-- 
paul-moore.com
