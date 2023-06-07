Return-Path: <netdev+bounces-8692-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DFD057253A5
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 07:47:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 309911C20C67
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 05:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E107E10FC;
	Wed,  7 Jun 2023 05:46:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07A510F7
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 05:46:59 +0000 (UTC)
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A2D19B9
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 22:46:55 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id 5614622812f47-39c4c3da9cbso785020b6e.2
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 22:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1686116815; x=1688708815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GyERF0RS7JY1jKOtadu+WV5iG7DwiHrgJtcnyQtVxBs=;
        b=GlOMRdsW7+vgAflLBokBqQInqf2YvCY16X9F7c0oI8vzt5RrnAH0JABHIBuBY1W1eM
         uO8Gz5eaHaY73kqV41aFZc7ygwYaAPKAUYPtbxB/gIv3p/rF0qCAe/jT/CsRsq0pDJt6
         oy2OnS0/M3yFeSnWibgScbxQoNEsTapqvob48=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686116815; x=1688708815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GyERF0RS7JY1jKOtadu+WV5iG7DwiHrgJtcnyQtVxBs=;
        b=V/TvcWk/84DmaY4ZO6A1wOSU7QXfpfgTZkEamskwEIrs2aQyiiRBcF3nldTdo9dWnM
         rzE5oor4Hl+/hTGojhYtbcXMta+gIx191XwkMNrDcGF8+jkv0Y1Nu3fxFSjhqg3GqE+r
         ztspdzm4+sGB7gc/QNlMAxOh7UfOH4dDlA3V986PdXh5MHu4NLXleoK53iU9a8agHlfD
         1KKjTCuEolKUZBUcxAfH0v7xucgGY0qkpjAINzhLt1ZUedM5jHqpbipRQw9+V2eivY1j
         W//HfrFiNZrXjFIMiK0nJGB2x4E6xmVXuXHy9Eyb3EboUFCQ6oz6pRsbfbNFnSolMPG8
         xVug==
X-Gm-Message-State: AC+VfDxW1jswJ7bMneWoXSRY8Mf546Q3YkEhLzZpJTanRReMjhIyYT1I
	tCj/soP4OMa5UyAMSnGtiLcZmh2Iz2ptJ7Lk7n0J+w==
X-Google-Smtp-Source: ACHHUZ5zS5dgpa7YaYuHV2jJugHaYJIOv9d28BunL9wYs4BNz5uH8Cp/8zFK5xbtcki3Nii4xLGr3KpAncBsV1F6M2Y=
X-Received: by 2002:a05:6808:4287:b0:397:ec35:f5a6 with SMTP id
 dq7-20020a056808428700b00397ec35f5a6mr2109539oib.57.1686116814839; Tue, 06
 Jun 2023 22:46:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-13-konstantin.meskhidze@huawei.com> <ZH89Pi1QAqNW2QgG@google.com>
In-Reply-To: <ZH89Pi1QAqNW2QgG@google.com>
From: Jeff Xu <jeffxu@chromium.org>
Date: Tue, 6 Jun 2023 22:46:43 -0700
Message-ID: <CABi2SkWqHeLkmqONbmavcp2SCiwe6YeH_3dkBLZwSsk7neyPMw@mail.gmail.com>
Subject: Re: [PATCH v11 12/12] landlock: Document Landlock's network support
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
Cc: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>, mic@digikod.net, 
	willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023 at 7:09=E2=80=AFAM G=C3=BCnther Noack <gnoack@google.co=
m> wrote:
>
> On Tue, May 16, 2023 at 12:13:39AM +0800, Konstantin Meskhidze wrote:
> > Describe network access rules for TCP sockets. Add network access
> > example in the tutorial. Add kernel configuration support for network.
> >
> > Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> > ---
> >
> > Changes since v10:
> > * Fixes documentaion as Micka=D1=91l suggested:
> > https://lore.kernel.org/linux-security-module/ec23be77-566e-c8fd-179e-f=
50e025ac2cf@digikod.net/
> >
> > Changes since v9:
> > * Minor refactoring.
> >
> > Changes since v8:
> > * Minor refactoring.
> >
> > Changes since v7:
> > * Fixes documentaion logic errors and typos as Micka=D1=91l suggested:
> > https://lore.kernel.org/netdev/9f354862-2bc3-39ea-92fd-53803d9bbc21@dig=
ikod.net/
> >
> > Changes since v6:
> > * Adds network support documentaion.
> >
> > ---
> >  Documentation/userspace-api/landlock.rst | 83 ++++++++++++++++++------
> >  1 file changed, 62 insertions(+), 21 deletions(-)
> >
> > diff --git a/Documentation/userspace-api/landlock.rst b/Documentation/u=
serspace-api/landlock.rst
> > index f6a7da21708a..f185dbaa726a 100644
> > --- a/Documentation/userspace-api/landlock.rst
> > +++ b/Documentation/userspace-api/landlock.rst
> > @@ -11,10 +11,10 @@ Landlock: unprivileged access control
> >  :Date: October 2022
> >
> >  The goal of Landlock is to enable to restrict ambient rights (e.g. glo=
bal
> > -filesystem access) for a set of processes.  Because Landlock is a stac=
kable
> > -LSM, it makes possible to create safe security sandboxes as new securi=
ty layers
> > -in addition to the existing system-wide access-controls. This kind of =
sandbox
> > -is expected to help mitigate the security impact of bugs or
> > +filesystem or network access) for a set of processes.  Because Landloc=
k
> > +is a stackable LSM, it makes possible to create safe security sandboxe=
s as new
> > +security layers in addition to the existing system-wide access-control=
s. This
> > +kind of sandbox is expected to help mitigate the security impact of bu=
gs or
> >  unexpected/malicious behaviors in user space applications.  Landlock e=
mpowers
> >  any process, including unprivileged ones, to securely restrict themsel=
ves.
> >
> > @@ -28,20 +28,24 @@ appropriately <kernel_support>`.
> >  Landlock rules
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > -A Landlock rule describes an action on an object.  An object is curren=
tly a
> > -file hierarchy, and the related filesystem actions are defined with `a=
ccess
> > -rights`_.  A set of rules is aggregated in a ruleset, which can then r=
estrict
> > -the thread enforcing it, and its future children.
> > +A Landlock rule describes an action on a kernel object.  Filesystem
> > +objects can be defined with a file hierarchy.  Since the fourth ABI
> > +version, TCP ports enable to identify inbound or outbound connections.
> > +Actions on these kernel objects are defined according to `access
> > +rights`_.  A set of rules is aggregated in a ruleset, which
> > +can then restrict the thread enforcing it, and its future children.
>
> I feel that this paragraph is a bit long-winded to read when the
> additional networking aspect is added on top as well.  Maybe it would
> be clearer if we spelled it out in a more structured way, splitting up
> the filesystem/networking aspects?
>
> Suggestion:
>
>   A Landlock rule describes an action on an object which the process
>   intends to perform.  A set of rules is aggregated in a ruleset,
>   which can then restrict the thread enforcing it, and its future
>   children.
>
>   The two existing types of rules are:
>
>   Filesystem rules
>       For these rules, the object is a file hierarchy,
>       and the related filesystem actions are defined with
>       `filesystem access rights`.
>
>   Network rules (since ABI v4)
>       For these rules, the object is currently a TCP port,
Remote port or local port ?


>       and the related actions are defined with `network access rights`.
>
> Please note that the landlock(7) man page is in large parts using the
> same phrasing as the kernel documentation.  It might be a good idea to
> keep them in sync and structured similarly.  (On that mailing list,
> the reviews are a bit more focused on good writing style.)
>
> The same reasoning applies to the example below as well.  Explaining
> multiple aspects of a thing in a single example can muddy the message,
> let's try to avoid that.  But I can also see that if we had two
> separate examples, a large part of the example would be duplicated.
>
> >  Defining and enforcing a security policy
> >  ----------------------------------------
> >
> >  We first need to define the ruleset that will contain our rules.  For =
this
> > -example, the ruleset will contain rules that only allow read actions, =
but write
> > -actions will be denied.  The ruleset then needs to handle both of thes=
e kind of
> > -actions.  This is required for backward and forward compatibility (i.e=
. the
> > -kernel and user space may not know each other's supported restrictions=
), hence
> > -the need to be explicit about the denied-by-default access rights.
> > +example, the ruleset will contain rules that only allow filesystem rea=
d actions
> > +and establish a specific TCP connection, but filesystem write actions
> > +and other TCP actions will be denied.  The ruleset then needs to handl=
e both of
> > +these kind of actions.  This is required for backward and forward comp=
atibility
> > +(i.e. the kernel and user space may not know each other's supported
> > +restrictions), hence the need to be explicit about the denied-by-defau=
lt access
> > +rights.
>
> I think it became a bit long - I'd suggest to split it into multiple
> paragraphs, one after "our rules." (in line with landlock(7)), and one
> after "will be denied."
>
> Maybe the long sentence "For this example, ..." in the middle
> paragraph could also be split up in two, to make it more readable?  I
> think the point of that sentence is really just to give a brief
> overview over what ruleset we are setting out to write.
>
> >
> >  .. code-block:: c
> >
> > @@ -62,6 +66,9 @@ the need to be explicit about the denied-by-default a=
ccess rights.
> >              LANDLOCK_ACCESS_FS_MAKE_SYM |
> >              LANDLOCK_ACCESS_FS_REFER |
> >              LANDLOCK_ACCESS_FS_TRUNCATE,
> > +        .handled_access_net =3D
> > +            LANDLOCK_ACCESS_NET_BIND_TCP |
> > +            LANDLOCK_ACCESS_NET_CONNECT_TCP,
> >      };
> >
> >  Because we may not know on which kernel version an application will be
> > @@ -70,14 +77,18 @@ should try to protect users as much as possible wha=
tever the kernel they are
> >  using.  To avoid binary enforcement (i.e. either all security features=
 or
> >  none), we can leverage a dedicated Landlock command to get the current=
 version
> >  of the Landlock ABI and adapt the handled accesses.  Let's check if we=
 should
> > -remove the ``LANDLOCK_ACCESS_FS_REFER`` or ``LANDLOCK_ACCESS_FS_TRUNCA=
TE``
> > -access rights, which are only supported starting with the second and t=
hird
> > -version of the ABI.
> > +remove the ``LANDLOCK_ACCESS_FS_REFER`` or ``LANDLOCK_ACCESS_FS_TRUNCA=
TE`` or
> > +network access rights, which are only supported starting with the seco=
nd,
> > +third and fourth version of the ABI.
>
> At some point it becomes too much to spell it out in one sentence; I'd re=
commend
>
>   Let's check if we should remove access rights which are only supported
>   in higher versions of the ABI.
>
> >
> >  .. code-block:: c
> >
> >      int abi;
> >
> > +    #define ACCESS_NET_BIND_CONNECT ( \
> > +        LANDLOCK_ACCESS_NET_BIND_TCP | \
> > +        LANDLOCK_ACCESS_NET_CONNECT_TCP)
> > +
>
> This #define does not seem to be used? -- Drop it?
>
>
> >      abi =3D landlock_create_ruleset(NULL, 0, LANDLOCK_CREATE_RULESET_V=
ERSION);
> >      if (abi < 0) {
> >          /* Degrades gracefully if Landlock is not handled. */
> > @@ -92,6 +103,11 @@ version of the ABI.
> >      case 2:
> >          /* Removes LANDLOCK_ACCESS_FS_TRUNCATE for ABI < 3 */
> >          ruleset_attr.handled_access_fs &=3D ~LANDLOCK_ACCESS_FS_TRUNCA=
TE;
> > +    case 3:
> > +        /* Removes network support for ABI < 4 */
> > +        ruleset_attr.handled_access_net &=3D
> > +            ~(LANDLOCK_ACCESS_NET_BIND_TCP |
> > +              LANDLOCK_ACCESS_NET_CONNECT_TCP);
> >      }
> >
> >  This enables to create an inclusive ruleset that will contain our rule=
s.
> > @@ -143,10 +159,23 @@ for the ruleset creation, by filtering access rig=
hts according to the Landlock
> >  ABI version.  In this example, this is not required because all of the=
 requested
> >  ``allowed_access`` rights are already available in ABI 1.
> >
> > -We now have a ruleset with one rule allowing read access to ``/usr`` w=
hile
> > -denying all other handled accesses for the filesystem.  The next step =
is to
> > -restrict the current thread from gaining more privileges (e.g. thanks =
to a SUID
> > -binary).
> > +For network access-control, we can add a set of rules that allow to us=
e a port
> > +number for a specific action: HTTPS connections.
> > +
> > +.. code-block:: c
> > +
> > +    struct landlock_net_service_attr net_service =3D {
> > +        .allowed_access =3D NET_CONNECT_TCP,
> > +        .port =3D 443,
> > +    };
> > +
> > +    err =3D landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> > +                            &net_service, 0);
> > +
> > +The next step is to restrict the current thread from gaining more priv=
ileges
> > +(e.g. through a SUID binary). We now have a ruleset with the first rul=
e allowing
> > +read access to ``/usr`` while denying all other handled accesses for t=
he filesystem,
> > +and a second rule allowing HTTPS connections.
> >
> >  .. code-block:: c
> >
> > @@ -355,7 +384,7 @@ Access rights
> >  -------------
> >
> >  .. kernel-doc:: include/uapi/linux/landlock.h
> > -    :identifiers: fs_access
> > +    :identifiers: fs_access net_access
> >
> >  Creating a new ruleset
> >  ----------------------
> > @@ -374,6 +403,7 @@ Extending a ruleset
> >
> >  .. kernel-doc:: include/uapi/linux/landlock.h
> >      :identifiers: landlock_rule_type landlock_path_beneath_attr
> > +                  landlock_net_service_attr
> >
> >  Enforcing a ruleset
> >  -------------------
> > @@ -451,6 +481,12 @@ always allowed when using a kernel that only suppo=
rts the first or second ABI.
> >  Starting with the Landlock ABI version 3, it is now possible to secure=
ly control
> >  truncation thanks to the new ``LANDLOCK_ACCESS_FS_TRUNCATE`` access ri=
ght.
> >
> > +Network support (ABI < 4)
> > +-------------------------
> > +
> > +Starting with the Landlock ABI version 4, it is now possible to restri=
ct TCP
> > +bind and connect actions to only a set of allowed ports.
> > +
> >  .. _kernel_support:
> >
> >  Kernel support
> > @@ -469,6 +505,11 @@ still enable it by adding ``lsm=3Dlandlock,[...]``=
 to
> >  Documentation/admin-guide/kernel-parameters.rst thanks to the bootload=
er
> >  configuration.
> >
> > +To be able to explicitly allow TCP operations (e.g., adding a network =
rule with
> > +``LANDLOCK_ACCESS_NET_TCP_BIND``), the kernel must support TCP (``CONF=
IG_INET=3Dy``).
> > +Otherwise, sys_landlock_add_rule() returns an ``EAFNOSUPPORT`` error, =
which can
> > +safely be ignored because this kind of TCP operation is already not po=
ssible.
> > +
> >  Questions and answers
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > --
> > 2.25.1
> >
>
> =E2=80=94G=C3=BCnther
>
> --
> Sent using Mutt =F0=9F=90=95 Woof Woof

