Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60AA5F80FC
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 00:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiJGWsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 18:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiJGWsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 18:48:25 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E4511C27C;
        Fri,  7 Oct 2022 15:48:13 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id o21so14129692ejm.11;
        Fri, 07 Oct 2022 15:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fJDQxjYM1KZNjTuhU3CIC9yELCWgPJ3RRsqUfE7thb4=;
        b=XJ581ZUsegVtmZCBO3f8b+PLbnMfgJl0xkktEvW2S/5nfxBuA7CnP6k5XoUOGIf467
         G8B8As32VLppyAZmWFAfH/L0FqdsLYq7F8HnuePzISQcX9jkmKOwZKPngO46R+xHRP36
         tWdRJZBYtuyB5VecepH6jwO2CrMu+4D34VVNOQU0bb2kC+iG40demSUsMDInuYWcI8Lo
         MwiC1Bj3UPGVelh1atfvuttBF8Av9yqZYcMBuT92jCIeeOWwqlbw5VWrioevg+rTRvrw
         771fLaaD/d356gS1+jnPbuVCtLYyYwwBrdsJbUO6CMvleAu6C++XxdGDsxsVVkzStWIT
         nyXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fJDQxjYM1KZNjTuhU3CIC9yELCWgPJ3RRsqUfE7thb4=;
        b=R3H48Wrs8C0YVQbEQZsMlUOyZkHB9zOv7VOjZlg4YNMIar0nbGmhV0eXqe/CFUjEuE
         3bMF1JejEPFUj63IXGRQ5IbWz65T6kZ8ErreGtBvN2JQz64VuD9XcpgzUius8AWI14k3
         oyNZ8/K3EpYXGnKgy3LSa455gRt3eEP67IPaPzDvAM9niWmMLf9ehWmKJLTXQjSpjZGp
         ludez+qvkPF5fubJs5EFX/SboETiGNKgIq81e3yg5AYYH3J6IADwRBT5iaqm/KDywT4P
         EK6wJXOu09p1Zy/H76NgKPcPodKS+LFe/IhbDZz00QQ/EX4sANDYs2YRH7yvyRjkgt5T
         29vQ==
X-Gm-Message-State: ACrzQf03sGDsmGiNtQEPRgMOLi14Uze9KKRB+D1+0CWVzYy2f1hBSyse
        11+48KGt1UupxO1JPsK2rDk=
X-Google-Smtp-Source: AMsMyM5u9idp1WGwqZ+ohxM42s/jR9JQylMJtbPdybnGyMhq9l+rQdd6Ikr1qeu0NW1UM8ObI4to2w==
X-Received: by 2002:a17:906:6a2a:b0:782:35ca:c2bc with SMTP id qw42-20020a1709066a2a00b0078235cac2bcmr5825958ejc.556.1665182891568;
        Fri, 07 Oct 2022 15:48:11 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id a19-20020a509b53000000b004590b29d8afsm2257363edj.84.2022.10.07.15.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 15:48:10 -0700 (PDT)
Date:   Sat, 8 Oct 2022 01:48:08 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
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
Message-ID: <20221007224808.dgksesjbiptwmqj7@skbuf>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
 <20220927202600.hy5dr2s6j4jnmfpg@skbuf>
 <YzN3P6NaDhjA1Qrk@colin-ia-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzN3P6NaDhjA1Qrk@colin-ia-desktop>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 03:20:47PM -0700, Colin Foster wrote:
> > The mfd driver can use these resources or can choose to ignore them, but
> > I don't see a reason why the dt-bindings should diverge from vsc7514,
> > its closest cousin.
> 
> This one I can answer. (from November 2021). Also I'm not saying that my
> interpretation is correct. Historically when there are things up for
> interpretation, I choose the incorrect path. (case in point... the other
> part of this email)
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20211125201301.3748513-4-colin.foster@in-advantage.com/#24620755
> 
> '''
> The thing with putting the targets in the device tree is that you're
> inflicting yourself unnecessary pain. Take a look at
> Documentation/devicetree/bindings/net/mscc-ocelot.txt, and notice that
> they mark the "ptp" target as optional because it wasn't needed when
> they first published the device tree, and now they need to maintain
> compatibility with those old blobs. To me that is one of the sillier
> reasons why you would not support PTP, because you don't know where your
> registers are. And that document is not even up to date, it hasn't been
> updated when VCAP ES0, IS1, IS2 were added. I don't think that Horatiu
> even bothered to maintain backwards compatibility when he initially
> added tc-flower offload for VCAP IS2, and as a result, I did not bother
> either when extending it for the S0 and S1 targets. At some point
> afterwards, the Microchip people even stopped complaining and just went
> along with it. (the story is pretty much told from memory, I'm sorry if
> I mixed up some facts). It's pretty messy, and that's what you get for
> creating these micro-maps of registers spread through the guts of the
> SoC and then a separate reg-name for each. When we worked on the device
> tree for LS1028A and then T1040, it was very much a conscious decision
> for the driver to have a single, big register map and split it up pretty
> much in whichever way it wants to. In fact I think we wouldn't be
> having the discussion about how to split things right now if we didn't
> have that flexibility.
> '''
> 
> I'm happy to go any way. The two that make the most sense might be:
> 
> micro-maps to make the VSC7512 "switch" portion match the VSC7514. The
> ethernet switch portion might still have to ignore these...
> 
> A 'mega-map' that would also be ignored by the switch. It would be less
> arbitrary than the <0 0> that I went with. Maybe something like
> <0x70000000 0x02000000> to at least point to some valid region.

A mega-map for the switch makes a lot more sense to me, if feasible
(it should not overlap with the regions of any other peripherals).
Something isn't quite right to me in having 20 reg-names for a single
device tree node, and I still stand for just describing the whole range
and letting the driver split it up according to its needs. I don't know
why this approach wasn't chosen for the ocelot switch and I did not have
the patience to map out the addresses that the peripherals use in the
Microchip SoCs relative to each other, so see if what I'm proposing is
possible.

But on the other hand this also needs to be balanced with the fact that
one day, someone might come along with a mscc,vsc7514-switch that's SPI
controlled, and expect that the dt-bindings for it in DSA mode expect
the same reg-names that they do in switchdev mode. Or maybe they
wouldn't expect that, I don't know. In any case, for NXP switches I
didn't have a compatibility issue with switchdev-mode Ocelot to concern
myself with, so I went with what made the most sense.
