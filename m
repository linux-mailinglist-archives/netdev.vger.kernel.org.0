Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835075FA98B
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 03:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiJKBBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 21:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiJKBBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 21:01:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F1079EE6
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 18:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665450085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UIc0PRRAegvqEDcOrK3Tyz8JLKn11AkZNNcOR20Pjew=;
        b=NNeEVpPRaI/4+PGBfP4G6EEpLokzAmhbaLrgjwz9A5zGpU/uRfAf0vCJzPDvU69CWukoct
        jr4uMCKCG6SsFEP1USydgyHsu9llZhcIpxNmaqKO1izLtPl5OwGarO2FzKZv9mgOQ+85IW
        G3S4hs6Pkr3yKiZU+sOlzkrd+yBXgGI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-439-ZyzLZNXyMVG0I8-pz0-6cA-1; Mon, 10 Oct 2022 21:01:24 -0400
X-MC-Unique: ZyzLZNXyMVG0I8-pz0-6cA-1
Received: by mail-wm1-f69.google.com with SMTP id az35-20020a05600c602300b003c5273b79fdso4167790wmb.3
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 18:01:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UIc0PRRAegvqEDcOrK3Tyz8JLKn11AkZNNcOR20Pjew=;
        b=gByDTNBG9nCkXnRf2G2lJlUhnq+xBrXV11kSj4Gt7XBIv2/6hQptcMosWBlQC+yE7r
         1gPolizOCbs8nlXpvwVFRcOQJ1KZuV7TPATnWGVZyShcLzmijVzVYSDZgpTbmhPJOU7J
         8H7DAQPh6MysFtCTDT31wfrncJdNCKAebXQRZatI1XRaG7ICQv/Xvz8Z/qGlpDFzxKD3
         90BvRIlREX/lnIHt9Z1nkaI04A+4oTPg4KkJZe/Ca5FbVVbB2CQoDp//YeijWJLhcPV2
         xDmZGFzeuyVLTvZ6ljIvHQhuXF1ZukVG0b3FbVrvTezjstwVg58umw1WJZlVysKy9AJY
         4qDg==
X-Gm-Message-State: ACrzQf2KjpurGq4Gb6EElYYRPEAFlRw6P4QImxlQy1yTHO6HS0RkAsrX
        J3AgDRBhOHww4k8qAv80b1iHEdiEZ+eLWspi+/KeG/FytKMO7ju76xdyZEegCDfrwfDdQnx4Va+
        S+SGzgOzcriiQjIY9Na2RUB7aAPpEiGJA
X-Received: by 2002:a05:600c:4e15:b0:3b4:a621:b54e with SMTP id b21-20020a05600c4e1500b003b4a621b54emr14277434wmq.47.1665450083317;
        Mon, 10 Oct 2022 18:01:23 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7leXsoXu7bEaYryj01zogLfSvFzsSiHWmZ8Id8pVM45N4IvlvWQO1JQvMzo7j2ZcgITlNxZRrxltSF8YBdsJo=
X-Received: by 2002:a05:600c:4e15:b0:3b4:a621:b54e with SMTP id
 b21-20020a05600c4e1500b003b4a621b54emr14277427wmq.47.1665450083184; Mon, 10
 Oct 2022 18:01:23 -0700 (PDT)
MIME-Version: 1.0
References: <20221007085310.503366-1-miquel.raynal@bootlin.com>
In-Reply-To: <20221007085310.503366-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 10 Oct 2022 21:01:12 -0400
Message-ID: <CAK-6q+i6LPM2YjCCaWU-LL6vFUCY=SweiWDJrA12M1cKtNYGUQ@mail.gmail.com>
Subject: Re: [PATCH wpan/next v4 0/8] net: ieee802154: Improve filtering support
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
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Oct 7, 2022 at 4:53 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hello,
>
> A fourth version of this series, where we try to improve filtering
> support to ease scan integration. Will then come a short series about
> the coordinator interfaces and then the proper scan series.
>

I think this patch series goes into the right direction. So I would
give it a go:

Acked-by: Alexander Aring <aahringo@redhat.com>

- Alex

