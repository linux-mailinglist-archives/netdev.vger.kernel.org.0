Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9440325A04
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 00:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhBYXBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 18:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhBYXBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 18:01:12 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3AACC061574
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 15:00:31 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id z7so4051292plk.7
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 15:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kxf9h4tqUsK+VxixyxuIKeqPvIe3ukAs7MJqIhaIljw=;
        b=EIHIeEjtemU9tTbuafRDsaPZaBpZRpTeE9HzxYzoK0BANlVYIT7MBzE6MLcVayPJzp
         7Qxywjf8K9Ayz4491t4Xy1lV5KTXR5X8BXblu/1D/aeQXcvTJIWPT0h+6Ozj19uPXGZ+
         gVRksniQtWHjfyRqaxW3TmSnDulGPE4QOtqHfvwuDzebAQ7JsJ8DEoC8e+R+46lJUMDP
         OzIkDvWlvijSvyI+Xrn4N9fzdIN9vf4h9vr6oQGUsMHFSHfM55DCwOCGriI1u7an5QMf
         wvykasVS3QT+cRINAQL88xHj4y3g2fSsFN6avD4+GQU4X5WJxSgVtUDNps2fiqku4gtU
         vezw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kxf9h4tqUsK+VxixyxuIKeqPvIe3ukAs7MJqIhaIljw=;
        b=jsh9mxDGl7wbAVgI458GeerG9187pROdjELBE6q4vePLu1o3wGjL5pKhOWUDn8Ah13
         rQ5VWT6NGp/Sm4T8pzouj7bm7agFFrE65xVj7i8ZAKWlnvmG+jLu2bJY4S2SnfeppORS
         DU9vcDkV1I6/zdEje7ptHE/LnVAxJY33OfQPf48ofexkjF4eEdrxHjAG21ZmkhvXCDDB
         oHeUd8kDkKu9t4oeOtEiLlG0cjgKlAz/2eEunPx1/lhXCy8CIiFeDitgD5dDOn3Wl4Rd
         E9eMZF3VQ/H6ZK2QqT3Rnne0TOx4Uu7VaaJa/CHwY241hYJDvMcxBEexuJ+RTjqJvJAR
         wsEA==
X-Gm-Message-State: AOAM530lmFoqR8/MW+Q5Mou8Im/C3SNoNlJW2PNy1ck3CyOYQBw+jum1
        CtBoNTnQfyuOrinkVVOcZFnI/dmsSaprFwJMt2X2jg==
X-Google-Smtp-Source: ABdhPJz6Ii9ETPujzxwPz7oiV4RzSQkzSeteTwFuaTbiAz44zQaEKPLe0wompjkm7asJ+IB06x45zotHTVhXN281NNs=
X-Received: by 2002:a17:902:b610:b029:e3:2b1e:34ff with SMTP id
 b16-20020a170902b610b02900e32b1e34ffmr81112pls.69.1614294031100; Thu, 25 Feb
 2021 15:00:31 -0800 (PST)
MIME-Version: 1.0
References: <20210215120345.GE2087@kadam> <33d68f94-2d20-fdc4-c572-16138aa6305b@gmail.com>
 <20210215160222.GE2222@kadam>
In-Reply-To: <20210215160222.GE2222@kadam>
From:   Arjun Roy <arjunroy@google.com>
Date:   Thu, 25 Feb 2021 15:00:20 -0800
Message-ID: <CAOFY-A250ZDuE3PgFHueLWWRP187uEXFPw78XR_O_eFzS9p-Fg@mail.gmail.com>
Subject: Re: [net-next] tcp: Sanitize CMSG flags and reserved args in tcp_zerocopy_receive.
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     David Ahern <dsahern@gmail.com>, kbuild@lists.01.org,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, lkp@intel.com,
        kbuild-all@lists.01.org, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 8:02 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Mon, Feb 15, 2021 at 08:04:11AM -0700, David Ahern wrote:
> > On 2/15/21 5:03 AM, Dan Carpenter wrote:
> > > Hi Arjun,
> > >
> > > url:    https://github.com/0day-ci/linux/commits/Arjun-Roy/tcp-Sanitize-CMSG-flags-and-reserved-args-in-tcp_zerocopy_receive/20210212-052537
> > > base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git  e4b62cf7559f2ef9a022de235e5a09a8d7ded520
> > > config: x86_64-randconfig-m001-20210209 (attached as .config)
> > > compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> > >
> > > If you fix the issue, kindly add following tag as appropriate
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > >
> > > smatch warnings:
> > > net/ipv4/tcp.c:4158 do_tcp_getsockopt() warn: check for integer overflow 'len'
> > >
> > > vim +/len +4158 net/ipv4/tcp.c
> > >
> > > 3fdadf7d27e3fb Dmitry Mishin            2006-03-20  3896  static int do_tcp_getsockopt(struct sock *sk, int level,
> > > 3fdadf7d27e3fb Dmitry Mishin            2006-03-20  3897            int optname, char __user *optval, int __user *optlen)
> > > ^1da177e4c3f41 Linus Torvalds           2005-04-16  3898  {
> > > 295f7324ff8d9e Arnaldo Carvalho de Melo 2005-08-09  3899    struct inet_connection_sock *icsk = inet_csk(sk);
> > > ^1da177e4c3f41 Linus Torvalds           2005-04-16  3900    struct tcp_sock *tp = tcp_sk(sk);
> > > 6fa251663069e0 Nikolay Borisov          2016-02-03  3901    struct net *net = sock_net(sk);
> > > ^1da177e4c3f41 Linus Torvalds           2005-04-16  3902    int val, len;
> > >
> > > "len" is int.
> > >
> > > [ snip ]
> > > 05255b823a6173 Eric Dumazet             2018-04-27  4146  #ifdef CONFIG_MMU
> > > 05255b823a6173 Eric Dumazet             2018-04-27  4147    case TCP_ZEROCOPY_RECEIVE: {
> > > 7eeba1706eba6d Arjun Roy                2021-01-20  4148            struct scm_timestamping_internal tss;
> > > e0fecb289ad3fd Arjun Roy                2020-12-10  4149            struct tcp_zerocopy_receive zc = {};
> > > 05255b823a6173 Eric Dumazet             2018-04-27  4150            int err;
> > > 05255b823a6173 Eric Dumazet             2018-04-27  4151
> > > 05255b823a6173 Eric Dumazet             2018-04-27  4152            if (get_user(len, optlen))
> > > 05255b823a6173 Eric Dumazet             2018-04-27  4153                    return -EFAULT;
> > > c8856c05145490 Arjun Roy                2020-02-14  4154            if (len < offsetofend(struct tcp_zerocopy_receive, length))
> > > 05255b823a6173 Eric Dumazet             2018-04-27  4155                    return -EINVAL;
> > >
> > >
> > > The problem is that negative values of "len" are type promoted to high
> > > positive values.  So the fix is to write this as:
> > >
> > >     if (len < 0 || len < offsetofend(struct tcp_zerocopy_receive, length))
> > >             return -EINVAL;
> > >
> > > 110912bdf28392 Arjun Roy                2021-02-11  4156            if (unlikely(len > sizeof(zc))) {
> > > 110912bdf28392 Arjun Roy                2021-02-11  4157                    err = check_zeroed_user(optval + sizeof(zc),
> > > 110912bdf28392 Arjun Roy                2021-02-11 @4158                                            len - sizeof(zc));
> > >                                                                                                         ^^^^^^^^^^^^^^^^
> > > Potentially "len - a negative value".
> > >
> > >
> >
> > get_user(len, optlen) is called multiple times in that function. len < 0
> > was checked after the first one at the top.
> >
>
> What you're describing is a "Double Fetch" bug, where the attack is we
> get some data from the user, and we verify it, then we get it from the
> user a second time and trust it.  The problem is that the user modifies
> it between the first and second get_user() call so it ends up being a
> security vulnerability.
>
> But I'm glad you pointed out the first get_user() because it has an
> ancient, harmless pre git bug in it.
>
> net/ipv4/tcp.c
>   3888  static int do_tcp_getsockopt(struct sock *sk, int level,
>   3889                  int optname, char __user *optval, int __user *optlen)
>   3890  {
>   3891          struct inet_connection_sock *icsk = inet_csk(sk);
>   3892          struct tcp_sock *tp = tcp_sk(sk);
>   3893          struct net *net = sock_net(sk);
>   3894          int val, len;
>   3895
>   3896          if (get_user(len, optlen))
>   3897                  return -EFAULT;
>   3898
>   3899          len = min_t(unsigned int, len, sizeof(int));
>   3900
>   3901          if (len < 0)
>                     ^^^^^^^
> This is impossible.  "len" has to be in the 0-4 range because of the
> min_t() assignment.  It's harmless though and the condition should just
> be removed.
>
>   3902                  return -EINVAL;
>   3903
>   3904          switch (optname) {
>   3905          case TCP_MAXSEG:
>
> Anyway, I will create a new Smatch warning for this situation.
>
> > Also, maybe I am missing something here, but offsetofend can not return
> > a negative value, so this checks catches len < 0 as well:
> >
> >       if (len < offsetofend(struct tcp_zerocopy_receive, length))
> >               return -EINVAL;
> >
>
> offsetofend is (unsigned long)12.  If we compare a negative integer with
> (unsigned long)12 then negative number is type promoted to a high
> positive value.
>
>         if (-1 < (usigned long)12)
>                 printf("dan is wrong\n");
>
> regards,
> dan carpenter
>
>
Thank you for the catch. I will send out a fix momentarily.

Actually, now I'm curious - why does do_tcp_getsockopt get called so
many times, per getsockopt target - rather than just using the
originally read value?

-Arjun
