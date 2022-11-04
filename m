Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2261619DDD
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 17:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbiKDQxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 12:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbiKDQx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 12:53:26 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFB3FD20;
        Fri,  4 Nov 2022 09:52:35 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id l11so8491694edb.4;
        Fri, 04 Nov 2022 09:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t+deqpnlgE4k94JlPSRYO/kA8EcF5g1y8pAznEO26RU=;
        b=jAdMpVKzUAocTJEhTayND/WRxtbwYR7FxW/esiAISPNU8jLqXM4f9hLZZuAzjNGOdR
         Mix+PT2bluqmyx0xKD6yDMdlcrrrccKWNfwgyOcy6ud2+imlMqxrorJyXzFfd7Rv77Z4
         HOiLQd6KJ2/EYTAmPVNTuqhQAv1xK8YGqJQIstSFlTBWs56t1njHpP/KYPCAa/VjOg4F
         OC5Y3hx/QJ/6JPrRYq+s9Kzjoi7ar+fduB9mBcrrDG0S8VEu7/9Nbw2yQ/5p/dP2odxu
         twHGAR74YgznXZNHpAekukBSMnMi7vfkBYfMfYlr5x/c7YgxrcMoI5LkMrHgFAAW+jRD
         KUJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t+deqpnlgE4k94JlPSRYO/kA8EcF5g1y8pAznEO26RU=;
        b=GqcAyzaaN/KvUZ4OiW8KN1/D+qLJzsR9UWwvrLjV0gd/Nz8rg41TlYbVOZbSPGBb3K
         6PBKXe66dD3kaly1YdmEh44Ru58iMieVsez9FFqfQ44KgWiyOA40HaTwo2gSsFSof+tx
         v9cPRSIay9XDinIj0qLhv7f89ObFdAFc0wwqbOJbiEATEl3TSWVKQ50stntrGzcFuEHQ
         botDGYPa/P78LUObF8njucZMMlDfl52+wuioss5E2ikFJpa41tvoSh4d8dFILf0pmySr
         6geQRn1RbWTUytWBHL5bj4nNVxALHP33lmPduwEFvsSC5X9ukoETbQfK2GP+/wi3+sd7
         Ddfg==
X-Gm-Message-State: ACrzQf1AVF/klgLHEooNh7l6lHevoMlH2S4iqNnhD5DbMjFIynBGJ4LV
        sjIdK2eO5t7JEVkC+L+o5DU=
X-Google-Smtp-Source: AMsMyM6NghwZqic9dEd0iDrIUc0kYTKpCDsesPPB3KcvH6ZFGCrjk6WaPucNY8qebBMo5AzGApRAIQ==
X-Received: by 2002:a05:6402:3c2:b0:464:61f5:6d86 with SMTP id t2-20020a05640203c200b0046461f56d86mr5121297edw.382.1667580753572;
        Fri, 04 Nov 2022 09:52:33 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id f3-20020a056402004300b004611c230bd0sm2162551edu.37.2022.11.04.09.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 09:52:33 -0700 (PDT)
Date:   Fri, 4 Nov 2022 18:52:30 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
Message-ID: <20221104165230.oquh3dzisai2dt7e@skbuf>
References: <20221102185232.131168-1-krzysztof.kozlowski@linaro.org>
 <20221103233319.m2wq5o2w3ccvw5cu@skbuf>
 <698c3a72-f694-01ac-80ba-13bd40bb6534@linaro.org>
 <20221104020326.4l63prl7vxgi3od7@skbuf>
 <6056fe63-26f8-bbda-112a-5b7cf25570ad@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6056fe63-26f8-bbda-112a-5b7cf25570ad@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 09:09:02AM -0400, Krzysztof Kozlowski wrote:
> > I think that spi-cpha/spi-cpol belongs to spi-peripheral-props.yaml just
> > as much as the others do.
> > 
> > The distinction "device specific, not controller specific" is arbitrary
> > to me. These are settings that the controller has to make in order to
> > talk to that specific peripheral. Same as many others in that file.
> 
> Not every fruit is an orange, but every orange is a fruit. You do not
> put "color: orange" to schema for fruits. You put it to the schema for
> oranges.
> 
> IOW, CPHA/CPOL are not valid for most devices, so they cannot be in
> spi-peripheral-props.yaml.

Ok, then this patch is not correct either. The "nxp,sja1105*" devices
need to have only "spi-cpha", and the "nxp,sja1110*" devices need to
have only "spi-cpol".
