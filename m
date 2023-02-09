Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0BB690110
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 08:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjBIHQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 02:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjBIHQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 02:16:38 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5F445F71;
        Wed,  8 Feb 2023 23:15:00 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id d14so773807wrr.9;
        Wed, 08 Feb 2023 23:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rY1g9O1yCevGy6KnVm3nx+WrQfWq2/pjsLaafFIUf5g=;
        b=bRKbS66duCfoAC0id9taxO8QTkz+/itawKKzKDIZAEGZZcpFjeUAufTI3JKzfYzkYc
         +8u7HL2Q8pAN/g8ymoiZ8NxRJ/8qE7PTxTN2rdurWDqDxoyQ0lJxlPXugvKkTlRJSExm
         +eH/enxHCzdA2ODgnQl688PA6nFhvA8XZsfIeM+11mAmyopKfVEdvt2RwWtrvn/xRgax
         JskC7v7BdpNPKWzdO6cXJWbRqluw6fJ7C118pyHzQs+08xUEROCwo5BTQuSpn8xFtLoD
         pFfgehFS2O/BAIde3PprypiZywdFm5XVm3tFXcOaO2iyvsLFfT9T12+gNhPpBR4AoPzb
         v3NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rY1g9O1yCevGy6KnVm3nx+WrQfWq2/pjsLaafFIUf5g=;
        b=nU9jFr8wiubjKbeP+ZMlfrcpsKbtBveN3ETC510P+VLF7BgLa6kDmHqZbZZghCHy37
         yCr+6qxApR/dcHdxpoY6T8aUtrVjDUu4SDkGmDM/lu8N45oLL9u83MOPjvl6Vd3NRZ4E
         vYw+EMAwRndVPY8XA8nM5WyXj23c6wWktFpQBYNA0o7ZMNd/3GzCC29HmCXUUXrB5DBZ
         /1MhPCxr/WKtce+j8J3lPEMtwzz5ThOOaRkRz8t29k61bmLwYCKd2/k4ooewjFhD7FAY
         QS/u+be6m7b8F4yPNs3lORoCMf6zlh37O31Qii53x/z//wqnkZNfmY8R9ater8oKWFmZ
         MUAA==
X-Gm-Message-State: AO0yUKXWItQhyHjx9SRazh3gbbk/TJ5bMhYAvMFz/x3+7+CVanPTECAK
        JzgKEZgXHsyaDdp7/BXubGWcEFFTz4GywNqwyWE=
X-Google-Smtp-Source: AK7set9clA7Kg3f7TW7pZW9B5Jd3ydM5J5Ps5HM7l+0Z7qDb18CNyWOZf2nTDMKpIE+5ZDLoT3zPRfgNJRz7vWNy3w8=
X-Received: by 2002:a5d:6946:0:b0:2c4:538:a491 with SMTP id
 r6-20020a5d6946000000b002c40538a491mr160688wrw.475.1675926885862; Wed, 08 Feb
 2023 23:14:45 -0800 (PST)
MIME-Version: 1.0
References: <20230208155220.1640-1-bage@debian.org> <20230208155220.1640-3-bage@debian.org>
 <CABBYNZKnt5=dar6Rmav=Tv3QH1ghSUV2osZPnp7OQLcANp_1Tw@mail.gmail.com> <0B0EFD39-825F-4635-A7F3-CA96BCFED9A2@holtmann.org>
In-Reply-To: <0B0EFD39-825F-4635-A7F3-CA96BCFED9A2@holtmann.org>
From:   Vasily Khoruzhick <anarsoul@gmail.com>
Date:   Wed, 8 Feb 2023 23:14:19 -0800
Message-ID: <CA+E=qVdLhyJYj-53+OSgpLQcTXY=H4TsVb-UFQYhMSkHZJj4hA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] Bluetooth: btrtl: add support for the RTL8723CS
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Bastian Germann <bage@debian.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 8, 2023 at 11:02 PM Marcel Holtmann <marcel@holtmann.org> wrote:

Hi Marcel,

> Hi Luiz,
>
> >> The Realtek RTL8723CS is a SDIO WiFi chip. It also contains a Bluetooth
> >> module which is connected via UART to the host.
> >>
> >> It shares lmp subversion with 8703B, so Realtek's userspace
> >> initialization tool (rtk_hciattach) differentiates varieties of RTL8723CS
> >> (CG, VF, XX) with RTL8703B using vendor's command to read the chip type.
> >
> > Don't remember anything called rtk_hciattach, besides if that is based
> > on hciattach that is already deprecated in favor of btattach.
>
> and btattach is also deprecated. Write a proper serdev based driver.

It is already a proper serdev based driver. rtk_hciattach is only
mentioned to explain how differentiating the chips was implemented
prior to this driver.

Regards,
Vasily

> The hci_ldisc line discipline crap needs to be removed.
>
> Regards
>
> Marcel
>
