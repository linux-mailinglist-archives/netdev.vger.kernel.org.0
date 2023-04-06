Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA3AA6D9BAC
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjDFPFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239590AbjDFPFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:05:15 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F279775
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 08:04:49 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id br6so51182161lfb.11
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 08:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680793487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hOySwNNZhV1oqb8l3S6EWDmcIqB51Dry5oKAXw0evOc=;
        b=kDr+S5/F2xtYmZ99SVu7Jd73+uivl0RzjEnAnKGT40c/pw54y+Fz2qTbja2HPNw94r
         FlFbTI0OXLHBYq0w2pFJUD6o+0Uo8LNf1ppjsOSB0ocCuLnZuJ0YuGq4KXSgYUt82ufh
         CsXSSdRvNAuk+Km1mjwWP2kr8UkSvsVTdVSU+y8DcjKxfwlxganiYsiku+B5Zt5jyORg
         pth7kjpFNgmoOyt/pY1TyMk4MG8E16q10ZYhozXbEwDpEwR2jbT/ucjw6UQrJEtW4Fi+
         lp9o8/8RCfadi5lSvLzwEINxL8r2YkEymDEvFaFlC+Ulz4pmmwpTSkttVPV2BMLI2sAb
         POBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680793487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hOySwNNZhV1oqb8l3S6EWDmcIqB51Dry5oKAXw0evOc=;
        b=KbDxnlQwfNwR/KV3wRpKpr8Zt2YwjwsFxXJxrHvnCYZPbmW6oTPV0/TBk6obKG0OW/
         nx5gVqcTAWiuGcI8WAdrFTYOsULWo8X99vmVnfwY+yaVsfCU5vY1tcMjv3aqP3GQtKhW
         rlZfNX3xwTxC9n3JYw8fdbtIJxYVe7fCGXHqw73x/MsmyhSiSAr4OoAgYVp8ATV0FK1w
         s547V5djsvXF0XCjaobUPZa2ZzlfSubzPWPVcF28vTElnxb8jzsczCdWZhjkZX0dhbbq
         tqckZ8beY5dOKVJvMxDws95Na3E7I1QaBvMOQlvngHrJfQhBAgvEErEu9A6AuTlHRFVf
         Sl7g==
X-Gm-Message-State: AAQBX9dLSENW/C7kCUZtuMeeycdWnCAwuWCGwjRvjuYasQCBAA+g1U1+
        jcaRhgKw2FgCQtipRFwQHybsgWdF5h/FXqwPsPk=
X-Google-Smtp-Source: AKy350Z9g0zl8uEgeZv2yq9zzoh8L1u1zC8Kxvt+vtd1bvv6P13/Cm4JxR3jyfRC4Mz2HWryfb8KWbHaynfBRmXgiVw=
X-Received: by 2002:ac2:4153:0:b0:4ea:fc8f:7852 with SMTP id
 c19-20020ac24153000000b004eafc8f7852mr2975327lfi.12.1680793486877; Thu, 06
 Apr 2023 08:04:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAJGXZLhL-LLjiA-ge8O5A5NDoZ5JABqZHqix0y-8ThcJjBSe=A@mail.gmail.com>
 <20230324153407.096d6248@kernel.org>
In-Reply-To: <20230324153407.096d6248@kernel.org>
From:   Aleksey Shumnik <ashumnik9@gmail.com>
Date:   Thu, 6 Apr 2023 18:04:35 +0300
Message-ID: <CAJGXZLi7LedV_MYr==1RsN6goth73Y4txA=neci_QQcwa5Oqvw@mail.gmail.com>
Subject: Re: [BUG] gre interface incorrectly generates link-local addresses
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        pabeni@redhat.com, edumazet@google.com, a@unstable.cc,
        Thomas.Winter@alliedtelesis.co.nz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear maintainers,

I remind you that the problem is still relevant.
The problem is not only in generating the number of link-local
addresses in an amount equal to the number of addresses on all
interfaces defined in /etc/network/interfaces before the gre
interface.
Due to the new method of link-local address generation, the same
link-local address may be formed on several gre interfaces, which may
lead to errors in the operation of some network services

Would you please answer the following questions
> Which linux distribution did you use when you found an error with the
> lack of link-local address generation on the gre interface?
> After fixing the error, only one link-local address is generated?
Is this a bug or an expected behavior?

On Sat, Mar 25, 2023 at 1:34=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> Adding Thomas as well.
>
> On Fri, 24 Mar 2023 19:35:06 +0300 Aleksey Shumnik wrote:
> > Dear Maintainers,
> >
> > I found that GRE arbitrarily hangs IP addresses from other interfaces
> > described in /etc/network/interfaces above itself (from bottom to
> > top). Moreover, this error occurs on both ip4gre and ip6gre.
> >
> > Example of mgre interface:
> >
> > 13: mgre1@NONE: <MULTICAST,NOARP,UP,LOWER_UP> mtu 1400 qdisc noqueue
> > state UNKNOWN group default qlen 1000
> >     link/gre 0.0.0.0 brd 0.0.0.0
> >     inet 10.10.10.100/8 brd 10.255.255.255 scope global mgre1
> >        valid_lft forever preferred_lft forever
> >     inet6 fe80::a0a:a64/64 scope link
> >        valid_lft forever preferred_lft forever
> >     inet6 fe80::7f00:1/64 scope host
> >        valid_lft forever preferred_lft forever
> >     inet6 fe80::a0:6842/64 scope host
> >        valid_lft forever preferred_lft forever
> >     inet6 fe80::c0a8:1264/64 scope host
> >        valid_lft forever preferred_lft forever
> >
> > It seems that after the corrections in the following commits
> > https://github.com/torvalds/linux/commit/e5dd729460ca8d2da02028dbf264b6=
5be8cd4b5f
> > https://github.com/torvalds/linux/commit/30e2291f61f93f7132c060190f8360=
df52644ec1
> > https://github.com/torvalds/linux/commit/23ca0c2c93406bdb1150659e720bda=
1cec1fad04
> >
> > in function add_v4_addrs() instead of stopping after this check:
> >
> > if (addr.s6_addr32[3]) {
> >                 add_addr(idev, &addr, plen, scope, IFAPROT_UNSPEC);
> >                 addrconf_prefix_route(&addr, plen, 0, idev->dev, 0, pfl=
ags,
> >                                                                 GFP_KER=
NEL);
> >                  return;
> > }
> >
> > it goes further and in this cycle hangs addresses from all interfaces o=
n the gre
> >
> > for_each_netdev(net, dev) {
> >       struct in_device *in_dev =3D __in_dev_get_rtnl(dev);
> >       if (in_dev && (dev->flags & IFF_UP)) {
> >       struct in_ifaddr *ifa;
> >       int flag =3D scope;
> >       in_dev_for_each_ifa_rtnl(ifa, in_dev) {
> >             addr.s6_addr32[3] =3D ifa->ifa_local;
> >             if (ifa->ifa_scope =3D=3D RT_SCOPE_LINK)
> >                      continue;
> >             if (ifa->ifa_scope >=3D RT_SCOPE_HOST) {
> >                      if (idev->dev->flags&IFF_POINTOPOINT)
> >                               continue;
> >                      flag |=3D IFA_HOST;
> >             }
> >             add_addr(idev, &addr, plen, flag,
> >                                     IFAPROT_UNSPEC);
> >             addrconf_prefix_route(&addr, plen, 0, idev->dev,
> >                                      0, pflags, GFP_KERNEL);
> >             }
> > }
> >
> > Moreover, before switching to Debian 12 kernel version 6.1.15, I used
> > Debian 11 on 5.10.140, and there was no error described in the commit
> > https://github.com/torvalds/linux/commit/e5dd729460ca8d2da02028dbf264b6=
5be8cd4b5f.
> > One link-local address was always generated on the gre interface,
> > regardless of whether the destination or the local address of the
> > tunnel was specified.
> >
> > Which linux distribution did you use when you found an error with the
> > lack of link-local address generation on the gre interface?
> > After fixing the error, only one link-local address is generated?
> > I think this is a bug and most likely the problem is in generating
> > dev->dev_addr, since link-local is formed from it.
> >
> > I suggest solving this problem or roll back the code changes made in
> > the comments above.
>
