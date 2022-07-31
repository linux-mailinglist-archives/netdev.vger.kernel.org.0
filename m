Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18524585FB1
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 18:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiGaQCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 12:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237471AbiGaQCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 12:02:47 -0400
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C421FD06;
        Sun, 31 Jul 2022 09:02:46 -0700 (PDT)
Received: by mail-il1-f178.google.com with SMTP id j20so3025949ila.6;
        Sun, 31 Jul 2022 09:02:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:references:in-reply-to:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=Yq7IbsWb6KGMKaLqYMBkrgh9qZVrTfcDeSB4X4YswxE=;
        b=DESqx0VFhfjV99BEzXS4wn3MlhP1FqBKKAs8tm3KOsOPaEO9Z+JDvv/DZEc4BF8a97
         ak4gZ4YEdWpo4bMnKyFVSUqIvJNb3jPk6IK6UUoE+dI97ZcHnf9Vo3veb5UcDb1WujuX
         mttQwDwtgqPzkmNOMiNE3JPdwGkvJDafupikUAxFT5bfhj3/3+AiOT8e6BXu16ay/4/D
         vlcF3Ndt4Qc25hK8LxLnVrZi6OB+O+9QtoXnGE95pgDRJVmp5u2vdx6DyuXBPxIzU0qq
         gKVWA56T55xS05P8SJSGU6yCXxLxuEZMa8Dgkh8tO05mNQ6dOMXRnCWtk6TimX1fn97R
         cOeg==
X-Gm-Message-State: AJIora/IU0m5wXDSZxm5cszyx53cTzepf1x3AIunGaLX10lz80SP9lVJ
        1KBQotk3/C4lBas+3LOc4/eMisvVCw==
X-Google-Smtp-Source: AGRyM1s+ueUdhvIOJSejGa9xW8hJwCQnq39jrQwJI44xF3l1OTLOhZUlqkBkEWz7m7XcKWQVUFVkUg==
X-Received: by 2002:a92:6f0a:0:b0:2d9:24b5:9401 with SMTP id k10-20020a926f0a000000b002d924b59401mr4454365ilc.89.1659283365495;
        Sun, 31 Jul 2022 09:02:45 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id m3-20020a924a03000000b002de2b639101sm2891012ilf.4.2022.07.31.09.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jul 2022 09:02:44 -0700 (PDT)
Received: (nullmailer pid 3380586 invoked by uid 1000);
        Sun, 31 Jul 2022 16:02:39 -0000
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     John Crispin <john@phrozen.org>, Jakub Kicinski <kuba@kernel.org>,
        UNGLinuxDriver@microchip.com,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        devicetree@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Mans Rullgard <mans@mansr.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Kurt Kanzenbach <kurt@linutronix.de>
In-Reply-To: <20220731150006.2841795-1-vladimir.oltean@nxp.com>
References: <20220731150006.2841795-1-vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] dt-bindings: net: dsa: make phylink bindings required for CPU/DSA ports
Date:   Sun, 31 Jul 2022 10:02:39 -0600
Message-Id: <1659283359.435016.3380585.nullmailer@robh.at.kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 31 Jul 2022 18:00:06 +0300, Vladimir Oltean wrote:
> It is desirable that new DSA drivers are written to expect that all
> their ports register with phylink, and not rely on the DSA core's
> workarounds to skip this process.
> 
> To that end, DSA is being changed to warn existing drivers when such DT
> blobs are in use:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220729132119.1191227-1-vladimir.oltean@nxp.com/
> 
> Introduce another layer of validation in the DSA DT schema, and assert
> that CPU and DSA ports must have phylink-related properties present.
> 
> Suggested-by: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> I've sent this patch separately because at least right now I don't have
> a reason to resend the other 4 patches linked above, and this has no
> dependency on those.
> 
>  .../devicetree/bindings/net/dsa/dsa-port.yaml | 22 +++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/net/dsa/dsa-port.yaml:91:3: [warning] wrong indentation: expected 4 but found 2 (indentation)
./Documentation/devicetree/bindings/net/dsa/dsa-port.yaml:92:5: [warning] wrong indentation: expected 6 but found 4 (indentation)
./Documentation/devicetree/bindings/net/dsa/dsa-port.yaml:94:5: [warning] wrong indentation: expected 6 but found 4 (indentation)
./Documentation/devicetree/bindings/net/dsa/dsa-port.yaml:95:7: [warning] wrong indentation: expected 8 but found 6 (indentation)
./Documentation/devicetree/bindings/net/dsa/dsa-port.yaml:97:7: [warning] wrong indentation: expected 8 but found 6 (indentation)
./Documentation/devicetree/bindings/net/dsa/dsa-port.yaml:99:7: [warning] wrong indentation: expected 8 but found 6 (indentation)

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.example.dtb: switch@8: ethernet-ports:ethernet-port@3: 'phy-mode' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.example.dtb: switch@8: Unevaluated properties are not allowed ('ethernet-ports' was unexpected)
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.example.dtb: switch@ff240000: ethernet-ports:port@0: 'phy-mode' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.example.dtb: switch@ff240000: ethernet-ports:port@0: 'oneOf' conditional failed, one must be fixed:
	'fixed-link' is a required property
	'phy-handle' is a required property
	'managed' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.example.dtb: switch@ff240000: Unevaluated properties are not allowed ('dsa,member', 'ethernet-ports' were unexpected)
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/brcm,b53.example.dtb: switch@36000: ethernet-ports:port@8: 'phy-mode' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/brcm,b53.example.dtb: switch@36000: Unevaluated properties are not allowed ('ethernet-ports' was unexpected)
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/microchip,ksz.example.dtb: switch@0: ethernet-ports:port@5: 'phy-mode' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/microchip,ksz.example.dtb: switch@0: Unevaluated properties are not allowed ('ethernet-ports' was unexpected)
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/microchip,ksz.example.dtb: switch@1: ethernet-ports:port@6: 'phy-mode' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/microchip,ksz.example.dtb: switch@1: Unevaluated properties are not allowed ('ethernet-ports' was unexpected)
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

