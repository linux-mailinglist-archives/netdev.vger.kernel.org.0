Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71765564B13
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 03:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbiGDBOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 21:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbiGDBNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 21:13:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BBE6162F3
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 18:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656897183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l6VkutLRt58AHq8Nn03GgZWZyUXFCmGZ7rv040e8EzE=;
        b=B7TuUeq6L+Zq3YoAEXYJVLHgxaXXxaY2zRmen8w/FCPePhex1jqhiH+3bX1TsiUup5SJau
        0BTuAZd4FE6VIo6YMrssVSbTian02B9zzz4PA9h/u5bEYGPm6PQ67RaOGyHqfBB4HARzat
        WpZKhmpSqv02UpdhkONlZAXUyXtDjfw=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-mW53L4kXMMK48XIjR4LY0w-1; Sun, 03 Jul 2022 21:12:55 -0400
X-MC-Unique: mW53L4kXMMK48XIjR4LY0w-1
Received: by mail-qt1-f197.google.com with SMTP id u2-20020ac80502000000b002f94701339eso5603561qtg.13
        for <netdev@vger.kernel.org>; Sun, 03 Jul 2022 18:12:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l6VkutLRt58AHq8Nn03GgZWZyUXFCmGZ7rv040e8EzE=;
        b=KboCL0wndwA2v120EZFeY4p+G9AXU22SJVUk+10DDiX4+vwZnz9BsVd1xjd7099KKJ
         CkZb5IQbe8k/0a4AjyNd2Hv1DIlHNhFzRcLjGuUf7UW47PF02d1glsXC91Y9Zj9YGlh9
         rkDZdh5ctvaM+vWy9Wck/szsRN+ZC6bO9X1sh2a3KF7iIW6WQL6bsYa64Hghl+LPCgrL
         6RpF/iHBqNynoO+2iEAvbfjFo242HuJY1qj36GocGr5aBwADELfZwSG7n4oU4fq4qaD4
         Ad1fCstPtQukCc/ni6m/WJRR4fPErqupI1fNMxfZug3Pte4mQzvslXyjUHoMj8gcMawH
         EFdw==
X-Gm-Message-State: AJIora/+XbqRAN5tldaj/gJhkL+n3WotgLWbLIZN1UVfqAPorK0V6h1E
        2HG+9XLYxLYWpgTOkLAtEYRN790qnEXDvuUieOXCoQOnEwWUbLqRdeLg75KkaS7JzXRvUap2ca7
        lQwj5GK4EE482QxsPE04hMBnjvxacNbJC
X-Received: by 2002:a05:622a:38f:b0:305:1ea5:4a7 with SMTP id j15-20020a05622a038f00b003051ea504a7mr7760148qtx.291.1656897174797;
        Sun, 03 Jul 2022 18:12:54 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1unUxMt5esZ/+Fv3eQoXGfrd9TWwp72cMFu9/6CDqTg3coES5NffiarICXjmemhUwr7iqw0L6LKLwsGLea/RF0=
X-Received: by 2002:a05:622a:38f:b0:305:1ea5:4a7 with SMTP id
 j15-20020a05622a038f00b003051ea504a7mr7760129qtx.291.1656897174600; Sun, 03
 Jul 2022 18:12:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com> <20220701143052.1267509-10-miquel.raynal@bootlin.com>
In-Reply-To: <20220701143052.1267509-10-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 3 Jul 2022 21:12:43 -0400
Message-ID: <CAK-6q+hu4YGfU9V5EkRiT+Z8MJhOEeVsVv=vEz5fHPkDL99=TQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next 09/20] net: mac802154: Introduce a global device lock
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
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Jul 1, 2022 at 10:36 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> The purpose of this device lock is to prevent the removal of the device
> while an asynchronous MLME operation happens. The RTNL works well for
> that but in a later series having the RTNL taken here will be
> problematic and will cause lockdep to warn us about a circular
> dependency. We don't really need the RTNL here, just a serialization
> over this operation.
>
> Replace the RTNL calls with this new lock.

I am unhappy about this solution. Can we not interrupt the ongoing
operation "scan" here and come to an end at a stop?

The RTNL is NOT only to prevent the removal of something... If mostly
all operations are protected by and I know one which makes trouble
here... setting page/channel. I know we don't hold the rtnl lock on
other transmit functionality for phy settings which has other reasons
why we allow it... but here we offer a mac operation which delivers
wrong results if somebody does another setting e.g. set page/channel
while scan is going on and we should prevent this.

Dropping the rtnl lock, yes we can do that... I cannot think about all
the side effects which this change will bring into, one I know is the
channel setting, mostly everything that is interfering with a scan and
then ugly things which we don't want... preparing the code for the
page/channel gives us a direction on how to fix and check the other
cases if we find them. btw: we should do this on another approach
anyway because the rtnl lock is not held during a whole operation and
we don't want that.

We should also take care that we hold some references which we held
during the scan, even if it's protected by stop (just for
correctness).

- Alex

