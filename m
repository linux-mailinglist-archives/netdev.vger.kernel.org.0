Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931D4427B7B
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 17:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234841AbhJIPsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 11:48:31 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:33882
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234290AbhJIPsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 11:48:30 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 642D940011
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 15:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633794392;
        bh=v1+QlvKaJ7Bh5M6oMybEXJsFX39EduvKj9WCPeD3iRE=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=ktP2f3fq7PHuT1E6KdcNjSe9xSf7Jr/Vm9lvJSOqxattK3D/7O6FDL3s0ZePS+iU+
         WXrfFIdfbWmalHTxCBcHlRdCRsywzCBGqKmpXfLp354Pq1pS9zv9dVuBZKK2zswtf6
         I3rJRjsXJelfJmV1SlVIMBzCxJBmmb4El8ciTsW0SJwUi+/EBTphRQZqvQ+Jbrb3q4
         WkjfaxW+2Sl/tJHKTgCUmtS7MMelQ82woZ7+o0yto+1BiDBcOQ0ySgPRbfzu1Mzzet
         S3MnuE1XLEJMs+Jke97cT8KV27hp5UjGBcdZOtiAIEILieC1tohRbBXyBeuisBPG/9
         O9mFjoHKkdbtw==
Received: by mail-ed1-f72.google.com with SMTP id 14-20020a508e4e000000b003d84544f33eso11860437edx.2
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 08:46:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v1+QlvKaJ7Bh5M6oMybEXJsFX39EduvKj9WCPeD3iRE=;
        b=GuoB3SoaSB5NqDigYJS0nJ0Xm1z3wmsjkzEGGAv7bmSaldLw2fKbY73rcWSZ6JtZ09
         JubZr6sJMOpdpDNMEhpzGe63g+fQlcEnNVGoA8E1ia+U+U+Mbg3NfpggqTXG0SR3BzxH
         rXvVVjJ6Me3D5tfj7G/pSB9UzX9RfGi721LpTJlYV5uBw1jon8hSf66UUyye8eV6AwXu
         q/IYHTdRzNQlMDff7vB1v3U1PYi/2X1UBzTwTeoUnpHMf7cDWTL6t70xp4hpLMNJQsYE
         N73uDhLRF1aN2cdlJ3nZHn6NIh9lIqrilmwJX5k6bqBBZfnFzVr/dpEl8Lu2MK1pPSJq
         9fCw==
X-Gm-Message-State: AOAM530CRtvBa0UaSO+dc8X55N5k1+Og3pokkai+BdQtVdUgZwNxQlaT
        zOttFNp8qdyn1rGAN2GTTwoIm0ciKY+hk/OSbJ3zkuQieKN/mLqLK0fiogGew/bK0B/UE2oZ6QE
        4Cxy+7Ok/0DolptA6tGPRfA84q04re8eXWw==
X-Received: by 2002:a50:9d8e:: with SMTP id w14mr24670466ede.74.1633794391989;
        Sat, 09 Oct 2021 08:46:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2VPYG8VbUO+BMxIVbYguDgxJuPFsNUpuHGhQL3ig+n1yG0BiNoNGTraMX8HzkO8k4m52zUQ==
X-Received: by 2002:a50:9d8e:: with SMTP id w14mr24670441ede.74.1633794391842;
        Sat, 09 Oct 2021 08:46:31 -0700 (PDT)
Received: from [192.168.0.20] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id l5sm1096050ejx.76.2021.10.09.08.46.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Oct 2021 08:46:31 -0700 (PDT)
Subject: Re: [PATCH v2] dt-bindings: net: nfc: nxp,pn544: Convert txt bindings
 to yaml
To:     David Heidelberg <david@ixit.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ~okias/devicetree@lists.sr.ht
References: <20211009153003.33529-1-david@ixit.cz>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <8050a43b-8278-8148-2827-cccbfc28b414@canonical.com>
Date:   Sat, 9 Oct 2021 17:46:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211009153003.33529-1-david@ixit.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/10/2021 17:30, David Heidelberg wrote:
> Convert bindings for NXP PN544 NFC driver to YAML syntax.
> 
> Signed-off-by: David Heidelberg <david@ixit.cz>
> ---
> v2
>  - Krzysztof is a maintainer
>  - pintctrl dropped
>  - 4 space indent for example
>  - nfc node name
> 
>  .../bindings/net/nfc/nxp,pn544.yaml           | 65 +++++++++++++++++++
>  .../devicetree/bindings/net/nfc/pn544.txt     | 33 ----------
>  2 files changed, 65 insertions(+), 33 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/pn544.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml b/Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
> new file mode 100644
> index 000000000000..6a4bc511d962
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
> @@ -0,0 +1,65 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/nfc/nxp,pn544.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: NXP Semiconductors PN544 NFC Controller
> +
> +maintainers:
> +  - Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> +
> +properties:
> +  compatible:
> +    const: nxp,pn544-i2c
> +
> +  clock-frequency: true
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  enable-gpios:
> +    description: Output GPIO pin used for enabling/disabling the PN544
> +
> +  firmware-gpios:
> +    description: Output GPIO pin used to enter firmware download mode
> +
> +  pinctrl-names:
> +    items:
> +      - const: default

I wasn't specific, because pinctrl always go together - names with -0.
This as well should be dropped.


Best regards,
Krzysztof
