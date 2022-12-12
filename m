Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADEAB64A7B7
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 19:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbiLLSzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 13:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbiLLSyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 13:54:25 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652961142;
        Mon, 12 Dec 2022 10:54:22 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id d14so14294042edj.11;
        Mon, 12 Dec 2022 10:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BgV8i0tXAyZeNZyh4HIfX0CjYjIHu3CMOk3qOrTDz8E=;
        b=XCVvWXp4U42UcmKN6L7IJtVa16hwaVbR6xY1vgYKIgrXVOY+0V/4Y0r2ngm7iZ9Yxs
         E7nQ1uF6F8o02wXrFSpv8oBqv+kr09m7OJKmfUQO+rHikcjG2b36X+ujhN306TKptuuG
         Zv4nBJ3qITL7j7Kqbu0n5uyUUTlXAxW76jcGnkHLCYeaPK9Ct1FnfV/kp0IV9qpBT8S/
         6Bg0T4vMpuiqCd0QfEym3HI7JPok/2WlXzsEIw/YAuseYe4OE9EhBXWn2SGYYVoJUrn5
         CivZlyaOQ6zIisw2NXvR2M8Nk6A3PYYyOXoDgztY9j0ynan9vSDHkbY2V38DZWp6bHNK
         4KhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BgV8i0tXAyZeNZyh4HIfX0CjYjIHu3CMOk3qOrTDz8E=;
        b=AcQodzYXhVKRkunx+Tn7L7ioDz3GLdxeZ7NgQi9BhY2srRpjThJkXOvAkez8cm1RGF
         zuRiO2G3WxbqOWldYvn9sQ63MIrva/5TIhlSeKa0mBIRm+SyvNpnn/+YP1YXFBREqxdt
         Clp7MnHyMODFb4isoHNxbjtnGDKvWYDXVSzHXLACGg0IhtMhOOI/euhf+/whIbLchADQ
         vANoiIy788woVw2pBbjNj+PMqgJAk0W1hqyGy+mQwtXn4MmNCvWAeUNlj2vQT9RcqqSM
         xD0A2L487Y3f/LTKMdGEIbtiEjqGpIlkCLAwAovkrilX6+nq92xefgescbHZEgyXcrb1
         qlUA==
X-Gm-Message-State: ANoB5pkBx1ooF3ZMnwWCxltzGlS95XbC5H8hApP5KY+L9Et89ctUnQQ2
        QaULP4gRl/BZDWbS4SceydI=
X-Google-Smtp-Source: AA0mqf6+bzmOMDoOOVtF3VuMwbnXX3csUvARTR0d2wG839EPngtGTTTbFv0evGi3ci9A4F2BxyR1oA==
X-Received: by 2002:a05:6402:1148:b0:461:2160:9356 with SMTP id g8-20020a056402114800b0046121609356mr20319824edw.29.1670871260875;
        Mon, 12 Dec 2022 10:54:20 -0800 (PST)
Received: from skbuf ([188.27.185.63])
        by smtp.gmail.com with ESMTPSA id f5-20020a05640214c500b00458b41d9460sm3998447edx.92.2022.12.12.10.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 10:54:20 -0800 (PST)
Date:   Mon, 12 Dec 2022 20:54:17 +0200
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
Subject: Re: [PATCH v5 net-next 08/10] dt-bindings: net: add generic
 ethernet-switch
Message-ID: <20221212185417.cyoqye5ql33aajaw@skbuf>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-9-colin.foster@in-advantage.com>
 <20221210033033.662553-9-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221210033033.662553-9-colin.foster@in-advantage.com>
 <20221210033033.662553-9-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 07:30:31PM -0800, Colin Foster wrote:
> The dsa.yaml bindings had references that can apply to non-dsa switches. To
> prevent duplication of this information, keep the dsa-specific information
> inside dsa.yaml and move the remaining generic information to the newly
> created ethernet-switch.yaml.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
