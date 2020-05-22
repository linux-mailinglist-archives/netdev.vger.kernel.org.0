Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EEC1DDF7B
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 07:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgEVFuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 01:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgEVFuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 01:50:07 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768B7C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 22:50:07 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x14so3562356wrp.2
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 22:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J6uSgIvPffs8sYSrm4TgY70ZIgmbCFOZNIf03xy/8TM=;
        b=VZgtZRdnYkalv8ZUJqh0E3r5eGsSdNIMPRa76YQ7u1I2FCHScbjayAfle0YSlqQ9rH
         7KqsWW4sBkTLwPcsnNzW0qvUQ2ujV1CzLkmCP6ug4gfvaDQD4j08GSEuGvNvmNI7r6uC
         WEWNsiLknAOGbKwTjaNu159/mBICpjSbSawtfSliR0pWHKsGBVZ/SgjEiqKH7Bftsy/x
         +awCBDi8HzrG3nvfGHq1Y5oc+L3yhvw3BOEmS7SvK7YWjWpyvVNIeOF9Ldlk4uQMBrm7
         fO7gTHnSf3LBHfRE70xCc/jGlbeIlRYo76p4uGq0i+1ZNHaaV2BumqOEU08bDsGLHeTb
         X9hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J6uSgIvPffs8sYSrm4TgY70ZIgmbCFOZNIf03xy/8TM=;
        b=ZIQb/7g4ZNgALhHUOGR4R5oyYGyiNRNAL7+K2AEqpSBudI4ZLU5YQiBUQpdtkpOZYI
         vmw/UnubUiyi4yT7nDiaODBO9hw1Nv0iNkYTUBXSM7DC6P9oNSYuphY37jXBNFeMw1E0
         5eaUjl0EuJEDpNmKgyXT/F2iqWDmxjHgRfvzY90rETYJT+L+Na9rd+nQ6spjk8e/Olcw
         DUPcICB4EWdUp9xbSCDwN7a5552gp3IeVQTEHKtlzsynAjRF6k8sW/H2Jmm/3iiOpCxH
         ZPKPocekLW/0XO/NgXz+ukbkQKwH11GqqjE4KBciNTH/lCmRkr14Ks4/7frZ1l4AxITj
         6K/A==
X-Gm-Message-State: AOAM530yfA6bxJ1vlzw0Lz6r2rXT3H4lE5H1/ESXU7nsjkxEIPrlIBpq
        g7Bb2ZECmQIF0Ppro3E6rDF9I9btzL5MDfIx914=
X-Google-Smtp-Source: ABdhPJw4DeYZleFTX1EJLs/H30S4MbCmeqWDFq6H9bEXkXrlLci8WVJBo1Ur/TpZ5quz+mwsd1IOyuhYHi5FSskXN/Y=
X-Received: by 2002:a5d:4388:: with SMTP id i8mr1801609wrq.299.1590126606201;
 Thu, 21 May 2020 22:50:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200521182958.163436-1-edumazet@google.com>
In-Reply-To: <20200521182958.163436-1-edumazet@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 22 May 2020 13:56:57 +0800
Message-ID: <CADvbK_cdSYZvTj6jFCXHEU0VhD8K7aQ3ky_fvUJ49N-5+ykJkg@mail.gmail.com>
Subject: Re: [PATCH net] tipc: block BH before using dst_cache
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 2:30 AM Eric Dumazet <edumazet@google.com> wrote:
>
> dst_cache_get() documents it must be used with BH disabled.
Interesting, I thought under rcu_read_lock() is enough, which calls
preempt_disable().
have you checked other places where dst_cache_get() are used?

>
> sysbot reported :
>
> BUG: using smp_processor_id() in preemptible [00000000] code: /21697
> caller is dst_cache_get+0x3a/0xb0 net/core/dst_cache.c:68
> CPU: 0 PID: 21697 Comm:  Not tainted 5.7.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>  check_preemption_disabled lib/smp_processor_id.c:47 [inline]
>  debug_smp_processor_id.cold+0x88/0x9b lib/smp_processor_id.c:57
>  dst_cache_get+0x3a/0xb0 net/core/dst_cache.c:68
>  tipc_udp_xmit.isra.0+0xb9/0xad0 net/tipc/udp_media.c:164
>  tipc_udp_send_msg+0x3e6/0x490 net/tipc/udp_media.c:244
>  tipc_bearer_xmit_skb+0x1de/0x3f0 net/tipc/bearer.c:526
>  tipc_enable_bearer+0xb2f/0xd60 net/tipc/bearer.c:331
>  __tipc_nl_bearer_enable+0x2bf/0x390 net/tipc/bearer.c:995
>  tipc_nl_bearer_enable+0x1e/0x30 net/tipc/bearer.c:1003
>  genl_family_rcv_msg_doit net/netlink/genetlink.c:673 [inline]
>  genl_family_rcv_msg net/netlink/genetlink.c:718 [inline]
>  genl_rcv_msg+0x627/0xdf0 net/netlink/genetlink.c:735
>  netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
>  genl_rcv+0x24/0x40 net/netlink/genetlink.c:746
>  netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
>  netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
>  netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:672
>  ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
>  ___sys_sendmsg+0x100/0x170 net/socket.c:2416
>  __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
>  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> RIP: 0033:0x45ca29
>
> Fixes: e9c1a793210f ("tipc: add dst_cache support for udp media")
> Cc: Xin Long <lucien.xin@gmail.com>
> Cc: Jon Maloy <jon.maloy@ericsson.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> ---
>  net/tipc/udp_media.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
> index d6620ad535461a4d04ed5ba90569ce8b7df9f994..28a283f26a8dff24d613e6ed57e5e69d894dae66 100644
> --- a/net/tipc/udp_media.c
> +++ b/net/tipc/udp_media.c
> @@ -161,9 +161,11 @@ static int tipc_udp_xmit(struct net *net, struct sk_buff *skb,
>                          struct udp_bearer *ub, struct udp_media_addr *src,
>                          struct udp_media_addr *dst, struct dst_cache *cache)
>  {
> -       struct dst_entry *ndst = dst_cache_get(cache);
> +       struct dst_entry *ndst;
>         int ttl, err = 0;
>
> +       local_bh_disable();
> +       ndst = dst_cache_get(cache);
>         if (dst->proto == htons(ETH_P_IP)) {
>                 struct rtable *rt = (struct rtable *)ndst;
>
> @@ -210,9 +212,11 @@ static int tipc_udp_xmit(struct net *net, struct sk_buff *skb,
>                                            src->port, dst->port, false);
>  #endif
>         }
> +       local_bh_enable();
>         return err;
>
>  tx_error:
> +       local_bh_enable();
>         kfree_skb(skb);
>         return err;
>  }
> --
> 2.27.0.rc0.183.gde8f92d652-goog
>
