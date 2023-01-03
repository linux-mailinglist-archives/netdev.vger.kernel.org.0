Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF0A65B883
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 02:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235364AbjACBHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 20:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbjACBHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 20:07:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A1D6474
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 17:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672708022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4rKEcniu8y/j8TL1AS2/CkwoKpYsBCNUv3gh7eqUlJA=;
        b=gZb9Uw4wCWKX+gIF72ag37eMjCwReSR0E4rc5WIQcVncHlpdp9xf98xsBHCmJABObxNyVO
        w0r7h347ksjo7PAmIsmbri9Pdx8SL1gFIQL9oyw8LtAMtKkKzoAe3iF6+WWZrKPbx/Y0hT
        gGpygrWBltRAYgP7ydckPlYOkNdNFnk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-663-5B6wrtwrMKCvLYz2p2pcKA-1; Mon, 02 Jan 2023 20:07:01 -0500
X-MC-Unique: 5B6wrtwrMKCvLYz2p2pcKA-1
Received: by mail-ej1-f72.google.com with SMTP id gn28-20020a1709070d1c00b007c177fee5faso18254230ejc.23
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 17:07:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4rKEcniu8y/j8TL1AS2/CkwoKpYsBCNUv3gh7eqUlJA=;
        b=JnG83DQNvlpFAa2go7u2V25xmBGQdnfsxn5IMn6TD9Ychct2jFypgFPiCIDt5PJ8MH
         jr+mCvJ7ZJYOPzsTRuF/SS/A8As6W3ltUEhMRIPHhii62h1mbjfzO6v/kBpH/JRALraO
         O07xmEIdhY7175WSnfuORW3/A0E+WLuPSxryrhazL7IEKmwjLIjOBUnHPyWtIiKPulc9
         JK8mtK2zrM1n/mBbGMi49MpxCmpzzGbXU9Eh85QR3CI/cAZBbXWvmmwSrUqLztPzTdOH
         l96KXNwvCN+6QQ//XXOtKgFkgjiZIuNP1vLSFJ3xo4rR9MGI0UPxl3VIxJl7qwp8p1m3
         1LCg==
X-Gm-Message-State: AFqh2koO1oI3UQ53mJfS7pGsCq92964Lt7YlW1GzdGSiXrfN+fAO0yl0
        X+2cL98EhecJ2VYZ7QWju8nqZiCj2E2KatIsktKH4CsuhPC24LPnJ+uq8Y1h5XkcwQCN+F8KgE5
        JM+VPXlFl972V7PXJmue537XLzil+UWwU
X-Received: by 2002:a17:907:3a52:b0:7c0:e23f:17cd with SMTP id fc18-20020a1709073a5200b007c0e23f17cdmr2417540ejc.491.1672708020285;
        Mon, 02 Jan 2023 17:07:00 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt3q5LA1m8FiqaIblOq7WJyUm+jPTcHob2DMXpvnMkMn4dCRH6N8MxN8HQFzDbmx9rx6TqSg3QO+KDnIR7ZQrg=
X-Received: by 2002:a17:907:3a52:b0:7c0:e23f:17cd with SMTP id
 fc18-20020a1709073a5200b007c0e23f17cdmr2417528ejc.491.1672708020144; Mon, 02
 Jan 2023 17:07:00 -0800 (PST)
MIME-Version: 1.0
References: <20221217000226.646767-1-miquel.raynal@bootlin.com>
 <20221217000226.646767-7-miquel.raynal@bootlin.com> <CAK-6q+hJb-py2sNBGYBQeHLbyM_OWzi78-gOf0LcdTukFDO4MQ@mail.gmail.com>
In-Reply-To: <CAK-6q+hJb-py2sNBGYBQeHLbyM_OWzi78-gOf0LcdTukFDO4MQ@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 2 Jan 2023 20:06:49 -0500
Message-ID: <CAK-6q+hWBAPB=qT+nH29rzn_Up8UO+FYgTJ+GHH1TWJYu=2B5g@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 6/6] mac802154: Handle passive scanning
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jan 2, 2023 at 8:04 PM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Fri, Dec 16, 2022 at 7:04 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> ...
> > +void mac802154_scan_worker(struct work_struct *work)
> > +{
> > +       struct ieee802154_local *local =
> > +               container_of(work, struct ieee802154_local, scan_work.work);
> > +       struct cfg802154_scan_request *scan_req;
> > +       struct ieee802154_sub_if_data *sdata;
> > +       unsigned int scan_duration = 0;
> > +       struct wpan_phy* wpan_phy;
> > +       u8 scan_req_duration;
> > +       u8 page, channel;
> > +       int ret;
> > +
> > +       /* Ensure the device receiver is turned off when changing channels
> > +        * because there is no atomic way to change the channel and know on
> > +        * which one a beacon might have been received.
> > +        */
> > +       drv_stop(local);
> > +       synchronize_net();
>
> Do we do that for every channel switch? I think this is not necessary.
> It is necessary for bringing the transceiver into scan filtering mode,
> but we don't need to do that for switching the channel.
>
> And there is a difference why we need to do that for filtering. In my
> mind I had the following reason that the MAC layer is handled in Linux
> (softMAC) and by offloaded parts on the transceiver, this needs to be
> synchronized. The PHY layer is completely on the transceiver side,
> that's why you can switch channels during interface running. There
> exist some MAC parameters which are offloaded to the hardware and are
> currently not possible to synchronize while an interface is up,
> however this could change in future because the new helpers to
> synchronize softmac/transceiver mac handling.
>
> There is maybe a need here to be sure everything is transmitted on the
> hardware before switching the channel, but this should be done by the
> new mlme functionality which does a synchronized transmit. However we
> don't transmit anything here, so there is no need for that yet. We
> should never stop the transceiver being into receive mode and during
> scan we should always be into receive mode in
> IEEE802154_FILTERING_3_SCAN level without never leaving it.

s/without/and/

- Alex

