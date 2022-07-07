Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB6256ADF4
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 23:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236179AbiGGVtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 17:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236155AbiGGVs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 17:48:58 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53781D310
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 14:48:56 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id g1so17129408edb.12
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 14:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/5XOo443fdG2r9vIFuhWNwgNadDYwuAtZkD38lSSYgM=;
        b=XHChHwfiRysKOLDGMw5YWBoawDhJKqzbIhB+sBOifSzmsWuFfJge7mU4bff9V6EeVy
         usCdhQ3S8JonXCI1GpL1eERdtzP7Oql4TkpQzrg9+hPZ27KKXj+tbZs3TZQH1i6fQgF2
         MRSBjEFGq0PN3exCY7EJnPZhWHCyBAsND/sD15BewmPOYC+M0RoiSETSgwY1oP5BNDkM
         UXar2K+UrRqwBgOd8IqVW24IlNPrOrKYE7W2a+JgYAMCX+Po2JDONK47kNwYPxICoHFM
         PBOHBTbbkueXX7eVn61yiuNzAb8u0TkjCTZXpFbA2r7K/Awg67GnBRPv/cgMvR1HQl74
         lNMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/5XOo443fdG2r9vIFuhWNwgNadDYwuAtZkD38lSSYgM=;
        b=z0II7Z5xmSjSs0mNGfLBzlIefMOQ9QpmdlUrKMiVlLVsHlmeVCa9zMAHbV1ckhXIZz
         h3XmJZFeYCnvo/K+oqQrqD3541YDAcSEf+QGGQGo6ScFWV/PEHhxCNrAb4ELUOaFPJkh
         R6rvSiypTU7s4ikUgT0wIU6WXJQ9X5VA9Gzi0PZPihx20rf5IE+dM0bXx+J1FdCMer90
         LiVulbd7sHntz8ibGgyxaxg1WjvULkCELBR9T5U6PyYa+XqDKsrEyfEXszqmpn6XpUYe
         2hIkdbYuSfuKyihTJ9LUEpt4XEXLtWgUCFpaAJOd5aDT9rN7e2X5Q7FV1P5J06rOBGIB
         AizQ==
X-Gm-Message-State: AJIora9RtNjYtHMsAdBcKorh4VToelYLF7Lt2+A99WwtoYlUSGrMdq5R
        0rE7Igu203GrEu8nqfOMtiM=
X-Google-Smtp-Source: AGRyM1sxrHAgTBk1n9lxvYqVtjilIRy9LJx6b5rnBe89LCuUvdwpr/ODuQ4kjGmJWc3uG8zLiFxCfg==
X-Received: by 2002:a05:6402:5508:b0:43a:896e:8edd with SMTP id fi8-20020a056402550800b0043a896e8eddmr265487edb.203.1657230535246;
        Thu, 07 Jul 2022 14:48:55 -0700 (PDT)
Received: from skbuf ([188.25.231.143])
        by smtp.gmail.com with ESMTPSA id r9-20020a17090609c900b006fecf74395bsm924956eje.8.2022.07.07.14.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 14:48:54 -0700 (PDT)
Date:   Fri, 8 Jul 2022 00:48:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Subject: Re: [PATCH RFC net-next 5/5] net: dsa: always use phylink for CPU
 and DSA ports
Message-ID: <20220707214852.jbfpww5ynkuunc5d@skbuf>
References: <E1o8fA7-0059aO-K8@rmk-PC.armlinux.org.uk>
 <20220706102621.hfubvn3wa6wlw735@skbuf>
 <YsW3KSeeQBiWQOz/@shell.armlinux.org.uk>
 <Ysaw56lKTtKMh84b@shell.armlinux.org.uk>
 <20220707152727.foxrd4gvqg3zb6il@skbuf>
 <YscAPP7mF3KEE1/p@shell.armlinux.org.uk>
 <20220707163831.cjj54a6ys5bceb22@skbuf>
 <YscUwrPnBZ3dzpQ/@shell.armlinux.org.uk>
 <20220707193753.2j67ni3or3bfkt6k@skbuf>
 <YsdA0jcRCzR0c728@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsdA0jcRCzR0c728@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 09:23:46PM +0100, Russell King (Oracle) wrote:
> > > I'm not sure how practical that is when we have both DT and ACPI to deal
> > > with, and ACPI is certainly out of my knowledge area to be able to
> > > construct a software node to specify a fixed-link. Maybe it can be done
> > > at the fwnode layer? I don't know.
> > 
> > I don't want to be misunderstood. I brought up software nodes because
> > I'm sure you must have thought about this too, before proposing what you
> > did here. And unless there's a technical reason against software nodes
> > (which there doesn't appear to be, but I don't want to get ahead of
> > myself), I figured you must be OK with phylink absorbing the logic, case
> > in which I just don't understand why you are pushing back on a proposal
> > how to make phylink absorb the logic completely.
> 
> The reason I hadn't is because switching DSA to fwnode brings with it
> issues for ACPI, and Andrew wants to be very careful about ACPI in
> networking - and I think quite rightly. As soon as one switches from
> DT APIs to fwnode APIs, you basically permit people an easy path to
> re-use DT properties in ACPI-land without the ACPI issues being first
> considered.
> Yep - there's at least one other property we need to carry over from the
> DT node, which is the "ethernet" property.

I've cropped only these segments because there is something I apparently
need to highlight. What my patch does is _not_ at the device fwnode
level (in fact, DSA ports do not have a struct device, only the switch does),
but indeed at the most crude fwnode_handle level. And the fwnode_handles
I'm creating using the software_node API are not connected in any way
with the device. I'm not replacing the device's fwnodes with prosthetic
ones. The fact that I wrote "dn->fwnode.secondary = new_port_fwnode;" is
just a cheap hack to minimize the patch delta so I wouldn't have to
transport the software fwnode_handle from one place to another within
dsa_port_link_register_of(). This should definitely dissapear in the
final solution. In fact, as long as phylink doesn't keep a reference on
the fwnode after phylink_create() or phylink_fwnode_phy_connect(), I'm
pretty sure that the software node can even be deallocated during the
probing stage, no need to keep it for the entire lifetime of the device.

Therefore, no, we don't need the "ethernet" phandle in the software node
we create, because we just use that to pass it to phylink. We still keep
our original OF node for the rest of the activities. We don't even need
the "reg" u32 property, I just added that for no reason (I wasn't
completely sure what the API offers, then I didn't remove it).

So the concern that this software node can be abused for a transition to
ACPI is quite overestimated. Nothing in DSA is "switched to fwnode" per se,
and the creation of a fwnode is just part of "speaking the software node
language", which phylink already happily understands and so, needs no
change. Just my 2 cents.
