Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC80B4B1B12
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 02:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346724AbiBKBQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 20:16:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343941AbiBKBQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 20:16:49 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D97510F8
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 17:16:49 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id e140so1339921ybh.9
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 17:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NoBN/hs/2js7cc0keXoXey2EA40Z2Ak6h4Qlf3Psfq8=;
        b=WhzmaJEbj6x+sLRtijNtfoRuDESPF2KBzPHcvxqS5/loA4Oiylf+d6T/LRAXmdIc/N
         L/7AshaYN8bXoJy1c8GO0hNEOkiOgCTT0e15zLhtsTS95SFVEhQg73Y2XbVloB87EE7F
         c1vVbyYQDPUmAkk5u3pBmLEUJlh69axpwyW1PQpVloCOw2UpI4qlf+z/aZBtyTHnOPQV
         CKX4IF2Iu8iwkhmxRkCZtIz4nwE8mrbdsNmWbUcfL3niNJkj8b1YTKeNMPyQ0QP/hxwz
         0CVtjT5Y/7Z0GkoDERsgE4jVvl0hrvby86SceBtV55DFH8WYib0PcjftWD2JN9KJtdnW
         QdWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NoBN/hs/2js7cc0keXoXey2EA40Z2Ak6h4Qlf3Psfq8=;
        b=GjqEmWIVDP/iXEDSAQV+zTWiX3UISAzKOdgfd3YAt95/ZHJxgzx5ip4+TukvXyg+La
         wD/oIfm9yutTp2TI7oIDQ2e0lkIMw9XJT9nITxPiJ+UGJoHp6nd/CeM7/ZhGi2vuYEow
         rEyUfNx7i4W9Q3bXIwNWNMUnPlfIqTsrWddFvhswXos7/ns3AXjf9ZdmrXFkZiPhfBNh
         9eIvRrCwXmCssnX3HUFLjl0CPWALlfCpvv+PKkJViaxoOD6KUWOAr9d9Xo3JnNeQV44o
         BwfLwnq7EuZnPHOxB12mG/AOwAlSvNodkNySUdVFhNrwxKBkSwft/FiQV+mR8i275d7I
         qOFA==
X-Gm-Message-State: AOAM53123VnX/3WRDNBVrDmGV/Mq+LtXWA8SYglSYL3Xpx+p+VbnIOWg
        hQgPhpjfFdufDrXwt8ghOLlUYsjEzCvtd73gAZQTAg==
X-Google-Smtp-Source: ABdhPJzIYhJqQdxxwp0/1AjUJREgCWcUxi6xhSmlMBiKgtTzS8OM/ptmouxwZvHg2tfkzmCMautueSZh574KfrLq2jY=
X-Received: by 2002:a81:b624:: with SMTP id u36mr10672163ywh.437.1644542208736;
 Thu, 10 Feb 2022 17:16:48 -0800 (PST)
MIME-Version: 1.0
References: <20220209184116.18094-1-luizluca@gmail.com>
In-Reply-To: <20220209184116.18094-1-luizluca@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 11 Feb 2022 02:16:37 +0100
Message-ID: <CACRpkdZ8jBOxxdM62Z1wCtE5UKik+G28o8jfMfvj9g3dbfs=dg@mail.gmail.com>
Subject: Re: [PATCH v2] dt-bindings: net: dsa: realtek: convert to YAML
 schema, add MDIO
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 9, 2022 at 7:42 PM Luiz Angelo Daros de Luca
<luizluca@gmail.com> wrote:

> Schema changes:
>
> - support for mdio-connected switches (mdio driver), recognized by
>   checking the presence of property "reg"
> - new compatible strings for rtl8367s and rtl8367rb
> - "interrupt-controller" was not added as a required property. It might
>   still work polling the ports when missing.
>
> Examples changes:
>
> - renamed "switch_intc" to make it unique between examples
> - removed "dsa-mdio" from mdio compatible property
> - renamed phy@0 to ethernet-phy@0 (not tested with real HW)
>   phy@ requires #phy-cells
>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

THANKS for doing this!

Yours,
Linus Walleij
