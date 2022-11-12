Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293496265E2
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 01:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbiKLAOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 19:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234466AbiKLAOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 19:14:52 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EE213D56
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 16:14:51 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-368edbc2c18so57291767b3.13
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 16:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XDKvgE4abL1LNK9A1vR3QS/HEotmvgeQVhtEiU4bCpY=;
        b=o6ahKW4br5rBqjawkN84i9PyQeZlyu4NDHLMtdwIPBWpPNLZfcPQSzl9zHBZxKkH81
         9lFc4rMiP0/pWx5541rX0cQJRhUOsOzpK0Gb+roLXJ2nTnL8adQhupsW/hSRSDluKq3W
         Yw9putnEghIkFnwKHFEW7mZKWKfGYe7prfAjyXIUOVD9GOL+zs9byQ8vsPQBnIX0LHEx
         bhQ2Iv81MRNwFXXV8kE2/oRqzIg6mScJcbYaD5+4gqgUSbRjQ1D6qE+lRPW5goOQPr9Q
         rAmPGG+FdxOQvJM10qGCOki/l2sYW3PS+Pvtrxd0dWWlQ9nCpU6c0L9mmW+VLNL+UQo0
         wTLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XDKvgE4abL1LNK9A1vR3QS/HEotmvgeQVhtEiU4bCpY=;
        b=AFUdAlBcIsMos+rQPfHZX7shRfesh7a6Bued1RhEsmQM65i8Psp132jZBgJ5EzRuIA
         I9B56QuR0FgL3DSnEAe5Lkw3LNnNOScKby/N0Cgvuk7zyaZTg7tamdRDFHTHsygs5xIT
         KYphCeALcYaSgp3XJOjhzhXnalkqSOk1DWQFHyFgvGvgFmxlNPmx/BsgTGUfsOyPBj3w
         6pNIMQfU1VtGnMGZULmmoD5B2wkGRkagaMGJIj0yTTz2pItX80Kc1nuBvBp22m7+zB+M
         t7M5aWIUYfEKo1VRncXXWLz16FZDjcrQgSjlU8DSm7p7JQefpY4I+CH6iYB2QtGErqwH
         rc6A==
X-Gm-Message-State: ANoB5pm1QU35ZBGS0RXuKldC6u7ZRpwsRCnEoPa+e5yuhpb7KaltT2sw
        k6Oo7Zu5zh7jWiEGdO7nk/MfVcLiuIOUvfQylkB6Hg==
X-Google-Smtp-Source: AA0mqf6Y1guw19vg5V2gqWzMKChfMxZE3PEX1iRQHR48hbaUSEi1YGTVOhtxDfY/nSox9kf8fKhXQ4Kl4UBEJjZBvkU=
X-Received: by 2002:a81:254a:0:b0:36c:aaa6:e571 with SMTP id
 l71-20020a81254a000000b0036caaa6e571mr4171152ywl.467.1668212090749; Fri, 11
 Nov 2022 16:14:50 -0800 (PST)
MIME-Version: 1.0
References: <7ccd58e8e26bcdd82e66993cbd53ff59eebe3949.1668139105.git.jamie.bainbridge@gmail.com>
 <20221111092047.7d33bcd3@hermes.local> <CAAvyFNhkn2Zv16RMWGCtQh4SpjJX56q8gyEL3Mz6Ru+Ef=SJfA@mail.gmail.com>
 <20221111161120.770b9db2@hermes.local>
In-Reply-To: <20221111161120.770b9db2@hermes.local>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 11 Nov 2022 16:14:39 -0800
Message-ID: <CANn89i+sj9w+W3Mx-UsmaWzq_GcLwr=FQkHC61_2eBbvpVQQ1g@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: Add listening address to SYN flood message
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jamie Bainbridge <jamie.bainbridge@gmail.com>,
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

On Fri, Nov 11, 2022 at 4:11 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Sat, 12 Nov 2022 10:59:52 +1100
> Jamie Bainbridge <jamie.bainbridge@gmail.com> wrote:
>
> > On Sat, 12 Nov 2022 at 04:20, Stephen Hemminger
> > <stephen@networkplumber.org> wrote:
> > >
> > > On Fri, 11 Nov 2022 14:59:32 +1100
> > > Jamie Bainbridge <jamie.bainbridge@gmail.com> wrote:
> > >
> > > > +         xchg(&queue->synflood_warned, 1) == 0) {
> > > > +             if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
> > > > +                     net_info_ratelimited("%s: Possible SYN flooding on port %pI6c.%u. %s.\n",
> > > > +                                     proto, &sk->sk_v6_rcv_saddr,
> > > > +                                     sk->sk_num, msg);
> > > > +             } else {
> > > > +                     net_info_ratelimited("%s: Possible SYN flooding on port %pI4.%u. %s.\n",
> > > > +                                     proto, &sk->sk_rcv_saddr,
> > > > +                                     sk->sk_num, msg);
> > >
> > > Minor nit, the standard format for printing addresses would be to use colon seperator before port
> > >
> > >                 if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
> > >                         net_info_ratelimited("%s: Possible SYN flooding on [%pI6c]:%u. %s.\n",
> > >                                         proto, &sk->sk_v6_rcv_saddr, sk->sk_num, msg);
> > >                 } else {
> > >                         net_info_ratelimited("%s: Possible SYN flooding on %pI4:%u. %s.\n",
> > >                                         proto, &sk->sk_rcv_saddr, sk->sk_num, msg);
> >
> > I considered this too, though Eric suggested "IP.port" to match tcpdump.
>
> That works, if it happens I doubt it matters.

Note that "ss dst" really needs the [] notation for IPv6

ss -t dst "[::1]"
State                  Recv-Q             Send-Q
    Local Address:Port                            Peer Address:Port
         Process
CLOSE-WAIT             1                  0
            [::1]:50584                                  [::1]:ipp

So we have inconsistency anyway...

As you said, no strong opinion.
