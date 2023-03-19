Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785896C0162
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 13:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbjCSMGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 08:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjCSMGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 08:06:46 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B687B22132
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 05:06:35 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z21so36825845edb.4
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 05:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679227593;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3GQ0kuX+CANTyKsciGzMU4Vb8Jeilt6T7QwH/C5HtcI=;
        b=q/Wwmwtmi5ctcH6j5K3nCXBiz9uR0+OP/odaZ0yeLNMn0P9OkvfGw11VAgRnOyicjD
         dRjK50152RNnjgjge6gAAt5Oam85/MTmtLQltFikeLXblNNntYLDxeIl/jxH7cl6DlQU
         sY4XtUDCoocxbk8uJ7HOQfu1jUXU17C+IKRJby/o8bWFg/PmAAU/fafUO6CqreFLjueK
         aMRfAOGK16sg24DvYuSU3+cwAV/ypTXHaiO1E7FzvjPIDtQxYYpxTuvdJPLO5wV+DQCA
         oFGeTeBYPJtHdqLfLxMfW+FmzXsQe40biKcOOPKt9peVzMslgC29+L/CA9QbxDf/a150
         Ne3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679227593;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3GQ0kuX+CANTyKsciGzMU4Vb8Jeilt6T7QwH/C5HtcI=;
        b=vxC6npbrJu73KttqFOBY8rZUK+I79/xeLgGncDi6ZBeUOm5a7RPNnJFvMdDqzf5MBA
         M5PkDcBIJlthvFUJeJgCd3DisQyo12quVh/wIajycJgcmF+GKLW6X8K/1xR3o6uSvzP6
         vEp4VH2R0ul+eEbs/uJg3uX7SzfjEf1052gDiJo/RS8tRcQNSdjwFrA55Afdfe/wLYCG
         yq2apzEoVoPjSPKHzV6OXXmOstiBsjxqiCMWhcVled0pxmZo7rSrJrPaAnTTVpKq9EBV
         3gCa1wsTHKYZ2XwXjTB/h0OYO1HhqVLJDXiXVSjb3NyY9Er3LTDYjTL3FYLNXpVIvY2R
         9EvQ==
X-Gm-Message-State: AO0yUKUkuSWnOa5JeeMBgemqsjAaF6hA4g/aUSJO/embfSPR/kCL5+3q
        lpBPFuKTTRLcWApA8gsXpqDqWQ==
X-Google-Smtp-Source: AK7set9NHq4wBQYJWJ/ZRlVN9Tlxwe4UcNKkxGkrS38jM5S1VezeVO4DSvYLo/+tr/EvFNS6LaAQbQ==
X-Received: by 2002:a17:907:2101:b0:8d6:626d:7e03 with SMTP id qn1-20020a170907210100b008d6626d7e03mr5390303ejb.40.1679227593238;
        Sun, 19 Mar 2023 05:06:33 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:5b5f:f22b:a0b:559d? ([2a02:810d:15c0:828:5b5f:f22b:a0b:559d])
        by smtp.gmail.com with ESMTPSA id i3-20020a508703000000b004fbd365fb33sm3468506edb.38.2023.03.19.05.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Mar 2023 05:06:32 -0700 (PDT)
Message-ID: <efc29278-b1b6-c30c-5c89-294e5198b80a@linaro.org>
Date:   Sun, 19 Mar 2023 13:06:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] dt-bindings: net: Drop unneeded quotes
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, linux-aspeed@lists.ozlabs.org,
        linux-can@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-mediatek@lists.infradead.org
References: <20230317233605.3967621-1-robh@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230317233605.3967621-1-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/03/2023 00:36, Rob Herring wrote:
> Cleanup bindings dropping unneeded quotes. Once all these are fixed,
> checking for this can be enabled in yamllint.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

