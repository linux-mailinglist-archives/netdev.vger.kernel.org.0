Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1C15B122F
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 03:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiIHBka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 21:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiIHBk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 21:40:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AAFC6FC3
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 18:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662601226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=omTeNvcKp/F4WU/b2YX04Q0z1z9EGBUTXmAYav/J+8I=;
        b=dOlM5IQmVAjNmmq5UzdWy4f9v+SJjLna1L6AprYd1zTZmzT+T/d3rfJsN6I46F0owtdjug
        ZS8GrELwzqQ794F2eELd7mVhoChstEJvOyJnUs7i555zZwOLL42TY2FDGMZBhxIap3TzBb
        F/CAl1h9BkxGxILCHMZCMZiAn39TGhk=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-653-KcWeWKC3M5SDnpKQa-M31g-1; Wed, 07 Sep 2022 21:40:25 -0400
X-MC-Unique: KcWeWKC3M5SDnpKQa-M31g-1
Received: by mail-yb1-f198.google.com with SMTP id j11-20020a05690212cb00b006454988d225so10654762ybu.10
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 18:40:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=omTeNvcKp/F4WU/b2YX04Q0z1z9EGBUTXmAYav/J+8I=;
        b=P+iVuLQxBFNtXj7Cpr+/chfOiNWfxjm8qEDMOE5S7fPBJTVdqevWVZ2a0Zs5lnSbBf
         l+XI/qf1mSZbwPpuF3ELPJSKxF00HBHQQ5dXCAlHKcsR01X0cFay5XpL5waPV5XPj+2q
         +NB+dLyj4wXL5GbHQmDsDzKyODBa2KsAcZTEUe3yNkMWjOwRhl9VpWgk32y9C1uiYvC+
         2X0wY2XVhO3QFBtkBSN1KKbg212TOA2GzlEAds2+T37p3zIYbYaUixAbh63vdo16YnzU
         4BxV58fCYYrHsSOC3VnX92Kj2v7nrMJ7SD92KXE0nITPWyar2lim5I0yfEeVS1v5Zybq
         /MEA==
X-Gm-Message-State: ACgBeo3IAPethXl2Ac+97c5PdYHZJK4+HYBMJOeSG4ia32NOsqZj8vk1
        A6DvPtYMnLABfLjlrwudPnTffUCD+KiHfWgu8+jabmW98q+DNrEmKWds1vicPjD9RSg2Xi/NzYj
        gEDhXkLPPr+beOJ+ZNL3RuR620R8/8hQV
X-Received: by 2002:a81:1353:0:b0:345:34b5:ad29 with SMTP id 80-20020a811353000000b0034534b5ad29mr5649143ywt.17.1662601224876;
        Wed, 07 Sep 2022 18:40:24 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5LZWdEKyps6F3LhUYn+aKdzCf042LfowbjEVJPv2xs6teQumCPjTo+wP371qgCXE/dW4wx5ZMJEoBMQXO4/y0=
X-Received: by 2002:a81:1353:0:b0:345:34b5:ad29 with SMTP id
 80-20020a811353000000b0034534b5ad29mr5649140ywt.17.1662601224700; Wed, 07 Sep
 2022 18:40:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220905203412.1322947-1-miquel.raynal@bootlin.com>
In-Reply-To: <20220905203412.1322947-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 7 Sep 2022 21:40:13 -0400
Message-ID: <CAK-6q+g64BTFsHKKwoCqRGEERRgwoMSTX2LJMQMmmRseWBi=hQ@mail.gmail.com>
Subject: Re: [PATCH wpan/next v3 0/9] net: ieee802154: Support scanning/beaconing
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
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Sep 5, 2022 at 4:34 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hello,
>
> A third version of this series, dropping the scan patches for now
> because before we need to settle on the filtering topic and the
> coordinator interface topic. Here is just the filtering part, I've
> integrated Alexander's patches, as well as the atusb fix. Once this is
> merge there are a few coordinator-related patches, and finally the
> scan.

I think we have a communication problem here and we should talk about
what the problems are and agree on a way to solve them.

The problems are:

1. We never supported switching from an operating phy (interfaces are
up) into another filtering mode.

2. Scan requires to be in "promiscuous mode" (according to the
802.15.4 spec promiscuous mode). We don't support promiscuous mode
(according to the 802.15.4 spec promiscuous mode). We "can" however
use the currently supported mode which does not filter anything
(IEEE802154_FILTERING_NONE) when we do additional filtering in
mac802154. _But_ this is only required when the phy is scanning, it
will also deliver anything to the upper layers.

This patch-series tries to do the second thing, okay that's fine. But
I thought this should only be done while the phy is in "scanning
mode"? The other receive path while not in promiscuous mode
(phy->filtering == IEEE802154_FILTERING_4_FRAME_FIELDS) should never
require any additional filtering. I somehow miss this point here.

For 1), the driver should change the filtering mode" when we start to
"listen", this is done by the start() driver callback. They should get
all receive parameters and set up receiving to whatever mac802154,
currently there is a bit of chaos there. To move it into drv_start()
is just a workaround to begin this step that we move it at some point
to the driver. I mention 1) here because that should be part of the
picture how everything works together when the phy is switched to a
different filter level while it's operating (I mean there are running
interfaces on it which requires IEEE802154_FILTERING_4_FRAME_FIELDS)
which then activates the different receive path for the use case of
scanning (something like (phy->state & WPANPHY_SCANING) == true)?

I am sorry, but I somehow miss the picture of how those things work
together. It is not clear for me and I miss those parts to get a whole
picture of this. For me it's not clear that those patches are going in
this direction.

- Alex

