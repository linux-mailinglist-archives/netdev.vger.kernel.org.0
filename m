Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C359C6A1205
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 22:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjBWVaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 16:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjBWVaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 16:30:12 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE863515FB
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 13:30:09 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-536bbef1c5eso225331797b3.9
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 13:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4BG68yXM18nFMzuEzbEzhZY3lfpTIMaOZoRW5LPn/4U=;
        b=XAWHipEydWosQe7fBGUUK9UuovN2s9ZKRyuQW/oaNSj0SWXsr6WzXFeVbbDIoqQikJ
         Pe71LIcOsrYOTfPNrHcLux7Ma3XOTFPj4C1MRUY6twF2ryGEkv6zyLpYuaV99Z4OcHkE
         pBul/hMpDr/QRJei3RUd9fKo+m2or4ifdc7w6JUA7CJKMJbgtkep8KNSFAIKB+Hl4FYO
         KQxaSLBFYycFnLaTStcZDsoJDlT00DB43TPnBxAS3A06ifUG099brQcEFc1eo3WcnZvN
         gJNSO3DucWmpIFeywBFiivezFuwKM7ErozjmwEakq+OFqBjxBN7+WLRf6xvx6YmN/Giw
         KeNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4BG68yXM18nFMzuEzbEzhZY3lfpTIMaOZoRW5LPn/4U=;
        b=DCyAXrYawk9tvWisAghWjP2DN3WoeYo1gmAbY/m8wl9CGHKagjqgWh3HXNyBb2KlYh
         029KQc7uqalKk04PNNQ7UiMT6oXoBeaiFfK6xHkz9Sda6U2Wdd7ZIQXnlOwVVt61hr3U
         nNW1H9QOXhxtQTJ1Ql8T/yMwfQGv7KahL4NOzosE0z/09EcbZr7hJKl977RHcCB+BAvs
         JslRxHXAk4iC+qoMORYAkvNYFtnl+/jEgI/iG4KtoF7fMBVlcVGGD2bpMxzoqoNgNmIx
         Sy9le916JibJMHleyTjIjJr0KsgPA3H9a3gG80B0k+0TISXnaL+IxgFuyYW0VbGYLXV9
         ocfQ==
X-Gm-Message-State: AO0yUKUn3bnT6ij1PvZWVXwGB4OZcDaSizCxpNdQBQKk/hzIqBeztg8V
        Wb0XUmjYT2VKBmKUclEjBQOSs6YemGTFnMKKxHl9Fejilp24/GXRD7+RPQ==
X-Google-Smtp-Source: AK7set8l+TkygtQKb7Ixt4MGhRzD9YVKljUVzE98UjYgby3O4tm9YSA8eAfzUYY0kMgJlyCSQrnXMA9FedWkysuvO1I=
X-Received: by 2002:a05:6902:1143:b0:90d:a6c0:6870 with SMTP id
 p3-20020a056902114300b0090da6c06870mr4442145ybu.2.1677187808837; Thu, 23 Feb
 2023 13:30:08 -0800 (PST)
MIME-Version: 1.0
References: <20230222192925.1778183-1-edliaw@google.com> <20230222192925.1778183-2-edliaw@google.com>
 <Y/crdG+quVvKMF0m@kroah.com> <CAG4es9Wa+PxomxmK348O8nxfXny8jo=9kqQ0KOYgQq82gTNeaQ@mail.gmail.com>
 <Y/fICk4NYFEF9EoS@kroah.com>
In-Reply-To: <Y/fICk4NYFEF9EoS@kroah.com>
From:   Edward Liaw <edliaw@google.com>
Date:   Thu, 23 Feb 2023 13:29:42 -0800
Message-ID: <CAG4es9WoVhTEGLmokfXA8YaJC+nWBOicFKpuePbidtm9cd0c2g@mail.gmail.com>
Subject: Re: [PATCH 4.14 v2 1/4] bpf: Do not use ax register in interpreter on div/mod
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, bpf@vger.kernel.org,
        kernel-team <kernel-team@android.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, Feb 23, 2023 at 10:46:50AM -0800, Edward Liaw wrote:
> > > What is the git commit id in Linus's tree of this commit?
> >
> > Hi Greg,
> > It is a partial revert of 144cd91c4c2bced6eb8a7e25e590f6618a11e854.
>
> Please document that in the changelog text very very well when you
> resend this.

Sorry, I made a mistake.  The original commit was made to 4.19.y with
commit id c348d806ed1d3075af52345344243824d72c4945.
