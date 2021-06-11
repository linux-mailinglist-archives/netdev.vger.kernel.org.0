Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8843A3AB7
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 06:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhFKEIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 00:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhFKEIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 00:08:10 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35EDC061574;
        Thu, 10 Jun 2021 21:06:12 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id r7so21142289edv.12;
        Thu, 10 Jun 2021 21:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2ru5NTnEQDZPpXWhXfz8XIfDBceAFX5z5yz+wskB7s4=;
        b=rnpRxAB7xEyWP4hzkTxgysmXz/FyKywiZroIuzOkJBL3KRh9oRzDqy9J1043TgAl78
         4PCR/+AyRlPkWgUWEURWlk45lNUpoRD28S0fu1U9Y+8Kmd7lYYXRGgcT91qHdDp9D27K
         9XulUPUBnqYbSuY2eoHCNcNy2fp3Q2CJJTiydH5qRFNawrsWkDRlMkn0lQzls28vENCy
         sLhyt7yAddWTPYbEeHla0wUO8caJaToOVsgSgPnw6NUG9W0qUNlpCzdtmfUQvSmRa74r
         +IryXDd/qyV/w5RSEICTxz9CtVxWKJVRGGIxfQiYTbsZyIYzT/re7ktckx+OvIgGXGux
         GlXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2ru5NTnEQDZPpXWhXfz8XIfDBceAFX5z5yz+wskB7s4=;
        b=B3z2Y2Dr+uAhd3dw+p4bP5/hzncGQ37BXPNBVOGaONXN5RJP+bJIP/mrGJEjzOdUia
         5Q7aTIVck+GQ8fH56x10+MSy2aXKD2HE9tWqpDbu5U8j73ZLxBYYL40YlzvMt7PQnKU0
         UiwvH2BQt2CB68DzzdJtXUyHklGC3XGuaZ2zJNpCIDWIxoMsX2Q8xdyM+dC7yVWUQyhY
         NiNczmIckNYXOGzayeMkFsKu96vGCFs6N+jKPVr1htW1XDWCVgqD4f8gzdGln93W1BXB
         9Xo4LJszlXm5k/tqxnTYwE7nMj55E77RMekg3X87dyLmgn5hF8nglGlHCqRKeDtbeqkJ
         k4Bg==
X-Gm-Message-State: AOAM531IFeX6C0Gk3fckaEWTWaoA7QclKSegpS3FLWYGil12IyLUmMos
        zgriaHlirg8eabgqPH+ij5MBhz1cZ58nlq4TZUYL1zrpsrU2hf0Xljrp19cW
X-Google-Smtp-Source: ABdhPJz8ubjy2qKc6iuAXBIjZx2bDZsZQ8aahgIxvFMKlgr6sTd3csIARxbzFcY7SbbBISWU2240qfpEug+Kg5ErQ3c=
X-Received: by 2002:a05:6402:34c6:: with SMTP id w6mr1598733edc.174.1623384371192;
 Thu, 10 Jun 2021 21:06:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210610020108.1356361-1-liushixin2@huawei.com> <CAHC9VhQM4YP527Z9ijTBk2i++S=viZ1hKVo6GgCOUcNCVgB2vw@mail.gmail.com>
In-Reply-To: <CAHC9VhQM4YP527Z9ijTBk2i++S=viZ1hKVo6GgCOUcNCVgB2vw@mail.gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Fri, 11 Jun 2021 12:05:44 +0800
Message-ID: <CAD-N9QVNhOoj17tC4OTGbbhYmM0kxnk=Q_XKD0iQ8G4tORqPGQ@mail.gmail.com>
Subject: Re: [PATCH -next] netlabel: Fix memory leak in netlbl_mgmt_add_common
To:     Paul Moore <paul@paul-moore.com>
Cc:     Liu Shixin <liushixin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 7:43 AM Paul Moore <paul@paul-moore.com> wrote:
>
> On Wed, Jun 9, 2021 at 9:29 PM Liu Shixin <liushixin2@huawei.com> wrote:
> >
> > Hulk Robot reported memory leak in netlbl_mgmt_add_common.
> > The problem is non-freed map in case of netlbl_domhsh_add() failed.
> >
> > BUG: memory leak
> > unreferenced object 0xffff888100ab7080 (size 96):
> >   comm "syz-executor537", pid 360, jiffies 4294862456 (age 22.678s)
> >   hex dump (first 32 bytes):
> >     05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01  ................
> >   backtrace:
> >     [<0000000008b40026>] netlbl_mgmt_add_common.isra.0+0xb2a/0x1b40
> >     [<000000003be10950>] netlbl_mgmt_add+0x271/0x3c0
> >     [<00000000c70487ed>] genl_family_rcv_msg_doit.isra.0+0x20e/0x320
> >     [<000000001f2ff614>] genl_rcv_msg+0x2bf/0x4f0
> >     [<0000000089045792>] netlink_rcv_skb+0x134/0x3d0
> >     [<0000000020e96fdd>] genl_rcv+0x24/0x40
> >     [<0000000042810c66>] netlink_unicast+0x4a0/0x6a0
> >     [<000000002e1659f0>] netlink_sendmsg+0x789/0xc70
> >     [<000000006e43415f>] sock_sendmsg+0x139/0x170
> >     [<00000000680a73d7>] ____sys_sendmsg+0x658/0x7d0
> >     [<0000000065cbb8af>] ___sys_sendmsg+0xf8/0x170
> >     [<0000000019932b6c>] __sys_sendmsg+0xd3/0x190
> >     [<00000000643ac172>] do_syscall_64+0x37/0x90
> >     [<000000009b79d6dc>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> >
> > Fixes: 63c416887437 ("netlabel: Add network address selectors to the NetLabel/LSM domain mapping")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Liu Shixin <liushixin2@huawei.com>
> > ---
> >  net/netlabel/netlabel_mgmt.c | 20 ++++++++++++++++----
> >  1 file changed, 16 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
> > index e664ab990941..e7f00c0f441e 100644
> > --- a/net/netlabel/netlabel_mgmt.c
> > +++ b/net/netlabel/netlabel_mgmt.c
> > @@ -191,6 +191,12 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
> >                 entry->family = AF_INET;
> >                 entry->def.type = NETLBL_NLTYPE_ADDRSELECT;
> >                 entry->def.addrsel = addrmap;
> > +
> > +               ret_val = netlbl_domhsh_add(entry, audit_info);
> > +               if (ret_val != 0) {
> > +                       kfree(map);
> > +                       goto add_free_addrmap;
> > +               }
> >  #if IS_ENABLED(CONFIG_IPV6)
> >         } else if (info->attrs[NLBL_MGMT_A_IPV6ADDR]) {
> >                 struct in6_addr *addr;
> > @@ -243,13 +249,19 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
> >                 entry->family = AF_INET6;
> >                 entry->def.type = NETLBL_NLTYPE_ADDRSELECT;
> >                 entry->def.addrsel = addrmap;
> > +
> > +               ret_val = netlbl_domhsh_add(entry, audit_info);
> > +               if (ret_val != 0) {
> > +                       kfree(map);
> > +                       goto add_free_addrmap;
> > +               }
> >  #endif /* IPv6 */
> > +       } else {
> > +               ret_val = netlbl_domhsh_add(entry, audit_info);
> > +               if (ret_val != 0)
> > +                       goto add_free_addrmap;
> >         }
> >
> > -       ret_val = netlbl_domhsh_add(entry, audit_info);
> > -       if (ret_val != 0)
> > -               goto add_free_addrmap;
> > -
> >         return 0;
>
> Thanks for the report and a fix, although I think there may be a
> simpler fix that results in less code duplication; some quick pseudo
> code below:
>
>   int netlbl_mgmt_add_common(...)
>   {
>      void *map_p = NULL;
>
>      if (NLBL_MGMT_A_IPV4ADDR) {
>        struct netlbl_domaddr4_map *map;
>        map_p = map;

It's better to use a separate map_p pointer, not like the draft patch
I sent yesterday.

>
>      } else if (NLBL_MGMT_A_IPV6ADDR) {
>        struct netlbl_domaddr4_map *map;
>        map_p = map;
>     }
>
>   add_free_addrmap:
>     kfree(map_p);
>     kfree(addrmap);
>   }

Simple comment here: we should separate kfree(map_p) and
kfree(addrmap) into different goto labels, just like the draft patch I
sent yesterday.

>
> ... this approach would even simplify the error handling after the
> netlbl_af{4,6}list_add() calls a bit too (you could jump straight to
> add_free_addrmap).
>
> --
> paul moore
> www.paul-moore.com
