Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A87E500918
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 10:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241391AbiDNJCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 05:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241040AbiDNJBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 05:01:53 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3766E546
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 01:59:14 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id md20-20020a17090b23d400b001cb70ef790dso8682979pjb.5
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 01:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0LUCoLOqsjdmuMA9Sv/GTYrqnMUY1MiY7Yfiq4vegQE=;
        b=HomuRkNsmV7IKhzIJt76YdeNNTkW/NrcqeA7SzFmKUtPaY3/VHAjsS6yZ7zHOBKR8r
         zCbX6k8iFJINPRJt9zuZu8/CXDMqLnhSxOGqYIJpYeDl+0FvJm/iSC9G3LsO52+Oz2dg
         rsYn2iXkkOEIHk3i3p7NtE9HPSbQsp1vtXzXF2xhtp8OUDuCvSp+B5vvOv5814PjX+ok
         4LMXXWwLCY54XIJCI9Ibtxe+l/9oNMHcSY+At3un98WY7TMznKD02N7Wk8UNO8TB52aB
         47NserAFqEUbjQx9vcfA+BEoQm5QtpTY7JEe5FLzJ5a8cfqTN4598JvJjiu2XQgMRIRQ
         rsog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0LUCoLOqsjdmuMA9Sv/GTYrqnMUY1MiY7Yfiq4vegQE=;
        b=OYcJrJrO+uGEXqLXY1Ovd3m+Rb7HBgYuNdVIcnLLMlV98JrszfZ8JeJ82PgX4E23A5
         jS9tKP776EPA6JpasVccJ80emQxnLtDnQEtwjf7LY+613lsklLPvsfLheufVMQ7hEE6C
         nbXMYVSUlsXYPb9nk7NVELqYMKUTnB35fuadX6N2MtnNBX3z7qathVwR9MO1rZlefihW
         wX9ZIkSXYHX1B6eR4Nq4SeELhira8xhMjOBBs5LPjg7m+ObfAmE30dcutLVw7V61Fkd+
         2sZDYTOrI+5b7YrU6O4O1xyiYJqJo9SYS9ZJXWfyKWsmCa4oZ0PJvUWOq5oyJhIsV5oB
         CtGA==
X-Gm-Message-State: AOAM533f0UxGO2pm/sXaNKEmIgCIisoD6py49UVjA/aCDWWNG10yPock
        Ov9d+IdEF+MlxofBXWMskMggF4p4oazzkyB8JnE+Jw==
X-Google-Smtp-Source: ABdhPJxlr3HwneXRMQWmwp1QPVtDvPbaeJ6+jvqdb1zomhx1OdLrBeAIymtji6CSi0zshAF41yPRZfFxQZO+hbVuwLs=
X-Received: by 2002:a17:902:7205:b0:156:1a0a:2c39 with SMTP id
 ba5-20020a170902720500b001561a0a2c39mr46589099plb.88.1649926754208; Thu, 14
 Apr 2022 01:59:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220414025609.578-1-aajith@arista.com> <0bf37720-870a-9dde-d825-92e12633ce38@gmail.com>
In-Reply-To: <0bf37720-870a-9dde-d825-92e12633ce38@gmail.com>
From:   Arun Ajith S <aajith@arista.com>
Date:   Thu, 14 Apr 2022 14:29:01 +0530
Message-ID: <CAOvjArTBoxSnX_ck_pW9Fq1cVXtT1sQ9zVHL207fdwj5v5iygQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net/ipv6: Introduce accept_unsolicited_na
 knob to implement router-side changes for RFC9131
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        dsahern@kernel.org, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, prestwoj@gmail.com,
        gilligan@arista.com, noureddine@arista.com, gk@arista.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you.
Do I have to post a v5 with the fixup ?

-Arun

-Arun


On Thu, Apr 14, 2022 at 11:42 AM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
>
> On 4/14/22 09:56, Arun Ajith S wrote:
> > Add a new neighbour cache entry in STALE state for routers on receiving
> > an unsolicited (gratuitous) neighbour advertisement with
> > target link-layer-address option specified.
> > This is similar to the arp_accept configuration for IPv4.
> > A new sysctl endpoint is created to turn on this behaviour:
> > /proc/sys/net/ipv6/conf/interface/accept_unsolicited_na.
> >
>
> Hi,
>
> Building the documentation (htmldocs) with this patch, I got:
>
> /home/bagas/repo/linux-stable/Documentation/networking/ip-sysctl.rst:2475:
> WARNING: Unexpected indentation.
> /home/bagas/repo/linux-stable/Documentation/networking/ip-sysctl.rst:2477:
> WARNING: Unexpected indentation.
> /home/bagas/repo/linux-stable/Documentation/networking/ip-sysctl.rst:2481:
> WARNING: Unexpected indentation.
> /home/bagas/repo/linux-stable/Documentation/networking/ip-sysctl.rst:2482:
> WARNING: Block quote ends without a blank line; unexpected unindent.
>
> I have applied following fixup.
>
> ---- 8> ----
> From 304846b43a9f962f53f3841afabfd597b3b80951 Mon Sep 17 00:00:00 2001
> From: Bagas Sanjaya <bagasdotme@gmail.com>
> Date: Thu, 14 Apr 2022 12:59:46 +0700
> Subject: [PATCH] fixup for "net/ipv6: Introduce accept_unsolicited_na knob to
>  implement router-side changes for RFC9131"
>
> Fix the simple table syntax.
>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index 9e17efe343a..433f2e4a5fe 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -2472,13 +2472,17 @@ accept_unsolicited_na - BOOLEAN
>         unsolicited neighbour advertisement with target link-layer address option
>         specified. This is as per router-side behavior documented in RFC9131.
>         This has lower precedence than drop_unsolicited_na.
> +
> +        ====   ======  ======  ==============================================
>          drop   accept  fwding                   behaviour
>          ----   ------  ------  ----------------------------------------------
>             1        X       X  Drop NA packet and don't pass up the stack
>             0        0       X  Pass NA packet up the stack, don't update NC
>             0        1       0  Pass NA packet up the stack, don't update NC
>             0        1       1  Pass NA packet up the stack, and add a STALE
> -                                 NC entry
> +                               NC entry
> +        ====   ======  ======  ==============================================
> +
>         This will optimize the return path for the initial off-link communication
>         that is initiated by a directly connected host, by ensuring that
>         the first-hop router which turns on this setting doesn't have to
>
> base-commit: 38e01f46e0e7f88b92ca0b3f52ac6b9909ed413b
> --
> An old man doll... just what I always wanted! - Clara
>
> Thanks.
>
> --
> An old man doll... just what I always wanted! - Clara
