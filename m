Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04FE8681A86
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 20:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbjA3Tc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 14:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236733AbjA3Tc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 14:32:56 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0819023
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 11:32:54 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5073cf66299so143746607b3.17
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 11:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F7qcVHgFqar+RLPHhCuxmTSqYurpoqGeRnlo4MeMdGM=;
        b=CS32Maq9UJAiRgqyO0xukKCPo7dsZyvjjAuhNB2mMrr+lZXiZAqa8a46EFpfzMZ2th
         yjNPa8D9mHMnBEePhzXUh472qX3RcVX6ln6L+6KOQMOKvDv0ShlFIxV1N8yn/oNYsUNN
         WIEJMbv4C9KxGR4nMnEQsGEsvODz3UaGauFDRanlSksG9EAIH/Us7jgPKNj5CrOKmIxE
         FZtdsWq077HccqmNXHQeyQ9JokzwQUB0InJq+q19wzFT9uD8ur060EkZR8Lqoa+xdVJE
         u4FqRzKdfe4FKLq6/FoBp1fkZSB8RwI5XviqMErrHp+E6mVJy72kPuR5zAOAKwr8aBNB
         uC2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F7qcVHgFqar+RLPHhCuxmTSqYurpoqGeRnlo4MeMdGM=;
        b=weYtyX7LLppPVdKe1gf9knfO9lcsyEiTXR3U5x73AyEFYkn3+GO1nIgvkFdkCw4zgZ
         Gw3uyexCLAS379BhZxYwPtJ5sYAEy/TBywnELXDpSAFxZjIiihEynFTSGmMVuPdneZUq
         nBEkT/r81dF1QoUGpWNa6RpZRBGx9mLtHyONtmnxzBGoDGhiRlyp7/HA6VDiCsyeetD6
         MKoXdRMX/4sfSSk2cyBEwBYWJAsA9ko94weskaGQ+Av5BfqQi0VdIqe9IpjZzd8Xql2f
         GA749ZdZR0fzIaZ6ciF+k92fm/zRUfHYLFAn2w8MOvqOZcR2ZwrlDv3rYcHR4/gusiBp
         Invw==
X-Gm-Message-State: AO0yUKXBg6rxMYI41YQ4AwtUlZEjhjUO35iw+LJhfoqdhovZmh2evcFi
        UN1nEui8E2g+Ygz2CJm+iqVwmTI=
X-Google-Smtp-Source: AK7set/5Fg6GioxcVztoFtuuSBujoatLB/R0sV1FhzZ5YkHBDHZGMdXBdqjWWPbUYe/m7NQjsfGJ9d0=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a0d:f304:0:b0:508:3e6d:8ac1 with SMTP id
 c4-20020a0df304000000b005083e6d8ac1mr2108805ywf.207.1675107173419; Mon, 30
 Jan 2023 11:32:53 -0800 (PST)
Date:   Mon, 30 Jan 2023 11:32:51 -0800
In-Reply-To: <20230128043217.1572362-12-kuba@kernel.org>
Mime-Version: 1.0
References: <20230128043217.1572362-1-kuba@kernel.org> <20230128043217.1572362-12-kuba@kernel.org>
Message-ID: <Y9gbYw3oc7GjfFnU@google.com>
Subject: Re: [PATCH net-next 11/13] netlink: specs: finish up operation enum-models
From:   Stanislav Fomichev <sdf@google.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/27, Jakub Kicinski wrote:
> I had a (bright?) idea of introducing the concept of enum-models
> to account for all the weird ways families enumerate their messages.
> I've never finished it because generating C code for each of them
> is pretty daunting. But for languages which can use ID values directly
> the support is simple enough, so clean this up a bit.

> "unified" model is what I recommend going forward.
> "directional" model is what ethtool uses.
> "notify-split" is used by the proposed DPLL code, but we can just
> make them use "unified", it hasn't been merged :)

> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   Documentation/netlink/genetlink-c.yaml        |  4 +-
>   Documentation/netlink/genetlink-legacy.yaml   | 11 ++-
>   Documentation/netlink/genetlink.yaml          |  4 +-
>   .../netlink/genetlink-legacy.rst              | 82 +++++++++++++++++++
>   4 files changed, 92 insertions(+), 9 deletions(-)

> diff --git a/Documentation/netlink/genetlink-c.yaml  
> b/Documentation/netlink/genetlink-c.yaml
> index e23e3c94a932..bbcfa2472b04 100644
> --- a/Documentation/netlink/genetlink-c.yaml
> +++ b/Documentation/netlink/genetlink-c.yaml
> @@ -218,9 +218,7 @@ additionalProperties: False
>             to a single enum.
>             "directional" has the messages sent to the kernel and from the  
> kernel
>             enumerated separately.
> -          "notify-split" has the notifications and request-response  
> types in
> -          different enums.
> -        enum: [ unified, directional, notify-split ]
> +        enum: [ unified ]
>         name-prefix:
>           description: |
>             Prefix for the C enum name of the command. The name is formed  
> by concatenating
> diff --git a/Documentation/netlink/genetlink-legacy.yaml  
> b/Documentation/netlink/genetlink-legacy.yaml
> index 88db2431ef26..5642925c4ceb 100644
> --- a/Documentation/netlink/genetlink-legacy.yaml
> +++ b/Documentation/netlink/genetlink-legacy.yaml
> @@ -241,9 +241,7 @@ additionalProperties: False
>             to a single enum.
>             "directional" has the messages sent to the kernel and from the  
> kernel
>             enumerated separately.
> -          "notify-split" has the notifications and request-response  
> types in
> -          different enums.
> -        enum: [ unified, directional, notify-split ]
> +        enum: [ unified, directional ] # Trim
>         name-prefix:
>           description: |
>             Prefix for the C enum name of the command. The name is formed  
> by concatenating
> @@ -307,6 +305,13 @@ additionalProperties: False
>                         type: array
>                         items:
>                           type: string
> +                    # Start genetlink-legacy
> +                    value:
> +                      description: |
> +                        ID of this message if value for request and  
> response differ,
> +                        i.e. requests and responses have different  
> message enums.
> +                      $ref: '#/$defs/uint'
> +                    # End genetlink-legacy
>                   reply: *subop-attr-list
>                   pre:
>                     description: Hook for a function to run before the  
> main callback (pre_doit or start).
> diff --git a/Documentation/netlink/genetlink.yaml  
> b/Documentation/netlink/genetlink.yaml
> index b5e712bbe7e7..62a922755ce2 100644
> --- a/Documentation/netlink/genetlink.yaml
> +++ b/Documentation/netlink/genetlink.yaml
> @@ -188,9 +188,7 @@ additionalProperties: False
>             to a single enum.
>             "directional" has the messages sent to the kernel and from the  
> kernel
>             enumerated separately.
> -          "notify-split" has the notifications and request-response  
> types in
> -          different enums.
> -        enum: [ unified, directional, notify-split ]
> +        enum: [ unified ]
>         name-prefix:
>           description: |
>             Prefix for the C enum name of the command. The name is formed  
> by concatenating
> diff --git a/Documentation/userspace-api/netlink/genetlink-legacy.rst  
> b/Documentation/userspace-api/netlink/genetlink-legacy.rst
> index 65cbbffee0bf..ae6053e3e50c 100644
> --- a/Documentation/userspace-api/netlink/genetlink-legacy.rst
> +++ b/Documentation/userspace-api/netlink/genetlink-legacy.rst
> @@ -74,6 +74,88 @@ type. Inside the attr-index nest are the policy  
> attributes. Modern
>   Netlink families should have instead defined this as a flat structure,
>   the nesting serves no good purpose here.

> +Operations
> +==========
> +
> +Enum (message ID) model
> +-----------------------
> +
> +unified
> +~~~~~~~
> +
> +Modern families use the ``unified`` message ID model, which uses
> +a single enumeration for all messages within family. Requests and
> +responses share the same message ID. Notifications have separate
> +IDs from the same space. For example given the following list
> +of operations:
> +
> +.. code-block:: yaml
> +
> +  -
> +    name: a
> +    value: 1
> +    do: ...
> +  -
> +    name: b
> +    do: ...
> +  -
> +    name: c
> +    value: 4
> +    notify: a
> +  -
> +    name: d
> +    do: ...
> +
> +Requests and responses for aperation ``a`` will have the ID of 1,

s/aperation/operation/ ?

> +the requests and responses of ``b`` - 2 (since there is no explicit
> +``value`` it's previous operation ``+ 1``). Notification ``c`` will
> +used the ID of 4, operation ``d`` 5 etc.

s/used/use/ ?

> +
> +directional
> +~~~~~~~~~~~
> +
> +The ``directional`` model splits the ID assignment by the direction of
> +the message. Messages from and to the kernel can't be confused with
> +each other so this conserves the ID space (at the cost of making
> +the programming more cumbersome).
> +
> +In this case ``value`` attribute should be specified in the ``request``
> +``reply`` sections of the operations (if an operation has both ``do``
> +and ``dump`` the IDs are shared, ``value`` should be set in ``do``).
> +For notifications the ``value`` is provided at the op level but it
> +only allocates a ``reply`` (i.e. a "from-kernel" ID). Let's look
> +at an example:
> +
> +.. code-block:: yaml
> +
> +  -
> +    name: a
> +    do:

[..]

> +      request:
> +        value: 2
> +	attributes: ...
> +      reply:
> +        value: 1
> +	attributes: ...

'attributes' indentation is wrong for both request/reply?

> +  -
> +    name: b
> +    notify: a
> +  -
> +    name: c
> +    notify: a
> +    value: 7
> +  -
> +    name: d
> +    do: ...
> +
> +In this case ``a`` will use 2 when sending the message to the kernel
> +and expects message with ID 1 in response. Notificatoin ``b`` allocates
> +a "from-kernel" ID which is 2. ``c`` allocates "from-kernel" ID of 7.
> +If operation ``d`` does not set ``values`` explicitly in the spec
> +it will be allocated 3 for the request (``a`` is the previous operation
> +with a request section and the value of 2) and 8 for response (``c`` is
> +the previous operation in the "from-kernel" direction).
> +
>   Other quirks (todo)
>   ===================

> --
> 2.39.1

