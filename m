Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C1C2BC556
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 12:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbgKVLYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 06:24:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:59800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727360AbgKVLYI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Nov 2020 06:24:08 -0500
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FD74208C3
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 11:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606044247;
        bh=0Kq89qyHyvptVPKtElFZEUG9dY78bzi3WGEYX/n3emg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=W5hlo5EfiwhRGfT/MtMerHQhS4qxNjNhhyUTqO2yFEQ5Eg5jZ6UvyqMtOx/j+fFED
         f1np59J5Pt/HSVyLdB7/uJZo9Ep1wVTkjy0vKgSGK17Xw5crIMLvVG11UwelJkOiOu
         iLTlifU12s/wpSywzzU1qRjA41Az0B9VFh8qhKx4=
Received: by mail-oi1-f182.google.com with SMTP id t143so16342327oif.10
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 03:24:07 -0800 (PST)
X-Gm-Message-State: AOAM532uFFt1BHhKJfQ8FjJY9DAeVgZg05IHAye5nKDGFDletRGAdNWk
        c0lzSpL5SNdpZvXXR+YwxCNCj6+oAsz3PZJsirM=
X-Google-Smtp-Source: ABdhPJxiL363n+SSQWMiIeGZrrt3qxcoba7c4DhiiMfjHpN9p+Ew6CagsrAr/GQm26OMtHa2FCC7WuKc2hdi+h9CUCc=
X-Received: by 2002:aca:3c54:: with SMTP id j81mr12093693oia.11.1606044246851;
 Sun, 22 Nov 2020 03:24:06 -0800 (PST)
MIME-Version: 1.0
References: <20201121214844.1488283-1-kuba@kernel.org>
In-Reply-To: <20201121214844.1488283-1-kuba@kernel.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sun, 22 Nov 2020 12:23:50 +0100
X-Gmail-Original-Message-ID: <CAK8P3a32JYqeFUD=BUaN0q6_idVS+mWx1VFwWsOLOYLA_C+3Yg@mail.gmail.com>
Message-ID: <CAK8P3a32JYqeFUD=BUaN0q6_idVS+mWx1VFwWsOLOYLA_C+3Yg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] compat: always include linux/compat.h from net/compat.h
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 21, 2020 at 10:49 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> We're about to do reshuffling in networking headers and
> eliminate some implicit includes. This results in:
>
> In file included from ../net/ipv4/netfilter/arp_tables.c:26:
> include/net/compat.h:60:40: error: unknown type name =E2=80=98compat_uptr=
_t=E2=80=99; did you mean =E2=80=98compat_ptr_ioctl=E2=80=99?
>     struct sockaddr __user **save_addr, compat_uptr_t *ptr,
>                                         ^~~~~~~~~~~~~
>                                         compat_ptr_ioctl
> include/net/compat.h:61:4: error: unknown type name =E2=80=98compat_size_=
t=E2=80=99; did you mean =E2=80=98compat_sigset_t=E2=80=99?
>     compat_size_t *len);
>     ^~~~~~~~~~~~~
>     compat_sigset_t
>
> Currently net/compat.h depends on linux/compat.h being included
> first. After the upcoming changes this would break the 32bit build.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
