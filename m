Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F205C55CE14
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240277AbiF1LW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 07:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbiF1LWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 07:22:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AAA592E087
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 04:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656415373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=acdCF6iYkZn7d+1bviTwCpM+1enwsilN4jZ+ihkP0yc=;
        b=B/rL+RL2xjfHzkCJTrsiawsJWkWGGCi+hfIVKA3DmXpGfzSk/ekFQI3P+njVL8HmJlGjI7
        OrH1QGA9533SfsMaJQDIQ55gEbGJFF8EyvfHnx4oS9WaHCWO7GImxjXakiNG5U+s1Gv5Qy
        RJU+gXomAwZJi9rwhPY7OHu3pmRssok=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-psQ5qL8aM4a2whS3eAqqMA-1; Tue, 28 Jun 2022 07:22:52 -0400
X-MC-Unique: psQ5qL8aM4a2whS3eAqqMA-1
Received: by mail-wm1-f70.google.com with SMTP id v184-20020a1cacc1000000b0039c7efa3e95so4968838wme.3
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 04:22:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=acdCF6iYkZn7d+1bviTwCpM+1enwsilN4jZ+ihkP0yc=;
        b=LN79r8sCqVw7Rwg1E/avjhsEfob8ryXJdUCAO/HWUjYxAVJky79j+Zb+F5yQDtC8qN
         YFDspV/h1mizS3wZEllaUE6ldCpGkKoPsZxqbjQGh2LJkR+aUwvenIMWmXIkJ7CyvQMN
         48uZdBZc/GP9VRSnMzdshbFOlrNDSdYBxaYTnBau3au0yXFJGOgI8A72Iu3Qrjz7DRIa
         SwkzuRHjAt8rz1+p/RilwepNwLvYTJhvAuJpvjjJFei5HpNoDvN+ClPDurquLCgEoVKF
         AIdJVfDKu/fBsieJ9BROsztMJ2ABkDIxhQ+ciKKyQmgLxzqZRWAeI704y8vYqiEEHW6F
         EG0w==
X-Gm-Message-State: AJIora/EGQi6yNd3837bh5T4PV94otyFfQj+HFWyCYTT4Pg9EtDBRKb2
        ScOjuB99YrdcfjLPiNH3UAIrWeYvAkG6oHEaUWxgSRMnpJ/gswjhtFeDsd66ksIHQKjDHV7xco2
        i39EhmqFWccm+3JM1
X-Received: by 2002:a5d:4443:0:b0:21b:9339:d820 with SMTP id x3-20020a5d4443000000b0021b9339d820mr17123668wrr.324.1656415371226;
        Tue, 28 Jun 2022 04:22:51 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vdgcLyjT9qmhEx5D0Y1yDfrMocphAVk8/DmCE3HP5ONI93eSJZWA+a3iENjFzGOSqU5wYEWQ==
X-Received: by 2002:a5d:4443:0:b0:21b:9339:d820 with SMTP id x3-20020a5d4443000000b0021b9339d820mr17123650wrr.324.1656415371028;
        Tue, 28 Jun 2022 04:22:51 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-115-110.dyn.eolo.it. [146.241.115.110])
        by smtp.gmail.com with ESMTPSA id k22-20020a05600c0b5600b003a02cbf862esm16623467wmr.13.2022.06.28.04.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 04:22:50 -0700 (PDT)
Message-ID: <6644160a045fad4d12c76c462ebde935bf644af4.camel@redhat.com>
Subject: Re: [PATCH net-next v2 1/1] net: phy: ax88772a: fix lost pause
 advertisement configuration
From:   Paolo Abeni <pabeni@redhat.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>
Date:   Tue, 28 Jun 2022 13:22:49 +0200
In-Reply-To: <20220628064355.GD13092@pengutronix.de>
References: <20220626152703.18157-1-o.rempel@pengutronix.de>
         <20220627221705.0a49f3c9@kernel.org>
         <20220628064355.GD13092@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-06-28 at 08:43 +0200, Oleksij Rempel wrote:
> On Mon, Jun 27, 2022 at 10:17:05PM -0700, Jakub Kicinski wrote:
> > On Sun, 26 Jun 2022 17:27:03 +0200 Oleksij Rempel wrote:
> > > Subject: [PATCH net-next v2 1/1] net: phy: ax88772a: fix lost pause advertisement configuration
> > > 
> > > In case of asix_ax88772a_link_change_notify() workaround, we run soft
> > > reset which will automatically clear MII_ADVERTISE configuration. The
> > > PHYlib framework do not know about changed configuration state of the
> > > PHY, so we need use phy_init_hw() to reinit PHY configuration.
> > > 
> > > Fixes: dde258469257 ("net: usb/phy: asix: add support for ax88772A/C PHYs")
> > 
> > Why net-next?
> 
> It is old bug but it will be notable only after this patch:
> https://lore.kernel.org/all/20220624080208.3143093-1-o.rempel@pengutronix.de/
> 
> Should I resend it to net?

It depends ;) is the fix functionally depending on the above patch? If
yes, please update the commit message including such info (and the fix
will go via net-next).

If instead this patch is correct even regarless of
89183b6ea8dd39771d92e99723f6cf60b5670dad, I *think* it should go via -
net.

Thanks!

Paolo

