Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2980A61FF77
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 21:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbiKGUWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 15:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbiKGUW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 15:22:29 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A265B1B;
        Mon,  7 Nov 2022 12:22:28 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id b2so33242428eja.6;
        Mon, 07 Nov 2022 12:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZWnUgY3H+f2hHbNpDyrd9y8lMZYq8JYfCbySIrmSMWA=;
        b=doCBwBhczp8/I2UwT7SYVdcEF9a9gIgnRlAGDDlRAdKCh4SHQV4TNvPrSaa5x0Sqry
         GkmgasqxjuMv2lP+WcYFIM5W9rY31ffQffH1CtwFIfHEYsz52iX0MRx67lMGKyaZH7ud
         oXFgbm6BZiKkLs8HzzfsWhFow9vRtq2PQmoRon+llUlMqQVIxAJLRCYfoJAty7W9bGQp
         bCPfQ5SaaTQ9qqzToD2sOdZ11ZWXoOtox3tGBZ0yW12LUcUzOYqYBJRbYx6ITWG3TCno
         ExEP+pTqTZj3jCbBDM3tPKqTNFjFrRrZaVgI0LKNMHABIATd7Ii453I6xTRfd7328Q1s
         vhaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZWnUgY3H+f2hHbNpDyrd9y8lMZYq8JYfCbySIrmSMWA=;
        b=zlqcjuUoaPTmcikBXzdMG0DzHdgzLSTuCEiD30FdMGauDvXFwanytjLEgxwSDB51W0
         sXEJsm3RGnaz0FGohECRatWSE/ERpG+GN5ZFk6iXmDvNgZ2W/inBuqissHBOOPKPDVlw
         DZbPiKDTk+c2n3uhCctdUdY7+GMzZ4hZEcVI4KGqbJteNFAQp/WUXKekult4oKHKx5lF
         st0YcRXTiPuan0ywyzQIyWv/RiU8KjdYdMK6ZFC41Uw/C+PTicOrZ+wdvo6g48KtZk11
         aM2Qzbf6T47xpmy1doE3CX43Kg0vxEyiDVLUpvxb4PZ5GCMN8vn+CaADjpFurBrcaHb1
         BB5A==
X-Gm-Message-State: ACrzQf3cWk4VcO+TQR8fTMIE4w2fJGDyPxpyd0be63MGl/O6cUtr/BG+
        +dxGTF3dAzlsOzWUpz/n3PM=
X-Google-Smtp-Source: AMsMyM7vmBCBiz9UcZbHfUkcznt3wshglyqBpTgsfylJlCW1wN5492RzoQkUcuAoYFCRE22b8mmyLw==
X-Received: by 2002:a17:907:6eab:b0:78d:4c16:a687 with SMTP id sh43-20020a1709076eab00b0078d4c16a687mr49567196ejc.392.1667852546809;
        Mon, 07 Nov 2022 12:22:26 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id v24-20020aa7d9d8000000b0045c3f6ad4c7sm4641188eds.62.2022.11.07.12.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 12:22:26 -0800 (PST)
Date:   Mon, 7 Nov 2022 22:22:23 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Saravana Kannan <saravanak@google.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 08/11] of: property: Add device link support
 for PCS
Message-ID: <20221107202223.ihdk4ubbqpro5w5y@skbuf>
References: <20221103210650.2325784-1-sean.anderson@seco.com>
 <20221103210650.2325784-9-sean.anderson@seco.com>
 <20221107201010.GA1525628-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107201010.GA1525628-robh@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 02:10:10PM -0600, Rob Herring wrote:
> On Thu, Nov 03, 2022 at 05:06:47PM -0400, Sean Anderson wrote:
> > This adds device link support for PCS devices. Both the recommended
> > pcs-handle and the deprecated pcsphy-handle properties are supported.
> > This should provide better probe ordering.
> > 
> > Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> > ---
> > 
> > (no changes since v1)
> > 
> >  drivers/of/property.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> 
> Seems like no dependency on the rest of the series, so I can take this 
> patch?

Is fw_devlink well-behaved these days, so as to not break (forever defer)
the probing of the device having the pcs-handle, if no driver probed on
the referenced PCS? Because the latter is what will happen if no one
picks up Sean's patches to probe PCS devices in the usual device model
way, I think.
