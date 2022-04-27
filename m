Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1568551221B
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 21:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbiD0TH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 15:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232563AbiD0THT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 15:07:19 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA56D30F74
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 11:55:10 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id w17so5040703ybh.9
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 11:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j3lBdD4GtdfuLMXUozbnDwowFFcjMZYRVPLsP+AgMcU=;
        b=nZjC+sPezdU6/sIyymL8+lboZ0eGQkFj48qM/Qjp/cuTUskAMS/udm47HLWj9IvxZc
         XInlUz4NInt8kiZ5Dzw/RV/ylrqHJxUqW5pz51Fyh6lGOvxZQbXlmajOczljkcClfQ6m
         9h87VgQF0sAuCDUHk/kXI89Bs5r0vbeyRZwfr5li6y5Imah16Jy5CbDnGQ4YJubUYfyf
         vwL8CrE49NGXLlgSZPK9GukP16eqhvh2MpTWGbeYGfsc64gkB07ktFHsfKTKnagpa/ok
         JtZkQJ2LNVFtN45/JIpeVAJ2RKPu2mRMvEhf6E1Nnf9j+VY7femVp98QnzT33vNTj2DC
         RoYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j3lBdD4GtdfuLMXUozbnDwowFFcjMZYRVPLsP+AgMcU=;
        b=joTebYDXjrthK1t7IyiX+Rj6OSSTQw6n72xnkH7frVcLw7XqIjdErcLd9p39Z4mL6Q
         A++/MRCJ4J/of/iE1Xrmwa5E72T+/Cskm+STfUTgczo4q/JR/MrNCrJtS9fvqyaS75Fc
         rYjsNu38s93fqiAc/buc7Dlt57d3wEGFJCrGsWZlYzL+wnyM7MTTRkCfWe0EKt3QiHIG
         QrHNXsON5HJaJSBDUWGNskZYnXqJz34xMI7cgYl2uJh6yVXuezX1MGSUskpgqOWQCecS
         7sOzWHs6oHVKIV7KDkoWJ7DeZXKnPSq09lQ7Ml5/7108b4t3fLmhNHOQCZFoJ7q552QM
         D4TA==
X-Gm-Message-State: AOAM5310NdnjU8sGYKTo7/vdN96eQR7aZOzkyrR9m5LvGEa44Qkd+pqo
        B9bHJ32FxLnpfRZblCkW6ko8fXd8F7UE6nKom+TNKw==
X-Google-Smtp-Source: ABdhPJzHHPoayLSkVHp95DEYm6a44e5llK2VixyILwyrvUOLFsqrlfdfrZRTos9Yhc8iYa3UFHCT1YYaAr/cy41kCqc=
X-Received: by 2002:a25:2a49:0:b0:648:f2b4:cd3d with SMTP id
 q70-20020a252a49000000b00648f2b4cd3dmr1024330ybq.231.1651085709765; Wed, 27
 Apr 2022 11:55:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220422201237.416238-1-eric.dumazet@gmail.com>
 <YmlilMi5MmApVqTX@shredder> <CANn89i+x44iM97YmGa6phMMUx6L5a3Cn86aNwq3OsbQf3iVgWA@mail.gmail.com>
 <CANn89iLue8fy-6TTEsTwzWAog-KnAcsG19up34621W8Bp+0=NQ@mail.gmail.com> <CANn89iK3uzj4MzAyPrjQVR+5fZQaBdopuMEAZGP6QmWeXZj19Q@mail.gmail.com>
In-Reply-To: <CANn89iK3uzj4MzAyPrjQVR+5fZQaBdopuMEAZGP6QmWeXZj19Q@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 27 Apr 2022 11:54:58 -0700
Message-ID: <CANn89iKEUb9DWWMggsTiRjuEs=+X1631q1bU=foH2krb-tiT_Q@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net: generalize skb freeing deferral to
 per-cpu lists
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 10:59 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Apr 27, 2022 at 10:11 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Wed, Apr 27, 2022 at 9:53 AM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Wed, Apr 27, 2022 at 8:34 AM Ido Schimmel <idosch@idosch.org> wrote:
> > > >
> > >
> > > >
> > > > Eric, with this patch I'm seeing memory leaks such as these [1][2] after
> > > > boot. The system is using the igb driver for its management interface
> > > > [3]. The leaks disappear after reverting the patch.
> > > >
> > > > Any ideas?
> > > >
> > >
> > > No idea, skbs allocated to send an ACK can not be stored in receive
> > > queue, I guess this is a kmemleak false positive.
> > >
> > > Stress your host for hours, and check if there are real kmemleaks, as
> > > in memory being depleted.
> >
> > AT first when I saw your report I wondered if the following was needed,
> > but I do not think so. Nothing in __kfree_skb(skb) cares about skb->next.
> >
> > But you might give it a try, maybe I am wrong.
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 611bd719706412723561c27753150b27e1dc4e7a..9dc3443649b962586cc059899ac3d71e9c7a3559
> > 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6594,6 +6594,7 @@ static void skb_defer_free_flush(struct softnet_data *sd)
> >
> >         while (skb != NULL) {
> >                 next = skb->next;
> > +               skb_mark_not_on_list(skb);
> >                 __kfree_skb(skb);
> >                 skb = next;
> >         }
>
> Oh well, there is definitely a leak, sorry for that.

Ido, can you test if the following patch solves your issue ?
It definitely looks needed.

Thanks !

diff --git a/net/core/dev.c b/net/core/dev.c
index 611bd719706412723561c27753150b27e1dc4e7a..e09cd202fc579dfe2313243e20def8044aafafa2
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6617,7 +6617,7 @@ static __latent_entropy void
net_rx_action(struct softirq_action *h)

                if (list_empty(&list)) {
                        if (!sd_has_rps_ipi_waiting(sd) && list_empty(&repoll))
-                               return;
+                               goto end;
                        break;
                }

@@ -6644,6 +6644,7 @@ static __latent_entropy void
net_rx_action(struct softirq_action *h)
                __raise_softirq_irqoff(NET_RX_SOFTIRQ);

        net_rps_action_and_irq_enable(sd);
+end:
        skb_defer_free_flush(sd);
 }
