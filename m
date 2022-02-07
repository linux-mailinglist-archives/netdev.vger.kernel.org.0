Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A1B4AC8DC
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 19:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbiBGSwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 13:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235186AbiBGSvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 13:51:10 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A2FC0401DA
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 10:51:08 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id v186so42988762ybg.1
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 10:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G3C/ia8dQRTRLjg0OoFrC2IgLazdEPO0o5eddLxNF9g=;
        b=YbdflBHXhQpYmpoKWpjSGWEQ2qVbz7DWPuYhvOqYvdyqPeqBsLCkob4qz0vqErorBH
         wkQ+vuBX7J0/jSfUWy/w40Ru0BMiiWWIoT13SJILzRBN7ncvG7daVeauRPomHvKy5zKd
         H/Nzx7fZo44SdeWGVvRcm+b05OyWa5bypv41V/GFWPwIFUqJqwwKwTZTWofpe6ykU9UI
         5gZAP51SMMbLBfRZS6WnFNMbQ+CxLyf/8ISXpE1aL1NzDR+nJORFGqOlpzKIZ9zAAQS3
         WZdcB/47uuXaAoIVH8SP0n2JpDiU0c1zcJsEmHdgVD1Xm/DSHQ4Q1YoDNaeuhtVR1qjq
         st3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G3C/ia8dQRTRLjg0OoFrC2IgLazdEPO0o5eddLxNF9g=;
        b=OZyvOh0SIZI08Yqxy56BC6056AqhKPfkK51Vm3D1OchFLuFOYDjuVR6/uGBQbQfBX6
         ZFEne5WXA3/YR3L4Bj+MEbhC+LML6bGONHuMCTtDaXhmlPRJnB68BImGOJ0t4QC8KEpS
         /Ti4CYfrAhgcP9IIGCiM7GdIgo6xQjIHWAh91gbXeDxevd+siJkNB7Zy8qrgo7DQC2TX
         0/jmJfIaBZr4H73IomFrhBHmRQk6atkWEh9M/jvOHbX9EnTBfIMArJ6Zk3rQe7UUVuer
         R5i3Xj68Ah/PGBnMPxsEvVdf7hAw44g+cK5GB8Jc/jhhG58b6ePWt+n4tAZzIheFeFS9
         a7Ug==
X-Gm-Message-State: AOAM532FmJHaMoAwUt89i2a97XkhlhPY7H/8hfNRVO1+fVHzPlC7BOsZ
        7AxI8Sr71Zm9wsdu8aq4b7eJq86rlJG/0gUlkOJfgTvIzfQQXddY
X-Google-Smtp-Source: ABdhPJwGklcxlgTw1GLX04btOZ8vmYiLnYix+Za4LWd0Exl1M31H0rn0lsN98kE9jv2bkqst8vBwZ7jFGoTpoM1XuF8=
X-Received: by 2002:a81:8742:: with SMTP id x63mr1292264ywf.112.1644259867737;
 Mon, 07 Feb 2022 10:51:07 -0800 (PST)
MIME-Version: 1.0
References: <20220207171756.1304544-1-eric.dumazet@gmail.com>
 <20220207171756.1304544-10-eric.dumazet@gmail.com> <c81703cb-a2b1-4a45-3c5f-0833576f4785@hartkopp.net>
 <CANn89iJhf+-myjz0GgTeWmohnoBottRa+nP8DPqM3yoS64cmHQ@mail.gmail.com> <70900ebc-876d-cbb3-a048-9104e2e96420@hartkopp.net>
In-Reply-To: <70900ebc-876d-cbb3-a048-9104e2e96420@hartkopp.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 7 Feb 2022 10:50:56 -0800
Message-ID: <CANn89iJQayZegWUQYQEXuuhKTT5K9DQCQMCo6q4b1VxmWJD__A@mail.gmail.com>
Subject: Re: [PATCH net-next 09/11] can: gw: switch cangw_pernet_exit() to
 batch mode
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 7, 2022 at 10:40 AM Oliver Hartkopp <socketcan@hartkopp.net> wrote:
>
>
>
> On 07.02.22 18:54, Eric Dumazet wrote:
> > On Mon, Feb 7, 2022 at 9:41 AM Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> (..)
> >>> -static void __net_exit cangw_pernet_exit(struct net *net)
> >>> +static void __net_exit cangw_pernet_exit_batch(struct list_head *net_list)
> >>>    {
> >>> +     struct net *net;
> >>> +
> >>>        rtnl_lock();
> >>> -     cgw_remove_all_jobs(net);
> >>> +     list_for_each_entry(net, net_list, exit_list)
> >>> +             cgw_remove_all_jobs(net);
> >>
> >> Instead of removing the jobs for ONE net namespace it seems you are
> >> remove removing the jobs for ALL net namespaces?
> >>
> >> Looks wrong to me.
> >
> > I see nothing wrong in my patch.
> >
> > I think you have to look more closely at ops_exit_list() in
> > net/core/net_namespace.c
>
> Ok, thanks. Your patch just moved the list_for_each_entry() to gw.c.
> So there is no functional difference.
>
> Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
>
> > BTW, the sychronize_rcu() call in cgw_remove_all_jobs is definitely
> > bad, you should absolutely replace it by call_rcu() or kfree_rcu()
>
> Advise is welcome!
>
> The synchronize_rcu() has been introduced in fb8696ab14ad ("can: gw:
> synchronize rcu operations before removing gw job entry") as
> can_can_gw_rcv() is called under RCU protection (NET_RX softirq).
>
> That patch was a follow-up to d5f9023fa61e ("can: bcm: delay release of
> struct bcm_op after synchronize_rcu()") where Thadeu Lima de Souza
> Cascardo detected a race in the BCM code.
>
> When call_rcu() is enough to make sure we do not get a race in
> can_can_gw_rcv() while receiving skbs and removing filters with
> cgw_unregister_filter() I would be happy this rcu thing being fixed up.
>

Can you test this straightforward patch, thanks !
diff --git a/net/can/gw.c b/net/can/gw.c
index d8861e862f157aec36c417b71eb7e8f59bd064b9..20e74fe7d0906dccc65732b8f9e7e14e2d1192c3
100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -577,6 +577,13 @@ static inline void cgw_unregister_filter(struct
net *net, struct cgw_job *gwj)
                          gwj->ccgw.filter.can_mask, can_can_gw_rcv, gwj);
 }

+static void cgw_job_free_rcu(struct rcu_head *rcu_head)
+{
+       struct cgw_job *gwj = container_of(rcu_head, struct cgw_job, rcu);
+
+       kmem_cache_free(cgw_cache, gwj);
+}
+
 static int cgw_notifier(struct notifier_block *nb,
                        unsigned long msg, void *ptr)
 {
@@ -596,8 +603,7 @@ static int cgw_notifier(struct notifier_block *nb,
                        if (gwj->src.dev == dev || gwj->dst.dev == dev) {
                                hlist_del(&gwj->list);
                                cgw_unregister_filter(net, gwj);
-                               synchronize_rcu();
-                               kmem_cache_free(cgw_cache, gwj);
+                               call_rcu(&gwj->rcu, cgw_job_free_rcu);
                        }
                }
        }
@@ -1155,8 +1161,7 @@ static void cgw_remove_all_jobs(struct net *net)
        hlist_for_each_entry_safe(gwj, nx, &net->can.cgw_list, list) {
                hlist_del(&gwj->list);
                cgw_unregister_filter(net, gwj);
-               synchronize_rcu();
-               kmem_cache_free(cgw_cache, gwj);
+               call_rcu(&gwj->rcu, cgw_job_free_rcu);
        }
 }

@@ -1224,8 +1229,7 @@ static int cgw_remove_job(struct sk_buff *skb,
struct nlmsghdr *nlh,

                hlist_del(&gwj->list);
                cgw_unregister_filter(net, gwj);
-               synchronize_rcu();
-               kmem_cache_free(cgw_cache, gwj);
+               call_rcu(&gwj->rcu, cgw_job_free_rcu);
                err = 0;
                break;
        }
