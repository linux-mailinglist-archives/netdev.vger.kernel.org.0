Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3833C51C0D8
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379967AbiEENhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379808AbiEENgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:36:51 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39B05710F;
        Thu,  5 May 2022 06:33:11 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id d6so5210242ede.8;
        Thu, 05 May 2022 06:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=YBh4fSQX1SjtAOeTQBT6qh7xXgQX0hrw/vPZrDk8kl0=;
        b=QVQdBUAr2fBR6TDsf/0Bgl+n2gsTKYcI99p8ef08EPIV+jTaXpUuMrzeItEXdo0Z0t
         12MOwc14Q/vjwr1gUBSm/ifm5ZF38S/Hz8bZtibKyE8EOAKBA98qPHlEZU+Wl2OrsWHz
         p+7EWpDGfQTPRS5JtfEi62gUygDtUScamZ7WRxTgJq97XLCcvN3RuJZUroJsBT5C/bbV
         +XFoFBrvY5pESG3GsfRlGUdlcPm3RfWrknBTAvAGo/cxEK1tafk52xKtluBcFKvOt+sh
         aOBWWpicZ3yIJZvAp6ISeiVblFpLgp6B37zcEqhrC5l6C3Kr+SO2EJoFx2RJnI639F61
         JKPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=YBh4fSQX1SjtAOeTQBT6qh7xXgQX0hrw/vPZrDk8kl0=;
        b=ZdY+OH1y4HJFhaxrmiNB6WiA74h404HZ5XuWUe5IHgy5rQtn0rXamisLNeUrZ+eikA
         90U20bM6pOJ4F82WwJuoxOscc91V3UbvHH37XGvXKdUIkIXoUadK9FPxmm+h1XRpg3f+
         RWQ81UtCtEp7+Ogg4YKgGz2qtoZTjy7E4LEQ79Mc+eOH9rj5itjZroaDqVNCKjv+iLUi
         fdgQrUzl3st/wAM4NCzsjke2ZqNBBw0DSJr9iNWc9Y+m1Z9g9BdxQQq6+fhpOaQb8iPD
         ZR0n98Qrfw6Cp8lDXD5WzQoHV4CwM6zZvXe8xw4j552nxM0PIsuXP0BzhcHJjkwOGD+N
         smFg==
X-Gm-Message-State: AOAM530wcJlbMQeIPPx38XWPoTLcU3OCvTzjIrv3fvwPKiezdldMicYs
        MYtv7dTVXyoPNdw60i3rqKE=
X-Google-Smtp-Source: ABdhPJyti2fzgy7lBZwv9hr5ITrughg8szQhWL+aoHoF5bRcpehFlY8kR4rXVtXHxFsTI13ub54YYg==
X-Received: by 2002:a05:6402:42c8:b0:427:d087:29 with SMTP id i8-20020a05640242c800b00427d0870029mr19637136edc.53.1651757590119;
        Thu, 05 May 2022 06:33:10 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id el22-20020a170907285600b006f3ef214e1dsm756920ejc.131.2022.05.05.06.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 06:33:09 -0700 (PDT)
Message-ID: <6273d215.1c69fb81.b7a4a.4478@mx.google.com>
X-Google-Original-Message-ID: <YnPSE5dM6YanWt9T@Ansuel-xps.>
Date:   Thu, 5 May 2022 15:33:07 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v6 10/11] net: dsa: qca8k: add LEDs support
References: <20220503151633.18760-1-ansuelsmth@gmail.com>
 <20220503151633.18760-11-ansuelsmth@gmail.com>
 <YnMujjDHD5M9UdH0@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnMujjDHD5M9UdH0@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 03:55:26AM +0200, Andrew Lunn wrote:
> > +		ret = fwnode_property_read_string(led, "default-state", &state);
> 
> You should probably use led_default_state led_init_default_state_get()
> 
>     Andrew

Oh, didn't know it was a thing, is this new? Anyway thanks.

-- 
	Ansuel
