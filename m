Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672324C2022
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241920AbiBWXn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234743AbiBWXn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:43:56 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACA04B1F5
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 15:43:27 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id gb39so742028ejc.1
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 15:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hOdAUEVD40qL0i0qi4RgEf0RUlc1xQ/ooxbTS9VBzgU=;
        b=dNWMyN86anDVXvqlHoTXPJzfKIbcgcZdiw2TTcvZNrOmnSlOr8OB/cuvrljQwtL3vv
         go+CaUOhGCdSCUIseM8XKQZ20ddwQw0mYcWQ9tn5VYXd7kEnJfbI5dLKOiqT8XsgPsom
         QR3W82cKo7+2HMG1BNNW37c+TNQ79UWc2rp2wEGgfBVZZaF12g2GmuBesij6NueP/0K9
         eyXnxO0XrAoczduXn/Z27cPDtzpUI9LwIj382d0wuSWd+7kjb1SBx8GVSO7cPDdyLQHN
         7sUDhIM6GR9F3h+ID5SmoMKXxpSVMXr+qI3wLiUbPIP1LRT+NwXMCYzaAzCZYPgiFVnZ
         RMaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hOdAUEVD40qL0i0qi4RgEf0RUlc1xQ/ooxbTS9VBzgU=;
        b=1Ai8mfAy3O5vTbE4Je6mF10A2xjp+PMaN1nVMT1YQxx5w1WjsiU0xaVcGDxwwomcdl
         eOSYcIsVH6k0kM4Ax60gUfKxH4yCxG2sAsyicU51wPMT3oOO7MILTXv+rBwgZdryZDem
         T0dqqMk85Hy8CQqMiQDsmo0qUp54nukNCO+GgzfP6XD4xilthbrrScGXAOgmjcD5ZL+n
         1Q034ovugSxvEXqs+SQazszdfuj6cVBKf84A3UXEHDxtFjz5Pb/BSOStymivnbvnSesf
         qrronytHNO10gCEWN9wkP4EpILSLdhWBXaZzBdQRKZlnOgUdt80cpgzJ4D8wm4QV2IWc
         hYhQ==
X-Gm-Message-State: AOAM532S3uwMASWfYUHCm0vXJ1DVtJ4ZLYuF3tMLiLWHbrodNy/0DZ4Y
        qerz4Y+UamkUg3nfo798dVFs4gsLjs8=
X-Google-Smtp-Source: ABdhPJz+t5m6uRo8Qvc42zoyS/8rm85dN+xklZMqLZFSoRorBbPs+9klI5CgkkUkfFtZDL96iidUaA==
X-Received: by 2002:a17:906:85b:b0:69d:eb3:8a7c with SMTP id f27-20020a170906085b00b0069d0eb38a7cmr61415ejd.427.1645659806394;
        Wed, 23 Feb 2022 15:43:26 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id pg26sm446937ejb.194.2022.02.23.15.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 15:43:25 -0800 (PST)
Date:   Thu, 24 Feb 2022 01:43:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com
Subject: Re: [PATCH net-next v3 0/2] net: dsa: realtek: add rtl8_4t tag
Message-ID: <20220223234324.l24vak5usy6vpjkp@skbuf>
References: <20220222224758.11324-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222224758.11324-1-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 07:47:56PM -0300, Luiz Angelo Daros de Luca wrote:
> In those cases, using 'rtl8_4t' might be an alternative way to avoid
> checksum offload, either using runtime or device-tree property.

Good point. Can you please add one more patch that updates
Documentation/devicetree/bindings/net/dsa/dsa-port.yaml?
