Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5A6539BAC
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 05:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349425AbiFADaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 23:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349447AbiFADam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 23:30:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A0C29CC9C
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 20:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654054238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uez4pdd6rTNByI07DHPT6nt3P15ulK/dmFK17elfDS8=;
        b=Io+4xV09eqsdfzLKIbwvOw6AQ1Fj2rneM1QtO/IOnRtS1ELBCNslgfw+YJLnm5sZYcTO2A
        ufe/tmBE3dZ0byc60ZJfnj2es7IFSEOdujKr1GzRwQsAaj2w1urKXx8l7zYt23QTZS2JLy
        IBuOL+Ut1Kr0Vb5XpU3bFOFZo4W/vzA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-C-J0gSU0Noicb4bbwjk0bA-1; Tue, 31 May 2022 23:30:37 -0400
X-MC-Unique: C-J0gSU0Noicb4bbwjk0bA-1
Received: by mail-qk1-f200.google.com with SMTP id bk38-20020a05620a1a2600b006a603146aa4so439771qkb.13
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 20:30:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uez4pdd6rTNByI07DHPT6nt3P15ulK/dmFK17elfDS8=;
        b=hToVwWR85/UntjXbC6expw3+ieqHdjt+URJwClt9JxvymjXZdO9iBYBcO2zKUcXdLM
         9AP6Zlu6EdnY8fvRlIdCZuyUBt/ngI3zboI0iVgxFX189/tji8ITFV6MwmNOw2tCnvM6
         Iz7BkMhjB5BXJLJjDRcE6ti2C2fPYRmxG9k7TptgZcLEEDkxeWMXM5Pi1mqSR/luBAqI
         Y+Y/Ddir/Yha90FD3AcBO5oDRQIQRQ5rTLWIbmefPjugkic/SEmOgvEQ0bkhLn1al9ci
         EkRdGftVBgwwbljKMvZdI78qqMlaHClJArjrQOIZ6VJ/tPVRS0U05Sqj+QVM4LcMqsRA
         +wCA==
X-Gm-Message-State: AOAM533+bgoCInHshE9aL9ryFKbg42u4INAA5KIwzs2Lz1rjzc/Wn3Cb
        hQCz8GxFMEYjSJ5mKWrUQEsxU9B2EYJWEbEbys9nyW/OiNVczOm2wcveMkXFojTpBr9kYPG52X0
        wHOGjDBYXXvom7vFf0IHZED9RGbOVC7T3
X-Received: by 2002:ac8:5a82:0:b0:304:c138:9895 with SMTP id c2-20020ac85a82000000b00304c1389895mr2893547qtc.470.1654054236982;
        Tue, 31 May 2022 20:30:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmL0YAluv459XcSBEPJSIe71phqGVQHBoIyR7YZoUQlxcpz3e0vsJ8mQlBCbKPaoJGLQR7yyMdg4YqTTsxkcs=
X-Received: by 2002:ac8:5a82:0:b0:304:c138:9895 with SMTP id
 c2-20020ac85a82000000b00304c1389895mr2893543qtc.470.1654054236821; Tue, 31
 May 2022 20:30:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220519150516.443078-1-miquel.raynal@bootlin.com>
In-Reply-To: <20220519150516.443078-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 31 May 2022 23:30:25 -0400
Message-ID: <CAK-6q+hmd_Z-xJrz6QVM37gFrPRkYPAnyERit5oyDS=Beb83kg@mail.gmail.com>
Subject: Re: [PATCH wpan-next v4 00/11] ieee802154: Synchronous Tx support
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, May 19, 2022 at 11:06 AM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> Hello,
>
> This series brings support for that famous synchronous Tx API for MLME
> commands.
>
> MLME commands will be used during scan operations. In this situation,
> we need to be sure that all transfers finished and that no transfer
> will be queued for a short moment.
>

Acked-by: Alexander Aring <aahringo@redhat.com>

There will be now functions upstream which will never be used, Stefan
should wait until they are getting used before sending it to net-next.

- Alex

