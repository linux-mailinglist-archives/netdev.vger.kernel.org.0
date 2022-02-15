Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7921D4B6200
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 05:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiBOEQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 23:16:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiBOEQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 23:16:42 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE840C24B2
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 20:16:32 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id w4so2720591vsq.1
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 20:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KPSye3DP/aFMtQWU+DcD705eQqcCbNUk8oNVOh77QSE=;
        b=AoFMavfC/VlDk5aFgDQJotxl1ztysH/sXAcOoinln3hBw8Pdv0uLD+H+iWhPL9KiTK
         aMVfYd6GdURq5JYLbTmPVcOzyBZLeIob1xqQFJ1x+TNQ0RgEYMg+NyTE7rSe3yZW7fh/
         zxDPNP0Z7zQUxzhg8WsTyZt2m8dgrGz1n1T0OMPbsUr81VLFfeJZtAMFPI7xDrJbSIaV
         Lw1hVXz4TuLLQ8ETlG+4SKp4urQM1N3gPtOxigrySdv7N5C1alNttEyEgn/9m6HGG0OE
         h1rHtGgn2IBIkJWuoJJA0TLoBoa2MY548/b1DHdo4RGGZQEJiZ/rXu0oB2i0W03iIG7L
         07bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KPSye3DP/aFMtQWU+DcD705eQqcCbNUk8oNVOh77QSE=;
        b=Ycrot6B3MGQTW0mI37DZIcZBe6euJBmaJSXfbnTNNi86toJIxdyLSafnOBGMDaUgYB
         RLtdy633z7DcXr3v5ZS58nsW7DaKQdVtEBBpvMxxNGonGQ6HAp6TQD4keOqe5ZCSt51/
         7EweA2oi+rropgnz9TusNfRrK8rlsJCZSpLB1W0K2/+Jo5Za7nrIIynVgwAow8LfWGSu
         KQB/KaN1vmTDkWEMI/LBbPe0YgsBbNNpEeISVvk4KVxsfKPc02y3kgH27Y7pwL6dPqKC
         YeJV8yDH0Jz5ISL0liRWX9qtILTdMv6sopl7OLa9qenmIW32fsSihcodBgMgJ6cfby8e
         6KoA==
X-Gm-Message-State: AOAM532rQGtwET6ovFSmMPgddvdLQmhhuvibAdmjdPyY/OBQTtK1Nf1Q
        XeKCLgDlG6Fgk8wcNMxJtCs/xFYiTsY=
X-Google-Smtp-Source: ABdhPJx03QmP1A8mv6fQyC46i3LdrlmKzT8PqQ2FnXKn2aBviVYyXD488VzcVpd/p8l7M6VASy9zYg==
X-Received: by 2002:a67:ae0a:: with SMTP id x10mr754357vse.87.1644898591899;
        Mon, 14 Feb 2022 20:16:31 -0800 (PST)
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com. [209.85.217.46])
        by smtp.gmail.com with ESMTPSA id t23sm3195081uar.15.2022.02.14.20.16.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 20:16:31 -0800 (PST)
Received: by mail-vs1-f46.google.com with SMTP id e26so4946677vso.3
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 20:16:30 -0800 (PST)
X-Received: by 2002:a67:d118:: with SMTP id u24mr765733vsi.35.1644898590656;
 Mon, 14 Feb 2022 20:16:30 -0800 (PST)
MIME-Version: 1.0
References: <20220214200400.513069-1-willemdebruijn.kernel@gmail.com> <202202150837.bGbeRjWx-lkp@intel.com>
In-Reply-To: <202202150837.bGbeRjWx-lkp@intel.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 14 Feb 2022 23:15:54 -0500
X-Gmail-Original-Message-ID: <CA+FuTScqkbST6PZAfZ0brq04+26kCkvhgG0uYii2iPDeC5MzXA@mail.gmail.com>
Message-ID: <CA+FuTScqkbST6PZAfZ0brq04+26kCkvhgG0uYii2iPDeC5MzXA@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: per-netns exclusive flowlabel checks
To:     kernel test robot <lkp@intel.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, llvm@lists.linux.dev,
        kbuild-all@lists.01.org, davem@davemloft.net, kuba@kernel.org,
        Congyu Liu <liu3101@purdue.edu>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 7:19 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Willem,
>
> Thank you for the patch! Perhaps something to improve:

>    In file included from net/sched/cls_flow.c:24:
>    In file included from include/net/ip.h:30:
>    In file included from include/net/route.h:24:
>    In file included from include/net/inetpeer.h:16:
>    include/net/ipv6.h:403:30: error: no member named 'ipv6' in 'struct net'
>                READ_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl))

I'll wrap the whole function in IS_ENABLED(CONFIG_IPV6).
fl6_sock_lookup is only called from code in .c files that are
conditional on CONFIG_IPV6.
