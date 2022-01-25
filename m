Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C078449B622
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 15:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1578848AbiAYOVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 09:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1578286AbiAYORt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 09:17:49 -0500
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D98C061751
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 06:17:49 -0800 (PST)
Received: by mail-ua1-x92f.google.com with SMTP id b37so19938611uad.12
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 06:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K9qNYEguOKx8AbCzHGgE3pgKrH/csc5za8weZ+n8ZZg=;
        b=LS7D4KNsPJm+YayCIFnCNcWjxylNoNw76n+xa/aqD7ItWtHSu1WRHB9yIn8y3TUNPA
         dEYVHfrxQ7mzWI0eYoamdm7KWjxJQS2JrVak6Mwqcel5fZ3CS4x2AAXnjjZsRrP212CQ
         WApKf2bqXjzUdlba0CtSBhB0NgDGnChhkJMIwEif33CGe3FYZX2uK+2loylJPwHFCAfI
         +cFAVegIQ6WWXh9I5v2nwTzMdOv2f+9BrYEqmF8QMi3MFBFrYE6+TgzYs+dzxVVllnab
         /owNzn5URyT6TyiaPMPf64C6dLSPcz5PHCZlTKW9NjL/eIF5QYSfDCOyD1nY0nthq9eR
         kx5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K9qNYEguOKx8AbCzHGgE3pgKrH/csc5za8weZ+n8ZZg=;
        b=GrOWLyz/mq5Me6pTQnDeQYTem10ooKwdigIbiArjuzdlL8IyOuJuaGWDUt/utt8Pla
         wwlrzR/X/294zBiy6pyEBOSDN/sKYyeYINJMC3iHVgOqIxbx3sIkwNKF8uzu+MIyByTf
         Q9gSG8WDReap1hNC1fFUf2Z+TcwwoXeJBGr9Q41OYDJ+vt0NI+epMEcubeYPiXw9zRzF
         3+ZPbNbFPlM4kGr2vMhzUHDn9kdew/qNB8sRyQZKCNLG5n80IBQc0pIRfWhtzctWQjAR
         MvG/lfi1b56MsyX3NefMWywwqYkKQEwFfry8UJkUW7IIl/79qzQzXax4tRKEZqH2+ZNC
         tjOg==
X-Gm-Message-State: AOAM531m6FRKH+zTxPgE7xCjAPnw5BgJcnOnV9UaCtSj+QppqABKPJgW
        RzW5RCKY5cX81ePvORw8fnYG3a4GzfQ=
X-Google-Smtp-Source: ABdhPJxhFB07YMUlS9xGfVQmApci1YeT1OiqNYh5q0XSOucDd+eiFFcTQue4e+zPiXA3kjjTIpyHCw==
X-Received: by 2002:a9f:3f88:: with SMTP id k8mr7654883uaj.76.1643120268390;
        Tue, 25 Jan 2022 06:17:48 -0800 (PST)
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com. [209.85.222.52])
        by smtp.gmail.com with ESMTPSA id g25sm501743vsj.6.2022.01.25.06.17.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 06:17:47 -0800 (PST)
Received: by mail-ua1-f52.google.com with SMTP id b37so19938466uad.12
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 06:17:46 -0800 (PST)
X-Received: by 2002:a67:d389:: with SMTP id b9mr4563384vsj.79.1643120266518;
 Tue, 25 Jan 2022 06:17:46 -0800 (PST)
MIME-Version: 1.0
References: <20220124080215.265538-1-konstantin.meskhidze@huawei.com> <20220124080215.265538-2-konstantin.meskhidze@huawei.com>
In-Reply-To: <20220124080215.265538-2-konstantin.meskhidze@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 25 Jan 2022 09:17:10 -0500
X-Gmail-Original-Message-ID: <CA+FuTSf4EjgjBCCOiu-PHJcTMia41UkTh8QJ0+qdxL_J8445EA@mail.gmail.com>
Message-ID: <CA+FuTSf4EjgjBCCOiu-PHJcTMia41UkTh8QJ0+qdxL_J8445EA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] landlock: TCP network hooks implementation
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     mic@digikod.net, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, netfilter@vger.kernel.org,
        yusongping@huawei.com, artem.kuzin@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 3:02 AM Konstantin Meskhidze
<konstantin.meskhidze@huawei.com> wrote:
>
> Support of socket_bind() and socket_connect() hooks.
> Current prototype can restrict binding and connecting of TCP
> types of sockets. Its just basic idea how Landlock could support
> network confinement.
>
> Changes:
> 1. Access masks array refactored into 1D one and changed
> to 32 bits. Filesystem masks occupy 16 lower bits and network
> masks reside in 16 upper bits.
> 2. Refactor API functions in ruleset.c:
>     1. Add void *object argument.
>     2. Add u16 rule_type argument.
> 3. Use two rb_trees in ruleset structure:
>     1. root_inode - for filesystem objects
>     2. root_net_port - for network port objects
>
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>

> +static int hook_socket_connect(struct socket *sock, struct sockaddr *address, int addrlen)
> +{
> +       short socket_type;
> +       struct sockaddr_in *sockaddr;
> +       u16 port;
> +       const struct landlock_ruleset *const dom = landlock_get_current_domain();
> +
> +       /* Check if the hook is AF_INET* socket's action */
> +       if ((address->sa_family != AF_INET) && (address->sa_family != AF_INET6))
> +               return 0;

Should this be a check on the socket family (sock->ops->family)
instead of the address family?

It is valid to pass an address with AF_UNSPEC to a PF_INET(6) socket.
And there are legitimate reasons to want to deny this. Such as passing
a connection to a unprivileged process and disallow it from disconnect
and opening a different new connection.

> +
> +       socket_type = sock->type;
> +       /* Check if it's a TCP socket */
> +       if (socket_type != SOCK_STREAM)
> +               return 0;
> +
> +       if (!dom)
> +               return 0;
> +
> +       /* Get port value in host byte order */
> +       sockaddr = (struct sockaddr_in *)address;
> +       port = ntohs(sockaddr->sin_port);
> +
> +       return check_socket_access(dom, port, LANDLOCK_ACCESS_NET_CONNECT_TCP);
> +}
