Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953C35E9BEE
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 10:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbiIZIZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 04:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbiIZIZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 04:25:40 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA341759E
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 01:25:39 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id a10so6619852ljq.0
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 01:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=GZBV9OGw8DdSGYGJkRdjOca8Y5MVevVqvq54GVdoBQo=;
        b=iKL1/IFU8J7oqMca4hSRicdDK/Fsiv9H8/SiPwKRfULevTIlrPuMFUQsC6yBFbXZzB
         gScA/rralH8vxBVEFlh9IHSoxMiF84PIaqwYTjCr+o8vRuaSn8JGhl+SQj3YfADTVKWo
         8v7ftlHrJo7PUJP+nb9YGu5Lzi5pRE2hDDtxB2pjL7ZuokdGTlzt+/AQz/xb99RjiRyh
         xpLW/DXfqnxU3+XnUb424agl2Z9dlOkCMZGkgow+pNKO9RyPCXp4eRRVICHTKs5vJZ1R
         LmOtcK/8JlARqvyOvlgZSsvcsaqaNFZ+jMbHcqD7rus2ECHvDp3z692bh84qFOAXC+IJ
         pMcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=GZBV9OGw8DdSGYGJkRdjOca8Y5MVevVqvq54GVdoBQo=;
        b=JW/Va6th2rALpnI3bjCGeOljo3O27Jq450QRGYgymH5jfYgB2aVM+B5CgucCBOl04e
         wEbbDyBRQwRkxoRYTv7H1n9rceCcGq6le9DPeDPcFBvwM6kpBW1OE29qJPPIpTTFVgwz
         9uv8rdnEcFOQwIO9qySpWGd0HkHmd7Mr4Acdg9JCCnFEe+mDZhf0CVGrxdWBkOhcR5/b
         vb14IfWw8353DVuKRg2vsPZf1+5YfggRfHgsWyL7QKDQsLS50VudMmYFISBdYLorNN0u
         gz6VllwHt55dWV2iSWfPpo0h4pft8U74tT6INFvbYJgNcklBwq33sZ6/QlysXNdOZNkQ
         QWiw==
X-Gm-Message-State: ACrzQf3IePmxpbPwQLhPokJTHU698SZbmplvoMAc7zT+x1KcoI4domLZ
        MWY8suhVJluLuOdon2+iNKlcqrnDhJYONkpdzMJEAN1nW3smCg==
X-Google-Smtp-Source: AMsMyM5xOnckrhjvMrFl8d4zWmf04h0VUWm4Lins3h04HT7tmCGZVj4oHmCvEOgTex4iD0WMmhGuuyzuP7CzxI7xzi4=
X-Received: by 2002:a2e:80c6:0:b0:26c:67ef:16ed with SMTP id
 r6-20020a2e80c6000000b0026c67ef16edmr7328980ljg.133.1664180738018; Mon, 26
 Sep 2022 01:25:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220923160937.1912-1-claudiajkang@gmail.com> <YzFYYXcZaoPXcLz/@corigine.com>
 <CAK+SQuRj=caHiyrtVySVoxRrhNttfg_cSbNFjG2PL7Fc0_ObGg@mail.gmail.com> <YzFgnIUFy49QX2b6@corigine.com>
In-Reply-To: <YzFgnIUFy49QX2b6@corigine.com>
From:   Juhee Kang <claudiajkang@gmail.com>
Date:   Mon, 26 Sep 2022 17:25:01 +0900
Message-ID: <CAK+SQuTHciJWhCi-YAQKPG4cwh7zB9_WR=-zK3xTUq9eTtE4+g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: use netdev_unregistering instead of
 open code
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, skhan@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 5:19 PM Simon Horman <simon.horman@corigine.com> wrote:
>
> On Mon, Sep 26, 2022 at 05:05:08PM +0900, Juhee Kang wrote:
> > Hi Simon,
>
> ...
>
> > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > index d66c73c1c734..f3f9394f0b5a 100644
> > > > --- a/net/core/dev.c
> > > > +++ b/net/core/dev.c
> > > > @@ -2886,8 +2886,7 @@ int netif_set_real_num_tx_queues(struct net_device *dev, unsigned int txq)
> > > >         if (txq < 1 || txq > dev->num_tx_queues)
> > > >                 return -EINVAL;
> > > >
> > > > -       if (dev->reg_state == NETREG_REGISTERED ||
> > > > -           dev->reg_state == NETREG_UNREGISTERING) {
> > > > +       if (dev->reg_state == NETREG_REGISTERED || netdev_unregistering(dev)) {
> > > >                 ASSERT_RTNL();
> > > >
> > > >                 rc = netdev_queue_update_kobjects(dev, dev->real_num_tx_queues,
> > >
> > > Is there any value in adding a netdev_registered() helper?
> > >
> >
> > The open code which is reg_state == NETREG_REGISTERED used 37 times on
> > some codes related to the network. I think that the
> > netdev_registered() helper is valuable.
>
> Thanks, FWIIW, that seems likely to me too.

Thanks!
Apart from this patch, is it okay to send a patch that adds the
netdev_registered helper function later?
