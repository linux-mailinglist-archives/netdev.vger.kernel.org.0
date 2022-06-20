Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7651550DCE
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 02:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235923AbiFTAZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 20:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234714AbiFTAZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 20:25:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED3F36172
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 17:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655684734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UJvYjv95AXuP3P9cnYoTAfwTzlqlt8Wr02sH+XDrEjU=;
        b=UxtSyF9xu7qkiWrKJIStJNno6+nWDQTdj0oANYFDi/+OSApIu9NWGIoHIoui9SDa1jHiUU
        RTn1H7fQZX7F6dGV5a6Fxs4pLDTMWdk2OGMPgSZF4qcU/kidiVfivjPQrLoId+CS0RGLy7
        g3HeyNpHlFCjyIWmetFs3SDJztYytcQ=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-227-kvOUQANDMMK4oc9L-qt71w-1; Sun, 19 Jun 2022 20:25:32 -0400
X-MC-Unique: kvOUQANDMMK4oc9L-qt71w-1
Received: by mail-qv1-f72.google.com with SMTP id q36-20020a0c9127000000b00461e3828064so10362430qvq.12
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 17:25:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UJvYjv95AXuP3P9cnYoTAfwTzlqlt8Wr02sH+XDrEjU=;
        b=pnPbb48DcexkpbyfBMicyaSQfFJ67uF7mMZOqW4M/qjTOsgTw5a/q4jMAn5BOcNRqH
         uj0SaeoxfSYZ5XKHTbsWL9vDF3vJc8q2GbrVTERxTvG0uEpeojTnU8CqT35KabKOoRzz
         Rn2MZSFsj8ZhYneLioozf4ARq3xZCa0ZhQvH40F/+V+iDTdDhiXOqdj7xmQQPbL1PZd5
         c1TBW6PUCKxDAQEK0KKthTsYzj9UbL4FBN0SdluTQWnE4KJP6xO4a+2fUTVSgO3HFW9H
         jZYOkFMlAmqhR0QJvE9ar2UMt4dwOwMZT/4jAkQGhfVVJyDbY/Er/aDhgDVqbd+wuDr0
         Ju3A==
X-Gm-Message-State: AJIora/gk+vwmKkxafhKJ+hS1lvoz808+IyaBP1YDuE51X0M84hPGX1R
        fCkB+HjH5W+nBd/hhX1y68CtFjU5BkuKBazfhAY58Jezhltumazi8g52tT8lwV8hi/vG6eGwAqU
        q3476QCHbA3mORJV0ScufAWYvYGSzuooY
X-Received: by 2002:ac8:5c07:0:b0:304:f7b7:7dda with SMTP id i7-20020ac85c07000000b00304f7b77ddamr17666695qti.123.1655684732516;
        Sun, 19 Jun 2022 17:25:32 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uj+lcTGbggSKQKdpbp4xNuLswdRNyhKC8qhv4nBHIaNsC856qU07BeD2FwpOdTWsmfnhFVIYkEFMrzwrYX4hY=
X-Received: by 2002:ac8:5c07:0:b0:304:f7b7:7dda with SMTP id
 i7-20020ac85c07000000b00304f7b77ddamr17666677qti.123.1655684732341; Sun, 19
 Jun 2022 17:25:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220617193254.1275912-1-miquel.raynal@bootlin.com>
 <20220617193254.1275912-3-miquel.raynal@bootlin.com> <CAK-6q+iJaZvtxXsFTPsYyWsDYmKhgVsMHKcDUCrCqmUR2YpEjg@mail.gmail.com>
In-Reply-To: <CAK-6q+iJaZvtxXsFTPsYyWsDYmKhgVsMHKcDUCrCqmUR2YpEjg@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 19 Jun 2022 20:25:21 -0400
Message-ID: <CAK-6q+i1s6p986xO1EcWL5_5etda7R0y8XvkjVmFkiS=p3sfUQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 2/6] net: ieee802154: Ensure only FFDs can
 become PAN coordinators
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
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 19, 2022 at 8:24 PM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Fri, Jun 17, 2022 at 3:35 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > This is a limitation clearly listed in the specification. Now that we
> > have device types,let's ensure that only FFDs can become PAN
> > coordinators.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  net/ieee802154/nl802154.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> > index 638bf544f102..0c6fc3385320 100644
> > --- a/net/ieee802154/nl802154.c
> > +++ b/net/ieee802154/nl802154.c
> > @@ -924,6 +924,9 @@ static int nl802154_new_interface(struct sk_buff *skb, struct genl_info *info)
> >                         return -EINVAL;
> >         }
> >
> > +       if (type == NL802154_IFTYPE_COORD && !cfg802154_is_ffd(rdev))
> > +               return -EINVAL;
> > +
>
> Look at my other mail regarding why the user needs to set this device
> capability, change the errno to "EOPNOTSUPP"... it would be nice to
> have an identically nl80211 handling like nl80211 to see which

s/like nl80211/in nl802154/

- Alex

