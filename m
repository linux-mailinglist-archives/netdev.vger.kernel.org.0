Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBFA3A2B41
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 14:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhFJMSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 08:18:42 -0400
Received: from mail-ej1-f49.google.com ([209.85.218.49]:42814 "EHLO
        mail-ej1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbhFJMSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 08:18:39 -0400
Received: by mail-ej1-f49.google.com with SMTP id k25so38336434eja.9;
        Thu, 10 Jun 2021 05:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w3+0JChAcpvoaCnj4IraBcQhrysENOwAy5Kr4swonKI=;
        b=or60PY1gBx/+etuyHLULzJI/T9+GFKKfgPiLJtkPlR1C1r42UV9QniwXf6KX6hs2RV
         CkCCvm3Dr0Rkmc3PLNexfZpQKnCF8acFTh66Y8YiFR9s7jpjVAyI7qa2D+kD/qmCz1Bu
         8lMQq/9ME3ieyAy8mHdrdygd4YPWCf9Fg7CnEv923reRdU4iUuLpPzdVnI7n0dN/Yewx
         3+Q/E4fqxPoYfIpPGE+mLMzF+kUxRaGl26rlESckYfYkS+da9qLUaxTGSC1bI3+Ba5gz
         ClByifC6YFW5Ew85G1jISctlnJbPGji5lHoQwm1ZlgZi1vjR6zOItfS8v5Wd0V6loj1w
         MY6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w3+0JChAcpvoaCnj4IraBcQhrysENOwAy5Kr4swonKI=;
        b=jP+lYKq3pIsKQj+nH1TmTQ0iL7lhFiiXELzgpie3hNm31kNLmXIBySI8VxoAo1IwWb
         HrJvQi+IQ8QcGWDqC+eKgX82YjyURFfnIwXQz9/o0QOarXC1COFDZuO1vBaPUC3OgB6L
         gRkR1/IpuiqS2NJi4nLWE7zNB0onK/xABa/lTXlBguWvSDvCaeTcUasiR2mOGg5qDuC9
         1Uj839/ktftW4g8qFhtPxpyxvId3cC05xy4IEun3Ncgdx9kI9vxAvkWz9E2guhvJS5t3
         BSjgGo23PjJH6oNaRiuNm/WEp8Jral4054AI5qRKpLZMMxqRjc5FeH2rjw38bcZat8KP
         qB+w==
X-Gm-Message-State: AOAM531lA9SwhzrJq354hj/ydfAo8SIP/U1WIUHRQBUV0cFAYPFhCUV1
        akEVtG98VYOgqfcU8xuLsh+QhHmuQiwCQretquU=
X-Google-Smtp-Source: ABdhPJzBcuf3sxNFOiimKoRw4ReNNXUKHwUVmN40nhUvyvCb7rVJQapdsNM5BTWf5aYjhAoGJffVzI0CTZTEK1oSqRM=
X-Received: by 2002:a17:906:3c44:: with SMTP id i4mr4196069ejg.135.1623327341370;
 Thu, 10 Jun 2021 05:15:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210610020108.1356361-1-liushixin2@huawei.com>
 <CAD-N9QWypyEa65-sz3rrtM2o5xzQd_5kJPyC4n+nK5JTviQvEQ@mail.gmail.com> <ea1c6878-94d4-63ba-5dea-1190c146581d@huawei.com>
In-Reply-To: <ea1c6878-94d4-63ba-5dea-1190c146581d@huawei.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Thu, 10 Jun 2021 20:15:15 +0800
Message-ID: <CAD-N9QUsM7sB9K49c_Vfq_D+zSYYU4VTLaRfnRiB1EfsmxihdQ@mail.gmail.com>
Subject: Re: [PATCH -next] netlabel: Fix memory leak in netlbl_mgmt_add_common
To:     Liu Shixin <liushixin2@huawei.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 6:45 PM Liu Shixin <liushixin2@huawei.com> wrote:
>
> On 2021/6/10 11:08, Dongliang Mu wrote:
> > On Thu, Jun 10, 2021 at 9:31 AM Liu Shixin <liushixin2@huawei.com> wrote:
> >> Hulk Robot reported memory leak in netlbl_mgmt_add_common.
> >> The problem is non-freed map in case of netlbl_domhsh_add() failed.
> >>
> >> BUG: memory leak
> >> unreferenced object 0xffff888100ab7080 (size 96):
> >>   comm "syz-executor537", pid 360, jiffies 4294862456 (age 22.678s)
> >>   hex dump (first 32 bytes):
> >>     05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >>     fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01  ................
> >>   backtrace:
> >>     [<0000000008b40026>] netlbl_mgmt_add_common.isra.0+0xb2a/0x1b40
> >>     [<000000003be10950>] netlbl_mgmt_add+0x271/0x3c0
> >>     [<00000000c70487ed>] genl_family_rcv_msg_doit.isra.0+0x20e/0x320
> >>     [<000000001f2ff614>] genl_rcv_msg+0x2bf/0x4f0
> >>     [<0000000089045792>] netlink_rcv_skb+0x134/0x3d0
> >>     [<0000000020e96fdd>] genl_rcv+0x24/0x40
> >>     [<0000000042810c66>] netlink_unicast+0x4a0/0x6a0
> >>     [<000000002e1659f0>] netlink_sendmsg+0x789/0xc70
> >>     [<000000006e43415f>] sock_sendmsg+0x139/0x170
> >>     [<00000000680a73d7>] ____sys_sendmsg+0x658/0x7d0
> >>     [<0000000065cbb8af>] ___sys_sendmsg+0xf8/0x170
> >>     [<0000000019932b6c>] __sys_sendmsg+0xd3/0x190
> >>     [<00000000643ac172>] do_syscall_64+0x37/0x90
> >>     [<000000009b79d6dc>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> >>
> >> Fixes: 63c416887437 ("netlabel: Add network address selectors to the NetLabel/LSM domain mapping")
> >> Reported-by: Hulk Robot <hulkci@huawei.com>
> >> Signed-off-by: Liu Shixin <liushixin2@huawei.com>
> >> ---
> >>  net/netlabel/netlabel_mgmt.c | 20 ++++++++++++++++----
> >>  1 file changed, 16 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
> >> index e664ab990941..e7f00c0f441e 100644
> >> --- a/net/netlabel/netlabel_mgmt.c
> >> +++ b/net/netlabel/netlabel_mgmt.c
> >> @@ -191,6 +191,12 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
> >>                 entry->family = AF_INET;
> >>                 entry->def.type = NETLBL_NLTYPE_ADDRSELECT;
> >>                 entry->def.addrsel = addrmap;
> >> +
> >> +               ret_val = netlbl_domhsh_add(entry, audit_info);
> >> +               if (ret_val != 0) {
> >> +                       kfree(map);
> >> +                       goto add_free_addrmap;
> >> +               }
> >>  #if IS_ENABLED(CONFIG_IPV6)
> >>         } else if (info->attrs[NLBL_MGMT_A_IPV6ADDR]) {
> >>                 struct in6_addr *addr;
> >> @@ -243,13 +249,19 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
> >>                 entry->family = AF_INET6;
> >>                 entry->def.type = NETLBL_NLTYPE_ADDRSELECT;
> >>                 entry->def.addrsel = addrmap;
> >> +
> >> +               ret_val = netlbl_domhsh_add(entry, audit_info);
> >> +               if (ret_val != 0) {
> >> +                       kfree(map);
> >> +                       goto add_free_addrmap;
> >> +               }
> >>  #endif /* IPv6 */
> >> +       } else {
> >> +               ret_val = netlbl_domhsh_add(entry, audit_info);
> >> +               if (ret_val != 0)
> >> +                       goto add_free_addrmap;
> >>         }
> >>
> >> -       ret_val = netlbl_domhsh_add(entry, audit_info);
> >> -       if (ret_val != 0)
> >> -               goto add_free_addrmap;
> >> -
> > Hi Shixin,
> >
> > I have a small suggestion about this patch: you can move the variable
> > map out of if/else if branches, like the following code snippet.
> >
> > Be aware to assign the variable map to NULL at first. Then kfree in
> > the last else branch will do nothing.
> >
> > I don't test the following diff, if there are any issues, please let me know.
> >
> > diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
> > index ca52f5085989..1824bcd2272b 100644
> > --- a/net/netlabel/netlabel_mgmt.c
> > +++ b/net/netlabel/netlabel_mgmt.c
> > @@ -78,6 +78,7 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
> >  {
> >         int ret_val = -EINVAL;
> >         struct netlbl_domaddr_map *addrmap = NULL;
> > +       struct netlbl_domaddr4_map *map = NULL;
> >         struct cipso_v4_doi *cipsov4 = NULL;
> >  #if IS_ENABLED(CONFIG_IPV6)
> >         struct calipso_doi *calipso = NULL;
> > @@ -147,7 +148,6 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
> >         if (info->attrs[NLBL_MGMT_A_IPV4ADDR]) {
> >                 struct in_addr *addr;
> >                 struct in_addr *mask;
> > -               struct netlbl_domaddr4_map *map;
> >
> >                 addrmap = kzalloc(sizeof(*addrmap), GFP_KERNEL);
> >                 if (addrmap == NULL) {
> > @@ -195,7 +195,6 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
> >         } else if (info->attrs[NLBL_MGMT_A_IPV6ADDR]) {
> >                 struct in6_addr *addr;
> >                 struct in6_addr *mask;
> > -               struct netlbl_domaddr6_map *map;
> >
> >                 addrmap = kzalloc(sizeof(*addrmap), GFP_KERNEL);
> >                 if (addrmap == NULL) {
> > @@ -247,8 +246,10 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
> >         }
> >
> >         ret_val = netlbl_domhsh_add(entry, audit_info);
> > -       if (ret_val != 0)
> > +       if (ret_val != 0) {
> > +               kfree(map);
> >                 goto add_free_addrmap;
> > +       }
> >
> >         return 0;
> >
> The type of map can be struct netlbl_domaddr4_map or struct netlbl_domaddr6_map
> under different conditions. It seems like I can't put them together simply.
>

Yes, you're right. It takes more code changes to handle different
types. I choose to use the generic void * pointer.

The advantage of the diff below is to improve its maintainability of
error handling. I add one additional label: add_free_map to handle the
deallocation of map.

Note that, I did not test this diff. It is only used for
clarification. And maybe the compiler complains about the usage of
void * pointer.

diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
index ca52f5085989..38edf170b109 100644
--- a/net/netlabel/netlabel_mgmt.c
+++ b/net/netlabel/netlabel_mgmt.c
@@ -78,6 +78,7 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
 {
        int ret_val = -EINVAL;
        struct netlbl_domaddr_map *addrmap = NULL;
+       void *map = NULL;
        struct cipso_v4_doi *cipsov4 = NULL;
 #if IS_ENABLED(CONFIG_IPV6)
        struct calipso_doi *calipso = NULL;
@@ -147,7 +148,6 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
        if (info->attrs[NLBL_MGMT_A_IPV4ADDR]) {
                struct in_addr *addr;
                struct in_addr *mask;
-               struct netlbl_domaddr4_map *map;

                addrmap = kzalloc(sizeof(*addrmap), GFP_KERNEL);
                if (addrmap == NULL) {
@@ -170,7 +170,7 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
                addr = nla_data(info->attrs[NLBL_MGMT_A_IPV4ADDR]);
                mask = nla_data(info->attrs[NLBL_MGMT_A_IPV4MASK]);

-               map = kzalloc(sizeof(*map), GFP_KERNEL);
+               map = kzalloc(sizeof(struct netlbl_domaddr4_map), GFP_KERNEL);
                if (map == NULL) {
                        ret_val = -ENOMEM;
                        goto add_free_addrmap;
@@ -183,10 +183,8 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
                        map->def.cipso = cipsov4;

                ret_val = netlbl_af4list_add(&map->list, &addrmap->list4);
-               if (ret_val != 0) {
-                       kfree(map);
-                       goto add_free_addrmap;
-               }
+               if (ret_val != 0)
+                       goto add_free_map;

                entry->family = AF_INET;
                entry->def.type = NETLBL_NLTYPE_ADDRSELECT;
@@ -218,7 +216,7 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
                addr = nla_data(info->attrs[NLBL_MGMT_A_IPV6ADDR]);
                mask = nla_data(info->attrs[NLBL_MGMT_A_IPV6MASK]);

-               map = kzalloc(sizeof(*map), GFP_KERNEL);
+               map = kzalloc(sizeof(struct netlbl_domaddr6_map), GFP_KERNEL);
                if (map == NULL) {
                        ret_val = -ENOMEM;
                        goto add_free_addrmap;
@@ -235,10 +233,8 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
                        map->def.calipso = calipso;

                ret_val = netlbl_af6list_add(&map->list, &addrmap->list6);
-               if (ret_val != 0) {
-                       kfree(map);
-                       goto add_free_addrmap;
-               }
+               if (ret_val != 0)
+                       goto add_free_map;

                entry->family = AF_INET6;
                entry->def.type = NETLBL_NLTYPE_ADDRSELECT;
@@ -248,10 +244,12 @@ static int netlbl_mgmt_add_common(struct genl_info *info,

        ret_val = netlbl_domhsh_add(entry, audit_info);
        if (ret_val != 0)
-               goto add_free_addrmap;
+               goto add_free_map;

        return 0;

+add_free_map:
+       kfree(map);
 add_free_addrmap:
        kfree(addrmap);
 add_doi_put_def:

> Thanks,
> >
> >
> >
> >>         return 0;
> >>
> >>  add_free_addrmap:
> >> --
> >> 2.18.0.huawei.25
> >>
> > .
> >
>
