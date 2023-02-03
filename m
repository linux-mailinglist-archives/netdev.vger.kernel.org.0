Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30E5689F35
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 17:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbjBCQ1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 11:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbjBCQ1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 11:27:08 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09CAA6BA4;
        Fri,  3 Feb 2023 08:26:54 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id mc11so16746980ejb.10;
        Fri, 03 Feb 2023 08:26:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RUj1tb4TuSYwUwoIhNOw99sNhzHtGAEfhnWg+uq4J14=;
        b=Asl8uQue9LWo08MaIkIb7jI1hRkLqzzudtQvDBpXIXqQkoxbdF/KLvIZZWQEXwvMPL
         bMvtYu3kDoM3Ub2P8qPZk7gb/iij7N7PVRvrSQ4BysUH7hVGOpm5uyc227mcM/PAEiEZ
         J+uoaJyFsFKUvfSBtY2fmSCxbDemT+ka2phibXCr/SauPiiEtHlXPsH/rhdDDC9Rx3/1
         faQ+ppX0WmhLws/GI1EvYhGEqfcK7VzFbgWjcJirBtrr0FTn56MDjm0W3gTJW7rGi2i3
         WHIoQhSkKqIWXhGqFNZtL0oGmQT8RKffugBYkey/NNNmOsjNTfePuW7lCLVVR72PvZvq
         ZhwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RUj1tb4TuSYwUwoIhNOw99sNhzHtGAEfhnWg+uq4J14=;
        b=CaepQXhNhAGnu/mlFtIJ+D9A6nyalNsUZEVKEfevGCCQ4IpIYQcmNaes4txdpTud1U
         igNrn3wLLi/h2K5eOjrBmYSyp0vyRksQXoLIAkqzMyuDQLyK1OJzFvqgdszRPtWyc6PN
         Obhh9p6bIPREUS7r/6BQ7T36OYN5lXGC22fRiSRzwPRWb1pPjZZX2LVLX3VaEkBWep1Q
         s2bHLhG7vq3Qtprod585jYZ2zwRRWB36459QPzzTuZVXhqbwLhBbHocBW+Z8uBWZSKuR
         dipwBXICYvNB4WPMxgZDR5u5Xfb8X3rGoFV3iKiVTEdxubNnAE/amPj/uZ0xEKW/dsC2
         pD6A==
X-Gm-Message-State: AO0yUKXxDAYATs+FC50t3eN5M+SirioG0/M/eFokqeU4XauxnkTcj39z
        oOsGqDF/s2+X6i9ieyv4s1ZcbC1i+3MhbfHRq00=
X-Google-Smtp-Source: AK7set9ZvBjDxtOpPvZm4xJVgjoc5lWay022JeXGf0nkD85UtAmHom1fDaYmgZrZMxxjELD+WyybujbXQE5jPLUyEc0=
X-Received: by 2002:a17:906:ca41:b0:88b:a2de:ed92 with SMTP id
 jx1-20020a170906ca4100b0088ba2deed92mr3145596ejb.193.1675441613406; Fri, 03
 Feb 2023 08:26:53 -0800 (PST)
MIME-Version: 1.0
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <20230130173429.3577450-2-netdev@kapio-technology.com> <Y9qrAup9Xt/ZDEG0@shredder>
 <f27dd18d9d0b7ff8b693af8a58ea8616@kapio-technology.com> <Y9vgz4x/O+dIp+0/@shredder>
 <766efaf94fcb6362c5ceb176ad7955f1@kapio-technology.com> <Y90y9u+4PxWk4b9E@shredder>
In-Reply-To: <Y90y9u+4PxWk4b9E@shredder>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 3 Feb 2023 18:26:41 +0200
Message-ID: <CA+h21hp5Eh3zF60J2mTZL+xenD7iMBXKG+Ui0t-oUzgwNwSw2g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] net: bridge: add dynamic flag to switchdev notifier
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@kapio-technology.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
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
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Feb 2023 at 18:14, Ido Schimmel <idosch@idosch.org> wrote:
> I *think* this is the change Vladimir asked you to do.

Yup, although instead of "is_dyn", I would still prefer "!is_static",
but again, that's a preference for bridge/switchdev maintainers to
override.
