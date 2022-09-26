Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB6F5E9BA1
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 10:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbiIZIHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 04:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234169AbiIZIHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 04:07:19 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965CE1C432
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 01:05:46 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id c7so6458742ljm.12
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 01:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=dDb2i13fBtu+EH3CiEibKEBT59YoFLUU+bsiVkR8l7w=;
        b=ihah1xcfdLbdTn51D9Oj+AUAMPAeSYDOoR7PK/JVPiIjPsD5rCDfYKe8UQJTKJdnh8
         HUgcPuY+vpg1xsH6XcootO9Wx4lcotoqXD6unGqW4w+GymwHvPn8VlpM2foivwVZRUt8
         w1NhcLCxEc8cN4LfsKZeF9GTQtcnfF3xW+psfsDgAlsBBs9fpEvN75p0A7QJEHzYCAhX
         Q/fi/UYQ5WmxnL186WHG02kU4+DFI0CAH1e1nkwM9im2UZk8igaQzw4yJS7ls93X4US7
         Re0NNxLA6Wc9a4cDrv4xeT6khiOblVh2EsKiYMasnXzfQ8C4l/H17JTjyfj4GXm++Zrx
         JDDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=dDb2i13fBtu+EH3CiEibKEBT59YoFLUU+bsiVkR8l7w=;
        b=6fhpBr5V/pfI1GMv4Wq1u8aHja00+gnwZdSwRAJ1EnzF6XHZaZzvZqW0gl2UveYv+i
         gkrcjk3W16ffOTknAz4eeo4igdLVzpd9ddnSeX2dh+VK8Y71CV259/VsJ+2v0B0/V1/1
         MvPVU3iI+6QWBiI4wxsxNTDCRoa4QB4grSgV/tWF+BeUBPY8WA72xQRngR2iNko93iPf
         QIR2m0V9FaGE98Qd1s5XmPL1r5t19sn62wOPEhixYlXCXS04N4pU7UHapXxxR8faEUcb
         mgtsCYy1zxow8qMmzlKjAguFdho+qwGdBdjdT0E9QgQk540+pZoTIbAu4V6u9JMtun1W
         Qv4g==
X-Gm-Message-State: ACrzQf15P/etfHdccVEIioIO40rpst8XwRON8e/5sNYWJB+AbZKXPJI7
        knMDV2GFdmezF2YBwt/7kXrFfgiQefI4o4/tKFw=
X-Google-Smtp-Source: AMsMyM7UMs2EgmUnR9uWxTb/VbyvmkdN8oHc8dHJrRrRnvNHkjk0RV8kdQZ15rNRQrTAMIZRUU8+5B2qg7rKLV+caEE=
X-Received: by 2002:a2e:97c5:0:b0:26c:54ba:4cc8 with SMTP id
 m5-20020a2e97c5000000b0026c54ba4cc8mr7161946ljj.219.1664179544948; Mon, 26
 Sep 2022 01:05:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220923160937.1912-1-claudiajkang@gmail.com> <YzFYYXcZaoPXcLz/@corigine.com>
In-Reply-To: <YzFYYXcZaoPXcLz/@corigine.com>
From:   Juhee Kang <claudiajkang@gmail.com>
Date:   Mon, 26 Sep 2022 17:05:08 +0900
Message-ID: <CAK+SQuRj=caHiyrtVySVoxRrhNttfg_cSbNFjG2PL7Fc0_ObGg@mail.gmail.com>
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

Hi Simon,
Thanks a lot for your review!

On Mon, Sep 26, 2022 at 4:44 PM Simon Horman <simon.horman@corigine.com> wrote:
>
> On Sat, Sep 24, 2022 at 01:09:35AM +0900, Juhee Kang wrote:
> > [You don't often get email from claudiajkang@gmail.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> >
> > The open code is defined as a helper function(netdev_unregistering)
> > on netdev.h, which the open code is dev->reg_state == NETREG_UNREGISTERING.
> > Thus, netdev_unregistering() replaces the open code. This patch doesn't
> > change logic.
> >
> > Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>
> > ---
> >  net/core/dev.c       | 9 ++++-----
> >  net/core/net-sysfs.c | 2 +-
> >  2 files changed, 5 insertions(+), 6 deletions(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index d66c73c1c734..f3f9394f0b5a 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -2886,8 +2886,7 @@ int netif_set_real_num_tx_queues(struct net_device *dev, unsigned int txq)
> >         if (txq < 1 || txq > dev->num_tx_queues)
> >                 return -EINVAL;
> >
> > -       if (dev->reg_state == NETREG_REGISTERED ||
> > -           dev->reg_state == NETREG_UNREGISTERING) {
> > +       if (dev->reg_state == NETREG_REGISTERED || netdev_unregistering(dev)) {
> >                 ASSERT_RTNL();
> >
> >                 rc = netdev_queue_update_kobjects(dev, dev->real_num_tx_queues,
>
> Is there any value in adding a netdev_registered() helper?
>

The open code which is reg_state == NETREG_REGISTERED used 37 times on
some codes related to the network. I think that the
netdev_registered() helper is valuable.

> ...

Best regards,
Juhee
