Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC16257A637
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 20:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiGSSMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 14:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239935AbiGSSLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 14:11:45 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E445E308;
        Tue, 19 Jul 2022 11:11:19 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id mf4so28737690ejc.3;
        Tue, 19 Jul 2022 11:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oFQ5ZoRQ7xPvEwHpT6dAI/Y5WSqaXBBPZHaMSxK+Pcw=;
        b=k7cidDMqq4R9oKOShik+Ajeb6Eb7qxkxuepRuZ3cwNVjjVnas8OG5VYKHSMBO2/X7t
         WLT0xAL5Zn+l/+bmIEXnyt5y9VYk+91PrjKoEGQ0OZCLg1y6O1/ZLTsFQoePt84MUqze
         smT6BeYNwVU8u60qtdZjuljctDReYPEaQgmabWuSW2ucNepkYMPo5xO3duqRnkIgh7lc
         kj/UmBovaggwwiIZOvlqXyQ4ZbU3G0C8kEbV8LtdIeDh5Xc/Si923Nw4hLvD8mFoQC8B
         8uysVk+KVZTYFAT3NxHpLUGluI0NgqGdo/0tcuaVuMy1NfTxzs9pjcXPBEFtTinhPcH4
         jg5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oFQ5ZoRQ7xPvEwHpT6dAI/Y5WSqaXBBPZHaMSxK+Pcw=;
        b=RR4m8bFRQG9KvKXpVSHO/kfXLmKKniC2csvUkOoSR5QK8yW85jA/XEgayXh4sU/aNw
         +uoLZGpyfMRF5n0KlcnsJ3m9rS6zWXkkdNUuzoiG6RC0c85I1YEhRlFN4+PUD0gKJ7PG
         q8FEmSoDg5CU8o+w45HY1+zskxZxdiYeMLKgZC+WN96w83aP5kRL1H1KQOIoSWtMiQ35
         MYVHmWAxdwK3BTDNFJwipytUIhmBP1STUq8pNDZU9HIFD4Yjxed1Lty60DW1ESmZJTM6
         ZrLBqbnqMdK66PCnIC3PWO+hyGEhNY07/1cnhOG6Y0fzTskQw2PYWjlzBuF6VdENN2j4
         rsJA==
X-Gm-Message-State: AJIora+Hyzf41sOGQ2MW7PTSpd54TKsdUGW+ZP38hH3eV+hmqY52+60u
        GgXLo8rW1ergUn1U6fDrQ7c=
X-Google-Smtp-Source: AGRyM1vrzPMh3dqrjGlhh3PwAnXW4KQokX/IMs0HL8VvNPn0GxhvoxzZ3J4dVwz2x5GzvwSBHdZVLA==
X-Received: by 2002:a17:907:7b92:b0:72b:67fb:8985 with SMTP id ne18-20020a1709077b9200b0072b67fb8985mr30618389ejc.569.1658254277894;
        Tue, 19 Jul 2022 11:11:17 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id n17-20020a170906089100b006fe0abb00f0sm6911930eje.209.2022.07.19.11.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 11:11:17 -0700 (PDT)
Date:   Tue, 19 Jul 2022 21:11:13 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Shawn Guo <shawnguo@kernel.org>, UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH net-next 0/9] net: pcs: Add support for devices
 probed in the "usual" manner
Message-ID: <20220719181113.q5jf7mpr7ygeioqw@skbuf>
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220719152539.i43kdp7nolbp2vnp@skbuf>
 <bec4c9c3-e51b-5623-3cae-6df1a8ce898f@seco.com>
 <20220719153811.izue2q7qff7fjyru@skbuf>
 <2d028102-dd6a-c9f6-9e18-5abf84eb37a1@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d028102-dd6a-c9f6-9e18-5abf84eb37a1@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 11:46:23AM -0400, Sean Anderson wrote:
> I'm saying that patches 4 and 5 [1] provide "...a working migration
> path to [my] PCS driver model." Since enetc/ocelot do not use
> devicetree for the PCS, patch 9 should have no effect.
> 
> That said, if you've tested this on actual hardware, I'm interested
> in your results. I do not have access to enetc/ocelot hardware, so
> I was unable to test whether my proposed migration would work.
> 
> --Sean
> 
> [1] I listed 6 but it seems like it just has some small hunks which should have been in 5 instead

Got it, thanks. So things actually work up until the end, after fixing
the compilation errors and warnings and applying my phy_mask patch first.
However, as mentioned by Russell King, this patch set now gives us the
possibility of doing this, which happily kills the system:

echo "0000:00:00.5-imdio:03" > /sys/bus/mdio_bus/drivers/lynx-pcs/unbind

For your information, pcs-rzn1-miic.c already has a device_link_add()
call to its consumer, and it does avoid the unbinding problem. It is a
bit of a heavy hammer as Russell points out (a DSA switch is a single
struct device, but has multiple net_devices and phylink instances, and
the switch device would be unregistered in its entirety), but on the
other hand, this is one of the simpler things we can do, until we have
something more fine-grained. I, for one, am perfectly happy with a
device link. The alternative would be reworking phylink to react on PCS
devices coming and going. I don't even know what the implications are
upon mac_select_pcs() and such...
