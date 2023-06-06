Return-Path: <netdev+bounces-8502-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC8C0724545
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:08:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58D92281023
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:08:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E5B32DBA9;
	Tue,  6 Jun 2023 14:08:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B58E37B71
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 14:08:22 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E9410D4
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:08:16 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bacd408046cso9183114276.3
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 07:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686060496; x=1688652496;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cnDk93iz3M1gjIcXeyXXi4udqdIoaJFkRLioRs5Zx48=;
        b=nDqxhF6exoEHdHRr/GyMmkYktyxZZ+BB1Wd7pztyPQtSyU0rsq3axfb2UBPBfJ7muI
         nGLJYkiJ9QqYv/Xrh+26tyXqUzxVW5SSxiee3qHWkKwX4oNC0gfgFV3TK4pbqbnKLOam
         Q24kWdogLuB17dIGGVrf35Z6pHRqHvLVWMaVD2HY2z6a3HOKj9gIDOjQcKS5p56rlvDK
         P47V5drU3iM+mMUdZikaPeeY0uIjOipQz69KPskz51SzzsIy5azjrlbYnIqnkFTczBwv
         zADdytE7RX/++mD+O6qyRouMZN1HxLCHtpbFwJbD+ldamcrG/2QLi3kyuZwbcm62yBDi
         infA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686060496; x=1688652496;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cnDk93iz3M1gjIcXeyXXi4udqdIoaJFkRLioRs5Zx48=;
        b=D2KDYMPW+uWOB+KDdfJhRU8eeOglcelaUFJlAmo65serNZpjZyluVbHkIvB0PUqw7r
         zbdi43QLgotMKED44ggK6PD1cmQ9BWaHqIXHTWfQNq6Iq9rd5VurxB/ab+lzUYzJ3ytY
         i9xtRSUaGa6P1/SS8kl+8TSKQwuDQLIRbNUgrugo6q/Bgxgb/myh4LhRvNUaSl18PDjF
         faNvQDn6g7KMgpFB8j0lMnvREMLvukth1yabWMs9IA5DgUlaDo2FIC9R7XgYR4bvTUOV
         /T0lb86ZKhgnRj4BxU/S+FhFAEVwgDb7sOXdtduH7+upaNhNfkwxmaKDo6+QO1XFP9Nu
         SbgQ==
X-Gm-Message-State: AC+VfDxGq/je0+/4plW68K83W57Or+ru4RmF9VgQPQf60mUco46KqndE
	eEZAJtaCQCWzbOLn3D3Qjew83lCyZo8=
X-Google-Smtp-Source: ACHHUZ47xPbdPQ79Dcp6kXQ1BagkYqbJ+2dKTNqDssqrf1y04bXVXggLEPJbeMiGx8sDFLOx7IZWvbX9t28=
X-Received: from sport.zrh.corp.google.com ([2a00:79e0:9d:4:1323:e421:4cdd:eab5])
 (user=gnoack job=sendgmr) by 2002:a05:6902:1106:b0:ba8:457d:1f22 with SMTP id
 o6-20020a056902110600b00ba8457d1f22mr1168299ybu.9.1686060495767; Tue, 06 Jun
 2023 07:08:15 -0700 (PDT)
Date: Tue, 6 Jun 2023 16:08:13 +0200
In-Reply-To: <20230515161339.631577-13-konstantin.meskhidze@huawei.com>
Message-Id: <ZH89Pi1QAqNW2QgG@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com> <20230515161339.631577-13-konstantin.meskhidze@huawei.com>
Subject: Re: [PATCH v11 12/12] landlock: Document Landlock's network support
From: "=?iso-8859-1?Q?G=FCnther?= Noack" <gnoack@google.com>
To: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 12:13:39AM +0800, Konstantin Meskhidze wrote:
> Describe network access rules for TCP sockets. Add network access
> example in the tutorial. Add kernel configuration support for network.
>=20
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
>=20
> Changes since v10:
> * Fixes documentaion as Micka=D1=91l suggested:
> https://lore.kernel.org/linux-security-module/ec23be77-566e-c8fd-179e-f50=
e025ac2cf@digikod.net/
>=20
> Changes since v9:
> * Minor refactoring.
>=20
> Changes since v8:
> * Minor refactoring.
>=20
> Changes since v7:
> * Fixes documentaion logic errors and typos as Micka=D1=91l suggested:
> https://lore.kernel.org/netdev/9f354862-2bc3-39ea-92fd-53803d9bbc21@digik=
od.net/
>=20
> Changes since v6:
> * Adds network support documentaion.
>=20
> ---
>  Documentation/userspace-api/landlock.rst | 83 ++++++++++++++++++------
>  1 file changed, 62 insertions(+), 21 deletions(-)
>=20
> diff --git a/Documentation/userspace-api/landlock.rst b/Documentation/use=
rspace-api/landlock.rst
> index f6a7da21708a..f185dbaa726a 100644
> --- a/Documentation/userspace-api/landlock.rst
> +++ b/Documentation/userspace-api/landlock.rst
> @@ -11,10 +11,10 @@ Landlock: unprivileged access control
>  :Date: October 2022
>=20
>  The goal of Landlock is to enable to restrict ambient rights (e.g. globa=
l
> -filesystem access) for a set of processes.  Because Landlock is a stacka=
ble
> -LSM, it makes possible to create safe security sandboxes as new security=
 layers
> -in addition to the existing system-wide access-controls. This kind of sa=
ndbox
> -is expected to help mitigate the security impact of bugs or
> +filesystem or network access) for a set of processes.  Because Landlock
> +is a stackable LSM, it makes possible to create safe security sandboxes =
as new
> +security layers in addition to the existing system-wide access-controls.=
 This
> +kind of sandbox is expected to help mitigate the security impact of bugs=
 or
>  unexpected/malicious behaviors in user space applications.  Landlock emp=
owers
>  any process, including unprivileged ones, to securely restrict themselve=
s.
>=20
> @@ -28,20 +28,24 @@ appropriately <kernel_support>`.
>  Landlock rules
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> -A Landlock rule describes an action on an object.  An object is currentl=
y a
> -file hierarchy, and the related filesystem actions are defined with `acc=
ess
> -rights`_.  A set of rules is aggregated in a ruleset, which can then res=
trict
> -the thread enforcing it, and its future children.
> +A Landlock rule describes an action on a kernel object.  Filesystem
> +objects can be defined with a file hierarchy.  Since the fourth ABI
> +version, TCP ports enable to identify inbound or outbound connections.
> +Actions on these kernel objects are defined according to `access
> +rights`_.  A set of rules is aggregated in a ruleset, which
> +can then restrict the thread enforcing it, and its future children.

I feel that this paragraph is a bit long-winded to read when the
additional networking aspect is added on top as well.  Maybe it would
be clearer if we spelled it out in a more structured way, splitting up
the filesystem/networking aspects?

Suggestion:

  A Landlock rule describes an action on an object which the process
  intends to perform.  A set of rules is aggregated in a ruleset,
  which can then restrict the thread enforcing it, and its future
  children.

  The two existing types of rules are:

  Filesystem rules
      For these rules, the object is a file hierarchy,
      and the related filesystem actions are defined with
      `filesystem access rights`.

  Network rules (since ABI v4)
      For these rules, the object is currently a TCP port,
      and the related actions are defined with `network access rights`.

Please note that the landlock(7) man page is in large parts using the
same phrasing as the kernel documentation.  It might be a good idea to
keep them in sync and structured similarly.  (On that mailing list,
the reviews are a bit more focused on good writing style.)

The same reasoning applies to the example below as well.  Explaining
multiple aspects of a thing in a single example can muddy the message,
let's try to avoid that.  But I can also see that if we had two
separate examples, a large part of the example would be duplicated.

>  Defining and enforcing a security policy
>  ----------------------------------------
>=20
>  We first need to define the ruleset that will contain our rules.  For th=
is
> -example, the ruleset will contain rules that only allow read actions, bu=
t write
> -actions will be denied.  The ruleset then needs to handle both of these =
kind of
> -actions.  This is required for backward and forward compatibility (i.e. =
the
> -kernel and user space may not know each other's supported restrictions),=
 hence
> -the need to be explicit about the denied-by-default access rights.
> +example, the ruleset will contain rules that only allow filesystem read =
actions
> +and establish a specific TCP connection, but filesystem write actions
> +and other TCP actions will be denied.  The ruleset then needs to handle =
both of
> +these kind of actions.  This is required for backward and forward compat=
ibility
> +(i.e. the kernel and user space may not know each other's supported
> +restrictions), hence the need to be explicit about the denied-by-default=
 access
> +rights.

I think it became a bit long - I'd suggest to split it into multiple
paragraphs, one after "our rules." (in line with landlock(7)), and one
after "will be denied."

Maybe the long sentence "For this example, ..." in the middle
paragraph could also be split up in two, to make it more readable?  I
think the point of that sentence is really just to give a brief
overview over what ruleset we are setting out to write.

>=20
>  .. code-block:: c
>=20
> @@ -62,6 +66,9 @@ the need to be explicit about the denied-by-default acc=
ess rights.
>              LANDLOCK_ACCESS_FS_MAKE_SYM |
>              LANDLOCK_ACCESS_FS_REFER |
>              LANDLOCK_ACCESS_FS_TRUNCATE,
> +        .handled_access_net =3D
> +            LANDLOCK_ACCESS_NET_BIND_TCP |
> +            LANDLOCK_ACCESS_NET_CONNECT_TCP,
>      };
>=20
>  Because we may not know on which kernel version an application will be
> @@ -70,14 +77,18 @@ should try to protect users as much as possible whate=
ver the kernel they are
>  using.  To avoid binary enforcement (i.e. either all security features o=
r
>  none), we can leverage a dedicated Landlock command to get the current v=
ersion
>  of the Landlock ABI and adapt the handled accesses.  Let's check if we s=
hould
> -remove the ``LANDLOCK_ACCESS_FS_REFER`` or ``LANDLOCK_ACCESS_FS_TRUNCATE=
``
> -access rights, which are only supported starting with the second and thi=
rd
> -version of the ABI.
> +remove the ``LANDLOCK_ACCESS_FS_REFER`` or ``LANDLOCK_ACCESS_FS_TRUNCATE=
`` or
> +network access rights, which are only supported starting with the second=
,
> +third and fourth version of the ABI.

At some point it becomes too much to spell it out in one sentence; I'd reco=
mmend

  Let's check if we should remove access rights which are only supported
  in higher versions of the ABI.

>=20
>  .. code-block:: c
>=20
>      int abi;
>=20
> +    #define ACCESS_NET_BIND_CONNECT ( \
> +        LANDLOCK_ACCESS_NET_BIND_TCP | \
> +        LANDLOCK_ACCESS_NET_CONNECT_TCP)
> +

This #define does not seem to be used? -- Drop it?


>      abi =3D landlock_create_ruleset(NULL, 0, LANDLOCK_CREATE_RULESET_VER=
SION);
>      if (abi < 0) {
>          /* Degrades gracefully if Landlock is not handled. */
> @@ -92,6 +103,11 @@ version of the ABI.
>      case 2:
>          /* Removes LANDLOCK_ACCESS_FS_TRUNCATE for ABI < 3 */
>          ruleset_attr.handled_access_fs &=3D ~LANDLOCK_ACCESS_FS_TRUNCATE=
;
> +    case 3:
> +        /* Removes network support for ABI < 4 */
> +        ruleset_attr.handled_access_net &=3D
> +            ~(LANDLOCK_ACCESS_NET_BIND_TCP |
> +              LANDLOCK_ACCESS_NET_CONNECT_TCP);
>      }
>=20
>  This enables to create an inclusive ruleset that will contain our rules.
> @@ -143,10 +159,23 @@ for the ruleset creation, by filtering access right=
s according to the Landlock
>  ABI version.  In this example, this is not required because all of the r=
equested
>  ``allowed_access`` rights are already available in ABI 1.
>=20
> -We now have a ruleset with one rule allowing read access to ``/usr`` whi=
le
> -denying all other handled accesses for the filesystem.  The next step is=
 to
> -restrict the current thread from gaining more privileges (e.g. thanks to=
 a SUID
> -binary).
> +For network access-control, we can add a set of rules that allow to use =
a port
> +number for a specific action: HTTPS connections.
> +
> +.. code-block:: c
> +
> +    struct landlock_net_service_attr net_service =3D {
> +        .allowed_access =3D NET_CONNECT_TCP,
> +        .port =3D 443,
> +    };
> +
> +    err =3D landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +                            &net_service, 0);
> +
> +The next step is to restrict the current thread from gaining more privil=
eges
> +(e.g. through a SUID binary). We now have a ruleset with the first rule =
allowing
> +read access to ``/usr`` while denying all other handled accesses for the=
 filesystem,
> +and a second rule allowing HTTPS connections.
>=20
>  .. code-block:: c
>=20
> @@ -355,7 +384,7 @@ Access rights
>  -------------
>=20
>  .. kernel-doc:: include/uapi/linux/landlock.h
> -    :identifiers: fs_access
> +    :identifiers: fs_access net_access
>=20
>  Creating a new ruleset
>  ----------------------
> @@ -374,6 +403,7 @@ Extending a ruleset
>=20
>  .. kernel-doc:: include/uapi/linux/landlock.h
>      :identifiers: landlock_rule_type landlock_path_beneath_attr
> +                  landlock_net_service_attr
>=20
>  Enforcing a ruleset
>  -------------------
> @@ -451,6 +481,12 @@ always allowed when using a kernel that only support=
s the first or second ABI.
>  Starting with the Landlock ABI version 3, it is now possible to securely=
 control
>  truncation thanks to the new ``LANDLOCK_ACCESS_FS_TRUNCATE`` access righ=
t.
>=20
> +Network support (ABI < 4)
> +-------------------------
> +
> +Starting with the Landlock ABI version 4, it is now possible to restrict=
 TCP
> +bind and connect actions to only a set of allowed ports.
> +
>  .. _kernel_support:
>=20
>  Kernel support
> @@ -469,6 +505,11 @@ still enable it by adding ``lsm=3Dlandlock,[...]`` t=
o
>  Documentation/admin-guide/kernel-parameters.rst thanks to the bootloader
>  configuration.
>=20
> +To be able to explicitly allow TCP operations (e.g., adding a network ru=
le with
> +``LANDLOCK_ACCESS_NET_TCP_BIND``), the kernel must support TCP (``CONFIG=
_INET=3Dy``).
> +Otherwise, sys_landlock_add_rule() returns an ``EAFNOSUPPORT`` error, wh=
ich can
> +safely be ignored because this kind of TCP operation is already not poss=
ible.
> +
>  Questions and answers
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> --
> 2.25.1
>=20

=E2=80=94G=C3=BCnther

--=20
Sent using Mutt =F0=9F=90=95 Woof Woof

