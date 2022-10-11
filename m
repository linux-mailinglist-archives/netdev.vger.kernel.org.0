Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BFD5FAFB7
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 11:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJKJxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 05:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiJKJxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 05:53:24 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BEA819283;
        Tue, 11 Oct 2022 02:53:23 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id g27so19317823edf.11;
        Tue, 11 Oct 2022 02:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ELjS81PwjqQiyf5mGAwEzkT1W0HRDMv+5erRjZ7RuLQ=;
        b=kIoTTB8ZNwOG9w6qq0ZIJ0LPuQeliEpZIELLknmgoAK4NaByX3aFSepOvud7Q5KiAY
         93axr1cusG2EFrbH6k1HkgTYoUmZNLGtCrFS08prJJhOxO9jKojNStBQqQHz1+Q0rFo9
         hIvxktGgEh6Qnm3kHRLZPpsM2+Bmqik8qRHoggJ/5XIg+IoUisP4T2oW4mli2CLR4xUD
         Fs0feCX8LbDNbTxsEY38eB7AfBd/udLGb9DrT74MkcfT1Wj91Jly7MpPYqPfXz22sBKV
         29htuS//FwNAPt/MVo9ytxr7wduHqbLKI5HsEBsXhJozcwzvFAFY2Ae7cGLQaSYTuOsl
         zlgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ELjS81PwjqQiyf5mGAwEzkT1W0HRDMv+5erRjZ7RuLQ=;
        b=T4NAcyufzZ3p0CAXiMHHYyehWl7V/9HDQly+/eX/zCiSQR7SWwJM4OLmr02ASBh22q
         PPSzsQ2vhRis8+ZNsfkSvwuJMBnnofzen0jzaYC32J5ejhvq7VDIAJwlS4EWGYHxp35O
         kbApgHXWxZAdFWVWCTbfEdLxFvmLWVHr9Or1ts/c0fdJ0pWlZ/LuqqOIgAn7mXL/iKGQ
         7Im0kicZ7cgC44Vxd807etQONEWm5xn1VQ5zF3p80OFihiv0Kv8/mvdKCEYUr6SsLXY6
         RHsmuNpktnGSJ27kEeEMK126wRUz/6cUtyQM0R7pzixL3QAIUqkyeiJMchkGc+Yr9bI2
         UPvA==
X-Gm-Message-State: ACrzQf17iqlekbmgCudCyrJqWxsFqJoeU+9hY5xBhC5wCuYH6c01a8Kp
        e3s+quDnRc7XxADMnt/6BmFIfAMrMG216w==
X-Google-Smtp-Source: AMsMyM6se43QQMI0lPdusx+BG1o2fymug7qixH9tmxIgEZRUkwg6mZBuwa2NlJ8ZfTHPQSGc6orvMA==
X-Received: by 2002:a05:6402:1bd0:b0:458:f170:fa74 with SMTP id ch16-20020a0564021bd000b00458f170fa74mr22233281edb.382.1665482001479;
        Tue, 11 Oct 2022 02:53:21 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id bt6-20020a0564020a4600b00458dda85495sm8903646edb.0.2022.10.11.02.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 02:53:20 -0700 (PDT)
Date:   Tue, 11 Oct 2022 12:53:18 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next 12/14] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Message-ID: <20221011095318.mqbrk3jrfioiql4x@skbuf>
References: <YzzLCYHmTcrHbZcH@colin-ia-desktop>
 <455e31be-dc87-39b3-c7fe-22384959c556@linaro.org>
 <Yz2mSOXf68S16Xg/@colin-ia-desktop>
 <28b4d9f9-f41a-deca-aa61-26fb65dcc873@linaro.org>
 <20221008000014.vs2m3vei5la2r2nd@skbuf>
 <c9ce1d83-d1ca-4640-bba2-724e18e6e56b@linaro.org>
 <20221010130707.6z63hsl43ipd5run@skbuf>
 <d27d7740-bf35-b8d4-d68c-bb133513fa19@linaro.org>
 <20221010174856.nd3n4soxk7zbmcm7@skbuf>
 <Y0RoraHpuPbN5O4C@COLIN-DESKTOP1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0RoraHpuPbN5O4C@COLIN-DESKTOP1.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 11:47:09AM -0700, Colin Foster wrote:
> Thank you for laying this path out for me. Hopefully when I go
> heads-down to implement this there won't be any gotchas. It seems pretty
> straightforward.
> 
> Maybe my only question would be where to send these patches. If these
> can all go through net-next it seems like there'd be no issue when step
> 8 (add 7512 documentation) comes along with this current patch set.
> 
> Otherwise this sounds good. I'll switch to getting a patch set of steps
> 1-7 as you suggest.

I have some doubts whether it would be good to also merge net/dsa/mscc,ocelot.yaml
(i.e. the NXP variants) into net/mscc,vsc7514-switch.yaml. A few "if" statements
on compatible string which decide the format of "reg" and of "reg-names" should cover
the differences. Not sure how the end result will look like.
