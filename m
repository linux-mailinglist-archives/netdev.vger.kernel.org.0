Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12964A4D45
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 04:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729111AbfIBCMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 22:12:49 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36643 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729033AbfIBCMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 22:12:49 -0400
Received: by mail-wm1-f68.google.com with SMTP id p13so12939746wmh.1
        for <netdev@vger.kernel.org>; Sun, 01 Sep 2019 19:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=X/xs6K3vzQqYYp8PjaQzBxxdZYXS3ux7y5N2hSY0Q7E=;
        b=IzGtIfBYfW5hlpnB6nE5doWoL1y4iiTZUx9G+RON5g0Y3+wGPTbPxTiDlEa3MwfNOJ
         g2E4gKabIUJZsUomXQF1XPXWSadXF3L4hpD5zl7fFI5p6LVm+YSeX7RXxilVhdeds9Jx
         6W9qRp/eCBRnz6dgSktPdGfuHUt8f003vEp6Aon7ndd0PC/OU+mTYBquPz5eG8V81X5H
         Z77mL/j+4U0oz3rrRY3nGxakN9OCpcuwV23o1SmteSPXQO6yvTEAHOhUV4kIWiCGJ/lK
         l48hrNCyMWHTCaDuB13Xwe7pVIShoFXOKSAFWx7rIUH1xLVoYZpeYKrqd98VG1VSEEmq
         XWdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=X/xs6K3vzQqYYp8PjaQzBxxdZYXS3ux7y5N2hSY0Q7E=;
        b=b1NLV5iVErLQcHjotyghbCQLEUbivmB1JXEZvOfI4c5164ORJNFwOasQaCTTzAKcmt
         t6OueT3625LSQMdFRwZlYArDjdRTyA+is9CnHFZLuGyDQ8husr+iL2BurJvLs0kAFdQm
         zB/oW/rwJWTP0QrUnAnzsW8olS30N/N61BdxlkvI8HwNgYWGv4FJUKzFbaV6ZDbvgb6+
         n+/otn3TZ4vOn42k1HeZlaBRfq2b6cQUUdb8ge2V4A0+Zx1cfhnhyd8ZyOOeS9L0izT1
         +aLy8uh63Zi/4xcbHdU1oGUWt9EANLskIXq2eCjs8qiebl8CRIal5zoQKaDbRuEtOAlL
         httA==
X-Gm-Message-State: APjAAAVqYUr4CKCqwSAyHYMaF6fQpgsB36U964i170lMuTUf+e5jYNb2
        YzdXalCr3AOsQ3kra9RAFO4HO8lLikwWdyKxFkt9zHRi8RI=
X-Google-Smtp-Source: APXvYqxGZqZym1sip1bmtMRoTK1RRddjoD6zKCOy1N4QW4IEB2C6L/4jhngBT7db0UGxjXRIC/NxsLcym6SHEmyNj8A=
X-Received: by 2002:a1c:1d84:: with SMTP id d126mr17671187wmd.58.1567390367239;
 Sun, 01 Sep 2019 19:12:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190901174759.257032-1-zenczykowski@gmail.com> <CAHo-Ooy_g-7eZvBSbKR2eaQW3_Bk+fik5YaYAgN60GjmAU=ADA@mail.gmail.com>
In-Reply-To: <CAHo-Ooy_g-7eZvBSbKR2eaQW3_Bk+fik5YaYAgN60GjmAU=ADA@mail.gmail.com>
From:   Lorenzo Colitti <lorenzo@google.com>
Date:   Mon, 2 Sep 2019 11:12:35 +0900
Message-ID: <CAKD1Yr2tcRiiLwGdTB3TwpxoAH0+R=dgfCDh6TpZ2fHTE2rC9w@mail.gmail.com>
Subject: Re: [PATCH] net-ipv6: fix excessive RTF_ADDRCONF flag on ::1/128
 local route (and others)
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 2, 2019 at 2:55 AM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
> It's not immediately clear to me what is the better approach as I'm
> not immediately certain what RTF_ADDRCONF truly means.
> However the in kernel header file comment does explicitly mention this
> being used to flag routes derived from RA's, and very clearly ::1/128
> is not RA generated, so I *think* the correct fix is to return to the
> old way the kernel used to do things and not flag with ADDRCONF...

AIUI, "addrconf" has always meant stateless address autoconfiguration
as per RFC 4862, i.e., addresses autoconfigured when getting an RA, or
autoconfigured based on adding the link-local prefix. Looking at 5.1
(the most recent release before c7a1ce397ada which you're fixing here)
confirms this interpretation, because RTF_ADDRCONF is only used by:

- addrconf_prefix_rcv: receiving a PIO from an RA
- rt6_add_route_info: receiving an RIO from an RA
- rt6_add_dflt_router, rt6_get_dflt_router: receiving the default
router from an RA
- __rt6_purge_dflt_routers: removing all routes received from RAs,
when enabling forwarding (i.e., switching from being a host to being a
router)


So, if I'm reading c7a1ce397ada right, I would say it's incorrect.
That patch changes things so that RTF_ADDRCONF is set for pretty much
all routes created by adding IPv6 addresses. That includes not only
IPv6 addresses created by RAs, which has always been the case, but
also IPv6 addresses created manually from userspace, or the loopback
address, and even multicast and anycast addresses created by
IPV6_JOIN_GROUP and IPV6_JOIN_ANYCAST. That's userspace-visible
breakage and should be reverted.

Not sure if this patch is the right fix, though, because it breaks
things in the opposite direction: even routes created by an IPv6
address added by receiving an RA will no longer have RTF_ADDRCONF.
Perhaps add something like this as well?

 struct fib6_info *addrconf_f6i_alloc(struct net *net, struct inet6_dev *id=
ev,
-                                     const struct in6_addr *addr, bool any=
cast,
-                                     const struct in6_addr *addr, u8 flags=
,
                                      gfp_t gfp_flags);

flags would be RTF_ANYCAST iff the code previously called with true,
and RTF_ADDRCONF if called by a function that is adding an IPv6
address coming from an RA.
