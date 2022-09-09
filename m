Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 806AD5B2B2B
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 02:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiIIAty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 20:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiIIAtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 20:49:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB7043629
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 17:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662684589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EDkvezHqKVwwq3RpBMzZM+g3RqI22B0rBBYbwFtaJvA=;
        b=IV2F7IJpgER3pHCyql6bZp+fNvapUhtHuxBojSr5c5kEQhNbC33ucGDGM8C/15sRP/crmD
        XRmrzSMmpC20Tn29PhyqoDE+faZVhzBhEEGohTS5Uo4XQPDKhu6nN4YONtxPtWgkpXfgUq
        VR1xV0oBbWfbnre3c+onnidYV7nyZ+A=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-251-SbGtd12NPumlnGji2EtMyQ-1; Thu, 08 Sep 2022 20:49:48 -0400
X-MC-Unique: SbGtd12NPumlnGji2EtMyQ-1
Received: by mail-il1-f200.google.com with SMTP id l20-20020a056e02067400b002dfa7256498so122477ilt.4
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 17:49:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=EDkvezHqKVwwq3RpBMzZM+g3RqI22B0rBBYbwFtaJvA=;
        b=o98jLgt8xSXiPyX45Fy1q3LcXKw9lLjBwaef3zfdBe/LcrwJQ5bYyzWJ80R7SEiXa3
         tjV9s2NWcvX071+YOQnY24v7K9zkJEH4H2o+Mg49XT36zRXyKszS3dsoTnDYNWPYGlP+
         8MJbTk4BxY1yFhdGUx0R4x1X+1n7HnPhBWjvLFMUt7RmG45uE3/FDwNfbbjW132gAIem
         Bm4cyDDC8ridP4Id22jL97jkMGQYmKOigibdQJLDrLO7iTLVuZPXGorwecjGfYm671Ab
         FFk/TNgtaU11dl/Be5P87v9s2HsP4sPY1K80FRGfF3Z6sNIehWDeFK9LzPhhI8azIJdF
         DPfw==
X-Gm-Message-State: ACgBeo3uioREiDdOa6SmIkyMIuPhQ3u5I6noClB0238TLbAUiDYOK/+P
        fEZfExrJS/BdsiJWGmLxB+vzBaXDjdbBnnvH5sr7ndmiI+l5RK1UKfuCjfe7pzJvNZ7vo0oGYbb
        8AbjuQUb9vmQ2iPU5BXXE4MwKg5o5RR2/
X-Received: by 2002:a05:6602:2d8b:b0:688:ece0:e1da with SMTP id k11-20020a0566022d8b00b00688ece0e1damr5351259iow.18.1662684587753;
        Thu, 08 Sep 2022 17:49:47 -0700 (PDT)
X-Google-Smtp-Source: AA6agR54vwkdF3+OlmpGtltB6FD9c/W1VgPD2j6EiEKC4If9aTc36WNrW2EXjP+N/AV26zzxm+P72dv6omhlcDXgw9U=
X-Received: by 2002:a05:6602:2d8b:b0:688:ece0:e1da with SMTP id
 k11-20020a0566022d8b00b00688ece0e1damr5351242iow.18.1662684587496; Thu, 08
 Sep 2022 17:49:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220905203412.1322947-1-miquel.raynal@bootlin.com> <20220905203412.1322947-6-miquel.raynal@bootlin.com>
In-Reply-To: <20220905203412.1322947-6-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 8 Sep 2022 20:49:36 -0400
Message-ID: <CAK-6q+gH3dRj6szUV6Add7G5nh1-5rBUpVLrrdbkjS22tz3ueA@mail.gmail.com>
Subject: Re: [PATCH wpan/next v3 5/9] net: mac802154: Drop IEEE802154_HW_RX_DROP_BAD_CKSUM
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
> This IEEE802154_HW_RX_DROP_BAD_CKSUM flag was only used by hwsim to
> reflect the fact that it would not validate the checksum (FCS). In other
> words, the filtering level of hwsim is always "NONE" while the core
> expects it to be higher.
>
> Now that we have access to real filtering levels, we can actually use
> them and always enforce the "NONE" level in hwsim. This case is already
> correctly handled in the receive so we can drop the flag.
>

I would say the whole hwsim driver currently only works because we
don't transmit wrong frames on a virtual hardware... However this can
be improved, yes. In my opinion the hwsim driver should pretend to
work like other transceivers sending frames to mac802154. That means
the filtering level should be implemented in hwsim not in mac802154 as
on real hardware the hardware would do filtering.

I think you should assume for now the previous behaviour that hwsim
does not send bad frames out. Of course there is a bug but it was
already there before, but the fix would be to change hwsim driver.

- Alex

