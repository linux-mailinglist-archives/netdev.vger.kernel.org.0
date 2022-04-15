Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92193502662
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 09:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351217AbiDOHvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 03:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbiDOHvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 03:51:22 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E20A1465;
        Fri, 15 Apr 2022 00:48:54 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id k62so682343pgd.2;
        Fri, 15 Apr 2022 00:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ojb7v3RWfPmTpcy1XYxej8SBWhny6YXG14sLiPEtEs4=;
        b=Y/tE9xzMFlHIGfuq7ZusEiu+m3bxcTOwYGI+fGLyNYe1zZtoYOYuhg50+bCRILMeBz
         G7Js2/5cqHzuyDM1htxWJVZtEDhrgsViXUgEhJb673jax5+6vA5/DzcXN7/IrUUBRjMV
         NCNDeqU0YbKo5qghlfwYBaDmvQbqc4VS3a04ersEwCo9/2ijImTuifVrI29Ojv90yaMy
         nvLUVHMJr+gZIzwrqzI0e9zEI60FGgYYC2+xJtdzU2JSp6CwjK4dkM1LYR8juNqCInkZ
         pawmzq8Jggv9ebiaOFaZUZgVYYsodnBMpt5jLOxm/wl/DMDYVkXwyLP8cNSH2Ny2TTHo
         aw0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ojb7v3RWfPmTpcy1XYxej8SBWhny6YXG14sLiPEtEs4=;
        b=n7dUAvHS/c7VICcfBycm/KzBkseX2LFaPY2BBbgP+yvqR5mZpVvx8eq1lYgzSRoO3S
         iLBR0i1ClB8lg+L+l9Ud2IHZKSac648mrrQPLuP1uzxXUE0leTy0sMysWu7EBAKjaWIg
         RopTsa0R/wDCd7DwREgVzoIuDexxYQhTAIT5JNA/EPwRPJ3BTPuBs88IwtDo5cIcOk5s
         vqZzk+XCJnriQ71AYticYvwX3fe1fjOAw0NY72sA8VfrESy6UDThumQ/HlEyjY4b+l/5
         6wgcsusGIhTjob2A0G+VvCrdGqbMpF07GrhtRxLlbgViGkkSnnYa0wrJDNyj3szSXMU7
         6/wg==
X-Gm-Message-State: AOAM533pRRx4hDB3GGGXE22FDn2KSOIU6z6hEeWYeVxNvunUhTp3w+vb
        8ER7dXGHo+CiqBF0nFQBpoPjPDO46RAgWSMB/DEV1SsUXmI=
X-Google-Smtp-Source: ABdhPJywl7yjw4I3QpEFEiONA2lIr6XXfv2kw6vi8Mqe8QZ7ESn2e4Oxf+oNppBVTiUGtyvpEBdcP0VRQLuerJPzvX8=
X-Received: by 2002:a63:7c42:0:b0:39c:c333:b3d4 with SMTP id
 l2-20020a637c42000000b0039cc333b3d4mr5442556pgn.456.1650008933574; Fri, 15
 Apr 2022 00:48:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220411210406.21404-1-luizluca@gmail.com> <20220412105018.gjrswtwrgjyndev4@bang-olufsen.dk>
 <CAJq09z53MZ6g=+tfwRU-N5BV5GcPSB5n0=+zj-cXOegMrq6g=A@mail.gmail.com>
 <20220414014527.gex5tlufyj4hm5di@bang-olufsen.dk> <CAJq09z6KSQS+oGFw5ZXRcSH5nQ3zongn4Owu0hCjO=RZZmHf+w@mail.gmail.com>
 <20220414113718.ofhgzhsmvyuxd2l2@bang-olufsen.dk> <YlgmG3mLlRKef+sy@lunn.ch>
In-Reply-To: <YlgmG3mLlRKef+sy@lunn.ch>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 15 Apr 2022 04:48:42 -0300
Message-ID: <CAJq09z5hG7VkhkxdhVTUvA-dMJr6_ajkHYBZ6N2ROFXLz0gijQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for RTL8367RB-VB
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tobias@waldekranz.com" <tobias@waldekranz.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
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

> > > Is it too late to get rid of all those compatible strings from
> > > dt-bindings? And rtl8367s from the driver?
> > > We must add all supported devices to the doc as well, similar to mv88e6085.
> >
> > You can always try! I'm OK with those things in principle, but others might
> > object due to ABI reasons.
>
> Anything which is in a released Linus kernel is ABI and cannot be
> removed. Anything in net-next, or an -rcX kernel can still be changed.

rtl8367s was added for 5.18. I'll prepare a patch for net to remove it.

Now, about dt-bindings, I don't know what is the best approach. As
device-tree should not focus on Linux, it is strange to use a
compatible "rtl8365mb" just because it is the Linux subdriver name and
that name was just because it was the first device supported. Also,
once published, it is not good to break it.

Just to illustrate it better, these are the chip versions rtl8365mb.c
already supports or could support:
- rtl8363nb (not in dt)
- rtl8363nb-vb (not in dt)
- rtl8363sc (not in dt)
- rtl8363sc-vb (not in dt)
- rtl8364nb (not in dt)
- rtl8364nb-vb (not in dt)
- rtl8365mb (the first supported by rtl8365mb.c, maybe it should be
realtek,rtl8365mb-vc as rtl8365mb and rtl8365mb-vb seems to exist and
they might be incompatible)
- rtl8366sc (not in dt)
- rtl8367rb-vb (not in dt)
- rtl8367s (in dt and referenced in the code. The one I'll remove from code)
- rtl8367sb (new)
- rtl8370mb (new)
- rtl8310sr (new)

and these are the ones referenced in rtl8366rb.c code:
- rtl8366rb (rtl8366rb.c)
- rtl8366s (removed from rtl8366rb.c recently)

but I know nothing about unsupported chip versions. These "models" are
referenced in the bindings but some of them are not really a chip,
like rtl8367 and rtl8367b:
- rtl8366 (??)
- rtl8367 (??)
- rtl8367b (??)
- rtl8367rb (??)
- rtl8368s (??)
- rtl8369 (??)
- rtl8370 (??)

Anyway, I'm planning on submitting something like this:

--- a/Documentation/devicetree/bindings/net/dsa/realtek.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
@@ -31,28 +31,14 @@ properties:
  compatible:
    enum:
      - realtek,rtl8365mb
-      - realtek,rtl8366
      - realtek,rtl8366rb
-      - realtek,rtl8366s
-      - realtek,rtl8367
-      - realtek,rtl8367b
-      - realtek,rtl8367rb
-      - realtek,rtl8367s
-      - realtek,rtl8368s
-      - realtek,rtl8369
-      - realtek,rtl8370
    description: |
-      realtek,rtl8365mb: 4+1 ports
-      realtek,rtl8366: 5+1 ports
-      realtek,rtl8366rb: 5+1 ports
-      realtek,rtl8366s: 5+1 ports
-      realtek,rtl8367:
-      realtek,rtl8367b:
-      realtek,rtl8367rb: 5+2 ports
-      realtek,rtl8367s: 5+2 ports
-      realtek,rtl8368s: 8 ports
-      realtek,rtl8369: 8+1 ports
-      realtek,rtl8370: 8+2 ports
+      realtek,rtl8365mb:
+        Use with models RTL8363NB, RTL8363NB-VB, RTL8363SC, RTL8363SC-VB,
+        RTL8364NB, RTL8364NB-VB, RTL8365MB, RTL8366SC, RTL8367RB-VB, RTL8367S,
+        RTL8367SB, RTL8370MB, RTL8310SR
+      realtek,rtl8367rb:
+        Use with models RTL8366RB, RTL8366S

  mdc-gpios:
    description: GPIO line for the MDC clock line.
