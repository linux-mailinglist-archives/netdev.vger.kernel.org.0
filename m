Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2F054015A
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 16:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245481AbiFGO2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 10:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242419AbiFGO2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 10:28:45 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69AC67675;
        Tue,  7 Jun 2022 07:28:44 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id u2so15697815pfc.2;
        Tue, 07 Jun 2022 07:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hHNUasEtqb0kg4AWZUNKoU2GcPV6062wzrkp7khS7KA=;
        b=hjJ7P83fHa7II86itmbf/5LiIf2R1CyjMT9q3Hi6CD/gKnVIQjngTi/ego4WOePT1A
         qi4wK1EBf7yIB/dh8+eWC8UOU0JN/URXKRkYNmWD5Vg0E0SFh3pBr2i0fZ8cnheBSi0q
         O2gaFLCq/7hUhgleC7PLALKlTzFK5BMTST7pQ/g4NrEYjjqh2On3X4kbhgbP7kZWSGfQ
         Ett5MtuhBihiqK4pApqtSSSUTNVDW48E9gM3aLfz19PBFi3n8d8Lt448OejhNulB+sNl
         ymuXkfXkXr9Ul97SCXLorGmr2XEJAY41llx/K3F86EaTPzfATEnf4yeMBScd3lg3zsHq
         Bdrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hHNUasEtqb0kg4AWZUNKoU2GcPV6062wzrkp7khS7KA=;
        b=74fZUz5SaICevPFVP+3cKEuXSKgPFcGFvfigDy8n8Vi0d54SmVk+kq5jMe22Nhkl2A
         ss79hpsNppg4GQ50JaiZ8TxqyXmNcQRQg/JziAjWKd/6XW56+8xU3CXVSS++XmPrRnpk
         N1nEW8F7VliWrrG9WUUhhquxFmNrY4AL9vpymYYCMjbdU11f5Tw1XqGfZjhTRD9n/78C
         tO2YQW6YQq9fkSmB3DArvhWq3A99bSfMqWvuDvU3w/8tXyTjFBNrT7AjJ9edhQYAdx6O
         jAzOpnk+cuoIzZEjHXWkZlNjWy0lb33IvqPSE8P8LjKJWiNeJ0mz3Q8yS6MZVdQjZ6Ts
         N38A==
X-Gm-Message-State: AOAM533BCqd/4ppNYq2a2fWZfUHC9l2OVaHNKgVn4B4fePXs6NGPSdNq
        aIfwuDFqnMSSZgL+lY9Bx1+7C7I0ozSWuebinsA=
X-Google-Smtp-Source: ABdhPJxQ7kydLDT6lo00gaRRnkl2nqDeOO+O9u6UyucLqcDU5DssAJG/FehYlkZk/r9iZaEp8IecSmMkW6jeMFKr0eE=
X-Received: by 2002:a63:3d0b:0:b0:37f:ef34:1431 with SMTP id
 k11-20020a633d0b000000b0037fef341431mr25564875pga.547.1654612123927; Tue, 07
 Jun 2022 07:28:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220606134553.2919693-1-alvin@pqrs.dk> <20220606134553.2919693-5-alvin@pqrs.dk>
In-Reply-To: <20220606134553.2919693-5-alvin@pqrs.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Tue, 7 Jun 2022 11:28:32 -0300
Message-ID: <CAJq09z6Gs9Ltah0mb0hnLORf+_jmLokqU9Oi63JpD8=-LZLpMg@mail.gmail.com>
Subject: Re: [PATCH net-next 4/5] net: dsa: realtek: rtl8365mb: remove
 learn_limit_max private data member
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The variable is just assigned the value of a macro, so it can be
> removed.

The 10-ports devices do use a different value.

    <10 ports
    /* MAX LUT Address Number */
   2112,

    10-ports
    /* MAX LUT Address Number 4096 + 64*/
   4160,

I guess learn_limit_max could be migrated to the new
rtl8365mb_chip_info structure.

Regards,

Luiz
