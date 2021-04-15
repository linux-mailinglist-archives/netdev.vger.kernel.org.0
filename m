Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4377361411
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 23:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbhDOVZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 17:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235584AbhDOVZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 17:25:09 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF9EC061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 14:24:46 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id w4so20940932wrt.5
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 14:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qxjMO1pimbrQemwb6NkKZVnAtJilSBgulm/qXMfwL8o=;
        b=EBgZJmwMYFz2K2zpiXdWACehaWfuRhWpiL9Ok7jW81SsltPJ+AuYUPMvpTbO7B+Zcm
         8M9Q9RWIawWKkq3yPfOnCWu0d9bDNCb/XW9Rkrme1vPC+dGblEr45UzgF8TBseFf60Cm
         rsiR/UDFFxx6voFagJr1zBUSG1p8f+ohcS2CHoqz64HQeq0A7Cq/3+uGnscELtF7SZuO
         fwbRKjhDfxJ+di7Dvz5vHegbUiL8SpxmVR5NikBHFQW8/vPxFki7xVIGxSpaPPOpuj35
         ry4Uz+CNRDVqYfj5vb3x8pgS4rXz2K+7LaEmeTBgW4gkR2Khcfk0OdraWRYFNBrL8eVY
         uinA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qxjMO1pimbrQemwb6NkKZVnAtJilSBgulm/qXMfwL8o=;
        b=l9vlG9iPsT6CiK+ALkA1xScL7UXyCexAVkf5SfPLva/P7HbBZQi1UTH9QMflWt7gVV
         v1+oBWIl3fDADW9vC8F5Bi4Vm3SlqQ4FzxkjoHpvCQGg5Ugvh8bMNAGn5FZqUiCYiZQ0
         /JDwBGDUZxb+WXVIe9ZEyeU6DmPsqCghGS0SldW6NzeryU5PpO+FIFubuivttKnJxOyf
         AhfIEbDVJABHzRsYwQMPm/IvKKSTYjMOr20DPja35Eiqp1nIybOue7Y/mxGMn8SxiZNx
         uAKrA1gnrov/1kXpM3PDtPrUUTxwdi0tWphuFp7t0h82iHvRD+y4bMRT+/jT5Y9XxDAf
         mfnA==
X-Gm-Message-State: AOAM530W5nnKawo4AchxqX3pvTIuZhuGk063yjkTaah2Z6WGjs4tc6w9
        W/S7AEBqjxR1WkcZ2ClHV0elQOAT4lF70nV1CWg=
X-Google-Smtp-Source: ABdhPJw3E53NjVVoyw4vPtykoHdL7OuILvjd/jA8GgkXWL+29M0D3CrZgayNGnMFmXDr70VfgcJntCxiHp50eikDx6A=
X-Received: by 2002:a5d:49ca:: with SMTP id t10mr5569903wrs.395.1618521884021;
 Thu, 15 Apr 2021 14:24:44 -0700 (PDT)
MIME-Version: 1.0
References: <20191005180442.11788-1-jiri@resnulli.us> <20191005180442.11788-8-jiri@resnulli.us>
In-Reply-To: <20191005180442.11788-8-jiri@resnulli.us>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 15 Apr 2021 17:24:32 -0400
Message-ID: <CADvbK_e70AOti7p6VfCPcu9X3VTEiKXO2r4RJbAtX1w58GyZYg@mail.gmail.com>
Subject: Re: [patch net-next 07/10] net: tipc: have genetlink code to parse
 the attrs during dumpit
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>, johannes.berg@intel.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Yuehaibing <yuehaibing@huawei.com>, mlxsw@mellanox.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 5, 2019 at 2:09 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> From: Jiri Pirko <jiri@mellanox.com>
>
> Benefit from the fact that the generic netlink code can parse the attrs
> for dumpit op and avoid need to parse it in the op callback.
>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  net/tipc/netlink.c   | 9 ++++++---
>  net/tipc/node.c      | 6 +-----
>  net/tipc/socket.c    | 6 +-----
>  net/tipc/udp_media.c | 6 +-----
>  4 files changed, 9 insertions(+), 18 deletions(-)
>
> diff --git a/net/tipc/netlink.c b/net/tipc/netlink.c
> index d6165ad384c0..5f5df232d72b 100644
> --- a/net/tipc/netlink.c
> +++ b/net/tipc/netlink.c
> @@ -176,7 +176,8 @@ static const struct genl_ops tipc_genl_v2_ops[] = {
>         },
>         {
>                 .cmd    = TIPC_NL_PUBL_GET,
> -               .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> +               .validate = GENL_DONT_VALIDATE_STRICT |
> +                           GENL_DONT_VALIDATE_DUMP_STRICT,
>                 .dumpit = tipc_nl_publ_dump,
>         },
>         {
> @@ -239,7 +240,8 @@ static const struct genl_ops tipc_genl_v2_ops[] = {
>         },
>         {
>                 .cmd    = TIPC_NL_MON_PEER_GET,
> -               .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> +               .validate = GENL_DONT_VALIDATE_STRICT |
> +                           GENL_DONT_VALIDATE_DUMP_STRICT,
>                 .dumpit = tipc_nl_node_dump_monitor_peer,
>         },
>         {
> @@ -250,7 +252,8 @@ static const struct genl_ops tipc_genl_v2_ops[] = {
>  #ifdef CONFIG_TIPC_MEDIA_UDP
>         {
>                 .cmd    = TIPC_NL_UDP_GET_REMOTEIP,
> -               .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> +               .validate = GENL_DONT_VALIDATE_STRICT |
> +                           GENL_DONT_VALIDATE_DUMP_STRICT,
>                 .dumpit = tipc_udp_nl_dump_remoteip,
>         },
Hi Jiri,

can I ask you why GENL_DONT_VALIDATE_DUMP_STRICT flag is needed when
using genl_dumpit_info(cb)->attrs in dumpit?

Thanks.

>  #endif
> diff --git a/net/tipc/node.c b/net/tipc/node.c
> index c8f6177dd5a2..f2e3cf70c922 100644
> --- a/net/tipc/node.c
> +++ b/net/tipc/node.c
> @@ -2484,13 +2484,9 @@ int tipc_nl_node_dump_monitor_peer(struct sk_buff *skb,
>         int err;
>
>         if (!prev_node) {
> -               struct nlattr **attrs;
> +               struct nlattr **attrs = genl_dumpit_info(cb)->attrs;
>                 struct nlattr *mon[TIPC_NLA_MON_MAX + 1];
>
> -               err = tipc_nlmsg_parse(cb->nlh, &attrs);
> -               if (err)
> -                       return err;
> -
>                 if (!attrs[TIPC_NLA_MON])
>                         return -EINVAL;
>
> diff --git a/net/tipc/socket.c b/net/tipc/socket.c
> index 3b9f8cc328f5..d579b64705b1 100644
> --- a/net/tipc/socket.c
> +++ b/net/tipc/socket.c
> @@ -3588,13 +3588,9 @@ int tipc_nl_publ_dump(struct sk_buff *skb, struct netlink_callback *cb)
>         struct tipc_sock *tsk;
>
>         if (!tsk_portid) {
> -               struct nlattr **attrs;
> +               struct nlattr **attrs = genl_dumpit_info(cb)->attrs;
>                 struct nlattr *sock[TIPC_NLA_SOCK_MAX + 1];
>
> -               err = tipc_nlmsg_parse(cb->nlh, &attrs);
> -               if (err)
> -                       return err;
> -
>                 if (!attrs[TIPC_NLA_SOCK])
>                         return -EINVAL;
>
> diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
> index 287df68721df..43ca5fd6574d 100644
> --- a/net/tipc/udp_media.c
> +++ b/net/tipc/udp_media.c
> @@ -448,15 +448,11 @@ int tipc_udp_nl_dump_remoteip(struct sk_buff *skb, struct netlink_callback *cb)
>         int i;
>
>         if (!bid && !skip_cnt) {
> +               struct nlattr **attrs = genl_dumpit_info(cb)->attrs;
>                 struct net *net = sock_net(skb->sk);
>                 struct nlattr *battrs[TIPC_NLA_BEARER_MAX + 1];
> -               struct nlattr **attrs;
>                 char *bname;
>
> -               err = tipc_nlmsg_parse(cb->nlh, &attrs);
> -               if (err)
> -                       return err;
> -
>                 if (!attrs[TIPC_NLA_BEARER])
>                         return -EINVAL;
>
> --
> 2.21.0
>
