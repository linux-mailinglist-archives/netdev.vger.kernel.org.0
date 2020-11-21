Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905212BC186
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 19:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgKUSlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 13:41:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:49466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728055AbgKUSlA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 13:41:00 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D696C2072C;
        Sat, 21 Nov 2020 18:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605984060;
        bh=R1sekdSH+ZqbaCKfx1qNvxXJrOGBbWdZE5CNdpaCIBw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e0KIXJot9iAkqHhtkiL+75Tg2jAspf+8YDfWC4t4VhESsB232ZgoAUlA0duYqAz7C
         pEYD/duz08++U+336fYqWMMoDFkeJUX/QqN9ahsbSuhtpUiKOlglJ5OnIUGpZIhOTx
         PD7+zGbq/Td5S4uy4+ipxjDvEiKtiQZnDUvBYgR8=
Date:   Sat, 21 Nov 2020 10:40:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, hch@lst.de, arnd@arndb.de
Subject: Re: [PATCH net-next] compat: always include linux/compat.h from
 net/compat.h
Message-ID: <20201121104059.41dd1d79@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201121175224.1465831-1-kuba@kernel.org>
References: <20201121175224.1465831-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Nov 2020 09:52:24 -0800 Jakub Kicinski wrote:
> In file included from net/ipv4/netfilter/arp_tables.c:26:
> include/net/compat.h:57:23: error: conflicting types for =E2=80=98uintptr=
_t=E2=80=99
>  #define compat_uptr_t uintptr_t
>                        ^~~~~~~~~
> include/asm-generic/compat.h:22:13: note: in expansion of macro =E2=80=98=
compat_uptr_t=E2=80=99
>  typedef u32 compat_uptr_t;
>              ^~~~~~~~~~~~~
> In file included from include/linux/limits.h:6,
>                  from include/linux/kernel.h:7,
>                  from net/ipv4/netfilter/arp_tables.c:14:
> include/linux/types.h:37:24: note: previous declaration of =E2=80=98uintp=
tr_t=E2=80=99 was here
>  typedef unsigned long  uintptr_t;
>                         ^~~~~~~~~

Ah, damn it, I obviously copied the wrong error into the commit
message. This is the correct one (after removing include of ethtool.h
from netdevice.h):


In file included from ../net/ipv4/netfilter/arp_tables.c:26:
include/net/compat.h:60:40: error: unknown type name =E2=80=98compat_uptr_t=
=E2=80=99; did you mean =E2=80=98compat_ptr_ioctl=E2=80=99?
    struct sockaddr __user **save_addr, compat_uptr_t *ptr,
                                        ^~~~~~~~~~~~~
                                        compat_ptr_ioctl
include/net/compat.h:61:4: error: unknown type name =E2=80=98compat_size_t=
=E2=80=99; did you mean =E2=80=98compat_sigset_t=E2=80=99?
    compat_size_t *len);
    ^~~~~~~~~~~~~
    compat_sigset_t
