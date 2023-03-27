Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDE06CA241
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 13:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbjC0LSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 07:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbjC0LSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 07:18:23 -0400
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463F84494;
        Mon, 27 Mar 2023 04:18:21 -0700 (PDT)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-54184571389so163693597b3.4;
        Mon, 27 Mar 2023 04:18:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679915900;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mfRGrWat4WK4Y8Q8toIh2J7eKaL0jEdcchM3E9jVj+4=;
        b=Ik4pJ/LDSlQW6gfewQq9CBduADiIhHhD5rCD7sENxbNV3yJI7R3elWlp+M4rw2XKP8
         bnpU31oyHabigHYVPeHGOPwdBM42gsiucMpzfA+p2/r1mLiH8n/HZFz//3AbXWMwuavg
         6oSi/i2Bo7FmvUmRiucksWVSe/lHVXgdwYV0VvzY5LQ5m79jqfVe58z/3pzOhoQVWRsQ
         +S+ZhPmZs4F3PbBnSGlzZsjtdEGfAE34zLi58yVW7QdYTNPNsGShY4/xkD6sdBeLrWUW
         YS/pZq9i9TfcKO33VE2ZRRMMofZOJIm61jXNC95e++0lWdSrA3ykGFhHLl6B4FRnV3K2
         2pNQ==
X-Gm-Message-State: AAQBX9f0xxA2VpcTKzykgQPo9sd9a5BXJv3a6qP0AX6PeA30EDvLCmVQ
        ZJb/tJ828K4Im4NEPlfJV2CWLPHCyL2stA==
X-Google-Smtp-Source: AKy350an7xFRsYTkpZDSFwUnnXcJkO11V+AM6KOwwcXf7eyCyUoKvbAfWH45f5UCBAP7scIwEwoTQg==
X-Received: by 2002:a0d:d7c4:0:b0:545:b05f:6722 with SMTP id z187-20020a0dd7c4000000b00545b05f6722mr10137992ywd.10.1679915900076;
        Mon, 27 Mar 2023 04:18:20 -0700 (PDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id u16-20020a81b610000000b00545a0818481sm1891818ywh.17.2023.03.27.04.18.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 04:18:19 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id b18so10048879ybp.1;
        Mon, 27 Mar 2023 04:18:19 -0700 (PDT)
X-Received: by 2002:a25:abee:0:b0:b68:7a4a:5258 with SMTP id
 v101-20020a25abee000000b00b687a4a5258mr7133480ybi.3.1679915899162; Mon, 27
 Mar 2023 04:18:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230316131526.283569-1-aleksandr.mikhalitsyn@canonical.com> <7b4f8261bd3cc76c123ee7fbd176ca6a82387dce.camel@debian.org>
In-Reply-To: <7b4f8261bd3cc76c123ee7fbd176ca6a82387dce.camel@debian.org>
From:   Luca Boccassi <bluca@debian.org>
Date:   Mon, 27 Mar 2023 11:18:08 +0000
X-Gmail-Original-Message-ID: <CAMw=ZnRFa4bnkvScSUzpHHjrXAiORdjUgthcsyvHkJ6B2TWp0Q@mail.gmail.com>
Message-ID: <CAMw=ZnRFa4bnkvScSUzpHHjrXAiORdjUgthcsyvHkJ6B2TWp0Q@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] Add SCM_PIDFD and SO_PEERPIDFD
To:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        davem@davemloft.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <brauner@kernel.org>, smcv@collabora.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 at 14:35, Luca Boccassi <bluca@debian.org> wrote:
>
> On Thu, 2023-03-16 at 14:15 +0100, Alexander Mikhalitsyn wrote:
> > 1. Implement SCM_PIDFD, a new type of CMSG type analogical to SCM_CREDENTIALS,
> > but it contains pidfd instead of plain pid, which allows programmers not
> > to care about PID reuse problem.
> >
> > 2. Add SO_PEERPIDFD which allows to get pidfd of peer socket holder pidfd.
> > This thing is direct analog of SO_PEERCRED which allows to get plain PID.
> >
> > 3. Add SCM_PIDFD / SO_PEERPIDFD kselftest
> >
> > Idea comes from UAPI kernel group:
> > https://uapi-group.org/kernel-features/
> >
> > Big thanks to Christian Brauner and Lennart Poettering for productive
> > discussions about this.
> >
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Leon Romanovsky <leon@kernel.org>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Christian Brauner <brauner@kernel.org>
> >
> > Alexander Mikhalitsyn (3):
> >   scm: add SO_PASSPIDFD and SCM_PIDFD
> >   net: core: add getsockopt SO_PEERPIDFD
> >   selftests: net: add SCM_PIDFD / SO_PEERPIDFD test
>
> I've implemented support for this in dbus-daemon:
>
> https://gitlab.freedesktop.org/dbus/dbus/-/merge_requests/398
>
> It's working very well. I am also working on the dbus-broker and polkit
> side of things, will share the links here once they are in a reviewable
> state. But the dbus-daemon implementation is enough to meaningfully
> test this.
>
> For the series:
>
> Tested-by: Luca Boccassi <bluca@debian.org>

Polkit changes:

https://gitlab.freedesktop.org/polkit/polkit/-/merge_requests/154
