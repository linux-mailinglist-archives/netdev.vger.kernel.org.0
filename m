Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD446B11F2
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 20:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjCHTXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 14:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbjCHTXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 14:23:12 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860623D08C;
        Wed,  8 Mar 2023 11:23:09 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso1819262wmo.0;
        Wed, 08 Mar 2023 11:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678303388;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4wtQRnwR5Mg8rvvMFL3tnEvl5qGz8ggKCs5aOpMnmKQ=;
        b=WY4Py3gy4Wb1Gf8TmeS2pdMIPyj5iXUzZ5Zorhj1v3ERciWeToD4eoX2S+Q381LHuH
         jtnw3IkoJUDuZbMKmM0ggNU7YFvLPFmFyzkqcTPioK1C45Vw9H5SnmQfvfV8h6qbyKNL
         U8VHukqFnR8sF0dBs4tVuxAjU/yOZ2QAv+A841mxfPFcHO/7mL4/IYO3tXLhdBvLElog
         lBP6AGLBo5GHZfyWb5CP9qNT7G2hyAgiW6GShMfLyssV0sY1X3fyMUi+bgeQTQOJKx0f
         ZJ1gyD1AWf5Ib2aJH7ZB3PLn2ORhVimz3urFHfbgrduzJ8D/3rC/xcf0OM1w838EyqZM
         bY0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678303388;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4wtQRnwR5Mg8rvvMFL3tnEvl5qGz8ggKCs5aOpMnmKQ=;
        b=h/6qxNgcuOOXqgW+yWWMskQPgRlSksnkUV/y++9O/jmb6PnZGSFZEJQnUtiRh5Wh4o
         CpKcftwKrXneb9pc76KPcBBqTQa4y2mDZRYEiWNyZmz28RMAU09eZ9uaPcnMYn1s+q6b
         oIjnEP9CJZZVbd9mSM+sSbMrfFH5VB2MlaSZJn4XpVuaHJ6cIzEWWHXmzqie8/rY3DcY
         O7dX9PgsHfWIauBHZxWCjDMduFmKusspNc7qMmIU2IC08rydzvh2rImfa1Y945YNRAIZ
         qT+CK3wLDCxocS7cMuHMQWfpPNleea+tYrT8yuQHPNcgBApK+a3HeBV2Gn0BvPMEIhWY
         8odQ==
X-Gm-Message-State: AO0yUKXkHoaPvTHmKTIP0LWPsxgCiUVwJuf1IBt1Tvrc8S5qr5PhxTNZ
        dhwmibjB7bnXbU2GzNYoWXI=
X-Google-Smtp-Source: AK7set8nW/rKm1sDbLXnRKDOIkYDxQtwQnWmrQKRlX2PVNHLoRzcZ3Zr/aqSaUe8vsW333owVqdLDA==
X-Received: by 2002:a05:600c:4448:b0:3dc:18de:b20d with SMTP id v8-20020a05600c444800b003dc18deb20dmr18376738wmn.33.1678303387685;
        Wed, 08 Mar 2023 11:23:07 -0800 (PST)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id r1-20020a05600c35c100b003dfe5190376sm315634wmq.35.2023.03.08.11.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 11:23:07 -0800 (PST)
Message-ID: <6408e09b.050a0220.e7ce5.1e98@mx.google.com>
X-Google-Original-Message-ID: <ZAjgidYdvOrN37Iu@Ansuel-xps.>
Date:   Wed, 8 Mar 2023 20:23:03 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH 09/11] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
 <20230307170046.28917-10-ansuelsmth@gmail.com>
 <ad43a809-b9fd-bd24-ee1a-9e509939023b@linaro.org>
 <df6264de-36c5-41f2-a2a0-08b61d692c75@lunn.ch>
 <5992cb0a-50a0-a19c-3ad1-03dd347a630b@linaro.org>
 <6408dbbb.1c0a0220.a28ce.1b32@mx.google.com>
 <36169a8a-d418-6d7e-b64c-a7c346b9a218@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36169a8a-d418-6d7e-b64c-a7c346b9a218@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 08:09:34PM +0100, Krzysztof Kozlowski wrote:
> On 08/03/2023 20:02, Christian Marangi wrote:
> > On Wed, Mar 08, 2023 at 07:49:26PM +0100, Krzysztof Kozlowski wrote:
> >> On 08/03/2023 14:57, Andrew Lunn wrote:
> >>> On Wed, Mar 08, 2023 at 11:58:33AM +0100, Krzysztof Kozlowski wrote:
> >>>> On 07/03/2023 18:00, Christian Marangi wrote:
> >>>>> Add LEDs definition example for qca8k Switch Family to describe how they
> >>>>> should be defined for a correct usage.
> >>>>>
> >>>>> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> >>>>
> >>>> Where is the changelog? This was v8 already! What happened with all
> >>>> review, changes?
> >>>
> >>> Did you read patch 0?
> >>>
> >>> We have decided to start again, starting small and working up. This
> >>> patchset just adds plain, boring LEDs. No acceleration, on hardware
> >>> offload. Just on/off, and fixed blink.
> >>
> >> Sure, but the patch is carried over. So what happened with all its
> >> feedback? Was there or was not? How can we know?
> >>
> > 
> > The history of the old series is a bit sad, not enough review, another
> > dev asking for a different implementation and me doing an hybrid to
> > reach a common point (and then disappear intro oblivion)...
> > 
> > Short story is that this current series have nothing related to the HW
> > offload feature and only in v7 it was asked to put the LED nodes in
> > ethernet-phy.yaml
> > 
> > I can put in the cover letter of v2 of this series the changelog of the
> > previous series but they would only be related to other part that are
> > not related to this.
> > 
> > Just to give you some context and explain why the changelog was dropped.
> 
> I am less interested in the changelog of entire patchset but of the
> patches which are for me to review. Sending vX as v1 suggests that all
> previous review work on this patch could be in some limbo state. Maybe
> nothing happened in all previous version, but it's now my task to dig it?
> 

OK, if you are intrested only on the DT changes I can list:
From v0 to v6:
- There was only qca8k Documentation addition for the leds node.
  Some extra binding were dropped due to implementation change but they
  were only specific to qca8k.

In v7:
- The default-trigger for netdev was introduced (this caused some
  warning for missing netdev trigger for that binding)
- It was suggested and asked to make the LEDs generic and add
  Documentration for phy-ethernet.yaml

In v8:
- The netdev trigger was added to the list of accepted default-trigger
- The Documentation for phy-ethernet.yaml was added

Then we decided to "reboot" the series and:
In v1:
- The default-trigger is dropped (will be introduced later when the work
  for the netdev trigger will be done)
- We use the default state to "keep"

This should be the entire changelog excluding some changed things done
from v0 to v6 with low review and implementation changed at least 3
times during the life of that series.


> This is why you have "---" for the patch changelog.

-- 
	Ansuel
