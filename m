Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351A85FA401
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 21:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiJJTL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 15:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJJTL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 15:11:26 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B349B635C;
        Mon, 10 Oct 2022 12:11:25 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w10so17207110edd.4;
        Mon, 10 Oct 2022 12:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+RG/4rWr2Io1JrEQJ5IlfsShd0SpiopfiVrMk4/IvCI=;
        b=o/DfF+VXOR0Vp8DHbq9AcPEp2oyQfep+GnvqBOJ2gDZNGHelivd1jnC/VcrU0QwhbL
         7YSjFMszOq2qs1gCtoHuCAz1CljJeRo0tXmIEKswERKiksnK7QQK0zR21K4+WqXXyBLU
         X2M4k35AKTC1Y/z2JcDNR8isGAOQBASFIvPRw2u3Y+fvID84mSpeKOkNFyz9G2WSWvmw
         Hl6tNgV1ZJTkOnRv4ugHr64mFZkTQUsdvG0RlObrgOflJFr2N1Alx2TqBgvEiq9C+lHs
         twNPS0jv6cfjP/nFabbjKPE9FBUkz5sFpwEAGySaBxKySYgqR1R8eXtZZNoRMhVUHKhn
         YsKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+RG/4rWr2Io1JrEQJ5IlfsShd0SpiopfiVrMk4/IvCI=;
        b=A6regy9herW/gkL0X/gGXMA0i8ZUNOOzAs36yiU8i/lQ47xSOUmgUFST8FaGd1+VlP
         UM9I+ReKsiNpBvXRNn5NO9XteQzdbc7oOWamaGk9tUC0sffvGEbwJpUAaWx7D+qnCoMc
         Fuvj0oOihQGpoAC/FuCpd6dprzRAn2dF8s/pEkIHAzUFAOrE9aLX6Z7WXVy4z/Do5NAx
         wI/MXLHotaYLdB7FEFWEJOQsQGbH73sd7ih6mW7QS2dOLt13Q1y243TSEfcdhdVR0p6k
         nXQYPE/uQlFmm8+xqfjVTW3x7xPjqk85GDoGk2aNSxVOZfqvXzx5KEmc0f12sMk0NY9m
         9ZZw==
X-Gm-Message-State: ACrzQf2NrkFnIJ1aafJFypXl91tcWmFUF6XIqWzL+O/OgqQNMIcjDuwE
        O1bLktk1lA5lJIRv744u1zmo03z81HnFyA==
X-Google-Smtp-Source: AMsMyM7Y3ezQhXU9KxyPvca7iwwZzD9jVEwDXSWlTLEM+ZC3VTxHewwZ0V3AhLRezWAc63++ABviTw==
X-Received: by 2002:a05:6402:1587:b0:458:fbea:436c with SMTP id c7-20020a056402158700b00458fbea436cmr19208258edv.407.1665429084057;
        Mon, 10 Oct 2022 12:11:24 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id b1-20020a1709063ca100b007305d408b3dsm5727243ejh.78.2022.10.10.12.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 12:11:23 -0700 (PDT)
Date:   Mon, 10 Oct 2022 22:11:20 +0300
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
Message-ID: <20221010191120.cqbxkn6x25vjfwoy@skbuf>
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

Generally patches on dt-bindings go through the subsystem to which they
belong, for example net-next etc. I don't think there are other dependencies?
