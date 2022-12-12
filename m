Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6681C64A773
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 19:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbiLLSrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 13:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbiLLSq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 13:46:28 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07087C18;
        Mon, 12 Dec 2022 10:46:17 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id z92so14306024ede.1;
        Mon, 12 Dec 2022 10:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LIqnjaezngtLNEp7isLzPA2shfRnfoXIJoBf7CQ93rI=;
        b=H8uWIP4eO1YxQwxoLb4ulLb1Xl2vq8gtcgHk7otP2Mh5hIp+8F1jyt4VNVIPnpjKYb
         ex9nMsCcDfnFTip94C35t/M2MeStVjExWFDjCVzf7evIq8y1Q7xyRu6jN0eVOJR4k21q
         EZK6dmfOWIYDGTFrQNijxRPmeh/oWF0xphbrVm+j53kccYsMtkGeU9W3h+LfQ4DwAiC3
         xFam0IPCI8gmSJRuXEyr5FBdZHqxl/vul3a1Ei5Ln98IGzEpiC0p7Rdhxt6hOoBfdzWN
         w0fPzdPPK9jLva12as1gic8LWTpAGtrlhEBEZV6lSK+ixjMXQNTA7n8d9Sz/gCsrJjou
         wUpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LIqnjaezngtLNEp7isLzPA2shfRnfoXIJoBf7CQ93rI=;
        b=NrqOjqmiv2RLnT6lNq4ND10jlGIXEXCTO90d7sgQFh/b62LhUzqCmaEXZpCy0VYkaV
         B8xX8HEkPPip3emn1En2lP3hI52jQZmSPIF3qe4wjNJGQpZSZ/NXi56hURtHPxryuAR1
         bBU0E0xlFTdh6WWLm7FvqiDrQ02rbZbucEyUQP6cK0x1JXX+zgSGkb0+bAiR4QJvoP6h
         0wNJLDsDFrWZc5gZMWMQFHU5d14Xea+lFz/hnNrQWuN0McCdJHD6xr+2QbsyWQsZS0Kg
         f7ZoXjcewjPJRl4APXoL8sGsmE1U+605/e1SZh5W7EArzTyMsj2iOeiTzWA6Uk8C4wFd
         WUCg==
X-Gm-Message-State: ANoB5pm2ale+PdBBTA/7LJo6fxz3LkNS21ytx6bjYp4BfaJ263tgoz1v
        cH8653SZoRM1FAZTFaCZ6O4=
X-Google-Smtp-Source: AA0mqf5qcPywMWUxBv1Oz1+GiwzWTko+mCdn6kipC6jyixD652tjVTc3o34OIe6BDffAtWUTbjTCww==
X-Received: by 2002:a05:6402:7ca:b0:46b:aa:8564 with SMTP id u10-20020a05640207ca00b0046b00aa8564mr12728933edy.30.1670870775491;
        Mon, 12 Dec 2022 10:46:15 -0800 (PST)
Received: from skbuf ([188.27.185.63])
        by smtp.gmail.com with ESMTPSA id d4-20020a056402516400b0046b00a9eeb5sm4090784ede.49.2022.12.12.10.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 10:46:15 -0800 (PST)
Date:   Mon, 12 Dec 2022 20:46:12 +0200
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
Subject: Re: [PATCH v5 net-next 02/10] dt-bindings: net: dsa: sf2: fix
 brcm,use-bcm-hdr documentation
Message-ID: <20221212184612.dyjlhxucybn6jh7m@skbuf>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-3-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221210033033.662553-3-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 07:30:25PM -0800, Colin Foster wrote:
> The property use-bcm-hdr was documented as an entry under the ports node
> for the bcm_sf2 DSA switch. This property is actually evaluated for each
> port. Correct the documentation to match the actual behavior and properly
> reference dsa-port.yaml for additional properties of the node.
> 
> Suggested-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
