Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9BF65C9AA
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 23:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238910AbjACW3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 17:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238906AbjACW2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 17:28:41 -0500
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029A91C92F;
        Tue,  3 Jan 2023 14:25:46 -0800 (PST)
Received: by mail-il1-f175.google.com with SMTP id g2so15599781ila.4;
        Tue, 03 Jan 2023 14:25:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a+Xe0vjRIB+tXNWYrD7r+kxJuDx4Qm4ZhI1U9RMGc6g=;
        b=seT8vQ7ybnyCbO8j3iFt1VUybXTXbdQV2ByiqgvPZHFWM1mm3+Z8BPPAWp7VwwABqd
         PX228MISNazSYCel+o2ZfZYausjlxXVf+q9sYyfALMpR9mO+nAWeCfKQDqZyiUh+uhjR
         NKzc1MqPNMUHh4NY1gVD2Ub3zzVybxcldPDlcKllJu0ZCXesWsK2fQpyKSDa9J34v53o
         8sooJHwCwr1ClManqlPjtxmwjWqak1a+5HR0NGHpnbv0rvdor1hCNXMwhkFQHLdOPiTK
         E75r237i5uM1HbhZLudLgf3JhTHp5S1Bi+2N9m+jd22H2k4HL+K9aCIlLS1MR7sw/OzP
         z39Q==
X-Gm-Message-State: AFqh2krvtEHJqyMuf0wIQ6Ei+XO67tUQoOEfOPmnLZzlOAwd4wcKytML
        RWNivaZqBuivs1ZKS6/Jhw==
X-Google-Smtp-Source: AMrXdXtnDeSVLLYObmQVFo0GZQVAk8nlVnFvvHtFCPyeXzbb0QNA46iGUJ7FoNUjhvOtZYYpIaXapg==
X-Received: by 2002:a05:6e02:214e:b0:302:db15:3981 with SMTP id d14-20020a056e02214e00b00302db153981mr38775478ilv.27.1672784734197;
        Tue, 03 Jan 2023 14:25:34 -0800 (PST)
Received: from robh_at_kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id z22-20020a05663822b600b0038a382d84c5sm10567133jas.64.2023.01.03.14.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 14:25:33 -0800 (PST)
Received: (nullmailer pid 4158431 invoked by uid 1000);
        Tue, 03 Jan 2023 22:25:31 -0000
Date:   Tue, 3 Jan 2023 16:25:31 -0600
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Marek Vasut <marex@denx.de>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        devicetree@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH v6 net-next 01/10] dt-bindings: dsa: sync with maintainers
Message-ID: <167278470815.4157827.15557237476346780909.robh@kernel.org>
References: <20230103051401.2265961-1-colin.foster@in-advantage.com>
 <20230103051401.2265961-2-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103051401.2265961-2-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon, 02 Jan 2023 21:13:52 -0800, Colin Foster wrote:
> The MAINTAINERS file has Andrew Lunn, Florian Fainelli, and Vladimir Oltean
> listed as the maintainers for generic dsa bindings. Update dsa.yaml and
> dsa-port.yaml accordingly.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
> 
> v5 -> v6
>   * No change
> 
> v5
>   * New patch
> 
> ---
>  Documentation/devicetree/bindings/net/dsa/dsa-port.yaml | 2 +-
>  Documentation/devicetree/bindings/net/dsa/dsa.yaml      | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 


Please add Acked-by/Reviewed-by tags when posting new versions. However,
there's no need to repost patches *only* to add the tags. The upstream
maintainer will do that for acks received on the version they apply.

If a tag was not added on purpose, please state why and what changed.

Missing tags:

Acked-by: Rob Herring <robh@kernel.org>


