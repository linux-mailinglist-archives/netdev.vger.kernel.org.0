Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B92F6F067
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 20:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfGTSul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jul 2019 14:50:41 -0400
Received: from mail-qk1-f179.google.com ([209.85.222.179]:45903 "EHLO
        mail-qk1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfGTSul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jul 2019 14:50:41 -0400
Received: by mail-qk1-f179.google.com with SMTP id s22so25755102qkj.12;
        Sat, 20 Jul 2019 11:50:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K1DjJdNnl+zka9s8zl8TpnQj9JyccYfNCrdgUGT2JBc=;
        b=E0Z9AYzsZ5A+FkVMOHPFogm4Q3Zy261XHb3O8qqBw+NPtSFvrRR3r9pVDAogOIlLHA
         0UtoVhxWsC/ziDJCqkqCypTBaL4SoK8wqXwBbJuG2es2KigAqB2th+fdX3p+1jGPSI5H
         kVNrplbfvGwAKoTpRtbYrBSgHTyHHg8Mj5cH1YteEA43gSa4HbpyhdHAMPYsUVGKfyfV
         B0zOFKof9uyzh6Ln1urU8CnzjrjUUhVwRR4UPS5CzKqAylTFUwOSfU9ItK5+ox8tgTIO
         ueUhn627l1gXxKK/AYv4OaB5wsJsTfQtRiTKrHHaukvnQsW09u4mr4m4MD8hRnFsvpev
         uxuA==
X-Gm-Message-State: APjAAAXHIRaqQwCJ4qWtnjNfnR87+tFy/mdH9EQGiKHwihkIA0nI1XM1
        zyHmygxLPizB5hkWsU3cuQFc/vNfmSgZ4uSsE/E=
X-Google-Smtp-Source: APXvYqwOgP5JyfSYb+na0Yw3siiSnE4qFFFhH9b1DMjUEZg8Ra4RTQ8jwZpCHV3GgMemx0iWkTj65t0WRcrRnMXGEsk=
X-Received: by 2002:a37:76c5:: with SMTP id r188mr39763653qkc.394.1563648640160;
 Sat, 20 Jul 2019 11:50:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190720174844.4b989d34@sf> <87wogca86l.fsf@mid.deneb.enyo.de>
In-Reply-To: <87wogca86l.fsf@mid.deneb.enyo.de>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 20 Jul 2019 20:50:23 +0200
Message-ID: <CAK8P3a3s3OeBj1MviaJV2UR0eUhF0GKPBi1iFf_3QKQyNPkuqw@mail.gmail.com>
Subject: Re: linux-headers-5.2 and proper use of SIOCGSTAMP
To:     Florian Weimer <fw@deneb.enyo.de>
Cc:     Sergei Trofimovich <slyfox@gentoo.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man <linux-man@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 20, 2019 at 8:10 PM Florian Weimer <fw@deneb.enyo.de> wrote:
>
> * Sergei Trofimovich:
>
> > Should #include <linux/sockios.h> always be included by user app?
> > Or should glibc tweak it's definition of '#include <sys/socket.h>'
> > to make it available on both old and new version of linux headers?
>
> What is the reason for dropping SIOCGSTAMP from <asm/socket.h>?
>
> If we know that, it will be much easier to decide what to do about
> <sys/socket.h>.

As far as I can tell, nobody thought it would be a problem to move it
from asm/sockios.h to linux/sockios.h, as the general rule is that one
should use the linux/*.h version if both exist, and that the asm/*.h
version only contains architecture specific definitions. The new
definition is the same across all architectures, so it made sense to
have it in the common file.

If the assumption was wrong, the obvious solution is to duplicate the
definitions everywhere or move the common parts into
asm-generic/sockios.h, but it would have been better to hear about
that earlier.

      Arnd
