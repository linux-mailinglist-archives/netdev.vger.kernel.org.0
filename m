Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26EDC14CAC5
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 13:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgA2MXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 07:23:32 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40848 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726067AbgA2MXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 07:23:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580300610;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5nmv5uDdO2YxGOuUkOfvD+c+DttH6/ocuyIFf6Oc6TY=;
        b=KHqpzFObOnqnjNvi7k5ze1UCSR1N3sLh1bOHVlJ2rJJojPbyDKtSzzm+XH1pxg9QUX0N49
        wj9lot6qsGctVsxZ+StEk+hKFmu7DGihBoH1ld7wpwuAutzjucMF+bmrgjLUe/90tvOnxO
        vEY0UcM8eMb6g6ddp/5pMgJh9FdbbX4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-jS_XjZHdP-agm8MnLn8yVA-1; Wed, 29 Jan 2020 07:23:27 -0500
X-MC-Unique: jS_XjZHdP-agm8MnLn8yVA-1
Received: by mail-wm1-f69.google.com with SMTP id p5so2521512wmc.4
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 04:23:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=5nmv5uDdO2YxGOuUkOfvD+c+DttH6/ocuyIFf6Oc6TY=;
        b=HBj8ae0r/qx6vux5/ChaJYrGiKVdl92AtPsmb6SzNXDoKExUToXZvnXr9vpupYqj51
         MJUj9jQ8DCuGOOhAqIUAClnMWCKhJZ1jvCf+UIqbBZ/4UPpAVQ0xIngwydAjQC0tTkYe
         N+U0iv8WSm74G76FZbHcq6ZCrARaJL7X0ZZ57HJ+Hd0Ujeyiwz0qOEfVyooJ+ODcSvqV
         RfW+a5e7CK3wee48+KIN/kMo8/vjwKfRgfPWy9IjifthcxbFxvSNFzYlSGuVsRnW2jwh
         lIfD4jCALmGD19DSXer1Mnl5/LkAsOCFyrkxRlO3KgNSCXkUL90R54chezE4TU+SRJ+m
         alOA==
X-Gm-Message-State: APjAAAV8uoAlsG9uh+1WGs+svdP7jW8m7EZhHz0rsAMPf6c3m/470ts+
        n/yDbUyGDSQbD5AjamQriuoirOq6STESG84nsRV9rIV3gg2sgrBleWZYvCsIQLv0Nn4CxY0h9os
        nvJKmnhjiUDoFOLMh
X-Received: by 2002:a5d:44cd:: with SMTP id z13mr35840914wrr.104.1580300606128;
        Wed, 29 Jan 2020 04:23:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqwEZ8x6ib4lBZz8jXGZ/UJbt6Q9zwe3y15c7vPAgYxYx/8I8lkBlKZc8NkaDPsL1VxOrG778A==
X-Received: by 2002:a5d:44cd:: with SMTP id z13mr35840890wrr.104.1580300605926;
        Wed, 29 Jan 2020 04:23:25 -0800 (PST)
Received: from [10.43.2.47] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id o4sm2544383wrw.97.2020.01.29.04.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 04:23:25 -0800 (PST)
Message-ID: <48acf1493888ea4084d9a9e75dc05c32e9e32fc9.camel@redhat.com>
Subject: Re: [PATCH net] phy: avoid unnecessary link-up delay in polling mode
From:   Petr Oros <poros@redhat.com>
Reply-To: poros@redhat.com
To:     David Miller <davem@davemloft.net>, ivecera@redhat.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Date:   Wed, 29 Jan 2020 13:23:25 +0100
In-Reply-To: <20200129.131511.287823999185152451.davem@davemloft.net>
References: <20200129101308.74185-1-poros@redhat.com>
         <20200129130622.1b8b6e43@cera.brq.redhat.com>
         <20200129.131511.287823999185152451.davem@davemloft.net>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller píše v St 29. 01. 2020 v 13:15 +0100:
> From: Ivan Vecera <ivecera@redhat.com>
> Date: Wed, 29 Jan 2020 13:06:22 +0100
> 
> > On Wed, 29 Jan 2020 11:13:08 +0100
> > Petr Oros <poros@redhat.com> wrote:
> > 
> >> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> >> index 6a5056e0ae7757..d5f4804c34d597 100644
> >> --- a/drivers/net/phy/phy_device.c
> >> +++ b/drivers/net/phy/phy_device.c
> >> @@ -1930,9 +1930,10 @@ int genphy_update_link(struct phy_device *phydev)
> >>  
> >>      /* The link state is latched low so that momentary link
> >>       * drops can be detected. Do not double-read the status
> >> -     * in polling mode to detect such short link drops.
> >> +     * in polling mode to detect such short link drops except
> >> +     * the link was already down.
> >>       */
> >> -    if (!phy_polling_mode(phydev)) {
> >> +    if (!phy_polling_mode(pihydev) || !phydev->link) {
> >                                ^
> > Please remove the extra 'i' ----
> 
> How could this have ever been even build tested, let alone functionally
> tested? :-/

Sorry, it was tested on xgene-enet with RTL8211E phy. With patch there was ~4s
delay and without it ~5s. But before send i added "except the link was already
down" comment and by mistake added extra "i" in vim. Again, sorry.

-Petr

> 


