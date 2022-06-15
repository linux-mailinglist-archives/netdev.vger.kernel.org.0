Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8880C54CAFE
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 16:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349123AbiFOOO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 10:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242364AbiFOOOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 10:14:53 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1D036312
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 07:14:51 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id o8so15587611wro.3
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 07:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TmFspR35i19OaG7kIq4BfP3Z5+5KHooJY8o+wf2Eu7g=;
        b=hnjS0y0DJB+Pgxck/o6M0KR1CyJPsNohu8wEV1ngzYEvfR3BNgdCgc8bBCjYcSn/q2
         LGrABHBIuN5wiJVr3vFBZSQoyuo+ow5O4zy8y+xuerraxDm52W00Ql6GN8mxJBK7Aged
         DMepzdaFMPS1SBM8wU0DjvHn5zjVaCWGHNtmseACjEovZd9TfrOheGRLWXnnpvnFbk3L
         Oh5JBbb6A+TcxaBr62FlW4W2kMYFlFl4qBPFa5Vljf/kfuiWpPulvsvFhKfMVnlp7H1I
         /Ewf9GWseGoqqzdlh7+S2YPdnfxgjB6XJIAkXpRzobHf9nGOIaKrkjPQFKm48HdjqWaG
         xCzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TmFspR35i19OaG7kIq4BfP3Z5+5KHooJY8o+wf2Eu7g=;
        b=tWZvOJnZC1DR+E1CHxpbRtowWE0KMk/F1LMQJpBKSRZ9vVt7pRJJpqkyuC9VyTiwK1
         ka6wUUbogW6yRCeEx4mTOi4EgXfnnnu9nSCOFhmDsEfSKTN0OcGUX4aYLJ/qeF28tRMC
         D6AY9tZdz36ToXElj2q3soOoQKFxUZ7sUyiERYPBlSZQedIxTELmSIMRYui1EunsSdYn
         ENtldME2rUVl9kEdS4ktOq62vOAUTml3f9VkDiCxQHYWnhmxXb7OaNC/9TkWVIi15M+2
         7ibAWQ1Ju+MgDYsvwHhKhEpNFMcDINxxzo6qIa5YIKmRgtYV1wvzPe4JzJNonQ7BHmAs
         vdMQ==
X-Gm-Message-State: AJIora/TV8yyVrt3HswyLvIScH0hym6Tb1PV7FHU0zKwQJi2FYAmM9+D
        wbHZ4mYT4nB3WgssdI+90Vb3DuXIqSeCNeJ4hMTD
X-Google-Smtp-Source: AGRyM1shZLCqZkkSojukqCXaW+5XT6IN8fQuWUaigb52d2YijY5GHtpeOYg1i3lr6LTItEcWJJFmcKwvqWFcwysL51U=
X-Received: by 2002:a05:6000:1447:b0:21a:278a:181c with SMTP id
 v7-20020a056000144700b0021a278a181cmr27393wrx.161.1655302489487; Wed, 15 Jun
 2022 07:14:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220608150942.776446-1-fred@cloudflare.com> <87tu8oze94.fsf@email.froward.int.ebiederm.org>
 <e1b62234-9b8a-e7c2-2946-5ef9f6f23a08@cloudflare.com> <87y1xzyhub.fsf@email.froward.int.ebiederm.org>
 <859cb593-9e96-5846-2191-6613677b07c5@cloudflare.com> <87o7yvxl4x.fsf@email.froward.int.ebiederm.org>
 <9ed91f15-420c-3db6-8b3b-85438b02bf97@cloudflare.com> <20220615103031.qkzae4xr34wysj4b@wittgenstein>
In-Reply-To: <20220615103031.qkzae4xr34wysj4b@wittgenstein>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 15 Jun 2022 10:14:38 -0400
Message-ID: <CAHC9VhR8yPHZb2sCu4JGgXOSs7rudm=9opB+-LsG6_Lta9466A@mail.gmail.com>
Subject: Re: [PATCH v3] cred: Propagate security_prepare_creds() error code
To:     Christian Brauner <brauner@kernel.org>
Cc:     Frederick Lawler <fred@cloudflare.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, selinux@vger.kernel.org,
        serge@hallyn.com, amir73il@gmail.com, kernel-team@cloudflare.com,
        Jeff Moyer <jmoyer@redhat.com>
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

On Wed, Jun 15, 2022 at 6:30 AM Christian Brauner <brauner@kernel.org> wrote:
>
> On Tue, Jun 14, 2022 at 01:59:08PM -0500, Frederick Lawler wrote:
> > On 6/14/22 11:30 AM, Eric W. Biederman wrote:
> > > Frederick Lawler <fred@cloudflare.com> writes:
> > >
> > > > On 6/13/22 11:44 PM, Eric W. Biederman wrote:
> > > > > Frederick Lawler <fred@cloudflare.com> writes:
> > > > >
> > > > > > Hi Eric,
> > > > > >
> > > > > > On 6/13/22 12:04 PM, Eric W. Biederman wrote:
> > > > > > > Frederick Lawler <fred@cloudflare.com> writes:
> > > > > > >
> > > > > > > > While experimenting with the security_prepare_creds() LSM hook, we
> > > > > > > > noticed that our EPERM error code was not propagated up the callstack.
> > > > > > > > Instead ENOMEM is always returned.  As a result, some tools may send a
> > > > > > > > confusing error message to the user:
> > > > > > > >
> > > > > > > > $ unshare -rU
> > > > > > > > unshare: unshare failed: Cannot allocate memory
> > > > > > > >
> > > > > > > > A user would think that the system didn't have enough memory, when
> > > > > > > > instead the action was denied.
> > > > > > > >
> > > > > > > > This problem occurs because prepare_creds() and prepare_kernel_cred()
> > > > > > > > return NULL when security_prepare_creds() returns an error code. Later,
> > > > > > > > functions calling prepare_creds() and prepare_kernel_cred() return
> > > > > > > > ENOMEM because they assume that a NULL meant there was no memory
> > > > > > > > allocated.
> > > > > > > >
> > > > > > > > Fix this by propagating an error code from security_prepare_creds() up
> > > > > > > > the callstack.
> > > > > > > Why would it make sense for security_prepare_creds to return an error
> > > > > > > code other than ENOMEM?
> > > > > > >    > That seems a bit of a violation of what that function is supposed to do
> > > > > > >
> > > > > >
> > > > > > The API allows LSM authors to decide what error code is returned from the
> > > > > > cred_prepare hook. security_task_alloc() is a similar hook, and has its return
> > > > > > code propagated.
> > > > > It is not an api.  It is an implementation detail of the linux kernel.
> > > > > It is a set of convenient functions that do a job.
> > > > > The general rule is we don't support cases without an in-tree user.  I
> > > > > don't see an in-tree user.
> > > > >
> > > > > > I'm proposing we follow security_task_allocs() pattern, and add visibility for
> > > > > > failure cases in prepare_creds().
> > > > > I am asking why we would want to.  Especially as it is not an API, and I
> > > > > don't see any good reason for anything but an -ENOMEM failure to be
> > > > > supported.
> > > > >
> > > > We're writing a LSM BPF policy, and not a new LSM. Our policy aims to solve
> > > > unprivileged unshare, similar to Debian's patch [1]. We're in a position such
> > > > that we can't use that patch because we can't block _all_ of our applications
> > > > from performing an unshare. We prefer a granular approach. LSM BPF seems like a
> > > > good choice.
> > >
> > > I am quite puzzled why doesn't /proc/sys/user/max_user_namespaces work
> > > for you?
> > >
> >
> > We have the following requirements:
> >
> > 1. Allow list criteria
> > 2. root user must be able to create namespaces whenever
> > 3. Everything else not in 1 & 2 must be denied
> >
> > We use per task attributes to determine whether or not we allow/deny the
> > current call to unshare().
> >
> > /proc/sys/user/max_user_namespaces limits are a bit broad for this level of
> > detail.
> >
> > > > Because LSM BPF exposes these hooks, we should probably treat them as an
> > > > API. From that perspective, userspace expects unshare to return a EPERM
> > > > when the call is denied permissions.
> > >
> > > The BPF code gets to be treated as a out of tree kernel module.
> > >
> > > > > Without an in-tree user that cares it is probably better to go the
> > > > > opposite direction and remove the possibility of return anything but
> > > > > memory allocation failure.  That will make it clearer to implementors
> > > > > that a general error code is not supported and this is not a location
> > > > > to implement policy, this is only a hook to allocate state for the LSM.
> > > > >
> > > >
> > > > That's a good point, and it's possible we're using the wrong hook for the
> > > > policy. Do you know of other hooks we can look into?
>
> Fwiw, from this commit it wasn't very clear what you wanted to achieve
> with this. It might be worth considering adding a new security hook for
> this. Within msft it recently came up SELinux might have an interest in
> something like this as well.

Just to clarify things a bit, I believe SELinux would have an interest
in a LSM hook capable of implementing an access control point for user
namespaces regardless of Microsoft's current needs.  I suspect due to
the security relevant nature of user namespaces most other LSMs would
be interested as well; it seems like a well crafted hook would be
welcome by most folks I think.

-- 
paul-moore.com
