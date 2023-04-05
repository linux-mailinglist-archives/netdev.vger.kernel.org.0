Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FB96D7B59
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 13:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237310AbjDELad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 07:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236978AbjDELac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 07:30:32 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408931BEA;
        Wed,  5 Apr 2023 04:30:31 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-94748e41044so30487966b.1;
        Wed, 05 Apr 2023 04:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680694229;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HpdM1fn1DrC1PKAdJR2ZSS2rMGNzgFU5L+dCTrf3tRU=;
        b=UTjS9jrQbpDvYRC4bMLJYJGC3k2T/LB3b3SWWdiYPR0CjxCzY5MQyxflCJwH+RJRS7
         Kgtg79sj+ILkQ/bep34irWoStyzOXI2BiSx74IC6N4Z1aFJnirFYK8j74ouud84MYRtx
         ZUvWHn0PPJMyL9DDdTmiIDWbwHD9IzpvLFmkLvF1BfO7Kzzy7RiU0TUmBpgi4QPmV1zB
         Yxo0B5Dpzh5f4UEF+j5QbSNgaLksKAPA6Wvf1y78FjUI9Odvtt0qKnrE5rNPWrkEj7Jg
         NuHf2RZqBlOzrYLDZwPOX4V8APEeges0+P2xMHU+SZm6nkEkSLYUWZaonMiahxtoVZf0
         tGBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680694229;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HpdM1fn1DrC1PKAdJR2ZSS2rMGNzgFU5L+dCTrf3tRU=;
        b=UFnXBLQKmx718OlFEt246v2aVywg720AweRh2YfLflHj0lg0T98NkMC6myYxxi8OMY
         DUHrBxhJQIOtH4+drLqvzx/aM3y8iu7PnEHyEH4EPXszpo+of9Jf7LjaD4TmFs7yKxd0
         KPAs8CMY9AtGY2DthR+fi9Zc8r0hgyVR3wHFUwr1BgLSvR3Eks/TtCiE6m6sOTvKTYiM
         03nKR6idNo8fdfk7rnNZ4AkPz22jKoVGz0XoS2BNZZ6gKsQzZfnpASasWNlVBUn2XckT
         QDZktkK7SQs1WZ128WxMkOi+RDcItvXTXEhgM3ENzDJwGpl4irkD5da1OVs111vmx7jP
         L7rQ==
X-Gm-Message-State: AAQBX9fhPW/dER5fxKVpOb5sxuEnwFrFpfi4JrIL5T/zIJGgI6az7krr
        ne4VQUIB6CDjF430MnV5LrQ=
X-Google-Smtp-Source: AKy350Z4wEfHi4E1C4111W3snVxzXCX7+XVJkBZJJ09MtE+z6h7zJFIURLu8JNeDyQtrQt+2A3tWQA==
X-Received: by 2002:aa7:df99:0:b0:502:2f3:abd3 with SMTP id b25-20020aa7df99000000b0050202f3abd3mr1540900edy.35.1680694229333;
        Wed, 05 Apr 2023 04:30:29 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id e9-20020a50a689000000b004fd2a7aa1ecsm7179244edc.32.2023.04.05.04.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 04:30:29 -0700 (PDT)
Date:   Wed, 5 Apr 2023 14:30:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: dsa: brcm,sf2: Drop unneeded
 "#address-cells/#size-cells"
Message-ID: <20230405113026.a7xruh5lsmvizqmt@skbuf>
References: <20230404204152.635400-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404204152.635400-1-robh@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 03:41:52PM -0500, Rob Herring wrote:
> There's no need for "#address-cells/#size-cells" in the brcm,sf2 node as
> no immediate child nodes have an address. What was probably intended was
> to put them in the 'ports' node, but that's not necessary as that is
> covered by ethernet-switch.yaml via dsa.yaml.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
