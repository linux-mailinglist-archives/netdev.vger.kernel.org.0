Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBDBB64A774
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 19:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbiLLSrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 13:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbiLLSqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 13:46:52 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DC429F;
        Mon, 12 Dec 2022 10:46:51 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id c66so14284749edf.5;
        Mon, 12 Dec 2022 10:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=epB6zTfweVmmiNYmsWHbb08P5JmiAsWOLYyFnL5+8DI=;
        b=mGiOG00DH7d1okC6HYRO1b4PT8S/5GYbqOgvUgMj17hjC878FhEfbbxutHxkemnqhX
         JNkbmcRWAIRH1kE79m8MWAY/ihzftkITk3I3KuJyMy33gNh6bjp1PPVCzKDN76WNplGW
         rXGWew94o0wZPWDMio4uDYvXVMV0LHg8SEepYk5eSpUvnfZAYGLVzeFWkch0R9gFxGmb
         +EOgWrHvAnW5g3Tyz6ln0DN7SCW27U65oY5gMwJ68gdpz/pU9fBr6cZr+FD9ECiZhOL2
         XoKznJx4pSJ0PbhTvEvTWpYkqPfSesi+WfU44as+TurmpKi+8dHr7ikJYOiRCUmTJJv1
         TbJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=epB6zTfweVmmiNYmsWHbb08P5JmiAsWOLYyFnL5+8DI=;
        b=D1XpORfU3Iwaj2EbZRofFNQsnlcLsUkVC0IysQud5a5v0Z64IstoE3PXGsGRHj/0r0
         55xV414CgwFZEvubjcDx8MHl6yZsPTGqizWh08OY4VDHT0KDxLQaQG6EbxhXibyz0see
         DEk/RE3yv6aSo3p0jeCQlTPw2V5OwJ2BbLgtzqooEyURISHz8UrjHsxsdOZxjvNoYs5c
         ETAUrAwz8KCvdBnm0Pdm2NWqx83EphjB866q4HzJCsTDoAC8y7x/72QI39EUhIVV035/
         MufAaldJfpRbApW9SEcFnulz9Mb3UhCLlc8fNXofMVouSyzMWcW7LHbIGLE7OItxXLbt
         6dGA==
X-Gm-Message-State: ANoB5plg6ARTw050WL5c/vq6Cn7dVImro/5fZMcBy8gffMGWZZV25TiP
        JPyLMSJCMEd3v/wbsO/tKg0=
X-Google-Smtp-Source: AA0mqf4jJTq2z83SlkLf5ctkhS+SAdQuYrAJekO9bKZrsoZHWmAkqlvsQJVIdrtwkcS/sFObZsRuVw==
X-Received: by 2002:a05:6402:3895:b0:467:7775:ba8 with SMTP id fd21-20020a056402389500b0046777750ba8mr15155363edb.1.1670870809782;
        Mon, 12 Dec 2022 10:46:49 -0800 (PST)
Received: from skbuf ([188.27.185.63])
        by smtp.gmail.com with ESMTPSA id l4-20020aa7c304000000b0046b1d63cfc1sm4081207edq.88.2022.12.12.10.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 10:46:49 -0800 (PST)
Date:   Mon, 12 Dec 2022 20:46:46 +0200
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
Subject: Re: [PATCH v5 net-next 03/10] dt-bindings: net: dsa: qca8k: remove
 address-cells and size-cells from switch node
Message-ID: <20221212184646.cb6y7rd7g2nzekh4@skbuf>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-4-colin.foster@in-advantage.com>
 <20221210033033.662553-4-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221210033033.662553-4-colin.foster@in-advantage.com>
 <20221210033033.662553-4-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 07:30:26PM -0800, Colin Foster wrote:
> The children of the switch node don't have a unit address, and therefore
> should not need the #address-cells or #size-cells entries. Fix the example
> schemas accordingly.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
