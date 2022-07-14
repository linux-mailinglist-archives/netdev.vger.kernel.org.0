Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30F9575600
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 21:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240758AbiGNTtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 15:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240729AbiGNTts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 15:49:48 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF86F101D1
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 12:49:45 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id y4so3770178edc.4
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 12:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/jNeMx3p2bq8iOjtc1prT9uw6kQU6kEL+D5PYhdBgeU=;
        b=iyx7LJkvTMnh0wjcxXWCL5Vn3fIyTAYtVfVQ4TKcaKx7XkNZTe6J6aDYOlvur/brpm
         6OgEmU4hx9gaMuCn3nd/ZjLTQaw06YQ0sl7Ha3xvfvw4lcfzktclCJRT5YFFOV+GYALM
         jSklOwJ81vnuHbCdac4fvzuUJ1JabjCG4//uILRcAknau55pC3Zw+JXI0sVKbFs/E69w
         dkkz+k4L3ldgaYxBFFvhGEkRsae/4gXGLNhVThTP2icDTm8m9dyJWcIdCxygQ2vuygD6
         VCKNmYBF+UlCjGr3VvxKSpZ40kzV9lnqulAFRFhm8artlo9llAPVaR4eE/EZ7563Uywx
         CBaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/jNeMx3p2bq8iOjtc1prT9uw6kQU6kEL+D5PYhdBgeU=;
        b=bHLnRgy12BQ/xs83eROpbrb1kxGQlAZGU7u6Rv13ii75L7AjtTm9wClptm2kO8Ll5T
         27hYqP57+I/RC2Q8RYGo0pbR3CrSUDhmw2mq+FNFhNGp3Zcu3Se4BWrgmAh8HtpHH78W
         nDuohmEcRXqQoRJ8X0IeUAr/mVp3WUc18FY5tkJ5/WxCr8ml6gts+QcO2YwWvxEuetyF
         QXE64YyaXFD0GkQ44qq29Gk2S+nkw+G6RWzzMUdjukUlvecs+QvK/pf5r/YJIBMwcXlr
         gs0F1GU1jXfok+PANCfO/3UvHTRowJP1qFv7Cl+B5s15lS9jrmgHaitukyZ7FMXr/SkU
         Ie2A==
X-Gm-Message-State: AJIora9Cug0DHPbF98aTk8dk1QtJbwpR3FgfdTdAYX9L72SvOcUJN0Dq
        p+BiaUn3ZZbkcT7Lv6dAP8ZETzIsRw9GFvJsO3E=
X-Google-Smtp-Source: AGRyM1uXPn1rYGETl86rp/eS+fuWIwsrZCW6UHhyMKGbdbc/Mmeq5QBY8n1fEgc3L/uCKClPdhIXWnQoGGz4jfCJ+Rg=
X-Received: by 2002:a05:6402:28c4:b0:43a:cdde:e047 with SMTP id
 ef4-20020a05640228c400b0043acddee047mr2818337edb.368.1657828184526; Thu, 14
 Jul 2022 12:49:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220712235310.1935121-1-joannelkoong@gmail.com>
 <20220712235310.1935121-4-joannelkoong@gmail.com> <e2d28352a6c00db7c3b31d0b9aeca3ee5b196247.camel@redhat.com>
In-Reply-To: <e2d28352a6c00db7c3b31d0b9aeca3ee5b196247.camel@redhat.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Thu, 14 Jul 2022 12:49:33 -0700
Message-ID: <CAJnrk1a68UtQs7gsAGPk5NfGcXPKonHZCscrvjsFOBz5g6+cBg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] selftests/net: Add sk_bind_sendto_listen test
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
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

On Thu, Jul 14, 2022 at 2:19 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2022-07-12 at 16:53 -0700, Joanne Koong wrote:
> > This patch adds a new test called sk_bind_sendto_listen.
> >
> > This test exercises the path where a socket's rcv saddr changes after it
> > has been added to the binding tables, and then a listen() on the socket
> > is invoked. The listen() should succeed.
> >
> > This test is copied over from one of syzbot's tests:
> > https://syzkaller.appspot.com/x/repro.c?x=1673a38df00000
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  tools/testing/selftests/net/.gitignore        |  1 +
> >  tools/testing/selftests/net/Makefile          |  1 +
> >  .../selftests/net/sk_bind_sendto_listen.c     | 80 +++++++++++++++++++
> >  3 files changed, 82 insertions(+)
> >  create mode 100644 tools/testing/selftests/net/sk_bind_sendto_listen.c
> >
> > diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
> > index 5b1adf6e29ae..5fd74a1162cc 100644
> > --- a/tools/testing/selftests/net/.gitignore
> > +++ b/tools/testing/selftests/net/.gitignore
> > @@ -39,3 +39,4 @@ toeplitz
> >  cmsg_sender
> >  unix_connect
> >  bind_bhash
> > +sk_bind_sendto_listen
> > diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
> > index e678fc3030a2..ffcc472d50d5 100644
> > --- a/tools/testing/selftests/net/Makefile
> > +++ b/tools/testing/selftests/net/Makefile
> > @@ -61,6 +61,7 @@ TEST_GEN_FILES += cmsg_sender
> >  TEST_GEN_FILES += stress_reuseport_listen
> >  TEST_PROGS += test_vxlan_vnifiltering.sh
> >  TEST_GEN_FILES += bind_bhash
> > +TEST_GEN_FILES += sk_bind_sendto_listen
>
> It looks like this is never invoked by the self-tests ?!? you should
> likely update bind_bhash.sh to run the new program.

Oh, I see. I didn't realize the net selftests should get invoked
automatically. Sorry about that.
I will add a "TEST_GEN_PROGS += sk_bind_sendto_listen" line to the
Makefile instead of adding it to bind_bhash.sh since the bhash setup
is not required for running ./sk_bind_sendto_listen. Thanks!

>
> Thanks!
>
> Paolo
>
