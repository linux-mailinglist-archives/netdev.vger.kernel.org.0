Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8018D5E9C12
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 10:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbiIZIaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 04:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbiIZIaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 04:30:20 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB8A1F2FC
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 01:30:17 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id s6so9640606lfo.7
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 01:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=vA99qk4zuxuYCYpdjliDhljjfb71ReXyQG1Dc2N3ihQ=;
        b=L9704/5EMN0mJMLBoCyVUW9y0pozrFDPNG3Vjzyc5Rytq1mUu5jTYQl8TeQlPe9YtW
         whjCB0jFHlMRLAi8sJCprMZTNz/QUYYFEO+BPPcQf3f5XpQWs/pdKDastHqvT9JxY1gn
         ZEWJSBhybM7WYJuZ9XJh2WcgNp5gqEofVRtYrtGplGgFxOQ7ZlKW4V0UN3zwBiuMloXR
         eL3jw5J6d2kY9wIMrhQTGL5dN6xIzLesehj3M0mstNStq+XJz1f+8KO2xiROnyf6hJr0
         9tFoF7hJRXRvpdbYDLrlygCfaCYY6LRXBtXoMla/xs0Vbwsf2zsXkthay1QKidmXYE9V
         Mbqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=vA99qk4zuxuYCYpdjliDhljjfb71ReXyQG1Dc2N3ihQ=;
        b=hTTEme2CQhufcd6flRAOqaT/UXQfzcbjeykHncccsqfA9/TtQO2mw0Ef8E8Y3KtUpM
         OesXNQJtIDEbetNrt66tYz8WQicG5OsvNqy37hMNMFkSl6XhE/nCiVoa6+8oMsY/4B5+
         +J7gGTnHm9LSEHK3Q47zWPCuf3ox41Kca9BJkoL4BAfpK5iTtvD9ncsCLPwa5yEQLy97
         9AHpYUkiq69boHe5H5/3LftqqeG9x68IqPAlZr6Zbf634qbafureRxqWWRC6WC/hqjUe
         4wktWDj8xLN53gXdY2kh1ZhmLJ1vbzgwIMWgZptzY1GYqWP+yjilTVOeKJiDJPgAvKDN
         u3SQ==
X-Gm-Message-State: ACrzQf3aO2mtsVgryoDkxQQQFtlHQSjgjmIjXSG9ECrJ9Frs1pwM6/YI
        NAQ/NytjlGdocj6NhNL9wzsFbIdLAjyQyu8wYeU=
X-Google-Smtp-Source: AMsMyM63unfrbpzrYr1BzAGAh20x8SacfsJNsAae0V/NDJC3nUZTRHr3A0Fh1x41UDQYDy/MQpJWm7hn7drsQO5DXR8=
X-Received: by 2002:a05:6512:33d5:b0:49a:d2dc:e1e3 with SMTP id
 d21-20020a05651233d500b0049ad2dce1e3mr7685501lfg.628.1664181015774; Mon, 26
 Sep 2022 01:30:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220923160937.1912-1-claudiajkang@gmail.com> <YzFYYXcZaoPXcLz/@corigine.com>
 <CAK+SQuRj=caHiyrtVySVoxRrhNttfg_cSbNFjG2PL7Fc0_ObGg@mail.gmail.com>
 <YzFgnIUFy49QX2b6@corigine.com> <CAK+SQuTHciJWhCi-YAQKPG4cwh7zB9_WR=-zK3xTUq9eTtE4+g@mail.gmail.com>
 <YzFiXabip3LRy5e2@corigine.com>
In-Reply-To: <YzFiXabip3LRy5e2@corigine.com>
From:   Juhee Kang <claudiajkang@gmail.com>
Date:   Mon, 26 Sep 2022 17:29:39 +0900
Message-ID: <CAK+SQuRJd8mmwKNKNM_qsQ-h4WhLX9OcUcV9YSgAQnzG1wGMwg@mail.gmail.com>
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

On Mon, Sep 26, 2022 at 5:27 PM Simon Horman <simon.horman@corigine.com> wrote:
>
> On Mon, Sep 26, 2022 at 05:25:01PM +0900, Juhee Kang wrote:
> > On Mon, Sep 26, 2022 at 5:19 PM Simon Horman <simon.horman@corigine.com> wrote:
> > >
> > > On Mon, Sep 26, 2022 at 05:05:08PM +0900, Juhee Kang wrote:
> > > > Hi Simon,
> > >
> > > ...
> > >
> > > > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > > > index d66c73c1c734..f3f9394f0b5a 100644
> > > > > > --- a/net/core/dev.c
> > > > > > +++ b/net/core/dev.c
> > > > > > @@ -2886,8 +2886,7 @@ int netif_set_real_num_tx_queues(struct net_device *dev, unsigned int txq)
> > > > > >         if (txq < 1 || txq > dev->num_tx_queues)
> > > > > >                 return -EINVAL;
> > > > > >
> > > > > > -       if (dev->reg_state == NETREG_REGISTERED ||
> > > > > > -           dev->reg_state == NETREG_UNREGISTERING) {
> > > > > > +       if (dev->reg_state == NETREG_REGISTERED || netdev_unregistering(dev)) {
> > > > > >                 ASSERT_RTNL();
> > > > > >
> > > > > >                 rc = netdev_queue_update_kobjects(dev, dev->real_num_tx_queues,
> > > > >
> > > > > Is there any value in adding a netdev_registered() helper?
> > > > >
> > > >
> > > > The open code which is reg_state == NETREG_REGISTERED used 37 times on
> > > > some codes related to the network. I think that the
> > > > netdev_registered() helper is valuable.
> > >
> > > Thanks, FWIIW, that seems likely to me too.
> >
> > Thanks!
> > Apart from this patch, is it okay to send a patch that adds the
> > netdev_registered helper function later?
>
> In my opinion that would be good: let's fix one thing at a time.

I agree with you.
I will send a patch by applying netdev_registered() helper function by
directory.
