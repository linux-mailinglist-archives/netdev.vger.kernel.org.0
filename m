Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32EE6496DE
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 23:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbiLKW6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 17:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLKW6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 17:58:30 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B499FF7;
        Sun, 11 Dec 2022 14:58:28 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id fc4so23735771ejc.12;
        Sun, 11 Dec 2022 14:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M33qCD7Tm8dDEgZk34tGAUKV2pp9BjLWodh2i56ini8=;
        b=YM/EYtHkM9CzZbVfnNVz3ugqNlk3HA3Qywye8HmZNtAVcbE8mI+jSfGVkYqFn/uidC
         GmaGFF3VGDlrfL7HwRPrWg2gx8OfTYa7KZJUQq0fNQzLNVIs3k7nkPn79sp8pYm5u5gN
         uJnxyNLtDSmRjf7Kp6IngeT2ofr0NQPEy3JC76VutmwpVNpmowA5+12MeB6WYVxMWD4n
         AdO/pAa1/8xPsrWuuzD+Os91s3wQpBwmiEDec3mfzWaNdFQaxgZ7KTUsVyMpIxo4snfp
         HM7ez7UKZKgsBcF+H5s+8TCro4smINVZnBLSR44U/xI5lmqrEyhvy2FlFmn3XJqCVDtp
         KY9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M33qCD7Tm8dDEgZk34tGAUKV2pp9BjLWodh2i56ini8=;
        b=s2VQKXUhzZx8VCDFWWzWXvQqPtdI7F5LZaj+APawwx0unXOIKmJJP3K2duGlr29kxd
         NMVLVXkNDsEdiyJcbMMRMjg3FpwdNboyCgV8m+eaE7fy0geEBMX61G7LLZcHPuOCBUiF
         wJrtDVZS0/bq3KQ8flUJNJnpwxxqO/babYLNBCgZdKOrGCtDdN7A74ZnWvpIiJk8my7U
         hH91no/5yhotNOggO5vlzUUr3J3UmSsVe1gWfbyJQr8YC0djZ0aGwB19LDwvFSTRzvfc
         lqE7mEi7cgY65AEcoKNvfu5jopPsR10yEXtTv+WDk/rb4lqL/Z5T+oSDq9FZqtKrbOnU
         CV2A==
X-Gm-Message-State: ANoB5pmjSK5f6Ff/NiUDzTXWy0dEdqLCtO3rsjL2aiohEhz/P5Pu+Gvc
        XlrHBenBQ2BS+oAkmIlxcCs=
X-Google-Smtp-Source: AA0mqf7p50+L95OeIEuBxlGylcnhYmtBdgeQFosfuZf9XnCV73/tM0sQHCcFFJhDfhxd79fyjh6MQw==
X-Received: by 2002:a17:906:150d:b0:7c1:65f5:7b92 with SMTP id b13-20020a170906150d00b007c165f57b92mr4674347ejd.48.1670799506624;
        Sun, 11 Dec 2022 14:58:26 -0800 (PST)
Received: from skbuf ([188.27.185.175])
        by smtp.gmail.com with ESMTPSA id f12-20020a170906390c00b007c0aa8eaf47sm2504998eje.116.2022.12.11.14.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Dec 2022 14:58:26 -0800 (PST)
Date:   Mon, 12 Dec 2022 00:58:23 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        linux-renesas-soc@vger.kernel.org,
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
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v5 net-next 01/10] dt-bindings: dsa: sync with maintainers
Message-ID: <20221211225823.nde77nlfriok4q6x@skbuf>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-2-colin.foster@in-advantage.com>
 <87o7sbh896.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o7sbh896.fsf@kurt>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 10, 2022 at 11:18:29AM +0100, Kurt Kanzenbach wrote:
> You can update the hellcreek binding as well. Thanks.
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
> index 73b774eadd0b..1d7dab31457d 100644
> --- a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
> @@ -12,7 +12,7 @@ allOf:
>  maintainers:
>    - Andrew Lunn <andrew@lunn.ch>
>    - Florian Fainelli <f.fainelli@gmail.com>
> -  - Vivien Didelot <vivien.didelot@gmail.com>
> +  - Vladimir Oltean <olteanv@gmail.com>
>    - Kurt Kanzenbach <kurt@linutronix.de>
>  
>  description:

Good observation. If there are no other comments on this patch series
(which otherwise looks reasonable to me), I suppose that could be
accomplished via a parallel patch as well? The diff you're proposing
does not seem to conflict with something else that Colin is touching in
this patch set.
