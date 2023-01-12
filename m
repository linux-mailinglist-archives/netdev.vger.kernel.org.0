Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6978D667E43
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 19:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240099AbjALSkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 13:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233104AbjALSjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 13:39:44 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D22C65B7
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 10:13:43 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso24419444pjp.4
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 10:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OtyhKe6rLSwFAOH3nTqt3P+j7w543MZ1zq+nbv1ttq4=;
        b=hLBawgFRnAdwFsrc7fSLeWJqWUPZ4fJgUq10ypbKWLOMzHwcDoAome22b6IVx6NGtJ
         ac0SHBc4H7svoIlgqL9ZsFneYPPjOtU02CDPTP3pJV37hJWrr1QWww2L2tHFDrUl9Si6
         JOLNHyXzcA/PgIrtMPpUS3AUmL7mTxsbqXssWCaJqLIw+oCKEQA+/pSv+FYqvlNwHRuU
         IjW6Q0vErd843pt/sjSSQyR8tC7eZ9mr5WMy7/CM72MTfC3eGjeeN17lfMNiwlxXBn+h
         2ovQopLYrNADUMUky5ipgZb0V56Zztee9jOmAHHHaKIxF+b+1jJpcDaQyCBb92D9bQqv
         ID/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OtyhKe6rLSwFAOH3nTqt3P+j7w543MZ1zq+nbv1ttq4=;
        b=kjK2ovszKHE4dGq+MRl/ftmGBoTPuHKtu98AB8wU+FQGTMzLB29WSrr3sb5sBro57O
         2gclHInsjExMGST5zxmUGE33i8O6YxMF6dsAi0lT3v5B1DD6BEVypoaEdditaQ2D9dMb
         guoHBBR3Zd87LAZPBPwqvrXFlAFmPsVZbGBB3RX8LyyyreG5LJb4RlAYwJ1I+GWrJFBp
         37humEhOKXHJaowWe3aTH6pS2abWCcXFdUi/Cy+W7SMyQZe/7TSkZy1ny2OQ4Hm9zob3
         ThyphG1u7PWyLfs1MGL7y7TrSiciB/RN1AHu8vXW+BGPRbI3hOkJr7hwEUu6LqxYddeh
         eO6w==
X-Gm-Message-State: AFqh2kp8pjUg++kzXvl6m8dwh4IZtOGHr2AzeKKAOmfBaj3bg4rg/5Cd
        j3SAUT8wiKOuOPFVR8D1HZGVdUgjjb6sT5UW90Y=
X-Google-Smtp-Source: AMrXdXvzgLrxQ1rBqdAGFCokaUZsARqO711DOBfdUMtyFsTev6EKhstay1bx3TgutS5ce5JPAB7Cs/GkV0IG5GllbQ0=
X-Received: by 2002:a17:90a:19d2:b0:229:8a:df21 with SMTP id
 18-20020a17090a19d200b00229008adf21mr325327pjj.141.1673547222414; Thu, 12 Jan
 2023 10:13:42 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673457624.git.lorenzo@kernel.org> <0a22f0c81e87fde34e3444e1bc83012a17498e8e.1673457624.git.lorenzo@kernel.org>
 <02cfb1dd78f6efb1ae3077de24fa357091168d39.camel@gmail.com> <Y8A0r6IA+l5RzDXq@lore-desk>
In-Reply-To: <Y8A0r6IA+l5RzDXq@lore-desk>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 12 Jan 2023 10:13:30 -0800
Message-ID: <CAKgT0UeX0n0b887MWUXiO54-PBMhxgSKPTab9AX3LPk3R4fS+w@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 5/5] net: ethernet: mtk_wed: add
 reset/reset_complete callbacks
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, sujuan.chen@mediatek.com,
        daniel@makrotopia.org, leon@kernel.org
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

On Thu, Jan 12, 2023 at 8:26 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> > On Wed, 2023-01-11 at 18:22 +0100, Lorenzo Bianconi wrote:
> > > Introduce reset and reset_complete wlan callback to schedule WLAN driver
> > > reset when ethernet/wed driver is resetting.
> > >
> > > Tested-by: Daniel Golle <daniel@makrotopia.org>
> > > Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > > Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  drivers/net/ethernet/mediatek/mtk_eth_soc.c |  7 ++++
> > >  drivers/net/ethernet/mediatek/mtk_wed.c     | 40 +++++++++++++++++++++
> > >  drivers/net/ethernet/mediatek/mtk_wed.h     |  8 +++++
> > >  include/linux/soc/mediatek/mtk_wed.h        |  2 ++
> > >  4 files changed, 57 insertions(+)
> > >
> >
> > Do we have any updates on the implementation that would be making use
> > of this? It looks like there was a discussion for the v2 of this set to
> > include a link to an RFC posting that would make use of this set.
>
> I posted the series to linux-wireless mailing list adding netdev one in cc:
> https://lore.kernel.org/linux-wireless/cover.1673103214.git.lorenzo@kernel.org/T/#md34b4ffcb07056794378fa4e8079458ecca69109

Thanks. It would be useful to include this link in the next revision
to make it easier to review.

> >
> > > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > index 1af74e9a6cd3..0147e98009c2 100644
> > > --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > @@ -3924,6 +3924,11 @@ static void mtk_pending_work(struct work_struct *work)
> > >     set_bit(MTK_RESETTING, &eth->state);
> > >
> > >     mtk_prepare_for_reset(eth);
> > > +   mtk_wed_fe_reset();
> > > +   /* Run again reset preliminary configuration in order to avoid any
> > > +    * possible race during FE reset since it can run releasing RTNL lock.
> > > +    */
> > > +   mtk_prepare_for_reset(eth);
> > >
> > >     /* stop all devices to make sure that dma is properly shut down */
> > >     for (i = 0; i < MTK_MAC_COUNT; i++) {
> > > @@ -3961,6 +3966,8 @@ static void mtk_pending_work(struct work_struct *work)
> > >
> > >     clear_bit(MTK_RESETTING, &eth->state);
> > >
> > > +   mtk_wed_fe_reset_complete();
> > > +
> > >     rtnl_unlock();
> > >  }
> > >
> > > diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
> > > index a6271449617f..4854993f2941 100644
> > > --- a/drivers/net/ethernet/mediatek/mtk_wed.c
> > > +++ b/drivers/net/ethernet/mediatek/mtk_wed.c
> > > @@ -206,6 +206,46 @@ mtk_wed_wo_reset(struct mtk_wed_device *dev)
> > >     iounmap(reg);
> > >  }
> > >
> > > +void mtk_wed_fe_reset(void)
> > > +{
> > > +   int i;
> > > +
> > > +   mutex_lock(&hw_lock);
> > > +
> > > +   for (i = 0; i < ARRAY_SIZE(hw_list); i++) {
> > > +           struct mtk_wed_hw *hw = hw_list[i];
> > > +           struct mtk_wed_device *dev = hw->wed_dev;
> > > +
> > > +           if (!dev || !dev->wlan.reset)
> > > +                   continue;
> > > +
> > > +           /* reset callback blocks until WLAN reset is completed */
> > > +           if (dev->wlan.reset(dev))
> > > +                   dev_err(dev->dev, "wlan reset failed\n");
> >
> > The reason why having the consumer would be useful are cases like this.
> > My main concern is if the error value might be useful to actually
> > expose rather than just treating it as a boolean. Usually for things
> > like this I prefer to see the result captured and if it indicates error
> > we return the error value since this could be one of several possible
> > causes for the error assuming this returns an int and not a bool.
>
> we can have 2 independent wireless chips connected here so, if the first one
> fails, should we exit or just log the error?

I would think you should log the error. I notice in your wireless
implementation you can return BUSY or TIMEOUT. Rather than doing the
dev_err in your reset function to distinguish between the two you
could just return the error and leave the printing of the error to
this dev_err message.

Also a follow-on question I had. It looks like reset_complete returns
an int but it is being ignored and in your implementation it is just
returning 0. Should that be a void instead of an int?
