Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69E4681C6B
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 22:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjA3VLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 16:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjA3VLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 16:11:10 -0500
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEF049010;
        Mon, 30 Jan 2023 13:11:00 -0800 (PST)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-1442977d77dso16838051fac.6;
        Mon, 30 Jan 2023 13:11:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QtS1hOVGy1iYOFFeFQMIgO1x/OkonW6YoQzkEFckPzU=;
        b=iZJvR+YE6BZn/ZHQ+tLelZFZxjjMEu7QkP0DpF0dDqz9si0ypBokyDd2G25I2OXcba
         kdZ8NgAjahV3jy6CUI8Jd//9cX8F2ujMZmK6kem9oF7vwdq8zfZdxMnmw/t9V5ngstCE
         DlGj/rKeM1W/XyUzD4MR1JPgKusuccojCGwpGeS2fPdi08JQ+vSSXAuR+URD8cPF85Qt
         14bgfhfyDXR0af4ytnDn+lAQFOQpe0yunVagQAnJBYxpMQcQl9LHBVEiJ5eUZ8Oktt5S
         TvDNtwOfMs5Ovkqdg3ReuLqy8UmSS/au0ZmSfmCvgSNacbsEG7g+ThVE/PBWEI6AwE8A
         EU9g==
X-Gm-Message-State: AFqh2kosQPaED46Ltr6IZgCrgJOjy0XhHjw9zMcZYHXxiyOPO4R/eKxM
        lNlnj+WVLcsrNfsPo8mSFgKkWqo74w==
X-Google-Smtp-Source: AMrXdXuJGbyj8gNQIj/mPUdLhKjk8E/OKzgjhw4eMZbazQl+dShj4U8/4uL6EkmUee/ARCR111xIBw==
X-Received: by 2002:a05:6871:608:b0:15b:a18a:f76a with SMTP id w8-20020a056871060800b0015ba18af76amr28479503oan.29.1675113060076;
        Mon, 30 Jan 2023 13:11:00 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id mt14-20020a0568706b0e00b0014ff15936casm5644447oab.40.2023.01.30.13.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 13:10:59 -0800 (PST)
Received: (nullmailer pid 3386072 invoked by uid 1000);
        Mon, 30 Jan 2023 21:10:58 -0000
Date:   Mon, 30 Jan 2023 15:10:58 -0600
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Lee Jones <lee@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v5 net-next 11/13] dt-bindings: mfd: ocelot: add
 ethernet-switch hardware support
Message-ID: <167511305805.3385819.10548444748268317338.robh@kernel.org>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
 <20230127193559.1001051-12-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127193559.1001051-12-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 27 Jan 2023 11:35:57 -0800, Colin Foster wrote:
> The main purpose of the Ocelot chips are the Ethernet switching
> functionalities. Document the support for these features.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
> 
> v5
>     * Update ref to mscc,vsc7514-switch.yaml instead of
>       mscc.ocelot.yaml
>     * Add unevaluatedProperties: false
> 
> v4
>     * New patch
> 
> ---
>  Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
