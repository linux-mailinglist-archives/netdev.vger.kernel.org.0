Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39AF56265D3
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 01:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiKLAKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 19:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbiKLAKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 19:10:41 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AFB13F5E
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 16:10:38 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id r3so7489044yba.5
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 16:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fdrQvQlOWJwIL1OF472J6xVUPdWj669bW3nbDh+Epjs=;
        b=BUxtyFxgJFO/zdooBLACb7F1+0jn7gdZhnzgAeVNlm8GnbC7VAlWWHysJEs8AG+wUK
         EaUeLhv9ZQ2H1TkOw8GHfRsUfWK+yGHfKUWrLF/mZhbfULKZRLWmgXgboe/v13H8LPA7
         Y3lH5inNqlZDKRgU5pfWPhoV9ar8oRK+4kSimmq3onkueWCXHlMZlALDGyjp73MrLep1
         jLOolGAlcndNK9YsJRFYYLen++nSKW4uwpagVpwPsbJqLgmkCxV4Jf+0lrMGGjfrjkQA
         MBp84LRg8ZCuLPn1urBAXdXTmjEw5whXzHgiooV2lj++YCR98wD2J1oj0Sopcy0BCTew
         5GAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fdrQvQlOWJwIL1OF472J6xVUPdWj669bW3nbDh+Epjs=;
        b=ngZlD2ROozd12GnhGt4w+viENApnUH0X5bUZ2bMkxkuQO2QX8QCq156cppkSyinyUF
         7J4tJHNjbi1C4qbuXOaBaf0yHtjWferm0SrJctOOfRM51Dq78iQVuuDKdE9IxTfhacDJ
         /Vm8wSU7wDdMVBO4cishZVDFfnTV1Il0X+a3NP3SWIPOrLFCMLJVl4ehK4AdErcNXeWt
         wBaDL5ldsNIBBuL6rwwuDcCFnJhZDRxQ7aLai7WnJWs5TdzeMeP4HidjS9yj7Fa32q5y
         629BE3CHI7qrdpPK/jpb72aW3e4h6+fLogTIlFL4Ddw+5Y7YDf8sG9SFDLgK8D2IYjm6
         MrCQ==
X-Gm-Message-State: ANoB5pnxpQBaCL/ujaoZT2LRUU0zpax35hL4Lu6HVgqard29vmatug68
        1mIfQceaPqN0+o+tcQwyhbCSA/UZFR8xkRi/5qLK2g==
X-Google-Smtp-Source: AA0mqf4BIYFv6xKCGx6CPnsAqydq7fWNbBz2TfpXCZoUE1QzUGze6zLS4kMwvn6bVWyWBSqqu8Lg0KoEjbpUT8mQt4U=
X-Received: by 2002:a05:6902:4aa:b0:6cb:ec87:a425 with SMTP id
 r10-20020a05690204aa00b006cbec87a425mr3562451ybs.387.1668211837901; Fri, 11
 Nov 2022 16:10:37 -0800 (PST)
MIME-Version: 1.0
References: <7ccd58e8e26bcdd82e66993cbd53ff59eebe3949.1668139105.git.jamie.bainbridge@gmail.com>
 <20221111092047.7d33bcd3@hermes.local> <CAAvyFNhkn2Zv16RMWGCtQh4SpjJX56q8gyEL3Mz6Ru+Ef=SJfA@mail.gmail.com>
In-Reply-To: <CAAvyFNhkn2Zv16RMWGCtQh4SpjJX56q8gyEL3Mz6Ru+Ef=SJfA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 11 Nov 2022 16:10:26 -0800
Message-ID: <CANn89i+TWNjZ3taWxOtPd2iXC6tJNwNJ2psQ+tarwOKY+BFmog@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: Add listening address to SYN flood message
To:     Jamie Bainbridge <jamie.bainbridge@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Fri, Nov 11, 2022 at 4:00 PM Jamie Bainbridge
<jamie.bainbridge@gmail.com> wrote:
>
> On Sat, 12 Nov 2022 at 04:20, Stephen Hemminger
> <stephen@networkplumber.org> wrote:
> >
> > On Fri, 11 Nov 2022 14:59:32 +1100
> > Jamie Bainbridge <jamie.bainbridge@gmail.com> wrote:
> >
> > > +         xchg(&queue->synflood_warned, 1) == 0) {
> > > +             if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
> > > +                     net_info_ratelimited("%s: Possible SYN flooding on port %pI6c.%u. %s.\n",
> > > +                                     proto, &sk->sk_v6_rcv_saddr,
> > > +                                     sk->sk_num, msg);
> > > +             } else {
> > > +                     net_info_ratelimited("%s: Possible SYN flooding on port %pI4.%u. %s.\n",
> > > +                                     proto, &sk->sk_rcv_saddr,
> > > +                                     sk->sk_num, msg);
> >
> > Minor nit, the standard format for printing addresses would be to use colon seperator before port
> >
> >                 if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
> >                         net_info_ratelimited("%s: Possible SYN flooding on [%pI6c]:%u. %s.\n",
> >                                         proto, &sk->sk_v6_rcv_saddr, sk->sk_num, msg);
> >                 } else {
> >                         net_info_ratelimited("%s: Possible SYN flooding on %pI4:%u. %s.\n",
> >                                         proto, &sk->sk_rcv_saddr, sk->sk_num, msg);
>
> I considered this too, though Eric suggested "IP.port" to match tcpdump.
>
> Please let me know which advice to follow?

IPv6 [address]:port is also a standard (and unambiguous) way.

https://www.rfc-editor.org/rfc/rfc5952#page-11
