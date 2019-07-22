Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC0F6FEC6
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 13:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbfGVLfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 07:35:06 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38285 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728824AbfGVLfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 07:35:05 -0400
Received: by mail-qk1-f194.google.com with SMTP id a27so28299579qkk.5;
        Mon, 22 Jul 2019 04:35:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L01qCkz8R2xosfyuEZvp1ctsvHkk0ZS7YXCL1fbHTTg=;
        b=V1xDSGptsNrwk6a8CB9xAxQJOKSDbpUeYEDDId/RmKPnCpn7dzP2n5AYEed6GxEHvE
         V9+J3BclTiHr/ztPgCUQxrCfb9gm+qCFMQ6mGlaUesqePuEu49l/SPGK+GkZP0abE3CE
         BgmePsM1YMRIluOue31ZeUkYPPucZrQJcOVbozhLod9WeOY+Zm1zy9hk6fUz/I1y2pgu
         nS0SGgHNwNHuaUKCd9bopZatU2Dxjr/A1JGxggaHyxoG4oQ9V4PGwScSCzPu/iYQkhP6
         3Z+OR0JdUthnErx8/Oa/YvarAwegdP5VrIsA1dZWJrhBTzWjvOAQLMJgwzQYqhL06Dwu
         XBAw==
X-Gm-Message-State: APjAAAW/FSLcFxK1tRNoWxUwVm0gX7PqIGSF44rpYMw+5JO8DLT9sscF
        613t+h7XWRLwTkuChxRcQ6DcspXav9bai5DyjDNSmF5N
X-Google-Smtp-Source: APXvYqwRV3AHra+9bgdoKzmcZiOOOQxgoLcbky0BTTL3fo7ZF95gQIxNo++LmeKMMuuvz8KOxwtMm3o9h+tRgxz0bGg=
X-Received: by 2002:a37:4ac3:: with SMTP id x186mr44586497qka.138.1563795304533;
 Mon, 22 Jul 2019 04:35:04 -0700 (PDT)
MIME-Version: 1.0
References: <87ftmys3un.fsf@oldenburg2.str.redhat.com>
In-Reply-To: <87ftmys3un.fsf@oldenburg2.str.redhat.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 22 Jul 2019 13:34:48 +0200
Message-ID: <CAK8P3a0hC4wvjwCi4=DCET3C4qARMY6c58ffjwG3b1ZPM6kr-A@mail.gmail.com>
Subject: Re: [PATCH glibc] Linux: Include <linux/sockios.h> in <bits/socket.h>
 under __USE_MISC
To:     Florian Weimer <fweimer@redhat.com>
Cc:     GNU C Library <libc-alpha@sourceware.org>,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man <linux-man@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 22, 2019 at 1:31 PM Florian Weimer <fweimer@redhat.com> wrote:
>
> Historically, <asm/socket.h> (which is included from <bits/socket.h>)
> provided ioctl operations for sockets.  User code accessed them
> through <sys/socket.h>.  The kernel UAPI headers have removed these
> definitions in favor of <linux/sockios.h>.  This commit makes them
> available via <sys/socket.h> again.

Looks good to me.

I wonder if we should still do these two changes in the kernel:

- include asm/socket.h from linux/socket.h for consistency
- move the defines that got moved from asm/sockios.h to linux/sockios.h
  back to the previous location to help anyone who is user
  newer kernel headers with older glibc headers.

      Arnd
