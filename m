Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39998432850
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 22:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbhJRUTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 16:19:16 -0400
Received: from mail-ot1-f51.google.com ([209.85.210.51]:38673 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233885AbhJRUTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 16:19:15 -0400
Received: by mail-ot1-f51.google.com with SMTP id l10-20020a056830154a00b00552b74d629aso10604otp.5;
        Mon, 18 Oct 2021 13:17:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+QTRqKsBwUF5QBlZ+P9EczvyYd3geHrWtPXQDM9mfYI=;
        b=Q/n3CmfAyFguXCuMuTEuu0MLzmQ2tSPMhJRPiyw7vRkJpOSFeBt2wS90My80L/nyXV
         lvf0uk074DL5yM/hq0+5qt6zY8Qkyf6wNmpplBRt5lmpbNAO2F5z/2vWE1t2hzzqMvAJ
         Ss/sZfntV63ZlFyGOujhWmXAyhrIHkJWA7nMvpPDlPeMUNPkOH5eVTe/l0rBicmw7Gji
         LvN0+hkrBXHofUZSh4JiyM+F2UWGfeZtsRu5zwYTu9JZzmFz6VHLLeaIbIoGEDUz/KkF
         TfQjup4Y5bBE0q9+hN01nib9qSgDHyeU8tYwRPtmI1GG01vEZHJ4Z4TWDK7Jy3fukV1R
         NFcA==
X-Gm-Message-State: AOAM531Mhl+t6xdApkHVNNCm2/42quHWW4R3UbCS2hJTgoTbh5Nq/Y8k
        I6bhHIGKIl7AcdbTBc0Vfg==
X-Google-Smtp-Source: ABdhPJzoFaCWZSoQ81hzprNoqlaJscw4R0IzU7j7FUXjQQhO/V5CH2tZckMs2IdJHpqCjkF8rOQhsQ==
X-Received: by 2002:a05:6830:236b:: with SMTP id r11mr1628636oth.145.1634588223651;
        Mon, 18 Oct 2021 13:17:03 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id c9sm3164562otn.77.2021.10.18.13.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 13:17:03 -0700 (PDT)
Received: (nullmailer pid 2883811 invoked by uid 1000);
        Mon, 18 Oct 2021 20:17:02 -0000
Date:   Mon, 18 Oct 2021 15:17:02 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Mark Greer <mgreer@animalcreek.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        None@robh.at.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-nfc@lists.01.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 6/8] dt-bindings: nfc: st,nci: convert to dtschema
Message-ID: <YW3WPkCP8MJr9jCy@robh.at.kernel.org>
References: <20211011073934.34340-1-krzysztof.kozlowski@canonical.com>
 <20211011073934.34340-7-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011073934.34340-7-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Oct 2021 09:39:32 +0200, Krzysztof Kozlowski wrote:
> Convert the ST NCI (ST21NFCB) NFC controller to DT schema format.
> 
> Changes during bindings conversion:
> 1. Add a new required "reg" property for SPI binding, because SPI child
>    devices use it as chip-select.
> 2. Drop the "clock-frequency" property during conversion because it is a
>    property of I2C bus controller, not I2C slave device.  It was also
>    never used by the driver.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  .../bindings/net/nfc/st,st-nci.yaml           | 106 ++++++++++++++++++
>  .../bindings/net/nfc/st-nci-i2c.txt           |  38 -------
>  .../bindings/net/nfc/st-nci-spi.txt           |  36 ------
>  3 files changed, 106 insertions(+), 74 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/st,st-nci.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/st-nci-i2c.txt
>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/st-nci-spi.txt
> 

Applied, thanks!
