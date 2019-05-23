Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7BC028CB7
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388372AbfEWVxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:53:32 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36945 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387709AbfEWVxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 17:53:31 -0400
Received: by mail-ed1-f66.google.com with SMTP id w37so11291885edw.4;
        Thu, 23 May 2019 14:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VhQSjUZmgcEW8XYx/F0uZNmJ222g1uNFRqG0lEK0f4k=;
        b=NqB8pFlGZ7gHJ3UNbEmaDyLrJE5Xg6/abm2vfrRKeelpjhlPWdVpyrtyo4RwOia5ov
         TJpAr1DdbC6g0Lfz8WRL7QsuQXSVj/OsIDCVi+orIY2kmLs9nqUnDe73oGgdpvKNPYvB
         UvdzPfTV/tNQzOsvTWiK0lfREtgxexqT9e/K16p5dXF7MgbZM3oi03ydnlgLZeD5mrv9
         YehoCjivnVIQUhmMv9gxvveTajMFULhHSZOVYckKQW7JImYDiw3WAZl2Ez0p7z9LtTVF
         7n72mb5P8/5aqZKi+4nspkXWSRUbnrzwPsw37vNEA0gWuGO0qlkgInc7yltIUc9r8S7c
         xKog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VhQSjUZmgcEW8XYx/F0uZNmJ222g1uNFRqG0lEK0f4k=;
        b=jrwQ4p47ky5R3lVUTXc7oliHSAn3Xl8QwBUghfsH8cKHgfOAREsORbcXaQH8157FkO
         6ZLfoFpIO5K9UHIfJzWCtKRiGLYA/n7WUKznPCWpAaH+dkSn2/2nOoqKapjvyBodtBBT
         YbaJZ4ZAmemnWWvr+tcLQWvx19kaQt2e178PxB2n0XFwrdApqjhKqoKbvdMHLKU66LTS
         7/Za/ivTt/p4Dy7Nskt3k83qR1WyEk1e7c0Cd93G1To5qBnUrcWZpuRsrFGyAx1prhV4
         XPyJBdjzFjKDAWfoJNiRSOa6bm4Nbdwzg+fnW5aYPRdWpGMhMtLIkzt0JdnD6ex1iH3O
         s8FA==
X-Gm-Message-State: APjAAAVEdxJeoB3V9B+pLkJlPluOzQyUgk/4IIUnITg/5JRNOOeP2+oi
        Ycut9qqTjzAcyNSORUmumYGK4SMBE+6/tD8rsqk=
X-Google-Smtp-Source: APXvYqzhCQlNbnJ+1k7klU9fj1/nA1jkZp3jFI//dEQT9LK/W/F+VxpnvtrMXP4S9Q81xRNKX52jGaJpekRtRqFneks=
X-Received: by 2002:a17:906:6a97:: with SMTP id p23mr26581568ejr.203.1558648409785;
 Thu, 23 May 2019 14:53:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190523210651.80902-1-fklassen@appneta.com> <20190523210651.80902-3-fklassen@appneta.com>
In-Reply-To: <20190523210651.80902-3-fklassen@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 23 May 2019 17:52:53 -0400
Message-ID: <CAF=yD-JBf6k7VLa6FQowuD5xDFbq5cB4ScTi7kb1hieQFDKnbg@mail.gmail.com>
Subject: Re: [PATCH net 2/4] net/udpgso_bench_tx: options to exercise TX CMSG
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 5:11 PM Fred Klassen <fklassen@appneta.com> wrote:
>
> This enhancement adds options that facilitate load testing with
> additional TX CMSG options, and to optionally print results of
> various send CMSG operations.
>
> These options are especially useful in isolating situations
> where error-queue messages are lost when combined with other
> CMSG operations (e.g. SO_ZEROCOPY).
>
> New options:
>
>     -T - add TX CMSG that requests TX software timestamps
>     -H - similar to -T except request TX hardware timestamps
>     -q - add IP_TOS/IPV6_TCLASS TX CMSG

To ensure that we do not regress, when adding options, please consider
(just a general suggestion, not a strong request for this patch set)
updating the kselftest to run a variant of the test with the new code
coverage. In this case, make the code pass/fail instead of only user
interpretable and add variants to udpgso.sh.

>     -P - call poll() before reading error queue
>     -v - print detailed results
>
> Fixes: 3a687bef148d ("selftests: udp gso benchmark")
> Signed-off-by: Fred Klassen <fklassen@appneta.com>

> +static void flush_errqueue_recv(int fd)
>  {
>         struct msghdr msg = {0};        /* flush */
> +       struct cmsghdr *cmsg;
> +       struct iovec entry;
> +       char control[1024];

can use more precise CMSG_SPACE based on worst case expectations, like
in udp_sendmmsg

> +       char buf[1500];

no need for payload

> +static void flush_errqueue(int fd)
> +{
> +       if (cfg_poll) {
> +               struct pollfd fds = { 0 };
> +               int ret;
> +
> +               fds.fd = fd;
> +               fds.events = POLLERR;

no need to pass POLLERR, it is always returned in revents.
