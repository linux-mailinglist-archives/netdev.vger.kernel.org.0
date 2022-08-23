Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6195359E718
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 18:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244494AbiHWQW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 12:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244584AbiHWQWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 12:22:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6D213F590
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661258650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N1QR7/fEkSEGvtR9cdL+cMtMgSlf4RLGbFttX75oGMA=;
        b=hgIltdZnr9HWCnOOdDiqiSfkTvzyx2R5Lkdz4eSwBNWUtVXSVaqLj8u4GypJ1itSDg6e+x
        3IDRj1UfksM/dsdfmDrdXs2ntzIsswT5UduhOipKXh9x7o0MFU76PHrPohsG78yiYdI2O2
        BnVJL85fKUocpZC2xGvl2lYEFFT2jVQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-397-XqOHBQYkNXefVuctNUNCcA-1; Tue, 23 Aug 2022 08:44:09 -0400
X-MC-Unique: XqOHBQYkNXefVuctNUNCcA-1
Received: by mail-qv1-f69.google.com with SMTP id m18-20020a0cf192000000b00496ac947c21so7303338qvl.4
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:44:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=N1QR7/fEkSEGvtR9cdL+cMtMgSlf4RLGbFttX75oGMA=;
        b=i3xLfrlZEw4WVtoELBZbWmjTRNdZaDVkxsnvFBd720ffQGEEJcAcYy9JxFh118nClw
         /3ssd1RtywOsAW12Eu9iLBK+d6GCxOZWX4FaoHqicrk4Cxfwuv+5hJZkIboY2LwN+/wR
         6NYjtBU3LKGAbYMfJ+dJmoxbYqif8yQiZpEsl4TEx1ttIQC4n8lrMV3HnM2v9k9gXNv6
         5TdA+O+zVqKlhmvOU2rewuDhtofo6abrMG77fxWImCb83MT0RdlQnuhwcvmq+YRqhzCY
         9NlajGoJIkNx5+lTVQMdIy76Gjr+rsQhqCc5nNtvyuXp7vFCicAdg2ifi+5L5ZdQT7iM
         q4ww==
X-Gm-Message-State: ACgBeo3/XPL9DmDML0ROAdKyVrJaZOBh3uJI4QqAcl6nnjzlHl/j9vBl
        4C0kWhaP+nL59Ov2Qho/j4YwAbJYoAg0BNNRG316bDGUQB0hnztl61RPfx6EUitcbmjDcDgulir
        HF845FWGxPXFBqsETXdaOWODAShHjv/so
X-Received: by 2002:a37:b741:0:b0:6b9:3b67:d0a7 with SMTP id h62-20020a37b741000000b006b93b67d0a7mr15353206qkf.770.1661258649011;
        Tue, 23 Aug 2022 05:44:09 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6KweMoriQTnzj4bnDSdUC0ausC1ixTLBAZJs1rzMT28/lX0LmWpmYCqZFNCfTj7g42M1xViFj9SYYbBbJHl68=
X-Received: by 2002:a37:b741:0:b0:6b9:3b67:d0a7 with SMTP id
 h62-20020a37b741000000b006b93b67d0a7mr15353188qkf.770.1661258648785; Tue, 23
 Aug 2022 05:44:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
 <20220701143052.1267509-18-miquel.raynal@bootlin.com> <CAK-6q+ifj5DNrq31qjjyk3OoAsf0+LuBttM5o8Rs8Pt_TA_JMg@mail.gmail.com>
 <20220819191315.387ba71b@xps-13>
In-Reply-To: <20220819191315.387ba71b@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 23 Aug 2022 08:43:58 -0400
Message-ID: <CAK-6q+inCxP_wCWw8VCHXCETB7QqPYRw5L3c+gF4CSTKYO9Mjg@mail.gmail.com>
Subject: Re: [PATCH wpan-next 17/20] net: ieee802154: Handle limited devices
 with only datagram support
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Aug 19, 2022 at 1:13 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Thu, 14 Jul 2022 23:16:33 -0400:
>
> > Hi,
> >
> > On Fri, Jul 1, 2022 at 10:37 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Some devices, like HardMAC ones can be a bit limited in the way they
> > > handle mac commands. In particular, they might just not support it at
> > > all and instead only be able to transmit and receive regular data
> > > packets. In this case, they cannot be used for any of the internal
> > > management commands that we have introduced so far and must be flagged
> > > accordingly.
> > >
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  include/net/cfg802154.h   | 3 +++
> > >  net/ieee802154/nl802154.c | 6 ++++++
> > >  2 files changed, 9 insertions(+)
> > >
> > > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > > index d6ff60d900a9..20ac4df9dc7b 100644
> > > --- a/include/net/cfg802154.h
> > > +++ b/include/net/cfg802154.h
> > > @@ -178,12 +178,15 @@ wpan_phy_cca_cmp(const struct wpan_phy_cca *a, const struct wpan_phy_cca *b)
> > >   *     setting.
> > >   * @WPAN_PHY_FLAG_STATE_QUEUE_STOPPED: Indicates that the transmit queue was
> > >   *     temporarily stopped.
> > > + * @WPAN_PHY_FLAG_DATAGRAMS_ONLY: Indicates that transceiver is only able to
> > > + *     send/receive datagrams.
> > >   */
> > >  enum wpan_phy_flags {
> > >         WPAN_PHY_FLAG_TXPOWER           = BIT(1),
> > >         WPAN_PHY_FLAG_CCA_ED_LEVEL      = BIT(2),
> > >         WPAN_PHY_FLAG_CCA_MODE          = BIT(3),
> > >         WPAN_PHY_FLAG_STATE_QUEUE_STOPPED = BIT(4),
> > > +       WPAN_PHY_FLAG_DATAGRAMS_ONLY    = BIT(5),
> > >  };
> > >
> > >  struct wpan_phy {
> > > diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> > > index 00b03c33e826..b31a0bd36b08 100644
> > > --- a/net/ieee802154/nl802154.c
> > > +++ b/net/ieee802154/nl802154.c
> > > @@ -1404,6 +1404,9 @@ static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
> > >         if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
> > >                 return -EPERM;
> > >
> > > +       if (wpan_phy->flags & WPAN_PHY_FLAG_DATAGRAMS_ONLY)
> > > +               return -EOPNOTSUPP;
> > > +
> >
> > for doing a scan it's also required to turn the transceiver into
> > promiscuous mode, right?
> >
> > There is currently a flag if a driver supports promiscuous mode or
> > not... I am not sure if all drivers have support for it. For me it
> > looks like a mandatory feature but I am not sure if every driver
> > supports it.
> > We have a similar situation with acknowledge retransmit handling...
> > some transceivers can't handle it and for normal dataframes we have a
> > default behaviour that we don't set it. However sometimes it's
> > required by the spec, then we can't do anything here.
> >
> > I think we should check on it but we should plan to drop this flag if
> > promiscuous mode is supported or not.
>
> Yes, you are right, I should check this flag is set, I will do it at
> the creation of the MONITOR interface, which anyway does not make sense
> if the device has no filtering support (promiscuous being a very
> standard one, but, as you said below, will later be replaced by some
> more advanced levels).
>
> > I also think that the
> > promiscuous driver_ops should be removed and moved as a parameter for
> > start() driver_ops to declare which "receive mode" should be
> > enabled... but we can do that in due course.
>
> Agreed.

We need to keep in mind that hwsim is a transceiver which only can run
in promiscuous mode and all receive paths need to be aware of this.
Yes, we can do that by saying on the ieee802154_rx() it always
receives frames in promiscuous mode and mac802154 does all the
filtering. I have the feeling there needs to be more done, because the
driver op to run into promiscuous mode and the mac802154 layer thinks
it's not BUT hwsim was it all the time. :-/

- Alex

