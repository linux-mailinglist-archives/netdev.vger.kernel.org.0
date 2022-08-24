Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD045A0374
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 23:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240277AbiHXVyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 17:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240178AbiHXVyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 17:54:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5784175CC2
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 14:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661378038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P8SV2XTXp+ycUiMu4OqXNB1nMaHaXIrJweUPXZpzvfQ=;
        b=eang0823/bjfW+GHIsdHdOLQwWPuHKOFZ4SytfN4XdSBiQevVhna8LFERVUm++P77zZ5le
        mbZrqSoYVn2fErV+jW9ouIuyTH1Ub05DcvauB+hzwLM+wUtMnDbgLvnq0UVUBOs7hxPrUk
        T6e7UveMzZKc2WiBXCPbQtc0pgjQS8Y=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-582-GIb1gmxPPEiXBpUrLXCRoA-1; Wed, 24 Aug 2022 17:53:57 -0400
X-MC-Unique: GIb1gmxPPEiXBpUrLXCRoA-1
Received: by mail-qt1-f198.google.com with SMTP id h19-20020ac85493000000b00343408bd8e5so13758924qtq.4
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 14:53:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=P8SV2XTXp+ycUiMu4OqXNB1nMaHaXIrJweUPXZpzvfQ=;
        b=p1GzcXXqZIJQbO+Ozdq/60qMby3OEYegc+qqhydKlFJDPPmS9lrT5gDZYIHe2FmWJd
         lXVZ3VQhqcVjw4RFmcrRNTR42M8Syp338nYHB7+D2IoiTRkkU0v/sZxg2FwucUkArfsJ
         i46SoV7Rr75zRZEIQiZ57oLgUYFOXcuQCAhkwq6iHnPpqniigLEDtw6pMWFE/hJgD/Qo
         MdZna+Z644xiQXJRhuMD/9pFQp5DMfL3Kn+XKDcthZsZpHrQ91AjwBCA/nimGasdrJfr
         H58b1y6OUIwnxypU/y8WNbQ0AkKGQPV7K1l6EYrH4WzGYTyetJeDUO0aSjGCfNvSLQUo
         a4HA==
X-Gm-Message-State: ACgBeo1ajg30NHQY5hls/cyaC9H6GTN3Lhm/YlJpF6BUV81bQV9jRUbs
        mfigDogz7nUUnidaOmHMfFdNxO8Nba+aeMjF0fgiVqKNVdnBwVHzY+Zq60nmxorn6Dm/xb3Pmbr
        MKULah9V4Kii9O4T+ik5nSNjn3dL1oIH8
X-Received: by 2002:a05:622a:4cd:b0:343:65a4:e212 with SMTP id q13-20020a05622a04cd00b0034365a4e212mr1170348qtx.526.1661378036871;
        Wed, 24 Aug 2022 14:53:56 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7xrH8Wkzbs/n47hMaXPwSqWBOuRh5IKesZcBM0OP/H8u9SmoqhBVInVcryoEYDFtCVHtZLNHO9ie+wH+bDji4=
X-Received: by 2002:a05:622a:4cd:b0:343:65a4:e212 with SMTP id
 q13-20020a05622a04cd00b0034365a4e212mr1170340qtx.526.1661378036685; Wed, 24
 Aug 2022 14:53:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
 <20220701143052.1267509-2-miquel.raynal@bootlin.com> <CAK-6q+jkUUjAGqEDgU1oJvRkigUbvSO5SXWRau6+320b=GbfxQ@mail.gmail.com>
 <20220819191109.0e639918@xps-13> <CAK-6q+gCY3ufaADHNQWJGNpNZJMwm=fhKfe02GWkfGEdgsMVzg@mail.gmail.com>
 <20220823182950.1c722e13@xps-13> <CAK-6q+jfva++dGkyX_h2zQGXnoJpiOu5+eofCto=KZ+u6KJbJA@mail.gmail.com>
 <20220824122058.1c46e09a@xps-13> <CAK-6q+gjgQ1BF-QrT01JWh+2b3oL3RU+SoxUf5t7h3Hc6R8pcg@mail.gmail.com>
 <20220824152648.4bfb9a89@xps-13>
In-Reply-To: <20220824152648.4bfb9a89@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 24 Aug 2022 17:53:45 -0400
Message-ID: <CAK-6q+itA0C4zPAq5XGKXgCHW5znSFeB-YDMp3uB9W-kLV6WaA@mail.gmail.com>
Subject: Re: [PATCH wpan-next 01/20] net: mac802154: Allow the creation of
 coordinator interfaces
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Aug 24, 2022 at 9:27 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Wed, 24 Aug 2022 08:43:20 -0400:
>
> > Hi,
> >
> > On Wed, Aug 24, 2022 at 6:21 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > ...
> > >
> > > Actually right now the second level is not enforced, and all the
> > > filtering levels are a bit fuzzy and spread everywhere in rx.c.
> > >
> > > I'm gonna see if I can at least clarify all of that and only make
> > > coord-dependent the right section because right now a
> > > ieee802154_coord_rx() path in ieee802154_rx_handle_packet() does not
> > > really make sense given that the level 3 filtering rules are mostly
> > > enforced in ieee802154_subif_frame().
> >
> > One thing I mentioned before is that we probably like to have a
> > parameter for rx path to give mac802154 a hint on which filtering
> > level it was received. We don't have that, I currently see that this
> > is a parameter for hwsim receiving it on promiscuous level only and
> > all others do third level filtering.
> > We need that now, because the promiscuous mode was only used for
> > sniffing which goes directly into the rx path for monitors. With scan
> > we mix things up here and in my opinion require such a parameter and
> > do filtering if necessary.
>
> I am currently trying to implement a slightly different approach. The
> core does not know hwsim is always in promiscuous mode, but it does
> know that it does not check FCS. So the core checks it. This is
> level 1 achieved. Then in level 2 we want to know if the core asked
> the transceiver to enter promiscuous mode, which, if it did, should
> not imply more filtering. If the device is working in promiscuous
> mode but this was not asked explicitly by the core, we don't really
> care, software filtering will apply anyway.
>

I doubt that I will be happy with this solution, this all sounds like
"for the specific current behaviour that we support 2 filtering levels
it will work", just do a parameter on which 802.15.4 filtering level
it was received and the rx path will check what kind of filter is
required and which not.
As driver ops start() callback you should say which filtering level
the receive mode should start with.

> I am reworking the rx path to clarify what is being done and when,
> because I found this part very obscure right now. In the end I don't
> think we need additional rx info from the drivers. Hopefully my
> proposal will clarify why this is (IMHO) not needed.
>

Never looked much in 802.15.4 receive path as it just worked but I
said that there might be things to clean up when filtering things on
hardware and when on software and I have the feeling we are doing
things twice. Sometimes it is also necessary to set some skb fields
e.g. PACKET_HOST, etc. and I think this is what the most important
part of it is there. However, there are probably some tune ups if we
know we are in third leveling filtering...

- Alex

