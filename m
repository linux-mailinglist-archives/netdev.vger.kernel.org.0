Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B233C5FA2E7
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 19:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiJJRtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 13:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJJRtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 13:49:02 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4670419A1;
        Mon, 10 Oct 2022 10:49:01 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id a67so7577255edf.12;
        Mon, 10 Oct 2022 10:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O4+QADBZkaIFq0lDPLVSz22x8suuy3sLKpvJ7JaHySc=;
        b=pjMaRbWTwZl/70leVH3XXmTHWUuSbFxXeW38k4ih91f/ezwk9ilGJFVj6tergDok4V
         51UGhRGl//6gnu3QIplid3c5kTw2xW8rA0eIoiiWpBXFM5nwc9qppPdsF+CXMlzy7fRL
         4fOT5JAgscRPKFPOAFmw0i9DtcxTaQbCpToXOe7FyTgZzUidDNqaak36wxRUstetbM8i
         CK5t7H1QmjbBrUIpEQfxxhXaneIt89zNme8I0X9ktXqw13slhJQB0K/oPzTti8E3kpFZ
         XDzG2kg2xr5w9TAInWQOLFFgxdzzU4ZyX+71ZnMacHVk7HPkUHAxl6lW2lvTTbtvUhJj
         rR5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O4+QADBZkaIFq0lDPLVSz22x8suuy3sLKpvJ7JaHySc=;
        b=goPc1Pfal7CgrnrYDxtl/UjTzYhKO2NBjYjsSgTM8TppXkJPS9O/KtKOu62yAeNpO5
         5JFWcJphl/irgA4M1nd1He9Juv3+GG0ZdQenA3hGfFF4opyhDcPCpLI7Q3fZ2/0L0k9j
         +haj3cQ9PJo91CYWqYLaqMVitUy45u/mGVNJdGfMj9oWkq6AKoYDwTSOFEUjNSoCGJkD
         yBFO2VK0GpwEpqs6yGhmqdpfc+hjhSAcCegb2AOKHJVYHUoNJBGvrR+5F28WZntFrh8w
         2ocrEAmcRYal71tjigiuB5J/qEryFN2N2Ze7FA0xC8rPJe8s7VFcZ559pIULuvaq/wzH
         4Trw==
X-Gm-Message-State: ACrzQf2QJzb9/PGWjQlbHqGk1p5/rl9fiqsxIuEFoezRc2co77KJR5Yd
        A0lvIg1EZRAVqL7r2ZF2yDs=
X-Google-Smtp-Source: AMsMyM6CvzWcVTe2IsqK1Cvc3K+ivclMAcjjzwmwfiXT4yy25gTT+lMTgnkuFFhWvXm1Uc2XlbjJzw==
X-Received: by 2002:a05:6402:14c9:b0:459:1a5b:6c47 with SMTP id f9-20020a05640214c900b004591a5b6c47mr19336861edx.426.1665424139953;
        Mon, 10 Oct 2022 10:48:59 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id la14-20020a170907780e00b0078d4962a46bsm5620821ejc.190.2022.10.10.10.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 10:48:59 -0700 (PDT)
Date:   Mon, 10 Oct 2022 20:48:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
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
Message-ID: <20221010174856.nd3n4soxk7zbmcm7@skbuf>
References: <20220926002928.2744638-13-colin.foster@in-advantage.com>
 <ec63b5aa-3dec-3c27-e987-25e36b1632ba@linaro.org>
 <YzzLCYHmTcrHbZcH@colin-ia-desktop>
 <455e31be-dc87-39b3-c7fe-22384959c556@linaro.org>
 <Yz2mSOXf68S16Xg/@colin-ia-desktop>
 <28b4d9f9-f41a-deca-aa61-26fb65dcc873@linaro.org>
 <20221008000014.vs2m3vei5la2r2nd@skbuf>
 <c9ce1d83-d1ca-4640-bba2-724e18e6e56b@linaro.org>
 <20221010130707.6z63hsl43ipd5run@skbuf>
 <d27d7740-bf35-b8d4-d68c-bb133513fa19@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d27d7740-bf35-b8d4-d68c-bb133513fa19@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 09:37:23AM -0400, Krzysztof Kozlowski wrote:
> What stops you from doing that? What do you need from me?

To end the discussion on a constructive note, I think if I were Colin,
I would do the following, in the following order, according to what was
expressed as a constraint:

1. Reword the "driver" word out of mscc,vsc7514-switch.yaml and express
   the description in terms of what the switch can do, not what the
   driver can do.

2. Make qca8k.yaml have "$ref: dsa.yaml#". Remove "$ref: dsa-port.yaml#"
   from the same schema.

3. Remove "- $ref: dsa-port.yaml#" from mediatek,mt7530.yaml. It doesn't
   seem to be needed, since dsa.yaml also has this. We need this because
   we want to make sure no one except dsa.yaml references dsa-port.yaml.

4. Move the DSA-unspecific portion from dsa.yaml into a new
   ethernet-switch.yaml. What remains in dsa.yaml is "dsa,member".
   The dsa.yaml schema will have "$ref: ethernet-switch.yaml#" for the
   "(ethernet-)switch" node, plus its custom additions.

5. Move the DSA-unspecific portion from dsa-port.yaml into a new
   ethernet-switch-port.yaml. What remains in dsa-port.yaml is:
   * ethernet phandle
   * link phandle
   * label property
   * dsa-tag-protocol property
   * the constraint that CPU and DSA ports must have phylink bindings

6. The ethernet-switch.yaml will have "$ref: ethernet-switch-port.yaml#"
   and "$ref: dsa-port.yaml". The dsa-port.yaml schema will *not* have
   "$ref: ethernet-switch-port.yaml#", just its custom additions.
   I'm not 100% on this, but I think there will be a problem if:
   - dsa.yaml references ethernet-switch.yaml
     - ethernet-switch.yaml references ethernet-switch-port.yaml
   - dsa.yaml also references dsa-port.yaml
     - dsa-port.yaml references ethernet-switch-port.yaml
   because ethernet-switch-port.yaml will be referenced twice. Again,
   not sure if this is a problem. If it isn't, things can be simpler,
   just make dsa-port.yaml reference ethernet-switch-port.yaml, and skip
   steps 2 and 3 since dsa-port.yaml containing just the DSA specifics
   is no longer problematic.

7. Make mscc,vsc7514-switch.yaml have "$ref: ethernet-switch.yaml#" for
   the "mscc,vsc7514-switch.yaml" compatible string. This will eliminate
   its own definitions for the generic properties: $nodename and
   ethernet-ports (~45 lines of code if I'm not mistaken).

8. Introduce the "mscc,vsc7512-switch" compatible string as part of
   mscc,vsc7514-switch.yaml, but this will have "$ref: dsa.yaml#" (this
   will have to be referenced by full path because they are in different
   folders) instead of "ethernet-switch.yaml". Doing this will include
   the common bindings for a switch, plus the DSA specifics.

9. Optional: rework ti,cpsw-switch.yaml, microchip,lan966x-switch.yaml,
   microchip,sparx5-switch.yaml to have "$ref: ethernet-switch.yaml#"
   which should reduce some duplication in existing schemas.

10. Question for future support of VSC7514 in DSA mode: how do we decide
    whether to $ref: ethernet-switch.yaml or dsa.yaml? If the parent MFD
    node has a compatible string similar to "mscc,vsc7512", then use DSA,
    otherwise use generic ethernet-switch?

Colin, how does this sound?
