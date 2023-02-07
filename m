Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D9468CFC9
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 07:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjBGGtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 01:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjBGGtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 01:49:42 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316D6298D9
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 22:49:41 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id cr11so10083465pfb.1
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 22:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o/CSckEZneREzc3kHdu+J2V8qJBWUsoyPtYrVkjFwzw=;
        b=C+5Ke/dVYng9xNOxfIb7Bl2YdIxdAFsoCC+OHbabOrEGBsvxTP/wtrmxzcLbIEvWlY
         050mjkwkuB626xi+GO/4+95ANuVQN5GUBhUrTlSJrYtsd1RSL+TETEtGYKb841badoo7
         LqT89HDljGkRKpaAXFodNrBN3iTSo0zT0nmmzZkX+SsyKXlgZhuHb8J+BjRDy3jnu5AW
         nKuZGcoIdonMIcFlk1HpBacf8shtAPfNp3fPsBfi9QNuug6A2E/igUKJpcR/hWOOEp9B
         RPxUrZZrwIVm2UBFJpjP33zjGa6Zf+tjN2xJNPb9Avtji18vizwPYHTDQrh1SwOgHcys
         84JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o/CSckEZneREzc3kHdu+J2V8qJBWUsoyPtYrVkjFwzw=;
        b=vLSgnZhHnMdhGDUn/Chg8fk3w0TDIcofszGce2dgecIp+BdFRTJLVKfs5IIZpwQFW4
         NFt4GXwOeFL13TtN2oIWq+O5t3xHjEx68ksXKCsTv8XN2ZZlXF0yqU/tseQjmwgmh70l
         3Z1dzdQWFnCaKMvUYnPaj0b3Yeg9vmQnXSeKuSqbIzEGZFpXDZGFPBfyKBqwLqzOJVxU
         j9xeN0veWE53NmKomK+HuXZeZu9pKrgPqgkfQnkvH0dvbKntnWm2zxyOx4vZgiIiPmqr
         S+ag2/o7wFN8/Ea+x6M2oJSec414vJcvAzO4dVpdH4WpY+01uuE2/jRuEsJdrPDQ6daz
         o17Q==
X-Gm-Message-State: AO0yUKUoXWAuzFI+mtpAKpIxhliIUw6ECNQVHyCG6yTaI0b3HGoLyCnX
        tzzjzbNnXb0zTgvCQbHedrB4Jz+P2QvR1Tk+Rfs0tQ==
X-Google-Smtp-Source: AK7set+lSF6h4ihqXMsgGagqqFaj6yB78FXTHOazJ1c86xZkVfF7VhvjVOu5aO/JI9I3OprkBFQIP9PiP+HGMh6pZ9s=
X-Received: by 2002:aa7:8ede:0:b0:590:7829:f566 with SMTP id
 b30-20020aa78ede000000b005907829f566mr490179pfr.50.1675752580282; Mon, 06 Feb
 2023 22:49:40 -0800 (PST)
MIME-Version: 1.0
References: <20221222134844.lbzyx5hz7z5n763n@skbuf> <4263dc33-0344-16b6-df22-1db9718721b1@linaro.org>
 <20221223134459.6bmiidn4mp6mnggx@skbuf>
In-Reply-To: <20221223134459.6bmiidn4mp6mnggx@skbuf>
From:   Saravana Kannan <saravanak@google.com>
Date:   Mon, 6 Feb 2023 22:49:03 -0800
Message-ID: <CAGETcx8De_qm9hVtK5CznfWke9nmOfV8OcvAW6kmwyeb7APr=g@mail.gmail.com>
Subject: Re: Advice on MFD-style probing of DSA switch SoCs
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lee Jones <lee@kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 23, 2022 at 5:44 AM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> On Fri, Dec 23, 2022 at 09:44:14AM +0100, Krzysztof Kozlowski wrote:
> > just trim the code... we do not need to scroll over unrelated pieces.
>
> ok
>
> > > However, the irq_domain/irqchip handling code in this case will go to
> > > drivers/net/dsa/, and it won't really be a "driver" (there is no struct
> >
> > Why? Devicetree hierarchy has nothing to do with Linux driver hierarchy
> > and nothing stops you from putting irqchip code in respective directory
> > for such DT. Your parent device can be MFD, can be same old DSA switch
> > driver etc. Several options.

Hi Vladimir,

I stumbled onto this thread when searching for some old emails between
us to refresh my memory on fw_devlink + DSA issues.


>
> True, in fact I've already migrated in my tree the drivers for
> nxp,sja1110-base-tx-mdio and nxp,sja1110-base-t1-mdio (which in the
> current bindings, are under ethernet-switch/mdios/mdio@N) to dedicated
> platform drivers under drivers/net/mdio/. The sja1105 driver will have
> to support old bindings as well, so code in sja1105_mdio.c which
> registers platform devices for MDIO nodes for compatibility will have to
> stay.
>
> But I don't want to keep doing that for other peripherals. The irqchip
> is not a child of the ethernet-switch, not in any sense at all. The
> ethernet-switch even has 2 IRQ lines which need to be provided by the
> irqchip, so there would be a circular dependency in the device tree
> description if the ethernet-switch was the parent.

I'm glad you are looking into this and agree how IRQ controllers are
independent of the rest of the ethernet-switch, etc.

> fw_devlink doesn't really like that, and has been causing problems for
> similar topologies with other DSA switches. There have been discussions
> with Saravana Kannan, and he proposed introducing a FWNODE_FLAG_BROKEN_PARENT
> flag, that says "don't create device links between a consumer and a
> supplier, if the consumer needs a resource from the supplier to probe,
> and the supplier needs to manually probe the consumer to finish its own
> probing".
> https://patchwork.kernel.org/project/netdevbpf/cover/20210826074526.825517-1-saravanak@google.com/

It did land as FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD and it's used for
PHYs. But yeah, it's not a great long term solution.

> That patch didn't really go anywhere to my knowledge, but I'd prefer to
> sidestep all that discussion about what constitutes a broken parent and
> what doesn't, and here, introducing an irqchip driver which is a fwnode
> child of the ethernet-switch driver seems like a big mistake, given past
> experience.

IMHO, the DSA is a logical device that's made up of many different
pieces of real hardware IP. IMHO an ideal solution would be something
like a dsa_bus type where we add a dsa_device. The dsa_device will
list all the necessary devices (IRQ, PHY, MDIO, etc -- they can be
wherever they want in DT) as its suppliers and when the dsa_device is
probed, it can assume all its suppliers are present and then do the
DSA initialization.

This would also solve the PHYs problem you stated earlier. So,
basically you'd move some of the dsa initialization code into the
dsa_probe() function of the dsa_bus.

Hope I'm making some sense. Let me know if you want to discuss this
further and I can try and provide more context and details.

Also, there's already a driver core feature that does just this --
component devices -- but the implementation is old and not so great
IMHO. Component device model can be done better using device links. I
want to refactor the component device framework to use device links,
but that's a problem for another time.

-Saravana
