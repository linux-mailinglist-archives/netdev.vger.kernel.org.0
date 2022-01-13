Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B3F48DBC4
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 17:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236682AbiAMQ3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 11:29:39 -0500
Received: from mail-ot1-f41.google.com ([209.85.210.41]:34807 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236675AbiAMQ3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 11:29:38 -0500
Received: by mail-ot1-f41.google.com with SMTP id m8-20020a9d4c88000000b00592bae7944bso3677590otf.1;
        Thu, 13 Jan 2022 08:29:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=FfTUA1KU03ihyLDr4QVv1wu6ZMXWlYbNR+Fc01A/CSI=;
        b=zX54qrq0HHo68KaNbEXZu5VCCBRKsJoEK86uvUPPHgPcxhls0O+AIm2RtNDkdPfX3f
         t0nnPHZgCDuxUw5wqaP3d3tfTvM6tltw378EiEukjhRcQTWHUV36n4ZbFk/eMGyFxdmW
         i5lBFq6T31KkvbGg009W1D+pw8W++Pg0OVjKqGWuetuuQf6o5irNkeMOeUaJMY9FLgFa
         NwTK/USqeJ1wgqPwlx1aJvgPLcs26FJVNDhc+wKjonTQB2+pyF911Xvm3txCF9vkEEQs
         15oFtrm+oVBlfgEWhumhe3Kv8iEq/1BhiyX2o4AZpK0uo5DySPAJ+f1SInet8MqOsqKy
         Zpgw==
X-Gm-Message-State: AOAM532kJ4a2p5a3L9lcx+zvLx+2/gvkw5kNt8ZpTQkbm+i7MuyxjmSp
        i7iGHxcLWGW9+xlgk6QbHpec2ECu/g==
X-Google-Smtp-Source: ABdhPJy9L40U/ZtKmKlqocpouZSmrB8ql0DG0YsqA2zf91UqCHDFjbH1bW5G2LCfIEpgEpNeAzLD8w==
X-Received: by 2002:a05:6830:149a:: with SMTP id s26mr3524165otq.23.1642091377692;
        Thu, 13 Jan 2022 08:29:37 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id n26sm634762ooc.48.2022.01.13.08.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 08:29:36 -0800 (PST)
Received: (nullmailer pid 3647187 invoked by uid 1000);
        Thu, 13 Jan 2022 16:29:34 -0000
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn?= <kabel@kernel.org>
Cc:     linux-phy@lists.infradead.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>
In-Reply-To: <20220112181602.13661-1-kabel@kernel.org>
References: <20220112181602.13661-1-kabel@kernel.org>
Subject: Re: [PATCH devicetree v2] dt-bindings: phy: Add `tx-p2p-microvolt` property binding
Date:   Thu, 13 Jan 2022 10:29:34 -0600
Message-Id: <1642091374.247178.3647186.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jan 2022 19:16:02 +0100, Marek Behún wrote:
> Common PHYs and network PCSes often have the possibility to specify
> peak-to-peak voltage on the differential pair - the default voltage
> sometimes needs to be changed for a particular board.
> 
> Add properties `tx-p2p-microvolt` and `tx-p2p-microvolt-names` for this
> purpose. The second property is needed to specify the mode for the
> corresponding voltage in the `tx-p2p-microvolt` property, if the voltage
> is to be used only for speficic mode. More voltage-mode pairs can be
> specified.
> 
> Example usage with only one voltage (it will be used for all supported
> PHY modes, the `tx-p2p-microvolt-names` property is not needed in this
> case):
> 
>   tx-p2p-microvolt = <915000>;
> 
> Example usage with voltages for multiple modes:
> 
>   tx-p2p-microvolt = <915000>, <1100000>, <1200000>;
>   tx-p2p-microvolt-names = "2500base-x", "usb", "pcie";
> 
> Add these properties into a separate file phy/transmit-amplitude.yaml,
> selecting it for validation if either of the `tx-p2p-microvolt`,
> `tx-p2p-microvolt-names` properties is set for a node.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  .../bindings/phy/transmit-amplitude.yaml      | 110 ++++++++++++++++++
>  1 file changed, 110 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/transmit-amplitude.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/phy/transmit-amplitude.yaml:98:7: [warning] wrong indentation: expected 8 but found 6 (indentation)
./Documentation/devicetree/bindings/phy/transmit-amplitude.yaml:100:7: [warning] wrong indentation: expected 8 but found 6 (indentation)

dtschema/dtc warnings/errors:

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1579281

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

