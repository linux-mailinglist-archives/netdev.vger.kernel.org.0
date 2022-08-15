Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07B6593222
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbiHOPlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbiHOPlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:41:06 -0400
Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2862711;
        Mon, 15 Aug 2022 08:41:04 -0700 (PDT)
Received: by mail.hallyn.com (Postfix, from userid 1001)
        id 7BEB177A; Mon, 15 Aug 2022 10:41:02 -0500 (CDT)
Date:   Mon, 15 Aug 2022 10:41:02 -0500
From:   "Serge E. Hallyn" <serge@hallyn.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
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
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com
Subject: Re: [PATCH v4 0/4] Introduce security_create_user_ns()
Message-ID: <20220815154102.GA20944@mail.hallyn.com>
References: <20220801180146.1157914-1-fred@cloudflare.com>
 <87les7cq03.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhRpUxyxkPaTz1scGeRm+i4KviQQA7WismOX2q5agzC+DQ@mail.gmail.com>
 <87wnbia7jh.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhS3udhEecVYVvHm=tuqiPGh034-xPqXYtFjBk23+p-Szg@mail.gmail.com>
 <20220814155508.GA7991@mail.hallyn.com>
 <CAHC9VhRSCXCM51xpOT95G_WVi=UQ44gNV=uvvG23p8wn16uYSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRSCXCM51xpOT95G_WVi=UQ44gNV=uvvG23p8wn16uYSA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 14, 2022 at 10:32:51PM -0400, Paul Moore wrote:
> On Sun, Aug 14, 2022 at 11:55 AM Serge E. Hallyn <serge@hallyn.com> wrote:
> > On Mon, Aug 08, 2022 at 03:16:16PM -0400, Paul Moore wrote:
> > > On Mon, Aug 8, 2022 at 2:56 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> > > > Paul Moore <paul@paul-moore.com> writes:
> > > > > On Mon, Aug 1, 2022 at 10:56 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> > > > >> Frederick Lawler <fred@cloudflare.com> writes:
> > > > >>
> > > > >> > While creating a LSM BPF MAC policy to block user namespace creation, we
> > > > >> > used the LSM cred_prepare hook because that is the closest hook to prevent
> > > > >> > a call to create_user_ns().
> > > > >>
> > > > >> Re-nack for all of the same reasons.
> > > > >> AKA This can only break the users of the user namespace.
> > > > >>
> > > > >> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > > > >>
> > > > >> You aren't fixing what your problem you are papering over it by denying
> > > > >> access to the user namespace.
> > > > >>
> > > > >> Nack Nack Nack.
> > > > >>
> > > > >> Stop.
> > > > >>
> > > > >> Go back to the drawing board.
> > > > >>
> > > > >> Do not pass go.
> > > > >>
> > > > >> Do not collect $200.
> > > > >
> > > > > If you want us to take your comments seriously Eric, you need to
> > > > > provide the list with some constructive feedback that would allow
> > > > > Frederick to move forward with a solution to the use case that has
> > > > > been proposed.  You response above may be many things, but it is
> > > > > certainly not that.
> > > >
> > > > I did provide constructive feedback.  My feedback to his problem
> > > > was to address the real problem of bugs in the kernel.
> > >
> > > We've heard from several people who have use cases which require
> > > adding LSM-level access controls and observability to user namespace
> > > creation.  This is the problem we are trying to solve here; if you do
> > > not like the approach proposed in this patchset please suggest another
> > > implementation that allows LSMs visibility into user namespace
> > > creation.
> >
> > Regarding the observability - can someone concisely lay out why just
> > auditing userns creation would not suffice?  Userspace could decide
> > what to report based on whether the creating user_ns == /proc/1/ns/user...
> 
> One of the selling points of the BPF LSM is that it allows for various
> different ways of reporting and logging beyond audit.  However, even
> if it was limited to just audit I believe that provides some useful
> justification as auditing fork()/clone() isn't quite the same and
> could be difficult to do at scale in some configurations.  I haven't
> personally added a BPF LSM program to the kernel so I can't speak to
> the details on what is possible, but I'm sure others on the To/CC line
> could help provide more information if that is important to you.
> 
> > Regarding limiting the tweaking of otherwise-privileged code by
> > unprivileged users, i wonder whether we could instead add smarts to
> > ns_capable().
> 
> The existing security_capable() hook is eventually called by ns_capable():
> 
>   ns_capable()
>     ns_capable_common()
>       security_capable(const struct cred *cred,
>                        struct user_namespace *ns,
>                        int cap,
>                        unsigned int opts);
> 
> ... I'm not sure what additional smarts would be useful here?

Oh - i wasn't necessarily thinking of an LSM.  I was picturing a
sysctl next to unprivileged_userns_clone.  But you're right, looks
like an LSM could already do this.  Of course, there's an issue early
on in that the root user in the new namespace couldn't setuid, so
the uid mapping is still limited.  So this idea probably isn't worth
the characters we've typed about it so far, sorry.

> [side note: SELinux does actually distinguish between capability
> checks in the initial user namespace vs child namespaces]
> 
> > Point being, uid mapping would still work, but we'd
> > break the "privileged against resources you own" part of user
> > namespaces.  I would want it to default to allow, but then when a
> > 0-day is found which requires reaching ns_capable() code, admins
> > could easily prevent exploitation until reboot from a fixed kernel.
> 
> That assumes that everything you care about is behind a capability
> check, which is probably going to be correct in a lot of the cases,
> but I think it would be a mistake to assume that is always going to be
> true.

I might be thinking wrongly, but if it's not behind a capability check,
then it seems to me it's not an exploit that can only be reached by
becoming root in a user namespace, which means disabling user namespace
creation by unprivileged users will not stop the attack.
