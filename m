Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6508E55CD8C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbiF0LSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 07:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbiF0LSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 07:18:12 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AD663F7;
        Mon, 27 Jun 2022 04:18:11 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id q18-20020a9d7c92000000b00616b27cda7cso5534571otn.9;
        Mon, 27 Jun 2022 04:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MlDfKtxm8cDw4sHEiZIcPUA0dM/IHA0IOKEhNhf1DZk=;
        b=NscgHoObVDLgKHijGkS1lmMA7hg9xxc+S0x14Tdo3nH7spOp6M/fbyn/c4qDhqP5YV
         4nqNFmSpDoECwTcgQbT4QFS7ksZaqwrX5Ch8RJsRylmJtqTo/myxHV11A0ocdUBme/i0
         BWkoCdH5VHU4G0eSapIHS4P0px8CQUP95gPjzlKHwHB4dcYnGITRq4MNG57vcI22EEIf
         zb3x/QLfcrmPRu2Uct25iNpu33jhDJS1Fy98t1rjvpCrr196PH1PRYpJbeGecxDniKJg
         sCaSySNYhy6IgBTQKKVv2Lvjxe0k30m8iH3aWQ6UJzG+WcQvbrAvnWgc0O4HzPHJt+6P
         jhXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MlDfKtxm8cDw4sHEiZIcPUA0dM/IHA0IOKEhNhf1DZk=;
        b=afwpqhbM1oMJnGTYfjpMVfX9wRrB8E2eedwoh8vTEB++DdMZTH+/ClXBC9Nmfji+io
         6KoEeb3xGUoO0msAow58sNVNXQQeqUcrJG2q75StugJWEQwSyh+XQVxIzf8VQPJK/Jpw
         EahoGRVjXWLx3rbLgHdK4LYJZUKUlx63eHZfhcs13xd/03pcSupckt3zUb1jsBTIRABm
         FurN1xkTgmqLinGtbpdfgsPiHCKcaT3XQGHuBmKEW7OaCmxQBlwu4kLQCeegmJYwSj7D
         OKHQb595FXydBXZg8tFMHeEqzQXu3VH6q1xZE7p2vpwmCFqWO3QkNuiHnTx7pnNy6g3S
         wqEg==
X-Gm-Message-State: AJIora9EdpS9XE8zbOXoW6+ZOtFNVBteOJ4bevKkkViV+MqWrj8+16Co
        1bGC3MeeppTs1naA4Qz+xrXgReVu6aOWwQKpPK8=
X-Google-Smtp-Source: AGRyM1vAfYKBQwsq8LyNeu6J6SzAC4KrkzViYtfQOGGipCbDhpkgrkt4s9aAW/HfOMrqwIf8nJS55bolYFymkGs61Bg=
X-Received: by 2002:a05:6830:6609:b0:616:c30d:1d11 with SMTP id
 cp9-20020a056830660900b00616c30d1d11mr3393833otb.116.1656328690893; Mon, 27
 Jun 2022 04:18:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220625054524.2445867-1-zys.zljxml@gmail.com> <CANn89iKyovwB1WC0FbGV3tqz2f+0rSShtPjStuEhvyygSjOGrQ@mail.gmail.com>
In-Reply-To: <CANn89iKyovwB1WC0FbGV3tqz2f+0rSShtPjStuEhvyygSjOGrQ@mail.gmail.com>
From:   Katrin Jo <zys.zljxml@gmail.com>
Date:   Mon, 27 Jun 2022 19:18:00 +0800
Message-ID: <CAOaDN_RSOdrWK0wKs__PWENzH8-hx9ynCF0Q71PqxtZo5TJriQ@mail.gmail.com>
Subject: Re: [PATCH v2] ipv6/sit: fix ipip6_tunnel_get_prl when memory
 allocation fails
To:     Eric Dumazet <edumazet@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        katrinzhou <katrinzhou@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 5:01 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sat, Jun 25, 2022 at 7:45 AM <zys.zljxml@gmail.com> wrote:
> >
> > From: katrinzhou <katrinzhou@tencent.com>
> >
> > Fix an illegal copy_to_user() attempt when the system fails to
> > allocate memory for prl due to a lack of memory.
>
> I do not really see an illegal copy_to_user()
>
> c = 0
> -> len = 0
>
> if ((len && copy_to_user(a + 1, kp, len)) || put_user(len, &a->datalen))
>
> So the copy_to_user() should not be called ?
>
> I think you should only mention that after this patch, correct error
> code is returned (-ENOMEM)
>
>
> >
> > Addresses-Coverity: ("Unused value")
> > Fixes: 300aaeeaab5f ("[IPV6] SIT: Add SIOCGETPRL ioctl to get/dump PRL.")
> > Signed-off-by: katrinzhou <katrinzhou@tencent.com>
> > ---
> >
> > Changes in v2:
> > - Move the position of label "out"
> >
> >  net/ipv6/sit.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
> > index c0b138c20992..3330882c0f94 100644
> > --- a/net/ipv6/sit.c
> > +++ b/net/ipv6/sit.c
> > @@ -323,8 +323,6 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
> >                 kcalloc(cmax, sizeof(*kp), GFP_KERNEL_ACCOUNT | __GFP_NOWARN) :
> >                 NULL;
> >
> > -       rcu_read_lock();
> > -
> >         ca = min(t->prl_count, cmax);
> >
> >         if (!kp) {
> > @@ -342,6 +340,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
> >         }
> >
> >         c = 0;
> > +       rcu_read_lock();
> >         for_each_prl_rcu(t->prl) {
> >                 if (c >= cmax)
> >                         break;
> > @@ -353,7 +352,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
> >                 if (kprl.addr != htonl(INADDR_ANY))
> >                         break;
> >         }
> > -out:
> > +
> >         rcu_read_unlock();
> >
> >         len = sizeof(*kp) * c;
> > @@ -362,7 +361,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
> >                 ret = -EFAULT;
> >
> >         kfree(kp);
> > -
> > +out:
> >         return ret;
> >  }
> >
> > --
> > 2.27.0
> >

Thanks for pointing that out. I will modify the message in the next
version of the patch.
And, could c = 0 (line 344) be removed? It is initialized at the beginning.
I think it is a cleanup work.

Best Regards,
Katrin
