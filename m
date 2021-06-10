Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D423A229E
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 05:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhFJDQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbhFJDQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 23:16:16 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F63C061760;
        Wed,  9 Jun 2021 20:09:03 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w21so30984108edv.3;
        Wed, 09 Jun 2021 20:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XwhrgajC6sjsC/HOcZZ9qIFMdsIPeaNkncBtG+FZ390=;
        b=cYeZ8jmhyDeyWJZ76ZwPW/ouMZaJmS5KoE/dA43/MvxJIkxKxQKBefUjvdBpUrurGv
         S01vFZ56iUzme0IURhvxpmAzmRHiAa03vX4aMZNYB3zvnse/YU1rrCral0zCpx42sj6s
         gH9qHRe6DjDWTneuLcRnGhRc4kTwi6qA9fV8Wu94XwNj9pRxI5SJ99X5niYVsOmPLQJX
         400QFG0YT1Vn91JtIcVGPyaiOiMGDjWH+PDnvQvGKs5XFhDM1Z3uAoivGYGXRsQuXhId
         HLCpYwUPB/R9EVzVnGYlUbhAK/FfZ+pj2YJCgdcW0N9b6c/75oKtvlRo7VfI0AGjaCic
         SNJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XwhrgajC6sjsC/HOcZZ9qIFMdsIPeaNkncBtG+FZ390=;
        b=o193D3v3xpne6t3wKuoJ5xSVHP2/I57dKBV9SgCTApDHjkzN2YOoPwlBaz5mpddQmp
         rvoKg9CCjoLgkYX/D7cO0uVd2ni/QVy922+c+WUPX0tX0gC/biLqdxEPbQU3O2XsLMVj
         oPAFgao+xGyXJcnd3tpN5Ynp6DFoywE3PAA7vFStK0UFuar5A0qaqfJtyJaKgwZDAb2P
         3gI211pYlgASfb397DyM/L93aDxP7HUMUmFHLTPHM64afKnQFoFYk42wiPs/lTXHLcHw
         Sr+Yj2dlw41+pvGjaHRuxTPzIOlJ79TUqiK4AxZ0Cbj05r+gnPpsmczbpRkCGs0neim5
         Npfw==
X-Gm-Message-State: AOAM530QV0q1cr5TQ8tpKDPhV43YDbp20HaEjme3HvjKf3hbqNgzEPIt
        jkW35Qx48Sy9GbTcIHvHIe+/ltRJdKhk0OHv/rOz7d9lJfC7Yv7o1VI=
X-Google-Smtp-Source: ABdhPJw8wNmuyUNNJaeUtfiMKY6pDHrmZpMJpa7G9slaLupkB1V2sVGvs9V8+RzrQlijMQ6ZzRRuJljQNKWfZNDigtQ=
X-Received: by 2002:a05:6402:3082:: with SMTP id de2mr2459158edb.214.1623294541934;
 Wed, 09 Jun 2021 20:09:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210610020108.1356361-1-liushixin2@huawei.com>
In-Reply-To: <20210610020108.1356361-1-liushixin2@huawei.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Thu, 10 Jun 2021 11:08:35 +0800
Message-ID: <CAD-N9QWypyEa65-sz3rrtM2o5xzQd_5kJPyC4n+nK5JTviQvEQ@mail.gmail.com>
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

On Thu, Jun 10, 2021 at 9:31 AM Liu Shixin <liushixin2@huawei.com> wrote:
>
> Hulk Robot reported memory leak in netlbl_mgmt_add_common.
> The problem is non-freed map in case of netlbl_domhsh_add() failed.
>
> BUG: memory leak
> unreferenced object 0xffff888100ab7080 (size 96):
>   comm "syz-executor537", pid 360, jiffies 4294862456 (age 22.678s)
>   hex dump (first 32 bytes):
>     05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01  ................
>   backtrace:
>     [<0000000008b40026>] netlbl_mgmt_add_common.isra.0+0xb2a/0x1b40
>     [<000000003be10950>] netlbl_mgmt_add+0x271/0x3c0
>     [<00000000c70487ed>] genl_family_rcv_msg_doit.isra.0+0x20e/0x320
>     [<000000001f2ff614>] genl_rcv_msg+0x2bf/0x4f0
>     [<0000000089045792>] netlink_rcv_skb+0x134/0x3d0
>     [<0000000020e96fdd>] genl_rcv+0x24/0x40
>     [<0000000042810c66>] netlink_unicast+0x4a0/0x6a0
>     [<000000002e1659f0>] netlink_sendmsg+0x789/0xc70
>     [<000000006e43415f>] sock_sendmsg+0x139/0x170
>     [<00000000680a73d7>] ____sys_sendmsg+0x658/0x7d0
>     [<0000000065cbb8af>] ___sys_sendmsg+0xf8/0x170
>     [<0000000019932b6c>] __sys_sendmsg+0xd3/0x190
>     [<00000000643ac172>] do_syscall_64+0x37/0x90
>     [<000000009b79d6dc>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Fixes: 63c416887437 ("netlabel: Add network address selectors to the NetLabel/LSM domain mapping")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Liu Shixin <liushixin2@huawei.com>
> ---
>  net/netlabel/netlabel_mgmt.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
> index e664ab990941..e7f00c0f441e 100644
> --- a/net/netlabel/netlabel_mgmt.c
> +++ b/net/netlabel/netlabel_mgmt.c
> @@ -191,6 +191,12 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
>                 entry->family = AF_INET;
>                 entry->def.type = NETLBL_NLTYPE_ADDRSELECT;
>                 entry->def.addrsel = addrmap;
> +
> +               ret_val = netlbl_domhsh_add(entry, audit_info);
> +               if (ret_val != 0) {
> +                       kfree(map);
> +                       goto add_free_addrmap;
> +               }
>  #if IS_ENABLED(CONFIG_IPV6)
>         } else if (info->attrs[NLBL_MGMT_A_IPV6ADDR]) {
>                 struct in6_addr *addr;
> @@ -243,13 +249,19 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
>                 entry->family = AF_INET6;
>                 entry->def.type = NETLBL_NLTYPE_ADDRSELECT;
>                 entry->def.addrsel = addrmap;
> +
> +               ret_val = netlbl_domhsh_add(entry, audit_info);
> +               if (ret_val != 0) {
> +                       kfree(map);
> +                       goto add_free_addrmap;
> +               }
>  #endif /* IPv6 */
> +       } else {
> +               ret_val = netlbl_domhsh_add(entry, audit_info);
> +               if (ret_val != 0)
> +                       goto add_free_addrmap;
>         }
>
> -       ret_val = netlbl_domhsh_add(entry, audit_info);
> -       if (ret_val != 0)
> -               goto add_free_addrmap;
> -

Hi Shixin,

I have a small suggestion about this patch: you can move the variable
map out of if/else if branches, like the following code snippet.

Be aware to assign the variable map to NULL at first. Then kfree in
the last else branch will do nothing.

I don't test the following diff, if there are any issues, please let me know.

diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
index ca52f5085989..1824bcd2272b 100644
--- a/net/netlabel/netlabel_mgmt.c
+++ b/net/netlabel/netlabel_mgmt.c
@@ -78,6 +78,7 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
 {
        int ret_val = -EINVAL;
        struct netlbl_domaddr_map *addrmap = NULL;
+       struct netlbl_domaddr4_map *map = NULL;
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
@@ -195,7 +195,6 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
        } else if (info->attrs[NLBL_MGMT_A_IPV6ADDR]) {
                struct in6_addr *addr;
                struct in6_addr *mask;
-               struct netlbl_domaddr6_map *map;

                addrmap = kzalloc(sizeof(*addrmap), GFP_KERNEL);
                if (addrmap == NULL) {
@@ -247,8 +246,10 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
        }

        ret_val = netlbl_domhsh_add(entry, audit_info);
-       if (ret_val != 0)
+       if (ret_val != 0) {
+               kfree(map);
                goto add_free_addrmap;
+       }

        return 0;





>         return 0;
>
>  add_free_addrmap:
> --
> 2.18.0.huawei.25
>
