Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B278676A4A
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 00:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjAUXHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 18:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjAUXHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 18:07:31 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B103C15;
        Sat, 21 Jan 2023 15:07:29 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id v13so10626442eda.11;
        Sat, 21 Jan 2023 15:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5W5FXRUDgu1hTQjxZFO4OyeWjrcuKQnGQ+NdBC2JCLc=;
        b=TQzEHgJzRrrr12GYVA0fzC3V4YQvIyu2sAdd9OoOjBHzNvEBn8VGS2I+RZYAkzQqVD
         dqzdLVWyG6Uf0P8AaJAPxdjfCXMuKVqsR8Y6tsQYsrac3KtZB70i4aVSpHCmoAJXmRvG
         c0X2ZlZ97omAZEmG0RXI00qhncC3m950FoTea7SEwoEonAVajRx0ARsSLU16081GWTSE
         jVVgG6aaYVZdhbesJ0n0uBn5t0diA8AL1G/fvmk2tiV1s5aKEld5swNzas6H79O2N/7d
         BFYpBlpJ1pxv5QTnuKmRzFQ7tsa9LhvaDsPwDJUBaUFwULuo1r0xVy77iamJmyoDnh0q
         uvzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5W5FXRUDgu1hTQjxZFO4OyeWjrcuKQnGQ+NdBC2JCLc=;
        b=wImm+w23Zu0OOVWn0o+SUbiJrlL/TOdkNmGG5A4TuSqN15+b23iWqv0y5OyBh3Hf1j
         CMGsKIuK9q9NQBVGGdzWutfvMbaVsf7FqSCKlyTqqPGpTDQkhvAkxj5sZMrx6nc9vNwe
         efKKT6679l+yrQad382FyyHH0ASOlh1tBJCtm76RGoEBnLODgF407X+cYcRmYrGkS/VC
         RQfVwE8zdA/+RT0EYk/bcdw+BAacFYDVusDWKMR+gzlxb8c2xuAF5D9jiz3rVMluPliC
         SxhcZJ0HuZ4BB0/Sw5N/Molr6ACN43XbGOlJJnBzxyCPncu07nM88wb+Op4Ii2Gyvcut
         QVng==
X-Gm-Message-State: AFqh2krfXJz1mif9DenxeOZOmZCNqNBMGXF+/2/n2bnrWt2U6OstvQq7
        xRSsSpHLvoFi8qd4X0kXANg=
X-Google-Smtp-Source: AMrXdXtRJkbVY0vGPMCoTJ1C33SkbNPoPLu/TFRkCSX/Ya5fGGDae3RMcjsazn8nVO8P/D7OAbM+ow==
X-Received: by 2002:a05:6402:f04:b0:480:cbe7:9ee2 with SMTP id i4-20020a0564020f0400b00480cbe79ee2mr24001268eda.22.1674342448181;
        Sat, 21 Jan 2023 15:07:28 -0800 (PST)
Received: from localhost ([2a02:168:633b:1:485:9427:753:83a])
        by smtp.gmail.com with ESMTPSA id x13-20020aa7cd8d000000b0047e6fdbf81csm3991802edv.82.2023.01.21.15.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Jan 2023 15:07:27 -0800 (PST)
Date:   Sun, 22 Jan 2023 00:07:26 +0100
From:   =?iso-8859-1?Q?G=FCnther?= Noack <gnoack3000@gmail.com>
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     mic@digikod.net, willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
Subject: Re: [PATCH v9 12/12] landlock: Document Landlock's network support
Message-ID: <Y8xwLvDbhKPG8JqY@galopp>
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-13-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230116085818.165539-13-konstantin.meskhidze@huawei.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

Thank you for sending these patches! I'll start poking a bit at the
Go-Landlock library to see how we can support it there when this lands.

On Mon, Jan 16, 2023 at 04:58:18PM +0800, Konstantin Meskhidze wrote:
> Describe network access rules for TCP sockets. Add network access
> example in the tutorial. Add kernel configuration support for network.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v8:
> * Minor refactoring.
> 
> Changes since v7:
> * Fixes documentaion logic errors and typos as Mickaёl suggested:
> https://lore.kernel.org/netdev/9f354862-2bc3-39ea-92fd-53803d9bbc21@digikod.net/
> 
> Changes since v6:
> * Adds network support documentaion.
> 
> ---
>  Documentation/userspace-api/landlock.rst | 72 ++++++++++++++++++------
>  1 file changed, 56 insertions(+), 16 deletions(-)
> 
> diff --git a/Documentation/userspace-api/landlock.rst b/Documentation/userspace-api/landlock.rst
> index d8cd8cd9ce25..980558b879d6 100644
> --- a/Documentation/userspace-api/landlock.rst
> +++ b/Documentation/userspace-api/landlock.rst
> @@ -11,10 +11,10 @@ Landlock: unprivileged access control
>  :Date: October 2022
>  
>  The goal of Landlock is to enable to restrict ambient rights (e.g. global
> -filesystem access) for a set of processes.  Because Landlock is a stackable
> -LSM, it makes possible to create safe security sandboxes as new security layers
> -in addition to the existing system-wide access-controls. This kind of sandbox
> -is expected to help mitigate the security impact of bugs or
> +filesystem or network access) for a set of processes.  Because Landlock
> +is a stackable LSM, it makes possible to create safe security sandboxes as new
> +security layers in addition to the existing system-wide access-controls. This
> +kind of sandbox is expected to help mitigate the security impact of bugs or
>  unexpected/malicious behaviors in user space applications.  Landlock empowers
>  any process, including unprivileged ones, to securely restrict themselves.
>  
> @@ -30,18 +30,20 @@ Landlock rules
>  
>  A Landlock rule describes an action on an object.  An object is currently a
>  file hierarchy, and the related filesystem actions are defined with `access
> -rights`_.  A set of rules is aggregated in a ruleset, which can then restrict
> -the thread enforcing it, and its future children.
> +rights`_.  Since ABI version 4 a port data appears with related network actions
> +for TCP socket families.  A set of rules is aggregated in a ruleset, which
> +can then restrict the thread enforcing it, and its future children.
>  
>  Defining and enforcing a security policy
>  ----------------------------------------
>  
>  We first need to define the ruleset that will contain our rules.  For this
>  example, the ruleset will contain rules that only allow read actions, but write
> -actions will be denied.  The ruleset then needs to handle both of these kind of
> +actions will be denied. The ruleset then needs to handle both of these kind of

(This one looks like an unintentional whitespace change; the
double-space ending is used in this file, so we should probably stay
consistent.)

>  actions.  This is required for backward and forward compatibility (i.e. the
>  kernel and user space may not know each other's supported restrictions), hence
> -the need to be explicit about the denied-by-default access rights.
> +the need to be explicit about the denied-by-default access rights.  Also ruleset

Wording nit: "Also, the ruleset"...?

> +will have network rules for specific ports, so it should handle network actions.
>  
>  .. code-block:: c
>  
> @@ -62,6 +64,9 @@ the need to be explicit about the denied-by-default access rights.
>              LANDLOCK_ACCESS_FS_MAKE_SYM |
>              LANDLOCK_ACCESS_FS_REFER |
>              LANDLOCK_ACCESS_FS_TRUNCATE,
> +        .handled_access_net =
> +            LANDLOCK_ACCESS_NET_BIND_TCP |
> +            LANDLOCK_ACCESS_NET_CONNECT_TCP,
>      };
>  
>  Because we may not know on which kernel version an application will be
> @@ -70,14 +75,18 @@ should try to protect users as much as possible whatever the kernel they are
>  using.  To avoid binary enforcement (i.e. either all security features or
>  none), we can leverage a dedicated Landlock command to get the current version
>  of the Landlock ABI and adapt the handled accesses.  Let's check if we should
> -remove the ``LANDLOCK_ACCESS_FS_REFER`` or ``LANDLOCK_ACCESS_FS_TRUNCATE``
> -access rights, which are only supported starting with the second and third
> -version of the ABI.
> +remove the ``LANDLOCK_ACCESS_FS_REFER`` or ``LANDLOCK_ACCESS_FS_TRUNCATE`` or
> +network access rights, which are only supported starting with the second,
> +third and fourth version of the ABI.
>  
>  .. code-block:: c
>  
>      int abi;
>  
> +    #define ACCESS_NET_BIND_CONNECT ( \
> +        LANDLOCK_ACCESS_NET_BIND_TCP | \
> +        LANDLOCK_ACCESS_NET_CONNECT_TCP)
> +
>      abi = landlock_create_ruleset(NULL, 0, LANDLOCK_CREATE_RULESET_VERSION);
>      if (abi < 0) {
>          /* Degrades gracefully if Landlock is not handled. */
> @@ -92,6 +101,11 @@ version of the ABI.
>      case 2:
>          /* Removes LANDLOCK_ACCESS_FS_TRUNCATE for ABI < 3 */
>          ruleset_attr.handled_access_fs &= ~LANDLOCK_ACCESS_FS_TRUNCATE;
> +    case 3:
> +        /* Removes network support for ABI < 4 */
> +		ruleset_attr.handled_access_net &=
           ^^^^^
           Nit: Indentation differs from "case 2"
           
> +			~(LANDLOCK_ACCESS_NET_BIND_TCP |
> +			  LANDLOCK_ACCESS_NET_CONNECT_TCP);
>      }
>  
>  This enables to create an inclusive ruleset that will contain our rules.
> @@ -143,10 +157,24 @@ for the ruleset creation, by filtering access rights according to the Landlock
>  ABI version.  In this example, this is not required because all of the requested
>  ``allowed_access`` rights are already available in ABI 1.
>  
> -We now have a ruleset with one rule allowing read access to ``/usr`` while
> -denying all other handled accesses for the filesystem.  The next step is to
> -restrict the current thread from gaining more privileges (e.g. thanks to a SUID
> -binary).
> +For network access-control, we can add a set of rules that allow to use a port
> +number for a specific action. All ports values must be defined in network byte
> +order.

What is the point of asking user space to convert this to network byte
order? It seems to me that the kernel would be able to convert it to
network byte order very easily internally and in a single place -- why
ask all of the users to deal with that complexity? Am I overlooking
something?

> +
> +.. code-block:: c
> +
> +    struct landlock_net_service_attr net_service = {
> +        .allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
> +        .port = htons(8080),
> +    };

This is a more high-level comment:

The notion of a 16-bit "port" seems to be specific to TCP and UDP --
how do you envision this struct to evolve if other protocols need to
be supported in the future?

Should this struct and the associated constants have "TCP" in its
name, and other protocols use a separate struct in the future?

> +
> +    err = landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +                            &net_service, 0);
> +
> +The next step is to restrict the current thread from gaining more privileges
> +(e.g. thanks to a SUID binary). We now have a ruleset with the first rule allowing
         ^^^^^^
         "through" a SUID binary? "thanks to" sounds like it's desired
         to do that, while we're actually trying to prevent it here?

> +read access to ``/usr`` while denying all other handled accesses for the filesystem,
> +and a second rule allowing TCP binding on port 8080.
>  
>  .. code-block:: c
>  
> @@ -355,7 +383,7 @@ Access rights
>  -------------
>  
>  .. kernel-doc:: include/uapi/linux/landlock.h
> -    :identifiers: fs_access
> +    :identifiers: fs_access net_access
>  
>  Creating a new ruleset
>  ----------------------
> @@ -374,6 +402,7 @@ Extending a ruleset
>  
>  .. kernel-doc:: include/uapi/linux/landlock.h
>      :identifiers: landlock_rule_type landlock_path_beneath_attr
> +                  landlock_net_service_attr
>  
>  Enforcing a ruleset
>  -------------------
> @@ -451,6 +480,12 @@ always allowed when using a kernel that only supports the first or second ABI.
>  Starting with the Landlock ABI version 3, it is now possible to securely control
>  truncation thanks to the new ``LANDLOCK_ACCESS_FS_TRUNCATE`` access right.
>  
> +Network support (ABI < 4)
> +-------------------------
> +
> +Starting with the Landlock ABI version 4, it is now possible to restrict TCP
> +bind and connect actions to only a set of allowed ports.
> +
>  .. _kernel_support:
>  
>  Kernel support
> @@ -469,6 +504,11 @@ still enable it by adding ``lsm=landlock,[...]`` to
>  Documentation/admin-guide/kernel-parameters.rst thanks to the bootloader
>  configuration.
>  
> +To be able to explicitly allow TCP operations (e.g., adding a network rule with
> +``LANDLOCK_ACCESS_NET_TCP_BIND``), the kernel must support TCP (``CONFIG_INET=y``).
> +Otherwise, sys_landlock_add_rule() returns an ``EAFNOSUPPORT`` error, which can
> +safely be ignored because this kind of TCP operation is already not possible.
> +
>  Questions and answers
>  =====================
>  
> -- 
> 2.25.1
> 
