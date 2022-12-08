Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3C9647906
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 23:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiLHWqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 17:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiLHWqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 17:46:10 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FC88F701
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 14:46:01 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 130so2412418pfu.8
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 14:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GXy3yVe6q44PfcggGGGUoLM0qgF3oqADIjhfyUy/5w8=;
        b=m0U0ZyFNHfG7+MToeaYyNjB7X1PggzXeEpqu2rb1ZJ7cTBviwA7gIG9Tyg572P8M1b
         aKoxD95GRuURnVVDMmNXtach1deUW3CYeOF5HiN+hYwwM+xShJ0zYF+iP0iEFmn/cHM2
         lEauTXA0ZpM1jcwn45Hth/b30ZBTjfcRMzgHJkIvt3Pl08Id5JbUY7+Vupwn4p0vOjJE
         1E6B+2w13xlykPVmmMf+fKKASvtjbBEG8Tui51K4xAhWtHIyua0fwLbOPhtad3sc6YB0
         wnq14MofX2PUUUiAPae/85s/LGMAQZtc8xd1yTvA1WF4lH5xFjw8y2ZZoxfgpGRWjQOd
         6QNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GXy3yVe6q44PfcggGGGUoLM0qgF3oqADIjhfyUy/5w8=;
        b=KkoV3v5QlAOteMxPYMYHmNt83pfCorELwnxe3W73D7vKtz++ilqyBX8uYbtV7y77ej
         aWuFUOx/uhtFfzEGEx4iBqXcNvQ4Kz7ktN89HcdbERch2qplYsBPX/wjijH0Ate2ofwl
         aUTRPO3iEuv9sfjzCnAZwD1DfS7+cWKfsVLOkk8avzRw3CWaj/iM0kGk2xhlG141rsUg
         uKtmJgaEK8RcFp3s55dFbTTUCLe9rZpohniotxBA3jci6qThjw/3aN1iqDbfCHs1Gtq4
         JbxhsRita91Xy0qBDGF9Rve7g8SokryWJ0T4LSAh5Gnak4Scexp0Yss01wZi41PYOK1o
         /N9g==
X-Gm-Message-State: ANoB5pmfb1DmVRyKZsPv4J6NWE4jChd3a3ZPfa/P5KQW0AMfVs8JiiEX
        Pg6r54s2eztJBghM25FAX92d/5tE/pPcRDMQeo8j
X-Google-Smtp-Source: AA0mqf6bVEu+zdRUSkuWOcp4cIkScjpUe3duREc67t/ScI57nnNA5ajNFIWKMsygOUVvxfoMtTAQsEEbtmvq9CmQ8oU=
X-Received: by 2002:a63:e74a:0:b0:478:42f:5a3d with SMTP id
 j10-20020a63e74a000000b00478042f5a3dmr48968019pgk.3.1670539560762; Thu, 08
 Dec 2022 14:46:00 -0800 (PST)
MIME-Version: 1.0
References: <CAFqZXNs2LF-OoQBUiiSEyranJUXkPLcCfBkMkwFeM6qEwMKCTw@mail.gmail.com>
 <108a1c80eed41516f85ebb264d0f46f95e86f754.camel@redhat.com>
 <CAHC9VhSSKN5kh9Kqgj=aCeA92bX1mJm1v4_PnRgua86OHUwE3w@mail.gmail.com>
 <48dd1e9b21597c46e4767290e5892c01850a45ff.camel@redhat.com>
 <CAHC9VhT0rRhr7Ty_p3Ld5O+Ltf8a8XSXcyik7tFpDRMrTfsF+A@mail.gmail.com>
 <50e7ea22119c3afcb4be5a4b6ad9747465693d10.camel@redhat.com> <CAFqZXNtOku4vr5RrQU4vcvCVz5iK79CimeUVHu0S=QoN-QVEjg@mail.gmail.com>
In-Reply-To: <CAFqZXNtOku4vr5RrQU4vcvCVz5iK79CimeUVHu0S=QoN-QVEjg@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 8 Dec 2022 17:45:49 -0500
Message-ID: <CAHC9VhSQnhH3UL4gqzu+YiA1Q3YyLLCv88gLJOvw-0+uw5Lvkw@mail.gmail.com>
Subject: Re: Broken SELinux/LSM labeling with MPTCP and accept(2)
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        SElinux list <selinux@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>, mptcp@lists.linux.dev,
        network dev <netdev@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 6, 2022 at 9:43 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> On Mon, Dec 5, 2022 at 9:58 PM Paolo Abeni <pabeni@redhat.com> wrote:
> >
> > On Fri, 2022-12-02 at 15:16 -0500, Paul Moore wrote:
> [...]
> > > What if we added a new LSM call in mptcp_subflow_create_socket(), just
> > > after the sock_create_kern() call?
> >
> > That should work, I think. I would like to propose a (last) attempt
> > that will not need an additional selinux hook - to try to minimize the
> > required changes and avoid unnecessary addional work for current and
> > future LSM mainteniance and creation.
> >
> > I tested the following patch and passes the reproducer (and mptcp self-
> > tests). Basically it introduces and uses a sock_create_nosec variant,
> > to allow mptcp_subflow_create_socket() calling
> > security_socket_post_create() with the corrct arguments. WDYT?

I'm still working my way through the recent patch posted by Paolo
(sorry, I lost some time due to build failures and other discussions),
but I wanted to comment on a few things in Ondrej's email ...

> This seems like a step in the right direction, but I wonder if we
> shouldn't solve the current overloading of the "kern" flag more
> explicitly - i.e. split it into two flags: one to indicate that the
> socket will only be used internally by the kernel ("internal") and
> another one to indicate if it should be labeled according to the
> current task or as a kernel-created socket ("kern"?).

The problem here is that labeling behavior isn't always going to be
the same across LSMs, or rather I don't want to force a specific
labeling behavior at the LSM layer.  We pass the @kern flag to
indicate a kernel socket that is not visible to userspace, but we
leave it up to the individual LSMs to handle that as they see fit
(including if they should label sockets based on @current, an
associated socket, or something else).

> Another concern I have about this approach is whether it is possible
> (in some more advanced scenario) for mptcp_subflow_create_socket() to
> be called in the context of a different task than the one
> creating/handling the main socket. Because then a potential socket
> accepted from the new subflow socket would end up with an unexpected
> (and probably semantically wrong) label. Glancing over the call tree,
> it seems it can be called via some netlink commands - presumably
> intended to be used by mptcpd?

Yes, this is something we need to be careful about, if we want to
treat all of these subflows just as we would treat the main socket,
the subflows need to be labeled the same as the main socket,
regardless of the process which creates them.

As a FYI to the non-SELinux folks, a socket's label can be important
even when it is not visible to userspace as the label is used both to
set the on-the-wire label (CIPSO, CALIPSO, labeled IPsec) and in the
per-packet access controls (see security_sock_rcv_skb()).

-- 
paul-moore.com
