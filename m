Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29D6598708
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245258AbiHRPLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245167AbiHRPLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:11:22 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0E8BE4CF
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:11:18 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-11ba6e79dd1so2077108fac.12
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=GANP9vLRwQ2YLUROnRwlZNpTwcMjsaJ3VgtSa/PtcQA=;
        b=0qFr3gX8grFcH8xmET6oC1qTaE9YXfJGFQ2GhO7NEnI8UJe/rml2OLbEr4Jw1nQKgR
         d12kPSjSQe3qNmXickEgFu68t4SIk6+fn1KvnQautrJRDdPKcPRfC9kt1hvPEgu+ijXD
         7iHrt1dL8Pek8n+C/DBvnSz5bNp5udDpG9vzcJ4mjVl2uLAsjvPjxzZNC3uc1Sn9d8BN
         jgZh1sTFXRnSeYNTo+wlZfynZ0xcbCj8IKq0w2RsVpncFi6U9vN4TxyRRKmoNsvJJQvH
         8z5x3IrwifZWro1HnNJlG0tBICYV2T1LywfHD7Dw228ev4nd3JbJBYgF/S7hFYBg6Rd0
         xVCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=GANP9vLRwQ2YLUROnRwlZNpTwcMjsaJ3VgtSa/PtcQA=;
        b=A97Di9Vk/5/Oa4Q36T2RKCSegMIYWckX255G9ncZ4KxlZHBJWb7/tJOyxXvFDFV5Rp
         tDChwqAWNdA7Ovf7uMDtrmq1RiewbIbPDebmHeBwOKwzYXysPNg23z4SiNcy/HkOiSUF
         Ef5U7eElC2azU44rioQUjz/5vSNOgkE5LjK9lBdItydDRGZRsEBKbiAZ4vQlQQcK1yhB
         vwFIbNHLZ0J0TTINzOpdjhM+KVDwIRJU30RUGVEO/H9rd3EkF0KegmP2FmJWW+zELw87
         mU1k2Z0f8k8MsqU8rJGFyVGPlv0uwU4k7wZf++Qke8637BWsU3HsmmbB2caZZmjWZU6b
         tD9w==
X-Gm-Message-State: ACgBeo3OncO5mX3u42S/e2hK9Gs0ueAsmWOHk3juH63j1ePIFZvHOHTT
        Sr4tMCZFvrE/pBCyq3SrSFf92SlmynQSITWpqZmj
X-Google-Smtp-Source: AA6agR66YXOH5oppw7egFiDoyCC8ej5Sf5Kmv975mn8bSRsO6rpaEhSZQdqJw2zGnbq9Y7af7ZLG1mLeF4J63BZuPNo=
X-Received: by 2002:a05:6870:a78d:b0:11c:437b:ec70 with SMTP id
 x13-20020a056870a78d00b0011c437bec70mr1643477oao.136.1660835477277; Thu, 18
 Aug 2022 08:11:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220815162028.926858-1-fred@cloudflare.com> <CAHC9VhTuxxRfJg=Ax5z87Jz6tq1oVRcppB444dHM2gP-FZrkTQ@mail.gmail.com>
 <8735dux60p.fsf@email.froward.int.ebiederm.org> <CAHC9VhSHJNLS-KJ-Rz1R12PQbqACSksLYLbymF78d5hMkSGc-g@mail.gmail.com>
 <871qte8wy3.fsf@email.froward.int.ebiederm.org> <CAHC9VhSU_sqMQwdoh0nAFdURqs_cVFbva8=otjcZUo8s+xyC9A@mail.gmail.com>
 <8735du7fnp.fsf@email.froward.int.ebiederm.org> <CAHC9VhQuRNxzgVeNhDy=p5+RHz5+bTH6zFdU=UvvEhyH1e962A@mail.gmail.com>
 <87tu6a4l83.fsf@email.froward.int.ebiederm.org> <20220818140521.GA1000@mail.hallyn.com>
In-Reply-To: <20220818140521.GA1000@mail.hallyn.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 18 Aug 2022 11:11:06 -0400
Message-ID: <CAHC9VhRqBxtV04ARQFPWpMf1aFZo0HP_HiJ+8VpXAT-zXF6UXw@mail.gmail.com>
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
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 10:05 AM Serge E. Hallyn <serge@hallyn.com> wrote:
> On Wed, Aug 17, 2022 at 04:24:28PM -0500, Eric W. Biederman wrote:
> > Paul Moore <paul@paul-moore.com> writes:
> > > On Wed, Aug 17, 2022 at 4:56 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> > >> Paul Moore <paul@paul-moore.com> writes:
> > >> > On Wed, Aug 17, 2022 at 3:58 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> > >> >> Paul Moore <paul@paul-moore.com> writes:
> > >> >>
> > >> >> > At the end of the v4 patchset I suggested merging this into lsm/next
> > >> >> > so it could get a full -rc cycle in linux-next, assuming no issues
> > >> >> > were uncovered during testing
> > >> >>
> > >> >> What in the world can be uncovered in linux-next for code that has no in
> > >> >> tree users.
> > >> >
> > >> > The patchset provides both BPF LSM and SELinux implementations of the
> > >> > hooks along with a BPF LSM test under tools/testing/selftests/bpf/.
> > >> > If no one beats me to it, I plan to work on adding a test to the
> > >> > selinux-testsuite as soon as I'm done dealing with other urgent
> > >> > LSM/SELinux issues (io_uring CMD passthrough, SCTP problems, etc.); I
> > >> > run these tests multiple times a week (multiple times a day sometimes)
> > >> > against the -rcX kernels with the lsm/next, selinux/next, and
> > >> > audit/next branches applied on top.  I know others do similar things.
> > >>
> > >> A layer of hooks that leaves all of the logic to userspace is not an
> > >> in-tree user for purposes of understanding the logic of the code.
> > >
> > > The BPF LSM selftests which are part of this patchset live in-tree.
> > > The SELinux hook implementation is completely in-tree with the
> > > subject/verb/object relationship clearly described by the code itself.
> > > After all, the selinux_userns_create() function consists of only two
> > > lines, one of which is an assignment.  Yes, it is true that the
> > > SELinux policy lives outside the kernel, but that is because there is
> > > no singular SELinux policy for everyone.  From a practical
> > > perspective, the SELinux policy is really just a configuration file
> > > used to setup the kernel at runtime; it is not significantly different
> > > than an iptables script, /etc/sysctl.conf, or any of the other myriad
> > > of configuration files used to configure the kernel during boot.
> >
> > I object to adding the new system configuration knob.
>
> I do strongly sympathize with Eric's points.  It will be very easy, once
> user namespace creation has been further restricted in some distros, to
> say "well see this stuff is silly" and go back to simply requiring root
> to create all containers and namespaces, which is generally quite a bit
> easier anywway.  And then, of course, give everyone root so they can
> start containers.

That's assuming a lot.  Many years have passed since namespaces were
first introduced, and awareness of good security practices has
improved, perhaps not as much as any of us would like, but to say that
distros, system builders, and even users are the same as they were so
many years ago is a bit of a stretch in my opinion.

However, even ignoring that for a moment, do we really want to go to a
place where we dictate how users compose and secure their systems?
Linux "took over the world" because it offered a level of flexibility
that wasn't really possible before, and it has flourished because it
has kept that mentality.  The Linux Kernel can be shoehorned onto most
hardware that you can get your hands on these days, with driver
support for most anything you can think to plug into the system.  Do
you want a single-user environment with no per-user separation?  We
can do that.  Do you want a traditional DAC based system that leans
heavy on ACLs and capabilities?  We can do that.  Do you want a
container host that allows you to carve up the system with a high
degree of granularity thanks to the different namespaces?  We can do
that.  How about a system that leverages the LSM to enforce a least
privilege ideal, even on the most privileged root user?  We can do
that too.  This patchset is about giving distro, system builders, and
users another choice in how they build their system.  We've seen both
in this patchset and in previously failed attempts that there is a
definite want from a user perspective for functionality such as this,
and I think it's time we deliver it in the upstream kernel so they
don't have to keep patching their own systems with out-of-tree
patches.

> Eric and Paul, I wonder, will you - or some people you'd like to represent
> you - be at plumbers in September?  Should there be a BOF session there?  (I
> won't be there, but could join over video)  I think a brainstorming session
> for solutions to the above problems would be good.

Regardless of if Eric or I will be at LPC, it is doubtful that all of
the people who have participated in this discussion will be able to
attend, and I think it's important that the users who are asking for
this patchset have a chance to be heard in each forum where this is
discussed.  While conferences are definitely nice - I definitely
missed them over the past couple of years - we can't use them as a
crutch to help us reach a conclusion on this issue; we've debated much
more difficult things over the mailing lists, I see no reason why this
would be any different.

-- 
paul-moore.com
