Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69CE52F02B
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351417AbiETQJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351404AbiETQJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:09:20 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829FE17D380
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:09:19 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id n10so16477603ejk.5
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7Cg6LCQfLn0WTSvtR466h1aEa2Iwynbdw1Q3+GdOyGc=;
        b=hn11T95mrho5yuqp2gZrUIBSVxzM8d397y/SgcNfkDuej6NZ35p5WaBiVTBr8Yb5cZ
         K1PNeYeoieYOWYuVZFtUrL8DbE5xa9toqzYOreQmJtRYPEGWsyK+G10RvApdBy6/NDIu
         x/uCmwil0wE5EiKN9EtoAXuBnu1fTGoFjy38Z5wnywInwR37UWmCwY65QL7Gc8mzukq7
         veK2NgpNRPZIkFx4jxfTEPJnLTnTpl6Vx0MSIEmnbjrDA10gCEnYhsJI2fxxLVSEabRo
         7cwoG9ogF+y2uxT6BgNSVbAXRI9DlzoBE9z28XDsRZdFrxlAeG3orgSbeuSth3iYQG9I
         nqqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7Cg6LCQfLn0WTSvtR466h1aEa2Iwynbdw1Q3+GdOyGc=;
        b=to7INwSaOD4GyF7aUw8YwcxD11oY6IjL3e8sS1mezzCuI3gyq3TeHhJcXqCvFPEG4n
         +kWAQ7zqcWon12B3fTR+RKms7T+ra6JHi7IrBtHUT+y/b1xAfgPMisvka4IY+7RS9QZL
         9sFKlwJlCjRgpAasyNjann5vKVHSwGjWDE9v9134bMnxC0D4BCjBD47lYwnv7GI0xiUu
         vm5VBrCN9TkWCAuzIGzjWEspAr/CNcLxC16S2yrfhtvb1nXu7jsk638+sVMFxxNMvyHh
         I6dLAZ+7KwyEjEn9Gr8IIxXgDPB9syYQw2JWeYWTFHOzRKnw43P+4FkmQVAMFcXn79bj
         2sfQ==
X-Gm-Message-State: AOAM5302T15jrjjRyNui27aEkSX0i4U66Qfp7wCnkvbCXwAtvUWaEtTN
        DS9OU6QeCjnIMTsDf1+gsh0=
X-Google-Smtp-Source: ABdhPJwVSQh87j/fQYXfttzAvS9rCL+sj10jEGCuy9Reln3FFPjoBUuGc+RJz4+CjUCYy2GNYnxjZg==
X-Received: by 2002:a17:907:971b:b0:6f4:3b8c:ae04 with SMTP id jg27-20020a170907971b00b006f43b8cae04mr9685554ejc.548.1653062957920;
        Fri, 20 May 2022 09:09:17 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id s27-20020a170906221b00b006f3ef214e73sm3264386ejs.217.2022.05.20.09.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 09:09:17 -0700 (PDT)
Date:   Fri, 20 May 2022 19:09:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, patches@lists.linux.dev,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Juergen Borleis <jbe@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Mans Rullgard <mans@mansr.com>
Subject: Re: [PATCH v2] net: dsa: restrict SMSC_LAN9303_I2C kconfig
Message-ID: <20220520160916.jwpbi6y2uyqlbrwz@skbuf>
References: <20220520051523.10281-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520051523.10281-1-rdunlap@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 10:15:23PM -0700, Randy Dunlap wrote:
> Since kconfig 'select' does not follow dependency chains, if symbol KSA
> selects KSB, then KSA should also depend on the same symbols that KSB
> depends on, in order to prevent Kconfig warnings and possible build
> errors.
> 
> Change NET_DSA_SMSC_LAN9303_I2C and NET_DSA_SMSC_LAN9303_MDIO so that
> they are limited to VLAN_8021Q if the latter is enabled. This prevents
> the Kconfig warning:
> 
> WARNING: unmet direct dependencies detected for NET_DSA_SMSC_LAN9303
>   Depends on [m]: NETDEVICES [=y] && NET_DSA [=y] && (VLAN_8021Q [=m] || VLAN_8021Q [=m]=n)
>   Selected by [y]:
>   - NET_DSA_SMSC_LAN9303_I2C [=y] && NETDEVICES [=y] && NET_DSA [=y] && I2C [=y]
> 
> Fixes: 430065e26719 ("net: dsa: lan9303: add VLAN IDs to master device")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Vivien Didelot <vivien.didelot@gmail.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Juergen Borleis <jbe@pengutronix.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Mans Rullgard <mans@mansr.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
