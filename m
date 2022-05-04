Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC5451ADBE
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 21:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353205AbiEDT3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 15:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343627AbiEDT3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 15:29:49 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23164A3C5;
        Wed,  4 May 2022 12:26:12 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id y21so2834716edo.2;
        Wed, 04 May 2022 12:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U4ugFnEHiQMZfrDXCj3ch+k+wAUwvH2FEn+27B1gMn8=;
        b=b3IHFNU5vyS3CmCibqe8vz7MofuxGI2zN9F6/a91ENRH1Htd7thQmbLBLOEY7Ks4SI
         /cV8G7CfQwdkOl46mzL6a7KKRYD9T5cRdSKL1ABALGWARV3jJp7DtBOUYjFbrZIF241D
         fpNgsJsWhTfuhBmIovBY5a/pkIBv3BZvGrJcW0MPGJRF4dCwgbsh+a/rRE7zD1NQB5y8
         gf8CbZ37kbvhxvVE9LSiBBjltSu4ZaW4kfYXj5S0pyMgmYu0RoFcXPwYnGdiCf6WgLq3
         TSQkyURrqx/M3vcg9hbyf8O2HtEiBb9z6ZZqs47i1dP2OzujDM8xaN3yLxeTbbXJWzAU
         H8oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U4ugFnEHiQMZfrDXCj3ch+k+wAUwvH2FEn+27B1gMn8=;
        b=O8gtTvqYqMJo8FsoVDTIJIt/+Wm/WoqMGITMo+b9dYi2QfQYIxC+qAVEcwKQiDON9d
         k++6Yk6X5LjP+2aaoxrhBcUrgoSPo/1MGE3lBuyVNh8psXzK9fR2tMgV4nN+6f83rcnO
         aBvd8pK3JzKT5jBxD3DCyk7pw16CoReFa73WX6qKeamBoJaSoovc10UVabQb0lgEvtAN
         dJDZUIbzVWtExboFMrUlQlDQIbVOgXtcIj1Pw1/jj23sS46JtEKgjx8v1gL95oF2c1DJ
         g1bHRZTsuNquocKPmWKhVdbwPVccarXNJx+egVDrwPaeRbNTO/DlM9PJN0uEvW5RbIIu
         zEYQ==
X-Gm-Message-State: AOAM533Gyiw45DKxRIyyrUCysC3UJQHNo8SIb7KYSzRnd/Hysw+d0kGs
        fSmikswQhD75U4pHqzvbjT4=
X-Google-Smtp-Source: ABdhPJzNYhVKyEWXU83EQ5Wc+8d0ouLMc/N3EANkkzqM3BU/cf3RUZlUmzDzUR2yIzUYxjD95PgmYQ==
X-Received: by 2002:aa7:dc0e:0:b0:426:af42:6a06 with SMTP id b14-20020aa7dc0e000000b00426af426a06mr24800545edu.307.1651692371247;
        Wed, 04 May 2022 12:26:11 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id gv23-20020a1709072bd700b006f3ef214e41sm6015940ejc.167.2022.05.04.12.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 12:26:10 -0700 (PDT)
Date:   Wed, 4 May 2022 22:26:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [Patch net-next v13 05/13] net: dsa: microchip: add DSA support
 for microchip LAN937x
Message-ID: <20220504192609.p6bkyghvdluauwag@skbuf>
References: <20220504151755.11737-1-arun.ramadoss@microchip.com>
 <20220504151755.11737-6-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504151755.11737-6-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 08:47:47PM +0530, Arun Ramadoss wrote:
> Basic DSA driver support for lan937x and the device will be
> configured through SPI interface.
> 
> drivers/net/dsa/microchip/ path is already part of MAINTAINERS &
> the new files come under this path. Hence no update needed to the
> MAINTAINERS
> 
> Reused KSZ APIs for port_bridge_join() & port_bridge_leave() and
> added support for port_stp_state_set().
> 
> RGMII internal delay values for the mac is retrieved from
> rx-internal-delay-ps & tx-internal-delay-ps as per the feedback from
> v3 patch series.
> https://lore.kernel.org/netdev/20210802121550.gqgbipqdvp5x76ii@skbuf/
> 
> It supports standard delay 2ns only. If the property is not found, the
> value will be forced to 0.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
