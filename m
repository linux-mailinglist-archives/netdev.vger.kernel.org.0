Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5F754CC2A
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 17:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346059AbiFOPGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 11:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242181AbiFOPGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 11:06:19 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9593A197
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 08:06:18 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id s1so9007265ilj.0
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 08:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j6yW8cSNxyHcKGLBH/RzzZpKDGH+HEQvUp5OHLJ1vSg=;
        b=nHFIWSpabtnN+Um1pljyrhwwDAfJjxUkuJ6rvWuwYZgQx3aHiUVOzZBoQ315+IY0IK
         y9sYTVz0n6GHUXTI1hng+qIVv9i00u8NOVnfVbThgFFOBxMJPVRnOoLGZMJaolcOFg0W
         l4S0cC3C+ob82bPzHmurYZcuzY3FwqJYYvn3E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j6yW8cSNxyHcKGLBH/RzzZpKDGH+HEQvUp5OHLJ1vSg=;
        b=pHuRwhtSIJ9kUz+FX+gEm8FIf3PM0S6Yo+Rs1jYlUl22xieEbIKHE0ncz8Cc6GagFe
         yQKGZYibI49W3ecAfFyQ6Q/hVYvBtCVFYnhNA2ltQ5RIikkP6fO0A6ilDkPp8E9bVL/A
         ox1uI4IVaPcEavsKJUeYT1lhoQC40NeZNZXQZomtxCZsttperEQGUxzmrS7zncTbDRZn
         e3RRMnjpanuftqDBrY/Q0Xq7hxGpy0t3oFUzg1lnpWvznO1gF9OOm7JacfTvSjFPDruz
         zJS6M0QgsP5GqGS538ljndNArBW9zZUZwCp4BOXQCRQlPMapUaeiEKgTDL/w/f+cpXod
         G9vg==
X-Gm-Message-State: AJIora9Fv8yh9NyZObGJlN2V09bisx1LCOrEE6c3rHILk4/H2+qU9nQC
        V0fvyoA31CUB36pr5q+S0Uh/2HmZAPUAFOuF2FJZRg==
X-Google-Smtp-Source: AGRyM1vl6hb3B14OhbZ5pyrW5E0uvZJEWyTkyieVnvYbDV9l4KSiSfWp3W3NzE6bbMlKOpxyW1c3ccvo1VZk+jYZkps=
X-Received: by 2002:a05:6e02:1747:b0:2d3:e571:5058 with SMTP id
 y7-20020a056e02174700b002d3e5715058mr142461ill.309.1655305577283; Wed, 15 Jun
 2022 08:06:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220608150942.776446-1-fred@cloudflare.com> <87tu8oze94.fsf@email.froward.int.ebiederm.org>
 <e1b62234-9b8a-e7c2-2946-5ef9f6f23a08@cloudflare.com> <87y1xzyhub.fsf@email.froward.int.ebiederm.org>
 <859cb593-9e96-5846-2191-6613677b07c5@cloudflare.com> <87o7yvxl4x.fsf@email.froward.int.ebiederm.org>
 <9ed91f15-420c-3db6-8b3b-85438b02bf97@cloudflare.com> <20220615103031.qkzae4xr34wysj4b@wittgenstein>
 <CAHC9VhR8yPHZb2sCu4JGgXOSs7rudm=9opB+-LsG6_Lta9466A@mail.gmail.com>
In-Reply-To: <CAHC9VhR8yPHZb2sCu4JGgXOSs7rudm=9opB+-LsG6_Lta9466A@mail.gmail.com>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Wed, 15 Jun 2022 16:06:06 +0100
Message-ID: <CALrw=nGZtrNYn+CV+Q_w-2=Va_9m3C8PDvvPtd01d0tS=2NMWQ@mail.gmail.com>
Subject: Re: [PATCH v3] cred: Propagate security_prepare_creds() error code
To:     Paul Moore <paul@paul-moore.com>,
        Christian Brauner <brauner@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Frederick Lawler <fred@cloudflare.com>, linux-doc@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-mm@kvack.org, linux-nfs@vger.kernel.org,
        linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, keyrings@vger.kernel.org,
        selinux@vger.kernel.org, serge@hallyn.com, amir73il@gmail.com,
        kernel-team <kernel-team@cloudflare.com>,
        Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 3:14 PM Paul Moore <paul@paul-moore.com> wrote:
>
> On Wed, Jun 15, 2022 at 6:30 AM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Tue, Jun 14, 2022 at 01:59:08PM -0500, Frederick Lawler wrote:
> > > On 6/14/22 11:30 AM, Eric W. Biederman wrote:
> > > > Frederick Lawler <fred@cloudflare.com> writes:
> > > >
> > > > > On 6/13/22 11:44 PM, Eric W. Biederman wrote:
> > > > > > Frederick Lawler <fred@cloudflare.com> writes:
> > > > > >
> > > > > > > Hi Eric,
> > > > > > >
> > > > > > > On 6/13/22 12:04 PM, Eric W. Biederman wrote:
> > > > > > > > Frederick Lawler <fred@cloudflare.com> writes:
> > > > > > > >
> > > > > > > > > While experimenting with the security_prepare_creds() LSM hook, we
> > > > > > > > > noticed that our EPERM error code was not propagated up the callstack.
> > > > > > > > > Instead ENOMEM is always returned.  As a result, some tools may send a
> > > > > > > > > confusing error message to the user:
> > > > > > > > >
> > > > > > > > > $ unshare -rU
> > > > > > > > > unshare: unshare failed: Cannot allocate memory
> > > > > > > > >
> > > > > > > > > A user would think that the system didn't have enough memory, when
> > > > > > > > > instead the action was denied.
> > > > > > > > >
> > > > > > > > > This problem occurs because prepare_creds() and prepare_kernel_cred()
> > > > > > > > > return NULL when security_prepare_creds() returns an error code. Later,
> > > > > > > > > functions calling prepare_creds() and prepare_kernel_cred() return
> > > > > > > > > ENOMEM because they assume that a NULL meant there was no memory
> > > > > > > > > allocated.
> > > > > > > > >
> > > > > > > > > Fix this by propagating an error code from security_prepare_creds() up
> > > > > > > > > the callstack.
> > > > > > > > Why would it make sense for security_prepare_creds to return an error
> > > > > > > > code other than ENOMEM?
> > > > > > > >    > That seems a bit of a violation of what that function is supposed to do
> > > > > > > >
> > > > > > >
> > > > > > > The API allows LSM authors to decide what error code is returned from the
> > > > > > > cred_prepare hook. security_task_alloc() is a similar hook, and has its return
> > > > > > > code propagated.
> > > > > > It is not an api.  It is an implementation detail of the linux kernel.
> > > > > > It is a set of convenient functions that do a job.
> > > > > > The general rule is we don't support cases without an in-tree user.  I
> > > > > > don't see an in-tree user.
> > > > > >
> > > > > > > I'm proposing we follow security_task_allocs() pattern, and add visibility for
> > > > > > > failure cases in prepare_creds().
> > > > > > I am asking why we would want to.  Especially as it is not an API, and I
> > > > > > don't see any good reason for anything but an -ENOMEM failure to be
> > > > > > supported.
> > > > > >
> > > > > We're writing a LSM BPF policy, and not a new LSM. Our policy aims to solve
> > > > > unprivileged unshare, similar to Debian's patch [1]. We're in a position such
> > > > > that we can't use that patch because we can't block _all_ of our applications
> > > > > from performing an unshare. We prefer a granular approach. LSM BPF seems like a
> > > > > good choice.
> > > >
> > > > I am quite puzzled why doesn't /proc/sys/user/max_user_namespaces work
> > > > for you?
> > > >
> > >
> > > We have the following requirements:
> > >
> > > 1. Allow list criteria
> > > 2. root user must be able to create namespaces whenever
> > > 3. Everything else not in 1 & 2 must be denied
> > >
> > > We use per task attributes to determine whether or not we allow/deny the
> > > current call to unshare().
> > >
> > > /proc/sys/user/max_user_namespaces limits are a bit broad for this level of
> > > detail.
> > >
> > > > > Because LSM BPF exposes these hooks, we should probably treat them as an
> > > > > API. From that perspective, userspace expects unshare to return a EPERM
> > > > > when the call is denied permissions.
> > > >
> > > > The BPF code gets to be treated as a out of tree kernel module.
> > > >
> > > > > > Without an in-tree user that cares it is probably better to go the
> > > > > > opposite direction and remove the possibility of return anything but
> > > > > > memory allocation failure.  That will make it clearer to implementors
> > > > > > that a general error code is not supported and this is not a location
> > > > > > to implement policy, this is only a hook to allocate state for the LSM.
> > > > > >
> > > > >
> > > > > That's a good point, and it's possible we're using the wrong hook for the
> > > > > policy. Do you know of other hooks we can look into?
> >
> > Fwiw, from this commit it wasn't very clear what you wanted to achieve
> > with this. It might be worth considering adding a new security hook for
> > this. Within msft it recently came up SELinux might have an interest in
> > something like this as well.
>
> Just to clarify things a bit, I believe SELinux would have an interest
> in a LSM hook capable of implementing an access control point for user
> namespaces regardless of Microsoft's current needs.  I suspect due to
> the security relevant nature of user namespaces most other LSMs would
> be interested as well; it seems like a well crafted hook would be
> welcome by most folks I think.
>
> --
> paul-moore.com

Just to get the full picture: is there actually a good reason not to
make this hook support this scenario? I understand it was not
originally intended for this, but it is well positioned in the code,
covers multiple subsystems (not only user namespaces), doesn't require
changing the LSM interface and it already does the job - just the
kernel internals need to respect the error code better. What bad
things can happen if we extend its use case to not only allocate
resources in LSMs?

After all, the original Linus email introducing Linux stated that
Linux was not intended to be a great OS, but here we are :)

Ignat
