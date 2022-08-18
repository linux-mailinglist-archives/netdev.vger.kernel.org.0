Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D86598258
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244433AbiHRLe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243923AbiHRLe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:34:27 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD876481DD
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 04:34:25 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id fy5so2710989ejc.3
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 04:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=HqeI3YVJBXY9jFdOhnuBdki9pRm2RnVLCCzZPUHwDDQ=;
        b=AhFXepU1nmn6SKZNk9jYS5z1+Hb4Q7TBzADbkIOMnG+kq4iBOgcE1vBuUCnn1JGcqT
         NqgfcKrecI4EQe++G+6IBkDwKuYv++ici/NgGrXAFkcjgMUnrbEEN0tKSFLhHh6t+26z
         FyBQ/XJi8TNSJnv+p8nKy+cCDBZYTedFtDgaYVOhBJCCeX6nvlXfqZvGJ92rTm5MCyM6
         GXl7PiGgxMNsVhMw1e358GdvuXFPnOOvDpalBut3c63OFzZYoGRZEoXwJdsBJ4FH7fAg
         A6cqNwr5PN6nsDuiI8oau3aLNL+C+HhBeGCXzmGWzBOkfiY1fyUiRjVHS5OVj12LuVXm
         gAhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=HqeI3YVJBXY9jFdOhnuBdki9pRm2RnVLCCzZPUHwDDQ=;
        b=UBTKrfkm9vkoK7KJ6USEvyKKKXwWiImP8FVaTRhwQPBkEwflHdW1Z4qNyCpd5HT9rd
         Dt3FOVukXzUKL5noYjR1qHaUoMm2BgwZu6HcsfwzZ7nmXxKpRBbiBGwTAOMkkIzjb7ib
         Nye9+dhcbTCDDGOl5WsW23EJsoVYpjGK1nPK0SmX0KxnHw9nwRvelvVFq4mlaIkGSMne
         W9ucXBcMKq8jfRxsH6Nbmj1d/AKaR3brHkHb/eUii6R8RLAfEcvXljwpnzIvQfuIlkEF
         MbWPzI5/pyQMTO4ZBnagVWM57piLE5cYkq9nKHUE5EALuOvoSQvM7w+8PJQnYzM8J73w
         tq+w==
X-Gm-Message-State: ACgBeo18WW1D40wynB44RRI7mY5RCBv8L0qkRPj43TTeiNvvh71LyHMw
        OeNdxSnWKHFGqyWiQbltxZQ=
X-Google-Smtp-Source: AA6agR7DI3L898dxoIQHGAbvMghH24ri0GbNQmZ5R/Ov6G7QRPhWZ/TsB4mx81Kmf2OCgBCm9/g1gA==
X-Received: by 2002:a17:907:2c48:b0:730:cdc9:2c0b with SMTP id hf8-20020a1709072c4800b00730cdc92c0bmr1634152ejc.482.1660822464117;
        Thu, 18 Aug 2022 04:34:24 -0700 (PDT)
Received: from skbuf ([188.25.231.137])
        by smtp.gmail.com with ESMTPSA id 4-20020a170906328400b0073ae9ba9ba9sm729319ejw.9.2022.08.18.04.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 04:34:23 -0700 (PDT)
Date:   Thu, 18 Aug 2022 14:34:20 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Network Development <netdev@vger.kernel.org>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: commit 65ac79e181 breaks our ksz9567
Message-ID: <20220818113420.6jo3zxc4hdpnuzfo@skbuf>
References: <408851bb-5245-7a10-3335-c475d4d1ca0f@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <408851bb-5245-7a10-3335-c475d4d1ca0f@prevas.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 01:03:13PM +0200, Rasmus Villemoes wrote:
> We have a board in development which includes a ksz9567 switch, whose
> cpu port is connected to a lan7801 usb chip. This works fine up until
> 5.18, but is broken in 5.19. The kernel log contains
> 
>  ksz9477-switch 4-005f lan1 (uninitialized): validation of gmii with
> support 00000000,00000000,000062ff and advertisement
> 00000000,00000000,000062ff failed: -EINVAL
>  ksz9477-switch 4-005f lan1 (uninitialized): failed to connect to PHY: -EINVAL
>  ksz9477-switch 4-005f lan1 (uninitialized): error -22 setting up PHY for tree 0, switch 0, port 0
> 
> and similar lines for the other four ports.
> 
> Bisecting points at
> 
> commit 65ac79e1812016d7c5760872736802f985ec7455
> Author: Arun Ramadoss <arun.ramadoss@microchip.com>
> Date:   Tue May 17 15:13:32 2022 +0530
> 
>     net: dsa: microchip: add the phylink get_caps
> 
> Our DT is, I think, pretty standard, and as I said works fine with 5.18:

Depends on what you mean by "pretty standard", see this change set which
I'll resubmit soon (today):
https://patchwork.kernel.org/project/netdevbpf/cover/20220806141059.2498226-1-vladimir.oltean@nxp.com/

> 
>         ksz9567: switch@5f {
>                 compatible = "microchip,ksz9567";
>                 reg = <0x5f>;
>                 status = "okay";
> 
>                 ports {
>                         #address-cells = <1>;
>                         #size-cells = <0>;
> 
>                         port@0 {
>                                 reg = <0>;
>                                 label = "lan1";
>                         };
>   ....
>                         port@6 {
>                                 reg = <6>;
>                                 label = "cpu";
>                                 ethernet = <&ethernet3>;
>                                 fixed-link {
>                                         speed = <1000>;
>                                         full-duplex;
>                                 };

The CPU port has no phy-mode. Good luck figuring out it's an RGMII mode.
(not related to the reported breakage though, which complains about
missing phy-mode on the LAN ports)

>                         };
>                 };
> 
> ...
>         ethernet3: ethernet@2 {
>                 compatible = "usb424,7801";
>                 reg = <2>;
>                 phy-mode = "rgmii-id";
> 
>                 mdio {
>                         compatible = "lan78xx-mdiobus";
>                         #address-cells = <1>;
>                         #size-cells = <0>;
>                 };
> 
>                 fixed-link {
>                         speed = <1000>;
>                         full-duplex;
>                 };
>         };
> 
> Any clues?
> 
> Thanks,
> Rasmus
