Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F4B62373E
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 00:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbiKIXIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 18:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiKIXIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 18:08:05 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21F1647D;
        Wed,  9 Nov 2022 15:08:04 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id fn7-20020a05600c688700b003b4fb113b86so98010wmb.0;
        Wed, 09 Nov 2022 15:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LwVitJc+OKf+8w4wSRaaZOyHv8YAZ//3DtpKET00R7I=;
        b=hBckYn0WxZvQCSKJBFl3QcweKiTVzJiGEsjEaBhtXNElu3i8fx7xHVayMhZ/82qZWz
         Vw1DDRQpFx7OXW7pGWHrN6na6/ByAgBzax4W9/viPKIiJTtedoVNn0iLUB4jBLeIUU9l
         Ad1AHLLzd1eTEdb2Vq7bCkUK+1s61+bY1VZFLx/28sWvBPZcZBUa/5kIPRnmhyH8KsrE
         mmX0w3c1XIL2xypjVCrGVdZAMhiaSkjAx+4U6/03FzWoW63P5OsspCyPxf4YR7nZaZR7
         QG4NZR52xZe6IeJELNJ2cKzhvyJ5X/YqvryHyqAveQO6o8sUHcvV+yUSJ+bYRotzLoGo
         ETTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LwVitJc+OKf+8w4wSRaaZOyHv8YAZ//3DtpKET00R7I=;
        b=Z5P0liubnN9mEcParV88Gk3OYvn4EtGB5mdlu48WiT2LRODmAEYX7HYW2slKxIx/Rf
         CbOkEch+Iy10M8VsUSeMI3vflZ0g5/LKQ11bbGkQH4N3SM8wPPydiX3S98KU6ODA7Nba
         naPzmp/QmWatD2k1f94BkmVJ/C31A/IdiwueDse+cvf3hCm4PA1LdJ0lmYZg0rslBZ7R
         yce0x9r4josomYG/TpCE0jL+jKRX7kpz4sFr52d1imnkj6AbIqkJ51saGv0QmMfiSDxf
         YY16hbu9r9WR3enURUriRmN5rlyT5rz2A9AAv9u6yMOpZJlopQ6TxKdmsWSDZEyy4KmH
         WIiw==
X-Gm-Message-State: ACrzQf20NuRnytmycNv42D617G3w0HEGKW59Fk38AnLSfJhNbnK7BAFS
        PUFehU59JXzsgnYCRcBDLTA=
X-Google-Smtp-Source: AMsMyM4AJxypXUVf/EsY503k79RpGyRHyzcplzZwHSA1aIE3JjDY7Zwoj701g6KVLOuJRL8C9m3FXg==
X-Received: by 2002:a05:600c:4b27:b0:3cf:8ec7:b8f with SMTP id i39-20020a05600c4b2700b003cf8ec70b8fmr23266575wmp.69.1668035283125;
        Wed, 09 Nov 2022 15:08:03 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id fc18-20020a05600c525200b003b49bd61b19sm3288752wmb.15.2022.11.09.15.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 15:08:02 -0800 (PST)
Date:   Thu, 10 Nov 2022 01:07:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v2 net-next 2/6] dt-bindings: net: dsa: qca8k: utilize
 shared dsa.yaml
Message-ID: <20221109230759.gw7prntz7i5lxwiq@skbuf>
References: <20221104045204.746124-1-colin.foster@in-advantage.com>
 <20221104045204.746124-1-colin.foster@in-advantage.com>
 <20221104045204.746124-3-colin.foster@in-advantage.com>
 <20221104045204.746124-3-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104045204.746124-3-colin.foster@in-advantage.com>
 <20221104045204.746124-3-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 09:52:00PM -0700, Colin Foster wrote:
> The dsa.yaml binding contains duplicated bindings for address and size
> cells, as well as the reference to dsa-port.yaml. Instead of duplicating
> this information, remove the reference to dsa-port.yaml and include the
> full reference to dsa.yaml.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> ---
> 
> v1 -> v2
>   * Add #address-cells and #size-cells to the switch layer. They aren't
>     part of dsa.yaml.

I'm afraid this is not the correct resolution to the warnings you saw.
There is no reason to have #address-cells = <1> under the "switch" node,
since none of that node's children have a unit address (see: "ports", "mdio").
The schema example is wrong, please fix that.
