Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3BC653134
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 14:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbiLUNBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 08:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLUNBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 08:01:03 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AA0E86;
        Wed, 21 Dec 2022 05:01:01 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id p1-20020a05600c1d8100b003d8c9b191e0so409715wms.4;
        Wed, 21 Dec 2022 05:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=AdWnQ27kmD5VfUep6TMl51Z7Mmf8V787tpSu6AJKxEg=;
        b=oyt/8pGg1HMGojQDGzHmX1gBi3DLmAoeXQRc50l2jVvtEt6ZUyvgBemjlgZWoLJsuT
         GOGNdrKiCXl8WF1xSR18lM5B4hZhpDb5oK1r8wFqNXYE1wcn5AY2xf8s80pnEEVQMgl9
         /KU4+l09Zj/e3sGYiIN8fm0y7//8OWmzVSJ0tyS1Md16UtA57RCifis2Ho3SPJfj7S9p
         jS++UST56AC+kpLbchtuYsTovkvz3OK6cit9gDtpXgZy9ZSd/NbrOj3ahbje6OcVEYJE
         P2hZUIMC+4SxXDuEc4P5QCc95AgkXXzkmYAeu7/X6z9fJfzrSojuu4OSrh5WajJyqAGu
         k71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AdWnQ27kmD5VfUep6TMl51Z7Mmf8V787tpSu6AJKxEg=;
        b=AaykZJ6s0eyzzpboq+zFuO6TcWfa+LjCIk29oDbHrJSnOHoNR9HQ9eTD0AuSRrcmY3
         BcwsQnF7ts38SnOsMpysm/w7wSW1etyFT/lcy53EQSTPq6IpLQkufFX2jh/lyvxZlQKm
         OB6y53yCbQHEouQAuptJ+pVNnS2aaW4Ia/CrgLiJVC5UJwmD6KhcD1KPhQ+RacYwIIe6
         eIvf1IPf5lGbepCnuFsthXguSRy14XdlMB5OJJ4PaBqUAEc/yGioUbfBLvQCit2Ahslp
         QRm7F4VAQeMnE23XoF/KbpF6xcbbOrezkYy0mVqGsH8b7hbrQ/otQTU+hAMuFQ+iUjkP
         d1ZA==
X-Gm-Message-State: AFqh2kokdzB5WZY716dRYiDZzy5kUnt1HmD2pBakc0Rk/xKYbh76aaWk
        zMZHW2s7px11mjS9nu080RI=
X-Google-Smtp-Source: AMrXdXusTys0JXtfMzelMdlOYTwD5NxEVLnl3ZVjpk1SyvqgRkDQPrajXdSjXMWVddhhIdX2zVCXDQ==
X-Received: by 2002:a05:600c:510e:b0:3d3:5885:4d21 with SMTP id o14-20020a05600c510e00b003d358854d21mr1527171wms.17.1671627660155;
        Wed, 21 Dec 2022 05:01:00 -0800 (PST)
Received: from Ansuel-xps. (host-82-55-238-56.retail.telecomitalia.it. [82.55.238.56])
        by smtp.gmail.com with ESMTPSA id h20-20020a05600c415400b003d1e34bcbb2sm2263193wmm.13.2022.12.21.05.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 05:00:59 -0800 (PST)
Message-ID: <63a3038b.050a0220.d41c3.6f48@mx.google.com>
X-Google-Original-Message-ID: <Y6MDiW7SlyPxDU4g@Ansuel-xps.>
Date:   Wed, 21 Dec 2022 14:00:57 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH v7 06/11] leds: trigger: netdev: add hardware control
 support
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-7-ansuelsmth@gmail.com>
 <Y5tUU5zA/lkYJza+@shell.armlinux.org.uk>
 <639ca665.1c0a0220.ae24f.9d06@mx.google.com>
 <Y6JMe9oJDCyLkq7P@lunn.ch>
 <Y6LX43poXJ4k/7mv@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6LX43poXJ4k/7mv@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 09:54:43AM +0000, Russell King (Oracle) wrote:
> On Wed, Dec 21, 2022 at 12:59:55AM +0100, Andrew Lunn wrote:
> > > > One thought on this approach though - if one has a PHY that supports
> > > > "activity" but not independent "rx" and "tx" activity indications
> > > > and it doesn't support software control, how would one enable activity
> > > > mode? There isn't a way to simultaneously enable both at the same
> > > > time... However, I need to check whether there are any PHYs that fall
> > > > into this category.
> > > >
> > > 
> > > Problem is that for such feature and to have at least something working
> > > we need to face compromise. We really can't support each switch feature
> > > and have a generic API for everything.
> > 
> > I agree we need to make compromises. We cannot support every LED
> > feature of every PHY, they are simply too diverse. Hopefully we can
> > support some features of every PHY. In the worst case, a PHY simply
> > cannot be controlled via this method, which is the current state
> > today. So it is not worse off.
> 
> ... and that compromise is that it's not going to be possible to enable
> activity mode on 88e151x with how the code stands and with the
> independent nature of "rx" and "tx" activity control currently in the
> netdev trigger... making this whole approach somewhat useless for
> Marvell PHYs.

Again we can consider adding an activity mode. It seems logical that
some switch may only support global traffic instead of independend tx or
rx... The feature are not mutually exclusive. One include the other 2.

We already a simple workaround for the link mode where on the current
driver, if the link mode is enabled just all rule for 10 100 and 1000
mbps are enabled simulating a global link event.

> 
> We really need to see a working implementation for this code for more
> than just one PHY to prove that it is actually possible for it to
> support other PHYs. If not, it isn't actually solving the problem,
> and we're going to continue getting custom implementations to configure
> the LED settings.
> 

Agree that we need other user for this to catch some problem in the
implementation of this generic API.

-- 
	Ansuel
