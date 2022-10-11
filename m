Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E18F5FA9C3
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 03:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiJKBOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 21:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiJKBOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 21:14:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CB94D4D2
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 18:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665450846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sxFeYXoCqMMianpkw6OIwMS6oBCanEKWQTOlKjpW6i8=;
        b=a7nY41nTo9TU6FgeMzmWKGFNSNQwIyS+CEDm/45emOtbRmOo1kTQhXSeMMQ6RCBGmpR9w8
        lNsnUREJ+7SMyuNLjkuiagA+e5DKwtROH3trJwAltbyk8zyleuErzs8OqdXyUWh4dExICV
        egPX3xAHiPpoRMYYpeVCH/lUO6BSn1U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-427-F1lphIu7MSS3feLoCa8rTg-1; Mon, 10 Oct 2022 21:14:04 -0400
X-MC-Unique: F1lphIu7MSS3feLoCa8rTg-1
Received: by mail-wm1-f72.google.com with SMTP id 2-20020a05600c268200b003c4290989e1so1842251wmt.2
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 18:14:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sxFeYXoCqMMianpkw6OIwMS6oBCanEKWQTOlKjpW6i8=;
        b=hFPwHSkNhLxDJZmQKXB+dGTvA5OV2Q7dq08zUZuiNEXGyNKv3I7Hv+hC6pcTyvGYbN
         i40M44ynXyxbLLiO8RqtfwfeAoO6cP9cqpGtbup1k6GI0EFPKfcrIGwHTgcA89ts5fdr
         qqJ/u0T6cNePXMjF5s1jPWB/s+pHbQSQbTwb3QmTJKsUfslc2Y8cWfRqoK+euSFSMLfK
         YozStjVS+2wJqmf2o8a+3sY5T3XTd2cwRysVm4jlK8ME7x1YWP1kkum2MadNhkRcsiTV
         nsaz7M6B4zxI7GXcDmsY6oESU4/JcLPT5ebJ+S4I6j9Vz8A4rIY3jlg9YnKaMW1f9ffC
         o95g==
X-Gm-Message-State: ACrzQf2L9z/o6vea+js+70t64o+vBY0vvN2jWMOGSk+CKNEEWdz5DRQU
        68mglaaqafuYgWJrikLVMFre0IH+yg44CmR05/jIHGZoZZFaeHTcqBB8/lA5to6FR3XAQuk2SU8
        fKLpDZIboojojksFMKDJotW+QfcPdrxbT
X-Received: by 2002:adf:fad0:0:b0:22e:4998:fd5d with SMTP id a16-20020adffad0000000b0022e4998fd5dmr13073307wrs.267.1665450843797;
        Mon, 10 Oct 2022 18:14:03 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6I42i/UzyW5Nbsy29VOOeuh8PZtqzXMa9Odk273V1cv2MoonD8mVEdsBDjH83e4IJTuV4P64csSuoKAck5dkw=
X-Received: by 2002:adf:fad0:0:b0:22e:4998:fd5d with SMTP id
 a16-20020adffad0000000b0022e4998fd5dmr13073292wrs.267.1665450843629; Mon, 10
 Oct 2022 18:14:03 -0700 (PDT)
MIME-Version: 1.0
References: <20221007085310.503366-1-miquel.raynal@bootlin.com>
 <20221007085310.503366-6-miquel.raynal@bootlin.com> <CAK-6q+iun+K8F6Mv3=WLL92iZnv-9oSnoRYtY4Zex2DZqS8ABQ@mail.gmail.com>
In-Reply-To: <CAK-6q+iun+K8F6Mv3=WLL92iZnv-9oSnoRYtY4Zex2DZqS8ABQ@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 10 Oct 2022 21:13:52 -0400
Message-ID: <CAK-6q+iKf5bXX+EPBw9utCpAoBVjZ678na0V_n4GUes5O=NLLw@mail.gmail.com>
Subject: Re: [PATCH wpan/next v4 5/8] ieee802154: hwsim: Implement address filtering
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Oct 10, 2022 at 9:04 PM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Fri, Oct 7, 2022 at 4:53 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > We have access to the address filters being theoretically applied, we
> > also have access to the actual filtering level applied, so let's add a
> > proper frame validation sequence in hwsim.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  drivers/net/ieee802154/mac802154_hwsim.c | 111 ++++++++++++++++++++++-
> >  include/net/ieee802154_netdev.h          |   8 ++
> >  2 files changed, 117 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
> > index 458be66b5195..84ee948f35bc 100644
> > --- a/drivers/net/ieee802154/mac802154_hwsim.c
> > +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> > @@ -18,6 +18,7 @@
> >  #include <linux/netdevice.h>
> >  #include <linux/device.h>
> >  #include <linux/spinlock.h>
> > +#include <net/ieee802154_netdev.h>
> >  #include <net/mac802154.h>
> >  #include <net/cfg802154.h>
> >  #include <net/genetlink.h>
> > @@ -139,6 +140,113 @@ static int hwsim_hw_addr_filt(struct ieee802154_hw *hw,
> >         return 0;
> >  }
> >
> > +static void hwsim_hw_receive(struct ieee802154_hw *hw, struct sk_buff *skb,
> > +                            u8 lqi)
> > +{
> > +       struct ieee802154_hdr hdr;
> > +       struct hwsim_phy *phy = hw->priv;
> > +       struct hwsim_pib *pib;
> > +
> > +       rcu_read_lock();
> > +       pib = rcu_dereference(phy->pib);
> > +
> > +       if (!pskb_may_pull(skb, 3)) {
> > +               dev_dbg(hw->parent, "invalid frame\n");
> > +               goto drop;
> > +       }
> > +
> > +       memcpy(&hdr, skb->data, 3);
> > +
> > +       /* Level 4 filtering: Frame fields validity */
> > +       if (hw->phy->filtering == IEEE802154_FILTERING_4_FRAME_FIELDS) {

I see, there is this big if handling. But it accesses the
hw->phy->filtering value. It should be part of the hwsim pib setting
set by the driver callback. It is a question here of mac802154 layer
setting vs driver layer setting. We should do what the mac802154 tells
the driver to do, this way we do what the mac802154 layer is set to.

However it's a minor thing and it's okay to do it so...

- Alex

