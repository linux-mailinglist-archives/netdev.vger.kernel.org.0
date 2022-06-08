Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0E25437C5
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244490AbiFHPlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244512AbiFHPls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:41:48 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD841DB1EC
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 08:41:46 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-30ec2aa3b6cso213039497b3.11
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 08:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LP4fGiwchOepUXQLJyNFXiUoA+zS//fcsT/cuwm4tlI=;
        b=QxaZRbC+2xrn1jOOcDVjvPkPscG2uVMODGD/tLVJ02xN+b1Rt1/o4BiwhKf4XNlIAt
         nGJII3de+kH4Mia94+RW5sjguzHjeuSB+L112NY6jvuWJO9gQ9K8sIrhDkuM2yGBm7Dp
         1CVFhSqXMmeOYQkYNl9HAAcfhNqPZF1ztseJCv4s8D+PCZYeMOpk2NQ3hwef8pUOKfwe
         ZAXyGc5jCtH6GDWxwq32WsYe2ZyT+0GVqcjj4mQif9v/l/U1s97szKcizc4OYlZsb5I6
         nI74p4Srya/Y6wnW5y1o14FBbq8CXwhbWCjaLhc/kRLeHDfRc638q2QYNh/9j+QNd7eY
         icXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LP4fGiwchOepUXQLJyNFXiUoA+zS//fcsT/cuwm4tlI=;
        b=jrx4FZ5UwkQTm9udm0aDh6z1K56oj1ENxBdHIoJz/nIZd1+KpGY1ZuhpqAXlFNGKpg
         2XrAjPgLnSzbNTKrTjHUXj6YiX5m4/OvncanRx2VDvS4NEC0cO9F/RKBTML8iSszYB43
         AJ1TRIQceOin6hUV86XE/ld7Df71SRUhsL1GE3sulCmwKiMzgngGJDGq3Mo+bo/ZMtqo
         XCBjPn0b1xU/SlUMDdHS620BAja69psERBMHEwwBpVuuF/P4oqGHwgrCnEDWCZgXeXfX
         c+Yb4EuNiS7M4pJ46uYYtbhImF68hkbrQ6tztIAsHbeDUU71fgWE7SySzpwpq7bsGbHU
         Fnng==
X-Gm-Message-State: AOAM532Yywok8B7n2sSW5clW+jPDnkvWPke89EPdwXRT92WmQAMRqdRw
        k6uj7nLUNOH5OYc5CxTlZXaX94gxgh3C0cZLyx4rJA==
X-Google-Smtp-Source: ABdhPJyzCbKfc9P/w1c9Y/NE3YSYjNXBkE+0G3tG5wqyS/4KzQYufihhOFInjQRvRfuCT4gUfxMwVvwgPBs4SYeolUM=
X-Received: by 2002:a81:6ad4:0:b0:30c:45af:ae3f with SMTP id
 f203-20020a816ad4000000b0030c45afae3fmr37040988ywc.55.1654702905904; Wed, 08
 Jun 2022 08:41:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220607233614.1133902-1-eric.dumazet@gmail.com>
 <20220607233614.1133902-6-eric.dumazet@gmail.com> <YqBRan+zhcf9d4EU@zx2c4.com>
In-Reply-To: <YqBRan+zhcf9d4EU@zx2c4.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 8 Jun 2022 08:41:34 -0700
Message-ID: <CANn89iKJpBPzJHaNt5CnLxCqxMTdwg9Y2ZQeRwXfcMLkbvwG4g@mail.gmail.com>
Subject: Re: [PATCH net-next 5/9] wireguard: use dev_sw_netstats_rx_add()
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
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

On Wed, Jun 8, 2022 at 12:36 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Eric,
>
> On Tue, Jun 07, 2022 at 04:36:10PM -0700, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > We have a convenient helper, let's use it.
> > This will make the following patch easier to review and smaller.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Jason A. Donenfeld <Jason@zx2c4.com>
>
> The subject line should be:
>
>     wireguard: receive: use dev_sw_netstats_rx_add()
>
> Please don't commit it before changing that. With that addressed,
>
>     Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
>

Got it, thanks.


> Regards,
> Jason
>
> >  drivers/net/wireguard/receive.c | 9 +--------
> >  1 file changed, 1 insertion(+), 8 deletions(-)
> >
> > diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
> > index 7b8df406c7737398f0270361afcb196af4b6a76e..7135d51d2d872edb66c856379ce2923b214289e9 100644
> > --- a/drivers/net/wireguard/receive.c
> > +++ b/drivers/net/wireguard/receive.c
> > @@ -19,15 +19,8 @@
> >  /* Must be called with bh disabled. */
> >  static void update_rx_stats(struct wg_peer *peer, size_t len)
> >  {
> > -     struct pcpu_sw_netstats *tstats =
> > -             get_cpu_ptr(peer->device->dev->tstats);
> > -
> > -     u64_stats_update_begin(&tstats->syncp);
> > -     ++tstats->rx_packets;
> > -     tstats->rx_bytes += len;
> > +     dev_sw_netstats_rx_add(peer->device->dev, len);
> >       peer->rx_bytes += len;
> > -     u64_stats_update_end(&tstats->syncp);
> > -     put_cpu_ptr(tstats);
> >  }
> >
> >  #define SKB_TYPE_LE32(skb) (((struct message_header *)(skb)->data)->type)
> > --
> > 2.36.1.255.ge46751e96f-goog
> >
