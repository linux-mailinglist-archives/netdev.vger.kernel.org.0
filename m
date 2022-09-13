Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBB25B771D
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 19:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbiIMRBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 13:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231793AbiIMRBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 13:01:08 -0400
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B5A8D3D8;
        Tue, 13 Sep 2022 08:52:02 -0700 (PDT)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-1278624b7c4so33284230fac.5;
        Tue, 13 Sep 2022 08:52:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=6Zxhbl7LxU5qELLtcpL71bgm+csNbrX5/FOGxIAUqIw=;
        b=BiC6+7i3KM7WLZSKjlmqa3qbVVXAf06UUdMH/NDyQevEdLIqV0+gu1d/+/hTKcY4rv
         vOwW3B5X/1tIvkQRtb+5YBa2t8eNV3gpJbP2mmiAkmHuJjARFIZFWx1vzZw812oo5k6X
         228OhFf8u2Km46LwPbF0XHItJXUGSHTHDjIuZUaVeyJHU78sYpRdjRDoAhcIU/Atwa+G
         f033Owdd8BrlyOCoPBRa9UB5g3L4vT/VHoj1Rq4SkrERc1affcZa5YMd6vQ42cIXPvsQ
         kv23ZOVSnBQD4RklR3CmOmCRcgwUgPWKQ4Q7GRO7wtjWi1s6BujYSGn69f2Kg6zudbKh
         l0qw==
X-Gm-Message-State: ACgBeo1SPEK3lAZXNcVnu/hb+itqVjb/zesbwUkPAZwQ4kMy5/fI5h5v
        ZxvGHyK6gzyeu2ZgjtlYnw==
X-Google-Smtp-Source: AA6agR7sudikaulOJjDjKBhjit+p3YIiP/+/9fBG0IadZMnM/tMs/qmmt53+RNlMkYVlbg91XHE0aQ==
X-Received: by 2002:a05:6870:a713:b0:127:70ba:aa86 with SMTP id g19-20020a056870a71300b0012770baaa86mr2184471oam.154.1663084278229;
        Tue, 13 Sep 2022 08:51:18 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id x7-20020a4a8d47000000b004728e64dc0fsm5616486ook.38.2022.09.13.08.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 08:51:17 -0700 (PDT)
Received: (nullmailer pid 3801723 invoked by uid 1000);
        Tue, 13 Sep 2022 15:51:16 -0000
Date:   Tue, 13 Sep 2022 10:51:16 -0500
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Woojung Huh <woojung.huh@microchip.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, UNGLinuxDriver@microchip.com,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        John Crispin <john@phrozen.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Marek Vasut <marex@denx.de>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: dsa: mt7530: replace
 label = "cpu" with proper checks
Message-ID: <20220913155116.GA3801652-robh@kernel.org>
References: <20220912175058.280386-1-vladimir.oltean@nxp.com>
 <20220912175058.280386-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912175058.280386-2-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Sep 2022 20:50:56 +0300, Vladimir Oltean wrote:
> The fact that some DSA device trees use 'label = "cpu"' for the CPU port
> is nothing but blind cargo cult copying. The 'label' property was never
> part of the DSA DT bindings for anything except the user ports, where it
> provided a hint as to what name the created netdevs should use.
> 
> DSA does use the "cpu" port label to identify a CPU port in dsa_port_parse(),
> but this is only for non-OF code paths (platform data).
> 
> The proper way to identify a CPU port is to look at whether the
> 'ethernet' phandle is present.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
