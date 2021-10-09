Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A52427C5A
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 19:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhJIRW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 13:22:57 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:49586
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231904AbhJIRWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 13:22:54 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B0A543FFD9
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 17:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633800056;
        bh=kL5onibrdbpTWmZcYTtwUGQkos1VrIQlfQOfi9rMBeo=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=tWwRsWSWTGQVVHm1S/UHgAMw8wNyY+pKURh7w3nBIxJ/+qROYaNFzZ/+u4Hz/rTn6
         ezNEAE3jykIHtEs7v7VohX01/WsrNfnseFv1Cx2tIWcp+0FpyqFYG0G51+fPOdJFrR
         ezMrCQmDXLZ7bt6UeBgHlwq/yVjJQjwUJD7iYVBdwa3pFlFE2Oc8USG8Lk0Hh0mzRc
         hYvdcOxl0MsHGAk66+BeAM1/RH0KRvauOkQkU4H1zoAHO9b7Kl11lUHmxF9rYkPf+a
         57ABPHy5YZvlr9eiW0rzwbTsZXNHkDE2ftugnO+hJzPRaofVXWG/CHGl2p6UCW63vG
         kU4j9ccqiuj6A==
Received: by mail-ed1-f71.google.com with SMTP id p20-20020a50cd94000000b003db23619472so11951925edi.19
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 10:20:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kL5onibrdbpTWmZcYTtwUGQkos1VrIQlfQOfi9rMBeo=;
        b=K0wh6az6cRwjmWd2FOjRKae7kpkbnyIZ3rso/zSROH4qrRSCy4nZYXkoVyFsYSTOXK
         xsZJZRWKlpz+k0bqspB6j14/Xg24QxfJzFsumEa1qeUKFRPMZ9fBoB0WWRhlX6/BSo+p
         IlG4BQyg/itHuzFzjFNgpyPadBOEgrRy2c+FkBa3P2WhfS7BMQAxy6L50npLeG3KARE2
         41ygz5zcK1oYXD7s9/6L3hCmnB/grmfxC8Zaq7x9BVorb/SECMqrjkQn23+6aOPH0Y1p
         Q9cxOT6nl+03cWh7+FGvPBCTQkeXWVXFFcWFowy/uA+TxPGrAMTaw7kWfpz2MGClOgaU
         cg/A==
X-Gm-Message-State: AOAM5334gXjf9i9FF3a78TTJt93Con5oD2e2lOPfZBsxAO5TVEetmUuT
        NdK79qQbwP7tsuaimiHU5T1a53VaK/2CadsFJtY1oHTTYXL8PfBs0jz+47iEH6So80Z2Lc/sud2
        Lz8HNWNWs3Bn2EcK0Na2rP72tW2uq3kZpwQ==
X-Received: by 2002:a05:6402:270b:: with SMTP id y11mr18888062edd.387.1633800056456;
        Sat, 09 Oct 2021 10:20:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpQpfv74csrtSy6KUNxlPMuDmjg00caC1cHGJ+WK/WStFDQ1Er51zX/DIqVocH4mB+/nMy6w==
X-Received: by 2002:a05:6402:270b:: with SMTP id y11mr18888050edd.387.1633800056330;
        Sat, 09 Oct 2021 10:20:56 -0700 (PDT)
Received: from [192.168.0.20] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id u23sm1238626edq.36.2021.10.09.10.20.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Oct 2021 10:20:55 -0700 (PDT)
Subject: Re: [PATCH v3] dt-bindings: net: nfc: nxp,pn544: Convert txt bindings
 to yaml
To:     David Heidelberg <david@ixit.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ~okias/devicetree@lists.sr.ht
References: <20211009161941.41634-1-david@ixit.cz>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <192edb2d-837d-12ac-bb95-e38c8fd20381@canonical.com>
Date:   Sat, 9 Oct 2021 19:20:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211009161941.41634-1-david@ixit.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/10/2021 18:19, David Heidelberg wrote:
> Convert bindings for NXP PN544 NFC driver to YAML syntax.
> 
> Signed-off-by: David Heidelberg <david@ixit.cz>
> ---
> v2
>  - Krzysztof is a maintainer
>  - pintctrl dropped
>  - 4 space indent for example
>  - nfc node name
> v3
>  - remove whole pinctrl
>  .../bindings/net/nfc/nxp,pn544.yaml           | 61 +++++++++++++++++++
>  .../devicetree/bindings/net/nfc/pn544.txt     | 33 ----------
>  2 files changed, 61 insertions(+), 33 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/pn544.txt
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
