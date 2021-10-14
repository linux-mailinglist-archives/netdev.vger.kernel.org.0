Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF8B42DBA1
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbhJNOdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:33:13 -0400
Received: from mail-ot1-f48.google.com ([209.85.210.48]:36834 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbhJNOdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 10:33:11 -0400
Received: by mail-ot1-f48.google.com with SMTP id p6-20020a9d7446000000b0054e6bb223f3so8504224otk.3;
        Thu, 14 Oct 2021 07:31:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=DIK3JlJ2bJ0du5PT7KO43mUV3V2btTbFFXy8E8ul2KA=;
        b=elc7e5ElTtNxi976oFg92xvtNo1kv3i98iaUJYqtVhBsPoJItHrLFPOkPYdEHsGVBZ
         267sGgf8k433P/K0ooZXPqGVzFCcwVPcWoXFVgGu3WrgiMFuyZjWlL8fq7VL0lYtgSUV
         aK0579rNgHBIH/fLnv909De3AHjR35aM0tD+AfGHUYCZxO6fa424DA54afd6QQLy93eA
         8Mf9JSNIdEvl9suoEPMNy/Hz+rvTesRuKscYdwvv+nNSP/JQ3UR+kTq8MO5nVd66Va7z
         YFHSwYW96hG6WNu56j702OKiwnHMxuJsbLUNLoGuZpw4cHMOZwWL1FgSGcS5GF6qUvNI
         UcnQ==
X-Gm-Message-State: AOAM531LWrIxz1K5gxjtYc1FAFjGhWYxme7/WVig1Cat7DniS5NXdMz7
        aZLKNf8t6j53+00F9pws4w==
X-Google-Smtp-Source: ABdhPJyHytxarfX7/zX2hA7gK8CZmnmZShlDHqNBGtLn5OQ1682QHnABXJKOMT99anGKWPL1DaT5IQ==
X-Received: by 2002:a9d:7b48:: with SMTP id f8mr2828575oto.112.1634221865888;
        Thu, 14 Oct 2021 07:31:05 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id u15sm503178oon.35.2021.10.14.07.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 07:31:05 -0700 (PDT)
Received: (nullmailer pid 3295872 invoked by uid 1000);
        Thu, 14 Oct 2021 14:31:04 -0000
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Shawn Guo <shawnguo@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20211013222313.3767605-6-vladimir.oltean@nxp.com>
References: <20211013222313.3767605-1-vladimir.oltean@nxp.com> <20211013222313.3767605-6-vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 5/6] dt-bindings: net: dsa: sja1105: add {rx,tx}-internal-delay-ps
Date:   Thu, 14 Oct 2021 09:31:04 -0500
Message-Id: <1634221864.138006.3295871.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Oct 2021 01:23:12 +0300, Vladimir Oltean wrote:
> Add a schema validator to nxp,sja1105.yaml and to dsa.yaml for explicit
> MAC-level RGMII delays. These properties must be per port and must be
> present only for a phy-mode that represents RGMII.
> 
> We tell dsa.yaml that these port properties might be present, we also
> define their valid values for SJA1105. We create a common definition for
> the RX and TX valid range, since it's quite a mouthful.
> 
> We also modify the example to include the explicit RGMII delay properties.
> On the fixed-link ports (in the example, port 4), having these explicit
> delays is actually mandatory, since with the new behavior, the driver
> shouts that it is interpreting what delays to apply based on phy-mode.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  .../devicetree/bindings/net/dsa/dsa.yaml      |  4 ++
>  .../bindings/net/dsa/nxp,sja1105.yaml         | 42 +++++++++++++++++++
>  2 files changed, 46 insertions(+)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml:82:9: [warning] wrong indentation: expected 10 but found 8 (indentation)
./Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml:84:17: [warning] wrong indentation: expected 14 but found 16 (indentation)
./Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml:85:21: [warning] wrong indentation: expected 18 but found 20 (indentation)
./Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml:86:25: [warning] wrong indentation: expected 22 but found 24 (indentation)
./Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml:93:17: [warning] wrong indentation: expected 14 but found 16 (indentation)
./Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml:94:21: [warning] wrong indentation: expected 18 but found 20 (indentation)
./Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml:96:21: [warning] wrong indentation: expected 18 but found 20 (indentation)
./Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml:103:5: [warning] wrong indentation: expected 2 but found 4 (indentation)
./Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml:104:9: [warning] wrong indentation: expected 6 but found 8 (indentation)
./Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml:105:13: [warning] wrong indentation: expected 10 but found 12 (indentation)
./Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml:109:13: [warning] wrong indentation: expected 10 but found 12 (indentation)
./Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml:110:13: [warning] wrong indentation: expected 13 but found 12 (indentation)
./Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml:111:13: [warning] wrong indentation: expected 13 but found 12 (indentation)

dtschema/dtc warnings/errors:

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1540707

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

