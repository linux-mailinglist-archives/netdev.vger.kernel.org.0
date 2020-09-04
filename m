Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACAFC25E382
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 23:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgIDV4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 17:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727057AbgIDV4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 17:56:04 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F6FC061244;
        Fri,  4 Sep 2020 14:56:04 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id h20so5365113ybj.8;
        Fri, 04 Sep 2020 14:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KcyncAqSFy7yZSCjaOLEH2w+g+v8p0de1qrtkMCAZfc=;
        b=pl0/LUUaRuHxm2M5Ivj0OlWc8ZirA7IBaWUoxsvGhUE5OCAmW1raV2zU3IzficZ6Gr
         hcDbzlVWfXOlDwpRLxwUbfCLpwuJ9+VhsZ7F8JNiYFWs8UT9FFNCatOpPvFrPb2rjPsM
         3m5mJFKMidcLyA9usUGrO71UlAyPupaRK6C+HB3qGaxCRsCRf+y4AkLBW8r4v6WxBZSs
         GXLScTHOzrOCUtZRmFcIVdp0oyufwpiOEubaS5Hkm6y/A9nEsMB4gEMJSzkQHHiluCEO
         3IAyEMOh0oE9gD+u4JIGq4F1lgZ46gIhVvR2QgxTWycJx8WR82d9CXYXtdu2DGv0zS43
         9hIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KcyncAqSFy7yZSCjaOLEH2w+g+v8p0de1qrtkMCAZfc=;
        b=iWcfQ44JkVU7Yoyind5PawOzUCGAAm623eltqbOBNxxiEKxHfFqFDy7/XjI1JDwlxf
         3WVABM1gY8L1XzGyjCYUVYMSJPKTORw+j1Z1K6IYUKsRMqYekRo+aFD/kN7zRiMKLtE/
         EwoHMOMF4t3w2SAZAZNVHRq4E4gJAa6tdF6K7n/c1fl6MxRSbiACYtSM9dqpBJJW+QOu
         KAH4OqGyCIwO7c9TAtcignxD9l1cq3/B16fliuUUKd7E3CePsGOquaNdUSVDK240TjM9
         B5omvux9/BUVddsOBP/3vI4H10BG9k9J25Vehcx2Xc54tQN6/7nu8NXZT/MVf/es8Dwa
         zyhQ==
X-Gm-Message-State: AOAM531qJg9e+oJs/eSoO3Q1tjO/N9Lqh/A+za4TRhCEFWSnDDCkZPP7
        SGyR/60GINCgKz6nDIuywkyD7YFB59h1eJI7cDJ5uKMpd9Y=
X-Google-Smtp-Source: ABdhPJypc+laymLo8EpQUTGHbnvae0+KX6YmjdG9g9xmuJ8RFoINixFFxwrvAC5Cs2KLEg3mlr3HOojEf0EvTO+bx9M=
X-Received: by 2002:a25:cb57:: with SMTP id b84mr12826825ybg.425.1599256563699;
 Fri, 04 Sep 2020 14:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200904161313.29535-1-quentin@isovalent.com> <20200904161313.29535-3-quentin@isovalent.com>
In-Reply-To: <20200904161313.29535-3-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Sep 2020 14:55:52 -0700
Message-ID: <CAEf4BzZCSd2Y8KrVMHPG8=pjaF_GfVZqt3Tu0jRkRP_gSDreSg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] tools: bpftool: add "inner_map" to "bpftool
 map create" outer maps
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Martynas Pumputis <m@lambda.lt>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 4, 2020 at 9:16 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> There is no support for creating maps of types array-of-map or
> hash-of-map in bpftool. This is because the kernel needs an inner_map_fd
> to collect metadata on the inner maps to be supported by the new map,
> but bpftool does not provide a way to pass this file descriptor.
>
> Add a new optional "inner_map" keyword that can be used to pass a
> reference to a map, retrieve a fd to that map, and pass it as the
> inner_map_fd.
>
> Add related documentation and bash completion. Note that we can
> reference the inner map by its name, meaning we can have several times
> the keyword "name" with different meanings (mandatory outer map name,
> and possibly a name to use to find the inner_map_fd). The bash
> completion will offer it just once, and will not suggest "name" on the
> following command:
>
>     # bpftool map create /sys/fs/bpf/my_outer_map type hash_of_maps \
>         inner_map name my_inner_map [TAB]
>
> Fixing that specific case seems too convoluted. Completion will work as
> expected, however, if the outer map name comes first and the "inner_map
> name ..." is passed second.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../bpf/bpftool/Documentation/bpftool-map.rst | 10 +++-
>  tools/bpf/bpftool/bash-completion/bpftool     | 22 ++++++++-
>  tools/bpf/bpftool/map.c                       | 48 +++++++++++++------
>  3 files changed, 62 insertions(+), 18 deletions(-)
>

[...]
