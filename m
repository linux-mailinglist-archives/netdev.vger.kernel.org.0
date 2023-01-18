Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2806672C2E
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 00:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjARXBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 18:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjARXBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 18:01:42 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73BD4FC35;
        Wed, 18 Jan 2023 15:01:40 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id hw16so1153383ejc.10;
        Wed, 18 Jan 2023 15:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JG0zmDr4Gx7JTYrA4JUjYF+9TusUlPQwAzE14ZbaLBE=;
        b=oRqBiOJYIlMdDowmL/wHGABFcI0fDixl2PMB36ctD5uSKk3azFGtf6qd2Fvk85nbjC
         RZGiY6WOS6aL3GADhFTaSpq9sDvNd66O4zvJIfSzbuoiU8TfqAStjiekALks5NkGSaKe
         ovGZ8gH0HmxO9jFlluSL74dBYh1vn5KfO7NSBBuv+DCGaPm6jsuW1hq8QeP+fNTfmlqX
         3IcskUgDBjlFzRib6paxCj+S90vgVnJVBiNY0ccVMPpVBJ9PeZVJOHdXXs+2uIBtQoT/
         vlsHkNs0iO6OaL9F9gRjvD02YML4zxlAojbWSyksCeYa74+TLtrx2SxLVb3arsFe5b7r
         ZhGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JG0zmDr4Gx7JTYrA4JUjYF+9TusUlPQwAzE14ZbaLBE=;
        b=3KyCHuspMJPJVqNIBs8eJvSsb0B8lAFbzzjJRt9QmrH0LkaKJTyqos4GncvXh9n6VD
         UgTEAJ2VKj57KpaKi8ZNu9Zs8J1SgRRt1ckX4X7wQZPJkjxEdXP2e3/j3RO2ziiM2ZmU
         kYLZ/tTB2Sgk5LkuffCZ3+C2VzBkf+uAwkBuMbwtHklAt5Je9L8PetSahda6MnuVnbnA
         xy7n2UwkkJ1EC89Ns+p8c1pgPRsGcjgJkADkmQrA/poT1ajBhW5Wms2kw6HTL5olkz22
         +keeC+fRmhR65gqhMM1GDG09IvveFj9Pof/JncqSiEhaJ4Gsj5D+js4svCvX2t/LQX5p
         FgDg==
X-Gm-Message-State: AFqh2koC9x8S2KT1jN8X++boGvEe3EScoKlSB1WmU2t+1HDRl8S+rFSd
        bJLQ7o+fJocj6z22aDnRAB0=
X-Google-Smtp-Source: AMrXdXuoqpi45+sG2pftBtwBbFskPfB44UC+cRcWbZWXXc+n+Hirrb16NdbKE6aaVF+8KoKPwtvNJQ==
X-Received: by 2002:a17:907:1019:b0:84c:69f8:2ec2 with SMTP id ox25-20020a170907101900b0084c69f82ec2mr8598505ejb.22.1674082899134;
        Wed, 18 Jan 2023 15:01:39 -0800 (PST)
Received: from skbuf ([188.27.185.42])
        by smtp.gmail.com with ESMTPSA id k11-20020a1709062a4b00b0073022b796a7sm15579629eje.93.2023.01.18.15.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 15:01:38 -0800 (PST)
Date:   Thu, 19 Jan 2023 01:01:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
Subject: Re: [RFC PATCH net-next 2/5] net: dsa: propagate flags down towards
 drivers
Message-ID: <20230118230135.szu6a7kvt2mjb3i5@skbuf>
References: <20230117185714.3058453-1-netdev@kapio-technology.com>
 <20230117185714.3058453-3-netdev@kapio-technology.com>
 <20230117231750.r5jr4hwvpadgopmf@skbuf>
 <e4acb7edb300d41a9459890133b928b4@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4acb7edb300d41a9459890133b928b4@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 11:35:08PM +0100, netdev@kapio-technology.com wrote:
> I am not sure I understand you entirely.
> From my standpoint I see it as so: that until now any fdb entry coming to
> port_fdb_add() (or port_fdb_del()) are seen as static entries. And this
> changes nothing with respect to those static entries as how drivers handle
> them.

This is true; it is implicit that the port_fdb_add() and port_fdb_del()
DSA methods request switches to operate on static FDB entries (in hardware).

> When the new dynamic flag is true, all drivers will ignore it in patch #3,
> so basically nothing will change by that.

This is not true, because it assumes that DSA never called port_fdb_add()
up until now for bridge FDB entries with the BR_FDB_STATIC flag unset,
which is incorrect (it did).

So what will change is that drivers which used to react to those bridge
FDB entries will stop doing so.

> Then in patch #5 the dynamic flag is handled by the mv88e6xxx driver.
> 
> I don't know the assisted_learning_on_cpu_port feature you mention, but
> there has still not been anything but static entries going towards
> port_fdb_add() yet...

For starters, you can read the commit message of the patch that
introduced it, which is d5f19486cee7 ("net: dsa: listen for
SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign bridge neighbors").
