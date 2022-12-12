Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D856B64A78E
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 19:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbiLLSv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 13:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbiLLSvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 13:51:05 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DDD6585;
        Mon, 12 Dec 2022 10:48:46 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id r26so14259654edc.10;
        Mon, 12 Dec 2022 10:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tDsiZVcT6LKv7qv4YhKSrW1h5gXitQdAoJlA0RCwOu8=;
        b=HP/Xkt3w9LogTnaJ422r+uFe6+l3afLWuFBe+9OVrnLwVPm5ZQBnuzS+iWXyFqhx6b
         FDABNAclChq/qR7zEfj65N5HOHRPV7SE+pVuUcvPV4LSgvi+DMYGnUUNsIRkk+bOFcPd
         sMHot19nZZWPzZOE46VY5fw6NSvrXQJTNrhyul+Bw1rTDg4MV4B3GeG+lPD736Ykq3nN
         uZl8SXRjxFoGtU82QjK8zmTaA2+cljVEmTyrdjedNeJGPxuIVFWa+3pFmrwL7ypbRU1P
         07LVxnLtufZ2rf8G1shkghekIwBssniWsTxiwnYm+6Y2sOvyenhus6gQurGgkGk5d1HW
         WtVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tDsiZVcT6LKv7qv4YhKSrW1h5gXitQdAoJlA0RCwOu8=;
        b=nVEK1vOrPBuyg8osWysHdL8HxaY57XEHHV4D2utLjkTWatSPy3h/SBrFIieiAiDvKb
         7bkFzuBlEKC5Tci4w0Z1AtN91QRMSsPV1HwiulDenewzc3cmmIpptcAMXxfhknFpF9lI
         UL6LMTcQo4Omu9A/74FJnUeeFpRw9+r8MWKPR378atGSrMW10D8JFsnJOM/QD6nMAgIo
         vVFKTG9AlWQZIMUYnJO+UmFplSLd+2UiDcq5XwuhZIplF4PExcjgCqPLEQPgJfqctQ5U
         GAjuVCKij/V8XtB+MYwzeUcX31Og+c4H14wTbIi49h7ACTCVa+RXIcjxxkw4bUZkMUZd
         yCvg==
X-Gm-Message-State: ANoB5plaYxjcFKuoTb4lOwI7xAzfoQsgAkwv/EHY3gq42YjtFKMeUiAi
        cg/EjcMqCiF+HpbcVVvjze0=
X-Google-Smtp-Source: AA0mqf5Qocjl8+YpMT20fwcLZCQ4QL1cX+13/KOp6puSW8LFCIkKbdkD+FctF1YbdtV8nHiMimPtQQ==
X-Received: by 2002:a05:6402:3901:b0:468:3d69:ac89 with SMTP id fe1-20020a056402390100b004683d69ac89mr17524046edb.20.1670870924925;
        Mon, 12 Dec 2022 10:48:44 -0800 (PST)
Received: from skbuf ([188.27.185.63])
        by smtp.gmail.com with ESMTPSA id n13-20020a05640204cd00b004677b1b1a70sm4053373edw.61.2022.12.12.10.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 10:48:44 -0800 (PST)
Date:   Mon, 12 Dec 2022 20:48:41 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v5 net-next 04/10] dt-bindings: net: dsa: utilize base
 definitions for standard dsa switches
Message-ID: <20221212184841.siswunoxmkyek2hb@skbuf>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-5-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221210033033.662553-5-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 07:30:27PM -0800, Colin Foster wrote:
> DSA switches can fall into one of two categories: switches where all ports
> follow standard '(ethernet-)?port' properties, and switches that have
> additional properties for the ports.
> 
> The scenario where DSA ports are all standardized can be handled by
> switches with a reference to the new 'dsa.yaml#/$defs/ethernet-ports'.
> 
> The scenario where DSA ports require additional properties can reference
> '$dsa.yaml#' directly. This will allow switches to reference these standard
> definitions of the DSA switch, but add additional properties under the port
> nodes.
> 
> Suggested-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Acked-by: Alvin Šipraga <alsi@bang-olufsen.dk> # realtek
> Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
